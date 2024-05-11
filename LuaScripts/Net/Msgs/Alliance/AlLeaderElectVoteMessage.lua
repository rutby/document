---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/7 19:21
---AlLeaderElectVoteMessage


local AlLeaderElectVoteMessage = BaseClass("AlLeaderElectVoteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("playerUid", uid);
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.AlLeaderElectManager:OnRecvVoteResult(t)
        EventManager:GetInstance():Broadcast(EventId.UpdateAlElectRed)
    end
end

AlLeaderElectVoteMessage.OnCreate = OnCreate
AlLeaderElectVoteMessage.HandleMessage = HandleMessage

return AlLeaderElectVoteMessage