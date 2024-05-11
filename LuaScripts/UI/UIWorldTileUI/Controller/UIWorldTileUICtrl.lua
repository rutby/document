local UIWorldTileUICtrl = BaseClass("UIWorldTileUICtrl", UIBaseCtrl)
local function CloseSelf(self,hidAnim)
	if hidAnim~=nil and hidAnim == true then
		UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI, {anim = true,playEffect = false})
	else
		UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
	end
end

local function GetBuildBtn(self,buildInfo)
	local buttonList = {}
	if buildInfo ~= nil then
		if buildInfo.ownerUid == LuaEntry.Player.uid then
			local uuid = buildInfo.uuid
			local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
			if buildData ~= nil then
				local buildId = buildData.itemId
				local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
				if buildTemplate ~= nil then
					if buildData.level >= 0 then
						if buildData.destroyStartTime>0 then
							local curTime = UITimeManager:GetInstance():GetServerTime()
							if buildData.destroyEndTime>curTime then
								table.insert(buttonList,WorldTileBtnType.City_SpeedUpRuins)
							elseif buildData.destroyEndTime<=0 then
								table.insert(buttonList,WorldTileBtnType.City_Repair)
							end
						elseif true then
							local curTime = UITimeManager:GetInstance():GetServerTime()
							local isSpeedUp = buildData.updateTime > curTime
							local maxLv = DataCenter.BuildTemplateManager:GetBuildMaxLevel(buildTemplate)
							local canShowUpgrade = maxLv > buildData.level and buildData.level > 0 and (not isSpeedUp)
							if buildId == BuildingTypes.FUN_BUILD_SCIENE or buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART or buildId == BuildingTypes.FUN_BUILD_SCIENCE_1 then
								local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
								if queue ~= nil then
									local state = queue:GetQueueState()
									if state == NewQueueState.Finish then
										SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
									elseif state == NewQueueState.Work then
										table.insert(buttonList,WorldTileBtnType.City_SpeedUpScience)
										canShowUpgrade = false
									end
									table.insert(buttonList,WorldTileBtnType.City_Science)
								end
							elseif buildId == BuildingTypes.FUN_BUILD_HOSPITAL then
								local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
								if queue ~= nil then
									table.insert(buttonList, WorldTileBtnType.City_Recovery)
									local state = queue:GetQueueState()
									if state == NewQueueState.Finish then
										SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
									elseif state == NewQueueState.Work then
										table.insert(buttonList, WorldTileBtnType.City_SpeedUpHospital)
										canShowUpgrade = false
									end
								end
							elseif buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK or buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
									or buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK or buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
								local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId))
								if queue ~= nil then
									if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
										table.insert(buttonList,WorldTileBtnType.City_TrainingTank)
									elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
										table.insert(buttonList,WorldTileBtnType.City_TrainingInfantry)
									elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
										table.insert(buttonList,WorldTileBtnType.City_TrainingAircraft)
									elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
										table.insert(buttonList,WorldTileBtnType.City_TrainingTrap)
									end

									local state = queue:GetQueueState()
									if state == NewQueueState.Finish then
										SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
									elseif state == NewQueueState.Work then
										table.insert(buttonList,WorldTileBtnType.City_SpeedUpTrain)
										canShowUpgrade = false
									end
								end
							end
							if canShowUpgrade and buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and BuildingUtils.IsInEdenSubwayGroup(buildId)==false then
								table.insert(buttonList,WorldTileBtnType.City_Upgrade)
							end
							table.insert(buttonList,WorldTileBtnType.City_Details)
							--if buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
							--	table.insert(buttonList,WorldTileBtnType.AssistanceSeasonBuild)
							--	--table.insert(buttonList,WorldTileBtnType.SeasonBuildPickUp)
							--end
							if  buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
								--table.insert(buttonList,WorldTileBtnType.City_BatteryrAttack)
							elseif  buildId == BuildingTypes.FUN_BUILD_TRAINFIELD_1 or buildId == BuildingTypes.FUN_BUILD_TRAINFIELD_2 or buildId == BuildingTypes.FUN_BUILD_TRAINFIELD_3 then
								--if EquipmentUtil.IsEquipmentSysOpen() then
								--	table.insert(buttonList,WorldTileBtnType.GarageEquipment)
								--end
							elseif buildId == BuildingTypes.FUN_BUILD_POLICE_STATION then
								table.insert(buttonList, WorldTileBtnType.PoliceStation)
							elseif buildId == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
								--table.insert(buttonList,WorldTileBtnType.AllianceResSupport)--MK: 联盟援助入口
								table.insert(buttonList, WorldTileBtnType.AllianceEntrance)
							elseif buildId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then	--虫洞入口
								--local configOpenState = LuaEntry.DataConfig:CheckSwitch("new_worm_hole")
								--if configOpenState then
								--	if not isSpeedUp then
								--		table.insert(buttonList,WorldTileBtnType.WormHole_Enter)
								--		--table.insert(buttonList,WorldTileBtnType.WormHoleToB)
								--	end
								--else
								--	table.insert(buttonList,WorldTileBtnType.WormHole_Enter)
								--	table.insert(buttonList, WorldTileBtnType.City_PickUp)
								--end
								if LuaEntry.Player.serverType ~= ServerType.EDEN_SERVER then
									table.insert(buttonList, WorldTileBtnType.WormHoleToB)
									table.insert(buttonList, WorldTileBtnType.WormHoleToC)
								end
							elseif buildId == BuildingTypes.WORM_HOLE_CROSS then
								table.insert(buttonList,WorldTileBtnType.AssistanceSeasonBuild)
								if  LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
									table.insert(buttonList, WorldTileBtnType.CrossWormHoleEnter)
								else
									local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
									if queue ~= nil then
										table.insert(buttonList,WorldTileBtnType.City_Recovery)
										local state = queue:GetQueueState()
										if state == NewQueueState.Finish then
											SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
										end
									end
								end
								if DataCenter.CrossWormManager:IsNewWormTrain() then
									table.insert(buttonList, WorldTileBtnType.CrossWormHero)
								end
								if EquipmentUtil.IsEquipmentSysOpen() then
									table.insert(buttonList, WorldTileBtnType.DefenceSuitEquipmentCross)
								end
							elseif buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(buildId) then  --虫洞出口
								--local configOpenState = LuaEntry.DataConfig:CheckSwitch("new_worm_hole")
								--if configOpenState then
								if buildData.level == 0 then
									isSpeedUp = false
									table.insert(buttonList,WorldTileBtnType.WormHole_Create)
									table.insert(buttonList,WorldTileBtnType.WormHole_Dismantle)
								elseif buildData.level == 1 then
									--table.insert(buttonList,WorldTileBtnType.WormHole_Dismantle)  uibuild_btn_chaichu
									--if LuaEntry.Player.serverType == ServerType.NORMAL then
										table.insert(buttonList,WorldTileBtnType.WormHole_Enter)
									--end
									--table.insert(buttonList,WorldTileBtnType.WormHoleToA)
								end
								--else
								--	table.insert(buttonList,WorldTileBtnType.WormHole_Enter)
								--	table.insert(buttonList, WorldTileBtnType.City_PickUp)
								--end
							elseif buildId == BuildingTypes.FUN_BUILD_MARKET then
								table.insert(buttonList,WorldTileBtnType.City_Call)
								table.insert(buttonList,WorldTileBtnType.City_QiFei)
							elseif buildId == BuildingTypes.FUN_BUILD_COLD_STORAGE then
								table.insert(buttonList,WorldTileBtnType.City_ColdCapacity)
							elseif buildId == BuildingTypes.FUN_BUILD_WATER_STORAGE then
								table.insert(buttonList,WorldTileBtnType.CommonShop)
							elseif buildId == BuildingTypes.APS_BUILD_PUB then
								--if self:CheckPubButtonOpen(WorldTileBtnType.Poster_Exchange) and LuaEntry.DataConfig:CheckSwitch("battlefield_medal_send") then
								--	table.insert(buttonList,WorldTileBtnType.Poster_Exchange)
								--end
								--if self:CheckPubButtonOpen(WorldTileBtnType.Hero_Advance) then
								--	table.insert(buttonList,WorldTileBtnType.Hero_Advance)
								--end
								if self:CheckPubButtonOpen(WorldTileBtnType.Hero_Recruit) then
									table.insert(buttonList,WorldTileBtnType.Hero_Recruit)
								end
								--if self:CheckPubButtonOpen(WorldTileBtnType.HeroMedalShop) then
								--	table.insert(buttonList,WorldTileBtnType.HeroMedalShop)
								--end
								--if DataCenter.HeroMedalRedemptionManager:IsOpen() then
								--	table.insert(buttonList, WorldTileBtnType.HeroMetalRedemption)
								--end
							elseif buildId == BuildingTypes.FUN_BUILD_COMPREHENSIVE_STORAGE then
								table.insert(buttonList,WorldTileBtnType.City_IntegratedWarehouse)
							elseif buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
								table.insert(buttonList,WorldTileBtnType.City_ResourceTransport)
							elseif buildId == BuildingTypes.FUN_BUILD_DEFENCE_CENTER then
								table.insert(buttonList,WorldTileBtnType.City_Defence)
							elseif buildId == BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW then
								local showLevel = LuaEntry.DataConfig:TryGetNum("battle_config", "k15")
								if DataCenter.BuildManager.MainLv >= showLevel then
									table.insert(buttonList,WorldTileBtnType.City_Defence)
								end
								if EquipmentUtil.IsEquipmentSysOpen() then
									table.insert(buttonList,WorldTileBtnType.DefenceSuitEquipment)
								end
							elseif buildId == BuildingTypes.FUN_BUILD_SPEED then
								table.insert(buttonList,WorldTileBtnType.BuildNitrogen)
							elseif buildId == BuildingTypes.FUN_BUILD_RADAR_CENTER then
								--table.insert(buttonList,WorldTileBtnType.RadarCenter_Alert)
								local effect = Mathf.Round(LuaEntry.Effect:GetGameEffect(EffectDefine.DETECT_EVENT_FUNCTION_OPEN))
								if effect > 0 then
									table.insert(buttonList,WorldTileBtnType.RadarCenter_Detective)
								end
							elseif buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
								--local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
								--if isAvailable and LuaEntry.DataConfig:CheckSwitch("APS_monthcard") then
								--	table.insert(buttonList, WorldTileBtnType.GolloesCamp)
								--end
								--local num = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_GULU_STORE_OPEN)
								--if num > 0 then
								--	table.insert(buttonList, WorldTileBtnType.City_GROCERY_STORE)
								--end
								--if DataCenter.CommonShopManager:CheckIfModuleOpen() then
								--	table.insert(buttonList, WorldTileBtnType.CommonShop)
								--end
							elseif buildId == BuildingTypes.FUN_BUILD_BARRACKS then
								if buildData.level > 0 then
									table.insert(buttonList, WorldTileBtnType.ARMY)
									--table.insert(buttonList, WorldTileBtnType.WorldNews)
								end
							elseif buildId == BuildingTypes.FUN_BUILD_MAIN then
								--local showLevel = LuaEntry.DataConfig:TryGetNum("battle_config", "k15")
								--if DataCenter.BuildManager.MainLv >= showLevel then
								--	table.insert(buttonList,WorldTileBtnType.City_Defence)
								--end
								--local configOpenState = LuaEntry.DataConfig:CheckSwitch("base_talent_switch")
								--if configOpenState then
								--	table.insert(buttonList,WorldTileBtnType.Talent)
								--end

								if DataCenter.TalentDataManager:IsSystemOpen() then
									table.insert(buttonList,WorldTileBtnType.Talent)
								end
								if DataCenter.DecorationDataManager:IsSystemOpen() then
									table.insert(buttonList, WorldTileBtnType.Decoration)
								end
								table.insert(buttonList, WorldTileBtnType.Furnace)
							--elseif buildId == BuildingTypes.FUN_BUILD_DRONE then
							--	local lv = LuaEntry.DataConfig:TryGetNum("center_building_unlock", "k2")
							--	if DataCenter.WorldTrendManager:CheckOpen() and DataCenter.BuildManager.MainLv >= lv then
							--		table.insert(buttonList,WorldTileBtnType.WorldTrend)
							--	end
							elseif buildId == BuildingTypes.FUN_BUILD_HERO_OFFICE then
								table.insert(buttonList,WorldTileBtnType.HeroOfficial)
							elseif buildId == BuildingTypes.FUN_BUILD_HERO_BAR then

							elseif buildId == BuildingTypes.DS_EQUIP_FACTORY then
								table.insert(buttonList,WorldTileBtnType.HeroEquip)
							end
							--if buildData.level > 0 then
							--	if buildId ~= BuildingTypes.FUN_BUILD_MAIN then
							--		if buildId == BuildingTypes.APS_BUILD_PUB then
							--			if self:CheckPubButtonOpen(WorldTileBtnType.City_Details) then
							--				table.insert(buttonList,WorldTileBtnType.City_Details)
							--			end
							--		else
							--			table.insert(buttonList,WorldTileBtnType.City_Details)
							--		end
							--	end
							--end
						
							if DataCenter.GarageRefitManager:GetGarageRefitData(buildId) then
								table.insert(buttonList,WorldTileBtnType.GarageRefit)
							end
							if DataCenter.DesertOperateManager:CanShowPanel(uuid) then
								table.insert(buttonList, WorldTileBtnType.DesertOperate)
							end
							table.sort(buttonList,function(a,b)
								local sortA = a + 100
								local sortB = b + 100
								if a == WorldTileBtnType.Talent then
									sortA = 2
								end
								if b == WorldTileBtnType.Talent then
									sortB = 2
								end
								if a == WorldTileBtnType.Decoration then
									sortA = 1
								end
								if b == WorldTileBtnType.Decoration then
									sortB = 1
								end
								-- 如果有英雄勋章商店 那么它应该排在按钮的第二位(第一位为City_Details, id为3)
								if a == WorldTileBtnType.HeroMedalShop then
									sortA = 104
								end
								if b == WorldTileBtnType.HeroMedalShop then
									sortB = 104
								end
								return sortA > sortB
							end)
							--有建筑加速时，加速排第二
							if isSpeedUp then
								if #buttonList == 1 then
									table.insert(buttonList,1,WorldTileBtnType.City_SpeedUp)
								elseif #buttonList == 0 then
									table.insert(buttonList,WorldTileBtnType.City_SpeedUp)
								else
									table.insert(buttonList,2,WorldTileBtnType.City_SpeedUp)
								end
							end
							
							--英雄驻扎
							if DataCenter.HeroStationManager:Enabled() and
							   DataCenter.HeroStationManager:GetStationIdByBuildId(buildId) ~= nil then
								table.insert(buttonList, WorldTileBtnType.Hero_Station)
							end
						end
					end
				end
			end
		else
			local Player = LuaEntry.Player
			if Player:IsInAlliance() and buildInfo.allianceId == Player.allianceId then
			else
				table.insert(buttonList,WorldTileBtnType.City_Rally)
				table.insert(buttonList,WorldTileBtnType.City_Attack)
			end
		end
	end
	return buttonList
end

local function GetBuildBtnEnumName(self,btnValue)
	for k,v in pairs(WorldTileBtnType) do
		if v == btnValue then
			return k
		end
	end
end

local function CheckPubButtonOpen(self, btnType)
	local k2 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k2")
	if string.IsNullOrEmpty(k2) then
		return true
	end
	local vec = string.split(k2, ";")
	local mainLv = DataCenter.BuildManager.MainLv

	local index = -1
	if btnType == WorldTileBtnType.Hero_Recruit then
		index = 1
	elseif btnType == WorldTileBtnType.Hero_Advance then
		index = 2
	elseif btnType == WorldTileBtnType.HeroResetShop then
		index = 3
	elseif btnType == WorldTileBtnType.City_Details then
		index = 4
	elseif btnType == WorldTileBtnType.Poster_Exchange then
		index = 5
	elseif btnType == WorldTileBtnType.HeroMedalShop then
		index = 6
	end
	if index < 0 or index > table.count(vec) then
		return true
	end
	return mainLv >= toInt(vec[index])
end

UIWorldTileUICtrl.CloseSelf = CloseSelf
UIWorldTileUICtrl.GetBuildBtn = GetBuildBtn
UIWorldTileUICtrl.GetBuildBtnEnumName = GetBuildBtnEnumName
UIWorldTileUICtrl.CheckPubButtonOpen = CheckPubButtonOpen
return UIWorldTileUICtrl