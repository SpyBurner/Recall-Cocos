local GameObject = require("app.core.GameObject")
local Ground = class("Ground", GameObject)

function Ground:ctor()
    self.body = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), display.width, 50)  -- Red ground
    self:addChild(self.body)

    -- ✅ Add physics body
    local physicsBody = cc.PhysicsBody:createBox(cc.size(display.width, 50))
    physicsBody:setDynamic(false)
    physicsBody:setContactTestBitmask(1)
    self:setPhysicsBody(physicsBody)
end

return Ground
