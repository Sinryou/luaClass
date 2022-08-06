-- lua枚举
local function enumTable(tb)
    assert(type(tb)=="table","Enum input must be a table!")
    local enumtb = {}
    for i, v in ipairs(tb) do
        enumtb[v] = i
    end
    enumtb.getName=tb
    return enumtb
end

return enumTable