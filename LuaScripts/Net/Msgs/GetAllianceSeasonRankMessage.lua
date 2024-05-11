---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/2/7 14:14
---
local GetAllianceSeasonRankMessage = BaseClass("GetAllianceSeasonRankMessage", SFSBaseMessage)
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
        DataCenter.AllianceBaseDataManager:SetAllianceForceData(t)
        EventManager:GetInstance():Broadcast(EventId.AllianceForceRankUpdate)
    end

end

GetAllianceSeasonRankMessage.OnCreate = OnCreate
GetAllianceSeasonRankMessage.HandleMessage = HandleMessage

return GetAllianceSeasonRankMessage