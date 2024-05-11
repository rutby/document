--- 黑骑士分数排行榜
--- Created by shimin.
--- DateTime: 2024/2/22 21:01
---

local UIBlackKnightScoreRankView = BaseClass("UIBlackKnightScoreRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleBtnTab = require "UI.UICommonTab.UICommonToggleBtnTab"
local UIBlackKnightScoreRankCell = require "UI.UIBlackKnightScoreRank.Component.UIBlackKnightScoreRankCell"

local TabTypeList =
{
    UIBlackKnightRankType.PersonalRank, UIBlackKnightRankType.AllianceRank
}

local TabNameType =
{
    [UIBlackKnightRankType.PersonalRank] = GameDialogDefine.PERSONAL_RANK,
    [UIBlackKnightRankType.AllianceRank] = GameDialogDefine.ALLIANCE_RANK,
}

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local toggle_btn_path = "ToggleGroupBg/ToggleGroup/ToggleBtn"
local rank_name_text_path = "title_content/rank_name_text"
local player_name_text_path = "title_content/player_name_text"
local score_name_text_path = "title_content/score_name_text"
local scroll_view_path = "scroll_view"
local empty_text_path = "empty_text"
local self_rank_path = "UIBlackKnightScoreRankCell"
local title_content_path = "title_content"

function UIBlackKnightScoreRankView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIBlackKnightScoreRankView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightScoreRankView:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightScoreRankView:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightScoreRankView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.rank_name_text = self:AddComponent(UITextMeshProUGUIEx, rank_name_text_path)
    self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
    self.score_name_text = self:AddComponent(UITextMeshProUGUIEx, score_name_text_path)
    self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.self_rank = self:AddComponent(UIBlackKnightScoreRankCell, self_rank_path)
    self.title_content = self:AddComponent(UIBaseContainer, title_content_path)
    self.toggle_btn = {}
    for i = 1, #TabTypeList, 1 do
        self.toggle_btn[i] = self:AddComponent(UICommonToggleBtnTab, toggle_btn_path .. i)
    end
end

function UIBlackKnightScoreRankView:ComponentDestroy()
  
end

function UIBlackKnightScoreRankView:DataDefine()
    self.rankType = UIBlackKnightRankType.PersonalRank
    self.tabList = {}
    self.on_tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
    self.list = {}
end

function UIBlackKnightScoreRankView:DataDestroy()
    self.rankType = UIBlackKnightRankType.PersonalRank
    self.tabList = {}
    self.on_tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
    self.list = {}
end

function UIBlackKnightScoreRankView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.BlackKnightRank, self.BlackKnightRankSignal)
end

function UIBlackKnightScoreRankView:OnRemoveListener()
    self:RemoveUIListener(EventId.BlackKnightRank, self.BlackKnightRankSignal)
    base.OnRemoveListener(self)
end

function UIBlackKnightScoreRankView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_RANK)
    self:GetTabList(UIBlackKnightRankType.PersonalRank)
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

function UIBlackKnightScoreRankView:BlackKnightRankSignal()
    self:Refresh()
end

function UIBlackKnightScoreRankView:OnTabClick(rankType)
    if  self.rankType ~= rankType then
        self:SetToggleChoose(self.rankType, false)
        self.rankType = rankType
        self:SetToggleChoose(self.rankType, true)
        self:SendMsg()
        self:Refresh()
    end
end

function UIBlackKnightScoreRankView:Refresh()
    if self.rankType == UIBlackKnightRankType.AllianceRank then
        self.rank_name_text:SetLocalText(GameDialogDefine.RANK)
        self.player_name_text:SetLocalText(GameDialogDefine.ALLIANCE)
        self.score_name_text:SetLocalText(GameDialogDefine.SCORE)
        self.empty_text:SetLocalText(GameDialogDefine.RANK_ALLIANCE_EMPTY_TIPS)
        self.self_rank:ReInit(DataCenter.ActBlackKnightManager:GetSelfAllianceRank())
    elseif self.rankType == UIBlackKnightRankType.PersonalRank then
        self.rank_name_text:SetLocalText(GameDialogDefine.RANK)
        self.player_name_text:SetLocalText(GameDialogDefine.PLAYER)
        self.score_name_text:SetLocalText(GameDialogDefine.SCORE)
        self.empty_text:SetLocalText(GameDialogDefine.RANK_USER_EMPTY_TIPS)
        self.self_rank:ReInit(DataCenter.ActBlackKnightManager:GetSelfRank())
    end
    self:ShowCells()
end

function UIBlackKnightScoreRankView:SetToggleChoose(tabType, choose)
    if self.toggle_btn[tabType] ~= nil then
        self.toggle_btn[tabType]:SetSelect(choose)
    end
end

function UIBlackKnightScoreRankView:SendMsg()
    if self.rankType == UIBlackKnightRankType.AllianceRank then
        DataCenter.ActBlackKnightManager:SendMonsterSiegeAllianceRank()
    elseif self.rankType == UIBlackKnightRankType.PersonalRank then
        DataCenter.ActBlackKnightManager:SendMonsterSiegeUserRank()
    end
end

function UIBlackKnightScoreRankView:GetTabList(selectTabType)
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


function UIBlackKnightScoreRankView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.title_content:SetActive(true)
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.title_content:SetActive(false)
        self.empty_text:SetActive(true)
    end
end

function UIBlackKnightScoreRankView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBlackKnightScoreRankCell)--清循环列表gameObject
end

function UIBlackKnightScoreRankView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIBlackKnightScoreRankCell, itemObj)
    item:ReInit(self.list[index])
end

function UIBlackKnightScoreRankView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIBlackKnightScoreRankCell)
end

function UIBlackKnightScoreRankView:GetDataList()
    self.list = {}
    if self.rankType == UIBlackKnightRankType.AllianceRank then
        local list = DataCenter.ActBlackKnightManager:GetAllianceRankHistory()
        for k,v in ipairs(list) do
            local param = {}
            param.rankType = self.rankType
            param.data = v
            table.insert(self.list, param)
        end
    elseif self.rankType == UIBlackKnightRankType.PersonalRank then
        local list = DataCenter.ActBlackKnightManager:GetUserRankHistory()
        for k,v in ipairs(list) do
            local param = {}
            param.rankType = self.rankType
            param.data = v
            table.insert(self.list, param)
        end
    end
end



return UIBlackKnightScoreRankView