local Object <const> = require "Object"

local Engine = Object:extend("CarParts.Engine")

-- Override
function Engine:__tostring()
    return "I am an Engine. Vrooom!"
end

return Engine