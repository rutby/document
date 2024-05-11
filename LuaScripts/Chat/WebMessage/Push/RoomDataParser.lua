--[[
	用来解析房间推送消息的工具
	这几个推送消息，基本上都是在serverData.data.msgs里包含着属性
	主要是推送类型，以及相关房间等
	然后在msg的主体消息中，即serverData.data.msgs.msg中包含着具体的成员信息
	一般是存着一个json
	注意：服务器中，角色必须要登录过聊天服务器，才可以从推送消息发送过来！！！
	角色登录聊天服务器是发送过消息：ChatMsgDefines.UserSetInfo
]]

local RoomDataParser = {}
local rapidjson = require "rapidjson"


--获取成员id
-- 聊天消息的实体msg中，装着uid列表的json
-- 但是有可能msg里面就只有一个uid
local function __ParseMemberUids(msg)
    local memberUids = {}
	
	local UserMgr = ChatManager2:GetInstance().User
	
	local memberArr = rapidjson.decode(msg)
	if memberArr == nil or type(memberArr) ~= "table" then
		if msg == ChatInterface.getPlayer().Uid then
			table.insert(memberUids, msg)
		else
			ChatPrint("??")
			table.insert(memberUids, msg)
		end
	else
		for uid, value in pairs(memberArr) do
			if value then
				table.insert(memberUids, uid)
				
				-- 带了一个senderInfo过来；这里先简单处理一下
				UserMgr:__processSenderInfo(uid, value)
			end
		end
	end
    
    return memberUids
end


function RoomDataParser.DecodeRoomInfo(serverData)

	if serverData.data == nil or serverData.data.roomInfo == nil then
		return nil
	end
	
	local roomInfo = serverData.data.roomInfo
	if type(roomInfo) == "string" then
		if string.IsNullOrEmpty(roomInfo) then
			return nil
		end
		roomInfo = rapidjson.decode(roomInfo)
	end
	
	return roomInfo
end


function RoomDataParser.DecodeMsgs(serverData)

	if serverData.data == nil or serverData.data.msgs == nil then
		return nil
	end

	local msgs = serverData.data.msgs
	if type(msgs) == "string" then
		if string.IsNullOrEmpty(msgs) then
			return nil
		end
		
		msgs = rapidjson.decode(msgs)
	end

	return msgs
end

-- 解析消息
-- 因为加入房间，退出房间等，都有一条系统消息，所以这个就是模拟系统消息的过程
-- 虽然目前看起来这个做法不是很好，但是之前就是这么设计的，暂时也没有时间去优化
function RoomDataParser.ProcessMsgs(msgs, action)
	if msgs == nil then
		return nil, nil
	end
	
	local roomMgr = ChatManager2:GetInstance().Room
	local chatData = roomMgr:CreateChatMessage()
	chatData:onParseServerData(msgs)
	roomMgr:AddChat(chatData, true)
	
	local roomData = roomMgr:GetRoomData(chatData.roomId)
	if roomData == nil then
		return nil, nil
	end
	
	-- 解析member
	local members = __ParseMemberUids(msgs.msg)
	if #members > 0 then
		if action == "add" then
			roomData:addMembers(members)
		elseif action == "remove" then
			roomData:removeMembers(members)
		elseif action == "quit" then
			roomData:removeMember(chatData.senderUid)
		end
	end
	
	return chatData, members
end

return RoomDataParser