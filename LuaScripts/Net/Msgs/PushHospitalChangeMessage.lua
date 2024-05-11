---
--- Created by shimin.
--- DateTime: 2020/8/18 20:45
---
local PushHospitalChangeMessage = BaseClass("PushHospitalChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.HospitalManager:PushHospitalChangeHandle(t)
end

PushHospitalChangeMessage.OnCreate = OnCreate
PushHospitalChangeMessage.HandleMessage = HandleMessage

return PushHospitalChangeMessage