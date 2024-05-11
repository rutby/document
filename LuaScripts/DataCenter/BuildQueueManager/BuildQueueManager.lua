--建造队列管理器
local BuildQueueManager = BaseClass("BuildQueueManager")
local BuildRobotData = require "DataCenter.BuildQueueManager.BuildRobotData"

function BuildQueueManager:__init()
	self:AddListener()
	self.timer = nil
	self.timer_action = function(temp)
		self:CheckAllQueueTimeFinish()
		self:CheckWorldBuildQueueTimeFinish()
		self:CheckAllFixQueueTimeFinish()
		self:CheckAllNoQueueTimeFinish()
	end
	self:DataReset()
end

function BuildQueueManager:__delete()
	self:RemoveListener()
	self:DeleteTimer()
	
	self.queueList = {}
	self.worldBuildCheckDic = {}
	self.fixQueueList = {}
	self.timeFinishFlag = {}--队列完成发送信号标志（防止多次发送）
	self.worldBuildTimeFinishFlag = {}
	self.heroFreeTimeDict = {}
	self.worldHeroFreeTimeDict = {}
	self.fixTimeFinishFlag = {}
	self.buildNoQueueList = {}--针对不需要建筑队列但是有升级时间的建筑
	self.buildNoQueueTimeFinishFlag = {}--针对不需要建筑队列但是有升级时间的建筑
end

function BuildQueueManager:DataReset()
	self:DeleteTimer()
	self.queueList = {}
	self.worldBuildCheckDic = {}
	self.fixQueueList = {}
	self.timeFinishFlag = {}--队列完成发送信号标志（防止多次发送）
	self.worldBuildTimeFinishFlag = {}
	self.heroFreeTimeDict = {}
	self.worldHeroFreeTimeDict = {}
	self.fixTimeFinishFlag = {}
	self.buildNoQueueList = {}--针对不需要建筑队列但是有升级时间的建筑
	self.buildNoQueueTimeFinishFlag = {}--针对不需要建筑队列但是有升级时间的建筑
	self:AddTimer()
end

function BuildQueueManager:Startup()
end

function BuildQueueManager:AddListener()
	if self.buildUpgradeStartSignal == nil then
		self.buildUpgradeStartSignal = function(param)
			self:BuildUpgradeStartSignal(param)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart , self.buildUpgradeStartSignal)--建筑开始升级
	end
	if self.buildInitEndSignal == nil then
		self.buildInitEndSignal = function()
			self:BuildInitEndSignal()
		end
		EventManager:GetInstance():AddListener(EventId.LUA_BUILD_INIT_END , self.buildInitEndSignal)--建筑开始升级
	end
	if self.onBuildUpgradeFinishSignal == nil then
		self.onBuildUpgradeFinishSignal = function(data)
			self:OnBuildUpgradeFinishSignal(data)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish , self.onBuildUpgradeFinishSignal)
	end
	if self.onBuildUpdateSignal == nil then
		self.onBuildUpdateSignal = function(data)
			self:OnBuildUpdateSignal(data)
		end
		EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA , self.onBuildUpdateSignal)
	end
	if self.buildFixStartSignal == nil then
		self.buildFixStartSignal = function(data)
			self:BuildFixStartSignal(data)
		end
		EventManager:GetInstance():AddListener(EventId.BuildFixStart , self.buildFixStartSignal)
	end
	if self.buildFixFinishSignal == nil then
		self.buildFixFinishSignal = function(data)
			self:BuildFixFinishSignal(data)
		end
		EventManager:GetInstance():AddListener(EventId.BuildFixFinish , self.buildFixFinishSignal)
	end
	if self.addBuildSpeedSuccessSignal == nil then
		self.addBuildSpeedSuccessSignal = function(data)
			self:AddBuildSpeedSuccessSignal(data)
		end
		EventManager:GetInstance():AddListener(EventId.AddBuildSpeedSuccess , self.addBuildSpeedSuccessSignal)
	end
end

function BuildQueueManager:RemoveListener()
	if self.buildUpgradeStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)--建筑开始升级
		self.buildUpgradeStartSignal = nil
	end
	if self.buildInitEndSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.LUA_BUILD_INIT_END, self.buildInitEndSignal)--建筑开始升级
		self.buildInitEndSignal = nil
	end
	if self.onBuildUpgradeFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.onBuildUpgradeFinishSignal)
		self.onBuildUpgradeFinishSignal = nil
	end
	if self.onBuildUpdateSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.onBuildUpdateSignal)
		self.onBuildUpdateSignal = nil
	end
	if self.buildFixStartSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildFixStart, self.buildFixStartSignal)
		self.buildFixStartSignal = nil
	end
	if self.buildFixFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildFixFinish, self.buildFixFinishSignal)
		self.buildFixFinishSignal = nil
	end
	if self.addBuildSpeedSuccessSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.AddBuildSpeedSuccess, self.addBuildSpeedSuccessSignal)
		self.addBuildSpeedSuccessSignal = nil
	end
end

function BuildQueueManager:BuildFixStartSignal(uuid)
	if uuid ~= 0 then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if buildData ~= nil and buildData.destroyEndTime>0 then
			DataCenter.BuildQueueManager:AddFixQueue(uuid)
		end
	end
end

function BuildQueueManager:BuildFixFinishSignal(uuid)
	if uuid ~= 0 then
		DataCenter.BuildQueueManager:RemoveFixQueue(uuid)
	end
end

function BuildQueueManager:AddFixQueue(uuid)
	self.fixQueueList[uuid] = true
end
function BuildQueueManager:RemoveFixQueue(uuid)
	self.fixQueueList[uuid] = nil
	self.fixTimeFinishFlag[uuid] =nil
end

function BuildQueueManager:CheckAllFixQueueTimeFinish()
	local removeList = {}
	for k,v in pairs(self.fixQueueList) do
		if self.fixTimeFinishFlag[k] == nil then
			if self:IsFixQueueTimeFinish(k) then
				removeList[k] = true
				self.fixTimeFinishFlag[k] = true
				EventManager:GetInstance():Broadcast(EventId.Build_Fix_Time_End,k)
			end
		else
			removeList[k]= true
		end
	end
	for k, v in pairs(removeList) do
		self:RemoveFixQueue(k)
	end
end

function BuildQueueManager:OnBuildUpgradeFinishSignal(uuid)
	if uuid ~= 0 then
		self:RemoveBuildUpgradeNoQueue(uuid)
		local queue = self:GetQueueDataByBuildUuid(uuid,true,false)
		if queue~=nil then
			self:ResetQueue(queue.uuid)
		end
	end
end

--初始化队列信息
function BuildQueueManager:InitQueueList(message)
	if message["user_robots"]~=nil then
		self:DataReset()
		table.walk(message["user_robots"],function (k,v)
			self:UpdateQueueData(v,true)
		end)
	end
end

function BuildQueueManager:UpdateRobotEffect(message)
	local robotUuid = message["robotUuid"]
	if self.queueList[robotUuid]~=nil then
		if message["effect"]~=nil then
			self.queueList[robotUuid]:HandleEffect(message["effect"])
		end
		
	end
end

function BuildQueueManager:UpdateQueueData(message)
	if message ==nil then
		return
	end
	if message["uuid"]==nil then
		return
	end
	local uuid = message["uuid"]
	if self.queueList[uuid]==nil then
		local queue = BuildRobotData.New()
		self.queueList[uuid] = queue
	end
	self.queueList[uuid]:ParseData(message)
	EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
end


function BuildQueueManager:ResetQueue(uuid)
	if self.queueList[uuid]~=nil then
		self.queueList[uuid]:ResetQueue()
		self.timeFinishFlag[uuid] = nil
		self.heroFreeTimeDict[uuid] = nil
	end
end

function BuildQueueManager:GetQueueByUuid(uuid)
	return self.queueList[uuid]
end
function BuildQueueManager:GetQueueDataByBuildUuid(bUuid,isBuild,isScience)
	for k,v in pairs(self.queueList) do
		if isBuild then
			if v.occupyUuid == bUuid and v.state == RobotState.BUILD then
				return v
			end
		else
			if v.occupyUuid == bUuid and v.state ~= RobotState.BUILD then
				return v
			end
		end
		
	end
end

--是否能升级 (判断队列是否满足)
function BuildQueueManager:IsCanUpgrade(buildId,level)
	local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
	if levelTemplate ~= nil and (levelTemplate.no_queue == BuildNoQueue.Yes or (levelTemplate.scan ~= BuildScanAnim.Play and levelTemplate:GetBuildTime() == 0)) then
		return true
	end
	local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	return self:GetFreeQueue(template:IsSeasonBuild()) ~= nil
end

--获取队列正在升级的建筑
function BuildQueueManager:GetAllQueueUuid()
	for k,v in pairs(self.queueList) do
		if v.occupyUuid ~= 0 then
			return v.occupyUuid
		end
	end
	return nil
end

function BuildQueueManager:GetQueueValueList()
	if self.queueList~=nil then
		return table.values(self.queueList)
	end
	return nil
end
-- 有赛季队列空闲
function BuildQueueManager:HasFreeSeasonQueue()
	for _, v in pairs(self.queueList) do
		if v:CanUse() and DataCenter.BuildQueueTemplateManager:IsSeasonRobot(v.robotId) then
			return true
		end
	end
	return false
end

function BuildQueueManager:OnBuildUpdateSignal(uuid)
	if uuid ~= 0 then
		self:CheckAllQueueTimeFinish()
		self:CheckAllFixQueueTimeFinish()
		self:CheckAllNoQueueTimeFinish()
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if buildData ~= nil then
			local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
			local noQueue = template ~= nil and template.no_queue == BuildNoQueue.Yes
			if buildData.updateTime > 0 then
				if noQueue then
					self:AddBuildUpgradeNoQueue(uuid)
				else
				end
			else
				if noQueue then
					self:RemoveBuildUpgradeNoQueue(uuid)
				else
					local queue = self:GetQueueDataByBuildUuid(uuid,true,false)
					if queue ~= nil then
						self:ResetQueue(queue.uuid)
					end
				end
			end
		end
	end
end

function BuildQueueManager:DeleteTimer()
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

function BuildQueueManager:AddTimer()
	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
	end

	self.timer:Start()
end

--检测完成的队列
function BuildQueueManager:CheckAllQueueTimeFinish()
	for k,v in pairs(self.queueList) do
		if self.timeFinishFlag[k] == nil then
			if self:IsQueueTimeFinish(v) then
				self.timeFinishFlag[k] = true
				EventManager:GetInstance():Broadcast(EventId.Build_Time_End,v.occupyUuid)
				local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.occupyUuid)
				if buildData ~= nil and buildData:IsNeedShowBox() then
					EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildModel,buildData.pointId)
				else
					DataCenter.BuildManager:CheckSendBuildFinish(v.occupyUuid)
				end
			elseif v.occupyUuid ~= 0 and v.state == RobotState.BUILD then
				if self.heroFreeTimeDict[k] == nil or not self.heroFreeTimeDict[k][2] then
					local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.occupyUuid)
					if buildData ~= nil  then
						if buildData.level > 0 then
							local freeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)	--英雄是否存在拥有加速技能
							local effectTime = BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId)
							if freeTime or effectTime > 0 then
								local curTime = UITimeManager:GetInstance():GetServerTime()
								if buildData.updateTime > 0 and buildData.updateTime ~= LongMaxValue and buildData.updateTime - curTime <= effectTime*1000 then
									self.heroFreeTimeDict[k] = {}
									self.heroFreeTimeDict[k][1] = v.occupyUuid
									self.heroFreeTimeDict[k][2] = false
									self.heroFreeTimeDict[k][3] = RobotState.BUILD
									self.heroFreeTimeDict[k][4] = k
									self.heroFreeTimeDict[k][5] = v.robotId
									EventManager:GetInstance():Broadcast(EventId.QueueHeroFreeTime,{uuid = v.occupyUuid,type = 1})
								end
							end
						end
					end
				end
			end
		end
	end
end

function BuildQueueManager:IsQueueTimeFinish(data)
	if data.occupyUuid ~= 0 and data.state == RobotState.BUILD then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(data.occupyUuid)
		if buildData ~= nil then
			if buildData:IsUpgradeFinish() then
				return true
			end
		else
			local curTime = UITimeManager:GetInstance():GetServerTime()
			if data.endTime < curTime then
				return true
			end
		end
	end
	return false
end
function BuildQueueManager:IsFixQueueTimeFinish(bUuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData:IsFixFinish() then
		return true
	end
	return false
end
--防止气泡做两次动画
function BuildQueueManager:SetTimeFinishFlag(bUuid)
	self.timeFinishFlag[bUuid] = true
	if self.heroFreeTimeDict[bUuid] then
		self.heroFreeTimeDict[bUuid] = nil
	end
end

function BuildQueueManager:SetFixFinishFlag(bUuid)
	self.fixTimeFinishFlag[bUuid] = true
end

function BuildQueueManager:SetCanUseHeroFreeTime(uuid)
	for i, v in pairs(self.heroFreeTimeDict) do
		if v[1] == uuid then
			v[2] = true
		end
	end
end
function BuildQueueManager:GetCanUseHeroFreeTime(uuid)
	for i, v in pairs(self.heroFreeTimeDict) do
		if v[1] == uuid then
			return v
		end
	end
	return nil
end

function BuildQueueManager:RefreshWorldBuildQueueList(worldBuildData)
	local buildTemplate= DataCenter.BuildTemplateManager:GetBuildingDesTemplate(worldBuildData.itemId)
	if buildTemplate~=nil and buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
		local uuid = worldBuildData.uuid
		if worldBuildData.updateTime>0 then
			self.worldBuildCheckDic[uuid] = 1
		else
			self.worldBuildCheckDic[uuid] = nil
			self.worldBuildTimeFinishFlag[uuid] = nil
			self.worldHeroFreeTimeDict[uuid] = nil
		end
	end
end

function BuildQueueManager:RemoveFromWorldBuildQueueList(bUuid)
	self.worldBuildCheckDic[bUuid] = nil
	self.worldBuildTimeFinishFlag[bUuid] = nil
	self.worldHeroFreeTimeDict[bUuid] = nil
end

function BuildQueueManager:CheckWorldBuildQueueTimeFinish()
	for k,v in pairs(self.worldBuildCheckDic) do
		if self.worldBuildTimeFinishFlag[k] == nil then
			local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
			if buildData ~= nil then
				if buildData:IsUpgradeFinish() then
					self.worldBuildTimeFinishFlag[k] = true
					EventManager:GetInstance():Broadcast(EventId.Build_Time_End, k)
					if buildData:IsNeedShowBox() then
						EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildModel,buildData.pointId)
					else
						DataCenter.BuildManager:CheckSendBuildFinish(k)
					end
				elseif self.worldHeroFreeTimeDict[k] == nil then
					if buildData.level > 0 then
						local freeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)	--英雄是否存在拥有加速技能
						local effectTime = BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId)
						if freeTime or effectTime > 0 then
							local curTime = UITimeManager:GetInstance():GetServerTime()
							if buildData.updateTime > 0 and buildData.updateTime ~= LongMaxValue and buildData.updateTime - curTime <= effectTime*1000 then
								local queue = self:GetQueueDataByBuildUuid(k, true, false)
								if queue ~= nil then
									local param = {}
									param.robotId = queue.robotId
									param.queueUuid = queue.uuid
									param.index = queue.index
									self.worldHeroFreeTimeDict[k] = param
									EventManager:GetInstance():Broadcast(EventId.WorldBuildQueueHeroFreeTime, k)
								end
							end
						end
					end
				end
			end
			
		end
	end
	
end

function BuildQueueManager:GetCanUseWorldHeroFreeTime(uuid)
	return self.worldHeroFreeTimeDict[uuid]
end

function BuildQueueManager:AddBuildUpgradeNoQueue(uuid)
	self.buildNoQueueList[uuid] = true
end

function BuildQueueManager:RemoveBuildUpgradeNoQueue(uuid)
	self.buildNoQueueList[uuid] = nil
	self.buildNoQueueTimeFinishFlag[uuid] = nil
end

function BuildQueueManager:CheckAllNoQueueTimeFinish()
	local removeList = {}
	for k,v in pairs(self.buildNoQueueList) do
		if self.buildNoQueueTimeFinishFlag[k] == nil then
			if self:IsNoQueueTimeFinish(k) then
				removeList[k] = true
				self.buildNoQueueTimeFinishFlag[k] = true
				
				EventManager:GetInstance():Broadcast(EventId.Build_Time_End, k)
				local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
				if buildData ~= nil and buildData:IsNeedShowBox() then
					EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildModel,buildData.pointId)
				else
					DataCenter.BuildManager:CheckSendBuildFinish(k)
				end
				
			end
		else
			removeList[k]= true
		end
	end
	for k, v in pairs(removeList) do
		self:RemoveBuildUpgradeNoQueue(k)
	end
end

function BuildQueueManager:IsNoQueueTimeFinish(bUuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil and buildData:IsUpgradeFinish() then
		return true
	end
	return false
end

function BuildQueueManager:BuildUpgradeStartSignal(uuid)
	if uuid ~= 0 then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
		if buildData ~= nil and buildData.updateTime > 0 then
			self:AddBuildUpgradeNoQueue(uuid)
		end
	end
end

--登录后建筑初始化完成检测数据
function BuildQueueManager:BuildInitEndSignal()
	local list = DataCenter.BuildManager:GetAllBuildUuid()
	for k,v in ipairs(list) do
		self:OnBuildUpdateSignal(v)
	end
end

function BuildQueueManager:UnlockBuildingQueueHandle(message)
	local errCode = message["errorCode"]
	if errCode == nil then
		if message["robot"] ~= nil then
			self:UpdateQueueData(message["robot"])
		end
		if message["remainGold"] ~= nil then
			LuaEntry.Player.gold = message["remainGold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		UIUtil.ShowTipsId(GameDialogDefine.BUILD_QUEUE_ADD_SUCCESS)
	else
		if errCode ~= SeverErrorCode then
			UIUtil.ShowTipsId(errCode)
		end
	end
end

--获取我拥有的建造队列
function BuildQueueManager:GetOwnBuildQueueList()
	local result = {}
	local curTime = UITimeManager:GetInstance():GetServerTime()
	for k,v in pairs(self.queueList) do
		if v.expireTime == 0 or v.expireTime > curTime then
			table.insert(result, v)
		end
	end
	return result
end

--获取我拥有的建造队列数量
function BuildQueueManager:GetOwnBuildQueueCount()
	return #self:GetOwnBuildQueueList()
end

--获取空闲的队列
function BuildQueueManager:GetFreeQueue(isSeason)
	if isSeason then
		-- 优先使用世界机器人
		for _, v in pairs(self.queueList) do
			if v:CanUse() and DataCenter.BuildQueueTemplateManager:IsSeasonRobot(v.robotId) then
				return v
			end
		end
	end
	for _, v in pairs(self.queueList) do
		if v:CanUse() and not DataCenter.BuildQueueTemplateManager:IsSeasonRobot(v.robotId) then
			return v
		end
	end
	return nil
end

function BuildQueueManager:UserNewbieRobotUnlockHandle(message)
	local errCode = message["errorCode"]
	if errCode == nil then
		DataCenter.GuideManager:SendSaveGuideMessage(FreeLeaseSecondBuildQueue, SaveGuideDoneValue)
		self:UpdateQueueData(message)
		UIUtil.ShowTipsId(GameDialogDefine.BUILD_QUEUE_ADD_SUCCESS)
	else
		if errCode ~= SeverErrorCode then
			UIUtil.ShowTipsId(errCode)
		end
	end
end

function BuildQueueManager:PushBuildUnlockAddHandle(message)
	if message["robot"] ~= nil then
		self:UpdateQueueData(message["robot"])
	end
end

function BuildQueueManager:AddBuildSpeedSuccessSignal(uuid)
	self:OnBuildUpdateSignal(uuid)
end

return BuildQueueManager