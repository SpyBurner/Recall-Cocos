local GameObject = require("GameObject")
local CollisionLayers = require("CollisionLayers")

local BoxObject = class("BoxObject", GameObject)

function BoxObject:ctor(size, position)
    GameObject.ctor(self)  -- Call parent constructor

    size = size or cc.size(50, 50)  -- Default size (50x50)
    position = position or cc.p(0, 0)  -- Default position

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
    self:setPosition(position)
end

return BoxObject
