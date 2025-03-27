local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local AnimationComponent = require("app.components.AnimationComponent")
local DamageOnContact = require("app.components.stat.DamageOnContact")

local CallBackOnContact = require("app.components.stat.CallBackOnContact")

local DragonFire = class("DragonFire", GameObject)

function DragonFire:ctor(direction, speed, lifetime)
    GameObject.ctor(self)

    self.speed = speed or 500  -- ✅ Default speed
    self.lifetime = lifetime or 3  -- ✅ Default lifetime (seconds)
    self.direction = direction or cc.p(1, 0)  -- ✅ Default direction (right)

    -- ✅ Normalize direction to ensure correct speed scaling
    local length = math.sqrt(self.direction.x * self.direction.x + self.direction.y * self.direction.y)
    if length > 0 then
        self.direction.x = self.direction.x / length
        self.direction.y = self.direction.y / length
    end

    -- ✅ Set position
    -- self:setPosition(position)

    local animations = {
        { name = "bullet", plist = "res/Sprites/Enemy/Dragon/bullet.plist", frameTime = 0.1, loop = true, nil }
    }

    self.animComponent = AnimationComponent:create(self, animations, 5)
    self:addComponent(self.animComponent)
    self.animComponent:play("bullet")  -- ✅ Play flying animation by default

    -- ✅ Create physics body

    local spriteSize = cc.size(16 * 5, 8 * 5)  -- ✅ Adjust size as needed

    local physicsBody = cc.PhysicsBody:createBox(spriteSize)  -- ✅ Adjust size as needed
    physicsBody:setDynamic(false)  -- ✅ Enable physics
    physicsBody:setGravityEnable(false)  -- ✅ Ignore gravity
    physicsBody:setRotationEnable(false)  -- ✅ No rotation

    physicsBody:setVelocity(cc.p(self.direction.x * self.speed, self.direction.y * self.speed))  -- ✅ Move in direction

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.ENEMY)  -- ✅ Fireball belongs to PROJECTILE layer
    physicsBody:setCollisionBitmask(0)
    physicsBody:setContactTestBitmask(CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.PUSHABLE))  -- ✅ Detect collisions
    
    self:setPhysicsBody(physicsBody)

    local contactComponent = CallBackOnContact:create(self, function(other)
        local mask = other:getPhysicsBody():getCategoryBitmask()

        print("🔥 DragonFire contact with:", other.__cname, "Mask:", mask)

        if bit.band(mask, CollisionLayers.PLAYER) ~= 0 or bit.band(mask, CollisionLayers.PUSHABLE) ~= 0 then
            -- ✅ Apply damage to player or pushable object
            local target = other:getComponent("CoreStat")
            if target then
                print("🔥 DragonFire hit target!")
                target:TakeDamage(1)  -- ✅ Example damage value
            else
                print("❌ Target has no CoreStat component!")
            end

            -- ✅ Destroy fireball on contact
            self:destroy()
        end
    end, nil, false, CollisionLayers:collidesWith(CollisionLayers.PLAYER, CollisionLayers.PUSHABLE))

    self:addComponent(contactComponent)

    -- ✅ Schedule self-destruction
    -- self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function DragonFire:update(dt)
    GameObject.update(self, dt)  -- Call parent update
    self.lifetime = self.lifetime - dt
    if self.lifetime <= 0 then
        self:destroy()
    end
end

function DragonFire:destroy()
    -- print("🔥 DragonFire expired!")
    self:runAction(cc.RemoveSelf:create())
end

return DragonFire
