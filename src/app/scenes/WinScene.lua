local WinScene = class("WinScene", cc.Scene)

function WinScene:ctor()
    local bgColor = cc.LayerColor:create(cc.c4b(173, 216, 230, 255)) -- Light Cyan (R:173, G:216, B:230, A:255)
    self:addChild(bgColor)

    -- Add a label to display "You Win!"
    local winLabel = cc.Label:createWithSystemFont("You Win!", "Arial", 48)
    winLabel:setPosition(display.cx, display.cy + 100)
    self:addChild(winLabel)

    local textColor = cc.c3b(0, 0, 0) -- Black (R:0, G:0, B:0)

    -- Add a button to go back to the main menu
    local backButton = cc.MenuItemFont:create("Back to Menu")
    backButton:setColor(textColor)
    backButton:setPosition(display.cx, display.cy - 50)
    backButton:registerScriptTapHandler(function()
        local menuScene = require("app.scenes.MenuScene"):create()
        cc.Director:getInstance():replaceScene(menuScene)
    end)

    local menu = cc.Menu:create(backButton)
    menu:setPosition(0, 0)
    self:addChild(menu)
end

return WinScene