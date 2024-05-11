--建筑特效管理器
local BuildEffectManager = BaseClass("BuildEffectManager")
local BuildEffectObject = require "Scene.BuildEffectObject.BuildEffectObject"
local BuildUpgradeEffectObject = require "Scene.BuildEffectObject.BuildUpgradeEffectObject"

local effect_go_path = "ModelGo/UpgradeEffectGo"

function BuildEffectManager:__init()
	self.allEffect = {} --所有特效
	self.buildEffectType = {}
	self:AddListener()
end

function BuildEffectManager:__delete()
	self:RemoveListener()
	self:DestroyAllEffect()
	self.buildEffectType = {}
	self.allEffect = {} --所有特效
end

function BuildEffectManager:Startup()
end

function BuildEffectManager:AddListener()
	if self.onBuildTrainingStartSignal == nil then
		self.onBuildTrainingStartSignal = function(param)
			self:OnBuildTrainingStartSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.onBuildTrainingStartSignal)
	end
	if self.queueTimeEndSignal == nil then
		self.queueTimeEndSignal = function(param)
			self:QueueTimeEndSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
		EventManager:GetInstance():AddListener(EventId.TrainingArmyFinish, self.queueTimeEndSignal)
	end
	if self.buildUpgradeStartSignal == nil then
		self.buildUpgradeStartSignal = function(param)
			self:BuildUpgradeStartSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)
	end
	if self.buildUpgradeFinishSignal == nil then
		self.buildUpgradeFinishSignal = function(param)
			self:BuildUpgradeFinishSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
	end
	if self.buildStaminaChangeSignal == nil then
		self.buildStaminaChangeSignal = function(param)
			self:BuildStaminaChangeSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.BuildingStaminaChanged, self.buildStaminaChangeSignal)
	end
	if self.zombieInvadeChangeSignal == nil then
		self.zombieInvadeChangeSignal = function()
			self:ZombieInvadeChangeSignal()
		end
		EventManager:GetInstance():AddListener(EventId.CityZombieInvadeChange, self.zombieInvadeChangeSignal)
	end
	if self.vitaFireStateChangeSignal == nil then
		self.vitaFireStateChangeSignal = function()
			self:VitaFireStateChangeSignal()
		end
		EventManager:GetInstance():AddListener(EventId.VitaFireStateChange, self.vitaFireStateChangeSignal)
	end
	if self.vitaDayNightChangeSignal == nil then
		self.vitaDayNightChangeSignal = function()
			self:VitaDayNightChangeSignal()
		end
		EventManager:GetInstance():AddListener(EventId.VitaDayNightChange, self.vitaDayNightChangeSignal)
	end
	if self.saveGuideSignal == nil then
		self.saveGuideSignal = function()
			self:SaveGuideSignal()
		end
		EventManager:GetInstance():AddListener(EventId.SaveGuide, self.saveGuideSignal)
	end
	if self.citySiegeUpdateSignal == nil then
		self.citySiegeUpdateSignal = function()
			self:CitySiegeUpdateSignal()
		end
		EventManager:GetInstance():AddListener(EventId.CitySiegeUpdate, self.citySiegeUpdateSignal)
	end
	if self.mainLvUpSignal == nil then
		self.mainLvUpSignal = function()
			self:MainLvUpSignal()
		end
		EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
	end
end

function BuildEffectManager:RemoveListener()
	if self.onBuildTrainingStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.onBuildTrainingStartSignal)
		self.onBuildTrainingStartSignal = nil
	end
	if self.queueTimeEndSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
		EventManager:GetInstance():RemoveListener(EventId.TrainingArmyFinish, self.queueTimeEndSignal)
		self.queueTimeEndSignal = nil
	end
	if self.buildUpgradeStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)
		self.buildUpgradeStartSignal = nil
	end
	if self.onBuildTrainingStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.onBuildTrainingStartSignal)
		self.onBuildTrainingStartSignal = nil
	end
	if self.zombieInvadeChangeSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.CityZombieInvadeChange, self.zombieInvadeChangeSignal)
		self.zombieInvadeChangeSignal = nil
	end
	if self.vitaFireStateChangeSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.VitaFireStateChange, self.vitaFireStateChangeSignal)
		self.vitaFireStateChangeSignal = nil
	end
	if self.vitaDayNightChangeSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.VitaDayNightChange, self.vitaDayNightChangeSignal)
		self.vitaDayNightChangeSignal = nil
	end
	if self.saveGuideSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.SaveGuide, self.saveGuideSignal)
		self.saveGuideSignal = nil
	end
	if self.citySiegeUpdateSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.CitySiegeUpdate, self.citySiegeUpdateSignal)
		self.citySiegeUpdateSignal = nil
	end
	if self.mainLvUpSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
		self.mainLvUpSignal = nil
	end
end


function BuildEffectManager:DestroyAllEffect()
	for k,v in pairs(self.allEffect) do
		v:Destroy()
	end
	self.allEffect = {}
end

function BuildEffectManager:GetEffectTypeByBuildId(buildId)
	if self.buildEffectType[buildId] ~= nil then
		return self.buildEffectType[buildId]
	end
	local list = {}
	self.buildEffectType[buildId] = list
	if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK
			or buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
			or buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		table.insert(list, BuildEffectType.TrainZzz)
	elseif buildId == BuildingTypes.FUN_BUILD_MAIN then
		table.insert(list, BuildEffectType.SafeArea)
	end
	if table.hasvalue(CityResidentDefines.ScareHideBuildIds, buildId) then
		table.insert(list, BuildEffectType.RuinFire)
	end
	table.insert(list, BuildEffectType.Upgrading)
	return list
end

function BuildEffectManager:CheckShowEffect(bUuid,needShowSound)
	if DataCenter.BuildManager:IsBuildInView(bUuid) then
		local param = self:GetBuildNeedShowBuildEffect(bUuid)
		if param == nil then
			self:DeleteOneBuildEffect(bUuid)
		else
			if needShowSound and param.buildEffectType == BuildEffectType.SafeArea then
				SoundUtil.PlayEffect(SoundAssets.Music_Effect_Light_Range)
			end
			self:ShowOneBuildEffect(param)
			
		end
	else
		self:DeleteOneBuildEffect(bUuid)
	end
end


--获取建筑需要显示的特效
function BuildEffectManager:GetBuildNeedShowBuildEffect(uuid)
	if CS.SceneManager.World ~= nil and SceneUtils.GetIsInCity() then
		local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if data ~= nil then
			local buildId = data.itemId
			local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
			local list = self:GetEffectTypeByBuildId(buildId)
			if list ~= nil and buildTemplate ~= nil then
				for k, v in ipairs(list) do
					if v == BuildEffectType.TrainZzz then
						if data.level > 0 and (not data:IsUpgrading()) then
							local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId)
							local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
							if queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
								local param = {}
								param.prefabName = UIAssets.VFX_idle_zzz
								param.worldPos = buildTemplate:GetPosition() + Vector3.New(0, 2, 0)
								param.buildId = buildId
								param.bUuid = uuid
								param.buildEffectType = v
								return param
							end
						end
					elseif v == BuildEffectType.Upgrading then
						if data.level > 0 and data:IsUpgrading() then
							local effect_go = nil
							local city = CS.SceneManager.World:GetBuildingByPoint(data.pointId)
							if city ~= nil then
								local transform = city:GetTransform()
								if transform ~= nil then
									effect_go = transform:Find(effect_go_path)
								end
							end
							if effect_go ~= nil then
								local param = {}
								param.scale = Vector3.one * (tonumber(buildTemplate.upgrade_scale) or 1)
								param.prefabName = UIAssets.BuildUpgradingEffect
								param.worldPos = buildTemplate:GetPosition()
								param.buildId = buildId
								param.bUuid = uuid
								param.buildEffectType = v
								param.specialParam = {}
								param.specialParam.bUuid = uuid
								param.specialParam.worldPos = param.worldPos
								param.specialParam.effect_go = effect_go
								param.specialScript = BuildUpgradeEffectObject
								return param
							end
						end
					elseif v == BuildEffectType.RuinFire then
						if data:GetCurStamina() <= 0 then
							local prefabName = nil
							if buildId == BuildingTypes.DS_BAR then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_jiuba_zhaohuo.prefab"
							elseif buildId == BuildingTypes.DS_RESTAURANT then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_canting_zhaohuo.prefab"
							elseif buildId == BuildingTypes.DS_COAL_YARD then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_fadianzhan_zhaohuo.prefab"
							elseif buildId == BuildingTypes.DS_FACTORY then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_famuchang_zhaohuo.prefab"
							elseif buildId == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_huishouzhan_zhaohuo.prefab"
							elseif buildId == BuildingTypes.DS_FARM then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_lierenxiaowu_zhaohuo.prefab"
							elseif buildId == BuildingTypes.DS_HOUSE_1 or buildId == BuildingTypes.DS_HOUSE_2 or
							       buildId == BuildingTypes.DS_HOUSE_3 or buildId == BuildingTypes.DS_HOUSE_4 or
							       buildId == BuildingTypes.DS_HOUSE_5 or buildId == BuildingTypes.DS_HOUSE_6 or
							       buildId == BuildingTypes.DS_HOUSE_7 or buildId == BuildingTypes.DS_HOUSE_8 then
								prefabName = "Assets/_Art/Effect/prefab/scene/Eff_minju_zhaohuo.prefab"
							end
							if prefabName then
								local param = {}
								param.prefabName = prefabName
								param.worldPos = buildTemplate:GetPosition()
								param.rot = Quaternion.Euler(0, buildTemplate:GetRotation(), 0)
								param.buildId = buildId
								param.bUuid = uuid
								param.buildEffectType = v
								return param
							end
						end
					elseif v == BuildEffectType.SafeArea then
						if DataCenter.CityResidentManager:CanShowMainSafe() then
							local radius = DataCenter.CityResidentManager:GetSafeRadius()
							local param = {}
							param.prefabName = "Assets/Main/Prefab_Dir/Home/Building/Decoration/MainSafe.prefab"
							param.worldPos = Vector3.New(101, 0, 101)
							param.buildId = buildId
							param.bUuid = uuid
							param.buildEffectType = v
							param.scale = Vector3.New(radius, 1, radius)
							
							--引导相关
							local guideRadius = DataCenter.GuideManager:GetFlag(GuideTempFlagType.ChangeSafeArea)
							if guideRadius ~= nil then
								param.scale = Vector3.New(guideRadius, 1, guideRadius)
							end
							return param
						end
					end
				end
			end
		end
	end
	return nil
end
--显示一个特效
function BuildEffectManager:ShowOneBuildEffect(param)
	if self.allEffect[param.bUuid] == nil then
		self.allEffect[param.bUuid] = BuildEffectObject.New()
	end
	self.allEffect[param.bUuid]:ReInit(param)
end

function BuildEffectManager:DeleteOneBuildEffect(bUuid)
	if self.allEffect[bUuid] ~= nil then
		self.allEffect[bUuid]:Destroy()
		self.allEffect[bUuid] = nil
	end
end


function BuildEffectManager:SetOneBuildEffectScale(buildType,scale)
	--BuildingTypes.FUN_BUILD_MAIN
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildType)
	if buildData then
		local effectObj = self.allEffect[buildData.uuid]
		if effectObj then
			effectObj:SetScale(scale)
		end
	end
end

function BuildEffectManager:OnBuildTrainingStartSignal(bUuid)
	self:CheckShowEffect(bUuid)
end

function BuildEffectManager:QueueTimeEndSignal(queueType)
	self:RefreshEffectByQueueType(queueType)
end

function BuildEffectManager:RefreshEffectByQueueType(queueType)
	local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(tonumber(queueType))
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
	if buildData ~= nil then
		self:CheckShowEffect(buildData.uuid)
	end
end

function BuildEffectManager:BuildUpgradeStartSignal(bUuid)
	self:CheckShowEffect(bUuid)
end

function BuildEffectManager:BuildUpgradeFinishSignal(bUuid)
	self:CheckShowEffect(bUuid,true)
end

function BuildEffectManager:BuildStaminaChangeSignal(bUuid)
	self:CheckShowEffect(bUuid)
end

function BuildEffectManager:ZombieInvadeChangeSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end
end

function BuildEffectManager:VitaFireStateChangeSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end
end

function BuildEffectManager:VitaDayNightChangeSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end

	--引导相关
	if DataCenter.GuideManager:GetFlag(GuideTempFlagType.ChangeSafeArea) ~= nil then
		local curTime = UITimeManager:GetInstance():GetServerTime()
		local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
		if dayNight == VitaDefines.DayNight.LateAtNight then
			DataCenter.GuideManager:RemoveOneTempFlag(GuideTempFlagType.ChangeSafeArea)
		end
	end
	
end

function BuildEffectManager:SaveGuideSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end
end

function BuildEffectManager:CitySiegeUpdateSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end
end

function BuildEffectManager:MainLvUpSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if buildData then
		self:CheckShowEffect(buildData.uuid)
	end
end

return BuildEffectManager