local GameObject = require("app.core.GameObject")

-- For creation
local BaseObject = class("BaseObject", GameObject)
function BaseObject:ctor()
    GameObject.ctor(self)  -- ✅ Call parent constructor
end

return BaseObject
