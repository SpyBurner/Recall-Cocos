local GameObject = class("GameObject", function()
    return cc.Node:create()  -- All game objects are nodes
end)

function GameObject:ctor()
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

-- ✅ Override this in subclasses (like Unity's Update())
function GameObject:update(dt)
    -- Default: Do nothing, should be overridden
end

return GameObject
