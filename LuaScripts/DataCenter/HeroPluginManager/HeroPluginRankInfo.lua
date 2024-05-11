--- Created by shimin.
--- DateTime: 2023/7/19 11:05
--- 英雄插件排行信息

local HeroPluginRankInfo = BaseClass("HeroPluginRankInfo")

function HeroPluginRankInfo:__init()
	self.uid = 0
	self.rank = 0
	self.score = 0
	self.serverId = 0
	self.name = ""
	self.pic = ""
	self.picVer = 0
	self.plugin = {}
	self.lv = 0
	self.allianceAbbr = ""
	self.allianceName = ""
	self.heroId = 0
	self.country = ""
	self.serverId = 0
end

function HeroPluginRankInfo:__delete()
	self.uid = 0
	self.rank = 0
	self.score = 0
	self.serverId = 0
	self.name = ""
	self.pic = ""
	self.picVer = 0
	self.plugin = {}
	self.lv = 0
	self.allianceAbbr = ""
	self.allianceName = ""
	self.heroId = 0
	self.country = ""
	self.serverId = 0
end

function HeroPluginRankInfo:UpdateInfo(message)
	if message == nil then
		return
	end
	
	self.uid = message["uid"]
	self.rank = message["rank"] or 0
	self.score = message["score"] or 0
	self.serverId = message["serverId"] or 0
	self.name = message["name"] or ""
	self.pic = message["pic"] or ""
	self.picVer = message["picVer"] or 0
	self.plugin = {}
	local temp = message["plugin"]
	if temp ~= nil and temp ~= "" then
		local spl = string.split_ss_array(temp, ";")
		for k, v in ipairs(spl) do
			local spl1 = string.split_ii_array(v, ",")
			local param = {}
			param.id = spl1[1] or 0
			param.level = spl1[2] or 0
			table.insert(self.plugin, param)
		end
	end
	
	self.lv = message["lv"] or 0
	self.allianceAbbr = message["abbr"] or ""
	self.allianceName = message["allianceName"] or ""
	self.heroId = message["heroId"] or 0
	self.country = message["country"] or ""
	self.serverId = message["serverId"] or 0
end

return HeroPluginRankInfo