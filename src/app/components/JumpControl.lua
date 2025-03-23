local bit = require("bit")  -- ✅ Require bitwise operations for Lua 5.1

local Component = require("app.core.Component")
local Input = require("app.core.Input")
local CollisionLayers = require("app.core.CollisionLayers")

local JumpComponent = class("JumpComponent", Component)

function JumpComponent:ctor(owner, jumpStrength, rayCastHeight)
    Component.ctor(self, owner)
    self.jumpStrength = jumpStrength
    self.isOnGround = false
    self.rayCastHeight = 100

    if (owner.joystick) then
        self.joystick = owner.joystick
    end
end

local lastRayCast = 0

function JumpComponent:update(dt)
    if not self.isEnabled then return end  -- ✅ Fix variable name

    -- Jump if the player is pressing up
    if self.joystick then
        local direction = self.joystick:getDirection()
        if direction.y == 1 then
            self:jump()
        end
    end

    -- ✅ Use dt-based timer instead of os.time()
    self.lastRayCast = (self.lastRayCast or 0) + dt
    if self.lastRayCast < 0.2 then return end
    self.lastRayCast = 0

    -- ✅ Ensure we are raycasting correctly
    local startPos = self.owner:getPhysicsBody():getPosition()
    local physicsWorld = cc.Director:getInstance():getRunningScene():getPhysicsWorld()

    local rayStartPos = cc.p(startPos.x, startPos.y - 5)
    local rayEndPos = cc.p(rayStartPos.x, rayStartPos.y - self.rayCastHeight)

    print("Raycasting from:", rayStartPos.x, rayStartPos.y, " to ", rayEndPos.x, rayEndPos.y)

    physicsWorld:rayCast(
        function(world, data)
            self:onRayCastHit(data)
        end,
        rayStartPos,
        rayEndPos
    )
end




function JumpComponent:jump()
    print("isOnGround:", self.isOnGround)
    local body = self.owner:getPhysicsBody()
    if body and self.isOnGround then
        body:setVelocity(cc.p(body:getVelocity().x, self.jumpStrength))
        self.isOnGround = false
    end

end

function JumpComponent:land()
    self.isOnGround = true
end

function JumpComponent:onRayCastHit(data)
    local node = data.shape:getBody():getNode()

    if not node then
        print("Ray hit nothing")
        return false
    end

    print("Ray hit object with bitmask:", node:getPhysicsBody():getCategoryBitmask())

    if bit.band(node:getPhysicsBody():getCategoryBitmask(), CollisionLayers.WALL) ~= 0 then
        print("Hit ground! Landing...")
        self:land()
    else
        print("Hit something else:", node:getPhysicsBody():getCategoryBitmask())
    end

    return false
end

return JumpComponent
