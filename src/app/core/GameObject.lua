local GameObject = class("GameObject", function()
    return cc.Node:create()  -- ✅ All game objects are nodes
end)

function GameObject:ctor()
    self.components = {}  -- ✅ Store all attached components
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)  -- ✅ Schedule update once
end

function GameObject:addComponent(component)
    table.insert(self.components, component)  -- ✅ Store component in a list
end

-- ✅ Update loop (called every frame)
function GameObject:update(dt)
    for _, component in ipairs(self.components) do
        if component.update then
            component:update(dt)  -- ✅ Call update on all components
        end
    end
end

return GameObject
