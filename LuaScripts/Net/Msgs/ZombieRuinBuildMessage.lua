---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/28 19:08
---

local ZombieRuinBuildMessage = BaseClass("ZombieRuinBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, stamina)
    base.OnCreate(self)

    self.sfsObj:PutLong("uuid", uuid)
    self.sfsObj:PutLong("destroyType", stamina)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    if t["errorCode"] == nil then
        DataCenter.BuildManager:HandleRuinBuilding(t)
    end
end

ZombieRuinBuildMessage.OnCreate = OnCreate
ZombieRuinBuildMessage.HandleMessage = HandleMessage

return ZombieRuinBuildMessage