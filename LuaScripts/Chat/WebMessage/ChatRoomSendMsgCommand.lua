--[[
    ---发送聊天消息
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomSendMsgCommand = BaseClass("ChatRoomSendMsgCommand", WebSocketBaseMessage)
local Localization = CS.GameEntry.Localization

local function getMsgExtra(post,media)
	-- 没有额外参数的话，就不不处理这个table了
	if post == nil and media == nil then
		return nil
	end
	
	local tbl = {}
	tbl["post"] = post
	if not string.IsNullOrEmpty(media) then
		tbl["media"] = media
	end
	return tbl
end

local function getChatData(chatData)
	local extraMsg = getMsgExtra(chatData.post, chatData.media)
	local param = {
		roomId = chatData.roomId,
		msg   = chatData.msg,
		sendTime  = chatData.sendLocalTime,
		extra     = extraMsg,
	}
	return param
end

local function OnCreate(self, chatData)
	local t = getChatData(chatData)
    self.tableData = t
end

local function HandleMessage(self, serverData)
	if (serverData ~= nil and serverData["result"] and serverData["result"]["code"]) then
		local expireTime = 0
		if (serverData["result"]["expireTime"]) then
			expireTime = serverData["result"]["expireTime"]
		end
		local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(expireTime)
		local strTips = Localization:GetString(serverData["result"]["code"], strExpireTime)
		UIUtil.ShowTips(strTips)
	end
     --ChatPrint("%s,%s", msg.cmd, msg.result.status)
end

ChatRoomSendMsgCommand.OnCreate = OnCreate
ChatRoomSendMsgCommand.HandleMessage = HandleMessage


return ChatRoomSendMsgCommand