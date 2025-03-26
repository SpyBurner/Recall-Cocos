local BoxObject = require("app.objects.BoxObject") 

-- For creation
local Box28 = class("Box28")
function Box28:create()
    return BoxObject:create(cc.size(8*5, 16*5), 0.06, 0.1, 0.4, "res/Sprites/Physic/box28.png")
end

return Box28
