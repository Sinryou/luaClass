-- lua枚举 (针对 Lua 5.4 & Lua 5.5 优化)

if not table.create then
    rawset(table, "create", function(narr, nrec) return {} end)
end

local function readonly_newindex()
    error("Not allowed to modify enum table after initialized.", 2)
end

local function enum(arg1, arg2)
    local tb, typo
    if type(arg1) == "table" then
        tb = arg1
    else
        assert(type(arg1) == "string" and type(arg2) == "table", "Usage: enum(table) or enum(name, table)")
        tb, typo = arg2, arg1
    end

    local count <const> = #tb
    local enumtb <const> = table.create(0, count)
    for i = 1, count do
        local v <const> = tb[i]
        enumtb[v] = i
    end

    local meta_index <const> = {
        __type = typo or "enum",
        getName = function(index) return tb[index] end
    }

    local mt <const> = {
        __index = meta_index,
        __newindex = readonly_newindex,
        __len = function() return count end,
        __tostring = function()
            return typo and ("Enum: " .. typo) or "Enum"
        end
    }

    setmetatable(enumtb, mt)
    return enumtb
end

return enum