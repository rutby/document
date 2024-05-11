---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/5/11 11:00
---

local EquipmentToggleBtn = BaseClass('EquipmentToggleBtn', UIBaseContainer)
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
    self.toogle = self:AddComponent(UIToggle, "")
    self.toogle:SetOnValueChanged(function(tf)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        if tf then
            self:OnToggleClick()
        end
    end)
    self.choose = self:AddComponent(UIBaseContainer, "Choose")
    self.redPoint = self:AddComponent(UIBaseContainer, "ImgWarn")
    self.redPoint:SetActive(false)
    self.unselectName = self:AddComponent(UITextMeshProUGUIEx, "unselectName")
    self.selectName = self:AddComponent(UITextMeshProUGUIEx, "Choose/selectName")
end

local function ComponentDestroy(self)

end

local function SetData(self, data)
    self.data = data
    self:RefreshView()
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnToggleClick(self)
    EventManager:GetInstance():Broadcast(EventId.EquipmentToggleClick, self.data.index)
end

local function SetSelect(self, selectIndex)
    self.choose:SetActive(self.data.index == selectIndex)
    self.selectName:SetActive(self.data.index == selectIndex)
    self.unselectName:SetActive(self.data.index ~= selectIndex)
end

local function RefreshView(self)
    self.unselectName:SetLocalText(self.data.unselectName)
    self.selectName:SetLocalText(self.data.selectName)
end

EquipmentToggleBtn.OnCreate= OnCreate
EquipmentToggleBtn.OnDestroy = OnDestroy
EquipmentToggleBtn.ComponentDefine = ComponentDefine
EquipmentToggleBtn.ComponentDestroy = ComponentDestroy
EquipmentToggleBtn.SetData = SetData
EquipmentToggleBtn.OnAddListener = OnAddListener
EquipmentToggleBtn.OnRemoveListener = OnRemoveListener
EquipmentToggleBtn.OnToggleClick = OnToggleClick
EquipmentToggleBtn.SetSelect = SetSelect
EquipmentToggleBtn.RefreshView = RefreshView

return EquipmentToggleBtn