--[[
	所有世界的管理器，保存管理了所有服务器信息列表
	这个主要是用来做世界地图这个功能使用的
]]

local AllWorldsManager = BaseClass("AllWorldsManager")
local ServerListInfo = require "DataCenter.AllWorldsData.ServerListInfo"

function AllWorldsManager:__init()
	-- 是一个map: id, server
	self.serverList = {}
end

-- 获取服务器列表信息
function AllWorldsManager:GetServerListInfo(id)
	return self.serverList[id]
end


-- 服务器消息返回
function AllWorldsManager:onServerList(message)
	if message== nil then
		return 
	end
	local info = ServerListInfo.New()
	info:initFromNet(message)
	if info.serverId>0 then
		self.serverList[info.serverId] = info
	end
end

return AllWorldsManager

