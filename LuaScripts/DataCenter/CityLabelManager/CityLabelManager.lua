--- Created by shimin.
--- DateTime: 2022/11/21 11:27
--- 主城内建筑等级显示管理器

local CityLabelManager = BaseClass("CityLabelManager")
local StopHideTime = 0.6--松手多长时间后消失
local ShowLod = 3--高度40显示

function CityLabelManager:__init()
	self.canShowLod = false
	self.isShow = false--是否正在显示
	self.disappearTimer = nil
	self.disappear_timer_callback = function() 
		self:DisappearTimerCallBack()
	end
	self.canDragShow = false
	self.hideBuildMark = false	
	self.cacheLod = 1
	self.hideBuildMarkUuid = {}
	self.baseLevel = 0
	self.noResetHideMark = false
	self.haveHideBuild = false--完全为了效率 代替 table.count(self.hideBuildMarkUuid)
	self.disappearTime = 0
	self:AddListener()
end

function CityLabelManager:__delete()
	self:DeleteDisappearTimer()
	self.disappearTime = 0
	self.cacheLod = 1
	self.canShowLod = false
	self.isShow = false--是否正在显示
	self.disappear_timer_callback = nil
	self.drag_show_timer_callback = nil
	self.canDragShow = false
	self.hideBuildMark = false
	self.baseLevel = 0
	self.noResetHideMark = false
	self:RemoveListener()
end

function CityLabelManager:Startup()
end

function CityLabelManager:AddListener()
	if self.pveLevelEnterSignal == nil then
		self.pveLevelEnterSignal = function()
			self:PveLevelEnterSignal()
		end
		EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
	end
	if self.onEnterWorldSignal == nil then
		self.onEnterWorldSignal = function()
			self:OnEnterWorldSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
	end
	if self.onEnterCitySignal == nil then
		self.onEnterCitySignal = function()
			self:OnEnterCitySignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
	end
	self:AddCityListener()
end

function CityLabelManager:AddCityListener()
	if self.refreshGuideSignal == nil then
		self.refreshGuideSignal = function()
			self:RefreshGuideSignal()
		end
		EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.refreshGuideSignal)
	end
	if self.onWorldInputPointUpSignal == nil then
		self.onWorldInputPointUpSignal = function()
			self:OnWorldInputPointUpSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnWorldInputPointUp, self.onWorldInputPointUpSignal)
	end

	if self.changeCameraLodSignal == nil then
		self.changeCameraLodSignal = function(id)
			self:ChangeCameraLodSignal(id)
		end
		EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
	end
	if self.onWorldInputDragBeginSignal == nil then
		self.onWorldInputDragBeginSignal = function()
			self:OnWorldInputDragBeginSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnWorldInputDragBegin, self.onWorldInputDragBeginSignal)
	end
	if self.onWorldInputPointDownSignal == nil then
		self.onWorldInputPointDownSignal = function(index)
			self:OnWorldInputPointDownSignal(index)
		end
		EventManager:GetInstance():AddListener(EventId.OnWorldInputPointDown, self.onWorldInputPointDownSignal)
	end
	if self.onTouchPinchCameraNearSignal == nil then
		self.onTouchPinchCameraNearSignal = function()
			self:OnTouchPinchCameraNearSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnTouchPinchCameraNear, self.onTouchPinchCameraNearSignal)
	end
	if self.onTouchPinchCameraFarSignal == nil then
		self.onTouchPinchCameraFarSignal = function()
			self:OnTouchPinchCameraFarSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnTouchPinchCameraFar, self.onTouchPinchCameraFarSignal)
	end
end

function CityLabelManager:RemoveCityListener()
	if self.refreshGuideSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.refreshGuideSignal)
		self.refreshGuideSignal = nil
	end
	if self.changeCameraLodSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
		self.changeCameraLodSignal = nil
	end
	if self.onWorldInputPointUpSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointUp, self.onWorldInputPointUpSignal)
		self.onWorldInputPointUpSignal = nil
	end
	if self.onWorldInputDragBeginSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnWorldInputDragBegin, self.onWorldInputDragBeginSignal)
		self.onWorldInputDragBeginSignal = nil
	end
	if self.onWorldInputPointDownSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointDown, self.onWorldInputPointDownSignal)
		self.onWorldInputPointDownSignal = nil
	end
	if self.onTouchPinchCameraNearSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnTouchPinchCameraNear, self.onTouchPinchCameraNearSignal)
		self.onTouchPinchCameraNearSignal = nil
	end
	if self.onTouchPinchCameraFarSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnTouchPinchCameraFar, self.onTouchPinchCameraFarSignal)
		self.onTouchPinchCameraFarSignal = nil
	end
end

function CityLabelManager:RemoveListener()
	if self.onEnterCitySignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
		self.onEnterCitySignal = nil
	end
	if self.pveLevelEnterSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
		self.pveLevelEnterSignal = nil
	end
	if self.onEnterWorldSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
		self.onEnterWorldSignal = nil
	end
	self:RemoveCityListener()
end

function CityLabelManager:InitData()
	self.baseLevel = LuaEntry.DataConfig:TryGetNum("show_power", "k4")
	if CS.SceneManager.World ~= nil then
		self.canShowLod = self:CanShowByLod(CS.SceneManager.World:GetLodLevel())
	end
	self.disappearTime = StopHideTime
end

function CityLabelManager:CanShowByLod(lod)
	return lod >= ShowLod
end

function CityLabelManager:DeleteDisappearTimer()
	if self.disappearTimer ~= nil then
		self.disappearTimer:Stop()
		self.disappearTimer = nil
	end
end

function CityLabelManager:AddDisappearTimer()
	if self.disappearTime > 0 then
		self:DeleteDisappearTimer()
		if self.disappearTimer == nil then
			self.disappearTimer = TimerManager:GetInstance():GetTimer(self.disappearTime, self.disappear_timer_callback, self, true, false, false)
			self.disappearTimer:Start()
		end
	end
end

function CityLabelManager:DisappearTimerCallBack()
	self:DeleteDisappearTimer()
	if DataCenter.BuildManager.MainLv >= self.baseLevel then
		self:SetNoShowLevel()
	end
end

function CityLabelManager:ChangeCameraLodSignal(lod)
	self.cacheLod = lod
	local show = self:CanShowByLod(lod)
	if show ~= self.canShowLod then
		self.canShowLod = show
	end
	self:RefreshShow()
	self:RefreshBuildMark(lod)
end

function CityLabelManager:CanShow()
	if self.canShowLod and SceneUtils.GetIsInCity() and (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldTileUI)) then
		if DataCenter.BuildManager.MainLv >= self.baseLevel then
			if self.canDragShow then
				return true
			else
				return false
			end
		else
			return true
		end
	end
	return false
end

function CityLabelManager:RefreshShow()
	local show = self:CanShow()
	if show ~= self.isShow then
		self.isShow = show
		if self.isShow then
			EventManager:GetInstance():Broadcast(EventId.SetBuildCanShowLevel)
		else
			self:DeleteDisappearTimer()
			EventManager:GetInstance():Broadcast(EventId.SetBuildNoShowLevel)
		end
	end
end

function CityLabelManager:OnEnterCitySignal()
	self:AddCityListener()
end
function CityLabelManager:OnEnterWorldSignal()
	self:RemoveCityListener()
end
function CityLabelManager:PveLevelEnterSignal()
	self:RemoveCityListener()
end

function CityLabelManager:SetNoShowLevel()
	if self.isShow then
		self.isShow = false
		self:DeleteDisappearTimer()
		EventManager:GetInstance():Broadcast(EventId.SetBuildNoShowLevel)
	end
end

function CityLabelManager:OnWorldInputPointDownSignal(index)
	self.canDragShow = true
end

function CityLabelManager:OnWorldInputPointUpSignal()
	self.canDragShow = false
	if self.isShow then
		self:AddDisappearTimer()
	end
end

function CityLabelManager:OnWorldInputDragBeginSignal()
	if self.canDragShow then
		self:DeleteDisappearTimer()
		self:RefreshShow()
	end
end

function CityLabelManager:CanHideBuildMarkByLod(lod)
	if DataCenter.GuideManager:InGuide() then
		return true
	end
	if lod <= CityBuildHideMarkLod then
		return true
	end

	--if self.hideBuildMark then
	--	if lod <= CityBuildShowMarkLod then
	--		return true
	--	end
	--else
	--	if lod <= CityBuildHideMarkLod then
	--		return true
	--	end
	--end
	
	return false
end

function CityLabelManager:RefreshBuildMark(lod)
	if CS.SceneManager.World ~= nil then
		local hideBuildMark = self:CanHideBuildMarkByLod(lod)
		if self.hideBuildMark ~= hideBuildMark then
			self.hideBuildMark = hideBuildMark
			if self.hideBuildMark then
				EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildMark, false)
				--在升级中的建筑，显示盖
				local upgradeList = DataCenter.BuildManager:GetAllUpgradingFurnitureBuild()
				if upgradeList ~= nil then
					for k,v in ipairs(upgradeList) do
						local city = CS.SceneManager.World:GetBuildingByPoint(v.pointId)
						if city ~= nil then
							city:ChangeNearModel(false)
						end
					end
				end
			else
				if self.noResetHideMark then
					for k,v in pairs(self.hideBuildMarkUuid) do
						local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
						if buildData ~= nil then
							DataCenter.BuildWallEffectManager:SetOriginalMaterial(k, false)
						end
					end
				else
					self.hideBuildMarkUuid = {}
					self.haveHideBuild = false
				end
				
				EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildMark, true)
				if self.noResetHideMark then
					for k,v in pairs(self.hideBuildMarkUuid) do
						local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
						if buildData ~= nil then
							local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
							if city ~= nil then
								city:ChangeNearModel(true)
							end
						end
					end
				end
			end
		end
	end
end

function CityLabelManager:RefreshGuideSignal()
	self:RefreshBuildMark(self.cacheLod)
end

function CityLabelManager:IsShowBuildMark()
	return not self.hideBuildMark
end

function CityLabelManager:SetNoResetHideBuildMark(noReset)
	self.noResetHideMark = noReset
end

function CityLabelManager:AddOneHideBuildMark(uuid)
	if not self.hideBuildMarkUuid[uuid] then
		self.hideBuildMarkUuid[uuid] = true
		self.haveHideBuild = true
	end
end

function CityLabelManager:AddOneBuildInView(bUuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData.level > 0 and buildData:IsUpgrading() then
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
		if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
			local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
			if city ~= nil then
				city:ChangeNearModel(false)
			end
		end
	end
end

function CityLabelManager:BuildOutViewSignal(bUuid)

end

function CityLabelManager:IsNeedHideMark(uuid)
	return self.hideBuildMarkUuid[uuid]
end

function CityLabelManager:OnTouchPinchCameraNearSignal()
end

function CityLabelManager:OnTouchPinchCameraFarSignal()
	if self.haveHideBuild and (not self.hideBuildMark) then
		for k,v in pairs(self.hideBuildMarkUuid) do
			local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
			if buildData ~= nil then
				local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
				if city ~= nil then
					city:ChangeNearModel(false)
					DataCenter.BuildWallEffectManager:RefreshOneWallEffect(k)
				end
			end
		end
		self.hideBuildMarkUuid = {}
		self.haveHideBuild = false
	end
end

return CityLabelManager