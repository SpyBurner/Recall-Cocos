local GameView = class("GameView", cc.load("mvc").ViewBase)

function GameView:onCreate()
    -- ✅ Add background (light gray)
    local bgColor = cc.LayerColor:create(cc.c4b(200, 200, 200, 255))
    self:addChild(bgColor)

    -- ✅ Add UI label for controls
    local label = cc.Label:createWithSystemFont("Move: A/D or ← → | Jump: W or ↑", "Arial", 24)
    label:setPosition(display.cx, display.height - 50)
    self:addChild(label)
end

return GameView
