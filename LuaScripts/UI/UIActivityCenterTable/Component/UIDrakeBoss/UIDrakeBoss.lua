--- Created by shimin
--- DateTime: 2023/10/31 21:43
--- 德雷克活动界面

local UIDrakeBoss = BaseClass("UIDrakeBoss", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_text_path = "Panel/title_text"
local info_btn_path = "Panel/info_btn"
local date_text_path = "Panel/date_text"
local time_text_path = "Panel/time/Di/time_text"
local use_btn_path = "Panel/use_btn"
local use_btn_text_path = "Panel/use_btn/use_btn_text"
local view_reward_btn_path = "Panel/view_reward_btn"
local view_reward_btn_text_path = "Panel/view_reward_btn/view_reward_btn_text"
local task_icon_path = "Panel/task_go/item"
local task_name_text_path = "Panel/task_go/layout/task_name_text"
local task_des_text_path = "Panel/task_go/task_des_text"
local task_finish_text_path = "Panel/task_go/task_finish_text"
local task_reward_btn_path = "Panel/task_go/task_reward_btn"
local task_reward_btn_text_path = "Panel/task_go/task_reward_btn/task_reward_btn_text"
local go_btn_path = "Panel/goto_btn"
local goto_btn_text_path = "Panel/goto_btn/goto_btn_text"
local call_boss_go_path = "Panel/goto_btn/btnTxt_yellow_mid_new"
local call_boss_text_path = "Panel/goto_btn/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text1"
local call_boss_use_text_path = "Panel/goto_btn/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2"
local call_boss_use_icon_path = "Panel/goto_btn/btnTxt_yellow_mid_new/icon_go/btnTxt_yellow_mid_new_icon"

function UIDrakeBoss:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIDrakeBoss:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.date_text = self:AddComponent(UITextMeshProUGUIEx, date_text_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseBtnClick()
    end)
    self.use_btn_text = self:AddComponent(UITextMeshProUGUIEx, use_btn_text_path)
    self.view_reward_btn = self:AddComponent(UIButton, view_reward_btn_path)
    self.view_reward_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnViewRewardBtnClick()
    end)
    self.view_reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, view_reward_btn_text_path)
    self.taskItem = self:AddComponent(UICommonItem, task_icon_path)
    self.task_name_text = self:AddComponent(UITextMeshProUGUIEx, task_name_text_path)
    self.task_des_text = self:AddComponent(UITextMeshProUGUIEx, task_des_text_path)
    self.task_finish_text = self:AddComponent(UITextMeshProUGUIEx, task_finish_text_path)
    self.task_reward_btn = self:AddComponent(UIButton, task_reward_btn_path)
    self.task_reward_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnTaskRewardBtnClick()
    end)
    self.task_reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, task_reward_btn_text_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoBtnClick()
    end)
    self.goto_btn_text = self:AddComponent(UITextMeshProUGUIEx, goto_btn_text_path)
    self.call_boss_go = self:AddComponent(UIBaseContainer, call_boss_go_path)
    self.call_boss_text = self:AddComponent(UITextMeshProUGUIEx, call_boss_text_path)
    self.call_boss_use_text = self:AddComponent(UITextMeshProUGUIEx, call_boss_use_text_path)
    self.call_boss_use_icon = self:AddComponent(UIImage, call_boss_use_icon_path)
end

function UIDrakeBoss:ComponentDestroy()
end

function UIDrakeBoss:DataDefine()
    self.isClick = false
    self.activityData = nil
    self.time_callback = function() 
        self:OnTimerCallBack()
    end
    self.timer = nil
    self.curState = -1
end

function UIDrakeBoss:DataDestroy()
    self:DeleteTimer()
    self.isClick = false
    self.activityData = nil
    self.curState = nil
end

function UIDrakeBoss:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDrakeBoss:OnEnable()
    base.OnEnable(self)
end

function UIDrakeBoss:OnDisable()
    base.OnDisable(self)
end

function UIDrakeBoss:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshDrakeBoss, self.RefreshDrakeBossSignal)
    self:AddUIListener(EventId.QuestRewardSuccess, self.QuestRewardSuccessSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
end

function UIDrakeBoss:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshDrakeBoss, self.RefreshDrakeBossSignal)
    self:RemoveUIListener(EventId.QuestRewardSuccess, self.QuestRewardSuccessSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
end

function UIDrakeBoss:SetData(activityId)
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
    self:ReInit()
end

function UIDrakeBoss:ReInit()
    self.activityData = DataCenter.ActDrakeBossManager:GetActivity()
    if self.activityData ~= nil then
        DataCenter.ActDrakeBossManager:SendGetUserDrakeBoss()
        self.title_text:SetLocalText(self.activityData.name)
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime - 1000)
        self.date_text:SetText(startT .. "-" .. endT)
        self:AddTimer()
        self:OnTimerCallBack()
        local itemId = DataCenter.ActDrakeBossManager:GetItemId()
        if itemId ~= nil then
            local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if template ~= nil then
                self.call_boss_use_icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
            end
        end
    end
    
    --local task = DataCenter.ActDrakeBossManager:GetTask()
    --if task ~= nil then
    --    local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), task.id)
    --    if template ~= nil then
    --        self.taskItem:LoadSprite(string.format(LoadPath.UITask, template.icon))
    --    end
    --end
    local k2 = LuaEntry.DataConfig:TryGetStr("drake_boss", "k2")
    if k2 ~= nil then
        local split = string.split(k2, "|")
        local param = {}
        param.itemId = tonumber(split[1])
        param.count = tonumber(split[2])
        param.rewardType = RewardType.GOODS
        self.taskItem:ReInit(param)
    end
  
    self.use_btn_text:SetLocalText(110029)
    self.view_reward_btn_text:SetLocalText(302635)
    self.task_name_text:SetLocalText(302632)
    self.task_finish_text:SetLocalText(110461)
    self.task_reward_btn_text:SetLocalText(170004)
    self.goto_btn_text:SetLocalText(302640)
    self.call_boss_text:SetLocalText(470028)
    self:Refresh()
end

function UIDrakeBoss:Refresh()
    self.isClick = false
    local task = DataCenter.ActDrakeBossManager:GetTask()
    if task ~= nil then
        local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), task.id)
        if template ~= nil then
            self.task_des_text:SetLocalText(template.desc, task.num, template.para2)
        end
        if self.curState and self.curState ~= task.state then
            self.curState = task.state
            if task.state == TaskState.NoComplete then
                self.task_reward_btn:SetActive(true)
                CS.UIGray.SetGray(self.task_reward_btn.transform, true, false)
                self.task_finish_text:SetActive(false)
            elseif task.state == TaskState.CanReceive then
                self.task_reward_btn:SetActive(true)
                CS.UIGray.SetGray(self.task_reward_btn.transform, false, true)
                self.task_finish_text:SetActive(false)
            elseif task.state == TaskState.Received then
                self.task_reward_btn:SetActive(false)
                self.task_finish_text:SetActive(true)
            end
        end
    end
    if DataCenter.ActDrakeBossManager:HasBoss() then
        self.call_boss_go:SetActive(false)
        self.goto_btn_text:SetActive(true)
    else
        self.call_boss_go:SetActive(true)
        self.goto_btn_text:SetActive(false)
        local useCount = DataCenter.ActDrakeBossManager:GetPerUseItemCount()
        local itemId = DataCenter.ActDrakeBossManager:GetItemId()
        local own = DataCenter.ItemData:GetItemCount(itemId)
        if own >= useCount then
            --绿色
            self.call_boss_use_text:SetLocalText(150033, string.format(TextColorStr, TextColorGreenLight, own), useCount)
        else
            --红色
            self.call_boss_use_text:SetLocalText(150033, string.format(TextColorStr, TextColorRed, own), useCount)
        end
    end
end

function UIDrakeBoss:RefreshDrakeBossSignal()
    self:Refresh()
end

function UIDrakeBoss:QuestRewardSuccessSignal()
    self:Refresh()
end

function UIDrakeBoss:RefreshItemsSignal()
    self:Refresh()
end


function UIDrakeBoss:OnTaskRewardBtnClick()
    if not self.isClick then
        local task = DataCenter.ActDrakeBossManager:GetTask()
        if task ~= nil then
            if task.state == TaskState.CanReceive then
                self.isClick = true
                SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, { id = tostring(task.id) })
            end
        end
    end
end

function UIDrakeBoss:OnInfoBtnClick()
    UIUtil.ShowIntro(Localization:GetString(tostring(self.activityData.name)), 
            Localization:GetString(100239), Localization:GetString(tostring(self.activityData.story)))
end

function UIDrakeBoss:OnUseBtnClick()
    local itemId = DataCenter.ActDrakeBossManager:GetItemId()
    if itemId ~= nil then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if template ~= nil then
            --英雄是否满军阶
            local isMax = false
            local heroId = tonumber(template.para3)
            local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
            if heroData ~= nil and heroData:IsReachMaxMilitaryRank() then
                isMax = true
            end
            if isMax then
                local useCount = DataCenter.ActDrakeBossManager:GetPerUseItemCount()
                local item = DataCenter.ItemData:GetItemById(tostring(itemId))
                if item ~= nil and item.count >= useCount then
                    --弹出使用道具面板
                    local param = {}
                    param.uuid = item.uuid
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDrakeBossUseItem, {anim = true, isBlur = true}, param)
                else
                    UIUtil.ShowTipsId(302647)
                end
            else
                UIUtil.ShowTipsId(302646)
            end
        end
    end
end

function UIDrakeBoss:OnViewRewardBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDrakeBossRewardTip, {anim = true, isBlur = true})
end

function UIDrakeBoss:OnGoBtnClick()
    if DataCenter.ActDrakeBossManager:HasBoss() then
        --判断boss是否距离过远
        if DataCenter.ActDrakeBossManager:IsBossFar() then
            --弹出提示
            UIUtil.ShowMessage(Localization:GetString(470059), 1, 470028, 110106, function()
                DataCenter.ActDrakeBossManager:UseItem()
            end)
        else
            DataCenter.ActDrakeBossManager:GoToBoss()  
        end
    else
        DataCenter.ActDrakeBossManager:UseItem()
    end
end

function UIDrakeBoss:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback, self, false, false, false)
    end
    self.timer:Start()
end

function UIDrakeBoss:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIDrakeBoss:OnTimerCallBack()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if remainTime > 0 then
        self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.time_text:SetText("")
        self:DeleteTimer()
    end
end


return UIDrakeBoss