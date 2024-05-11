---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/18 21:44
---

local UserLevelUpResidentMessage = BaseClass("UserLevelUpResidentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] == nil then
        DataCenter.VitaManager:HandleEffectChange(t)
    end
end

UserLevelUpResidentMessage.OnCreate = OnCreate
UserLevelUpResidentMessage.HandleMessage = HandleMessage

return UserLevelUpResidentMessage