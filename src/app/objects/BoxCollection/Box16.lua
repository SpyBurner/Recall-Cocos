local BoxObject = require("app.objects.BoxObject") 

-- For creation
local Box16 = class("Box16")
function Box16:create()
    return BoxObject:create(cc.size(16*5, 16*5), 0.05, 0.05, 0.5, "res/Sprites/Physic/box16.png")
end

return Box16
