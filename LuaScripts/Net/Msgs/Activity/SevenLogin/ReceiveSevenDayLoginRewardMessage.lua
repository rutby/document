---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 领取主题活动奖励
local ReceiveSevenDayLoginRewardMessage = BaseClass("ReceiveSevenDayLoginRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,activityId,day)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("day",day)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActSevenLoginData:GetRewardState(t)
    end
end

ReceiveSevenDayLoginRewardMessage.OnCreate = OnCreate
ReceiveSevenDayLoginRewardMessage.HandleMessage = HandleMessage

return ReceiveSevenDayLoginRewardMessage