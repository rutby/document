---
--- Created by shimin.
--- DateTime: 2020/9/11 15:10
---
local PushTaskCompleteMessage = BaseClass("PushTaskCompleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.TaskManager:PushUpdateTaskHandle(t)
end

PushTaskCompleteMessage.OnCreate = OnCreate
PushTaskCompleteMessage.HandleMessage = HandleMessage

return PushTaskCompleteMessage