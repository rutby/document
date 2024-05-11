local ArmyManager = BaseClass("ArmyManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function __init(self)
	self.allArmy = {}
end

local function __delete(self)
	self.allArmy = {}
end

local function InitData(self,message)
	if message["army"] ~= nil then
		self.allArmy = {}
		for k,v in pairs(message["army"]) do
			self:UpdateOneArmy(v)
		end
	end
end

local function UpdateOneArmy(self,message)
	if message ~= nil then
		local id = message["id"]
		local one = self:FindArmy(id)
		if one == nil then
			one = ArmyInfo.New()
			one:UpdateInfo(message)
			self.allArmy[id] = one
		else
			one:UpdateInfo(message)
		end
	end
end

local function FindArmy(self,id)
	if id ~= nil then
		return self.allArmy[tostring(id)]
	end
end

local function PushArmyChangeHandle(self,message)
	if message["army"] ~= nil then
		for k,v in pairs(message["army"]) do
			self:UpdateOneArmy(v)
		end
		EventManager:GetInstance():Broadcast(EventId.TrainArmyData)
	end
end

local function ArmyAddMessageHandle(self,message)
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end

		if message["gold"] ~= nil then
			LuaEntry.Player.gold = message["gold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end

		if message["remainArray"] ~= nil then
			DataCenter.ItemData:UpdateItems(message["remainArray"])
			EventManager:GetInstance():Broadcast(EventId.RefreshItems)
		end
		local itemId = nil
		local queueType = NewQueueType.Default
		local queue = message["queue"]
		if queue ~= nil then
			local itemObj = queue["itemObj"]
			if itemObj ~= nil then
				local tempItemId = itemObj["itemId"]
				local subItemId= string.split(tempItemId,";")
				if subItemId ~= nil and #subItemId > 1 then
					itemId = subItemId[1]
				end
				queueType = queue["type"]
				DataCenter.QueueDataManager:UpdateQueueData(queue)
			end
		end
		local armyId = 0
		if message["userArmy"] ~= nil then
			armyId = message["userArmy"]["id"]
			local prepareType = message["prepare"]
			local lastCount = 0
			local army = self:FindArmy(armyId)
			if army ~= nil then
				if prepareType == ArmyTrainType.ArmyTrainType_Reserve then
					lastCount = army.prepare
				else
					lastCount = army.free
				end
			end
			self:UpdateOneArmy(message["userArmy"])
			if army == nil then
				army = self:FindArmy(armyId)
			end
			if army ~= nil then
				local nowCount = 0
				if prepareType == ArmyTrainType.ArmyTrainType_Reserve then
					nowCount = army.prepare
				else
					nowCount = army.free
				end
				local changeCount = nowCount - lastCount
				if changeCount > 0 then
					local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
					if template ~= nil then
						local str = Localization:GetString("130058",Localization:GetString(template.name).." x"..(changeCount))
						local max = 0
						local total = 0
						if prepareType == ArmyTrainType.ArmyTrainType_Reserve then
							max = DataCenter.ArmyManager:GetReserveArmyMax()
							total = DataCenter.ArmyManager:GetReserveArmyNum() - math.ceil(changeCount)
						else
							max = DataCenter.ArmyManager:GetArmyNumMax(template.arm)
							total = DataCenter.ArmyManager:GetTotalArmyNum(template.arm) - math.ceil(changeCount)
						end
						if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
							TimerManager:GetInstance():DelayInvoke(function()
								UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, army.free - lastCount, total, max, max, template.arm, prepareType)
							end, 3)
						else
							UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, army.free - lastCount, total, max, max, template.arm, prepareType)
						end
						local power = GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), armyId, "power", 0)
						if power > 0 then
							GoToUtil.ShowPower({power = changeCount * power})
						end
					end
				end
			end
			EventManager:GetInstance():Broadcast(EventId.TrainArmyData,armyId)
		end
		if itemId ~= nil then
			local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
			local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
			if list ~= nil then
				for k,v in pairs(list) do
					EventManager:GetInstance():Broadcast(EventId.TrainingArmy, v.uuid)
				end
			end
		end
		if message["free"] ~= nil and message["free"] == TrainFreeType.Bauble then
			local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
			if template ~= nil then
				local baubleName = self:GetBaubleNameByArmType(template.arm)
				UIUtil.ShowTips(Localization:GetString(GameDialogDefine.TRAIN_BAUBLE_FINISH, baubleName))
			end
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

local function SoldierUpMessageHandle(self,message)
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end

		if message["gold"] ~= nil then
			LuaEntry.Player.gold = message["gold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end

		if message["remainArray"] ~= nil then
			DataCenter.ItemData:UpdateItems(message["remainArray"])
			EventManager:GetInstance():Broadcast(EventId.RefreshItems)
		end

		local queue = message["queue"]
		if queue ~= nil then
			local itemObj = queue["itemObj"]
			if itemObj ~= nil then
				local itemId = ""
				local tempItemId = itemObj["itemId"]
				local subItemId= string.split(tempItemId,";")
				if subItemId ~= nil and #subItemId > 1 then
					itemId = subItemId[1]
				end
				DataCenter.QueueDataManager:UpdateQueueData(queue)
				local queueType =  queue["type"]
				local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
				local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
				if list ~= nil then
					for k,v in pairs(list) do
						EventManager:GetInstance():Broadcast(EventId.TrainingArmy, v.uuid)
					end
				end
			end
		end
		local srcArmyId = 0
		local srcArmy = message["srcArmy"]
		if srcArmy ~= nil then
			self:UpdateOneArmy(srcArmy)
			srcArmyId = srcArmy["id"]
		end

		local upgradeArmy = message["upgradeArmy"]
		if upgradeArmy ~= nil then
			local armyId = upgradeArmy["id"]
			local lastCount = 0
			local army = self:FindArmy(armyId)
			if army ~= nil then
				lastCount = army.free
			end
			self:UpdateOneArmy(upgradeArmy)
			if army == nil then
				army = self:FindArmy(armyId)
			end
			if army ~= nil and army.free > lastCount then
				local changeCount = army.free - lastCount
				UIUtil.ShowTips(Localization:GetString("360105",Localization:GetString(GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), armyId, "name", 0)).." x"..changeCount))
				
				local power = GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), armyId, "power", 0) - 
						GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), srcArmyId, "power", 0)
				if power > 0 then
					GoToUtil.ShowPower({power = changeCount * power})
				end
			end

			EventManager:GetInstance():Broadcast(EventId.TrainArmyData,armyId)
		end

	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end


local function GetArmyQueue(self,type)
	return DataCenter.QueueDataManager:GetQueueByType(type)
end


local function GetArmyQueueTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		return  NewQueueType.CarSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		return  NewQueueType.BowSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		return  NewQueueType.FootSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
		return  NewQueueType.Trap
	end
	return NewQueueType.Default
end

local function SendSpeedFinishQueue(self,qUuid)
	SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = qUuid,itemIDs = "",isGold = IsGold.UseGold })
end

local function GetSoldierTypeByBuildId(self,buildId)
	if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		return  SoldierType.CarSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		return  SoldierType.BowSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		return  SoldierType.FootSoldier
	elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
		return SoldierType.Trap
	end
	return NewQueueType.Default;
end

local function GetExtraData(self,soldierType)
	return nil
end

local function GetArmyFreeList(self)
	local list ={}
	table.walk(self.allArmy,function (k,v)
		list[k] =v.free
	end)
	return list
end

local function GetArmyCrossList(self)
	local list ={}
	table.walk(self.allArmy,function (k,v)
		list[k] =v.cross
	end)
	return list
end

--获取在队列中的士兵template
local function GetQueueArmyTemplate(self,type)
	local queue = self:GetArmyQueue(type)
	if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
		local armyId = ""
		local tempList = string.split(queue.itemId,";")
		if tempList ~= nil and #tempList > 3 then
			--晋级 
			armyId = tempList[3]
		elseif tempList ~= nil and #tempList > 1 then
			armyId = tempList[1]
			--训练
		end

		return DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
	end
end

--获取正在升级或晋级的兵数
local function GetQueueArmyNum(self, buildType)
	local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildType)

	local count = 0
	local queue = self:GetArmyQueue(queueType)
	if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" and queue:GetQueueState() ~= NewQueueState.Free then
		
		local tempList = string.split(queue.itemId,";")
		if tempList ~= nil and #tempList > 3 then
			--晋级 
			count = toInt(tempList[4])
		elseif tempList ~= nil and #tempList > 1 then
			if #tempList == 2 or (#tempList == 3 and toInt(tempList[3]) == ArmyTrainType.ArmyTrainType_Normal) then
				count = toInt(tempList[2])
			end
			--训练
		end
	end
	return count
end


--核对发送收兵
local function CheckSendFinish(self,queueType)
	local queue = self:GetArmyQueue(queueType)
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
		return true
	end
	return false
end

--获取最大解锁兵种id
local function GetMaxUnLockId(self,buildId)
	local list = self:GetArmyList(buildId)
	local count = #list
	if count > 0 then
		for i = count, 1, -1 do
			if self:IsUnLock(list[i]) then
				return i, list[i]
			end
		end
	end
	return 0, ""
end

--是否解锁兵种
local function IsUnLock(self,id)
	local tempK,tempV = self:GetLockTrainBuild(id)
	if tempK ~= nil and tempV ~= nil then
		return false
	end
	tempK,tempV = self:GetLockTrainScience(id)
	if tempK ~= nil and tempV ~= nil then
		return false
	end

	return true
end
--获取未解锁的建筑条件
local function GetLockTrainBuild(self,id)
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
	if template ~= nil then
		for k,v in ipairs(template.unlock_train_build) do
			if not DataCenter.BuildManager:HasBuildByIdAndLevel(v[1],v[2]) then
				return v[1],v[2]
			end
		end
	end
end
--获取未解锁的科技条件
local function GetLockTrainScience(self,id)
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
	if template ~= nil then
		if template.unlock_train_science ~= nil then
			for k,v in ipairs(template.unlock_train_science) do
				if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v[1],v[2]) then
					return v[1],v[2]
				end
			end
		end
	end
end

--local function GetUpgradeArmyUnlock(self,buildId)
--	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
--	if template~=nil then
--		local effectNum = template:GetUpgradeStateEffect()
--
--	end
--end

--是否可以晋级
local function IsCanUpgrade(self, id, buildId)
	local armys = self:GetArmyList(buildId)
	local army = self:FindArmy(id)
	if army == nil or army.free <= 0 then
		return false
	end
	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
	for k,v in ipairs(armys) do
		local templateV = DataCenter.ArmyTemplateManager:GetArmyTemplate(v)

		if templateV and templateV.level > template.level then
			local flag = true
			if templateV.unlock_upgrade_build ~= nil then
				for tk,tv in ipairs(templateV.unlock_upgrade_build) do
					if not DataCenter.BuildManager:HasBuildByIdAndLevel(tv[1],tv[2]) then
						flag = false
					end
				end
			end

			--for tk,tv in ipairs(templateV.unlock_upgrade_science) do
			--	if not DataCenter.ScienceManager:HasScienceByIdAndLevel(tv[1],tv[2]) then
			--		flag = false
			--	end
			--end
			if flag then
				return true
			end
		end
	end
	return false
end

local function GetCanUnLockUpgrade(self,buildId)
	local effectNum =0
	if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
		effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.TANK_UPGRADE_SWITCH)
	elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
		effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.PLANE_UPGRADE_SWITCH)
	elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
		effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.INFANTRY_UPGRADE_SWITCH)
	elseif buildId == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
		effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.TRAP_UPGRADE_SWITCH)
	end
	if effectNum<1 then
		return false
	else
		return true
	end
end

--获取最高可以升级的id
local function GetMaxUpgradeId(self, id, buildId)
	local result = -1
	local armys = self:GetArmyList(buildId)

	local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
	for k,v in ipairs(armys) do
		local templateV = DataCenter.ArmyTemplateManager:GetArmyTemplate(v)

		if templateV.level > template.level then
			local flag = true
			if templateV.unlock_upgrade_build ~= nil then
				for tk,tv in ipairs(templateV.unlock_upgrade_build) do
					if not DataCenter.BuildManager:HasBuildByIdAndLevel(tv[1],tv[2]) then
						flag = false
					end
				end
			end

			if templateV.unlock_upgrade_science ~= nil then
				for tk,tv in ipairs(templateV.unlock_upgrade_science) do
					if not DataCenter.ScienceManager:HasScienceByIdAndLevel(tv[1],tv[2]) then
						flag = false
					end
				end
			end
			if flag then
				result = v
			else
				break
			end
		end
	end
	return result
end
--获取可以晋升士兵的建筑
local function GetCanUpgradeArmyBuildId(self)
	for k, v in ipairs(BarracksBuild) do
		local list = self:GetArmyList(v)
		local count = #list
		if count > 0 then
			for i = count, 1, -1 do
				if self:IsCanUpgrade(list[i], v) then
					return v
				end
			end
		end
	end
	return 0
end

--获取建筑对应的所有兵种信息
local function GetArmyList(self,buildId)
	local result = {}
	local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
	if buildDesTemplate ~= nil then
		for k, v in ipairs(buildDesTemplate.open_arms) do
			table.insert(result, v)
		end
	end
	return result
end

local function GetArmyNumMax(self, armType)
	local num = 0
	if armType == ArmType.Trap then
		num = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_TRAP_NUM_MAX)
	else
		num = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ARMY_NUM_MAX)
	end
	return math.max(math.floor(num), 1)
end

local function GetTotalArmyNum(self, armType)

	--空闲
	local freeSoldiers =  self:GetArmyFreeList()
	--跨服
	local crossSoldiers = self:GetArmyCrossList()
	--出征
	local march = self:GetTotalMarchArmyNum()
	--伤兵
	local injured = (armType ~= ArmType.Trap and DataCenter.HospitalManager:GetHospitalCount() or 0)
	local soliderNum = injured
	for _, dict in ipairs({ freeSoldiers, crossSoldiers, march }) do
		for k, v in pairs(dict) do
			local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
			if template ~= nil and (template.mercenary ==nil or template.mercenary <= 0) then
				if (armType ~= ArmType.Trap and template.arm ~= ArmType.Trap) or (armType == ArmType.Trap and template.arm == ArmType.Trap) then
					soliderNum = soliderNum + v
				end
			end
		end
	end
	--训练和晋升队列
	local armyBuilds = BarracksBuild
	for _, v in pairs(armyBuilds) do
		if armType ~= ArmType.Trap and v ~= BuildingTypes.FUN_BUILD_TRAP_BARRACK or
		   armType == ArmType.Trap and v == BuildingTypes.FUN_BUILD_TRAP_BARRACK then
			soliderNum = soliderNum + self:GetQueueArmyNum(v)
		end
	end
	return soliderNum
end

local function GetTotalMarchArmyNum(self)
	local list ={}
	table.walk(self.allArmy,function (k,v)
		list[k] =v.march
	end)
	return list
end

local function GetTotalMarchAndFreeArmyNum(self)
	local list ={}
	table.walk(self.allArmy,function (k,v)
		list[k] = v.march + v.free
	end)
	return list
end

local function GetArmyDataForPve(self, pveEntrance)
	local list ={}
	table.walk(self.allArmy,function (k,v)
		local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
		if template ~= nil then
			if (template.mercenary ==nil or template.mercenary<=0) and template.arm ~= ArmType.Trap then
				list[k] = v.march + v.free
			end
		end

	end)
	if pveEntrance ~= PveEntrance.MineCave then
		local hospital = DataCenter.HospitalManager:GetAllHospital()
		if hospital~=nil and #hospital>0 then
			for k,v in pairs(hospital) do
				local soldierId = v.armyId
				if list[soldierId]~=nil then
					list[soldierId] = list[soldierId] +v.heal+v.dead
				else
					list[soldierId] = v.heal+v.dead
				end
			end
		end
	end
	
	return list
end

local function GetArmyUnlock(self, buildId)
	if buildId == nil then
		return ""
	end
	local userUid = LuaEntry.Player.uuid
	local key = userUid.."_"..tostring(buildId)
	local id = Setting:GetString(key, "")
	return id
end

local function SaveArmyUnlock(self, buildId, armyId)
	local userUid = LuaEntry.Player.uuid
	local key = userUid.."_"..tostring(buildId)
	Setting:SetString(key, armyId)
	EventManager:GetInstance():Broadcast(EventId.UnlockArmy, buildId)
end

--通过兵种类型获取直接完成装饰名字
function ArmyManager:GetBaubleNameByArmType(armType)
	local result = ""
	local effectId = 0
	if armType == ArmType.Tank then
		effectId = EffectDefine.TRAIN_FINISH_TANK
	elseif armType == ArmType.Robot then
		effectId = EffectDefine.TRAIN_FINISH_INFANTRY
	elseif armType == ArmType.Plane then
		effectId = EffectDefine.TRAIN_FINISH_PLANE
	end

	return result
	
end
local function GetReserveArmyMax(self)
	local max = math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.Effect_Reserve_Max))
	return max
end

local function GetReserveArmyNum(self)
	local num = 0
	if self:IsReserveSystemOpen() then
		table.walk(self.allArmy,function (_, v)
			num = num + v.prepare
		end)
	end
	return num
end

local function GetAllReserveArmy(self)
	local list ={}
	if self:IsReserveSystemOpen() then
		table.walk(self.allArmy,function (k, v)
			if v.prepare > 0 then
				list[k] = v.prepare
			end
		end)
	end
	return list
end

local function GetReserveQueueArmyNum(self, buildType)
	if not self:IsReserveSystemOpen() then
		return 0
	end

	local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildType)

	local count = 0
	local queue = self:GetArmyQueue(queueType)
	if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" and queue:GetQueueState() ~= NewQueueState.Free then
		local tempList = string.split(queue.itemId,";")
		if tempList ~= nil and tempList[4] ~= nil then
			--预备兵不能晋级
		elseif tempList ~= nil and tempList[3] ~= nil then
			if toInt(tempList[3]) == ArmyTrainType.ArmyTrainType_Reserve then
				count = toInt(tempList[2])
			end
			--训练
		end
	end
	return count
end

local function NeedShowReserveBubble(self)
	if not self:IsReserveSystemOpen() then
		return false
	end
	local reserveCurrent = self:GetReserveArmyNum()
	if reserveCurrent <= 0 then
		return false
	end
	local max = DataCenter.ArmyManager:GetArmyNumMax()
	local current = DataCenter.ArmyManager:GetTotalArmyNum()
	return current < max
end

local function IsReserveSystemOpen(self)
	local configOpenState = LuaEntry.DataConfig:CheckSwitch("Reserve")
	return configOpenState
end

--引导极特殊函数（当前大本等级是否有可以解锁但还没有解锁的新兵种）
function ArmyManager:IsUnlockArmyInMainLevel()
	--先取等级最高的建筑对应兵种（低等级不存在，等级最高兵营比其他兵营解锁的士兵低）
	local maxLevel = 0
	local level = 0
	local maxBuildId = 0
	for k, v in ipairs(BarracksBuild) do
		level = DataCenter.BuildManager:GetMaxBuildingLevel(v)
		if maxLevel < level then
			maxLevel = level
			maxBuildId = v
		end
	end
	if maxBuildId > 0 then
		local list = self:GetArmyList(maxBuildId)
		local count = #list
		if count > 0 then
			local mainLv = DataCenter.BuildManager.MainLv
			for i = count, 1, -1 do
				if not self:IsUnLock(list[i]) then
					local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(list[i])
					if template ~= nil then
						for k, v in ipairs(template.unlock_train_build) do
							if v[2] <= mainLv then
								return true
							end
						end
					end
				end
			end
		end
	end
	
	return false
end

function ArmyManager:GetArmyFreeCount(armyId)
	local result =  0
	local info = self:FindArmy(armyId)
	if info ~= nil then
		result = info.free
	end
	return result
end

ArmyManager.__init = __init
ArmyManager.__delete = __delete
ArmyManager.InitData = InitData
ArmyManager.UpdateOneArmy = UpdateOneArmy
ArmyManager.FindArmy = FindArmy
ArmyManager.PushArmyChangeHandle = PushArmyChangeHandle
ArmyManager.ArmyAddMessageHandle = ArmyAddMessageHandle
ArmyManager.SoldierUpMessageHandle = SoldierUpMessageHandle
ArmyManager.GetArmyQueue = GetArmyQueue
ArmyManager.GetArmyQueueTypeByBuildId = GetArmyQueueTypeByBuildId
ArmyManager.SendSpeedFinishQueue = SendSpeedFinishQueue
ArmyManager.GetSoldierTypeByBuildId = GetSoldierTypeByBuildId
ArmyManager.GetExtraData = GetExtraData
ArmyManager.GetArmyFreeList = GetArmyFreeList
ArmyManager.GetArmyCrossList = GetArmyCrossList
ArmyManager.GetQueueArmyTemplate = GetQueueArmyTemplate
ArmyManager.CheckSendFinish = CheckSendFinish
ArmyManager.GetMaxUnLockId = GetMaxUnLockId
ArmyManager.IsUnLock = IsUnLock
ArmyManager.GetLockTrainBuild = GetLockTrainBuild
ArmyManager.GetLockTrainScience = GetLockTrainScience
ArmyManager.IsCanUpgrade = IsCanUpgrade
ArmyManager.GetArmyList = GetArmyList
ArmyManager.GetMaxUpgradeId = GetMaxUpgradeId
ArmyManager.GetCanUnLockUpgrade = GetCanUnLockUpgrade
ArmyManager.GetArmyNumMax = GetArmyNumMax
ArmyManager.GetTotalArmyNum = GetTotalArmyNum
ArmyManager.GetTotalMarchArmyNum =GetTotalMarchArmyNum
ArmyManager.GetQueueArmyNum = GetQueueArmyNum
ArmyManager.GetTotalMarchAndFreeArmyNum = GetTotalMarchAndFreeArmyNum
ArmyManager.GetArmyDataForPve = GetArmyDataForPve
ArmyManager.GetArmyUnlock = GetArmyUnlock
ArmyManager.SaveArmyUnlock = SaveArmyUnlock
ArmyManager.GetReserveArmyMax = GetReserveArmyMax
ArmyManager.GetReserveArmyNum = GetReserveArmyNum
ArmyManager.GetAllReserveArmy = GetAllReserveArmy
ArmyManager.GetReserveQueueArmyNum = GetReserveQueueArmyNum
ArmyManager.NeedShowReserveBubble = NeedShowReserveBubble
ArmyManager.IsReserveSystemOpen = IsReserveSystemOpen
ArmyManager.GetCanUpgradeArmyBuildId = GetCanUpgradeArmyBuildId
return ArmyManager