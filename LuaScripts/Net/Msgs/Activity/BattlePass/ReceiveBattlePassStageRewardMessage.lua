---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---领取阶段奖励
local ReceiveBattlePassStageRewardMessage = BaseClass("ReceiveBattlePassStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId,level,type)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId",activityId)
    self.sfsObj:PutInt("level",level)
    self.sfsObj:PutInt("type",type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActBattlePassData:GetStageRewardHandle(t)
    end
end

ReceiveBattlePassStageRewardMessage.OnCreate = OnCreate
ReceiveBattlePassStageRewardMessage.HandleMessage = HandleMessage

return ReceiveBattlePassStageRewardMessage