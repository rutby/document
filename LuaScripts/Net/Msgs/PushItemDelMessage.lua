---
--- Created by shimin.
--- DateTime: 2021/7/29 22:15
---
local PushItemDelMessage = BaseClass("PushItemDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ItemManager:PushItemDelHandle(t)
end

PushItemDelMessage.OnCreate = OnCreate
PushItemDelMessage.HandleMessage = HandleMessage

return PushItemDelMessage