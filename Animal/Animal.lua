local Object = require "Object"

local Animal = Object:extend()

function Animal:new(name, age)
    self.name = name
    self.age = age
end

function Animal:eat()
end

return Animal