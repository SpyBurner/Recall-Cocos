local PlayerController = class("PlayerController")

function PlayerController:ctor(player)
    self.player = player  -- Reference to the player object

    -- ✅ Keyboard input
    local function onKeyPressed(keyCode, event)
        if keyCode == cc.KeyCode.KEY_A or keyCode == cc.KeyCode.KEY_LEFT_ARROW then
            self.player:moveLeft()
        elseif keyCode == cc.KeyCode.KEY_D or keyCode == cc.KeyCode.KEY_RIGHT_ARROW then
            self.player:moveRight()
        elseif keyCode == cc.KeyCode.KEY_W or keyCode == cc.KeyCode.KEY_UP_ARROW then
            self.player:jump()
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, player)
end

return PlayerController
