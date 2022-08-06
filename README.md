# Object

This objective lua file externs from rxi's classic.lua, see [there](https://github.com/rxi/classic) to know how to use it basiclly.


## Usage-Externed

The [module](Object.lua) should be dropped in to an existing project and
required by it:

```lua
Object = require "Object"
```

Except the usage from rxi's classic.lua, Object.lua overrided the __tostring function which makes classes and objects can be printed in a visible way.

### Print classes and objects
```lua
    local Dog = require "Animal.Dog"
    print(Dog) --> Class: Animal.Dog

    local dog = Dog("haski",3,"black")
    print(dog) --> Animal.Dog{ ["name"] = haski,["color"] = black,["age"] = 3,} 
```

Object.lua allows objects to clone themselvs to avoid lua's shallow copy problem.

### Object Clone
```lua
local cat1 = Cat("titi",5)
print(cat1) --> Animal.Cat{ ["age"] = 5,["name"] = titi,} 

local cat2 = cat1:clone()
cat2.age = 2
print(cat1, cat2) --> Animal.Cat{ ["age"] = 5,["name"] = titi,}       Animal.Cat{ ["age"] = 2,["name"] = titi,}
```
Object.lua allows to compare different objects. When the two objects have same class and property values, they are recognized as equal.

### Comapre objects
```lua
local cat1 = Cat("titi",5)
local cat2 = Cat("titi",5)
local cat3 = Cat("tomy",2)
print(cat1:equal(cat2)) --> true
print(cat1:equal(cat3)) --> false
```

### Get the class Type
```lua
local Cat = require "Animal.Cat"

local cat1 = Cat("titi",5)

print(Cat:getClassName()) --> Animal.Cat
print(cat1:getClassName()) --> Animal.Cat

```

Use enum.lua can oganize table in a enum-like way.

### Enum-like table
```lua
local enum = require "enum"

local ShapeColor = enum({"red","blue","green"})
print(ShapeColor.green) --> 3
print(ShapeColor.getName[ShapeColor.green]) --> green
```


## License

This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.

