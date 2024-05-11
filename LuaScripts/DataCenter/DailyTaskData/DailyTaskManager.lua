---
--- 日常任务
--- Created by shimin.
--- DateTime: 2020/9/11 17:53
---
local DailyTaskManager = BaseClass("DailyTaskManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
	self.curReward = {} --领取到哪个奖励
	self.dailyQuestTasks = {}
	self.rewardList = {}--箱子奖励，point和奖励
	self.dailyBoxActive = {}
	self.ActivityOverviewList = {}
	self:AddListener()
end

local function __delete(self)
	self:RemoveListener()
	self.curReward = nil
	self.dailyQuestTasks = nil
	self.rewardList = nil
	self.dailyBoxActive = nil
	self.ActivityOverviewList = nil
end

local function AddListener(self)
	EventManager:GetInstance():AddListener(EventId.OnPassDay, self.TryReqUpdateData)
end

local function RemoveListener(self)
	EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.TryReqUpdateData)
end

local function TryReqUpdateData(self)
	SFSNetwork.SendMessage(MsgDefines.DailyQuestLs)
end

--初始化所有任务信息
local function InitData(self,message)
	self:UpdateDailyTask(message)
end

--更新章节任务信息
local function UpdateDailyTask(self,message)
	if message ~= nil then
		self.curReward = 0
		self.dailyQuestTasks = {}
		self.rewardList = {}
		self.dailyBoxActive = {}
		if message["curReward"] ~= nil then
			self.curReward = message["curReward"]
		end
		if message["rewardList"] ~= nil then
			for k,v in pairs(message["rewardList"]) do
				if v["point"] ~= nil and v["info"] ~= nil then
					self.rewardList[v["point"]] = DataCenter.RewardManager:ReturnRewardParamForView(v["info"])
					table.insert(self.dailyBoxActive,v.point)
				end
			end
		end
		if message["dailyQuest"] ~= nil then
			for k,v in pairs(message["dailyQuest"]) do
				self:UpdateOneDailyTaskInfo(v)
			end
		end
	end
end

--更新一个子任务信息
local function UpdateOneDailyTaskInfo(self,message)
	if message ~= nil then
		local id = message["id"]
		local one = self:FindTaskInfo(id)
		if one == nil then
			one = DailyTaskInfo.New()
			one:UpdateInfo(message)
			self.dailyQuestTasks[id] = one
		else
			one:UpdateInfo(message)
		end
	end
end

--获取任务信息
local function FindTaskInfo(self,id)
	return self.dailyQuestTasks[id]
end

--local function PushNewDailyTaskHandle(self,message)
--	self:UpdateDailyTask(message)
--	EventManager:GetInstance():Broadcast(EventId.DailyQuestSuccess)
--end

local function DailyQuestLsMessageHandle(self,message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	else
		self:UpdateDailyTask(message)
		EventManager:GetInstance():Broadcast(EventId.DailyQuestLs)
	end
end

--获取当前的活跃值
local function GetCurValue(self) 
	local result = 0
	if self.dailyQuestTasks ~= nil then
		for k,v in pairs(self.dailyQuestTasks) do
			if v.state == TaskState.Received then
				local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(k)
				if template ~= nil then
					result = result + template.point
				end
			end
		end
	end
	return result
end

--领取宝箱奖励处理
local function DailyQuestRewardMessageHandle(self,message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	else
		DataCenter.RewardManager:ShowCommonReward(message)
		for k,v in pairs(message["reward"]) do
			DataCenter.RewardManager:AddOneReward(v)
		end
		EventManager:GetInstance():Broadcast(EventId.DailyQuestReward)
	end
end

local function SetCurReward(self,value)
	--self.curReward = value
	table.insert(self.curReward,value)
end

--获取箱子状态
local function GetBoxState(self,index,curPoint)
	for i = 1, #self.curReward do
		if self.curReward[i] == index then
			return TaskState.Received
		end
	end
	local boxValue = self.dailyBoxActive[index]
	if boxValue then
		if curPoint >= boxValue then
			return TaskState.CanReceive
		else
			return TaskState.NoComplete
		end
	end
	return TaskState.NoComplete
end

--获取排序好的每日任务
local function GetSortDailyTask(self)
	local allDailyTask = self:GetAllDailyTask()
	table.sort(allDailyTask, function(a,b)
		if a.state > b.state then
			return  true
		elseif a.state == b.state then
			local template1 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(a.id)
			local template2 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(b.id)
			if template1 ~= nil and template2 ~= nil and  template1.order < template2.order then
				return true
			else
				return false
			end
			return false
		end
	end)
	
	local seen = {}
	local result = {}
	for _, value in ipairs(allDailyTask) do
		local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(value.id)
		if template ~= nil and not seen[template.list] then
			seen[template.list] = true
			table.insert(result, value)
		end
	end
	
	local receiveList = self:GetAllReceivedDailyTask()
	for i = 1, #receiveList do
		table.insert(result,receiveList[i])
	end
	return result
end

local function GetAllDailyTask(self)
	local result = {}
	if self.dailyQuestTasks ~= nil then
		for k,v in pairs(self.dailyQuestTasks) do
			if v.state ~= TaskState.Received then
				local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(v.id)
				if template ~= nil and template.show == QuestShowType.Show then
					table.insert(result,v)
				end
			end
		end
	end
	return result
end

local function GetAllReceivedDailyTask(self)
	local result = {}
	if self.dailyQuestTasks ~= nil then
		for k,v in pairs(self.dailyQuestTasks) do
			if v.state == TaskState.Received then
				local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(v.id)
				if template ~= nil and template.show == QuestShowType.Show then
					table.insert(result,v)
				end
			end
		end
	end
	table.sort(result, function(a,b)
		if a.state > b.state then
			return  true
		elseif a.state == b.state then
			local template1 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(a.id)
			local template2 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(b.id)
			if template1 ~= nil and template2 ~= nil and  template1.order < template2.order then
				return true
			else
				return false
			end
			return false
		end
	end)
	return result
end

--获取活跃度
local function GetDailyCurValue(self,index)
	return self.dailyBoxActive[index]
end

--获取每日任务最高活跃度
local function GetDailyMaxValue(self)
	local max = table.count(self.dailyBoxActive)
	if next(self.dailyBoxActive) then
		return self.dailyBoxActive[max]
	end
	return 100
end

--获取箱子奖励
local function GetBoxRewardShow(self,point) 
	return self.rewardList[point]
end

--是否显示每日任务
local function IsShowDailyTask(self)
	return true 
end

local function GetRedDotNum(self)
	local result = 0
	local curPoint = self:GetCurValue()
	for k,v in ipairs(self.dailyBoxActive) do
		if curPoint >= v and (self:GetBoxState(k,curPoint) ~= TaskState.Received) then
			result = result + 1
		end
	end
	return result
end

--获取已完成任务红点
local function GetRedNum(self)
	local result = 0
	local list = self:GetAllDailyTask()
	for i = 1, table.length(list) do
		if list[i].state == 1 then
			result = result + 1
		end
	end
	
	local curValue = self:GetCurValue()
	local allClaimed = true
	for i = 1, 5 do
		local tempState = self:GetBoxState(i,curValue)
		if tempState ~= TaskState.Received then
			allClaimed = false
		end
		if tempState == TaskState.CanReceive then
			result = result + 1
		end
		if i == 5 and allClaimed then
			result = 0
		end
	end
	return result
end

local function GetBoxRedNum(self)
	local curValue = self:GetCurValue()
	local allClaimed = false
	for i = 1, 5 do
		local tempState = self:GetBoxState(i,curValue)
		if tempState ~= TaskState.Received then
			allClaimed = true
		end
	end
	return allClaimed
end

--领取任务奖励处理
local function DailyTaskRewardMessageHandle(self,message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	else
		 --DataCenter.RewardManager:ShowCommonReward(message)
		 if message["reward"] ~= nil then
		 	for k,v in pairs(message["reward"]) do
		 		DataCenter.RewardManager:AddOneReward(v)
		 	end
		 end
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
		if message["taskInfo"] ~= nil then
			self:UpdateOneDailyTaskInfo(message["taskInfo"])
		end
		EventManager:GetInstance():Broadcast(EventId.DailyQuestSuccess)
	end
end

local function CheckShowEveryDayTask()
	local k2 = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
	local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
	local check1 = k2 <= 0 or chapterId > k2
	local k8 = LuaEntry.DataConfig:TryGetNum("quest_pre", "k8")
	local mainLv = DataCenter.BuildManager.MainLv
	local check2 = k8 <= 0 or mainLv >= k8
	return check1 and check2
end

local function DailyQuestGetAllRewardHandle(self, message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		return
	end

	local rewardParam = {}
	rewardParam["reward"] = {}
	--任务奖励
	if message["tasks"] ~= nil then
		for k,v in ipairs(message["tasks"]) do
			self:UpdateOneDailyTaskInfo(v)
		end
		EventManager:GetInstance():Broadcast(EventId.DailyQuestGetAllTaskReward)
	end
	if message["taskReward"] ~= nil then
		table.insert(rewardParam["reward"], message["taskReward"])
		for k,v in pairs(message["taskReward"]) do
			DataCenter.RewardManager:AddOneReward(v)
		end
	end

	--箱子奖励
	if message["stages"] then
		for k,v in ipairs(message["stages"]) do
			self:SetCurReward(v)
		end
		EventManager:GetInstance():Broadcast(EventId.DailyQuestReward)
	end
	if message["stageReward"] then
		table.insert(rewardParam["reward"], message["stageReward"])
		for k,v in pairs(message["stageReward"]) do
			DataCenter.RewardManager:AddOneReward(v)
		end
	end

	DataCenter.RewardManager:ShowCommonRewards(rewardParam)
end

DailyTaskManager.__init = __init
DailyTaskManager.__delete = __delete
DailyTaskManager.InitData = InitData
--DailyTaskManager.PushNewDailyTaskHandle = PushNewDailyTaskHandle
DailyTaskManager.UpdateDailyTask = UpdateDailyTask
DailyTaskManager.FindTaskInfo = FindTaskInfo
DailyTaskManager.DailyQuestLsMessageHandle = DailyQuestLsMessageHandle
DailyTaskManager.UpdateOneDailyTaskInfo = UpdateOneDailyTaskInfo
DailyTaskManager.GetCurValue = GetCurValue
DailyTaskManager.DailyQuestRewardMessageHandle = DailyQuestRewardMessageHandle
DailyTaskManager.SetCurReward = SetCurReward
DailyTaskManager.GetBoxState = GetBoxState
DailyTaskManager.GetRedNum = GetRedNum
DailyTaskManager.GetSortDailyTask = GetSortDailyTask
DailyTaskManager.GetBoxRewardShow = GetBoxRewardShow
DailyTaskManager.IsShowDailyTask = IsShowDailyTask
DailyTaskManager.GetRedDotNum = GetRedDotNum
DailyTaskManager.DailyTaskRewardMessageHandle = DailyTaskRewardMessageHandle
DailyTaskManager.GetDailyMaxValue = GetDailyMaxValue
DailyTaskManager.GetDailyCurValue = GetDailyCurValue
DailyTaskManager.GetAllDailyTask = GetAllDailyTask
DailyTaskManager.GetAllReceivedDailyTask = GetAllReceivedDailyTask
DailyTaskManager.AddListener = AddListener
DailyTaskManager.RemoveListener = RemoveListener
DailyTaskManager.TryReqUpdateData = TryReqUpdateData
DailyTaskManager.GetBoxRedNum = GetBoxRedNum
DailyTaskManager.CheckShowEveryDayTask = CheckShowEveryDayTask
DailyTaskManager.DailyQuestGetAllRewardHandle = DailyQuestGetAllRewardHandle

return DailyTaskManager