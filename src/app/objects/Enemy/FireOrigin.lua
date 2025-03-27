local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")
local DragonFire = require("app.objects.Enemy.DragonFire")  -- Ensure this is imported

local FireOrigin = class("FireOrigin", GameObject)

function FireOrigin:ctor()
    GameObject.ctor(self)
end

function FireOrigin:Trigger()
    -- print("🔥 Fire triggered at:", self:getPositionX(), self:getPositionY())

    -- ✅ Create a fireball with correct parameters
    local fireball = DragonFire:create(cc.p(-1, 0), 600, 2)  -- Position, direction, speed, lifetime

    fireball:setPosition(cc.p(self:getPosition()))  -- Set fireball position to FireOrigin position
    -- ✅ Add fireball to the scene instead of FireOrigin
    local parentScene = self:getParent()
    if parentScene then
        parentScene:addChild(fireball)
    else
        -- print("❌ FireOrigin has no parent!")
    end
end

return FireOrigin
