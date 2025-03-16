local GameController = require("app.controllers.GameController")

local GameScene = class("GameScene", function()
    return cc.Scene:createWithPhysics()  -- ✅ Create scene with physics enabled
end)

function GameScene:ctor()
    local physicsWorld = self:getPhysicsWorld()
    physicsWorld:setGravity(cc.p(0, -500))  -- ✅ Set gravity

    -- ✅ Enable debug drawing (optional, for testing)
    physicsWorld:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    -- ✅ Load game logic
    local game = GameController:create()
    self:addChild(game)
end

return GameScene
