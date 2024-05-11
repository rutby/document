---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/1 14:45
---

local UIGloryDeclare = BaseClass("UIGloryDeclare", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGloryDeclareItem = require "UI.UIGlory.UIGloryDeclare.Component.UIGloryDeclareItem"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local return_path = "UICommonPopUpTitle/panel"
local close_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local rank_path = "Top/Rank"
local rank_icon_path = "Top/RankIcon"
local left_alliance_name_path = "Top/LeftAllianceName"
local left_power_path = "Top/LeftPower"
local left_score_path = "Top/LeftScore"
local left_alliance_flag_path = "Top/LeftAllianceFlag"
local right_desc_path = "Top/RightDesc"
local match_btn_path = "Match"
local match_text_path = "Match/MatchText"
local match_cost_path = "Match/MatchCost"
local scroll_view_path = "ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_path)
    self.rank_text = self:AddComponent(UIText, rank_path)
    self.rank_icon_image = self:AddComponent(UIImage, rank_icon_path)
    self.left_alliance_name_text = self:AddComponent(UIText, left_alliance_name_path)
    self.left_power_text = self:AddComponent(UIText, left_power_path)
    self.left_score_text = self:AddComponent(UIText, left_score_path)
    self.left_alliance_flag = self:AddComponent(AllianceFlagItem, left_alliance_flag_path)
    self.right_desc_text = self:AddComponent(UIText, right_desc_path)
    self.match_btn = self:AddComponent(UIButton, match_btn_path)
    self.match_btn:SetOnClick(function()
        self:OnMatchClick()
    end)
    self.match_text = self:AddComponent(UIText, match_text_path)
    self.match_text:SetLocalText(302839)
    self.match_cost_text = self:AddComponent(UIText, match_cost_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    self.return_btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.scroll_view = nil
end

local function DataDefine(self)
    self.cost = 0
    self.allianceData = nil
    self.warData = nil
    self.dataList = {}
end

local function DataDestroy(self)
    self.cost = nil
    self.allianceData = nil
    self.warData = nil
    self.dataList = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GloryGetDeclareAlliance, self.OnGloryGetDeclareAlliance)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GloryGetDeclareAlliance, self.OnGloryGetDeclareAlliance)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryDeclareItem, itemObj)
    item:SetData(self.dataList[index])
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryDeclareItem)
end

local function ShowScroll(self)
    local count = #self.dataList
    if count > 0 then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
    end
end

local function ReInit(self)
    DataCenter.GloryManager:SendGetDeclareAlliance()
end

local function Refresh(self)
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local warData = DataCenter.GloryManager:GetWarData()
    self.cost = DataCenter.GloryManager:GetMatchCost()
    self.allianceData = allianceData
    self.warData = warData
    if warData.seasonRank <= 3 then
        self.rank_text:SetActive(false)
        self.rank_icon_image:SetActive(true)
        self.rank_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. warData.seasonRank)
    else
        self.rank_text:SetActive(true)
        self.rank_text:SetText(warData.seasonRank)
        self.rank_icon_image:SetActive(false)
    end
    self.left_alliance_name_text:SetText(UIUtil.GetAllianceWholeName(allianceData.ownerServerId, allianceData.abbr, allianceData.allianceName))
    self.left_power_text:SetText(string.GetFormattedSeperatorNum(allianceData.fightPower))
    self.left_score_text:SetText(string.GetFormattedSeperatorNum(warData.seasonScore))
    self.left_alliance_flag:SetData(allianceData.icon)
    self.right_desc_text:SetText("")
    self.match_cost_text:SetText(string.GetFormattedSeperatorNum(self.cost))
    self.dataList = DataCenter.GloryManager:GetDeclareAllianceDataList()
    self:ShowScroll()
end

local function OnMatchClick(self)
    if DataCenter.GloryManager:HasEnoughTimeToDeclare() then
        local haveCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(RewardType.SAPPHIRE)
        if haveCount >= self.cost then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryMatch)
            self.view.ctrl:CloseSelf()
        else
            UIUtil.ShowTipsId(120020)
        end
    else
        UIUtil.ShowTipsId(302842)
    end
end

local function OnGloryGetDeclareAlliance(self)
    self:Refresh()
end

UIGloryDeclare.OnCreate = OnCreate
UIGloryDeclare.OnDestroy = OnDestroy
UIGloryDeclare.OnEnable = OnEnable
UIGloryDeclare.OnDisable = OnDisable
UIGloryDeclare.ComponentDefine = ComponentDefine
UIGloryDeclare.ComponentDestroy = ComponentDestroy
UIGloryDeclare.DataDefine = DataDefine
UIGloryDeclare.DataDestroy = DataDestroy
UIGloryDeclare.OnAddListener = OnAddListener
UIGloryDeclare.OnRemoveListener = OnRemoveListener

UIGloryDeclare.OnCreateCell = OnCreateCell
UIGloryDeclare.OnDeleteCell = OnDeleteCell
UIGloryDeclare.ShowScroll = ShowScroll

UIGloryDeclare.ReInit = ReInit
UIGloryDeclare.Refresh = Refresh

UIGloryDeclare.OnMatchClick = OnMatchClick

UIGloryDeclare.OnGloryGetDeclareAlliance = OnGloryGetDeclareAlliance

return UIGloryDeclare