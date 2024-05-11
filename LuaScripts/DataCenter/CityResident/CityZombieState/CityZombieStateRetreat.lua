---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/29 18:57
---

local CityZombieStateBase = require "DataCenter.CityResident.CityZombieState.CityZombieStateBase"
local CityZombieStateRetreat = BaseClass("CityZombieStateRetreat", CityZombieStateBase)

local function OnEnter(self)
    self.data.target = nil
    self.data.targetBUuid = 0
    self.data:PlayAnim(CityResidentDefines.AnimName.Walk1)
    self.data:SetSpeed(DataCenter.CityResidentManager:GetZombieRetreatSpeed())
    local curPos = self.data:GetPos()
    local mask = DataCenter.CityResidentManager:GetCurrentCityMask()
    local wayPoint = WayPointUtil.GetNearWayPoint(curPos, mask, CityResidentDefines.WayPointFlag.Invade)
    self.data.spawnId = tonumber(WayPointUtil.GetWayPointArg(wayPoint, "spawnId"))
    self.data:GoToPos(wayPoint.pos, mask, CityResidentDefines.WayPointFlag.All)
    
    local lifetime = DataCenter.CityResidentManager:GetZombieRetreatLifetime()
    self.data:SetLifetime(lifetime)
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.ZombieState.WanderWalk)
end

CityZombieStateRetreat.OnEnter = OnEnter
CityZombieStateRetreat.OnFinish = OnFinish

return CityZombieStateRetreat