---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2021/11/24 17:21
---
local UINoticeHeroTipsView = BaseClass("UINoticeHeroTipsView",UIBaseView)
local base = UIBaseView
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIHeroStars = require 'UI.UIHero2.Common.UIHeroStars'

local Localization = CS.GameEntry.Localization

local hero_rect = "Hero_Rect"
local hero_path = "Hero_Rect/HeroBg_Rect/Hero_Txt/UIHeroCellSmall"
local hero_star_path = "Hero_Rect/HeroBg_Rect/Hero_Txt/UIHeroStars"

local hero_txt_path = "Hero_Rect/HeroBg_Rect/Hero_Txt"
local anim_path = ""
local UIState = {
    None = 1,
    Show = 2,
    Hide = 3,
    HeroNotice = 4,
}

local function OnCreate(self)
    base.OnCreate(self)
    self.isFirst = true
    self.state = UIState.Show
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

local function ComponentDefine(self)
    self.hero_rect = self:AddComponent(UIBaseContainer,hero_rect)
    self.heroStars = self:AddComponent(UIHeroStars,hero_star_path)
    self.hero = self:AddComponent(UIHeroCellSmall,hero_path)

    self.hero_txt = self:AddComponent(UIText,hero_txt_path)
    self.anim = self:AddComponent(UIAnimator,anim_path)
end

local function DataDefine(self)
    self.initSizeDeltaX = 0
    self.loopNum = 0
    self.loop = 0
end

local function OnDestroy(self)
    self.hero_rect= nil
    self.hero     = nil
    self.hero_txt = nil
    self.anim     = nil
    self.initSizeDeltaX = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UI_SHOWNOTICE, self.SetNewNotice)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UI_SHOWNOTICE, self.SetNewNotice)
end

local function SetNewNotice(self,noticeType)
    self.ctrl:SetNewNotice(noticeType)
end

local function ReInit(self)
    self.timer = 0
    --self:ResetUI()
    self:SetState(UIState.Show)
end

local function OnUpdateUI(self)
    if self.state == UIState.None then
        self:SetState(UIState.Show)
    end
end

local function ResetUI(self)
    self.ImgBg.transform.localScale = Vector3.one
    self.ImgBg.color = Color.New(0, 0, 0, 1)
end

local function SetState(self,s, force)
    if self.state == s and not force then
        return
    end
    self.state = s
    self.timer = 0
    if s == UIState.None then
        self.hero_txt:SetText("")
        --self:ResetUI()
    elseif s == UIState.Show then
        self.hero_txt:SetText("")
        self:Play("UINoticeTips_HeroShow")
    elseif s == UIState.Hide then
        self.hero_txt:SetText("")
        self:Play("UINoticeTips_HeroHide")
    elseif s == UIState.HeroNotice then
        self.loopNum = self.loopNum + 1
        self:Play("UINoticeTips_HeroWord2")
    end
end


local function Update(self)
    if self.state == UIState.None then
        return
    end
    self.timer = self.timer + Time.deltaTime
    if self.state == UIState.Show then
        if self.timer < 2 then
            --提前填充内容
            local nextContent = NoticeTipsManager:GetInstance():GetNotice(true)
            if nextContent then
                --是否有循环次数
                self.loopNum = 0
                if nextContent.tab.loop then
                    self.loop = tonumber(nextContent.tab.loop)
                else
                    self.loop = 0
                end
                self.hero:InitWithConfigId(nextContent.tab.configId,nextContent.tab.quality)
                self.hero_txt:SetText(nextContent.content)

                self:RefreshHeroStar(nextContent.tab.quality, nextContent.noticeType == NoticeType.AcquireHero)

                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.hero_txt.rectTransform)
                self.initSizeDeltaX = self.hero_txt:GetSizeDelta().x
            end
        end
        if self.timer >= 2 then
            local nextContent = NoticeTipsManager:GetInstance():GetNotice(true)
            if nextContent then
                self.hero:InitWithConfigId(nextContent.tab.configId,nextContent.tab.quality)
                self.hero_txt:SetText(nextContent.content)

                self:RefreshHeroStar(nextContent.tab.quality, nextContent.noticeType == NoticeType.AcquireHero)

                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.hero_txt.rectTransform)
                self:SetState(UIState.HeroNotice)
            else
                if self.isFirst then
                    self:SetState(UIState.HeroNotice)
                    self.isFirst = false
                else
                    self:SetState(UIState.Hide)
                end
            end
        end
    elseif self.state == UIState.Hide then
        if self.timer >= 0.5 then
            local nextContent = NoticeTipsManager:GetInstance():GetNotice(true)
            if nextContent then
                self:SetState(UIState.Show)
            else
                self:SetState(UIState.None)
                self.ctrl:CloseSelf()
            end
        end
    elseif self.state == UIState.HeroNotice then
        local offset = Mathf.Abs(self.hero_txt:GetAnchoredPosition().x) >= self.initSizeDeltaX + 30
        if self.timer >= 14 or offset then
            
            if self.loop == 0 or self.loopNum >= self.loop  then
                local nextContent = NoticeTipsManager:GetInstance():GetNotice(true)
                if nextContent then
                    --是否有循环次数
                    self.loopNum = 0
                    if nextContent.tab.loop then
                        self.loop = tonumber(nextContent.tab.loop)
                    else
                        self.loop = 0
                    end
                    self.hero:InitWithConfigId(nextContent.tab.configId,nextContent.tab.quality)
                    self.hero_txt:SetText(nextContent.content)
                    
                    self:RefreshHeroStar(nextContent.tab.quality, nextContent.noticeType == NoticeType.AcquireHero)

                    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.hero_txt.rectTransform)
                    self.initSizeDeltaX = self.hero_txt:GetSizeDelta().x
                    self:SetState(UIState.HeroNotice, true)
                else
                    self:SetState(UIState.Hide)
                end
            else
                self:SetState(UIState.HeroNotice, true)
            end
        end
    end
end

local function Play(self,animName)
    --self.anim:SetTrigger(animName)
    self.anim:Play(animName,0,0)
end

local function RefreshHeroStar(self, quality, showFlag)
    if showFlag == false then
        self.heroStars:SetActive(false)
        return
    end
    self.heroStars:SetActive(true)
    
    local starPara = {}
    starPara.showStarNum = quality
    starPara.isLeft = true
    starPara.maxStarNum = 100
    self.heroStars:SetData(starPara)
    self.hero:SetStarActive(false)
end

UINoticeHeroTipsView.OnCreate = OnCreate
UINoticeHeroTipsView.OnDestroy = OnDestroy
UINoticeHeroTipsView.OnEnable = OnEnable
UINoticeHeroTipsView.OnDisable = OnDisable
UINoticeHeroTipsView.ComponentDefine =ComponentDefine
UINoticeHeroTipsView.DataDefine =DataDefine
UINoticeHeroTipsView.OnAddListener =OnAddListener
UINoticeHeroTipsView.OnRemoveListener =OnRemoveListener
UINoticeHeroTipsView.SetNewNotice = SetNewNotice
UINoticeHeroTipsView.ReInit =ReInit
UINoticeHeroTipsView.Update = Update
UINoticeHeroTipsView.ResetUI =ResetUI
UINoticeHeroTipsView.OnUpdateUI =OnUpdateUI
UINoticeHeroTipsView.SetState =SetState
UINoticeHeroTipsView.Play =Play
UINoticeHeroTipsView.RefreshHeroStar = RefreshHeroStar

return UINoticeHeroTipsView