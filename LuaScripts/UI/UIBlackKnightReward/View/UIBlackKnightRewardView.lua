--- 黑骑士奖励
--- Created by shimin.
--- DateTime: 2024/2/23 17:24

local UIBlackKnightRewardView = BaseClass("UIBlackKnightRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBlackKnightRewardScoreCell = require "UI.UIBlackKnightReward.Component.UIBlackKnightRewardScoreCell"
local UIBlackKnightRewardCell = require "UI.UIBlackKnightReward.Component.UIBlackKnightRewardCell"
local UICommonToggleBtnTab = require "UI.UICommonTab.UICommonToggleBtnTab"

local RankType = 
{
    ScoreReward = 1,--积分奖励
    PersonalRank = 2,--个人排行
    AllianceRank = 3,--联盟排行
}

local TabTypeList =
{
    RankType.ScoreReward, RankType.PersonalRank, RankType.AllianceRank
}

local TabNameType =
{
    [RankType.ScoreReward] = GameDialogDefine.ACTIVITY_REWARD,
    [RankType.PersonalRank] = GameDialogDefine.PERSONAL_RANK,
    [RankType.AllianceRank] = GameDialogDefine.ALLIANCE_RANK,
}

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local toggle_btn_path = "ToggleGroupBg/ToggleGroup/ToggleBtn"
local score_reward_go_path = "score_reward_go"
local score_reward_personal_score_text_path = "score_reward_go/score_reward_select/score_reward_personal_score_text"
local score_reward_personal_score_num_path = "score_reward_go/score_reward_select/score_reward_personal_score_num"
local score_reward_alliance_score_text_path = "score_reward_go/score_reward_select/score_reward_alliance_score_text"
local score_reward_alliance_score_num_path = "score_reward_go/score_reward_select/score_reward_alliance_score_num"
local score_reward_score_get_text_path = "score_reward_go/score_reward_select/score_reward_score_get_text"
local score_reward_Info_btn_path = "score_reward_go/score_reward_select/score_reward_Info_btn"
local score_reward_scroll_view_path = "score_reward_go/score_reward_scroll_view"
local rank_go_path = "rank_go"
local rank_text_path = "rank_go/rank_text"
local rank_num_text_path = "rank_go/rank_text/rank_num_text"
local time_text_path = "rank_go/time_text"
local time_num_text_path = "rank_go/time_num_text"
local rank_scroll_view_path = "rank_go/rank_scroll_view"

function UIBlackKnightRewardView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIBlackKnightRewardView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightRewardView:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightRewardView:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightRewardView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.toggle_btn = {}
    for i = 1, #TabTypeList, 1 do
        self.toggle_btn[i] = self:AddComponent(UICommonToggleBtnTab, toggle_btn_path .. i)
    end
    
    self.score_reward_go = self:AddComponent(UIBaseContainer, score_reward_go_path)
    self.rank_go = self:AddComponent(UIBaseContainer, rank_go_path)
    self.score_reward_personal_score_text = self:AddComponent(UITextMeshProUGUIEx, score_reward_personal_score_text_path)
    self.score_reward_personal_score_num = self:AddComponent(UITextMeshProUGUIEx, score_reward_personal_score_num_path)
    self.score_reward_alliance_score_text = self:AddComponent(UITextMeshProUGUIEx, score_reward_alliance_score_text_path)
    self.score_reward_alliance_score_num = self:AddComponent(UITextMeshProUGUIEx, score_reward_alliance_score_num_path)
    self.score_reward_score_get_text = self:AddComponent(UITextMeshProUGUIEx, score_reward_score_get_text_path)
    self.score_reward_Info_btn = self:AddComponent(UIButton, score_reward_Info_btn_path)
    self.score_reward_Info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.score_scroll_view = self:AddComponent(UIScrollView, score_reward_scroll_view_path)
    self.score_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnScoreCellMoveIn(itemObj, index)
    end)
    self.score_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnScoreCellMoveOut(itemObj, index)
    end)
    self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
    self.rank_num_text = self:AddComponent(UITextMeshProUGUIEx, rank_num_text_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
    self.time_num_text = self:AddComponent(UITextMeshProUGUIEx, time_num_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, rank_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIBlackKnightRewardView:ComponentDestroy()
  
end

function UIBlackKnightRewardView:DataDefine()
    self.rankType = RankType.ScoreReward
    self.tabList = {}
    self.on_tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
    self.score_list = {}
    self.list = {}
    self.rewardEndTime = 0
    self.time_callback = function() 
        self:RefreshTime()
    end
end

function UIBlackKnightRewardView:DataDestroy()
    self:DeleteTimer()
    self.rankType = RankType.ScoreReward
    self.tabList = {}
    self.on_tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
    self.score_list = {}
    self.list = {}
    self.rewardEndTime = 0
end

function UIBlackKnightRewardView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
end

function UIBlackKnightRewardView:OnRemoveListener()
    self:RemoveUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
    base.OnRemoveListener(self)
end

function UIBlackKnightRewardView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.ACTIVITY_REWARD)
    self.score_reward_score_get_text:SetLocalText(GameDialogDefine.SCORE_GET)
    self.score_reward_alliance_score_text:SetLocalText(GameDialogDefine.ALLIANCE_SCORE_WITH, "")
    self.score_reward_personal_score_text:SetLocalText(GameDialogDefine.PERSONAL_SCORE_WITH, "")
    self.time_text:SetLocalText(GameDialogDefine.ACTIVITY_LEFT_TIME)
    self:GetTabList(RankType.ScoreReward)
    for k, v in ipairs(self.toggle_btn) do
        local tabParam = self.tabList[k]
        if tabParam == nil then
            v:SetActive(false)
        else
            v:ReInit(tabParam)
        end
    end
    self:SendMsg()
    self:Refresh()
end

function UIBlackKnightRewardView:BlackKnightUpdateSignal()
    if self.rankType == RankType.ScoreReward then
        self:Refresh()
    end
end

function UIBlackKnightRewardView:OnTabClick(rankType)
    if  self.rankType ~= rankType then
        self:SetToggleChoose(self.rankType, false)
        self.rankType = rankType
        self:SetToggleChoose(self.rankType, true)
        self:SendMsg()
        self:Refresh()
    end
end

function UIBlackKnightRewardView:Refresh()
    if self.rankType == RankType.ScoreReward then
        self.score_reward_go:SetActive(true)
        self.rank_go:SetActive(false)

        local info = DataCenter.ActBlackKnightManager:GetActInfo()
        if info ~= nil then
            self.score_reward_alliance_score_num:SetText(string.GetFormattedSeperatorNum(info.allKill))
            self.score_reward_personal_score_num:SetText(string.GetFormattedSeperatorNum(info.userKill))
        end
        self:ShowScoreCells()
    elseif self.rankType == RankType.AllianceRank then
        self.score_reward_go:SetActive(false)
        self.rank_go:SetActive(true)
        self.rank_text:SetLocalText(GameDialogDefine.ALLIANCE_RANK)
        local info = DataCenter.ActBlackKnightManager:GetActInfo()
        if info ~= nil then
            if info.allRank == nil or info.allRank <= 0 then
                self.rank_num_text:SetLocalText(GameDialogDefine.UN_RANK)
            else
                self.rank_num_text:SetText(info.allRank)
            end
            if info.rewardTime ~= nil and info.rewardTime ~= 0 then
                self.rewardEndTime = info.rewardTime
            else
                self.rewardEndTime = info.activityET
            end
            self:AddTimer()
            self:RefreshTime()
        end
        self:ShowCells()
    elseif self.rankType == RankType.PersonalRank then
        self.score_reward_go:SetActive(false)
        self.rank_go:SetActive(true)
        self.rank_text:SetLocalText(GameDialogDefine.PERSONAL_RANK)
        local info = DataCenter.ActBlackKnightManager:GetActInfo()
        if info ~= nil then
            if info.userRank == nil or info.userRank <= 0 then
                self.rank_num_text:SetLocalText(GameDialogDefine.UN_RANK)
            else
                self.rank_num_text:SetText(info.userRank)
            end
            if info.rewardTime ~= nil and info.rewardTime ~= 0 then
                self.rewardEndTime = info.rewardTime
            else
                self.rewardEndTime = info.activityET
            end
            self:AddTimer()
            self:RefreshTime()
        end
        self:ShowCells()
    end
end

function UIBlackKnightRewardView:SetToggleChoose(tabType, choose)
    if self.toggle_btn[tabType] ~= nil then
        self.toggle_btn[tabType]:SetSelect(choose)
    end
end

function UIBlackKnightRewardView:SendMsg()
    if self.rankType == RankType.ScoreReward then
        DataCenter.ActBlackKnightManager:SendMonsterSiegeActivityInfo()
    end
end

function UIBlackKnightRewardView:GetTabList(selectTabType)
    self.tabList = {}
    local index = 0
    for _, tabType in ipairs(TabTypeList) do
        index = index + 1
        local tabParam = {}
        tabParam.index = index
        if selectTabType == tabType then
            tabParam.select = true
            self.rankType = index
        else
            tabParam.select = false
        end
        tabParam.tabType = tabType
        tabParam.visible = true
        tabParam.callback = self.on_tab_callback
        tabParam.name = Localization:GetString(TabNameType[tabType])
        table.insert(self.tabList, tabParam)
    end
end


function UIBlackKnightRewardView:OnInfoBtnClick()
    UIUtil.ShowIntro(Localization:GetString(GameDialogDefine.BLACK_KNIGHT), Localization:GetString(GameDialogDefine.SCORE_GET)
    , Localization:GetString(GameDialogDefine.SCORE_GET_TIPS))
end

function UIBlackKnightRewardView:ShowScoreCells()
    self:ClearScoreScroll()
    self:GetScoreDataList()
    local count = table.count(self.score_list)
    if count > 0 then
        self.score_scroll_view:SetTotalCount(count)
        self.score_scroll_view:RefillCells()
    end
end

function UIBlackKnightRewardView:ClearScoreScroll()
    self.score_scroll_view:ClearCells()--清循环列表数据
    self.score_scroll_view:RemoveComponents(UIBlackKnightRewardScoreCell)--清循环列表gameObject
end

function UIBlackKnightRewardView:OnScoreCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.score_scroll_view:AddComponent(UIBlackKnightRewardScoreCell, itemObj)
    item:ReInit(self.score_list[index])
end

function UIBlackKnightRewardView:OnScoreCellMoveOut(itemObj, index)
    self.score_scroll_view:RemoveComponent(itemObj.name, UIBlackKnightRewardScoreCell)
end

function UIBlackKnightRewardView:GetScoreDataList()
    self.score_list = DataCenter.ActBlackKnightManager:GetLevelRankRewardList()
end

function UIBlackKnightRewardView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIBlackKnightRewardView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBlackKnightRewardCell)--清循环列表gameObject
end

function UIBlackKnightRewardView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIBlackKnightRewardCell, itemObj)
    item:ReInit(self.list[index])
end

function UIBlackKnightRewardView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIBlackKnightRewardCell)
end

function UIBlackKnightRewardView:GetDataList()
    self.list = {}
    local info = DataCenter.ActBlackKnightManager:GetActInfo()
    if info ~= nil then
        if self.rankType == RankType.AllianceRank then
            local list = DataCenter.ActBlackKnightManager:GetAllianceRewardList()
            for k,v in ipairs(list) do
                local param = {}
                param.rank = v.rank
                param.reward = v.reward
                param.select = info.allRank == (v.rank + 1)
                table.insert(self.list, param)
            end
        elseif self.rankType == RankType.PersonalRank then
            local list = DataCenter.ActBlackKnightManager:GetUserRewardList()
            for k,v in ipairs(list) do
                local param = {}
                param.rank = v.rank
                param.reward = v.reward
                param.select = info.userRank == (v.rank + 1)
                table.insert(self.list, param)
            end
        end
    end
end

function UIBlackKnightRewardView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.rewardEndTime and self.rewardEndTime > 0 then
        self.time_num_text:SetActive(true)
        local ingLeftTime = self.rewardEndTime - curTime
        if ingLeftTime >= 0 then
            self.time_num_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(ingLeftTime))
        else
            self:Refresh()
        end
    else
        self.time_num_text:SetActive(false)
        self:DeleteTimer()
    end
end

function UIBlackKnightRewardView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIBlackKnightRewardView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback ,self, false, false, false)
        self.timer:Start()
    end
end


return UIBlackKnightRewardView