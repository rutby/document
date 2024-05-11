---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/2 14:04
---
local PushNowZombieAttackMessage = BaseClass("PushNowZombieAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        return
    end
    
    DataCenter.CitySiegeManager:HandleNowAttack(t)
end

PushNowZombieAttackMessage.OnCreate = OnCreate
PushNowZombieAttackMessage.HandleMessage = HandleMessage

return PushNowZombieAttackMessage