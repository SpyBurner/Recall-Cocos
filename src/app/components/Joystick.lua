local Component = require("app.core.Component")
local Input = require("app.core.Input")

local Joystick = class("Joystick", Component)

function Joystick:ctor(owner, keyUp, keyDown, keyLeft, keyRight)
    Component.ctor(self, owner)  -- ✅ Call base class constructor

    self.direction = cc.p(0, 0)

    self.keyUp = keyUp
    self.keyDown = keyDown
    self.keyLeft = keyLeft
    self.keyRight = keyRight

    self.playerControlled = (keyUp ~= nil and keyDown ~= nil and keyLeft ~= nil and keyRight ~= nil)

    -- ✅ Run input initialization on the owner (which is a Node)
    if owner and owner.runAction then
        owner:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                local scene = cc.Director:getInstance():getRunningScene()
                if scene then
                    Input.init(scene)
                end
            end)
        ))
    else
        print("❌ Joystick Error: Owner does not support runAction()")
    end

    self.stat = owner:getComponent("CoreStat")

    self.stat.OnDeathEvent:AddListener(function()
        self.isEnabled = false
        self.direction.x = 0
        self.direction.y = 0
    end)
end

function Joystick:setDirection(x, y)
    if x and y then
        self.direction.x = x
        self.direction.y = y
    else
        error("❌ Joystick Error: Invalid direction values")
    end
end

function Joystick:getDirection()
    return self.direction
end

function Joystick:update(dt)
    -- print("Joystick update")
    if not self.isEnabled then return end 

    if not self.playerControlled then return end  -- Only update if player-controlled

    if Input.isKeyPressed(self.keyUp) then
        self.direction.y = 1
    elseif Input.isKeyPressed(self.keyDown) then
        self.direction.y = -1
    else
        self.direction.y = 0
    end

    if Input.isKeyPressed(self.keyLeft) then
        self.direction.x = -1
    elseif Input.isKeyPressed(self.keyRight) then
        self.direction.x = 1
    else
        self.direction.x = 0
    end
end

return Joystick
