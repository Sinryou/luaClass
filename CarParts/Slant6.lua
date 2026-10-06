local Engine <const> = require "CarParts.Engine"

local Slant6 = Engine:extend("CarParts.Slant6")

-- Override
function Slant6:__tostring()
    return "I am a slant-6. VROOOM!"
end

return Slant6