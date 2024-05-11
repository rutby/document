---
--- 荣耀之战联赛分组
--- Created by shimin.
--- DateTime: 2023/2/28 18:56
---

local UIGloryAllianceIntelligenceView = BaseClass("UIGloryAllianceIntelligenceView", UIBaseView)
local base = UIBaseView
local UIGloryAllianceIntelligenceCell = require "UI.UIGlory.UIGloryAllianceIntelligence.Component.UIGloryAllianceIntelligenceCell"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local GloryContribution = require "DataCenter.Glory.GloryContribution"

--分数排序类型
local RankSortType = 
{
    High = 1,
    Low = 2,
}

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local flag_path = "ImgBg/TopInfo/AllianceFlag"
local abbr_name_text_path = "ImgBg/TopInfo/nameBg/abbr_name_text"
local rank_text_path = "ImgBg/TopInfo/layout/rank_text"
local rank_value_text_path = "ImgBg/TopInfo/layout/rank_text/rank_value_text"
local score_text_path = "ImgBg/TopInfo/layout/score_text"
local score_value_text_path = "ImgBg/TopInfo/layout/score_text/score_value_text"
local rest_time_text_path = "ImgBg/TopInfo/layout/rest_time_text"
local rest_time_value_text_path = "ImgBg/TopInfo/layout/rest_time_text/rest_time_value_text"
local record_btn_path = "ImgBg/TopInfo/record_btn"
local record_btn_text_path = "ImgBg/TopInfo/record_btn/record_btn_text"
local set_rest_btn_path = "ImgBg/TopInfo/set_rest_btn"
local set_rest_btn_text_path = "ImgBg/TopInfo/set_rest_btn/set_rest_btn_text"
local toggle_path = "ImgBg/ToggleGroup/Toggle%s"
local player_name_text_path = "ImgBg/Head/player_name_text"
local score_name_text_path = "ImgBg/Head/score_sort_btn/score_name_text"
local score_sort_btn_path = "ImgBg/Head/score_sort_btn"
local scroll_view_path = "ImgBg/ScrollView"
local my_bottom_cell_path = "ImgBg/MyItemBottom"
local empty_text_path = "ImgBg/empty_text"
local head_go_path = "ImgBg/Head"

function UIGloryAllianceIntelligenceView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryAllianceIntelligenceView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryAllianceIntelligenceView:OnEnable()
    base.OnEnable(self)
end

function UIGloryAllianceIntelligenceView:OnDisable()
    base.OnDisable(self)
end

function UIGloryAllianceIntelligenceView:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)

    self.flagN = self:AddComponent(AllianceFlagItem, flag_path)
    self.abbr_name_text = self:AddComponent(UIText, abbr_name_text_path)
    self.rank_text = self:AddComponent(UIText, rank_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.rest_time_text = self:AddComponent(UIText, rest_time_text_path)
    self.record_btn = self:AddComponent(UIButton, record_btn_path)
    self.record_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRecordBtnClick()
    end)
    self.record_btn_text = self:AddComponent(UIText, record_btn_text_path)
    self.set_rest_btn = self:AddComponent(UIButton, set_rest_btn_path)
    self.set_rest_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSetRestBtnClick()
    end)
    self.set_rest_btn_text = self:AddComponent(UIText, set_rest_btn_text_path)
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.score_name_text = self:AddComponent(UIText, score_name_text_path)
    self.score_sort_btn = self:AddComponent(UIButton, score_sort_btn_path)
    self.score_sort_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnScoreSortBtnClick()
    end)
    self.my_bottom_cell = self:AddComponent(UIGloryAllianceIntelligenceCell, my_bottom_cell_path)
    self.rank_value_text = self:AddComponent(UIText, rank_value_text_path)
    self.score_value_text = self:AddComponent(UIText, score_value_text_path)
    self.rest_time_value_text = self:AddComponent(UIText, rest_time_value_text_path)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
    self.head_go = self:AddComponent(UIBaseContainer, head_go_path)
    
    self.toggle = {}
    for k,v in pairs(GloryScoreRankType) do
        local toggle = self:AddComponent(UIToggle, string.format(toggle_path, v))
        if toggle ~= nil then
            toggle:SetOnValueChanged(function(tf)
                if tf then
                    self:ToggleControlBorS(v)
                end
            end)
            --toggle.redPoint = toggle:AddComponent(UIBaseContainer, "redPoint")
            toggle.showName = toggle:AddComponent(UIText, "Txt_ListToggle")
            self.toggle[v] = toggle
        end
    end
    
end

function UIGloryAllianceIntelligenceView:ComponentDestroy()
  
end

function UIGloryAllianceIntelligenceView:DataDefine()
    self.rankType = GloryScoreRankType.Week
    self.rankSortType = RankSortType.High
    self.list = {}
    self.myRankInfo = nil
end

function UIGloryAllianceIntelligenceView:DataDestroy()
    self.rankType = GloryScoreRankType.Week
    self.rankSortType = RankSortType.High
    self.list = {}
    self.myRankInfo = nil
end

function UIGloryAllianceIntelligenceView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GloryGetWarData, self.GloryGetWarDataSignal)
    self:AddUIListener(EventId.GloryGetContribution, self.GloryGetContributionSignal)
    self:AddUIListener(EventId.GlorySetAvoid, self.GlorySetAvoidSignal)
end

function UIGloryAllianceIntelligenceView:OnRemoveListener()
    self:RemoveUIListener(EventId.GloryGetWarData, self.GloryGetWarDataSignal)
    self:RemoveUIListener(EventId.GloryGetContribution, self.GloryGetContributionSignal)
    self:RemoveUIListener(EventId.GlorySetAvoid, self.GlorySetAvoidSignal)
    base.OnRemoveListener(self)
end

function UIGloryAllianceIntelligenceView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.ALLIANCE_INTELLIGENCE)
    self.empty_text:SetLocalText(GameDialogDefine.RANK_EMPTY_DES)
    for k,v in pairs(self.toggle) do
        if k == GloryScoreRankType.Week then
            v.showName:SetLocalText(GameDialogDefine.WEEK)
        elseif k == GloryScoreRankType.Season then
            v.showName:SetLocalText(GameDialogDefine.SEASON)
        end
        self:SetToggleTabSelect(k, false)
    end
    self.rankType = GloryScoreRankType.Week
    if self.toggle[self.rankType] ~= nil then
        self.toggle[self.rankType]:SetIsOn(true)
    end

    self:SetToggleTabSelect(self.rankType, true)
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData ~= nil then
        self.flagN:SetData(allianceData.icon)
        self.abbr_name_text:SetText('[' .. allianceData.abbr ..']' .. allianceData.allianceName)
    end
    self.rank_text:SetLocalText(GameDialogDefine.RANK)
    self.score_text:SetLocalText(GameDialogDefine.SCORE)
    self.rest_time_text:SetLocalText(GameDialogDefine.REST_TIME)
    self.record_btn_text:SetLocalText(GameDialogDefine.DECLARATION_RECORD)
    self.set_rest_btn_text:SetLocalText(GameDialogDefine.SET_REST_TIME)
    self.player_name_text:SetLocalText(GameDialogDefine.PLAYER)
    self.score_name_text:SetLocalText(GameDialogDefine.CONTRIBUTE)
    self:RefreshAllianceScore()
    DataCenter.GloryManager:SendGetContribution(self.rankType)
    self:ShowCells()
end

function UIGloryAllianceIntelligenceView:RefreshAllianceScore()
    local warData = DataCenter.GloryManager:GetWarData()
    if warData ~= nil then
        self.rank_value_text:SetText(warData.seasonRank)
        self.score_value_text:SetText(string.GetFormattedSeperatorNum(warData.seasonScore))
        self.rest_time_value_text:SetText(warData:GetShowAvoidTime())
    end
end

function UIGloryAllianceIntelligenceView:OnRecordBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryAllianceDeclareRecord)
end
function UIGloryAllianceIntelligenceView:OnSetRestBtnClick()
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryAllianceSetTruce)
    else
        UIUtil.ShowTipsId(GameDialogDefine.CANT_SET_TRUCE_TIPS)
    end
end

function UIGloryAllianceIntelligenceView:OnScoreSortBtnClick()
    if self.rankSortType == RankSortType.High then
        self.rankSortType = RankSortType.Low
    else
        self.rankSortType = RankSortType.High
    end
    self:ShowCells()
end

function UIGloryAllianceIntelligenceView:ToggleControlBorS(rankType)
    if self.rankType ~= rankType then
        self:SetToggleTabSelect(self.rankType, false)
    end
    self.rankType = rankType
    self:SetToggleTabSelect(self.rankType, true)
    DataCenter.GloryManager:SendGetContribution(self.rankType)
    self:ShowCells()
end

--联盟信息刷新
function UIGloryAllianceIntelligenceView:GloryGetWarDataSignal()
    self:RefreshAllianceScore()
end

--盟友贡献排行信息刷新
function UIGloryAllianceIntelligenceView:GloryGetContributionSignal(rankType)
    if self.rankType == rankType then
        self:ShowCells()
    end
end

function UIGloryAllianceIntelligenceView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.head_go:SetActive(true)
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.head_go:SetActive(false)
        self.empty_text:SetActive(true)
    end
    self.my_bottom_cell:ReInit(self.myRankInfo)
end

function UIGloryAllianceIntelligenceView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIGloryAllianceIntelligenceCell)--清循环列表gameObject
end

function UIGloryAllianceIntelligenceView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryAllianceIntelligenceCell, itemObj)
    if self.rankSortType == RankSortType.High then
        item:ReInit(self.list[index])
    else
        item:ReInit(self.list[#self.list - index + 1])
    end
end

function UIGloryAllianceIntelligenceView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryAllianceIntelligenceCell)
end

function UIGloryAllianceIntelligenceView:GetDataList()
    local myUid = LuaEntry.Player.uid
    self.myRankInfo = nil
    self.list = {}
    local contributionList = DataCenter.GloryManager:GetContributionList()
    if contributionList ~= nil and #contributionList > 0 then
        if #contributionList > 1 then
            table.sort(contributionList, function(a,b)
                return b.score < a.score
            end)
        end
        for k,v in ipairs(contributionList) do
            local param = {}
            param.rank = k
            param.contribution = v
            table.insert(self.list, param)
            if v.uid == myUid then
                self.myRankInfo = param
            end
        end
    end
    if self.myRankInfo == nil then
        local param = {}
        param.rank = 0
        local contribution = GloryContribution.New()
        contribution.score = 0
        contribution.rank = 0
        contribution.name = LuaEntry.Player.name
        contribution.uid = LuaEntry.Player.uid
        contribution.pic = LuaEntry.Player.pic
        contribution.picVer = LuaEntry.Player.picVer
        contribution.headSkinId = LuaEntry.Player.headSkinId
        contribution.headSkinET = LuaEntry.Player.headSkinET
        contribution.sex = LuaEntry.Player.sex
        contribution.power = LuaEntry.Player.power
        param.contribution = contribution
        self.myRankInfo = param
    end
end

function UIGloryAllianceIntelligenceView:GlorySetAvoidSignal()
    self:RefreshAllianceScore()
end

function UIGloryAllianceIntelligenceView:SetToggleTabSelect(tabType, isSelect)
    if self.toggle[tabType] ~= nil then
        local nameText =  self.toggle[tabType].showName
        if nameText ~= nil then
            if isSelect then
                nameText:SetColor(TabSelectColor)
                nameTextShadow:AllEnable(true)
                nameTextShadow:SetAllColor(TabSelectShadow)
                nameText:SetAnchoredPosition(TabSelectHeightVec)
            else
                nameText:SetColor(TabUnSelectColor)
                nameTextShadow:AllEnable(false)
                nameText:SetAnchoredPosition(TabUnSelectHeightVec)
            end
        end
    end
end

return UIGloryAllianceIntelligenceView