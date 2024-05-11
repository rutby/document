---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/23 10:52
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateWorkPut = BaseClass("CityResidentStateWorkPut", CityResidentStateBase)

local function OnEnter(self)
    self.data:Idle()
    self.data:PlayAnim(CityResidentDefines.AnimName.Idle)
    self.data:ShowTool("")
    self.data:WaitForFinish(1)
end

local function OnFinish(self)
    self.data:ShowTool("")
    self.data:SetState(CityResidentDefines.State.GoToWorkWayPoint)
end

CityResidentStateWorkPut.OnEnter = OnEnter
CityResidentStateWorkPut.OnFinish = OnFinish

return CityResidentStateWorkPut