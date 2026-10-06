local Car <const> = require "CarParts.Car"
local Slant6 <const> = require "CarParts.Slant6"
local AllWeatherRadial <const> = require "CarParts.AllWeatherRadial"

local function main()
    local car <const> = Car()
    local engine <const> = Slant6()
    car:setEngine(engine)

    for i = 1, 4 do
        car:setTireAtIndex(AllWeatherRadial(), i)
    end

    car:print()
end

main()