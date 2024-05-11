---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/27 18:43
---

local PushUserResidentParamMessage = BaseClass("PushUserResidentParamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleUpdateData(t)
    end
end

PushUserResidentParamMessage.OnCreate = OnCreate
PushUserResidentParamMessage.HandleMessage = HandleMessage

return PushUserResidentParamMessage