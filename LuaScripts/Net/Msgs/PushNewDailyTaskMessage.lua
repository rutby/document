---
--- Created by shimin.
--- DateTime: 2020/9/11 19:03
---
local PushNewDailyTaskMessage = BaseClass("PushNewDailyTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    --DataCenter.DailyTaskManager:PushNewDailyTaskHandle(t)
end

PushNewDailyTaskMessage.OnCreate = OnCreate
PushNewDailyTaskMessage.HandleMessage = HandleMessage

return PushNewDailyTaskMessage