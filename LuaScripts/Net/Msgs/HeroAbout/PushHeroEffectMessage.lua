---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/2/21 2:44 PM
---
--- 英雄作用号发生变化


local PushHeroEffectMessage = BaseClass("PushHeroEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    
    local heroUuid = message['heroUuid']
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
        heroData:HandleEffect(message['effect'])        
    end
end

PushHeroEffectMessage.OnCreate = OnCreate
PushHeroEffectMessage.HandleMessage = HandleMessage

return PushHeroEffectMessage