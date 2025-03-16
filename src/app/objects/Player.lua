local GameObject = require("app.core.GameObject")
local JumpComponent = require("app.components.JumpComponent")
local Input = require("app.core.Input")  -- ✅ Import Input directly

local Player = class("Player", GameObject)

function Player:ctor()
    self.body = cc.LayerColor:create(cc.c4b(0, 0, 255, 255), 50, 50)
    self.body:setPosition(cc.p(-25, -25))
    self:addChild(self.body)

    -- ✅ Add physics body
    local material = cc.PhysicsMaterial(0.1, 0.5, 0.9)
    local physicsBody = cc.PhysicsBody:createBox(cc.size(50, 50), material)
    physicsBody:setDynamic(true)
    physicsBody:setContactTestBitmask(1)
    self:setPhysicsBody(physicsBody)

    -- ✅ Attach JumpComponent
    self.jumpComponent = JumpComponent:create(self)

    -- ✅ Enable update loop
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)

    -- ✅ Initialize input
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            local scene = cc.Director:getInstance():getRunningScene()
            if scene then
                Input.init(scene)  -- ✅ Move input setup to Player
            end
        end)
    ))

    -- ✅ Enable collision detection
    local function onContactBegin(contact)
        print("onContactBegin", contact:getShapeA():getBody():getNode(), contact:getShapeB():getBody():getNode())
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        -- ✅ Check if player touches the ground
        if a == self or b == self then
            self:land()  -- ✅ Move collision handling to Player
        end
        return true
    end

    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(contactListener, self)
end

function Player:update(dt)
    -- ✅ Handle input inside Player instead of GameController
    if Input.isKeyPressed(cc.KeyCode.KEY_A) or Input.isKeyPressed(cc.KeyCode.KEY_LEFT_ARROW) then
        self:moveLeft()
    elseif Input.isKeyPressed(cc.KeyCode.KEY_D) or Input.isKeyPressed(cc.KeyCode.KEY_RIGHT_ARROW) then
        self:moveRight()
    end

    if Input.isKeyPressed(cc.KeyCode.KEY_W) or Input.isKeyPressed(cc.KeyCode.KEY_UP_ARROW) then
        self:jump()
    end
end

function Player:moveLeft()
    self:getPhysicsBody():setVelocity(cc.p(-200, self:getPhysicsBody():getVelocity().y))
end

function Player:moveRight()
    self:getPhysicsBody():setVelocity(cc.p(200, self:getPhysicsBody():getVelocity().y))
end

function Player:jump()
    if self.jumpComponent then
        self.jumpComponent:jump()
    end
end

function Player:land()
    if self.jumpComponent then
        self.jumpComponent:land()
    end
end

return Player
