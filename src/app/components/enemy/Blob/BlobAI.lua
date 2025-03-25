local Component = require("app.core.Component")
local CollisionLayers = require("app.core.CollisionLayers")

local BlobAI = class("BlobAI", Component)

function BlobAI:ctor(owner, target)
    Component.ctor(self, owner)
    self.target = target
    self.direction = cc.p(1, 0)  -- Moving right initially

    self.joystick = self.owner:getComponent("Joystick")
    if not self.joystick then
        error("BlobAI requires a Joystick component on the owner.")
    end

    self.jumpComponent = self.owner:getComponent("JumpComponent")
    if not self.jumpComponent then
        error("BlobAI requires a JumpComponent on the owner.")
    end
    
    self.hitForward = false
    self.hitDown = false
end

function BlobAI:update(dt)
    -- print("Blob ground check: ", self.jumpComponent.isOnGround)

    if not self.isEnabled then return end

    local position = cc.p(self.owner:getPosition())
    local physicsWorld = self.owner:getScene():getPhysicsWorld()

    -- ✅ Define Raycast Directions
    local forwardCheck = cc.pAdd(position, cc.p(self.direction.x * 50, 0))  -- Forward
    local downCheck = cc.pAdd(forwardCheck, cc.p(0, -45))  -- 45° downward

    -- ✅ Perform Raycast Checks
    local mask = bit.bor(CollisionLayers.WALL, CollisionLayers.PUSHABLE)

    local function checkBit(contact)
        local body = contact.shape:getBody()
        if body and bit.bor(body:getCategoryBitmask(), mask) ~= 0 then
            -- Hit detected, return true to stop the raycast
            return true
        end
        return false  -- No hit
    end

    local function raycastCallbackForward(world, contact)
        self.hitForward = checkBit(contact)
    end
    local function raycastCallbackDown(world, contact)
        self.hitForward = checkBit(contact)
    end

    physicsWorld:rayCast(raycastCallbackForward, position, forwardCheck)
    physicsWorld:rayCast(raycastCallbackDown, forwardCheck, downCheck)

    -- ✅ Only turn around if on ground
    if self.jumpComponent.isOnGround and not self.hitForward and not self.hitDown then
        self.direction.x = -self.direction.x  -- Flip direction
    end

    -- ✅ Check if target is higher
    if self.target then
        local targetPos = cc.p(self.target:getPosition())
        if targetPos.y > position.y + 10 then
            self.direction.y = 1  -- Move up
        else
            self.direction.y = 0  -- Move normally
        end
    end

    -- ✅ Apply Direction to Joystick
    self.joystick:setDirection(self.direction.x, self.direction.y)

    self.hitForward = false  -- Reset hit check for next frame
    self.hitDown = false  -- Reset hit check for next frame
end

return BlobAI
