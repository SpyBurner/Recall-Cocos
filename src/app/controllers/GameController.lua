local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  
local CameraFollow = require("app.components.CameraFollow")
local Tilemap = require("app.objects.Tilemap")
local AnimationComponent = require("app.components.AnimationComponent")
local PlayerAnimationControl = require("app.components.player.PlayerAnimationControl")
local MouseTracker = require("app.components.control.MouseTracker")
local BaseObject = require("app.objects.BaseObject")  -- Import the base GameObject class
local Box16 = require("app.objects.BoxCollection.Box16")  -- Import the BoxObject class

local Blob = require("app.objects.Enemy.Blob")

local GameController = class("GameController", cc.Node)

function GameController:ctor()
    
    local map = Tilemap:create("res/maps/simple_map.tmx", 5)  -- Load your TMX file
    map:setPosition(cc.p(0, 0))
    self:addChild(map)

    -- PLAYER
    local player = ControllableObject:create(3, 0.5, 8, 8, 5, 150, 600, true, "Player")  -- ✅ Player-controlled
    player:setPosition(cc.p(100, display.cy))
    player:setLocalZOrder(10)  -- ✅ Set Z-order to ensure player is on top of the map

    -- Animation
    local animations = {
        { name = "idle", plist = "res/Sprites/Player/idle/Idle.plist", frameTime = 0.2, loop = true },
        { name = "walk", plist = "res/Sprites/Player/walk/Walk.plist", frameTime = 0.1, loop = true },
        { name = "jump", plist = "res/Sprites/Player/jump/Jump.plist", frameTime = 0.15, loop = false },
        { name = "dead", plist = "res/Sprites/Player/dead/dead.plist", frameTime = 0.1, loop = false, callback = function()
            print("Player is dead!")
        end },
    }
    
    local animComponent = AnimationComponent:create(player, animations, 5)
    player:addComponent(animComponent)

    animComponent:play("idle")  -- ✅ Play idle animation by default

    local playerAnimControl = PlayerAnimationControl:create(player)
    player:addComponent(playerAnimControl)

    -- PLAYER

    -- ✅ Attach CameraFollow component
    local cameraFollow = CameraFollow:create(player, nil, 100)  -- Follow with 100px deadzone
    player:addComponent(cameraFollow)
    
    self:addChild(player)

    -- Mouse control

    -- local controlHandlerObject = BaseObject:create()
    -- controlHandlerObject:setAnchorPoint(cc.p(0.5, 0.5))
    -- -- controlHandlerObject:setPosition(0, 0)

    -- local cursor = cc.LayerColor:create(cc.c4b(0, 255, 0, 255), 50, 50)
    -- -- cursor:setAnchorPoint(cc.p(0.5, 0.5))
    -- controlHandlerObject:addChild(cursor)
    -- cursor:setPosition(cc.p(-25, -25))


    -- local mouseTracker = MouseTracker:create(controlHandlerObject, true)
    -- controlHandlerObject:addComponent(mouseTracker)

    -- self:addChild(controlHandlerObject)
    -- Mouse control

    -- Physic object
    local physicObject = Box16:create()
    physicObject:setPosition(cc.p(400, display.cy))

    self:addChild(physicObject)
    -- Physic object

    -- Enemy
    local blob1 = Blob:create(player)  -- Pass the player as the target
    blob1:setPosition(cc.p(300, display.cy + 200))

    self:addChild(blob1)
    -- Enemy


end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
