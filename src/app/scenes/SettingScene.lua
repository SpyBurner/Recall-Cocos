local SettingScene = class("SettingScene", cc.Scene)

function SettingScene:ctor()
    local bgColor = cc.LayerColor:create(cc.c4b(200, 200, 200, 255)) -- Light Gray Background
    self:addChild(bgColor)

    local titleLabel = cc.Label:createWithSystemFont("Settings", "Arial", 48)
    titleLabel:setPosition(display.cx, display.cy + 150)
    self:addChild(titleLabel)

    local textColor = cc.c3b(0, 0, 0) -- Black text color

    -- Audio Volume Label
    local volumeLabel = cc.Label:createWithSystemFont("Volume: ", "Arial", 36)
    volumeLabel:setPosition(display.cx - 80, display.cy + 50)
    self:addChild(volumeLabel)

    -- Volume Control Buttons
    local volume = cc.UserDefault:getInstance():getFloatForKey("audioVolume", 1.0)
    local volumeDisplay = cc.Label:createWithSystemFont(string.format("%.1f", volume), "Arial", 36)
    volumeDisplay:setPosition(display.cx + 50, display.cy + 50)
    self:addChild(volumeDisplay)

    local function adjustVolume(amount)
        volume = math.max(0.0, math.min(1.0, volume + amount))
        cc.UserDefault:getInstance():setFloatForKey("audioVolume", volume)
        cc.SimpleAudioEngine:getInstance():setBackgroundMusicVolume(volume)
        volumeDisplay:setString(string.format("%.1f", volume))
    end

    local increaseButton = cc.MenuItemFont:create("+")
    increaseButton:setColor(textColor)
    increaseButton:setPosition(display.cx + 120, display.cy + 50)
    increaseButton:registerScriptTapHandler(function() adjustVolume(0.1) end)

    local decreaseButton = cc.MenuItemFont:create("-")
    decreaseButton:setColor(textColor)
    decreaseButton:setPosition(display.cx - 120, display.cy + 50)
    decreaseButton:registerScriptTapHandler(function() adjustVolume(-0.1) end)

    -- Mute Toggle
    local isMuted = cc.UserDefault:getInstance():getBoolForKey("audioMuted", false)
    local muteLabel = cc.Label:createWithSystemFont("Mute: " .. (isMuted and "ON" or "OFF"), "Arial", 36)
    muteLabel:setPosition(display.cx, display.cy - 20)
    self:addChild(muteLabel)

    local muteButton = cc.MenuItemFont:create("Toggle Mute")
    muteButton:setColor(textColor)
    muteButton:setPosition(display.cx, display.cy - 60)
    muteButton:registerScriptTapHandler(function()
        isMuted = not isMuted
        cc.UserDefault:getInstance():setBoolForKey("audioMuted", isMuted)
        cc.SimpleAudioEngine:getInstance():setEffectsVolume(isMuted and 0 or volume)
        cc.SimpleAudioEngine:getInstance():setBackgroundMusicVolume(isMuted and 0 or volume)
        muteLabel:setString("Mute: " .. (isMuted and "ON" or "OFF"))
    end)

    -- Back Button
    local backButton = cc.MenuItemFont:create("Back to Menu")
    backButton:setColor(textColor)
    backButton:setPosition(display.cx, display.cy - 150)
    backButton:registerScriptTapHandler(function()
        local menuScene = require("app.scenes.MenuScene"):create()
        cc.Director:getInstance():replaceScene(menuScene)
    end)

    local menu = cc.Menu:create(increaseButton, decreaseButton, muteButton, backButton)
    menu:setPosition(0, 0)
    self:addChild(menu)
end

return SettingScene
