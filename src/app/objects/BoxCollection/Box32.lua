local BoxObject = require("app.objects.BoxObject") 

-- For creation
local Box32 = class("Box32")
function Box32:create()
    return BoxObject:create(cc.size(32*5, 32*5), 0.08, 0, 0.45, "res/Sprites/Physic/box32.png")
end

return Box32
