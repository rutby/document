---
--- Created by Beef
--- DateTime: 2024/4/2 11:20
---

--- 丧尸围城任务界面

local UIPreviewStormView = BaseClass("UIPreviewStormView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIPreviewStormTaskCell = require "UI.UIPreviewStorm.Component.UIPreviewStormTaskCell"

local panel_btn_path = "Anim/panel"
local close_btn_path = "Anim/CloseBtn"
local title_text_path = "Anim/title_text"
local des_text_path = "Anim/des_text"
local reward_tip_text_path = "Anim/reward_tip_text"
local scroll_view_path = "Anim/ScrollView"
local time_go_path = "Anim/time_go"
local time_text_path = "Anim/time_go/time_text"
local task_cell_path = "Anim/task_go/UIPreviewStormTaskCell"
local info_btn_path = "Anim/time_go/info_btn"

local TaskCellCount = 2

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
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.time_go = self:AddComponent(UIBaseContainer, time_go_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
    self.taskCells = {}
    for i = 1, TaskCellCount, 1 do
        self.taskCells[i] = self:AddComponent(UIPreviewStormTaskCell, task_cell_path .. i)
    end
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
end

function UIPreviewStormView:ComponentDestroy()
end

function UIPreviewStormView:DataDefine()
    self.list = {}
    self.isClick = false
    self.left_timer_callback = function()
        self:OnLeftTimerCallBack()
    end
end

function UIPreviewStormView:DataDestroy()
    self:RemoveLeftTimer()
    self.list = {}
    self.isClick = false
end

function UIPreviewStormView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPreviewStormView:OnEnable()
    base.OnEnable(self)
end

function UIPreviewStormView:OnDisable()
    base.OnDisable(self)
end

function UIPreviewStormView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
end

function UIPreviewStormView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
end

function UIPreviewStormView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.ZOMBIE_COMING_TITLE)
    self.des_text:SetLocalText(GameDialogDefine.ZOMBIE_COMING_DES)
    self.reward_tip_text:SetLocalText(GameDialogDefine.REWARD)
    self:Refresh()
end

function UIPreviewStormView:ShowCells()
    self:ClearScroll()
    self.list = self:GetDataList()
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
    local attackData = DataCenter.CitySiegeManager:GetAttackData()
    return DataCenter.RewardManager:ReturnRewardParamForView(attackData.reward) or {}
end

function UIPreviewStormView:Refresh()
    self.isClick = false
    self:RefreshTime()
    local attackData = DataCenter.CitySiegeManager:GetAttackData()
    for i = 1, TaskCellCount do
        local questId = attackData.questIds[i]
        if questId then
            local param = {}
            param.taskId = questId
            self.taskCells[i]:ReInit(param)
            self.taskCells[i]:SetActive(true)
        else
            self.taskCells[i]:SetActive(false)
        end
    end
    self:ShowCells()
end

function UIPreviewStormView:RefreshTime()
    local attackData = DataCenter.CitySiegeManager:GetAttackData()
    local state = attackData:GetState()
    if state == CitySiegeAttackState.Ready then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local callTime = DataCenter.CitySiegeManager:GetCallTime()
        local restTime = callTime - curTime
        local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
        self.time_go:SetActive(true)
        self.time_text:SetText(restTimeStr)
        self:AddLeftTimer()
    else
        self.time_go:SetActive(false)
        self:RemoveLeftTimer()
    end
end

function UIPreviewStormView:AddLeftTimer()
    if self.leftTime == nil then
        self.leftTime = TimerManager:GetInstance():GetTimer(0.49, self.left_timer_callback, self, false, false, false)
        self.leftTime:Start()
    end
end

function UIPreviewStormView:RemoveLeftTimer()
    if self.leftTime ~= nil then
        self.leftTime:Stop()
        self.leftTime = nil
    end
end

function UIPreviewStormView:OnLeftTimerCallBack()
    self:RefreshTime()
end

function UIPreviewStormView:OnInfoBtnClick()
    UIUtil.ShowIntro(Localization:GetString(GameDialogDefine.STORM_PREVIEW_TITLE), "", Localization:GetString(GameDialogDefine.STORM_PREVIEW_INFO_DES))
end

function UIPreviewStormView:MainTaskSuccessSignal()
    self:Refresh()
end

function UIPreviewStormView:CanClick()
    return true
end

return UIPreviewStormView