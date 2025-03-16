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
    physicsBody:setContactTestBitmask(CollisionLayers.PLAYER)
    physicsBody:setCollisionBitmask(CollisionLayers.PLAYER)

    -- physicsBody:setGroup(CollisionLayers.WALL)

    self:setPhysicsBody(physicsBody)
end

return Ground
