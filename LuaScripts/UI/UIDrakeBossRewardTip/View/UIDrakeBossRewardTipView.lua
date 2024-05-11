--- Created by shimin
--- DateTime: 2023/11/1 15:22
--- 德雷克boss查看奖励界面

local UIDrakeBossRewardTipView = BaseClass("UIDrakeBossRewardTipView", UIBaseView)
local base = UIBaseView
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local call_reward_text_path = "call_go/call_reward_text"
local call_scroll_view_path = "call_go/call_scroll_view"
local join_reward_text_path = "join_go/join_reward_text"
local join_reward_des_text_path = "join_go/join_reward_des_text"
local join_scroll_view_path = "join_go/join_scroll_view"


function UIDrakeBossRewardTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIDrakeBossRewardTipView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.call_reward_text = self:AddComponent(UITextMeshProUGUIEx, call_reward_text_path)
    self.join_reward_text = self:AddComponent(UITextMeshProUGUIEx, join_reward_text_path)
    self.join_reward_des_text = self:AddComponent(UITextMeshProUGUIEx, join_reward_des_text_path)
    self.call_scroll_view = self:AddComponent(UIScrollView, call_scroll_view_path)
    self.call_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCallCellMoveIn(itemObj, index)
    end)
    self.call_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCallCellMoveOut(itemObj, index)
    end)
    self.join_scroll_view = self:AddComponent(UIScrollView, join_scroll_view_path)
    self.join_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnJoinCellMoveIn(itemObj, index)
    end)
    self.call_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnJoinCellMoveOut(itemObj, index)
    end)
end

function UIDrakeBossRewardTipView:ComponentDestroy()
end

function UIDrakeBossRewardTipView:DataDefine()
    self.call_list = {}
    self.join_list = {}
end

function UIDrakeBossRewardTipView:DataDestroy()
    self.call_list = {}
    self.join_list = {}
end

function UIDrakeBossRewardTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDrakeBossRewardTipView:OnEnable()
    base.OnEnable(self)
end

function UIDrakeBossRewardTipView:OnDisable()
    base.OnDisable(self)
end

function UIDrakeBossRewardTipView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshDrakeBoss, self.RefreshDrakeBossSignal)
end

function UIDrakeBossRewardTipView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshDrakeBoss, self.RefreshDrakeBossSignal)
end

function UIDrakeBossRewardTipView:ReInit()
    self.title_text:SetLocalText(372721)
    self.call_reward_text:SetLocalText(302636)
    self.join_reward_text:SetLocalText(302637)
    self:Refresh()
    self:ShowCallCells()
    self:ShowJoinCells()
end

function UIDrakeBossRewardTipView:Refresh()
    local cur = DataCenter.ActDrakeBossManager:GetCurJoinTimes()
    local all = DataCenter.ActDrakeBossManager:GetJoinMaxAllTimes()
    if cur >= all then
        --绿色
        self.join_reward_des_text:SetLocalText(302638, string.format(TextColorStr, TextColorGreen, all), all)
    else
        --红色
        self.join_reward_des_text:SetLocalText(302638, string.format(TextColorStr, TextColorRed, cur), all)
    end
end

function UIDrakeBossRewardTipView:RefreshDrakeBossSignal()
    self:Refresh()
end

function UIDrakeBossRewardTipView:ShowCallCells()
    self:ClearCallScroll()
    self:GetCallDataList()
    local count = table.count(self.call_list)
    if count > 0 then
        self.call_scroll_view:SetTotalCount(count)
        self.call_scroll_view:RefillCells()
    end
end

function UIDrakeBossRewardTipView:ClearCallScroll()
    self.call_scroll_view:ClearCells()--清循环列表数据
    self.call_scroll_view:RemoveComponents(UICommonItemChange)--清循环列表gameObject
end

function UIDrakeBossRewardTipView:OnCallCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.call_scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.call_list[index])
end

function UIDrakeBossRewardTipView:OnCallCellMoveOut(itemObj, index)
    self.call_scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

function UIDrakeBossRewardTipView:GetCallDataList()
    self.call_list = DataCenter.ActDrakeBossManager:GetCallShowReward()
end

function UIDrakeBossRewardTipView:ShowJoinCells()
    self:ClearJoinScroll()
    self:GetJoinDataList()
    local count = table.count(self.join_list)
    if count > 0 then
        self.join_scroll_view:SetTotalCount(count)
        self.join_scroll_view:RefillCells()
    end
end

function UIDrakeBossRewardTipView:ClearJoinScroll()
    self.join_scroll_view:ClearCells()--清循环列表数据
    self.join_scroll_view:RemoveComponents(UICommonItemChange)--清循环列表gameObject
end

function UIDrakeBossRewardTipView:OnJoinCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.join_scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.join_list[index])
end

function UIDrakeBossRewardTipView:OnJoinCellMoveOut(itemObj, index)
    self.join_scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

function UIDrakeBossRewardTipView:GetJoinDataList()
    self.join_list = DataCenter.ActDrakeBossManager:GetJoinShowReward()
end

return UIDrakeBossRewardTipView