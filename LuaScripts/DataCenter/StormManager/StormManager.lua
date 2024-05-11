--- Created by shimin.
--- DateTime: 2023/11/9 21:05
--- 暴风雪管理器

local StormManager = BaseClass("StormManager")

function StormManager:__init()
    self.stormStartTime = 0 -- 暴风雪 开始时间
    self.stormEndTime = 0 -- 暴风雪 结束时间
    self.stormAlertTime = 0 -- 暴风雪 警报时间
    self.stormType = StormType.Normal -- 暴风雪 类型
    self.hasNewStorm = false -- 是否是新的暴风雪
    
    self.callTime = 0--默认0 -> 叫第一次 变1 -> 叫第二次 变2
    self.alreadyReward = {} -- 1;2 表示第一次和第二次都领了奖励
    self.rewardList = {}--全部完成获得奖励
    self.taskList = {} --<index, <taskId>>  index表示第几次暴风雪
    self.panelType = UIStormPanelType.Short
    self.short_timer_callback = function() 
        self:OnShortTimerCallBack()
    end
    self.deadList = {} --<index, <residentId>>  index表示第几次暴风雪
end

function StormManager:__delete()
    self:RemoveShortTimer()
    self.stormStartTime = 0 -- 暴风雪 开始时间
    self.stormEndTime = 0 -- 暴风雪 结束时间
    self.stormAlertTime = 0 -- 暴风雪 警报时间
    self.stormType = StormType.Normal -- 暴风雪 类型
    self.hasNewStorm = false -- 是否是新的暴风雪

    self.callTime = 0--默认0 -> 叫第一次 变1 -> 叫第二次 变2
    self.alreadyReward = {} -- 1;2 表示第一次和第二次都领了奖励
    self.rewardList = {}--全部完成获得奖励
    self.taskList = {} --<index, <taskId>>  index表示第几次暴风雪
    self.panelType = UIStormPanelType.Short
    self.deadList = {} --<index, <residentId>>  index表示第几次暴风雪
end

function StormManager:Startup()

end

--获取暴风雪状态
function StormManager:GetStormState()
    if self.callTime > 0 and (not self.alreadyReward[self.callTime]) then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < self.stormStartTime then
            return StormState.Alert
        else
            return StormState.Start
        end
    end
    
    return StormState.No
end

--获取奖励状态
function StormManager:GetRewardState()
    if self.alreadyReward[self.callTime] then
        return StormRewardState.Got
    elseif self:GetStormState() == StormState.Alert or self:GetStormState() == StormState.Start then
        local list = self.taskList[self.callTime]
        if list ~= nil then
            local task = nil
            for k, v in ipairs(list) do
                task = DataCenter.TaskManager:FindTaskInfo(v)
                if task ~= nil then
                    if task.state == TaskState.NoComplete then
                        return StormRewardState.No
                    end
                else
                    return StormRewardState.No
                end
            end
            return StormRewardState.CanGet
        end
    end
  
    return StormRewardState.No
end

--初始化信息
function StormManager:InitData(message)
    self:UpdateNewbieResidentStorm(message["newbie_resident_storm"])
    self:InitConfigData()
    if self:NeedStartNextStorm() then
        if self:GetStormState() == StormState.No then
            self:SendStartNewbieStorm()
        end
    end
end

--更新
function StormManager:UpdateNewbieResidentStorm(message)
    if message ~= nil then
        self.alreadyReward = {}
        local alreadyReward = message["alreadyReward"]
        if alreadyReward ~= nil and alreadyReward ~= "" then
            local spl = string.split_ii_array(alreadyReward, ";")
            for k, v in ipairs(spl) do
                self.alreadyReward[v] = true
            end
        end
        self.callTime = message["callTime"]
    end
end

--初始化配置
function StormManager:InitConfigData()
    if self.taskList[1] == nil then
        self.taskList = {}
        local temp = LuaEntry.DataConfig:TryGetStr("storm_config", "k7")
        if temp ~= "" then
            local str = string.split_ss_array(temp, "|")
            for k, v in ipairs(str) do
                self.taskList[k] = string.split_ii_array(v, ";")
            end
        end
    end

    if self.deadList[1] == nil then
        self.deadList = {}
        local temp = LuaEntry.DataConfig:TryGetStr("storm_config", "k9")
        if temp ~= "" then
            local str = string.split_ss_array(temp, "|")
            for k, v in ipairs(str) do
                self.deadList[k] = string.split_ii_array(v, ";")
            end
        end
    end
end

--更新暴风雪时间数据
function StormManager:UpdateStormTime(message)
    if message ~= nil then
        local temp = message.stormStartTime
        if temp ~= nil then
            self.stormStartTime = temp
        end
        temp =  message.stormEndTime
        if temp ~= nil then
            self.stormEndTime = temp
        end
        temp =  message.stormType
        if temp ~= nil then
            self.stormType = temp
        end
        temp =  message.hasNewStorm
        if temp ~= nil then
            self.hasNewStorm = temp
        end
    end
end

-- 是否是暴风雪天
function StormManager:IsStorm(time)
    return time < self.stormEndTime
end

--召唤暴风雪
function StormManager:SendStartNewbieStorm()
    DataCenter.GuideManager:SendSaveGuideMessage(WaitStartNextStorm, nil)
    SFSNetwork.SendMessage(MsgDefines.StartNewbieStorm)
end

--召唤暴风雪回调
function StormManager:StartNewbieStormHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        self.rewardList = {}
        self:UpdateStormTime(message["residentParam"])
        self:UpdateNewbieResidentStorm(message["newbie_resident_storm"])
        self.panelType = UIStormPanelType.Long
        EventManager:GetInstance():Broadcast(EventId.RefreshStorm)
        --打开暴风雪界面
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPreviewStorm, {anim = true, isBlur = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide})
    else
        UIUtil.ShowTipsId(errCode)
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.StartNewbieStorm, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

--领取暴风雪奖励
function StormManager:SendCollectNewbieStormReward()
    if self:GetRewardState() == StormRewardState.CanGet then
        SFSNetwork.SendMessage(MsgDefines.CollectNewbieStormReward, {newbieStormId = self.callTime})
    end
end

--领取暴风雪奖励回调
function StormManager:CollectNewbieStormRewardHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        local reward = message["reward"]
        if reward ~= nil then
            for k,v in pairs(reward) do
                DataCenter.RewardManager:AddOneReward(v)
            end
            DataCenter.RewardManager:ShowCommonReward(message)
        end
        self:UpdateStormTime(message["residentParam"])
        self:UpdateNewbieResidentStorm(message["newbie_resident_storm"])
        EventManager:GetInstance():Broadcast(EventId.RefreshStorm)

        --这里检测
        if self:NeedStartNextStorm() then
            self:AddShortTimer()
        end
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--发送获取暴风雪展示奖励
function StormManager:SendGetNewbieStormReward()
    SFSNetwork.SendMessage(MsgDefines.GetNewbieStormReward, {newbieStormId = self.callTime})
end

--获取暴风雪展示奖励回调
function StormManager:GetNewbieStormRewardHandle(message)
    local errCode = message["errorCode"]
    if errCode == nil then
        local reward = message["reward"]
        if reward ~= nil then
            self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
            EventManager:GetInstance():Broadcast(EventId.RefreshStorm)
        end
    else
        UIUtil.ShowTipsId(errCode)
    end
end

--获取奖励
function StormManager:GetRewardList()
    return self.rewardList
end

--获取任务
function StormManager:GetTaskList()
    return self.taskList[self.callTime]
end

--获取死亡小人
function StormManager:GetDeadList()
    return self.deadList[self.callTime]
end

--是否需要召唤暴风雪
function StormManager:NeedStartNextStorm()
    return DataCenter.GuideManager:GetSaveGuideValue(WaitStartNextStorm) == SaveGuideDoneValue
end


function StormManager:AddShortTimer()
    if self.shortTime == nil then
        self.shortTime = TimerManager:GetInstance():GetTimer(2, self.short_timer_callback, self, false, false, false)
        self.shortTime:Start()
    end
end

function StormManager:RemoveShortTimer()
    if self.shortTime ~= nil then
        self.shortTime:Stop()
        self.shortTime = nil
    end
end

function StormManager:OnShortTimerCallBack()
    if not UIManager:GetInstance():HasWindow() then
        if self:NeedStartNextStorm() then
            if self:GetStormState() == StormState.No then
                self:RemoveShortTimer()
                self:SendStartNewbieStorm()
            end
        else
            self:RemoveShortTimer()
        end
    end
end

return StormManager
