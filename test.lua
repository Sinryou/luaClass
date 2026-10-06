-- 全面测试套件：验证 Lua 5.4 & Lua 5.5 环境下的功能与优化特性
local Object <const> = require "Object"
local enum <const> = require "enum"
local Common <const> = require "Modules.Common"
local OSUtil <const> = require "Modules.OSUtil"
local PathUtil <const> = require "Modules.PathUtil"

local passed = 0
local failed = 0

local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print(" [PASS] " .. name)
    else
        failed = failed + 1
        print(" [FAIL] " .. name .. ": " .. tostring(err))
    end
end

print("========== Lua Version: " .. _VERSION .. " ==========")

-- 1. Object 基础继承与实例化
test("Object: extend & new & __call", function()
    local Base = Object:extend("TestBase")
    function Base:new(val)
        self.val = val
    end

    local Derived = Base:extend("TestDerived")
    function Derived:new(val, extra)
        Derived.super.new(self, val)
        self.extra = extra
    end

    local obj = Derived(10, 20)
    assert(obj.val == 10)
    assert(obj.extra == 20)
    assert(obj:is(Derived))
    assert(obj:is(Base))
    assert(obj:is(Object))
    assert(Derived:is(Base))
    assert(Derived:is(Object))
end)

-- 2. Object 接口实现 (implement)
test("Object: implement (no vararg table allocation)", function()
    local IFly = Object:extend("IFly")
    function IFly:fly() return "flying" end

    local ISwim = Object:extend("ISwim")
    function ISwim:swim() return "swimming" end

    local Duck = Object:extend("Duck")
    Duck:implement(IFly, ISwim)

    local d = Duck()
    assert(type(d.fly) == "function" and d:fly() == "flying")
    assert(type(d.swim) == "function" and d:swim() == "swimming")
end)

-- 3. Object: clone 与深拷贝及循环引用保护
test("Object: clone with deep copy & circular reference protection", function()
    local Person = Object:extend("Person")
    function Person:new(name, info)
        self.name = name
        self.info = info or {}
    end

    local p1 = Person("Alice", { city = "Beijing", details = { zip = 100000 } })
    local p2 = p1:clone()

    assert(p1 ~= p2)
    assert(p1.name == p2.name)
    assert(p1.info ~= p2.info)
    assert(p1.info.details ~= p2.info.details)
    assert(p1.info.details.zip == p2.info.details.zip)

    -- 修改 p2 不影响 p1
    p2.info.details.zip = 200000
    assert(p1.info.details.zip == 100000)

    -- 循环引用深拷贝测试
    local c1 = { name = "node1" }
    local c2 = { name = "node2", prev = c1 }
    c1.next = c2
    local p_circular = Person("Cyclic", { root = c1 })
    local p_cloned = p_circular:clone()
    assert(p_cloned.info.root.next.prev == p_cloned.info.root)
end)

-- 4. Object: equal 深度比较
test("Object: equal", function()
    local Item = Object:extend("Item")
    function Item:new(id, meta)
        self.id = id
        self.meta = meta
    end

    local it1 = Item(1, { tags = { "a", "b" } })
    local it2 = Item(1, { tags = { "a", "b" } })
    local it3 = Item(2, { tags = { "a", "b" } })

    assert(it1:equal(it1)) -- 快速引用相等
    assert(it1:equal(it2)) -- 深度值相等
    assert(not it1:equal(it3))
end)

-- 5. Object: getClassName 与 __tostring 格式
test("Object: getClassName & __tostring formatting", function()
    local Widget = Object:extend("CustomWidget")
    function Widget:new(x, y)
        self.x = x
        self.y = y
    end

    assert(Widget:getClassName() == "CustomWidget")
    local w = Widget(5, 10)
    assert(w:getClassName() == "CustomWidget")
    local str = tostring(w)
    assert(str:find("CustomWidget{") == 1)
    assert(str:find('%["x"%] = 5') ~= nil)
    assert(str:find('%["y"%] = 10') ~= nil)

    -- 循环引用 __tostring 保护
    local bad = Widget(1, 2)
    bad.self_ref = bad
    local str_circ = tostring(bad)
    assert(str_circ:find("<circular reference>") ~= nil)
end)

-- 6. enum 功能测试
test("enum: creation, values, readonly protection & metamethods", function()
    local Status = enum("Status", { "Pending", "Running", "Finished" })
    assert(Status.Pending == 1)
    assert(Status.Running == 2)
    assert(Status.Finished == 3)
    assert(Status.getName(2) == "Running")
    assert(#Status == 3)
    assert(tostring(Status) == "Enum: Status")

    -- 验证只读保护
    local write_failed = false
    local ok = pcall(function() Status.NewKey = 99 end)
    assert(not ok, "Enum should not allow new keys")
end)

-- 7. Common 模块测试 (包括 <close> 和 utf8)
test("Common: isInt, isFloat, len, map, quote_arg", function()
    assert(Common.isInt(10))
    assert(Common.isInt(10.0))
    assert(not Common.isInt(10.5))
    assert(Common.isFloat(10.5))

    -- utf8 字符计数
    assert(Common.len("hello") == 5)
    assert(Common.len("你好世界") == 4) -- utf8 字符数测试

    local mapped = Common.map(function(x) return x * 2 end, { 1, 2, 3 })
    assert(#mapped == 3 and mapped[1] == 2 and mapped[2] == 4 and mapped[3] == 6)

    local quoted = Common.quote_arg("hello world")
    assert(quoted ~= "hello world")
end)

-- 8. Common 文件操作与 <close> 机制
test("Common: fileWrite, fileRead, fileAppend with <close>", function()
    local test_path = "test_io_temp.txt"
    assert(Common.fileWrite(test_path, "Hello Lua 5.5!"))
    local content = Common.fileRead(test_path)
    assert(content == "Hello Lua 5.5!")
    assert(Common.fileAppend(test_path, " More content."))
    local content2 = Common.fileRead(test_path)
    assert(content2 == "Hello Lua 5.5! More content.")
    os.remove(test_path)
end)

-- 9. List 模块及深克隆与 tail 修复测试
test("LinkedList: addHead, addTail, delTail, printList & clone", function()
    local LinkedList = require "List.LinkedList"
    local Node = require "List.Node"

    local list = LinkedList()
    list:addHead(Node(10))
    list:addTail(Node(20))
    list:addTail(Node(30))
    assert(#list == 3)

    local clone_list = list:clone()
    assert(#clone_list == 3)

    -- 删除原链表尾部
    list:delTail()
    assert(#list == 2)
    assert(list.tail.data == 20) -- 验证 tail 正确更新

    -- 克隆链表不受影响
    assert(#clone_list == 3)
    assert(clone_list.tail.data == 30)
end)

-- 10. PathUtil 目录与文件工具测试
test("PathUtil: basic checks", function()
    assert(PathUtil.fileExist("Object.lua"))
    assert(PathUtil.dirExist("Animal"))
    assert(PathUtil.fileName("Animal/Cat.lua") == "Cat.lua")
    assert(PathUtil.getExtension("Animal/Cat.lua") == ".lua")
    assert(PathUtil.fileNameWithoutExtension("Animal/Cat.lua") == "Cat")
    local contents = PathUtil.listDirContents("Shape")
    assert(type(contents) == "table" and #contents > 0)
end)

print(string.format("\n=========================================="))
print(string.format("RESULTS: %d Passed, %d Failed", passed, failed))
print(string.format("=========================================="))

if failed > 0 then
    os.exit(1)
end
