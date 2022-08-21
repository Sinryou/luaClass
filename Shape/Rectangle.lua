local Shape = require "Shape.Shape"
local ShapeColor = require "Shape.ShapeColor"

local Rectangle = Shape:extend()

-- Override
function Rectangle:draw()
    local info = string.format("drawing a rectangle at (%d %d %d %d) in %s",self.bounds.x,self.bounds.y,self.bounds.width,self.bounds.heght,ShapeColor.getName(self.fillColor))
    print(info)
end

return Rectangle