---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 6/24/21 4:44 PM
---

local HeroAdvanceController = BaseClass("HeroAdvanceController", Singleton)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local LAST_CAN_ADVANCE_NUM = 'LAST_CAN_ADVANCE_NUM'


local function __init(self)
    self.consumeMap = {}
    self.lastCanAdvanceNum = 0; --Setting:GetPrivateInt(LAST_CAN_ADVANCE_NUM, 0)
end

local function __delete(self)
    self.consumeMap = nil
    self.curAdvanceUuid = nil
    self.lastCanAdvanceNum = nil
end


local function SetAdvanceHeroUuid(self, heroUuid)
    print("#zlh# SetAdvanceHeroUuid heroUuid" .. tostring(heroUuid))

    self.curAdvanceUuid = heroUuid
    local data = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    self.isAdvanceMaster = data and data.isMaster
    self.consumeMap = {}
end

local function GetAdvanceHeroUuid(self)
    return self.curAdvanceUuid
end

local function GetAdvanceHeroData(self)
    if self.curAdvanceUuid == nil then
        return nil
    end
    
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
    return heroData
end

local function IsConsumeFull(self)
    if self.curAdvanceUuid == nil or self.consumeMap == nil then
        return false
    end
    
    local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
    local requireNum = coreHeroData:GetAdvanceConsume():GetTotalNeedNum()
    
    return table.count(self.consumeMap) >= requireNum
end

local function GetCurConsumeMap(self) 
    return self.consumeMap or {}
end

local function IsAlreadySelect(self, heroUuid)
    if self.curAdvanceUuid == nil or self.consumeMap == nil then
        return false
    end
    
    local key = table.keyof(self.consumeMap, heroUuid)
    return key ~= nil, key
end

local function OnToggleDogFood(self, heroUuid)
    local ret, key = self:IsAlreadySelect(heroUuid)
    if ret then
        self.consumeMap[key] = nil
    else
        local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
        local selfHeroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        local consume = coreHeroData:GetAdvanceConsume()
        local _, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
        local _, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
        local canEatSameHero = coreHeroData:CanAdvanceEatOther(selfHeroData, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
        local canEatSameCamp = coreHeroData:CanAdvanceEatOther(selfHeroData, HeroAdvanceConsumeType.ConsumeType_Same_Camp)
        sameHeroNum = sameHeroNum or 0
        sameCampNum = sameCampNum or 0
        for i = 1, HeroUtils.ConsumeSlotMax do
            if self.consumeMap[i] == nil then
                if i <= sameHeroNum then
                    if canEatSameHero then
                        self.consumeMap[i] = heroUuid
                        break
                    end
                else
                    if canEatSameCamp then
                        self.consumeMap[i] = heroUuid
                        break
                    end
                end
            end
        end
    end
end

---获取升阶相关配置
local function GetAdvanceConfigByQuality(self, configQuality) 
    local config = LocalController:instance():getLine(TableName.NewHeroesQuality, configQuality)
    return config
end

local function GetCurAdvanceRequireNum(self)
    if self.curAdvanceUuid == nil then
        return 0
    end

    local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curAdvanceUuid)
    local requireNum = coreHeroData:GetAdvanceConsume():GetTotalNeedNum()
    return requireNum
end


local function OnHandleHeroOneKeyAdvance(self, message)
    if message["errorCode"] ~= nil then
        local errorCode = message["errorCode"]
        local lang = Localization:GetString(errorCode)
        local str = lang or errorCode

        UIUtil.ShowTips(lang or str)
        return
    end

    --更新英雄
    if message['heros'] ~= nil then
        table.walk(message['heros'], function (_, v)
            DataCenter.HeroDataManager:UpdateOneHero(v)
        end)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceOneKeySuccess, {anim = true, playEffect = false}, message['heros'])
    end
    --移除消耗的英雄
    DataCenter.HeroDataManager:RemoveHeroes(message["rmHeroes"])
    EventManager:GetInstance():Broadcast(EventId.OnOneKeyAdvanceSuccess, message)
end

-- 消息处理
local function OnHandleHeroAdvance(self, message)
    print("#zlh# OnHandleHeroAdvance")
    if message["errorCode"] ~= nil then
        local errorCode = message["errorCode"]
        local lang = Localization:GetString(errorCode)
        local str = lang or errorCode
        
        UIUtil.ShowTips(lang or str)
        return
    end
    
    --local isPreMaster = self.isAdvanceMaster == true
    --self:SetAdvanceHeroUuid(nil)
    --message["isPreMaster"] = isPreMaster
    --更新核心英雄
    local hero = message["heroInfo"]
    if hero ~= nil then
        local uuid = hero["uuid"]
        local power = 0
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
        if heroData ~= nil then
            power = HeroUtils.GetHeroPower(heroData)
        end
        DataCenter.HeroDataManager:UpdateOneHero(hero)
        heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
        if heroData ~= nil then
            power = HeroUtils.GetHeroPower(heroData) - power
        end
        if power > 0 then
            GoToUtil.ShowPower({power = power})
        end
    end
    --todo:缓存消耗的英雄数据 后续弹窗可能用到
    --移除消耗的英雄
    --DataCenter.HeroDataManager:RemoveHeroes(message["rmHeroes"])
    --self:ResetRedPointAll()

    -- 交给 HeroStationUpdateMessage 处理了
    --for _, heroUuid in pairs(message["rmHeroes"]) do
    --    LuaEntry.Player:RemoveStationHero(heroUuid)
    --end
    
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceSuccess, message)
    EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
    --弹出进阶成功的弹窗
    --local uuid = message["heroInfo"]["uuid"]
    --local data = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    --if data ~= nil then
    --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceSuccess, {}, message)
    --end
    --UIUtil.ShowTipsId(120025) 
end


local function HasRaritySOrAHeroInConsume(self)
    local coreData = self:GetAdvanceHeroData()
    local consumeMap = self:GetCurConsumeMap()
    local requireType2 = coreData:GetAdvanceConsume():GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)

    --类型 是吃自己的不进行提示
    if requireType2 == nil  then
        return false
    end

    local ret, str = false, ''
    local heroIdList = {}
    for _, heroUuid in ipairs(consumeMap) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        --自己吃自己不提示
        if heroData.heroId == coreData.heroId then
            goto continue
        end
        
        if  table.hasvalue(heroIdList, heroData.heroId) then
            goto continue
        end
        
        table.insert(heroIdList, heroData.heroId)
        
        if heroData ~= nil and (heroData.rarity == HeroUtils.RarityType.S or heroData.rarity == HeroUtils.RarityType.A) then
            local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroData.quality), heroData:GetName())
            ret = true
            str = str .. ((str == '' and '' or '、') .. heroName)
        end
        
        ::continue::
    end
    
    return ret, str
end

local function HasStationedHeroInConsume(self)
    local consumeMap = self:GetCurConsumeMap()
    local ret, heroNames, buildNames = false, {}, {}
    for _, heroUuid in ipairs(consumeMap) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        local stationId = DataCenter.HeroStationManager:GetHeroStationId(heroUuid)
        if stationId ~= nil then
            local level = 0
            local buildId = DataCenter.HeroStationManager:GetBuildIdByStationId(stationId)
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil then
                level = buildData.level
            end
            ret = true
            table.insert(heroNames, heroData:GetName())
            table.insert(buildNames, Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name")))
        end
    end
    
    return ret, heroNames, buildNames
end

---是否有充足的狗粮
local function HasFullDogForCore(self, coreHeroData)
    if coreHeroData ~= nil then
        if (not coreHeroData.isMaster) and coreHeroData.rarity <= HeroUtils.RarityType.A then
            return false
        end
        if not coreHeroData:IsMaxQuality() then
            local condition = coreHeroData:GetAdvanceConsume():GetCondition()
            if condition ~= nil then
                for k, v in pairs(condition) do
                    if not self:HasFullDogForCoreByConsumeType(v, coreHeroData) then
                        return false
                    end
                end
                return true
            end
        end
    end
    return false
end


function HeroAdvanceController:HasFullDogForCoreByConsumeType(consumeData, heroData)
    if consumeData.requireType == HeroAdvanceConsumeType.ConsumeType_Same_Hero then
        local result = 0
        local uuid = heroData.uuid
        local requireQuality = consumeData.requireQuality
        local requireNum = consumeData.requireNum
        local allHeroes = DataCenter.HeroDataManager:GetAllHeroListByHeroId(heroData.heroId)
        for _, v in ipairs(allHeroes) do
            if v.quality == requireQuality and (not v.isMaster) and v.uuid ~= uuid then
                result = result + 1
                if result >= requireNum then
                    return true
                end
            end
        end
    elseif consumeData.requireType == HeroAdvanceConsumeType.ConsumeType_Same_Camp then
        local result = 0
        local uuid = heroData.uuid
        local requireQuality = consumeData.requireQuality
        local requireNum = consumeData.requireNum
        local camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        local rarity = heroData.rarity
        local rarityTypeA = HeroUtils.RarityType.A
        local tempRarity = 0
        local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
        for _, v in pairs(allHeroes) do
            if v.quality == requireQuality and v.camp == camp and (not v.isMaster) and v.uuid ~= uuid then
                tempRarity = v.rarity
                if tempRarity >= rarity or tempRarity > rarityTypeA then
                    result = result + 1
                    if result >= requireNum then
                        return true
                    end
                end
            end
        end
    end
    return false
end


local function GetRedDotShowNum(self)
    local k3 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k6")
    local vec1 = string.split(k3, "|")
    local mainLv = DataCenter.BuildManager.MainLv
    local needNum = -1
    local maxNum = 0
    local total = #vec1
    for i = 1, total do
        local vec2 = string.split(vec1[total - i + 1], ";")
        if table.count(vec2) == 2 then
            local lv = toInt(vec2[1])
            maxNum = toInt(vec2[2])
            if mainLv >= lv then
                needNum = maxNum
                break
            end
        end
    end

    if needNum < 0 then
        needNum = maxNum
    end
    return needNum
end
---获取当前可进阶英雄数量 且 满足 进阶排序的1，2优先级
local function GetCanAdvanceNumForBubbleTip(self)
    local needNum = self:GetRedDotShowNum()
    --for _, v in ipairs(HeroUtils.HeroAllCamps) do
    --    local curCanAdvanceNum = self:GetAdvanceHeroNum(v, needNum)
    --    if curCanAdvanceNum >= 1 then
    --        return 1
    --    end
    --end
    --return 0
    local curCanAdvanceNum = self:GetAdvanceHeroNum(-1, needNum)
    return curCanAdvanceNum > 0 and 1 or 0
end


---是否可以在酒馆上显示进阶气泡 
---策划要求：升阶的气泡提示，只在新的可升阶英雄出现时提示一次，玩家进入升阶界面一次后酒馆上不再弹出
local function CanShowAdvanceBubble(self)
    local curCanAdvanceNum = self:GetCanAdvanceNumForBubbleTip()
    --return curCanAdvanceNum > self.lastCanAdvanceNum
    --策划新要求：只要有能一键进阶的气泡就不消失 一键进阶的定义：蓝色和紫色能进阶的 参考文档优先级1、2
    return curCanAdvanceNum > 0
    
end

---更新可升阶英雄数
local function UpdateAdvanceNum(self)
    self.lastCanAdvanceNum = self:GetCanAdvanceNumForBubbleTip()
    --Setting:SetPrivateInt(LAST_CAN_ADVANCE_NUM, self.lastCanAdvanceNum)
    EventManager:GetInstance():Broadcast(EventId.CheckPubBubble)
end

local function SetPreStoreAdvanceNum(self)
    local key = LuaEntry.Player.uid.."_Advance_Num"
    local num = self:GetAdvanceHeroNum(-1)
    Setting:SetInt(key, num)
    
end

local function GetPreStoreAdvanceNum(self)
    local key = LuaEntry.Player.uid.."_Advance_Num"
    local num = Setting:GetInt(key, 0)
    return num
end

local function HasHeroCanAdvance(self, rarity)
    local heroes = DataCenter.HeroDataManager:GetMasterHeroList()
    for _, heroData in pairs(heroes) do
        if heroData.rarity == rarity then
            local canAdvance = self:HasFullDogForCore(heroData)
            if canAdvance then
                return true
            end
        end
    end
    return false
end

local function GetAdvanceHeroNum(self, camp, checkNum)
    local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
    checkNum = checkNum or 1
    local count = 0
    local rarity = 0 
    local rarityTypeC = HeroUtils.RarityType.C
    local rarityTypeB = HeroUtils.RarityType.B
    local campType = nil
    for _, heroData in pairs(allHeroes) do
        rarity = heroData.rarity
        if heroData.quality <= Poster_Show_Bubble_Quality and (rarity == rarityTypeC or rarity == rarityTypeB) then
            campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            if (camp == -1 or camp == campType) and (not heroData.isMaster) then
                if self:HasFullDogForCore(heroData) then
                    count = count + 1
                    if count >= checkNum then
                        return 1
                    end
                end
            end
        end
    end
    return 0
end

local function GetRedPointState(self, camp)
    local needNum = self:GetRedDotShowNum()
    local curCanAdvanceNum = self:GetAdvanceHeroNum(-1, needNum)
    local curCanAdvanceNum1 = self:GetAdvanceHeroNum(camp, 1)
    return curCanAdvanceNum > 0 and curCanAdvanceNum1 > 0 
end


local function CanEatHero(self, coreHero, eatHero)
    if eatHero == nil or coreHero == nil then
        return false
    end
    local consume = coreHero:GetAdvanceConsume()
    local _, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local _, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    local canEatSameHero = coreHero:CanAdvanceEatOther(eatHero, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local canEatSameCamp = coreHero:CanAdvanceEatOther(eatHero, HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    sameHeroNum = sameHeroNum or 0
    sameCampNum = sameCampNum or 0

    local currentSameHeroNum = 0
    local index = 1
    while index <= sameHeroNum do
        if self.consumeMap[index] ~= nil then
            currentSameHeroNum = currentSameHeroNum + 1
        end
        index = index + 1
    end
    if sameHeroNum > 0 and currentSameHeroNum < sameHeroNum and canEatSameHero then
        return true
    end
    
    local currentSameCampNum = 0
    while index <= sameCampNum + sameHeroNum do
        if self.consumeMap[index] ~= nil then
            currentSameCampNum = currentSameCampNum + 1
        end
        index = index + 1
    end

    if sameCampNum > 0 and currentSameCampNum < sameCampNum and canEatSameCamp then
        return true
    end
    return false
end

local function HasHeroAdvanced(self)
    local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
    for _, v in pairs(allHeroes) do
        if v ~= nil and v.quality > 1 then
            return true
        end
    end
    return false
end

HeroAdvanceController.__init = __init
HeroAdvanceController.__delete = __delete
HeroAdvanceController.SetAdvanceHeroUuid = SetAdvanceHeroUuid
HeroAdvanceController.GetAdvanceHeroUuid = GetAdvanceHeroUuid
HeroAdvanceController.GetAdvanceHeroData = GetAdvanceHeroData
HeroAdvanceController.IsConsumeFull = IsConsumeFull
HeroAdvanceController.GetCurConsumeMap = GetCurConsumeMap
HeroAdvanceController.IsAlreadySelect = IsAlreadySelect
HeroAdvanceController.GetAdvanceConfigByQuality = GetAdvanceConfigByQuality
HeroAdvanceController.OnToggleDogFood = OnToggleDogFood
HeroAdvanceController.GetCurAdvanceRequireNum = GetCurAdvanceRequireNum
HeroAdvanceController.OnHandleHeroAdvance = OnHandleHeroAdvance
HeroAdvanceController.HasRaritySOrAHeroInConsume = HasRaritySOrAHeroInConsume
HeroAdvanceController.HasStationedHeroInConsume = HasStationedHeroInConsume
HeroAdvanceController.HasFullDogForCore = HasFullDogForCore
HeroAdvanceController.CanShowAdvanceBubble = CanShowAdvanceBubble
HeroAdvanceController.UpdateAdvanceNum = UpdateAdvanceNum
HeroAdvanceController.GetCanAdvanceNumForBubbleTip = GetCanAdvanceNumForBubbleTip
HeroAdvanceController.GetRedPointState = GetRedPointState
HeroAdvanceController.GetPreStoreAdvanceNum = GetPreStoreAdvanceNum
HeroAdvanceController.SetPreStoreAdvanceNum = SetPreStoreAdvanceNum
HeroAdvanceController.GetAdvanceHeroNum = GetAdvanceHeroNum
HeroAdvanceController.OnHandleHeroOneKeyAdvance = OnHandleHeroOneKeyAdvance
HeroAdvanceController.CanEatHero = CanEatHero
HeroAdvanceController.HasHeroCanAdvance = HasHeroCanAdvance
HeroAdvanceController.GetRedDotShowNum = GetRedDotShowNum
HeroAdvanceController.HasHeroAdvanced = HasHeroAdvanced

return HeroAdvanceController