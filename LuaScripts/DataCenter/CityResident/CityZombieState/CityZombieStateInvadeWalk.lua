---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/23 10:52
---

local CityZombieStateBase = require "DataCenter.CityResident.CityZombieState.CityZombieStateBase"
local CityZombieStateInvadeWalk = BaseClass("CityZombieStateInvadeWalk", CityZombieStateBase)

local function OnEnter(self)
    self.data:PlayAnim(CityResidentDefines.AnimName.Walk1)
    self.data:SetSpeed(DataCenter.CityResidentManager:GetZombieWalkSpeed())
    local mask = DataCenter.CityResidentManager:GetCurrentCityMask()
    local pos = WayPointUtil.GetRandomPos(mask, CityResidentDefines.WayPointFlag.Center)
    self.data:GoToPos(pos, mask, CityResidentDefines.WayPointFlag.City)
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.ZombieState.InvadeIdle)
end

CityZombieStateInvadeWalk.OnEnter = OnEnter
CityZombieStateInvadeWalk.OnFinish = OnFinish

return CityZombieStateInvadeWalk