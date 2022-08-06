local Animal = require "Animal.Animal"
local MathInterface = require "Animal.MathInterface"

local Cat = Animal:extend()
Cat:implement(MathInterface)

-- Override
function Cat:eat()
    print((self.name or "Cat").." eats fish.")
end
-- Override
function Cat:mathing()
    print((self.name or "Cat").." calculates.")
end

return Cat