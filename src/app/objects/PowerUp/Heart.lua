local GameObject = require("app.core.GameObject")
local CallBackOnContact = require("app.components.stat.CallBackOnContact")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

local Heart = class("Heart", GameObject)

function Heart:ctor(spritePath, scale)
    GameObject.ctor(self)

    self.scale = scale or 5  -- ✅ Default scale

    -- ✅ Load sprite
    print("❤️ Heart: Loading sprite from " .. spritePath)
    self.sprite = cc.Sprite:create(spritePath)
    if self.sprite then
        self.sprite:setScale(self.scale)  -- ✅ Set scale
        self:addChild(self.sprite)

        local texture = self.sprite:getTexture()
        texture:setAliasTexParameters()
    else
        print("❌ Failed to load heart sprite!")
    end

    -- ✅ Create physics body (apply scale)
    local spriteSize = self.sprite:getContentSize()
    local physicsBody = cc.PhysicsBody:createBox(cc.size(spriteSize.width * self.scale, spriteSize.height * self.scale))
    physicsBody:setDynamic(true)  -- ✅ Allow movement
    physicsBody:setGravityEnable(true)  -- ✅ Let it be affected by gravity

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.POWERUP)  -- ✅ Heart belongs to POWERUP layer
    physicsBody:setCollisionBitmask(CollisionLayers.WALL)  -- ✅ Can collide with walls but still remains a POWERUP
    physicsBody:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER))  -- ✅ Detect collisions with player

    self:setPhysicsBody(physicsBody)

    -- ✅ Attach contact logic
    local function onPickup(other)
        local coreStat = other:getComponent("CoreStat")
        if coreStat then
            coreStat:Heal(1)  -- ✅ Heal the player by 1 HP
            print("❤️ Heart: Player healed!")
            -- self:removeFromParent(true)  -- ✅ Destroy heart after pickup
        else
            print("❌ No CoreStat found on player!")
        end
    end

    -- ✅ Add CallBackOnContact component (only reacts to player)
    local contactComponent = CallBackOnContact:create(self, onPickup, nil, true)
    self:addComponent(contactComponent)
end

return Heart
