local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")
local DamageOnContact = require("app.components.stat.DamageOnContact")
local BaseObject = require("app.objects.BaseObject")


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
    -- local size_grow = 0.1

    self.tileSize = self.tilemap:getTileSize()
    -- self.tileSize = cc.size(self.tileSize.width + size_grow, self.tileSize.height + size_grow)
    self.mapSize = self.tilemap:getMapSize()

    -- ✅ Add physics collision layers (if applicable)
    self:setupCollisionLayer("Collisions")

    --! HARD CODE DAMAGE
    self:setupDamageLayer("Damage", 1) 
end

function Tilemap:setupCollisionLayer(layerName)
    print("Creating collision layer")
    local collisionLayer = self.tilemap:getLayer(layerName)
    if not collisionLayer then return end  -- ✅ Skip if no collision layer

    local mapWidth = self.mapSize.width
    local mapHeight = self.mapSize.height
    local tileSize = self.tileSize

    tileSize = cc.size(tileSize.width * self.scale, tileSize.height * self.scale)

    local visited = {}  -- ✅ Track visited tiles

    local function isTileSolid(x, y)
        if x < 0 or x >= mapWidth or y < 0 or y >= mapHeight then
            return false
        end
        return collisionLayer:getTileAt(cc.p(x, y)) ~= nil
    end
    
    local function floodFill(x, y)
        if visited[x .. "," .. y] then return nil end  -- ✅ Already processed
        if not isTileSolid(x, y) then return nil end  -- ✅ Not a solid tile
    
        -- ✅ Start flood fill at (x, y)
        local minX, minY = x, y
        local maxX, maxY = x, y
    
        -- ✅ Expand horizontally
        while maxX + 1 < mapWidth and isTileSolid(maxX + 1, y) do
            maxX = maxX + 1
        end
    
        -- ✅ Expand vertically while ensuring horizontal width is consistent
        local tempMaxY = y
        local validRow = true
        while tempMaxY + 1 < mapHeight and validRow do
            for i = minX, maxX do
                if not isTileSolid(i, tempMaxY + 1) then
                    validRow = false
                    break
                end
            end
            if validRow then
                tempMaxY = tempMaxY + 1
            end
        end
        maxY = tempMaxY
    
        -- ✅ Mark all tiles in this block as visited
        for i = minX, maxX do
            for j = minY, maxY do
                visited[i .. "," .. j] = true
            end
        end
    
        -- ✅ Compute collider size and center position
        local colliderWidth = (maxX - minX + 1) * tileSize.width
        local colliderHeight = (maxY - minY + 1) * tileSize.height
    
        -- ✅ Flip Y-coordinate for correct positioning
        local centerX = minX * tileSize.width + colliderWidth / 2
        local centerY = (mapHeight - maxY - 1) * tileSize.height + colliderHeight / 2  -- ✅ FIXED
    
        return colliderWidth, colliderHeight, centerX, centerY
    end

    -- ✅ Process all tiles
    for x = 0, mapWidth - 1 do
        for y = 0, mapHeight - 1 do
            local width, height, cx, cy = floodFill(x, y)
            if width and height then
                -- ✅ Create a single large physics body
                local body = cc.PhysicsBody:createBox(cc.size(width, height))
                body:setDynamic(false)  -- ✅ Static solid tiles
                body:setCategoryBitmask(CollisionLayers.WALL)
                body:setCollisionBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.ENEMY, CollisionLayers.PROJECTILE))
                body:setContactTestBitmask(0)

                local node = cc.Node:create()
                node:setPosition(cx, cy)  -- ✅ Centered position with fixed Y
                node:setPhysicsBody(body)
                self:addChild(node)
            end
        end
    end
end

function Tilemap:setupDamageLayer(layerName, damage)
    print("Creating damage layer")
    local damageLayer = self.tilemap:getLayer(layerName)
    if not damageLayer then 
        print("❌ No damage layer found")
        return 
    end  -- ✅ Exit if no damage layer

    local mapWidth = self.mapSize.width
    local mapHeight = self.mapSize.height
    local tileSize = self.tileSize
    tileSize = cc.size(tileSize.width * self.scale, tileSize.height * self.scale)

    for x = 0, mapWidth - 1 do
        for y = 0, mapHeight - 1 do
            local tile = damageLayer:getTileAt(cc.p(x, y))
            if tile then
                -- ✅ Create a physics body for the damage tile
                local body = cc.PhysicsBody:createBox(tileSize)
                body:setDynamic(false)  -- ✅ Static body (doesn't move)
                body:setCategoryBitmask(CollisionLayers.SPIKE)  
                body:setCollisionBitmask(0)  -- ❌ No physical collision (pass-through)
                body:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.ENEMY))                  

                local node = BaseObject:create()

                -- ✅ Flip Y-coordinate for correct positioning
                local flippedY = (mapHeight - y - 1) * tileSize.height

                node:setPosition((x + 0.5) * tileSize.width, flippedY + (0.5 * tileSize.height))  -- ✅ Centered position
                node:setPhysicsBody(body)

                -- ✅ Add DamageOnContact component
                local damageComponent = DamageOnContact:create(node, damage)
                if damageComponent then
                    node:addComponent(damageComponent)
                else
                    print("❌ Failed to create DamageOnContact at:", x, y)
                end

                -- node:setTag(1)  -- ✅ Mark as a damage tile


                self:addChild(node)  -- ✅ Add to the tilemap node
            end
        end
    end
end





return Tilemap
