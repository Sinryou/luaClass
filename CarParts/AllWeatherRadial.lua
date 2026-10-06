local Tire <const> = require "CarParts.Tire"

local AllWeatherRadial = Tire:extend("CarParts.AllWeatherRadial")

-- Override
function AllWeatherRadial:__tostring()
    return "I am a tire for rain or shine."
end

return AllWeatherRadial