local BoxObject = require("app.objects.BoxObject") 

-- For creation
local Box16 = class("Box16")
function Box16:create()
    return BoxObject:create(cc.size(8*5, 8*5),  0.1, 0.0001, 0.95, "res/Sprites/Physic/box8.png")
end

return Box16
