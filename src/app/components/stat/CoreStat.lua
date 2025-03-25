local Component = require("app.core.Component")
local Event = require("app.core.Event")  -- ✅ Import the Event system

local CoreStat = class("CoreStat", Component)

function CoreStat:ctor(owner, maxHP, iframe)
    Component.ctor(self, owner)  -- ✅ Call base class constructor
    
    self.maxHp = maxHP or 3  -- ✅ Default max HP
    self.hp = self.maxHp  -- ✅ Current HP
    self.isDead = false  -- ✅ Flag to check if the object is dead

    self.iframe = iframe or 1  -- ✅ Default iframe duration
    self.lastIframe = 0  -- ✅ Last iframe time


    self.OnDeathEvent = Event:create()  -- ✅ Create a death event

    self.OnHpChangeEvent = Event:create()  -- ✅ Create an HP change event
end

function CoreStat:GetHp()
    return self.hp
end

function CoreStat:TakeDamage(damage)
    -- print("TakeDamage triggerd at time: ", os.time())
    
    if self.isDead then return end  -- ✅ Don't take damage if already dead
    
    if os.time() - self.lastIframe < self.iframe then
        return  -- ✅ Ignore damage if in iframe
    end
    
    self.lastIframe = os.time()  -- ✅ Update last iframe time
    self.hp = self.hp - damage
    
    print("💥 CoreStat: Taking damage:", damage)

    self.OnHpChangeEvent:Invoke(self.hp)  -- ✅ Invoke the HP change event

    if self.hp <= 0 then
        self.hp = 0
        self:Die()
    end
end

function CoreStat:Die()
    if self.isDead then return end
    self.isDead = true

    local body = self.owner:getPhysicsBody()
    body.velocity = cc.p(0, 0)  -- ✅ Stop the object from moving

    -- ✅ Invoke the event, triggering all registered listeners
    self.OnDeathEvent:Invoke(self.owner)
end

function CoreStat:update(dt)
    -- No update logic needed for now
end

return CoreStat
