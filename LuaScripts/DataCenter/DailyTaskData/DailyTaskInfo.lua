local DailyTaskInfo = BaseClass("DailyTaskInfo")

local function __init(self)
	self.id = 0 		
	self.num = 0 			--一共完成的数量
	self.totalNum = 0		--一次的数量
	self.totalTimes = 0		--可以完成的次数
	self.state = 0 			--任务状态  0 未完成 1 已完成  2已领奖
	self.reward = {}		--任务奖励
end

local function __delete(self)
	self.id = nil
	self.num = nil
	self.totalNum = nil
	self.totalTimes = nil
	self.state = nil
	self.reward = nil
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
	if message["totalNum"] ~= nil then
		self.totalNum = message["totalNum"]
	end
	if message["totalTimes"] ~= nil then
		self.totalTimes = message["totalTimes"]
	end
	if message["state"] ~= nil then
		self.state = message["state"]
	end
	if message["reward"] ~= nil then
		self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
	end
end

DailyTaskInfo.__init = __init
DailyTaskInfo.__delete = __delete
DailyTaskInfo.UpdateInfo = UpdateInfo

return DailyTaskInfo