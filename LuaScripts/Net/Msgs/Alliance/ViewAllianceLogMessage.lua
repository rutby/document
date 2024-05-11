---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 
--- DateTime: 
--- 查看联盟日志
local ViewAllianceLogMessage = BaseClass("ViewAllianceLogMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,time,isAllianceCity)
    base.OnCreate(self)
    self.sfsObj:PutLong ("time", time)
    self.sfsObj:PutBool ("isAllianceCity",isAllianceCity)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
        return
    end
    local isAllianceCity = message["isAllianceCity"]
    if isAllianceCity~=nil and isAllianceCity == true then
        DataCenter.AllianceCityLogManager:UpdateAllianceLogData(message["logs"])
    else
        DataCenter.AllianceMainManager:UpdateAllianceLogData(message["logs"])
    end
    
end

ViewAllianceLogMessage.OnCreate = OnCreate
ViewAllianceLogMessage.HandleMessage = HandleMessage

return ViewAllianceLogMessage