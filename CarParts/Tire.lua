local Object <const> = require "Object"

local Tire = Object:extend("CarParts.Tire")

-- Override
function Tire:__tostring()
    return "I am a tire. I last a while"
end

return Tire