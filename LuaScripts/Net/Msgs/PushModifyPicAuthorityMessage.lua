---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/5 21:27
---
---
local PushModifyPicAuthorityMessage = BaseClass("PushModifyPicAuthorityMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, stationId)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    LuaEntry.Player:UpdateSendCustomHead(t)
end

PushModifyPicAuthorityMessage.OnCreate = OnCreate
PushModifyPicAuthorityMessage.HandleMessage = HandleMessage

return PushModifyPicAuthorityMessage