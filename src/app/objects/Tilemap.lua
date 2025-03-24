local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local Tilemap = class("Tilemap", GameObject)

function Tilemap:ctor(mapFile, scale)
    GameObject.ctor(self)  -- ✅ Call parent constructor

    -- ✅ Load Tilemap from TMX file
    self.tilemap = cc.TMXTiledMap:create(mapFile)
    if not self.tilemap then
        error("Failed to load tilemap: " .. mapFile)
    end


    self.scale = scale or 1

    self.tilemap:setScale(self.scale)

    self:addChild(self.tilemap)

    -- ✅ Set map properties
    self.tileSize = self.tilemap:getTileSize()
    -- self.tileSize = cc.size(self.tileSize.width * self.scale, self.tileSize.height * self.scale)
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
            print("Checking tile at " .. x .. ", " .. y)
            local tile = collisionLayer:getTileAt(cc.p(x, y))
            if tile then
                -- ✅ Create a physics body for solid tiles
                local body = cc.PhysicsBody:createBox(self.tileSize)
                body:setDynamic(false)
    
                body:setCategoryBitmask(CollisionLayers.WALL)
            
                body:setCollisionBitmask(
                    CollisionLayers:collidesWith(  -- What the wall collides with
                        CollisionLayers.PLAYER, 
                        CollisionLayers.ENEMY, 
                        CollisionLayers.PROJECTILE,
                        CollisionLayers.E_PROJECTILE
                    )
                )
                
                body:setCollisionBitmask(
                    CollisionLayers:collidesWith(CollisionLayers.PLAYER) -- ✅ Make sure player can "hit" the ground
                )

                tile:setPhysicsBody(body)
            end
        end
    end
end

return Tilemap
