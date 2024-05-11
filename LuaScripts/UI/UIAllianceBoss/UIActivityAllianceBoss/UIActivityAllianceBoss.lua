local UIActivityAllianceBoss = BaseClass("UIActivityAllianceBoss", UIBaseView)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local txt_act_name_path = "RightView/Txt_ActName"
local txt_act_desc_path = "RightView/Txt_ActDesc"
local txt_act_end_time_path = "RightView/ActTime/remainTime"
local txt_act_date_path = "RightView/Txt_ActDate"

local rule_btn_path = "RightView/infoBtn"
local reward_btn_path = "RightView/RightBtnList/RewardBtn"
local reward_text_path = "RightView/RightBtnList/RewardBtn/RewardText"
local record_btn_path = "RightView/RightBtnList/RecordBtn"
local record_btn_text_path = "RightView/RightBtnList/RecordBtn/RecordBtnText"
local ranklist_btn_path = "RightView/RightBtnList/RanklistBtn"
local ranklist_btn_text_path = "RightView/RightBtnList/RanklistBtn/RanklistBtnText"
local bottom_btn_path = "RightView/BottomBtn"
local bottom_btn_text_path = "RightView/BottomBtn/BottomBtnText"
local bottom_donate_node_path = "RightView/Bottom/BottomDonateNode"
local donate_progress_slider_path = "RightView/Bottom/BottomDonateNode/DonateProgressSlider"
local donate_txt_progress_path = "RightView/Bottom/BottomDonateNode/DonateProgressSlider/DonateTxt_Progress"
local boss_level_label_path = "RightView/Bottom/BottomDonateNode/BossLevelLabel"
local boss_des_label_path = "RightView/BossDesLabel"
local bottom_attack_node_path = "RightView/Bottom/BottomAttackNode"
local attack_progress_slider_path = "RightView/Bottom/BottomAttackNode/AttackProgressSlider"
local attack_txt_progress_path = "RightView/Bottom/BottomAttackNode/AttackProgressSlider/AttackTxt_Progress"
local boss_damage_label_path = "RightView/Bottom/BottomAttackNode/BossDamageLabel"
local boss_item_num_label_path = "RightView/Bottom/BottomAttackNode/BossItemNumLabel"
local attack_reward_btn_path = "RightView/Bottom/BottomAttackNode/AttackRewardNode/AttackRewardBtn"
local attack_box_reward_count_label_path = "RightView/Bottom/BottomAttackNode/AttackRewardNode/AttackBoxRewardCountLabel"
local attack_box_multiple_label_path = "RightView/Bottom/BottomAttackNode/AttackRewardNode/AttackBoxMultipleLabel"
local multiple_node_path = "RightView/MultipleNode"
local multiple_label_path = "RightView/MultipleNode/MultipleLabel"
local multiple_number_label_path = "RightView/MultipleNode/MultipleNumberLabel"
local multiple_bg_click_btn_path = "RightView/MultipleNode/multipleBgClickBtn"
local small_multiple_bg_path = "RightView/Bottom/BottomAttackNode/AttackRewardNode/smallMultipleBg"
local multiple_bg_path = "RightView/MultipleNode/multipleBg"
local gold_num_path = "RightView/Bottom/BottomAttackNode/goldObj/goldNum"

local boss_name_node_path = "RightView/Bottom/BossNameNode"
local boss_name_text_path = "RightView/Bottom/BossNameNode/BossNameText"
local boss_level_text_path = "RightView/Bottom/BossNameNode/BossLevelText"
local free_package_btn_path = "RightView/freePackageBtn"
local free_txt_path = "RightView/freePackageBtn/freeTxt"

local donate_txt_path = "RightView/Bottom/Txt_Donate"
local donateTips_btn_path = "RightView/Bottom/Txt_Donate/Btn_DonateTips"

local ViewStateEnum = {
    NoneState = -1, --刚进界面的无状态
    NoAllianceState = 0, -- 无联盟状态
    DonateState = 1, --捐献阶段
    PrepareState = 2, --准备阶段 捐献完毕但是盟主还没开启进攻
    AttackState = 3, --进攻阶段
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()


end

local function OnDestroy(self)
    self:ComponentDestroy()

    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)

    self.timer_action = function(temp)
        self:Update1000ms()
    end

    self.dataReturn = false
    self:AddTimer()
    
    self.update_action = function()
        self:OnUpdate()
    end
    self.isScheduleOn = false
end

local function OnDisable(self)

    self.timer_action = nil
    self:DeleteTimer()
    
    if self.isScheduleOn then
        UpdateManager:GetInstance():RemoveUpdate(self.update_action)
        self.isScheduleOn = false
    end

    base.OnDisable(self)
end

local function ComponentDefine(self)

    self.txt_act_name = self:AddComponent(UITextMeshProUGUIEx, txt_act_name_path)
    self.txt_act_desc = self:AddComponent(UITextMeshProUGUIEx, txt_act_desc_path)
    self.txt_act_date = self:AddComponent(UITextMeshProUGUIEx, txt_act_date_path)
    self.txt_act_end_time = self:AddComponent(UITextMeshProUGUIEx, txt_act_end_time_path)
    
    self.rule_btn = self:AddComponent(UIButton, rule_btn_path)
    self.rule_btn:SetOnClick(function() 
        --点击左上角的规则说明
        local activityData = DataCenter.AllianceBossManager:GetActivityData(self.activityId)
        if(activityData ~= nil) then
            UIUtil.ShowIntro(Localization:GetString(activityData.name), Localization:GetString("302027"), Localization:GetString(activityData.story))
        end
    end)

    -- 查看捐献奖励列表按钮
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
    self.reward_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossDamageReward,{ anim = true, isBlur = true})
    end)
    self.reward_text = self:AddComponent(UITextMeshProUGUIEx, reward_text_path)
    self.reward_text:SetLocalText(373004) -- 捐献奖励预览

    -- 捐献排行榜按钮
    self.record_btn = self:AddComponent(UIButton, record_btn_path)
    self.record_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossDonateRank,{ anim = true, isBlur = true})
    end)
    self.record_btn_text = self:AddComponent(UITextMeshProUGUIEx, record_btn_text_path)
    self.record_btn_text:SetLocalText(373008) -- 捐献排行榜

    -- 战斗排行按钮
    self.ranklist_btn = self:AddComponent(UIButton, ranklist_btn_path)
    self.ranklist_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossDamageRank,{ anim = true, isBlur = true})
    end)
    self.ranklist_btn_text = self:AddComponent(UITextMeshProUGUIEx, ranklist_btn_text_path)
    self.ranklist_btn_text:SetLocalText(390040) -- 伤害排行榜

    self.bottom_btn = self:AddComponent(UIButton, bottom_btn_path)
    self.bottom_btn:SetOnClick(function()
        self:OnBottomBtnClick()
    end)

    self.bottom_btn_text = self:AddComponent(UITextMeshProUGUIEx, bottom_btn_text_path)

    self.bottom_donate_node = self:AddComponent(UIBaseContainer, bottom_donate_node_path)
    self.donate_progress_slider = self:AddComponent(UISlider, donate_progress_slider_path)
    self.donate_txt_progress = self:AddComponent(UITextMeshProUGUIEx, donate_txt_progress_path)

    self.boss_level_label = self:AddComponent(UITextMeshProUGUIEx, boss_level_label_path)
    self.boss_des_label = self:AddComponent(UITextMeshProUGUIEx, boss_des_label_path)
    
    --进攻进度条节点
    self.bottom_attack_node = self:AddComponent(UIBaseContainer, bottom_attack_node_path)
    self.attack_progress_slider = self:AddComponent(UISlider, attack_progress_slider_path)
    self.attack_txt_progress = self:AddComponent(UITextMeshProUGUIEx, attack_txt_progress_path)
    self.boss_damage_label = self:AddComponent(UITextMeshProUGUIEx, boss_damage_label_path)
    self.boss_damage_label:SetLocalText(373015)
    self.boss_item_num_label = self:AddComponent(UITextMeshProUGUIEx, boss_item_num_label_path)
    
    --攻击进度条旁边的宝箱点击按钮
    self.attack_reward_btn = self:AddComponent(UIButton, attack_reward_btn_path)
    self.attack_reward_btn:SetOnClick(function()
        self:OnAttackRewardShowBtnClick()
    end)
    -- 当前伤害奖励倍数
    self.attack_box_reward_count_label = self:AddComponent(UITextMeshProUGUIEx, attack_box_reward_count_label_path)
    -- 当前捐献奖励倍数
    self.attack_box_multiple_label = self:AddComponent(UITextMeshProUGUIEx, attack_box_multiple_label_path)
    self.attack_box_multiple_label:SetLocalText(373004)
    -- 捐献倍数节点
    self.multiple_node = self:AddComponent(UIBaseContainer, multiple_node_path)
    self.multiple_label = self:AddComponent(UITextMeshProUGUIEx, multiple_label_path)
    self.multiple_label:SetLocalText(373004)
    self.multiple_number_label = self:AddComponent(UITextMeshProUGUIEx, multiple_number_label_path)
    self.multiple_bg_click_btn = self:AddComponent(UIButton, multiple_bg_click_btn_path)
    self.multiple_bg_click_btn:SetOnClick(function() 
        self:OnMultipleBgBtnClick()
    end)

    -- boss名字节点
    self.boss_name_node = self:AddComponent(UIBaseContainer, boss_name_node_path)
    self.boss_name_text = self:AddComponent(UITextMeshProUGUIEx, boss_name_text_path)
    self.boss_name_text:SetLocalText(155064)
    self.boss_level_text = self:AddComponent(UITextMeshProUGUIEx, boss_level_text_path)

    -- 免费奖励
    --self.freePackageBtnAnimN = self:AddComponent(UIAnimator, free_package_btn_path)
    self.free_package_btn = self:AddComponent(UIButton, free_package_btn_path)
    self.free_package_btn:SetOnClick(function()
        --领取免费奖励
        DataCenter.AllianceBossManager:OnSendReceiveAllianceBossFreeRewardMessage()
    end)

    self.free_txt = self:AddComponent(UITextMeshProUGUIEx, free_txt_path)
    self.free_txt:SetLocalText(373014)

    self.small_multiple_bg = self:AddComponent(UIImage, small_multiple_bg_path)
    self.multiple_bg = self:AddComponent(UIImage, multiple_bg_path)
    self.gold_num = self:AddComponent(UITextMeshProUGUIEx, gold_num_path)

    self.donate_txt = self:AddComponent(UITextMeshProUGUIEx,donate_txt_path)
    self.donate_txt:SetLocalText(373053)
    self.donateTips_btn = self:AddComponent(UIButton,donateTips_btn_path)
    self.donateTips_btn:SetOnClick(function()
        self:OnClickDonateTips()
    end)
end

local function ComponentDestroy(self)

    self.txt_act_name = nil
    self.txt_act_desc = nil
    self.txt_act_end_time = nil

    self.rule_btn = nil
    self.reward_btn = nil
    self.reward_text = nil
    self.record_btn = nil
    self.record_btn_text = nil
    self.ranklist_btn = nil
    self.ranklist_btn_text = nil
    self.bottom_btn = nil
    self.bottom_btn_text = nil
    self.bottom_donate_node = nil
    self.donate_progress_slider = nil
    self.donate_txt_progress = nil
    self.boss_level_label = nil
    self.boss_des_label = nil
    self.bottom_attack_node = nil
    self.attack_progress_slider = nil
    self.attack_txt_progress = nil
    self.boss_damage_label = nil
    self.attack_reward_btn = nil
    self.attack_box_reward_count_label = nil
    self.attack_box_multiple_label = nil
    self.boss_item_num_label = nil
    self.multiple_node = nil
    self.multiple_label = nil
    self.multiple_number_label = nil
    self.multiple_bg_click_btn = nil
    self.boss_name_node = nil
    self.boss_name_text = nil
    self.boss_level_text = nil
    self.free_package_btn = nil
    self.freePackageBtnAnimN = nil
    self.free_txt = nil
    self.update_action = nil
    self.small_multiple_bg = nil
    self.multiple_bg = nil
    self.gold_num = nil

end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetAllianceBossActivityInfo, self.OnAllianceBossDataReturn)
    self:AddUIListener(EventId.CallAllianceBoss, self.OnSummonBossReturn)
    self:AddUIListener(EventId.ReceiveAllianceBossFreeReward, self.OnFreeRewardReceived)
    self:AddUIListener(EventId.AllianceBossDonate, self.OnRefreshDonateProgress)
    self:AddUIListener(EventId.PushAllianceBossDamageUpdate, self.OnPushDamageChange)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetAllianceBossActivityInfo, self.OnAllianceBossDataReturn)
    self:RemoveUIListener(EventId.CallAllianceBoss, self.OnSummonBossReturn)
    self:RemoveUIListener(EventId.ReceiveAllianceBossFreeReward, self.OnFreeRewardReceived)
    self:RemoveUIListener(EventId.AllianceBossDonate, self.OnRefreshDonateProgress)
    self:RemoveUIListener(EventId.PushAllianceBossDamageUpdate, self.OnPushDamageChange)
    
    base.OnRemoveListener(self)
end

local function SetData(self, activityId, actId)
    self.curr_view_state = ViewStateEnum.NoneState
    self.activityId = activityId
    self:ShowNoneState()

    DataCenter.AllianceBossManager:OnSendGetAllianceBossActivityInfoMessage()

    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if(activityData ~= nil) then
        self.txt_act_name:SetLocalText(activityData.name)
        self.txt_act_desc:SetLocalText(activityData.desc_info)
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.endTime - 1000)
        self.txt_act_date:SetText(startT .. "-" .. endT)
    end
    
    local attackItemId = LuaEntry.DataConfig:TryGetNum("alliance_boss", "k1")
    local itemCount = DataCenter.ItemData:GetItemCount(attackItemId)
    self.boss_item_num_label:SetLocalText(373031) --剩余攻击次数 {}
    self.gold_num:SetText(tostring(itemCount))
end

local function OnAllianceBossDataReturn(self)
    self.dataReturn = true
    self:OnRefreshDonateProgress()
    self:OnRefreshAttackProgress(false)
    self:Update1000ms()

    local bigIconPath = self:GetIconPathByBossLevel(true)
    self.multiple_bg:LoadSprite(bigIconPath)
    local smallIconPath = self:GetIconPathByBossLevel(false)
    self.small_multiple_bg:LoadSprite(smallIconPath)
    
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo ~= nil then
        self.attack_box_multiple_label:SetText("x" .. tostring(bossInfo.lv))
    end
end


local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end

    self.timer:Start()
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

-- 按秒刷新倒计时
local function Update1000ms(self)
    -- 刷新界面状态
    self:CheckAndShowCurrState()

    -- 活动结束时间

    if self.curr_view_state == ViewStateEnum.DonateState then
        --在捐献期间显示捐献结束倒计时
        local donateEndTime = DataCenter.AllianceBossManager:GetDonateStageEndTime()
        local now = UITimeManager:GetInstance():GetServerTime()
        local delta = math.max(0, donateEndTime - now)
        self.txt_act_end_time:SetLocalText(373022, UITimeManager:GetInstance():MilliSecondToFmtString(delta))
    else
        self.donate_txt:SetActive(false)
        --在第二阶段显示活动结束倒计时
        local endtime = DataCenter.AllianceBossManager:GetActivityEndTime()
        local now = UITimeManager:GetInstance():GetServerTime()
        local delta = math.max(0, endtime - now)
        self.txt_act_end_time:SetLocalText(373021, UITimeManager:GetInstance():MilliSecondToFmtString(delta))
    end
end

-- 按帧倒计时
local function OnUpdate(self)

    if not self.curLv then
       return 
    end
    if self.targetLv > self.curLv then
        -- 要到下一级 按固定速度增长
        local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
        local curLvMaxDamage = damageLevelInfo[self.curLv].damage
        local increasePerFrame = curLvMaxDamage / 10 -- 

        --当前帧要移动到的经验值
        local curFrameDamage = self.curDamage + increasePerFrame
        if curFrameDamage >= curLvMaxDamage then
            -- 判断是否达到了最大等级
            local isMaxLv = damageLevelInfo[self.curLv] == nil
            if isMaxLv then
                curFrameDamage = curLvMaxDamage
                self.curDamage = curLvMaxDamage
            else
                curFrameDamage = curLvMaxDamage
                self.curLv = self.curLv + 1
                self.curDamage = 0
                --self.attack_box_multiple_label:SetText("x" .. tostring(self.curLv))
            end
        else
            self.curDamage = curFrameDamage
        end

        local progressBarPercent = curFrameDamage / curLvMaxDamage
        self.attack_progress_slider:SetValue(progressBarPercent)
        self.attack_txt_progress:SetText(tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage)))
    else
        -- 已经在目标等级 判断目标经验是否更高
        if self.targetDamage > self.curDamage then
            -- 插值
            local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
            local delta = self.targetDamage - self.curDamage
            local lerpValue = delta / 10
            if lerpValue < 1 then
                lerpValue = 1
            end

            local curLvMaxDamage = damageLevelInfo[self.curLv].damage
            local curFrameDamage = self.curDamage + lerpValue
            if curFrameDamage > self.targetDamage then
                curFrameDamage = self.targetDamage
            end

            --if curFrameDamage > curLvMaxDamage then
            --    curFrameDamage = curLvMaxDamage
            --end

            local progressBarPercent = curFrameDamage / curLvMaxDamage
            self.attack_progress_slider:SetValue(progressBarPercent)
            self.curDamage = curFrameDamage
            self.attack_txt_progress:SetText(tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage)))
        else
            -- 已经到了目标伤害值 停止按帧计时
            UpdateManager:GetInstance():RemoveUpdate(self.update_action)
            self.isScheduleOn = false
        end
    end
end

--点击底部按钮
local function OnBottomBtnClick(self)
    if self.curr_view_state == ViewStateEnum.NoAllianceState then
        self:OnJoinAllianceBtnClick()
    elseif self.curr_view_state == ViewStateEnum.DonateState then
        self:OnDonateBtnClick()
    elseif self.curr_view_state == ViewStateEnum.PrepareState then
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            -- 如果是r4r5 展示开战按钮
            self:OnSummonBtnClick()
        else
            UIUtil.ShowTipsId(308027) --只有R4 R5可宣战
        end
    elseif self.curr_view_state == ViewStateEnum.AttackState then
        self:OnAttackBtnClick()
    end
end

-- 未加入联盟的玩家进入界面会看到加入联盟的按钮
local function OnJoinAllianceBtnClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
end

--捐献按钮
local function OnDonateBtnClick(self)
    if self.curr_view_state == ViewStateEnum.DonateState then
        --打开捐献界面
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossDonateResource,{ anim = true, isBlur = true})
    end
end

--r4 r5开启进攻阶段的按钮
local function OnSummonBtnClick(self)
    -- 发送请求召唤联盟boss
    DataCenter.AllianceBossManager:OnSendCallAllianceBossMessage()
end

-- r4 r5召唤完boss的回调
local function OnSummonBossReturn(self)
    -- 召唤完boss 要刷新界面
    DataCenter.AllianceBossManager:OnSendGetAllianceBossActivityInfoMessage()
    UIUtil.ShowTipsId(373019)
end

--攻击按钮
local function OnAttackBtnClick(self)
    -- 点击跳转到对应联盟boss的位置
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo ~= nil and bossInfo.pointId ~= nil then
        GoToUtil.CloseAllWindows()
        local worldPos = SceneUtils.TileIndexToWorld(bossInfo.pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom)
    end
end

--攻击奖励预览
local function OnAttackRewardShowBtnClick(self)
    -- 判断当前能不能获得奖励 如果没有奖励就弹提示
    if self.curLv == nil or self.curLv == 0 then
        UIUtil.ShowTipsId(373016)
    else
        local txt = self.attack_box_multiple_label:GetText()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossRewardShow,{anim = true, isBlur = true},txt)
    end
end

-- 检测当前是那种状态
local function CheckAndShowCurrState(self)
    -- 没有加入联盟的时候 无论那个阶段都只显示加入俩能耐
    if LuaEntry.Player:IsInAlliance() == false then
        self:ShowNoAllianceState()
    else
        if self.dataReturn == false then
            return
        end

        local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
        if bossInfo == nil then
            -- 依赖于boss数据 如果没有boss数据就不显示以下阶段
            self:ShowNoneState()
            return
        end
        --如果有联盟 判断目前是哪个阶段
        local now = UITimeManager:GetInstance():GetServerTime()
        --捐献阶段结束时间 结束后进入准备或进攻阶段
        local donateEndTime = DataCenter.AllianceBossManager:GetDonateStageEndTime()
        if now < donateEndTime then
            --捐献阶段
            self:ShowDonateState()
        else
            --进攻阶段 如果联盟盟主没有开战 则为准备阶段 如果开战 则为进攻阶段
            if bossInfo.pointId ~= nil and bossInfo.pointId > 0 then
                --有坐标 已开战
                self:ShowAttackState()
            else
                --无坐标 还未开战
                self:ShowPrepareState()
            end
        end
    end
end

-- 展示默认状态 啥也没有
local function ShowNoneState(self)
    
    self.bottom_attack_node:SetActive(false)
    self.boss_des_label:SetActive(false)
    self.boss_name_node:SetActive(false)
    self.bottom_donate_node:SetActive(false)
    self.multiple_node:SetActive(false)
    self.bottom_btn:SetActive(false)
    self.boss_des_label:SetActive(false)
    self.ranklist_btn:SetActive(false)
    self.free_package_btn:SetActive(false)
    self.donate_txt:SetActive(false)
end

-- 展示无联盟状态
local function ShowNoAllianceState(self)
    if self.curr_view_state ~= ViewStateEnum.NoAllianceState then
        --切换到捐献阶段
        self.bottom_attack_node:SetActive(false)
        self.boss_des_label:SetActive(false)
        self.boss_name_node:SetActive(false)
        self.bottom_donate_node:SetActive(false)
        self.multiple_node:SetActive(false)
        self.ranklist_btn:SetActive(false)
        
        --无联盟状态只有一个加入联盟按钮
        self.bottom_btn:SetActive(true)
        self.bottom_btn_text:SetLocalText(390079) --加入联盟
        self.free_package_btn:SetActive(false)

        self.curr_view_state = ViewStateEnum.NoAllianceState
    end
end

-- 展示捐献阶段
local function ShowDonateState(self)
    if self.curr_view_state ~= ViewStateEnum.DonateState then
        --切换到捐献阶段
        self.bottom_attack_node:SetActive(false)
        self.boss_des_label:SetActive(false)
        self.boss_name_node:SetActive(false)
        self.ranklist_btn:SetActive(false)

        self.bottom_btn:SetActive(true)
        self.bottom_btn_text:SetLocalText(373009) --捐献
        self.bottom_donate_node:SetActive(true)
        self.multiple_node:SetActive(true)
        self.free_package_btn:SetActive(false)
        
        self.donate_txt:SetActive(true)

        self.curr_view_state = ViewStateEnum.DonateState
    end

end

-- 展示准备阶段
local function ShowPrepareState(self)
    if self.curr_view_state ~= ViewStateEnum.PrepareState then
        --切换到准备阶段
        self.bottom_attack_node:SetActive(false)
        self.boss_name_node:SetActive(true)

        local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
        if bossInfo ~= nil then
            self.boss_level_text:SetLocalText(300665, tostring(bossInfo.lv))
        end

        self.bottom_donate_node:SetActive(false)
        self.multiple_node:SetActive(true)
        -- 准备阶段显示伤害排行榜按钮
        self.ranklist_btn:SetActive(true)

        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            -- 如果是r4r5 展示开战按钮
            self.bottom_btn:SetActive(true)
            self.bottom_btn_text:SetLocalText(373017) --开战
            self.boss_des_label:SetActive(false)
        else
            -- 如果是普通成员 展示等待开战多语言
            self.boss_des_label:SetActive(true)
            self.bottom_btn:SetActive(false)
            self.boss_des_label:SetLocalText(373018) -- 等待盟主开启
        end
        
        self.curr_view_state = ViewStateEnum.PrepareState
    end

    -- 如果没有领取每日奖励 就显示
    if DataCenter.AllianceBossManager:GetIsFreeRewardCanReceive() then
        self.free_package_btn:SetActive(true)
        --self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    else
        self.free_package_btn:SetActive(false)
    end
end

-- 展示进攻阶段
local function ShowAttackState(self)
    if self.curr_view_state ~= ViewStateEnum.AttackState then
        --切换到进攻状态
        self.bottom_attack_node:SetActive(true)
        self.boss_name_node:SetActive(false)
        self.bottom_donate_node:SetActive(false)
        self.multiple_node:SetActive(false)
        self.bottom_btn:SetActive(true)
        self.bottom_btn_text:SetLocalText(100150) --攻击
        self.boss_des_label:SetActive(false)
        -- 进攻阶段显示伤害排行榜按钮
        self.ranklist_btn:SetActive(true)
        self.curr_view_state = ViewStateEnum.AttackState
    end

    --进攻阶段 如果有免费奖励 就显示领取按钮
    if DataCenter.AllianceBossManager:GetIsFreeRewardCanReceive() then
        self.free_package_btn:SetActive(true)
        --self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    else
        self.free_package_btn:SetActive(false)
    end
end

-- 领取免费奖励之后
local function OnFreeRewardReceived(self)
    -- 隐藏免费奖励按钮
    self.free_package_btn:SetActive(false)
    local attackItemId = LuaEntry.DataConfig:TryGetNum("alliance_boss", "k1")
    local itemCount = DataCenter.ItemData:GetItemCount(attackItemId)
    self.gold_num:SetText(tostring(itemCount))
end

-- 点击圆形倍数图标
local function OnMultipleBgBtnClick(self)
    --弹出说明面板
    -- local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
    -- local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)

    local param = {}
    -- param["itemName"] = name
    param["itemDesc"] = CS.GameEntry.Localization:GetString("373005")
    param["alignObject"] = self.multiple_bg_click_btn
    param.isLocal = true

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
end

local function OnRefreshDonateProgress(self)
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo == nil then
        return
    end

    local lvExpInfo = DataCenter.AllianceBossManager:GetBossLvAndExpInfo()
    if lvExpInfo == nil then
        return
    end
    local curLvMaxExp = lvExpInfo[bossInfo.lv].exp
    self.donate_txt_progress:SetText(tostring(bossInfo.exp) .. "/" .. tostring(curLvMaxExp))
    local progressBarPercent = bossInfo.exp / curLvMaxExp
    self.donate_progress_slider:SetValue(progressBarPercent)
    self.boss_level_label:SetLocalText(300665, tostring(bossInfo.lv)) -- 等级. xxx

    local multipleNumber =  DataCenter.AllianceBossManager:GetMultipleNumber()
    self.multiple_number_label:SetText("x" .. tostring(multipleNumber))
    self.attack_box_multiple_label:SetText("x" .. tostring(multipleNumber))
end

local function OnPushDamageChange(self)
    self:OnRefreshAttackProgress(true)
end

local function OnRefreshAttackProgress(self, useAnim)
    local currDamage = DataCenter.AllianceBossManager:GetCurrBossSelfDamage()
    if currDamage == nil then
        return
    end

    local damageShowArr = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
    --上一级的最大伤害量
    local lastLevelDamage = 0
    --当前等级的最大伤害量
    local currLevelDeltaDamage = 0

    local targetLv = 0
    local targetDamage = 0
    local curGetBoxNum = 0
    for k,v in ipairs(damageShowArr) do 
        currLevelDeltaDamage = v.damage - lastLevelDamage
        if v.damage > currDamage then
            break
        end
        targetLv = k
        lastLevelDamage = v.damage
        curGetBoxNum = curGetBoxNum + 1
    end

    --当前等级内的伤害量
    local curLevelDamage = currDamage - lastLevelDamage
    targetDamage = curLevelDamage
    self.attack_box_reward_count_label:SetText("x" .. tostring(curGetBoxNum))

    if useAnim == true then
        self.targetLv = targetLv
        if self.isScheduleOn == false then
            UpdateManager:GetInstance():AddUpdate(self.update_action)
            self.isScheduleOn = true
        end
        self.targetDamage = targetDamage
    else
        --不使用动画 直接设置当前伤害量和伤害等级
        self.curLv = targetLv
        self.targetLv = targetLv
        self.curDamage = targetDamage
        self.targetDamage = targetDamage

        local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
        local delta = self.targetDamage - self.curDamage
        local lerpValue = delta / 10
        if lerpValue < 1 then
            lerpValue = 1
        end

        local curLvMaxDamage = damageLevelInfo[self.curLv+1].damage -- 之前的逻辑有问题 self.curlv暂时指的是已经挑战过的等级
        local curFrameDamage = self.curDamage + lerpValue
        if curFrameDamage > self.targetDamage then
            curFrameDamage = self.targetDamage
        end
        
        --造成伤害显示不再有最大值限制 by zzl
        --if curFrameDamage > curLvMaxDamage then
        --    curFrameDamage = curLvMaxDamage
        --end

        local progressBarPercent = curFrameDamage / curLvMaxDamage

        self.attack_progress_slider:SetValue(progressBarPercent)
        self.curDamage = curFrameDamage
        self.attack_txt_progress:SetText(tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage)))
    
        local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
        if bossInfo ~= nil then
            self.attack_box_multiple_label:SetText("x" .. tostring(bossInfo.lv))
        end
    end
end

local function GetIconPathByBossLevel(self, big)
    local activityData = DataCenter.AllianceBossManager:GetActivityData(self.activityId)
    if activityData == nil then
        return
    end
    local levelVec = string.split(activityData.para2, "|")
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo == nil then
        return
    end
    local index = 1
    for k,v in ipairs(levelVec) do
        if bossInfo.lv >= toInt(v) then
            index = k
        else
            break
        end
    end
    
    local nameText = "Assets/Main/Sprites/UI/UIAllianceBoss/activity_alianceboss_"
    if big then
        nameText = nameText .. "da_"
    else
        nameText = nameText .. "xiao_"
    end

    nameText = nameText .. tostring(index)
    return nameText
end

local function OnClickDonateTips(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBossDonateTips, { anim = true, isBlur = true})
end

UIActivityAllianceBoss.OnCreate = OnCreate
UIActivityAllianceBoss.OnDestroy = OnDestroy
UIActivityAllianceBoss.OnEnable = OnEnable
UIActivityAllianceBoss.OnDisable = OnDisable
UIActivityAllianceBoss.ComponentDefine = ComponentDefine
UIActivityAllianceBoss.ComponentDestroy = ComponentDestroy
UIActivityAllianceBoss.OnAddListener = OnAddListener
UIActivityAllianceBoss.OnRemoveListener = OnRemoveListener
UIActivityAllianceBoss.SetData = SetData

UIActivityAllianceBoss.OnAllianceBossDataReturn = OnAllianceBossDataReturn
UIActivityAllianceBoss.AddTimer = AddTimer
UIActivityAllianceBoss.DeleteTimer = DeleteTimer
UIActivityAllianceBoss.Update1000ms = Update1000ms
UIActivityAllianceBoss.OnUpdate = OnUpdate
UIActivityAllianceBoss.OnBottomBtnClick = OnBottomBtnClick
UIActivityAllianceBoss.OnJoinAllianceBtnClick = OnJoinAllianceBtnClick
UIActivityAllianceBoss.OnDonateBtnClick = OnDonateBtnClick
UIActivityAllianceBoss.OnSummonBtnClick = OnSummonBtnClick
UIActivityAllianceBoss.OnSummonBossReturn = OnSummonBossReturn
UIActivityAllianceBoss.OnAttackBtnClick = OnAttackBtnClick
UIActivityAllianceBoss.OnAttackRewardShowBtnClick = OnAttackRewardShowBtnClick

UIActivityAllianceBoss.CheckAndShowCurrState = CheckAndShowCurrState
UIActivityAllianceBoss.ShowNoneState = ShowNoneState
UIActivityAllianceBoss.ShowNoAllianceState = ShowNoAllianceState
UIActivityAllianceBoss.ShowDonateState = ShowDonateState
UIActivityAllianceBoss.ShowPrepareState = ShowPrepareState
UIActivityAllianceBoss.ShowAttackState = ShowAttackState

UIActivityAllianceBoss.OnFreeRewardReceived = OnFreeRewardReceived
UIActivityAllianceBoss.OnMultipleBgBtnClick = OnMultipleBgBtnClick
UIActivityAllianceBoss.OnRefreshDonateProgress = OnRefreshDonateProgress
UIActivityAllianceBoss.OnPushDamageChange = OnPushDamageChange
UIActivityAllianceBoss.OnRefreshAttackProgress = OnRefreshAttackProgress
UIActivityAllianceBoss.GetIconPathByBossLevel = GetIconPathByBossLevel

UIActivityAllianceBoss.OnClickDonateTips = OnClickDonateTips

return UIActivityAllianceBoss