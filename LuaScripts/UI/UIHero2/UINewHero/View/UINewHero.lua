---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/10/21 4:09 PM
---
--- 新英雄展示页

local UINewHero = BaseClass("UINewHero", UIBaseView)
local base = UIBaseView

local UIHeroInfoLeft = require "UI.UIHero2.UIHeroInfo.Component.UIHeroInfoLeft"
local UINewHeroDetail = require "UI.UIHero2.UINewHero.Component.UINewHeroDetail"

local CloseTime = 1.8

local Tabs = {
    Detail = 1,
    Story = 2
}

local RarityColor =
{
    [1] = "orange",
    [2] = "purple",
    [3] = "blue",
    [4] = "green",
}

local RarityEff =
{
    [HeroColor.ORANGE] = "Ani/Eff_UI_Newhero",
    [HeroColor.PURPLE] = "Ani/Eff_UI_Newhero_zi",
    [HeroColor.BLUE] = "Ani/Eff_UI_Newhero_lan",
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:OnOpen()
end

local function OnDestroy(self)
    self.tagDescList = nil

    if self.bgModel ~= nil then
        self.bgModel:Destroy()
        self.bgModel = nil
    end

    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData ~= nil then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.CloseNewHero, tostring(heroData.heroId))
    end
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    local btnClose = self:AddComponent(UIButton, "Ani/Panel")
    btnClose:SetOnClick(function()
        if self.canClose then
            self.ctrl:CloseSelf()
        end
    end)
    self.bg_image = self:AddComponent(UIImage, "Ani/Bg")
    self.bg2_image = self:AddComponent(UIImage, "Ani/Root/NodeHeroInfo/Bg2")
    self.bg3_image = self:AddComponent(UIImage, "Ani/Root/NodeHeroInfo/Banner/Bg3")
    self.bg4_image = self:AddComponent(UIImage, "Ani/Root/NodeHeroInfo/Banner/Bg4")
    self.nodeRoot    = self:AddComponent(UIBaseContainer, 'Ani/Root')
    self.hero_image = self:AddComponent(UIImage, "Ani/Root/NodeHeroInfo/HeroMask/HeroImage")
    self.hero_spine = self.transform:Find("Ani/Root/NodeHeroInfo/HeroMask/HeroSpine"):GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
    self.hero_spine_rect_go = self:AddComponent(UIBaseContainer, "Ani/Root/NodeHeroInfo/HeroMask/HeroSpineRect")
    self.pages = {}
    self.pages[Tabs.Detail] = self:AddComponent(UINewHeroDetail, "Ani/Root/PageRoot/PageDetail")
    self.tabButtons = {}
    self.tabButtons[Tabs.Detail] = self:AddComponent(UIButton, "Ani/Root/PageRoot/TabContent/BtnDetail")
    for k, v in pairs(self.tabButtons) do
        v:SetOnClick(function ()
            self:SwitchTab(k)
        end)
    end
    
    self.componentLeft =self:AddComponent(UIHeroInfoLeft, "Ani/Root/NodeHeroInfo")
    self.imgNew      = self:AddComponent(UIBaseContainer, 'Ani/Root/NodeHeroInfo/ImgNewHeroBg')
    
    self.textTip = self:AddComponent(UITextMeshProUGUIEx, 'Ani/Root/NodeCloseTip/TextTip')
    self.textTip:SetLocalText(129074)

    self.nodePower       = self:AddComponent(UIBaseContainer, 'Ani/Root/ImgPowerBg')
    self.textPower       = self:AddComponent(UITextMeshProUGUIEx, 'Ani/Root/ImgPowerBg/TextPower')
    self.pageRoot = self:AddComponent(UIBaseContainer, "Ani/Root/PageRoot")
    self.nodeRoot.transform:Set_localScale(1, 1, 1)
    self.click_text = self:AddComponent(UITextMeshProUGUIEx, "Ani/clickText")
    self.click_text:SetLocalText(321366) -- 点击任意位置关闭
    self.camp_image = self:AddComponent(UIImage, "Ani/Root/NodeHeroInfo/Banner_Text/NodeTag/ImgCampBg/ImgCamp")
    self.camp_text = self:AddComponent(UITextMeshProUGUIEx, "Ani/Root/NodeHeroInfo/Banner_Text/NodeTag/ImgCampBg/TextCampName")
end

local function ComponentDestroy(self)
    self.componentLeft = nil
    self.pageSkill = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    
    pcall(function()
        CS.SceneManager.World:DisablePostProcess()
    end)
    
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, false)
    self.canClose = false
    self.click_text:SetActive(false)
    self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.canClose = true
        self.click_text:SetActive(true)
    end, CloseTime)
end

local function OnDisable(self)
    pcall(function()
        CS.SceneManager.World:EnablePostProcess()
    end)
    
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, true)
    if self.spinePath then
        CommonUtil.UnloadAsset(self.spinePath, "UINewHeroSpine")
    end

    if self.closeTimer then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end
    
    base.OnDisable(self)
end

local function RefreshHeroInfo(self)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local heroId = heroData.heroId
    local quality = heroData.quality
    local camp = heroData.camp

    local power = HeroUtils.GetHeroPower(heroData)
    self.textPower:SetText(string.GetFormattedSeperatorNum(power))
    self.componentLeft:InitData(heroId, quality, camp, self.heroUuid)
    
    local campName = HeroUtils.GetCampNameAndDesc(camp)
    self.camp_image:LoadSprite(string.format(LoadPath.UITroopsNew, "ui_camp_" .. camp))
    self.camp_text:SetText(campName)
    
    for _, v in pairs(self.pages) do
        v:InitData(self.heroUuid)
    end
end

local function OnOpen(self)
    local heroUuid, onClose = self:GetUserData()
    self.heroUuid = heroUuid
    self.ctrl.onClose = onClose
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    
    self.hero_image:SetActive(false)
    self.hero_spine.gameObject:SetActive(false)
    
    self.hero_image:LoadSprite(HeroUtils.GetHeroIconPath(heroData.heroId, true))
    self.spinePath = HeroUtils.GetSpinePath(heroData.heroId)
    if self.spinePath then
        CommonUtil.LoadAsset(self.spinePath, "UINewHeroSpine", typeof(CS.Spine.Unity.SkeletonDataAsset), function(asset)
            if asset then
                self.hero_spine.gameObject:SetActive(true)
                self.hero_spine.skeletonDataAsset = asset
                self.hero_spine:Initialize(true)
                self.hero_spine:MatchRectTransformWithBounds()
                local size = self.hero_spine:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta
                local toSize = self.hero_spine_rect_go.rectTransform.sizeDelta
                local scale = toSize.y / size.y
                self.hero_spine.rectTransform.localScale = Vector3.one * scale
                local animations = asset:GetSkeletonData().Animations
                if animations.Count > 0 then
                    local animation = animations.Items[0]
                    self.hero_spine.AnimationState:SetAnimation(0, animation.Name, true)
                end
            end
        end)
    else
        local picPath = HeroUtils.GetHeroBigPic(heroData.heroId)
        self.hero_image:LoadSprite(picPath, nil, function()
            self.hero_image:SetActive(true)
        end)
    end
    
    local color = RarityColor[heroData.rarity]
    self.bg_image:SetActive(false)
    self.bg_image:LoadSprite(string.format(LoadPath.UINewHero, "newhero_bg1_" .. color), nil, function()
        self.bg_image:SetActive(true)
    end)
    --self.bg2_image:SetActive(false)
    --self.bg2_image:LoadSprite(string.format(LoadPath.UINewHero, "newhero_bg2_" .. color), nil, function()
    --    self.bg2_image:SetActive(true)
    --end)
    self.bg3_image:SetActive(false)
    self.bg3_image:LoadSprite(string.format(LoadPath.UINewHero, "newhero_bg3_" .. color), nil, function()
        self.bg3_image:SetActive(true)
    end)
    self.bg4_image:SetActive(false)
    self.bg4_image:LoadSprite(string.format(LoadPath.HeroDetailPath, "newhero_bg4_" .. color), nil, function()
        self.bg4_image:SetActive(true)
    end)

    self:RefreshHeroInfo()

    --self.pageRoot:SetActive(true)
    self.nodePower:SetActive(true)
    self.imgNew:SetActive(DataCenter.HeroDataManager:IsNewHero(self.heroUuid))

    for _, eff in pairs(RarityEff) do
        self.transform:Find(eff).gameObject:SetActive(false)
    end
    self.transform:Find(RarityEff[heroData.rarity]).gameObject:SetActive(true)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_GetHero_One)
end

local function SwitchTab(self, tabIdx)
    if self.currentTab == tabIdx then
        return
    end

    self.currentTab = tabIdx

    for k, tabObj in pairs(self.tabButtons) do
        tabObj:SetActive(k ~= tabIdx)
    end

    for k, pageObj in pairs(self.pages) do
        pageObj:SetActive(k == tabIdx)
    end
end

local function OnKeyEscape(self)
    if self.canClose then
        self.ctrl:CloseSelf()
    end
end

UINewHero.OnCreate= OnCreate
UINewHero.OnDestroy = OnDestroy
UINewHero.OnEnable = OnEnable
UINewHero.OnDisable = OnDisable
UINewHero.ComponentDefine = ComponentDefine
UINewHero.ComponentDestroy = ComponentDestroy

UINewHero.RefreshHeroInfo = RefreshHeroInfo
UINewHero.OnOpen = OnOpen
UINewHero.SwitchTab = SwitchTab
UINewHero.OnKeyEscape = OnKeyEscape

return UINewHero