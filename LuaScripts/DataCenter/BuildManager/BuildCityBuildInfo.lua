--- Created by shimin.
--- DateTime: 2023/11/24 00:05
--- 0级假建筑

local BuildCityBuildInfo = BaseClass("BuildCityBuildInfo")

function BuildCityBuildInfo:__init()
	self.pointId = 0			--坐标			
	self.buildId = 0			--建筑id
	self.state = BuildCityBuildState.None--状态
	self.preState = 0
end

function BuildCityBuildInfo:InitData(pointId, buildId)
	self.pointId = pointId
	self.buildId = buildId
	self:Refresh()
end

function BuildCityBuildInfo:Refresh()
	local state = BuildCityBuildState.None
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
	if buildData ~= nil and buildData.level ~= 0 then
		state = BuildCityBuildState.Own
	else
		--判断前置建筑
		state = BuildCityBuildState.Fake
		local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
		if desTemplate ~= nil then
			local num = desTemplate:GetCurMaxCanBuildNum()
			if num <= 0 then
				state = BuildCityBuildState.Pre
			end
		end
		
		local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, 0)
		if levelTemplate ~= nil then
			--判断地块
			local need_pve = levelTemplate.need_pve
			if need_pve ~= 0 then
				if not DataCenter.LandManager:IsZoneUnlocked(need_pve) then
					state = BuildCityBuildState.Pre
					self.preState = BuildCityBuildPreState.Pve
				end
			end
			if state ~= BuildCityBuildState.Pre then
				local preBuild = levelTemplate:GetPreBuild()
				if preBuild ~= nil then
					for k1, v1 in ipairs(preBuild) do
						if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
							state = BuildCityBuildState.Pre
							self.preState = BuildCityBuildPreState.Build
							break
						end
					end
				end
			end

			if state ~= BuildCityBuildState.Pre then
				--判断科技
				local needScience = levelTemplate:GetNeedScience()
				if needScience[1] ~= nil then
					for k, v in ipairs(needScience) do
						if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
							state = BuildCityBuildState.Pre
							self.preState = BuildCityBuildPreState.Science
							break
						end
					end
				end
			end

			if state ~= BuildCityBuildState.Pre then
				--判断vip
				local need_vip = levelTemplate.need_vip or 0
				if need_vip ~= 0 then
					local vipData = DataCenter.VIPManager:GetVipData()
					if vipData == nil or vipData.level < need_vip then
						state = BuildCityBuildState.Pre
						self.preState = BuildCityBuildPreState.Vip
					end
				end
			end

			if state ~= BuildCityBuildState.Pre then
				--判断地块奖励
				local need_landreward = levelTemplate.need_landreward or 0
				if need_landreward ~= 0 then
					if not DataCenter.LandManager:IsRewardReceived(need_landreward) then
						state = BuildCityBuildState.Pre
						self.preState = BuildCityBuildPreState.LandReward
					end
				end
			end

			if state ~= BuildCityBuildState.Pre then
				--判断地块奖励
				local need_block = levelTemplate.need_block or 0
				if need_block ~= 0 then
					if not DataCenter.LandManager:IsBlockUnlocked(need_block) then
						state = BuildCityBuildState.Pre
						self.preState = BuildCityBuildPreState.LandReward
					end
				end
			end
		end
	end
	if state ~= self.state then
		self.state = state
		self:CheckShowCreateHudBubble()
		return true
	end
	return false
end

function BuildCityBuildInfo:CanBuildUpgrade()
	if self.state == BuildCityBuildState.Own then
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
		if buildData ~= nil then
			if buildData:IsUpgrading()==false and buildData:IsUpgradeFinish()==false then
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
				local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
				local canShowUpgrade = maxLv > buildData.level and buildData.level > 0
				if canShowUpgrade then
					if self.buildId == BuildingTypes.FUN_BUILD_SCIENCE_1 or self.buildId == BuildingTypes.FUN_BUILD_SCIENE or self.buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
						local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(buildData.uuid)
						if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
							return false
						end
					elseif self.buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK or self.buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
							or self.buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
						local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.buildId))
						if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
							return false
						end
					end
					
					local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, buildData.level)
					if levelTemplate ~= nil then
						local zeroLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, 0)
						if zeroLevelTemplate ~= nil and zeroLevelTemplate:IsFurnitureBuild() then
							--家具建筑判断经验满
							local all = levelTemplate.levelup_exp
							local cur = DataCenter.FurnitureManager:GetBuildCurExp(buildData.uuid)
							if all > cur then
								return false
							end
						end
						
						--章节
						local need_chapter = levelTemplate.need_chapter or 0
						if need_chapter > 0 and not DataCenter.ChapterTaskManager:IsReachChapter(need_chapter) then
							return false
						end

						--前置建筑
						local list = levelTemplate:GetPreBuild()
						if list ~= nil and list[1] ~= nil then
							for k1, v1 in ipairs(list) do
								if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
									return false
								end
							end
						end

						--判断地块
						local need_pve = levelTemplate.need_pve
						if need_pve ~= 0 then
							if not DataCenter.LandManager:IsZoneUnlocked(need_pve) then
								return false
							end
						end
						
						--资源
						list = levelTemplate:GetNeedResource()
						if list ~= nil and list[1] ~= nil then
							for k,v in pairs(list) do
								local resourceType = v.resourceType
								local count = v.count
								local own = LuaEntry.Resource:GetCntByResType(resourceType)
								if own < count then
									return false
								end
							end
						end
						--道具
						list = levelTemplate:GetNeedItem()
						if list ~= nil and list[1] ~= nil then
							for _, v in ipairs(list) do
								local itemId = v[1]
								local count = v[2]
								if DataCenter.ItemData:GetItemCount(itemId) < count then
									return false
								end
							end
						end
						
						return true
					end
				end
			end
		end
	end
	return false
end

function BuildCityBuildInfo:CanBuildUpgradeJump()
	if self.state == BuildCityBuildState.Own then
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
		if buildData ~= nil then
			if buildData:IsUpgrading()==false and buildData:IsUpgradeFinish()==false then
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
				local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
				local canShowUpgrade = maxLv > buildData.level and buildData.level > 0
				if canShowUpgrade then
					if self.buildId == BuildingTypes.FUN_BUILD_SCIENCE_1 or self.buildId == BuildingTypes.FUN_BUILD_SCIENE or self.buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
						local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(buildData.uuid)
						if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
							return false
						end
					elseif self.buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK or self.buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
							or self.buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
						local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.buildId))
						if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
							return false
						end
					end

					local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, buildData.level)
					if levelTemplate ~= nil then
						return true
					end
				end
			end
		end
	end
	return false
end

function BuildCityBuildInfo:CheckShowCreateHudBubble()
	if self.state == BuildCityBuildState.Fake then
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
		if buildData == nil then
			local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId,0)
			if levelTemplate ~= nil then
				local needBoxConfig = toInt(levelTemplate.need_open)
				if needBoxConfig ==1 then
					if DataCenter.CityResidentManager.readyQueueHudSwitch then
						local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
						if buildTemplate ~= nil then
							local hudParam = {}
							hudParam.uuid = self.pointId
							hudParam.pos = buildTemplate:GetPosition() + Vector3.New(0, 1, 0)
							hudParam.type = CityHudType.BuildCreate
							hudParam.location = CityHudLocation.UI
							hudParam.unique = false
							DataCenter.CityHudManager:Create(hudParam)
							return
						end
					end
				end
			end
		end
	end
	DataCenter.CityHudManager:Destroy(self.pointId, CityHudType.BuildCreate)
end
return BuildCityBuildInfo