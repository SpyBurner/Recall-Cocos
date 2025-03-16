local Input = {}

Input.keys = {}  -- ✅ Stores currently pressed keys
Input.debugMode = false  -- ✅ Toggle debug mode (set to `true` for logs)

-- ✅ Callbacks for any key press or release
Input.onAnyKeyDown = nil  -- Function triggered when any key is pressed
Input.onAnyKeyUp = nil  -- Function triggered when any key is released

-- ✅ Register key press
local function onKeyPressed(keyCode, event)
    if Input.debugMode then
        print("[Input] Key Pressed:", keyCode)
    end
    Input.keys[keyCode] = true

    -- ✅ Call onAnyKeyDown callback if assigned
    if Input.onAnyKeyDown then
        Input.onAnyKeyDown(keyCode)
    end
end

-- ✅ Register key release
local function onKeyReleased(keyCode, event)
    if Input.debugMode then
        print("[Input] Key Released:", keyCode)
    end
    Input.keys[keyCode] = false

    -- ✅ Call onAnyKeyUp callback if assigned
    if Input.onAnyKeyUp then
        Input.onAnyKeyUp(keyCode)
    end
end

-- ✅ Check if a specific key is currently pressed
function Input.isKeyPressed(keyCode)
    return Input.keys[keyCode] or false
end

-- ✅ Check if **any key** is currently held down
function Input.isAnyKeyPressed()
    for _, isPressed in pairs(Input.keys) do
        if isPressed then
            return true  -- ✅ At least one key is pressed
        end
    end
    return false  -- ✅ No keys are pressed
end

-- ✅ Check if **no keys** are being pressed (all keys released)
function Input.areAllKeysReleased()
    for _, isPressed in pairs(Input.keys) do
        if isPressed then
            return false  -- ✅ At least one key is still pressed
        end
    end
    return true  -- ✅ No keys are being pressed
end

-- ✅ Enable or disable debugging
function Input.setDebugMode(enabled)
    Input.debugMode = enabled
end

-- ✅ Properly initialize the input system
function Input.init(scene)
    if Input.debugMode then
        print("[Input] Initializing Input System...")
    end 

    local keyboardListener = cc.EventListenerKeyboard:create()
    keyboardListener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyboardListener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(keyboardListener, scene)
end

return Input
