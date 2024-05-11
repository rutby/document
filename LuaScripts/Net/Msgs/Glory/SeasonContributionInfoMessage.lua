---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 16:07
---

local SeasonContributionInfoMessage = BaseClass("SeasonContributionInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
    base.OnCreate(self)
    self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end

    DataCenter.GloryManager:HandleGetContribution(t)
end

SeasonContributionInfoMessage.OnCreate = OnCreate
SeasonContributionInfoMessage.HandleMessage = HandleMessage

return SeasonContributionInfoMessage