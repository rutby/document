---
--- 黑骑士排行榜个人排行
--- Created by shimin.
--- DateTime: 2023/3/7 12:17
---
local UIDonateSoldierRankPersonal = BaseClass("UIDonateSoldierRankPersonal", UIBaseContainer)
local base = UIBaseContainer
local UIDonateSoldierRankPersonalCell = require "UI.UIDonateSoldierRank.Component.UIDonateSoldierRankPersonalCell"

local personal_select_path = "personal_select"
local personal_rank_name_text_path = "personal_select/personal_rank_name_text"
local personal_player_name_text_path = "personal_select/personal_player_name_text"
local personal_score_name_text_path = "personal_select/personal_score_name_text"
local personal_reward_name_text_path = "personal_select/personal_reward_name_text"
local personal_scroll_view_path = "personal_scroll_view"
local personal_empty_text_path = "personal_empty_text"

function UIDonateSoldierRankPersonal:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIDonateSoldierRankPersonal:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRankPersonal:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRankPersonal:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRankPersonal:ComponentDefine()
    self.personal_select = self:AddComponent(UIBaseContainer, personal_select_path)
    self.personal_rank_name_text = self:AddComponent(UIText, personal_rank_name_text_path)
    self.personal_player_name_text = self:AddComponent(UIText, personal_player_name_text_path)
    self.personal_score_name_text = self:AddComponent(UIText, personal_score_name_text_path)
    self.personal_reward_name_text = self:AddComponent(UIText, personal_reward_name_text_path)
    self.personal_empty_text = self:AddComponent(UIText, personal_empty_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, personal_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIDonateSoldierRankPersonal:ComponentDestroy()

end

function UIDonateSoldierRankPersonal:DataDefine()
    self.list = {}
    self.hasInit = false
end

function UIDonateSoldierRankPersonal:DataDestroy()
    self.list = {}
    self.hasInit = false
end

function UIDonateSoldierRankPersonal:OnAddListener()
    base.OnAddListener(self)
end

function UIDonateSoldierRankPersonal:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDonateSoldierRankPersonal:ReInit()
    self.personal_rank_name_text:SetLocalText(GameDialogDefine.RANK)
    self.personal_player_name_text:SetLocalText(GameDialogDefine.PLAYER)
    self.personal_score_name_text:SetLocalText(GameDialogDefine.SCORE)
    self.personal_reward_name_text:SetLocalText(GameDialogDefine.REWARD)
    self.personal_empty_text:SetLocalText(GameDialogDefine.RANK_USER_EMPTY_TIPS)
end

function UIDonateSoldierRankPersonal:Refresh(type)
    if not self.hasInit then
        self:ReInit()
        self.hasInit = true
    end
    self.cell_type = type
    self:ShowCells()
end

function UIDonateSoldierRankPersonal:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.personal_select:SetActive(true)
        self.personal_empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.personal_empty_text:SetActive(true)
        self.personal_select:SetActive(false)
    end
end

function UIDonateSoldierRankPersonal:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIDonateSoldierRankPersonalCell)--清循环列表gameObject
end

function UIDonateSoldierRankPersonal:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIDonateSoldierRankPersonalCell, itemObj)
    item:ReInit(self.list[index])
end

function UIDonateSoldierRankPersonal:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIDonateSoldierRankPersonalCell)
end

function UIDonateSoldierRankPersonal:GetDataList()
    self.list = DataCenter.ActivityDonateSoldierManager:GetDonateSolderRankArrayByType(self.cell_type)
end

return UIDonateSoldierRankPersonal