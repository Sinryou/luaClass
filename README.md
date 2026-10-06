# Object

This objective lua file extends from rxi's classic.lua, see [there](https://github.com/rxi/classic) to know how to use it basically.
This project is specifically optimized for **Lua 5.4** and **Lua 5.5**.

## Lua 5.4 & 5.5 Optimizations

- **Lua 5.5 Read-Only For-Loop Compatibility**: Fixed loop variable mutation in serialization to comply with Lua 5.5's read-only for-loop variable constraints.
- **`<const>` Variable Attributes**: Adopted `<const>` for module imports, immutable bindings, and constants to allow compiler optimizations and prevent accidental mutation.
- **`<close>` RAII Resource Management**: Implemented `<close>` to-be-closed file handles and scope guards in `Modules/Common.lua` (`fileRead`, `fileWrite`, `fileAppend`, `sendTerminal`), ensuring deterministic resource cleanup even on errors.
- **`table.create` Table Preallocation**: Utilized Lua 5.5's native `table.create(nseq, nrec)` (with seamless fallback for Lua 5.4) across classes, enums, lists, and utilities to reduce memory reallocations and table resizing overhead.
- **Class Name Caching**: Cached `__name` on classes so `getClassName()` resolves in $O(1)$ time rather than repeatedly scanning `package.loaded`.
- **Zero-Allocation Varargs in `implement`**: Rewritten `implement(...)` using `select("#", ...)` and `select(i, ...)` to eliminate temporary `{...}` table heap allocations.
- **Cycle-Safe Serialization & Cloning**: Added cycle protection to `__tostring`, `dump`, `clone`, and `equal` to prevent recursion stack overflow.
- **String Concatenation with Buffers**: Replaced $O(N^2)$ `..` concatenation loops with `table.concat` buffers.
- **LinkedList Bug Fixes**: Fixed `delTail` where `tail` pointer wasn't updated, removed redundant node allocations, and implemented deep list cloning.

---

## Usage-Extended

The [module](Object.lua) can be dropped in to an existing project and required:

```lua
local Object <const> = require "Object"
```

### Print classes and objects
```lua
local Dog <const> = require "Animal.Dog"
print(Dog) --> Class: Animal.Dog

local dog <const> = Dog("haski", 3, "black")
print(dog) --> Animal.Dog{ ["name"] = haski,["color"] = black,["age"] = 3,} 
```

### Object Clone
Object.lua allows objects to clone themselves with deep copy and circular reference safety:
```lua
local Cat <const> = require "Animal.Cat"

local cat1 <const> = Cat("titi", 5)
print(cat1) --> Animal.Cat{ ["name"] = titi,["age"] = 5,} 

local cat2 <const> = cat1:clone()
cat2.age = 2
print(cat1, cat2) --> Animal.Cat{ ["name"] = titi,["age"] = 5,}       Animal.Cat{ ["name"] = titi,["age"] = 2,}
```

### Compare objects
Object.lua allows comparing different objects. When two objects have the same class and properties, they are recognized as equal:
```lua
local cat1 <const> = Cat("titi", 5)
local cat2 <const> = Cat("titi", 5)
local cat3 <const> = Cat("tomy", 2)
print(cat1:equal(cat2)) --> true
print(cat1:equal(cat3)) --> false
```

### Get the class Type
```lua
local Cat <const> = require "Animal.Cat"

local cat1 <const> = Cat("titi", 5)

print(Cat:getClassName()) --> Animal.Cat
print(cat1:getClassName()) --> Animal.Cat
```

### Enum-like table
Using enum.lua can organize tables in an enum-like, read-only structure:
```lua
local enum <const> = require "enum"

local ShapeColor <const> = enum("ShapeColor", {"red", "blue", "green"})
print(ShapeColor.green) --> 3
print(ShapeColor.getName(ShapeColor.green)) --> green
print(#ShapeColor) --> 3
print(ShapeColor) --> Enum: ShapeColor
```

## Running Tests

Run the comprehensive test suite:

```bash
lua test.lua
```

## License

This module is free software; you can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
