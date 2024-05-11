--[[
-- added by wsh @ 2017-12-18
-- 定时器管理：负责定时器获取、回收、缓存、调度等管理
-- 注意：
-- 1、任何需要定时更新的函数从这里注册，游戏逻辑层最好使用不带"Co"的接口
-- 2、带有"Co"的接口都是用于协程，它的调度会比普通更新后一步---次序依从Unity函数调用次序：https://docs.unity3d.com/Manual/ExecutionOrder.html
-- 3、UI界面倒计时刷新等不需要每帧去更新的逻辑最好用定时器，少用Updatable，定时器能很好避免频繁的无用调用
-- 4、定时器并非精确定时，误差范围和帧率相关
-- 5、循环定时器不会累积误差，这点和Updater的Update函数自己去控制时间刷新是一致的，很好用
-- 6、定时器是weak表，使用临时对象时不会持有引用
-- 7、慎用临时函数、临时闭包，所有临时对象要外部自行维护引用以保障生命周期，否则会被GC掉===>很重要***
-- 8、考虑到定时器可能会被频繁构造、回收，这里已经做了缓存池优化
--]]

local TimerManager = BaseClass("TimerManager", Singleton)

-- 构造函数
local function __init(self)
	-- handle
	self.__update_handle = nil
	self.__coupdate_handle = nil
	-- 定时器列表
	self.__update_timer = {}
	self.__coupdate_timer = {}
	-- 定时器缓存
	--self.__pool = {}
	-- 待添加的定时器列表
	self.__update_toadd = {}
	self.__coupdate_toadd = {}
end

-- 延后回收定时器，必须全部更新完毕再回收，否则会有问题
local function DelayRecycle(self, timers)
	for timer,_ in pairs(timers) do
		if timer:IsOver() then
			timer:Stop()
			--table.insert(self.__pool, timer)
			timers[timer] = nil
		end
	end
end

-- Update回调
local function UpdateHandle(self)
	-- 更新定时器
	for timer,_ in pairs(self.__update_toadd) do
		self.__update_timer[timer] = true
		self.__update_toadd[timer] = nil
	end
	for timer,_ in pairs(self.__update_timer) do
		--if timer.target_obj~=nil then
		--	Logger.Log("updateStart class name:"..timer.target_obj._class_type.__cname)
		--end
		timer:Update()
		--if timer.target_obj~=nil then
		--	Logger.Log("updateFinish class name:"..timer.target_obj._class_type.__cname)
		--end
		
	end
	DelayRecycle(self, self.__update_timer)
end


-- CoUpdate回调
local function CoUpdateHandle(self)
	-- 更新定时器
	for timer,_ in pairs(self.__coupdate_toadd) do
		self.__coupdate_timer[timer] = true
		self.__coupdate_toadd[timer] = nil
	end
	for timer,_ in pairs(self.__coupdate_timer) do
		timer:Update()
	end
	DelayRecycle(self, self.__coupdate_timer)
end

-- 启动
local function Startup(self)
	self:Dispose()
	self.__update_handle = UpdateBeat:CreateListener(UpdateHandle, TimerManager:GetInstance())
	self.__coupdate_handle = CoUpdateBeat:CreateListener(CoUpdateHandle, TimerManager:GetInstance())
	UpdateBeat:AddListener(self.__update_handle)
	CoUpdateBeat:AddListener(self.__coupdate_handle)
end

-- 释放
local function Dispose(self)
	if self.__update_handle ~= nil then
		UpdateBeat:RemoveListener(self.__update_handle)
		self.__update_handle = nil
	end
	if self.__coupdate_handle ~= nil then
		CoUpdateBeat:RemoveListener(self.__coupdate_handle)
		self.__coupdate_handle = nil
	end
	self:Cleanup()
end

-- 清理：可用在场景切换前，不清理关系也不大，只是缓存池不会下降
local function Cleanup(self)
	self.__update_timer = {}
	self.__coupdate_timer = {}
	--self.__pool = {}
	self.__update_toadd = {}
	self.__coupdate_toadd = {}
end

-- 获取定时器
local function InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
	local timer = nil
	--if table.length(self.__pool) > 0 then
	--	timer = table.remove(self.__pool)
	--	if delay and func then
	--		timer:Init(delay, func, obj, one_shot, use_frame, unscaled)
	--	end
	--else
		timer = Timer.New(delay, func, obj, one_shot, use_frame, unscaled)
	--end
	return timer
end

-- 获取Update定时器
local function GetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
	assert(not self.__update_timer[timer] and not self.__update_toadd[timer])
	local timer = InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
	self.__update_toadd[timer] = true
	return timer
end

-- 获取CoUpdate定时器
local function GetCoTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
	assert(not self.__coupdate_timer[timer] and not self.__coupdate_toadd[timer])
	local timer = InnerGetTimer(self, delay, func, obj, one_shot, use_frame, unscaled)
	self.__coupdate_toadd[timer] = true
	return timer
end

-- 做一个延时调用处理
-- 默认1秒后调用；如果可能中途终止，那么请接收返回值，然后调用[return value]:Stop()
local function DelayInvoke(self, callback, delayTime, userdata)
	delayTime = tonumber(delayTime or 1)
	local t = TimerManager:GetInstance():GetTimer(delayTime,
			function(userdata)
				if t ~= nil then
					t:Stop()
					t = nil
				end
				callback(userdata)
			end,
			userdata, true, false, false)

	t:Start()
	return t
end


-- 析构函数
local function __delete(self)
	self:Cleanup()
	self.__update_handle = nil
	self.__coupdate_handle = nil
	self.__update_timer = nil
	self.__coupdate_timer = nil
	--self.__pool = nil
	self.__update_toadd = nil
	self.__coupdate_toadd = nil
end

TimerManager.__init = __init
TimerManager.__delete = __delete
TimerManager.Startup = Startup
TimerManager.Cleanup = Cleanup
TimerManager.Dispose = Dispose
TimerManager.GetTimer = GetTimer
TimerManager.GetCoTimer = GetCoTimer
TimerManager.DelayInvoke = DelayInvoke

return TimerManager;