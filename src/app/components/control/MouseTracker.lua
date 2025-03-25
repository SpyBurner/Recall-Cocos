local Component = require("app.core.Component")

local MouseTracker = class("MouseTracker", Component)

function MouseTracker:ctor(owner, moveToMouse)
    Component.ctor(self, owner)
    self.mouseX, self.mouseY = 0, 0
    self.moveToMouse = moveToMouse or false

    -- ✅ Mouse event listener
    local function onMouseMove(event)
        local screenPos = event:getLocation()  -- Screen-space coordinates
        print("🟡 [Screen Space] Event Location:", screenPos.x, screenPos.y)

        local worldPos = cc.p(self:convertToWorldSpace(screenPos.x, screenPos.y))
        print("🟢 [World Space] Converted World Position:", worldPos.x, worldPos.y)

        self.mouseX, self.mouseY = worldPos.x, worldPos.y
    end

    local listener = cc.EventListenerMouse:create()
    listener:registerScriptHandler(onMouseMove, cc.Handler.EVENT_MOUSE_MOVE)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, owner)
end

-- ✅ Convert screen space to world space
function MouseTracker:convertToWorldSpace(x, y)
    local director = cc.Director:getInstance()
    local camera = cc.Camera:getDefaultCamera()
    
    -- ✅ Step 1: Flip the Y-coordinate to match OpenGL space
    local winSize = director:getWinSize()
    local flippedY = winSize.height - y  -- 🔄 Flip Y-axis

    -- ✅ Step 2: Convert UI coordinates to OpenGL coordinates
    -- local glPos = director:convertToGL(cc.p(x, y))
    -- print("🔵 [Fixed OpenGL Space] Converted GL Position:", glPos.x, glPos.y)

    -- ✅ Step 3: Convert OpenGL coordinates to world space
    -- local worldPos = camera:convertToWorldSpace(cc.p(x, flippedY))
    local camPos = cc.p(camera:getPosition())

    local worldPos = cc.p(camPos.x + x - winSize.width/2, camPos.y + flippedY - winSize.width/2 + 120)

    return worldPos.x, worldPos.y
end

function MouseTracker:update(dt)
    if not self.isEnabled then return end

    if self.moveToMouse then
        self.owner:setPosition(self.mouseX, self.mouseY)
        -- print("🎯 [Object Moved] New Position:", self.mouseX, self.mouseY)
    end
end

function MouseTracker:getMousePosition()
    return cc.p(self.mouseX, self.mouseY)
end

return MouseTracker
