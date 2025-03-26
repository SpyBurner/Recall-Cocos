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

    self.coins = 0

    self.OnDeathEvent = Event:create()  -- ✅ Create a death event

    self.OnHpChangeEvent = Event:create()  -- ✅ Create an HP change event

    self.OnCoinsChangeEvent = Event:create()  -- ✅ Create a coins change event
end

function CoreStat:GetHp()
    return self.hp
end

function CoreStat:Heal()
    if self.isDead then return end  -- ✅ Don't heal if already dead
    if self.hp >= self.maxHp then return end  -- ✅ Don't heal if already at max HP

    self.hp = math.min(self.hp + 1, self.maxHp)  -- ✅ Heal by 1, but not exceeding max HP
    print("❤️ CoreStat: ", self.owner:getName()," healed to HP:", self.hp)

    self.OnHpChangeEvent:Invoke(self.hp)  -- ✅ Invoke the HP change event
end

function CoreStat:TakeDamage(damage)
    -- print("TakeDamage triggerd at time: ", os.time())
    
    if self.isDead then return end  -- ✅ Don't take damage if already dead
    
    if os.time() - self.lastIframe < self.iframe then
        return  -- ✅ Ignore damage if in iframe
    end
    
    self.lastIframe = os.time()  -- ✅ Update last iframe time
    self.hp = self.hp - damage
    
    print("💥 CoreStat: ", self.owner:getName()," taking damage:", damage)

    self.OnHpChangeEvent:Invoke(self.hp)  -- ✅ Invoke the HP change event

    if self.hp <= 0 then
        self.hp = 0
        self:Die(self.owner)  -- ✅ Call the die function if HP is zero
    end
end

function CoreStat:Die(theDeathObject)
    if theDeathObject ~= self.owner then return end  -- ✅ Ensure the object is the same as the owner
    if self.isDead then return end
    self.isDead = true

    local body = self.owner:getPhysicsBody()
    body.velocity = cc.p(0, 0)  -- ✅ Stop the object from moving

    -- ✅ Invoke the event, triggering all registered listeners
    self.OnDeathEvent:Invoke(self.owner)
end

function CoreStat:AddCoins(value)
    if self.isDead then return end  -- ✅ Don't pick up coins if dead

    self.coins = self.coins + value  -- ✅ Increment coin count
    print("💰 CoreStat: ", self.owner:getName()," picked up a coin! Total coins:", self.coins)

    self.OnCoinsChangeEvent:Invoke(self.coins)  -- ✅ Invoke the coins change event
end

function CoreStat:update(dt)
    -- No update logic needed for now
end

return CoreStat
