--[[
    目的:
    这个协议主要用些界面下拉请求历史消息

    界面下拉请求请求历史消息
    单个房间push N条历史记录
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetHistoryMsgsByTimeCommand = BaseClass("GetHistoryMsgsByTimeCommand", WebSocketBaseMessage)

-- FIXME: 目前服务器有个bug，他固定每次都返回40条消息。
-- 如果目前历史消息过少的话，就会导致拉回来的消息会有和现有消息重叠的情况

local function setRoomId(roomId)
	local roomMgr = ChatManager2:GetInstance().Room
	local roomData = roomMgr:GetRoomData(roomId)
	
	-- 这里获取的是一个ms时间
	local firstTime = tonumber(roomData:GetFirstMsgServerTime())
	
	local tbl = {}
	tbl["roomId"] = roomData.roomId
	tbl["start"] = 0
	tbl["end"] = toInt(firstTime / 1000) + 1
	
	ChatPrint("++ req roomId : %s, time : %f..... first id : %d, MsgTime : %f", 
		tbl["roomId"], tbl["end"], roomData.firstSeqId, roomData.firstMsgTime)
	
	--(roomData:getToTalNum() == 0) and 0 or roomData.msgs[1]:getServerTime()
	
	return tbl
end

local function OnCreate(self, roomId)
	local tbl = setRoomId(roomId)
    self.tableData = tbl
end

local function HandleMessage(self, handle)
	local roomMgr = ChatManager2:GetInstance().Room
	local userMgr = ChatManager2:GetInstance().User
	
    if handle.result and (not table.IsNullOrEmpty(handle.result.msg)) then
		local msg = handle.result.msg
		
		--for k,v in pairs(msg) do
			--ChatPrint("++ msg id: %d, time : %f.", v.seqId, v.serverTime)
		--end
		
		local first = msg[1]
		roomMgr:onParseServerChatData(first.roomId, msg)
		userMgr:__processAllUserInfos()

		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_RESULT, true)
    else
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REQUEST_HISTORY_MSG_RESULT, false)
    end

end

GetHistoryMsgsByTimeCommand.OnCreate = OnCreate
GetHistoryMsgsByTimeCommand.HandleMessage = HandleMessage

return GetHistoryMsgsByTimeCommand