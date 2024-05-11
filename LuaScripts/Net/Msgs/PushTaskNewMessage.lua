---
--- Created by shimin.
--- DateTime: 2020/9/11 15:09
---
local PushTaskNewMessage = BaseClass("PushTaskNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.TaskManager:PushUpdateTaskHandle(t)
end

PushTaskNewMessage.OnCreate = OnCreate
PushTaskNewMessage.HandleMessage = HandleMessage

return PushTaskNewMessage