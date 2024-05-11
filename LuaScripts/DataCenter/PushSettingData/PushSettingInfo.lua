local PushSettingInfo = BaseClass("PushSettingInfo")

local function __init(self)
	self.status = 0 		
	self.type = 0 		
	self.audio = 0 		
end

local function __delete(self)
	self.status = nil
	self.type = nil
	self.audio = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	if message["type"] ~= nil then
		self.type = message["type"]
	end
	if message["status"] ~= nil then
		self.status = message["status"]
	end
	if message["audio"] ~= nil then
		self.audio = message["audio"]
	end
end


PushSettingInfo.__init = __init
PushSettingInfo.__delete = __delete
PushSettingInfo.UpdateInfo = UpdateInfo

return PushSettingInfo