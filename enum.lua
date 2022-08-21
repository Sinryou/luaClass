-- lua枚举
local function enum(arg1, arg2)
    local tb, typo
    if type(arg1)=="table" then
        tb = arg1
    else
        assert(type(arg1)=="string" and type(arg2)=="table")
        tb, typo = arg2, arg1
    end
    local enumtb = {}
    for i, v in ipairs(tb) do
        enumtb[v] = i
    end
    local mt = {
        __index = {
            __type = typo or "enum",
            getName = function(index) return tb[index] end
        },
        __newindex = function()
            local msg = 'Not allowed to modify enum table after initialized.'
            error(msg, 2)
        end
    }
    setmetatable(enumtb, mt)
    return enumtb
end

return enum