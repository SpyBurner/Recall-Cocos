local Component = require("app.core.Component")
local JumpComponent = class("JumpComponent", Component)

function JumpComponent:ctor(owner)
    Component.ctor(self, owner)  -- Call base class constructor
    self.jumpStrength = 300
    self.isOnGround = true
end

function JumpComponent:jump()
    local body = self.owner:getPhysicsBody()
    if body and self.isOnGround then
        body:setVelocity(cc.p(body:getVelocity().x, self.jumpStrength))
        self.isOnGround = false  -- Prevent multiple jumps
    end
end

function JumpComponent:land()
    self.isOnGround = true
end

return JumpComponent
