---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/8/2 10:05
---
local GetEdenMarchSignalPointMessage = BaseClass("GetEdenMarchSignalPointMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,uid,worldId,serverId)
    base.OnCreate(self)
    self.sfsObj:PutInt("worldId",worldId)
    self.sfsObj:PutInt("serverId",serverId)
    self.sfsObj:PutUtfString("uid",uid)
end
local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        EventManager:GetInstance():Broadcast(EventId.EdenMarchSignalPoint,t)
    end
end

GetEdenMarchSignalPointMessage.OnCreate = OnCreate
GetEdenMarchSignalPointMessage.HandleMessage = HandleMessage

return GetEdenMarchSignalPointMessage