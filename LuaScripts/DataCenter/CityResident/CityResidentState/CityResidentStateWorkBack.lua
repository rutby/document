---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/23 10:52
---

local CityResidentStateBase = require "DataCenter.CityResident.CityResidentState.CityResidentStateBase"
local CityResidentStateWorkBack = BaseClass("CityResidentStateWorkBack", CityResidentStateBase)

local function OnEnter(self)
    local fUuid = nil
    local tool = ""
    local career = self.data:GetCareer()
    if career == CityResidentDefines.Career.Hunter then
        local furnitureInfoList = DataCenter.FurnitureManager:GetFurnitureByFurnitureId(FurnitureType.FoodCupboard)
        if #furnitureInfoList > 0 then
            fUuid = furnitureInfoList[1].uuid
        end
        tool = "HandMeat_Lv2"
    elseif career == CityResidentDefines.Career.Sawyer then
        fUuid = self.data.residentData.fUuid
        tool = ""
    elseif career == CityResidentDefines.Career.Smith then
        fUuid = self.data.residentData.fUuid
        tool = ""
    end
    if fUuid then
        self.data:PlayAnim(CityResidentDefines.AnimName.CarryWalk)
        self.data:SetSpeed(DataCenter.CityResidentManager:GetResidentWalkSpeed())
        self.data:ShowTool(tool)
        self.data:SetAutoAnim(false)
        self.data:GoToFurniture(fUuid)
        return
    end
    
    self.data:SetState(CityResidentDefines.State.Rest)
end

local function OnFinish(self)
    self.data:SetState(CityResidentDefines.State.WorkPut)
end

CityResidentStateWorkBack.OnEnter = OnEnter
CityResidentStateWorkBack.OnFinish = OnFinish

return CityResidentStateWorkBack