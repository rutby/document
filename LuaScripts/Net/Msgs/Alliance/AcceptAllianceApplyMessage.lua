---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/11 17:51
---
local AcceptAllianceApplyMessage = BaseClass("AcceptAllianceApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,playerId)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("playerId",playerId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        if t["playerId"]~=nil then
            DataCenter.AllianceMemberDataManager:UpdateOneAllianceApply(t["playerId"],true)
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceMemberRedPoint)
    end
end
AcceptAllianceApplyMessage.OnCreate = OnCreate
AcceptAllianceApplyMessage.HandleMessage = HandleMessage
return AcceptAllianceApplyMessage