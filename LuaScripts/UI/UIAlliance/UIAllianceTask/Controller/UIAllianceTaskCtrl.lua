local UIAllianceTaskCtrl = BaseClass("UIAllianceTaskCtrl", UIBaseCtrl)

local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceTask)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function JumpTo(self, jump)
	if jump == 2 then--沙虫暴君
		GoToUtil.GoAttackMonster()
	elseif jump == 4 then--联盟科技
		local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
		if not unlock then
			UIUtil.ShowTipsId(390994)
			return
		end
		self:Close()
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience,{ anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide})
	elseif jump == 5 then--联盟帮助
		self:Close()
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceHelp,{ anim = true})
	elseif jump == 7 then
		self:Close()
		GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER, WorldTileBtnType.RadarCenter_Detective)
	end
end

local function GoEdenWar(self)
	--服务器解锁等级
	local unlockLvList = DataCenter.WorldAllianceCityDataManager.trendsUnLockLv
	local unlockLv = 1
	if next(unlockLvList) then
		for i = 1, #unlockLvList do
			if unlockLvList[i].unLockTime <= UITimeManager:GetInstance():GetServerTime() then
				unlockLv = unlockLvList[i].cityLv
			end
		end
	else
		unlockLv = 0
	end

	--配置范围
	local k1 = LuaEntry.DataConfig:TryGetNum("search_ruins", "k1")
	--获取所有遗迹点
	local template = DataCenter.AllianceCityTemplateManager:GetAllTemplate()
	--自己盟是否有遗迹
	local hasAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity()
	if hasAlTerritory then
		--如果已有遗迹
		local myAlId = LuaEntry.Player.allianceId
		local myCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
		local lv = 1
		if myCities then
			for i = 1, #myCities do
				local config =  DataCenter.AllianceCityTemplateManager:GetTemplate(myCities[i])
				if config.level > lv then
					lv = config.level
				end
			end
		end
		local maxLv = DataCenter.AllianceCityTemplateManager:GetTemplateMaxLv()
		if lv < maxLv then
			lv = lv + 1
		end
		if unlockLv ~= 0 then
			if lv < unlockLv then
				unlockLv = lv
			end
		else
			unlockLv = lv
		end
	else
		unlockLv = 1
	end
	local buildList = {}
	for i, v in pairs(template) do
		if v.eden_city_type == WorldCityType.AllianceCity and v.server_type == ServerType.NORMAL then
			local distance = math.ceil(SceneUtils.TileDistance(v.pos, DataCenter.BuildManager.main_city_pos))
			if distance <= k1 then
				local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(tonumber(i))
				if cityData == nil then
					--当自己盟没有联盟城时只找1级遗迹
					if hasAlTerritory == nil then
						if v.level == 1 then
							local param = {}
							param.distance = distance
							param.pos = v.pos
							param.id = i
							table.insert(buildList,param)
							if #buildList >= 4 then
								break
							end
						end
					else
						if v.level == unlockLv then
							local param = {}
							param.distance = distance
							param.pos = v.pos
							param.id = i
							table.insert(buildList,param)
							if #buildList >= 4 then
								break
							end
						end
					end
				end
			end
		end
		
	end
	if next(buildList) then
		table.sort(buildList, function(a,b)
			if a.distance < b.distance then
				return true
			end
			return false
		end)
		GoToUtil.CloseAllWindows()
		local cityId = buildList[1].id
		local tile = GetTableData(TableName.WorldCity,cityId, "size")
		local pointIndex = SceneUtils.TilePosToIndex(buildList[1].pos)
		local worldPos = SceneUtils.TileIndexToWorld(pointIndex)
		worldPos.x = worldPos.x - tile+1
		worldPos.z = worldPos.z - tile+1
		pointIndex = SceneUtils.WorldToTileIndex(worldPos)
		GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime, function()
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldSiegePoint,buildList[1].id,pointIndex)
		end)
	else
		UIUtil.ShowTips(Localization:GetString("372182",unlockLv))
	end
end

local function ShareTask(self, taskConf, taskInfo)
	local share_param = {}
	share_param.post = PostType.Text_AllianceTaskShare
	share_param.taskId = taskConf.id
	share_param.taskName = taskConf.name
	share_param.curProg = taskInfo.curProg
	share_param.maxProg = taskConf.param
	share_param.postType = PostType.Text_AllianceTaskShare
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

UIAllianceTaskCtrl.CloseSelf = CloseSelf
UIAllianceTaskCtrl.Close = Close
UIAllianceTaskCtrl.JumpTo = JumpTo
UIAllianceTaskCtrl.ShareTask = ShareTask
UIAllianceTaskCtrl.GoEdenWar = GoEdenWar

return UIAllianceTaskCtrl