local bit = require("bit")  -- ✅ Require bitwise operations for Lua 5.1

local Component = require("app.core.Component")
local Input = require("app.core.Input")
local CollisionLayers = require("app.core.CollisionLayers")

local JumpComponent = class("JumpComponent", Component)

function JumpComponent:ctor(owner, jumpStrength, rayCastHeight)
    Component.ctor(self, owner)
    self.jumpStrength = jumpStrength
    self.isOnGround = false
    self.rayCastHeight = 30

    if (owner.joystick) then
        self.joystick = owner.joystick
    end
end

local lastRayCast = 0

function JumpComponent:update(dt)
    if not self.isEnabled then return end  

    -- Jump if pressing up
    if self.joystick then
        local direction = self.joystick:getDirection()
        if direction.y == 1 then
            self:jump()
        end
    end

    -- ✅ Use dt-based timing
    self.lastRayCast = (self.lastRayCast or 0) + dt
    if self.lastRayCast < 0.1 then return end
    self.lastRayCast = 0

    local startPos = self.owner:getPhysicsBody():getPosition()
    local physicsWorld = cc.Director:getInstance():getRunningScene():getPhysicsWorld()

    local playerWidth = 50
    local offsets = {-playerWidth / 3, 0, playerWidth / 3}  -- ✅ Cast from Left, Center, Right

    local rayStep = 5  -- ✅ Distance between ray start heights
    local totalChecks = math.floor(self.rayCastHeight / rayStep)  -- ✅ Number of rays to cast

    for _, offsetX in ipairs(offsets) do
        for i = 0, totalChecks do
            local rayStartPos = cc.p(startPos.x + offsetX, startPos.y - (i * rayStep))
            local rayEndPos = cc.p(rayStartPos.x, rayStartPos.y - rayStep)

            physicsWorld:rayCast(
                function(world, data)
                    self:onRayCastHit(data)
                end,
                rayStartPos,
                rayEndPos
            )
        end
    end
end

function JumpComponent:jump()
    -- print("isOnGround:", self.isOnGround)
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

    if not node then return false end

    local category = node:getPhysicsBody():getCategoryBitmask()
    print("Ray hit at Y:", data.start.y, "->", data.contact.y, "Bitmask:", category)

    if bit.band(category, CollisionLayers.WALL) ~= 0 then
        print("✅ Landed on a thin platform!")
        self:land()
    end
    return false
end


return JumpComponent
