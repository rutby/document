---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/4/19 21:19
---
local PushPuzzleTaskFinish = BaseClass("PushPuzzleTaskFinish", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ActivityPuzzleDataManager:HandlePushPuzzleTaskFinish(t)
end

PushPuzzleTaskFinish.OnCreate = OnCreate
PushPuzzleTaskFinish.HandleMessage = HandleMessage

return PushPuzzleTaskFinish