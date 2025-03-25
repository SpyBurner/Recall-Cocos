local ControllableObject = require("app.objects.ControllableObject")
local AnimationComponent = require("app.components.AnimationComponent")
local BlobAnimationControl = require("app.components.enemy.Blob.BlobAnimationControl")
local BlobAI = require("app.components.enemy.Blob.BlobAI")
local DamageOnContact = require("app.components.stat.DamageOnContact")

local Blob = class("Blob")

function Blob:create(target)
    -- blob
    local blob = ControllableObject:create(1, 0, 8, 8, 5, 90, 200, false, "Blob")  -- ✅ blob-controlled
    blob:setPosition(cc.p(100, display.cy))

    -- Animation
    local animations = {
        { name = "blob_walk", plist = "res/Sprites/Enemy/Blob/walk.plist", frameTime = 0.1, loop = true },
        { name = "blob_die", plist = "res/Sprites/Enemy/Blob/die.plist", frameTime = 0.1, loop = false, callback = function()
            print("Blob dies!")
            blob:runAction(cc.RemoveSelf:create())
        end },
    }

    blob:getComponent("CoreStat").OnDeathEvent:AddListener(function()
        blob:getPhysicsBody():setEnabled(false)  -- Disable physics body
    end)
    
    local animComponent = AnimationComponent:create(blob, animations, 5)
    blob:addComponent(animComponent)

    animComponent:play("blob_walk")  -- ✅ Play idle animation by default

    local damageOnContact = DamageOnContact:create(blob, 1)  -- ✅ Add damage component
    blob:addComponent(damageOnContact)
   
    local blobAnimControl = BlobAnimationControl:create(blob)
    blob:addComponent(blobAnimControl)

    local blobAI = BlobAI:create(blob, target)  -- ✅ Add AI component
    blob:addComponent(blobAI)

    blob:getComponent("CoreStat").OnDeathEvent:AddListener(function()
        print("Blob is dead!")
    end)

    return blob
end

return Blob