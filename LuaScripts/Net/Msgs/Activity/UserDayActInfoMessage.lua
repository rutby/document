---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 七日请求信息
local UserDayActInfoMessage = BaseClass("UserDayActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
        return
    end
    DataCenter.ActivityListDataManager:RefreshSevenDayActData(message)
end

UserDayActInfoMessage.OnCreate = OnCreate
UserDayActInfoMessage.HandleMessage = HandleMessage

return UserDayActInfoMessage