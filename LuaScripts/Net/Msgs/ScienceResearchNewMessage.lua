---
--- Created by shimin.
--- DateTime: 2020/7/23 10:50
---
local ScienceResearchNewMessage = BaseClass("ScienceResearchNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("itemId", param.itemId)
        self.sfsObj:PutInt("useGold", param.useGold)
        self.sfsObj:PutLong("bUuid", param.bUuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ScienceManager:ScienceResearchNewMessageHandle(t)
end

ScienceResearchNewMessage.OnCreate = OnCreate
ScienceResearchNewMessage.HandleMessage = HandleMessage

return ScienceResearchNewMessage