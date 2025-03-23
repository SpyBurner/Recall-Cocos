local GameObject = require("app.core.GameObject")
local Ground = class("Ground", GameObject)
local CollisionLayers = require("app.core.CollisionLayers")

function Ground:ctor(width, height)
    self.body = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), width, height)  -- Red ground
    self.body:setPosition(cc.p(-width/2, -height/2))
    self:addChild(self.body)

    -- ✅ Add physics body
    local physicsBody = cc.PhysicsBody:createBox(cc.size(width, height))
    physicsBody:setDynamic(false)
    
    physicsBody:setCategoryBitmask(CollisionLayers.WALL)

    physicsBody:setCollisionBitmask(
        CollisionLayers:collidesWith(  -- What the wall collides with
            CollisionLayers.PLAYER, 
            CollisionLayers.ENEMY, 
            CollisionLayers.PROJECTILE,
            CollisionLayers.E_PROJECTILE
        )
    )
    
    physicsBody:setContactTestBitmask(  -- ✅ Raycast uses this!
        CollisionLayers:collidesWith(  
            CollisionLayers.PLAYER  -- ✅ Allow player raycast detection
        )
    )
    

    -- physicsBody:setGroup(CollisionLayers.WALL)

    self:setPhysicsBody(physicsBody)
end

return Ground
