---
--- 章节任务
--- Created by 
--- DateTime:
---
local ChapterTaskCellManager = BaseClass("ChapterTaskCellManager")
local Localization = CS.GameEntry.Localization

function ChapterTaskCellManager:__init()
	self.chapterId = 0
	self.chapterSubTaskArray = {}
	self.mainAnimShow = false
	self.waitArrow = 0
	local str =  LuaEntry.DataConfig:TryGetStr("quest_pre","k5")
	self.quest_arrow = string.split(str,";")
	self.isCd = false
	self.quest_arrow_timer = nil
	self.quest_arrow_action = function(temp)
		self:RefreshArrowTimer()
	end
	self.guidState = true
	self.powerPveState = false
	self.isChapterB = DataCenter.ChapterTaskManager:CheckChapterIsB() 
end

function ChapterTaskCellManager:__delete()
	self.chapterId = nil
	self.chapterSubTaskArray = nil
	self.mainAnimShow = nil
	self.canReceiveList = {}
	self.isTaskCompleteNew = nil
	self.rewardGetType = nil
	self.isChapterReward = nil
	self.isCd = nil
	self:DeleteArrowTimer()
	self.guidState = nil
	self.powerPveState = nil
	self.isChapterB = nil
end

function ChapterTaskCellManager:QuestSortHandle()
	local newList = {}
	local bubbleList = DataCenter.TaskManager:GetCurBubbleTaskType()
		local typeList = DataCenter.ChapterTaskManager:GetCurChapterAllType()
	for i = 1 ,#bubbleList do
		table.insert(newList,bubbleList[i])
	end
	for i = 1 ,#typeList do
		table.insert(newList,typeList[i])
	end
	table.sort(newList,function(a,b)
		if tonumber(a) < tonumber(b) then
			return true
		end
		return false
	end)
	return newList
end

--获取当前显示的第一个list
function ChapterTaskCellManager:GetShowList()
	local typeList = self:QuestSortHandle()
	local taskData = nil
	for i = 1 ,#typeList do
		if type(typeList[i]) == "string" then
			taskData = DataCenter.TaskManager:GetBubbleTaskByType(tonumber(typeList[i]))
		else
			taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(typeList[i])
		end
		if taskData then
			return typeList[i]
		end
	end
	return nil
end

function ChapterTaskCellManager:GetShowListByIndex(index)
	local typeList = self:QuestSortHandle()
	local taskData = nil
	for i = 1 ,#typeList do
		if type(typeList[i]) == "string" then
			taskData = DataCenter.TaskManager:GetBubbleTaskByType(tonumber(typeList[i]))
		else
			taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(typeList[i])
		end
		if taskData and index == i then
			return typeList[i]
		end
	end
	return nil
end

--taskId string
--检查当前是否有该任务在显示
function ChapterTaskCellManager:CheckIdIsShow(taskId)
	local typeList = self:QuestSortHandle()
	local taskData = nil
	for i = 1 ,#typeList do
		if type(typeList[i]) == "string" then
			taskData = DataCenter.TaskManager:GetBubbleTaskByType(tonumber(typeList[i]))
		else
			taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(typeList[i])
		end
		if taskData and taskData.id == taskId then
			return true
		end
	end
	return false
end

--{{{箭头
function ChapterTaskCellManager:AddArrowTimer()
	local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
	if chapterId == 0 then
		return
	end
	if chapterId <= tonumber(self.quest_arrow[1]) then
		if self.quest_arrow_timer == nil and not self.isCd then
			self.waitArrow = 0
			self.quest_arrow_timer = TimerManager:GetInstance():GetTimer(1, self.quest_arrow_action , self, false,false,false)
			self.quest_arrow_timer:Start()
		end
	end
end

function ChapterTaskCellManager:RefreshArrowTimer()
	if self.waitArrow >= tonumber(self.quest_arrow[2]) then
		
		if DataCenter.TaskManager:GetTaskMsg() or WorldArrowManager:GetInstance():IsCreateWorldArrow() then
			self.waitArrow = 0
			return
		end
		if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideArrow)
				or CS.SceneManager.IsInPVE() or DataCenter.GuideManager:InGuide() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
			return
		end
		if UIManager:GetInstance():HasWindow() or CrossServerUtil:GetIsCrossServer() then
			self:DeleteArrowTimer()
			return
		end
		self:DeleteArrowTimer()
		if self.isChapterB then
			local list = DataCenter.ChapterTaskManager:GetCanReceivedList()
			if list and table.count(list) == 0 then
				EventManager:GetInstance():Broadcast(EventId.ChapterArrow)
			end
		else
			local list = self:GetShowList()
			if list then
				local value = tonumber(list)
				if type(list) == "string" then
					value = tonumber(list) + 1000
				end
				EventManager:GetInstance():Broadcast(EventId.ChapterArrow,value)
			end
		end
	end
	self.waitArrow = self.waitArrow + 1
end

function ChapterTaskCellManager:DeleteArrowTimer()
	if self.quest_arrow_timer ~= nil then
		self.quest_arrow_timer:Stop()
		self.quest_arrow_timer = nil
	end
end

function ChapterTaskCellManager:ResetArrowTime()
	self.arrowWaitTime =  TimerManager:GetInstance():DelayInvoke(function()
		self.arrowWaitTime:Stop()
		self.arrowWaitTime = nil
		self.isCd = false
		self:AddArrowTimer()
	end, tonumber(self.quest_arrow[4]))
end

function ChapterTaskCellManager:SetCdState()
	self.isCd = false
end
--}}}

--上一次领奖list
function ChapterTaskCellManager:SetLastList(list)
	self.lastList = list
end

--检查是否会有任务球关闭
function ChapterTaskCellManager:CheckListShow()
	local taskData = nil
	if self.lastList > 1000 then
		taskData = DataCenter.TaskManager:GetBubbleTaskByType(self.lastList - 1000)
	else
		taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(self.lastList)
	end
	if taskData then
		return false
	else
		return self.lastList
	end
end

--引导标志任务处理
function ChapterTaskCellManager:GuidSetState(state)
	self.guidState = state
end

function ChapterTaskCellManager:GuidGetState()
	return self.guidState
end

function ChapterTaskCellManager:CheckNewSwitch()
	local isOpen = LuaEntry.DataConfig:CheckSwitch("simplebubble") -- 开关
	return isOpen
end

--pve战力不足退出状态修改
function ChapterTaskCellManager:SetPvePowerState(state)
	self.powerPveState = state
end

function ChapterTaskCellManager:GetPvePowerState()
	return self.powerPveState
end

function ChapterTaskCellManager:SetMainAnimShowState(state)
	self.mainAnimShow = state
end

function ChapterTaskCellManager:GetMainAnimShowState()
	return self.mainAnimShow
end

return ChapterTaskCellManager