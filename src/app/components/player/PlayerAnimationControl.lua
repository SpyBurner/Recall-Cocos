local Component = require("app.core.Component")
local PlayerAnimationControl = class("PlayerAnimationControl", Component)

function PlayerAnimationControl:ctor(owner)
    Component.ctor(self, owner)  -- ✅ Initialize base component
    
    self.animationComponent = owner:getComponent("AnimationComponent")
    self.movementControl = owner:getComponent("MovementControl")
    self.jumpControl = owner:getComponent("JumpComponent")

    if (not self.animationComponent) or (not self.movementControl) or (not self.jumpControl) then
        print("❌ Missing required components!")
        return
    end

    self.lastDirection = cc.p(1, 0)  
end


function PlayerAnimationControl:update(dt)
    if self.jumpControl:isJumping() then
        self.animationComponent:play("jump")
    elseif self.movementControl:isMoving() then
        self.animationComponent:play("walk")
    else
        self.animationComponent:play("idle")
    end

    local direction = self.movementControl:getDirection()

    if (math.abs(direction.x) > 0.1) then
        self.lastDirection = direction  -- ✅ Update last direction only if moving
    end

    local scale = self.animationComponent.scale

    if (direction.x > 0) then
        self.animationComponent.sprite:setScaleX(scale)  -- ✅ Face right
    elseif (direction.x < 0) then
        self.animationComponent.sprite:setScaleX(-scale)  -- ✅ Face left
    end


end


return PlayerAnimationControl
