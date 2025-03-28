cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

-- ✅ Add custom search paths
local fileUtils = cc.FileUtils:getInstance()
fileUtils:addSearchPath("app/")             -- Main app folder
fileUtils:addSearchPath("app/scenes/")      -- Scenes folder
fileUtils:addSearchPath("app/views/")       -- UI Views folder
fileUtils:addSearchPath("app/controllers/") -- Controllers folder
fileUtils:addSearchPath("app/objects/")     -- ✅ Objects folder (for Player, Ground, etc.)
fileUtils:addSearchPath("app/core/")        -- ✅ Core folder (for GameObject, Input, etc.)
fileUtils:addSearchPath("app/components/")  -- Components folder

local function main()
    local glview = cc.Director:getInstance():getOpenGLView()
    -- glview:setFrameSize(1920, 1030)
    glview:setFrameSize(1280, 720)
    -- glview:setFullScreen(true)
    
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
