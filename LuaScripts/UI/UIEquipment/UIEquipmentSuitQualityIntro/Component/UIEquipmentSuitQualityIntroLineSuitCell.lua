---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/6 15:16
---

local UIEquipmentSuitQualityIntroLineSuitCell = BaseClass('UIEquipmentSuitQualityIntroLineSuitCell', UIBaseContainer)
local base = UIBaseContainer
local UIEquipmentSuitQualityIntroSuitCell = require "UI.UIEquipment.UIEquipmentSuitQualityIntro.Component.UIEquipmentSuitQualityIntroSuitCell"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.cellObjList = {}
    for k = 1, EquipmentConst.EquipmentSuitQualityViewCellSuitNumPerLine do
        local cell = self:AddComponent(UIEquipmentSuitQualityIntroSuitCell, 'EquipSuitLine_'..k)
        table.insert(self.cellObjList, cell)
    end
end

local function ComponentDestroy(self)
    self.cellObjList = nil
end

local function SetData(self, dataList)
    for k, cell in ipairs(self.cellObjList) do
        local cellData = dataList[k]
        cell:SetActive(cellData ~= nil)
        if cellData ~= nil then
            cell:SetData(cellData)
        end
    end
end

UIEquipmentSuitQualityIntroLineSuitCell.OnCreate= OnCreate
UIEquipmentSuitQualityIntroLineSuitCell.OnDestroy = OnDestroy
UIEquipmentSuitQualityIntroLineSuitCell.ComponentDefine = ComponentDefine
UIEquipmentSuitQualityIntroLineSuitCell.ComponentDestroy = ComponentDestroy
UIEquipmentSuitQualityIntroLineSuitCell.SetData = SetData

return UIEquipmentSuitQualityIntroLineSuitCell