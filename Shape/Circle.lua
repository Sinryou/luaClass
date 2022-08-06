local Shape = require "Shape.Shape"
local ShapeColor = require "Shape.ShapeColor"

local Circle = Shape:extend()

function Circle:new(fillColor,bounds)
    if fillColor == ShapeColor.red then
        fillColor = ShapeColor.green
    end
    self.super.new(self,fillColor,bounds)
end

-- Override
function Circle:draw()
    local info = string.format("drawing a circle at (%d %d %d %d) in %s",self.bounds.x,self.bounds.y,self.bounds.width,self.bounds.heght,ShapeColor.getName[self.fillColor])
    print(info)
end

return Circle