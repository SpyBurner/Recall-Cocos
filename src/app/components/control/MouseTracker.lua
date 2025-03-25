local Component = require("app.core.Component")  -- Import the base Component class

local MouseTracker = class("MouseTracker", Component)

function MouseTracker:ctor(owner, moveToMouse)
    Component.ctor(self, owner)  -- Call parent constructor
    self.mouseX, self.mouseY = 0, 0  -- Store mouse position
    self.moveToMouse = moveToMouse or false  -- Flag to move the object to the mouse position

end

function MouseTracker:update(dt)
    if not self.isEnabled then return end

    -- Get the mouse position in OpenGL coordinates
    local mousePos = cc.Director:getInstance():getOpenGLView():getMousePosition()
    self.mouseX, self.mouseY = mousePos.x, mousePos.y

    if (self.moveToMouse) then
        -- Move the owner object to the mouse position
        local ownerPos = self.owner:getPosition()
        local targetPos = cc.p(self.mouseX, self.mouseY)
        self.owner:setPosition(newPos)
    end
end

function MouseTracker:getMousePosition()
    return cc.p(self.mouseX, self.mouseY)
end

return MouseTracker
