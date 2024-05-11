local UIWorldTileBuildBtn = BaseClass("UIWorldTileBuildBtn", UIBaseContainer)
local base = UIBaseContainer
local Sound = CS.GameEntry.Sound
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData =  {
	btnType,
	info,
	position,
}

local this_path = ""
local btn_image_path = "BtnImage"
local btnNameBg_rect_path = "BtnImage/Rect_BtnNameBg"
local btnName_txt_path = "BtnImage/Rect_BtnNameBg/Txt_BtnName"
-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.btn = self:AddComponent(UIButton, btn_image_path)
	self.btnImage = self:AddComponent(UIImage, btn_image_path)
	self.anim = self:AddComponent(UIAnimator, this_path)
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self.needChangeGray = false

	self._btnNameBg_rect = self:AddComponent(UIBaseContainer,btnNameBg_rect_path)
	self._btnName_txt = self:AddComponent(UITextMeshProUGUIEx,btnName_txt_path)
end

--控件的销毁
local function ComponentDestroy(self)
	if self.needChangeGray then
		CS.UIGray.SetGray(self.btnImage.transform,false,true)
	end
	self.btn = nil
	self.btnImage = nil
	self.anim = nil
end

--变量的定义
local function DataDefine(self)
	self.param = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	if self.param.btnType == WorldTileBtnType.City_Robot_Set then
		local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.param.info.uuid,false,false)
		if queue~=nil then
			local iconStr = GetTableData(TableName.Robot,queue.robotId,"icon1")
			self.btnImage:LoadSprite(string.format(LoadPath.UIBuildBtns,iconStr))
		else
			self.btnImage:LoadSprite(string.format(LoadPath.UIBuildBtns, WorldTileBtnTypeImage[param.btnType]))
		end
	else
		self.btnImage:LoadSprite(string.format(LoadPath.UIBuildBtns, WorldTileBtnTypeImage[param.btnType]))
	end
	
	self.btnImage:SetLocalPosition(param.position)
	self.needChangeGray = false
	if param.btnType ==WorldTileBtnType.WormHoleToC then
		if CrossServerUtil:CanShowCrossSubwayBuildBtn()==false then
			self.needChangeGray = true
		end
	end
	if self.needChangeGray then
		CS.UIGray.SetGray(self.btnImage.transform,true,true)
	end

	self:RefreshBtnName(param)
end

local function UpdateTime(self)
	--if self.param.inCD~=nil and self.param.inCD == true then
	--	local curTime = UITimeManager:GetInstance():GetServerTime()
	--	local deltaTime = self.param.endCDTime - curTime
	--	if deltaTime >0 then
	--		self.num:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
	--	else
	--		self.num:SetText("00:00:00")
	--	end
	--end
end

local function RefreshBtnName(self,param)
	local dialog = nil
	dialog = WorldTileBtnTypName[param.btnType]
	if dialog ~= nil and dialog ~= "" then
		self._btnNameBg_rect:SetActive(true)
		self._btnName_txt:SetLocalText(dialog)
	else
		self._btnNameBg_rect:SetActive(false)
	end
end

local function OnBtnClick(self)
	if self.param.btnType == WorldTileBtnType.City_MyProfile then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,self.param.info.ownerUid)
	elseif self.param.btnType == WorldTileBtnType.City_Upgrade then
		GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, {buildId = self.param.info.itemId})
	elseif self.param.btnType == WorldTileBtnType.City_SpeedUp then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true},ItemSpdMenu.ItemSpdMenu_City,self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.City_SpeedUpRuins then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true},ItemSpdMenu.ItemSpdMenu_Fix_Ruins,self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.City_Attack then
		
	elseif self.param.btnType == WorldTileBtnType.HeroOfficial then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroOfficial, {anim = true, UIMainAnim = UIMainAnimType.AllHide }, 1)
	elseif self.param.btnType == WorldTileBtnType.City_TrainingAircraft or self.param.btnType == WorldTileBtnType.City_TrainingTank
			or self.param.btnType == WorldTileBtnType.City_TrainingInfantry or self.param.btnType == WorldTileBtnType.City_TrainingTrap then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain,self.param.info.itemId)
	elseif self.param.btnType == WorldTileBtnType.City_Science then
		DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(self.param.info.uuid)
		GoToUtil.GotoScience(nil,nil,self.param.info.uuid)
		return
	elseif self.param.btnType == WorldTileBtnType.City_Recovery then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Repair)
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHospital)
	elseif self.param.btnType == WorldTileBtnType.BuildNitrogen then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildNitrogenDetail)
	elseif self.param.btnType == WorldTileBtnType.WormHole_Enter then
		local mainBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
		local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.info.itemId)
		if mainBuildData~=nil and buildData~=nil then
			local rangeList = BuildingUtils.GetBuildRoundPos(SceneUtils.IndexToTilePos(buildData.pointId,ForceChangeScene.World),2)
			local choosePoint = 0
			local secondChoosePoint = 0
			if rangeList ~= nil then
				for k,v in ipairs(rangeList) do
					if choosePoint<=0 then
						local pos = SceneUtils.TilePosToIndex(v, ForceChangeScene.World)
						if CS.SceneManager.World:IsTileWalkable(CS.SceneManager.World:IndexToTilePos(pos))==true then
							if secondChoosePoint<=0 then
								secondChoosePoint = pos
							end
							local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pos)
							if worldTileInfo ~= nil then
								local pointData = worldTileInfo:GetPointInfo()
								if pointData == nil then
									choosePoint = pos
								end

							end
						end
					end
				end
			end
			if choosePoint>0 then
				MarchUtil.OnClickStartMarch(MarchTargetType.STATE,choosePoint)
			elseif secondChoosePoint>0 then
				MarchUtil.OnClickStartMarch(MarchTargetType.STATE,secondChoosePoint)
			end
			
		end
	elseif self.param.btnType == WorldTileBtnType.WormHole_Create then
		--建筑虫洞
		--检查下是否已有部队正在前往修建虫洞
		local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
		local count = #selfMarch
		if count > 0 then
			for i = 1, count do
				local march = selfMarch[i]
				--正在修建
				if march:GetMarchStatus() == MarchStatus.BUILD_WORM_HOLE then
					if march.targetUuid == self.param.info.uuid then
						return 	UIUtil.ShowTipsId(121268)
					end
					
				end
				--已有部队正在前往
				if march:GetMarchTargetType() == MarchTargetType.BUILD_WORM_HOLE then
					if march.targetUuid == self.param.info.uuid then
						return 	UIUtil.ShowTipsId(121267)
					end
					
				end
			end
		end
		MarchUtil.OnClickStartMarch(MarchTargetType.BUILD_WORM_HOLE, self.param.info.mainIndex, self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.WormHole_Dismantle then
		local uuid = self.param.info.uuid
		UIUtil.ShowMessage(Localization:GetString("121046"),2,nil,nil,function ()SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew,{buildUuid = uuid})end,nil)
	elseif self.param.btnType == WorldTileBtnType.WormHoleToB then
		local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
		if #list > 0 then
			local buildData = list[1]
			local targetServerId = buildData.server
			local pointId = buildData.pointId
			if pointId>0 then
				local position = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
				position.x = position.x-1
				position.y = position.y
				position.z = position.z-1
				UIUtil.ShowMessage(Localization:GetString("121265",Localization:GetString("156012")),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
					GoToUtil.GotoWorldPos(position,nil,nil,function()
						WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
					end,targetServerId)
				end)
			end
		else
			UIUtil.ShowTips(Localization:GetString("140259"))
		end
	elseif self.param.btnType == WorldTileBtnType.WormHoleToC then
		if CrossServerUtil:CanShowCrossSubwayBuildBtn() then
			if DataCenter.CrossWormManager:IsNewWormTrain() then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UICrossWorm, 1)
			else
				GoToUtil.GotoCrossWorm()
			end
		else
			UIUtil.ShowTips(Localization:GetString("104274"))
		end
		
		
	elseif self.param.btnType == WorldTileBtnType.CrossWormHoleEnter then
		if CrossServerUtil:CanPlaceCrossSubway() then
			local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
			if crossBuildData~=nil then
				local targetServerId = crossBuildData.server
				--对比已有前往虫洞的部队
				--local selfMarch = CS.SceneManager.World:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
				--local goHoleNum = 0
				--if selfMarch.Count > 0 then
				--	for i = 0, selfMarch.Count - 1 do
				--		local march = selfMarch[i]
				--		if march:GetMarchTargetType() == MarchTargetType.GO_WORM_HOLE or march:GetMarchTargetType() == MarchTargetType.CROSS_SERVER_WORM then
				--			goHoleNum = goHoleNum + 1
				--		end
				--	end
				--end
				--if goHoleNum >= mainBuildData.level then
				--	UIUtil.ShowTipsId(129015)
				--	return
				--end
				MarchUtil.OnClickStartMarch(MarchTargetType.CROSS_SERVER_WORM,LuaEntry.Player:GetMainWorldPos(), crossBuildData.uuid,nil,nil,nil,targetServerId)
			else
				UIUtil.ShowTips(Localization:GetString("104273"))
			end
		else
			UIUtil.ShowTips(Localization:GetString("104274"))
		end
	elseif self.param.btnType == WorldTileBtnType.CrossWormHero then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UICrossWormHero, self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.City_Details then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
		if buildData.itemId == BuildingTypes.WORM_HOLE_CROSS and LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER and buildData.worldId == LuaEntry.Player:GetCurWorldId() then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIArmyInfo)
		elseif buildData.itemId == BuildingTypes.WORM_HOLE_CROSS and DataCenter.CrossWormManager:IsNewWormTrain() then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UICrossWorm, 1)
		else
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildInfo, NormalBlurPanelAnim, {buildId = buildData.itemId})
		end
	elseif self.param.btnType == WorldTileBtnType.PoliceStation then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPoliceStation)
	elseif self.param.btnType == WorldTileBtnType.SeasonBuildPickUp then
		local uuid = self.param.info.uuid
		UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.BUILD_PUCK_UP_CONFIRM_DES),2,nil,nil, function ()
			SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew,{buildUuid = uuid}) end,nil)
	elseif self.param.btnType == WorldTileBtnType.AssistanceSeasonBuild then
		local mainLv = DataCenter.BuildManager.MainLv
		local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
		if mainLv >= needMainLv then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance,NormalBlurPanelAnim,self.param.info.uuid,LuaEntry.Player.uid,self.param.info.pointIndex,AssistanceType.Build)
		else
			UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
		end
	elseif self.param.btnType == WorldTileBtnType.DesertOperate then
		local uuid = self.param.info.uuid
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertOperate, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, uuid)
	elseif self.param.btnType == WorldTileBtnType.City_PickUp then
		local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
		if tempBuild ~= nil  then
			local resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(tempBuild.itemId)
			if resourceType ~= ResourceType.None then
				if tempBuild.state == BuildingStateType.Normal then
					local num = DataCenter.BuildManager:GetOutResourceNum(self.param.info.uuid)
					if num > 0 then
						local worldPos = SceneUtils.TileIndexToWorld(tempBuild.pointId)
						local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
						--DataCenter.FlyResourceEffectManager:ShowGetResourceEffect(pos,resourceType,FlyMoneyCount)
						DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos + FlyGetResourceDelta,DataCenter.ResourceManager:GetResourceIconByType(resourceType),num,self.param.info.uuid)
					end
				end
				SFSNetwork.SendMessage(MsgDefines.UserResSynNew,{resourceType = resourceType})
			end
			if DataCenter.BuildManager:IsCanOutItemByBuildId(tempBuild.itemId) then
				if tempBuild.state == BuildingStateType.Normal and DataCenter.BuildManager:IsHaveItem(self.param.info.uuid) then
					SFSNetwork.SendMessage(MsgDefines.ReceiveBuildingGrowValReward,{uuid = self.param.info.uuid})
				end
			end
		end
		SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew,{buildUuid = self.param.info.uuid})
	elseif self.param.btnType == WorldTileBtnType.City_ColdCapacity then
		if self.param.info.itemId == BuildingTypes.FUN_BUILD_COLD_STORAGE then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTableNew,UICapacityTableTab.Farming)
		else
			UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTableNew)
		end
	elseif self.param.btnType == WorldTileBtnType.City_IntegratedWarehouse then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTableNew,UICapacityTableTab.Farming)
	elseif self.param.btnType == WorldTileBtnType.City_ResourceTransport then
		--打开运输资源页面
		UIManager:GetInstance():OpenWindow(UIWindowNames.UITransportRes,self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.Hero_Advance then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance, {anim = false,UIMainAnim = UIMainAnimType.AllHide})
	--elseif self.param.btnType == WorldTileBtnType.Hero_Bag then
	--	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag, {anim = false,UIMainAnim = UIMainAnimType.AllHide})
	elseif self.param.btnType == WorldTileBtnType.GolloesCamp then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesCamp, {anim = true})
	elseif self.param.btnType == WorldTileBtnType.Poster_Exchange then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPosterExchangeMain, {anim = false,UIMainAnim = UIMainAnimType.AllHide})
	elseif self.param.btnType == WorldTileBtnType.Hero_Recruit then
		local arrow = nil
		local isTen = nil
		if self.view.worldTileBtnType then
			if self.view.questTemplate then
				arrow = tonumber(self.view.questTemplate.para3)
				if self.view.questTemplate.gopara[3] then
					isTen = tonumber(self.view.questTemplate.gopara[3])
				end
			end
		end
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit,nil,arrow,isTen)
	elseif self.param.btnType == WorldTileBtnType.City_SpeedUpTrain then
		local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.param.info.itemId))
		if queue ~= nil then
			local state = queue:GetQueueState()
			if state == NewQueueState.Work then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true},ItemSpdMenu.ItemSpdMenu_Soldier,queue.uuid)
			end
		end
	elseif self.param.btnType == WorldTileBtnType.City_SpeedUpScience then
		local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.param.info.uuid)
		if queue ~= nil then
			local state = queue:GetQueueState()
			if state == NewQueueState.Work then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true},ItemSpdMenu.ItemSpdMenu_Science,queue.uuid)
			end
		end
	elseif self.param.btnType == WorldTileBtnType.City_SpeedUpHospital then
		local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
		if queue ~= nil then
			local state = queue:GetQueueState()
			if state == NewQueueState.Work then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true},ItemSpdMenu.ItemSpdMenu_Heal,queue.uuid)
			end
		end
	elseif self.param.btnType == WorldTileBtnType.City_IntegratedWarehouse then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTableNew,UICapacityTableTab.Farming)

	elseif self.param.btnType == WorldTileBtnType.City_Defence then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDefenceTable)
	elseif self.param.btnType == WorldTileBtnType.City_BatteryrAttack then
		--local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
		--CS.SceneManager.World.AttackRangeEffect:SetActive(true)
	elseif self.param.btnType == WorldTileBtnType.City_Assistance then
		local selfUid = LuaEntry.Player.uid
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance,NormalBlurPanelAnim,self.param.info.uuid,selfUid,self.param.info.mainIndex,AssistanceType.Build)
	elseif self.param.btnType == WorldTileBtnType.RadarCenter_Alert then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
	elseif self.param.btnType == WorldTileBtnType.RadarCenter_Detective then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
	elseif self.param.btnType == WorldTileBtnType.City_Repair then
		local uuid = self.param.info.uuid
		SFSNetwork.SendMessage(MsgDefines.UserStartFixBuilding,uuid)
	elseif self.param.btnType == WorldTileBtnType.AllianceEntrance then
		if LuaEntry.Player:IsInAlliance() ==false then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
		else
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable)
		end
	elseif self.param.btnType == WorldTileBtnType.AllianceResSupport then
		if not LuaEntry.Player:IsInAlliance() then
			UIUtil.ShowTipsId(390838)
			return
		end
		local data =  DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail,{ anim = true },data.uid, AllianceMemberOpenType.ResSupport)
	elseif self.param.btnType == WorldTileBtnType.AllianceBattle then
		if not LuaEntry.Player:IsInAlliance() then
			UIUtil.ShowTipsId(GameDialogDefine.NO_JOIN_ALLIANCE)
			GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
			return
		end
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceWarMainTable,2)
	elseif self.param.btnType == WorldTileBtnType.City_Robot_Set then
		local bUuid = self.param.info.uuid
		local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(bUuid,false,false)
		if queue~=nil then
			SFSNetwork.SendMessage(MsgDefines.UserRobotDismiss,queue.uuid)
		end
	elseif self.param.btnType == WorldTileBtnType.ARMY then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIArmyInfo)
	elseif self.param.btnType == WorldTileBtnType.WorldNews then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBattleNews)
		--GoToUtil.GotoOpenView(UIWindowNames.UIWorldBattleNews)
	elseif self.param.btnType == WorldTileBtnType.Hero_Station then
		UIUtil.OpenHeroStationByBuildUuid(self.param.info.uuid)
	elseif self.param.btnType == WorldTileBtnType.CommonShop then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
	elseif self.param.btnType == WorldTileBtnType.GarageRefit then
		local needMainLv = DataCenter.GarageRefitManager.needMainLv
		if DataCenter.BuildManager.MainLv >= needMainLv then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIGarageRefit, self.param.info.itemId)
		else
			UIUtil.ShowTips(Localization:GetString("140339", needMainLv))
		end
	elseif self.param.btnType == WorldTileBtnType.GarageEquipment then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipmentMain, {anim = true, UIMainAnim = UIMainAnimType.AllHide}, self.param.info.itemId)
	elseif self.param.btnType == WorldTileBtnType.DefenceSuitEquipment then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipmentMain, {anim = true, UIMainAnim = UIMainAnimType.AllHide}, self.param.info.itemId)
	elseif self.param.btnType == WorldTileBtnType.DefenceSuitEquipmentCross then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipmentMain, {anim = true, UIMainAnim = UIMainAnimType.AllHide}, self.param.info.itemId)
	elseif self.param.btnType == WorldTileBtnType.EquipmentBag then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Open_Equipment_Factory)
		UIManager:GetInstance():OpenWindow(UIWindowNames.EquipmentBag)
	elseif self.param.btnType == WorldTileBtnType.Talent then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentInfo, {anim = true, UIMainAnim = UIMainAnimType.AllHide}, DataCenter.TalentDataManager.specialShowTalentId)
	elseif self.param.btnType == WorldTileBtnType.HeroResetShop then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop)
	elseif self.param.btnType == WorldTileBtnType.Decoration then
		DecorationUtil.OpenDecorationPanel()
		return
	elseif self.param.btnType == WorldTileBtnType.HeroMedalShop then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMedalShop, {anim = true, UIMainAnim = UIMainAnimType.AllHide })
	elseif self.param.btnType == WorldTileBtnType.HeroMetalRedemption then
		local param = {}
		param.enterType = 
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMetalRedemption, {anim = true}, param)
	elseif self.param.btnType == WorldTileBtnType.Furnace then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIVitaFurnace)
	elseif self.param.btnType == WorldTileBtnType.HeroEquip then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquip)
	end
		self.view.ctrl:CloseSelf(true)
end

local function PlayAnim(self,name)
	self.anim:Play(name,0,0)
end

local function GetPosition(self)
	return self.btn.transform.position
end


UIWorldTileBuildBtn.OnCreate = OnCreate
UIWorldTileBuildBtn.OnDestroy = OnDestroy
UIWorldTileBuildBtn.Param = Param
UIWorldTileBuildBtn.OnEnable = OnEnable
UIWorldTileBuildBtn.OnDisable = OnDisable
UIWorldTileBuildBtn.ComponentDefine = ComponentDefine
UIWorldTileBuildBtn.ComponentDestroy = ComponentDestroy
UIWorldTileBuildBtn.DataDefine = DataDefine
UIWorldTileBuildBtn.DataDestroy = DataDestroy
UIWorldTileBuildBtn.ReInit = ReInit
UIWorldTileBuildBtn.OnBtnClick = OnBtnClick
UIWorldTileBuildBtn.PlayAnim = PlayAnim
UIWorldTileBuildBtn.RefreshBtnName = RefreshBtnName
UIWorldTileBuildBtn.UpdateTime =UpdateTime
UIWorldTileBuildBtn.GetPosition =GetPosition
return UIWorldTileBuildBtn