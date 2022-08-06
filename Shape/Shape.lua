local Object = require "Object"

local Shape = Object:extend()

function Shape:new(fillColor,bounds)
    self.fillColor = fillColor
    self.bounds = {}
    self.bounds.x = bounds[1]
    self.bounds.y = bounds[2]
    self.bounds.width = bounds[3]
    self.bounds.heght = bounds[4]
end

function Shape:draw()
end

return Shape