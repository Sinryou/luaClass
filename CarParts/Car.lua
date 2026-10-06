local Object <const> = require "Object"

local Car = Object:extend("CarParts.Car")

function Car:new(engine)
    self.engine = engine
    self.tires = table.create(4, 0)
end

function Car:setEngine(newEngine)
    self.engine = newEngine
end

function Car:getEngine()
    return self.engine
end

function Car:setTireAtIndex(tire, index)
    if not self.tires then
        self.tires = table.create(4, 0)
    end
    assert(index >= 1 and index <= 4, "bad index in setTire of index " .. index)
    self.tires[index] = tire
end

function Car:getTireAtIndex(index)
    assert(index >= 1 and index <= 4, "bad index in getTireAtIndex of index " .. index)
    return self.tires and self.tires[index]
end

function Car:print()
    if self.engine then
        print(self.engine)
    end
    if self.tires then
        for i = 1, #self.tires do
            print(self.tires[i])
        end
    end
end

return Car