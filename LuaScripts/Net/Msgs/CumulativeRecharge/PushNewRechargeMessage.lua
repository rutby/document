---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---有新的累充活动推送
local PushNewRechargeMessage = BaseClass("PushNewRechargeMessage", SFSBaseMessage)
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
    DataCenter.CumulativeRechargeManager:PushNewRechargeHandle(t)
    DataCenter.KeepPayManager:HandleNew(t)
end

PushNewRechargeMessage.OnCreate = OnCreate
PushNewRechargeMessage.HandleMessage = HandleMessage

return PushNewRechargeMessage