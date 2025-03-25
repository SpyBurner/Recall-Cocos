local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  
local CameraFollow = require("app.components.CameraFollow")
local Tilemap = require("app.objects.Tilemap")
local AnimationComponent = require("app.components.AnimationComponent")
local PlayerAnimationControl = require("app.components.player.PlayerAnimationControl")
local MouseTracker = require("app.components.control.MouseTracker")
local GameObject = require("app.core.GameObject")  -- Import the base GameObject class


local GameController = class("GameController", cc.Node)

function GameController:ctor()
    
    local map = Tilemap:create("res/maps/simple_map.tmx", 5)  -- Load your TMX file
    map:setPosition(cc.p(0, 0))
    self:addChild(map)

    -- PLAYER
    local player = ControllableObject:create(3, 1, 8, 8, 5, 150, 600, true)  -- ✅ Player-controlled
    player:setPosition(cc.p(display.cx, display.cy + 100))

    -- Animation
    local animations = {
        { name = "idle", plist = "res/Sprites/Player/idle/Idle.plist", frameTime = 0.2, loop = true },
        { name = "walk", plist = "res/Sprites/Player/walk/Walk.plist", frameTime = 0.1, loop = true },
        { name = "jump", plist = "res/Sprites/Player/jump/Jump.plist", frameTime = 0.15, loop = false, callback = function()
            print("Jump animation finished!")
        end },
        { name = "dead", plist = "res/Sprites/Player/dead/dead.plist", frameTime = 0.1, loop = false,}
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

    local controlHandlerObject = GameObject:create()
    controlHandlerObject:setPosition(cc.p(display.cx, display.cy))

    local cursor = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), 10, 10)
    controlHandlerObject:addChild(cursor)
    cursor:setPosition(cc.p(0, 0))

    -- local mouseTracker = MouseTracker:create(controlHandlerObject)
    -- controlHandlerObject:addComponent(mouseTracker)

    -- Mouse control

end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
