local GameView = class("GameView", cc.load("mvc").ViewBase)

function GameView:onCreate()
    -- ✅ Add background (light gray)
    local bgColor = cc.LayerColor:create(cc.c4b(200, 200, 200, 255))
    self:addChild(bgColor)

    -- ✅ Add ground (red rectangle with physics)
    self.ground = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), display.width, 50)
    self.ground:setPosition(0, 50)

    local groundBody = cc.PhysicsBody:createBox(cc.size(display.width, 50))
    groundBody:setDynamic(false)  -- Static ground
    groundBody:setContactTestBitmask(1)  -- Enable collision detection
    self.ground:setPhysicsBody(groundBody)
    self:addChild(self.ground)

    -- ✅ Add UI label for controls
    local label = cc.Label:createWithSystemFont("Move: A/D or ← → | Jump: W or ↑", "Arial", 24)
    label:setPosition(display.cx, display.height - 50)
    self:addChild(label)
end

return GameView
