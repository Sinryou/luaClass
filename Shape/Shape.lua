local Object <const> = require "Object"

local Shape = Object:extend("Shape.Shape")

function Shape:new(fillColor, bounds)
    self.fillColor = fillColor
    local b <const> = table.create(0, 5)
    b.x = bounds[1]
    b.y = bounds[2]
    b.width = bounds[3]
    b.height = bounds[4]
    self.bounds = b
end

function Shape:draw()
end

return Shape