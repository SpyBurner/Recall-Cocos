local GameView = require("app.views.GameView")
local GameController = require("app.controllers.GameController")

local GameScene = class("GameScene", function()
    return cc.Scene:createWithPhysics()
end)

function GameScene:ctor()
    local physicsWorld = self:getPhysicsWorld()
    physicsWorld:setGravity(cc.p(0, -1000))
    physicsWorld:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    -- ✅ Create game view (UI & ground)
    self.view = GameView:create()
    self:addChild(self.view)

    -- ✅ Create game controller (handles player)
    self.controller = GameController:create(physicsWorld)
    self:addChild(self.controller)
end

return GameScene
