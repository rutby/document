---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/17 14:44
---
local base = SFSBaseMessage
local MigrateActivityInfoMessage = BaseClass("MigrateActivityInfoMessage", base)
local function OnCreate(self)
    base.OnCreate(self)
end
local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        EventManager:GetInstance():Broadcast(EventId.RefreshMigrateInfo,t)
    end
end

MigrateActivityInfoMessage.OnCreate = OnCreate
MigrateActivityInfoMessage.HandleMessage = HandleMessage

return MigrateActivityInfoMessage