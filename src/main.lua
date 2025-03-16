cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

-- ✅ Add custom search paths
local fileUtils = cc.FileUtils:getInstance()
fileUtils:addSearchPath("app/")        -- Make sure "app" folder is included
fileUtils:addSearchPath("app/scenes/") -- Add scenes folder
fileUtils:addSearchPath("app/views/")  -- Add views folder
fileUtils:addSearchPath("app/controllers/")  -- Add controllers folder

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
