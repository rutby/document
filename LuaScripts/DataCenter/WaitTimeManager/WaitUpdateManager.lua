--等待update回调管理器
local WaitUpdateManager = BaseClass("WaitUpdateManager")

function WaitUpdateManager:__init()
	self.all = {} --所有
	self.__update_handle = nil
	self:AddUpdate()
end

function WaitUpdateManager:__delete()
	self.all = {} --所有
	self:RemoveUpdate()
end

function WaitUpdateManager:Startup()
end

--内部方法
function WaitUpdateManager:AddUpdate()
	if self.__update_handle == nil then
		self.__update_handle = function() self:Update() end
		UpdateManager:GetInstance():AddUpdate(self.__update_handle)
	end
end

--内部方法
function WaitUpdateManager:RemoveUpdate()
	if self.__update_handle ~= nil then
		UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
		self.__update_handle = nil
	end
end

function WaitUpdateManager:DestroyAllTimer()
	for k, v in pairs(self.allWaitTimer) do
		v:stop()
	end
	self.allWaitTimer = {}
end

function WaitUpdateManager:AddOneUpdate(callback, param)
	self.all[callback] = (param or {})
	self:AddUpdate()
end

function WaitUpdateManager:DeleteOneUpdate(callback)
	self.all[callback] = nil
	if table.count(self.all) == 0 then
		self:RemoveUpdate()
	end
end

function WaitUpdateManager:Update()
	for k,v in pairs(self.all) do
		if k ~= nil then
			k(k, v)
		end
	end
end


return WaitUpdateManager