---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/2 10:44
---

local CitySpecialStateBase = require "DataCenter.CityResident.CitySpecialState.CitySpecialStateBase"
local CitySpecialStateSiegeBossDead = BaseClass("CitySpecialStateSiegeBossDead", CitySpecialStateBase)

local Duration = 4

local function OnEnter(self)
    self.data:Idle()
    self.data:PlayAnim("dead")
    self.data:WaitForFinish(Duration)
end

local function OnFinish(self)
    DataCenter.CitySiegeManager:DestroyBoss(self.data.zombieId)
end

CitySpecialStateSiegeBossDead.OnEnter = OnEnter
CitySpecialStateSiegeBossDead.OnFinish = OnFinish

return CitySpecialStateSiegeBossDead