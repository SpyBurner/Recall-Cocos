local Component = require("app.core.Component")

local DamageOnContact = class("DamageOnContact", Component)

function DamageOnContact:ctor(owner, damageAmount)
    Component.ctor(self, owner)
    self.damage = damageAmount or 10
    self.isColliding = false  -- Track if collision is ongoing

    local physicsBody = self.owner:getPhysicsBody()
    if not physicsBody then
        print("❌ DamageOnContact: Owner must have a physics body!")
        return
    end

    -- ✅ Enable contact listener
    local function onContactBegin(contact)
        return self:handleContactBegin(contact)
    end

    local function onContactEnd(contact)
        return self:handleContactEnd(contact)
    end

    local eventListener = cc.EventListenerPhysicsContact:create()
    eventListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    eventListener:registerScriptHandler(onContactEnd, cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)

    self.owner:getEventDispatcher():addEventListenerWithSceneGraphPriority(eventListener, self.owner)
end

function DamageOnContact:handleContactBegin(contact)
    -- print("💥 DamageOnContact: Collision started!")

    local nodeA = contact:getShapeA():getBody():getNode()
    local nodeB = contact:getShapeB():getBody():getNode()

    if not nodeA or not nodeB then return false end

    local other = (nodeA == self.owner) and nodeB or nodeA
    self.target = other:getComponent("CoreStat")

    if self.target then
        -- print("💥 DamageOnContact: Start dealing continuous damage to", other.__cname)
        self.isColliding = true  -- Mark as in contact
    end

    return true
end

function DamageOnContact:handleContactEnd(contact)
    -- print("🛑 DamageOnContact: Collision ended!")
    self.isColliding = false  -- Stop applying damage
    self.target = nil  -- Clear reference
end

function DamageOnContact:update(dt)
    if self.isColliding and self.target then
        self.target:TakeDamage(self.damage)
    end
end

return DamageOnContact
