local Object <const> = require "Object"

local Animal = Object:extend("Animal.Animal")

function Animal:new(name, age)
    self.name = name
    self.age = age
end

function Animal:eat()
end

return Animal