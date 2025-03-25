local Component = require("app.core.Component")

local ReloadGame = class("ReloadGame", Component)

function ReloadGame:ctor(owner)
    Component.ctor(self, owner)

    -- ✅ Create keyboard event listener
    local eventListener = cc.EventListenerKeyboard:create()
    eventListener:registerScriptHandler(handler(self, self.onKeyPressed), cc.Handler.EVENT_KEYBOARD_PRESSED)

    -- ✅ Add listener with fixed priority
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

function ReloadGame:onKeyPressed(keyCode, event)
    if keyCode == cc.KeyCode.KEY_R then
        print("🔄 Reloading game...")

        -- ✅ Get current scene class
        local sceneName = cc.Director:getInstance():getRunningScene().__cname  
        print("🔄 Reloading Scene:", sceneName)

        -- ✅ Create a new instance of the scene (Modify this based on your game structure)
        local newScene = require("app.scenes." .. sceneName):create()

        -- ✅ Reload the scene with a transition
        cc.Director:getInstance():replaceScene(newScene)
    end

    local sceneName = cc.Director:getInstance():getRunningScene().__cname
    print("Currently in scene:", sceneName)

    if keyCode == cc.KeyCode.KEY_ESCAPE then
        if (sceneName == "GameScene") then
            print("🔄 Exiting game...")
            local MenuScene = require("app.scenes.MenuScene")  -- Load menu scene
            local scene = MenuScene:create()
            cc.Director:getInstance():replaceScene(scene)
        else
            print("🔄 Exiting game...")
        end
    end
end

return ReloadGame
