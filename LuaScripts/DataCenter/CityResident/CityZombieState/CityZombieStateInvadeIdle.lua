---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/23 10:52
---

local CityZombieStateBase = require "DataCenter.CityResident.CityZombieState.CityZombieStateBase"
local CityZombieStateInvadeIdle = BaseClass("CityZombieStateInvadeIdle", CityZombieStateBase)

local function OnEnter(self)
    self.data:Idle()
    self.data:PlayAnim(CityResidentDefines.AnimName.Idle)
    self.data:WaitForFinish(0.5)
end

local function OnFinish(self)
    self.data:Refresh()
end

CityZombieStateInvadeIdle.OnEnter = OnEnter
CityZombieStateInvadeIdle.OnFinish = OnFinish

return CityZombieStateInvadeIdle