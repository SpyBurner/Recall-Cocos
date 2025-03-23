local Component = require("app.core.Component")
local CameraFollow = class("CameraFollow", Component)

function CameraFollow:ctor(owner, camera, deadzoneRadius)
    Component.ctor(self, owner)  -- ✅ Initialize base component
    

    self.deadzoneRadius = deadzoneRadius or 50  -- ✅ Default deadzone
end


function CameraFollow:update(dt)
    if not self.isEnabled or not camera then return end  -- ✅ Ensure camera is valid

    -- ✅ Get player position
    local playerPos = self.owner:getPosition()

    -- ✅ Get camera position
    -- ✅ Assign default camera if none provided
    local camera = cc.Director:getInstance():getRunningScene():getDefaultCamera()

    print("Camera pos:", camera:getPosition())
    local cameraPos = camera:getPosition()

    -- ✅ Calculate the distance between camera & player
    local dx = playerPos.x - cameraPos.x
    local dy = playerPos.y - cameraPos.y
    local distance = math.sqrt(dx * dx + dy * dy)

    -- ✅ Only move camera if player is outside the deadzone
    if distance > self.deadzoneRadius then
        local moveSpeed = 5  -- ✅ Adjust movement speed to smooth follow
        local newX = cameraPos.x + dx * dt * moveSpeed
        local newY = cameraPos.y + dy * dt * moveSpeed

        camera:setPosition(newX, newY)
    end
end


return CameraFollow
