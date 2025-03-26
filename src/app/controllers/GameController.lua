local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  
local CameraFollow = require("app.components.CameraFollow")
local Tilemap = require("app.objects.Tilemap")
local AnimationComponent = require("app.components.AnimationComponent")
local PlayerAnimationControl = require("app.components.player.PlayerAnimationControl")
local MouseTracker = require("app.components.control.MouseTracker")
local BaseObject = require("app.objects.BaseObject")  -- Import the base GameObject class
local ReloadGame = require("app.components.control.ReloadLevel")  -- Import the ReloadGame component

local Box8 = require("app.objects.BoxCollection.Box8")  -- Import the BoxObject class
local Box16 = require("app.objects.BoxCollection.Box16")  -- Import the BoxObject class
local Box28 = require("app.objects.BoxCollection.Box28")  -- Import the BoxObject class
local Box32 = require("app.objects.BoxCollection.Box32")  -- Import the BoxObject class


local Blob = require("app.objects.Enemy.Blob")

local Heart = require("app.objects.PowerUp.Heart")  -- Import the Heart class

local SpriteGameObject = require("app.objects.UI.SpriteGameObject")
local StayAtPosition = require("app.components.ui.StayAtPosition")

local GameController = class("GameController", cc.Node)

function GameController:ctor()
    
    local map = Tilemap:create("res/maps/simple_map.tmx", 5)  -- Load your TMX file
    map:setPosition(cc.p(0, 0))
    self:addChild(map)

    local reload = ReloadGame:create(map)  -- Create the reload component
    map:addComponent(reload)  -- Add the reload component to the map

    -- PLAYER
    local player = ControllableObject:create(3, 1, 8, 8, 5, 150, 500, true, "Player")  -- ✅ Player-controlled
    
    player:setPosition(map:tileToWorldCoord(cc.p(12,41)))
    player:setLocalZOrder(10)  -- ✅ Set Z-order to ensure player is on top of the map

    local threeByThree_temp = Box8:create()
    threeByThree_temp:setPosition(map:tileToWorldCoord(cc.p(22, 41)))
    self:addChild(threeByThree_temp)

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

    -- Physic object
    local oneByOne = Box8:create()
    oneByOne:setPosition(map:tileToWorldCoord(cc.p(11,10 + 13)))
    self:addChild(oneByOne)

    local oneByOne1 = Box8:create()
    oneByOne1:setPosition(map:tileToWorldCoord(cc.p(14,10 + 13)))
    self:addChild(oneByOne1)

    local twoByTwo = Box16:create()
    twoByTwo:setPosition(map:tileToWorldCoord(cc.p(18,10 + 20)))
    self:addChild(twoByTwo)

    local twoByTwo2 = Box16:create()
    twoByTwo2:setPosition(map:tileToWorldCoord(cc.p(67,10 + 18)))
    self:addChild(twoByTwo2)

    local twoByTwo3 = Box16:create()
    twoByTwo3:setPosition(map:tileToWorldCoord(cc.p(78,10 + 12)))
    self:addChild(twoByTwo3)

    local twoByTwo4 = Box16:create()
    twoByTwo4:setPosition(map:tileToWorldCoord(cc.p(83, 35)))
    self:addChild(twoByTwo4)

    local threeByThree = Box28:create()
    threeByThree:setPosition(map:tileToWorldCoord(cc.p(39,10 + 16)))
    self:addChild(threeByThree)

    local bigBox = Box32:create()
    bigBox:setPosition(map:tileToWorldCoord(cc.p(114, 6)))
    self:addChild(bigBox)


    -- Enemy
    local blob1 = Blob:create(player)  -- Pass the player as the target
    blob1:setPosition(map:tileToWorldCoord(cc.p(74, 42)))
    self:addChild(blob1)

    local blob2 = Blob:create(player)  -- Pass the player as the target
    blob2:setPosition(map:tileToWorldCoord(cc.p(77, 36)))
    self:addChild(blob2)

    local blob3 = Blob:create(player)  -- Pass the player as the target
    blob3:setPosition(map:tileToWorldCoord(cc.p(73, 32)))
    self:addChild(blob3)

    local blob4 = Blob:create(player)  -- Pass the player as the target
    blob4:setPosition(map:tileToWorldCoord(cc.p(60, 42)))
    self:addChild(blob4)

    local blob5 = Blob:create(player)  -- Pass the player as the target
    blob5:setPosition(map:tileToWorldCoord(cc.p(62, 42)))
    self:addChild(blob5)

    local blob6 = Blob:create(player)  -- Pass the player as the target
    blob6:setPosition(map:tileToWorldCoord(cc.p(38, 42)))
    self:addChild(blob6)

    local blob7 = Blob:create(player)  -- Pass the player as the target
    blob7:setPosition(map:tileToWorldCoord(cc.p(11, 29)))
    self:addChild(blob7)
    -- Enemy

    -- PowerUp

    -- Heart
    -- ✅ List of tile coordinates for hearts
    local heartPositions = {
        cc.p(19, 24),
        cc.p(26, 42),
        cc.p(65, 27),
        cc.p(77, 22),
        cc.p(39, 30),
        cc.p(112, 17),
        cc.p(91, 26)
    }

    -- ✅ Spawn hearts at each position
    for _, tilePos in ipairs(heartPositions) do
        local heart = Heart:create("res/Sprites/Powerup/heart.png")  -- ✅ Create heart object
        heart:setPosition(map:tileToWorldCoord(tilePos))  -- ✅ Convert tile position to world position
        self:addChild(heart)  -- ✅ Add to the scene
    end


    -- PowerUp

    -- ✅ Create a game object with a sprite and counter
    local coinDisplay = SpriteGameObject:create("res/Sprites/Powerup/coin.png", 5)

    -- ✅ Attach the position-locking component
    local stayComponent = StayAtPosition:create(coinDisplay, cc.p(300, 500))
    coinDisplay:addComponent(stayComponent)

    -- ✅ Add to scene
    self:addChild(coinDisplay)

    -- ✅ Example: Increment counter when a coin is collected
    coinDisplay:incrementCounter(1)

end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
