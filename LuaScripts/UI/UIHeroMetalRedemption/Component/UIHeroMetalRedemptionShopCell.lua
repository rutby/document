--- Created by shimin
--- DateTime: 2023/7/20 19:02
--- 英雄代币商店界面cell

local UIHeroMetalRedemptionShopCell = BaseClass("UIHeroMetalRedemptionShopCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local quality_img_path = "ImgQuality"
local icon_img_path = "ItemIcon"
local upgrade_go_path = "RotationGo"
local lv_text_path = "LvText"
local num_text_path = "NumText"

local SelectLocalPos = Vector3.New(0, -2, 0)

function UIHeroMetalRedemptionShopCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionShopCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionShopCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionShopCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionShopCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.upgrade_go = self:AddComponent(UIBaseContainer, upgrade_go_path)
    self.lv_text = self:AddComponent(UIText, lv_text_path)
    self.num_text = self:AddComponent(UIText, num_text_path)
end

function UIHeroMetalRedemptionShopCell:ComponentDestroy()
end

function UIHeroMetalRedemptionShopCell:DataDefine()
    self.param = {}
end

function UIHeroMetalRedemptionShopCell:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionShopCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionShopCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionShopCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroMetalRedemptionShopCell:Refresh()
   
end

function UIHeroMetalRedemptionShopCell:OnBtnClick()
    if self.param.callback ~= nil then
        local pos = self.btn:GetPosition()
        self.param.callback(self.param.index, pos)
    end
end

function UIHeroMetalRedemptionShopCell:SetSelect(go)
    go:SetActive(true)
    go.transform:SetParent(self.icon_img.transform)
    go:SetLocalPosition(SelectLocalPos)
    go:SetLocalScale(ResetScale)
end



return UIHeroMetalRedemptionShopCell