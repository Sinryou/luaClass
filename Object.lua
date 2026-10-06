-- Copyright (C), 2014, rxi.
-- Copyright (C), 2022, Sinryou. Followed the MIT license.
-- FileName: Object.lua
-- Lua简单类的实现 (优化针对 Lua 5.4 & Lua 5.5)

-- Lua 5.5 table.create 兼容层 (Lua 5.4 环境安全回退)
if not table.create then
    rawset(table, "create", function(narr, nrec) return {} end)
end

local Object <const> = table.create(0, 16)
Object.__index = Object
Object.__type = "Class"
Object.__name = "Object"

-- 判断是类还是对象
local function isClass(obj)
    if type(obj) ~= "table" then
        return false
    end
    return rawget(obj, "__index") == obj and (rawget(obj, "__type") == "Class" or (getmetatable(obj) and getmetatable(obj).__type == "Class"))
end

-- 构造函数，通过 类名() 的方式实例化
function Object:new(...)
end

-- 继承类，通过 子类 = 父类:extend([name]) 的方式继承
function Object:extend(name)
    assert(isClass(self), "Function [extend] must call by a Class!")
    local cls <const> = table.create(0, 8)
    for k, v in pairs(self) do
        if type(k) == "string" and k:sub(1, 2) == "__" and k ~= "__name" then
            cls[k] = v
        end
    end
    cls.__index = cls
    cls.super = self
    if type(name) == "string" and name ~= "" then
        cls.__name = name
    else
        local info <const> = debug.getinfo(2, "S")
        if info and info.short_src then
            cls.__def_src = info.short_src
        end
    end
    setmetatable(cls, self)
    return cls
end

-- 类实现接口，通过 类:implement(接口...) 的方式实现
-- 该方法允许类继承非父类的方法
function Object:implement(...)
    assert(isClass(self), "Function [implement] must call by a Class!")
    local count <const> = select("#", ...)
    for i = 1, count do
        local iface <const> = select(i, ...)
        if type(iface) == "table" then
            for k, v in pairs(iface) do
                if self[k] == nil and type(v) == "function" then
                    self[k] = v
                end
            end
        end
    end
end

-- 判断对象是否为指定类，通过 对象:is(类) 调用
function Object:is(T)
    assert(isClass(T), "Input of function [is] must be a Class!")
    if self == T then
        return true
    end
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end

-- 复制一个对象，通过 新对象 = 对象:clone() 调用
-- 深度拷贝对象内部数据，同时对循环引用具备保护机制
function Object:clone()
    assert(not isClass(self), "Function [clone] must call by an Object!")
    local visited = {}
    local function copy(org)
        if type(org) ~= "table" then
            return org
        end
        if visited[org] then
            return visited[org]
        end
        -- 如果是Class类定义本身，不进行拷贝，直接引用
        if isClass(org) then
            return org
        end
        local mt <const> = getmetatable(org)
        local res = table.create(0, 8)
        visited[org] = res
        for k, v in pairs(org) do
            local cloned_k = copy(k)
            local cloned_v
            -- 对实现了自定义clone方法的Object实例，优先调用自身clone
            if type(v) == "table" and not isClass(v) and type(v.clone) == "function" and v ~= org then
                cloned_v = v:clone()
            else
                cloned_v = copy(v)
            end
            res[cloned_k] = cloned_v
        end
        if mt then
            setmetatable(res, mt)
        end
        return res
    end
    return copy(self)
end

-- 对象全等的方法，当对象为同一类且属性值相同时两个对象全等
-- 具备循环引用保护及快速相同引用比对
function Object:equal(obj)
    assert(not isClass(self), "Function [equal] must call by an Object!")
    if self == obj then
        return true
    end
    if type(obj) ~= "table" or getmetatable(self) ~= getmetatable(obj) then
        return false
    end
    local visited = {}
    local function deepCompare(t1, t2)
        if t1 == t2 then return true end
        local type1 <const> = type(t1)
        local type2 <const> = type(t2)
        if type1 ~= type2 then return false end
        if type1 ~= "table" then return t1 == t2 end

        local pair_key <const> = tostring(t1) .. "=" .. tostring(t2)
        if visited[pair_key] then return true end
        visited[pair_key] = true

        local compared = {}
        for k1, v1 in pairs(t1) do
            local v2 = t2[k1]
            if v2 == nil or not deepCompare(v1, v2) then return false end
            compared[k1] = true
        end

        for k2, _ in pairs(t2) do
            if not compared[k2] then return false end
        end
        return true
    end
    return deepCompare(self, obj)
end

-- 获取对象或类的类名称 (支持显式缓存和package.loaded延迟发现)
function Object:getClassName()
    local cls <const> = isClass(self) and self or getmetatable(self)
    if not cls then
        return "Object"
    end
    local cached <const> = rawget(cls, "__name")
    if cached then
        return cached
    end
    for k, v in pairs(package.loaded) do
        if cls == v then
            rawset(cls, "__name", k)
            return k
        end
    end
    -- 若未通过 require 注册，尝试从定义源文件中提取类名
    local def_src <const> = rawget(cls, "__def_src")
    if def_src then
        local base_name <const> = def_src:match("([^/\\]+)%.lua$") or def_src:match("([^/\\]+)$")
        if base_name and base_name ~= "main" and base_name ~= "init" then
            rawset(cls, "__name", base_name)
            return base_name
        end
    end
    return "Object"
end

-- 重写打印方法，print()打印为类名+对象属性
-- Lua 5.5 循环变量只读兼容，且利用 table.concat 优化拼接性能与循环引用保护
function Object:__tostring()
    if isClass(self) then
        return "Class: " .. self:getClassName()
    end
    local visited = {}
    local function dump(o)
        if type(o) ~= "table" then
            return tostring(o)
        end
        if visited[o] then
            return "<circular reference>"
        end
        visited[o] = true

        local parts = table.create(8, 0)
        for k, v in pairs(o) do
            local key_repr <const> = (type(k) == "number") and k or ('"' .. tostring(k) .. '"')
            table.insert(parts, "[" .. key_repr .. "] = " .. dump(v) .. ",")
        end
        visited[o] = nil
        return "{ " .. table.concat(parts) .. "} "
    end
    return self:getClassName() .. dump(self)
end

-- 重写调用，实例化一个对象
function Object:__call(...)
    assert(isClass(self), "Function [__call] must call by a Class! Do use this function by newObject=YourClassName() Style.")
    local obj <const> = setmetatable(table.create(0, 8), self)
    obj:new(...)
    return obj
end

return Object