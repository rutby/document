---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/24 19:27
---

local PushAlCityInfoUpdateMessage = BaseClass("PushAlCityInfoUpdateMessage", SFSBaseMessage)
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
        DataCenter.WorldAllianceCityDataManager:UpdateAllCityDataRequest()
        local infoList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.AllianceCityRecord)
        if infoList and #infoList > 0 then
            local isOpen = DataCenter.ActivityListDataManager:CheckIsSend(infoList[1])
            if isOpen then
                DataCenter.WorldAllianceCityRecordManager:CheckNeedShowRecordRed()
            end
        end
        
    end
end

PushAlCityInfoUpdateMessage.OnCreate = OnCreate
PushAlCityInfoUpdateMessage.HandleMessage = HandleMessage

return PushAlCityInfoUpdateMessage