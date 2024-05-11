---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2020/12/17 19:12
---
local MailDialogReadMessage = BaseClass("MailDialogReadMessage", SFSBaseMessage)

local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, fromUser,type)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("fromUser", fromUser);
    self.sfsObj:PutInt("type", type);
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    Logger.Log(t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    end
    EventManager:GetInstance():Broadcast(EventId.MailPush)
end

MailDialogReadMessage.OnCreate = OnCreate
MailDialogReadMessage.HandleMessage = HandleMessage

return MailDialogReadMessage