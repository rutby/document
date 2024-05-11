local UIActivityALVSBattle = BaseClass("UIActivityALVSBattle", UIBaseContainer)
local base = UIBaseContainer
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local UIALVSAllianceItem = require "UI.UIActivityCenterTable.Component.UIActivityALVSDonateSoldier.UIALVSAllianceItem"
local Localization = CS.GameEntry.Localization

--path define

local back_path = "Back"
local top_node_path = "TopNode"
local title_path = "TitleNode/Title"
local hori_path = "TopNode/Hori"
local center_desc_path = "TopNode/Hori/CenterDesc"
local time_path = "TopNode/Hori/Time"
local left_alliance_flag_path = "TopNode/LeftAllianceFlag"
local left_alliance_flag_empty_path = "TopNode/LeftAllianceFlagEmpty"
local left_alliance_name_path = "TopNode/LeftAllianceName"
local left_alliance_name2_path = "TopNode/LeftAllianceName2"
local left_alliance_score_path = "TopNode/LeftAllianceScore"
local left_alliance_score_desc_path = "TopNode/LeftAllianceScoreDesc"
local score_info_path = "TopNode/LeftAllianceScore/ScoreInfo"
local right_alliance_flag_path = "TopNode/RightAllianceFlag"
local right_alliance_flag_empty_path = "TopNode/RightAllianceFlagEmpty"
local right_alliance_name_path = "TopNode/RightAllianceName"
local right_alliance_name2_path = "TopNode/RightAllianceName2"
local right_alliance_score_path = "TopNode/RightAllianceScore"
local right_alliance_score_desc_path = "TopNode/RightAllianceScoreDesc"
local center_pic_node_path = "CenterPicNode"
local intro_1_path = "CenterPicNode/Center/Intro_1"
local intro_2_path = "CenterPicNode/Center/Intro_2"
local intro_3_path = "CenterPicNode/Center/Intro_3"
local intro_desc_1_path = "CenterPicNode/Center/Intro_1/IntroDesc_1"
local intro_desc_2_path = "CenterPicNode/Center/Intro_2/IntroDesc_2"
local intro_desc_3_path = "CenterPicNode/Center/Intro_3/IntroDesc_3"
local left_path = "CenterPicNode/Left"
local right_path = "CenterPicNode/Right"
local attack_bottom_desc_path = "AttackState/AttackBottomDesc"
local prepare_bottom_desc_path = "PrepareState/PrepareBottomDesc"
-- local prepare_bottom_desc2_path = "PrepareState/PrepareBottomDesc2"

local no_alliance_state_path = "NoAllianceState"
local join_alliance_btn_path = "NoAllianceState/JoinAllianceBtn"
local join_alliance_text_path = "NoAllianceState/JoinAllianceBtn/JoinAllianceText"
local prepare_state_path = "PrepareState"
local declare_war_btn_path = "PrepareState/DeclareWarBtn"
local declare_war_text_path = "PrepareState/DeclareWarBtn/DeclareWarText"
-- local declare_des_text_path = "PrepareState/DeclareDesText"
local wait_start_text_path = "PrepareState/WaitStartText"
local attack_state_path = "AttackState"
local attack_act_time_text_path = "TitleNode/attackActTimeNode/attackActTimeText"

local begin_war_btn_path = "AttackState/BeginWarBtn"
local begin_war_text_path = "AttackState/BeginWarBtn/BeginWarText"
local begin_war_des_text_path = "AttackState/BeginWarDesText"
--AllianceCenterLayout/SelfNode/
--AllianceCenterLayout/EnemyNode/
-- 敌我联盟建筑图标
local self1_path = "AttackState/AllianceCenterLayout/SelfNode/SelfAllianceCenter/self1"
local self2_path = "AttackState/AllianceCenterLayout/SelfNode/SelfAllianceCenter/self2"
local self3_path = "AttackState/AllianceCenterLayout/SelfNode/SelfAllianceCenter/self3"
local enemy1_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyAllianceCenter/enemy1"
local enemy2_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyAllianceCenter/enemy2"
local enemy3_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyAllianceCenter/enemy3"
-- 胜利失败
local left_win_path = "AttackState/LeftWin"
local left_lose_path = "AttackState/LeftLose"
local right_win_path = "AttackState/RightWin"
local right_lose_path = "AttackState/RightLose"

local right_btn_list_path = "RightBtnList"
local reward_path = "RightBtnList/Reward"
local reward_red_pt_path = "RightBtnList/Reward/reward_red_pt"
local reward_text_path = "RightBtnList/Reward/reward_red_pt/RewardText"
local reward_btn_text_path = "RightBtnList/Reward/RewardBtnText"
local rule_path = "RightBtnList/Rule"
local donate_rank_path = "RightBtnList/DonateRank"
local rule_text_path = "RightBtnList/Rule/RuleText"
local hero_text_path = "RightBtnList/DonateRank/HeroText"

local score_node_path = "AttackState/ScoreNode"
local line1_desc_path = "AttackState/ScoreNode/Line1/Line1Desc"
local line1_left_val_path = "AttackState/ScoreNode/Line1/Line1LeftVal"
local line1_right_val_path = "AttackState/ScoreNode/Line1/Line1RightVal"
local line2_desc_path = "AttackState/ScoreNode/Line2/Line2Desc"
local line2_left_val_path = "AttackState/ScoreNode/Line2/Line2LeftVal"
local line2_right_val_path = "AttackState/ScoreNode/Line2/Line2RightVal"

local no_enemy_state_path = "NoEnemyState"
local ready1_desc_path = "NoEnemyState/ready1Desc"
local self_left_path = "AttackState/AllianceCenterLayout/SelfNode/SelfLeft"
local self_right_path = "AttackState/AllianceCenterLayout/SelfNode/SelfRight"
local enemy_left_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyLeft"
local enemy_right_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyRight"

local self_pos_node_path = "AttackState/AllianceCenterLayout/SelfNode/SelfPosNode"
local self_pos_icon1_path = "AttackState/AllianceCenterLayout/SelfNode/SelfPosNode/SelfPos1Node/SelfPosIcon1"
local self_pos_icon2_path = "AttackState/AllianceCenterLayout/SelfNode/SelfPosNode/SelfPos2Node/SelfPosIcon2"
local self_pos_icon3_path = "AttackState/AllianceCenterLayout/SelfNode/SelfPosNode/SelfPos3Node/SelfPosIcon3"
local enemy_pos_node_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyPosNode"
local enemy_pos_icon1_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyPosNode/EnemyPos1Node/EnemyPosIcon1"
local enemy_pos_icon2_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyPosNode/EnemyPos2Node/EnemyPosIcon2"
local enemy_pos_icon3_path = "AttackState/AllianceCenterLayout/EnemyNode/EnemyPosNode/EnemyPos3Node/EnemyPosIcon3"

local enemy_node_path = "AttackState/AllianceCenterLayout/EnemyNode"

local left_des_text_path = "TopNode/BgNode/LeftDesText"
local right_des_text_path = "TopNode/BgNode/RightDesText"

--path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end


local function ComponentDefine(self)
    self.title = self:AddComponent(UIText, title_path)
    self.hori = self:AddComponent(UIImage, hori_path)
    self.top_node = self:AddComponent(UIText, top_node_path)
    self.center_desc = self:AddComponent(UIText, center_desc_path)
    self.time = self:AddComponent(UIText, time_path)
    self.left_alliance_flag = self:AddComponent(AllianceFlagItem, left_alliance_flag_path)
    self.left_alliance_flag_empty = self:AddComponent(UIImage, left_alliance_flag_empty_path)
    self.left_alliance_name = self:AddComponent(UIText, left_alliance_name_path)
    self.left_alliance_name2 = self:AddComponent(UIText, left_alliance_name2_path)
    self.left_alliance_score = self:AddComponent(UIText, left_alliance_score_path)
    self.left_alliance_score_desc = self:AddComponent(UIText, left_alliance_score_desc_path)
    self.left_alliance_score_desc:SetLocalText(308017)
    self.right_alliance_flag = self:AddComponent(AllianceFlagItem, right_alliance_flag_path)
    self.right_alliance_flag_empty = self:AddComponent(UIImage, right_alliance_flag_empty_path)
    self.right_alliance_name = self:AddComponent(UIText, right_alliance_name_path)
    self.right_alliance_name2 = self:AddComponent(UIText, right_alliance_name2_path)
    self.right_alliance_score = self:AddComponent(UIText, right_alliance_score_path)
    self.right_alliance_score_desc = self:AddComponent(UIText, right_alliance_score_desc_path)
    self.right_alliance_score_desc:SetLocalText(308017)
    self.score_info = self:AddComponent(UIButton, score_info_path)
    self.score_info:SetOnClick(function()
        self:OnScoreTipBtnClick()
    end)
    self.center_pic_node = self:AddComponent(UIBaseContainer, center_pic_node_path)
    self.intro_1 = self:AddComponent(UIBaseContainer, intro_1_path)
    self.intro_2 = self:AddComponent(UIBaseContainer, intro_2_path)
    self.intro_3 = self:AddComponent(UIBaseContainer, intro_3_path)
    self.intro_desc_1 = self:AddComponent(UIText, intro_desc_1_path)
    self.intro_desc_1:SetLocalText(308005)
    self.intro_desc_2 = self:AddComponent(UIText, intro_desc_2_path)
    self.intro_desc_2:SetLocalText(308007)
    self.intro_desc_3 = self:AddComponent(UIText, intro_desc_3_path)
    self.intro_desc_3:SetLocalText(308006)

    self.left = self:AddComponent(UIButton, left_path)
    self.left:SetOnClick(function() 
        self:OnLeftBtnClick()
    end)
    self.right = self:AddComponent(UIButton, right_path)
    self.right:SetOnClick(function()
        self:OnRightBtnClick()
    end)
    self.attack_bottom_desc = self:AddComponent(UIText, attack_bottom_desc_path)
    self.prepare_bottom_desc = self:AddComponent(UIText, prepare_bottom_desc_path)
    -- self.prepare_bottom_desc2 = self:AddComponent(UIText, prepare_bottom_desc2_path)
    -- local value = LuaEntry.DataConfig:TryGetStr("activity_donate_v2", "k7")
    -- self.prepare_bottom_desc2:SetLocalText(308028, value)

    -- 无联盟状态
    self.no_alliance_state = self:AddComponent(UIBaseContainer, no_alliance_state_path)
    self.join_alliance_btn = self:AddComponent(UIButton, join_alliance_btn_path)
    self.join_alliance_btn:SetOnClick(function()
        self:OnJoinAllianceBtnClick()
    end)
    self.join_alliance_text = self:AddComponent(UIText, join_alliance_text_path)
    self.join_alliance_text:SetLocalText(390079)
    -- 准备状态
    self.prepare_state = self:AddComponent(UIBaseContainer, prepare_state_path)
    self.declare_war_btn = self:AddComponent(UIButton, declare_war_btn_path)
    self.declare_war_btn:SetOnClick(function()
        self:OnDeclareWarBtnClick()
    end)
    self.declare_war_text = self:AddComponent(UIText, declare_war_text_path)
    self.declare_war_text:SetLocalText(302839)
    -- self.declare_des_text = self:AddComponent(UIText, declare_des_text_path)
    -- self.declare_des_text:SetLocalText(308045)

    self.wait_start_text = self:AddComponent(UIText, wait_start_text_path)
    self.wait_start_text:SetLocalText(308030)

    -- 攻击状态
    self.attack_state = self:AddComponent(UIBaseContainer, attack_state_path)    
    self.attack_act_time_text = self:AddComponent(UIText, attack_act_time_text_path)

    self.begin_war_btn = self:AddComponent(UIButton, begin_war_btn_path)
    self.begin_war_btn:SetOnClick(function() 
        self:OnBeginBattleBtnClick()
    end)
    self.begin_war_text = self:AddComponent(UIText, begin_war_text_path)
    self.begin_war_text:SetLocalText(308015)
    self.begin_war_des_text = self:AddComponent(UIText, begin_war_des_text_path)
    self.begin_war_des_text:SetLocalText(308045)
    
    self.self1 = self:AddComponent(UIALVSAllianceItem, self1_path)
    self.self1:SetIsSelf(true)
    self.self2 = self:AddComponent(UIALVSAllianceItem, self2_path)
    self.self2:SetIsSelf(true)
    self.self3 = self:AddComponent(UIALVSAllianceItem, self3_path)
    self.self3:SetIsSelf(true)
    self.enemy1 = self:AddComponent(UIALVSAllianceItem, enemy1_path)
    self.enemy2 = self:AddComponent(UIALVSAllianceItem, enemy2_path)
    self.enemy3 = self:AddComponent(UIALVSAllianceItem, enemy3_path)

    self.left_win = self:AddComponent(UIText, left_win_path)
    self.left_win:SetLocalText(390186)
    self.left_lose = self:AddComponent(UIText, left_lose_path)
    self.left_lose:SetLocalText(390187)
    self.right_win = self:AddComponent(UIText, right_win_path)
    self.right_win:SetLocalText(390186)
    self.right_lose = self:AddComponent(UIText, right_lose_path)
    self.right_lose:SetLocalText(390187)

    self.right_btn_list = self:AddComponent(UIBaseContainer, right_btn_list_path)
    self.reward = self:AddComponent(UIButton, reward_path)
    self.reward:SetOnClick(function()
        self:OnRightRewardBtnClick()
    end)
    self.reward_btn_text = self:AddComponent(UIText, reward_btn_text_path)
    self.reward_btn_text:SetLocalText(130065)
    self.reward_red_pt = self:AddComponent(UIBaseContainer, reward_red_pt_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
    self.rule = self:AddComponent(UIButton, rule_path)
    self.rule:SetOnClick(function()
        self:OnRightRuleBtnClick()

    end)
    self.rule_text = self:AddComponent(UIText, rule_text_path)
    self.rule_text:SetLocalText(372116)

    self.donate_rank = self:AddComponent(UIButton, donate_rank_path)
    self.donate_rank:SetOnClick(function()
        self:OnRightDonateRankBtnClick()
    end)
    self.hero_text = self:AddComponent(UIText, hero_text_path)
    self.hero_text:SetLocalText(390267)

    -- 下方得分表
    self.score_node = self:AddComponent(UIImage, score_node_path)
    self.line1_desc = self:AddComponent(UIText, line1_desc_path)
    self.line1_desc:SetLocalText(308023)
    self.line1_left_val = self:AddComponent(UIText, line1_left_val_path)
    self.line1_right_val = self:AddComponent(UIText, line1_right_val_path)
    self.line2_desc = self:AddComponent(UIText, line2_desc_path)
    self.line2_desc:SetLocalText(308024)
    self.line2_left_val = self:AddComponent(UIText, line2_left_val_path)
    self.line2_right_val = self:AddComponent(UIText, line2_right_val_path)

    self.no_enemy_state = self:AddComponent(UIImage, no_enemy_state_path)
    self.ready1_desc = self:AddComponent(UIText, ready1_desc_path)
    self.ready1_desc:SetLocalText(308029)

    self.self_left = self:AddComponent(UIButton, self_left_path)
    self.self_left:SetOnClick(function()
        self:OnSelfLeftBtnClick()
    end)
    self.self_right = self:AddComponent(UIButton, self_right_path)
    self.self_right:SetOnClick(function()
        self:OnSelfRightBtnClick()
    end)
    self.enemy_left = self:AddComponent(UIButton, enemy_left_path)
    self.enemy_left:SetOnClick(function()
        self:OnEnemyLeftBtnClick()
    end)
    self.enemy_right = self:AddComponent(UIButton, enemy_right_path)
    self.enemy_right:SetOnClick(function()
        self:OnEnemyRightBtnClick()
    end)

    self.self_pos_node = self:AddComponent(UIBaseContainer, self_pos_node_path)
    self.self_pos_icon1 = self:AddComponent(UIImage, self_pos_icon1_path)
    self.self_pos_icon2 = self:AddComponent(UIImage, self_pos_icon2_path)
    self.self_pos_icon3 = self:AddComponent(UIImage, self_pos_icon3_path)
    self.enemy_pos_node = self:AddComponent(UIBaseContainer, enemy_pos_node_path)
    self.enemy_pos_icon1 = self:AddComponent(UIImage, enemy_pos_icon1_path)
    self.enemy_pos_icon2 = self:AddComponent(UIImage, enemy_pos_icon2_path)
    self.enemy_pos_icon3 = self:AddComponent(UIImage, enemy_pos_icon3_path)

    self.left_des_text = self:AddComponent(UIText, left_des_text_path)
    self.left_des_text:SetLocalText(308017)
    self.right_des_text = self:AddComponent(UIText, right_des_text_path)
    self.right_des_text:SetLocalText(308017)

    self.enemy_node = self:AddComponent(UIBaseContainer, enemy_node_path)

    self.currSelfBuildIdx = 1
    self.currEnemyBuildIdx = 1
end

local function ComponentDestroy(self)
    self.back = nil
    self.hori = nil
    self.top_node = nil
    self.title = nil
    self.center_desc = nil
    self.time = nil
    self.left_alliance_flag = nil
    self.left_alliance_flag_empty = nil
    self.left_alliance_name = nil
    self.left_alliance_score = nil
    self.left_alliance_score_desc = nil
    self.right_alliance_flag = nil
    self.right_alliance_flag_empty = nil
    self.right_alliance_name = nil
    self.right_alliance_score = nil
    self.right_alliance_score_desc = nil
    self.center_pic_node = nil
    self.intro_1 = nil
    self.intro_2 = nil
    self.intro_3 = nil
    self.left = nil
    self.right = nil
    self.attack_bottom_desc = nil
    self.prepare_bottom_desc = nil
    -- self.prepare_bottom_desc2 = nil

    self.score_info = nil

    self.no_alliance_state = nil
    self.join_alliance_btn = nil
    self.join_alliance_text = nil
    self.prepare_state = nil
    self.declare_war_btn = nil
    self.declare_war_text = nil
    -- self.declare_des_text = nil
    self.wait_start_text = nil

    self.attack_state = nil

    self.begin_war_btn = nil
    self.begin_war_text = nil
    self.begin_war_des_text = nil

    self.self1 = nil
    self.self2 = nil
    self.self3 = nil
    self.self4 = nil
    self.enemy1 = nil
    self.enemy2 = nil
    self.enemy3 = nil
    self.enemy4 = nil

    self.left_win = nil
    self.left_lose = nil
    self.right_win = nil
    self.right_lose = nil
    self.attack_act_time_text = nil

    self.right_btn_list = nil
    self.reward = nil
    self.reward_btn_text = nil
    self.reward_red_pt = nil
    self.reward_text = nil
    self.rule = nil
    self.rule_text = nil
    self.donate_rank = nil
    self.hero_text = nil

    self.score_node = nil
    self.line1_desc = nil
    self.line1_left_val = nil
    self.line1_right_val = nil
    self.line2_desc = nil
    self.line2_left_val = nil
    self.line2_right_val = nil
    self.intro_desc_1 = nil
    self.intro_desc_2 = nil
    self.intro_desc_3 = nil

    
    self.no_enemy_state = nil
    self.ready1_desc = nil

    self.self_left = nil
    self.self_right = nil
    self.enemy_left = nil
    self.enemy_right = nil

    self.self_pos_node = nil
    self.self_pos_icon1 = nil
    self.self_pos_icon2 = nil
    self.self_pos_icon3 = nil
    self.enemy_pos_node = nil
    self.enemy_pos_icon1 = nil
    self.enemy_pos_icon2 = nil
    self.enemy_pos_icon3 = nil

    self.left_des_text = nil
    self.right_des_text = nil
    self.enemy_node = nil

end
local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PushALVSMatchSuccessReturn, self.OnMatchSuccess)
    self:AddUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnActivityInfoReturn)
    self:AddUIListener(EventId.PushALVSDonateArmyBattleStartReturn, self.OnStartBattleSuccess)
    self:AddUIListener(EventId.ALVSDonateArmyBattleInfoReturn, self.OnStartBattleInfoReturn)
    self:AddUIListener(EventId.ReceiveALVSDonateArmyStageReward, self.CheckRewardRedPt)
    self:AddUIListener(EventId.PushDonateArmyDefenceResult, self.OnAllianceCenterStateChange)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PushALVSMatchSuccessReturn, self.OnMatchSuccess)
    self:RemoveUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnActivityInfoReturn)
    self:RemoveUIListener(EventId.PushALVSDonateArmyBattleStartReturn, self.OnStartBattleSuccess)
    self:RemoveUIListener(EventId.ALVSDonateArmyBattleInfoReturn, self.OnStartBattleInfoReturn)
    self:RemoveUIListener(EventId.ReceiveALVSDonateArmyStageReward, self.CheckRewardRedPt)
    self:RemoveUIListener(EventId.PushDonateArmyDefenceResult, self.OnAllianceCenterStateChange)
    base.OnRemoveListener(self)
end

local function SetData(self,activityId,id)
    self.activityId = activityId
    self:RefreshState(true)
    self.introIdx = 1
    self:RefreshIntroNode()

    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData ~= nil then
        self.title:SetLocalText(activityData.name)
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.endTime)
        self.attack_act_time_text:SetText(startT .. "-" .. endT)
    end
end

--刷新匹配/进攻界面内部状态
local function RefreshState(self, sendRequest)
    ---战斗模块分为三种显示状态：
    --- 1.未加入联盟 显示加入联盟按钮

    self.left_des_text:SetActive(false)
    self.right_des_text:SetActive(false)

    if LuaEntry.Player:IsInAlliance() == false then
        self:ShowNoAllianceState()
    else
        local now = UITimeManager:GetInstance():GetServerTime()
        -- 准备期结束时间
        local prepareEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetPrepareEndTimeStamp()
        -- local donateEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetDonateEndTimeStamp()
        self.left_alliance_name2:SetActive(false)
        self.right_alliance_name2:SetActive(false)
        -- 展示自己联盟的名字 标志
        local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if allianceData then
            self.left_alliance_flag_empty:SetActive(false)
            self.left_alliance_name:SetText(UIUtil.GetAllianceWholeName(allianceData.ownerServerId, allianceData.abbr, allianceData.allianceName))
            self.left_alliance_name2:SetText(UIUtil.GetAllianceWholeName(allianceData.ownerServerId, allianceData.abbr, allianceData.allianceName))
            self.left_alliance_flag:SetData(allianceData.icon)
            self.left_alliance_flag:SetActive(true)
        end

        if now < prepareEndTime then -- timeCfg[3]是捐献期结束时间戳
            --- 2.已加入联盟 并且未处于进攻状态 此时显示匹配按钮 如已匹配 隐藏匹配按钮
            self:ShowPrepareState()
        else
            --- 3.已加入联盟 处于进攻阶段 此时显示战斗相关的组件
            local vsAlliance = DataCenter.ActivityALVSDonateSoldierManager:GetVsAllianceInfo()
            if vsAlliance == nil then
                -- 进攻阶段 如果此时仍没有对手 显示无对手界面
                self:ShowNoEnemy()
            else
                if sendRequest then
                    --发送请求获取战斗数据
                    DataCenter.ActivityALVSDonateSoldierManager:SendGetALVSDonateArmyBattleInfoMessage()
                else
                    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
                    --有战斗数据再刷界面
                    if battleData ~= nil then
                        self:ShowAttackState()
                    end
                end
            end
        end
    end

    -- 刷新完 执行一下定时器
    self:OnUpdate1000ms()
    self:CheckRewardRedPt()
    self:CheckShowAllianceIconStyle()
end

-- 点击匹配按钮
local function OnDeclareWarBtnClick(self)
    local warData = DataCenter.GloryManager:GetWarData()

    local now = UITimeManager:GetInstance():GetServerTime()
    local declareStartTime = DataCenter.ActivityALVSDonateSoldierManager:GetCanDelcareStartTimeStamp()

    if DataCenter.AllianceBaseDataManager:IsR4orR5() == false then
        --不是r4 r5
        UIUtil.ShowTipsId(308027)
        return
    end

    if now < declareStartTime then
        -- 没到可宣战时间
        UIUtil.ShowTipsId(308009)
        return
    end

    if warData and warData.seasonScore > 0 then
        -- 打开匹配界面
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIALVSBattleDeclare)
    else
        -- todo wsy 没有赛季积分
        
    end
end

-- 匹配推送
local function OnMatchSuccess(self)
    -- 如果在界面里面 并且收到了匹配推送 就发请求然后刷新界面
    DataCenter.ActivityALVSDonateSoldierManager:OnGetALVSDonateSoldierActivityInfo(false)
end

-- 活动信息返回
local function OnActivityInfoReturn(self)
    self:RefreshState(false)
end

-- 展示未加入联盟的状态
local function ShowNoAllianceState(self)
    self.no_alliance_state:SetActive(true)
    self.prepare_state:SetActive(false)
    self.attack_state:SetActive(false)
    self.no_enemy_state:SetActive(false)
    -- self.right_btn_list:SetActive(false)

    self.rule:SetActive(true)
    self.reward:SetActive(false)
    self.donate_rank:SetActive(false)

    self.hori:SetActive(false)

    -- 未加入联盟应该显示左右两边的联盟问号标志
    self.left_alliance_flag_empty:SetActive(true)
    self.right_alliance_flag_empty:SetActive(true)
    -- 隐藏联盟旗帜节点
    self.left_alliance_flag:SetActive(false)
    self.right_alliance_flag:SetActive(false)
    -- 联盟名字显示为???
    self.left_alliance_name:SetText("")
    self.right_alliance_name:SetText("")
    self.left_alliance_name2:SetText("")
    self.right_alliance_name2:SetText("")
    --联盟得分显示为???
    self.left_alliance_score:SetText("")
    self.right_alliance_score:SetText("")
    -- 展示中央说明部分
    self.center_pic_node:SetActive(true)
end

-- 展示匹配状态
local function ShowPrepareState(self)
    self.no_alliance_state:SetActive(false)
    self.prepare_state:SetActive(true)
    self.attack_state:SetActive(false)
    self.no_enemy_state:SetActive(false)
    -- self.right_btn_list:SetActive(false)
    self.rule:SetActive(true)
    self.reward:SetActive(false)
    self.donate_rank:SetActive(false)

    self.hori:SetActive(true)
    
    self.left_alliance_score:SetActive(false)
    self.right_alliance_score:SetActive(false)
    self.wait_start_text:SetActive(false)

    -- 如果已匹配 隐藏匹配按钮
    local vsAlliance = DataCenter.ActivityALVSDonateSoldierManager:GetVsAllianceInfo()
    if vsAlliance then
        self.right_alliance_name:SetText(UIUtil.GetAllianceWholeName(vsAlliance.serverId, vsAlliance.abbr, vsAlliance.name))
        self.right_alliance_flag:SetActive(true)
        self.right_alliance_flag:SetData(vsAlliance.icon)
        self.right_alliance_flag_empty:SetActive(false)
        self.declare_war_btn:SetActive(false)
        -- self.prepare_bottom_desc2:SetActive(false)
        -- self.declare_des_text:SetActive(false)
        self.wait_start_text:SetActive(true)
    else
        --未匹配 R4R5显示匹配按钮
        self.right_alliance_name:SetText("???")
        self.right_alliance_flag:SetActive(false)
        self.right_alliance_flag_empty:SetActive(true)
    end
  
    -- 展示中央说明部分
    self.center_pic_node:SetActive(true)
end

-- 展示战斗状态
local function ShowAttackState(self)
    self.no_alliance_state:SetActive(false)
    self.prepare_state:SetActive(false)
    self.attack_state:SetActive(true)
    self.no_enemy_state:SetActive(false)
    -- self.right_btn_list:SetActive(true)
    self.hori:SetActive(true)

    self.rule:SetActive(true)
    self.reward:SetActive(true)
    self.donate_rank:SetActive(true)

    -- 隐藏中央说明部分
    self.center_pic_node:SetActive(false)
    -- 联盟中心节点刷新
    self:CreateAllianceCenters()
    -- 进攻状态会R4R5有开启进攻按钮
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    --init active false
    self.begin_war_btn:SetActive(false)
    self.enemy_node:SetActive(true)
    self.begin_war_des_text:SetActive(false)
    self.left_win:SetActive(false)
    self.left_lose:SetActive(false)
    self.right_win:SetActive(false)
    self.right_lose:SetActive(false)
    self.score_node:SetActive(false)
    
    self.left_des_text:SetActive(true)
    self.right_des_text:SetActive(true)

    local selfAllianceInfo = nil
    local enemyAllianceInfo = nil
    for _, v in ipairs(battleData) do
        if v.allianceId == LuaEntry.Player.allianceId then
            selfAllianceInfo = v
        else
            enemyAllianceInfo = v
        end
    end

    local now = UITimeManager:GetInstance():GetServerTime()
    if selfAllianceInfo ~= nil then
        -- 己方联盟
        if selfAllianceInfo.state == 0 then
            -- 己方联盟未开启迎战
            -- r4 r5 显示开战按钮
            -- if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            -- end

            local autoDefeateTimeStamp = DataCenter.ActivityALVSDonateSoldierManager:GetAutoDefeateTimeStamp()
            if now > autoDefeateTimeStamp then 
                -- 在自动判负之前 可以看到宣战按钮
                -- 等待结算
                self.center_desc:SetLocalText(308043)
                -- 设置时间不显示
                self.time:SetActive(false)
                -- 隐藏宣战按钮
                self.begin_war_btn:SetActive(false)
                self.begin_war_des_text:SetActive(false)
                -- 并且把联盟城堡状态置为已失守 -- 是否为己方联盟true
                self:SetAllianceCenterAllFail(true)
                self:RefreshScorePanel()
            else
                self.enemy_node:SetActive(false)
                self.begin_war_btn:SetActive(true)
                self.begin_war_des_text:SetActive(true)
            end
   
        elseif selfAllianceInfo.state == 1 then
            --战斗中
            --第一次进入需要弹窗
            local state = Setting:GetString(LuaEntry.Player.uid .. "_" .."ALVS_BATTLE_STATE","")
            if state == "" then
                Setting:SetString(LuaEntry.Player.uid .. "_" .."ALVS_BATTLE_STATE","1")
                UIUtil.ShowMessage(Localization:GetString("308047"),1,GameDialogDefine.CONFIRM,nil,nil,nil,nil,100378)
            end
            self:RefreshScorePanel()
        elseif selfAllianceInfo.state == 2 then
            --结束等待结算
            self:RefreshScorePanel()
        elseif selfAllianceInfo.state == 3 then
            -- 左边胜利
            self.left_win:SetActive(true)
            self:RefreshScorePanel()
        elseif selfAllianceInfo.state == 4 then
            -- 左边失败
            self.left_lose:SetActive(true)
            self:RefreshScorePanel()
        elseif selfAllianceInfo.state == 5 then
            --平局 不显示胜利失败标志
            self:RefreshScorePanel()
        end

        self.left_alliance_name:SetActive(false)
        self.left_alliance_name2:SetActive(true)
        self.left_alliance_score:SetActive(true)
        self.left_alliance_score:SetText(tostring(selfAllianceInfo.score))
    end

    if enemyAllianceInfo ~= nil then
        -- 敌方联盟
        if enemyAllianceInfo.state == 0 then
            -- 敌方联盟未开启迎战
            local autoDefeateTimeStamp = DataCenter.ActivityALVSDonateSoldierManager:GetAutoDefeateTimeStamp()
            if now > autoDefeateTimeStamp then 
                -- 显示自动判负时间
                -- 敌方在规定时间内没宣战 则也判负 --是否为己方联盟false
                self:SetAllianceCenterAllFail(false)
            end
        elseif enemyAllianceInfo.state == 1 then
            --战斗中
    
        elseif enemyAllianceInfo.state == 2 then
            --结束等待结算
    
        elseif enemyAllianceInfo.state == 3 then
            -- 右边胜利
            self.right_win:SetActive(true)
        elseif enemyAllianceInfo.state == 4 then
            -- 右边失败
            self.right_lose:SetActive(true)
        elseif enemyAllianceInfo.state == 5 then
            --平局 不显示胜利失败标志
            
        end

        self.right_alliance_name:SetActive(false)
        self.right_alliance_name2:SetActive(true)
        self.right_alliance_score:SetActive(true)
        self.right_alliance_score:SetText(tostring(enemyAllianceInfo.score))
    end

    local vsAlliance = DataCenter.ActivityALVSDonateSoldierManager:GetVsAllianceInfo()
    if vsAlliance then
        self.right_alliance_name2:SetText(UIUtil.GetAllianceWholeName(vsAlliance.serverId, vsAlliance.abbr, vsAlliance.name))
        self.right_alliance_flag:SetActive(true)
        self.right_alliance_flag:SetData(vsAlliance.icon)
        self.right_alliance_flag_empty:SetActive(false)
        self.declare_war_btn:SetActive(false)
        -- self.prepare_bottom_desc2:SetActive(false)
        -- self.declare_des_text:SetActive(false)
        self.wait_start_text:SetActive(true)
    end
end

local function ShowNoEnemy(self)
    --除了无对手节点以外全部隐藏
    self.top_node:SetActive(false)
    self.no_alliance_state:SetActive(false)
    self.prepare_state:SetActive(false)
    self.attack_state:SetActive(false)
    self.no_enemy_state:SetActive(true)

    self.rule:SetActive(true)
    self.reward:SetActive(true)
    self.donate_rank:SetActive(false)

    -- self.right_btn_list:SetActive(false)
end

-- 每秒定时在UIActivityALVSMain中调用
local function OnUpdate1000ms(self)
    --最下方说明文字状态重置 只有需要及时的地方才会显示
    if self.attack_state:GetActive() then
        ---- 战斗阶段的节点处于打开状态 ----
        local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
        if battleData == nil then
            return
        end

        local selfAllianceInfo = nil
        local enemyAllianceInfo = nil
        for _, v in ipairs(battleData) do
            if v.allianceId == LuaEntry.Player.allianceId then
                selfAllianceInfo = v
            else
                enemyAllianceInfo = v
            end
        end

        if selfAllianceInfo == nil then
            return
        end
        local now = UITimeManager:GetInstance():GetServerTime()
        self.attack_bottom_desc:SetActive(false)
        if selfAllianceInfo.state == 0 then
            -- 未开启迎战
            local autoDefeateTimeStamp = DataCenter.ActivityALVSDonateSoldierManager:GetAutoDefeateTimeStamp()
            local autoDefeateDeltaTime = 0
            if now < autoDefeateTimeStamp then 
                -- 显示自动判负时间
                self.attack_bottom_desc:SetActive(true)
                autoDefeateDeltaTime = autoDefeateTimeStamp - now
            end
            -- 距离自动判负还有{0}
            self.attack_bottom_desc:SetLocalText(308016, UITimeManager:GetInstance():MilliSecondToFmtString(autoDefeateDeltaTime))

            if now > autoDefeateTimeStamp then
                -- 如果在未宣战的状态 已经到自动判负时间了 这里就不能再宣战了
                -- 等待结算
                self.center_desc:SetLocalText(308043)
                -- 设置时间不显示
                self.time:SetActive(false)
                -- 隐藏宣战按钮
                self.begin_war_btn:SetActive(false)
                self.begin_war_des_text:SetActive(false)
                -- 并且把联盟城堡状态置为已失守 -- 是否为己方联盟true
                self:SetAllianceCenterAllFail(true)
            else
                -- 显示到下个阶段的倒计时
                local nextStateDeltaTime = 0
                local prepareEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetAttackEndTimeStamp()
                if prepareEndTime - now > 0 then
                    nextStateDeltaTime = prepareEndTime - now
                end
                --战斗阶段
                self.center_desc:SetLocalText(308014)
                self.time:SetActive(true)
                self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nextStateDeltaTime))
            end
        elseif selfAllianceInfo.state == 1 or selfAllianceInfo.state == 2 then
            local lang = 0
            if selfAllianceInfo.state == 1 then
                -- 战斗中倒计时 显示战斗状态
                lang = 308014
            else
                --己方已打完战斗 敌人还没打完 并未分出胜负 显示等待结算
                lang = 308043
            end

            -- 显示到下个阶段的倒计时
            local nextStateDeltaTime = 0
            local prepareEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetAttackEndTimeStamp()
            if prepareEndTime - now > 0 then
                nextStateDeltaTime = prepareEndTime - now
            end
            --战斗阶段
            self.center_desc:SetLocalText(lang)
            self.time:SetActive(true)
            self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nextStateDeltaTime))
        else
            -- 显示 已结束
            self.center_desc:SetLocalText(302861)
            self.time:SetActive(false)
        end

        if enemyAllianceInfo and enemyAllianceInfo.state == 0 then
            local autoDefeateTimeStamp = DataCenter.ActivityALVSDonateSoldierManager:GetAutoDefeateTimeStamp()
            if now > autoDefeateTimeStamp then 
                -- 显示自动判负时间
                -- 敌方在规定时间内没宣战 则也判负 --是否为己方联盟false
                self:SetAllianceCenterAllFail(false)
            end
        end

        -- 刷新cell时间和状态
        self:AllianceBuildingOnUpdate()
    elseif self.prepare_state:GetActive() then
        ---- 准备阶段处于打开状态 ----

        -- 如果到了可以匹配的阶段 匹配倒计时就消失
        local now = UITimeManager:GetInstance():GetServerTime()
        --准备期结束时间戳
        local prepareEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetPrepareEndTimeStamp()
        -- 可宣战时间戳
        local canDeclareTime = DataCenter.ActivityALVSDonateSoldierManager:GetCanDelcareStartTimeStamp()

        local declareDeltaTime = 0
        self.prepare_bottom_desc:SetActive(false)
        if now < canDeclareTime then 
            -- 还没到宣战的时间
            self.prepare_bottom_desc:SetActive(true)
            declareDeltaTime = canDeclareTime - now
        end
        -- 距离可宣战还有{0}
        self.prepare_bottom_desc:SetLocalText(308008, UITimeManager:GetInstance():MilliSecondToFmtString(declareDeltaTime))

        -- 显示到下个阶段的倒计时
        local nextStateDeltaTime = 0
        if prepareEndTime - now > 0 then
            nextStateDeltaTime = prepareEndTime - now
        end
        -- 准备中：
        self.center_desc:SetLocalText(308012)
        self.time:SetActive(true)
        self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nextStateDeltaTime))

    elseif self.no_alliance_state:GetActive() then
        -- 无联盟状态打开
    elseif self.no_enemy_state:GetActive() then
        -- 无对手状态打开
    end
end

local function AllianceBuildingOnUpdate(self)
    for k = 1, 4 do
        local selfName = "self" .. tostring(k)
        local enemyName = "enemy" .. tostring(k)

        local selfBuildingComp = self[selfName]
        if  selfBuildingComp and selfBuildingComp:GetActive() then
            selfBuildingComp:OnUpdate1000ms()
        end
        
        local enemyBuildingComp = self[enemyName]
        if  enemyBuildingComp and enemyBuildingComp:GetActive() then
            enemyBuildingComp:OnUpdate1000ms()
        end
    end
end

local function CreateAllianceCenters(self)
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    for _,v in ipairs(battleData) do
        local isNextAttack = false
        local nodeName = ""
        if v.allianceId == LuaEntry.Player.allianceId then
            --己方联盟
            nodeName = "self"
        else
            nodeName = "enemy"
        end
        for k, v2 in ipairs(v.allianceBuildings) do
            local buildingName = nodeName .. tostring(k)
            local buildingComp = self[buildingName]
            if  buildingComp then
                buildingComp:SetActive(true)
                buildingComp:SetAllianceBuildingInfo(v2, k)

                if isNextAttack then
                    isNextAttack = false
                    buildingComp:SetIsNextAttackBuilding()
                end
            end

            if nodeName == "self" then
                if v2.state == 1 then
                    self.currSelfBuildIdx = k
                end
            else
                if v2.state == 1 then
                    self.currEnemyBuildIdx = k
                end
            end

            if v2.state == 1 then
                isNextAttack = true
            end
        end
    end
end

-- 手动设置联盟建筑防守失败状态 用于可宣战时间内没宣战的时候调用
-- 此时服务器状态不会置为失守 需要前端自己设置一下。
local function SetAllianceCenterAllFail(self, isSelfAlliance)
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    for _,v in ipairs(battleData) do
        local nodeName = ""
        if v.allianceId == LuaEntry.Player.allianceId and isSelfAlliance == true then
            --己方联盟
            nodeName = "self"
        elseif v.allianceId ~= LuaEntry.Player.allianceId and isSelfAlliance == false then
            nodeName = "enemy"
        end

        for k, v2 in ipairs(v.allianceBuildings) do
            local buildingName = nodeName .. tostring(k)
            local buildingComp = self[buildingName]
            if  buildingComp then
                buildingComp:SetAllianceBuildingFail()
            end
        end
    end
end

--R4 R5可点击的开启战斗阶段按钮
local function OnBeginBattleBtnClick(self)

    if DataCenter.AllianceBaseDataManager:IsR4orR5() == false then
        UIUtil.ShowTipsId(308018)
        return
    end
    
    -- if self:OnBeginBattleCheckAllianceBuilding() then
    --     --有联盟中心没造 弹提示
    --     UIUtil.ShowSecondMessage(
    --         Localization:GetString("308033"), --标题
    --         Localization:GetString("308019"), --您的联盟尚未放置所有的联盟中心，敌方远征军进攻未放置的联盟中心将会直接获胜，可能会损失大量积分，是否确定迎战？
    --         2, --按钮数量
    --         308033, --按钮文字1
    --         "", --按钮文字2
    --         function() --按钮1回调
    --             self:OnBeginBattleTip()
    --         end
    --     )
    -- else
    --     self:OnBeginBattleTip()
    -- end
    self:OnBeginBattleTip()
end

-- 检测是否提示 联盟中心未建造
local function OnBeginBattleCheckAllianceBuilding(self)
    local ret = false

    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    local allBuildingBuild = true
    for _, v in ipairs(battleData) do
        if v.allianceId == LuaEntry.Player.allianceId then
            
            for _, v2 in ipairs(v.allianceBuildings) do
                if v2.pointId == 0 then                
                    allBuildingBuild = false
                    break
                end
            end

            break
        end
    end

    if allBuildingBuild == false then
        ret = true
    end

    return ret
end

local function OnBeginBattleTip(self)
    local firstWaveTime = toInt(LuaEntry.DataConfig:TryGetStr("activity_donate_v2", "k10"))
    UIUtil.ShowSecondMessage(
        Localization:GetString("308033"), --标题
        Localization:GetString("308041", firstWaveTime), --迎战后，敌方远征军{0}分钟后将会从距离联盟中心I最近的遗迹内出发并向联盟中心I发起进攻。请确认您的联盟中心I已做好防守准备。
        2, --按钮数量
        308033, --按钮文字1
        "", --按钮文字2
        function() --按钮1回调
            self:OnConfirmStartBattle()
        end
    )
end

local function OnConfirmStartBattle(self)
    DataCenter.ActivityALVSDonateSoldierManager:SendALVSDonateArmyOpenAttackMessage()
end

--开始战斗推送
local function OnStartBattleSuccess(self)
    DataCenter.ActivityALVSDonateSoldierManager:SendGetALVSDonateArmyBattleInfoMessage()
end

--开始战斗请求返回
local function OnStartBattleInfoReturn(self)
    self:RefreshState(false)
end

local function CheckRewardRedPt(self)
    local canShowRedPtNum = DataCenter.ActivityALVSDonateSoldierManager:GetIsCurrRewardCanReceiveNum()
    if canShowRedPtNum > 0 then
        self.reward_red_pt:SetActive(true)
        self.reward_text:SetText(tostring(canShowRedPtNum))
    else
        self.reward_red_pt:SetActive(false)
    end
end

local function RefreshScorePanel(self)
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    self.score_node:SetActive(true)

    local leftWin = 0
    local leftWavesCount = 0
    local rightWin = 0
    local rightWavesCount = 0
    
    for _,v in ipairs(battleData) do
        local winCount = 0
        for _, v2 in ipairs(v.allianceBuildings) do
            if v2.state == 2 then
                winCount = winCount + 1
            end
        end
        if v.allianceId == LuaEntry.Player.allianceId then
            --己方联盟
            leftWin = winCount
            leftWavesCount = v.winRound
        else
            rightWin = winCount
            rightWavesCount = v.winRound
        end
    end

    self.line1_left_val:SetText(tostring(leftWin))
    self.line2_left_val:SetText(tostring(leftWavesCount))

    self.line1_right_val:SetText(tostring(rightWin))
    self.line2_right_val:SetText(tostring(rightWavesCount))
end

-- 切换图片说明按钮左
local function OnLeftBtnClick(self)
    if self.introIdx == 1 then
        self.introIdx = 3
    else
        self.introIdx = self.introIdx - 1
    end

    self:RefreshIntroNode()
end

-- 切换图片说明按钮右
local function OnRightBtnClick(self)
    if self.introIdx == 3 then
        self.introIdx = 1
    else
        self.introIdx = self.introIdx + 1
    end

    self:RefreshIntroNode()
end

local function RefreshIntroNode(self)
    self.intro_1:SetActive(false)
    self.intro_2:SetActive(false)
    self.intro_3:SetActive(false)
    local nodeName = "intro_" .. tostring(self.introIdx)
    local node = self[nodeName]
    if node ~= nil then
        node:SetActive(true)
    end
end

--点击加入联盟按钮
local function OnJoinAllianceBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
end

---------右侧按钮---------
-- 奖励按钮
local function OnRightRewardBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIALVSDonateSoldierReward,{ anim = true})
end

-- 规则按钮
local function OnRightRuleBtnClick(self)
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        UIUtil.ShowIntro(Localization:GetString(activityData.name), Localization:GetString("100239"), Localization:GetString(activityData.story))
    end
end

-- 捐献记录按钮
local function OnRightDonateRankBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIALVSDonateRank,{ anim = true})
end

local function OnAllianceCenterStateChange(self)
    self:CreateAllianceCenters()
    self:OnUpdate1000ms()
    self:CheckShowAllianceIconStyle()
end

local function OnScoreTipBtnClick(self)
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        UIUtil.ShowIntro(Localization:GetString(activityData.name), Localization:GetString("302027"), Localization:GetString("308025"))
    end
end

-- 检测显示联盟中心的形式。
-- 如果在结束状态 则显示全部联盟中心。
-- 如果在其他状态 显示被攻击的联盟中心
-- 如果没有被攻击的联盟中心 默认显示第一个。
local function CheckShowAllianceIconStyle(self)
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    local isInEndState = false
    for _, v in ipairs(battleData) do
        if v.state >= 3 then
            isInEndState = true
        end
    end
    
    if isInEndState then
        -- 已处于胜利/失败/平局状态
        -- 显示所有的联盟中心

        for _, v in ipairs(battleData) do
            local nodeName = ""
            if v.allianceId == LuaEntry.Player.allianceId then
                --己方联盟
                nodeName = "self"
            elseif v.allianceId ~= LuaEntry.Player.allianceId then
                nodeName = "enemy"
            end
    
            for k, v2 in ipairs(v.allianceBuildings) do
                local buildingName = nodeName .. tostring(k)
                local buildingComp = self[buildingName]
                if  buildingComp then
                    buildingComp:SetActive(true)
                    buildingComp:SetBattleIsFinished(true)
                end
            end
        end

        self.self_left:SetActive(false)
        self.self_right:SetActive(false)
        self.enemy_left:SetActive(false)
        self.enemy_right:SetActive(false)
        self.self_pos_node:SetActive(false)
        self.enemy_pos_node:SetActive(false)
    else
        -- 显示当前应该显示的联盟中心
        self:ShowTargetAllianceCenter(true)
        self:ShowTargetAllianceCenter(false)

        self.self_left:SetActive(true)
        self.self_right:SetActive(true)
        self.enemy_left:SetActive(true)
        self.enemy_right:SetActive(true)
        self.self_pos_node:SetActive(true)
        self.enemy_pos_node:SetActive(true)
    end
end

local function OnSelfLeftBtnClick(self)
    if self.currSelfBuildIdx == 1 then
        self.currSelfBuildIdx = 3
    else
        self.currSelfBuildIdx = self.currSelfBuildIdx - 1
    end

    self:ShowTargetAllianceCenter(true)
end

local function OnSelfRightBtnClick(self)
    if self.currSelfBuildIdx == 3 then
        self.currSelfBuildIdx = 1
    else
        self.currSelfBuildIdx = self.currSelfBuildIdx + 1
    end

    self:ShowTargetAllianceCenter(true)
end

local function OnEnemyLeftBtnClick(self)
    if self.currEnemyBuildIdx == 1 then
        self.currEnemyBuildIdx = 3
    else
        self.currEnemyBuildIdx = self.currEnemyBuildIdx - 1
    end

    self:ShowTargetAllianceCenter(false)
end

local function OnEnemyRightBtnClick(self)
    if self.currEnemyBuildIdx == 3 then
        self.currEnemyBuildIdx = 1
    else
        self.currEnemyBuildIdx = self.currEnemyBuildIdx + 1
    end

    self:ShowTargetAllianceCenter(false)
end

local function ShowTargetAllianceCenter(self, selfAlliance)

    local battleData = DataCenter.ActivityALVSDonateSoldierManager:GetBattleArrlianceArr()
    if battleData == nil then
        return
    end

    for _, v in ipairs(battleData) do
        -- 已处于胜利/失败/平局状态
        -- 显示所有的联盟中心
        local nodeName = ""
        local iconNodeName = ""
        local showIdx = 1
        if v.allianceId == LuaEntry.Player.allianceId and selfAlliance then
            --己方联盟
            nodeName = "self"
            iconNodeName = "self_pos_icon"
            showIdx = self.currSelfBuildIdx
        elseif v.allianceId ~= LuaEntry.Player.allianceId and not selfAlliance then
            nodeName = "enemy"
            iconNodeName = "enemy_pos_icon"
            showIdx = self.currEnemyBuildIdx
        end

        if nodeName ~= "" then
            for k, v2 in ipairs(v.allianceBuildings) do
                local buildingName = nodeName .. tostring(k)
                local buildingComp = self[buildingName]
                if  buildingComp then
                    buildingComp:SetActive(showIdx == k)
                end

                local posIconName = iconNodeName .. tostring(k)
                local posComp = self[posIconName]
                if posComp then
                    posComp:SetActive(showIdx == k)
                end
            end
        end
        
    end
end

UIActivityALVSBattle.OnCreate = OnCreate
UIActivityALVSBattle.OnDestroy = OnDestroy
UIActivityALVSBattle.ComponentDefine = ComponentDefine
UIActivityALVSBattle.ComponentDestroy = ComponentDestroy
UIActivityALVSBattle.OnEnable = OnEnable
UIActivityALVSBattle.OnDisable = OnDisable
UIActivityALVSBattle.OnAddListener = OnAddListener
UIActivityALVSBattle.OnRemoveListener = OnRemoveListener
UIActivityALVSBattle.SetData = SetData
UIActivityALVSBattle.RefreshState = RefreshState
UIActivityALVSBattle.ShowNoAllianceState = ShowNoAllianceState
UIActivityALVSBattle.ShowPrepareState = ShowPrepareState
UIActivityALVSBattle.ShowAttackState = ShowAttackState
UIActivityALVSBattle.OnUpdate1000ms = OnUpdate1000ms
UIActivityALVSBattle.OnMatchSuccess = OnMatchSuccess
UIActivityALVSBattle.OnDeclareWarBtnClick = OnDeclareWarBtnClick
UIActivityALVSBattle.OnActivityInfoReturn = OnActivityInfoReturn
UIActivityALVSBattle.CreateAllianceCenters = CreateAllianceCenters
UIActivityALVSBattle.OnBeginBattleBtnClick = OnBeginBattleBtnClick
UIActivityALVSBattle.OnStartBattleSuccess = OnStartBattleSuccess
UIActivityALVSBattle.OnStartBattleInfoReturn = OnStartBattleInfoReturn
UIActivityALVSBattle.CheckRewardRedPt = CheckRewardRedPt
UIActivityALVSBattle.OnLeftBtnClick = OnLeftBtnClick
UIActivityALVSBattle.OnRightBtnClick = OnRightBtnClick
UIActivityALVSBattle.RefreshIntroNode = RefreshIntroNode
UIActivityALVSBattle.OnJoinAllianceBtnClick = OnJoinAllianceBtnClick
UIActivityALVSBattle.AllianceBuildingOnUpdate = AllianceBuildingOnUpdate
UIActivityALVSBattle.OnRightRewardBtnClick = OnRightRewardBtnClick
UIActivityALVSBattle.OnRightRuleBtnClick = OnRightRuleBtnClick
UIActivityALVSBattle.OnRightDonateRankBtnClick = OnRightDonateRankBtnClick
UIActivityALVSBattle.RefreshScorePanel = RefreshScorePanel
UIActivityALVSBattle.ShowNoEnemy = ShowNoEnemy
UIActivityALVSBattle.OnBeginBattleCheckAllianceBuilding = OnBeginBattleCheckAllianceBuilding
UIActivityALVSBattle.OnBeginBattleTip = OnBeginBattleTip
UIActivityALVSBattle.OnConfirmStartBattle = OnConfirmStartBattle
UIActivityALVSBattle.OnAllianceCenterStateChange = OnAllianceCenterStateChange
UIActivityALVSBattle.OnScoreTipBtnClick = OnScoreTipBtnClick
UIActivityALVSBattle.SetAllianceCenterAllFail = SetAllianceCenterAllFail
UIActivityALVSBattle.CheckShowAllianceIconStyle = CheckShowAllianceIconStyle
UIActivityALVSBattle.OnSelfLeftBtnClick = OnSelfLeftBtnClick
UIActivityALVSBattle.OnSelfRightBtnClick = OnSelfRightBtnClick
UIActivityALVSBattle.OnEnemyLeftBtnClick = OnEnemyLeftBtnClick
UIActivityALVSBattle.OnEnemyRightBtnClick = OnEnemyRightBtnClick
UIActivityALVSBattle.ShowTargetAllianceCenter = ShowTargetAllianceCenter

return UIActivityALVSBattle