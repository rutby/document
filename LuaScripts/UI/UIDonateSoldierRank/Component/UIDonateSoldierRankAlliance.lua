---
--- 黑骑士排行榜联盟排行
--- Created by shimin.
--- DateTime: 2023/3/7 12:17
---
local UIDonateSoldierRankAlliance = BaseClass("UIDonateSoldierRankAlliance", UIBaseContainer)
local base = UIBaseContainer
local UIDonateSoldierRankAllianceCell = require "UI.UIDonateSoldierRank.Component.UIDonateSoldierRankAllianceCell"

local alliance_select_path = "alliance_select"
local alliance_rank_name_text_path = "alliance_select/alliance_rank_name_text"
local alliance_player_name_text_path = "alliance_select/alliance_player_name_text"
local alliance_score_name_text_path = "alliance_select/alliance_score_name_text"
local alliance_reward_name_text_path = "alliance_select/alliance_reward_name_text"
local alliance_scroll_view_path = "alliance_scroll_view"
local alliance_empty_text_path = "alliance_empty_text"

function UIDonateSoldierRankAlliance:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIDonateSoldierRankAlliance:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRankAlliance:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRankAlliance:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRankAlliance:ComponentDefine()
    self.alliance_select = self:AddComponent(UIBaseContainer, alliance_select_path)
    self.alliance_rank_name_text = self:AddComponent(UIText, alliance_rank_name_text_path)
    self.alliance_player_name_text = self:AddComponent(UIText, alliance_player_name_text_path)
    self.alliance_score_name_text = self:AddComponent(UIText, alliance_score_name_text_path)
    self.alliance_reward_name_text = self:AddComponent(UIText, alliance_reward_name_text_path)
    self.alliance_empty_text = self:AddComponent(UIText, alliance_empty_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, alliance_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIDonateSoldierRankAlliance:ComponentDestroy()

end

function UIDonateSoldierRankAlliance:DataDefine()
    self.list = {}
    self.hasInit = false
end

function UIDonateSoldierRankAlliance:DataDestroy()
    self.list = {}
    self.hasInit = false
end

function UIDonateSoldierRankAlliance:OnAddListener()
    base.OnAddListener(self)
end

function UIDonateSoldierRankAlliance:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDonateSoldierRankAlliance:ReInit()
    self.alliance_rank_name_text:SetLocalText(GameDialogDefine.RANK)
    self.alliance_player_name_text:SetLocalText(GameDialogDefine.ALLIANCE)
    self.alliance_score_name_text:SetLocalText(GameDialogDefine.SCORE)
    self.alliance_reward_name_text:SetLocalText(GameDialogDefine.REWARD)
    self.alliance_empty_text:SetLocalText(GameDialogDefine.RANK_ALLIANCE_EMPTY_TIPS)
end

function UIDonateSoldierRankAlliance:Refresh()
    if not self.hasInit then
        self:ReInit()
        self.hasInit = true
    end
    self:ShowCells()
end

function UIDonateSoldierRankAlliance:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.alliance_select:SetActive(true)
        self.alliance_empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.alliance_empty_text:SetActive(true)
        self.alliance_select:SetActive(false)
    end
end

function UIDonateSoldierRankAlliance:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIDonateSoldierRankAllianceCell)--清循环列表gameObject
end

function UIDonateSoldierRankAlliance:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIDonateSoldierRankAllianceCell, itemObj)
    item:ReInit(self.list[index])
end

function UIDonateSoldierRankAlliance:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIDonateSoldierRankAllianceCell)
end

function UIDonateSoldierRankAlliance:GetDataList()
    -- self.list = DataCenter.ActBlackKnightManager:GetAllianceRankHistory()
end

return UIDonateSoldierRankAlliance