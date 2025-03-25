local Event = class("Event")

function Event:ctor()
    self.listeners = {}  -- ✅ Stores all event listeners
end

-- ✅ Add a listener (function) to the event
function Event:AddListener(listener)
    table.insert(self.listeners, listener)
end

-- ✅ Remove a specific listener
function Event:RemoveListener(listener)
    for i, v in ipairs(self.listeners) do
        if v == listener then
            table.remove(self.listeners, i)
            break
        end
    end
end

-- ✅ Call all registered event listeners
function Event:Invoke(...)
    for _, listener in ipairs(self.listeners) do
        listener(...)  -- ✅ Call listener with arguments
    end
end

return Event
