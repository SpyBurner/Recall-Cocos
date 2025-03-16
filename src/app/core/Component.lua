local Component = class("Component")

function Component:ctor(owner)
    self.owner = owner  -- ✅ The node this component is attached to
    self.isEnabled = true
end

function Component:update(dt)
    -- ✅ Override this in child components
end

return Component
