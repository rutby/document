---
--- Created by shimin.
--- DateTime: 2020/11/9 18:53
---
local HeroTalentPageRenameMessage = BaseClass("HeroTalentPageRenameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    if param ~= nil then
        self.sfsObj:PutUtfString("uuid", param.uuid)
        self.sfsObj:PutInt("talentPageIndex", param.talentPageIndex)
        self.sfsObj:PutUtfString("name", param.name)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --HeroManager:GetInstance():HeroTalentPageRenameHandle(t)
end

HeroTalentPageRenameMessage.OnCreate = OnCreate
HeroTalentPageRenameMessage.HandleMessage = HandleMessage

return HeroTalentPageRenameMessage