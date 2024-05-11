---
--- PVE 战斗结算UI
---
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"
local UIPVEResultView = BaseClass("UIPVEResultView", UIBaseView)
local base = UIBaseView
local Const = require "Scene.BattlePveModule.Const"
local UIPVEResultWin = require "UI.UIPVE.UIPVEResult.Component.UIPVEResultWin"
local UIPVEResultFail = require "UI.UIPVE.UIPVEResult.Component.UIPVEResultFail"

local this_path = ""
local panel_path = "UICommonPanel"
local win_path = "Win"
local fail_path = 'Fail'
local continue_path = "BtnList/Continue"
local continue_text_path = "BtnList/Continue/ContinueText"
local return_path = "BtnList/Return"
local return_text_path = "BtnList/Return/ReturnText"
local tap_desc_path = "TapDesc"

local arenaResult_path = "arena"
local arenaOldRank_path = "arena/rank/oldRank"
local arenaRankArrow_path = "arena/rank/rankArrow"
local arenaNewRank_path = "arena/rank/newRank"
local arenaScore_path = "arena/score"
local arenaOldScore_path = "arena/score/oldScore"
local arenaScoreArrow_path = "arena/score/scoreArrow"
local arenaNewScore_path = "arena/score/newScore"
local arenaRewardContent_path = "arena/scrollRect/Viewport/Content"


local function OnCreate(self)
    base.OnCreate(self)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self:OnCloseClick()
    end)

    self.win = self:AddComponent(UIPVEResultWin, win_path)
    self.fail = self:AddComponent(UIPVEResultFail, fail_path)

    self.continue_btn = self:AddComponent(UIButton, continue_path)
    self.continue_btn:SetOnClick(function()
        self:OnContinueClick()
    end)
    self.continue_text = self:AddComponent(UITextMeshProUGUIEx, continue_text_path)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self:OnReturnClick()
    end)
    self.return_text = self:AddComponent(UITextMeshProUGUIEx, return_text_path)
    self.return_text:SetLocalText(321384)
    self.tap_desc_text = self:AddComponent(UITextMeshProUGUIEx, tap_desc_path)
    self.tap_desc_text:SetLocalText(129074)

    self.arenaResultN = self:AddComponent(UIBaseContainer, arenaResult_path)
    self.arenaResultN:SetActive(false)
    self.arenaOldRankN = self:AddComponent(UITextMeshProUGUIEx, arenaOldRank_path)
    self.arenaRankArrowN = self:AddComponent(UIImage, arenaRankArrow_path)
    self.arenaNewRankN = self:AddComponent(UITextMeshProUGUIEx, arenaNewRank_path)
    self.arenaScoreN = self:AddComponent(UIBaseContainer, arenaScore_path)
    self.arenaOldScoreN = self:AddComponent(UITextMeshProUGUIEx, arenaOldScore_path)
    self.arenaScoreArrowN = self:AddComponent(UIImage, arenaScoreArrow_path)
    self.arenaNewScoreN = self:AddComponent(UITextMeshProUGUIEx, arenaNewScore_path)
    self.arenaRewardContentN = self:AddComponent(UIBaseContainer, arenaRewardContent_path)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    local result = self:GetUserData()
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    self.isWin = (result == Const.Result.Win)
    if self.isWin then
        self.continue_text:SetLocalText(321385)
        self.win:SetActive(true)
        self.win:Refresh()
        self.fail:SetActive(false)
        self.anim:Play("Eff_Ani_PVE_Win", 0, 0)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_pve_finish)
        self.tap_desc_text:SetColor(Color.New(142/255,140/255,139/255,1))
        if entranceType == PveEntrance.LandBlock then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveBattleShowResultWin, tostring(DataCenter.BattleLevel:GetLevelId()))
        end
    else
        self.continue_text:SetLocalText(120952)
        self.win:SetActive(false)
        self.fail:SetActive(true)
        self.fail:Refresh()
        self.anim:Play("Eff_Ani_PVE_Fail", 0, 0)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_pve_lost)
        self.tap_desc_text:SetColor(Color.New(211/255,203/255,199/255,1))
        if entranceType == PveEntrance.Story then
            local curLevel = DataCenter.StoryManager:GetCurLevel()
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveBattleShowResult, tostring(curLevel + 1))
        elseif entranceType == PveEntrance.LandBlock then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveBattleShowResultFail, SaveGuideDoneValue)
        end
    end
    if entranceType == PveEntrance.Test then
        self.fail:ShowPowerLack(true)
        self.continue_btn:SetActive(false)
    elseif entranceType == PveEntrance.Story then
        self.fail:ShowPowerLack(true)
        self.continue_btn:SetActive(DataCenter.StoryManager:GetCurLevel() < DataCenter.StoryManager:GetMaxLevel())
    elseif entranceType == PveEntrance.LandBlock then
        self.fail:ShowPowerLack(true)
        self.continue_btn:SetActive(false)
    elseif entranceType == PveEntrance.DetectEventPve then
        self.fail:ShowPowerLack(true)
        self.continue_btn:SetActive(false)
    elseif entranceType == PveEntrance.ArenaBattle then
        self.fail:ShowPowerLack(false)
        self.arenaResultN:SetActive(true)
        self.continue_btn:SetActive(false)
        local arrowPath = "Assets/Main/Sprites/UI/Common/New/%s.png"
        local newRank, oldRank, newScore, oldScore = DataCenter.ArenaManager:GetFightRankChange()
        self.arenaOldRankN:SetText(oldRank <= 0 and "--" or oldRank)
        local rankArrow = oldRank < newRank and "Common_btn_arrow3" or "Common_btn_arrow4"
        self.arenaRankArrowN:LoadSprite(string.format(arrowPath, rankArrow))
        self.arenaNewRankN:SetText(newRank)
        self.arenaOldScoreN:SetText(oldScore)
        local scoreArrow = oldScore <= newScore and "Common_btn_arrow4" or "Common_btn_arrow3"
        self.arenaScoreArrowN:LoadSprite(string.format(arrowPath, scoreArrow))
        self.arenaNewScoreN:SetText(newScore)
        self:ShowArenaRewards()
    else
        self.continue_btn:SetActive(false)
    end
    
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.TimerAction, self, false, false, false)
    self.timer:Start()
    self:TimerAction()
end

local function OnDisable(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function TimerAction(self)
    if self.isWin then
        self.win:TimerAction()
    else
        self.fail:TimerAction()
    end
end

local function OnCloseClick(self)
    -- 点背景
    local levelParam = DataCenter.BattleLevel.levelParam
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.Story then
        DataCenter.BattleLevel:Exit(nil, function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureMain, { anim = true })
        end)
    else
        DataCenter.BattleLevel:Exit()
    end
end

local function OnContinueClick(self)
    -- 点继续按钮
    local curLevel = DataCenter.StoryManager:GetCurLevel()
    DataCenter.StoryManager:StartPve(curLevel + 1)
end

local function OnReturnClick(self)
    -- 点返回按钮
    local levelParam = DataCenter.BattleLevel.levelParam
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    
    DataCenter.BattleLevel:Exit()
end

local function OnKeyEscape(self)
    self:OnCloseClick()
end

local function ShowArenaRewards(self)
    if not self.arenaRewardItemsTb then
        self.arenaRewardItemsTb = {}
    end
    local arenaRewards = DataCenter.ArenaManager:GetCachedRewards() or {}
    for i, reward in ipairs(arenaRewards) do
        self:GameObjectInstantiateAsync(UIAssets.UIGuidePioneerResultArenaCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.arenaRewardContentN.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            NameCount = NameCount + 1
            local nameStr = tostring(NameCount)
            go.name = nameStr
            local itemObj = self.arenaRewardContentN:AddComponent(UICommonItemChange, go.name)
            local tempParam =  {}
            tempParam.rewardType = reward.type
            tempParam.itemId = reward.value.itemId
            tempParam.count = reward.value.rewardAdd
            itemObj:ReInit(tempParam)
        end)
    end
end

UIPVEResultView.OnCreate = OnCreate
UIPVEResultView.OnDestroy = OnDestroy
UIPVEResultView.OnEnable = OnEnable
UIPVEResultView.OnDisable = OnDisable
UIPVEResultView.OnAddListener = OnAddListener
UIPVEResultView.OnRemoveListener = OnRemoveListener

UIPVEResultView.TimerAction = TimerAction

UIPVEResultView.OnCloseClick = OnCloseClick
UIPVEResultView.OnContinueClick = OnContinueClick
UIPVEResultView.OnReturnClick = OnReturnClick
UIPVEResultView.OnKeyEscape = OnKeyEscape

UIPVEResultView.ShowArenaRewards = ShowArenaRewards

return UIPVEResultView

