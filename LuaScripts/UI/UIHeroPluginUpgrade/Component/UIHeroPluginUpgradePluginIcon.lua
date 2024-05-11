--- Created by shimin
--- DateTime: 2023/6/8 18:29
--- 英雄插件图标

local UIHeroPluginUpgradePluginIcon = BaseClass("UIHeroPluginUpgradePluginIcon", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local quality_img_path = "QualityBg"
local red_dot_path = "PluginBtnRed"
local camp_img_path = "CampImg"
local level_text_path = "Text_lv"
local score_bg_path = "scoreBg"
local score_text_path = "scoreBg/score_text"

function UIHeroPluginUpgradePluginIcon:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradePluginIcon:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradePluginIcon:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradePluginIcon:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradePluginIcon:ComponentDefine()
    self.plugin_btn_red = self:AddComponent(UIBaseContainer, red_dot_path)
    self.camp_img = self:AddComponent(UIImage, camp_img_path)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    self.level_text = self:AddComponent(UIText, level_text_path)
    self.score_bg = self:AddComponent(UIBaseContainer, score_bg_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.btn = self:AddComponent(UIButton, this_path)
    if self.btn ~= nil then
        self.btn:SetOnClick(function()
            self:OnBtnClick()
        end)
    end
end

function UIHeroPluginUpgradePluginIcon:ComponentDestroy()
end

function UIHeroPluginUpgradePluginIcon:DataDefine()
    self.param = {}
end

function UIHeroPluginUpgradePluginIcon:DataDestroy()
    self.param = {}
end

function UIHeroPluginUpgradePluginIcon:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradePluginIcon:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradePluginIcon:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginUpgradePluginIcon:Refresh()
    self.level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.param.level)
    self.quality_img:LoadSprite(DataCenter.HeroPluginManager:GetQualityIconName(self.param.level))
    self.camp_img:LoadSprite(DataCenter.HeroPluginManager:GetCampIconName(self.param.camp))
    if self.param.score == nil then
        self.score_bg:SetActive(false)
    else
        self.score_bg:SetActive(true)
        self.score_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_SCORE_WITH, string.GetFormattedSeperatorNum(self.param.score))
    end
end

function UIHeroPluginUpgradePluginIcon:OnBtnClick()
    if self.param.callback ~= nil then
        self.param.callback()
    end
end

return UIHeroPluginUpgradePluginIcon