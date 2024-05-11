---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/27 16:01
---LeagueMatchNoticePanel.lua

local LeagueMatchNoticePanel = BaseClass("LeagueMatchNoticePanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path = "title"
local subTitle_path = "subTitle"
local infoBtn_path = "rightLayer/infoBtn"
local rewardBtn_path = "rightLayer/rewardBtn"
local rewardBtnTxt_path = "rightLayer/rewardBtn/rewawdTxt"
local cdTime_path = "cdTime"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function DataDefine(self)
    self.baseInfo = nil
end

local function DataDestroy(self)
    self.baseInfo = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
    base.OnRemoveListener(self)
end


local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.subTitleN = self:AddComponent(UITextMeshProUGUIEx, subTitle_path)
    self.subTitleN:SetLocalText("372617")
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
    self.rewardBtnN:SetOnClick(function()
        self:OnClickRewardBtn()
    end)
    self.rewardBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, rewardBtnTxt_path)
    self.rewardBtnTxtN:SetLocalText(100072)
    self.cdTimeN = self:AddComponent(UITextMeshProUGUIEx, cdTime_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.subTitleN = nil
    self.infoBtnN = nil
    self.rewardBtnN = nil
    self.cdTimeN = nil
end

local function ShowPanel(self)    
    self:RefreshAll()
end

local function RefreshAll(self)
    if IsNull(self.gameObject) then
        return
    end
    
    self.baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
    if not self.baseInfo then
        return
    end
    self.titleN:SetLocalText("372616", self.baseInfo.season)
    self.subTitleN:SetLocalText("372617")
    
    self:AddCountDownTimer()
end


local function AddCountDownTimer(self)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.baseInfo.drawStartTime - curTime
    if remainTime > 0 then
        self.cdTimeN:SetText(Localization:GetString("372618", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
    else
        self.cdTimeN:SetText("")
        self:DelCountDownTimer()
        DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnClickInfoBtn(self)
    UIUtil.ShowIntro(Localization:GetString("100239"), Localization:GetString("100239")
    , Localization:GetString("372813"))
end

local function OnClickRewardBtn(self)
    local targetTab = 3
    local targetSeg = SegmentType.Silver
    local matchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
    local duelInfo = matchInfo and matchInfo.duelInfo --DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
    if duelInfo then
        if duelInfo.rankType == SegmentType.Silver then
            targetSeg = SegmentType.Silver
        elseif duelInfo.rankType == SegmentType.Gold then
            targetSeg = SegmentType.Gold
        else
            targetSeg = SegmentType.Diamond
        end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILeagueMatchReward, { anim = true }, targetTab, targetSeg)
end


LeagueMatchNoticePanel.OnCreate = OnCreate
LeagueMatchNoticePanel.OnDestroy = OnDestroy
LeagueMatchNoticePanel.DataDefine = DataDefine
LeagueMatchNoticePanel.DataDestroy = DataDestroy
LeagueMatchNoticePanel.ComponentDefine = ComponentDefine
LeagueMatchNoticePanel.ComponentDestroy = ComponentDestroy
LeagueMatchNoticePanel.OnAddListener = OnAddListener
LeagueMatchNoticePanel.OnRemoveListener = OnRemoveListener

LeagueMatchNoticePanel.RefreshAll = RefreshAll
LeagueMatchNoticePanel.AddCountDownTimer = AddCountDownTimer
LeagueMatchNoticePanel.RefreshRemainTime = RefreshRemainTime
LeagueMatchNoticePanel.DelCountDownTimer = DelCountDownTimer
LeagueMatchNoticePanel.OnClickInfoBtn = OnClickInfoBtn
LeagueMatchNoticePanel.OnClickRewardBtn = OnClickRewardBtn
LeagueMatchNoticePanel.ShowPanel = ShowPanel

return LeagueMatchNoticePanel