local Circle = require "Shape.Circle"
local Rectangle = require "Shape.Rectangle"
local ShapeColor = require "Shape.ShapeColor"

local function main()
    local c = Circle(ShapeColor.red,{0,0,10,30})
    c:draw()
    local r = Rectangle(ShapeColor.green,{30,40,50,60})
    r:draw()
end

main()