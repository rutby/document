---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/11 12:28
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateBartenderSweep = BaseClass("CityResidentStateBartenderSweep", CityResidentStateBase)

local function OnEnter(self)
    self.data:Idle()
    self.data:ShowTool("")
    self.data:PlayAnim(CityResidentDefines.AnimName.Sweep)
    local curSeg = DataCenter.VitaManager:GetCurSegment()
    if curSeg.type == VitaDefines.SegmentType.Rest then
        self.data:WaitForFinish(5)
    end
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.State.Rest)
end

CityResidentStateBartenderSweep.OnEnter = OnEnter
CityResidentStateBartenderSweep.OnFinish = OnFinish

return CityResidentStateBartenderSweep