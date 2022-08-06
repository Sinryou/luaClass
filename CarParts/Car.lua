-- local Tire = require "CarParts.Tire"
-- local Engine = require "CarParts.Engine"
local Object = require "Object"

local Car = Object:extend()

-- function Car:new()
--     self.engine = Engine()
--     self.tires[1] = Tire()
--     self.tires[2] = Tire()
--     self.tires[3] = Tire()
--     self.tires[4] = Tire()
-- end

function Car:setEngine(newEngine)
    self.engine = newEngine
end

function Car:getEngine()
    return self.engine
end

function Car:setTireAtIndex(tire, index)
    if not self.tires then
        self.tires = {}
    end
    assert(index>=1 and index<=4,"bad index in setTire of index "..index)
    self.tires[index] = tire
end

function Car:getTireAtIndex(index)
    assert(index>=1 and index<=4,"bad index in getTireAtIndex of index "..index)
    return self.tires[index]
end

function Car:print()
    print(self.engine)
    for _, v in ipairs(self.tires) do
        print(v)
    end
end

return Car