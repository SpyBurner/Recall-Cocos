local Component = require("app.core.Component")

local DamageOnContact = class("DamageOnContact", Component)

function DamageOnContact:ctor(owner, damageAmount)
    Component.ctor(self, owner)
    self.damage = damageAmount or 10
    self.isColliding = false  

    local physicsBody = self.owner:getPhysicsBody()
    if not physicsBody then
        print("❌ DamageOnContact: Owner must have a physics body!")
        return
    end

    -- ✅ Create a single contact listener
    local eventListener1 = cc.EventListenerPhysicsContact:create()
    eventListener1:registerScriptHandler(handler(self, self.handleContactBegin), cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    local eventListener2 = cc.EventListenerPhysicsContact:create()
    eventListener2:registerScriptHandler(handler(self, self.handleContactEnd), cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)

    -- ✅ Use fixed priority to ensure events fire properly
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener1, 1)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(eventListener2, 2)
end

function DamageOnContact:handleContactBegin(contact)
    print("Contact detected!")
    local nodeA = contact:getShapeA():getBody():getNode()
    local nodeB = contact:getShapeB():getBody():getNode()

    if not nodeA or not nodeB then return false end

    local other = (nodeA == self.owner) and nodeB or nodeA

    self.target = other:getComponent("CoreStat")

    if self.target then
        self.isColliding = true  
        self.target:TakeDamage(self.damage)
        return true  -- ✅ Ensure the event is processed
    end

    return false
end

function DamageOnContact:handleContactEnd(contact)
    local nodeA = contact:getShapeA():getBody():getNode()
    local nodeB = contact:getShapeB():getBody():getNode()

    if (not nodeA or not nodeB or not(nodeA == self.owner or nodeB == self.owner)) then return end

    print("Contact ended!")
    self.isColliding = false  
    self.target = nil  
end

function DamageOnContact:update(dt)
    if self.isColliding and self.target then
        self.target:TakeDamage(self.damage)
    end
end

return DamageOnContact
