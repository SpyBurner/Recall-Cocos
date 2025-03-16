local bit = require("bit")  -- ✅ Require bitwise operations for Lua 5.1

local CollisionLayers = {
    PLAYER       = bit.lshift(1, 0),  -- `0b000000000001`
    ENEMY        = bit.lshift(1, 1),  -- `0b000000000010`
    PROJECTILE   = bit.lshift(1, 2),  -- `0b000000000100`
    E_PROJECTILE = bit.lshift(1, 3),  -- `0b000000001000`
    WALL         = bit.lshift(1, 4),  -- `0b000000010000`
    CAMERA       = bit.lshift(1, 5),  -- `0b000000100000`
    PARTICLE     = bit.lshift(1, 6),  -- `0b000001000000`
    DETECTION    = bit.lshift(1, 7),  -- `0b000010000000`
    SPIKE        = bit.lshift(1, 8),  -- `0b000100000000`
    POWERUP      = bit.lshift(1, 9),  -- `0b001000000000`
    PUSHABLE     = bit.lshift(1, 10), -- `0b010000000000`
    GATE         = bit.lshift(1, 11), -- `0b100000000000`
    DEFAULT      = 0xFFFFFFFF         -- All layers
}

-- ✅ Use `bit.bor()` instead of `|` for Lua 5.1
function CollisionLayers:collidesWith(...)
    local result = 0
    for _, layer in ipairs({...}) do
        result = bit.bor(result, layer)
    end
    return result
end

return CollisionLayers
