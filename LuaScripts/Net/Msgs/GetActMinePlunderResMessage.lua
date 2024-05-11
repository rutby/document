---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/5/12 16:29
---
local GetActMinePlunderResMessage = BaseClass("GetActMinePlunderResMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.AllianceMineManager:SetActMineResNum(t)
        EventManager:GetInstance():Broadcast(EventId.AllianceActMineResUpdate)
    end
end

GetActMinePlunderResMessage.OnCreate = OnCreate
GetActMinePlunderResMessage.HandleMessage = HandleMessage

return GetActMinePlunderResMessage