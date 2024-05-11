---
--- 主线任务
--- Created by shimin.
--- DateTime: 2020/9/11 15:29
---
local TaskManager = BaseClass("TaskManager")
local Localization = CS.GameEntry.Localization
local ActivityOverviewTemplate = require "DataCenter.TaskData.ActivityOverviewTemplate"
local Const = require("Scene.PVEBattleLevel.Const")
local WarnList = 9999
local function __init(self)
	self.allTask = {}
	self.isTaskCompleteNew = false    --任务的完成领奖刷新状态
	self.taskMsgIsShowType = false
	self.actViewTimeDic = nil
	self.curTaskIndex = 0
	self.pveTask = {}
	--self.bubbleTask = {}
	self.pveRewardGetType = {}
	self.completeValue = false
	self.seasonTask = {}
	self.chapterBTaskId = 0
end

local function __delete(self)
	self.allTask = nil
	self.isTaskCompleteNew = nil
	self.taskMsgIsShowType = nil
	self.actViewTimeDic = nil
	self.curTaskIndex = nil
	self.pveTask = nil
	--self.bubbleTask = nil
	self.pveRewardGetType = nil
	self.completeValue = nil
	self.seasonTask = nil
	self.chapterBTaskId = nil
end

--初始化所有任务信息
local function InitData(self,message)
	if message["task"] ~= nil then
		self.allTask = {}
		self.seasonTask = {}
		for k,v in pairs(message["task"]) do
			self:UpdateOneTaskInfo(v)
		end
	end
	self.chapterBTaskId = 0
	self:InitPVETask()
	EventManager:GetInstance():Broadcast(EventId.TaskInitFinish)
end


local function InitPVETask(self)
	self.pveTask = {}
end

local function GetBubbleTask(self)
	local result = {}
	if self.allTask then
		for i ,v in pairs(self.allTask) do
			local bubble = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), i, "bubble", 0)
			if bubble == QuestBubbleType.World then
				if v.state ~= TaskState.Received then
					table.insert(result,v)
				end
			end
		end
	end
	table.sort(result,self.SortBubbleTask)
	return result
end

local function SortBubbleTask(a,b)
	if a.state > b.state then
		return true
	elseif a.state < b.state then
		return false
	else
		local orderA = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), a.id, "order", 0)
		local orderB = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), b.id, "order", 0)
		return orderA < orderB
	end

	return false
end

local function GetCurBubbleTaskType(self)
	local data = self:GetBubbleTask()
	local type = {}
	local list = {}
	for i = 1 ,#data do
		type[GetTableData(DataCenter.QuestTemplateManager:GetTableName(), data[i].id, "list")] = true
	end
	for i ,v in pairs(type) do
		table.insert(list,i)
	end
	table.sort(list,function(a,b)
		if a < b then
			return true
		end
		return false
	end)
	return list
end

local function GetBubbleTaskByType(self,type)
	local data = self:GetBubbleTask()
	for i = 1, #data do
		local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), data[i].id)
		if type == tonumber(template.list) then
			if template.quest_pre ~= "" then
				--前置任务没接到也当完成
				local taskInfo = self:FindTaskInfo(template.quest_pre)
				if taskInfo then
					if taskInfo.state == TaskState.Received then
						return data[i]
					end
				else
					return data[i]
				end
			else
				return data[i]
			end
		end
	end
	return nil
end

--更新一个任务信息
local function UpdateOneTaskInfo(self,message)
	if message ~= nil then
		local id = message["id"]
		local one = self:FindTaskInfo(id)
		if one == nil then
			one = TaskInfo.New()
			one:UpdateInfo(message)
			self.allTask[id] = one
			local type = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), id, "type", 0)
			if type == QuestType.PVE then
				self.pveTask[id] = one
			elseif type == QuestType.SeasonChapter then
				self.seasonTask[id] = one
			end
		else
			one:UpdateInfo(message)
		end
	end
end

--获取任务信息
local function FindTaskInfo(self,id)
	if id ~= nil then
		return self.allTask[tostring(id)]
	end
end

--获取排好序的主任务信息 state true 不需要排序
local function GetAllMainTask(self)
	local canReceiveListTask = {}
	local noCompleteListTask = {}
	local canReceiveList = {}
	local noCompleteList = {}
	local template = nil
	for k,v in pairs(self.allTask) do
		template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
		if template~=nil and (template.pos_type == nil or template.pos_type == 0) then
			if v.state == TaskState.CanReceive then
				if template ~= nil and template.order > 0 and template.type == QuestType.Main then
					local temp = {}
					temp.data = v
					temp.order = template.order
					temp.list = template.list
					temp.data.taskType = 0
					if template.listType then
						temp.data.taskType = template.listType
					end
					-- 同一个list字段只能显示一个
					local keyName = template.list
					if canReceiveListTask[keyName] == nil then
						canReceiveListTask[keyName] = temp
					else
						if canReceiveListTask[keyName].order > temp.order then
							canReceiveListTask[keyName] = temp
						end
					end
				end
			elseif v.state == TaskState.NoComplete then
				template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
				if template == nil then
					--Logger.LogError("questTemplate is nil id = "..k)
				end
				if template ~= nil and template.order > 0 and template.type == QuestType.Main then
					local temp = {}
					temp.data = v
					temp.order = template.order
					temp.list = template.list
					temp.data.taskType = 0
					if template.listType then
						temp.data.taskType = template.listType
					end
					-- 同一个list字段只能显示一个
					local keyName = template.list
					if noCompleteListTask[keyName] == nil then
						noCompleteListTask[keyName] = temp
					else
						if noCompleteListTask[keyName].order > temp.order then
							noCompleteListTask[keyName] = temp
						end
					end
				end
			end
		end
		
	end
	for i, v in pairs(canReceiveListTask) do
		table.insert(canReceiveList,v)
	end
	for i, v in pairs(noCompleteListTask) do
		table.insert(noCompleteList,v)
	end
	if canReceiveList[2] ~= nil then
		table.sort(canReceiveList,self.GetAllSortTask)
	end
	if noCompleteList[2] ~= nil then
		table.sort(noCompleteList,self.GetAllSortTask)
	end
	
	local result = {}
	local hasMainTask = false  -- 主线任务  最多显示一条
	local canRecMaxNum = self:GetCanRecQuestShowMaxNum()
	local curCanRecNum = 0
	for k,v in ipairs(canReceiveList) do
		if v.taskType == 0 and not hasMainTask then -- 主线任务  最多显示一条
			table.insert(result, v.data)
			hasMainTask = true
		elseif curCanRecNum < canRecMaxNum then
			curCanRecNum = curCanRecNum + 1
			table.insert(result, v.data)
		else
			break
		end
	end
	local curNoCompleteMaxNum = 0
	local noCompleteMaxNum = self:GetCanRecQuestShowMaxNum()
	for k,v in ipairs(noCompleteList) do
		if v.taskType == 0 and not hasMainTask then -- 主线任务  最多显示一条
			table.insert(result, v.data)
			hasMainTask = true
		elseif curNoCompleteMaxNum < noCompleteMaxNum then
			curNoCompleteMaxNum = curNoCompleteMaxNum + 1
			table.insert(result,v.data)
		else
			break
		end
	end
	
	return result
end

local function GetMainAndSideTaskList(self)
	local res = self:GetAllMainTask()
	local mainList = {}
	local sideList = {}
	for k,v in ipairs(res) do
		if v.taskType == 0 and #mainList < 1 then -- 主线任务  最多显示一条
			table.insert(mainList, v)
		elseif v.taskType == 1 then	-- 支线任务
			table.insert(sideList, v)
		end
	end
	return mainList,sideList
end

--领奖任务修改任务状态
local function SetMainTaskState(self,id)
	self.allTask[id].state  = TaskState.Received
end

--获取赛季章节任务  state true  不需要排序
local function GetSeasonChapterTask(self,state)
	local allTask = {}
	local listOne = {}
	local needCheckList2 = true --如果listOne有值就不用取list == 2的了（没写注释 我也不知道 == 2嘛意思）
	local taskInfo = nil
	local canAdd = false
	for k, v in pairs(self.seasonTask) do
		if v.state ~= TaskState.Received then
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
			if template ~= nil then
				canAdd = false
				if template.list == QuestListType.List1 then
					if template.quest_pre == "" then
						canAdd = true
					else
						taskInfo = self:FindTaskInfo(template.quest_pre)
						if taskInfo == nil or taskInfo.state == TaskState.Received then
							canAdd = true
						end
					end
					if canAdd then
						table.insert(listOne, v)
						if needCheckList2 then
							needCheckList2 = false
						end
					end
				elseif needCheckList2 and template.list == QuestListType.List2 then
					if template.quest_pre == "" then
						canAdd = true
					else
						taskInfo = self:FindTaskInfo(template.quest_pre)
						if taskInfo == nil or taskInfo.state == TaskState.Received then
							canAdd = true
						end
					end
					if canAdd then
						table.insert(allTask, v)
					end
				end
			end
		end
	end
	
	if listOne[1] ~= nil then
		if state or listOne[2] == nil then
			return listOne
		end
		table.sort(listOne, self.SortBubbleTask)
		return listOne
	end
	
	if (not state) and allTask[2] ~= nil then
		table.sort(allTask, self.SortBubbleTask)
	end
	return allTask
end

local function GetSpecialTask(self)
	local allResult = {}
	for k,v in pairs(self.allTask) do
		if v.state ~= TaskState.Received then
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
			if template ~= nil and template.order > 0 and template.type == QuestType.Main and template.position == "2" then
				table.insert(allResult,v)
			end
		end
	end
	if #allResult>0 then
		table.sort(allResult,self.SpecialSortTask)
		return allResult[1]
	end
end
local function GetSurvivalActTask(self)
	local result = {}
	for k,v in pairs(self.allTask) do
		local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
		if template~=nil then
			if template.type == 49 or template.type == 50 then
				result[template.id] = template
			end
		end
		
	end
	return result
end

local function SpecialSortTask(a,b)
	return GetTableData(DataCenter.QuestTemplateManager:GetTableName(), a.id, "order",  0) 
			< GetTableData(DataCenter.QuestTemplateManager:GetTableName(), b.id, "order",  0)
end

--任务排序
local function GetAllSortTask(a,b)
	if a.list > b.list then
		return false
	elseif a.list < b.list then
		return true
	end
	return false
end

local function PushUpdateTaskHandle(self,message)
	if message["task"] ~= nil then
		for k,v in pairs(message["task"]) do
			self:UpdateOneTaskInfo(v)
		end
	end
	local list = self:GetCanReceivedMainList()
	if next(list) then
		self.isTaskCompleteNew = true
	end
	EventManager:GetInstance():Broadcast(EventId.OnSpecialTaskUpdate)
	EventManager:GetInstance():Broadcast(EventId.MainTaskSuccess)
end

local function TaskRewardGetHandle(self,message)
	if message["errorCode"] ~= nil then
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	else
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		--前置任务完成，后续任务更新
		--if message["task"] then
		--	self:UpdateOneTaskInfo(message["task"])
		--end
		local taskId = message["taskId"]
		if message["taskId"] == tostring(self.chapterBTaskId) then
			self.chapterBTaskId = 0
		end
		if self:ReceiveOneTask(taskId) then
			if message["reward"] ~= nil then
				local isHeroTrialTask = DataCenter.ActSevenDayData:IsHeroTrialTask(taskId)
				if isHeroTrialTask then
					DataCenter.RewardManager:ShowCommonReward(message)
				end
				local drakeTask = DataCenter.ActDrakeBossManager:GetTask()
				if drakeTask and drakeTask.id == taskId then	--德雷克任务需要展示获取奖励界面，主线不需要
					DataCenter.RewardManager:ShowCommonReward(message)
				end
				if taskId == FiveStarTaskId then
					--local scaleFactor = UIManager:GetInstance():GetScaleFactor()
					--local position = Vector3.New(799, 165, 0) * scaleFactor
					--local resourceType = ResourceType.Gold
					--local pic = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
					--local flyPos = Vector3.New(0,0,0)
					--UIUtil.DoFly(tonumber(resourceType), 3, pic, position, flyPos)
					--TimerManager:GetInstance():DelayInvoke(function()
					--	for k,v in pairs(message["reward"]) do
					--		DataCenter.RewardManager:AddOneReward(v)
					--	end
					--end, 1.5)
					DataCenter.RewardManager:ShowCommonReward(message)
						for k,v in pairs(message["reward"]) do
							DataCenter.RewardManager:AddOneReward(v)
						end
				elseif DataCenter.ActBossDataManager:GetIsInShowRewardTaskList(taskId) ==true then
					DataCenter.RewardManager:ShowCommonReward(message)
					for k,v in pairs(message["reward"]) do
						DataCenter.RewardManager:AddOneReward(v)
					end
				else
					for k,v in pairs(message["reward"]) do
						DataCenter.RewardManager:AddOneReward(v)
					end
				end
			end
			self.isTaskCompleteNew = true
			EventManager:GetInstance():Broadcast(EventId.OnSpecialTaskUpdate)
			EventManager:GetInstance():Broadcast(EventId.MainTaskSuccess,message["taskId"])
			EventManager:GetInstance():Broadcast(EventId.QuestRewardSuccess,message["taskId"])
			
		end
	end
end

--收取一个任务的奖励
local function ReceiveOneTask(self,id)
	local task = self:FindTaskInfo(id)
	if task ~= nil then
		task.state = TaskState.Received
		return true
	end
	return false
end

--是否显示主线任务
local function IsShowMainTask(self)
	return false
end

--获取可领奖任务可显示最大数量
local function GetCanRecQuestShowMaxNum(self)
	return LuaEntry.DataConfig:TryGetNum("maxnum_mainquest", "k2")
end

--获取未完成任务可显示最大数量
local function GetNoCompleteQuestShowMaxNum(self)
	return LuaEntry.DataConfig:TryGetNum("maxnum_mainquest", "k1")
end

local function GetCanReceivedList(self)
	local result = {}
	if self.allTask ~= nil then
		for k,v in pairs((self.allTask)) do
			if v.state == TaskState.CanReceive then
				table.insert(result,v.id)
			end
		end
	end
	return result
end

--主线任务可领奖任务
local function GetCanReceivedMainList(self)
	local result = {}
	if self.allTask ~= nil then
		for k,v in pairs((self.allTask)) do
			if v.state == TaskState.CanReceive then
				local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
				if template ~= nil and template.order > 0 and template.type == QuestType.Main then
					table.insert(result,v.id)
				end
			end
		end
	end
	return result
end

--是否还有主线任务
local function IsHaveMainTask(self)
	if self.allTask ~= nil then
		for k,v in pairs((self.allTask)) do
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
			if template ~= nil and template.order > 0 and template.type == QuestType.Main then
				return true
			end
		end
	end
	return false
end

local function SetCompleteNew(self)
	self.isTaskCompleteNew = false
end

local function SetCompleteValue(self,state)
	self.completeValue = state
end

local function GetCompleteValue(self)
	return self.completeValue
end

local function SetTaskMsg(self,state)
	self.taskMsgIsShowType = state
end

local function GetTaskMsg(self)
	return self.taskMsgIsShowType
end

local function SetCurTaskViewIndex(self,index)
	self.curTaskIndex = index
end

local function GetCurTaskViewIndex(self)
	return  self.curTaskIndex
end

--获取pve任务
local function GetPVETaskById(self,pveID)
	local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pveID)
	local task = {}
	if self.pveTask and next(self.pveTask) then
		if pveTemplate.task and next(pveTemplate.task) then
			local taskId = pveTemplate.task
			for i = 1 ,#taskId do
				if self.pveTask[tostring(taskId[i])] and self.pveTask[tostring(taskId[i])].state ~= TaskState.Received then
					table.insert(task,self.pveTask[tostring(taskId[i])])
				end
			end
		end
	end
	if next(task) then
		table.sort(task,self.SortPveTask)
	end
	return task
end

local function GetPveTaskList(self,pveID)
	local data = self:GetPVETaskById(pveID)

	local type = {}
	local list = {}
	for i = 1 ,#data do
		type[GetTableData(DataCenter.QuestTemplateManager:GetTableName(), data[i].id, "list",  0)] = true
	end
	for i ,v in pairs(type) do
		table.insert(list,i)
	end
	table.sort(list,function(a,b)
		if a < b then
			return true
		end
		return false
	end)
	table.insert(list,WarnList)
	return list
end

--pve任务排序
local function SortPveTask(a,b)
	return GetTableData(DataCenter.QuestTemplateManager:GetTableName(), a.id, "order",  0)
			< GetTableData(DataCenter.QuestTemplateManager:GetTableName(), b.id, "order",  0)
end

local function SetPveRewardType(self,type,state)
	--if type - 100 < 0 then
		self.pveRewardGetType[type] = state
	--else
	--	self.pveRewardGetType[type - 100] = type
	--end
end

local function GetPveRewardType(self,type)
	if self.pveRewardGetType[type] then
		return self.pveRewardGetType[type]
	else
		return nil
	end
end

--退出时清空
local function ClearFelledTree(self)
	self.pveRewardGetType = {}
	self.felledTab = {}
end

--砍数处理
local function FelledTreeHandle(self,resourceType,realNum)
	--任务不存在
	if self.felledTab and not next(self.felledTab) then
		return
	end

	--同步数量并检查是否完成
	for i = 1 ,#self.felledTab do
		if self.felledTab[i].resType == resourceType then
			self.felledTab[i].num = self.felledTab[i].num + realNum
			if self.felledTab[i].num >= self.felledTab[i].targetNum and not self.felledTab[i].isSyncPve then
				self.felledTab[i].isSyncPve = true
				DataCenter.BattleLevel:TaskSyncPveResource()
			end
		end
	end
end

local function GetFelledTree(self,id)
	if self.felledTab then
		for i = 1 ,#self.felledTab do
			if self.felledTab[i].id == id then
				return self.felledTab[i].num
			end
		end
	end
	return 0
	--return self.felledTree
end
--}}}


local function IsFinishTask(self, taskId)
	local task = self:FindTaskInfo(taskId)
	if task == nil then
		local taskInfo = DataCenter.ChapterTaskManager:FindTaskInfo(taskId)
		if taskInfo ~= nil and taskInfo.state ~= TaskState.NoComplete then
			return true
		end
	elseif task ~= nil and task.state ~= TaskState.NoComplete then
		return true
	end
	return false
end

--当章节任务删除时需要保存在主任务中建筑需要判断前置条件
local function AddOneTaskWhenDelete(self, task)
	if task ~= nil then
		local mainTask = self:FindTaskInfo(task.id)
		if mainTask == nil then
			self.allTask[task.id] = task
		end
	end
end

local function RecordLastTaskId(self,id)
	self.chapterBTaskId = id
end
local function GetLastTaskId(self)
	return self.chapterBTaskId
end

--在主界面是否有可以显示的任务
function TaskManager:HaveShowTask()
	for k, v in pairs(self.allTask) do
		if v.state == TaskState.CanReceive or v.state == TaskState.NoComplete then
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
			if template ~= nil and template.order > 0 and template.type == QuestType.Main then
				return true
			end
		end
	end
	return false
end

--在主界面是否有可以显示的赛季任务
function TaskManager:HaveShowSeasonTask()
	local taskInfo = nil
	for k, v in pairs(self.seasonTask) do
		if v.state ~= TaskState.Received then
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
			if template ~= nil then
				if template.list == QuestListType.List1 then
					if template.quest_pre == "" then
						return true
					else
						taskInfo = self:FindTaskInfo(template.quest_pre)
						if taskInfo == nil or taskInfo.state == TaskState.Received then
							return true
						end
					end
				elseif template.list == QuestListType.List2 then
					if template.quest_pre == "" then
						return true
					else
						taskInfo = self:FindTaskInfo(template.quest_pre)
						if taskInfo == nil or taskInfo.state == TaskState.Received then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

local function CheckShowMainTask()
	local k1 = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
	local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
	local check1 = k1 <= 0 or chapterId > k1
	local k9 = LuaEntry.DataConfig:TryGetNum("quest_pre", "k9")
	local mainLv = DataCenter.BuildManager.MainLv or 0
	local check2 = k9 <= 0 or mainLv >= k9
	return check1 and check2
end

TaskManager.__init = __init
TaskManager.__delete = __delete
TaskManager.InitData = InitData
TaskManager.PushUpdateTaskHandle = PushUpdateTaskHandle
TaskManager.UpdateOneTaskInfo = UpdateOneTaskInfo
TaskManager.FindTaskInfo = FindTaskInfo
TaskManager.GetAllMainTask = GetAllMainTask
TaskManager.GetSurvivalActTask =GetSurvivalActTask
TaskManager.TaskRewardGetHandle = TaskRewardGetHandle
TaskManager.ReceiveOneTask = ReceiveOneTask
TaskManager.IsShowMainTask = IsShowMainTask
TaskManager.GetCanRecQuestShowMaxNum = GetCanRecQuestShowMaxNum
TaskManager.GetNoCompleteQuestShowMaxNum = GetNoCompleteQuestShowMaxNum
TaskManager.GetSpecialTask = GetSpecialTask
TaskManager.SpecialSortTask = SpecialSortTask
TaskManager.GetCanReceivedList = GetCanReceivedList
TaskManager.GetAllSortTask = GetAllSortTask
TaskManager.GetCanReceivedMainList = GetCanReceivedMainList
TaskManager.IsHaveMainTask = IsHaveMainTask
TaskManager.SetCompleteNew = SetCompleteNew
TaskManager.SetCompleteValue = SetCompleteValue
TaskManager.GetCompleteValue = GetCompleteValue
TaskManager.SetTaskMsg = SetTaskMsg
TaskManager.GetTaskMsg = GetTaskMsg
TaskManager.SetMainTaskState = SetMainTaskState
TaskManager.GetSeasonChapterTask = GetSeasonChapterTask
TaskManager.SetCurTaskViewIndex = SetCurTaskViewIndex
TaskManager.GetCurTaskViewIndex = GetCurTaskViewIndex
TaskManager.InitPVETask = InitPVETask
TaskManager.GetBubbleTask = GetBubbleTask
TaskManager.SortBubbleTask = SortBubbleTask
TaskManager.GetCurBubbleTaskType = GetCurBubbleTaskType
TaskManager.GetBubbleTaskByType = GetBubbleTaskByType
TaskManager.GetPVETaskById = GetPVETaskById
TaskManager.SortPveTask = SortPveTask
TaskManager.GetPveTaskList = GetPveTaskList
TaskManager.ClearFelledTree = ClearFelledTree
TaskManager.FelledTreeHandle = FelledTreeHandle
TaskManager.GetFelledTree = GetFelledTree
TaskManager.IsFinishTask = IsFinishTask
TaskManager.SetPveRewardType = SetPveRewardType
TaskManager.GetPveRewardType = GetPveRewardType
TaskManager.AddOneTaskWhenDelete = AddOneTaskWhenDelete
TaskManager.RecordLastTaskId = RecordLastTaskId
TaskManager.GetLastTaskId = GetLastTaskId
TaskManager.GetMainAndSideTaskList = GetMainAndSideTaskList
TaskManager.CheckShowMainTask = CheckShowMainTask

return TaskManager