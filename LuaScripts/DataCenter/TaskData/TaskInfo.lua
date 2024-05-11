local TaskInfo = BaseClass("TaskInfo")

local function __init(self)
	self.id = 0 		
	self.num = 0 --当前任务完成进度		
	self.state = 0 		
	self.rewardList = {}
	self.taskShow = false
	self.exp = 0
	self.taskReward = false
end

local function __delete(self)
	self.id = nil
	self.num = nil
	self.state = nil
	self.rewardList = nil
	self.taskShow = nil
	self.exp = nil
	self.taskReward = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	if message["id"] ~= nil then
		self.id = message["id"]
	end
	if message["taskId"] ~= nil then
		self.id = message["taskId"]
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
	if message["exp"] ~= nil then
		self.exp = message["exp"]
	end
end

local function SetTaskShowState(self)
	self.taskShow = true
end

local function SetTaskRewardState(self)
	self.taskReward = true
end



TaskInfo.__init = __init
TaskInfo.__delete = __delete
TaskInfo.UpdateInfo = UpdateInfo
TaskInfo.SetTaskShowState = SetTaskShowState
TaskInfo.SetTaskRewardState = SetTaskRewardState
return TaskInfo