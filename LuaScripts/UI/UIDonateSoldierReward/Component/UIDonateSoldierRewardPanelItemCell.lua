local UIDonateSoldierRewardPanelItemCell = BaseClass("UIDonateSoldierRewardPanelItemCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local mask_path = "mask"
local effect_path = "effect"
local checkmark_path = "checkmark"
local item_path = "item_container/item"
function UIDonateSoldierRewardPanelItemCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UIDonateSoldierRewardPanelItemCell:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRewardPanelItemCell:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRewardPanelItemCell:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRewardPanelItemCell:ComponentDefine()
    self.mask = self:AddComponent(UIBaseContainer, mask_path)
    self.effect = self:AddComponent(UIBaseContainer, effect_path)
    self.checkmark = self:AddComponent(UIBaseContainer, checkmark_path)
    self.item = self:AddComponent(UICommonItem,item_path)
end

function UIDonateSoldierRewardPanelItemCell:ComponentDestroy()
    self.effect = nil
    self.checkmark = nil
end

function UIDonateSoldierRewardPanelItemCell:SetData(data, showMask, showEffect, showCheckmark)
    self.mask:SetActive(showMask)
    self.effect:SetActive(showEffect)
    self.checkmark:SetActive(showCheckmark)
    self.item:ReInit(data)
end

return UIDonateSoldierRewardPanelItemCell