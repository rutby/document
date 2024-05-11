local HeroDataManager = BaseClass("HeroDataManager")
local Localization = CS.GameEntry.Localization
local HeroInfo = require "DataCenter.HeroData.HeroInfo"
local function __init(self)
	self.inited = false
	self.allHero = {} 				--存uuid和heroInfo
	self.typeHeroes = {}			--key:heroId, value: List<HeroData>
	self.heroesHistory = {}			--图鉴记录
	self.newHeroTags = {}			--新英雄标识
	self.masterQuality = {}
	self.remindList = {}  --提醒记录 value: uuid+remindFlag
	self.remindMarked = false
	self.maxLevel = -1 -- 当前英雄的最高等级
	self.lastSeasonHero = nil
	self.masterHero = {}--为了性能，保存主英雄 <heroId， 存uuid和heroInfo>
	self.displayedHeroIds = {}
end

local function __delete(self)
	self.typeHeroes = {}			--key:heroId, value: List<HeroData>
	self.inited = nil
	self.allHero = {}
	self.heroesHistory = {}
	self.newHeroTags = nil
	self.masterQuality = nil
	self.maxLevel = nil
	self.lastSeasonHero = nil
	self.masterHero = {}--为了性能，保存主英雄
	self.displayedHeroIds = {}
end

--初始化英雄信息
local function InitData(self,message)
	self.inited = false
	--招募历史记录
	self.heroesHistory = message['digHeroesHistory']
	
	if message["userHero"] ~= nil then
		self.allHero = {}
		self.masterQuality = {}
		self.typeHeroes = {}
		self.masterHero = {}
		self:UpdateHeroes(message["userHero"])
		print("#zlh# hero.count:" .. table.count(self.allHero))
		--if SceneUtils.GetIsInPve() then
		--	DataCenter.BattleLevel:UpdateHireHeroData()
		--end
	else
		print("#zlh# heroes is nil")
	end
	

	--记录下每个英雄的最大品质
	
	self.inited = true
end

--更新一组英雄
local function UpdateHeroes(self, array)
	if array ~= nil then
		for k,v in pairs(array) do
			self:UpdateOneHero(v)
		end
	end
end

--更新一个英雄
local function UpdateOneHero(self, message)
	if message == nil then
		return
	end

	local uuid = message["uuid"] or message['heroUuid']
	if uuid == nil then
		return false
	end

	local one = self:GetHeroByUuid(uuid)
	if one ~= nil then
		one:UpdateInfo(message)
	else
		one = HeroInfo.New()
		one:UpdateInfo(message)
		self.allHero[uuid] = one

		if self.inited then
			if not table.hasvalue(self.heroesHistory, tonumber(one.heroId)) then
				table.insert(self.heroesHistory, tonumber(one.heroId))

				self:AddNewHeroTag(uuid)
				if self.inited then
					self.remindMarked = false
				end
			end
		end

		if self.typeHeroes[one.heroId] == nil then
			self.typeHeroes[one.heroId] = {one}
		else
			table.insert(self.typeHeroes[one.heroId], one)
		end
		if one.isMaster then
			self.masterHero[one.heroId] = one
		end
	end
	self.maxLevel = math.max(self.maxLevel, one.level)
end

local function AddOneHero(self, data)
	self.allHero[data.uuid] = data
	
	if self.typeHeroes[data.heroId] == nil then
		self.typeHeroes[data.heroId] = { data }
	else
		table.insert(self.typeHeroes[data.heroId], data)
	end
	if data.isMaster then
		self.masterHero[data.heroId] = data
	end
end

--通过uuid删除一个英雄
local function RemoveOneHeroByUuid(self,uuid)
	local hero = self.allHero[uuid]
	if hero ~= nil then
		if self.typeHeroes[hero.heroId] ~= nil then
			for k,v in ipairs(self.typeHeroes[hero.heroId]) do
				if v == hero then
					table.remove(self.typeHeroes[hero.heroId], k)
					break
				end
			end
		end
		self.allHero[uuid] = nil
		if hero.isMaster then
			self.masterHero[hero.heroId] = nil
		end
	end
end

local function RemoveHeroes(self, heroUuids)
	for _, uuid in pairs(heroUuids) do
		self:RemoveOneHeroByUuid(uuid)
	end
end

--通过uuid获取英雄信息
local function GetHeroByUuid(self,uuid)
	if uuid == HireHeroUuid then
		return HeroUtils.GetHireHeroData()
	end
	return self.allHero[uuid]
end

local function GetHeroById(self, heroId)
	return self.masterHero[heroId]
end

local function GetHeroPostersById(self, heroId)
	local result = {}
	local list = self.typeHeroes[heroId]
	if list ~= nil then
		for _, v in ipairs(list) do
			if not v.isMaster then
				table.insert(result, v)
			end
		end
	end
	
	return result
end

function HeroDataManager:GetAllHeroListByHeroId(heroId)
	return self.typeHeroes[heroId]
end

--此英雄是否同id的最佳英雄, 如果不是返回最佳英雄uuid
local function IsTheOptimalHeroInSameId(self, heroData)
	if heroData.isMaster then
		return true, heroData.uuid
	end
	
	local optimal = 0
	local data = self:GetHeroById(heroData.heroId)
	if data ~= nil then
		optimal = data.uuid
	end

	return false, optimal
end

-- 通过heroId获取heroUUID
function HeroDataManager:GetHeroUuidByHeroId(heroId)
	local data = self:GetHeroById(tonumber(heroId))
	if data ~= nil then
		return data.uuid
	end
	
	return 0
end

--慎用，数据爆炸 一般需求用GetMasterHeroList
local function GetAllHeroList(self)
	return self.allHero
end

function HeroDataManager:GetMasterHeroList()
	return table.values(self.masterHero)
end

--根据等级排序英雄
function HeroDataManager:GetHeroSortList()
	local result = self:GetMasterHeroList()
	if result[2] ~= nil then
		local campA = nil
		local campB = nil
		table.sort(result, function(heroA,heroB)
			if heroA.level ~= heroB.level then
				return heroA.level > heroB.level
			end

			if heroA.quality ~= heroB.quality then
				return heroA.quality > heroB.quality
			end
			campA = heroA:GetCamp()
			campB = heroB:GetCamp()
			if campA ~= campB then
				return campA < campB
			end
			return heroA.heroId < heroB.heroId
		end)
	end
	return result
end
--根据稀有度排序英雄
function HeroDataManager:GetAllHeroBySort()
	local result = self:GetMasterHeroList()
	if result[2] ~= nil then
		local campA = nil
		local campB = nil
		table.sort(result, function(heroA,heroB)
			if heroA.rarity ~= heroB.rarity then
				return heroA.rarity < heroB.rarity
			end
			if heroA.level ~= heroB.level then
				return heroA.level > heroB.level
			end

			if heroA.quality ~= heroB.quality then
				return heroA.quality > heroB.quality
			end
			campA = heroA:GetCamp()
			campB = heroB:GetCamp()
			if campA ~= campB then
				return campA < campB
			end
			return heroA.heroId < heroB.heroId
		end)
	end
	return result
end

--根据稀有度排序阵营英雄
function HeroDataManager:GetAllHeroByCampAndSort(campType, isSort)
	local result = {}
	local list = self:GetMasterHeroList()
	if list[1] ~= nil then
		for k, v in ipairs(list) do
			if v:GetCamp() == campType or campType == HeroCamp.All then
				table.insert(result, v)
			end
		end
	end
	if isSort then
		if #result > 0 then
			table.sort(result, function(heroA,heroB)
				if heroA.rarity ~= heroB.rarity then
					return heroA.rarity < heroB.rarity
				end
				if heroA.level ~= heroB.level then
					return heroA.level > heroB.level
				end

				if heroA.quality ~= heroB.quality then
					return heroA.quality > heroB.quality
				end

				return heroA.heroId < heroB.heroId
			end)
		end
	end
	return result
end

--获取解锁插件的最高战力英雄
function HeroDataManager:GetAllHeroByPowerSortAndPlugin()
	--按战力排序
	local result = self:GetMasterHeroList()
	if result[2] ~= nil then
		table.sort(result, function(heroA,heroB)
			local heroAPower = HeroUtils.GetHeroPower(heroA)
			local heroBPower = HeroUtils.GetHeroPower(heroB)
			if heroAPower > heroBPower then
				return true
			end
			return false
		end)
		local campType = nil
		for k,v in ipairs(result) do
			campType = GetTableData(HeroUtils.GetHeroXmlName(), v.heroId, "camp")
			if DataCenter.HeroPluginManager:IsUnlock(campType, v.uuid) then
				return v
			end
		end
		return result[1]
	end
	return nil
end

local function GetHeroListForCollect(self)
	--只筛选带采集标签的英雄上阵
	local list = self:GetMasterHeroList()
	if list[2] ~= nil then
		local campA = nil
		local campB = nil
		table.sort(list, function(a, b)
			if a.rarity ~= b.rarity then
				return a.rarity < b.rarity
			end
			if a.level ~= b.level then
				return b.level < a.level
			end
			if a.quality ~= b.quality then
				return b.quality < a.quality
			end
			campA = a:GetCamp()
			campB = b:GetCamp()
			if campA ~= campB then
				return campA < campB
			end
			return a.heroId < b.heroId
		end)
	end
	local collectHeroList = {}
	local otherHeroList = {}
	if list[1] ~= nil then
		for k,v in ipairs(list) do
			local id = v.heroId
			local tags = HeroUtils.GetTagsByHeroId(id)
			local isCollectHero = false
			for a,b in pairs(tags) do
				if b == 13 then --采集类英雄
					isCollectHero = true
				end
			end
			if isCollectHero or v.rarity>=3 then
				if collectHeroList[v.heroId] == nil then
					collectHeroList[v.heroId] = v
				end
			else
				if otherHeroList[v.heroId] == nil then
					otherHeroList[v.heroId] = v
				end
			end
		end
	end
	
	return collectHeroList,otherHeroList
end

local function GetHeroIdListInMarch(self)
	local heroIdList = {}
	for k,v in pairs(self.masterHero) do
		if v.state == ArmyFormationState.March then
			heroIdList[v.heroId] =1
		end
	end
	return heroIdList
end




local function IsInHistory(self, heroId)
	heroId = tonumber(heroId)
	if 	self.heroesHistory == nil then
		return false
	end
	
	return table.hasvalue(self.heroesHistory, heroId)
end

local function AddNewHeroTag(self, newHeroUuid)
	if not table.hasvalue(self.newHeroTags, newHeroUuid) then
		table.insert(self.newHeroTags, newHeroUuid)
	end
end

local function RemoveNewHeroTag(self, newHeroUuid)
	if newHeroUuid then
		table.removebyvalue(self.newHeroTags, newHeroUuid)
	end
end

local function ClearNewHeroTags(self)
	self.newHeroTags = {}
end

local function IsNewHero(self, heroUuid)
	return table.hasvalue(self.newHeroTags, heroUuid)
end

-- 废弃了，使用 ShowHeroRed
local function GetHeroRedNum(self)
	self:RebuildRemindList()
	local needRemind = #self.remindList > 0
	return needRemind and 1 or 0
end

local function ShowHeroRed(self)
	for _, heroData in pairs(self.allHero) do
		if heroData.isMaster and (heroData:CanUpMilitaryRank() or heroData:HeroBookRedPoint()) then
			return true
		end
	end

	local hasBuilding = DataCenter.BuildManager:HasBuilding(BuildingTypes.APS_BUILD_PUB)
	if hasBuilding then
		if DataCenter.LotteryDataManager:HaveFree() or DataCenter.LotteryDataManager:CanAnyMultiRecruit() then
			return true
		end
	end
	
	return false
end

local function MarkHeroRedPoint(self)
	self.remindMarked = true
end

local RemindFlag = 
{
	NewHero = 1,
	CanBeyond = 2,
	CanUpMilitaryRank = 3,
	CanSkillUpgrade = 4,
	ShowUpgrade = 5,
	Advance = 6,
	Camp = 7,
}

local function RebuildRemindList(self)
	local list = {}

	for _, uuid in pairs(self.newHeroTags) do
		local value = uuid .. RemindFlag.NewHero
		table.insert(list, value)

		--如果是marked的状态 检查是否有新的变化
		if self.remindMarked and not table.hasvalue(self.remindList, value) then
			self.remindMarked = false
		end
	end
	local upgradeSkillFlag = false
	for uuid, heroData in pairs(self.allHero) do
		--突破和技能升级提醒只针对同id的最佳英雄
		--if not self:IsTheOptimalHeroInSameId(heroData) then
		if not heroData.isMaster then
			goto continue
		end

		local canUpRank = heroData:CanUpMilitaryRank()
		if canUpRank then
			local value = uuid .. RemindFlag.CanUpMilitaryRank
			table.insert(list, value)
			upgradeSkillFlag = true
			break
		end
		
		local advance = heroData:CanQualityUp()
		if advance then
			local value = uuid .. RemindFlag.Advance
			table.insert(list, value)
			upgradeSkillFlag = true
			break
		end
		::continue::
	end
	if upgradeSkillFlag then
		self.remindMarked = false
	end
	self.remindList = list
end

local function GetFreeAddTimeHero(self,type)
	--道恩 22001  军师  11001
	local heroId = DataCenter.HeroEffectSkillManager:GetHeroByEffectId(type)
	local data = self:GetHeroById(heroId)
	if data ~= nil then
		local unlock = true
		local skillData = data:GetSkillData(data.skillList[2])
		if skillData ~= nil then
			unlock = data:IsSkillUnlock(data.skillList[2])
			if unlock then
				return data
			end
		end
	end

	return nil
end

local function BeyondHero(self, heroUuid)
	local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
	local maxLevel = HeroUtils.GetHeroCurrentMaxLevel(heroData.heroId, heroData.quality, heroData:GetCurMilitaryRankId())

	if heroData.level >= maxLevel then
		local name = Localization:GetString(heroData.config["name"])
		local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(heroData.rarity), name)
		local str = ""

		if HeroUtils.IsUseMainLvMaxLevel() then
			local needLv = DataCenter.HeroLevelUpTemplateManager:GetNeedMainLv()
			str = Localization:GetString(GameDialogDefine.HERO_UPGRADE_MAX_LEVEL_NEED_MAIN_LEVEL_TIP, heroName, needLv)
		elseif HeroUtils.IsNewMaxLevel() then
			local rankId = HeroUtils.GetNextMaxLevelByRankId(heroData.heroId, heroData:GetCurMilitaryRankId(), heroData.level)
			local rankName = GetTableData(TableName.HeroMilitaryRank, rankId, "name")
			str = Localization:GetString("129287", heroName, Localization:GetString(rankName))
		else
			local star =  HeroUtils.GetNextMaxLevelByQuality(heroData.heroId, heroData.quality, heroData.level)
			if star <= 0 then
				return
			end
			star = Mathf.Round((star - 1) / 2)
			str = Localization:GetString("129232", heroName, tostring(star))
		end
		UIUtil.ShowMessage(str, 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
			if HeroUtils.IsUseMainLvMaxLevel() then
				GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
			elseif HeroUtils.IsNewMaxLevel() then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMilitaryRank, heroUuid)
			else
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance, heroUuid)
			end
		end)
		return
	end

	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBeyond, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, heroUuid)
end

local function GetHighestHeroLevel(self)
	return self.maxLevel
end

local function HasBeyondHero(self)
	local result = false
	for _, v in pairs(self.masterHero) do
		if v ~= nil and v:NeedBeyond() then
			result = true
			break
		end
	end
	return result
end

local function GetMasterQuality(self, heroId)
	if self.masterQuality == nil then
		self.masterQuality = {}
	end
	if self.masterQuality[heroId] ~= nil then
		return self.masterQuality[heroId]
	end
	local data = self:GetHeroById(heroId)
	if data ~= nil then
		self.masterQuality[heroId] = data.quality
	end
	if self.masterQuality[heroId] ~= nil then
		return self.masterQuality[heroId]
	end
	return 1
end

local function SetMasterQuality(self, heroId, quality)
	if self.masterQuality == nil then
		self.masterQuality = {}
	end
	self.masterQuality[heroId] = quality
end

local function NeedShowNewHeroWindow(self, heroUuid)
	local showFlag = false
	if DataCenter.GuideManager:InGuide() then
		showFlag = true
	else
		local data = self:GetHeroByUuid(heroUuid)
		if data ~= nil and (data.rarity == HeroUtils.RarityType.S or data.rarity == HeroUtils.RarityType.A or data.rarity == HeroUtils.RarityType.B) then
			if not table.hasvalue(self.displayedHeroIds, data.heroId) then
				table.insert(self.displayedHeroIds, data.heroId)
				showFlag = true
			end
		end
	end
	return showFlag
end

local function GetHeroMaxQuality(self)
	local result = 1
	for _, v in pairs(self.masterHero) do
		if v ~= nil and result < v.quality then
			result = v.quality
		end
	end
	return result
end

local function GetLastSeasonHeroRecordInfoHandler(self, message)
	if message["heroRecords"] ~= nil then
		self.lastSeasonHero = {}
		for _, v in ipairs(message["heroRecords"]) do
			local data = DeepCopy(v)
			table.insert(self.lastSeasonHero, data)
		end
		EventManager:GetInstance():Broadcast(EventId.GetLastSeasonHeroRecordInfoSuccess)
	end
end

local function GetLastSeasonHeroRecordInfo(self)
	return self.lastSeasonHero
end

local function HasMaxedOrangeHero(self, camp)
	local enoughCamp = (camp == HeroCamp.All or camp == nil )
	local needRarity = HeroUtils.RarityType.S
	local campType = nil
	for _, heroData in pairs(self.masterHero) do
		campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
		if heroData.rarity == needRarity and (enoughCamp or campType == camp) and heroData:IsMaxQuality() then
			return true
		end
	end
	return false
end

--获取最高分的英雄插件
function HeroDataManager:GetMaxScoreHeroPluginHero()
	local result = nil
	local maxScore = 0
	local score = 0
	for _, heroData in pairs(self.masterHero) do
		if heroData.plugin ~= nil then
			score = heroData.plugin:GetScore()
			if maxScore < score then
				maxScore = score
				result = heroData
			end
		end
	end
	return result
end

function HeroDataManager:GetAllHeroPosters()
	local result = {}
	for k, v in pairs(self.typeHeroes) do
		if v[2] ~= nil then
			--肯定有海报
			local uuidList = {}--<quality, list>
			for k1, v1 in ipairs(v) do
				if not v1.isMaster then
					if uuidList[v1.quality] == nil then
						uuidList[v1.quality] = {}
					end
					table.insert(uuidList[v1.quality], v1.uuid)
				end
			end
			local campType = GetTableData(HeroUtils.GetHeroXmlName(), k, "camp")
			for k1, v1 in pairs(uuidList) do
				local param = {}
				param.heroId = k
				param.quality = k1
				param.camp = campType
				param.rarity = v[1].rarity
				param.uuidList = v1
				param.count = #param.uuidList
				table.insert(result, param)
			end
		end
	end
	return result
end

--发送英雄选择阵营
function HeroDataManager:SendHeroChooseCamp(heroUuid, chooseCamp)
	SFSNetwork.SendMessage(MsgDefines.HeroChooseCamp, {heroUuid = heroUuid, chooseCamp = chooseCamp})
end

--英雄选择阵营回调
function HeroDataManager:HeroChooseCampHandle(message)
	local errCode = message["errorCode"]
	if errCode == nil then
		self:UpdateOneHero(message["hero"])
		UIUtil.ShowTipsId(GameDialogDefine.NEW_HUMAN_CHANGE_CAMP_SUCCESS)
		EventManager:GetInstance():Broadcast(EventId.ChangeHeroCamp)
	else
		UIUtil.ShowTipsId(errCode)
	end
end

HeroDataManager.__init = __init
HeroDataManager.__delete = __delete
HeroDataManager.InitData = InitData
HeroDataManager.UpdateOneHero = UpdateOneHero
HeroDataManager.GetHeroByUuid = GetHeroByUuid
HeroDataManager.GetHeroById = GetHeroById
HeroDataManager.GetHeroPostersById = GetHeroPostersById
HeroDataManager.UpdateHeroes = UpdateHeroes
HeroDataManager.AddOneHero = AddOneHero
HeroDataManager.RemoveOneHeroByUuid = RemoveOneHeroByUuid
HeroDataManager.RemoveHeroes = RemoveHeroes
HeroDataManager.GetHeroIdListInMarch = GetHeroIdListInMarch
HeroDataManager.GetAllHeroList = GetAllHeroList
HeroDataManager.IsTheOptimalHeroInSameId = IsTheOptimalHeroInSameId
HeroDataManager.GetLastSeasonHeroRecordInfoHandler = GetLastSeasonHeroRecordInfoHandler
HeroDataManager.IsInHistory = IsInHistory
HeroDataManager.GetLastSeasonHeroRecordInfo = GetLastSeasonHeroRecordInfo
HeroDataManager.AddNewHeroTag =AddNewHeroTag
HeroDataManager.RemoveNewHeroTag =RemoveNewHeroTag
HeroDataManager.ClearNewHeroTags =ClearNewHeroTags
HeroDataManager.IsNewHero =IsNewHero
HeroDataManager.MarkHeroRedPoint = MarkHeroRedPoint

HeroDataManager.RebuildRemindList =RebuildRemindList
HeroDataManager.GetHeroRedNum =GetHeroRedNum
HeroDataManager.ShowHeroRed =ShowHeroRed

HeroDataManager.GetFreeAddTimeHero = GetFreeAddTimeHero
HeroDataManager.BeyondHero = BeyondHero
HeroDataManager.GetHighestHeroLevel = GetHighestHeroLevel
HeroDataManager.HasBeyondHero = HasBeyondHero
HeroDataManager.GetMasterQuality = GetMasterQuality
HeroDataManager.SetMasterQuality = SetMasterQuality
HeroDataManager.GetHeroListForCollect = GetHeroListForCollect
HeroDataManager.NeedShowNewHeroWindow = NeedShowNewHeroWindow
HeroDataManager.GetHeroMaxQuality = GetHeroMaxQuality
HeroDataManager.HasMaxedOrangeHero = HasMaxedOrangeHero

return HeroDataManager