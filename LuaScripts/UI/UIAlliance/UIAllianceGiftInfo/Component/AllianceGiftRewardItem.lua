---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/8 18:41
---
local AllianceGiftRewardItem = BaseClass("AllianceGiftRewardItem", UIBaseContainer)
local base = UIBaseContainer

local item_quality_path = "ImgQuality"
local item_icon_path = "ItemIcon"
local num_text_path = "NumText"
local name_text_path = "NameText"
local flag_text_path = "FlagText"
local btn_path =""
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.btn = self:AddComponent(UIButton, btn_path)

    self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
end

-- 销毁
local function OnDestroy(self)
    self.item_quality = nil
    self.item_icon = nil
    self.num_text = nil
    self.name_text = nil
    self.flag_text = nil
    self.btn = nil
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
local function RefreshData(self,data)
    self.param = data
    self.name_text:SetText(self.param.itemName)
    self.num_text:SetText(self.param.count)
    self.item_quality:LoadSprite(self.param.itemColor)
    self.item_icon:LoadSprite(self.param.iconName)
    self.flag_text:SetText(self.param.itemFlag)
end


local function OnBtnClick(self)
end


AllianceGiftRewardItem.OnCreate = OnCreate
AllianceGiftRewardItem.OnDestroy = OnDestroy
AllianceGiftRewardItem.OnBtnClick = OnBtnClick
AllianceGiftRewardItem.OnEnable = OnEnable
AllianceGiftRewardItem.OnDisable = OnDisable
AllianceGiftRewardItem.RefreshData = RefreshData

return AllianceGiftRewardItem