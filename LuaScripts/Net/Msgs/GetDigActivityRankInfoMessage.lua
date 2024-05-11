---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/13 18:54
--- GetDigActivityRankInfoMessage.lua


local GetDigActivityRankInfoMessage = BaseClass("GetDigActivityRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.DigActivityManager:OnRecvDigRankResp(t)
    end
end

GetDigActivityRankInfoMessage.OnCreate = OnCreate
GetDigActivityRankInfoMessage.HandleMessage = HandleMessage

return GetDigActivityRankInfoMessage