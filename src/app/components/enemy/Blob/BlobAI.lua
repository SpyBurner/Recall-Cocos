local Component = require("app.core.Component")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

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
    self.lastRayCast = 0  -- Timer for raycast interval
end

function BlobAI:update(dt)
    if not self.isEnabled then return end

    -- ✅ Use dt-based timing (like `JumpComponent`)
    self.lastRayCast = (self.lastRayCast or 0) + dt
    if self.lastRayCast < 0.1 then return end
    self.lastRayCast = 0

    local position = cc.p(self.owner:getPosition())
    local physicsWorld = self.owner:getScene():getPhysicsWorld()

    -- ✅ Define Multiple Raycast Positions
    local offsets = {-10, 0, 10}  -- ✅ Cast from Left, Center, Right
    local forwardLength = 25
    local downwardLength = 45

    -- ✅ Collision Mask
    local mask = bit.bor(CollisionLayers.WALL, CollisionLayers.PUSHABLE)

    -- ✅ Reset hit detection before new raycast
    self.hitForward = false
    self.hitDown = false
    
    local function raycastCallbackForward(data)
        local node = data.shape:getBody():getNode()
        if not node then return true end  -- ✅ Ensure node exists
        local category = node:getPhysicsBody():getCategoryBitmask()
        
        if (bit.band(category, mask) ~= 0) then
            -- print("✅ Forward Ray Hit Detected!")  -- ✅ Debug print
            self.hitForward = true
        end
        -- print("Raycast forward hit category:", category)  -- ✅ Debug print

        return true
    end
    
    local function raycastCallbackDown(data)
        local node = data.shape:getBody():getNode()
        if not node then return true end  -- ✅ Ensure node exists
        local category = node:getPhysicsBody():getCategoryBitmask()
        
        if (bit.band(category, mask) ~= 0) then
            -- print("✅ Downward Ray Hit Detected!")  -- ✅ Debug print
            self.hitDown = true
        end
        -- print("Raycast downward hit category:", category)  -- ✅ Debug print
        return true
    end
    

    for _, offsetX in ipairs(offsets) do
        local startX = position.x + offsetX
        local startForward = cc.p(startX + self.direction.x * forwardLength, position.y)
        local endForward = cc.p(startX + (self.direction.x * forwardLength), position.y)  
        local endDown = cc.p(endForward.x, endForward.y - downwardLength)

        -- print("Position: ", position.x, position.y)  -- ✅ Debug print
        -- print("Raycast positions: ", startForward.x, startForward.y, "\n", endForward.x, endForward.y,"\n", endDown.x, endDown.y)  -- ✅ Debug print
    
        -- ✅ Perform raycasts
        physicsWorld:rayCast(function(world, data) raycastCallbackForward(data) end, startForward, endForward)
        physicsWorld:rayCast(function(world, data) raycastCallbackDown(data) end, endForward, endDown)
    end
    
    

    -- ✅ Only turn around if on ground & no forward/downward obstacle
    if self.jumpComponent.isOnGround and (self.hitForward or not self.hitDown) then
        self.direction.x = -self.direction.x  -- Flip direction
    end

    -- ✅ Move Up if Target is Higher
    if self.target then
        local targetPos = cc.p(self.target:getPosition())

        local dx = targetPos.x - position.x
        local dy = targetPos.y - position.y
        local targetDistance = math.sqrt(dx * dx + dy * dy)

        if targetDistance < 50 then
            self.direction.y = (targetPos.y > position.y + 50) and 1 or 0
        end

    end

    -- ✅ Apply Direction to Joystick
    self.joystick:setDirection(self.direction.x, self.direction.y)

    -- print("Hit: ", self.hitForward, self.hitDown)
    -- print("isOnGround: ", self.jumpComponent.isOnGround)
    -- print("Direction: ", self.direction.x, self.direction.y)
end

return BlobAI
