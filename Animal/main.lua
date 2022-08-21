local Cat = require "Animal.Cat"
local Dog = require "Animal.Dog"

local function main()
    local a = Cat()
    a.name = "mimi"
    a.age = 3
    print(a)
    a:eat()

    local a1 = Cat("titi",5)
    print(a1)
    a1:mathing()

    local a2 = a1:clone()
    print(a2~=a1)

    local b = Dog("haski",3,"black")
    print(b)
    b:eat()

    -- for k, v in pairs(package.loaded) do
    -- 	print(k, v)
    -- end
end

main()