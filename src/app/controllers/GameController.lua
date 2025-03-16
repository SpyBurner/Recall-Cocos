local Input = require("app.core.Input")
local Player = require("app.objects.Player")

local GameController = class("GameController", cc.Node)

function GameController:ctor()
    self.player = Player:create()
    self.player:setPosition(display.cx, 150)
    self:addChild(self.player)

    -- ✅ Delay Input initialization until scene is ready
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1),  -- Small delay ensures scene is loaded
        cc.CallFunc:create(function()
            local scene = cc.Director:getInstance():getRunningScene()
            if scene then
                Input.init(scene)  -- ✅ Now we pass a valid scene
            else
                print("❌ Error: Scene is still nil!")
            end
        end)
    ))

    -- ✅ Enable update loop
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

-- ✅ Update loop (called every frame)
function GameController:update(dt)
    if Input.isKeyPressed(cc.KeyCode.KEY_A) or Input.isKeyPressed(cc.KeyCode.KEY_LEFT_ARROW) then
        self.player:moveLeft()
    elseif Input.isKeyPressed(cc.KeyCode.KEY_D) or Input.isKeyPressed(cc.KeyCode.KEY_RIGHT_ARROW) then
        self.player:moveRight()
    end

    if Input.isKeyPressed(cc.KeyCode.KEY_W) or Input.isKeyPressed(cc.KeyCode.KEY_UP_ARROW) then
        self.player:jump()
    end
end

local function onContactBegin(contact)
    local a = contact:getShapeA():getBody():getNode()
    local b = contact:getShapeB():getBody():getNode()

    -- ✅ Check if player touches the ground
    if a == self.player or b == self.player then
        self.player:land()  -- ✅ Tell player that it has landed
    end
    return true
end


return GameController
