-- Copyright (C), 2014, rxi.
-- Copyright (C), 2022, Sinryou. Followed the MIT license.
-- FileName: Object.lua
-- lua简单类的实现

local Object = {}
Object.__index = Object
Object.__type = "Class"

-- 判断是类还是对象
local function isClass(obj)
    assert(obj.__type=="Class","Input of function (isClass) must be a Class or an Object!")
    if obj.__index == obj then
        return true
    end
    return false
end

-- 构造函数，通过 类名() 的方式实例化
function Object:new()
end

-- 继承类，通过 子类=父类:extend()的方式继承
function Object:extend()
    assert(isClass(self),"Function [extend] must call by a Class!")
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then
            cls[k] = v
        end
    end
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)
    return cls
end

-- 类实现接口，通过 类:implement(接口)的方式实现
-- 该方法允许类继承非父类的方法
function Object:implement(...)
    assert(isClass(self),"Function [implement] must call by a Class!")
    for _, cls in pairs({...}) do
        for k, v in pairs(cls) do
            if self[k] == nil and type(v) == "function" then
                self[k] = v
            end
        end
    end
end

-- 判断对象是否为指定类，通过 对象:is(类) 调用
function Object:is(T)
    assert(isClass(T),"Input of function [is] must be a Class!")
    local mt = getmetatable(self)
    while mt do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end

-- 复制一个对象，通过 新对象=对象:clone() 调用
-- 避免lua表浅拷贝带来的问题
function Object:clone()
    assert(not isClass(self),"Function [clone] must call by an Object!")
    local function copy(org, res)
        for k,v in pairs(org) do
            -- 对该对象内的对象只进行浅拷贝
            if type(v) ~= "table" or v.__type == "Class" then
                res[k] = v;
            else
                res[k] = {};
                copy(v, res[k])
            end
        end
    end
    local res = getmetatable(self)()
    copy(self, res)
    return res
end

-- 对象全等的方法，当对象为同一类且属性值相同时两个对象全等
-- 不重写__eq避免不必要的麻烦
function Object:equal(obj)
    assert(not isClass(self),"Function [equal] must call by an Object!")
    if type(obj)=="table" and getmetatable(self)~=getmetatable(obj) then
        return false
    end
    local function deepCompare(t1, t2)
        local type1 = type(t1)
        local type2 = type(t2)
        if type1 ~= type2 then return false end
        if type(t1) ~= 'table' and type(t2) ~= 'table' then return t1 == t2 end

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
    return deepCompare(self,obj)
end

-- 获取对象或类的类名称
function Object:getClassName()
    local temp = isClass(self) and self or getmetatable(self)
    for k, v in pairs(package.loaded) do
        if temp == v then
            return k
        end
    end
end

-- 重写打印方法，print()打印为类名+对象属性
function Object:__tostring()
    if isClass(self) then
        return "Class: "..self:getClassName()
    end
    local function dump(o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
    end
    return self:getClassName()..dump(self)
end

-- 重写调用，实例化一个对象
function Object:__call(...)
    assert(isClass(self),"Function [__call] must call by a Class! Do use this function by newObject=YourClassName() Style.")
    local obj = setmetatable({}, self)
    obj:new(...)
    return obj
end

return Object