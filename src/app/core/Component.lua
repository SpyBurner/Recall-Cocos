local Component = class("Component")

function Component:ctor(owner)
    self.owner = owner  
    self.isEnabled = true  

end

function Component:update(dt)
    -- ✅ Override this in child components
end

function Component:enable()
    self.isEnabled = true
end

function Component:disable()
    self.isEnabled = false
end


return Component
