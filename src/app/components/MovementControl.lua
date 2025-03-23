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

end

function MovementControl:update(dt)
    if not self.isEnabled then return end

    local newVelocityX = 0  -- Default to stop movement

    if self.joystick then
        self.direction = self.joystick:getDirection()
    end

    if math.abs(self.direction.x) > 0.1 then
        -- ✅ Check for wall before moving
        if not self:isWallAhead(self.direction.x) then
            newVelocityX = self.direction.x * self.speed
        else
            newVelocityX = 0  -- Stop if a wall is ahead
        end
    end

    local velocityY = self.physicsBody:getVelocity().y
    self.physicsBody:setVelocity(cc.p(newVelocityX, velocityY))
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
