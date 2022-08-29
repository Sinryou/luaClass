function Typeof(obj)
    if type(obj) ~= "table" or not obj.__type then
        return type(obj)
    elseif obj.__type ~= "Class" then
        return obj.__type
    else
        return obj:getClassName()
    end
end

function IsInt(i)
    if type(i) == "number" then
        return i % 1 == 0
    end
    return false
end

function IsFloat(i)
    if type(i) == "number" then
        return i % 1 ~= 0
    end
    return false
end

function IsEmpty(o)
    if type(o) == "table" then
        return next(o) == nil
    end
    return o == nil or o == ''
end

function Len(t)
    if type(t) ~= "table" then
        return #t
    end
    local len=0
    for _, _ in pairs(t) do
        len = len + 1
    end
    return len
end

function FileExist(path)
    if not path then return nil end
    local file = io.open(path, "rb")
    if file then
        file:close()
        return true
    end
    return false
end

function FileRead(path)
    if not path then return nil end
    local file = io.open(path, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return data
    end
    return ""
end

function FileWrite(path, cont)
    if not path then return nil end
    local file = io.open(path, "w")
    if file then
        file:write(cont)
        file:close()
        return true
    end
    return false
end

function FileAppend(path, cont)
    if not path then return nil end
    local file = io.open(path, "a")
    if file then
        file:write(cont)
        file:close()
        return true
    end
    return false
end

function SendPopen(cmd)
    local rsp = io.popen(cmd)
    if rsp then
        local result = rsp:read("*a")
        rsp:close()
        return result
    end
    return ""
end

function SendTerminal(cmd)
    local currentPath = debug.getinfo(1).source:match([[@(.+)[\/].-%.lua]])
    local pyCmd = [[python %s/execCmd.py %s]]
    cmd = pyCmd:format(currentPath, cmd)
    local rsp = io.popen(cmd)
    if rsp then
        local result = rsp:read("*a")
        rsp:close()
        return result:match([[^stdout:(.*)stderr:.*%s$]]), result:match([[^stdout:.*stderr:(.*)%s$]])
    end
    return "", ""
end
