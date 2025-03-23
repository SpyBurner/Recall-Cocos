local Component = require("app.core.Component")
local CameraFollow = class("CameraFollow", Component)

function CameraFollow:ctor(owner, camera, deadzoneRadius, movespeed)
    Component.ctor(self, owner)  -- ✅ Initialize base component
    
    self.movespeed = movespeed or 1.2  -- ✅ Default movement speed

    self.deadzoneRadius = deadzoneRadius or 50  -- ✅ Default deadzone
end


function CameraFollow:update(dt)
    if not self.isEnabled then return end

    -- ✅ Get player position
    local playerPos = cc.p(self.owner:getPosition())

    -- ✅ Get camera position
    -- ✅ Assign default camera if none provided
    local camera = cc.Director:getInstance():getRunningScene():getDefaultCamera()

    -- print("Camera pos:", camera:getPosition())
    local cameraPos = cc.p(camera:getPosition())

    -- ✅ Calculate the distance between camera & player
    local dx = playerPos.x - cameraPos.x
    local dy = playerPos.y - cameraPos.y
    local distance = math.sqrt(dx * dx + dy * dy)

    -- ✅ Only move camera if player is outside the deadzone
    if distance > self.deadzoneRadius then
        local newX = cameraPos.x + dx * dt * self.movespeed
        local newY = cameraPos.y + dy * dt * self.movespeed

        camera:setPosition(newX, newY)
    end
end


return CameraFollow
