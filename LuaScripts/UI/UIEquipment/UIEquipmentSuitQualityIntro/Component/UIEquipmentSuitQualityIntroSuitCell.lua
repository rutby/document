---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/6 15:16
---



local UIEquipmentSuitQualityIntroSuitCell = BaseClass('UIEquipmentSuitQualityIntroSuitCell', UIBaseContainer)
local base = UIBaseContainer

local skillText_path = "skillText"
local skillUnlock_path = "skillUnlock"
local skillUnlock_title_path = "skillUnlockTitle"
local icon_img_path = "icon"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.skillText = self:AddComponent(UITextMeshProUGUIEx, skillText_path)
    self.skillUnlock = self:AddComponent(UITextMeshProUGUIEx, skillUnlock_path)
    self.skillUnlock_title = self:AddComponent(UITextMeshProUGUIEx, skillUnlock_title_path)
    self.skillUnlock_title:SetLocalText(200571)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
end

local function ComponentDestroy(self)

end

local function SetData(self, data)
    self.data = data
    self.skillText:SetText(self.data.effect)
    self.skillUnlock:SetText(self.data.unlockStr)
    self.icon_img:LoadSprite(self.data.iconName)
end

UIEquipmentSuitQualityIntroSuitCell.OnCreate= OnCreate
UIEquipmentSuitQualityIntroSuitCell.OnDestroy = OnDestroy
UIEquipmentSuitQualityIntroSuitCell.ComponentDefine = ComponentDefine
UIEquipmentSuitQualityIntroSuitCell.ComponentDestroy = ComponentDestroy
UIEquipmentSuitQualityIntroSuitCell.SetData = SetData

return UIEquipmentSuitQualityIntroSuitCell