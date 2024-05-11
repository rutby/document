local ChapterTaskInfo = BaseClass("ChapterTaskInfo")

local function __init(self)
	self.id = 0 		
	self.num = 0 		
	self.state = 0 		
	self.rewardList = {}
	self.listType = 0
	self.taskReward = false
end

local function __delete(self)
	self.id = nil
	self.num = nil
	self.state = nil
	self.rewardList = nil
	self.listType = nil
	self.taskReward = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	if message["id"] ~= nil then
		self.id = message["id"]
	end
	if message["num"] ~= nil then
		self.num = message["num"]
	end
	if message["state"] ~= nil then
		self.state = message["state"]
	end
	if message["reward"] ~= nil then
		self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
	end
	self.listType = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), self.id, "list")
end

local function SetTaskRewardState(self)
	self.taskReward = true
end

ChapterTaskInfo.__init = __init
ChapterTaskInfo.__delete = __delete
ChapterTaskInfo.UpdateInfo = UpdateInfo
ChapterTaskInfo.SetTaskRewardState = SetTaskRewardState

return ChapterTaskInfo