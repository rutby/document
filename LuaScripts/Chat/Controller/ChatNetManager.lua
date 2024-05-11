--[[ 
	聊天WebSocket管理器
	整个聊天登录即选路流程放到这里了
	同时发收发消息也放到这里了，因为理论上用户不需要知道CS.ChatService及WebSocket
]]

local ChatNetManager = BaseClass("ChatNetManager")
local rapidjson = require "rapidjson"
local ChatService = CS.ChatService.Instance
local Network = CS.GameEntry.Network

-- private变量
local CHAT_APP_ID = "100004"
local WS_SERVER_LIST_URL = "http://10.7.88.22:8082/server/links"

local CONNECT_NONE		= 0
local CONNECT_REQUEST	= 1
local CONNECT_OPENING	= 2
local CONNECT_OPENED	= 3	-- 已经建立连接了
local CONNECT_RUNNING	= 4 -- 已经收到服务器消息了
local CONNECT_CLOSEING	= 5	-- 
local CONNECT_CLOSED	= 6	-- 已经关闭了

local ChatMsgMapType = {}

local function GetMsgType(cmd)
	local msgType = ChatMsgMapType[cmd]
	if msgType == nil then
		local msgTypePath = ChatMsgMap[cmd]
		if msgTypePath ~= nil then
			msgType = require(msgTypePath);
			ChatMsgMapType[cmd] = msgType
		end
	end
	return msgType;
end

-------------------------------------------------------------------
-- C包装器
local WebSocketCImpl = {}

function WebSocketCImpl:Connect(p, ip, port)
	if self.c then
		self.c:connect(p, ip, port)
	else
		ChatPrint('WebSocketCImpl:Connect not ready')
	end
end

function WebSocketCImpl:IsOpen()
	if self.c then
		return self.c:is_connect()
	else
		ChatPrint('WebSocketCImpl:IsOpen not ready')
		return false
	end
end

function WebSocketCImpl:SendLuaMessage(json)
	if self.c then
		self.c:send(json)
	else
		ChatPrint('WebSocketCImpl:SendLuaMessage not ready')
	end
end

function WebSocketCImpl:SendLuaTable(tbl)
	if self.c then
		self.c:sendtable(tbl)
	else
		ChatPrint('WebSocketCImpl:SendLuaTable not ready')
	end	
end

function WebSocketCImpl:Disconnect()
	if self.c then
		self.c:close()
		self.c = nil
	end
end
-------------------------------------------------------------------	


-------------------------------------------------------------------
--[[
事件通知函数；主要是从C#通知过来。
onRequest: 请求服务器列表返回
onOpen: 建立连接
onClose: 关闭连接
onError: 连接错误
]]
function ChatNetManager:__onRequest(param)

	-- 请求返回后，先置网络状态
	self:__setStatus(CONNECT_NONE)
	
	local respon = nil
	
	if not (string.IsNullOrEmpty(param)) then
		respon = rapidjson.decode(param)
	end
	
	if respon == nil then
		ChatPrint("__onRequest but param is empty?")
		self:__doRetryConnect()
		return
	end

	-- 如果成功的话，就解析这个json
	self.requestList = respon

	if (respon.code == 1) then
		self.connect_count = 0
		self:Connect()
	else
		-- 服务器不让连，几秒后再连。。。
		self:__doRetryConnect()
	end

end

function ChatNetManager:__onOpen(param)
	self.connect_count = 0
	self:__setStatus(CONNECT_OPENED)
	ChatPrint("onOpen")
end

function ChatNetManager:__onClose(param)
	ChatPrint("onClose")
	
	-- 只有已经处于连接状态的时候才去发送断开消息
	if self.connect_status == CONNECT_RUNNING then
		ChatManager2:GetInstance():onErrorOrDisconnect()
	end
	-- 这里不用判断了，无脑重连，如果是用户主动关闭了聊天，那么重连标志就是false
	self:__setStatus(CONNECT_CLOSED)
	self:__doRetryConnect()
end

function ChatNetManager:__onError(param)
	ChatPrint("onError")
	
	if self.connect_status == CONNECT_RUNNING then
		ChatManager2:GetInstance():onErrorOrDisconnect()
	end
	self:__setStatus(CONNECT_CLOSED)
	self:__doRetryConnect()
end

-- 接收json消息
function ChatNetManager:__onMessage(param)	
	local data = rapidjson.decode(param)
	self:__onMessageTable(data)
end

-- 接收table消息
function ChatNetManager:__onMessageTable(tbl)
	
	self:__setStatus(CONNECT_RUNNING)

	--Logger.Log("WebSocketNetwork.HandleMessage")
	local cmd = tbl.cmd
	ChatPrint("websocket push : " .. cmd)
	if cmd ~= nil then
		local msgType = GetMsgType(cmd)
		if msgType ~= nil then
			local msg = msgType:NewEmpty()
			msg:HandleMessage(tbl)
		end
	end
end

-- 重新连接
function ChatNetManager:__doRetryConnect()
	
	-- 一般是游戏已经关闭了，不再进行重连
	if self.do_retry == false then
		ChatPrint("not do retry!")
		return 
	end
	
	if self.retryTimer ~= nil then
		ChatPrint("Already in retry!")
		return
	end
	
	-- 因为timer没有标识，所以这里用个变量来标识一下
	ChatPrint("__doRetryConnect begin!")
	self.retryTimer = TimerManager:GetInstance():DelayInvoke(
		function()
			ChatPrint("__doRetryConnect time up, retry!")
			self.connect_count = 0
			self.retryTimer = nil
			self:Connect()
		end, 3)

end

function ChatNetManager:__stopRetryTimer()
	if self.retryTimer then
		self.retryTimer:Stop()
		self.retryTimer = nil
	end
end

function ChatNetManager:__stopReqTimer()
	if self.req_timer then
		self.req_timer:Stop()
		self.req_timer = nil
	end
end


-------------------------------------------------------------------

-- 构造函数
function ChatNetManager:__init()
	self.request_count = 0
	self.request_no = 1		-- 请求编号
	self.requestList = nil
	self.cur_server = 1
	self.connect_count = 0
	self.connect_status = CONNECT_NONE
	self.req_timer = nil -- 请求服务器列表重试
	self.retry_timer = nil	-- 重连计时器
	self.do_retry = false -- 是否开启重连
	self.WebSocketInst = ChatService -- ws连接器
end

function ChatNetManager:InitWebSocketInst()
	
	--if true then
	if LuaEntry.WebSocket == nil then
		self.WebSocketInst = ChatService
		return
	end
	
	-- 如果能用C的话，就用C的ws
	self.WebSocketInst = WebSocketCImpl
	if WebSocketCImpl.c then
		ChatPrint('WebSocketCImpl:Init already connect!!!')
		WebSocketCImpl.c:close()
	end

	local c = LuaEntry.WebSocket.create()
	if c == nil then
		return false
	end

	local time = ChatInterface.getServerTime()
	local uid = ChatInterface.getPlayerUid()
	local sign = cutils.CalcChatSign(CHAT_APP_ID, uid, time)

	c:addheader("APPID", CHAT_APP_ID)
	c:addheader("TIME", tostring(time))
	c:addheader("UID", uid)
	c:addheader("SIGN", sign)
	
	c:setdelegate(function (e, p, no)
			self:__onCallback(e, p, no)
		end)
	
	-- 这个必须要在setdelegate之后调用。潜规则，暂时先如此
	c:setrecvtable()
	
	-- 注意这两个参数必须要一起用才有pingpong的效果，具体原因不明
	c:enableping(20)
	c:autoclose(45)

	WebSocketCImpl.c = c

	return true
end

-- 连接服务器
function ChatNetManager:Connect()
	
	-- 在连接中和关闭中都直接返回即可
	if self.connect_status == CONNECT_OPENING then
		ChatPrint("already in connect!")
		return
	end
	
	--if self.connect_status == CONNECT_CLOSED then
		--ChatPrint("already closed!")
		--return
	--end
	
	if self.requestList == nil or self.requestList.data == nil or #self.requestList.data == 0 then
		ChatPrint("no connect data!")
		return
	end
	
	local index = 1
	if LuaEntry.DataConfig:CheckSwitch("ChangeChatServerWhenReconnect") then
		index = Setting:GetPrivateInt(SettingKeys.CHAT_CONNECT_SERVER_INDEX, 0)
		index = index + 1
		if index > #self.requestList.data then
			index = 1
		end
		Setting:SetPrivateInt(SettingKeys.CHAT_CONNECT_SERVER_INDEX, index)
	end
	
	local currentServer = self.requestList.data[index]
	ChatPrint("Connect : %s on %s:%d", currentServer.protocol, currentServer.ip, currentServer.port)
	
	-- 每次connect都创建一个
	self:InitWebSocketInst()
	
	-- 不用检测他是否连接超时了，连接超时回返回OnError
	self:__setStatus(CONNECT_OPENING)
	self.do_retry = true
	self.WebSocketInst:Connect(currentServer.protocol, currentServer.ip, currentServer.port)
	--ChatService:Connect(currentServer.protocol, currentServer.ip, 22222)
	
	return
end

-- 聊天是否运行中
function ChatNetManager:IsRunning()
	return (self.connect_status == CONNECT_RUNNING)
end

-- 设置连接状态
function ChatNetManager:__setStatus(status)
	self.connect_status = status
	ChatPrint("set status : %d", status)
end

-- 聊天初始化，要使用gameuid
function ChatNetManager:Init(gameuid)
	
	ChatPrint("ChatNetManager:Init %s", tostring(gameuid))
	
	if ChatInterface.isDebug() then
		CHAT_APP_ID = "100004"
		WS_SERVER_LIST_URL = "http://10.7.88.22:8082/server/links"
	elseif CS.GameEntry.GlobalData:isChina() then
		CHAT_APP_ID = "100004"
		WS_SERVER_LIST_URL = "http://cn-chat-gate-aps.first.fun/server/links"
	else
		CHAT_APP_ID = "100004"
		WS_SERVER_LIST_URL = "http://chat.gate.ds.metapoint.club/server/links"
	end
	
	ChatService:Init(CHAT_APP_ID, gameuid, 
		function (e, p, no) 
			self:__onCallback(e, p, no)
		end)
	
	-- 请求服务器列表
	self.request_count = 0
	self:RequestServerList(WS_SERVER_LIST_URL)
	
end

function ChatNetManager:Uninit()
	ChatPrint("ChatNetManager:Uninit")
	
	self:CloseWebSocket()
	ChatService:Uninit()
end

-- 消息回调函数
-- 把onMessage放到最前面，比较容易命中。。。。
function ChatNetManager:__onCallback(e, p, no)
	ChatPrint("[callback] (%d) - %s", no or 0, e)

	if e == "onMessage" then
		self:__onMessage(p)
	elseif e == "onMessageTable" then
		self:__onMessageTable(p)
	elseif e == "onRequest" then
		self:__onRequest(p)
	elseif e == "onOpen" then
		self:__onOpen()
	elseif e == "onClose" then
		self:__onClose()
	elseif e == "onError" then
		self:__onError(p)
	else
		ChatPrint("ChatManager2:Init ???" .. e)
	end
end

-- 请求服务器的数据
function ChatNetManager:RequestServerList()
	
	if (self.connect_status ~= CONNECT_NONE) and (self.connect_status ~= CONNECT_CLOSED) then
		ChatPrint("RequestServerList status error? stauts = %s", tostring(self.connect_status))
	end
	
	self.do_retry = true
	self:__setStatus(CONNECT_REQUEST)
	self.request_no = self.request_no + 1
	
	ChatPrint("RequestServerList - %d", self.request_no)
			
	ChatService:RequestServerList(WS_SERVER_LIST_URL, self.request_no)
end

-- 发送SFS消息
function ChatNetManager:SendSFSMessage(cmd, ...)
	Logger.Log("SendMessage: ", cmd)
	local msgType = GetMsgType(cmd);
	local msg = msgType:NewMessage(...)
	Network:SendLuaMessage(cmd, msg:ToBinary())
end

-- 发送websocket消息
function ChatNetManager:SendMessage(cmd, ...)
	Logger.Log("WebSocketNetwork SendMessage: ", cmd)
	local msgType = GetMsgType(cmd);
	local msg = msgType:NewMessage(...)

	local dataTbl = {}
	dataTbl["cmd"] = cmd
	dataTbl["params"] = msg.tableData

	if msg.tableData.sendTime then
		dataTbl["sendTime"] = msg.tableData.sendTime
	else
		dataTbl["sendTime"] = math.modf(UITimeManager:GetInstance():GetServerTime())
	end
	
	self:SendTableMessage(dataTbl)
end

-- 发送table数据
-- C接口直接发送一个table。C#接口需要转换成json再发送
function ChatNetManager:SendTableMessage(dataTbl)
	local WS = self.WebSocketInst
	if (WS == WebSocketCImpl) then
		WS:SendLuaTable(dataTbl)
	else
		local jsonData = rapidjson.encode(dataTbl)
		WS:SendLuaMessage(jsonData)
	end
end

function ChatNetManager:CloseWebSocket()
	ChatPrint("CloseWebSocket!!!")
	-- 主动关闭web socket，需要做一个标志；否则系统网络断开，又开始重连了
	self.do_retry = false
	if self.connect_status == CONNECT_RUNNING then
		ChatManager2:GetInstance():onErrorOrDisconnect()
	end
	self:__setStatus(CONNECT_CLOSEING)
	self:__stopRetryTimer()
	self:__stopReqTimer() 
	self.WebSocketInst:Disconnect()
	self:__setStatus(CONNECT_CLOSED)
end

function ChatNetManager:OnHandleMessage(cmd, t)
	if t ~= nil and t.errorCode ~= nil then
		Logger.LogError(cmd .. " has error code: ", t.errorCode)
	else
		Logger.Log("HandleMessage: ", cmd)
	end

	local msgType = GetMsgType(cmd)
	if msgType ~= nil then
		local msg = msgType:NewEmpty()
		msg:HandleMessage(t)
		return true
	end

	return false
end
	
return ChatNetManager

