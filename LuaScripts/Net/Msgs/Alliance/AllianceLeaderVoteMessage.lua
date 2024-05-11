---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/10/25 12:10
---
local AllianceLeaderVoteMessage = BaseClass("AllianceLeaderVoteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization


local function OnCreate(self, uid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("candidateUid", uid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.AllianceBaseDataManager:UpdateLeaderVoteStatus(t.vote)
        DataCenter.AllianceLeaderElectManager:UpdateOneCandidateInfo(t.candidateInfo)
        EventManager:GetInstance():Broadcast(EventId.AlLeaderVoteStatusChange)
    end
end

AllianceLeaderVoteMessage.OnCreate = OnCreate
AllianceLeaderVoteMessage.HandleMessage = HandleMessage

return AllianceLeaderVoteMessage