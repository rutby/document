---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/11 18:01
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateBartenderGoSweep = BaseClass("CityResidentStateBartenderGoSweep", CityResidentStateBase)

local function OnEnter(self)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.DS_BAR)
    if buildData and buildData.level > 0 then
        local wayPoint = WayPointUtil.GetOneWayPointByMask(buildData.uuid, CityResidentDefines.WayPointFlag.Special)
        if wayPoint then
            self.data:ShowTool("")
            self.data:SetAutoAnim(true)
            self.data:GoToBuildingPos(buildData.uuid, wayPoint.pos, false)
            return
        end
    end

    self.data:SetState(CityResidentDefines.State.GoToIdle)
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.State.BartenderSweep)
end

CityResidentStateBartenderGoSweep.OnEnter = OnEnter
CityResidentStateBartenderGoSweep.OnFinish = OnFinish

return CityResidentStateBartenderGoSweep