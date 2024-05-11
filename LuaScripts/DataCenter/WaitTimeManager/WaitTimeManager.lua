--等待时间回调管理器（针对一些极特殊功能使用，道具返还tips必须在建筑升级tips之后弹出）
local WaitTimeManager = BaseClass("WaitTimeManager")

function WaitTimeManager:__init()
	self.allWaitTimer = {} --所有计时器
	self.timer_callback = function(callback) 
		self:OnTimerCallBack(callback)
	end
end

function WaitTimeManager:__delete()
	self:DestroyAllTimer()
end

function WaitTimeManager:Startup()
end

function WaitTimeManager:DestroyAllTimer()
	for k, v in pairs(self.allWaitTimer) do
		if v ~= nil then
			v:Stop()
		end
	end
	self.allWaitTimer = {}
end

function WaitTimeManager:AddOneWait(time, callback)
	self.allWaitTimer[callback] = TimerManager:GetInstance():GetTimer(time, self.timer_callback, callback, true, false, false)
	self.allWaitTimer[callback]:Start()
end

function WaitTimeManager:DeleteOneTimer(callback)
	if self.allWaitTimer[callback] ~= nil then
		self.allWaitTimer[callback]:Stop()
		self.allWaitTimer[callback] = nil
	end
end

function WaitTimeManager:OnTimerCallBack(callback)
	self:DeleteOneTimer(callback)
	callback()
end


return WaitTimeManager