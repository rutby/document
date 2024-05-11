--[[
	获取自定义聊天房间列表
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetCustomRoomListCommand = BaseClass("GetCustomRoomListCommand", WebSocketBaseMessage)
local rapidjson = require "rapidjson"

local function OnCreate(self, tbl)
    self.tableData.group = "custom"
end

local function HandleMessage(self, data)
    
    local result = data.result
    if result == nil then 
		return 
	end

	local roomMgr = ChatManager2:GetInstance().Room
	local rooms = result.rooms
	local ids = {}
	
    for roomId,jsonStr in pairs(rooms) do
        local roomInfo = rapidjson.decode(jsonStr)
		
        if roomInfo then 
			local room = roomMgr:CreateChatRoom(roomInfo.roomId, roomInfo.group)
			room:onParseServerData(roomInfo)
            table.insert(ids, roomId)
        end
    end

    if #ids > 0 then 
		-- 获取到房间之后，再去请求每个custom房间的最后20条消息
		roomMgr:requestMultiRoomLatestMsg(ids)
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
    end 
   
end

GetCustomRoomListCommand.OnCreate = OnCreate
GetCustomRoomListCommand.HandleMessage = HandleMessage

return GetCustomRoomListCommand