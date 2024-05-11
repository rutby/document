---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/12/6 11:12
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateSickSleepHouse = BaseClass("CityResidentStateSickSleepHouse", CityResidentStateBase)

local function OnEnter(self)
    local fUuid, index = DataCenter.CityResidentManager.occupyMgr:TryOccupyBed(self.data.uuid)
    if fUuid ~= 0 then
        local furnitureTf = DataCenter.FurnitureObjectManager:GetTransformByFurnitureUuid(fUuid)
        if furnitureTf then
            local isOdd = (index % 2 == 1)
            local pos = furnitureTf.position
            pos.y = isOdd and 0.11 or 0.61 -- 上下铺
            local eulerAngles = furnitureTf.eulerAngles
            eulerAngles.y = eulerAngles.y - 180
            self.data:SetPos(pos)
            self.data:SetRot(Quaternion.Euler(eulerAngles.x, eulerAngles.y, eulerAngles.z))
            self.data:Idle()
            self.data:PlayAnim(CityResidentDefines.AnimName.SickSleep)
            self.fUuid = fUuid
            return
        end
    end

    self.data:SetState(CityResidentDefines.State.GoToIdle)
end

CityResidentStateSickSleepHouse.OnEnter = OnEnter

return CityResidentStateSickSleepHouse