--- Created by shimin
--- DateTime: 2023/7/20 17:17
--- 英雄海报兑换勋章cell

local UIHeroMetalRedemptionHeroCell = BaseClass("UIHeroMetalRedemptionHeroCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroStarCell = require "UI.UIHeroMetalRedemption.Component.UIHeroStarCell"
local UIHeroStars = require 'UI.UIHero2.Common.UIHeroStars'

local this_path = ""
local quality_bg_img_path = "ImgPosterQualityBg"
local icon_img_path = "ImgPosterQualityBg/ImgPosterIcon"
local quality_fg_img_path = "ImgPosterQualityFg"
local camp_img_path = "imgCamp"
local star_go_path = "NodeArrow"
local select_go_path = "select_go"
local num_text_path = "NumText"

function UIHeroMetalRedemptionHeroCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionHeroCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionHeroCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionHeroCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionHeroCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.quality_bg_img = self:AddComponent(UIImage, quality_bg_img_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.quality_fg_img = self:AddComponent(UIImage, quality_fg_img_path)
    self.camp_img = self:AddComponent(UIImage, camp_img_path)
    self.star_go = self:AddComponent(UIHeroStars, star_go_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.num_text = self:AddComponent(UIText, num_text_path)
end

function UIHeroMetalRedemptionHeroCell:ComponentDestroy()

end

function UIHeroMetalRedemptionHeroCell:DataDefine()
    self.param = {}
    self.callback = function(num)
        self:OnSelectNum(num)
    end
end

function UIHeroMetalRedemptionHeroCell:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionHeroCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionHeroCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionHeroCell:ReInit(param)
    self.param = param
    self.icon_img:LoadSprite(HeroUtils.GetHeroIconPath(self.param.heroId))
    self.quality_bg_img:LoadSprite(HeroUtils.GetPosterRarityPath(self.param.rarity, true, false))
    self.quality_fg_img:LoadSprite(HeroUtils.GetPosterRarityPath(self.param.rarity, false, false))
    self.camp_img:LoadSprite(HeroUtils.GetCampIconPath(self.param.camp))
    
    local starParam = {}
    starParam.showStarNum = self.param.quality
    starParam.maxStarNum = starParam.showStarNum
    self.star_go:SetData(starParam)
    self:RefreshNum()
end

function UIHeroMetalRedemptionHeroCell:OnBtnClick()
    if self.param.num > 0 then
        self:OnSelectNum(0)
    else
        --打开选择数量界面
        local param = {}
        param.callback = self.callback
        param.tabType = UIHeroMetalRedemptionTabType.HeroPage
        param.num = self.param.num
        param.count = self.param.count
        param.heroId = self.param.heroId
        param.rarity = self.param.rarity
        param.camp = self.param.camp
        param.quality = self.param.quality
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMetalRedemptionSelectCount,{ anim = true, playEffect = true}, param)
    end
end

function UIHeroMetalRedemptionHeroCell:SetSelectNum(num)
    if self.param.num ~= num then
        self.param.num = num
        self:RefreshNum()
    end
end

function UIHeroMetalRedemptionHeroCell:RefreshNum()
    if self.param.num > 0 then
        if self.param.count ~= nil then
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.num) .. "/" .. string.GetFormattedSeperatorNum(self.param.count))
        else
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.num))
        end
      
        if self.param.useSelect then
            self.select_go:SetActive(true)
        end
    else
        if self.param.count ~= nil then
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.count))
        else
            self.num_text:SetText(0)
        end
       
        if self.param.useSelect then
            self.select_go:SetActive(false)
        end
    end
end

--设置数量回调
function UIHeroMetalRedemptionHeroCell:OnSelectNum(num)
    self:SetSelectNum(num)
    if self.param.callback ~= nil then
        self.param:callback()
    end
end



return UIHeroMetalRedemptionHeroCell