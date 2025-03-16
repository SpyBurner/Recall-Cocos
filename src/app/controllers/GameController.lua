local GameView = require("app.views.GameView")
local GameController = class("GameController", GameView)  -- Extend GameView

function GameController:onCreate()
    GameController.super.onCreate(self)  -- Call GameView's onCreate()

    -- ✅ Create player (blue rectangle with physics)
    self.player = cc.LayerColor:create(cc.c4b(0, 0, 255, 255), 50, 50)  -- Blue 50x50 box
    self.player:setPosition(display.cx, display.cy)

    -- ✅ Add physics body for player
    local playerBody = cc.PhysicsBody:createBox(cc.size(50, 50))
    playerBody:setDynamic(true)  -- Enable physics movement
    playerBody:setMass(1.0)      -- Normal mass
    playerBody:setVelocity(cc.p(0, 0))  -- Start with no movement
    playerBody:setContactTestBitmask(1)  -- Enable collision detection
    self.player:setPhysicsBody(playerBody)
    self:addChild(self.player)

    -- ✅ Track whether the player is on the ground
    self.isOnGround = false

    -- ✅ Enable keyboard input
    local function onKeyPressed(keyCode, event)
        self:handleInput(keyCode, true)
    end
    local function onKeyReleased(keyCode, event)
        self:handleInput(keyCode, false)
    end

    local keyboardListener = cc.EventListenerKeyboard:create()
    keyboardListener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyboardListener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(keyboardListener, self)

    -- ✅ Enable collision detection
    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        -- If the player touches the ground, set `isOnGround = true`
        if (a == self.player and b == self.ground) or (b == self.player and a == self.ground) then
            self.isOnGround = true
        end
        return true
    end

    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(contactListener, self)
end

-- ✅ Handle player input (walk, jump)
function GameController:handleInput(keyCode, isPressed)
    local playerBody = self.player:getPhysicsBody()
    local speed = 200

    if keyCode == cc.KeyCode.KEY_LEFT_ARROW or keyCode == cc.KeyCode.KEY_A then
        playerBody:setVelocity(cc.p(-speed, playerBody:getVelocity().y))  -- Move left
    elseif keyCode == cc.KeyCode.KEY_RIGHT_ARROW or keyCode == cc.KeyCode.KEY_D then
        playerBody:setVelocity(cc.p(speed, playerBody:getVelocity().y))  -- Move right
    elseif keyCode == cc.KeyCode.KEY_UP_ARROW or keyCode == cc.KeyCode.KEY_W then
        if self.isOnGround then
            playerBody:setVelocity(cc.p(playerBody:getVelocity().x, 300))  -- Jump up
            self.isOnGround = false  -- Reset ground check
        end
    end
end

return GameController
