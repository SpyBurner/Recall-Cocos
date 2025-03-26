local Component = require("app.core.Component")

local KeyEvent = class("KeyEvent", Component)

function KeyEvent:ctor(owner, keyToWatch, onPress, onRelease)
    Component.ctor(self, owner)

    self.keyToWatch = keyToWatch  -- ✅ Key to track (e.g., `cc.KeyCode.KEY_SPACE`)
    self.onPress = onPress  -- ✅ Callback when key is pressed
    self.onRelease = onRelease  -- ✅ Callback when key is released
    self.isKeyDown = false  -- ✅ Prevents duplicate handling

    -- ✅ Create keyboard event listener
    local eventListener = cc.EventListenerKeyboard:create()
    eventListener:registerScriptHandler(handler(self, self.onKeyPressed), cc.Handler.EVENT_KEYBOARD_PRESSED)
    eventListener:registerScriptHandler(handler(self, self.onKeyReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)

    -- ✅ Add listener with fixed priority
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

function KeyEvent:update(dt)
    -- local velocity = self.owner:getPhysicsBody():getVelocity()
    -- print("Current Velocity:", velocity.x, velocity.y)
end

function KeyEvent:onKeyPressed(keyCode, event)
    if not self.isEnabled then
        return  -- ✅ Ignore if component is disabled
    end
    if keyCode == self.keyToWatch and not self.isKeyDown then
        self.isKeyDown = true  -- ✅ Mark key as held
        print("🟢 Key Pressed:", keyCode)

        -- ✅ Trigger onPress callback if defined
        if self.onPress then
            self.onPress()
        end
    end
end

function KeyEvent:onKeyReleased(keyCode, event)
    if not self.isEnabled then
        return  -- ✅ Ignore if component is disabled
    end
    if keyCode == self.keyToWatch then
        self.isKeyDown = false  -- ✅ Reset key state
        print("🔴 Key Released:", keyCode)

        -- ✅ Trigger onRelease callback if defined
        if self.onRelease then
            self.onRelease()
        end
    end
end

return KeyEvent
