--气泡管理器
local BuildBubbleManager = BaseClass("BuildBubbleManager")
local NoRefreshTime = 3 --防止消息返回出现问题，永远不刷新
local Localization = CS.GameEntry.Localization

function BuildBubbleManager:__init()
	self.showBubbleNode = true
	self.buildTypeBubbleType = {}
	self.on_click_callback = function(param) 
		self:OnClickCallBack(param)
	end
	self.noRefreshTimer = {}
	self.noRefreshTimerCallBack = function(uuid) 
		self:NoRefreshTimerCallBack(uuid)
	end
	self.wait_timer = {}
	self.wait_timer_callback = function(uuid)
		self:WaitTimerCallBack(uuid)
	end
	self:AddListener()
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIBubble, {})
end

function BuildBubbleManager:__delete()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBubble)
	self:RemoveAllTimer()
	self:RemoveListener()
	self:ClearAll()
end
function BuildBubbleManager:AddListener()
	if self.onBuildTrainingStartSignal == nil then
		self.onBuildTrainingStartSignal = function(param)
			self:OnBuildTrainingStartSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.onBuildTrainingStartSignal)
	end
	if self.onBuildTrainingFinishSignal == nil then
		self.onBuildTrainingFinishSignal = function(param)
			self:OnBuildTrainingFinishSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.TrainingArmyFinish, self.onBuildTrainingFinishSignal)
	end
	if self.onScienceQueueResearchSignal == nil then
		self.onScienceQueueResearchSignal = function(param)
			self:OnScienceQueueResearchSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.onScienceQueueResearchSignal)
	end
	if self.onScienceQueueFinishSignal == nil then
		self.onScienceQueueFinishSignal = function(param)
			self:OnScienceQueueFinishSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.OnScienceQueueFinish, self.onScienceQueueFinishSignal)
	end
	if self.onHospitalUpdateSignal == nil then
		self.onHospitalUpdateSignal = function(param)
			self:OnHospitalUpdateSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.HospitalUpdate, self.onHospitalUpdateSignal)
	end
	if self.hospitalStartSignal == nil then
		self.hospitalStartSignal = function(param)
			self:HospitalStartSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.HospitaiStart, self.hospitalStartSignal)
	end
	if self.hospitalFinishSignal == nil then
		self.hospitalFinishSignal = function(param)
			self:HospitalFinishSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.HospitalFinish, self.hospitalFinishSignal)
	end
	if self.queueTimeEndSignal == nil then
		self.queueTimeEndSignal = function(param)
			self:QueueTimeEndSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
		EventManager:GetInstance():AddListener(EventId.AllianceQueueHelpNew, self.queueTimeEndSignal)
	end
	if self.onAllianceHelpCallBack == nil then
		self.onAllianceHelpCallBack = function(param)
			self:OnAllianceHelpCallBack(param)
		end
		EventManager:GetInstance():AddListener(EventId.AllianceBuildHelpNew, self.onAllianceHelpCallBack)
	end
	if self.updateBuildDataSignal == nil then
		self.updateBuildDataSignal = function(param)
			self:UpdateBuildDataSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.updateBuildDataSignal)
	end
	if self.checkDetectEventSignal == nil then
		self.checkDetectEventSignal = function(param)
			self:CheckDetectEventSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.GetAllDetectInfo, self.checkDetectEventSignal)
		EventManager:GetInstance():AddListener(EventId.DetectInfoChange, self.checkDetectEventSignal)
		EventManager:GetInstance():AddListener(EventId.FormationInfoUpdate, self.checkDetectEventSignal)
	end
	if self.buildTimeEndSignal == nil then
		self.buildTimeEndSignal = function(param)
			self:BuildTimeEndSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.Build_Time_End, self.buildTimeEndSignal)
	end
	if self.updateAllianceSignal == nil then
		self.updateAllianceSignal = function(param)
			self:UpdateAllianceSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.AllianceMemberNeedHelp, self.updateAllianceSignal)
		EventManager:GetInstance():AddListener(EventId.AllianceQuitOK, self.updateAllianceSignal)
		EventManager:GetInstance():AddListener(EventId.AllianceBaseDataUpdated, self.updateAllianceSignal)
		EventManager:GetInstance():AddListener(EventId.OnGetNewAlJoinReq, self.updateAllianceSignal)
	end
	if self.garageRefitUpdateSignal == nil then
		self.garageRefitUpdateSignal = function(param)
			self:GarageRefitUpdateSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.GarageRefitUpdate, self.garageRefitUpdateSignal)
	end
	if self.mainLvUpSignal == nil then
		self.mainLvUpSignal = function(param)
			self:MainLvUpSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
	end
	if self.updateArmySignal == nil then
		self.updateArmySignal = function(param)
			self:UpdateArmySignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.TrainArmyData, self.updateArmySignal)
	end
	if self.onCommonShopRedChangeSignal == nil then
		self.onCommonShopRedChangeSignal = function(param)
			self:OnCommonShopRedChangeSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.OnCommonShopRedChange, self.onCommonShopRedChangeSignal)
	end
	if self.onEnterCitySignal == nil then
		self.onEnterCitySignal = function()
			self:OnEnterCitySignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
	end
	if self.onUpdateArenaBaseInfoSignal == nil then
		self.onUpdateArenaBaseInfoSignal = function()
			self:OnUpdateArenaBaseInfoSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnUpdateArenaBaseInfo, self.onUpdateArenaBaseInfoSignal)
	end
	if self.opinionUpdateSignal == nil then
		self.opinionUpdateSignal = function()
			self:OpinionUpdateSignal()
		end
		EventManager:GetInstance():AddListener(EventId.OpinionUpdate, self.opinionUpdateSignal)
		EventManager:GetInstance():AddListener(EventId.OpinionChooseMail, self.opinionUpdateSignal)
	end
	if self.storyUpdateHangupTimeSignal == nil then
		self.storyUpdateHangupTimeSignal = function()
			self:StoryUpdateHangupTimeSignal()
		end
		EventManager:GetInstance():AddListener(EventId.StoryUpdateHangupTime, self.storyUpdateHangupTimeSignal)
		EventManager:GetInstance():AddListener(EventId.ShowStoryRewardBubble, self.storyUpdateHangupTimeSignal)
	end
	if self.checkPubBubbleSignal == nil then
		self.checkPubBubbleSignal = function()
			self:CheckPubBubbleSignal()
		end
		EventManager:GetInstance():AddListener(EventId.HeroLotteryInfoUpdate, self.checkPubBubbleSignal)
		EventManager:GetInstance():AddListener(EventId.CheckPubBubble, self.checkPubBubbleSignal)
	end
	if self.refreshItemsSignal == nil then
		self.refreshItemsSignal = function()
			self:RefreshItemsSignal()
		end
		EventManager:GetInstance():AddListener(EventId.RefreshItems, self.refreshItemsSignal)
	end
	if self.refreshHeroEquipSignal == nil then
		self.refreshHeroEquipSignal = function()
			self:RefreshHeroEquipSignal()
		end
		EventManager:GetInstance():AddListener(EventId.AddSpeedSuccess, self.refreshHeroEquipSignal)
		EventManager:GetInstance():AddListener(EventId.HeroEquipQueueFinish, self.refreshHeroEquipSignal)
	end
	EventManager:GetInstance():AddListener(EventId.RefreshHeroBountyBubble, self.CheckHeroBountySignal)
	EventManager:GetInstance():AddListener(EventId.MonthCardInfoUpdated, self.RefreshGolloesCampBubbleSignal)
end

function BuildBubbleManager:RemoveListener()
	if self.onEnterCitySignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
		self.onEnterCitySignal = nil
	end
	if self.onUpdateArenaBaseInfoSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnUpdateArenaBaseInfo, self.onUpdateArenaBaseInfoSignal)
		self.onUpdateArenaBaseInfoSignal = nil
	end
	if self.onBuildTrainingStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.onBuildTrainingStartSignal)
		self.onBuildTrainingStartSignal = nil
	end
	if self.onBuildTrainingFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.TrainingArmyFinish, self.onBuildTrainingFinishSignal)
		self.onBuildTrainingFinishSignal = nil
	end
	if self.onScienceQueueResearchSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.onScienceQueueResearchSignal)
		self.onScienceQueueResearchSignal = nil
	end
	if self.onScienceQueueFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueFinish, self.onScienceQueueFinishSignal)
		self.onScienceQueueFinishSignal = nil
	end
	if self.onHospitalUpdateSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.HospitalUpdate, self.onHospitalUpdateSignal)
		self.onHospitalUpdateSignal = nil
	end
	if self.hospitalStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.HospitaiStart, self.hospitalStartSignal)
		self.hospitalStartSignal = nil
	end
	if self.hospitalFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.HospitalFinish, self.hospitalFinishSignal)
		self.hospitalFinishSignal = nil
	end
	if self.queueTimeEndSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
		EventManager:GetInstance():RemoveListener(EventId.AllianceQueueHelpNew, self.queueTimeEndSignal)
		self.queueTimeEndSignal = nil
	end
	if self.onAllianceHelpCallBack ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.AllianceBuildHelpNew, self.onAllianceHelpCallBack)
		self.onAllianceHelpCallBack = nil
	end
	if self.updateBuildDataSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.updateBuildDataSignal)
		self.updateBuildDataSignal = nil
	end
	if self.checkDetectEventSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.GetAllDetectInfo, self.checkDetectEventSignal)
		EventManager:GetInstance():RemoveListener(EventId.DetectInfoChange, self.checkDetectEventSignal)
		EventManager:GetInstance():RemoveListener(EventId.FormationInfoUpdate, self.checkDetectEventSignal)
		self.checkDetectEventSignal = nil
	end
	if self.buildTimeEndSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.Build_Time_End, self.buildTimeEndSignal)
		
		self.buildTimeEndSignal = nil
	end
	if self.updateAllianceSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.AllianceMemberNeedHelp, self.updateAllianceSignal)
		EventManager:GetInstance():RemoveListener(EventId.AllianceQuitOK, self.updateAllianceSignal)
		EventManager:GetInstance():RemoveListener(EventId.AllianceBaseDataUpdated, self.updateAllianceSignal)
		EventManager:GetInstance():RemoveListener(EventId.OnGetNewAlJoinReq, self.updateAllianceSignal)
		self.updateAllianceSignal = nil
	end
	if self.garageRefitUpdateSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.GarageRefitUpdate, self.garageRefitUpdateSignal)
		self.garageRefitUpdateSignal = nil
	end
	if self.mainLvUpSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
		self.mainLvUpSignal = nil
	end
	if self.updateArmySignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.TrainArmyData, self.updateArmySignal)
		self.updateArmySignal = nil
	end
	if self.onCommonShopRedChangeSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnCommonShopRedChange, self.onCommonShopRedChangeSignal)
		self.onCommonShopRedChangeSignal = nil
	end
	if self.opinionUpdateSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OpinionUpdate, self.opinionUpdateSignal)
		EventManager:GetInstance():RemoveListener(EventId.OpinionChooseMail, self.opinionUpdateSignal)
		self.opinionUpdateSignal = nil
	end
	if self.storyUpdateHangupTimeSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.StoryUpdateHangupTime, self.storyUpdateHangupTimeSignal)
		EventManager:GetInstance():RemoveListener(EventId.ShowStoryRewardBubble, self.storyUpdateHangupTimeSignal)
		self.storyUpdateHangupTimeSignal = nil
	end
	if self.checkPubBubbleSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.HeroLotteryInfoUpdate, self.checkPubBubbleSignal)
		EventManager:GetInstance():RemoveListener(EventId.CheckPubBubble, self.checkPubBubbleSignal)
		self.checkPubBubbleSignal = nil
	end
	if self.refreshItemsSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.refreshItemsSignal)
		self.refreshItemsSignal = nil
	end
	if self.refreshHeroEquipSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.AddSpeedSuccess, self.refreshHeroEquipSignal)
		EventManager:GetInstance():RemoveListener(EventId.HeroEquipQueueFinish, self.refreshHeroEquipSignal)
		self.refreshHeroEquipSignal = nil
	end
	EventManager:GetInstance():RemoveListener(EventId.MonthCardInfoUpdated, self.RefreshGolloesCampBubbleSignal)
	EventManager:GetInstance():RemoveListener(EventId.RefreshHeroBountyBubble, self.CheckHeroBountySignal)
end

function BuildBubbleManager:Startup()
end

--获取建筑和气泡类型
function BuildBubbleManager:GetBuildBubbleTypeListByBuildType(buildType)
	-- 读缓存
	if self.buildTypeBubbleType[buildType] ~= nil then
		return self.buildTypeBubbleType[buildType]
	end
	local list = {}
	table.insert(list, BuildBubbleType.UpgradeAllianceHelp)
	table.insert(list,BuildBubbleType.UpgradeFinish)
	if buildType == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		table.insert(list,BuildBubbleType.CarSoldierEnd)
	elseif buildType == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		table.insert(list,BuildBubbleType.FootSoldierEnd)
	elseif buildType == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		table.insert(list,BuildBubbleType.BowSoldierEnd)
	elseif buildType == BuildingTypes.FUN_BUILD_SCIENE then
		table.insert(list, BuildBubbleType.ScienceFree)
		table.insert(list, BuildBubbleType.ScienceAllianceHelp)
		table.insert(list, BuildBubbleType.ScienceEnd)
	elseif buildType == BuildingTypes.FUN_BUILD_ARENA then
		table.insert(list,BuildBubbleType.ArenaFreeTime)
	elseif buildType == BuildingTypes.FUN_BUILD_RADAR_CENTER then
		table.insert(list,BuildBubbleType.DetectEvent)
	elseif buildType == BuildingTypes.FUN_BUILD_WATER_STORAGE then
		table.insert(list,BuildBubbleType.CommonShopFree)
	elseif buildType == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
		table.insert(list,BuildBubbleType.GolloesMonthCard)
	elseif DataCenter.BuildManager:GetGarageIndex(buildType) ~= nil then
		table.insert(list,BuildBubbleType.GarageRefitFree)
	elseif buildType == BuildingTypes.FUN_BUILD_HOSPITAL then
		table.insert(list, BuildBubbleType.HospitalFree)
		table.insert(list, BuildBubbleType.HospitalTreating)
		table.insert(list, BuildBubbleType.HospitalEnd)
		table.insert(list, BuildBubbleType.HospitalAllianceHelp)
	elseif buildType == BuildingTypes.FUN_BUILD_OPINION_BOX then
		table.insert(list, BuildBubbleType.OpinionBox)
	elseif buildType == BuildingTypes.DS_EXPLORER_CAMP then
		table.insert(list, BuildBubbleType.HangupReward)
	elseif buildType == BuildingTypes.APS_BUILD_PUB then
		table.insert(list, BuildBubbleType.HeroRecruit)
	elseif buildType == BuildingTypes.FUN_BUILD_HERO_BAR then
		table.insert(list, BuildBubbleType.PubFreeEnergy)
	elseif buildType == BuildingTypes.DS_EQUIP_SMELTING_FACTORY
			or buildType == BuildingTypes.DS_EQUIP_MATERIAL_FACTORY
			or buildType == BuildingTypes.DS_EQUIP_SMELTING_FACTORY_2 then
		table.insert(list,BuildBubbleType.GetItem)
	elseif buildType == BuildingTypes.DS_EQUIP_FACTORY  then
		table.insert(list,BuildBubbleType.HeroEquip)
	end
	table.sort(list, function(a, b)
		return BuildBubbleTypeOrder[a] < BuildBubbleTypeOrder[b]
	end)
	self.buildTypeBubbleType[buildType] = list
	return list
end

--获取建筑需要显示的气泡
function BuildBubbleManager:GetBuildNeedShowBuildBubble(uuid)
	if CS.SceneManager.World ~= nil and SceneUtils.GetIsInCity() then
		local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if data ~= nil and DataCenter.GuideManager:IsStartCanShowBuild() then
			local buildState = data.state
			if buildState ~= BuildingStateType.FoldUp and data.destroyStartTime <= 0 then
				local buildId = data.itemId
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
				local list = self:GetBuildBubbleTypeListByBuildType(data.itemId, buildTemplate, data.level)
				if list ~= nil and buildTemplate ~= nil then
					local isContinue = true
					local param = {}
					for k, v in ipairs(list) do
						if isContinue then
							if data:IsUpgradeFinish() == true then
								if v == BuildBubbleType.UpgradeFinish and data:IsNeedShowBox() then
									param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildUpgradeFinish)
									param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
									isContinue = false
									param.worldPos = buildTemplate:GetPosition()
									param.buildBubbleType = v
									param.callBack = self.on_click_callback
									param.uuid = uuid
									param.bgScale = BuildBubbleBgScale
									param.iconScale = ResetScale
									param.buildId = buildId
									param.bUuid = uuid
								end
							else
								if v == BuildBubbleType.FootSoldierEnd then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.FootSoldier)
									if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
										local armyId = ""
										local tempList = string.split_ss_array(queue.itemId, ";")
										if tempList[4] ~= nil then
											armyId = tempList[3]
										else
											armyId = tempList[1]
										end
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
										if template ~= nil then
											param.iconName = string.format(LoadPath.SoldierIcons, template.bubble_icon)
										end
										param.worldPos = buildTemplate:GetPosition()
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.CarSoldierEnd then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.CarSoldier)
									if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
										local armyId = ""
										local tempList = string.split_ss_array(queue.itemId, ";")
										if tempList[4] ~= nil then
											armyId = tempList[3]
										else
											armyId = tempList[1]
										end
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
										if template ~= nil then
											param.iconName = string.format(LoadPath.SoldierIcons, template.bubble_icon)
										end
										param.worldPos = buildTemplate:GetPosition()
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.BowSoldierEnd then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.BowSoldier)
									if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
										local armyId = ""
										local tempList = string.split_ss_array(queue.itemId, ";")
										if tempList[4] ~= nil then
											armyId = tempList[3]
										else
											armyId = tempList[1]
										end
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
										if template ~= nil then
											param.iconName = string.format(LoadPath.SoldierIcons, template.bubble_icon)
										end
										param.worldPos = buildTemplate:GetPosition()
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HospitalFree then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
									if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free and DataCenter.HospitalManager:IsHaveInjuredSolider() then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalFree)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HospitalTreating then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
									if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalTreating)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HospitalEnd then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
									if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										local template = DataCenter.HospitalManager:GetMaxSoldierInTreating()
										if template ~= nil then
											param.iconName = string.format(LoadPath.SoldierIcons, template.bubble_icon)
										end
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.ScienceFree then
									local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
									if data.level > 0 and buildState == BuildingStateType.Normal and queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ScienceFree)
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.ScienceEnd then
									local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
									if data.level > 0 and queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
										local id = tonumber(queue.itemId)
										local level = 1
										local science = DataCenter.ScienceDataManager:GetScienceById(id)
										if science ~= nil then
											level = science.level + 1
										end
										local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
										if template ~= nil then
											param.iconName = string.format(LoadPath.ScienceIcons, template.icon)
										end
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										param.worldPos = buildTemplate:GetPosition()
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.UpgradeAllianceHelp then
									if LuaEntry.Player:IsInAlliance() and data.updateTime > 0 and (data.isHelped == AllianceHelpState.No or data.isHelped == AllianceHelpState.RuinsHelped) and data.level > 0 then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.UpgradeAllianceHelp)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.ScienceAllianceHelp then
									local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
									if data.level > 0 and buildState == BuildingStateType.Normal and LuaEntry.Player:IsInAlliance() and queue ~= nil and queue:GetQueueState() == NewQueueState.Work and queue.isHelped == 0 then
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ScienceAllianceHelp)
										param.worldPos = buildTemplate:GetPosition()
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HospitalAllianceHelp then
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
									if data.level > 0 and buildState == BuildingStateType.Normal and LuaEntry.Player:IsInAlliance() and queue ~= nil and queue:GetQueueState() == NewQueueState.Work and queue.isHelped == 0 then
										param.worldPos = buildTemplate:GetPosition()
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HospitalAllianceHelp)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = queue.uuid
										param.itemId = queue.itemId
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.CommonShopFree then
									if data.level > 0 and buildState == BuildingStateType.Normal then
										--通用商店免费红点
										if DataCenter.CommonShopManager:GetRedCount() > 0 then
											param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.ShopFree)
											param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
											isContinue = false
											param.buildBubbleType = v
											param.worldPos = buildTemplate:GetPosition()
											param.callBack = self.on_click_callback
											param.uuid = uuid
											param.bgScale = BuildBubbleBgScale
											param.iconScale = ResetScale
											param.buildId = buildId
											param.bUuid = uuid
										end
									end
								elseif v == BuildBubbleType.DetectEvent then
									if data.level > 0 and DataCenter.RadarCenterDataManager:CanShowBuildBubble() then
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DetectEvent)
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.GarageRefitFree then
									if data.level > 0 and DataCenter.GarageRefitManager:CanShowBubble(buildId) then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.GarageRefitFree)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.ArenaFreeTime then
									if data.level > 0 and DataCenter.ArenaManager:GetChallengeRedCount() > 0 then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.AllianceBattle)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.OpinionBox then
									if data.level > 0 and DataCenter.OpinionManager:HasMailRed() then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.OpinionBox)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HangupReward then
									if data.level > 0 and DataCenter.StoryManager:CanShowBubble() then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HangupReward)
										if DataCenter.StoryManager:IsHangUpTimeMaxed() then
											param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DefaultYellow)

										else
											param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										end
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
										param.timerAction = function(time_text)
											local hangupTime = DataCenter.StoryManager:GetHangupTime()
											local curTime = UITimeManager:GetInstance():GetServerTime()
											local maxTime = DataCenter.StoryManager:GetMaxHangupTime()
											local time = math.min(curTime - hangupTime, maxTime)
											time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
										end
									end
								elseif v == BuildBubbleType.HeroRecruit then
									if data.level > 0 and (DataCenter.LotteryDataManager:HaveFree() or DataCenter.LotteryDataManager:CanAnyMultiRecruit()) then
										param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.HeroRecruit)
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.worldPos = buildTemplate:GetPosition()
										param.buildBubbleType = v
										param.callBack = self.on_click_callback
										param.uuid = uuid
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.PubFreeEnergy then
									if data.level > 0 then
										local showTime = DataCenter.BuildManager:GetShowBubbleTime(uuid)
										local now = UITimeManager:GetInstance():GetServerTime()
										if showTime > 0 then
											if showTime > now then
												--添加计时器
												self:AddOneWaitTimer(data.uuid, (showTime - now) / 1000)
											else
												param.iconName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Energy)
												param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
												isContinue = false
												param.worldPos = buildTemplate:GetPosition()
												param.buildBubbleType = v
												param.callBack = self.on_click_callback
												param.uuid = uuid
												param.bgScale = BuildBubbleBgScale
												param.iconScale = ResetScale
												param.buildId = buildId
												param.bUuid = uuid
											end
										end
									end
								elseif v == BuildBubbleType.GetItem then
									if data.level > 0 then
										local showTime = DataCenter.BuildManager:GetShowBubbleTime(uuid)
										local now = UITimeManager:GetInstance():GetServerTime()
										if showTime > 0 then
											if showTime >= now then
												--添加计时器
												self:AddOneWaitTimer(data.uuid, (showTime - now) / 1000, v)
											else
												local itemId = BuildingUtils:GetOutPutItemIdByBuildingId(buildId)
												param.iconName = DataCenter.ItemTemplateManager:GetIconPath(itemId)
												param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
												isContinue = false
												param.worldPos = buildTemplate:GetPosition()
												param.buildBubbleType = v
												param.pos = data.pointId
												param.tiles = buildTemplate.tiles
												param.callBack = self.on_click_callback
												param.uuid = uuid
												param.bgScale = BuildBubbleBgScale
												param.iconScale = ResetScale
												param.buildId = buildId
												param.bUuid = uuid
												local maxTime = DataCenter.BuildManager:GetShowBubbleTime(uuid, 1)
												local lastCollectTime = data.lastCollectTime
												local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, data.level)
												if levelTemplate ~= nil then
													local collectMax = levelTemplate:GetCollectMax()
													param.progressTimerAction = function(fill, text)
														if maxTime < lastCollectTime then
															return
														end
														local totalTime = math.max(maxTime - lastCollectTime, 1)
														local progress = 1
														if now > lastCollectTime then
															local cutTime = now - lastCollectTime
															progress = math.min(cutTime / totalTime, 1)
														end
														fill:SetFillAmount(progress)

														local outPut = math.floor(collectMax * progress)
														param.outPut = outPut
														text:SetText(outPut)
													end
												end
											end
										end
									end
								elseif v == BuildBubbleType.HeroEquip then
									if data.level > 0 then
										local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
										if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
											param.iconName = HeroEquipUtil:GetEquipmentIcon(queue.itemId)
											param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
											isContinue = false
											param.worldPos = buildTemplate:GetPosition()
											param.buildBubbleType = v
											param.pos = data.pointId
											param.tiles = buildTemplate.tiles
											param.callBack = self.on_click_callback
											param.uuid = uuid
											param.bgScale = BuildBubbleBgScale
											param.iconScale = ResetScale
											param.buildId = buildId
											param.bUuid = uuid
										end
									end
								elseif v == BuildBubbleType.HeroBountyFinish then
									if data.level > 0 and DataCenter.HeroBountyDataManager:GetIsShowBubble() and DataCenter.HeroBountyDataManager:GetIsTaskFinish() then
										param.iconName = string.format(LoadPath.UIBuildBubble, "bubble_icon_bounty2")
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.HeroBountyFree then
									if data.level > 0 and DataCenter.HeroBountyDataManager:GetIsShowBubble() and DataCenter.HeroBountyDataManager:GetIsTaskFinish() == false then
										param.iconName = string.format(LoadPath.UIBuildBubble, "bubble_icon_bounty1")
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								elseif v == BuildBubbleType.GolloesMonthCard then
									local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
									local hasMonthCard = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
									local hasShow = DataCenter.MonthCardNewManager:HasClickBubble()
									if isAvailable == true and hasMonthCard == false and hasShow == false then
										param.iconName = string.format(LoadPath.UIBuildBubble, "bubble_icon_decorate_30day")
										param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Default)
										isContinue = false
										param.buildBubbleType = v
										param.worldPos = buildTemplate:GetPosition()
										param.callBack = self.on_click_callback
										param.bgScale = BuildBubbleBgScale
										param.iconScale = ResetScale
										param.buildId = buildId
										param.bUuid = uuid
									end
								end
								
							end
						end

					end
					if not isContinue then
						return param
					end
				end
			end
		end
	end
	return nil
end

--删除该建筑所有气泡
function BuildBubbleManager:DeleteOneBuildBubble(bUuid)
	EventManager:GetInstance():Broadcast(EventId.RemoveOneBuildBubble, bUuid)
	self:RemoveOneWaitTimer(bUuid)
end

--显示一个气泡
function BuildBubbleManager:ShowOneBuildBubble(param)
	EventManager:GetInstance():Broadcast(EventId.ShowOneBuildBubble, param)
end

function BuildBubbleManager:OnBuildTrainingStartSignal(data)
	self:CheckShowBubble(data)
end

function BuildBubbleManager:RefreshGolloesCampBubbleSignal()
	local buildUuid = 0
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRAINFIELD_4)
	if buildData then
		buildUuid = buildData.uuid
	end
	DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
end

function BuildBubbleManager:OnScienceQueueResearchSignal(bUuid)
	self:CheckShowBubble(bUuid)
end

function BuildBubbleManager:HospitalStartSignal(data)
	self:RefreshBubbleByQueueType(NewQueueType.Hospital)
end

function BuildBubbleManager:QueueTimeEndSignal(data)
	self:RefreshBubbleByQueueType(data)
end

function BuildBubbleManager:OnAllianceHelpCallBack(data)
	self:CheckShowBubble(tonumber(data))
end

function BuildBubbleManager:OnClickCallBack(param)
	local guideParam = {}
	guideParam.buildBubbleType = param.buildBubbleType
	DataCenter.GuideManager:SetCompleteNeedParam(guideParam)
	DataCenter.GuideManager:CheckGuideComplete()
	
	if param.buildBubbleType == BuildBubbleType.FootSoldierEnd then
		--收兵 步兵
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Soldier)
		DataCenter.ArmyManager:CheckSendFinish(NewQueueType.FootSoldier)
	elseif param.buildBubbleType == BuildBubbleType.CarSoldierEnd then
		--收兵 坦克
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Soldier)
		DataCenter.ArmyManager:CheckSendFinish(NewQueueType.CarSoldier)
	elseif param.buildBubbleType == BuildBubbleType.BowSoldierEnd then
		--收兵 飞机
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Soldier)
		DataCenter.ArmyManager:CheckSendFinish(NewQueueType.BowSoldier)
	elseif param.buildBubbleType == BuildBubbleType.HospitalFree then
		--打开医院界面
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHospital)
	elseif param.buildBubbleType == BuildBubbleType.HospitalTreating then
		--打开加速界面
		local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
		if queue ~= nil then
			local state = queue:GetQueueState()
			if state == NewQueueState.Work then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, NormalBlurPanelAnim, ItemSpdMenu.ItemSpdMenu_Heal,queue.uuid)
			end
		end
	elseif param.buildBubbleType == BuildBubbleType.HospitalEnd then
		--收治疗兵
		DataCenter.HospitalManager:CheckSendFinish()
	elseif param.buildBubbleType == BuildBubbleType.ScienceFree then
		--打开科技界面
		GoToUtil.GotoScience()
	elseif param.buildBubbleType == BuildBubbleType.ScienceEnd then
		--收科技
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Science)
		DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(param.bUuid)
	elseif param.buildBubbleType == BuildBubbleType.AllianceHelp then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Alliance)
		local curTime = UITimeManager:GetInstance():GetServerTime()
		DataCenter.AllianceHelpDataManager:SetHelpNum(0)
		SFSNetwork.SendMessage(MsgDefines.AlHelpAll,math.floor(curTime))
	elseif param.buildBubbleType == BuildBubbleType.CommonShopFree then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
	elseif param.buildBubbleType == BuildBubbleType.UpgradeAllianceHelp then
		SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp,param.uuid,AllianceHelpType.Building,NewQueueType.Default,"")
	elseif param.buildBubbleType == BuildBubbleType.ScienceAllianceHelp then
		SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp,param.uuid,AllianceHelpType.Queue,NewQueueType.Science,param.itemId)
	elseif param.buildBubbleType == BuildBubbleType.HospitalAllianceHelp then
		SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp,param.uuid,AllianceHelpType.Queue,NewQueueType.Hospital,param.itemId)
	elseif param.buildBubbleType == BuildBubbleType.HeroRecruit then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, true)
	elseif param.buildBubbleType == BuildBubbleType.DetectEvent then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
	elseif param.buildBubbleType == BuildBubbleType.DetectEventFinished then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
	elseif param.buildBubbleType == BuildBubbleType.GarageRefitFree then
		GoToUtil.GoToGarageRefit(param.buildId)
	elseif param.buildBubbleType == BuildBubbleType.ArenaFreeTime then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Arena)
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaMain,{anim = false})
	elseif param.buildBubbleType == BuildBubbleType.OpinionBox then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIOpinionBox)
	elseif param.buildBubbleType == BuildBubbleType.HangupReward then
		if DataCenter.LandManager:IsFunctionEnd() then
			--打开推图关
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureMain,  { anim = true })
		end
		--打开挂机奖励
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureReward, NormalPanelAnim)
	elseif param.buildBubbleType == BuildBubbleType.PubFreeEnergy then
		local maxNum = 100
		local config = DataCenter.ArmyFormationDataManager:GetConfigData()
		if config~=nil then
			maxNum = config.FormationStaminaMax
		end
		local curNum = LuaEntry.Player:GetCurStamina()
		if curNum >= maxNum then
			UIUtil.ShowTipsId(143603)
		else
			local num = DataCenter.BuildManager:GetOutResourceNum(param.bUuid)
			if num > 0 then
				--飞图标
				local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(param.buildBubbleType, param.buildId)
				if obj ~= nil then
					UIUtil.DoFly(RewardType.FORMATION_STAMINA ,6, param.iconName, obj:GetArrowPosition(),
							UIUtil.GetUIMainSavePos(UIMainSavePosType.Stamina))
				end
				SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {resourceType = ResourceType.FORMATION_STAMINA})
				self:DeleteOneBuildBubble(param.bUuid)
				UIUtil.ShowTips(Localization:GetString(GameDialogDefine.GOT_STAMINA) .. " +" .. string.GetFormattedSeperatorNum(num))
			end
		end
	elseif param.buildBubbleType == BuildBubbleType.GolloesMonthCard then
		DataCenter.MonthCardNewManager:OnClickBubble()
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = WelfareTagType.MonthCard })
		self:DeleteOneBuildBubble(param.bUuid)
	elseif param.buildBubbleType == BuildBubbleType.UpgradeFinish then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Bubble_Build_Finish)
		DataCenter.BuildManager:CheckSendBuildFinish(param.bUuid)
	elseif param.buildBubbleType == BuildBubbleType.GetItem then
		self:CollectItem(param)
	elseif param.buildBubbleType == BuildBubbleType.HeroEquip then
		self:CollectHeroEquip(param)
	end

	local bubbleName = DataCenter.BuildBubbleManager:GetBubbleNameByBubbleType(param.buildBubbleType)
	if bubbleName ~= nil and param.buildId ~= nil then
		DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickBubble, param.buildId..";".. bubbleName)
	end
end
function BuildBubbleManager:CollectItem(param)
	local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(param.bUuid)
	if DataCenter.BuildManager:IsCanOutItemByBuildId(tempBuild.itemId) then
		if tempBuild.state == BuildingStateType.Normal then
			local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(param.buildBubbleType, param.buildId)
			if obj ~= nil then
				UIUtil.DoFly(RewardType.GOODS , 6, param.iconName, obj:GetArrowPosition(), UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods))
			end
			local itemId = ''
			if param.buildId == BuildingTypes.DS_EQUIP_SMELTING_FACTORY
					or param.buildId == BuildingTypes.DS_EQUIP_SMELTING_FACTORY_2 then
				itemId = BuildingUtils.ITEM_SMELTING
				SFSNetwork.SendMessage(MsgDefines.UserResSynNew,{resourceType = 10001, itemId = itemId})
			elseif param.buildId == BuildingTypes.DS_EQUIP_MATERIAL_FACTORY then
				itemId = BuildingUtils.ITEM_MATERIAL
				SFSNetwork.SendMessage(MsgDefines.UserResSynNew,{resourceType = 10001, itemId = itemId})
			end

			self:DeleteOneBuildBubble(param.bUuid)
		end
	end
end
function BuildBubbleManager:CollectHeroEquip(param)
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		DataCenter.HeroEquipManager:HeroEquipCollect(queue.uuid, queue.itemId);
	end
	self:DeleteOneBuildBubble(param.bUuid)
end
function BuildBubbleManager:CheckHeroBountySignal()
	local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_HERO_BOUNTY)
	for k1,v1 in pairs(list) do
		DataCenter.BuildBubbleManager:CheckShowBubble(v1.uuid)
	end
end
function BuildBubbleManager:OnBuildTrainingFinishSignal(data)
	self:RefreshBubbleByQueueType(data)
end

function BuildBubbleManager:OnScienceQueueFinishSignal()
	self:RefreshBubbleByQueueType(NewQueueType.Science)
end

function BuildBubbleManager:RefreshBubbleByQueueType(queueType)
	local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(tonumber(queueType))
	local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
	if list ~= nil then
		for k, v in ipairs(list) do
			DataCenter.BuildBubbleManager:CheckShowBubble(v.uuid)
		end
	end
end

function BuildBubbleManager:HospitalFinishSignal()
	self:RefreshBubbleByQueueType(NewQueueType.Hospital)
end

function BuildBubbleManager:OnHospitalUpdateSignal()
	self:RefreshBubbleByQueueType(NewQueueType.Hospital)
end

function BuildBubbleManager:UpdateAllianceSignal()
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
	if buildData then
		DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
	end
end

function BuildBubbleManager:UpdateArmySignal()
	--local list = { EffectDefine.DAILY_FREE_INFANTRY, EffectDefine.DAILY_FREE_TANK, EffectDefine.DAILY_FREE_PLANE, EffectDefine.DAILY_FREE_TRAP }
	--for _, effectId in ipairs(list) do
	--	DataCenter.BuildBubbleManager.RefreshHeroEffectSkillSignal(effectId)
	--end
	--local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BARRACKS)
	--if buildData then
	--	DataCenter.BuildBubbleManager:CheckShowBubble(buildData.uuid)
	--end
end

function BuildBubbleManager:CheckShowBubble(bUuid)
	if self.noRefreshTimer[bUuid] == nil then
		if DataCenter.BuildManager:IsBuildInView(bUuid) then
			local param = self:GetBuildNeedShowBuildBubble(bUuid)
			if param == nil then
				self:DeleteOneBuildBubble(bUuid)
			else
				self:ShowOneBuildBubble(param)
			end
		else
			self:DeleteOneBuildBubble(bUuid)
		end
	end
end

function BuildBubbleManager:UpdateBuildDataSignal(bUuid)
	if bUuid ~= nil then
		DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(bUuid))
	end
end

function BuildBubbleManager:BuildTimeEndSignal(bUuid)
	if bUuid ~= nil then
		DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(bUuid))
	end
end

function BuildBubbleManager:CheckDetectEventSignal()
	DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DetectEvent)
end


function BuildBubbleManager:GetBuildListByBubbleType(type)
	local result = {}
	if type == BuildBubbleType.DetectEvent or type == BuildBubbleType.DetectEventFinished then
		table.insert(result, BuildingTypes.FUN_BUILD_RADAR_CENTER)
	elseif type == BuildBubbleType.GarageRefitFree then
		for _, garage in ipairs(GarageBuildIds) do
			table.insert(result,garage)
		end
		table.insert(result, BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
	elseif type == BuildBubbleType.ArenaFreeTime then
		table.insert(result, BuildingTypes.FUN_BUILD_ARENA)
	elseif type == BuildBubbleType.CommonShopFree then
		table.insert(result, BuildingTypes.FUN_BUILD_WATER_STORAGE)
	elseif type == BuildBubbleType.OpinionBox then
		table.insert(result, BuildingTypes.FUN_BUILD_OPINION_BOX)
	elseif type == BuildBubbleType.HangupReward then
		table.insert(result, BuildingTypes.DS_EXPLORER_CAMP)
	elseif type == BuildBubbleType.HeroRecruit then
		table.insert(result, BuildingTypes.APS_BUILD_PUB)
	elseif type == BuildBubbleType.HeroEquip then
		table.insert(result, BuildingTypes.DS_EQUIP_FACTORY)
	end
	return result
end

function BuildBubbleManager:CheckShowByBubbleType(type)
	local buildList = self:GetBuildListByBubbleType(type)
	for k,v in ipairs(buildList) do
		local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
		for k1,v1 in pairs(list) do
			DataCenter.BuildBubbleManager:CheckShowBubble(v1.uuid)
		end
	end
end

--通过建筑id和气泡类型获取气泡obj
function BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(bubbleType, buildId)
	local windowName = UIWindowNames.UIBubble
	if UIManager:GetInstance():IsPanelLoadingComplete(windowName) then
		local luaWindow = UIManager:GetInstance():GetWindow(windowName)
		if luaWindow ~= nil and luaWindow.View ~= nil then
			local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
			if buildData ~= nil then
				local obj = luaWindow.View:GetObjByBuildUuid(buildData.uuid)
				if obj ~= nil then
					if obj.param ~= nil and obj.param.buildBubbleType == bubbleType then
						return obj
					end
				end
			end
		end
	end
end

function BuildBubbleManager:ShowBubbleNode()
	if not self.showBubbleNode then
		self.showBubbleNode = true
		self:RefreshBubbleNode()
	end
end

function BuildBubbleManager:HideBubbleNode()
	if self.showBubbleNode then
		self.showBubbleNode = false
		self:RefreshBubbleNode()
	end
end

function BuildBubbleManager:RefreshBubbleNode()
	EventManager:GetInstance():Broadcast(EventId.RefreshBubbleActive)
end

function BuildBubbleManager:GetBubbleNameByBubbleType(bubbleType)
	for k,v in pairs(BuildBubbleType) do
		if v == bubbleType then
			return k
		end
	end
end

function BuildBubbleManager:ClearAll()
	self:ClearAllNoRefresh()
end

function BuildBubbleManager:GarageRefitUpdateSignal()
	DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.GarageRefitFree)
end

function BuildBubbleManager:MainLvUpSignal()
	DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.GarageRefitFree)
	DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.DetectEvent)
end

function BuildBubbleManager:NoRefreshSignal(uuid)
	DataCenter.BuildBubbleManager:SetNoRefresh(uuid)
end

function BuildBubbleManager:SetNoRefresh(uuid)
	self:ClearOneNoRefresh(uuid)
	if self.noRefreshTimer[uuid] == nil then
		self.noRefreshTimer[uuid] = TimerManager:GetInstance():GetTimer(NoRefreshTime, self.noRefreshTimerCallBack, uuid, true,false,false)
		self.noRefreshTimer[uuid]:Start()
	end
end

function BuildBubbleManager:ClearOneNoRefresh(uuid)
	if self.noRefreshTimer[uuid] ~= nil then
		self.noRefreshTimer[uuid]:Stop()
		self.noRefreshTimer[uuid] = nil
	end
end

function BuildBubbleManager:NoRefreshTimerCallBack(uuid)
	if self.noRefreshTimer[uuid] ~= nil then
		self:ClearOneNoRefresh(uuid)
		self:CheckShowBubble(uuid)
	end
end

function BuildBubbleManager:ClearAllNoRefresh()
	if self.noRefreshTimer ~= nil then
		for k,v in pairs(self.noRefreshTimer) do
			v:Stop()
		end
		self.noRefreshTimer = {}
	end
end

function BuildBubbleManager:OnEnterCitySignal()
	self:RefreshBubbleNode()
end

function BuildBubbleManager:OnUpdateArenaBaseInfoSignal()
	self:CheckShowByBubbleType(BuildBubbleType.ArenaFreeTime)
end

function BuildBubbleManager:OnCommonShopRedChangeSignal()
	self:CheckShowByBubbleType(BuildBubbleType.CommonShopFree)
end

function BuildBubbleManager:CanShowBubble()
	return self.showBubbleNode
end

function BuildBubbleManager:OpinionUpdateSignal()
	self:CheckShowByBubbleType(BuildBubbleType.OpinionBox)
end

function BuildBubbleManager:StoryUpdateHangupTimeSignal()
	self:CheckShowByBubbleType(BuildBubbleType.HangupReward)
end

function BuildBubbleManager:CheckPubBubbleSignal()
	self:CheckShowByBubbleType(BuildBubbleType.HeroRecruit)
end

function BuildBubbleManager:RefreshItemsSignal()
	self:CheckShowByBubbleType(BuildBubbleType.HeroRecruit)
	self:CheckShowByBubbleType(BuildBubbleType.GarageRefitFree)
end

function BuildBubbleManager:RefreshHeroEquipSignal()
	self:CheckShowByBubbleType(BuildBubbleType.HeroEquip)
end

function BuildBubbleManager:AddOneWaitTimer(uuid, time)
	local timeParam = self.wait_timer[uuid]
	if timeParam == nil or timeParam.time > time then
		self:RemoveOneWaitTimer(uuid)
		local param = {}
		param.uuid = uuid
		param.time = time
		param.timer = TimerManager:GetInstance():GetTimer(time, self.wait_timer_callback, uuid, true, false, false)
		param.timer:Start()
		self.wait_timer[uuid] = param
	end
end

function BuildBubbleManager:RemoveOneWaitTimer(uuid)
	if self.wait_timer[uuid] ~= nil then
		self.wait_timer[uuid].timer:Stop()
		self.wait_timer[uuid] = nil
	end
end

function BuildBubbleManager:WaitTimerCallBack(uuid)
	self:RemoveOneWaitTimer(uuid)
	self:CheckShowBubble(uuid)
end

function BuildBubbleManager:RemoveAllTimer()
	for k, v in pairs(self.wait_timer) do
		v.timer:Stop()
	end
	self.wait_timer = {}
end


return BuildBubbleManager