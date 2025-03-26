local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local FireOrigin = class("FireOrigin", GameObject)

function FireOrigin:ctor()
    GameObject.ctor(self)
end

function FireOrigin:Trigger()
    print("Fire triggered")
    local dragonFire = DragonFire:create(cc.p(-1, 0), 100, 5)  -- ✅ Create fireball

    local position = cc.p(self:getPosition())
    dragonFire:setPosition(position)
    self:addChild(dragonFire)  -- ✅ Add fireball to the scene
end

return FireOrigin
