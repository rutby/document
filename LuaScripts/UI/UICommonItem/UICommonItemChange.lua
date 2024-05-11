--- Created by shimin.
--- DateTime: 2023/10/18 21:43
--- 通用道具改变大小类

local UICommonItemChange = BaseClass("UICommonItemChange",UIBaseContainer)
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local base = UIBaseContainer

local item_path = "UICommonItem"

function UICommonItemChange:OnCreate()
    base.OnCreate(self)
    self.item = self:AddComponent(UICommonItem, item_path)
end

function UICommonItemChange:ReInit(data)
    self.item:ReInit(data)
end

function UICommonItemChange:SetFlagActive(active)
    self.item:SetFlagActive(active)
end

function UICommonItemChange:SetItemCountActive(value)
    self.item:SetItemCountActive(value)
end

function UICommonItemChange:SetItemCount(value)
    self.item:SetItemCount(value)
end

function UICommonItemChange:SetItemCountColor(value)
    self.item:SetItemCountColor(value)
end
function UICommonItemChange:SetCheckActive(value)
    self.item:SetCheckActive(value)
end
function UICommonItemChange:SetCheckActive(value1,value2)
    self.item:SetCheckActive(value1,value2)
end
function UICommonItemChange:SetHeroTypeTipPos(value)
    self.item:SetHeroTypeTipPos(value)
end

function UICommonItemChange:GetResName()
    return self.item:GetResName()
end
function UICommonItemChange:GetPosition()
    return self.item:GetPosition()
end
function UICommonItemChange:GetIconPath()
    return self.item:GetIconPath()
end

function UICommonItemChange:SetOnClick(fun)
    return self.item.btn:SetOnClick(fun)
end

function UICommonItemChange:GetParam()
    return self.item.param
end

function UICommonItemChange:OnClickItem()
    self.item:OnBtnClick()
end

return UICommonItemChange