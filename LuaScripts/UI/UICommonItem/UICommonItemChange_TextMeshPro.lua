--- Created by shimin.
--- DateTime: 2023/10/18 21:43
--- 通用道具改变大小类

local UICommonItemChange_TextMeshPro = BaseClass("UICommonItemChange_TextMeshPro",UIBaseContainer)
local UICommonItem = require "UI.UICommonItem.UICommonItem_TextMeshPro"
local base = UIBaseContainer

local item_path = "UICommonItem"

function UICommonItemChange_TextMeshPro:OnCreate()
    base.OnCreate(self)
    self.item = self:AddComponent(UICommonItem, item_path)
end

function UICommonItemChange_TextMeshPro:ReInit(data)
    self.item:ReInit(data)
end

function UICommonItemChange_TextMeshPro:SetFlagActive(active)
    self.item:SetFlagActive(active)
end

function UICommonItemChange_TextMeshPro:SetFlagActive(value)
    self.item:SetItemCountActive(value)
end

function UICommonItemChange_TextMeshPro:SetItemCount(value)
    self.item:SetItemCount(value)
end

function UICommonItemChange_TextMeshPro:SetItemCountColor(value)
    self.item:SetItemCountColor(value)
end
function UICommonItemChange_TextMeshPro:SetCheckActive(value)
    self.item:SetCheckActive(value)
end
function UICommonItemChange_TextMeshPro:SetHeroTypeTipPos(value)
    self.item:SetHeroTypeTipPos(value)
end

function UICommonItemChange_TextMeshPro:GetResName()
    return self.item:GetResName()
end
function UICommonItemChange_TextMeshPro:GetPosition()
    return self.item:GetPosition()
end
function UICommonItemChange_TextMeshPro:GetIconPath()
    return self.item:GetIconPath()
end

function UICommonItemChange_TextMeshPro:SetOnClick(fun)
    return self.item.btn:SetOnClick(fun)
end

function UICommonItemChange_TextMeshPro:GetParam()
    return self.item.param
end

return UICommonItemChange_TextMeshPro