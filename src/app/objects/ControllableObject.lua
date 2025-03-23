local GameObject = require("app.core.GameObject")
local Joystick = require("app.components.Joystick")
local MovementControl = require("app.components.MovementControl")
local JumpControl = require("app.components.JumpControl")

local CollisionLayers = require("app.core.CollisionLayers")

local ControllableObject = class("ControllableObject", GameObject)

function ControllableObject:ctor(speed, jumpStrength, isPlayer)
    GameObject.ctor(self)  -- ✅ Call base constructor

    self.physicMaterial = cc.PhysicsMaterial(0, 0, 0)  -- ✅ Create a physic material

    self.physicsBody = cc.PhysicsBody:createBox(cc.size(50, 50), self.physicMaterial)
    self.physicsBody:setDynamic(true)
    self.physicsBody:setRotationEnable(false)
    

    self.physicsBody:setCategoryBitmask(CollisionLayers.PLAYER)

    self.physicsBody:setCollisionBitmask(
        CollisionLayers:collidesWith(  -- What the player PHYSICALLY collides with
            CollisionLayers.WALL, 
            CollisionLayers.SPIKE, 
            CollisionLayers.GATE
        )
    )

    self.physicsBody:setContactTestBitmask(
        CollisionLayers:collidesWith(  -- What the player CAN DETECT (triggers collision callbacks)
            CollisionLayers.ENEMY, 
            CollisionLayers.PROJECTILE, 
            CollisionLayers.E_PROJECTILE, 
            CollisionLayers.POWERUP
        )
    )

    self:setPhysicsBody(self.physicsBody)

    if (isPlayer) then
        self.joystick = Joystick:create(self, cc.KeyCode.KEY_W, cc.KeyCode.KEY_S, cc.KeyCode.KEY_A, cc.KeyCode.KEY_D)
        self:addComponent(self.joystick)
    end

    -- ✅ Attach movement component
    self.movementControl = MovementControl:create(self, speed, isPlayer)
    self:addComponent(self.movementControl)

    -- ✅ Attach jump component
    self.jumpControl = JumpControl:create(self, jumpStrength)
    self:addComponent(self.jumpControl)

    -- ✅ Create visual representation
    self.sprite = cc.LayerColor:create(cc.c4b(0, 255, 0, 255), 50, 50)
    self.sprite:setPosition(cc.p(-25, -25))
    self:addChild(self.sprite)
end

return ControllableObject
