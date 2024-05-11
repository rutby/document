---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 抽奖
local LuckyRollLotteryMessage = BaseClass("LuckyRollLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId,fiveLottery,useFree)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("fiveLottery",fiveLottery)
    self.sfsObj:PutInt("useFree",useFree)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActLuckyRollInfo:UpdateRollInfo(t)
        EventManager:GetInstance():Broadcast(EventId.ActLuckyRollGetReward,t)
    end
end

LuckyRollLotteryMessage.OnCreate = OnCreate
LuckyRollLotteryMessage.HandleMessage = HandleMessage

return LuckyRollLotteryMessage