---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UILeagueMatchRewardView.lua

local base = UIBaseView--Variable
local UILeagueMatchRewardView = BaseClass("UILeagueMatchRewardView", base)--Variable
local Localization = CS.GameEntry.Localization
local DayRewardPanel = require "UI.LeagueMatch.UILeagueMatchReward.Component.LeagueMatchDayRewardPanel"
local AlRewardPanel = require "UI.LeagueMatch.UILeagueMatchReward.Component.LeagueMatchAlRewardPanel"
local SeasonRewardPanel = require "UI.LeagueMatch.UILeagueMatchReward.Component.LeagueMatchSeasonRewardPanel"

local TabType = {
    DayReward = 1,
    AlReward = 2,
    SeasonReward = 3,
}

local TabName = {
    [TabType.DayReward] = "372815",
    [TabType.AlReward] = "372816",
    [TabType.SeasonReward] = "372817",
}

local TitleName = {
    [TabType.DayReward] = "372637",
    [TabType.AlReward] = "372638",
    [TabType.SeasonReward] = "372639",
}

local SegmentName = {
    [SegmentType.Silver] = "372611",
    [SegmentType.Gold] = "372612",
    [SegmentType.Diamond] = "372613",
}

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local tab_path = "ImgBg/tab/Toggle"
local segmentContainer_path = "layout/segment"
local segment_path = "layout/segment/segment_"
local dayRewardPanel_path = "layout/LeagueMatchDayRewardPanel"
local alRewardPanel_path = "layout/LeagueMatchAlRewardPanel"
local seasonRewardPanel_path = "layout/LeagueMatchSeasonRewardPanel"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.tabTbN = {}
    for i = 1, 3 do
        local tab = self:AddComponent(UIBaseContainer, tab_path .. i)
        local tabBtn = tab:AddComponent(UIButton, "")
        tabBtn:SetOnClick(function()
            self:OnClickTab(i)
        end)
        local select = tab:AddComponent(UIBaseContainer, "Choose")
        local selectTxt = tab:AddComponent(UITextMeshProUGUIEx, "Choose/selectName")
        selectTxt:SetLocalText(TabName[i])
        local unselectTxt = tab:AddComponent(UITextMeshProUGUIEx, "unselectName")
        unselectTxt:SetLocalText(TabName[i])
        local red = tab:AddComponent(UIBaseContainer, "ImgWarn")
        local redNum = tab:AddComponent(UITextMeshProUGUIEx, "ImgWarn/TxtNum")
        local visible = self:CheckIfTabVisible(i)
        tab:SetActive(visible)
        local newTab = {
            rootN = tab,
            btnN = tabBtn,
            selectN = select,
            selectTxtN = selectTxt,
            unselectTxtN = unselectTxt,
            redN = red,
            redNumN = redNum,
            isVisible = visible,
        }
        table.insert(self.tabTbN, newTab)
    end
    self.segmentN = self:AddComponent(UIBaseContainer, segmentContainer_path)
    self.segmentN:SetActive(DataCenter.LeagueMatchManager:CheckIsOpenForReward())
    self.segmentTbN = {}
    for i = 1, 3 do
        local segment = self:AddComponent(UIBaseContainer, segment_path .. i)
        local btn = segment:AddComponent(UIButton, "")
        btn:SetOnClick(function()
            self:OnClickSegment(i)
        end)
        local select = segment:AddComponent(UIBaseContainer, "select")
        local unselect = segment:AddComponent(UIBaseContainer, "unselect")
        local selectTxt = segment:AddComponent(UITextMeshProUGUIEx, "select/selectTxt")
        selectTxt:SetLocalText(SegmentName[i])
        local unselectTxt = segment:AddComponent(UITextMeshProUGUIEx, "unselect/unselectTxt")
        unselectTxt:SetLocalText(SegmentName[i])
        local red = segment:AddComponent(UIBaseContainer, "red")
        local newSeg = {
            selectN = select,
            selectTxtN = selectTxt,
            unselectN = unselect,
            unselectTxtN = unselectTxt,
            redN = red,
            btnN = btn,
        }
        table.insert(self.segmentTbN, newSeg)
    end
    self.dayRewardPanelN = self:AddComponent(DayRewardPanel, dayRewardPanel_path)
    self.alRewardPanelN = self:AddComponent(AlRewardPanel, alRewardPanel_path)
    self.seasonRewardPanelN = self:AddComponent(SeasonRewardPanel, seasonRewardPanel_path)
    self.panelTbN = {
        self.dayRewardPanelN,
        self.alRewardPanelN,
        self.seasonRewardPanelN
    }
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.tabTbN = nil
    self.segmentN = nil
    self.segmentTbN = nil
    self.dayRewardPanelN = nil
    self.alRewardPanelN = nil
    self.seasonRewardPanelN = nil
end

local function DataDefine(self)
    self.curTab = nil
    self.curSegment = SegmentType.None
    self.cacheSeg = SegmentType.None
end

local function DataDestroy(self)
    self.curTab = nil
    self.curSegment = nil
    self.cacheSeg = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnUpdateCandidates)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnUpdateCandidates)
end

local function InitUI(self)
    self.isInMatch = DataCenter.LeagueMatchManager:CheckIsMatchOpen()

    local targetTab, targetSeg = self:GetUserData()
    if not self.tabTbN[targetTab] or not self.tabTbN[targetTab].isVisible then
        for i, v in ipairs(self.tabTbN) do
            if v.isVisible then
                targetTab = i
                break
            end
        end
    end

    if self.isInMatch then
        targetSeg = targetSeg or SegmentType.Silver
    else
        targetSeg = SegmentType.None
    end
    self.cacheSeg = targetSeg
    self:SelectTabAndSegment(targetTab, targetSeg)
end

local function SelectTabAndSegment(self, tab, seg)
    if self.curTab == tab and self.curSegment == seg then
        return
    end
    self.curTab = tab
    self.curSegment = seg
    
    for i, v in ipairs(self.tabTbN) do
        if i == tab then
            v.selectN:SetActive(true)
        else
            v.selectN:SetActive(false)
        end
    end
    for i, v in ipairs(self.segmentTbN) do
        if i == seg then
            v.selectN:SetActive(true)
            v.unselectN:SetActive(false)
        else
            v.unselectN:SetActive(true)
            v.selectN:SetActive(false)
        end
    end
    
    for i = 1, 3 do
        if i == tab then
            self.titleN:SetLocalText(TitleName[i])
            self.panelTbN[i]:SetActive(true)
            self.panelTbN[i]:ShowPanel(self.curSegment)
        else
            self.panelTbN[i]:SetActive(false)
        end
    end
end

local function CheckIfTabVisible(self, tab)
    if tab == TabType.DayReward then
        return true
    else
        return DataCenter.LeagueMatchManager:CheckIsOpenForReward()
    end
end

local function CheckIfInMatch(self)
    return DataCenter.LeagueMatchManager:CheckIfInMatch()
    --local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    --local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
    --if tempStage == LeagueMatchStage.Notice or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
    --    return myMatchInfo.lastDuelInfo
    --else
    --    return myMatchInfo.duelInfo
    --end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickTab(self, index)
    self:SelectTabAndSegment(index, self.cacheSeg)
end

local function OnClickSegment(self, index)
    self:SelectTabAndSegment(self.curTab, index)
end

UILeagueMatchRewardView.OnCreate = OnCreate
UILeagueMatchRewardView.OnDestroy = OnDestroy
UILeagueMatchRewardView.OnAddListener = OnAddListener
UILeagueMatchRewardView.OnRemoveListener = OnRemoveListener
UILeagueMatchRewardView.ComponentDefine = ComponentDefine
UILeagueMatchRewardView.ComponentDestroy = ComponentDestroy
UILeagueMatchRewardView.DataDefine = DataDefine
UILeagueMatchRewardView.DataDestroy = DataDestroy

UILeagueMatchRewardView.InitUI = InitUI
UILeagueMatchRewardView.ResetTabs = ResetTabs
UILeagueMatchRewardView.SelectTabAndSegment = SelectTabAndSegment
UILeagueMatchRewardView.CheckIfTabVisible = CheckIfTabVisible
UILeagueMatchRewardView.CheckIfInMatch = CheckIfInMatch
UILeagueMatchRewardView.GetRewardInfo = GetRewardInfo
UILeagueMatchRewardView.OnClickCloseBtn = OnClickCloseBtn
UILeagueMatchRewardView.OnClickTab = OnClickTab
UILeagueMatchRewardView.OnClickSegment = OnClickSegment

return UILeagueMatchRewardView