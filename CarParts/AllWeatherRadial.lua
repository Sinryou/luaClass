local Tire = require "CarParts.Tire"

local AllWeatherRadial = Tire:extend()

-- Override
function AllWeatherRadial:__tostring()
    return "I am a tire for rain or shine."
end

return AllWeatherRadial