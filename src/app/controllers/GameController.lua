local ControllableObject = require("app.objects.ControllableObject") 
local Ground = require("app.objects.Ground")  

local GameController = class("GameController", cc.Node)

function GameController:ctor(physicsWorld)
    local player = ControllableObject:create(physicsWorld, 700, 600, true)  -- ✅ Player-controlled
    player:setPosition(cc.p(display.cx, display.cy + 100))
    self:addChild(player)

    local ground2 = Ground:create(500, 200)
    ground2:setPosition(cc.p(display.cx, 0))
    self:addChild(ground2)



    -- ✅ Enable update loop (Only needed if GameController has its own logic)
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
