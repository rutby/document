--[[
	创建聊天房间命令
	type = 0 自定义房间
	type = 1 私聊
]]

local CreateChatRoomCommand = BaseClass("CreateChatRoomCommand", SFSBaseMessage)

local function OnCreate(self, param)

	if param.type then
		self.sfsObj:PutLong("type", param.type)
	end

	self.sfsObj:PutUtfString("name", param.name)

	-- 创建房间时携带的用户列表
	-- 这个memberList可以是一个;分割的字符串，也可以是一个member table array！
	local memberList = param.memberList
	if type(memberList) == "string" then
		memberList = string.split(memberList, ";")
	end
	
	if type(memberList) == "table" then
		self.sfsObj:PutLuaArray("members", memberList)
	else
		print("member error!!!")
	end
	
end

local function HandleMessage(self, t)
	if t["errorCode"] then
		local hintString = ChatInterface.getString(t["errorCode"])
		ChatInterface.flyHint(hintString)
	end
	EventManager:GetInstance():Broadcast(EventId.ChatRoomCreate, t["success"])
end

CreateChatRoomCommand.OnCreate = OnCreate
CreateChatRoomCommand.HandleMessage = HandleMessage

return CreateChatRoomCommand
