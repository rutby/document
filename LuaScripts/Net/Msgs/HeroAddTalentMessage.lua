---
--- Created by shimin.
--- DateTime: 2020/11/9 18:56
---
local HeroAddTalentMessage = BaseClass("HeroAddTalentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("uuid", param.uuid)
        self.sfsObj:PutInt("talentPageIndex", param.talentPageIndex)
        self.sfsObj:PutInt("talentId", param.talentId)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --HeroManager:GetInstance():HeroAddTalentHandle(t)
end

HeroAddTalentMessage.OnCreate = OnCreate
HeroAddTalentMessage.HandleMessage = HandleMessage

return HeroAddTalentMessage