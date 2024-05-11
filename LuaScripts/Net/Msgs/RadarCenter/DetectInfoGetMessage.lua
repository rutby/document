---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 21:38
---
local DetectInfoGetMessage = BaseClass("DetectInfoGetMessage", SFSBaseMessage)
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
        DataCenter.RadarCenterDataManager:UpdateDetectEventInfo(t)
        EventManager:GetInstance():Broadcast(EventId.GetAllDetectInfo)
    end
end

DetectInfoGetMessage.OnCreate = OnCreate
DetectInfoGetMessage.HandleMessage = HandleMessage

return DetectInfoGetMessage