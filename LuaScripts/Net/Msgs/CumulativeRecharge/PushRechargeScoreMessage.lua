---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---积分变化推送
local PushRechargeScoreMessage = BaseClass("PushRechargeScoreMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end
    DataCenter.CumulativeRechargeManager:PushRechargeScoreHandle(t)
    DataCenter.KeepPayManager:HandleScore(t)
end

PushRechargeScoreMessage.OnCreate = OnCreate
PushRechargeScoreMessage.HandleMessage = HandleMessage

return PushRechargeScoreMessage