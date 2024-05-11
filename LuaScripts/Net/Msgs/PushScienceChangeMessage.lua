---
--- Created by shimin.
--- DateTime: 2020/8/26 15:53
---
local PushScienceChangeMessage = BaseClass("PushScienceChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ScienceManager:PushScienceChangeHandle(t)
end

PushScienceChangeMessage.OnCreate = OnCreate
PushScienceChangeMessage.HandleMessage = HandleMessage

return PushScienceChangeMessage