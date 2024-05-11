--升级结束特效管理器
local BuildUpgradeEffectManager = BaseClass("BuildUpgradeEffectManager")
local ResourceManager = CS.GameEntry.Resource
local DestroyTime = 4

function BuildUpgradeEffectManager:__init()
	self.allEffect = {} --所有特效
	self.timerList = {}
	self.timer_callback = function(request)
		self:OnTimerCallBack(request)
	end
	self:AddListener()
end

function BuildUpgradeEffectManager:__delete()
	self:RemoveListener()
	self:DestroyAllTimer()--计时器要在加载资源前删除
	self:DestroyAllEffect()
	self.allEffect = {} --所有特效
	self.timerList = {}
end

function BuildUpgradeEffectManager:AddListener()
	if self.buildUpgradeFinishSignal == nil then
		self.buildUpgradeFinishSignal = function(uuid)
			self:BuildUpgradeFinishSignal(uuid)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
	end
end

function BuildUpgradeEffectManager:RemoveListener()
	if self.buildUpgradeFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
		self.buildUpgradeFinishSignal = nil
	end
end

function BuildUpgradeEffectManager:Startup()
end

function BuildUpgradeEffectManager:DestroyAllEffect()
	for k,v in pairs(self.allEffect) do
		v:Destroy()
	end
	self.allEffect = {}
end

function BuildUpgradeEffectManager:DestroyOneEffect(effect)
	if self.allEffect[effect] ~= nil then
		self.allEffect[effect]:Destroy()
		self.allEffect[effect] = nil
	end
end

function BuildUpgradeEffectManager:ShowOneEffect(pos, scale)
	local request = ResourceManager:InstantiateAsync(UIAssets.BuildUpgradeFinishEffect)
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		local tf = request.gameObject.transform
		if tf ~= nil then
			tf:SetParent(CS.SceneManager.World.DynamicObjNode)
			tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			tf:Set_position(pos.x, pos.y, pos.z)
			tf:Set_localScale(scale, scale, scale)
			self:AddOneTime(DestroyTime, request)
		end
	end)
	self.allEffect[request] = request
end

function BuildUpgradeEffectManager:AddOneTime(time, request)
	local timer = TimerManager:GetInstance():GetTimer(time, self.timer_callback, request, true, false, false)
	timer:Start()
	self.timerList[request] = timer
end

function BuildUpgradeEffectManager:RemoveOneTime(request)
	if self.timerList[request] ~= nil then
		self.timerList[request]:Stop()
		self.timerList[request] = nil
	end
end

function BuildUpgradeEffectManager:OnTimerCallBack(request)
	self:RemoveOneTime(request)
	self:DestroyOneEffect(request)
end

function BuildUpgradeEffectManager:DestroyAllTimer()
	for k,v in pairs(self.timerList) do
		v:Stop()
	end
	self.timerList = {}
end

function BuildUpgradeEffectManager:BuildUpgradeFinishSignal(bUuid)
	if DataCenter.BuildManager:IsBuildInView(bUuid) then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
		if buildData ~= nil then
			local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
			if buildTemplate ~= nil then
				local pos = buildTemplate:GetPosition()
				local scale = tonumber(buildTemplate.upgrade_scale) or 1
				self:ShowOneEffect(pos, scale)
			end
		end
	end
end


return BuildUpgradeEffectManager