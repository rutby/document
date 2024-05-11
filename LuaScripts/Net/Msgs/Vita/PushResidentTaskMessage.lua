---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/10 17:06
---

local PushResidentTaskMessage = BaseClass("PushResidentTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleResidentTaskUpdate(t)
    end
end

PushResidentTaskMessage.OnCreate = OnCreate
PushResidentTaskMessage.HandleMessage = HandleMessage

return PushResidentTaskMessage