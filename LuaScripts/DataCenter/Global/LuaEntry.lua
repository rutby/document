--[[
	LUA端的全局数据，类似GameEntry.Data
	每次消息回来都重新new一个，防止数据串乱

	这个主要管理一些游戏系统中常用但是未分组的数据
	譬如：
		PlayerInfo
		GlobalData	全局数据
		GlobalValue	全局变量
		Resource
		World		世界上的一些下发数据
		DataConfig	游戏配置数据
]]


local LuaEntry = {}

local PlayerInfo = require "DataCenter.Global.PlayerInfo"
local GlobalData = require "DataCenter.Global.GlobalData"
local ResourceInfo = require "DataCenter.Global.ResourceInfo"
local DataConfig = require "DataCenter.Global.DataConfig"
local EffectData = require "DataCenter.Global.EffectData"
-- 初始化
function LuaEntry:init()
	self.Player = PlayerInfo.New()
	self.Resource = ResourceInfo.New()
	self.GlobalData = GlobalData.New()
	self.DataConfig = DataConfig.New()
	self.Effect = EffectData.New()
	
	-- 初始化C模块
	--local ret = self:__InitCModule()
	--if not ret then
		--LuaEntry:__UninitCModule()
	--end
end

function LuaEntry:Uninit()
	self:__UninitCModule()
end

------------------------------------------------------------------
-- C 模块相关的代码
-- C Module的异步更新器
local function AsyncUpdate()
	if LuaEntry.Async then
		LuaEntry.Async.Async_Update()
	end
end

function LuaEntry:__UninitCModule()
	if LuaEntry.Async then
		UpdateManager:GetInstance():RemoveUpdate(AsyncUpdate)
		LuaEntry.Async.Async_Uninit()
	end
	
	self.Sqlite = nil
	self.WebSocket = nil
	self.Async = nil
end

-- 初始化C的几个模块，这个整个游戏间初始化一次就够了
function LuaEntry:__InitCModule()
	-- 初始化xlua内部的几个组件
	if (_G["rg_sqlite"] ~= nil) then
		self.Sqlite = _G["rg_sqlite"]
	else
		return false
	end

	if (_G["rg_async"] ~= nil) then
		self.Async = _G["rg_async"]
		self.Async.Async_Init()

		UpdateManager:GetInstance():AddUpdate(AsyncUpdate)
	else
		return false
	end

	local luaopen_websocket = package.loadlib("xlua", "luaopen_websocket")
	if (_G["rg_websocket"] ~= nil) then
		self.WebSocket = _G["rg_websocket"]
	else
		return false
	end

	--local luaopen_cutils = package.loadlib("xlua", "luaopen_cutils")
	--if luaopen_cutils then
	--	luaopen_cutils()
	--else
	--	return false
	--end
	-- print("user C Module!!")
	return true
end
-- C 模块相关的代码
------------------------------------------------------------------


function LuaEntry:onMessage(data)
	self.GlobalData:InitFromNet(data)
	if self.Player ==nil then
		self.Player = PlayerInfo.New()
	end
	self.Player:InitFromNet(data)
	
	self.DataConfig:InitFromNet(data)
	
	self.Effect = EffectData.New()
	self.Effect:InitFromNet(data)

	self.Resource = ResourceInfo.New()
	self.Resource:InitFromNet(data)
end

function LuaEntry:LoadDataConfig()
	self.DataConfig = DataConfig.New()
	self.DataConfig:InitFromTable()
end
return LuaEntry

