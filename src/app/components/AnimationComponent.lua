local Component = require("app.core.Component")

local AnimationComponent = class("AnimationComponent", Component)

function AnimationComponent:ctor(owner, animations, scale)
    Component.ctor(self, owner)
    self.animations = {}
    self.currentAnimation = nil
    self.sprite = cc.Sprite:create()

    
    if not self.sprite then
        print("❌ Failed to create sprite!")
    else
        print("✅ Sprite created successfully.")
    end
    
    self.scale = scale or 1
    self.sprite:setScale(self.scale)
    self.sprite:setAnchorPoint(0.5, 0.5);

    -- local ownerPos = cc.p(owner:getPosition())
    -- self.sprite:setPosition(ownerPos.x, ownerPos.y)

    self.owner:addChild(self.sprite)

    -- ✅ Load all animations from the given list
    for _, animData in ipairs(animations) do
        self:loadAnimation(animData)
    end
end

function AnimationComponent:update(dt)
end



function AnimationComponent:loadAnimation(animData)
    local name = animData.name
    local plistFile = animData.plist  
    local frameTime = animData.frameTime or 0.1
    local shouldLoop = animData.loop or false
    local callback = animData.callback

    print("🔍 Loading animation:", name, "from:", plistFile)

    -- ✅ Load the `.plist` (this also loads the corresponding `.png`)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames(plistFile)

    -- ✅ Get texture from plist
    local frameDict = cc.FileUtils:getInstance():getValueMapFromFile(plistFile)
    local textureFile = plistFile:gsub(".plist", ".png")  -- ✅ Find the corresponding texture file
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureFile)

    if not texture then
        print("❌ Failed to load texture:", textureFile)
        return
    end

    -- ✅ Disable smoothing (set nearest-neighbor filtering)
    texture:setAliasTexParameters()  -- 🔥 Fixes blurriness

    -- ✅ Extract frame names from `.plist`
    local frameNames = frameDict["frames"]  
    if not frameNames then
        print("❌ No frames found in plist:", plistFile)
        return
    end

    -- ✅ Collect all frames in order
    local frames = {}
    local index = 1
    while true do
        local frameName = string.format("%s%d.png", name, index)  
        local frame = spriteFrameCache:getSpriteFrame(frameName)
        if not frame then break end
        table.insert(frames, frame)
        print("✅ Loaded frame:", frameName)
        index = index + 1
    end

    if #frames == 0 then
        print("❌ No valid frames found for:", name)
        return
    end

    -- ✅ Create animation
    -- local animation = cc.Animation:createWithSpriteFrames(frames, frameTime)
    -- animation:setLoops(shouldLoop and -1 or 1)

    -- ✅ Store animation data
    self.animations[name] = {
        frames = frames,
        frameTime = frameTime,
        shouldLoop = shouldLoop,
        callback = callback
    }
    print("✅ Animation stored:", name)
end

function AnimationComponent:play(name)
    -- print("🎬 Attempting to play animation:", name)

    local animData = self.animations[name]
    if not animData then
        -- print("❌ Animation not found in stored list:", name)
        return
    end

    if not animData.frames then
        -- print("❌ Animation data is nil for:", name)
        return
    end

    -- ✅ Check if the animation is already playing
    if self.currentAnimation == name then
        -- print("🎬 Animation already playing:", name)
        return
    end

    self:stop()

    self.currentAnimation = name
    local animation = cc.Animation:createWithSpriteFrames(animData.frames, animData.frameTime)
    animation:setLoops(animData.shouldLoop and -1 or 1)
    local animate = cc.Animate:create(animation)
    self.sprite:stopAllActions()
    self.sprite:runAction(animate)
end


function AnimationComponent:stop()
    self.sprite:stopAllActions()
    self.currentAnimation = nil
end

function AnimationComponent:getCurrentAnimation()
    return self.currentAnimation
end

return AnimationComponent
