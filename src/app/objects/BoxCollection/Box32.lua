local BoxObject = require("app.objects.BoxObject") 

-- For creation
local Box32 = class("Box32")
function Box32:create()
    return BoxObject:create(cc.size(32*5, 32*5), 0.04, 0, 0.2, "res/Sprites/Physic/box32.png")
end

return Box32
