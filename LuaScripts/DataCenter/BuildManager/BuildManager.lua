--数据更新要和刷新表现分开 BuildingDate 为数据  fire为刷表现，一定要先把数据全部更新完，在刷表现 2023.4.21 整理一次
local BuildManager = BaseClass("BuildManager")
local BuildingDate = require "DataCenter.BuildManager.BuildingDate"
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local RewardUtil = require "Util.RewardUtil"
local Resource = CS.GameEntry.Resource

local function __init(self)
	self.inViewBuild = {}
	self.noShowRedDot = {} --不显示红点的建筑ID list
	self.noShowUnlock = nil --不显示解锁动画的建筑ID list
	self.changeMovePos = {}
	self.allBuilding = {} --所有建筑数据  (建筑uuid,data)
	self.buildIdBuilding = {}--(建筑id,data)
	self.MainLv = 0--主基地等级
	self.main_city_pos = Vector2.New(50, 50)--主城中心点坐标（中心点）
	self.showPoint = 0--新号开始展示主城点
	self.newUserWorld = 0
	self.pickEffect = {}
	self.sendList ={}
	self.sendFixList = {}
	self.country = nil
	self.showCityLabel = true
	self:AddListener()
	self.showPutBuildFromPanel = nil--从哪个面板打开的建筑放置界面
	self.timer_action = function(temp)
		self:PostNotice()
	end
	self.upgradeReward = {}
	self.curMainBuildStamina = 0 --记录大本升级前燃料值
	self.onMovingStateBuildUuid = 0
	self.isCheck = false
	self.inViewWorldBuild = {}
	self.fireData = {}--缓存发送到c#的建筑数据(增加/更新建筑)
	self.fireRemoveData = {}--缓存发送到c#的建筑数据（删除建筑）
	self.waitFireEvent = {}--为了实现先修改数据 在刷新表现，建筑的表现全部放到这里，等数据修改完统一发送
	self.showSafe = false
	self.hurtReqs = {}
end

local function __delete(self)
	self.sendList = nil
	self.sendFixList = nil
	self.inViewBuild = nil
	self.noShowRedDot = nil
	self.noShowUnlock = nil
	self.changeMovePos = nil
	self.allBuilding = {}
	self.buildIdBuilding = {}
	self.MainLv = 0
	self.main_city_pos = Vector2.New(50, 50)--主城中心点坐标（中心点）
	self.newUserWorld = nil
	self.showPoint = nil
	self.showPutBuildFromPanel = nil
	self.country = nil
	for i, v in pairs(self.pickEffect) do
		v:Destroy()
		self.pickEffect[i] = nil
	end
	self.pickEffect = nil
	self.showCityLabel = nil
	self.upgradeReward = nil
	self.curMainBuildStamina= nil
	self:RemoveListener()
	self.inViewWorldBuild = {}
	self.fireData = {}--缓存发送到c#的建筑数据(增加/更新建筑)
	self.fireRemoveData = {}--缓存发送到c#的建筑数据（删除建筑）
	self.waitFireEvent = {}--为了实现先修改数据 在刷新表现，建筑的表现全部放到这里，等数据修改完统一发送
	self.hurtReqs = {}
end

local function Startup()
end

local function InitData(self,message)
	if message["user"] ~= nil then
		local u = message["user"]
		if u["newUserWorld"] ~= nil then
			self.newUserWorld = u["newUserWorld"]
		else
			self.newUserWorld = NewUserWorld.Pass
		end
		self.country = u["country"]
	else
		self.newUserWorld = NewUserWorld.Pass
	end
	self:UpdateBuildings(message["building_new"]);
	if message["world_building"]~=nil then
		local dic = message["world_building"]
		for k,v in pairs(dic) do
			local buildId = v["bId"]
			if buildId~= BuildingTypes.FUN_BUILD_MAIN then
				self:AddBuilding(v, true)
			end
		end
	end

	if message["worldMainPoint"]~=nil then
		LuaEntry.Player:SetMainWorldPointId(message["worldMainPoint"])
	end
	local effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
	if effectTime > 0 then
		self.isCheck = true
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function SetOnMovingBuildUuid(self,uuid)
	self.onMovingStateBuildUuid = uuid
end
local function GetOnMovingBuildUuid(self)
	return self.onMovingStateBuildUuid
end
local function UpdateBuildings(self, message)
	self.allBuilding = {}
	self.buildIdBuilding = {}
	for k,v in pairs(message) do
		self:AddBuilding(v)
	end
	DataCenter.BuildCityBuildManager:InitData()
end

local function AddBuilding(self,message,isWorldBuild)
	local uuid = message["uuid"]
	local one = self.allBuilding[uuid]
	local oldLevel, newLevel, oldPointId, newPointId = -1, -1, 0, 0
	if one == nil then
		one = BuildingDate.New()
		one:UpdateInfo(message, isWorldBuild)
		self.allBuilding[uuid] = one
		local buildId = one.itemId
		if self.buildIdBuilding[buildId] == nil then
			self.buildIdBuilding[buildId] = {}
		end
		table.insert(self.buildIdBuilding[buildId],one)
	else
		oldLevel = one.level
		oldPointId = one.pointId
		one:UpdateInfo(message)
	end
	if one.itemId == BuildingTypes.FUN_BUILD_MAIN then
		self:AddOneWaitFireEvent(EventId.HeroStationUpdate)
		self:AddOneWaitFireEvent(EventId.RefreshWelfareRedDot)
		self:AddOneWaitFireEvent(EventId.MainLvUp)
	end

	newLevel = one.level
	newPointId = one.pointId
	if newLevel > oldLevel then
		local info = {}
		info.uuid = uuid
		info.oldLevel = oldLevel
		info.newLevel = newLevel
		self:AddOneWaitFireEvent(EventId.BuildLevelUp, info)
	end
	if newPointId ~= oldPointId then
		local info = {}
		info.uuid = uuid
		info.oldPointId = oldPointId
		info.newPointId = newPointId
		self:AddOneWaitFireEvent(EventId.BuildMove, info)
	end
	if BuildingUtils.IsInEdenSubwayGroup(one.itemId) == true then
		EventManager:GetInstance():Broadcast(EventId.UIEdenSubwayBuildUpdate,one.itemId)
	end
	DataCenter.BuildQueueManager:RefreshWorldBuildQueueList(one)
	DataCenter.DesertDataManager:UpdateSeasonBuildList(one)
	self:AddOneFireData(one)
end
--删除一个建筑，只删除数据
local function RemoveBuilding(self,uuid)
	if self.allBuilding[uuid] ~= nil then
		local buildId =self.allBuilding[uuid].itemId
		local list = self.buildIdBuilding[buildId]
		if list ~= nil then
			local removeId = 0
			for k,v in ipairs(list) do
				if v.uuid == uuid then
					removeId = k
				end
			end
			table.remove(self.buildIdBuilding[buildId],removeId)
			if table.count(self.buildIdBuilding[buildId]) == 0 then
				self.buildIdBuilding[buildId] = nil
			end
		end
		if BuildingUtils.IsInEdenSubwayGroup(buildId) == true then
			EventManager:GetInstance():Broadcast(EventId.UIEdenSubwayBuildUpdate,buildId)
		end
		self.allBuilding[uuid] = nil
	end
	self:AddOneFireRemoveData(uuid)
	DataCenter.BuildQueueManager:RemoveFromWorldBuildQueueList(uuid)
	DataCenter.DesertDataManager:RemoveSeasonBuild(uuid)
end

local function CheckIsSendMessage(self,uuid)
	return self.sendList[uuid]~=nil
end

local function CheckIsSendFixMessage(self,uuid)
	return self.sendFixList[uuid]~=nil
end

local function DelayClearSendList(self,uuid)
	self.sendList[uuid] = true
	TimerManager:GetInstance():DelayInvoke(function()
		if self.sendList~=nil then
			self.sendList[uuid]=nil
		end
	end, 1)
end

local function DelayClearSendFixList(self,uuid)
	self.sendFixList[uuid] = true
	TimerManager:GetInstance():DelayInvoke(function()
		if self.sendFixList~=nil then
			self.sendFixList[uuid]=nil
		end
	end, 1)
end
local function BuildCcdMNewHandle(self,message)
	if message["errorCode"] == nil then
		if message["remainGold"] ~= nil then
			LuaEntry.Player.gold = message["remainGold"]
			self:AddOneWaitFireEvent(EventId.UpdateGold)
		end
		local arrays = message["itemCostArr"]
		if arrays ~= nil then
			for k,v in pairs(arrays) do
				DataCenter.ItemData:UpdateOneItem(v)
			end
		end

		local bUuid = 0
		local endTime = 0
		local startTime =0
		local buildId = 0
		local buildLevel = 0
		local isFixRuin = false
		if message["isFixRuins"]~=nil then
			isFixRuin = message["isFixRuins"]
		end
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			bUuid = dic["uuid"]
			if dic ~= nil then
				self:AddBuilding(dic)
				local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
				if buildData~=nil then
					bUuid = buildData.uuid
					if isFixRuin==true then
						startTime =buildData.destroyStartTime
						endTime = buildData.destroyEndTime
						buildId = buildData.itemId
						buildLevel = buildData.level
						if buildData:IsFixFinish() then
							DataCenter.BuildQueueManager:SetFixFinishFlag(bUuid)
						end
					else
						startTime =buildData.startTime
						endTime = buildData.updateTime
						buildId = buildData.itemId
						buildLevel = buildData.level
						if buildData:IsUpgradeFinish() then
							DataCenter.BuildQueueManager:SetTimeFinishFlag(bUuid)
						end
					end
				end

				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
			end
		end

		if message["finished"] ~= nil then
			local isFinish = message["finished"]
			if isFinish then
				if self:CheckShowUnlock(buildId,buildLevel) == false then
					--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeTip,{anim = true}, {buildUid = bUuid})
					--self:AddOneWaitFireEvent(EventId.ShowPower,RewardType.POWER)
				end
				--self:CheckShowBuildAddDes(buildId,level)
				self:CheckShowFogUnlock(buildId,buildLevel)
				self:AddOneWaitFireEvent(EventId.BuildUpgradeFinish,bUuid)
				if buildId ~= 0 then
					UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FINISH_UPGRADE_WITH,
							Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + buildLevel, "name"))))
					local power = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + buildLevel, "power", 0)
					if buildLevel > 1 then
						power = power - GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + buildLevel - 1, "power", 0)
					end
					if power > 0 then
						GoToUtil.ShowPower({power = power})
					end
				end
				--self:AddOneWaitFireEvent(EventId.ShowMainUIPart)
				SoundUtil.PlayEffect(SoundAssets.Music_Effect_Finish)
				--CS.BuildingUtils.ShowAddPower(bUuid)
			end
		end
		if isFixRuin == true then
			local signal = SFSObject.New()
			signal:PutLong("bUuid", bUuid)
			signal:PutLong("endTime", endTime)
			signal:PutLong("startTime",startTime)
			self:AddOneWaitFireEvent(EventId.AddBuildFixSpeedSuccess,signal)
		else
			self:AddOneWaitFireEvent(EventId.AddBuildSpeedSuccess, bUuid)
		end
		local backRewards = message["backRewards"]
		if backRewards ~= nil then
			for k, v in pairs(backRewards) do
				DataCenter.RewardManager:AddOneReward(v)
			end
			local list = DataCenter.RewardManager:ReturnRewardParamForMessage(backRewards)
			if list ~= nil then
				for k,v in ipairs(list) do
					if v.rewardType == RewardType.GOODS then
						--这里极特殊处理
						DataCenter.WaitTimeManager:AddOneWait(WaitTipsTime, function()
							UIUtil.ShowTips(Localization:GetString(GameDialogDefine.BACK_REWARD_TIP_WITH,
									DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId),
									string.GetFormattedSeperatorNum(v.count)))
						end)
						break
					end
				end
			end
		end
		
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		local temp = message["errorCode"]
		if temp == "E100173" then
			UIUtil.ShowTipsId(170008)
		else
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	end
end

local function GetBuildIdByNewQueue(self,queueType)
	if queueType == NewQueueType.Science then
		return BuildingTypes.FUN_BUILD_SCIENE
	elseif queueType == NewQueueType.FootSoldier then
		return BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
	elseif queueType == NewQueueType.CarSoldier then
		return BuildingTypes.FUN_BUILD_CAR_BARRACK
	elseif queueType == NewQueueType.BowSoldier then
		return BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK
	elseif queueType == NewQueueType.Trap then
		return BuildingTypes.FUN_BUILD_TRAP_BARRACK
	elseif queueType == NewQueueType.Hospital then
		return BuildingTypes.FUN_BUILD_HOSPITAL
	end
end

local function GetNewQueueTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_SCIENE or buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART or buildId == BuildingTypes.FUN_BUILD_SCIENCE_1 then
		return NewQueueType.Science
	elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		return NewQueueType.FootSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		return NewQueueType.CarSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		return NewQueueType.BowSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
		return NewQueueType.Trap
	elseif buildId == BuildingTypes.FUN_BUILD_HOSPITAL then
		return NewQueueType.Hospital
	end
end

local function AddListener(self)
	EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
	EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
	EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UILoadingExitSignal)--进入场景
	EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
	if self.worldBuildInViewSignal == nil then
		self.worldBuildInViewSignal = function(uuid)
			self:WorldBuildInViewSignal(uuid)
		end
		EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_IN_VIEW, self.worldBuildInViewSignal)
	end
	if self.worldBuildOutViewSignal == nil then
		self.worldBuildOutViewSignal = function(uuid)
			self:WorldBuildOutViewSignal(uuid)
		end
		EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.worldBuildOutViewSignal)
	end
end

local function RemoveListener(self)
	EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
	EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
	EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
	EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
	if self.worldBuildInViewSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_IN_VIEW, self.worldBuildInViewSignal)
		self.worldBuildInViewSignal = nil
	end
	if self.worldBuildOutViewSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.worldBuildOutViewSignal)
		self.worldBuildOutViewSignal = nil
	end
end

--视野中添加一个建筑
local function AddOneBuildInView(self,bUuid)
	self.inViewBuild[bUuid] = true
	
end

--视野中删除一个建筑
local function RemoveOneBuildInView(self,bUuid)
	self.inViewBuild[bUuid] = nil
end

--一个建筑进入视野
local function BuildInViewSignal(bUuid)
	DataCenter.BuildManager:AddOneBuildInView(bUuid)
	DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
	DataCenter.FurnitureObjectManager:ShowOneBuildFurniture(bUuid)
	DataCenter.CityLabelManager:AddOneBuildInView(bUuid)
	DataCenter.BuildEffectManager:CheckShowEffect(bUuid)
end

--一个建筑离开视野
local function BuildOutViewSignal(bUuid)
	DataCenter.BuildManager:RemoveOneBuildInView(bUuid)
	DataCenter.BuildBubbleManager:DeleteOneBuildBubble(bUuid)
	DataCenter.FurnitureObjectManager:HideOneBuildFurniture(bUuid)
	DataCenter.CityLabelManager:BuildOutViewSignal(bUuid)
	DataCenter.BuildEffectManager:DeleteOneBuildEffect(bUuid)
end

--这个建筑在是否在视野中
local function IsBuildInView(self,bUuid)
	return self.inViewBuild[bUuid] ~= nil
end

--获取建筑的建造状态
local function GetBuildState(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
		--特殊建筑处理，默认最大值为0，仅在作用号加成下增加数量
		if self:GetMaxBuildNum(buildId) == 0 then
			return BuildState.BUILD_LIST_STATE_VIP_LEVEL
		end
	elseif buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
		if self:GetMaxBuildNum(buildId) == 0 then
			return BuildState.BUILD_LIST_NEED_PARA3_SCIENCE
		end
	elseif buildId == BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2 or
			buildId == BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2 or
			buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_1 or
			buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_2 then
		if self:GetMaxBuildNum(buildId) == 0 then
			return BuildState.BUILD_LIST_NEED_MASTERY
		end
	end
	local buildNum = self:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
	local maxNum = self:GetMaxBuildNum(buildId)
	if buildNum >=  maxNum then
		return BuildState.BUILD_LIST_REACH_MAX
	end

	local curMaxNum, maxType = self:GetCurMaxBuildNum(buildId)
	if buildNum >= curMaxNum then
		--判断引导
		if maxType == BuildMaxNumType.Cur then
			return BuildState.BUILD_LIST_REACH_CUR_MAX
		elseif maxType == BuildMaxNumType.Guide then
			return BuildState.BUILD_LIST_NEED_GUIDE
		elseif maxType == BuildMaxNumType.Quest then
			return BuildState.BUILD_LIST_NEED_QUEST
		elseif maxType == BuildMaxNumType.Chapter then
			return BuildState.BUILD_LIST_NEED_CHAPTER
		end
		return BuildState.BUILD_LIST_REACH_CUR_MAX
	end
	local buildDesTemplate =DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	local buildLevelTemplate =DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
	local preAllianceCenterFinish = true
	if buildLevelTemplate~=nil and buildDesTemplate.tab_type == UIBuildListTabType.SeasonBuild and not string.IsNullOrEmpty(buildLevelTemplate.para1) then
		local allianceCenterId = tonumber(buildLevelTemplate.para1)
		local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
		if allianceCenterData ==nil then
			preAllianceCenterFinish = false
		end

	end
	if preAllianceCenterFinish ==false then
		return BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD
	end

	local fixCount = 0
	local list = self:GetFoldUpBuildByBuildId(buildId)
	if list ~= nil then
		for k,v in ipairs(list) do
			if not v:IsInFix() then
				return BuildState.BUILD_LIST_RECEIVED
			else
				fixCount = fixCount + 1
			end
		end
	end
	if curMaxNum <= fixCount + buildNum then
		return BuildState.BUILD_LIST_STATE_BREAK
	end

	if buildLevelTemplate ~= nil then
		if fixCount == 0 then
			-- 判断专精等级
			if not table.IsNullOrEmpty(buildLevelTemplate.needMasteryList) then
				for _, masteryId in ipairs(buildLevelTemplate.needMasteryList) do
					if not DataCenter.MasteryManager:HasLearntMastery(masteryId) then
						return BuildState.BUILD_LIST_NEED_MASTERY
					end
				end
			end
			--判断月卡
			if buildLevelTemplate.month_card and buildLevelTemplate.month_card ~= 0 then
				if not DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
					return BuildState.BUILD_LIST_STATE_NEED_BUY_MONTH
				end
			end
			--天赋解锁
			if not string.IsNullOrEmpty(buildLevelTemplate.need_talent) then
				if not DataCenter.TalentDataManager:IsTalentOpen(buildLevelTemplate.need_talent) then
					return BuildState.BUILD_LIST_NEED_UNLOCK_TALENT
				end
			end
			--判断物品要求
			local lackItem = false
			local needItem = buildLevelTemplate:GetNeedItem()
			if needItem ~= nil then
				for k1,v1 in ipairs(needItem) do
					local curNum = DataCenter.ItemData:GetItemCount(v1[1])
					if curNum < v1[2] then
						--判断礼包要求

						if buildLevelTemplate.gift_id ~= nil and buildLevelTemplate.gift_id ~= "" then
							local vec1 = string.split(buildLevelTemplate.gift_id,";")
							local hasExchangeInfo = false
							for k,v in ipairs(vec1) do
								local gift = GiftPackageData:GetInstance():GetInfoById(v)
								if gift ~= nil then
									hasExchangeInfo = true
									break
								end
							end
							if hasExchangeInfo then
								return BuildState.BUILD_LIST_STATE_NEED_BUY
							end
						end
						lackItem = true
					end
				end
			end
			if lackItem then
				if buildId == 479000 or buildId == 480000 or buildId == 481000 or buildId == 482000 then
					---机器人建筑特殊处理
					return BuildState.BUILD_LIST_STATE_NEED_ITEM_FORM_GIFT
				end
			end
			--判前置科技
			local needScience = buildLevelTemplate:GetNeedScience()
			if needScience ~= nil and table.count(needScience) > 0 then
				for k1,v1 in ipairs(needScience) do
					if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v1.scienceId,v1.level) then
						--判前置建筑
						local preBuild = buildLevelTemplate:GetPreBuild()
						if preBuild ~= nil then
							for k2,v2 in ipairs(preBuild) do
								if not DataCenter.BuildManager:IsExistBuildByTypeLv(v2[1],v2[2]) then
									return BuildState.BUILD_LIST_SCIENCE_BUILD
								end
							end
						end
						return BuildState.BUILD_LIST_SCIENCE
					end
				end
			else
				--判前置建筑
				local preBuild = buildLevelTemplate:GetPreBuild()
				if preBuild ~= nil then
					for k1,v1 in ipairs(preBuild) do
						if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1],v1[2]) then
							return BuildState.BUILD_LIST_PREBUILD
						end
					end
				end
			end

			-- 判断赛季城解锁
			if buildLevelTemplate.need_ruin ~= 0 and buildLevelTemplate.need_ruin ~= "" then
				local ownCount = DataCenter.WorldAllianceCityDataManager:GetMyAllianceCityNumByOutLevel(buildLevelTemplate.need_ruin)
				if ownCount <= 0 then
					return BuildState.BUILD_LIST_NEED_ALLIANCE_CITY_BUILD
				end
			end
		end

		--判人口
		local needPeopleNum = buildLevelTemplate:GetNeedPeopleNumByBuildNum(buildNum + 1)
		if needPeopleNum > 0 then
			if needPeopleNum > LuaEntry.Resource:GetCntByResType(ResourceType.People) then
				return BuildState.BUILD_LIST_LACK_PEOPLE
			end
		end

		if buildDesTemplate.put ~= BuildPutType.Lv0 then
			--判资源
			local needResource = buildLevelTemplate:GetNeedResource()
			if needResource ~= nil then
				for k,v in ipairs(needResource) do
					if v.count > LuaEntry.Resource:GetCntByResType(v.resourceType) then
						return BuildState.BUILD_LIST_LACK_RESOURCE
					end
				end
			end
		end
		--判断物品要求
		local needItem = buildLevelTemplate:GetNeedItem()
		if needItem ~= nil then
			for k1,v1 in ipairs(needItem) do
				local curNum = DataCenter.ItemData:GetItemCount(v1[1])
				if curNum < v1[2] then
					return BuildState.BUILD_LIST_STATE_NEED_BUY_ITEM
				end
			end
		end
	end
	return BuildState.BUILD_LIST_STATE_OK

end

--获取建筑是否已经解锁，仅判断科技和建筑前置
local function CheckBuildingUnlockWithPreBuildAndScience(self, buildId)
	local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
	if buildNum > 0 then
		return true
	end
	local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
	if levelTemplate ~= nil then
		--判前置科技
		local needScience = levelTemplate:GetNeedScience()
		if needScience ~= nil and table.count(needScience) > 0 then
			for _,v1 in ipairs(needScience) do
				if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v1.scienceId,v1.level) then
					return false
				end
			end
		else
			--判前置建筑
			--判前置建筑
			local preBuild = levelTemplate:GetPreBuild()
			if preBuild ~= nil then
				for k1,v1 in ipairs(preBuild) do
					if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
						return false
					end
				end
			end
		end
	end
	return true
end

--param ignore:无视资源限制
local function GetCanUpgradeBuildUuidList(self, ignore, isSeason)
	local result = {}
	isSeason = isSeason or false
	local list = self:GetAllBuildWithoutPickUp()
	if list ~= nil then
		for k, v in ipairs(list) do
			local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.itemId)
			if buildTemplate ~= nil then
				if buildTemplate:IsSeasonBuild() == isSeason and self:GetBuildCanUpgrade(v.uuid, ignore)  then
					table.insert(result, v.uuid)
				end
			end
		end
	end
	return result
end

-- 建筑是否可以升级
-- ignore:无视资源限制
local function GetBuildCanUpgrade(self,bUuid,ignore)
	local canUpgrade =false
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData.state == BuildingStateType.Normal then
		local level = buildData.level
		local buildId = buildData.itemId
		local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
		local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
		if buildTemplate ~= nil then
			if maxLv > level then
				local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
				if buildLevelTemplate ~= nil then
					local preBuild = buildLevelTemplate:GetPreBuild()
					if preBuild ~= nil then
						for k,v in ipairs(preBuild) do
							if not DataCenter.BuildManager:IsExistBuildByTypeLv(v[1], v[2]) then
								return false
							end
						end
					end

					if not ignore then
						local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(bUuid)
						if not ret.enough then
							return false
						end
					end
					canUpgrade = true
				end
			end
		end
	end
	return canUpgrade
end

-- 是否显示建筑升级气泡
-- 相比 GetBuildCanUpgrade，消耗只检测 item 和 人口 不检测 resource
local function ShowBuildCanUpgradeBubble(self, bUuid)
	local canUpgrade =false
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData.state == BuildingStateType.Normal then
		local level = buildData.level
		local buildId = buildData.itemId
		local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
		local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
		if buildTemplate ~= nil then
			if string.IsNullOrEmpty(buildTemplate.upgrade_notice) then
				return false
			elseif maxLv > level and self.MainLv - level >= tonumber(buildTemplate.upgrade_notice) then
				local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
				if buildLevelTemplate ~= nil then
					local preBuild = buildLevelTemplate:GetPreBuild()
					if preBuild ~= nil then
						for k,v in ipairs(preBuild) do
							if not DataCenter.BuildManager:IsExistBuildByTypeLv(v[1], v[2]) then
								return false
							end
						end
					end

					local ret = self:CheckBuildUpgradeResAndItem(bUuid)
					if not ret.enough then
						return false
					end
					canUpgrade = true
				end
			end
		end
	end
	return canUpgrade
end

--获取自己建筑中最低等级的升级资源最少的建筑： 任务跳转用
function BuildManager:GetMinCanUpgradeBuild()
	local result = nil
	local minCost = IntMaxValue
	local minLevel = IntMaxValue
	local list = self:GetCanUpgradeBuildUuidList(true)
	if list[1] ~= nil then
		local level = IntMaxValue
		local cost = IntMaxValue
		for k, v in ipairs(list) do
			level, cost = self:GetBuildMinLevel(v)
			if minLevel > level then
				minLevel = level
				minCost = cost
				result = v
			elseif minLevel == level and minCost > cost then
				minLevel = level
				minCost = cost
				result = v
			end
		end
	end
	return result
end

local function GetBuildMinLevel(self,bUuid)
	local cost = IntMaxValue
	local level = IntMaxValue
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.itemId ~= BuildingTypes.FUN_BUILD_MAIN then
		level = buildData.level
		local buildId = buildData.itemId
		local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
		local maxLv = buildTemplate:GetBuildMaxLevel()
		if maxLv > level then
			local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
			if buildLevelTemplate ~= nil then
				local resources = buildLevelTemplate:GetNeedResource()
				if resources ~= nil then
					for k,v in ipairs(resources) do
						local resourceType = v.resourceType
						if resourceType == ResourceType.Money then
							cost = v.count
							break
						end
					end
				end
			end
		end
	end
	return level, cost
end

--获取建筑图片的完整路径
local function GetBuildIconPath(self,buildId, level)
	return string.format(LoadPath.BuildIconOutCity, GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level, "pic"))
end

--获取建筑额外能建造的数量（作用号增加）
local function GetExtraCanBuildNum(self,buildId)
	return DataCenter.BuildManager:GetUnlock2BuildByEffectAndType(buildId)
end

local function FreeBuildingFoldUpNewHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = 0
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				bUuid = dic["uuid"]
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
			end
		end
		if message["needRemove"] then
			self:RemoveBuilding(message["needRemove"])
		end
		self:AddOneWaitFireEvent(EventId.FoldUpSeasonBuild)
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function FreeBuildingExpendDomeHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = 0
		bUuid = message["uuid"]
		self:AddBuilding(message)
		CS.SceneManager.World:OnExtendDome()
		self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function FreeBuildingUpNewHandle(self,message)
	if message["errorCode"] == nil then
		if message["serverSystemTime"] ~= nil then
			CS.GameEntry.Timer:UpdateServerMilliseconds(message["serverSystemTime"])
			UITimeManager:GetInstance():UpdateServerMsDeltaTime(message["serverSystemTime"])
		end
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		if message["remainGold"] ~= nil then
			LuaEntry.Player.gold = message["remainGold"]
			self:AddOneWaitFireEvent(EventId.UpdateGold)
		end
		local bUuid = 0
		local endTime = 0
		local startTime = 0
		local pointId = 0
		local level = 0
		local itemId =0
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				bUuid = dic["uuid"]
				--新逻辑
				if dic["bId"]~=nil then
					itemId =dic["bId"]
				end
				if dic["lv"]~=nil then
					level =dic["lv"]
				end
				if dic["pId"]~=nil then
					pointId =dic["pId"]
				end
				if dic["sT"]~=nil then
					startTime =dic["sT"]
				end
				if dic["uT"]~=nil then
					endTime =dic["uT"]
				end
				local gold = message["gold"]
				if gold == BuildUpgradeUseGoldType.Yes then
					self:AddOneWaitFireEvent(EventId.BuildUpgradeAnimationFinish,bUuid)
				end
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
				--local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k6")
				--if dic.bId == BuildingTypes.FUN_BUILD_MAIN and dic.lv >= showPower then
				--	self:CheckMainBuildUpgradePanel(itemId,level,message["reward"])
				--end
				if endTime>0 then
					self:AddOneWaitFireEvent(EventId.BuildUpgradeStart, bUuid)
				else
					self:CheckGetNewBuildSendMessage(itemId, level, bUuid)
					self:OpenUpgradeSuccess(itemId, level)

					if self:CheckShowUnlock(itemId,level) == false then
						--self:AddOneWaitFireEvent(EventId.ShowPower,RewardType.POWER)
					end
					self:CheckShowFogUnlock(itemId,level)
					if itemId == BuildingTypes.FUN_BUILD_MAIN then
						if level == 10 then --大本升级到十本发送打点
							local ok, errorMsg = xpcall(function()
								CS.GameEntry.Sdk:LogEventLevelUp(level)
								return true
							end, debug.traceback)

						end
					end
					self:AddOneWaitFireEvent(EventId.BuildUpgradeFinish,bUuid)
					SoundUtil.PlayEffect(SoundAssets.Music_Effect_Finish)
					if itemId ~= 0 then
						UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FINISH_UPGRADE_WITH,
								Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level,"name"))))
						local power = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level, "power", 0)
						if level > 1 then
							power = power - GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level - 1, "power", 0)
						end
						if power > 0 then
							GoToUtil.ShowPower({power = power})
						end
					end
				end
			end
		end
		if message["queue"] ~= nil then
			for k,v in pairs(message["queue"]) do
				DataCenter.QueueDataManager:UpdateQueueData(v)
			end
		end
		if message["reward"] ~= nil then
			for k,v in pairs(message["reward"]) do
				-- 人口特殊处理
				if v.type ~= RewardType.PEOPLE then
					DataCenter.RewardManager:AddOneReward(v)
				end
			end
			if next(message["reward"]) then
				local dic = message["buildInfo"]
				local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(dic.uuid)
				local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
				local reward = message["reward"][1]
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(dic.bId)
				if buildTemplate and buildTemplate:IsSeasonBuild() then
					DataCenter.RewardManager:ShowCommonReward(message)
				end

				if reward.type == RewardType.GOODS then
					local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.value.itemId)
					if goods ~= nil then
						UIUtil.DoFly(RewardType.GOODS,5,string.format(LoadPath.ItemPath, goods.icon),CS.SceneManager.World:WorldToScreenPoint(pos),Vector3.New(0,0,0))
					end
				elseif reward.type == RewardType.ARM then
					local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.value.itemId)
					local max = DataCenter.ArmyManager:GetArmyNumMax(army.arm)
					local total = DataCenter.ArmyManager:GetTotalArmyNum(army.arm)
					if army ~= nil then
						local param = {}
						param.type = RewardType.ARM
						param.path = string.format(LoadPath.SoldierIcons,army.icon)
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						param.add = reward.value.count
						param.total = total
						param.max = max
						if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISoliderGetTip) then
							self:AddOneWaitFireEvent(EventId.BuildUpgradeRewardArmy,param)
						end
					end
				elseif reward.type == RewardType.PVE_POINT then
					if reward.value ~= 0 then
						local max = LuaEntry.Resource:GetMaxStorageByResType(RewardToResType[reward.type])
						max = Mathf.Floor(max)
						local param = {}
						param.type = RewardType.PVE_POINT
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},reward.value, reward.total, max, max,param)
					end
				elseif reward.type == RewardType.DETECT_EVENT then
					local needItemId = self:GetEventStoreMax()
					if reward.value ~= 0 then
						local param = {}
						param.type = RewardType.DETECT_EVENT
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},reward.value, reward.total, needItemId, needItemId,param)
					end
				elseif reward.type == RewardType.PEOPLE then
					self:UpdatePeopleByBuildReward(reward, pos)
				end
				if dic.bId == BuildingTypes.FUN_BUILD_MAIN then
					local rewardList = message["reward"]
					for i = 1, #rewardList do
						if rewardList[i].type == RewardType.FORMATION_STAMINA then
							if rewardList[i].value ~= 0 then
								local param = {}
								param.type = RewardType.FORMATION_STAMINA
								param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
								local maxNum = 100
								local config = DataCenter.ArmyFormationDataManager:GetConfigData()
								if config~=nil then
									maxNum = config.FormationStaminaMax
								end
								if maxNum - self.curMainBuildStamina < rewardList[i].value then
									rewardList[i].value = maxNum - self.curMainBuildStamina
									if rewardList[i].value < 0 then
										rewardList[i].value = 0
									end
								end
								UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},rewardList[i].value, rewardList[i].total, maxNum, maxNum,param)
								break
							end
						end
					end
				end
			end
		end
		if message["robot"]~=nil then
			DataCenter.BuildQueueManager:UpdateQueueData(message["robot"])
		end
		self:AddOneWaitFireEvent(EventId.ShowMainUIPart)
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end
		self:AddOneWaitFireEvent(EventId.ResetUIBuildClickState)
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function FreeBuildingStartFixHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = 0
		local endTime = 0
		local startTime = 0
		local pointId = 0
		local level = 0
		local itemId =0
		if message~= nil then
			local dic = message
			if dic ~= nil then
				bUuid = dic["uuid"]
				--新逻辑
				if dic["bId"]~=nil then
					itemId =dic["bId"]
				end
				if dic["lv"]~=nil then
					level =dic["lv"]
				end
				if dic["pId"]~=nil then
					pointId =dic["pId"]
				end
				if dic["dStT"]~=nil then
					startTime =dic["dStT"]
				end
				if dic["dEndT"]~=nil then
					endTime =dic["dEndT"]
				end
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
				self:AddOneWaitFireEvent(EventId.BuildFixStart, bUuid)
			end
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end
	end
end

local function FreeBuildingFinishFixHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = 0
		if message~= nil then
			local dic = message
			if dic ~= nil then
				bUuid = dic["uuid"]
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
				self:AddOneWaitFireEvent(EventId.BuildFixFinish,bUuid)
			end
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end
	end
end

--是否有该等级的建筑
local function HasBuildByIdAndLevel(self,id,level)
	local curLevel = DataCenter.BuildManager:GetMaxBuildingLevel(id)
	return curLevel >= level
end

local function CheckShowBuildUnlockWhenScienceLevelUp(self, scienceId, level)
	
end

--检测解锁
local function CheckShowUnlock(self, id, level)
	--士兵解锁
	local isContinue = true
	for k, v in ipairs(BarracksBuild) do
		if v == id and level > 1 then
			local idList = DataCenter.ArmyManager:GetArmyList(v)
			for _, armyId in ipairs(idList) do
				if isContinue then
					if DataCenter.ArmyManager:IsUnLock(armyId) then
						local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
						if template ~= nil and template.unlock_train_build[1] ~= nil then
							for _, v1 in ipairs(template.unlock_train_build) do
								if isContinue then
									if v1[1] == id and v1[2] == level then
										DataCenter.ArmyManager:SaveArmyUnlock(v1[1], armyId)
										isContinue = false
										break
									end
								else
									break
								end
							end
						end
					end
				else
					break
				end
			end
		end
	end

	return false
end

--获得建筑id
local function GetBuildId(self, id)
	return id // BuildLevelCap * BuildLevelCap
end

--获得建等级
local function GetBuildLevel(self, id)
	return id % BuildLevelCap
end

local function GetEffectNumWithType(self, value,type)
	if type == EffectLocalType.Num then
		local a, b = math.modf(value)
		if b == 0 then
			return string.GetFormattedSeperatorNum(a)
		end
		return string.GetFormattedSeperatorNum(value)
	elseif type == EffectLocalType.Time then
		return UITimeManager:GetInstance():SecondToFmtString(value)
	elseif type == EffectLocalType.Percent then
		local a, b = math.modf(value)
		if b == 0 then
			return a .. "%"
		end
		return value .. "%"
	elseif type == EffectLocalType.Dialog then
		if value~=nil and value~="" then
			return Localization:GetString(value)
		else
			return ""
		end

	elseif type == EffectLocalType.PositiveNum then
		local a, b = math.modf(value)
		if b == 0 then
			return "+" .. string.GetFormattedSeperatorNum(a)
		end
		return "+" .. string.GetFormattedSeperatorNum(value)
	elseif type == EffectLocalType.NegativeNum then
		local a, b = math.modf(value)
		if b == 0 then
			return "-" .. string.GetFormattedSeperatorNum(a)
		end
		return "-" .. string.GetFormattedSeperatorNum(value)
	elseif type == EffectLocalType.PositiveTime then
		return "+" .. UITimeManager:GetInstance():SecondToFmtString(value)
	elseif type == EffectLocalType.NegativeTime then
		return "-" .. UITimeManager:GetInstance():SecondToFmtString(value)
	elseif type == EffectLocalType.PositivePercent then
		local a, b = math.modf(value)
		if b == 0 then
			return "+" .. string.GetFormattedSeperatorNum(a) .. "%"
		end
		return "+" .. string.GetFormattedSeperatorNum(value) .. "%"
	elseif type == EffectLocalType.NegativePercent then
		local a, b = math.modf(value)
		if b == 0 then
			return "-" .. string.GetFormattedSeperatorNum(a) .. "%"
		end
		return "-" .. string.GetFormattedSeperatorNum(value) .. "%"
	end
end

--获取无符号的显示
function BuildManager:GetEffectNumWithoutSymbolByType(value, type)
	if type == EffectLocalType.Num or type == EffectLocalType.PositiveNum or type == EffectLocalType.NegativeNum then
		local a, b = math.modf(value)
		if b == 0 then
			return string.GetFormattedSeperatorNum(a)
		end
		return string.GetFormattedSeperatorNum(value)
	elseif type == EffectLocalType.Time or type == EffectLocalType.PositiveTime or type == EffectLocalType.NegativeTime then
		return UITimeManager:GetInstance():SecondToFmtString(value)
	elseif type == EffectLocalType.Percent or type == EffectLocalType.PositivePercent or type == EffectLocalType.NegativePercent then
		local a, b = math.modf(value)
		if b == 0 then
			return string.GetFormattedSeperatorNum(a) .. "%"
		end
		return string.GetFormattedSeperatorNum(value) .. "%"
	elseif type == EffectLocalType.Dialog then
		if value ~= nil and value ~= "" then
			return Localization:GetString(value)
		else
			return ""
		end
	end
	return ""
end

--检测是否有新属性增加
local function CheckShowBuildAddDes(self,id,level)
	local curTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id,level)
	if curTemplate ~= nil then
		if level > 1 then
			local lastTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id,level - 1)
			local curNums = curTemplate.local_num
			local lastNums = lastTemplate.local_num
			local curCount = #curNums
			local lastCount = #lastNums
			if curCount == lastCount then
				for i=1,curCount,1 do
					if curNums[i] ~= lastNums[i] then
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeAddDes,{anim = true},curTemplate.id)
						return
					end
				end
			end
		else
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeAddDes,{anim = true},curTemplate.id)
		end
	end
end

local function CheckShowFogUnlock(self,id,level)
	if id == BuildingTypes.FUN_BUILD_MAIN then
		local k1 = LuaEntry.DataConfig:TryGetNum("cityEscalate","k1")
		if level  == k1 then
			EventManager:GetInstance():Broadcast(EventId.BuildLvUpChangeRange)
		end
	end
end

local function playBuildUpdateEffect(self,id,level)
	--if UIManager:GetInstance():IsWindowOpen("WorldDesUI") then
	--	UIManager:GetInstance():DestroyWindow("WorldDesUI")
	--end
	--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeAddDes,{anim = true},curTemplate.id)
end

--是否显示建造红点
local function IsShowBuildRedDot(self)
	return false
end

local function IsShowRedDotByOnce(self,buildId)
	return self.noShowRedDot[buildId] == nil
end

local function CanShowUnlock(self,buildId)
	if self.noShowUnlock == nil then
		self:LoadNoShowUnlock()
	end
	return self.noShowUnlock[buildId] == nil
end

-- 设置建筑展示过红点
local function SetBuildRedDotOnce(self,buildId)
	self.noShowRedDot[buildId] = true
end

-- 设置建筑展示过解锁动画
local function SetBuildShowUnlock(self,buildId)
	self.noShowUnlock[buildId] = true
	self:SaveNoShowUnlock()
end

local function GetBuildRedDotByTabType(self, tab)
	local result = 0
	return result
end

local function IsShowRedDotByTemplateAndState(self,template,state)
	local redDotType = template.red_dot
	if redDotType == BuildRedDotType.No or (redDotType == BuildRedDotType.Once and not self:IsShowRedDotByOnce(template.id)) then
		return false
	end

	if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE
			or state == BuildState.BUILD_LIST_LACK_PEOPLE or state == BuildState.BUILD_LIST_RECEIVED then
		return true
	end
	return false
end

local function PushInitBuildHandle(self,t)
	if t["defaultBuilds"] ~= nil then
		for k,message in pairs(t["defaultBuilds"]) do
			if message["serverSystemTime"] ~= nil then
				CS.GameEntry.Timer:UpdateServerMilliseconds(message["serverSystemTime"])
				UITimeManager:GetInstance():UpdateServerMsDeltaTime(message["serverSystemTime"])
			end
			if message["remainGold"] ~= nil then
				LuaEntry.Player.gold = message["remainGold"]
				self:AddOneWaitFireEvent(EventId.UpdateGold)
			end

			local bUuid = 0
			if message["buildInfo"] ~= nil then
				local dic = message["buildInfo"]
				if dic ~= nil then
					bUuid = dic["uuid"]
					self:AddBuilding(dic)
					self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
				end
			end
			if message["queue"] ~= nil then
				for k,v in pairs(message["queue"]) do
					DataCenter.QueueDataManager:UpdateQueueData(v)
				end
			end
			if message["reward"] ~= nil then
				for k,v in pairs(message["reward"]) do
					DataCenter.RewardManager:AddOneReward(v)
				end
			end
			self:AddOneWaitFireEvent(EventId.ShowMainUIPart)
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	end
end

local function PushBuildUpgradeFinishHandle(self,message)
	local bUuid = 0
	local endTime = 0
	local startTime = 0
	local pointId = 0
	local level = 0
	local itemId =0
	local connect = 1
	if message["buildInfo"] ~= nil then
		local dic = message["buildInfo"]
		if dic ~= nil then
			bUuid = dic["uuid"]
			--新逻辑
			if dic["bId"]~=nil then
				itemId =dic["bId"]
			end
			if dic["lv"]~=nil then
				level =dic["lv"]
			end
			if dic["pId"]~=nil then
				pointId =dic["pId"]
			end
			if dic["sT"]~=nil then
				startTime =dic["sT"]
			end
			if dic["uT"]~=nil then
				endTime =dic["uT"]
			end
			if dic["con"]~=nil then
				connect =dic["con"]
			end

			self:AddBuilding(dic)
			self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)

			if itemId == BuildingTypes.FUN_BUILD_MAIN and level == 1 then
				CS.SceneManager.World:SetTouchInputControllerEnable(true)
				self:AddOneWaitFireEvent(EventId.UIMAIN_VISIBLE, true)
			end
			if itemId == BuildingTypes.FUN_BUILD_MAIN then
				if level == 10 then --大本升级到十本发送打点
					local ok, errorMsg = xpcall(function()
						CS.GameEntry.Sdk:LogEventLevelUp(level)
						return true
					end, debug.traceback)
				end
			end
			--if self:CheckShowUnlock(itemId,level) == false then
			--	UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeTip,{anim = true}, {buildUid = bUuid})
			--	self:AddOneWaitFireEvent(EventId.ShowPower,RewardType.POWER)
			--end
			--self:CheckShowBuildAddDes(buildId,level)
			self:CheckShowFogUnlock(itemId,level)
			self:AddOneWaitFireEvent(EventId.BuildUpgradeFinish,bUuid)
			SoundUtil.PlayEffect(SoundAssets.Music_Effect_Finish)
			if itemId ~= 0 then
				UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FINISH_UPGRADE_WITH,
						Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level,"name"))))
				local power = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level, "power", 0)
				if level > 1 then
					power = power - GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + level - 1, "power", 0)
				end
				if power > 0 then
					GoToUtil.ShowPower({power = power})
				end
			end
		end
		if message["reward"] ~= nil then
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end
	end
	if message["queue"] ~= nil then
		for k,v in pairs(message["queue"]) do
			DataCenter.QueueDataManager:UpdateQueueData(v)
		end
	end
	self:AddOneWaitFireEvent(EventId.ShowMainUIPart)
	self:FireFireData()
	self:FireWaitFireEvent()
end

--进入场景调用
local function UILoadingExitSignal()
	DataCenter.BirthPointTemplateManager:InitAllBirthPoint()
	DataCenter.CityLabelManager:InitData()
	CommonUtil.PlayGameBgMusic()
end

--通过建筑id获取对应的矿根资源类型
local function GetResourceTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_WATER then
		return ResourceType.Water
	elseif buildId == BuildingTypes.FUN_BUILD_STONE then
		return ResourceType.Metal
	elseif buildId == BuildingTypes.FUN_BUILD_OIL then
		return ResourceType.Oil
	end
	return ResourceType.None
end

local function GetResTypeByBuildUuid(self, bUuid)
	local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if tempBuild ~= nil  then
		local resourceType = self:GetOutResourceTypeByBuildId(tempBuild.itemId)
		return resourceType
	end
end

local function PushBuildingInfoHandle(self,message)
	if message["buildingInfo"] ~= nil then
		self:HandleBuildingInfos(message["buildingInfo"])
		if message["buildingInfo"][1] then
			local data = message["buildingInfo"][1]
			if (data["bId"] == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(data["bId"]) ==true) and data["lv"] == 0 then
				local signal = SFSObject.New()
				signal:PutLong("bUuid", data["uuid"])
				self:AddOneWaitFireEvent(EventId.CreatWormholeBuild,signal)
			end
		end

		if message["reward"] ~= nil then
			DataCenter.RewardManager:ShowCommonReward(message)
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end

		if message["robot"]~=nil then
			DataCenter.BuildQueueManager:UpdateQueueData(message["robot"])
		end

		self:FireFireData()
		self:FireWaitFireEvent()
	end
end

local function PushAddBuildingHandle(self, message)
	local buildings = message["buildings"]
	if buildings ~= nil then
		self:HandleBuildingInfos(buildings)
		self:FireFireData()
		self:FireWaitFireEvent()
		if buildings[1] ~= nil then
			for k,v in ipairs(buildings) do
				DataCenter.BuildCityBuildManager:CheckAddBuildModelVisible(v["bId"])
			end
		end
	end
end

local function HandleBuildingInfos(self, infos)
	for _, dic in pairs(infos) do
		local bUuid = dic["uuid"]
		local connect = 1
		if dic["connect"]~=nil then
			connect = dic["connect"]
		end
		if dic["con"]~=nil then
			connect = dic["con"]
		end
		self:AddBuilding(dic)
		if oldBuild == nil then
			self:CheckGetNewBuildSendMessage(dic["bId"],dic["lv"], bUuid)
		end
		DataCenter.BuildBubbleManager:NoRefreshTimerCallBack(bUuid)
		self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
	end
end

--通过建筑id获取对应产出资源类型
local function GetOutResourceTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_HERO_BAR then
		return ResourceType.FORMATION_STAMINA
	end
	return ResourceType.None
end

--通过建筑id获取对应产出资源类型
local function GetBuildTypesByOutResourceType(self, resourceType, itemId)
	return DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
end

--通过建筑id获取对应消耗资源类型
local function GetUseResourceTypeByBuildId(self,buildId)
	return ResourceType.None
end

local function UserResupplyBuildingHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = message["uuid"]
		self:AddBuilding(message)
		self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function UserResSynNewHandle(self,message)
	if message["errorCode"] == nil then
		self:AddOneWaitFireEvent(EventId.DelayRefreshResource,3)
		LuaEntry.Resource:UpdateResource(message)
		self:FlyExtraRewards(message)
		self:AddOneWaitFireEvent(EventId.UserResSynNew)
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function FlyExtraRewards(self, msg)
	if msg["extraReward"] then
		local fromPosList = {}
		local buildIds = self:GetBuildTypesByOutResourceType(msg["resourceType"], msg["itemId"])
		if buildIds ~= nil then
			for k1,v1 in ipairs(buildIds) do
				local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
				for k,v in pairs(list) do
					local worldPos = SceneUtils.TileIndexToWorld(v.pointId)
					local fromPos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
					table.insert(fromPosList, fromPos)
				end
			end
		end

		local extraRewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(msg["extraReward"])
		if extraRewardList and #extraRewardList > 0 then
			for m, pos in ipairs(fromPosList) do
				for i, v in ipairs(extraRewardList) do
					local rewardType = v.rewardType
					local itemId = v.itemId
					local pic = RewardUtil.GetPic(v.rewardType,itemId)
					if pic~="" then
						UIUtil.DoFly(tonumber(rewardType),1,pic,pos,Vector3.New(0,0,0))
					end
				end
			end
		end

		for k,v in pairs(msg["extraReward"]) do
			DataCenter.RewardManager:AddOneReward(v)
		end
	end
end

local function ShowGetResourceEffect(self,resourceType)
	if resourceType ~= ResourceType.None then
		local buildIds = DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
		if buildIds ~= nil then
			for k1,v1 in ipairs(buildIds) do
				local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
				for k,v in pairs(list) do
					local uuid = v.uuid
					if v.state == BuildingStateType.Normal then
						local num = DataCenter.BuildManager:GetOutResourceNum(uuid)
						if num > 0 then
							local worldPos = SceneUtils.TileIndexToWorld(v.pointId)
							local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
							DataCenter.FlyResourceEffectManager:ShowGetResourceEffect(pos,resourceType,FlyMoneyCount)
							DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos + FlyGetResourceDelta,DataCenter.ResourceManager:GetResourceIconByType(resourceType),num,uuid)
						end
					end
				end
			end
		end
	end
end

local function isReachMax(self, bUuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData.updateTime>0 then
		local level = buildData.level
		local buildId = buildData.itemId
		local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
		if buildTemplate ~= nil then
			local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
			if maxLv <= level then
				return true
			end
		end
	end
	return false
end

local function WorldMvHandle(self,message)
	if message["errorCode"] == nil then
		local arrays = message["itemCostArr"]
		if arrays ~= nil then
			for k,v in pairs(arrays) do
				DataCenter.ItemData:UpdateOneItem(v)
			end
		end
		self:AddOneWaitFireEvent(EventId.RefreshItems)
		if message["remainGold"] ~= nil then
			LuaEntry.Player.gold = message["remainGold"]
			self:AddOneWaitFireEvent(EventId.UpdateGold)
		end
		if message["worldMainPoint"]~=nil then
			LuaEntry.Player:SetMainWorldPointId(message["worldMainPoint"])
		end
		if SceneUtils.GetIsInWorld() then
			if CS.SceneManager.World~=nil then
				CS.SceneManager.World:OnMainBuildMove()
			end

			local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
			if mainWorldPos>0 then
				if CS.SceneManager.World~=nil then
					GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(mainWorldPos), CS.SceneManager.World.InitZoom,LookAtFocusTime)
				end
			end
		end

		self:AddOneWaitFireEvent(EventId.BuildMainZeroUpgradeSuccess)

		local needRemoveDic = {}--需要删除的建筑uuid
		for k,v in pairs(self.allBuilding) do
			if v~=nil and v.isWorldBuild ==true then
				needRemoveDic[v.uuid] = true
			end
		end

		if message["world_building"]~=nil then
			local dic = message["world_building"]
			for k,v in pairs(dic) do
				local buildId = v["bId"]
				local uuid = v["uuid"]
				if buildId~= BuildingTypes.FUN_BUILD_MAIN then
					self:AddBuilding(v, true)
					self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA, uuid)
				end
				if needRemoveDic[uuid] ~= nil then
					needRemoveDic[uuid] = nil
				end
			end
		end

		for a,b in pairs(needRemoveDic) do
			self:RemoveBuilding(a)
			self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA, a)
		end

		self:AddOneWaitFireEvent(EventId.MoveWorldCity)
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
	self:AddOneWaitFireEvent(EventId.SetMovingUI,UIMovingType.Close)
	self:FireFireData()
	self:FireWaitFireEvent()
end

--收取道具返回处理
local function ReceiveBuildingGrowValRewardHandle(self,message)
	if message["errorCode"] == nil then
		if message["reward"] ~= nil then
			DataCenter.RewardManager:ShowCommonReward(message)
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

--是否可以产出道具
local function IsCanOutItemByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM 
			or buildId == BuildingTypes.FUN_BUILD_VILLA
			or buildId == BuildingTypes.DS_EQUIP_SMELTING_FACTORY
			or buildId == BuildingTypes.DS_EQUIP_MATERIAL_FACTORY
			or buildId == BuildingTypes.DS_EQUIP_SMELTING_FACTORY_2 then
		return true
	end
	return false
end

--是否还有资源可以收取
local function IsHaveResource(self,uuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		--判断是否是可以自己产出资源的建筑
		local outResource = self:GetOutResourceTypeByBuildId(buildData.itemId)
		if outResource ~= ResourceType.None then
			local produceEndTime = buildData.produceEndTime
			local unavailableTime = buildData.unavailableTime
			local lastCollectTime = buildData.lastCollectTime
			if produceEndTime > 0 then
				if produceEndTime > unavailableTime then
					if unavailableTime > 0 then
						return unavailableTime > lastCollectTime;
					else
						return produceEndTime > lastCollectTime;
					end
				end
			else
				if unavailableTime > 0 then
					return unavailableTime > lastCollectTime;
				end
			end
		end
	end
	return false
end

--是否还有道具可以收取
local function IsHaveItem(self,uuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		local buildId = buildData.itemId
		local level = buildData.level
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
		if levelTemplate ~= nil then
			local time = UITimeManager:GetInstance():GetServerTime()
			local growValStartTime = buildData.growValStartTime
			local unavailableTime = buildData.unavailableTime
			if unavailableTime > 0 then
				time = unavailableTime
			end
			return (time - growValStartTime) * levelTemplate:GetOutItemSpeed() / 1000 > levelTemplate:GetOutItemNeedValue()
		end
	end
	return false
end

--获取可以显示收资源气泡的时间
--返回0不显示 返回大于0和现在时间比较，大于就计时器，小于等级就显示
local function GetShowBubbleTime(self,uuid, percent)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		local buildId = buildData.itemId
		local level = buildData.level
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
		if levelTemplate ~= nil then
			local outSpeed = levelTemplate:GetCollectSpeed() / 1000
			if outSpeed > 0 then
				local lastCollectTime = buildData.lastCollectTime
				local produceEndTime = buildData.produceEndTime
				local unavailableTime = buildData.unavailableTime
				if percent == nil then
					percent = levelTemplate:GetShowBubblePercent()
				end
				local needTime = math.max((levelTemplate:GetCollectMax() * percent),1) / outSpeed
				local time = math.ceil(needTime)
				local willTime = lastCollectTime + time
				if produceEndTime > 0 then
					if produceEndTime <= lastCollectTime then
						return 0
					end
					if produceEndTime > unavailableTime then
						if unavailableTime > 0 then
							if willTime <= unavailableTime then
								return willTime
							else
								return 0
							end
						end
					else
						if willTime <= produceEndTime then
							return willTime
						else
							return 0
						end
					end
				else
					if unavailableTime > 0 then
						if willTime <= unavailableTime then
							return willTime
						else
							return 0
						end
					end
				end
				return willTime
			end
		end
	end
	return 0
end

--获取可以显示收道具气泡的时间
--返回0不显示 返回大于0和现在时间比较，大于就计时器，小于等级就显示
local function GetShowItemBubbleTime(self,uuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		local buildId = buildData.itemId
		local level = buildData.level
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
		if levelTemplate ~= nil then
			local outSpeed = levelTemplate:GetOutItemSpeed() / 1000
			if outSpeed > 0 then
				local growValStartTime = buildData.growValStartTime
				local unavailableTime = buildData.unavailableTime
				local needTime = levelTemplate:GetOutItemNeedValue() / outSpeed
				local time = math.ceil(needTime)
				local willTime = growValStartTime + time
				if unavailableTime > 0 then
					if willTime <= unavailableTime then
						return willTime
					else
						return 0
					end
				end
				return willTime
			end
		end
	end
	return 0
end

--是否还有资源可以收取
local function GetOutResourceNum(self,uuid)
	if DataCenter.BuildManager:IsHaveResource(uuid) then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if buildData ~= nil then
			local buildId = buildData.itemId
			local level = buildData.level
			local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
			if levelTemplate ~= nil  then
				local outSpeed = levelTemplate:GetCollectSpeed() / 1000
				if outSpeed > 0 then
					local lastCollectTime = buildData.lastCollectTime
					local produceEndTime = buildData.produceEndTime
					local unavailableTime = buildData.unavailableTime
					local result = 0
					local now = UITimeManager:GetInstance():GetServerTime()
					if unavailableTime > 0 and now > unavailableTime then
						now = unavailableTime
					end

					if produceEndTime > 0 and now > produceEndTime then
						now = produceEndTime
					end
					local count = (now - lastCollectTime) * outSpeed
					local max = levelTemplate:GetCollectMax()
					if count > max then
						count = max
					end

					if buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
						-- 英雄驻扎额外金币
						count = DataCenter.HeroStationManager:CalcEffectedValue(count, HeroStationEffectType.GlobalMoney)
						count = Mathf.Round(count)
					end

					result = Mathf.Round(count)
					return result
				end
			end
		end
	end

	return 0
end

--通过建筑id获取产生资源的最大采集量的作用号
local function GetCollectMaxEffectByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_WATER then
		return EffectDefine.WATER_CAPACITY_ADD
	elseif buildId == BuildingTypes.FUN_BUILD_STONE then
		return EffectDefine.METAL_CAPACITY_ADD
	elseif buildId == BuildingTypes.FUN_BUILD_OIL then
		return EffectDefine.GAS_CAPACITY_ADD
	end
end

--通过建筑id获取功能按钮类型（仅用于只有一个功能的建筑）
local function GetWorldTileBtnTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		return WorldTileBtnType.City_TrainingTank
	elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		return WorldTileBtnType.City_TrainingInfantry
	elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		return WorldTileBtnType.City_TrainingAircraft
	elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
		return WorldTileBtnType.City_TrainingTrap
	end
end

--获取跳转可收获资源建筑的uuid （按照可收取数量从大到小排序）
local function GetCanGetResourceBuildUuidByResourceType(self,resourceType)
	local result = nil
	if resourceType ~= ResourceType.None then
		local buildIds = DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
		if buildIds ~= nil then
			local lists = {}
			for k1,v1 in ipairs(buildIds) do
				local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
				for k,v in pairs(list) do
					local param = {}
					param.uuid = v.uuid
					param.num = DataCenter.BuildManager:GetOutResourceNum(param.uuid)
					table.insert(lists,param)
				end
			end
			if #lists > 0 then
				table.sort(lists,function(a,b)
					return a.num > b.num
				end)
				result = lists[1]
			end
		end
	end
	return result
end


--建筑升级完成返回处理
local function FreeBuildingUpgradeFinishHandle(self,message)
	if message["errorCode"] == nil then
		local bUuid = 0
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			bUuid = dic["uuid"]
			self:AddBuilding(dic)
			self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
			self:AddOneWaitFireEvent(EventId.BuildBoxOpenFinish,bUuid)
			self:AddOneWaitFireEvent(EventId.BuildUpgradeFinish,bUuid)
			local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k6")
			--if dic.bId == BuildingTypes.FUN_BUILD_MAIN and dic.lv >= showPower then
			--	self:CheckMainBuildUpgradePanel(dic.bId,dic.lv,message["reward"])
			--end
			SoundUtil.PlayEffect(SoundAssets.Music_Effect_Finish)
			local buildData = self:GetBuildingDataByUuid(bUuid)
			if buildData ~= nil then
				local itemId = buildData.itemId
				if itemId ~= 0 then
					if buildData.level == 1 then
						UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FINISH_BUILD_WITH, 
								Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + buildData.level,"name"))))
					else
						UIUtil.ShowTips(Localization:GetString(GameDialogDefine.FINISH_UPGRADE_WITH,
								Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + buildData.level,"name"))))
					end
					local power = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + buildData.level, "power", 0)
					if buildData.level > 1 then
						power = power - GetTableData(DataCenter.BuildTemplateManager:GetTableName(), itemId + buildData.level - 1, "power", 0)
					end
					if power > 0 then
						GoToUtil.ShowPower({power = power})
					end
				end
			end
		end
		if message["reward"] ~= nil then
			for k,v in pairs(message["reward"]) do
				-- 人口特殊处理
				if v.type ~= RewardType.PEOPLE then
					DataCenter.RewardManager:AddOneReward(v)
				end
			end
			if next(message["reward"]) then
				local dic = message["buildInfo"]
				local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(dic.uuid)
				local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
				local reward = message["reward"][1]
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(dic.bId)
				if buildTemplate and buildTemplate:IsSeasonBuild() then
					DataCenter.RewardManager:ShowCommonReward(message)
				end

				if reward.type == RewardType.GOODS then
					local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.value.itemId)
					if goods ~= nil then
						UIUtil.DoFly(RewardType.GOODS,5,string.format(LoadPath.ItemPath, goods.icon),CS.SceneManager.World:WorldToScreenPoint(pos),Vector3.New(0,0,0))
					end
				elseif reward.type == RewardType.ARM then
					local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.value.itemId)
					local max = DataCenter.ArmyManager:GetArmyNumMax(army.arm)
					local total = DataCenter.ArmyManager:GetTotalArmyNum(army.arm)
					if army ~= nil then
						local param = {}
						param.type = RewardType.ARM
						param.path = string.format(LoadPath.SoldierIcons,army.icon)
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						param.add = reward.value.count
						param.total = total
						param.max = max
						if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISoliderGetTip) then
							self:AddOneWaitFireEvent(EventId.BuildUpgradeRewardArmy,param)
						end
					end
				elseif reward.type == RewardType.PVE_POINT then
					if reward.value ~= 0 then
						local max = LuaEntry.Resource:GetMaxStorageByResType(RewardToResType[reward.type])
						max = Mathf.Floor(max)
						local param = {}
						param.type = RewardType.PVE_POINT
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},reward.value, reward.total, max, max,param)
					end
				elseif reward.type == RewardType.DETECT_EVENT then
					local needItemId = self:GetEventStoreMax()
					if reward.value ~= 0 then
						local param = {}
						param.type = RewardType.DETECT_EVENT
						param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},reward.value, reward.total, needItemId, needItemId,param)
					end
				elseif reward.type == RewardType.PEOPLE then
					self:UpdatePeopleByBuildReward(reward, pos)
				end
				if dic.bId == BuildingTypes.FUN_BUILD_MAIN then
					local rewardList = message["reward"]
					for i = 1, #rewardList do
						if rewardList[i].type == RewardType.FORMATION_STAMINA then
							if rewardList[i].value ~= 0 then
								local param = {}
								param.type = RewardType.FORMATION_STAMINA
								param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
								local maxNum = 100
								local config = DataCenter.ArmyFormationDataManager:GetConfigData()
								if config~=nil then
									maxNum = config.FormationStaminaMax
								end
								if maxNum - self.curMainBuildStamina < reward.value then
									rewardList[i].value = maxNum - self.curMainBuildStamina
									if rewardList[i].value < 0 then
										rewardList[i].value = 0
									end
								end
								UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},rewardList[i].value, rewardList[i].total, maxNum, maxNum,param)
								break
							end
						end
					end
				end
				--self.upgradeReward[message["buildInfo"]["uuid"]] = message
				--self:AddOneWaitFireEvent(EventId.BuildUpgradeBubbleReward,message["buildInfo"]["bId"])
			end
		end
		Logger.Log("FreeBuildingUpgradeFinishHandle  fire event")
		self:FireFireData()
		self:FireWaitFireEvent()
		Logger.Log("FreeBuildingUpgradeFinishHandle  end")
		if bUuid ~= 0 then
			self:AfterBuildFinishShowEffect(bUuid)
		end
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end
	end
end

local function CheckMainBuildUpgradePanel(self,buildId,mainBuildLevel,rewardParam)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainBuildUpgrade,{anim = true, isBlur  = true},buildId, mainBuildLevel,rewardParam)
end

local function GetEventStoreMax(self)
	local str = LuaEntry.DataConfig:TryGetStr("detect_config", "k6")
	local vec = string.split(str,";")
	if table.count(vec) == 0 then
		return 1
	end
	local level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
	if level < 1 then
		return 1
	end
	local max = 1
	if table.count(vec) < level then
		max = toInt(vec[table.count(vec)])
	else
		max = toInt(vec[level])
	end
	return max
end

local function CheckBuildIsReward(self,uuid)
	if self.upgradeReward[uuid] then
		return true
	end
	return false
end

local function ClickBubbleUpgradeReward(self,uuid)
	local message = self.upgradeReward[uuid]
	for k,v in pairs(message["reward"]) do
		DataCenter.RewardManager:AddOneReward(v)
	end
	if next(message["reward"]) then
		local dic = message["buildInfo"]
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(dic.uuid)
		local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
		local reward = message["reward"][1]
		if reward.type == RewardType.GOODS then
			local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.value.itemId)
			if goods ~= nil then
				UIUtil.DoFly(RewardType.GOODS,5,string.format(LoadPath.ItemPath, goods.icon),CS.SceneManager.World:WorldToScreenPoint(pos),Vector3.New(0,0,0))
			end
		elseif reward.type == RewardType.ARM then
			local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.value.itemId)
			local max = DataCenter.ArmyManager:GetArmyNumMax(army.arm)
			local total = DataCenter.ArmyManager:GetTotalArmyNum(army.arm)
			if army ~= nil then
				local param = {}
				param.type = RewardType.ARM
				param.path = string.format(LoadPath.SoldierIcons,army.icon)
				param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
				param.add = reward.value.count
				param.total = total
				param.max = max
				if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISoliderGetTip) then
					EventManager:GetInstance():Broadcast(EventId.BuildUpgradeRewardArmy,param)
				end
			end
		elseif reward.type == RewardType.PVE_POINT then
			if reward.value ~= 0 then
				local max = LuaEntry.Resource:GetMaxStorageByResType(RewardToResType[reward.type])
				max = Mathf.Floor(max)
				local param = {}
				param.type = RewardType.PVE_POINT
				param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true},reward.value, reward.total, max, max,param)
			end
		end
	end
	self.upgradeReward[uuid] = nil
end

--如果建筑可以升级完成就发送 发送返回false
local function CheckSendBuildFinish(self,uuid,isDelaySend)
	local isFinish = true
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData~=nil then
		--虫洞出口自动完成，不发送
		if (buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(buildData.itemId)==true) and buildData.level == 0 then
			return isFinish
		end
		if buildData:IsUpgradeFinish() then
			isFinish =false
			--if DataCenter.GuideManager:InGuide() then
			if DataCenter.BuildManager:CheckIsSendMessage(uuid)==false then	
				if isDelaySend then
					return isFinish
				end
				WorldArrowManager:GetInstance():RemoveEffect()
				SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpgradeFinish,{uuid = uuid})
				DataCenter.BuildManager:DelayClearSendList(uuid)
			end
			--end
		end
	end
	return isFinish

end

local function CheckSendFixBuildFinish(self,uuid)
	local isFinish = true
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData~=nil then
		if buildData:IsFixFinish() then
			isFinish =false
			--if DataCenter.GuideManager:InGuide() then
			if DataCenter.BuildManager:CheckIsSendFixMessage(uuid)==false then
				WorldArrowManager:GetInstance():RemoveEffect()
				SFSNetwork.SendMessage(MsgDefines.UserFinishFixBuilding,uuid)
				DataCenter.BuildManager:DelayClearSendFixList(uuid)
			end
			--end
		end
	end
	return isFinish

end
--升级0级建筑的状态
local function IsCanUpgradeZeroBuild(self,uuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil and buildData.state == BuildingStateType.Normal and buildData.level == 0 then
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
		if levelTemplate ~= nil then
			--判断物品要求
			local needItem = levelTemplate:GetNeedItem()
			if needItem ~= nil then
				for k2,v2 in ipairs(needItem) do
					local item = DataCenter.ItemData:GetItemById(v2[1])
					if item == nil or item.count < v2[2] then
						return false
					end
				end
			end
		end
		return true
	end

	return false
end

local function FreeBuildingPlaceMainBuildingHandle(self,message)
	CS.SceneManager.World:UIDestroyBuilding()
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		local bUuid = 0
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				bUuid = dic["uuid"]
				local buildingId = 0
				if dic["buildingId"]~=nil then
					buildingId = dic["buildingId"]
				end
				if dic["bId"]~=nil then
					buildingId = dic["bId"]
				end
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
				self:AddOneWaitFireEvent(EventId.BuildPlace,bUuid)
			end
		end
		if message["reward"] ~= nil then
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end
	else
		UIUtil.ShowTips(self:ShowBuildErrorCode(message["errorCode"]))
		local lastPos = self:GetOneAndRemoveMoveBuild()
		BuildingUtils.ShowPutBuild(BuildingTypes.FUN_BUILD_MAIN, PlaceBuildType.Build, 0, lastPos)
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

--正常建筑0升1处理
local function BuildCityBuildingHandle(self,message)
	if message["errorCode"] == nil then
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,dic["uuid"])
			end
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function HasResourceBuildingFull(self, resourceType)
	local buildIds = DataCenter.ResourceManager:GetResourceOutBuildingUids(resourceType)
	for _, v in ipairs(buildIds) do
		if self:IsResourceBuildingFull(v) then
			return true, v
		end
	end
	return false, nil
end

local function IsResourceBuildingFull(self, buildUUid)
	local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildUUid)
	if data == nil or data.state == BuildingStateType.FoldUp then
		return false
	end
	local currentNum = self:GetOutResourceNum(buildUUid)
	local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
	if levelTemplate ~= nil and currentNum > 0 and currentNum >= levelTemplate:GetCollectMax() then
		return true
	end

	return false
end

--多种同样的建筑只算最先满的那个
local function GetAllResourceBuildingFullLatestTime()
	local buildingIds = {BuildingTypes.FUN_BUILD_STONE, BuildingTypes.FUN_BUILD_OIL, BuildingTypes.FUN_BUILD_WATER, BuildingTypes.FUN_BUILD_VILLA, BuildingTypes.FUN_BUILD_ELECTRICITY, BuildingTypes.FUN_BUILD_CONDOMINIUM, BuildingTypes.FUN_BUILD_GROCERY_STORE}
	local currentTime = UITimeManager:GetInstance():GetServerTime()

	local checkIds = {}
	table.walk(buildingIds, function (_, v)
		checkIds[v] = 0
	end)

	local allBuildings = DataCenter.BuildManager:GetAllBuildUuid()
	if allBuildings ~= nil then
		table.walk(allBuildings,function(_, v)
			local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
			if buildData == nil or checkIds[buildData.itemId] == nil or buildData.state == BuildingStateType.FoldUp then
				return
			else
				local time = DataCenter.BuildManager:GetShowBubbleTime(v, 1)
				if time <= 0 then
					return
				else
					if checkIds[buildData.itemId] == 0 or checkIds[buildData.itemId] > time then
						checkIds[buildData.itemId] = time
					end
				end
			end
		end)
	end

	local time = 0
	table.walk(checkIds, function (k, v)
		if v > 0 then
			if time == 0 or time < v then
				time = v
			end
		end
	end)

	local result = (time - currentTime) / 1000
	result = math.max(result, 0)
	return result
end

local function UpdateBuildDataSignal(self)
	DataCenter.BuildManager:AddTimer()
end

local function PostNotice(self)
	self:DeleteTimer()
end

local function DeleteTimer(self)
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

local function AddTimer(self)
	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(0.1, self.timer_action , self, false,false,false)
		self.timer:Start()
	end
end

-- 读取本地红点记录
local function LoadNoShowUnlock(self)
	self.noShowUnlock = {}
	local str = Setting:GetString(LuaEntry.Player.uid .. SettingKeys.BUILD_NO_SHOW_UNLOCK, "");
	if str ~= nil and str ~= "" then
		local list = string.split(str, ";")
		for _, v in ipairs(list) do
			if v ~= "" then
				local buildId = tonumber(v)
				self.noShowUnlock[buildId] = true
			end
		end
	end
end

-- 保存本地红点记录
local function SaveNoShowUnlock(self)
	local str = ""
	for k, _ in pairs(self.noShowUnlock) do
		str = str .. k .. ";"
	end
	Setting:SetString(LuaEntry.Player.uid .. SettingKeys.BUILD_NO_SHOW_UNLOCK, str)
end

local function ShowBuildErrorCode(self, errorCode)
	if errorCode == GameDialogDefine.OUT_UNLOCK_RANGE_REASON then
		return Localization:GetString(GameDialogDefine.OUT_UNLOCK_RANGE_REASON,CS.SceneManager.World.CurTileCountXMin, CS.SceneManager.World.CurTileCountYMin,
				CS.SceneManager.World.CurTileCountXMax, CS.SceneManager.World.CurTileCountYMax)

	end
	return Localization:GetString(errorCode)
end

local function FindMainBuildInitPositionHandle(self,message)
	if message["errorCode"] == nil then
		local serverId = message["serverId"]
		if serverId~=nil and serverId ~= LuaEntry.Player:GetSelfServerId() then
			if message["pointId"] ~= nil then
				self:AddOneWaitFireEvent(EventId.OnGetMigratePoint,message["pointId"])
			end
		else
			if message["pointId"] ~= nil then
				self.showPoint = message["pointId"]
			end
			--if message["maxAreaSize"] ~= nil then
			--	CS.SceneManager.World:SetWorldSize(message["maxAreaSize"])
			--end
			local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
			if seasonId >= 2 then
				local mainData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
				if mainData ~= nil then
					local param = {}
					param.buildUuid = mainData.uuid
					param.pointId = self.showPoint
					SFSNetwork.SendMessage(MsgDefines.FreeBuildingReplaceNew,param)
				end
			end
			self:AddOneWaitFireEvent(EventId.REGET_MAIN_POSITION)
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		self:AddOneWaitFireEvent(EventId.REGET_MAIN_POSITION)
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function FreeBuildingPlaceNewHandle(self,message)
	CS.SceneManager.World:UIDestroyBuilding()
	EventManager:GetInstance():Broadcast(EventId.OnEnterDragonUI,UIEnterDragonType.Close)
	self:AddOneWaitFireEvent(EventId.UIPlaceBuildSendMessageBack)
	if message["errorCode"] == nil then
		if message["serverSystemTime"] ~= nil then
			CS.GameEntry.Timer:UpdateServerMilliseconds(message["serverSystemTime"])
			UITimeManager:GetInstance():UpdateServerMsDeltaTime(message["serverSystemTime"])
		end
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		if message["remainGold"] ~= nil then
			LuaEntry.Player.gold = message["remainGold"]
			self:AddOneWaitFireEvent(EventId.UpdateGold)
		end
		if message["itemInfo"]~=nil then
			DataCenter.ItemData:UpdateOneItem(message["itemInfo"])
		end
		if message["queue"] ~= nil then
			for k,v in pairs(message["queue"]) do
				DataCenter.QueueDataManager:UpdateQueueData(v)
			end
		end
		local bUuid = 0
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				bUuid = dic["uuid"]
				local endTime = 0
				if dic["uT"]~=nil then
					endTime =dic["uT"]
				end
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA, bUuid)
				self:AddOneWaitFireEvent(EventId.BuildPlace,bUuid)
				if endTime > 0 then
					self:AddOneWaitFireEvent(EventId.BuildUpgradeStart, bUuid)
				end
			end
		end
		if message["reward"] ~= nil then
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
		end
		if message["robot"]~=nil then
			DataCenter.BuildQueueManager:UpdateQueueData(message["robot"])
		end

		local worldId = 0
		local serverId = 0
		local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
		if crossBuildData~=nil then
			worldId = crossBuildData.worldId
			serverId = crossBuildData.server

			if DataCenter.AccountManager:GetServerTypeByServerId(serverId) == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
				local pointId = crossBuildData.pointId
				local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
				position.x = position.x - 1
				position.z = position.z - 1
				GoToUtil.GotoDragonPos(position, nil, nil, function()
					WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
				end, serverId,worldId)
			end
		end

	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function FreeBuildingReplaceNewHandle(self,message)
	CS.SceneManager.World:UIDestroyBuilding()
	self:AddOneWaitFireEvent(EventId.UIPlaceBuildSendMessageBack)
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				local bUuid = dic["uuid"]
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
			end
		end
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
		end

	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function AddOneChangeMoveBuild(self,index)
	table.insert(self.changeMovePos,index)
end

local function GetOneAndRemoveMoveBuild(self)
	return table.remove(self.changeMovePos,1)
end

local function BuildWorldMoveNewHandle(self,message)
	CS.SceneManager.World:UIDestroyBuilding()
	if message["errorCode"] == nil then
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				local bUuid = dic["uuid"]
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
			end
		end
	else
		UIUtil.ShowTips(self:ShowBuildErrorCode(message["errorCode"]))
		--把建筑移回去
		local lastPos = self:GetOneAndRemoveMoveBuild()
		local temp = CS.SceneManager.World:GetBuildingByPoint(lastPos)
		if temp ~= nil then
			temp.transform.position = SceneUtils.TileIndexToWorld(lastPos)
		end
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function CanFastBuild(self)
	return false
end

local function GetFastBuildDataList(self, isSeason)
	return {}
end

local function GetBuildExp(self, buildId, level)
	local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
	return template and template.exp or 0
end

local function SetNewUserWorld(self,value)
	self.newUserWorld = value
end

local function IsInNewUserWorld(self)
	return self.newUserWorld == NewUserWorld.Ing
end

--获取该种建筑最大等级
local function GetMaxBuildingLevel(self,buildId)
	local data = self:GetMaxLvBuildDataByBuildId(buildId)
	if data == nil then
		return 0
	end

	return data.level
end


--通过建筑uuid获取建筑
local function GetBuildingDataByUuid(self,uuid)
	return self.allBuilding[uuid]
end


--通过建筑id获取所有除了收起外建筑
local function GetAllBuildingByItemIdWithoutPickUp(self,buildId)
	local result = {}
	local list = self.buildIdBuilding[buildId]
	if list ~= nil then
		for k,v in ipairs(list) do
			if v.state ~= BuildingStateType.FoldUp then
				table.insert(result,v)
			end
		end
	end
	return result
end


--通过类型获取建筑物
local function GetFunbuildByItemID(self,buildId)
	if self.buildIdBuilding ~= nil then
		local list = self.buildIdBuilding[buildId]
		if list ~= nil and table.count(list) > 0 then
			return list[1]
		end
	end
end

local function HasBuilding(self,buildId)
	local data = self:GetMaxLvBuildDataByBuildId(buildId)
	return data ~= nil and data.level > 0
end

-- includeFoldUp: bool, 是否包括被收起的建筑
local function GetMaxLvBuildDataByBuildId(self,buildId,includeFoldUp)
	local list = self.buildIdBuilding[buildId]
	if list ~= nil then
		local result = nil
		local level = -1
		for k,v in ipairs(list) do
			if level < v.level and (includeFoldUp or v.state ~= BuildingStateType.FoldUp) then
				level = v.level
				result = v
			end
		end
		return result
	end
end


local function GetArmyBuildMaxLevelData(self)
	local buildingTypes =
	{
		BuildingTypes.FUN_BUILD_CAR_BARRACK,
		BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,
		BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK,
		BuildingTypes.FUN_BUILD_TRAP_BARRACK,
	}
	local result = nil
	local level =-1
	for k,v in pairs(buildingTypes) do
		local buildData = self:GetMaxLvBuildDataByBuildId(v)
		if buildData~=nil then
			if level < buildData.level then
				level = buildData.level
				result = buildData
			end
		end
	end
	return result
end

local function GetUnlock2BuildByEffectAndType(self,buildId)
	local result = 0
	if buildId == BuildingTypes.FUN_BUILD_WATER then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_WATER_BUILD_NUM)
	elseif buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_HOTEL_NUM)
	elseif buildId == BuildingTypes.FUN_BUILD_OUT_WOOD then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.WOOD_BUILD_COUNT_ADD)
	elseif buildId == BuildingTypes.FUN_BUILD_STONE then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_METAL_COLLECT_NUM)
	elseif buildId == BuildingTypes.FUN_BUILD_OUT_STONE then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.STONE_BUILD_COUNT_ADD)
	elseif buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SCIENCE_QUEUE)
	elseif buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_BUILD_ARROW_TOWER_NUM)
	elseif buildId == BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2 then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SEASON_DESERT_ARMY_ATTACK_2)
	elseif buildId == BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2 then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SEASON_DESERT_ARMY_DEFEND_2)
	elseif buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_1 then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SEASON_DESERT_BUILD_DRONE_1)
	elseif buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_2 then
		result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SEASON_DESERT_BUILD_DRONE_2)
	end
	return result
end

--是否存在大于等于该等级的建筑
local function IsExistBuildByTypeLv(self,buildId,level)
	return self:GetMaxBuildingLevel(buildId) >= level
end

local function GetAllBuildUuid(self)
	local result = nil
	if self.allBuilding ~= nil then
		result = {}
		for k,v in pairs(self.allBuilding) do
			table.insert(result,k)
		end
	end
	return result
end

--通过类型获取建筑物
local function GetFoldUpBuildByBuildId(self,buildId)
	local list = self.buildIdBuilding[buildId]
	if list ~= nil then
		local result = {}
		for k,v in ipairs(list) do
			if v.state == BuildingStateType.FoldUp then
				table.insert(result,v)
			end
		end
		if table.count(result) > 1 then
			table.sort(result,function (a,b)
				if a.level == b.level then
					return a.uuid < b.uuid
				end
				if a.level > b.level then
					return true
				end
				return false
			end)
		end
		return result
	end
end

local function GetHaveBuildNumWithOutFoldUpByBuildId(self,buildId)
	local list = self:GetAllBuildingByItemIdWithoutPickUp(buildId)
	if list ~= nil then
		return #list
	end
	return 0
end

--通过类型获取建筑物
function BuildManager:GetFoldUpAndNotFixBuildByBuildId(buildId)
	local list = self.buildIdBuilding[buildId]
	if list ~= nil then
		local result = {}
		for k,v in ipairs(list) do
			if v.state == BuildingStateType.FoldUp and not v:IsInFix() then
				table.insert(result,v)
			end
		end
		if table.count(result) > 1 then
			table.sort(result,function (a,b)
				if a.level == b.level then
					return a.uuid < b.uuid
				end
				if a.level > b.level then
					return true
				end
				return false
			end)
		end
		return result
	end
end

--获取该建筑当前最大能建多少
local function GetCurMaxBuildNum(self,buildId)
	local result = 0
	local guideMaxNum = 0
	local taskMaxNum = 0
	local chapterMaxNum = 0
	local maxType = BuildMaxNumType.Cur
	local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
	if buildDesTemplate ~= nil and levelTemplate ~= nil then
		result = buildDesTemplate:GetCurMaxCanBuildNum()
		--判断引导
		guideMaxNum = levelTemplate:GetGuideCanBuildMaxNum()
		--判断任务
		taskMaxNum = levelTemplate:GetQuestCanBuildMaxNum()
		--判断章节
		chapterMaxNum = levelTemplate:GetChapterCanBuildMaxNum()
	end

	if result > guideMaxNum then
		result = guideMaxNum
		maxType = BuildMaxNumType.Guide
	end
	if result > taskMaxNum then
		result = taskMaxNum
		maxType = BuildMaxNumType.Quest
	end
	if result > chapterMaxNum then
		result = chapterMaxNum
		maxType = BuildMaxNumType.Chapter
	end

	result = result + self:GetUnlock2BuildByEffectAndType(buildId)
	return result, maxType
end

--获取该建筑最大能建多少
local function GetMaxBuildNum(self,buildId)
	local result = 0
	local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	if buildDesTemplate ~= nil then
		result = buildDesTemplate:GetMaxCanBuildNum()
	end
	result = result + self:GetUnlock2BuildByEffectAndType(buildId)
	return result
end

local function AllianceHelpAddSpeed(self,uuid,endTime,startTime)
	local data = self:GetBuildingDataByUuid(uuid)
	if data ~= nil then
		data.updateTime = endTime
		data.startTime = startTime
	end
end
local function AllianceHelpFixAddSpeed(self,uuid,endTime,startTime)
	local data = self:GetBuildingDataByUuid(uuid)
	if data ~= nil then
		data.destroyEndTime = endTime
		data.destroyStartTime = startTime
	end
end
local function OnAllianceCallHelp(self,uuid)
	local data = self:GetBuildingDataByUuid(uuid)
	if data ~= nil then
		if data.isHelped == AllianceHelpState.No then
			data.isHelped = AllianceHelpState.UpgradeHelped
		elseif data.isHelped == AllianceHelpState.RuinsHelped then
			data.isHelped = AllianceHelpState.UpgradeAndRuinsHelped
		end

	end
end
local function OnAllianceCallFixHelp(self,uuid)
	local data = self:GetBuildingDataByUuid(uuid)
	if data ~= nil then
		if data.isHelped == AllianceHelpState.No then
			data.isHelped = AllianceHelpState.RuinsHelped
		elseif data.isHelped == AllianceHelpState.UpgradeHelped then
			data.isHelped = AllianceHelpState.UpgradeAndRuinsHelped
		end

	end
end

--获取除基地外所有拥有的苍穹内建筑
local function GetAllInBaseTruckShowBuild(self)
	if self.allBuilding ~= nil then
		local hasHouse = false
		local result = {}
		for k,v in pairs(self.allBuilding) do
			if v.state ~= BuildingStateType.FoldUp then
				local buildId = v.itemId
				if buildId == BuildingTypes.FUN_BUILD_LIBRARY then
					hasHouse = true
				end
				if buildId ~= BuildingTypes.FUN_BUILD_MAIN and  buildId ~= BuildingTypes.FUN_BUILD_DOME then
					--剔除辅助建筑
					local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
					if buildDesTemplate ~= nil and (buildDesTemplate.build_type == BuildType.Normal
							or buildDesTemplate.build_type == BuildType.Main) then
						table.insert(result,v)
					end
				end
			end
		end
		if hasHouse then
			return result
		end
	end
end

--建造建筑机器人飞行时间（毫秒）
local function GetPathTimeFromDroneToBuildTarget(self, pointId, tile)
	return 0
end

--通过pointId获取建筑信息(已收起的建筑不通过这个接口获取)
local function GetBuildingDataByPointId(self,pointId, isWorldBuild)
	if self.allBuilding ~= nil then
		for k,v in pairs(self.allBuilding) do
			if (isWorldBuild and v.isWorldBuild) or ((not isWorldBuild) and (not v.isWorldBuild)) then
				if v:IsRangePoint(pointId) and v.state ~= BuildingStateType.FoldUp then
					return v
				end
			end
		end
	end
end

local function GetAllBuildWithoutPickUp(self)
	local result = nil
	if self.allBuilding ~= nil then
		result = {}
		for k,v in pairs(self.allBuilding) do
			if v.state ~= BuildingStateType.FoldUp then
				table.insert(result,v)
			end
		end
	end
	return result
end

local function PushBuildFoldUpHandle(self,message)
	local bUuid = 0
	if message["buildInfo"] ~= nil then
		local dic = message["buildInfo"]
		if dic ~= nil then
			bUuid = dic["uuid"]
			self:AddBuilding(dic)
			self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA,bUuid)
		end
	end
	if message["needRemove"] then
		self:RemoveBuilding(message["needRemove"])
		self:AddOneWaitFireEvent(EventId.NoticeMainViewUpdateMarch)
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

local function CheckReplaceMain(self)
	if LuaEntry.Player:GetMainWorldPos() == 0 and LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		if SceneUtils.GetIsInWorld() then
			if CS.SceneManager.World ~= nil and CS.SceneManager.World:IsBuildFinish() then
				if not DataCenter.AllianceLeaderElectManager:IsAutoJoin() then
					local mainBuild = self:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
					DataCenter.GuideManager:SetCurGuideId(GuideEndId)
					SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
					local level = mainBuild.level
					local id = BuildingTypes.FUN_BUILD_MAIN+level-1
					CS.SceneManager.World:UICreateBuilding(id, mainBuild.uuid, self.showPoint, PlaceBuildType.Replace)
				end
			end
		end
	end
end

local function CheckShowReplaceTip(self)
	local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if LuaEntry.Player:GetMainWorldPos() > 0 and LuaEntry.Player.serverType == ServerType.NORMAL then
		local show = Setting:GetPrivateBool("ForAlCompeteEdenToNormal",false)
		if show == true then
			Setting:SetPrivateBool("ForAlCompeteEdenToNormal",false)
			local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
			if actInfo~=nil and actInfo.preOpenTime == nil and DataCenter.LeagueMatchManager:CheckIsSubmitting() == false then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteNew, { anim = true, UIMainAnim = UIMainAnimType.AllHide },LeagueMatchTab.CrossServer)
				return
			end
		end
		show = Setting:GetPrivateBool("EdenActViewShow",false)
		if show == true then
			Setting:SetPrivateBool("EdenActViewShow",false)
			local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.EdenAllianceActMine)
			if #dataList>0 then
				local data = dataList[1]
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(data.id))
				return
			end
		end
		show = Setting:GetPrivateBool("EdenCrossActViewShow",false)
		if show == true then
			Setting:SetPrivateBool("EdenCrossActViewShow",false)
			local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.EdenAllianceCrossActMine)
			if #dataList>0 then
				local data = dataList[1]
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(data.id))
				return
			end
		end
		
		show = Setting:GetPrivateBool("ForCrossWarEdenToNormal",false)
		if show == true then
			Setting:SetPrivateBool("ForCrossWarEdenToNormal",false)
			local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.CrossCityWar)
			if #dataList>0 then
				local data = dataList[1]
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(data.id))
				return
			end
		end
	end
	if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and LuaEntry.Player:GetMainWorldPos() > 0 then
		local show = Setting:GetPrivateBool("Season5MoveAct",false)
		if show == false then
			Setting:SetPrivateBool("Season5MoveAct",true)
			DataCenter.RobotWarsManager:OpenRobotWars()
		end
	end
	local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
	if seasonId == 5 then
		local actInfo = DataCenter.RobotWarsManager:GetActivityInfo()
		if actInfo and DataCenter.ActivityListDataManager:CheckIsSend(actInfo) then
			if LuaEntry.Player.serverType == ServerType.NORMAL then
				local show = LuaEntry.Player:GetEnterEdenStatus()
				if show <=0 then
					GoToUtil.GotoOpenView(UIWindowNames.UISeason5Intro,{ anim = false })
				end
			end

		end
	end
	if LuaEntry.Player:GetMainWorldPos() == 0 then
		if SceneUtils.GetIsInCity() then
			if seasonId == 2 then
				SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
				local activityInfo = DataCenter.RobotWarsManager:GetActivityInfo()
				if activityInfo and DataCenter.ActivityListDataManager:CheckIsSend(activityInfo) then
					GoToUtil.GotoOpenView(UIWindowNames.UIRobotWarsPre, {anim = true, UIMainAnim = UIMainAnimType.AllHide})
				end
			elseif seasonId>2 then
				SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
			else
				UIUtil.ShowMessage(Localization:GetString("110235"), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
					SceneUtils.ChangeToWorld()
				end,nil,function()
					SceneUtils.ChangeToWorld()
				end)
			end

		end
		return true
	elseif mainBuild == nil or mainBuild.state == BuildingStateType.FoldUp then
		return true
	end
	return false
end

local function SetShowPutBuildFromPanel(self, showPutBuildFromPanel)
	self.showPutBuildFromPanel= showPutBuildFromPanel
end

local function GetShowPutBuildFromPanel(self)
	return self.showPutBuildFromPanel
end

local function IsShowDiamond(self)
	local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k2")
	if showPower <= self.MainLv then
		return true
	end
	return false
end

--机器人是否有飞行路径
local function IsShowBuildFlyPath(self)
	return false
end

-- 获取车库索引
local function GetGarageIndex(self, buildId)
	for i, bId in ipairs(GarageBuildIds) do
		if buildId == bId then
			return i
		end
	end
	return nil
end

local function GetCountry(self)
	return self.country
end

local function PushBuildDeleteHandle(self, message)
	if message["buildingUuids"] then
		for _, bUuid in ipairs(message["buildingUuids"]) do
			--local buildData = self.allBuilding[bUuid]
			--local buildId = buildData.itemId
			--
			---- del buildIdBuilding
			--table.removebyfunc(self.buildIdBuilding[buildId], function(data)
			--	return data.uuid == bUuid
			--end)
			--
			---- del allBuilding
			--self.allBuilding[bUuid] = nil
			--
			self:RemoveBuilding(bUuid)
			self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA, bUuid)
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	end
end

local function GetBuildIdByPointId(self, pointId)
	local pointInfo = DataCenter.WorldPointManager:GetBuildDataByPointIndex(pointId)
	if pointInfo ~= nil then
		return pointInfo.itemId
	end

	return nil
end

local function SetShowCityLabel(self, show)
	self.showCityLabel = show
	EventManager:GetInstance():Broadcast(EventId.SetCityLabelShow, show)
end

local function UpgradeBuilding(self, bUuid)
	local buildData = self.allBuilding[bUuid]
	if buildData == nil then
		return
	end

	if buildData.updateTime > 0 then
		--正在升级中
		UIUtil.ShowTipsId(GameDialogDefine.BUILD_UPGRADING)
	elseif buildData.state == BuildingStateType.Normal then
		local ret = self:CheckBuildUpgradeResAndItem(bUuid)
		if ret.lackList[1] ~= nil then
			local lackTab = {}
			for k, v in ipairs(ret.lackList) do
				if v.cellType == CommonCostNeedType.Resource then
					local param = {}
					param.type = ResLackType.Res
					param.id = v.resourceType
					param.targetNum = v.count
					table.insert(lackTab,param)
				elseif v.cellType == CommonCostNeedType.Goods then
					local param = {}
					param.type = ResLackType.Item
					param.id = v.itemId
					param.targetNum = v.count
					table.insert(lackTab,param)
				end
			end
			GoToResLack.GoToItemResLackList(lackTab)
			UIUtil.ShowTipsId(120020)
		else
			local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
			local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
			local no_queue = BuildNoQueue.No
			if buildData.level <= 0 then
				no_queue = levelTemplate.no_queue
			else
				local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
				if buildCurLevelTemplate ~= nil then
					no_queue = buildCurLevelTemplate.no_queue
				end
			end
			local needPathTime = 0
			if levelTemplate.scan == BuildScanAnim.Play then
				needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(buildData.pointId, buildTemplate.tiles)
			end
			local param = {}
			param.uuid = tostring(bUuid)
			param.gold = BuildUpgradeUseGoldType.No
			param.upLevel = buildData.level + 1
			param.clientParam = ""
			param.truckId = 0
			param.pathTime = needPathTime
			param.robotUuid = 0
			if DataCenter.BuildQueueManager:IsCanUpgrade(buildData.itemId,buildData.level) then
				if no_queue == BuildNoQueue.No then
					local useTime = levelTemplate:GetBuildTime() + needPathTime
					if useTime > 0 then
						local robot = DataCenter.BuildQueueManager:GetFreeQueue(buildTemplate:IsSeasonBuild())
						if robot ~= nil then
							param.robotUuid = robot.uuid
						end
					end
				end
				SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
			else
				local buildQueueParam = {}
				buildQueueParam.enterType = UIBuildQueueEnterType.Upgrade
				buildQueueParam.uuid = bUuid
				buildQueueParam.messageParam = param
				buildQueueParam.buildId = buildData.itemId
				GoToUtil.GotoOpenBuildQueueWindow(buildQueueParam)
			end
		end
	end
end

local function OpenUpgradeSuccess(self, buildId, level)
end

local function CheckGetNewBuildSendMessage(self,buildId,level,bUuid)
	--雷达建造完之后要拉取一下detect event的数据
	if buildId == BuildingTypes.FUN_BUILD_MAIN and level == DataCenter.RadarCenterDataManager:GetRadarBubbleOpenMainCityLevel() then
		self:AddOneWaitFireEvent(EventId.DetectInfoChange)
		return
	end
	if buildId == BuildingTypes.FUN_BUILD_RADAR_CENTER then
		DataCenter.RadarCenterDataManager:GetDetectEventData()
		return
	end
end

local function GetBuildQueueState(self, uuid)
	local buildData = self:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		if buildData.destroyStartTime > 0 then
			return BuildQueueState.Ruins
		elseif buildData.updateTime > 0 then
			return BuildQueueState.UPGRADE
		end

		local buildId = buildData.itemId
		local queueType = self:GetNewQueueTypeByBuildId(buildId)
		if queueType ~= nil then
			if queueType == NewQueueType.Science then
				local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
				if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
					return BuildQueueState.RESEARCH
				end
			else
				local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
				if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
					if queueType == NewQueueType.FootSoldier or queueType == NewQueueType.CarSoldier
							or queueType == NewQueueType.BowSoldier or queueType == NewQueueType.Trap then
						return BuildQueueState.TRAINING
					elseif queueType == NewQueueType.Hospital then
						return BuildQueueState.CURE_ARMY
					end
				end
			end
		end
	end

	return BuildQueueState.DEFAULT
end

local function SetCurStamina(self)
	self.curMainBuildStamina = LuaEntry.Player:GetCurStamina()
end

local function CanPutLv0(self, buildId)
	local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	return template ~= nil and template.put == BuildPutType.Lv0
end

--判断资源和道具是否足够升级/建造
local function CheckBuildUpgradeResAndItem(self, bUuid, buildId)
	local result = {}
	result.lackList = {}
	local level = 0
	if bUuid ~= nil then
		local buildData = self:GetBuildingDataByUuid(bUuid)
		if buildData ~= nil then
			level = buildData.level
			buildId = buildData.itemId
		end
	end
	local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
	if levelTemplate ~= nil then
		local list = levelTemplate:GetNeedResource()
		if list ~= nil and list[1] ~= nil then
			for _, v in ipairs(list) do
				if LuaEntry.Resource:GetCntByResType(v.resourceType) < v.count then
					local param = {}
					param.cellType = CommonCostNeedType.Resource
					param.resourceType = v.resourceType
					param.count = v.count
					table.insert(result.lackList, param)
				end
			end
		end

		list = levelTemplate:GetNeedItem()
		if list ~= nil and list[1] ~= nil then
			for _, v in ipairs(list) do
				if DataCenter.ItemData:GetItemCount(v[1]) < v[2] then
					local param = {}
					param.cellType = CommonCostNeedType.Goods
					param.itemId = v[1]
					param.count = v[2]
					table.insert(result.lackList, param)
				end
			end
		end
	end
	result.enough = result.lackList[1] == nil
	return result
end

function BuildManager:CanUseDiamondBuyItem()
	local useDiamondLevel = LuaEntry.DataConfig:TryGetNum("building_base", "k13")
	return self.MainLv >= useDiamondLevel
end

function BuildManager:GetOwnNumByBuildIdAndLevel(buildId, level)
	local result = 0
	local list = self:GetAllBuildingByItemIdWithoutPickUp(buildId)
	if list ~= nil then
		for k,v in ipairs(list) do
			if v.level >= level then
				result = result + 1
			end
		end
	end
	return result
end

function BuildManager:BackBuildingCollectTimeMessageHandle(message)
	if message["errorCode"] == nil then
		if message["buildInfo"] ~= nil then
			local dic = message["buildInfo"]
			if dic ~= nil then
				local bUuid = dic["uuid"]
				self:AddBuilding(dic)
				self:AddOneWaitFireEvent(EventId.UPDATE_BUILD_DATA, bUuid)
			end
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
	if DataCenter.GuideManager:GetGuideType() == GuideType.BackBuildCollectTime then
		DataCenter.GuideManager:DoNext()
	end
end

local function UpdatePeopleByBuildReward(self, reward, pos)
	if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBuildUpgradeSuccess) then
		local param = {}
		param.list = { ResourceType.People }
		param.uiName = UIWindowNames.UIBuildUpgradeSuccess
		param.noUseResetResource = true
		param.hideBtnList = { UIMainTopBtnType.Stamina }
		EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
		TimerManager:GetInstance():DelayInvoke(function()
			EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIBuildUpgradeSuccess)
		end, 5)
	end
	TimerManager:GetInstance():DelayInvoke(function()
		LuaEntry.Resource:UpdateResource({ people = reward.total })
	end, 1)
	UIUtil.DoFly(RewardType.PEOPLE, 5, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.People), CS.SceneManager.World:WorldToScreenPoint(pos), Vector3.New(0,0,0))
end

function BuildManager:AfterBuildFinishShowEffect(uuid)
	local buildData = self:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		local buildId = buildData.itemId
		local level = buildData.level

		--self:CheckShowBuildAddDes(buildId,level)
		self:CheckShowFogUnlock(buildId,level)
		self:CheckGetNewBuildSendMessage(buildId,level, uuid)
		if buildId == BuildingTypes.FUN_BUILD_MAIN then
			if level == 10 then --大本升级到十本发送打点
				local ok, errorMsg = xpcall(function()
					CS.GameEntry.Sdk:LogEventLevelUp(level)
					return true
				end, debug.traceback)
			end
		else
			local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
			if template and not self.isCheck then
				local effect = template.building_effect_last
				for i ,v in pairs(effect) do
					if i == EffectDefine.BUILD_TIME_REDUCE then
						local effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
						if effectTime > 0 then
							self.isCheck = true
							UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockNewFunc, {anim = true})
							return
						end
					end
				end
			end
		end
		self:OpenUpgradeSuccess(buildId,level)
		if self:CheckShowUnlock(buildId,level) == false then
			--UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeTip,{anim = true}, {buildUid = uuid})
			--EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
		end
	end
end

--一个建筑进入视野
function BuildManager:WorldBuildInViewSignal(bUuid)
	self:AddOneWorldBuildInView(bUuid)
	DataCenter.WorldBuildTimeManager:BuildInViewSignal(bUuid)
	DataCenter.WorldBuildBubbleManager:BuildInViewSignal(bUuid)
	DataCenter.DesertAnnexManager:OnBuildInView(bUuid)
end

--一个建筑离开视野
function BuildManager:WorldBuildOutViewSignal(bUuid)
	self:RemoveOneWorldBuildInView(bUuid)
	DataCenter.WorldBuildTimeManager:BuildOutViewSignal(bUuid)
	DataCenter.WorldBuildBubbleManager:BuildOutViewSignal(bUuid)
	DataCenter.DesertAnnexManager:OnBuildOutView(bUuid)
end

--视野中添加一个建筑
function BuildManager:AddOneWorldBuildInView(bUuid)
	self.inViewWorldBuild[bUuid] = true
end

--视野中删除一个建筑
function BuildManager:RemoveOneWorldBuildInView(bUuid)
	self.inViewWorldBuild[bUuid] = nil
end

--这个建筑在是否在视野中
function BuildManager:IsWorldBuildInView(bUuid)
	return self.inViewWorldBuild[bUuid] ~= nil
end

--获取所有可跨服的建筑
function BuildManager:GetAllCrossBuild()
	local result = {}
	for k,v in ipairs(CrossBuildType) do
		local list = self:GetAllBuildingByItemIdWithoutPickUp(v)
		if list[1] ~= nil then
			for k1, v1 in ipairs(list) do
				table.insert(result, v1)
			end
		end
	end
	return result
end

--清空发送建筑数据
function BuildManager:ClearFireData()
	self.fireData = {}
	self.fireRemoveData = {}
end

--清空发送建筑数据
function BuildManager:AddOneFireData(data)
	if data ~= nil then
		table.insert(self.fireData, data)
	end
end

--清空发送建筑数据
function BuildManager:AddOneFireRemoveData(data)
	if data ~= nil then
		table.insert(self.fireRemoveData, data)
	end
end

--清空发送建筑数据
function BuildManager:FireFireData()
	if self.fireData[1] ~= nil then
		EventManager:GetInstance():Broadcast(EventId.RefreshBuildDataArr, self.fireData)
	end
	if self.fireRemoveData[1] ~= nil then
		EventManager:GetInstance():Broadcast(EventId.DeleteBuildDataArr, self.fireRemoveData)
	end
	self:ClearFireData()
end

--清空等待发送事件
function BuildManager:ClearWaitFireEvent()
	self.waitFireEvent = {}
end

--添加一个等待发送的事件
function BuildManager:AddOneWaitFireEvent(eventId, eventParam)
	if eventId ~= nil then
		table.insert(self.waitFireEvent, {eventId = eventId, eventParam = eventParam})
	end
end

--发送等待发送的事件
function BuildManager:FireWaitFireEvent()
	if self.waitFireEvent[1] ~= nil then
		for k, v in ipairs(self.waitFireEvent) do
			EventManager:GetInstance():Broadcast(v.eventId, v.eventParam)
		end
		self:ClearWaitFireEvent()
	end
end

function BuildManager:UserRecoverBuildingStaminaHandle(message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTipsId(message["errorCode"])
	else
		self:AddBuilding(message)
		if message["resource"]~=nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		UIUtil.ShowTipsId(300541)
		self:FireFireData()
		self:FireWaitFireEvent()
	end
end

function BuildManager:UserRobotDismissHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	else
		local dic = message["build"]
		if dic ~= nil then
			self:AddBuilding(dic)
			if dic["buildingId"] ~= nil then
				local buildId = dic["buildingId"]
				local level = dic["level"] or 0
				UIUtil.ShowTips(Localization:GetString("130085",
						Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name"))))
			end
		end
		if message["robot"]~=nil then
			DataCenter.BuildQueueManager:UpdateQueueData(message["robot"])
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	end
end

function BuildManager:UserRobotOccupyHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	else
		local dic = message["build"]
		if dic ~= nil then
			self:AddBuilding(dic)
		end
		if message["robot"]~=nil then
			DataCenter.BuildQueueManager:UpdateQueueData(message["robot"])
		end
		self:FireFireData()
		self:FireWaitFireEvent()
	end
end
--- 推送大本0级升1级回调
function BuildManager:PushBuildMainCityHandle(message)
	CSharpCallLuaInterface.UpdateBuildings(message)
	if CS.SceneManager.World ~= nil then
		CS.SceneManager.World:ClearReInitObject()
		CS.SceneManager.World:ReInitObject()
	end
	local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
	if mainBuild ~= nil then
		self:AddOneWaitFireEvent(EventId.BuildUpgradeFinish, mainBuild.uuid)
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Finish)
		self:AddOneWaitFireEvent(EventId.BuildMainZeroUpgradeSucces)
	end
	self:FireFireData()
	self:FireWaitFireEvent()
end

--获取等级最小的建筑
function BuildManager:GetMinLevelBuild(buildId)
	local level = 999
	local result =  nil
	local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
	for k, v in ipairs(list) do
		if v.level < level then
			level = v.level
			result = v
		end
	end
	return result
end

--是否可以显示战力
function BuildManager:CanShowPower()
	local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
	if showPower <= self.MainLv then
		return true
	end
	return false
end

function BuildManager:CanShowSpeed()
	local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k3")
	if showPower <= self.MainLv then
		return true
	end
	return false
end

--获取所有正在升级的家具建筑
function BuildManager:GetAllUpgradingFurnitureBuild()
	local result = {}
	for k, v in pairs(self.allBuilding) do
		if v.level > 0 and v:IsUpgrading() then
			local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.itemId, 0)
			if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
				table.insert(result, v)
			end
		end
	end
	return result
end

--是否可以显示快捷建造
function BuildManager:CanShowUIMainBuild()
	local needLv = LuaEntry.DataConfig:TryGetNum("show_power", "k5")
	if needLv <= self.MainLv then
		return true
	end
	return false
end

function BuildManager:GetOwnBuildNum()
	local result = 0
	for k,v in pairs(self.allBuilding) do
		if v.state ~= BuildingStateType.FoldUp then
			if v.itemId ~= BuildingTypes.FUN_BUILD_BELL then
				result = result + 1
			end
		end
	end
	return  result
end

function BuildManager:GetAdaptiveBoxBaseNumByGroupAndLevel(groupid,levelid)
	local result = 0
	LocalController:instance():visitTable(TableName.Adaptive_Box, function(id, line)
		local garage = line:getValue("group")
		local level = line:getValue("level")
		local baseNum = line:getValue("base_num")
		if  garage == groupid and level == levelid then
			result = baseNum
		end
	end)
	return result
end

function BuildManager:SendRuinBuilding(uuid, deltaStamina)
	SFSNetwork.SendMessage(MsgDefines.ZombieRuinBuild, uuid, deltaStamina)
end

function BuildManager:HandleRuinBuilding(message)
	if message["building"] then
		local uuid = message["building"]["uuid"]
		local buildData = self.allBuilding[uuid]
		if buildData then
			buildData:UpdateInfo(message["building"])
		end
		EventManager:GetInstance():Broadcast(EventId.BuildingStaminaChanged, uuid)
		DataCenter.CityHudManager:RefreshBuildingHudByUuid(uuid)
	end
end

function BuildManager:SendRepairBuilding(uuid)
	SFSNetwork.SendMessage(MsgDefines.FixZombieRuinBuild, uuid)
end

function BuildManager:HandleRepairBuilding(message)
	if message["resource"] then
		LuaEntry.Resource:UpdateResource(message["resource"])
	end
	if message["building"] then
		local uuid = message["building"]["uuid"]
		local buildData = self.allBuilding[uuid]
		if buildData then
			buildData:UpdateInfo(message["building"])
			buildData.deltaStamina = 0
		end
		EventManager:GetInstance():Broadcast(EventId.BuildingStaminaChanged, uuid)
		DataCenter.CityHudManager:RefreshBuildingHudByUuid(uuid)
	end
end

function BuildManager:PushNoticeBuilding(buildId,endTime)
	if self.noticeDic == nil then
		self.noticeDic = {}
	end
	self.noticeDic[buildId] = endTime
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local minTime = LongMaxValue
	local chooseBuildId = 0
	for k,v in pairs(self.noticeDic) do
		if v>curTime then
			if minTime>v then
				chooseBuildId = k
				minTime = v
			end
		end
	end
	if chooseBuildId >0 then
		local nameStr = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), chooseBuildId,"name")
		local deltaTime = (minTime-curTime)*0.001
		DataCenter.PushNoticeManager:CheckPlayerBuildingFinish(deltaTime,{Localization:GetString(nameStr)})
	else
		DataCenter.PushNoticeManager:CheckPlayerBuildingFinish(0)
	end
end
function BuildManager:RemoveNoticeBuilding(buildId)
	if self.noticeDic~=nil then
		if self.noticeDic[buildId]~=nil then
			self.noticeDic[buildId] = nil
			local curTime = UITimeManager:GetInstance():GetServerTime()
			local minTime = LongMaxValue
			local chooseBuildId = 0
			for k,v in pairs(self.noticeDic) do
				if v>curTime then
					if minTime>v then
						chooseBuildId = k
					end
				end
			end
			if chooseBuildId >0 then
				local nameStr = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), chooseBuildId,"name")
				local deltaTime = (minTime-curTime)*0.001
				DataCenter.PushNoticeManager:CheckPlayerBuildingFinish(deltaTime,{Localization:GetString(nameStr)})
			else
				DataCenter.PushNoticeManager:CheckPlayerBuildingFinish(0)
			end
		end
	end
end

local function PlayHurtEffect(self, bUuid)
	if self.hurtReqs[bUuid] then
		return
	end

	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
	self.hurtReqs[bUuid] = Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/Eff_canting_hit.prefab")
	self.hurtReqs[bUuid]:completed('+', function(req)
		local go = req.gameObject
		local tf = go.transform
		tf.position = buildTemplate:GetPosition()
		tf.rotation = Quaternion.Euler(0, buildTemplate:GetRotation(), 0)
		tf.localScale = Vector3.one * (tonumber(buildTemplate.upgrade_scale) or 1)
		TimerManager:GetInstance():DelayInvoke(function()
			if self.hurtReqs[bUuid] then
				self.hurtReqs[bUuid]:Destroy()
				self.hurtReqs[bUuid] = nil
			end
		end, 2)
	end)
end

BuildManager.__init = __init
BuildManager.__delete = __delete
BuildManager.Startup = Startup
BuildManager.InitData = InitData
BuildManager.UpdateBuildings = UpdateBuildings
BuildManager.BuildCcdMNewHandle = BuildCcdMNewHandle
BuildManager.GetBuildIdByNewQueue = GetBuildIdByNewQueue
BuildManager.AddListener = AddListener
BuildManager.RemoveListener = RemoveListener
BuildManager.AddOneBuildInView = AddOneBuildInView
BuildManager.RemoveOneBuildInView = RemoveOneBuildInView
BuildManager.BuildInViewSignal = BuildInViewSignal
BuildManager.BuildOutViewSignal = BuildOutViewSignal
BuildManager.IsBuildInView = IsBuildInView
BuildManager.GetBuildState = GetBuildState
BuildManager.GetBuildIconPath = GetBuildIconPath
BuildManager.GetExtraCanBuildNum = GetExtraCanBuildNum
BuildManager.FreeBuildingFoldUpNewHandle = FreeBuildingFoldUpNewHandle
BuildManager.FreeBuildingUpNewHandle = FreeBuildingUpNewHandle
BuildManager.FreeBuildingExpendDomeHandle =FreeBuildingExpendDomeHandle
BuildManager.HasBuildByIdAndLevel =HasBuildByIdAndLevel
BuildManager.GetCanUpgradeBuildUuidList =GetCanUpgradeBuildUuidList
BuildManager.GetBuildCanUpgrade = GetBuildCanUpgrade
BuildManager.ShowBuildCanUpgradeBubble = ShowBuildCanUpgradeBubble
BuildManager.GetBuildId = GetBuildId
BuildManager.GetBuildLevel = GetBuildLevel
BuildManager.GetEffectNumWithType = GetEffectNumWithType
BuildManager.CheckShowBuildAddDes = CheckShowBuildAddDes
BuildManager.CheckShowFogUnlock = CheckShowFogUnlock
BuildManager.IsShowBuildRedDot = IsShowBuildRedDot
BuildManager.IsShowRedDotByOnce = IsShowRedDotByOnce
BuildManager.CanShowUnlock = CanShowUnlock
BuildManager.GetBuildRedDotByTabType = GetBuildRedDotByTabType
BuildManager.IsShowRedDotByTemplateAndState = IsShowRedDotByTemplateAndState
BuildManager.SetBuildRedDotOnce = SetBuildRedDotOnce
BuildManager.SetBuildShowUnlock = SetBuildShowUnlock
BuildManager.PushInitBuildHandle = PushInitBuildHandle
BuildManager.PushBuildUpgradeFinishHandle = PushBuildUpgradeFinishHandle
BuildManager.UILoadingExitSignal = UILoadingExitSignal
BuildManager.GetResourceTypeByBuildId = GetResourceTypeByBuildId
BuildManager.PushBuildingInfoHandle = PushBuildingInfoHandle
BuildManager.PushAddBuildingHandle = PushAddBuildingHandle
BuildManager.HandleBuildingInfos = HandleBuildingInfos
BuildManager.GetOutResourceTypeByBuildId = GetOutResourceTypeByBuildId
BuildManager.GetUseResourceTypeByBuildId = GetUseResourceTypeByBuildId
BuildManager.UserResupplyBuildingHandle = UserResupplyBuildingHandle
BuildManager.UserResSynNewHandle = UserResSynNewHandle
BuildManager.FlyExtraRewards = FlyExtraRewards
BuildManager.ShowGetResourceEffect = ShowGetResourceEffect
BuildManager.isReachMax = isReachMax
BuildManager.WorldMvHandle = WorldMvHandle
BuildManager.ReceiveBuildingGrowValRewardHandle = ReceiveBuildingGrowValRewardHandle
BuildManager.IsCanOutItemByBuildId = IsCanOutItemByBuildId
BuildManager.IsHaveResource = IsHaveResource
BuildManager.IsHaveItem = IsHaveItem
BuildManager.GetShowBubbleTime = GetShowBubbleTime
BuildManager.GetShowItemBubbleTime = GetShowItemBubbleTime
BuildManager.GetOutResourceNum = GetOutResourceNum
BuildManager.GetCollectMaxEffectByBuildId = GetCollectMaxEffectByBuildId
BuildManager.GetWorldTileBtnTypeByBuildId = GetWorldTileBtnTypeByBuildId
BuildManager.GetCanGetResourceBuildUuidByResourceType = GetCanGetResourceBuildUuidByResourceType
BuildManager.GetBuildMinLevel = GetBuildMinLevel
BuildManager.FreeBuildingUpgradeFinishHandle = FreeBuildingUpgradeFinishHandle
BuildManager.CheckSendBuildFinish = CheckSendBuildFinish
BuildManager.IsCanUpgradeZeroBuild=IsCanUpgradeZeroBuild
BuildManager.FreeBuildingPlaceMainBuildingHandle=FreeBuildingPlaceMainBuildingHandle
BuildManager.CheckShowUnlock = CheckShowUnlock
BuildManager.CheckBuildingUnlockWithPreBuildAndScience = CheckBuildingUnlockWithPreBuildAndScience
BuildManager.CheckShowBuildUnlockWhenScienceLevelUp = CheckShowBuildUnlockWhenScienceLevelUp
BuildManager.BuildCityBuildingHandle=BuildCityBuildingHandle
BuildManager.HasResourceBuildingFull = HasResourceBuildingFull
BuildManager.IsResourceBuildingFull = IsResourceBuildingFull
BuildManager.GetAllResourceBuildingFullLatestTime = GetAllResourceBuildingFullLatestTime
BuildManager.UpdateBuildDataSignal = UpdateBuildDataSignal
BuildManager.PostNotice = PostNotice
BuildManager.AddTimer = AddTimer
BuildManager.DeleteTimer = DeleteTimer
BuildManager.LoadNoShowUnlock = LoadNoShowUnlock
BuildManager.SaveNoShowUnlock = SaveNoShowUnlock
BuildManager.ShowBuildErrorCode = ShowBuildErrorCode
BuildManager.FindMainBuildInitPositionHandle = FindMainBuildInitPositionHandle
BuildManager.FreeBuildingPlaceNewHandle = FreeBuildingPlaceNewHandle
BuildManager.FreeBuildingReplaceNewHandle = FreeBuildingReplaceNewHandle
BuildManager.AddOneChangeMoveBuild = AddOneChangeMoveBuild
BuildManager.GetOneAndRemoveMoveBuild = GetOneAndRemoveMoveBuild
BuildManager.BuildWorldMoveNewHandle = BuildWorldMoveNewHandle
BuildManager.CanFastBuild = CanFastBuild
BuildManager.GetFastBuildDataList = GetFastBuildDataList
BuildManager.GetBuildExp = GetBuildExp
BuildManager.SetNewUserWorld = SetNewUserWorld
BuildManager.IsInNewUserWorld = IsInNewUserWorld
BuildManager.GetMaxBuildingLevel = GetMaxBuildingLevel
BuildManager.GetBuildingDataByUuid = GetBuildingDataByUuid
BuildManager.GetAllBuildingByItemIdWithoutPickUp = GetAllBuildingByItemIdWithoutPickUp
BuildManager.AddBuilding = AddBuilding
BuildManager.RemoveBuilding = RemoveBuilding
BuildManager.GetFunbuildByItemID = GetFunbuildByItemID
BuildManager.HasBuilding = HasBuilding
BuildManager.GetMaxLvBuildDataByBuildId = GetMaxLvBuildDataByBuildId
BuildManager.GetUnlock2BuildByEffectAndType = GetUnlock2BuildByEffectAndType
BuildManager.IsExistBuildByTypeLv = IsExistBuildByTypeLv
BuildManager.GetAllBuildUuid = GetAllBuildUuid
BuildManager.GetFoldUpBuildByBuildId = GetFoldUpBuildByBuildId
BuildManager.GetHaveBuildNumWithOutFoldUpByBuildId = GetHaveBuildNumWithOutFoldUpByBuildId
BuildManager.GetCurMaxBuildNum = GetCurMaxBuildNum
BuildManager.GetMaxBuildNum = GetMaxBuildNum
BuildManager.AllianceHelpAddSpeed = AllianceHelpAddSpeed
BuildManager.OnAllianceCallHelp = OnAllianceCallHelp
BuildManager.GetAllInBaseTruckShowBuild = GetAllInBaseTruckShowBuild
BuildManager.GetPathTimeFromDroneToBuildTarget = GetPathTimeFromDroneToBuildTarget
BuildManager.GetBuildingDataByPointId = GetBuildingDataByPointId
BuildManager.GetAllBuildWithoutPickUp = GetAllBuildWithoutPickUp
BuildManager.PushBuildFoldUpHandle = PushBuildFoldUpHandle
BuildManager.CheckReplaceMain = CheckReplaceMain
BuildManager.GetArmyBuildMaxLevelData =GetArmyBuildMaxLevelData
BuildManager.SetShowPutBuildFromPanel = SetShowPutBuildFromPanel
BuildManager.GetShowPutBuildFromPanel = GetShowPutBuildFromPanel
BuildManager.IsShowDiamond = IsShowDiamond
BuildManager.GetResTypeByBuildUuid = GetResTypeByBuildUuid
BuildManager.CheckIsSendMessage =CheckIsSendMessage
BuildManager.DelayClearSendList = DelayClearSendList
BuildManager.IsShowBuildFlyPath = IsShowBuildFlyPath
BuildManager.FreeBuildingStartFixHandle = FreeBuildingStartFixHandle
BuildManager.FreeBuildingFinishFixHandle = FreeBuildingFinishFixHandle
BuildManager.CheckSendFixBuildFinish = CheckSendFixBuildFinish
BuildManager.CheckIsSendFixMessage = CheckIsSendFixMessage
BuildManager.DelayClearSendFixList = DelayClearSendFixList
BuildManager.OnAllianceCallFixHelp = OnAllianceCallFixHelp
BuildManager.AllianceHelpFixAddSpeed = AllianceHelpFixAddSpeed
BuildManager.GetGarageIndex = GetGarageIndex
BuildManager.GetCountry = GetCountry
BuildManager.PushBuildDeleteHandle = PushBuildDeleteHandle
BuildManager.GetBuildIdByPointId = GetBuildIdByPointId
BuildManager.SetShowCityLabel = SetShowCityLabel
BuildManager.UpgradeBuilding = UpgradeBuilding
BuildManager.CheckGetNewBuildSendMessage = CheckGetNewBuildSendMessage
BuildManager.CheckBuildIsReward = CheckBuildIsReward
BuildManager.ClickBubbleUpgradeReward = ClickBubbleUpgradeReward
BuildManager.GetEventStoreMax = GetEventStoreMax
BuildManager.GetBuildQueueState = GetBuildQueueState
BuildManager.GetNewQueueTypeByBuildId = GetNewQueueTypeByBuildId
BuildManager.SetCurStamina = SetCurStamina
BuildManager.CanPutLv0 = CanPutLv0
BuildManager.CheckBuildUpgradeResAndItem = CheckBuildUpgradeResAndItem
BuildManager.GetBuildTypesByOutResourceType = GetBuildTypesByOutResourceType
BuildManager.OpenUpgradeSuccess = OpenUpgradeSuccess
BuildManager.SetOnMovingBuildUuid = SetOnMovingBuildUuid
BuildManager.GetOnMovingBuildUuid = GetOnMovingBuildUuid
BuildManager.CheckShowReplaceTip = CheckShowReplaceTip
BuildManager.UpdatePeopleByBuildReward = UpdatePeopleByBuildReward
BuildManager.CheckMainBuildUpgradePanel = CheckMainBuildUpgradePanel
BuildManager.PlayHurtEffect = PlayHurtEffect

return BuildManager