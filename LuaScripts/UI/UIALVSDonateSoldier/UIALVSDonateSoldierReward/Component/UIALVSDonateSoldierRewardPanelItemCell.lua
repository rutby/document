local UIDonateSoldierRewardPanelItemCell = BaseClass("UIDonateSoldierRewardPanelItemCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"


local item_container_path = "item_container"
local mask_path = "mask"
local effect_path = "effect"
local checkmark_path = "checkmark"

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
    self.item_container = self:AddComponent(UIBaseContainer, item_container_path)
    self.mask = self:AddComponent(UIBaseContainer, mask_path)
    self.effect = self:AddComponent(UIBaseContainer, effect_path)
    self.checkmark = self:AddComponent(UIBaseContainer, checkmark_path)
    

end

function UIDonateSoldierRewardPanelItemCell:ComponentDestroy()
    self.item_container:RemoveComponents(UICommonItem)
    self.item_container = nil
    self.effect = nil
    self.checkmark = nil
end

function UIDonateSoldierRewardPanelItemCell:SetData(data, showMask, showEffect, showCheckmark)


    self.mask:SetActive(showMask)
    self.effect:SetActive(showEffect)
    self.checkmark:SetActive(showCheckmark)
    
    self:GameObjectInstantiateAsync(UIAssets.UICommonItem, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject

        go:SetActive(true)
        go.transform:SetParent(self.item_container.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:SetAsLastSibling()
        go.transform:Set_localPosition(-75, 75, 0)

        local nameStr = "UIDonateSoldierRewardPanelItemCell"
        go.name = nameStr

        local resComp = self.item_container:AddComponent(UICommonItem, nameStr)
        resComp:ReInit(data)
    end)
end

return UIDonateSoldierRewardPanelItemCell