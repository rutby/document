
local UIActivityDonateSoldier = BaseClass("UIActivityDonateSoldier", UIBaseView)
local DonateSoldierRankItem = require "UI.UIActivityCenterTable.Component.UIActivityDonateSoldier.DonateSoldierRankItem"
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPveActStageTip = require "UI.UIActivityCenterTable.Component.UIActivityDonateSoldier.DonateSoldierStageTip"

-- 活动标题
local activity_title_label_path = "safeArea/topLeftLayer/Txt_Title"
-- 活动描述
local activity_des_label_path = "safeArea/topLeftLayer/Txt_Des"
-- 任务节点
local task_node_path = "safeArea/TaskNode"
-- 防守积分节点
local defence_node_path = "safeArea/DefenceNode"
-- 防守积分节点title1
local defence_title_path = "safeArea/DefenceNode/defenceTitle"
-- 防守积分label1
local defence_score_label1_path = "safeArea/DefenceNode/DefenceScoreLabel1"
-- 防守积分label2
local defence_score_label2_path = "safeArea/DefenceNode/DefenceScoreLabel2"
-- 防守积分排行榜button
local defence_rank_button_path = "safeArea/DefenceNode/DefenceRankBtn"
-- 查看排名按钮文字
local rank_btn_label_path = "safeArea/DefenceNode/DefenceRankBtn/RankTitle"
-- 任务框标题
local task_title_path = "safeArea/TaskNode/taskTitle"
-- 可用任务节点
local avaliable_task_node_path = "safeArea/TaskNode/avaliableTaskNode"
-- 可用任务名字label
local avaliable_task_name_label_path = "safeArea/TaskNode/avaliableTaskNode/taskName"
-- 可用任务进度条
local avaliable_task_progress_path = "safeArea/TaskNode/avaliableTaskNode/taskProgress"
-- 可用任务领取按钮
local avaliable_task_button_path = "safeArea/TaskNode/avaliableTaskNode/taskRewardBtn"
-- 可用任务未完成不可领取按钮
local avaliable_task_button_unfinish_path = "safeArea/TaskNode/avaliableTaskNode/taskRewardBtnUnfinish"
-- 不可用任务节点
local reload_task_node_path = "safeArea/TaskNode/taskReloadingNode"
-- 不可用任务倒数计时label
local reloading_task_label_path = "safeArea/TaskNode/taskReloadingNode/reloadingLabel"
-- 不可用任务倒计时时间label
local reloading_label_time_path = "safeArea/TaskNode/taskReloadingNode/reloadingLabelTime"

-- 军力对比标题label
local compare_title_label_path = "safeArea/PowerCompareNode/PowerCompareTitleNode/StateTitleLabel"
-- 军力对比倒计时label
local compare_title_count_label_path = "safeArea/PowerCompareNode/PowerCompareTitleNode/StateTimeLabel"
-- 己方联盟标题label
local self_alliance_title_label_path = "safeArea/PowerCompareNode/PowerCompareSelfNode/SelfTitle"
-- 己方联盟军力label
local self_alliance_power_label_path = "safeArea/PowerCompareNode/PowerCompareSelfNode/SelfValue"
-- 己方联盟军力数值label
local self_alliance_power_value_label_path = "safeArea/PowerCompareNode/PowerCompareSelfNode/SelfValueNum"
-- 敌方联盟标题label
local enemy_alliance_title_label_path = "safeArea/PowerCompareNode/PowerCompareOtherNode/OtherTitle"
-- 敌方联盟军力label
local enemy_alliance_power_label_path = "safeArea/PowerCompareNode/PowerCompareOtherNode/OtherValue"
-- 敌方联盟军力数值label
local enemy_alliance_power_value_label_path = "safeArea/PowerCompareNode/PowerCompareOtherNode/OtherValueNum"

-- 排行榜scrollview
local rank_scrollview_path = "safeArea/DonateRank/ScrollView"
-- 排行榜列标题1
local rank_playerrank_label_path = "safeArea/DonateRank/select/playerrank"
-- 排行榜列标题2
local rank_playername_label_path = "safeArea/DonateRank/select/playername"
-- 排行榜列标题3
local rank_playerpower_label_path = "safeArea/DonateRank/select/playerpower"

-- 捐献按钮
local donate_btn_path = "safeArea/BottomBtnNode/BtnDonate"
-- 战斗中按钮
local battle_btn_path = "safeArea/BottomBtnNode/BtnBattle"
-- 捐献按钮文字
local donate_btn_lable_path = "safeArea/BottomBtnNode/BtnDonate/DonateBtnLabel"
-- 战斗中按钮文字
local battle_btn_lable_path = "safeArea/BottomBtnNode/BtnBattle/BattleBtnLabel"
-- 打开奖励面板按钮
local reward_btn_path = "safeArea/RewardNode/RewardBtn"
-- 奖励按钮文字
local reward_btn_label_path = "safeArea/RewardNode/RewardBtnLabel"
-- 己方联盟选择签
local alliance_checkmark_path = "safeArea/CheckMarkNode/Checkmark"
-- 己方联盟选择签按钮
local alliance_checkmark_btn_path = "safeArea/CheckMarkNode/CheckMarkBtn"
-- 己方联盟选择签旁的label
local alliance_checkmark_label_path = "safeArea/CheckMarkNode/MyAllianceLabel"

-- 自己的排行榜排名
local self_rank_lable_path = "safeArea/DonateRank/SelfScoreNode/SelfRankLabel"
-- 自己的排行榜名字
local self_rank_name_label_path = "safeArea/DonateRank/SelfScoreNode/SelfNameLabel"
-- 自己的排行榜头像
local self_rank_head_path = "safeArea/DonateRank/SelfScoreNode/UIPlayerHead/HeadIcon"
-- 自己的排行榜分数
local self_rank_score_path = "safeArea/DonateRank/SelfScoreNode/SelfPowerLabel"
-- 简介按钮
local intro_btn_path = "safeArea/topLeftLayer/Txt_Title/Intro"
-- 任务奖励弹出框(复用了UIPveActStateTip)
local stage_tip_path = "safeArea/UIPveActStageTip"
local time_icon_path = "safeArea/PowerCompareNode/PowerCompareTitleNode/timeIcon"
--reward红点
local reward_redpt_path = "safeArea/RewardNode/reward_red_pt"
local reward_text_path = "safeArea/RewardNode/reward_red_pt/RewardText"
local progress_value_label_path = "safeArea/TaskNode/avaliableTaskNode/taskProgress/ProgressValueLabel"

-- local defence_title2_path = "safeArea/DefenceNode/defenceTitle/defenceTitle2"
local defence_num1_path = "safeArea/DefenceNode/DefenceScoreLabel1/DefenceNum1"
local defence_num2_path = "safeArea/DefenceNode/DefenceScoreLabel2/DefenceNum2"

local task_reward_btn_animator_path = "safeArea/TaskNode/avaliableTaskNode/taskRewardBtn"
--无更多任务提醒文字
local no_more_task_label_path = "safeArea/TaskNode/noMoreTaskLabel"

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
        self.view.ctrl:OnGetDonateSoldierTaskReward()

    end)
    self.avaliable_task_button_unfinish = self:AddComponent(UIButton, avaliable_task_button_unfinish_path)
    self.avaliable_task_button_unfinish:SetOnClick(function()
        --不可领奖按钮点击 弹提示
        local taskInfo = DataCenter.ActivityDonateSoldierManager:GetCurrentTaskInfo()
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

    self.compare_title_label = self:AddComponent(UIText, compare_title_label_path)
    self.compare_title_count_label = self:AddComponent(UIText, compare_title_count_label_path)
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
    self.battle_btn_state = 0
    self.donate_btn_lable = self:AddComponent(UIText, donate_btn_lable_path)
    self.battle_btn_lable = self:AddComponent(UIText, battle_btn_lable_path)
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
    self.reward_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDonateSoldierReward)
    end)
    self.reward_btn_label = self:AddComponent(UIText, reward_btn_label_path)
    self.reward_btn_label:SetLocalText(372781)
    self.activity_title_label = self:AddComponent(UIText, activity_title_label_path)
    self.activity_des_label = self:AddComponent(UIText, activity_des_label_path)

    self.alliance_checkmark = self:AddComponent(UIBaseContainer, alliance_checkmark_path)
    self.alliance_checkmark_btn = self:AddComponent(UIButton, alliance_checkmark_btn_path)
    self.alliance_checkmark_btn:SetOnClick(function() 
        self:OnCheckMarkClick()
    end)
    self.alliance_checkmark_label = self:AddComponent(UIText, alliance_checkmark_label_path)
    self.alliance_checkmark_label:SetLocalText(110293)

    self.alliance_checkmark:SetActive(false)
    self.showSelfAlliance = false

    self.timer_action = function(temp)
        self:OnUpdate()
    end
    
    self.self_rank_lable = self:AddComponent(UIText, self_rank_lable_path)
    self.self_rank_name_label = self:AddComponent(UIText, self_rank_name_label_path)
    self.self_rank_head = self:AddComponent(UIPlayerHead, self_rank_head_path)
    self.self_rank_score = self:AddComponent(UIText, self_rank_score_path)
    self.task_node = self:AddComponent(UIBaseContainer, task_node_path)
    self.defence_node = self:AddComponent(UIBaseContainer, defence_node_path)
    self.defence_title = self:AddComponent(UIText, defence_title_path)
    self.defence_score_label1 = self:AddComponent(UIText, defence_score_label1_path)
    self.defence_score_label2 = self:AddComponent(UIText, defence_score_label2_path)
    self.rank_btn_label = self:AddComponent(UIText, rank_btn_label_path)
    self.rank_btn_label:SetLocalText(372799)
    self.defence_rank_button = self:AddComponent(UIButton, defence_rank_button_path)
    self.defence_rank_button:SetOnClick(function()
        self:OnRankBtnClick()
    end)
    self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
    self.intro_btn:SetOnClick(function()
        self:OnTipBtnClick()
    end)

    self.stage_tip = self:AddComponent(UIPveActStageTip, stage_tip_path)
    self.view_state = -1
    self.time_icon = self:AddComponent(UIBaseContainer, time_icon_path)
    self.reward_redpt = self:AddComponent(UIBaseContainer, reward_redpt_path)
    self.progress_value_label = self:AddComponent(UIText, progress_value_label_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
    -- self.defence_title2 = self:AddComponent(UIText, defence_title2_path)
    self.defence_num1 = self:AddComponent(UIText, defence_num1_path)
    self.defence_num2 = self:AddComponent(UIText, defence_num2_path)
    self.task_reward_btn_animator = self:AddComponent(UIAnimator, task_reward_btn_animator_path)
    self.no_more_task_label = self:AddComponent(UIText, no_more_task_label_path)
    self.no_more_task_label:SetLocalText(372328)

    self.battle_btn_des_label = 308038
end

local function ComponentDestroy(self)
    self.task_title = nil
    self.avaliable_task_node = nil
    self.avaliable_task_name_label = nil
    self.avaliable_task_progress = nil
    self.avaliable_task_button = nil
    self.reload_task_node = nil
    self.reloading_task_label = nil
    self.compare_title_label = nil
    self.compare_title_count_label = nil
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
    self.defence_node = nil
    self.defence_title = nil
    self.defence_score_label1 = nil
    self.defence_score_label2 = nil
    self.defence_rank_button = nil
    self.stage_tip = nil
    self.time_icon = nil
    self.reward_redpt = nil
    self.progress_value_label = nil
    self.reward_text = nil
    -- self.defence_title2 = nil
    self.defence_num1 = nil
    self.defence_num2 = nil
    self.task_reward_btn_animator = nil
    self.reloading_label_time = nil
    self.no_more_task_label = nil

end

local function OnRankBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDonateSoldierRank)
end

local function SetStaticLocalText(self)
    -- 设置界面固定多语言
    self.rank_playerrank_label:SetLocalText(302822)
    self.rank_playername_label:SetLocalText(100184)
    self.rank_playerpower_label:SetLocalText(372780)
    self.donate_btn_lable:SetLocalText(372782)
    self.task_title:SetLocalText(372783)
    self.battle_btn_lable:SetText("")
    self.compare_title_label:SetText("")
    self.reloading_task_label:SetLocalText(372205)

    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        self.activity_title_label:SetLocalText(activityData.name)
        self.activity_des_label:SetLocalText(activityData.desc_info)
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
    self:AddTimer()
    self:OnUpdate(0)
end

local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PushArmyInfoEvent, BindCallback(self, self.OnArmyNumChange))
    self:AddUIListener(EventId.GetDonateArmyScoreInfo, BindCallback(self,self.OnGetDonateArmyScoreInfoReturn))
    -- 捐兵结束刷新自己和联盟的分数
    self:AddUIListener(EventId.DonateSoldier, BindCallback(self,self.OnRefreshView))
    self:AddUIListener(EventId.ReceiveDonateArmyTaskReward, BindCallback(self, self.OnRefreshTaskNode))
    self:AddUIListener(EventId.PushDonateArmyTaskUpdate, BindCallback(self, self.OnRefreshTaskNode))
    self:AddUIListener(EventId.UIDonateSoldierInfoDataUpdate, BindCallback(self, self.OnBattleDataReturn))
    self:AddUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
    self:AddUIListener(EventId.GetDonateArmyActivityInfo, BindCallback(self, self.OnRequestDonateSoldierActivityReturn))
    self:AddUIListener(EventId.PushPirateSiegeBattleStartEvent, BindCallback(self, self.OnOpenAttackStateReturn))
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PushArmyInfoEvent, BindCallback(self, self.OnArmyNumChange))
    self:RemoveUIListener(EventId.GetDonateArmyScoreInfo, BindCallback(self,self.OnGetDonateArmyScoreInfoReturn))
    self:RemoveUIListener(EventId.DonateSoldier, BindCallback(self,self.OnRefreshView))
    self:RemoveUIListener(EventId.ReceiveDonateArmyTaskReward, BindCallback(self, self.OnRefreshTaskNode))
    self:RemoveUIListener(EventId.PushDonateArmyTaskUpdate, BindCallback(self, self.OnRefreshTaskNode))
    self:RemoveUIListener(EventId.UIDonateSoldierInfoDataUpdate, BindCallback(self, self.OnBattleDataReturn))
    self:RemoveUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
    self:RemoveUIListener(EventId.GetDonateArmyActivityInfo, BindCallback(self, self.OnRequestDonateSoldierActivityReturn))
    self:RemoveUIListener(EventId.PushPirateSiegeBattleStartEvent, BindCallback(self, self.OnOpenAttackStateReturn))
    base.OnRemoveListener(self)
end

local function SetData(self,activityId,id)
    self.activityId = activityId
    -- 排行榜数据
    self.dataList = {}
    self:SetStaticLocalText()
    SFSNetwork.SendMessage(MsgDefines.GetDonateArmyScoreInfo)
    self.stage_tip:SetActive(false)
    self:RequestUpdateNewTask()
end

local function OnGetDonateArmyScoreInfoReturn(self)
    --获取数据请求发回后 首先判断是否进入了战斗 如果是 则发送战斗信息请求
    local attackOpenTime = DataCenter.ActivityDonateSoldierManager:GetExpeditionOpenTime()
    local nowTime = UITimeManager:GetInstance():GetServerTime()
    if attackOpenTime < nowTime then
        --进入战斗任务节点要隐藏
        self.task_node:SetActive(false)
        self.defence_node:SetActive(true)
        self.donate_btn:SetActive(false)
        -- 已经进入了战斗 发送战斗数据请求
        DataCenter.ActivityDonateSoldierManager:OnSendGetDonateSoldierInfoMsg()
    else
        -- 还未进入战斗
        self.view_state = 0
        self.task_node:SetActive(true)
        self.defence_node:SetActive(false)
        self.donate_btn:SetActive(true)
        self.battle_btn:SetActive(false)
        self.compare_title_label:SetLocalText(372777)--距离远征开启：
    end
    self:OnRefreshView()
end

local function OnRefreshView(self)
    self:OnReloadScrollView()
    self:RefreshSelfScore()
    self:RefreshAllianceScore()
    self:OnRefreshTaskNode()
    self:CheckRewardRedPt()
end

local function OnBattleDataReturn(self)
    -- 请求战斗数据返回后刷新当前右上角状态
    local battleData = DataCenter.ActivityDonateSoldierManager:DonateSoldierInfoViewData()
    if battleData then
        self.battle_btn_state = 0
        if battleData.state == AllianceDonateState.Waiting then
            -- 已经到了进攻时间 但并未开启进攻
            self.defence_title:SetLocalText(309017)
            self.compare_title_label:SetLocalText(309016)
            self.battle_btn_state = 1
            self.battle_btn_lable:SetLocalText(309013)  --开始迎敌
        elseif battleData.state == AllianceDonateState.Attaking then
            -- 正在进攻
            self.compare_title_label:SetLocalText(372794)
            -- 当前波次 {0}
            self.defence_title:SetLocalText(372796, tostring(battleData.round))
            -- self.defence_title2:SetText(tostring(battleData.round))
            self.battle_btn_lable:SetLocalText(308038) --迎战中
            self.battle_btn_des_label = 308038 --无法捐兵 迎战中
        else
            -- 远征已结束
            self.compare_title_label:SetLocalText(372800)
            -- self.defence_title2:SetText("")
            self.battle_btn_lable:SetLocalText(370100)  --活动已结束
            self.battle_btn_des_label = 370100 -- 活动已结束
            if battleData.state == AllianceDonateState.Victory then
                --我方胜利
                self.defence_title:SetLocalText(372801)
            elseif battleData.state == AllianceDonateState.Lose then
                --我方失败
                self.defence_title:SetLocalText(372802)
            elseif battleData.state == AllianceDonateState.End then
                -- 结算中
                self.defence_title:SetLocalText(309020)
            else
                self.defence_title:SetLocalText(372800)
            end
        end

        self.battle_btn:SetActive(true)
        --按钮加一个开始攻城的状态
        if self.battle_btn_state == 0 then
            --已出发 置灰
            CS.UIGray.SetGray(self.battle_btn.transform, true, true)--既要置灰又要能点击
        else
            --未出发 正常
            CS.UIGray.SetGray(self.battle_btn.transform, false, true)--既要置灰又要能点击
        end

        --进入战斗刷新红点
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end

    -- 我方防守积分{0}
    if battleData.state == AllianceDonateState.Waiting then
        self.defence_score_label1:SetLocalText(309018)
    else
        self.defence_score_label1:SetLocalText(372797)
        self.defence_num1:SetText(string.GetFormattedSeperatorNum(battleData.allianceDefenceScore))
    end

    -- 敌盟是否开启了战斗
    if battleData.vsAllianceState == AllianceDonateState.Waiting  then
        -- 敌盟未开启
        self.defence_score_label2:SetLocalText(309019)
    else
        -- 敌方防守积分{0}
        self.defence_score_label2:SetLocalText(372798)
        self.defence_num2:SetText(string.GetFormattedSeperatorNum(battleData.vsAllianceDefenceScore))
    end

    self.defence_node:SetActive(true)
end

local function OnReloadScrollView(self)
    self:ClearScroll()
    self.dataList = self.view.ctrl:GetDonateSoldierActivityDataList(self.showSelfAlliance)
    if #self.dataList > 0 then
        self.rank_scrollview:SetTotalCount(#self.dataList)
        self.rank_scrollview:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.rank_scrollview:AddComponent(DonateSoldierRankItem, itemObj)
    cellItem:SetData(self.dataList[index], index)
end

local function ClearScroll(self)
    self.rank_scrollview:RemoveComponents(DonateSoldierRankItem)
    self.rank_scrollview:ClearCells()
end

local function OnCellMoveOut(self,itemObj, index)
    self.rank_scrollview:RemoveComponent(itemObj.name, DonateSoldierRankItem)
end

local function OnDonateBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDonateSoldierSelect) 
end

local function OnRefreshTaskNode(self)
    local taskInfo = DataCenter.ActivityDonateSoldierManager:GetCurrentTaskInfo()
    if taskInfo == nil or taskInfo.taskId == nil then
        --无任务的状态
        self.avaliable_task_node:SetActive(false)
        if taskInfo == nil then
            --如果任务信息都没了 就不显示倒计时节点 显示无新任务
            self.no_more_task_label:SetActive(true)
        else
            local expeditionTimeStamp = DataCenter.ActivityDonateSoldierManager:GetExpeditionOpenTime()
            if taskInfo.nextRecoverTime ~= nil and taskInfo.nextRecoverTime >= expeditionTimeStamp then
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
    local selfAllianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)
    local enemyAllianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(2)

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

-- 计时器相关
local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end

    self.timer:Start()
end

-- 检测如果任务时间到了的时候请求刷新新任务
local function RequestUpdateNewTask(self)
    local taskInfo = DataCenter.ActivityDonateSoldierManager:GetCurrentTaskInfo()
    if taskInfo ~= nil and taskInfo.nextRecoverTime ~= nil then
        if taskInfo.nextRecoverTime == 0 then
            -- 当一个任务都没做的时候 任务刷新时间是0 这个时候不要刷任务
            return
        end
        local now = UITimeManager:GetInstance():GetServerTime()
        local leftTime = taskInfo.nextRecoverTime - now
        if leftTime < 0 then
            SFSNetwork.SendMessage(MsgDefines.GetDonateArmyActivityInfo)
        end
    end
end

-- 任务刷新倒计时到了 发送的获取捐兵活动信息的请求返回 要刷新任务信息
local function OnRequestDonateSoldierActivityReturn(self)
    self:OnRefreshTaskNode()
end

-- 每秒更新
local function OnUpdate(self, dt)
    local taskInfo = DataCenter.ActivityDonateSoldierManager:GetCurrentTaskInfo()
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

    -- 距离开启倒计时
    local expeditionTimeStamp = DataCenter.ActivityDonateSoldierManager:GetExpeditionOpenTime()
    local expeditionLeftTime = expeditionTimeStamp - now
    if expeditionLeftTime > 0 then
        -- 还未开启
        self.compare_title_count_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(expeditionLeftTime))
        self.time_icon:SetActive(true)
    else
        -- 已经开启
        self.compare_title_count_label:SetActive(false)
        if self.view_state == 0 then
            --到时间就刷新活动数据
            self.view_state = 1
            SFSNetwork.SendMessage(MsgDefines.GetDonateArmyScoreInfo)
        end
        self.time_icon:SetActive(false)
    end

end

local function RefreshSelfScore(self)
    local selfData = DataCenter.ActivityDonateSoldierManager:GetPlayerCurrDonateSoldierInfo()
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
    if self.battle_btn_state == 0 then
        -- 战斗中按钮 点击提示 战斗中无法捐献
        UIUtil.ShowTipsId(self.battle_btn_des_label)
    else
        -- 未出发 点击发送出发请求
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            UIUtil.ShowSecondMessage(
                Localization:GetString("309013"), --标题
                Localization:GetString("309014"), --内容 
                2, --按钮数量
                309013, --按钮文字1
                "", --按钮文字2
                function() --按钮1回调
                    DataCenter.ActivityDonateSoldierManager:OnSendOpenSiegeMsg()
                end
            )
        else
            UIUtil.ShowTipsId(309015)
        end
    end
    
end

local function OnOpenAttackStateReturn(self)
    DataCenter.ActivityDonateSoldierManager:OnSendGetDonateSoldierInfoMsg()
end

local function OnTipBtnClick(self)
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        UIUtil.ShowIntro(Localization:GetString(activityData.name), Localization:GetString("100239"), Localization:GetString(activityData.story))
    end
end

--判断红点是否应该显示
local function CheckRewardRedPt(self)
    local canShowRedPtNum = DataCenter.ActivityDonateSoldierManager:GetIsCurrRewardCanReceiveNum()
    if canShowRedPtNum > 0 then
        self.reward_redpt:SetActive(true)
        self.reward_text:SetText(tostring(canShowRedPtNum))
    else
        self.reward_redpt:SetActive(false)
    end
end

UIActivityDonateSoldier.OnCreate = OnCreate
UIActivityDonateSoldier.OnDestroy = OnDestroy
UIActivityDonateSoldier.ComponentDefine = ComponentDefine
UIActivityDonateSoldier.ComponentDestroy = ComponentDestroy
UIActivityDonateSoldier.SetStaticLocalText = SetStaticLocalText
UIActivityDonateSoldier.OnEnable = OnEnable
UIActivityDonateSoldier.OnDisable = OnDisable
UIActivityDonateSoldier.OnAddListener = OnAddListener
UIActivityDonateSoldier.OnRemoveListener = OnRemoveListener
UIActivityDonateSoldier.SetData = SetData
UIActivityDonateSoldier.OnCellMoveIn = OnCellMoveIn
UIActivityDonateSoldier.OnCellMoveOut = OnCellMoveOut
UIActivityDonateSoldier.OnReloadScrollView = OnReloadScrollView
UIActivityDonateSoldier.OnDonateBtnClick = OnDonateBtnClick
UIActivityDonateSoldier.OnRefreshTaskNode = OnRefreshTaskNode
UIActivityDonateSoldier.RefreshAllianceScore = RefreshAllianceScore
UIActivityDonateSoldier.RefreshSelfScore = RefreshSelfScore
UIActivityDonateSoldier.OnCheckMarkClick = OnCheckMarkClick
UIActivityDonateSoldier.ClearScroll = ClearScroll
UIActivityDonateSoldier.DeleteTimer = DeleteTimer
UIActivityDonateSoldier.AddTimer = AddTimer
UIActivityDonateSoldier.OnUpdate = OnUpdate
UIActivityDonateSoldier.OnArmyNumChange = OnArmyNumChange
UIActivityDonateSoldier.OnRefreshView = OnRefreshView
UIActivityDonateSoldier.OnBattleDataReturn = OnBattleDataReturn
UIActivityDonateSoldier.OnGetDonateArmyScoreInfoReturn = OnGetDonateArmyScoreInfoReturn
UIActivityDonateSoldier.OnRankBtnClick = OnRankBtnClick
UIActivityDonateSoldier.OnBattleBtnClick = OnBattleBtnClick
UIActivityDonateSoldier.OnTipBtnClick = OnTipBtnClick
UIActivityDonateSoldier.CheckRewardRedPt = CheckRewardRedPt
UIActivityDonateSoldier.RequestUpdateNewTask = RequestUpdateNewTask
UIActivityDonateSoldier.OnRequestDonateSoldierActivityReturn = OnRequestDonateSoldierActivityReturn
UIActivityDonateSoldier.OnOpenAttackStateReturn = OnOpenAttackStateReturn


return UIActivityDonateSoldier