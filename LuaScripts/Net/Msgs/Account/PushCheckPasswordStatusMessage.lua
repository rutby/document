---
--- Created by zzl
--- DateTime: 2021/12/06 17:09
---
local PushCheckPasswordStatusMessage = BaseClass("PushCheckPasswordStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    EventManager:GetInstance():Broadcast(EventId.PinInputClose)
end

PushCheckPasswordStatusMessage.OnCreate = OnCreate
PushCheckPasswordStatusMessage.HandleMessage = HandleMessage

return PushCheckPasswordStatusMessage