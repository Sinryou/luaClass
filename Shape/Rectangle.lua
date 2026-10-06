local Shape <const> = require "Shape.Shape"
local ShapeColor <const> = require "Shape.ShapeColor"

local Rectangle = Shape:extend("Shape.Rectangle")

-- Override
function Rectangle:draw()
    local b <const> = self.bounds
    local info <const> = string.format("drawing a rectangle at (%d %d %d %d) in %s",
        b.x, b.y, b.width, b.height, ShapeColor.getName(self.fillColor))
    print(info)
end

return Rectangle