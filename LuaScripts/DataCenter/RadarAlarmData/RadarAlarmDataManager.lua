--- Created by shimin.
--- DateTime: 2023/8/10 14:58
--- 警报管理器(集结不在)
local RadarAlarmDataManager = BaseClass("RadarAlarmDataManager")

function RadarAlarmDataManager:__init()
	self.alarm = {}--所有警报<marchUuid, marchInfo>
	self.cancel = {}--忽略的警报
	self:AddListener()
end

function RadarAlarmDataManager:__delete()
	self.alarm = {}--所有警报<marchUuid, marchInfo>
	self.cancel = {}--忽略的警报
	self:RemoveListener()
end

function RadarAlarmDataManager:AddListener()
end

function RadarAlarmDataManager:RemoveListener()
end

--获取个人所有警报
function RadarAlarmDataManager:GetAllMarches()
	local result = {}
	local mySeverId = LuaEntry.Player:GetCurServerId()
	for k, v in pairs(self.alarm) do
		table.insert(result, v)
	end

	--检查下跨服
	local cross = DataCenter.AllianceAlertDataManager:GetSelfCrossAlert()
	if cross ~= nil then
		for k, v in pairs(cross) do
			if v.server ~= mySeverId then
				table.insert(result, v)
				break
			end
		end
	end
	return result
end

--是否是忽略的警报
function RadarAlarmDataManager:IsCancel(marchUuid)
	return self.cancel[marchUuid] ~= nil
end
--添加忽略警报
function RadarAlarmDataManager:AddToCancelList(marchUuid)
	self.cancel[marchUuid] = true
end
--移除忽略警报
function RadarAlarmDataManager:RemoveToCancelList(marchUuid)
	self.cancel[marchUuid] = nil
end

--初始化警报
function RadarAlarmDataManager:InitData(allData)
	self.alarm = {}
	if allData ~= nil then
		for k, v in pairs(allData) do
			self:AddOneAlarm(v)
		end
	end
	EventManager:GetInstance():Broadcast(EventId.RefreshAlarm)
end

--更新个警报
function RadarAlarmDataManager:UpdateAlarm(needUpdateMarch, needRemoveMarchUuidList)
	if needUpdateMarch ~= nil then
		for k,v in pairs(needUpdateMarch) do
			self:AddOneAlarm(v)
		end
	end

	if needRemoveMarchUuidList ~= nil then
		for k,v in pairs(needRemoveMarchUuidList) do
			self:RemoveOneAlarm(k)
		end
	end
	EventManager:GetInstance():Broadcast(EventId.RefreshAlarm)
end

--添加一个警报
function RadarAlarmDataManager:AddOneAlarm(marchInfo)
	if marchInfo ~= nil then
		self.alarm[marchInfo.uuid] = marchInfo
	end
end

--删除一个警报
function RadarAlarmDataManager:RemoveOneAlarm(uuid)
	self.alarm[uuid] = nil
end

--判断警告类型
function RadarAlarmDataManager:GetWarningType(march)
	local marchTargetType = march:GetMarchTargetType()
	local targetUuid = march.targetUuid
	if marchTargetType == MarchTargetType.RALLY_FOR_BUILDING or marchTargetType == MarchTargetType.ATTACK_BUILDING then
		if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
			return WarningType.Attack
		end
	elseif marchTargetType == MarchTargetType.RALLY_FOR_CITY or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY then
		local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
		if (buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN) then
			return WarningType.Attack
		end
	elseif marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT then
		return WarningType.Attack
	elseif marchTargetType == MarchTargetType.SCOUT_BUILDING then
		if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
			return WarningType.Scout
		end
	elseif marchTargetType == MarchTargetType.SCOUT_CITY then
		local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
		if buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
			return WarningType.Scout
		end
	elseif marchTargetType == MarchTargetType.SCOUT_ARMY_COLLECT or marchTargetType == MarchTargetType.SCOUT_TROOP then
		return WarningType.Scout
	elseif marchTargetType == MarchTargetType.ASSISTANCE_BUILD then
		if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
			return WarningType.Assistance
		end
	elseif marchTargetType == MarchTargetType.ASSISTANCE_CITY then
		local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid)
		if buildingData ~= nil and buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
			return WarningType.Assistance
		end
	elseif marchTargetType == MarchTargetType.RESOURCE_HELP then
		if DataCenter.BuildManager:GetBuildingDataByUuid(targetUuid) ~= nil then
			return WarningType.Assistance
		end
	elseif marchTargetType == MarchTargetType.ATTACK_DESERT then
		local state = DataCenter.DesertDataManager:CheckIsSelfDesert(march.targetUuid)
		if state then
			return WarningType.Attack
		end
	end
end

--获取行军信息
function RadarAlarmDataManager:GetMarchByUuid(uuid)
	return self.alarm[uuid]
end

return RadarAlarmDataManager