---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/28 16:42
---
local RewardItem = BaseClass("RewardItem", UIBaseContainer)
local base = UIBaseContainer

local item_quality_path = "IconNode/UIGiftItem/clickBtn/ImgQuality"
local item_icon_path = "IconNode/UIGiftItem/clickBtn/ItemIcon"
local name_text_path = "TxtName"
local flag_path = "IconNode/UIGiftItem/clickBtn/FlagGo"
local flag_text_path = "IconNode/UIGiftItem/clickBtn/FlagGo/FlagText"
local num_txt_path = "TxtNum"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.flag_rect = self:AddComponent(UIImage,flag_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.num_txet = self:AddComponent(UITextMeshProUGUIEx,num_txt_path)
end

-- 销毁
local function OnDestroy(self)
    self.item_quality = nil
    self.item_icon = nil
    self.name_text = nil
    self.flag_text = nil
    self.flag_rect = nil
    self.param = nil
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
local function RefreshData(self,data,giftType)
    self.param = data
    self.name_text:SetText(self.param.itemName)
    self.item_quality:LoadSprite(self.param.itemColor)
    self.item_icon:LoadSprite(self.param.iconName)
    self.flag_rect:SetActive(self.param.itemFlag)
    if self.param.itemFlag then
        self.flag_text:SetText(self.param.itemFlag)
    end
    if giftType == 1 then
        if self.param.count ~= nil then
            self.num_txet:SetText("x"..self.param.count)
        end
    elseif giftType == 2 then
        self.num_txet:SetText("x"..self.param.count)
    end
end

RewardItem.OnCreate = OnCreate
RewardItem.OnDestroy = OnDestroy
RewardItem.OnEnable = OnEnable
RewardItem.OnDisable = OnDisable
RewardItem.RefreshData = RefreshData

return RewardItem