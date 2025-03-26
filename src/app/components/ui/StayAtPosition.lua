local Component = require("app.core.Component")

local StayAtPosition = class("StayAtPosition", Component)

function StayAtPosition:ctor(owner, screenPos)
    Component.ctor(self, owner)
    self.screenPos = screenPos or cc.p(0, 0)  -- ✅ Default to (0,0)
end

function StayAtPosition:update(dt)
    if not self.isEnabled then return end

    -- ✅ Convert screen position to world position (adjust for camera movement)
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    local winSize = director:getWinSize()

    -- ✅ Flip Y because Cocos2d-x screen coordinates start from bottom-left
    local worldPos = cc.p(self.screenPos.x, winSize.height - self.screenPos.y)

    -- ✅ Convert screen position to world space (accounts for camera movement)
    local scene = director:getRunningScene()
    local camera = cc.Camera:getDefaultCamera()
    local worldSpacePos = camera:convertToWorldSpace(worldPos)

    self.owner:setPosition(worldSpacePos)  -- ✅ Keep object locked to screen position
end

return StayAtPosition
