---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/12/21 11:13
---

local UIHeroQualityUpItem = BaseClass("UIHeroQualityUpItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local this_path = ""
local item_path = "UICommonItem"
local select_path = "Select"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
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
    self.item = self:AddComponent(UICommonItem, item_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.onClick = nil
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    local param = {}
    param.rewardType = RewardType.GOODS
    param.itemId = data.itemId
    self.item:ReInit(param)
end

local function SetSelected(self, selected)
    self.select_go:SetActive(selected)
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

local function OnClick(self)
    if self.onClick then
        self.onClick()
    end
end

UIHeroQualityUpItem.OnCreate = OnCreate
UIHeroQualityUpItem.OnDestroy = OnDestroy
UIHeroQualityUpItem.OnEnable = OnEnable
UIHeroQualityUpItem.OnDisable = OnDisable
UIHeroQualityUpItem.ComponentDefine = ComponentDefine
UIHeroQualityUpItem.ComponentDestroy = ComponentDestroy
UIHeroQualityUpItem.DataDefine = DataDefine
UIHeroQualityUpItem.DataDestroy = DataDestroy
UIHeroQualityUpItem.OnAddListener = OnAddListener
UIHeroQualityUpItem.OnRemoveListener = OnRemoveListener

UIHeroQualityUpItem.SetData = SetData
UIHeroQualityUpItem.SetSelected = SetSelected
UIHeroQualityUpItem.SetOnClick = SetOnClick
UIHeroQualityUpItem.OnClick = OnClick

return UIHeroQualityUpItem