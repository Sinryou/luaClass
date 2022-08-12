local Car = require "CarParts.Car"
-- local Engine = require "CarParts.Engine"
-- local Tire = require "CarParts.Tire"
local Slant6 = require "CarParts.Slant6"
local AllWeatherRadial = require "CarParts.AllWeatherRadial"

local function main()
    local car = Car()

    -- local engine = Engine()
    local engine = Slant6()
    car:setEngine(engine)

    for i = 1, 4 do
        -- car:setTireAtIndex(Tire(),i)
        car:setTireAtIndex(AllWeatherRadial(),i)
    end

    car:print()
end

main()