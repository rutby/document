---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/18 9:10
---

local PushMineCavePlunderLogMessage = BaseClass("PushMineCavePlunderLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.MineCaveManager:OnRecvNewPlunderLog(message)
end

PushMineCavePlunderLogMessage.OnCreate = OnCreate
PushMineCavePlunderLogMessage.HandleMessage = HandleMessage

return PushMineCavePlunderLogMessage