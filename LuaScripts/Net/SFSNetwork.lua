
local MsgMap = require "Net.Config.MsgMap"
local Network = CS.GameEntry.Network
local MsgTypeMap = {}

local SFSNetwork = {}

local function GetMsgType(cmd)
	local msgType = MsgTypeMap[cmd]
	if msgType == nil then
		local msgTypePath = MsgMap[cmd]
		if msgTypePath ~= nil then
			msgType = require(msgTypePath);
			MsgTypeMap[cmd] = msgType
		end
	end
	return msgType;
end

function SFSNetwork.SendMessage(cmd, ...)
	local msgType = GetMsgType(cmd);
	local msg = msgType:NewMessage(...)
	Network:SendLuaMessage(cmd, msg:ToBinary())
end

function SFSNetwork.HandleMessage(cmd, t)
	local msgType = GetMsgType(cmd)
	if msgType ~= nil then
		local ok, errorMsg = xpcall(function()
			local msg = msgType:NewEmpty()
			msg:HandleMessage(t)
			return true
		end, debug.traceback)
		if not ok then
			local now = UITimeManager:GetInstance():GetServerSeconds()
			CommonUtil.SendErrorMessageToServer(now, now, errorMsg)
			Logger.LogError(errorMsg)
			return false
		else
			return true
		end
	end
	return false
end

return SFSNetwork