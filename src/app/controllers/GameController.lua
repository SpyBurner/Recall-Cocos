local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  
local CameraFollow = require("app.components.CameraFollow")

local GameController = class("GameController", cc.Node)

function GameController:ctor(physicsWorld)
    local player = ControllableObject:create(150, 600, true)  -- ✅ Player-controlled
    player:setPosition(cc.p(display.cx, display.cy + 100))
    
    -- ✅ Attach CameraFollow component
    local cameraFollow = CameraFollow:create(player, nil, 100)  -- Follow with 100px deadzone
    player:addComponent(cameraFollow)
    
    self:addChild(player)

    local ground1 = Ground:create(50, display.height)
    ground1:setPosition(cc.p(display.cx, 50))
    self:addChild(ground1)

    local ground2 = Ground:create(500, 20)
    ground2:setPosition(cc.p(display.cx, 50))
    self:addChild(ground2)

    local ground3 = Ground:create(200, 20)
    ground3:setPosition(cc.p(display.cx + 300, 100))
    self:addChild(ground3)

    local ground4 = Ground:create(200, 20)
    ground4:setPosition(cc.p(display.cx + 600, 200))
    self:addChild(ground4)



    -- ✅ Enable update loop (Only needed if GameController has its own logic)
end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
