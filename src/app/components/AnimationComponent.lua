local Component = require("app.core.Component")

local AnimationComponent = class("AnimationComponent", Component)

function AnimationComponent:ctor(owner, animations, scale)
    Component.ctor(self, owner)  -- ✅ Initialize base component
    self.animations = {}  -- ✅ Store animations
    self.currentAnimation = nil
    self.sprite = cc.Sprite:create()  -- ✅ Create a sprite to display animations
    self.owner:addChild(self.sprite)
    self.scale = scale or 1  -- ✅ Default scale
    self.sprite:setScale(self.scale)  -- ✅ Apply scale

    -- ✅ Load all animations
    for _, animData in ipairs(animations) do
        self:loadAnimation(animData)
    end
end

function AnimationComponent:loadAnimation(animData)
    local name = animData.name
    local spriteSheet = animData.path
    local frameTime = animData.frameTime or 0.1  -- Default frame duration
    local shouldLoop = animData.loop or false
    local callback = animData.callback

    -- ✅ Load spritesheet
    local texture = cc.Director:getInstance():getTextureCache():addImage(spriteSheet)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames(spriteSheet:gsub(".png", ".plist"))  -- Assumes .plist file exists

    -- ✅ Get all frames from the spritesheet
    local frames = {}
    local index = 1
    while true do
        local frame = spriteFrameCache:getSpriteFrame(string.format("%s_%d.png", name, index))
        if not frame then break end
        table.insert(frames, frame)
        index = index + 1
    end

    -- ✅ Create animation
    local animation = cc.Animation:createWithSpriteFrames(frames, frameTime)
    if shouldLoop then
        animation:setLoops(-1)  -- ✅ Loop indefinitely
    else
        animation:setLoops(1)   -- ✅ Play once
    end

    -- ✅ Store animation data
    self.animations[name] = {
        animation = animation,
        callback = callback
    }
end

function AnimationComponent:play(name)
    if self.currentAnimation == name then return end  -- ✅ Avoid restarting the same animation

    local animData = self.animations[name]
    if not animData then
        print("❌ Animation not found:", name)
        return
    end

    self.currentAnimation = name
    local animate = cc.Animate:create(animData.animation)

    -- ✅ Add callback if animation does NOT loop
    local sequence
    if animData.animation:getLoops() == 1 then
        sequence = cc.Sequence:create(animate, cc.CallFunc:create(function()
            if animData.callback then animData.callback() end
            self.currentAnimation = nil  -- ✅ Reset animation state
        end))
    else
        sequence = animate
    end

    self.sprite:stopAllActions()  -- ✅ Stop any running animation
    self.sprite:runAction(sequence)  -- ✅ Play new animation
end

function AnimationComponent:stop()
    self.sprite:stopAllActions()
    -- self.currentAnimation = nil
end

function AnimationComponent:getCurrentAnimation()
    return self.currentAnimation
end

return AnimationComponent
