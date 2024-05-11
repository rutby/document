--- Created by shimin
--- DateTime: 2024/3/19 12:13
--- 暴风雪领奖界面

local UIPreviewStormView = BaseClass("UIPreviewStormView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIPreviewStormDeadCell = require "UI.UIPreviewStorm.Component.UIPreviewStormDeadCell"

local panel_btn_path = "Anim/panel"
local close_btn_path = "Anim/CloseBtn"
local title_text_path = "Anim/title_text"
local des_text_path = "Anim/des_text"
local reward_tip_text_path = "Anim/reward_tip_text"
local scroll_view_path = "Anim/ScrollView"
local reward_btn_path = "Anim/reward_btn"
local dead_tip_text_path = "Anim/dead_tip_text"
local dead_scroll_view_path = "Anim/dead_scroll_view"
local reward_btn_text_path = "Anim/reward_btn/reward_btn_text"

local RewardBtnPos = 
{
    HaveDead = Vector2.New(0,-400),
    NoDead = Vector2.New(0,-310)
}

function UIPreviewStormView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIPreviewStormView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)

    self.reward_tip_text = self:AddComponent(UITextMeshProUGUIEx, reward_tip_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
    self.reward_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRewardBtnClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.dead_tip_text = self:AddComponent(UITextMeshProUGUIEx, dead_tip_text_path)
    self.dead_scroll_view = self:AddComponent(UIScrollView, dead_scroll_view_path)
    self.dead_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnDeadCellMoveIn(itemObj, index)
    end)
    self.dead_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeadCellMoveOut(itemObj, index)
    end)
    self.reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, reward_btn_text_path)
end

function UIPreviewStormView:ComponentDestroy()
end

function UIPreviewStormView:DataDefine()
    self.list = {}
    self.isClick = false
    self.state = StormState.Alert
    self.dead_list = {}
end

function UIPreviewStormView:DataDestroy()
    self.list = {}
    self.isClick = false
    self.state = StormState.Alert
end

function UIPreviewStormView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPreviewStormView:OnEnable()
    base.OnEnable(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Preview_Storm) 
end

function UIPreviewStormView:OnDisable()
    base.OnDisable(self)
end

function UIPreviewStormView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshStorm, self.RefreshStormSignal)
end

function UIPreviewStormView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshStorm, self.RefreshStormSignal)
end

function UIPreviewStormView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.ZOMBIE_COMING_TITLE)
    self.des_text:SetLocalText(GameDialogDefine.SUCCESSFULLY_RESISTED)
    self.reward_tip_text:SetLocalText(GameDialogDefine.REWARD)
    self.dead_tip_text:SetLocalText(GameDialogDefine.DEAD_RESIDENT)
    self.reward_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
    self.state = DataCenter.StormManager:GetStormState()
    self:Refresh()
end

function UIPreviewStormView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIPreviewStormView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIPreviewStormView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItem, itemObj)
    item:ReInit(self.list[index])
end

function UIPreviewStormView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIPreviewStormView:GetDataList()
    self.list = {}
    local reward = DataCenter.StormManager:GetRewardList()
    if reward[1] == nil then
        DataCenter.StormManager:SendGetNewbieStormReward()
    else
        for k, v in ipairs(reward) do
            table.insert(self.list, v)
        end
    end
end

function UIPreviewStormView:Refresh()
    self.isClick = false
    local rewardState = DataCenter.StormManager:GetRewardState()
    if rewardState == StormRewardState.CanGet then
        self.reward_btn:SetActive(true)
    else
        self.reward_btn:SetActive(false)
    end
    self:ShowDeadCells()
    self:ShowCells()
end

function UIPreviewStormView:RefreshStormSignal()
    self:Refresh()
end

function UIPreviewStormView:OnRewardBtnClick()
    if not self.isClick then
        DataCenter.StormManager:SendCollectNewbieStormReward()
        self.isClick = true
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.StormGetRewardBtn, tostring(DataCenter.StormManager.callTime))
        self.ctrl:CloseSelf()
    end
end

function UIPreviewStormView:ShowDeadCells()
    self:ClearDeadScroll()
    self:GetDeadDataList()
    local count = table.count(self.dead_list)
    if count > 0 then
        self.dead_tip_text:SetActive(true)
        self.dead_scroll_view:SetActive(true)
        self.reward_btn:SetAnchoredPosition(RewardBtnPos.HaveDead)
        self.dead_scroll_view:SetTotalCount(count)
        self.dead_scroll_view:RefillCells()
    else
        self.dead_tip_text:SetActive(false)
        self.dead_scroll_view:SetActive(false)
        self.reward_btn:SetAnchoredPosition(RewardBtnPos.NoDead)
    end
end

function UIPreviewStormView:ClearDeadScroll()
    self.dead_scroll_view:ClearCells()--清循环列表数据
    self.dead_scroll_view:RemoveComponents(UIPreviewStormDeadCell)--清循环列表gameObject
end

function UIPreviewStormView:OnDeadCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.dead_scroll_view:AddComponent(UIPreviewStormDeadCell, itemObj)
    item:ReInit(self.dead_list[index])
end

function UIPreviewStormView:OnDeadCellMoveOut(itemObj, index)
    self.dead_scroll_view:RemoveComponent(itemObj.name, UIPreviewStormDeadCell)
end

function UIPreviewStormView:GetDeadDataList()
    self.dead_list = {}
    local reward = DataCenter.StormManager:GetDeadList()
    if reward ~= nil and reward[1] ~= nil then
        for k, v in ipairs(reward) do
            table.insert(self.dead_list, v)
        end
    end
end


return UIPreviewStormView