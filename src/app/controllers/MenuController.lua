local MenuView = require("app.views.MenuView")
local MenuController = class("MenuController", MenuView)  -- Inherit from MenuView

function MenuController:onCreate()
    MenuController.super.onCreate(self)  -- Call parent (MenuView) onCreate()

    -- ✅ Fix scene transitions by using "scenes.GameScene"
    self.playButton:registerScriptTapHandler(function()
        print("Play button clicked!")
        local GameScene = require("app.scenes.GameScene")  -- Load the correct scene
        local scene = GameScene:create()
        cc.Director:getInstance():replaceScene(scene)
    end)

    self.settingsButton:registerScriptTapHandler(function()
        print("Settings button clicked!")
        local SettingsScene = require("app.scenes.SettingsScene")  -- Load settings scene
        local scene = SettingsScene:create()
        cc.Director:getInstance():replaceScene(scene)
    end)

    self.exitButton:registerScriptTapHandler(function()
        print("Exit button clicked!")
        cc.Director:getInstance():endToLua()  -- Exit game
    end)
end

return MenuController
