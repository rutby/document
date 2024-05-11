local ScienceDataManager = BaseClass("ScienceDataManager")
local ScienceInfo = require "DataCenter.ScienceData.ScienceInfo"
local function __init(self)
	self.allScience = {}  --itemId,scienceInfo
end

local function __delete(self)
	self.allScience = nil
end

local function InitData(self,message)
	if message["science_new"] ~= nil then
		self.allScience = {}
		for k,v in pairs(message["science_new"]) do
			self:UpdateOneData(v)
		end
	end
	if message["battleScienceOpenTime"] then
		self.battleScienceOpenTime = message["battleScienceOpenTime"]
	end
end

local function UpdateOneData(self,message)
	if message["itemId"] ~= nil then
		local id = message["itemId"]
		local one = self:GetScienceById(id)
		if one == nil then
			one = ScienceInfo.New()
			one:UpdateInfo(message)
			self.allScience[id] = one
		else
			one:UpdateInfo(message)
		end
	end
end

--通过科技id获取科技信息
local function GetScienceById(self,id)
	return self.allScience[id]
end

local function CheckIfBattleScienceOpen(self)
	local curTime = UITimeManager:GetInstance():GetServerTime()
	return self.battleScienceOpenTime and self.battleScienceOpenTime > 0 and self.battleScienceOpenTime < curTime
end



ScienceDataManager.__init = __init
ScienceDataManager.__delete = __delete
ScienceDataManager.InitData = InitData
ScienceDataManager.UpdateOneData = UpdateOneData
ScienceDataManager.GetScienceById = GetScienceById
ScienceDataManager.CheckIfBattleScienceOpen = CheckIfBattleScienceOpen


return ScienceDataManager