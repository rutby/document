---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 领取赛季周卡奖励
local ReceiveSeasonWeekCardRewardMessage = BaseClass("ReceiveSeasonWeekCardRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,activityId,type)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("type",type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActSeasonWeekCardData:ReceiveRewardHandle(t)
    end
end

ReceiveSeasonWeekCardRewardMessage.OnCreate = OnCreate
ReceiveSeasonWeekCardRewardMessage.HandleMessage = HandleMessage

return ReceiveSeasonWeekCardRewardMessage