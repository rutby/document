---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 军备日历
local GetHeroEventCalendarMessage = BaseClass("GetHeroEventCalendarMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,activityId)
    base.OnCreate(self)
    if activityId ~= nil then
        self.sfsObj:PutUtfString("activityId", activityId)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ActPersonalArmsInfo:SetCalendar(t)
    end
end

GetHeroEventCalendarMessage.OnCreate = OnCreate
GetHeroEventCalendarMessage.HandleMessage = HandleMessage

return GetHeroEventCalendarMessage