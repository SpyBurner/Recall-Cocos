local Input = {}

Input.keys = {}  -- Store pressed keys

-- ✅ Register key press
local function onKeyPressed(keyCode, event)
    if DEBUG > 0 then
        -- print("Key Pressed:", keyCode)  -- Debugging
    end
    Input.keys[keyCode] = true
end

-- ✅ Register key release
local function onKeyReleased(keyCode, event)
    if DEBUG > 0 then
        -- print("Key Released:", keyCode)  -- Debugging
    end
    Input.keys[keyCode] = false
end

-- ✅ Check if a key is currently pressed
function Input.isKeyPressed(keyCode)
    return Input.keys[keyCode] or false
end

-- ✅ Properly initialize the input system
function Input.init(scene)
    if DEBUG > 0 then
        print("Initializing Input System...")  -- Debugging
    end 
    
    local keyboardListener = cc.EventListenerKeyboard:create()
    keyboardListener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyboardListener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(keyboardListener, scene)
end

return Input
