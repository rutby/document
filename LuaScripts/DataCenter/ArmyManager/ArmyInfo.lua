local ArmyInfo = BaseClass("ArmyInfo")

local function __init(self)
	self.id = 0 		--兵种id + 等级
	self.free = 0 		--可以使用发兵
	self.cross = 0 		--跨服的兵
	self.train = 0 		--训练中的兵
	self.level = 0 		--兵的等级
	self.upgrade = 0 	--晋级中的兵
	self.march = 0 --出征中的兵
	self.prepare = 0--预备兵
end

local function __delete(self)
	self.id = nil
	self.free = nil
	self.cross = nil
	self.train = nil
	self.level = nil
	self.upgrade = nil
	self.march = nil
	self.prepare = 0--预备兵
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end

	self.id = message["id"]
	if message["free"] ~= nil then
		self.free = message["free"]
	else
		self.free = 0
	end
	if message["cross"] ~= nil then
		self.cross = message["cross"]
	else
		self.cross = 0
	end
	if message["march"] ~= nil then
		self.march = message["march"]
	else
		self.march = 0
	end
	if message["train"] ~= nil then
		self.train = message["train"]
	else
		self.train = 0
	end
	if message["upgrade"] ~= nil then
		self.upgrade = message["upgrade"]
	else
		self.upgrade = 0
	end
	if message["prepare"] then
		self.prepare = message["prepare"]
	else
		self.prepare = 0
	end
	--if message["level"]~=nil then
	--	self.level = message["level"]
	--else
		local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.id)
		if template~=nil then
			self.level = template.level
		end
	--end
	
	
end

local function GetAddValueEffectName(self)
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.id)
	if template ~= nil then
		return template:GetAddValueEffectName()
	end
end

local function UpdateFree(self,num)
	self.free = self.free + num
end

ArmyInfo.__init = __init
ArmyInfo.__delete = __delete
ArmyInfo.UpdateInfo = UpdateInfo
ArmyInfo.GetAddValueEffectName =GetAddValueEffectName
ArmyInfo.UpdateFree = UpdateFree
return ArmyInfo