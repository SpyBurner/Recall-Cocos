local MenuController = require("app.controllers.MenuController")

local MenuScene = class("MenuScene", cc.Scene)

function MenuScene:ctor()
    local menu = MenuController:create()
    self:addChild(menu)
end

return MenuScene
