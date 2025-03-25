local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local BoxObject = class("BoxObject", GameObject)

function BoxObject:ctor(size)
    GameObject.ctor(self)  -- Call parent constructor

    size = size or cc.size(50, 50)  -- Default size (50x50)

    -- ✅ Create physics body
    local physicsBody = cc.PhysicsBody:createBox(size)
    physicsBody:setDynamic(true)  -- Allows movement by physics

    -- ✅ Set fixed collision layers
    physicsBody:setCategoryBitmask(CollisionLayers.PUSHABLE)  -- Box belongs to PUSHABLE layer
    physicsBody:setContactTestBitmask(
        bit.bor(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.WALL)
    )  -- Box collides with Player, Enemy, and Wall
    physicsBody:setCollisionBitmask(
        bit.bor(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.WALL)
    )  -- Box reacts to collisions with these layers

    self:setPhysicsBody(physicsBody)
end

return BoxObject
