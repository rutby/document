---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/22 15:45
---
local AllianceLeaderTransMessage = BaseClass("AllianceLeaderTransMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,playerId)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("playerId", playerId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t["errorPara2"])))
    else
        local newLeaderUid = nil
        if t["alliance"]~=nil then
            newLeaderUid = t["alliance"].learderUid
            DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
        end
        if t["oldLeaderId"]~=nil then
            DataCenter.AllianceMemberDataManager:AllianceLeaderChange(t["oldLeaderId"],newLeaderUid,t["oldLeaderRank"])
        end
        
        EventManager:GetInstance():Broadcast(EventId.AllianceMember)
        UIUtil.ShowTipsId(390952) 
    end
end
AllianceLeaderTransMessage.OnCreate = OnCreate
AllianceLeaderTransMessage.HandleMessage = HandleMessage

return AllianceLeaderTransMessage