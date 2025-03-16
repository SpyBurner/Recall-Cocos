local GameObject = require("app.core.GameObject")
local JumpComponent = require("app.components.JumpComponent")  -- ✅ Import JumpComponent

local Player = class("Player", GameObject)

function Player:ctor()
    self.body = cc.LayerColor:create(cc.c4b(0, 0, 255, 255), 50, 50)  -- Blue square
    self.body:setPosition(cc.p(-25, -25))  -- ✅ Align with physics body
    self:addChild(self.body)

    -- ✅ Add physics body
    local physicsBody = cc.PhysicsBody:createBox(cc.size(50, 50))
    physicsBody:setDynamic(true)
    physicsBody:setMass(1.0)
    physicsBody:setVelocity(cc.p(0, 0))
    physicsBody:setContactTestBitmask(1)
    self:setPhysicsBody(physicsBody)

    -- ✅ Attach JumpComponent
    self.jumpComponent = JumpComponent:create(self)

    -- ✅ Enable update loop
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

-- ✅ Update loop (runs every frame)
function Player:update(dt)
    local velocity = self:getPhysicsBody():getVelocity()
    self:getPhysicsBody():setVelocity(cc.p(velocity.x * 0.9, velocity.y))  -- Apply friction
end

-- ✅ Movement functions
function Player:moveLeft()
    self:getPhysicsBody():setVelocity(cc.p(-200, self:getPhysicsBody():getVelocity().y))
end

function Player:moveRight()
    self:getPhysicsBody():setVelocity(cc.p(200, self:getPhysicsBody():getVelocity().y))
end

function Player:jump()
    if self.jumpComponent then
        self.jumpComponent:jump()  -- ✅ Let JumpComponent handle jumping
    end
end

function Player:land()
    if self.jumpComponent then
        self.jumpComponent:land()  -- ✅ Tell JumpComponent that player is on ground
    end
end

return Player
