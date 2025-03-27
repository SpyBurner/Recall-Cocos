local GameObject = require("app.core.GameObject")
local AnimationComponent = require("app.components.AnimationComponent")
local DamageOnContact = require("app.components.stat.DamageOnContact")
local CallBackOnContact = require("app.components.stat.CallBackOnContact")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")
local CoreStat = require("app.components.stat.CoreStat")

local Event = require("app.core.Event")

local DragonFire = require("app.objects.Enemy.DragonFire")
local DragonAI = require("app.components.enemy.Dragon.DragonAI")

local Dragon = class("Dragon", GameObject)

function Dragon:ctor(scale, target)
    GameObject.ctor(self)

    self.scale = scale or 1  -- ✅ Default scale
    self:setLocalZOrder(5)

    self.target = target  -- ✅ Target to follow (e.g., player)

    local spriteSize = cc.p(130, 130)

    -- ✅ Create physics body (apply scale)
    local physicsBody = cc.PhysicsBody:createBox(cc.size(spriteSize.x * self.scale, spriteSize.y * self.scale))
    physicsBody:setDynamic(false)  -- ✅ Allow movement
    physicsBody:setGravityEnable(false)  -- ✅ Not affected by gravity
    physicsBody:setRotationEnable(false)  -- ✅ No rotation

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.ENEMY)  -- ✅ Dragon belongs to ENEMY layer
    physicsBody:setCollisionBitmask(CollisionLayers.WALL)  -- ✅ Can collide with walls
    physicsBody:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.PUSHABLE))  -- ✅ Detect collisions with player

    self:setPhysicsBody(physicsBody)

    self.isAttacking = false

    -- ✅ Animation setup
    local animations = {
        { name = "dragon_attack", plist = "res/Sprites/Enemy/Dragon/dragon_attack.plist", frameTime = 0.5, loop = false, 
            callback = function()
                -- print("Attack animation callback")
                self.isAttacking = true  -- ✅ Set attacking flag
            end },

        { name = "dragon_recover", plist = "res/Sprites/Enemy/Dragon/dragon_recover.plist", frameTime = 0.5, loop = false, 
            callback = function()
                -- print("Recover animation callback")
                self.isAttacking = false
            end},
        { name = "dragon_death", plist = "res/Sprites/Enemy/Dragon/dragon_death.plist", frameTime = 2, loop = false, callback = function()
            print("Dragon dies!")
            self:runAction(cc.RemoveSelf:create())
        end },
    }

    self.animComponent = AnimationComponent:create(self, animations, self.scale)
    self:addComponent(self.animComponent)
    self.animComponent:play("dragon_recover")  -- ✅ Play flying animation by default

    -- -- ✅ Damage on contact
    -- local damageOnContact = DamageOnContact:create(self, 2)  -- ✅ Add damage component
    -- self:addComponent(damageOnContact)

    self.coreStat = CoreStat:create(self, 100, 0)  -- ✅ Add core stat component
    self:addComponent(self.coreStat)

    self.coreStat.OnDeathEvent:AddListener(function()
        self.animComponent:play("dragon_death")  -- ✅ Play death animation
    end)

    self.OnAttack = Event:create()

    self.dragonAI = DragonAI:create(self, target)  -- ✅ Create AI component
    self:addComponent(self.dragonAI)

    -- Hard code cooldown
    self.cooldown = 0.08
    self.cooldownTimer = 0

    print("Dragon created!")
end


function Dragon:Attack()
    if self.cooldownTimer > 0 then
        -- print("❌ Attack on cooldown!")
        return  -- ✅ Ignore attack if within cooldown
    end

    -- print("Dragon attacks!")
    self.cooldownTimer = self.cooldown  -- ✅ Reset cooldown timer
    self.OnAttack:Invoke()
end

return Dragon