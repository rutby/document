---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/27 21:14
---
local UIPlayerInfoView = BaseClass("UIPlayerInfoView", UIBaseView)
local base = UIBaseView
local UIHeroInfoSkillItem = require "UI.UIHero2.UIHeroInfo.Component.UIHeroInfoSkillItem"

local Localization = CS.GameEntry.Localization

local closeBtnPath = "Bg"
local skillItemContainerPath = "Root/SkillItem"
local skillItemPath = "Root/SkillItem/UIHeroInfoSkillItem"
local skillDescTextPath = "Root/SkillDescText"
local titleBgPath = "Root/TitleBg"
local shineEffectPath = "Root/SkillItem/ShineEffect"
local explodeEffectPath = "Root/SkillItem/ExplodeEffect"

local function PlayCloseAnim(self)
    self.starPlayClose = true
    self.closeBtnImg:SetAlpha(0)
    self.skillDescText:SetActive(false)
    self.titleBg:SetActive(false)
    self.skillItemContainer.transform:DOMove(self.targetPos, 0.4):SetDelay(0.1):SetEase(CS.DG.Tweening.Ease.InBack):OnComplete(function()
        self.shineEffect:SetActive(false)
        self.explodeEffect:SetActive(true)
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.ctrl:CloseSelf()
        end, 0.18)
    end)
end



local function OnCreate(self)
    base.OnCreate(self)

    self.starPlayClose = false
    self.canClose = false
    self.closeBtn = self:AddComponent(UIButton, closeBtnPath)
    self.closeBtn:SetOnClick(function()
        if self.ctrl and not self.starPlayClose and self.canClose then
            PlayCloseAnim(self)
        end
    end)
    self.closeBtnImg = self:AddComponent(UIImage, closeBtnPath)
    self.closeBtnImg:SetAlpha(0.5)
    self.skillItemContainer = self:AddComponent(UIBaseContainer, skillItemContainerPath)
    self.skillItemContainer:SetLocalPositionXYZ(0, 80, 0)
    self.skillItem = self:AddComponent(UIHeroInfoSkillItem, skillItemPath)
    self.skillDescText = self:AddComponent(UIText, skillDescTextPath)
    self.skillDescText:SetActive(true)
    self.titleBg = self:AddComponent(UIImage, titleBgPath)
    self.titleBg:SetActive(true)
    self.shineEffect = self:AddComponent(UIBaseContainer, shineEffectPath)
    self.shineEffect:SetActive(true)
    self.explodeEffect = self:AddComponent(UIBaseContainer, explodeEffectPath)
    self.explodeEffect:SetActive(false)

    self.skillData,self.heroData,self.targetPos = self:GetUserData()

    if not self.skillData or not self.heroData or not self.targetPos then
        self.ctrl:CloseSelf()
        return
    end


    self.skillItem:SetData(self.skillData,
        { showSkillName = false, showSkillLevel = true, showStar = true }
        , self.selectSkillCallBack)
    self.skillItem:SetShowRed(false)
    --self.skillItem:ShowNewTag()
    
    local desc, effectDesc = HeroUtils.GetSkillDescStr(self.skillData.skillId, self.skillData.level, "#4FC890", false)
    self.skillDescText:SetText(desc)

    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.canClose = true
    end, 1)
    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

local function OnDestroy(self)

    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
    self.closeBtn = nil
    self.closeBtnImg = nil
    self.skillItemContainer = nil
    self.skillItem = nil
    self.skillDescText = nil
    self.shineEffect = nil
    self.explodeEffect = nil

    base.OnDestroy(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end



UIPlayerInfoView.OnCreate= OnCreate
UIPlayerInfoView.OnDestroy = OnDestroy
UIPlayerInfoView.OnAddListener = OnAddListener
UIPlayerInfoView.OnRemoveListener = OnRemoveListener

return UIPlayerInfoView