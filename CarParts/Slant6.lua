local Engine = require "CarParts.Engine"

local Slant6 = Engine:extend()

-- Override
function Slant6:__tostring()
    return "I am a slant-6. VROOOM!"
end

return Slant6