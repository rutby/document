---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/6/9 14:19
---

local UseHeroEffectSkillMessage = BaseClass("UseHeroEffectSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, effectId, num)
    base.OnCreate(self)
    self.sfsObj:PutInt("effectId", effectId)
    self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] then
        return
    end

    DataCenter.HeroEffectSkillManager:HandleUseHeroEffectSkillMessage(t)
end

UseHeroEffectSkillMessage.OnCreate = OnCreate
UseHeroEffectSkillMessage.HandleMessage = HandleMessage

return UseHeroEffectSkillMessage