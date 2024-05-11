---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/15 16:12
---

local UIHeroIntensifyDetail = BaseClass("UIHeroIntensifyDetail", UIBaseView)
local base = UIBaseView
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local black_path = "UICommonMidPopUpTitle/panel"
local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local top_info_path = "Root/TopInfo"
local desc_left_path = "Root/DescBg/DescLeft"
local desc_right_path = "Root/DescBg/DescRight"
local next_left_path = "Root/DescBg/NextLeft"
local next_right_path = "Root/DescBg/NextRight"
local info_path = "Root/DescBg/Info"
local random_path = "Root/DescBg/Random"
local random_rest_path = "Root/DescBg/Random/RandomRest"
local slider_exp_path = "Root/SliderBg/Slider/SliderExp"
local slider_path = "Root/SliderBg/Slider"
local level_path = "Root/SliderBg/Level"

local poster_bg_path = "Root/Cost/PosterBg"
local poster_path = poster_bg_path .. "/Poster"
local poster_num_path = poster_bg_path .. "/PosterNum"
local poster_btn_path = poster_bg_path .. "/PosterBtn"
local poster_btn_text_path = poster_bg_path .. "/PosterBtn/PosterBtnText"
local poster_add_path = poster_bg_path .. "/PosterAdd"

local medal_bg_path = "Root/Cost/MedalBg"
local medal_path = medal_bg_path .. "/Medal"
local medal_num_path = medal_bg_path .. "/MedalNum"
local medal_btn_path = medal_bg_path .. "/MedalBtn"
local medal_btn_text_path = medal_bg_path .. "/MedalBtn/MedalBtnText"
local medal_add_path = medal_bg_path .. "/MedalAdd"

local SLIDER_DURATION = 2

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.black_btn = self:AddComponent(UIButton, black_path)
    self.black_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(136023)
    self.top_info_btn = self:AddComponent(UIButton, top_info_path)
    self.top_info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnTopInfoClick()
    end)
    self.desc_left_text = self:AddComponent(UIText, desc_left_path)
    self.desc_right_text = self:AddComponent(UITweenNumberText, desc_right_path)
    self.next_left_text = self:AddComponent(UIText, next_left_path)
    self.next_right_text = self:AddComponent(UITweenNumberText, next_right_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoClick()
    end)
    self.random_btn = self:AddComponent(UIButton, random_path)
    self.random_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRandomClick()
    end)
    self.random_rest_text = self:AddComponent(UIText, random_rest_path)
    self.slider_exp_text = self:AddComponent(UIText, slider_exp_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.level_text = self:AddComponent(UIText, level_path)
    self.poster_bg_go = self:AddComponent(UIBaseContainer, poster_btn_path)
    self.poster = self:AddComponent(UIHeroCellSmall, poster_path)
    self.poster_num_text = self:AddComponent(UIText, poster_num_path)
    self.poster_btn = self:AddComponent(UIButton, poster_btn_path)
    self.poster_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnPosterBtnClick()
    end)
    self.poster_btn_text = self:AddComponent(UIText, poster_btn_text_path)
    self.poster_btn_text:SetLocalText(136004)
    self.poster_add_text = self:AddComponent(UIText, poster_add_path)
    self.medal_bg_go = self:AddComponent(UIBaseContainer, medal_bg_path)
    self.medal = self:AddComponent(UICommonItem, medal_path)
    self.medal_num_text = self:AddComponent(UIText, medal_num_path)
    self.medal_btn = self:AddComponent(UIButton, medal_btn_path)
    self.medal_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMedalBtnClick()
    end)
    self.medal_btn_text = self:AddComponent(UIText, medal_btn_text_path)
    self.medal_btn_text:SetLocalText(136004)
    self.medal_add_text = self:AddComponent(UIText, medal_add_path)
end

local function ComponentDestroy(self)
    self.black_btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.top_info_btn = nil
    self.desc_left_text = nil
    self.desc_right_text = nil
    self.next_left_text = nil
    self.next_right_text = nil
    self.info_btn = nil
    self.random_btn = nil
    self.random_rest_text = nil
    self.slider_exp_text = nil
    self.slider = nil
    self.level_text = nil
    self.poster_bg_go = nil
    self.poster = nil
    self.poster_num_text = nil
    self.poster_btn = nil
    self.poster_btn_text = nil
    self.poster_add_text = nil
    self.medal_bg_go = nil
    self.medal = nil
    self.medal_num_text = nil
    self.medal_btn = nil
    self.medal_btn_text = nil
    self.medal_add_text = nil
end

local function DataDefine(self)
    self.id = 0
    self.template = nil
    self.showTemplate = nil
    self.data = nil
    
    self.curExp = 0
    self.curLevel = 0
    self.levelDuration = 0
    self.tween = nil
end

local function DataDestroy(self)
    self.id = nil
    self.template = nil
    self.showTemplate = nil
    self.data = nil
    
    self.curExp = 0
    self.curLevel = nil
    self.levelDuration = nil
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroIntensifyUpdate, self.OnHeroIntensifyUpdate)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroIntensifyUpdate, self.OnHeroIntensifyUpdate)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local id, justOpen = self:GetUserData()
    self.id = id
    self:Refresh(true, justOpen)
end

local function Refresh(self, isInit, justOpen)
    self.data = DataCenter.HeroIntensifyManager:GetData(self.id)
    self.template = DataCenter.HeroIntensifyManager:GetTemplate(self.id, self.data.level)
    self.showTemplate = self.data:GetShowTemplate()
    self.info_btn:SetActive(self.showTemplate.tips ~= 0)
    self.random_btn:SetActive(self.template.type == HeroIntensifySlotType.Random)
    self.random_rest_text:SetLocalText(372234, self.data:GetRandomRest())
    local heroId = self.template.heroId
    
    -- 效果描述
    local oldShowTemplate = self.data:GetShowTemplate(self.curLevel)
    local nextShowTemplate = self.data:GetShowTemplate(self.data.level + 1)
    local oldVal = oldShowTemplate.effectVals[1] or 0
    local curVal = self.showTemplate.effectVals[1] or 0
    local nextVal = nextShowTemplate.effectVals[1] or 0
    local desc = self.showTemplate.descs[1].desc
    local effectNumType = self.showTemplate.descs[1].type
    local oldValStr = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(toInt(oldVal), effectNumType)
    local curValStr = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(toInt(curVal), effectNumType)
    local nextValStr = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(toInt(nextVal), effectNumType)
    local SmallNumFunc = function(x)
        return DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(toInt(x * 10) / 10, effectNumType)
    end
    local LargeNumFunc = function(x)
        return DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(toInt(x), effectNumType)
    end
    -- 当前和下一级效果值
    self.desc_left_text:SetLocalText(desc)
    self.next_left_text:SetLocalText(121548)
    if nextVal - curVal > 1.01 then
        self.desc_right_text:SetDecimal(false)
        self.next_right_text:SetDecimal(false)
        self.desc_right_text:SetTextFunc(LargeNumFunc)
        self.next_right_text:SetTextFunc(LargeNumFunc)
    else
        self.desc_right_text:SetDecimal(true)
        self.next_right_text:SetDecimal(true)
        self.desc_right_text:SetTextFunc(SmallNumFunc)
        self.next_right_text:SetTextFunc(SmallNumFunc)
    end
    if justOpen then
        self.desc_right_text:FromNumTweenToNum(0, curVal, SLIDER_DURATION, 0, 1.5)
        self.next_right_text:FromNumTweenToNum(curVal, nextVal, SLIDER_DURATION, 0, 1.5)
    elseif isInit then
        self.desc_right_text:SetNum(curVal)
        self.next_right_text:SetNum(nextVal)
    else
        self.desc_right_text:TweenToNum(curVal, SLIDER_DURATION, 0, 1.5)
        self.next_right_text:TweenToNum(nextVal, SLIDER_DURATION, 0, 1.5)
    end
    
    -- 弹出横条
    if not isInit and self.data.level > self.curLevel then
        UIUtil.ShowStarTip(Localization:GetString(desc), oldValStr, curValStr)
    end
    
    -- 进度条
    if isInit then
        self:SetSliderValue(self.data.exp, self.data.level)
    else
        self.levelDuration = SLIDER_DURATION / (self.data.level - self.curLevel + 1)
        self:TweenSliderValue(self.data.exp, self.data.level)
    end
    
    -- 海报
    if self:CanShowPoster() then
        self.poster_bg_go:SetActive(true)
        self.poster:InitWithConfigIdByPoster(heroId)
        self.poster_num_text:SetText(HeroUtils.GetPosterCount(heroId))
        self.poster.btn_go:SetOnClick(function()
            self:OnPosterClick()
        end)
        self.poster_add_text:SetText("+" .. DataCenter.HeroIntensifyManager:GetPosterExp())
        if HeroUtils.GetPosterCount(heroId) > 0 then
            UIGray.SetGray(self.poster_btn.transform, false, true)
        else
            UIGray.SetGray(self.poster_btn.transform, true, false)
        end
    else
        self.poster_bg_go:SetActive(false)
    end
    
    -- 勋章
    if self:CanShowMedal() then
        self.medal_bg_go:SetActive(true)
        self.medal:ReInit({ rewardType = RewardType.GOODS, itemId = HeroUtils.GetMedalItemId(heroId) })
        self.medal_num_text:SetText(HeroUtils.GetMedalCount(heroId))
        self.medal.btn:SetOnClick(function()
            self:OnMedalClick()
        end)
        self.medal_add_text:SetText("+" .. DataCenter.HeroIntensifyManager:GetMedalExp())
        if HeroUtils.GetMedalCount(heroId) > 0 then
            UIGray.SetGray(self.medal_btn.transform, false, true)
        else
            UIGray.SetGray(self.medal_btn.transform, true, false)
        end
    else
        self.medal_bg_go:SetActive(false)
    end
end

local function Update(self)
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.Space) then
        for i = 1, 10 do
            self:OnMedalBtnClick()
        end
    end
end

local function CanShowPoster(self)
    return true
end

local function CanShowMedal(self)
    if not LuaEntry.DataConfig:CheckSwitch("hero_camp_medal") then
        return false
    end
    local heroData = DataCenter.HeroDataManager:GetHeroById(self.template.heroId)
    return heroData and heroData:IsMaxQuality() and HeroUtils.GetMedalCount(self.template.heroId) > 0
end

local function SetSliderValue(self, exp, level)
    local template = DataCenter.HeroIntensifyManager:GetTemplate(self.id, level)
    local percent = Mathf.Clamp(exp / template.maxExp, 0, 1)
    self.curExp = exp
    self.curLevel = level
    self.slider:SetValue(percent)
    self.level_text:SetText("Lv." .. level)
    self.slider_exp_text:SetText(toInt(exp) .. "/" .. template.maxExp)
end

local function TweenSliderValue(self, exp, level)
    if self.tween then
        self.tween:Kill()
    end
    
    local Setter = function(x)
        self:SetSliderValue(x, self.curLevel)
    end
    
    local template = DataCenter.HeroIntensifyManager:GetTemplate(self.id, self.curLevel)
    if self.curLevel < level then
        local duration = (template.maxExp - self.curExp) / template.maxExp * self.levelDuration
        self.tween = DOTween.To(Setter, self.curExp, template.maxExp, duration):OnComplete(function()
            self:SetSliderValue(0, self.curLevel + 1)
            self:TweenSliderValue(exp, level)
        end)
    elseif self.curLevel == level then
        local duration = (exp - self.curExp) / template.maxExp * self.levelDuration
        self.tween = DOTween.To(Setter, self.curExp, exp, duration)
    else
        self:SetSliderValue(exp, level)
    end
end

local function OnTopInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("136000"), "", Localization:GetString("136015", DataCenter.HeroIntensifyManager:GetPosterExp(), DataCenter.HeroIntensifyManager:GetMedalExp()))
end

local function OnInfoClick(self)
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(self.showTemplate.tips)
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 350
    param.pivot = 0.5
    param.position = self.info_btn.transform.position + Vector3.New(0, 30, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnRandomClick(self)
    if self.data:GetRandomRest() >= DataCenter.HeroIntensifyManager:GetRandomTimeLimit() then
        UIUtil.ShowTipsId(372234)
        return
    end
    local itemId, cost = DataCenter.HeroIntensifyManager:GetRandomCost()
    local have = DataCenter.ItemData:GetItemCount(itemId)
    if have < cost then
        UIUtil.ShowTipsId(120021)
        return
    end
    UIUtil.ShowMessage(Localization:GetString("110028"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DataCenter.HeroIntensifyManager:SendIntensifyRandomEffect(self.id)
    end)
end

local function OnPosterClick(self)
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("136011", DataCenter.HeroIntensifyManager:GetPosterExp())
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 250
    param.pivot = 0.5
    param.position = self.poster.transform.position + Vector3.New(0, 50, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnMedalClick(self)
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("136012", DataCenter.HeroIntensifyManager:GetMedalExp())
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 250
    param.pivot = 0.5
    param.position = self.medal.transform.position + Vector3.New(0, 50, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnPosterBtnClick(self)
    local heroId = self.template.heroId
    local heroPosters = DataCenter.HeroDataManager:GetHeroPostersById(heroId)
    if #heroPosters == 0 then
        DataCenter.HeroLackTipManager:GotoGetHero(heroId, nil, function()
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroIntensifyDetail)
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroOfficial)
        end)
        return
    end
    
    if self.data.level >= DataCenter.HeroIntensifyManager:GetMaxLevel(self.id) then
        UIUtil.ShowTipsId(400013)
        return
    end
    
    local posterUuid = heroPosters[1].uuid
    local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
    if heroData and heroData:IsMaxQuality() or DataCenter.HeroIntensifyManager.noPosterWarning then
        DataCenter.HeroIntensifyManager:SendIntensify(self.id, HeroIntensifyCostType.Poster, posterUuid)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Hero_Upgrade)
    else
        UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("136006"), 2, "", "",
            function() -- 确认
                DataCenter.HeroIntensifyManager:SendIntensify(self.id, HeroIntensifyCostType.Poster, posterUuid)
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Hero_Upgrade)
            end,
            function(warning) -- 不再显示
                DataCenter.HeroIntensifyManager.noPosterWarning = not warning
            end)
    end
end

local function OnMedalBtnClick(self)
    local heroId = self.template.heroId
    
    if HeroUtils.GetMedalCount(heroId) == 0 then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.id = HeroUtils.GetMedalItemId(heroId)
        param.targetNum = 1
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
        return
    end
    
    if self.data.level >= DataCenter.HeroIntensifyManager:GetMaxLevel(self.id) then
        UIUtil.ShowTipsId(400013)
        return
    end
    
    local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
    if heroData and heroData:IsReachMaxMilitaryRank() or DataCenter.HeroIntensifyManager.noMedalWarning then
        DataCenter.HeroIntensifyManager:SendIntensify(self.id, HeroIntensifyCostType.Medal)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Hero_Upgrade)
    else
        UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("136007"), 2, "", "",
            function() -- 确认
                DataCenter.HeroIntensifyManager:SendIntensify(self.id, HeroIntensifyCostType.Medal)
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Hero_Upgrade)
            end,
            function(warning) -- 不再显示
                DataCenter.HeroIntensifyManager.noMedalWarning = not warning
            end)
    end
end

local function OnHeroIntensifyUpdate(self, id)
    if self.id == id then
        self:Refresh(false, false)
    end
end

UIHeroIntensifyDetail.OnCreate = OnCreate
UIHeroIntensifyDetail.OnDestroy = OnDestroy
UIHeroIntensifyDetail.OnEnable = OnEnable
UIHeroIntensifyDetail.OnDisable = OnDisable
UIHeroIntensifyDetail.ComponentDefine = ComponentDefine
UIHeroIntensifyDetail.ComponentDestroy = ComponentDestroy
UIHeroIntensifyDetail.DataDefine = DataDefine
UIHeroIntensifyDetail.DataDestroy = DataDestroy
UIHeroIntensifyDetail.OnAddListener = OnAddListener
UIHeroIntensifyDetail.OnRemoveListener = OnRemoveListener

UIHeroIntensifyDetail.ReInit = ReInit
UIHeroIntensifyDetail.Refresh = Refresh
UIHeroIntensifyDetail.Update = Update
UIHeroIntensifyDetail.CanShowPoster = CanShowPoster
UIHeroIntensifyDetail.CanShowMedal = CanShowMedal
UIHeroIntensifyDetail.ShowSlider = ShowSlider
UIHeroIntensifyDetail.SetSliderValue = SetSliderValue
UIHeroIntensifyDetail.TweenSliderValue = TweenSliderValue

UIHeroIntensifyDetail.OnTopInfoClick = OnTopInfoClick
UIHeroIntensifyDetail.OnInfoClick = OnInfoClick
UIHeroIntensifyDetail.OnRandomClick = OnRandomClick
UIHeroIntensifyDetail.OnPosterClick = OnPosterClick
UIHeroIntensifyDetail.OnMedalClick = OnMedalClick
UIHeroIntensifyDetail.OnPosterBtnClick = OnPosterBtnClick
UIHeroIntensifyDetail.OnMedalBtnClick = OnMedalBtnClick
UIHeroIntensifyDetail.OnHeroIntensifyUpdate = OnHeroIntensifyUpdate

return UIHeroIntensifyDetail