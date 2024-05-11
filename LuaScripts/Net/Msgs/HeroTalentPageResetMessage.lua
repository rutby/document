---
--- Created by shimin.
--- DateTime: 2020/11/9 18:51
---
local HeroTalentPageResetMessage = BaseClass("HeroTalentPageResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    if param ~= nil then
        self.sfsObj:PutUtfString("uuid", param.uuid)
        self.sfsObj:PutInt("talentPageIndex", param.talentPageIndex)
        self.sfsObj:PutUtfString("itemUuid", param.itemUuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --HeroManager:GetInstance():HeroTalentPageResetHandle(t)
end

HeroTalentPageResetMessage.OnCreate = OnCreate
HeroTalentPageResetMessage.HandleMessage = HandleMessage

return HeroTalentPageResetMessage