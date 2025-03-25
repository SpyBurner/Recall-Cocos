local Component = require("app.core.Component")
local Joystick = require("app.components.Joystick")

local CollisionLayers = require("app.core.CollisionLayers")

local MovementControl = class("MovementControl", Component)

function MovementControl:ctor(owner, speed, playerControlled, wallDistance)
    Component.ctor(self, owner)  -- ✅ Call base class constructor

    self.speed = speed or 200  -- ✅ Default speed
    self.direction = cc.p(0, 0)
    
    self.wallDistance = wallDistance or 50

    if playerControlled then
        self.joystick = self.owner.joystick
        print("Player controlled")
    else
        print("Not player controlled")
    end


    self.physicsBody = self.owner.physicsBody

    self.stat = self.owner:getComponent("CoreStat")

    self.stat.OnDeathEvent:AddListener(function()
        self.isEnabled = false  -- ✅ Disable movement on death
    end)

end

function MovementControl:getDirection()
    return self.direction
end

function MovementControl:isMoving()
    return math.abs(self.direction.x) > 0.1
end

function MovementControl:update(dt)
    if not self.isEnabled then return end

    
    if self.joystick then
        self.direction = self.joystick:getDirection()
    end


    if math.abs(self.direction.x) > 0.1 then
        -- ✅ Check if there's a wall before applying force
        -- if not self:isWallAhead(self.direction.x) then
            local force = cc.p(self.direction.x * self.speed * 1000, 0)  -- ✅ Large force for instant acceleration
            self.physicsBody:applyForce(force, self.physicsBody:getPosition())
        -- end
    else -- ✅ Stop if no input
        self.physicsBody:setVelocity(cc.p(0, self.physicsBody:getVelocity().y))
    end

    -- ✅ Clamp velocity to prevent overshooting
    local velocity = self.physicsBody:getVelocity()
    if math.abs(velocity.x) > self.speed then
        local clampedVelocityX = (velocity.x > 0) and self.speed or -self.speed
        self.physicsBody:setVelocity(cc.p(clampedVelocityX, velocity.y))  -- ✅ Limit to max speed
    end
end



function MovementControl:isWallAhead(direction)
    local physicsWorld = cc.Director:getInstance():getRunningScene():getPhysicsWorld()
    
    local posX, posY = self.owner:getPosition()
    local startPos = cc.p(posX, posY)
    local offsetX = direction * self.wallDistance  -- Adjust this to avoid false positives
    local rayStartPos = cc.p(startPos.x, startPos.y)
    local rayEndPos = cc.p(startPos.x + offsetX, startPos.y)

    local hitWall = false

    physicsWorld:rayCast(
        function(world, data)
            local hitNode = data.shape:getBody():getNode()
            if hitNode and bit.band(hitNode:getPhysicsBody():getCategoryBitmask(), CollisionLayers.WALL) ~= 0 then
                hitWall = true
            end
        end,
        rayStartPos,
        rayEndPos
    )

    return hitWall
end

return MovementControl
