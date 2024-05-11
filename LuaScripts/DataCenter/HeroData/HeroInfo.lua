local HeroInfo = BaseClass("HeroInfo")
local AdvanceReqData = require 'DataCenter.HeroData.AdvanceReqData'
local HeroPluginInfo = require "DataCenter.HeroData.HeroPluginInfo"
local HeroPropertyData = require "DataCenter.HeroData.HeroPropertyData"

local level2Id = {}
local heroReset_k7 = nil

local CampRedState =
{
	None = 1,--未初始化
	Show = 2,--可以显示，
	No = 3,--不显示
}

local function __init(self)
	self.uuid = 0							--唯一id long型
	self.heroId = 0							--英雄id number
	self.state = 0							--状态
	self.exp = 0							--经验
	self.level = 1							--等级
	self.quality = 0						--品质
	
	self.lastLevel = 0
	self.lastAtk = 0
	self.lastDef = 0
	self.lastLife = 0
	self.lastPower = 0
	
	self.atk = 0							--攻击力
	self.def = 0							--防御力
	self.power = 0							--战力值
	
	self.config = nil						--配置
	self.camp = 0							--阵营(可更改)
	self.rarity = 0							--稀有度
    
    self.skillDict = nil
	self.lastArkId = 0
	self.arkId = 0
	
	self.effectDict = {}   -- 英雄特有作用号

	self.backStoryRewardDict = nil -- 英雄背景故事奖励
	
	self.curMaxLevel = 0

	--军阶当前id和本稀有度英雄对应的最大等级id
	self.curMilitaryRankId = 1
	self.maxMilitaryRankId = 1
	
	--cache properties
	self.configQuality = 0
	self.advanceReq = nil
	
	self.isMaster = false
	self.plugin = nil--英雄插件
	self.chooseCamp = 0--选择的阵营
	self.canShowCampRed = CampRedState.None--阵营红点状态
	
	-- LW PVE
	self.modelId = 1
	-- LW PVE end
	self.heroStoryCount = 4						--英雄背景故事数量

	self.skillLevels = {}
end

local function __delete(self)
	self.uuid = nil
	self.heroId = nil
	self.state = nil
	self.exp = nil
	self.level = nil
	self.quality = nil

	self.lastLevel = nil
	self.lastAtk = nil
	self.lastDef = nil
	self.lastLife = nil
	self.lastPower = nil
	
	self.atk = nil
	self.def = nil
	self.power = nil
	
	self.config = nil
	self.camp = nil
	self.rarity = nil
	self.effectDict = nil
	self.backStoryRewardDict = nil
	self.plugin = nil--英雄插件
	self.chooseCamp = 0--选择的阵营
	self.canShowCampRed = CampRedState.None--阵营红点状态
	self.heroStoryCount = nil
	self.k1 = nil
	self.k5 = nil

	self.skillLevels = nil
end

local function UpdateInfo(self, message)
	if message == nil then
		return
	end
	
	self.uuid = message["uuid"]
	if self.uuid == nil then
		self.uuid= message["heroUuid"]
	end
	
	if message["heroId"] ~= nil then
		self.heroId = tonumber(message["heroId"])
	end
	
	if message["leaderState"] ~= nil then
		self.state = message["leaderState"]
	end
	
	if message["state"] ~= nil then
		self.state = message["state"]	
	end

	if message["exp"] ~= nil then
		self.exp = message["exp"]
	end

	if message["lev"] ~= nil then
		self.lastLevel = self.level
		--1.重置英雄时下发lev为1  2.连续升级时为避免后端滞后下发的低lev覆盖前端模拟的高lev这里做个限制
		--if message["lev"] == 1 or message['lev'] > self.level then
			self.level = message["lev"]
		--end
	end
	
	if message["heroLevel"] ~= nil then
		self.level = message["heroLevel"]
	end
	
	if message["qua"] ~= nil then
		self.quality = message["qua"]
	end
	
	if message["heroQuality"] ~= nil then
		self.quality = message["heroQuality"]
	end

	if message["atk"] ~= nil then
		self.lastAtk = self.atk
		self.atk = message["atk"]
	end

	if message["def"] ~= nil then
		self.lastDef = self.def
		self.def = message["def"]
	end

	if message["power"] ~= nil then
		self.lastPower = self.power
		self.power = message["power"]
	end

	--突破功能新增的当前等级上限
	if message['maxLv'] ~= nil then
		self.curMaxLevel = message['maxLv']
	end
	
	--显示为英雄还是海报 1为英雄 其他为海报
	if message['isHero'] ~= nil then
		self.isMaster = message['isHero'] == 1
	end
	
	self.configQuality = 0
	self.advanceReq = nil
	
	if self.config == nil then
    	self.config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.heroId)
		self.meta = self.config -- LW
		self.modelId = self.config.appearance or 0
		if self.config == nil then
			Logger.LogError('hero config not found! heroId:' .. self.heroId)
			return
		end
		self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId) -- LW
		if self.appearanceMeta == nil then
			Logger.LogError('hero appearance not found! appearance:' .. self.modelId)
			self.modelId = 10001
			self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
		end
		
		self.camp = self.config["camp"]
		self.heroType = self.camp -- LW
		self.rarity = self.config["rarity"]
		self.maxMilitaryRankId = self.config['max_rank_level']
		--if level2Id[self.config['max_rank_level']] then
		--	self.maxMilitaryRankId = level2Id[self.config['max_rank_level']]
		--else
		--	self.maxMilitaryRankId = 1
		--	for rankId = 1, 100 do
		--		local level = GetTableData(TableName.HeroMilitaryRank, rankId, 'level')
		--		if level == "" then
		--			break
		--		end
		--		if level == self.config['max_rank_level'] then
		--			self.maxMilitaryRankId = rankId
		--			level2Id[self.config['max_rank_level']] = rankId
		--			break
		--		end
		--	end
		--end

		self.finalLevel = self.config['max_level'] or 100
	end

	if message['rankLv'] ~= nil then
		for rankId = 1, self.maxMilitaryRankId do
			local level = GetTableData(TableName.HeroMilitaryRank, rankId, 'level')
			local stage = GetTableData(TableName.HeroMilitaryRank, rankId, 'stage')
			local messageStage = message['stage'] or 0
			if level == message['rankLv'] and messageStage == stage then
				self.curMilitaryRankId = rankId
				break
			end
		end
	end
	
	--初始化
	if self.skillDict == nil then
		self:UpdateHeroSkill()
	end

	if self.backStoryRewardDict == nil then
		self.backStoryRewardDict = {}
		local backgroundStoryArray = self.config['background']
		if backgroundStoryArray ~= nil then
			local storyTab = string.split(backgroundStoryArray, '|')
			for i = 1, #storyTab do 
				self.backStoryRewardDict[i] = false
			end 
		end
	end 

    if message['skills'] ~= nil then
        for _, dt in pairs(message['skills']) do
            local skillId = dt['skillId']
			local level   = dt['level']
			local slot   = dt['slot']
			local skillData = self.skillDict[skillId]
            if skillData ~= nil then
				self.skillLevels[slot] = level
                skillData:SetLevel(level)
            end
        end
    end

	if message['upSkillNum'] ~= nil then
    	self.upSkillNum = message['upSkillNum']
	end

	if message['effect'] ~= nil then
		self.effectDict = {}
		for k, v in pairs(message['effect']) do
			local effectId = tonumber(k)
			local effectValue = tonumber(v)
			self.effectDict[effectId] = effectValue
		end
	end

	--update cache
	local advanceType = tonumber(self.config["advanc_type"])
	self.configQuality = advanceType + self.quality
	self.advanceReq = AdvanceReqData.New(self.configQuality)
	if self.isMaster then
		DataCenter.HeroDataManager:SetMasterQuality(self.heroId, self.quality)
	end

	if message["plugin"] ~= nil then
		if self.plugin == nil then
			self.plugin = HeroPluginInfo.New()
		end
		self.plugin:UpdateInfo(message["plugin"])
	end

	if message["chooseCamp"] ~= nil then
		self.chooseCamp = message["chooseCamp"]
	end
	--  更新背景故事奖励状态
	if message['backRecord'] ~= nil  and self.backStoryRewardDict ~= nil then
		--发送的为领取下标
		local idxs = string.split(message['backRecord'],";")
		for k, v in pairs(idxs) do
			self.backStoryRewardDict[tonumber(v)] = true
		end
	end

	if self.propertyData == nil then
		self.propertyData = HeroPropertyData.New()
	end
end

local function UpdateBackStoryRewarDict(self, idx)
	if  self.backStoryRewardDict ~= nil then 
		self.backStoryRewardDict[idx] = true
	else
		self.backStoryRewardDict[idx] = false
	end 
end

local function GetBackStoryRewarDict(self, idx)
	if  self.backStoryRewardDict ~= nil then 
		return  self.backStoryRewardDict[idx]
	end 
	return nil
end


local function GetLvUpChangedAttr(self)
	local atkAdd = math.max(0, self.atk - self.lastAtk)
	local defAdd = math.max(0, self.atk - self.lastAtk)
	local armyAdd = 0
	local template = DataCenter.HeroLevelUpTemplateManager:GetTemplate(self.level)
	if template ~= nil then
		armyAdd = template:GetArmyNum(self.rarity)
	end
	
	local powerAdd = math.max(0, self.power - self.lastPower)
	
	return atkAdd, defAdd, armyAdd, powerAdd
end


local function SetUpSkillNum(self, num)
	self.upSkillNum = num
end

local function GetConfig(self)
	return self.config
end

--获取更改后的阵营
local function GetCamp(self)
	if self.camp == HeroCamp.NEW_HUMAN and self.chooseCamp ~= nil then
		return self.chooseCamp
	end
	return self.camp
end

---获取英雄可提升的最大品质
local function GetMaxQuality(self)
	--2代表橙色英雄海报能升到的最大品质   2;30
	--30代表30本之前玩家不能把紫色英雄海报升级成品质2以上
	if not self.isMaster then
		if heroReset_k7 == nil then
			local k7 = LuaEntry.DataConfig:TryGetStr("hero_reset", "k7")
			if not string.IsNullOrEmpty(k7) then
				local vec = string.split(k7, ";")
				if table.count(vec) == 3 then
					heroReset_k7 = {}
					for k, v in ipairs(vec) do
						table.insert(heroReset_k7, toInt(v))
					end
				end
			end
		end
		if heroReset_k7 ~= nil then
			if self.rarity == HeroUtils.RarityType.S then
				return heroReset_k7[1]
			elseif self.rarity == HeroUtils.RarityType.A then
				if DataCenter.BuildManager.MainLv < heroReset_k7[2] then
					return heroReset_k7[3]
				end
			end
		end
	end

	return self.config[HeroUtils.GetHeroMaxQualityLevelName()]
end

local function IsMaxQuality(self)
	local maxQuality = self:GetMaxQuality()
	return self.quality >= maxQuality
end


---获取当前配置品质(策划调整了配置的品质ID: 配置的advanc_type + 当前品质)
local function GetConfigQuality(self)
	return self.configQuality
	
	--local advanceType = tonumber(self.config["advanc_type"])
	--return advanceType + self.quality
end

-- 是否能升星
local function CanQualityUp(self)
	if self:IsMaxQuality() then
		return false
	end
	
	local advanceType = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, "advanc_type")
	local id = advanceType + self.quality
	
	local consume1 = GetTableData(TableName.NewHeroesQuality, id, "consume1")
	local consume1NeedCount = tonumber(consume1) or 0
	if consume1NeedCount > 0 then
		local itemId = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, "poster")
		local haveCount = DataCenter.ItemData:GetItemCount(itemId)
		if haveCount < consume1NeedCount then
			return false
		end
	end
	
	local consume2 = GetTableData(TableName.NewHeroesQuality, id, "consume2")
	local consume2Spls = string.split(consume2, ";")
	if #consume2Spls == 2 then
		local consume2NeedCount = tonumber(consume2Spls[1])
		local consume2NeedRarity = tonumber(consume2Spls[2])
		local haveCount = DataCenter.ItemData:GetPosterCountByCampRarity(self.camp, consume2NeedRarity)
		if haveCount < consume2NeedCount then
			return false
		end
	end
	
	return true
end

--- 获取当前品质下的等级上限
local function GetCurMaxLevel(self)
	return self.curMaxLevel
end

--是否达到当前最大等级
local function IsReachLevelLimit(self)
	local levelLimit = self:GetCurMaxLevel()
	return self.level >= levelLimit  
end

local function GetFinalLevel(self)
	return self.finalLevel
end


---requireType, requireQuality, requireNum
---@return
local function GetAdvanceConsume(self)
	return self.advanceReq
	--local advanceReq = self.advanceReq
	--if advanceReq ~= nil then
	--	return advanceReq.conditions
	--end
end

---作为核心升阶时能否吃掉某个狗粮
---@return 
local function CanAdvanceEatOther(self, otherHeroData, requireType)
	if type(otherHeroData) ~= "table" then
		otherHeroData = DataCenter.HeroDataManager:GetHeroByUuid(otherHeroData)
	end
	--if otherHeroData.isMaster then
	--	return false
	--end
	if otherHeroData.rarity < self.rarity and otherHeroData.rarity <= HeroUtils.RarityType.A then	
		return false
	end

	--type=1: 只有同类型同品质的其他英雄才能吃
	if requireType == HeroAdvanceConsumeType.ConsumeType_Same_Hero and self.heroId ~= otherHeroData.heroId then
		return false
	end
	--type=2: 同阵营同品质的其他英雄可以吃
	if requireType == HeroAdvanceConsumeType.ConsumeType_Same_Camp and self.camp ~= otherHeroData.camp then
		return false
	end

	local requireQuality, _ = self:GetAdvanceConsume():GetConditionByType(requireType)
	
	if requireQuality == nil then
		return false
	end
	
	if otherHeroData.quality ~= requireQuality then
		return false, HeroUtils.EatForbidReason.QualityNotMatch
	end
	--type=1: 只有同类型同品质的其他英雄才能吃
	if requireType == HeroAdvanceConsumeType.ConsumeType_Same_Hero then
		return self.heroId == otherHeroData.heroId, HeroUtils.EatForbidReason.HeroIdNotMatch
	end
	--type=2: 同阵营同品质的其他英雄可以吃
	if requireType == HeroAdvanceConsumeType.ConsumeType_Same_Camp then
		return self.camp == otherHeroData.camp, HeroUtils.EatForbidReason.CampNotMatch
	end

	return false
end

---英雄是否锁定
local function IsLocked(self)
	--todo:
	return false
end

local function GetBelongFormation(self)
	-- todo:
	return nil
end

local function GetResetExp(self)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_91)
	if list == nil then
		return 0
	end
	
	table.sort(list, function(a, b)
		return tonumber(a.para) > tonumber(b.para)
	end)

	local totalExp = self.exp
	for k=1, self.level-1 do
		local exp = HeroUtils.GetLevelUpNeedExp(k)
		totalExp = totalExp + exp
	end
	
	local returnExp, maxColor, itemId = 0, -1, 0  
	for _, item in ipairs(list) do
		if returnExp >= totalExp then
			break
		end
		
		local addNum = tonumber(item.para)
		if totalExp - returnExp < addNum then
			goto continue
		end
		
		local n = (totalExp - returnExp) // addNum
		returnExp = returnExp + addNum * n

		if maxColor == -1 then
			maxColor = item.color
			itemId = item.id
		end
		
		::continue::
	end
	
	return returnExp, maxColor, itemId
end

local function GetBornDateStr(self)
	local timeStamp = 1626332742000 -- self.bornTimeStamp
	local time = timeStamp // 1000
	local format = os.date("!*t", time)
	local format_time = string.format("%d/%d/%d",format.year,format.month,format.day)
	return format_time
end

local function GetAttrByQuality(self, quality, level, rankId)
	quality = quality or self.quality
	level = level or self.level
	rankId = rankId or self.curMilitaryRankId
	
	local beyondTimes = HeroUtils.GetBeyondTimesByLevel(self.curMaxLevel)
	local heroId = self.heroId
	return HeroUtils.GetHeroAttr(heroId, quality, level, beyondTimes, rankId)

	--[[

	--走新配置格式
	local qualityAddAttack = self.config['hero_quality_attr_attack'][math.min(#self.config['hero_quality_attr_attack'], quality)]
	local qualityAddDefence = self.config['hero_quality_attr_defens'][math.min(#self.config['hero_quality_attr_defens'], quality)]

	local attack = self.config['base_attack'] + self.config['attr_attack'] * (level -1) + qualityAddAttack + self.config['special_attr_attack'] * beyondTimes
	local defence = self.config['base_defens'] + self.config['attr_defens'] * (level -1) + qualityAddDefence + self.config['special_attr_defens'] * beyondTimes
	
	local rankAtk   = GetTableData(TableName.HeroMilitaryRank, rankId, 'atk')[self.rarity]
	local rankDef   = GetTableData(TableName.HeroMilitaryRank, rankId, 'def')[self.rarity]

	if rankAtk ~= nil then
		attack = attack + rankAtk
	end

	if rankDef ~= nil then
		defence = defence + rankDef
	end
	
	return attack, defence
	--]]
end

--出征中
local function IsInMarch(self)
	return self.state == ArmyFormationState.March
end

--在编队中
local function IsInFormation(self)
	--出征中
	local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
	for id, formationData in pairs(formationList) do
		if formationData.state ~= ArmyFormationState.March then
			goto continue
		end
		
		local heroes = formationData.heroes
		if table.containsKey(heroes, self.uuid) then
			return true, formationData.index, ArmyFormationState.March
		end
		
		::continue::
	end
	
	--编队模板中
	local patternData = DataCenter.ArmyFormationDataManager:GetFormationFormDataByHeroUuid(self.uuid)
	if patternData ~= nil then
		return true, patternData.index, ArmyFormationState.Free
	end
	
	return false
end

--- 更新单个技能等级
local function UpdateSkillLevel(self, skillId, level)
    local skill = self:GetSkillData(skillId)
    skill:SetLevel(level)
end

---获取下一等级品质将解锁的技能列表
local function GetNextUnlockSkills(self)
	local level = self.level +1

	local list = {}

	for _, skill in pairs(self.skillDict) do
		if skill.level == 1 and skill.unlockHeroLv == level then
			table.insert(list, skill.skillId)
		end
	end

	return list
	
	--return self:GetUnlockSkillByQuality(nextQuality)
end

local function GetUnlockSkillByLevel(self, level)
	local list = {}

	for _, skill in pairs(self.skillDict) do
		if skill.level == 1 and skill.unlockHeroLv == level then
			table.insert(list, skill.skillId)
		end
	end

	return list
end

local function GetUnlockSkillByQuality(self, quality)
	local list = {}

	--for _, skill in pairs(self.skillDict) do
	--	if skill.level == 1 and skill.unlockQuality == quality then
	--		table.insert(list, skill.skillId)
	--	end
	--end

	return list
end

local UpgradeSkillState = {
	NoUnlockSkill       = -1, --暂无解锁技能
	AllSKillReachMax    = -2, --所有技能都已满级
	UnlockSkillReachMax = -3, --已解锁技能都已达到满级
	CanUpgrade          =  0  --可以升级
}

---是否可以升级技能
local function GetUpgradeSkillState(self)
	local unlockNum, totalLv = 0, 0
	for _, v in pairs(self.skillDict) do
		if v.level > 0 then
			unlockNum = unlockNum + 1
		end
		
		totalLv = totalLv + v.level
	end
	
	--暂无解锁技能
	if unlockNum == 0 then
		return UpgradeSkillState.NoUnlockSkill
	end

	if totalLv >= unlockNum * HeroUtils.SkillLevelLimit then
		if unlockNum == table.count(self.skillDict) then
			--所有技能都已满级
			return UpgradeSkillState.AllSKillReachMax
		end

		--已解锁技能都已达到满级
		return UpgradeSkillState.UnlockSkillReachMax
	end

	return UpgradeSkillState.CanUpgrade
end


local function GetArkTotalLevel(self)
	local totalLevel = 0
	for _, v in pairs(self.skillDict) do
		totalLevel = totalLevel + v.level
	end
	
	return totalLevel
end

---获取方舟核心id
local function GetArkIdAndGrade(self)
	--local totalLevel = 0
	--for _, v in pairs(self.skillDict) do
	--	totalLevel = totalLevel + v.level
	--end
	--
	--local lineDataList = HeroUtils.GetArkLines(self.heroId)
	--
	--local id, grade = 0, 0
	--for k, v in ipairs(lineDataList) do
	--	local condition = GetTableData(TableName.HeroArkCore, v, 'condition')
	--	if totalLevel >= condition then
	--		id = v
	--		grade = k
	--	end
	--end
	--
	--return id, grade

	local totalLevel = self:GetArkTotalLevel()
	local id, grade = HeroUtils.GetArkIdAndGrade(self.heroId, totalLevel)
	return id, grade
end

local function HandleEffect(self, effect)
	for k, v in pairs(effect) do
		local effectId = tonumber(k)
		local effectValue = tonumber(v)
		self.effectDict[effectId] = effectValue
	end
end

local function GetSkillData(self, skillId)
	if self.skillDict[skillId] == nil then
		local skillSlotIndex = table.indexof(self.skillList, skillId)
		self.skillDict[skillId] = SkillInfo.New(self, skillId, self.skillUnlockLv[skillId], self.skillLevels[skillSlotIndex])
	end
	return self.skillDict[skillId]
end

local function GetSkillLevel(self, skillId)
	local skillData = self:GetSkillData(skillId)
	if skillData ~= nil then
		return skillData:GetLevel()
	end
	
	return 0 
end

local function GetEffectNum(self,effectId)
	local num =  0
	if self.effectDict[effectId]~=nil then
		num = self.effectDict[effectId]
	end
	return num
end

local function GetName(self)
	return HeroUtils.GetHeroNameByConfigId(self.heroId)
end

---是否培养过 (等级大于1或任意技能等级大于1)
local function HasCultivated(self)
	if self.level > 1 then
		return true
	end

	for _, v in pairs(self.skillDict) do
		if v.level > 1 then
			return true
		end
	end
	
	return false
end

--是否有技能可升级 [是否可升级军阶]
local function CanUpMilitaryRank(self, ignoreGold)
	local curRankId = self:GetCurMilitaryRankId()
	local maxRankId = self:GetMaxMilitaryRankId()

	if curRankId >= maxRankId then
		return false
	end

	local requireQuality = GetTableData(TableName.HeroMilitaryRank, curRankId, 'require')[self.rarity]
	if requireQuality == nil or self.quality < requireQuality then
		return false
	end

	local costMedalId = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, 'skill_levelup_item')
	local costMedalNum = GetTableData(TableName.HeroMilitaryRank, curRankId, 'cost_medal')[self.rarity]
	local costGoldNum = GetTableData(TableName.HeroMilitaryRank, curRankId, 'cost_coin')[self.rarity]

	local item = DataCenter.ItemData:GetItemById(costMedalId)
	local medalHave = item and item.count or 0

	if medalHave < costMedalNum then
		return false
	end

	if costGoldNum <= 0 or ignoreGold then
		return true
	end

	local goldHave = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
	return goldHave >= costGoldNum
end

local function NeedBeyond(self)
	return self:IsReachBreakLimit()
end

--是否可突破 [品质、资源都满足]
local function CanBeyond(self)
	if not self:NeedBeyond() then
		return false
	end

	--check res and quality limit
	local requireQuality = 0
	local template = DataCenter.HeroLevelUpTemplateManager:GetTemplate(self.level)
	if template ~= nil then
		requireQuality = template.break_require
	end
	if self.quality < requireQuality then
		return false
	end

	local costGold = HeroUtils.GetLevelUpSpeedGold(self.level)
	local goldHave = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
	return goldHave >= costGold
end

local function NeedShowRedPoint(self)
	--只检查同id英雄中最大品阶中的最高级英雄
	--if not DataCenter.HeroDataManager:IsTheOptimalHeroInSameId(self) then
	if not self.isMaster then
		return false
	end

	--可突破的
	if self:NeedBeyond() then
		local maxLevel = HeroUtils.GetHeroCurrentMaxLevel(self.heroId, self.quality, self:GetCurMilitaryRankId())
		if self.level < maxLevel then
			return true
		end
	end

	--可升军阶
	-- 暂时屏蔽，扬骋 2023/12/18
	--if self:CanUpMilitaryRank() then
	--	return true
	--end

	if self:IsAllOpenSkillCanUpgrade() then
		return true
	end
	if self:ShowUpGradeRedPoint() then
		return true
	end
	--插件红点
	if self:IsPluginRedDot() and self:IsInFormation() then
		return true
	end
	--if self:ShowAdvanceRedPoint() then
	--	return true
	--end
	--阵营红点
	if self:IsCampRedDot() then
		return true
	end
	return false
end

local function HeroBookRedPoint(self)
	if LuaEntry.DataConfig:CheckSwitch("hero_background") then
		local curRankId = self:GetCurMilitaryRankId()
		local maxRankId = self:GetMaxMilitaryRankId()
		local level = tonumber(GetTableData(TableName. HeroMilitaryRank, curRankId, "level"))
		local stage = tonumber(GetTableData(TableName. HeroMilitaryRank, curRankId, "stage"))
		for i = 1 , self.heroStoryCount do
			local isGetBox  = self:GetBackStoryRewarDict(i)
			if (not isGetBox) and i <= level then
				return true
			end
		end
	end
	return false
end

--是否达到突破限制
local function IsReachBreakLimit(self)
	--local maxExp = HeroUtils.GetLevelUpNeedExp(self.level)
	local needBreak = self.level == self.curMaxLevel and self.level < self.finalLevel
	return needBreak
end

local function GetCurMilitaryRankId(self)
	return self.curMilitaryRankId
end

local function GetMaxMilitaryRankId(self)
	return self.maxMilitaryRankId
end

--当前英雄是否达到军阶最大等级
local function IsReachMaxMilitaryRank(self)
	return self.curMilitaryRankId >= self.maxMilitaryRankId
end

local function IsSkillCanUpgrade(self, skillId)
	return false
	--if not self:IsSkillUnlock(skillId) then
	--	return false
	--end
	--local skillData = self.skillDict[skillId]
	--if skillData == nil then
	--	return false
	--end
	--local costMedalNum = self.config["skill_levelup_num"]
	--return skillData.level <= table.count(costMedalNum) and self.level >= skillData.unlockHeroLv
end

local function IsSkillUnlock(self, skillId)
	local skillData = self:GetSkillData(skillId)
	return skillData.level > 0 
	--return self.level >= skillData.unlockHeroLv
end

local function GetUpgradeCostResType()
	local cost = LuaEntry.DataConfig:TryGetStr("hero_cost_item", "k1")
	if not string.IsNullOrEmpty(cost) then
		local vec = string.split(cost, ";")
		if #vec >= 2 then
			local type = tonumber(vec[1])
			local itemId = tonumber(vec[2])
			return RewardToResType[type], itemId
		end
	end
end

--是否可以直升一级
local function IsCanLevelUp(self)
	if self:IsReachBreakLimit() == false and self:IsReachLevelLimit() == false then
		local needMainLv = tonumber(GetTableData(TableName.NewHeroesLevelUp, self.level + 1, "levelup_require_base")) or 0
		if DataCenter.BuildManager.MainLv >= needMainLv then
			local needExp = HeroUtils.GetLevelUpNeedExp(self.level) - self.exp
			local haveNum = 0
			local type, itemId = self:GetUpgradeCostResType()
			if type == RewardType.GOODS then
				haveNum = DataCenter.ItemData:GetItemCount(itemId)
			else
				haveNum = LuaEntry.Resource:GetCntByResType(type)
			end
			return haveNum >= needExp
			--[[local items = DataCenter.ItemData:GetHeroExpItem()
			if items ~= nil then
				local total = 0
				for k, v in ipairs(items) do
					total = total + v.addNum * v.item.count
					if total >= needExp then
						return true
					end
				end
			end]]
		end
	end
	return false
end

local function IsWakeUp(self)
	if self.rarity == HeroUtils.RarityType.S then
		local skillState = self:GetUpgradeSkillState()
		return skillState == UpgradeSkillState.AllSKillReachMax and self:IsMaxQuality()
		--return self:IsReachMaxMilitaryRank() and self:IsMaxQuality()
	end
	return false
end

local function GetSkillPower(self)
	local result = 0
	table.walk(self.skillDict, function (k, v)
		if self:IsSkillUnlock(k) then
			local strPos = GetTableData(TableName.SkillTab, k, 'power')
			if not string.IsNullOrEmpty(strPos) then
				local vec = string.split(strPos, "|")
				if table.count(vec) >= v.level then
					result = result + toInt(vec[v.level])
				end
			end
		end
	end)
	return result
end

local function GetAllWearEquipPower(self)
	return DataCenter.HeroEquipManager:GetAllEquipPower(self.heroId)
end

local function IsAllOpenSkillCanUpgrade(self)
	local needNum = 0
	local costMedalId = self.config["skill_levelup_item"]
	local costMedalNum = self.config["skill_levelup_num"]
	local currentNum = DataCenter.ItemData:GetItemCount(costMedalId)

	table.walk(self.skillDict, function (k, v)
		if self:IsSkillCanUpgrade(k) then
			local itemNeed = costMedalNum[v.level]
			if needNum < itemNeed then
				needNum = itemNeed
			end
		end
	end)
	return needNum <= currentNum and needNum > 0
end

local function CanEtoileUp(self)
	if self:IsEtoileMax() then
		return false
	end
	
	return HeroUtils.IsHeroEtoileUpItemEnough(self.uuid)
end

local function IsEtoileMax(self)
	local curRankId = self:GetCurMilitaryRankId()
	local maxRankId = self:GetMaxMilitaryRankId()
	return curRankId >= maxRankId
end

local function ShowAdvanceRedPoint(self, canAdvance)
	if canAdvance == nil then
		canAdvance = HeroAdvanceController:GetInstance():HasFullDogForCore(self)
	end
	if not canAdvance then
		return false
	end
	if self.quality <= 2 then
		return true
	end
	if self.rarity == HeroUtils.RarityType.S or self.rarity == HeroUtils.RarityType.A then
		local eat = self:GetAdvanceConsume()
		if eat:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero) ~= nil then
			return true
		end
	end
	local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
	if build == nil or build.level == 0 then
		local maxQuality = DataCenter.HeroDataManager:GetHeroMaxQuality()
		return self.quality >= maxQuality
	end
	local inFormation, index = self:IsInFormation()
	if inFormation and index == 1 then
		return true
	end
	return false
end

local function ShowUpGradeRedPoint(self)
	--local flag = false
	--local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
	--if build == nil or build.level == 0 then
	--	flag = true
	--end
	--if not flag then
	--	flag = self:IsInFormation()
	--end
	local inFormation, index = self:IsInFormation()
	--if inFormation and index == 1 then
	--	return true
	--end

	if inFormation and index == 1 then
		local _, upgrade = HeroUtils.GetHeroSkillAndUpgradeRedPointLevelCondition()
		if upgrade > DataCenter.BuildManager.MainLv then
			local maxLevel = HeroUtils.GetHeroCurrentMaxLevel(self.heroId, self.quality, self:GetCurMilitaryRankId())
			if self.level < maxLevel then
				local totalExp = HeroUtils.GetLevelUpNeedExp(self.level)
				local curExp = self.exp
				local needExp = totalExp - curExp
				local items = DataCenter.ItemData:GetHeroExpItem()
				if items ~= nil then
					local total = 0
					for k, v in ipairs(items) do
						total = total + v.addNum * v.item.count
						if total >= needExp then
							return true
						end
					end
				end
			end
		end
	end
	return false
end
--插件是否可以显示红点
function HeroInfo:IsPluginRedDot()
	if (self.plugin == nil or self.plugin.lv == 0) and DataCenter.HeroPluginManager:IsUnlock(self.camp, self.uuid) then
		return true
	end
	return false
end

--获取插件锁定的数量
function HeroInfo:GetLockPluginNum()
	if self.plugin ~= nil then
		return self.plugin:GetLockPluginNum()
	end
	return 0
end

--获取插件锁定的数量
function HeroInfo:GetPluginNum()
	if self.plugin ~= nil then
		return self.plugin:GetPluginNum()
	end
	return 0
end

--是否可以显示阵营红点
function HeroInfo:IsCampRedDot()
	if self.camp == HeroCamp.NEW_HUMAN and self.chooseCamp == HeroCamp.NEW_HUMAN then
		if DataCenter.HeroPluginManager:IsOpenSwitchCamp() then
			if self.canShowCampRed == CampRedState.None then
				self.canShowCampRed = Setting:GetPrivateInt(SettingKeys.HeroCampRed .. self.uuid, CampRedState.Show)
			end
			return self.canShowCampRed == CampRedState.Show
		end
	end
	return false
end

--设置不显示阵营红点
function HeroInfo:SetCampNoRedDot()
	if self.canShowCampRed ~= CampRedState.No then
		self.canShowCampRed = CampRedState.No
		Setting:SetPrivateInt(SettingKeys.HeroCampRed .. self.uuid, self.canShowCampRed)
		EventManager:GetInstance():Broadcast(EventId.RefreshHeroCampRed, self.uuid)
	end
end

local function GetHeroProperty(self,propertyType)
	if self.propertyData == nil then
		return 0
	end
	return self.propertyData:GetProperty(propertyType)
end

--获取所有解锁技能（除大招外
local function GetAllUnlockSkillsExcludeUltimate(self)
	local list = {}
	for _, v in pairs(self.skillDict) do
		if v.isUnlocked and v:GetSlotIndex() ~= ULTIMATE_SKILL_SLOT_INDEX then--index=2表示大招
			table.insert(list, v)
		end
	end
	return list
end
--获取大招
local function GetUltimateSkill(self)
	return self:GetHeroSkillBySlotIndex(ULTIMATE_SKILL_SLOT_INDEX)--index=2表示大招
end

local function GetAllSkills(self)
	return DeepCopy(self.skillDict)
end

local function GetAllUnlockSkills(self)
	local ret={}
	for _,v in pairs(self.skillDict) do
		if v.isUnlocked then
			table.insert(ret,v)
		end
	end
	return ret
end

local function GetHeroSkillBySlotIndex(self,slotIndex)
	local skillId = self.skillList and self.skillList[slotIndex]
	if skillId then
		return self.skillDict[skillId]
	end
	return nil
end

local function GetMaxHp(self)
	-- 英雄最大血量用统领数显示
	return math.floor(self:GetHeroProperty(HeroEffectDefine. HealPoint_Result))
end

local function GetAtk(self)
	return math.floor(self:GetHeroProperty(HeroEffectDefine.PhysicalAttack_Result))
end

local function GetDef(self)
	return math.floor(self:GetHeroProperty(HeroEffectDefine.PhysicalDefense_Result))
end

local function GetSoldierCapacity(self)
	return math.floor(self:GetHeroProperty(HeroEffectDefine.HeroSoldierCapacity))
end

local function UpdateFromTemplate(self,templateId,level,rank,skillLevel)
	-- self.isTemplate = true
	local heroTemplate = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), templateId)
	if heroTemplate == nil then
		Logger.LogError("HeroInfo UpdateFromTemplate error templateId: " .. templateId)
		return false
	end

	self.uuid = 0
	self.heroId = templateId
	self.camp = heroTemplate.camp
	self.heroType = heroTemplate.camp -- LW
	--self.heroJob = heroTemplate.job
	self.config = heroTemplate
	self.meta = heroTemplate -- LW
	self.exp = 0
	self.level = level or 1
	self.quality = heroTemplate.quality
	self.finalLevel = 100
	self.maxRank = heroTemplate.maxRank
	self.rank = 1
	self.firstName = heroTemplate.name
	self.nickName = heroTemplate.nickName
	self.modelId = heroTemplate.appearance
	self.maxHonorLevel = heroTemplate.maxHonorLevel
	self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
	if self.appearanceMeta == nil then
		Logger.LogError('hero appearance not found! appearance:' .. self.modelId)
		self.modelId = 10001
		self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.modelId)
	end
	self.fragId = heroTemplate.fragId
	self.propertyTemplateType = heroTemplate.propertyTemplateType
	self.honourLevel = 0

	--- 英雄属性
	if self.propertyData == nil then
		self.propertyData = HeroPropertyData.New()
	else
		self.propertyData:Clear()
	end

	-- 从表中读值
	--local property = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateByTypeAndLevel(self.propertyTemplateType,
	--		self.level, heroTemplate.hpFactor, heroTemplate.atkFactor, heroTemplate.defFactor,heroTemplate.accFactor,heroTemplate.critFactor)
	--for k, v in pairs(property) do
	--	local effectId = tonumber(k)
	--	local effectValue = tonumber(v)
	--	self.propertyData:SetProperty(effectId, effectValue)
	--end

	--- 考虑军阶后对部分属性重新计算

	--local attrRatio = self.rankTemplate:GetEffectRatio()
	----- 血量 (英雄等级+军衔附加+荣誉等级附加)*军衔属性系数*hero表参数
	--local hp = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateHp(self.propertyTemplateType, self.level)
	--local rankAddHp = self.rankTemplate:GetAddEffect(HeroEffectDefine.HealthPoint)
	--hp = (hp + rankAddHp) * attrRatio * heroTemplate.hpFactor
	--self.propertyData:SetProperty(HeroEffectDefine.HealthPoint, hp)
	--
	----- 攻击 (英雄等级+军衔附加)*军衔属性系数*hero表参数
	--local atk = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateAtk(self.propertyTemplateType, self.level)
	--local rankAddAtk = self.rankTemplate:GetAddEffect(HeroEffectDefine.PhysicalAttack)
	--atk = (atk + rankAddAtk) * attrRatio * heroTemplate.atkFactor
	--self.propertyData:SetProperty(HeroEffectDefine.PhysicalAttack, atk)
	--
	----- 防御 (英雄等级+军衔附加)*军衔属性系数*hero表参数
	--local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateDef(self.propertyTemplateType, self.level)
	--local rankAddDef = self.rankTemplate:GetAddEffect(HeroEffectDefine.PhysicalDefense)
	--def = (def + rankAddDef) * attrRatio * heroTemplate.defFactor
	--self.propertyData:SetProperty(HeroEffectDefine.PhysicalDefense, def)
	--
	---- 暴击伤害是读表的
	--local critDamage = DataCenter.HeroParamDataManager.defaultCriticialDamage
	--self.propertyData:SetProperty(HeroEffectDefine.CriticalDamage_Result,critDamage)

	--- 英雄技能
	if self.skillDict == nil then
		self:UpdateHeroSkill()
	end

	self.fromTemplate = true
	return true
end

local function UpdateHeroSkill(self)
	self.skillDict = {}
	self.skillList = {}
	self.skillUnlockLv = {}

	local skillArray = HeroUtils.GetHeroSkillList(self.heroId, self:GetCurMilitaryRankId())
	local unlockConditionArray = self.config['skill_unlock']
	--兼容旧配置格式
	if type(skillArray) ~= 'table' then
		skillArray = string.split(skillArray, '|')
		unlockConditionArray = string.split(unlockConditionArray, '|')
	end

	for k=1, #skillArray do
		local skillId = tonumber(skillArray[k])
		local unlockHeroLv = tonumber(unlockConditionArray[k])
		local level = 0
		if self.skillLevels then
			level = self.skillLevels[k] or 0
		end
		local skillData = SkillInfo.New(self, skillId, unlockHeroLv, level)

		self.skillList[k] = skillId
		self.skillDict[skillId] = skillData
		self.skillUnlockLv[skillId] = unlockHeroLv
	end
end

function HeroInfo:HasEquipInstall()
	local has = false
	for i = 1, HeroEquipConst.EquipSlot do
		local red = DataCenter.HeroEquipManager:PosHasRedDot(self.heroId, i)
		if red then
			return true
		end
	end
	return has
end

function HeroInfo:GetLevelUnlockSkill()
	local newUnlockSkills = {}
	for slotIndex, skillId in ipairs(self.skillList) do
		local skillData = self.skillDict[skillId]
		if skillData:IsUnlock() then
			local skillUnlockRank = HeroUtils.GetSkillLevelNeedRankId(self.rarity, slotIndex, 1)
			if self.level == skillData.unlockHeroLv and self.curMilitaryRankId >= skillUnlockRank then
				table.insert(newUnlockSkills,skillData)
			end
		end
	end
	return newUnlockSkills
end

function HeroInfo:GetRankUnlockSkill()
	local newUnlockSkills = {}
	for slotIndex, skillId in ipairs(self.skillList) do
		local skillData = self.skillDict[skillId]
		if skillData:IsUnlock() then
			local skillUnlockRank = HeroUtils.GetSkillLevelNeedRankId(self.rarity, slotIndex, 1)
			if self.curMilitaryRankId == skillUnlockRank and self.level >= skillData.unlockHeroLv then
				table.insert(newUnlockSkills,skillData)
			end
		end
	end
	return newUnlockSkills
end

function HeroInfo:GetK1()
	if self.k1 then
		return self.k1
	end
	self.k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
	return self.k1
end

function HeroInfo:GetK5()
	if self.k5 then
		return self.k5
	end
	self.k5 = LuaEntry.DataConfig:TryGetNum("power_setting", "k5")
	self.k5 = self.k5 > 0 and self.k5 or 1
	return self.k5
end

function HeroInfo:GetPower()
	local k1 = self:GetK1()
	local k5 = self:GetK5()
	local skillPower = self:GetSkillPower()
	local equipPower = self:GetAllWearEquipPower()
	local power = Mathf.Round((self.atk + self.def) ^ k5 * k1) + skillPower + equipPower
	return power
end

HeroInfo.__init = __init
HeroInfo.__delete = __delete
HeroInfo.UpdateInfo = UpdateInfo
HeroInfo.UpdateHeroSkill = UpdateHeroSkill
HeroInfo.GetConfig = GetConfig
HeroInfo.GetCamp = GetCamp
HeroInfo.GetMaxQuality = GetMaxQuality
HeroInfo.IsMaxQuality = IsMaxQuality
HeroInfo.GetConfigQuality = GetConfigQuality
HeroInfo.CanQualityUp = CanQualityUp
HeroInfo.GetCurMaxLevel = GetCurMaxLevel
HeroInfo.IsReachLevelLimit = IsReachLevelLimit
HeroInfo.GetFinalLevel = GetFinalLevel

HeroInfo.GetAdvanceConsume = GetAdvanceConsume
HeroInfo.CanAdvanceEatOther = CanAdvanceEatOther
HeroInfo.IsLocked = IsLocked
HeroInfo.GetBelongFormation = GetBelongFormation
HeroInfo.GetResetExp = GetResetExp
HeroInfo.GetLvUpChangedAttr = GetLvUpChangedAttr
HeroInfo.GetBornDateStr = GetBornDateStr
HeroInfo.GetAttrByQuality = GetAttrByQuality
HeroInfo.IsInMarch = IsInMarch
HeroInfo.IsInFormation = IsInFormation
HeroInfo.UpdateSkillLevel = UpdateSkillLevel
HeroInfo.GetNextUnlockSkills = GetNextUnlockSkills
HeroInfo.GetUnlockSkillByQuality = GetUnlockSkillByQuality
HeroInfo.UpgradeSkillState = UpgradeSkillState
HeroInfo.GetUpgradeSkillState = GetUpgradeSkillState
HeroInfo.SetUpSkillNum = SetUpSkillNum

HeroInfo.GetArkTotalLevel = GetArkTotalLevel
HeroInfo.GetArkIdAndGrade = GetArkIdAndGrade

HeroInfo.HandleEffect = HandleEffect
HeroInfo.GetSkillData = GetSkillData
HeroInfo.GetSkillLevel = GetSkillLevel
HeroInfo.GetEffectNum = GetEffectNum
HeroInfo.GetName = GetName
HeroInfo.HasCultivated = HasCultivated
HeroInfo.IsReachBreakLimit = IsReachBreakLimit

HeroInfo.NeedShowRedPoint = NeedShowRedPoint
HeroInfo.HeroBookRedPoint = HeroBookRedPoint
HeroInfo.CanUpMilitaryRank = CanUpMilitaryRank
HeroInfo.CanBeyond = CanBeyond
HeroInfo.NeedBeyond = NeedBeyond

HeroInfo.GetCurMilitaryRankId = GetCurMilitaryRankId
HeroInfo.GetMaxMilitaryRankId = GetMaxMilitaryRankId
HeroInfo.IsReachMaxMilitaryRank = IsReachMaxMilitaryRank
HeroInfo.IsSkillUnlock = IsSkillUnlock
HeroInfo.IsCanLevelUp = IsCanLevelUp
HeroInfo.IsWakeUp = IsWakeUp
HeroInfo.GetUnlockSkillByLevel = GetUnlockSkillByLevel
HeroInfo.IsSkillCanUpgrade = IsSkillCanUpgrade
HeroInfo.GetSkillPower = GetSkillPower
HeroInfo.GetAllWearEquipPower = GetAllWearEquipPower
HeroInfo.IsAllOpenSkillCanUpgrade = IsAllOpenSkillCanUpgrade

HeroInfo.ShowUpGradeRedPoint = ShowUpGradeRedPoint
HeroInfo.ShowAdvanceRedPoint = ShowAdvanceRedPoint

HeroInfo.CanEtoileUp = CanEtoileUp
HeroInfo.IsEtoileMax = IsEtoileMax

-- LW PVE
HeroInfo.GetHeroProperty = GetHeroProperty
HeroInfo.GetAllUnlockSkillsExcludeUltimate = GetAllUnlockSkillsExcludeUltimate
HeroInfo.GetUltimateSkill = GetUltimateSkill
HeroInfo.GetAllSkills = GetAllSkills
HeroInfo.GetAllUnlockSkills = GetAllUnlockSkills
HeroInfo.GetHeroSkillBySlotIndex = GetHeroSkillBySlotIndex
HeroInfo.GetMaxHp = GetMaxHp
HeroInfo.GetAtk = GetAtk
HeroInfo.GetDef = GetDef
HeroInfo.GetSoldierCapacity = GetSoldierCapacity
HeroInfo.UpdateFromTemplate = UpdateFromTemplate
HeroInfo.UpdateBackStoryRewarDict = UpdateBackStoryRewarDict
HeroInfo.GetBackStoryRewarDict = GetBackStoryRewarDict
HeroInfo.GetUpgradeCostResType = GetUpgradeCostResType

-- LW PVE end

return HeroInfo