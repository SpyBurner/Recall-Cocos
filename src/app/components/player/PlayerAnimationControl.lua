local Component = require("app.core.Component")
local CoreStat = require("app.components.stat.CoreStat")

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
    
    self.stat = self.owner:getComponent("CoreStat")
end


function PlayerAnimationControl:update(dt)
    if not self.animationComponent then return end  -- ✅ Prevent errors

    if self.stat.isDead then
        if self.animationComponent.animations["dead"] then
            self.animationComponent:play("dead")
        end
        return  -- ✅ Stop further processing if dead
    end

    if self.jumpControl:isJumping() then
        if self.animationComponent.animations["jump"] then
            self.animationComponent:play("jump")
        end
    elseif self.movementControl:isMoving() then
        if self.animationComponent.animations["walk"] then
            self.animationComponent:play("walk")
        end
    else
        if self.animationComponent.animations["idle"] then
            self.animationComponent:play("idle")
        end
    end

    -- ✅ Handle sprite flipping
    local direction = self.movementControl:getDirection()
    if math.abs(direction.x) > 0.1 then
        self.lastDirection = direction
    end

    local scale = self.animationComponent.scale
    if direction.x > 0 then
        self.animationComponent.sprite:setScaleX(scale)  -- ✅ Face right
    elseif direction.x < 0 then
        self.animationComponent.sprite:setScaleX(-scale)  -- ✅ Face left
    end
end


return PlayerAnimationControl
