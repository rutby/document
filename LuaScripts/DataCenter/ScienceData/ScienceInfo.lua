local ScienceInfo = BaseClass("ScienceInfo")

local function __init(self)
	self.uuid = 0 --科技唯一id
	self.itemId = "" --科技id
	self.level = 0 --等级
end

local function __delete(self)
	self.uuid = nil
	self.itemId = nil
	self.level = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end

	self.uuid = message["uuid"]
	self.itemId = message["itemId"]
	self.level = message["level"]
end


ScienceInfo.__init = __init
ScienceInfo.__delete = __delete
ScienceInfo.UpdateInfo = UpdateInfo

return ScienceInfo