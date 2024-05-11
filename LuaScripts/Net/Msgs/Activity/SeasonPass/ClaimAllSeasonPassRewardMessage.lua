---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/1/17 22:07
---ClaimAllSeasonPassRewardMessage.lua


local ClaimAllSeasonPassRewardMessage = BaseClass("ClaimAllSeasonPassRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.SeasonPassManager:OnRecvAllLevelRewardsResp(t)
    end
end

ClaimAllSeasonPassRewardMessage.OnCreate = OnCreate
ClaimAllSeasonPassRewardMessage.HandleMessage = HandleMessage

return ClaimAllSeasonPassRewardMessage