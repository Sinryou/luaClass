local Object = require "Object"

local Tire = Object:extend()

-- Override
function Tire:__tostring()
    return "I am a tire. I last a while"
end

return Tire