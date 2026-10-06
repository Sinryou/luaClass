local Shape <const> = require "Shape.Shape"
local ShapeColor <const> = require "Shape.ShapeColor"

local Circle = Shape:extend("Shape.Circle")

function Circle:new(fillColor, bounds)
    if fillColor == ShapeColor.red then
        fillColor = ShapeColor.green
    end
    self.super.new(self, fillColor, bounds)
end

-- Override
function Circle:draw()
    local b <const> = self.bounds
    local info <const> = string.format("drawing a circle at (%d %d %d %d) in %s",
        b.x, b.y, b.width, b.height, ShapeColor.getName(self.fillColor))
    print(info)
end

return Circle