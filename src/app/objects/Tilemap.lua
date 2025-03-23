local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local Tilemap = class("Tilemap", GameObject)

function Tilemap:ctor(mapFile)
    GameObject.ctor(self)  -- ✅ Call parent constructor

    -- ✅ Load Tilemap from TMX file
    self.tilemap = cc.TMXTiledMap:create(mapFile)
    if not self.tilemap then
        error("Failed to load tilemap: " .. mapFile)
    end

    self:addChild(self.tilemap)

    -- ✅ Set map properties
    self.tileSize = self.tilemap:getTileSize()
    self.mapSize = self.tilemap:getMapSize()

    -- ✅ Add physics collision layers (if applicable)
    self:setupCollisionLayer("Collisions") -- Change layer name as needed
end

function Tilemap:setupCollisionLayer(layerName)
    local collisionLayer = self.tilemap:getLayer(layerName)
    if not collisionLayer then return end  -- ✅ Skip if no collision layer

    local mapWidth = self.mapSize.width
    local mapHeight = self.mapSize.height

    for x = 0, mapWidth - 1 do
        for y = 0, mapHeight - 1 do
            local tile = collisionLayer:getTileAt(cc.p(x, y))
            if tile then
                -- ✅ Create a physics body for solid tiles
                local body = cc.PhysicsBody:createBox(self.tileSize)
                body:setDynamic(false)  -- ✅ Static tiles

                -- ✅ Set up collision layers
                body:setCategoryBitmask(CollisionLayers.WALL)
                body:setCollisionBitmask(
                    CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.PROJECTILE)
                )
                body:setContactTestBitmask(0)  -- Walls don’t trigger callbacks

                tile:setPhysicsBody(body)
            end
        end
    end
end

return Tilemap
