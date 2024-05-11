
local WebSocketBaseMessage = BaseClass("WebSocketBaseMessage")

local function NewEmpty(msgType)
	return msgType.New(true)
end

local function NewMessage(msgType, ...)
	return msgType.New(false, ...)
end

local function __init(self, isEmpty, ...)
	if not isEmpty then
		self.tableData = {}
		self:OnCreate(...)
	end
end

local function OnCreate(self)
end

local function HandleMessage(self, t)
end

local function OnDestroy(self)
end


local function __delete(self)
	self.tableData = nil
	self:OnDestroy()
end

WebSocketBaseMessage.__init = __init
WebSocketBaseMessage.NewEmpty = NewEmpty
WebSocketBaseMessage.NewMessage = NewMessage
WebSocketBaseMessage.OnCreate = OnCreate
WebSocketBaseMessage.HandleMessage = HandleMessage
WebSocketBaseMessage.OnDestroy = OnDestroy
WebSocketBaseMessage.__delete = __delete

return WebSocketBaseMessage