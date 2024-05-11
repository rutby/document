---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 请求VIP最新状态数据
local VipInfoMessage = BaseClass("VipInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    local errCode =  message["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        if message["vipInfo"] ~= nil then
            DataCenter.VIPManager:UpdateVipInfo(message["vipInfo"],false)
            EventManager:GetInstance():Broadcast(EventId.VipDataRefresh)
        end
    end
end

VipInfoMessage.OnCreate = OnCreate
VipInfoMessage.HandleMessage = HandleMessage

return VipInfoMessage