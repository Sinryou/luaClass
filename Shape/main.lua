local Circle <const> = require "Shape.Circle"
local Rectangle <const> = require "Shape.Rectangle"
local ShapeColor <const> = require "Shape.ShapeColor"

local function main()
    local c <const> = Circle(ShapeColor.red, {0, 0, 10, 30})
    c:draw()
    local r <const> = Rectangle(ShapeColor.green, {30, 40, 50, 60})
    r:draw()
end

main()