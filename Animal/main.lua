local Cat <const> = require "Animal.Cat"
local Dog <const> = require "Animal.Dog"

local function main()
    local a <const> = Cat()
    a.name = "mimi"
    a.age = 3
    print(a)
    a:eat()

    local a1 <const> = Cat("titi", 5)
    print(a1)
    a1:mathing()

    local a2 <const> = a1:clone()
    print(a2 ~= a1)

    local b <const> = Dog("haski", 3, "black")
    print(b)
    b:eat()
end

main()