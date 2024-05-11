---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/24 16:58
---
local AllianceCurShopItem = BaseClass("AllianceCurShopItem", UIBaseContainer)
local base = UIBaseContainer

local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local flag_text_path = "clickBtn/FlagGo/FlagText"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
end

-- 销毁
local function OnDestroy(self)
    self.item_quality = nil
    self.item_icon = nil
    self.flag_text = nil
    self.param =nil
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

-- 全部刷新
local function RefreshData(self,data)
    self.param = data
    self.item_quality:LoadSprite(self.param.itemColor)
    self.item_icon:LoadSprite(self.param.iconName)
    self.flag_text:SetText(self.param.itemFlag)
end

AllianceCurShopItem.OnCreate = OnCreate
AllianceCurShopItem.OnDestroy = OnDestroy
AllianceCurShopItem.OnEnable = OnEnable
AllianceCurShopItem.OnDisable = OnDisable
AllianceCurShopItem.RefreshData = RefreshData

return AllianceCurShopItem