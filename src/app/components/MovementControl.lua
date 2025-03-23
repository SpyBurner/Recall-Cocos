local Component = require("app.core.Component")
local Joystick = require("app.components.Joystick")

local MovementControl = class("MovementControl", Component)

function MovementControl:ctor(owner, speed, playerControlled)
    Component.ctor(self, owner)  -- ✅ Call base class constructor

    self.speed = speed or 200  -- ✅ Default speed
    self.direction = cc.p(0, 0)

    if playerControlled then
        self.joystick = self.owner.joystick
        print("Player controlled")
    else
        print("Not player controlled")
    end


    self.physicsBody = self.owner.physicsBody

end

function MovementControl:update(dt)
    if not self.isEnabled then return end  -- ✅ Fix variable name

    if self.joystick then
        -- print("Joystick is not nil")
        self.direction = self.joystick:getDirection()  -- ✅ Fix function name
    else
        -- print("Joystick is nil")
    end
    
    
    -- Remove all speed when change direction
    if (self.physicsBody:getVelocity().x * self.direction.x < 0) then
        self.physicsBody:setVelocity(cc.p(0, self.physicsBody:getVelocity().y))
    end

    -- Remove all speed when release button
    if (math.abs(self.direction.x) <= 0.1) then
        self.physicsBody:setVelocity(cc.p(0, self.physicsBody:getVelocity().y))
    end

    -- Apply force to the physics body
    self.physicsBody:applyForce(cc.p(self.direction.x * self.speed, 0))
    if self.physicsBody:getVelocity().x > self.speed then
        self.physicsBody:setVelocity(cc.p(self.speed, self.physicsBody:getVelocity().y))
    end
end

return MovementControl
