local GameObject = require("app.core.GameObject")
local Joystick = require("app.components.Joystick")
local MovementControl = require("app.components.MovementControl")
local JumpComponent = require("app.components.JumpComponent")
local CoreStat = require("app.components.stat.CoreStat")

local CollisionLayers = require("app.core.CollisionLayers")

local ControllableObject = class("ControllableObject", GameObject)

function ControllableObject:ctor(maxHP, iframe, width, height, scale, speed, jumpStrength, isPlayer, name)
    GameObject.ctor(self)  -- ✅ Call base constructor

    self.physicMaterial = cc.PhysicsMaterial(0, 0, 0)  -- ✅ Create a physic material

    self.maxHP = maxHP
    self.iframe = iframe  -- ✅ Default iframe duration

    self.width = width 
    self.height = height
    self.scale = scale

    self.width = self.width * self.scale
    self.height = self.height * self.scale

    self.name = name or "ControllableObject"  -- ✅ Default name

    self.physicsBody = cc.PhysicsBody:createBox(cc.size(self.width - 10, self.height - 5), self.physicMaterial)
    self.physicsBody:setDynamic(true)
    self.physicsBody:setRotationEnable(false)
    
    if isPlayer then
        self.physicsBody:setCategoryBitmask(CollisionLayers.PLAYER)
    else
        self.physicsBody:setCategoryBitmask(CollisionLayers.ENEMY)
    end

    self.physicsBody:setCollisionBitmask(
        CollisionLayers:collidesWith(  -- What the player PHYSICALLY collides with
            CollisionLayers.WALL,
            CollisionLayers.PUSHABLE
            -- CollisionLayers.SPIKE, 
            -- CollisionLayers.GATE
        )
    )

    local collisionMask = CollisionLayers:collidesWith(  -- What the player CAN COLLIDE with (triggers physics collision)
        CollisionLayers.WALL, 
        CollisionLayers.PUSHABLE, 
        CollisionLayers.SPIKE, 
        CollisionLayers.GATE
    )
    if isPlayer then
        collisionMask = CollisionLayers:collidesWith(collisionMask, CollisionLayers.ENEMY)
    else
        collisionMask = CollisionLayers:collidesWith(collisionMask, CollisionLayers.PLAYER)
    end

    self.physicsBody:setContactTestBitmask(collisionMask)  -- ✅ Set contact test bitmask

    self:setPhysicsBody(self.physicsBody)

    self.playerStat = CoreStat:create(self, self.maxHP, self.iframe)  -- ✅ Create a CoreStat component for the player
    self:addComponent(self.playerStat)

    if (isPlayer) then
        self.joystick = Joystick:create(self, cc.KeyCode.KEY_W, cc.KeyCode.KEY_S, cc.KeyCode.KEY_A, cc.KeyCode.KEY_D)
    else 
        self.joystick = Joystick:create(self)
    end
    self:addComponent(self.joystick)

    -- ✅ Attach movement component
    self.movementControl = MovementControl:create(self, speed, 100)
    self:addComponent(self.movementControl)

    -- ✅ Attach jump component
    self.jumpComponent = JumpComponent:create(self, jumpStrength)
    self:addComponent(self.jumpComponent)
    
    -- -- ✅ Create visual representation
    -- self.sprite = cc.LayerColor:create(cc.c4b(0, 255, 0, 255), 50, 50)
    -- self.sprite:setPosition(cc.p(-25, -25))
    -- self:addChild(self.sprite)
end

function ControllableObject:getName()
    return self.name
end

return ControllableObject
