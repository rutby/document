--[[
	房间解散推送
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomDismissMessage = BaseClass("PushRoomDismissMessage", WebSocketBaseMessage)


local function OnCreate(self)

end

local function HandleMessage(self, serverData)
	if string.IsNullOrEmpty(serverData.data) then
		ChatPrint("PushDismiss: no serverdata")
		return
	end
	
	local roomId = serverData.data
	ChatPrint("PushDismiss HandleMessage: " .. roomId)
	
	local roomMgr = ChatManager2:GetInstance().Room
    roomMgr:RemoveRoomData(roomId)
	
	-- 这里还要离开房间？多此一举？？？
	--ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, roomId)
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
end

PushRoomDismissMessage.OnCreate = OnCreate
PushRoomDismissMessage.HandleMessage = HandleMessage
return PushRoomDismissMessage