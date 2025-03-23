local bit = require("bit")  -- ✅ Require bitwise operations for Lua 5.1

local Component = require("app.core.Component")
local Input = require("app.core.Input")
local CollisionLayers = require("app.core.CollisionLayers")

local JumpComponent = class("JumpComponent", Component)

function JumpComponent:ctor(owner, jumpStrength, physicsWorld, rayCastHeight)
    Component.ctor(self, owner)
    self.jumpStrength = jumpStrength
    self.isOnGround = false
    self.rayCastHeight = 60
    self.physicsWorld = physicsWorld

    if (owner.joystick) then
        self.joystick = owner.joystick
    end
end

function JumpComponent:update(dt)
    if not self.isEnabled then return end  -- ✅ Fix variable name

    if self.joystick then
        local direction = self.joystick:getDirection()
        if direction.y == 1 then
            self:jump()
        end
    end

    local startPos = self.owner:getPhysicsBody():getPosition()
    local endPos = cc.p(startPos.x, startPos.y - self.rayCastHeight)

    print ("startPos:", startPos.x, startPos.y)
    print ("endPos:", endPos.x, endPos.y)

    self.physicsWorld:rayCast(
        function (world, data)
            self:onRayCastHit(data)
        end,
        startPos,
        endPos
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

    -- printTable(0, data)

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
