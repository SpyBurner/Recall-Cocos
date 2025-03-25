local Component = require("app.core.Component")
local CollisionLayers = require("app.core.CollisionLayers")
local bit = require("bit")

local DamageOnFall = class("DamageOnFall", Component)

function DamageOnFall:ctor(owner, damageAmount, speedThreshold)
    Component.ctor(self, owner)
    self.damage = damageAmount or 10  -- ✅ Default damage
    self.speedThreshold = speedThreshold or 50  -- ✅ Minimum fall speed required for damage

    -- ✅ Ensure the owner has a physics body
    local physicsBody = self.owner:getPhysicsBody()
    if not physicsBody then
        print("❌ DamageOnFall: Owner must have a physics body!")
        return
    end

    -- ✅ Create a contact listener
    local eventListener = cc.EventListenerPhysicsContact:create()
    eventListener:registerScriptHandler(handler(self, self.handleContactBegin), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    -- ✅ Use fixed priority to ensure it triggers correctly
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener, 1)
end

function DamageOnFall:handleContactBegin(contact)
    local bodyA = contact:getShapeA():getBody()
    local bodyB = contact:getShapeB():getBody()
    if not bodyA or not bodyB then return false end

    local nodeA = bodyA:getNode()
    local nodeB = bodyB:getNode()
    if not nodeA or not nodeB then return false end

    -- ✅ Ensure the box is part of the contact
    if nodeA ~= self.owner and nodeB ~= self.owner then return false end  

    -- ✅ Identify the object that is NOT the falling box
    local other = (nodeA == self.owner) and nodeB or nodeA

    -- ✅ Filter to only damage ENEMY objects
    local category = other:getPhysicsBody():getCategoryBitmask()
    if bit.band(category, CollisionLayers.ENEMY) == 0 then 
        return false  -- ❌ Ignore if it's not an enemy
    end

    -- ✅ Get the box's current falling speed
    local velocity = self.owner:getPhysicsBody():getVelocity()
    local fallSpeed = -velocity.y  -- Since downward velocity is negative in Cocos2d-x

    print("📏 Fall Speed:", fallSpeed, "Threshold:", self.speedThreshold)

    -- ✅ Check if fall speed is above the damage threshold
    if fallSpeed >= self.speedThreshold then
        local target = other:getComponent("CoreStat")
        if target then
            print("💥 DamageOnFall: Dealing", self.damage, "damage to", other.__cname)
            target:TakeDamage(self.damage)
        end
    else
        print("❌ Fall speed too low, no damage applied.")
    end

    return true
end

return DamageOnFall
