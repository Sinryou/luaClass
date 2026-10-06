local Animal <const> = require "Animal.Animal"

local Dog = Animal:extend("Animal.Dog")

function Dog:new(name, age, color)
    self.super.new(self, name, age)
    self.color = color
end

-- Override
function Dog:eat()
    print((self.name or "Dog") .. " eats meat.")
end

return Dog