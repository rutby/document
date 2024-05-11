---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/7/28 10:55
---
local LoginOtherMessage = BaseClass("LoginOtherMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, key)
    base.OnCreate(self)

    self.sfsObj:PutUtfString(key, key)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode == nil then
        if t["alliance"]~=nil then
            DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t,true)
			EventManager:GetInstance():Broadcast(EventId.AllianceInitOK)
        end
        if t["autoJoin"] then
            DataCenter.AllianceLeaderElectManager:UpdateAutoJoinSignal(t["autoJoin"])
        end
        if t["recommendUserSize"] then
            DataCenter.AllianceMemberDataManager:UpdateAlMemberRecommendNum(t)
        end
        if t["allianceOfficialArr"] then
            DataCenter.AllianceMemberDataManager:UpdateAlliancePosition(t)
        end
        
        DataCenter.BuildManager:CheckReplaceMain()
    end
end

LoginOtherMessage.OnCreate = OnCreate
LoginOtherMessage.HandleMessage = HandleMessage

return LoginOtherMessage