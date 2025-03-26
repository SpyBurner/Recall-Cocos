local GameObject = require("app.core.GameObject")
local CallBackOnContact = require("app.components.stat.CallBackOnContact")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

local Coin = class("Coin", GameObject)

function Coin:ctor(spritePath, scale, value)
    GameObject.ctor(self)

    self.scale = scale or 5  -- ✅ Default scale
    self.value = value or 1  -- ✅ Default coin value

    -- ✅ Load sprite
    print("🪙 Coin: Loading sprite from " .. spritePath)
    self.sprite = cc.Sprite:create(spritePath)
    if self.sprite then
        self.sprite:setScale(self.scale)  -- ✅ Set scale
        self:addChild(self.sprite)

        local texture = self.sprite:getTexture()
        texture:setAliasTexParameters()
    else
        print("❌ Failed to load coin sprite!")
    end

    -- ✅ Create physics body (apply scale)
    local spriteSize = self.sprite:getContentSize()
    local physicsBody = cc.PhysicsBody:createBox(cc.size(spriteSize.width * self.scale, spriteSize.height * self.scale))
    physicsBody:setDynamic(false)  -- ✅ Allow movement
    physicsBody:setGravityEnable(false)  -- ✅ Let it be affected by gravity
    physicsBody:setRotationEnable(false)  -- ✅ Disable rotation

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.POWERUP)  -- ✅ Coin belongs to POWERUP layer
    physicsBody:setCollisionBitmask(0)  -- ✅ Can collide with walls but still remains a POWERUP
    physicsBody:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER))  -- ✅ Detect collisions with player

    self:setPhysicsBody(physicsBody)

    -- ✅ Attach contact logic
    local function onPickup(other)
        local coreStat = other:getComponent("CoreStat")
        if coreStat then
            coreStat:AddCoins(self.value)  -- ✅ Add coin value to player's coins
            print("🪙 Coin: Player collected " .. self.value .. " coin(s)!")
            self:removeFromParent(true)  -- ✅ Destroy coin after pickup
        else
            print("❌ No CoreStat found on player!")
        end
    end

    -- ✅ Add CallBackOnContact component (only reacts to player)
    local contactComponent = CallBackOnContact:create(self, onPickup, nil, true)
    self:addComponent(contactComponent)
end

return Coin