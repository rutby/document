---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/8/18 19:16
---
local IDCardAuthenticateMessage = BaseClass("IDCardAuthenticateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,name, IDCard)
    base.OnCreate(self)
    self.sfsObj:PutInt("type",1)
    self.sfsObj:PutUtfString("name",name)
    self.sfsObj:PutUtfString("IDCard",IDCard)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        --UIUtil.ShowTipsId(errCode)
        EventManager:GetInstance():Broadcast(EventId.IDCardCheckFail)
    else
        EventManager:GetInstance():Broadcast(EventId.IDCardCheckSuccess)
    end
end

IDCardAuthenticateMessage.OnCreate = OnCreate
IDCardAuthenticateMessage.HandleMessage = HandleMessage

return IDCardAuthenticateMessage