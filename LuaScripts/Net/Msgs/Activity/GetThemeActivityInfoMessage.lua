---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/8/25 16:11
--- GetThemeActivityInfoMessage


local GetThemeActivityInfoMessage = BaseClass("GetThemeActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.ThemeActivityManager:UpdateNoticeRewardInfo(t)
    end
end

GetThemeActivityInfoMessage.OnCreate = OnCreate
GetThemeActivityInfoMessage.HandleMessage = HandleMessage

return GetThemeActivityInfoMessage