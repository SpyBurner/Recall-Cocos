local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  
local CameraFollow = require("app.components.CameraFollow")
local Tilemap = require("app.objects.Tilemap")
local AnimationComponent = require("app.components.AnimationComponent")

local GameController = class("GameController", cc.Node)

function GameController:ctor(physicsWorld)
    local player = ControllableObject:create(8, 8, 5, 150, 600, true)  -- ✅ Player-controlled
    player:setPosition(cc.p(display.cx, display.cy + 100))
    
    -- Animation
    local animations = {
        { name = "idle", path = "res/Sprites/Player/idle-sheet.png", frameTime = 0.2, loop = true },
        { name = "run", path = "res/Sprites/Player/walk-sheet.png", frameTime = 0.1, loop = true },
        { name = "jump", path = "res/Sprites/Player/jump-sheet.png", frameTime = 0.15, loop = false, callback = function()
            print("Jump animation finished!")
        end }
    }
    
    local animComponent = AnimationComponent:create(self, animations, 5)
    player:addComponent(animComponent)

    animComponent:play("idle")  -- ✅ Play idle animation by default

    -- ✅ Attach CameraFollow component
    local cameraFollow = CameraFollow:create(player, nil, 100)  -- Follow with 100px deadzone
    player:addComponent(cameraFollow)
    
    self:addChild(player)

    -- local ground1 = Ground:create(50, display.height)
    -- ground1:setPosition(cc.p(display.cx, 50))
    -- self:addChild(ground1)

    local ground2 = Ground:create(500, 20)
    ground2:setPosition(cc.p(display.cx, 50))
    self:addChild(ground2)

    -- local ground3 = Ground:create(200, 20)
    -- ground3:setPosition(cc.p(display.cx + 300, 100))
    -- self:addChild(ground3)

    -- local ground4 = Ground:create(200, 20)
    -- ground4:setPosition(cc.p(display.cx + 600, 200))
    -- self:addChild(ground4)

    local map = Tilemap:create("res/maps/simple_map.tmx", 5)  -- Load your TMX file
    map:setPosition(cc.p(0, 0))
    self:addChild(map)

    -- local sprite = cc.Sprite:create("res/HelloWorld.png")
    -- sprite:setPosition(cc.p(display.cx, display.cy))
    -- self:addChild(sprite)



    -- ✅ Enable update loop (Only needed if GameController has its own logic)
end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
