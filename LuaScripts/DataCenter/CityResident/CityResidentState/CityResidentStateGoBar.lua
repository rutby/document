---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/11 10:34
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateGoBar = BaseClass("CityResidentStateGoBar", CityResidentStateBase)

local function OnEnter(self)
    local tf, fUuid = DataCenter.CityResidentManager.occupyMgr:TryOccupyFurnitureTransform(self.data.uuid, FurnitureType.BarSeat)
    if tf then
        local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
        if furnitureInfo then
            self.data:ShowTool("")
            self.data:SetAutoAnim(true)
            self.data:GoToBuildingPos(furnitureInfo.bUuid, tf.position, true)
            return
        end
    end
    
    self.data:SetState(CityResidentDefines.State.GoToIdle)
    
    -- 小人说话
    local param = {}
    param.type = CityResidentDefines.TalkTriggerType.BarNoSeat
    param.rUuid = self.data.uuid
    DataCenter.CityResidentManager:TryResidentTalk(param)
end

local function OnExit(self)
    DataCenter.CityResidentManager.occupyMgr:ReleaseOccupyFurnitureTransform(self.data.uuid)
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.State.Drink)
end

CityResidentStateGoBar.OnEnter = OnEnter
CityResidentStateGoBar.OnExit = OnExit
CityResidentStateGoBar.OnFinish = OnFinish

return CityResidentStateGoBar