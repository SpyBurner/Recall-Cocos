local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")
local DamageOnFall = require("app.components.stat.DamageOnFall")

local BoxObject = class("BoxObject", GameObject)

function BoxObject:ctor(size, density, restitution, friction, spritePath)
    GameObject.ctor(self)  -- Call parent constructor

    size = size or cc.size(50, 50)  -- Default size (50x50)
    density = density or 1  -- Default density
    restitution = restitution or 0  -- Default bounciness (0 = no bounce)
    friction = friction or 0.5  -- Default friction

    size = cc.size(size.width - 5, size.height)  -- Ensure size is a cc.size object

    -- ✅ Create physics material
    local material = cc.PhysicsMaterial(density, restitution, friction)

    -- ✅ Create physics body with material
    local physicsBody = cc.PhysicsBody:createBox(size, material)
    physicsBody:setDynamic(true)  -- Allows movement by physics
    physicsBody:setRotationEnable(false)  -- Disable rotation
    -- ✅ Set fixed collision layers
    physicsBody:setCategoryBitmask(CollisionLayers.PUSHABLE)  -- Box belongs to PUSHABLE layer
    physicsBody:setCollisionBitmask(
        CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.WALL, CollisionLayers.PUSHABLE)
    )  -- Box reacts to collisions with these layers
    physicsBody:setContactTestBitmask(
        CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.WALL)
    )  -- Box collides with Player, Enemy, and Wall

    self:setPhysicsBody(physicsBody)

    -- ✅ Load sprite if provided
    if spritePath then
        local sprite = cc.Sprite:create(spritePath)
        if sprite then
            -- ✅ Get texture and disable smoothing
            local texture = sprite:getTexture()
            texture:setAliasTexParameters()  -- 🔥 Fixes blurriness by using nearest-neighbor filtering

            -- ✅ Scale sprite to match physics body size
            local spriteSize = sprite:getContentSize()
            sprite:setScale(size.width / spriteSize.width, size.height / spriteSize.height)

            -- ✅ Center sprite on the box
            self:addChild(sprite)
        else
            print("❌ Failed to load sprite: " .. spritePath)
        end
    end

    local damageOnFall = DamageOnFall:create(self, 500, 10)  -- Create DamageOnFall component
    self:addComponent(damageOnFall)

end

return BoxObject
