--[[
-- added by wsh @ 2017-11-28
-- 消息系统
-- 使用范例：
-- local Messenger = require "Framework.Common.Messenger";
-- local TestEventCenter = Messenger.New() --创建消息中心
-- TestEventCenter:AddListener(Type, callback) --添加监听
-- TestEventCenter:AddListener(Type, callback, ...) --添加监听
-- TestEventCenter:Broadcast(Type, ...) --发送消息
-- TestEventCenter:RemoveListener(Type, callback, ...) --移除监听
-- TestEventCenter:Cleanup() --清理消息中心
-- 注意：
-- 1、模块实例销毁时，要自动移除消息监听，不移除的话不能自动清理监听
-- 2、使用弱引用，即使监听不手动移除，消息系统也不会持有对象引用，所以对象的销毁是不受消息系统影响的
-- 3、换句话说：广播发出，回调一定会被调用，但回调参数中的实例对象，可能已经被销毁，所以回调函数一定要注意判空
--]]

local Messenger = BaseClass("Messenger");

local function __init(self)
	self.events = {}
	self.emptyTableList = {}
end

local function __delete(self)
	self.events = nil	
	self.error_handle = nil
	self.emptyTableList = nil
end

local function __popATable(self)
	local c = #self.emptyTableList
	local ret
	if c > 0 then
		ret = self.emptyTableList[c]
		self.emptyTableList[c] = nil
	else
		ret = {}
	end	
	
	return ret
end

local function __recycleATable(self, t)
	if t and t.n == nil and #t == 0 then
		table.insert(self.emptyTableList, t)
	end
end

local function AddListener(self, e_type, e_listener, ...)
	local event = self.events[e_type]
	if event == nil then
		event = setmetatable({}, {__mode = "k"})
		self.events[e_type] = event
	end

	if event[e_listener] ~= nil then
		error("Aready cotains listener : " .. tostring(e_listener))
		return
	end

	--Logger.Log("add event id:"..e_type.."name:"..tostring(e_listener))
	if select('#', ...) == 0 then
		event[e_listener] = __popATable(self)
	else
		event[e_listener] = setmetatable(SafePack(...), {__mode = "kv"}) 
	end
end

local function Broadcast(self, e_type, ...)
	local event = self.events[e_type]
	if event == nil then
		return
	end
	
	local arglen = select("#", ...)
	local ok, msg
	
	--防止boradcast執行中执行AddListener造成events列表错乱,复制一份执行
	local tmp_event = __popATable(self)
	for k, v in pairs(event) do
		tmp_event[k] = v
	end
	
	-- 减少lua的gc，这里没必要每次都concat
	for k, v in pairs(tmp_event) do
		--Logger.Log("event start event id:"..e_type.."name:"..tostring(k))
		local vlen = v.n and v.n or #v
		if arglen > 0 and vlen > 0 then
			local args = ConcatSafePack(v, SafePack(...))
			ok, msg = xpcall(k, debug.traceback, SafeUnpack(args))
		elseif vlen > 0 then
			ok, msg = xpcall(k, debug.traceback, table.unpack(v, 1, vlen))
		elseif arglen > 0 then
			ok, msg = xpcall(k, debug.traceback, ...)
		else
			ok, msg = xpcall(k, debug.traceback)
		end
		--Logger.Log("event over event id:"..e_type.."name:"..tostring(k))
		if not ok then
			local now = UITimeManager:GetInstance():GetServerSeconds()
			CommonUtil.SendErrorMessageToServer(now, now, msg)
			Logger.LogError(msg)
		end
	end
end

local function RemoveListener(self, e_type, e_listener)
	local event = self.events[e_type]
	if event == nil then
		return
	end

	self:__recycleATable(event[e_listener])
	event[e_listener] = nil
end

local function RemoveListenerByType(self, e_type)
	self.events[e_type] = nil
end

local function Cleanup(self)
	self.events = {}
end

Messenger.__init = __init
Messenger.__delete = __delete
Messenger.__popATable = __popATable
Messenger.__recycleATable = __recycleATable
Messenger.AddListener = AddListener
Messenger.Broadcast = Broadcast
Messenger.RemoveListener = RemoveListener
Messenger.RemoveListenerByType = RemoveListenerByType
Messenger.Cleanup = Cleanup

return Messenger;