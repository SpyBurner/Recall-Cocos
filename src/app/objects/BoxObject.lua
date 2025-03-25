local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local BoxObject = class("BoxObject", GameObject)

function BoxObject:ctor(size, density, restitution, friction, spritePath)
    GameObject.ctor(self)  -- Call parent constructor

    size = size or cc.size(50, 50)  -- Default size (50x50)
    density = density or 1  -- Default density
    restitution = restitution or 0  -- Default bounciness (0 = no bounce)
    friction = friction or 0.5  -- Default friction

    -- ✅ Create physics material
    local material = cc.PhysicsMaterial(density, restitution, friction)

    -- ✅ Create physics body with material
    local physicsBody = cc.PhysicsBody:createBox(size, material)
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

    -- ✅ Load sprite if provided
    if spritePath then
        local sprite = cc.Sprite:create(spritePath)
        if sprite then
            -- ✅ Scale sprite to match physics body size
            local spriteSize = sprite:getContentSize()
            sprite:setScale(size.width / spriteSize.width, size.height / spriteSize.height)

            -- ✅ Center sprite on the box
            self:addChild(sprite)
        else
            print("❌ Failed to load sprite: " .. spritePath)
        end
    end
end

return BoxObject
