local Player = require("app.objects.Player")

local GameController = class("GameController", cc.Node)

function GameController:ctor()
    self.player = Player:create()
    self.player:setPosition(display.cx, 150)
    self:addChild(self.player)
    
    -- ✅ Enable update loop (Only needed if GameController has its own logic)
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function GameController:update(dt)
    -- ✅ Nothing here, Player handles its own movement
end

return GameController
