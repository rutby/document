--[[
    解散房间 
]]

local ChatRoomDismissCommand = BaseClass("ChatRoomDismissCommand", SFSBaseMessage)

local function OnCreate(self, roomId)
	ChatPrint("Dismiss OnCreate: %s", roomId)
	self.sfsObj:PutUtfString("roomId", roomId)
end

local function HandleMessage(self, msg)
    ChatPrint("Dismiss HandleMessage: %s,%s", msg.cmd, msg.success)
end

ChatRoomDismissCommand.OnCreate = OnCreate
ChatRoomDismissCommand.HandleMessage = HandleMessage

return ChatRoomDismissCommand
