---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/5/20 19:08
---
local PushHeroLevelUpMessage = BaseClass("PushHeroLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --EventManager:GetInstance():Broadcast(EventId.HeroLevelUpgrade)
end

PushHeroLevelUpMessage.OnCreate = OnCreate
PushHeroLevelUpMessage.HandleMessage = HandleMessage

return PushHeroLevelUpMessage