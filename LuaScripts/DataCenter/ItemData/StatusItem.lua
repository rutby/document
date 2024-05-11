local StatusItem = BaseClass("StatusItem")

local function __init(self)
	self.type2 = 0
	self.startTime = 0
	self.endTime = 0
	self.stateId = 0
end

local function __delete(self)
	self.type2 = nil
	self.startTime = nil
	self.endTime = nil
	self.stateId = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end

	if message["type2"] ~= nil then
		self.type2 =  message["type2"]
	end
	if message["startTime"] ~= nil then
		self.startTime =  message["startTime"]
	end
	if message["endTime"] ~= nil then
		self.endTime =  message["endTime"]
	end
	if message["stateId"] ~= nil then
		self.stateId =  message["stateId"]
	end
end

StatusItem.__init = __init
StatusItem.__delete = __delete
StatusItem.UpdateInfo = UpdateInfo

return StatusItem