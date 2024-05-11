--[[
	向后端发送token 张胜坤说这个用于联盟聊天推送
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local SetTokenCommand = BaseClass("SetTokenCommand", WebSocketBaseMessage)

local function OnCreate(self, tbl)
  
    self.tableData = tbl
end

local function HandleMessage(self, serverData)
  
    local errCode = serverData["error"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    end
end

SetTokenCommand.OnCreate = OnCreate
SetTokenCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码，为了避免send带入，这里需要置nil
local function OnSend(param)
    param.send = nil
    WebSocketNetwork.SendMessage(ChatMsgDefines.SET_TOKEN_COMMAND, param)
end

function SetTokenCommand.create(roomId, roomName)
    if string.IsNullOrEmpty(roomId) or string.IsNullOrEmpty(roomName) then 
        -- ChatPrint("ChangeRoomNameCommand 参数不对")
        return nil
    end 

    local ret = {}
    ret.send = OnSend

    ret.token = {
        value = ChatInterface.getChatToken(),
        type  = ChatInterface.getChatTokenType(),
    }

    return ret
end
----------------------------------------------------------------


return SetTokenCommand