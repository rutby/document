---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 抽奖
local ActivityGiftBoxLotteryMessage = BaseClass("ActivityGiftBoxLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage

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
        DataCenter.ActGiftBoxData:GiftBoxLotteryHandle(t)
    end
end

ActivityGiftBoxLotteryMessage.OnCreate = OnCreate
ActivityGiftBoxLotteryMessage.HandleMessage = HandleMessage

return ActivityGiftBoxLotteryMessage