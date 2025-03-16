local bit = require("bit")  -- ✅ Require bitwise operations for Lua 5.1

local Component = require("app.core.Component")
local Input = require("app.core.Input")
local CollisionLayers = require("app.core.CollisionLayers")

local JumpComponent = class("JumpComponent", Component)

function JumpComponent:ctor(owner, jumpStrength, physicsWorld, rayCastHeight)
    Component.ctor(self, owner)
    self.jumpStrength = jumpStrength
    self.isOnGround = false
    self.rayCastHeight = 40
    self.physicsWorld = physicsWorld

    if (owner.joystick) then
        self.joystick = owner.joystick
    end

    -- ✅ Enable collision detection
    -- local function onContactBegin(contact)
    --     local a = contact:getShapeA():getBody():getNode()
    --     local b = contact:getShapeB():getBody():getNode()

    --     if a ~= self.owner then
    --         local temp = a
    --         a = b
    --         b = temp
    --     end

    --     local aX, aY = a:getPosition()
    --     local bX, bY = b:getPosition()
        
    --     print("Contact between A: " .. a:getName() .. " and B: " .. b:getName())
    --     print("A position: " .. aX .. ", " .. aY)
    --     print("B position: " .. bX .. ", " .. bY)

        

    --     local bitmaskB = b:getPhysicsBody():getCategoryBitmask()

    --     if (bit.bor(bitmaskB, CollisionLayers.WALL) == 0) then  -- ✅ Ensure player lands on ground
    --         return true
    --     end

    --     self:land()
    --     return true
    -- end

    -- local contactListener = cc.EventListenerPhysicsContact:create()
    -- contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    -- self.owner:getEventDispatcher():addEventListenerWithSceneGraphPriority(contactListener, self.owner)
end

function JumpComponent:update(dt)
    if not self.isEnabled then return end  -- ✅ Fix variable name

    if self.joystick then
        local direction = self.joystick:getDirection()
        if direction.y == 1 then
            self:jump()
        end
    end

    local startX, startY = self.owner:getPosition()
    local startPos = cc.p(startX, startY)
    local endPos = cc.p(startX, startY - self.rayCastHeight)

    self.physicsWorld:rayCast(
        function (world, data)
            self:onRayCastHit(data)
        end,
        startPos,
        endPos
    )
end



function JumpComponent:jump()
    print("Jumping:", self.isOnGround)
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
    cc.exports.printTable = function(indent, t)
        print(indent)
        if (type(t) ~= "table") then
            print(string.rep(" ", indent) .. t)
            return
        end
        for key, value in pairs(t) do
            if (type(value) ~= "table") then
                print(string.rep(" ", indent) .. key, value)
            else
                print(string.rep(" ", indent) .. key)
                printTable(indent + 2, value)
            end
        end
    end

    printTable(0, data)

    local node = data.shape:getBody():getNode()
    if node == self.owner then
        print("Hit self")
        return true
    end

    print("Hit different")
    self:land()
    return true
end

return JumpComponent
