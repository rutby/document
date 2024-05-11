local HospitalInfo = BaseClass("HospitalInfo")

local function __init(self)
	self.armyId = 0 		--兵种id + 等级
	self.heal = 0 		--正在治疗的数量
	self.dead = 0 		--未治疗的数量
	self.armsType = MarchArmsType.Free
end

local function __delete(self)
	self.armyId = nil
	self.heal = nil
	self.dead = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	if message["armyId"] ~= nil then
		self.armyId = message["armyId"]
	end
	if message["heal"] ~= nil then
		self.heal = message["heal"]
	end
	if message["dead"] ~= nil then
		self.dead = message["dead"]
	end
	if message["type"]~=nil then
		self.armsType = message["type"]
	end
end


HospitalInfo.__init = __init
HospitalInfo.__delete = __delete
HospitalInfo.UpdateInfo = UpdateInfo

return HospitalInfo