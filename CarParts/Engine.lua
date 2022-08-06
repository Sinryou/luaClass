local Object = require "Object"

local Engine = Object:extend()

-- Override
function Engine:__tostring()
    return "I am an Engine. Vrooom!"
end

return Engine