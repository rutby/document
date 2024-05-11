---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/1/11 15:34
---

local UIPopupPackageCell = BaseClass("UIPopupPackageCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local item_path = "Item"
local name_path = "Name"
local count_path = "Count"

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
    self.item = self:AddComponent(UICommonItemChange, item_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.count_text = self:AddComponent(UITextMeshProUGUIEx, count_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, reward)
    self.item:ReInit(reward)
    self.item:SetItemCount("")
    if reward.itemName then
        self.name_text:SetLocalText(reward.itemName)
    else
        self.name_text:SetText(DataCenter.RewardManager:GetNameByType(reward.rewardType, reward.itemId))
    end
    self.count_text:SetText("x" .. string.GetFormattedSeperatorNum(reward.count))
end

UIPopupPackageCell.OnCreate = OnCreate
UIPopupPackageCell.OnDestroy = OnDestroy
UIPopupPackageCell.OnEnable = OnEnable
UIPopupPackageCell.OnDisable = OnDisable
UIPopupPackageCell.ComponentDefine = ComponentDefine
UIPopupPackageCell.ComponentDestroy = ComponentDestroy
UIPopupPackageCell.DataDefine = DataDefine
UIPopupPackageCell.DataDestroy = DataDestroy
UIPopupPackageCell.OnAddListener = OnAddListener
UIPopupPackageCell.OnRemoveListener = OnRemoveListener

UIPopupPackageCell.SetData = SetData

return UIPopupPackageCell