local HospitalManager = BaseClass("HospitalManager")
local Localization = CS.GameEntry.Localization
local HospitalInfo = require "DataCenter.HospitalData.HospitalInfo"


local function __init(self)
	self.allHospital = {}
	self.dragonHospital = {}
end

local function __delete(self)
	self.allHospital = {}
	self.dragonHospital = {}
end

--初始化所有伤兵信息
local function InitData(self,message)
	if message["hospital"] ~= nil then
		self.allHospital = {}
		self.dragonHospital = {}
		for k,v in pairs(message["hospital"]) do
			self:UpdateOneHospitalInfo(v)
		end
	end
end

--更新一种伤兵信息
local function UpdateOneHospitalInfo(self,message)
	if message ~= nil then
		local id = message["armyId"]
		local armsType = message["type"]
		if armsType==nil then
			armsType = MarchArmsType.Free
		end
		if armsType == MarchArmsType.Free then
			local one = self.allHospital[id]
			if one == nil then
				one = HospitalInfo.New()
				one:UpdateInfo(message)
				self.allHospital[id] = one
			else
				one:UpdateInfo(message)
			end
			if one ~= nil and one.dead == 0 and one.heal == 0 then
				self.allHospital[id] = nil
			end
		elseif armsType == MarchArmsType.CROSS_DRAGON then
			local one = self.dragonHospital[id]
			if one == nil then
				one = HospitalInfo.New()
				one:UpdateInfo(message)
				self.dragonHospital[id] = one
			else
				one:UpdateInfo(message)
			end
			if one ~= nil and one.dead == 0 and one.heal == 0 then
				self.dragonHospital[id] = nil
			end
		end

	end
end

--获取这种伤兵信息
local function FindHospitalInfo(self,id)
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		return self.allHospital[id]
	else
		return self.dragonHospital[id]
	end

end

--获取排好序的所有伤兵信息
local function GetAllHospital(self)
	local result = {}
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for k,v in pairs(self.allHospital) do
			if v.dead > 0 or v.heal>0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	else
		for k,v in pairs(self.dragonHospital) do
			if v.dead > 0 or v.heal>0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	end

	return result
end

local function GetDeadHospital(self)
	local result = {}
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for k,v in pairs(self.allHospital) do
			if v.dead > 0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	else
		for k,v in pairs(self.dragonHospital) do
			if v.dead > 0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	end

	return result
end
--获取排好序的治疗中伤兵信息
local function GetTreatingHospital(self)
	local result = {}
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for k,v in pairs(self.allHospital) do
			if v.heal > 0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	else
		for k,v in pairs(self.dragonHospital) do
			if v.heal > 0 then
				table.insert(result,v)
			end
		end
		table.sort(result,self.SortHospitalSoldier)
	end

	return result
end

local function SortHospitalSoldier(a,b)
	local army1 = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.armyId)
	local army2 = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.armyId)
	if army1 == nil then
		return false
	elseif army2 == nil then
		return true
	else
		if army1.level > army2.level then
			return true
		elseif army1.level < army2.level then
			return false
		else
			local id1 = army1.id
			local id2 = army2.id
			if id1 > id2 then
				return true
			elseif id1 < id2 then
				return false
			end
		end
	end
	return false
end


--获取当前伤兵值
local function GetHospitalCount(self)
	local result = 0
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for k,v in pairs(self.allHospital) do
			result = result + v.heal
			result = result + v.dead
			if v.heal ~= nil and v.heal > 0 then
			end

		end
	else
		for k,v in pairs(self.dragonHospital) do
			result = result + v.heal
			result = result + v.dead
			if v.heal ~= nil and v.heal > 0 then
			end

		end
	end

	return result
end

--获取当前伤兵值
local function GetTotalDeadCount(self)
	local result = 0
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for _, v in pairs(self.allHospital) do
			result = result + v.dead
			if v.heal ~= nil and v.heal > 0 then
			end

		end
	else
		for _, v in pairs(self.dragonHospital) do
			result = result + v.dead
			if v.heal ~= nil and v.heal > 0 then
			end

		end
	end

	return result
end

--获取最大伤兵容量
local function GetHospitalMaxCount(self)
	return math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.TREAT_NUM_MAX_EFFECT_ADD) *
			(1 +  (LuaEntry.Effect:GetGameEffect(EffectDefine.HOS_MAX) + LuaEntry.Effect:GetGameEffect(EffectDefine.HOS_MAX_ADD)) / 100))
end

--获取除了30298作用号的最大伤兵容量(目前只有医院界面在用)
function HospitalManager:GetHospitalMaxCountWithoutAdd()
	return math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.TREAT_NUM_MAX_EFFECT_ADD) *
			(1 +  (LuaEntry.Effect:GetGameEffect(EffectDefine.HOS_MAX)) / 100))
end

local function HospitalCureHandle(self,message)
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end

		if message["gold"] ~= nil then
			LuaEntry.Player.gold = message["gold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end

		local itemId = nil
		local queue = message["queue"]
		if queue ~= nil then
			local itemObj = queue["itemObj"]
			if itemObj ~= nil then
				itemId = itemObj["itemId"]
				DataCenter.QueueDataManager:UpdateQueueData(queue)
			end
		end
		local army = message["army"]
		if army ~= nil then
			local power = 0
			local originalNum = 0
			local changeNum = 0
			for k,v in pairs(army) do
				originalNum = DataCenter.ArmyManager:GetArmyFreeCount(v.id)
				DataCenter.ArmyManager:UpdateOneArmy(v)
				changeNum = DataCenter.ArmyManager:GetArmyFreeCount(v.id) - originalNum
				if changeNum > 0 then
					power = power + changeNum * GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), v.id, "power", 0)
				end
			end
			UIUtil.ShowTipsId(130127)
			if power > 0 then
				GoToUtil.ShowPower({power = power})
			end
		end
		if message["hospitalArray"] ~= nil then
			for k,v in pairs(message["hospitalArray"]) do
				self:UpdateOneHospitalInfo(v)
			end
			EventManager:GetInstance():Broadcast(EventId.HospitalUpdate)
		end
		if itemId ~= nil then
			EventManager:GetInstance():Broadcast(EventId.HospitaiStart)
		end
	else
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	end
end

--恢复一种伤兵信息
local function ResetHospitalInfo(self,id)
	local temp = self:FindHospitalInfo(id)
	if temp ~= nil then
		if temp.dead <= 0 then
			self.allHospital[id] = nil
		else
			temp.heal = 0
		end
	end
end


local function PushHospitalChangeHandle(self,message)
	if message["hospital"] ~= nil then
		for k,v in pairs(message["hospital"]) do
			if v["cure"] ~= nil and v["armyId"] ~= nil then
				self:ResetHospitalInfo(v["armyId"])
			else
				self:UpdateOneHospitalInfo(v)
			end
		end
	end
	EventManager:GetInstance():Broadcast(EventId.HospitalUpdate)
end

--是否有受伤的士兵
local function IsHaveInjuredSolider(self)
	if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
		for k, v in pairs(self.allHospital) do
			if v.dead > 0 then
				return true
			end
		end
	else
		for k, v in pairs(self.dragonHospital) do
			if v.dead > 0 then
				return true
			end
		end
	end

	return false
end

--核对发送收治疗兵
local function CheckSendFinish(self)
	local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queue.uuid })
		return true
	end
	return false
end

--获取治疗中登记最高的士兵
local function GetMaxSoldierInTreating(self)
	local list = self:GetTreatingHospital()
	if list ~= nil and list[1] ~= nil then
		return DataCenter.ArmyTemplateManager:GetArmyTemplate(list[1].armyId)
	end
end

--获取治疗中士兵战力
function HospitalManager:GetPowerInTreating()
	local result = 0
	local list = self:GetTreatingHospital()
	if list ~= nil and list[1] ~= nil then
		for k,v in pairs(list) do
			result = result + GetTableData(DataCenter.ArmyTemplateManager:GetTableName(), v.armyId, "power", 0) * v.heal
		end
	end
	return result
end

HospitalManager.__init = __init
HospitalManager.__delete = __delete
HospitalManager.InitData = InitData
HospitalManager.UpdateOneHospitalInfo = UpdateOneHospitalInfo
HospitalManager.FindHospitalInfo = FindHospitalInfo
HospitalManager.GetAllHospital = GetAllHospital
HospitalManager.GetHospitalCount = GetHospitalCount
HospitalManager.GetHospitalMaxCount = GetHospitalMaxCount
HospitalManager.GetTreatingHospital = GetTreatingHospital
HospitalManager.SortHospitalSoldier = SortHospitalSoldier
HospitalManager.HospitalCureHandle = HospitalCureHandle
HospitalManager.PushHospitalChangeHandle = PushHospitalChangeHandle
HospitalManager.ResetHospitalInfo = ResetHospitalInfo
HospitalManager.IsHaveInjuredSolider = IsHaveInjuredSolider
HospitalManager.CheckSendFinish = CheckSendFinish
HospitalManager.GetMaxSoldierInTreating = GetMaxSoldierInTreating
HospitalManager.GetDeadHospital =GetDeadHospital
HospitalManager.GetTotalDeadCount = GetTotalDeadCount

return HospitalManager