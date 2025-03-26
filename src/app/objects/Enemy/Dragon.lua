local GameObject = require("app.core.GameObject")
local AnimationComponent = require("app.components.AnimationComponent")
local DamageOnContact = require("app.components.stat.DamageOnContact")
local CallBackOnContact = require("app.components.stat.CallBackOnContact")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

local DragonFire = require("app.objects.Enemy.DragonFire")

local Dragon = class("Dragon", GameObject)

function Dragon:ctor(spritePath, scale, target)
    GameObject.ctor(self)

    self.scale = scale or 5  -- ✅ Default scale
    self.setLocalZOrder(5)

    -- ✅ Create physics body (apply scale)
    local physicsBody = cc.PhysicsBody:createBox(cc.size(spriteSize.width * self.scale, spriteSize.height * self.scale))
    physicsBody:setDynamic(true)  -- ✅ Allow movement
    physicsBody:setGravityEnable(false)  -- ✅ Not affected by gravity

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.ENEMY)  -- ✅ Dragon belongs to ENEMY layer
    physicsBody:setCollisionBitmask(CollisionLayers.WALL)  -- ✅ Can collide with walls
    physicsBody:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER))  -- ✅ Detect collisions with player

    self:setPhysicsBody(physicsBody)

    self.isAttacking = false

    -- ✅ Animation setup
    local animations = {
        { name = "dragon_attack", plist = "res/Sprites/Enemy/Dragon/dragon_attack.plist", frameTime = 0.5, loop = false, 
            callback = function()
                self.isAttacking = true  -- ✅ Set attacking flag
            end },

        { name = "dragon_recover", plist = "res/Sprites/Enemy/Dragon/dragon_recover.plist", frameTime = 0.5, loop = false, callback = function)()
            self.isAttacking = false
        end},
        { name = "dragon_death", plist = "res/Sprites/Enemy/Dragon/dragon_death.plist", frameTime = 2, loop = false, callback = function()
            print("Dragon dies!")
            self:runAction(cc.RemoveSelf:create())
        end },
    }

    self.animComponent = AnimationComponent:create(self, animations, 5)
    self:addComponent(self.animComponent)
    animComponent:play("dragon_recover")  -- ✅ Play flying animation by default

    -- ✅ Damage on contact
    local damageOnContact = DamageOnContact:create(self, 2)  -- ✅ Add damage component
    self:addComponent(damageOnContact)

    self.coreStat = CoreStat:create(self, 100, 0)  -- ✅ Add core stat component
    self:addComponent(self.coreStat)

    self.coreStat.OnDeathEvent:subscribe(function()
        animComponent:play("dragon_death")  -- ✅ Play death animation
    end)
end

function Dragon:update(dt)
    if (self.coreStat.isDead) then
        return  -- ✅ Ignore update if dead
    end

    local targetPos = cc.p(target:getPosition())
    local selfPos = cc.p(self:getPosition())

    local distance = cc.pGetDistance(selfPos, targetPos)

    if distance < 700 and not self.isAttacking then
        self.animComponent:play("dragon_attack")  -- ✅ Play attack animation if within range
    end

    if distance >= 700
        self.animComponent:play("dragon_recover")  
    end

    while self.isAttacking then
        self::Attack()  -- ✅ Call attack function while attacking
    end
end

-- Hard code cooldown
local cooldown = 0.3
local lastAttackTime = 0

function Dragon:Attack()
    if os.time() - lastAttackTime < cooldown then
        return  -- ✅ Ignore attack if within cooldown
    end

    lastAttackTime = os.time()  -- ✅ Update last attack time

    local dragonFire = DragonFire:create("res/Sprites/Enemy/Dragon/dragon_fire.plist", 5, self)  -- ✅ Create fireball
end

return Dragon