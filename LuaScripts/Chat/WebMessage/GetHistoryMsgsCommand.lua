--[[
    目的：
    这个协议主要用于登录时请求历史最新消息,因为你没在登录时其他人也在不停的发送消息,
    这个时候本地数据库就不是最新的了，所以要请求最新历史消息

    根据房间id和时间请求服务器聊天数据
    每个房间push N条历史记录
]]


local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetHistoryMsgsCommand = BaseClass("GetHistoryMsgsCommand", WebSocketBaseMessage)


local function setRoomIds(ids)
	local idToTimes = {}
	for _,id in ipairs(ids) do
		idToTimes[id] = "0" --tostring(ChatInterface.getServerTime())  服务器说 ：0时返回最近20条
	end
	return idToTimes
end

local function OnCreate(self, ids)
	local t = setRoomIds(ids)
    self.tableData.rooms = t
end

local function HandleMessage(self, msg)

	-- 获取到了所有房间的最近一些消息	
	ChatManager2:GetInstance().Room:onRequestLatestMsg(msg)
	
	-- 如果是游戏第一次获取到房间等，这个地方要做一个处理。要和数据库同步
	ChatManager2:GetInstance().Room:onJoinRoomOK()

	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ENTER_ROOM_OK)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_RESULT)
end

GetHistoryMsgsCommand.OnCreate = OnCreate
GetHistoryMsgsCommand.HandleMessage = HandleMessage

return GetHistoryMsgsCommand