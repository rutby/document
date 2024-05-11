---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 29/3/2024 上午10:49
---
local PushWorldMarchNewMessage = BaseClass("PushWorldMarchNewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.WorldMarchDataManager:WorldMarchUpdateHandle(t)
end

PushWorldMarchNewMessage.OnCreate = OnCreate
PushWorldMarchNewMessage.HandleMessage = HandleMessage

return PushWorldMarchNewMessage