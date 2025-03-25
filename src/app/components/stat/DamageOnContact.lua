local Component = require("app.core.Component")

local DamageOnContact = class("DamageOnContact", Component)

function DamageOnContact:ctor(owner, damageAmount)
    Component.ctor(self, owner)  -- ✅ Call base class constructor
    self.damage = damageAmount or 10  -- ✅ Default damage value

    -- ✅ Ensure the owner has a physics body
    local physicsBody = self.owner:getPhysicsBody()
    if not physicsBody then
        print("❌ DamageOnContact: Owner must have a physics body!")
        return
    end

    -- ✅ Enable contact listener
    local function onContactBegin(contact)
        self:handleContact(contact)
        return true
    end
    local eventListener = cc.EventListenerPhysicsContact:create()
    eventListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    local eventDispatcher = self.owner:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(eventListener, self.owner)

    if (eventDispatcher) then
        print("✅ DamageOnContact: Event dispatcher found!")
    end
end

function DamageOnContact:handleContact(contact)
    print("💥 DamageOnContact: Collision detected!")

    -- ✅ Get objects from collision
    local nodeA = contact:getShapeA():getBody():getNode()
    local nodeB = contact:getShapeB():getBody():getNode()

    -- ✅ Ensure nodes are valid
    if not nodeA or not nodeB then return end

    -- ✅ Check which node is the owner, and find the other
    local other = (nodeA == self.owner) and nodeB or nodeA

    -- ✅ Check if the other object has `CoreStat`
    local coreStat = other:getComponent("CoreStat")
    if coreStat then
        print("💥 DamageOnContact: Dealing", self.damage, "damage to", other.__cname)
        coreStat:TakeDamage(self.damage)
    end
end

return DamageOnContact
