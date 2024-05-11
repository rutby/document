---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by shimin.
--- DateTime: 2020/12/17 16:53
---

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomChangeNameMessage = BaseClass("PushRoomChangeNameMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local rapidjson = require "rapidjson"

local function OnCreate(self)

end

local function HandleMessage(self, serverData)

	-- 必须要逐步分解
	local msgs = RoomDataParser.DecodeMsgs(serverData)
	if msgs == nil then
		print("data nil")
		return
	end
	
	-- 加入改名消息
	local chatData = RoomDataParser.ProcessMsgs(msgs)
	
	-- 通知修改
	local roomMgr = ChatManager2:GetInstance().Room
    local roomData = roomMgr:GetRoomData(msgs.roomId)
	-- web服务器通过msg字段来把消息发送过来
	local roomName = msgs.msg
	
    if roomData then
        roomData:setName(roomName)
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_NAME, msgs.roomId)
    end 

	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_Enum_UpdateRoomOperateInfo)
	
end


PushRoomChangeNameMessage.OnCreate = OnCreate
PushRoomChangeNameMessage.HandleMessage = HandleMessage
return PushRoomChangeNameMessage