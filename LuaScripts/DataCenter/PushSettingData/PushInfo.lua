local PushInfo = BaseClass("PushInfo")

local function __init(self)
	self.id = 0 		
	self.group = 0 		
	self.unlock = 0
	self.type = 0
end

local function __delete(self)
	self.id = nil
	self.group = nil
	self.unlock = nil
	self.type = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	if message["id"] ~= nil then
		self.id = message["id"]
	end
	if message["push_group"] ~= nil then
		self.group = message["push_group"]
	end
	if message["push_unlock"] ~= nil then
		self.unlock = message["push_unlock"]
	end
	if message["push_type"] ~= nil then
		self.type = message["push_type"]
	end
	
end

PushInfo.__init = __init
PushInfo.__delete = __delete
PushInfo.UpdateInfo = UpdateInfo

return PushInfo