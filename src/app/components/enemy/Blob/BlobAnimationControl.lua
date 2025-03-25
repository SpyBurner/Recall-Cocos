local Component = require("app.core.Component")
local CoreStat = require("app.components.stat.CoreStat")

local BlobAnimationControl = class("BlobAnimationControl", Component)

function BlobAnimationControl:ctor(owner)
    Component.ctor(self, owner)  -- ✅ Initialize base component
    
    self.animationComponent = owner:getComponent("AnimationComponent")
    self.movementControl = owner:getComponent("MovementControl")

    if (not self.animationComponent) or (not self.movementControl) then
        print("❌ Missing required components!")
        return
    end

    self.lastDirection = cc.p(1, 0) 
    
    self.stat = self.owner:getComponent("CoreStat")
end

function BlobAnimationControl:update(dt)
    if not self.animationComponent then return end  -- ✅ Prevent errors

    if self.stat and self.stat.isDead then
        if self.animationComponent.animations["blob_die"] then
            self.animationComponent:play("blob_die")
        end
        return  -- ✅ Stop further processing if dead
    end

    if self.movementControl:isMoving() then
        if self.animationComponent.animations["blob_walk"] then
            self.animationComponent:play("blob_walk")
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

return BlobAnimationControl