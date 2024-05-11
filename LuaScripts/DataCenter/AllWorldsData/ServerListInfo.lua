--[[
	表示一个服务器信息
]]

local ServerListInfo = BaseClass("ServerListInfo")

function ServerListInfo:__init()
	
	self.serverId = -1
	self.openTime = 0
	self.alName = ""
	self.allianceId = ""
	self.alAbbr = ""
	self.alCounty = ""
	self.alIcon = ""
	self.leaderName = ""
end

function ServerListInfo:initFromNet(dict)
	if dict["sId"]~=nil then
		self.serverId = dict["sId"]
	end
	if dict["openTime"]~=nil then
		self.openTime = dict["openTime"]
	end
	if dict["alCity"]~=nil then
		local alCityData = dict["alCity"]
		if alCityData["alId"]~=nil then
			self.allianceId = alCityData["alId"]
		end
		if alCityData["alAbbr"]~=nil then
			self.alAbbr = alCityData["alAbbr"]
		end
		if alCityData["alName"]~=nil then
			self.alName = alCityData["alName"]
		end
		if alCityData["alIcon"]~=nil then
			self.alIcon = alCityData["alIcon"]
		end
		if alCityData["alCounty"]~=nil then
			self.alCounty = alCityData["alCounty"]
		end
		if alCityData["leaderName"]~=nil then
			self.leaderName = alCityData["leaderName"]
		end
	end
end

function ServerListInfo:IsHaveAlliance()
	if self.allianceId~=nil and self.allianceId~="" then
		return true
	end
	return false
end



return ServerListInfo