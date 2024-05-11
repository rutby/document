--- Created by shimin
--- DateTime: 2023/6/9 19:29
--- 英雄插件解锁界面

local UIHeroPluginUnlockView = BaseClass("UIHeroPluginUnlockView", UIBaseView)
local base = UIBaseView

local title_text_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local panel_btn_path = "UICommonRewardPopUp/Panel"
local quality_img_path = "Root/UIHeroPluginBtn/QualityBg"
local camp_img_path = "Root/UIHeroPluginBtn/CampImg"
local level_text_path = "Root/UIHeroPluginBtn/Text_lv"

local Level = 1

function UIHeroPluginUnlockView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginUnlockView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    self.camp_img = self:AddComponent(UIImage, camp_img_path)
    self.level_text = self:AddComponent(UIText, level_text_path)
end

function UIHeroPluginUnlockView:ComponentDestroy()
end

function UIHeroPluginUnlockView:DataDefine()
    self.campType = 0
end

function UIHeroPluginUnlockView:DataDestroy()
    self.campType = 0
end

function UIHeroPluginUnlockView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUnlockView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUnlockView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUnlockView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUnlockView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUnlockView:ReInit()
    self.campType = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.CONGRATULATION_REWARD_GET)
    self:Refresh()
end

function UIHeroPluginUnlockView:Refresh()
    self.quality_img:LoadSprite(DataCenter.HeroPluginManager:GetQualityIconName(Level))
    self.camp_img:LoadSprite(DataCenter.HeroPluginManager:GetCampIconName(self.campType))
    self.level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, Level)
end

return UIHeroPluginUnlockView