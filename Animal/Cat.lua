local Animal <const> = require "Animal.Animal"
local MathInterface <const> = require "Animal.MathInterface"

local Cat = Animal:extend("Animal.Cat")
Cat:implement(MathInterface)

-- Override
function Cat:eat()
    print((self.name or "Cat") .. " eats fish.")
end

-- Override
function Cat:mathing()
    print((self.name or "Cat") .. " calculates.")
end

return Cat