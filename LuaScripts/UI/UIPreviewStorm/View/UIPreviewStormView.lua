--- Created by shimin
--- DateTime: 2023/11/10 14:39
--- 暴风雪预览界面

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
local anim_path = "Anim"

local TaskCellCount = 2
local EnterAnimName = "Eff_Ani_Sangshilaixi_In"

function UIPreviewStormView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIPreviewStormView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self:OnClickClose()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        self:OnClickClose()
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
    self.anim = self:AddComponent(UIAnimator, anim_path)
end

function UIPreviewStormView:ComponentDestroy()
end

function UIPreviewStormView:DataDefine()
    self.list = {}
    self.isClick = false
    self.left_timer_callback = function()
        self:OnLeftTimerCallBack()
    end
    self.state = StormState.Alert
    self.enter_anim_callback = function() 
        self:OnEnterAnimCallBack()
    end
    self.canClose = true
end

function UIPreviewStormView:DataDestroy()
    DataCenter.WaitTimeManager:DeleteOneTimer(self.enter_anim_callback)
    self:RemoveLeftTimer()
    self.list = {}
    self.isClick = false
    self.state = StormState.Alert
    self.canClose = true
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
    self:AddUIListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
end

function UIPreviewStormView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshStorm, self.RefreshStormSignal)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
end

function UIPreviewStormView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.ZOMBIE_COMING_TITLE)
    self.des_text:SetLocalText(GameDialogDefine.ZOMBIE_COMING_DES)
    self.reward_tip_text:SetLocalText(GameDialogDefine.REWARD)
    self.state = DataCenter.StormManager:GetStormState()
    self:Refresh()
    
    local ret ,time = self.anim:GetAnimationReturnTime(EnterAnimName)
    if ret and time ~= nil then
        self.canClose = false
        DataCenter.WaitTimeManager:AddOneWait(time - 1, self.enter_anim_callback)
    else
        self.canClose = true
    end
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
    self:RefreshTime()
    local taskList = DataCenter.StormManager:GetTaskList()
    if taskList ~= nil then
        for k, v in ipairs(taskList) do
            if self.taskCells[k] ~= nil then
                local param = {}
                param.taskId = v
                self.taskCells[k]:ReInit(param)
            end
        end
    end
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

function UIPreviewStormView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = 0
    if self.state == StormState.Alert then
        endTime = DataCenter.StormManager.stormStartTime
    else
        endTime = DataCenter.StormManager.stormEndTime
    end
    local left = math.floor((endTime - curTime) / 1000)
    if left >= 0 then
        self.time_go:SetActive(true)
        self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(left))
        self:AddLeftTimer()
    else
        self.time_go:SetActive(false)
        self:RemoveLeftTimer()
    end
end


function UIPreviewStormView:AddLeftTimer()
    if self.leftTime == nil then
        self.leftTime = TimerManager:GetInstance():GetTimer(1, self.left_timer_callback, self, false, false, false)
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

function UIPreviewStormView:OnEnterAnimCallBack()
    self.canClose = true
    DataCenter.WaitTimeManager:DeleteOneTimer(self.enter_anim_callback)
end

function UIPreviewStormView:OnClickClose()
    if self:CanClick() then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end
end

function UIPreviewStormView:CanClick()
    return self.canClose
end

return UIPreviewStormView