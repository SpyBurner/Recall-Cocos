local MenuView = class("MenuView", cc.load("mvc").ViewBase)

function MenuView:onCreate()
    -- ✅ Add light cyan background
    local bgColor = cc.LayerColor:create(cc.c4b(173, 216, 230, 255)) -- Light Cyan (R:173, G:216, B:230, A:255)
    self:addChild(bgColor)
    
    local textColor = cc.c3b(0, 0, 0) -- Black (R:0, G:0, B:0)

    -- Create buttons (without logic)
    self.playButton = cc.MenuItemFont:create("Play")
    self.settingsButton = cc.MenuItemFont:create("Settings")
    self.aboutButton = cc.MenuItemFont:create("About")
    self.exitButton = cc.MenuItemFont:create("Exit")

    -- Set button text color
    self.playButton:setColor(textColor)
    self.settingsButton:setColor(textColor)
    self.aboutButton:setColor(textColor)
    self.exitButton:setColor(textColor)

    -- Arrange buttons
    local menu = cc.Menu:create(self.playButton, self.settingsButton, self.aboutButton, self.exitButton)
    menu:alignItemsVerticallyWithPadding(20)
    menu:setPosition(display.cx, display.cy - 50)
    self:addChild(menu)
end

return MenuView
