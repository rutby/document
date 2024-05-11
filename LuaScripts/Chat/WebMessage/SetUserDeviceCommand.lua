--[[
	设置设备信息
    这个协议之前原生的代码只有ios发了 ，这里我全发了
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local SetUserDeviceCommand = BaseClass("SetUserDeviceCommand", WebSocketBaseMessage)


local function OnCreate(self, tbl)
    self.tableData = tbl
end

local function HandleMessage(self, serverData)
  
end

SetUserDeviceCommand.OnCreate = OnCreate
SetUserDeviceCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码，为了避免send带入，这里需要置nil
local function OnSend(param)
    param.send = nil
    WebSocketNetwork.SendMessage(ChatMsgDefines.SET_USER_DEVICE_COMMAND, param)
end

function SetUserDeviceCommand.create(roomId, roomName)
    if string.IsNullOrEmpty(roomId) or string.IsNullOrEmpty(roomName) then 
        -- ChatPrint("ChangeRoomNameCommand 参数不对")
        return nil
    end 

    local ret = {}
    ret.send = OnSend

    local info = {
                deviceType = ChatInterface.getDeviceType(),
                systemVerson = ChatInterface.getSystemVersion(),
                deviceName = ChatInterface.getDeviceName(),
                appVersion = ChatInterface.getVersionName(),
                appName  =  ChatInterface.getAppName(),
                serverNum = ChatInterface.getPlayerServerId()
            }

    ret.info = info

    return ret
end
----------------------------------------------------------------

return SetUserDeviceCommand