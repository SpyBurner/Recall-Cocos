local AboutScene = class("AboutScene", cc.Scene)

function AboutScene:ctor()
    local bgColor = cc.LayerColor:create(cc.c4b(173, 216, 230, 255)) -- Light Cyan (R:173, G:216, B:230, A:255)
    self:addChild(bgColor)

    local textColor = cc.c3b(0, 0, 0) -- Black (R:0, G:0, B:0)


    -- Add a label to display "About"
    local aboutLabel = cc.Label:createWithSystemFont("About", "Arial", 48)
    aboutLabel:setColor(textColor)
    aboutLabel:setPosition(display.cx, display.cy + 150)
    self:addChild(aboutLabel)

    -- Add a description label
    local descriptionLabel = cc.Label:createWithSystemFont(
        "This is a puzzle game developed using Cocos2d-x WITH LUA.\nEnjoy solving puzzles and have fun!",
        "Arial",
        24
    )
    descriptionLabel:setColor(textColor)
    descriptionLabel:setPosition(display.cx, display.cy)
    descriptionLabel:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self:addChild(descriptionLabel)


    -- Add a button to go back to the main menu
    local backButton = cc.MenuItemFont:create("Back to Menu")
    backButton:setColor(textColor)
    backButton:setPosition(display.cx, display.cy - 150)
    backButton:registerScriptTapHandler(function()
        local menuScene = require("app.scenes.MenuScene"):create()
        cc.Director:getInstance():replaceScene(menuScene)
    end)

    local menu = cc.Menu:create(backButton)
    menu:setPosition(0, 0)
    self:addChild(menu)
end

return AboutScene