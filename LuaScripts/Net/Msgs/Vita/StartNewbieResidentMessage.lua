---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/13 15:54
---

local StartNewbieResidentMessage = BaseClass("StartNewbieResidentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleNewbieResident(t)
    end
end

StartNewbieResidentMessage.OnCreate = OnCreate
StartNewbieResidentMessage.HandleMessage = HandleMessage

return StartNewbieResidentMessage