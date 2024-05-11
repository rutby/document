--[[
	设置用户信息

    改名字，换头像，换联盟会改变
    改变时都要发这个信息 以更新lastUpdateTime字段 ,当他再次说话时其他人检测到lastUpdateTime变更了会更新信息

]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local SetUserInfoCommand = BaseClass("SetUserInfoCommand", WebSocketBaseMessage)

local function OnCreate(self, lastUpdateTime)
	self.tableData.info = {}
	self.tableData.info.userName = ChatInterface.getPlayerName()
	--self.tableData.info.lang = ChatInterface.getLanguageName()
	self.tableData.info.abbr = ChatInterface.getAllianceAbbr()
	if (string.IsNullOrEmpty(self.tableData.info.abbr)) then
		self.tableData.info.abbr = nil
	end
	
	if not lastUpdateTime then
		lastUpdateTime = ChatInterface.getServerTime()
	end
	self.tableData.info.lastUpdateTime = lastUpdateTime
end

local function HandleMessage(self, msg)
    ChatPrint("SetUserInfoCommand %s,%s", msg.cmd, msg.result.status)
	
	--SFSNetwork.SendMessage(MsgDefines.GetUserInfoMulti, {ChatInterface.getPlayerUid()})
end

SetUserInfoCommand.OnCreate = OnCreate
SetUserInfoCommand.HandleMessage = HandleMessage

return SetUserInfoCommand