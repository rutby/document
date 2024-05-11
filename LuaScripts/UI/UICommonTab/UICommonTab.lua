---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/21 18:34
---

local UICommonTab = BaseClass("UICommonTab", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local on_path = "On"
local on_icon_path = "On/OnIcon"
local on_name_path = "On/OnName"
local off_path = "Off"
local off_icon_path = "Off/OffIcon"
local off_name_path = "Off/OffName"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.on_go = self:AddComponent(UIBaseContainer, on_path)
    self.on_icon_image = self:AddComponent(UIImage, on_icon_path)
    self.on_name_text = self:AddComponent(UITextMeshProUGUIEx, on_name_path)
    self.off_go = self:AddComponent(UIBaseContainer, off_path)
    self.off_icon_image = self:AddComponent(UIImage, off_icon_path)
    self.off_name_text = self:AddComponent(UITextMeshProUGUIEx, off_name_path)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.on_go = nil
    self.on_icon_image = nil
    self.off_go = nil
    self.off_icon_image = nil
end

local function DataDefine(self)
    self.name = ""
    self.selected = false
    self.onClick = nil
end

local function DataDestroy(self)
    self.name = nil
    self.selected = nil
    self.onClick = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function Refresh(self)
    self.on_name_text:SetText(self.name)
    self.off_name_text:SetText(self.name)
    self.on_go:SetActive(self.selected)
    self.off_go:SetActive(not self.selected)
end

local function SetName(self, name)
    self.name = name
    self:Refresh()
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

local function SetSelected(self, selected)
    self.selected = selected
    self:Refresh()
end

local function OnClick(self)
    if not self.selected and self.onClick then
        self.onClick()
    end
end

UICommonTab.OnCreate = OnCreate
UICommonTab.OnDestroy = OnDestroy
UICommonTab.OnEnable = OnEnable
UICommonTab.OnDisable = OnDisable
UICommonTab.ComponentDefine = ComponentDefine
UICommonTab.ComponentDestroy = ComponentDestroy
UICommonTab.DataDefine = DataDefine
UICommonTab.DataDestroy = DataDestroy
UICommonTab.OnAddListener = OnAddListener
UICommonTab.OnRemoveListener = OnRemoveListener

UICommonTab.Refresh = Refresh
UICommonTab.SetName = SetName
UICommonTab.SetOnClick = SetOnClick
UICommonTab.SetSelected = SetSelected

UICommonTab.OnClick = OnClick

return UICommonTab