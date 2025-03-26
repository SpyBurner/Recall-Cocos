local Component = require("app.core.Component")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

local CallBackOnContact = class("CallBackOnContact", Component)

function CallBackOnContact:ctor(owner, onBegin, onEnd, destroyOnContact)
    Component.ctor(self, owner)

    self.onBegin = onBegin  -- ✅ Callback when contact starts
    self.onEnd = onEnd      -- ✅ Callback when contact ends
    self.destroyOnContact = destroyOnContact or false  -- ✅ Default: do not destroy

    local physicsBody = self.owner:getPhysicsBody()
    if not physicsBody then
        print("❌ CallBackOnContact: Owner must have a physics body!")
        return
    end

    -- ✅ Create a contact listener
    local eventListener = cc.EventListenerPhysicsContact:create()
    eventListener:registerScriptHandler(handler(self, self.handleContactBegin), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    eventListener:registerScriptHandler(handler(self, self.handleContactEnd), cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)

    -- ✅ Use fixed priority to ensure events fire properly
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

function CallBackOnContact:handleContactBegin(contact)
    local bodyA = contact:getShapeA():getBody()
    local bodyB = contact:getShapeB():getBody()

    if not bodyA or not bodyB then return false end

    local nodeA = bodyA:getNode()
    local nodeB = bodyB:getNode()

    if not nodeA or not nodeB then return false end

    -- ✅ Ensure `self.owner` is part of the contact
    if nodeA ~= self.owner and nodeB ~= self.owner then return false end  

    -- ✅ Identify the object that is NOT the owner
    local other = (nodeA == self.owner) and nodeB or nodeA

    -- ✅ Filter for POWERUP objects
    local category = other:getPhysicsBody():getCategoryBitmask()
    if bit.band(category, CollisionLayers.POWERUP) == 0 then 
        return false  -- ❌ Ignore if it's not a powerup
    end

    -- ✅ Trigger the callback function if it exists
    if self.onBegin then
        print("⚡ CallBackOnContact: Triggering onBegin callback")
        self.onBegin(other)
    end

    -- ✅ Destroy power-up if flag is enabled
    if self.destroyOnContact then
        print("🗑️ Destroying power-up:", other.__cname)
        other:removeFromParent(true)
    end

    return true
end

function CallBackOnContact:handleContactEnd(contact)
    local bodyA = contact:getShapeA():getBody()
    local bodyB = contact:getShapeB():getBody()

    if not bodyA or not bodyB then return end

    local nodeA = bodyA:getNode()
    local nodeB = bodyB:getNode()

    if not nodeA or not nodeB then return end

    if nodeA ~= self.owner and nodeB ~= self.owner then return end  

    -- ✅ Identify the other object
    local other = (nodeA == self.owner) and nodeB or nodeA

    -- ✅ Filter for POWERUP objects
    local category = other:getPhysicsBody():getCategoryBitmask()
    if bit.band(category, CollisionLayers.POWERUP) == 0 then 
        return  -- ❌ Ignore if it's not a powerup
    end

    -- ✅ Trigger the callback function if it exists
    if self.onEnd then
        print("⚡ CallBackOnContact: Triggering onEnd callback")
        self.onEnd(other)
    end
end

return CallBackOnContact
