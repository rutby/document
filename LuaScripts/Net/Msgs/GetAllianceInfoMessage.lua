---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/8/9 21:49
---
local GetAllianceInfoMessage = BaseClass("GetAllianceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,allianceId)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("allianceId",allianceId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.AllianceTempListManager:RefreshAllianceData(t)
        EventManager:GetInstance():Broadcast(EventId.SearchAllianceSuccess)
    end

end

GetAllianceInfoMessage.OnCreate = OnCreate
GetAllianceInfoMessage.HandleMessage = HandleMessage

return GetAllianceInfoMessage