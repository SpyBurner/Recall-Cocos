local GameObject = require("app.core.GameObject")
local CollisionLayers = require("app.core.CollisionLayers")

local DragonFire = class("DragonFire", GameObject)

function DragonFire:ctor(position, direction, speed, lifetime, spritePath)
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
    self:setPosition(position)

    local animations = {
        { name = "default", plist = "res/Sprites/Enemy/Dragon/bullet.plist", frameTime = 0.5, loop = true, nil }
    }

    self.animComponent = AnimationComponent:create(self, animations, 5)
    self:addComponent(self.animComponent)
    animComponent:play("default")  -- ✅ Play flying animation by default

    -- ✅ Create physics body
    local physicsBody = cc.PhysicsBody:createBox(self.sprite:getContentSize())
    physicsBody:setDynamic(false)  -- ✅ Enable physics
    physicsBody:setGravityEnable(false)  -- ✅ Ignore gravity
    physicsBody:setRotationEnable(false)  -- ✅ No rotation

    physicsBody:setVelocity(cc.p(self.direction.x * self.speed, self.direction.y * self.speed))  -- ✅ Move in direction

    -- ✅ Collision settings
    physicsBody:setCategoryBitmask(CollisionLayers.ENEMY)  -- ✅ Fireball belongs to PROJECTILE layer
    physicsBody:setCollisionBitmask(bit.bor(CollisionLayers.WALL))  -- ✅ Collides with walls & enemies
    physicsBody:setContactTestBitmask(bit.bor(CollisionLayers.WALL))  -- ✅ Detect collisions

    self:setPhysicsBody(physicsBody)

    -- ✅ Schedule self-destruction
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function DragonFire:update(dt)
    self.lifetime = self.lifetime - dt
    if self.lifetime <= 0 then
        self:destroy()
    end
end

function DragonFire:destroy()
    print("🔥 DragonFire expired!")
    self:runAction(cc.RemoveSelf:create())
end

return DragonFire
