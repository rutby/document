---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/28 19:12
---

local FixZombieRuinBuildMessage = BaseClass("FixZombieRuinBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
    base.OnCreate(self)

    self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] == nil then
        DataCenter.BuildManager:HandleRepairBuilding(t)
    end
end

FixZombieRuinBuildMessage.OnCreate = OnCreate
FixZombieRuinBuildMessage.HandleMessage = HandleMessage

return FixZombieRuinBuildMessage