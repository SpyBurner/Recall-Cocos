local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  

local GameController = class("GameController", cc.Node)

function GameController:ctor(physicsWorld)
    local player = ControllableObject:create(physicsWorld, 200, 600, true)  -- ✅ Player-controlled
    player:setPosition(cc.p(100, 250))
    self:addChild(player)

    local ground1 = Ground:create(display.width, 200)
    ground1:setPosition(cc.p(display.cx, 25))
    self:addChild(ground1)

    local ground2 = Ground:create(50, display.height)
    ground2:setPosition(cc.p(display.cy, 200))
    self:addChild(ground2)



    -- ✅ Enable update loop (Only needed if GameController has its own logic)
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
