---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/11/10 11:58
---
local UserCancelGiveUpDesertMessage = BaseClass("UserCancelGiveUpDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, uuid,serverId)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
    self.sfsObj:PutInt("serverId",serverId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(t["errorCode"]))
    else
        DataCenter.DesertDataManager:UpdateOneDesertData(t)
        if t["uuid"]~=nil then
            local uuid = t["uuid"]
            EventManager:GetInstance():Broadcast(EventId.UserCancelDismissDesert,uuid)
            WorldDesertEffectManager:GetInstance():CheckShowDesert(uuid)
        end
    end

end

UserCancelGiveUpDesertMessage.OnCreate = OnCreate
UserCancelGiveUpDesertMessage.HandleMessage = HandleMessage

return UserCancelGiveUpDesertMessage