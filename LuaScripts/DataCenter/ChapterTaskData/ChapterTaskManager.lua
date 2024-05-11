---
--- 章节任务
--- Created by shimin.
--- DateTime: 2020/9/11 16:11
---
local ChapterTaskManager = BaseClass("ChapterTaskManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
	self.chapterId = 0
	self.chapterSubTaskArray = {}
	self.rewardList = {}
	self.canReceiveList = {}
	self.isTaskCompleteNew = false		--完成了任务、章节、有任务无完成标识
	self.rewardGetType = {}
	self.isChapterReward = false
	self.subTasks = {}
	self.chapterBTaskId = 0
	self.hasNextChapter = true
end

local function __delete(self)
	self.chapterId = 0
	self.chapterSubTaskArray = nil
	self.rewardList = nil
	self.canReceiveList = {}
	self.isTaskCompleteNew = nil
	self.rewardGetType = nil
	self.isChapterReward = nil
	self.subTasks = nil
	self.chapterBTaskId = nil
	self.hasNextChapter = nil
end

--初始化所有任务信息
local function InitData(self,message)
	if message["chapterTask"] ~= nil then
		--确实是同名包了两层
		self:UpdateChapterTask(message["chapterTask"])
	end
	self.chapterBTaskId = 0
end

local function CheckChapterIsB(self)
	self.chapterNew = LuaEntry.DataConfig:CheckSwitch("ChaptertaskAB")
	return self.chapterNew
	--if LuaEntry.Player.abTest == ABTestType.B then
	--	return self.chapterNew
	--else
	--	return false
	--end
end

--更新章节任务信息
local function UpdateChapterTask(self,message)
	if message ~= nil then
		if message["finishTaskCount"] ~= nil then
			self.finishTaskCount = tonumber(message["finishTaskCount"])
		end
		local chapterTask = message["chapterTask"]
		self.rewardList = {}
		if chapterTask ~= nil then
			if chapterTask["chapterid"] ~= nil then
				self.chapterId = tonumber(chapterTask["chapterid"])
			end
			if chapterTask["reward"] ~= nil then
				self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(chapterTask["reward"])
			end
			if chapterTask["subTasks"] ~= nil then
				self.subTasks = string.split(chapterTask["subTasks"],"|")
			end
		end 
		self.chapterSubTaskArray = {}
		if message["chapterSubTaskArray"] ~= nil then
			for k,v in pairs(message["chapterSubTaskArray"]) do
				self:UpdateOneChapterSubTaskInfo(v)
			end 
		end
		if message["hasNextChapter"] ~= nil then
			self.hasNextChapter = message["hasNextChapter"]
		end
		EventManager:GetInstance():Broadcast(EventId.ChapterTask)
	end
end

--更新一个子任务信息
local function UpdateOneChapterSubTaskInfo(self,message)
	if message ~= nil then
		local id = message["id"]
		local one = self:FindTaskInfo(id)
		if one == nil then
			one = ChapterTaskInfo.New()
			one:UpdateInfo(message)
			self.chapterSubTaskArray[id] = one
		else
			one:UpdateInfo(message)
		end
	end
end

local function CheckIsSuccess(self,questId)
	local data = self:FindTaskInfo(tostring(questId))
	if data then
		if data.state == TaskState.NoComplete then
			return false
		else
			return true
		end
	else
		local template = DataCenter.ChapterTemplateManager:GetChapterTemplateByQuestId(questId)
		if template ~= nil then
			local curId = self:GetCurChapterId()
			if curId > template.chapter then
				return true
			end
		end
	end
	return false
end

--获取任务信息
local function FindTaskInfo(self,id)
	return self.chapterSubTaskArray[id]
end

--获取排好序的章节任务信息
local function GetAllChapterTask(self, needReceivedTask) 
	local result = {}
	--不需要显示已完成任务
	local successtask = {}
	for k,v in pairs(self.chapterSubTaskArray) do
		local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), k)
		if v.state ~= TaskState.Received then
			if template ~= nil then
				table.insert(result,v)
			end
		else
			if template ~= nil then
				table.insert(successtask,v)
			end
		end
	end
	table.sort(result,self.SortTask)
	if self:CheckChapterIsB() or (needReceivedTask and needReceivedTask == true) then
		if next(successtask) then
			table.sort(successtask, function(a,b)
				if tonumber(a.id) < tonumber(b.id) then
					return true
				end
				return false
			end)
			for i = 1, table.length(successtask) do
				table.insert(result,successtask[i])
			end
		end
	end
	return result
end

--获取任务类型
local function GetChapterTaskType(self,type)
	local data = self:GetAllChapterTask()
	for i = 1, #data do
		if type == data[i].listType then
			local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), data[i].id)
			if template and template.questPre ~= "" then
				local taskInfo = self:FindTaskInfo(template.questPre)
				if taskInfo and taskInfo.state == TaskState.Received then
					return data[i]
				end
			else
				return data[i]
			end
		end
	end
	return nil
end

--当前章节有几个list任务
local function GetCurChapterAllType(self)
	local data = self:GetAllChapterTask()
	local type = {}
	local list = {}
	for i = 1 ,#data do
		type[data[i].listType] = true
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
	--没有任务检查下是否所有任务做完
	if not next(list) then
		local allNum =  self:GetAllNum()
		local completeNum = self:GetCompleteNum()
		local num =  self:GetCurChapterId()
		if completeNum >= allNum and num ~= 0 then
			list = {1}
			return list
		end
	end

	return list
end

local function SortChapterByData(self,list)
	local result = {}
	local successtask = {}
	for i = 1, #list do
		local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), list[i].id)
		if list[i].state ~= TaskState.Received then
			if template ~= nil then
				table.insert(result,list[i])
			end
		else
			if template ~= nil then
				table.insert(successtask,list[i])
			end
		end
	end
	table.sort(result,self.SortTask)
	if next(successtask) then
		table.sort(successtask, function(a,b)
			if tonumber(a.id) < tonumber(b.id) then
				return true
			end
			return false
		end)
		for i = 1, table.length(successtask) do
			table.insert(result,successtask[i])
		end
	end
	return result
end

--任务排序
local function SortTask(a,b)
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


--服务器推送
local function PushTaskChapterTaskHandle(self,message)
	self:UpdateChapterTask(message)
	local isRefresh = true
	local list = DataCenter.ChapterTaskManager:GetCanReceivedList()
	if next(list) then
		self.isTaskCompleteNew = true
	end
	if isRefresh then
		EventManager:GetInstance():Broadcast(EventId.ChapterTask,2)
	end
	if list ~= nil then
		for k,v in ipairs(list) do
			DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.TaskFinish,tostring(v))
		end
	end
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
		if message["chapterTasks"] then
			for i = 1, #message["chapterTasks"] do
				self:UpdateOneChapterSubTaskInfo(message["chapterTasks"][i])
			end
		end
		--if message["chapterTask"] then
		--	self:UpdateOneChapterSubTaskInfo(message["chapterTask"])
		--end
		if message["taskId"] == tostring(self.chapterBTaskId) then
			self.chapterBTaskId = 0
		end
		if message["finishTaskCount"] ~= nil then
			self.finishTaskCount = tonumber(message["finishTaskCount"])
		end
		if self:ReceiveOneTask(message["taskId"]) then
			if message["reward"] ~= nil then
				--DataCenter.RewardManager:ShowCommonReward(message)
				for k,v in pairs(message["reward"]) do
					DataCenter.RewardManager:AddOneReward(v)
				end
			end
			self.isTaskCompleteNew = true
			EventManager:GetInstance():Broadcast(EventId.ChapterTask,1)
			EventManager:GetInstance():Broadcast(EventId.QuestRewardSuccess,message["taskId"])
		end
	end
end

--手动设置任务状态
local function SetTaskState(self,id)
	if self.chapterSubTaskArray[id] then
		self.chapterSubTaskArray[id].state = TaskState.Received
	else
		DataCenter.TaskManager:SetMainTaskState(id)
	end
end

--获取子完成任务的数量
local function GetCompleteNum(self)
	local result = 0 
	if self.chapterSubTaskArray ~= nil then
		for k,v in pairs((self.chapterSubTaskArray)) do
			if v.state == TaskState.Received then
				result = result + 1
			end
		end
	end
	return result
end


--获取当前章节任务进度
local function GetProgressNum(self)
	local result = 0
	if self.chapterSubTaskArray ~= nil then
		for k,v in pairs((self.chapterSubTaskArray)) do
			if v.state == TaskState.Received or v.state == TaskState.CanReceive then
				result = result + 1
			end
		end
	end
	return result,self:GetAllNum()
end
--记录上次前往的任务 B
local function RecordLastTaskId(self,id)
	self.chapterBTaskId = id
end
local function GetLastTaskId(self)
	return self.chapterBTaskId
end

--获取所有任务数量
local function GetAllNum(self)
	local result = 0
	if self.subTasks ~= nil then
		result = table.count(self.subTasks)
	end
	return result 
end

--是否完成所有章节任务
local function IsCompleteAllChapter(self)
	local haveCompleteNum = self:GetCompleteNum()
	local allNum =  self:GetAllNum()
	return (self.chapterId == MaxChapterId and haveCompleteNum >= allNum) or (self.chapterId == 0 and allNum == 0)
end

--收取一个任务的奖励
local function ReceiveOneTask(self,id)
	local task = self:FindTaskInfo(id)
	if task ~= nil then
		task.state = TaskState.Received
		DataCenter.TaskManager:AddOneTaskWhenDelete(task)
		return true
	end
	return false
end

--领取章节奖励
local function ChapterTaskHandle(self,message)
	if message["errorCode"] ~= nil then
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	else
		if message["result"] then
			self:UpdateChapterTask(message)
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
			DataCenter.RewardManager:ShowCommonReward(message)
			self.chapterBTaskId = 0
			self.isTaskCompleteNew = true
			local chapterId = self:GetCurChapterId()
			if chapterId ~= nil then
				if message["hasNextChapter"] then
					self.hasNextChapter = message["hasNextChapter"]
					EventManager:GetInstance():Broadcast(EventId.ChapterTaskGetReward,chapterId - 1)
				else
					self.hasNextChapter = false
					self.chapterId = 0
					EventManager:GetInstance():Broadcast(EventId.ChapterTaskGetReward,chapterId)
				end
			end
			EventManager:GetInstance():Broadcast(EventId.ChapterTask,3)
		end
		if message["finishTaskCount"] ~= nil then
			self.finishTaskCount = tonumber(message["finishTaskCount"])
		end
	end
end

--获取章节任务奖励显示
local function GetChapterReward(self) 
	return self.rewardList
end

--获取章节任务奖励显示
local function GetChapterFinishTaskCount(self)
	if self.finishTaskCount == nil then
		return 0
	end
	return self.finishTaskCount
end

local function GetRedDotNum(self)
	local result = 0
	if self.chapterSubTaskArray ~= nil then
		for k,v in pairs((self.chapterSubTaskArray)) do
			if v.state == TaskState.CanReceive then
				result = result + 1
			end
		end
	end
	if self:GetCompleteNum() >= self:GetAllNum() then
		result = result + 1
	end
	return result
end

--获取当前章节id
local function GetCurChapterId(self)
	return self.chapterId
end

--获取可以领取奖励的任务id
local function GetCanReceivedList(self)
	local result = {}
	if self.chapterSubTaskArray ~= nil then
		for k,v in pairs((self.chapterSubTaskArray)) do
			if v.state == TaskState.CanReceive then
				table.insert(result,v.id)
				if not self.canReceiveList[v.id] then
					local param = {}
					param.id = v.id 
					param.isSend = false 
					self.canReceiveList[v.id] = param
				end
			end
		end
	end
	return result
end

local function SetCompleteNew(self)
	self.isTaskCompleteNew = false
end

local function SetRewardGetType(self,type,isMain)
	if isMain then
		if type - 100 < 1000 then
			self.rewardGetType[type] = type
		else
			self.rewardGetType[type - 100] = type
		end
	else
		if type - 100 < 0 then
			self.rewardGetType[type] = type
		else
			self.rewardGetType[type - 100] = type
		end
	end
end

local function GetRewardGetType(self,type)
	if self.rewardGetType[type] then
		return self.rewardGetType[type]
	else
		return nil
	end
end

local function SetCurQuestState(self,type)
	self.isChapterReward = type
end

local function GetCurQuestState(self)
	return self.isChapterReward
end

--是否完成chapterId章节
function ChapterTaskManager:IsFinishChapter(chapterId)
	if self:IsCompleteAllChapter() then
		return true
	end
	local curId = self:GetCurChapterId()
	if curId ~= nil and curId <= chapterId then
		return false
	end
	return true
end

--是否完成chapterId章节
function ChapterTaskManager:IsReachChapter(chapterId)
	if self:IsCompleteAllChapter() then
		return true
	end
	local curId = self:GetCurChapterId()
	if curId ~= nil and curId < chapterId then
		return false
	end
	return true
end

function ChapterTaskManager : CheckShowChapterTask()
	local allNum = self:GetAllNum()
	return self.hasNextChapter and allNum > 0
end

--领奖任务修改任务状态
function ChapterTaskManager : SetTaskState(id)
	self.chapterSubTaskArray[id].state  = TaskState.Received
end

function ChapterTaskManager:HasNextChapter()
	return self.hasNextChapter
end

ChapterTaskManager.__init = __init
ChapterTaskManager.__delete = __delete
ChapterTaskManager.InitData = InitData
ChapterTaskManager.CheckChapterIsB = CheckChapterIsB
ChapterTaskManager.PushTaskChapterTaskHandle = PushTaskChapterTaskHandle
ChapterTaskManager.UpdateChapterTask = UpdateChapterTask
ChapterTaskManager.FindTaskInfo = FindTaskInfo
ChapterTaskManager.GetAllChapterTask = GetAllChapterTask
ChapterTaskManager.SortChapterByData = SortChapterByData
ChapterTaskManager.SortTask = SortTask
ChapterTaskManager.TaskRewardGetHandle = TaskRewardGetHandle
ChapterTaskManager.SetTaskState = SetTaskState
ChapterTaskManager.UpdateOneChapterSubTaskInfo = UpdateOneChapterSubTaskInfo
ChapterTaskManager.CheckIsSuccess = CheckIsSuccess
ChapterTaskManager.IsCompleteAllChapter = IsCompleteAllChapter
ChapterTaskManager.GetCompleteNum = GetCompleteNum
ChapterTaskManager.GetProgressNum = GetProgressNum
ChapterTaskManager.RecordLastTaskId = RecordLastTaskId
ChapterTaskManager.GetLastTaskId = GetLastTaskId
ChapterTaskManager.GetAllNum = GetAllNum
ChapterTaskManager.ReceiveOneTask = ReceiveOneTask
ChapterTaskManager.ChapterTaskHandle = ChapterTaskHandle
ChapterTaskManager.GetChapterReward = GetChapterReward
ChapterTaskManager.GetRedDotNum = GetRedDotNum
ChapterTaskManager.GetCurChapterId = GetCurChapterId
ChapterTaskManager.GetCanReceivedList = GetCanReceivedList
ChapterTaskManager.SetCompleteNew = SetCompleteNew
ChapterTaskManager.GetChapterTaskType = GetChapterTaskType
ChapterTaskManager.GetCurChapterAllType = GetCurChapterAllType
ChapterTaskManager.SetRewardGetType = SetRewardGetType
ChapterTaskManager.GetRewardGetType = GetRewardGetType
ChapterTaskManager.SetCurQuestState = SetCurQuestState
ChapterTaskManager.GetCurQuestState = GetCurQuestState
ChapterTaskManager.GetChapterFinishTaskCount = GetChapterFinishTaskCount

return ChapterTaskManager