
local UIActivityALVSDonateSoldier = BaseClass("UIActivityALVSDonateSoldier", UIBaseContainer)
local ALVSDonateSoldierRankItem = require "UI.UIActivityCenterTable.Component.UIActivityALVSDonateSoldier.ALVSDonateSoldierRankItem"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPveActStageTip = require "UI.UIActivityCenterTable.Component.UIActivityDonateSoldier.DonateSoldierStageTip"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

-- 活动标题
local activity_title_label_path = "topLeftLayer/Txt_Title"
-- 活动描述
local activity_des_label_path = "topLeftLayer/Txt_Des"
-- 活动结束时间
local donate_act_time_text_path = "topLeftLayer/Txt_Des/DonateActTimeText"
-- 任务节点
local task_node_path = "TaskNode"
-- 任务框标题
local task_title_path = "TaskNode/taskTitle"
-- 可用任务节点
local avaliable_task_node_path = "TaskNode/avaliableTaskNode"
-- 可用任务名字label
local avaliable_task_name_label_path = "TaskNode/avaliableTaskNode/taskName"
-- 可用任务进度条
local avaliable_task_progress_path = "TaskNode/avaliableTaskNode/taskProgress"
-- 可用任务领取按钮
local avaliable_task_button_path = "TaskNode/avaliableTaskNode/taskRewardBtn"
-- 可用任务未完成不可领取按钮
local avaliable_task_button_unfinish_path = "TaskNode/avaliableTaskNode/taskRewardBtnUnfinish"
-- 不可用任务节点
local reload_task_node_path = "TaskNode/taskReloadingNode"
-- 不可用任务倒数计时label
local reloading_task_label_path = "TaskNode/taskReloadingNode/reloadingLabel"
-- 不可用任务倒计时时间label
local reloading_label_time_path = "TaskNode/taskReloadingNode/reloadingLabelTime"

-- 军力对比标题label
-- local compare_title_label_path = "PowerCompareNode/PowerCompareTitleNode/StateTitleLabel"
-- 军力对比倒计时label
-- local compare_title_count_label_path = "PowerCompareNode/PowerCompareTitleNode/StateTimeLabel"
-- 己方联盟标题label
local self_alliance_title_label_path = "PowerCompareNode/PowerCompareSelfNode/SelfTitle"
-- 己方联盟军力label
local self_alliance_power_label_path = "PowerCompareNode/PowerCompareSelfNode/SelfValue"
-- 己方联盟军力数值label
local self_alliance_power_value_label_path = "PowerCompareNode/PowerCompareSelfNode/SelfValueNum"
-- 敌方联盟标题label
local enemy_alliance_title_label_path = "PowerCompareNode/PowerCompareOtherNode/OtherTitle"
-- 敌方联盟军力label
local enemy_alliance_power_label_path = "PowerCompareNode/PowerCompareOtherNode/OtherValue"
-- 敌方联盟军力数值label
local enemy_alliance_power_value_label_path = "PowerCompareNode/PowerCompareOtherNode/OtherValueNum"

local enemy_name_path = "PowerCompareNode/EnemyNode/EnemyName"
local enemy_name_text_path = "PowerCompareNode/EnemyNode/EnemyNameText"
local state_title_label_path = "PowerCompareNode/PowerCompareTitleNode/StateTitleLabel"
local state_time_label_path = "PowerCompareNode/PowerCompareTitleNode/StateTimeLabel"
local left_alliance_flag_path = "PowerCompareNode/EnemyAllianceFlag/LeftAllianceFlag"
local left_alliance_flag_empty_path = "PowerCompareNode/EnemyAllianceFlag/LeftAllianceFlagEmpty"

-- 排行榜scrollview
local rank_scrollview_path = "DonateRank/ScrollView"
-- 排行榜列标题1
local rank_playerrank_label_path = "DonateRank/select/playerrank"
-- 排行榜列标题2
local rank_playername_label_path = "DonateRank/select/playername"
-- 排行榜列标题3
local rank_playerpower_label_path = "DonateRank/select/playerpower"

-- 捐献按钮
local donate_btn_path = "BottomBtnNode/BtnDonate"
-- 战斗中按钮
local battle_btn_path = "BottomBtnNode/BtnBattle"
-- 捐献按钮文字
local donate_btn_lable_path = "BottomBtnNode/BtnDonate/DonateBtnLabel"
-- 战斗中按钮文字
local battle_btn_lable_path = "BottomBtnNode/BtnBattle/BattleBtnLabel"
-- 打开奖励面板按钮
local reward_btn_path = "RewardNode/RewardBtn"
-- 奖励按钮文字
local reward_btn_label_path = "RewardNode/RewardBtnLabel"
-- 己方联盟选择签
local alliance_checkmark_path = "CheckMarkNode/Checkmark"
-- 己方联盟选择签按钮
local alliance_checkmark_btn_path = "CheckMarkNode/CheckMarkBtn"
-- 己方联盟选择签旁的label
local alliance_checkmark_label_path = "CheckMarkNode/MyAllianceLabel"

-- 自己的排行榜排名
local self_rank_lable_path = "DonateRank/SelfScoreNode/SelfRankLabel"
-- 自己的排行榜名字
local self_rank_name_label_path = "DonateRank/SelfScoreNode/SelfNameLabel"
-- 自己的排行榜头像
local self_rank_head_path = "DonateRank/SelfScoreNode/UIPlayerHead/HeadIcon"
-- 自己的排行榜分数
local self_rank_score_path = "DonateRank/SelfScoreNode/SelfPowerLabel"
-- 简介按钮
local intro_btn_path = "topLeftLayer/Txt_Title/Intro"
-- 任务奖励弹出框(复用了UIPveActStateTip)
local stage_tip_path = "UIPveActStageTip"
local time_icon_path = "PowerCompareNode/PowerCompareTitleNode/timeIcon"
--reward红点
local reward_redpt_path = "RewardNode/reward_red_pt"
local reward_text_path = "RewardNode/reward_red_pt/RewardText"
local progress_value_label_path = "TaskNode/avaliableTaskNode/taskProgress/ProgressValueLabel"

local task_reward_btn_animator_path = "TaskNode/avaliableTaskNode/taskRewardBtn"
--无更多任务提醒文字
local no_more_task_label_path = "TaskNode/noMoreTaskLabel"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.task_title = self:AddComponent(UIText, task_title_path)
    self.avaliable_task_node = self:AddComponent(UIBaseContainer, avaliable_task_node_path)
    self.avaliable_task_name_label = self:AddComponent(UIText, avaliable_task_name_label_path)
    self.avaliable_task_progress = self:AddComponent(UISlider, avaliable_task_progress_path)
    self.avaliable_task_button = self:AddComponent(UIButton, avaliable_task_button_path)
    self.avaliable_task_button:SetOnClick(function()
        --可领奖按钮点击 真的领奖
        SFSNetwork.SendMessage(MsgDefines.ReceiveALVSDonateArmyTaskReward)
    end)
    self.avaliable_task_button_unfinish = self:AddComponent(UIButton, avaliable_task_button_unfinish_path)
    self.avaliable_task_button_unfinish:SetOnClick(function()
        --不可领奖按钮点击 弹提示
        local taskInfo = DataCenter.ActivityALVSDonateSoldierManager:GetCurrentTaskInfo()
        if taskInfo and taskInfo.reward then
            local rewards = DataCenter.RewardManager:ReturnRewardParamForView(taskInfo.reward)
            self.stage_tip:SetData(rewards)
            self.stage_tip:SetPosX(self.avaliable_task_button_unfinish.transform.position.x)
            self.stage_tip:Show()
        end
    end)
    self.reload_task_node = self:AddComponent(UIBaseContainer, reload_task_node_path)
    self.reloading_task_label = self:AddComponent(UIText, reloading_task_label_path)
    self.reloading_label_time = self:AddComponent(UIText, reloading_label_time_path)

    -- self.compare_title_label = self:AddComponent(UIText, compare_title_label_path)
    -- self.compare_title_count_label = self:AddComponent(UIText, compare_title_count_label_path)
    self.self_alliance_title_label = self:AddComponent(UIText, self_alliance_title_label_path)
    self.self_alliance_power_label = self:AddComponent(UIText, self_alliance_power_label_path)
    self.self_alliance_power_value_label = self:AddComponent(UIText, self_alliance_power_value_label_path)
    self.enemy_alliance_title_label = self:AddComponent(UIText, enemy_alliance_title_label_path)
    self.enemy_alliance_power_label = self:AddComponent(UIText, enemy_alliance_power_label_path)
    self.enemy_alliance_power_value_label = self:AddComponent(UIText, enemy_alliance_power_value_label_path)
    self.rank_scrollview = self:AddComponent(UIScrollView, rank_scrollview_path)
    self.rank_scrollview:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.rank_scrollview:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.rank_playerrank_label = self:AddComponent(UIText, rank_playerrank_label_path)
    self.rank_playername_label = self:AddComponent(UIText, rank_playername_label_path)
    self.rank_playerpower_label = self:AddComponent(UIText, rank_playerpower_label_path)
    self.donate_btn = self:AddComponent(UIButton, donate_btn_path)
    self.donate_btn:SetOnClick(function()
        self:OnDonateBtnClick()
    end)
    self.battle_btn = self:AddComponent(UIButton, battle_btn_path)
    self.battle_btn:SetOnClick(function() 
        self:OnBattleBtnClick()
    end)
    CS.UIGray.SetGray(self.battle_btn.transform, true, true)--既要置灰又要能点击
    self.donate_btn_lable = self:AddComponent(UIText, donate_btn_lable_path)
    self.battle_btn_lable = self:AddComponent(UIText, battle_btn_lable_path)
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
    self.reward_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIALVSDonateSoldierReward)
    end)
    self.reward_btn_label = self:AddComponent(UIText, reward_btn_label_path)
    self.reward_btn_label:SetLocalText(372781)
    self.activity_title_label = self:AddComponent(UIText, activity_title_label_path)
    self.activity_des_label = self:AddComponent(UIText, activity_des_label_path)
    self.donate_act_time_text = self:AddComponent(UIText, donate_act_time_text_path)

    self.alliance_checkmark = self:AddComponent(UIBaseContainer, alliance_checkmark_path)
    self.alliance_checkmark_btn = self:AddComponent(UIButton, alliance_checkmark_btn_path)
    self.alliance_checkmark_btn:SetOnClick(function() 
        self:OnCheckMarkClick()
    end)
    self.alliance_checkmark_label = self:AddComponent(UIText, alliance_checkmark_label_path)
    self.alliance_checkmark_label:SetLocalText(110293)

    self.alliance_checkmark:SetActive(false)
    self.showSelfAlliance = false
    
    self.self_rank_lable = self:AddComponent(UIText, self_rank_lable_path)
    self.self_rank_name_label = self:AddComponent(UIText, self_rank_name_label_path)
    self.self_rank_head = self:AddComponent(UIPlayerHead, self_rank_head_path)
    self.self_rank_score = self:AddComponent(UIText, self_rank_score_path)
    self.task_node = self:AddComponent(UIBaseContainer, task_node_path)
    self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
    self.intro_btn:SetOnClick(function()
        self:OnTipBtnClick()
    end)

    self.stage_tip = self:AddComponent(UIPveActStageTip, stage_tip_path)
    self.time_icon = self:AddComponent(UIBaseContainer, time_icon_path)
    self.reward_redpt = self:AddComponent(UIBaseContainer, reward_redpt_path)
    self.progress_value_label = self:AddComponent(UIText, progress_value_label_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
    self.task_reward_btn_animator = self:AddComponent(UIAnimator, task_reward_btn_animator_path)
    self.no_more_task_label = self:AddComponent(UIText, no_more_task_label_path)
    self.no_more_task_label:SetLocalText(372328)

    self.state_title_label = self:AddComponent(UIText, state_title_label_path)
    self.state_title_label:SetLocalText(308013)
    self.state_time_label = self:AddComponent(UIText, state_time_label_path)
    self.left_alliance_flag = self:AddComponent(AllianceFlagItem, left_alliance_flag_path)
    self.left_alliance_flag_empty = self:AddComponent(UIImage, left_alliance_flag_empty_path)    
    self.enemy_name_text = self:AddComponent(UIText, enemy_name_text_path)
    self.enemy_name = self:AddComponent(UIText, enemy_name_path)
    self.enemy_name:SetLocalText(308011)


    self.battle_btn_des_label = 372795
end

local function ComponentDestroy(self)
    self.task_title = nil
    self.avaliable_task_node = nil
    self.avaliable_task_name_label = nil
    self.avaliable_task_progress = nil
    self.avaliable_task_button = nil
    self.reload_task_node = nil
    self.reloading_task_label = nil
    -- self.compare_title_label = nil
    -- self.compare_title_count_label = nil
    self.self_alliance_title_label = nil
    self.self_alliance_power_label = nil
    self.enemy_alliance_title_label = nil
    self.enemy_alliance_power_label = nil
    self.rank_scrollview = nil
    self.rank_playerrank_label = nil
    self.rank_playername_label = nil
    self.rank_playerpower_label = nil
    self.donate_btn = nil
    self.donate_btn_lable = nil
    self.reward_btn = nil
    self.reward_btn_label = nil
    self.activity_title_label = nil
    self.activity_des_label = nil
    self.alliance_checkmark = nil
    self.alliance_checkmark_btn = nil
    self.timer_action = nil
    self.self_rank_lable = nil
    self.self_rank_name_label = nil
    self.self_rank_head = nil
    self.self_rank_score = nil
    self.task_node = nil
    self.stage_tip = nil
    self.time_icon = nil
    self.reward_redpt = nil
    self.progress_value_label = nil
    self.reward_text = nil
    self.task_reward_btn_animator = nil
    self.reloading_label_time = nil
    self.no_more_task_label = nil
    self.state_title_label = nil
    self.state_time_label = nil
    self.left_alliance_flag = nil
    self.left_alliance_flag_empty = nil
    self.donate_act_time_text = nil
    self.enemy_name_text = nil
    self.enemy_name = nil

end

local function OnRankBtnClick(self)
    -- 现在去掉了这个界面
end

local function SetStaticLocalText(self)
    -- 设置界面固定多语言
    self.rank_playerrank_label:SetLocalText(302822)
    self.rank_playername_label:SetLocalText(100184)
    self.rank_playerpower_label:SetLocalText(372780)
    self.donate_btn_lable:SetLocalText(372782)
    self.task_title:SetLocalText(372783)
    self.battle_btn_lable:SetText("")
    -- self.compare_title_label:SetText("")
    self.reloading_task_label:SetLocalText(372205)

    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        self.activity_title_label:SetLocalText(activityData.name)
        self.activity_des_label:SetLocalText(activityData.desc_info)
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.endTime)
        self.donate_act_time_text:SetText(startT .. "-" .. endT)
    end

    self.self_alliance_power_label:SetLocalText(372778, "")
    self.enemy_alliance_power_label:SetLocalText(372779, "")
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetALVSDonateArmyActivityInfo, BindCallback(self, self.OnGetDonateArmyScoreInfoReturn))
    self:AddUIListener(EventId.PushArmyInfoEvent, BindCallback(self, self.OnArmyNumChange))
    -- 捐兵结束刷新自己和联盟的分数
    self:AddUIListener(EventId.ALVSDonateSoldier, BindCallback(self,self.OnRefreshView))
    self:AddUIListener(EventId.ReceiveALVSDonateArmyTaskReward, BindCallback(self, self.OnRefreshTaskNode))
    self:AddUIListener(EventId.PushALVSDonateArmyTaskUpdate, BindCallback(self, self.OnRefreshTaskNode))
    self:AddUIListener(EventId.ReceiveALVSDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetALVSDonateArmyActivityInfo, BindCallback(self, self.OnGetDonateArmyScoreInfoReturn))
    self:RemoveUIListener(EventId.PushArmyInfoEvent, BindCallback(self, self.OnArmyNumChange))
    self:RemoveUIListener(EventId.ALVSDonateSoldier, BindCallback(self,self.OnRefreshView))
    self:RemoveUIListener(EventId.ReceiveALVSDonateArmyTaskReward, BindCallback(self, self.OnRefreshTaskNode))
    self:RemoveUIListener(EventId.PushALVSDonateArmyTaskUpdate, BindCallback(self, self.OnRefreshTaskNode))
    self:RemoveUIListener(EventId.ReceiveALVSDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
    base.OnRemoveListener(self)
end

local function SetData(self,activityId,id)
    self.activityId = activityId
    -- 排行榜数据
    self.dataList = {}
    self:SetStaticLocalText()
    SFSNetwork.SendMessage(MsgDefines.GetALVSDonateArmyActivityInfo)
    self.stage_tip:SetActive(false)
end

local function OnGetDonateArmyScoreInfoReturn(self)
    --获取捐兵信息返回
    self.task_node:SetActive(true)
    self.donate_btn:SetActive(true)
    self.battle_btn:SetActive(false)
    -- self.compare_title_label:SetLocalText(372777)--距离远征开启：
    self:OnRefreshView()
    self:SetEnemyInfo()
end

local function OnRefreshView(self)
    self:OnReloadScrollView()
    self:RefreshSelfScore()
    self:RefreshAllianceScore()
    self:OnRefreshTaskNode()
    self:CheckRewardRedPt()
end

local function OnReloadScrollView(self)
    self:ClearScroll()
    self.dataList =  DataCenter.ActivityALVSDonateSoldierManager:GetALVSDonateSoldierActivityDataList(self.showSelfAlliance, true)
    if #self.dataList > 0 then
        self.rank_scrollview:SetTotalCount(#self.dataList)
        self.rank_scrollview:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.rank_scrollview:AddComponent(ALVSDonateSoldierRankItem, itemObj)
    cellItem:SetData(self.dataList[index], index)
end

local function ClearScroll(self)
    self.rank_scrollview:RemoveComponents(ALVSDonateSoldierRankItem)
    self.rank_scrollview:ClearCells()
end

local function OnCellMoveOut(self,itemObj, index)
    self.rank_scrollview:RemoveComponent(itemObj.name, ALVSDonateSoldierRankItem)
end

local function OnDonateBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIALVSDonateSoldierSelect) 
end

local function OnRefreshTaskNode(self)
    local taskInfo = DataCenter.ActivityALVSDonateSoldierManager:GetCurrentTaskInfo()
    if taskInfo == nil or taskInfo.taskId == nil then
        --无任务的状态
        self.avaliable_task_node:SetActive(false)
        if taskInfo == nil then
            --如果任务信息都没了 就不显示倒计时节点 显示无新任务
            self.no_more_task_label:SetActive(true)
        else
            local donateEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetDonateEndTimeStamp()
            if taskInfo.nextRecoverTime ~= nil and taskInfo.nextRecoverTime >= donateEndTime then
                --如果下次任务回复时间比远征开始时间还晚 就显示无新任务
                self.no_more_task_label:SetActive(true)
            else
                --如果下次任务回复时间比远征开始时间早 就显示任务刷新倒计时
                self.reload_task_node:SetActive(true)
            end

        end
        local taskTitle = Localization:GetString("372783")
        self.task_title:SetText(taskTitle)
        return
    end

    self.avaliable_task_node:SetActive(true)
    self.reload_task_node:SetActive(false)

    --有任务
    if taskInfo.state == 0 then
        --未完成
        self.avaliable_task_button:SetActive(false)
        self.avaliable_task_button_unfinish:SetActive(true)
        self.task_reward_btn_animator:Play("V_progress_box_idle", 0, 0)
    else
        --已完成
        self.avaliable_task_button:SetActive(true)
        self.avaliable_task_button_unfinish:SetActive(false)
        self.task_reward_btn_animator:Play("V_progress_box" , 0, 0)
    end

    local questId = taskInfo.taskId
    local questTemplate = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), questId)
    local taskTitle = Localization:GetString("372783") .." (".. tostring(taskInfo.taskNum) .. "/" .. tostring(taskInfo.maxTaskNum)..")"
    self.task_title:SetText(taskTitle)
    
    local str = ""
    -- if tonumber(questTemplate.progressshow) == 1 then
        local num = 0
        if taskInfo.num >= questTemplate.para2 then
            num = questTemplate.para2
        else
            num = taskInfo.num
        end

        str = string.format("  %s/%s  ",string.GetFormattedSeperatorNum(num), string.GetFormattedSeperatorNum(questTemplate.para2))
    -- else
    --     str = ""
    -- end
    self.avaliable_task_name_label:SetText(DataCenter.QuestTemplateManager:GetDesc(questTemplate))
    self.progress_value_label:SetText(str)
    --刷新进度条
    self.avaliable_task_progress:SetValue(taskInfo.num / Mathf.Max(1, questTemplate.para2))
end

local function RefreshAllianceScore(self)
    local selfAllianceScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(1)
    local enemyAllianceScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(2)

    -- self.self_alliance_power_label:SetLocalText(372778, tostring(selfAllianceScore))
    self.self_alliance_power_value_label:SetText(string.GetFormattedSeperatorNum(selfAllianceScore))
    -- self.enemy_alliance_power_label:SetLocalText(372779, tostring(enemyAllianceScore))
    self.enemy_alliance_power_value_label:SetText(string.GetFormattedSeperatorNum(enemyAllianceScore))
end

local function OnCheckMarkClick(self)
    self.showSelfAlliance = not self.showSelfAlliance
    self:OnReloadScrollView()
    self.alliance_checkmark:SetActive(self.showSelfAlliance)
end

-- 每秒定时在UIActivityALVSMain中调用
local function OnUpdate1000ms(self, dt)
    local taskInfo = DataCenter.ActivityALVSDonateSoldierManager:GetCurrentTaskInfo()
    local now = UITimeManager:GetInstance():GetServerTime()
    if taskInfo ~= nil and taskInfo.nextRecoverTime ~= nil then
        --有任务恢复倒计时 
        local leftTime = taskInfo.nextRecoverTime - now
        if leftTime >= 0 then
            self.reloading_label_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        else
            self.reloading_label_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
        end
    end

    local donateEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetDonateEndTimeStamp()
    local donateLeftTime = donateEndTime - now
    if donateLeftTime >= 0 then
        --捐兵持续时间内
        self.state_time_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(donateLeftTime))
        self.time_icon:SetActive(true)
    else
        --已到期
    end

end

local function RefreshSelfScore(self)
    local selfData = DataCenter.ActivityALVSDonateSoldierManager:GetPlayerCurrDonateSoldierInfo()
    local score = selfData.score
    if selfData.rank < 0 then
        --未上榜
        self.self_rank_lable:SetText("-")
        self.self_rank_score:SetText(tostring(score))
    else
        local rank = selfData.rank
    
        self.self_rank_lable:SetText(tostring(rank))
        self.self_rank_score:SetText(string.GetFormattedSeperatorNum(score))
    end


    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local selfAbbrName = ""
    if allianceData~=nil and LuaEntry.Player:IsInAlliance()  then
        selfAbbrName = "["..allianceData.abbr.."]"
    end

    self.self_rank_name_label:SetText(selfAbbrName .. LuaEntry.Player.name)
    self.self_rank_head:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
end

local function OnArmyNumChange(self)
    self:OnReloadScrollView()
end

local function OnBattleBtnClick(self)
    --战斗中按钮 点击提示 战斗中无法捐献
    UIUtil.ShowTipsId(self.battle_btn_des_label)
end

local function OnTipBtnClick(self)
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        UIUtil.ShowIntro(Localization:GetString(activityData.name), Localization:GetString("100239"), Localization:GetString(activityData.story))
    end
end

--判断红点是否应该显示
local function CheckRewardRedPt(self)
    local canShowRedPtNum = DataCenter.ActivityALVSDonateSoldierManager:GetIsCurrRewardCanReceiveNum()
    if canShowRedPtNum > 0 then
        self.reward_redpt:SetActive(true)
        self.reward_text:SetText(tostring(canShowRedPtNum))
    else
        self.reward_redpt:SetActive(false)
    end
end

local function SetEnemyInfo(self)
    local vsAlliance = DataCenter.ActivityALVSDonateSoldierManager:GetVsAllianceInfo()
    if vsAlliance ~= nil then    
        self.enemy_name_text:SetText(UIUtil.GetAllianceWholeName(vsAlliance.serverId, vsAlliance.abbr, vsAlliance.name))
        self.left_alliance_flag:SetData(vsAlliance.icon)
        self.left_alliance_flag_empty:SetActive(false)
    else
        self.enemy_name_text:SetLocalText(308026)
        self.left_alliance_flag:SetActive(false)
        self.left_alliance_flag_empty:SetActive(true)
    end
end

UIActivityALVSDonateSoldier.OnCreate = OnCreate
UIActivityALVSDonateSoldier.OnDestroy = OnDestroy
UIActivityALVSDonateSoldier.ComponentDefine = ComponentDefine
UIActivityALVSDonateSoldier.ComponentDestroy = ComponentDestroy
UIActivityALVSDonateSoldier.SetStaticLocalText = SetStaticLocalText
UIActivityALVSDonateSoldier.OnEnable = OnEnable
UIActivityALVSDonateSoldier.OnDisable = OnDisable
UIActivityALVSDonateSoldier.OnAddListener = OnAddListener
UIActivityALVSDonateSoldier.OnRemoveListener = OnRemoveListener
UIActivityALVSDonateSoldier.SetData = SetData
UIActivityALVSDonateSoldier.OnCellMoveIn = OnCellMoveIn
UIActivityALVSDonateSoldier.OnCellMoveOut = OnCellMoveOut
UIActivityALVSDonateSoldier.OnReloadScrollView = OnReloadScrollView
UIActivityALVSDonateSoldier.OnDonateBtnClick = OnDonateBtnClick
UIActivityALVSDonateSoldier.OnRefreshTaskNode = OnRefreshTaskNode
UIActivityALVSDonateSoldier.RefreshAllianceScore = RefreshAllianceScore
UIActivityALVSDonateSoldier.RefreshSelfScore = RefreshSelfScore
UIActivityALVSDonateSoldier.OnCheckMarkClick = OnCheckMarkClick
UIActivityALVSDonateSoldier.ClearScroll = ClearScroll
UIActivityALVSDonateSoldier.OnUpdate1000ms = OnUpdate1000ms
UIActivityALVSDonateSoldier.OnArmyNumChange = OnArmyNumChange
UIActivityALVSDonateSoldier.OnRefreshView = OnRefreshView
UIActivityALVSDonateSoldier.OnGetDonateArmyScoreInfoReturn = OnGetDonateArmyScoreInfoReturn
UIActivityALVSDonateSoldier.OnRankBtnClick = OnRankBtnClick
UIActivityALVSDonateSoldier.OnBattleBtnClick = OnBattleBtnClick
UIActivityALVSDonateSoldier.OnTipBtnClick = OnTipBtnClick
UIActivityALVSDonateSoldier.CheckRewardRedPt = CheckRewardRedPt
UIActivityALVSDonateSoldier.SetEnemyInfo = SetEnemyInfo

return UIActivityALVSDonateSoldier