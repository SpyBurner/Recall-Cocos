local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())  -- Seed the random generator for better randomness
end

function MyApp:run()
    local MenuScene = require("app.scenes.MenuScene")  -- Correct path
    local scene = MenuScene:create()
    cc.Director:getInstance():runWithScene(scene)  -- Start scene
end

return MyApp
