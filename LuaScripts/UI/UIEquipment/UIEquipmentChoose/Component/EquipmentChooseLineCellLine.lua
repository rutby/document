---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/16 11:28
---


local EquipmentChooseLineCellTitle = BaseClass('EquipmentChooseLineCellTitle', UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

end

local function ComponentDestroy(self)

end

local function SetData(self, data)
    self.data = data
end

EquipmentChooseLineCellTitle.OnCreate= OnCreate
EquipmentChooseLineCellTitle.OnDestroy = OnDestroy
EquipmentChooseLineCellTitle.ComponentDefine = ComponentDefine
EquipmentChooseLineCellTitle.ComponentDestroy = ComponentDestroy
EquipmentChooseLineCellTitle.SetData = SetData

return EquipmentChooseLineCellTitle