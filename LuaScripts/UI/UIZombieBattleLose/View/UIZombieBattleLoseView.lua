---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/11/30 13:00
---

local UIZombieBattleLoseView = BaseClass("UIZombieBattleLoseView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIGrowthList = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthList")
local UIStatisticList = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticHeroList")

function UIZombieBattleLoseView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:RefreshView()
    self:Show()
end

function UIZombieBattleLoseView:OnDestroy()
    if not IsNull(self.tabTween) then
        self.tabTween:Kill()
        self.tabTween = nil
    end
    base.OnDestroy(self)
end

function UIZombieBattleLoseView:ComponentDefine()

    self.canvasGroup = self.transform:Find("Root").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    self.canvasGroup.alpha = 0
    
    self.tryAgainBtn = self:AddComponent(UIButton, "Root/Bottom/TryAgainBtn")
    self.tryAgainBtnText = self:AddComponent(UIText,"Root/Bottom/TryAgainBtn/TryAgainBtnText")
    self.tryAgainBtn:SetOnClick(function()
        self:OnTryAgainBtnClick()
    end)    
    self.backBtn = self:AddComponent(UIButton, "Root/Bottom/BackBtn")
    self.backBtnText = self:AddComponent(UIText,"Root/Bottom/BackBtn/BackBtnText")
    self.backBtn:SetOnClick(function()
        self:OnBackBtnClick()
    end)

    self.defeatText = self:AddComponent(UIText,"Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
    self.defeatText:SetText(Localization:GetString("311106"))
    
    self.levelText = self:AddComponent(UIText,"Root/Top/LevelText")
    self.timeText = self:AddComponent(UIText,"Root/Top/TimeText")
    self.killNumText = self:AddComponent(UIText,"Root/Top/KillNumText")

    local param = self:GetUserData()
    local stageId = param.stageId
    self.stageTemp = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId)
    
    if self.stageTemp.type == LWStageType.DetectEvent then
        self.backBtnText:SetText(Localization:GetString("300520"))
    else
        self.backBtnText:SetText(Localization:GetString("450009"))
    end

    self.levelText:SetText(Localization:GetString("800313",GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId,'order')))
    self.tryAgainBtnText:SetText(Localization:GetString("450008"))--再来一次
    -- self.backBtnText:SetText(Localization:GetString("450009"))--返回基地

    self.tabBtns = {
        self:AddComponent(UIButton, "Root/Tabs/GuideBtn"),
        self:AddComponent(UIButton, "Root/Tabs/MakeBtn"),
        self:AddComponent(UIButton, "Root/Tabs/TakeBtn"),
    }
    for i, tabBtn in ipairs(self.tabBtns) do
        local idx = i
        tabBtn:SetOnClick(function()
            self:OnTabBtnClick(idx)
        end)
    end
    
    self.tabComps = {
        self:AddComponent(UIGrowthList, "Root/GrowGuideScroll", self.ctrl),
        self:AddComponent(UIStatisticList, "Root/MakeDmgScroll", "makeDmg"),
        self:AddComponent(UIStatisticList, "Root/TakeDmgScroll", "takeDmg"),
    }
    self.tabIdx = 1

    self.highlightMask = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask")
    self.highlightInner = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask/Inner")
    self.highlightMask:SetAnchoredPositionXY(0, -1)
    self.highlightInner:SetAnchoredPositionXY(0, 0)

    self.transform:Find("Root/Tabs/GuideBtn/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800799)
    self.transform:Find("Root/Tabs/Highlight/Mask/Inner/GuideBtnHigh/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800799)
    self.transform:Find("Root/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800800)
    self.transform:Find("Root/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800800)
    self.transform:Find("Root/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800801)
    self.transform:Find("Root/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.NewText)).text = CS.GameEntry.Localization:GetString(800801)
end

function UIZombieBattleLoseView:ComponentDestroy()
    self.back_btn = nil
end

function UIZombieBattleLoseView:Show()
    TimerManager:GetInstance():DelayInvoke(function()
        self.canvasGroup:DOFade(1,0.2)
        self.tabComps[1]:FirstTimeLoseGuide()
    end,1.5)
end

function UIZombieBattleLoseView:RefreshView()
    -- self.panelData = self:GetUserData()
    -- local time = Time.time - DataCenter.ZombieBattleManager.startTime
    -- self.killNumText:SetText( Localization:GetString("800303") .. " "..DataCenter.ZombieBattleManager.killNum)
    -- self.timeText:SetText( Localization:GetString("800304").." "..UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time))

    for i, tabComp in ipairs(self.tabComps) do
        if i == self.tabIdx then
            tabComp:SetActive(true)
            tabComp:RefreshView()
            tabComp:FadeIn()
        else
            tabComp:SetActive(false)
        end
    end
end

function UIZombieBattleLoseView:OnTabBtnClick(idx)
    if self.tabIdx == idx then
        return
    end

    self.tabIdx = idx
    self:RefreshView()
    
    if not IsNull(self.tabTween) then
        self.tabTween:Kill()
        self.tabTween = nil
    end
    self.tabTween = CS.DG.Tweening.DOTween.To(function()
        return self.highlightMask:GetAnchoredPositionX()
    end, function(value)
        self.highlightMask:SetAnchoredPositionXY(value, -1)
        self.highlightInner:SetAnchoredPositionXY(-value, 0)
    end, (self.tabIdx - 1) * 223, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UIZombieBattleLoseView:OnBackBtnClick()
    self.ctrl:CloseSelf()

    if self.stageTemp.type == LWStageType.DetectEvent then
        DataCenter.ZombieBattleManager:Exit()
    else
        DataCenter.ZombieBattleManager:Exit()
    end
end

function UIZombieBattleLoseView:OnTryAgainBtnClick()
    self.ctrl:CloseSelf()
    local param = {}
    param.type = PVEType.Barrage
    param.levelId = DataCenter.ZombieBattleManager.pveTemplate.stageMeta.id
    param.levelGroupId = DataCenter.ZombieBattleManager.param.levelGroupId
    param.extraData = DataCenter.ZombieBattleManager.param.extraData
    DataCenter.ZombieBattleManager:Destroy()
    DataCenter.ZombieBattleManager:Enter(param)
end

function UIZombieBattleLoseView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIZombieBattleLoseView:OnRemoveListener()
    self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
    base.OnRemoveListener(self)
end

function UIZombieBattleLoseView:OnKeyCodeEscape()
    TimerManager:GetInstance():DelayFrameInvoke(function()
        self:OnBackBtnClick()
    end, 1)
end


return UIZombieBattleLoseView