local MonsterManager = BaseClass("MonsterManager")

local function __init(self)
	self.find_monster_max_level = 0
	self.kill_boss_max_num = 0
	self.daily_kill_boss = 0
	self.lastTime = 0
	self.find_bossLevelRange = {}
end

local function __delete(self)
	self.find_monster_max_level = nil
	self.kill_boss_max_num = nil
	self.daily_kill_boss = nil
	self.lastTime = nil
end

local function InitData(self,message)
	self.find_monster_max_level = message["find_monster_max_level"]
	self.kill_boss_max_num = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k1")
	self.find_bossLevelRange = {}
	local str = LuaEntry.DataConfig:TryGetStr("search_monster", "k10")
	local arr1 = string.split(str,";")
	if #arr1>0 then
		for i=1,#arr1 do
			local arr2 = string.split(arr1[i],"|")
			if #arr2 ==2 then
				local levelRange = arr2[1]
				local buildLevel = toInt(arr2[2])
				local rangeArr = string.split(levelRange,"-")
				if #rangeArr ==2 then
					local min = toInt(rangeArr[1])
					local max = toInt(rangeArr[2])
					if min>0 and max>0 and buildLevel>0 then
						self.find_bossLevelRange[buildLevel] = {}
						self.find_bossLevelRange[buildLevel].minNum = min
						self.find_bossLevelRange[buildLevel].maxNum = max
					end
				end
			end
		end
	end
	self:UpdateKillBossNum(message)
end

local function UpdateKillBossNum(self,message)
	if message["daily_kill_boss"] then
		self.daily_kill_boss = message["daily_kill_boss"]
		--记录刷新时间
		self.lastTime = UITimeManager:GetInstance():GetServerSeconds()
	end
end

--获取现在可攻击怪的最大等级
local function GetCurCanAttackMaxLevel(self) 
	local hasAttackMaxLevel = LuaEntry.Player.pveLevel
	local result = hasAttackMaxLevel + 1
	local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
	if configOpenState then
		local k6 = LuaEntry.DataConfig:TryGetNum("search_monster", "k6")
		result = DataCenter.BuildManager.MainLv + k6
	end
	local max = DataCenter.MonsterTemplateManager:GetMonsterMaxLevel()
	if result > max then
		result = max
	end
	
	if result <= 0 then
		result = 1
	end
	
	local serverMaxLv = self:GetCanFindMonsterMaxLevel()
	if serverMaxLv and result > serverMaxLv then
		return serverMaxLv
	end
	return result
end

--获取现在可搜索怪的最大等级
local function GetCanFindMonsterMaxLevel(self) 
	return self.find_monster_max_level
end

local function GetCurCanAttackBossMaxLevel(self)
	local maxLevel = 1
	local result = DataCenter.BuildManager.MainLv
	for k,v in pairs(self.find_bossLevelRange) do
		if result>=k then
			local maxNum = v.maxNum
			if maxLevel<maxNum then
				maxLevel = maxNum
			end
		end
	end
	return maxLevel
end

local function GetRestKillBossNum(self)
	local curTime = UITimeManager:GetInstance():GetServerSeconds()
	if not UITimeManager:GetInstance():IsSameDayForServer(self.lastTime,curTime) then
		self.daily_kill_boss = 0
	end
	local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
	local restNum = self.kill_boss_max_num - self.daily_kill_boss + killAddNum
	return math.max(restNum,0)
end

local function GetKillBossNum(self)
	local curTime = UITimeManager:GetInstance():GetServerSeconds()
	if self.lastTime ~= nil then
		if not UITimeManager:GetInstance():IsSameDayForServer(self.lastTime,curTime) then
			self.daily_kill_boss = 0
		end
	end
	if self.daily_kill_boss == nil then
		return 0
	end
	return self.daily_kill_boss
end

local function GetMaxKillBossNum(self)
	local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
	if self.kill_boss_max_num then
		return (self.kill_boss_max_num + killAddNum)
	else
		return killAddNum
	end
end

MonsterManager.__init = __init
MonsterManager.__delete = __delete
MonsterManager.GetCurCanAttackMaxLevel = GetCurCanAttackMaxLevel
MonsterManager.GetCanFindMonsterMaxLevel = GetCanFindMonsterMaxLevel
MonsterManager.InitData = InitData
MonsterManager.UpdateKillBossNum = UpdateKillBossNum
MonsterManager.GetRestKillBossNum = GetRestKillBossNum
MonsterManager.GetKillBossNum = GetKillBossNum
MonsterManager.GetMaxKillBossNum = GetMaxKillBossNum
MonsterManager.GetCurCanAttackBossMaxLevel = GetCurCanAttackBossMaxLevel
return MonsterManager