---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/6 15:14
---


local UIEquipmentSuitQualityIntroLineCellTitle = BaseClass('UIEquipmentSuitQualityIntroLineCellTitle', UIBaseContainer)
local base = UIBaseContainer

local name_path = "TitleText"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
end

local function ComponentDestroy(self)

end

local function SetData(self, data)
    self.data = data
    self.name:SetLocalText(self.data.title, "")
end

UIEquipmentSuitQualityIntroLineCellTitle.OnCreate= OnCreate
UIEquipmentSuitQualityIntroLineCellTitle.OnDestroy = OnDestroy
UIEquipmentSuitQualityIntroLineCellTitle.ComponentDefine = ComponentDefine
UIEquipmentSuitQualityIntroLineCellTitle.ComponentDestroy = ComponentDestroy
UIEquipmentSuitQualityIntroLineCellTitle.SetData = SetData

return UIEquipmentSuitQualityIntroLineCellTitle