---
--- UIPVE控制器
---

local UIPVESceneCtrl = BaseClass("UIPVESceneCtrl", UIBaseCtrl)
local Const = require"Scene.PVEBattleLevel.Const"
local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self,onKeyFill, pveEntrance)
    self.curHeroes = {}
    self.curSoldiers = {}
    local freeSoldiers =  DataCenter.ArmyManager:GetArmyDataForPve(pveEntrance)
    self.maxSoldiers ={}
    table.walksort(freeSoldiers,function (leftKey,rightKey)
        local aData = DataCenter.ArmyManager:FindArmy(leftKey)
        local bData = DataCenter.ArmyManager:FindArmy(rightKey)
        if aData.level ~= bData.level then
            return aData.level > bData.level
        end
        return aData.id > bData.id
    end, function (k,v)
        if v>0 then
            self.maxSoldiers[k] = v
        end
    end)
    if onKeyFill then
        self:OnOneKeyFillClick()
    end
    
end

local function GetCurrentHeroDataList(self,camp)
    local heroes = {}
    local list = DataCenter.HeroDataManager:GetMasterHeroList()
    for _, v in ipairs(list) do
        if camp ~= nil and camp >-1 then
            local targetCamp = v:GetCamp()
            if targetCamp == camp then
                table.insert(heroes, v)
            end
        else
            table.insert(heroes, v)
        end
    end
    
    local campA = nil
    local campB = nil
    table.sort(heroes, function(heroA, heroB)
        if heroA.uuid == HireHeroUuid then
            return true
        elseif heroB.uuid == HireHeroUuid then
            return false
        end
        
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


    local result = {}
    for _, heroData in ipairs(heroes) do
        table.insert(result, heroData.uuid)
    end

    return result
end

local function GetHeroDataByUuid(self, heroUuid)
    local data = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
        local heroConfig = heroData:GetConfig()
        local camp = heroData:GetCamp()
        local rarity = heroConfig.rarity
        data.hero_rarity = HeroUtils.GetRarityIconName(rarity, true)
        data.rankId = heroData:GetCurMilitaryRankId()
        data.heroUuid = heroUuid
        data.heroId = heroData.heroId
        data.qualityIndex = heroData.quality
        data.quality = HeroUtils.GetQualityBgInTroopsByPath(heroData.quality)
        data.icon = HeroUtils.GetHeroBodyByHeroId(heroData.heroId)
        data.level = heroData.level
        data.camp  = HeroUtils.GetCampIconPath(camp)
        data.armyAdd = HeroUtils.GetArmyLimit(heroData.level, data.rankId, heroConfig['rarity'], heroData.heroId,heroData.quality)
        data.power = 0
        data.restCount = heroData.restCount
        local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
        local curAtk = heroData.atk
        local curDef = heroData.def
        local k5 = LuaEntry.DataConfig:TryGetNum("power_setting", "k5")
        if k5 <=0 then
            k5 = 1
        end
        local curPower = Mathf.Round(Mathf.Pow((curAtk + curDef),k5) * k1)
        local skillIdList = heroConfig['skill']
        if type(skillIdList) ~= 'table' then
            skillIdList = string.split(skillIdList, '|')
        end
        for i=1 ,#skillIdList do
            local skill = {}
            skill.id = tonumber(skillIdList[i])
            skill.level = 0
            local skillData = heroData:GetSkillData(skill.id)
            if skillData ~= nil and skillData:IsUnlock() then
                skill.level = skillData.level
                local powerStr = GetTableData(TableName.SkillTab, skill.id, 'power')
                local strArr = string.split(powerStr,"|")
                if #strArr>=skill.level then
                    local num = tonumber(strArr[skill.level])
                    if num ==nil then
                    else
                        curPower = curPower + tonumber(strArr[skill.level])
                    end

                end
            end
        end
        data.power = curPower
        data.index = 0
        data.rarity = rarity
        data.isInMarch = false
        if heroData.state == ArmyFormationState.March then
            data.isInMarch = true
        end
        data.isSelect = false
        data.isLock = false
        data.formIndex = 0
        local formData = DataCenter.ArmyFormationDataManager:GetFormationFormDataByHeroUuid(heroUuid)
        if formData~=nil then
            data.formIndex = formData.index
        end
        table.walk(self.curHeroes,function (k, v)
            if v == heroUuid then
                data.index = k
                data.isSelect = true
            else
                local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
                if tempHeroData~=nil then
                    if tempHeroData.heroId == heroData.heroId then
                        data.isLock = true
                    end
                end
            end
        end)
    end
    
    return data
end

local function GetCurHeroNum(self)
    return #self.curHeroes
end

local function GetMaxHeroNum(self)
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave then
        local _, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
        local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
        return MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
    elseif entranceType == PveEntrance.ArenaSetting or
           entranceType == PveEntrance.ArenaBattle then
        return MarchUtil.GetMaxHeroValueByFormationIndex(1)
    else
        local key = LuaEntry.DataConfig:CheckSwitch("new_bridge_item_b") and "k12" or "k5"
        local cfg = LuaEntry.DataConfig:TryGetStr("aps_pve_config", key)
        local spls = string.split(cfg, ";")
        local count = 0
        local needLv = 0
        for i = 1, 5 do
            needLv = tonumber(spls[i]) or 9999
            if DataCenter.BuildManager.MainLv >= needLv then
                count = count + 1
            else
                break
            end
        end
        return math.min(count, 5), needLv
    end
end
local function SelectHeroByUuid(self, heroUuid)
    local tempIndex = 0
    local maxHeroNum,needLv = self:GetMaxHeroNum()
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave then
        local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
        local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
        maxHeroNum = MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
    elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle then
        maxHeroNum = MarchUtil.GetMaxHeroValueByFormationIndex(1)
    end
    for i = 1, maxHeroNum do
        if tempIndex <= 0 then
            if self.curHeroes[i] == nil then
                tempIndex = i
            end
        end
    end
    if tempIndex > 0 then
        self.curHeroes[tempIndex] = heroUuid
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData~=nil then
            EventManager:GetInstance():Broadcast(EventId.OnSelectPVEHeroSelect,heroData.heroId)
        end
    else
        if maxHeroNum>=5 then
            UIUtil.ShowTipsId(400034)
        else
            if entranceType == PveEntrance.ArenaSetting or
                   entranceType == PveEntrance.ArenaBattle or
                   entranceType == PveEntrance.MineCave then
                UIUtil.ShowTipsId(400035)
            else
                UIUtil.ShowTips(CS.GameEntry.Localization:GetString("400033",needLv,maxHeroNum+1))
            end
        end
        
        --if self.curHeroes[1]~=nil then
        --    self:OnDeleteHeroByIndex(1)
        --end
        --self.curHeroes[1] = heroUuid
    end
    self:OnOneKeyFillClick()
    PveActorMgr:GetInstance():SetHeros(self.curHeroes)
    self:SaveSelection(self.curHeroes)
end

local function SaveSelection(self, heroes)
    if heroes ~= nil then
        local pveHeroes = table.concat(heroes, ";")
        local entryType = DataCenter.BattleLevel:GetEntranceType()
        if entryType == PveEntrance.ArenaBattle then
            local str = "ArenaPveCacheHeroes_" .. LuaEntry.Player.uid
            CS.GameEntry.Setting:SetString(str, pveHeroes)
        elseif entryType == PveEntrance.ArenaSetting then
            --竞技场防守阵容不设置默认英雄
        elseif entryType == PveEntrance.MineCave then
            --矿洞不设置默认英雄
        else
            Setting:SetPrivateString(SettingKeys.PVE_HEROES, pveHeroes)
        end
    end
end

local function OnDeleteHeroByIndex(self, index)
    local newList = {}
    for i = 1, #self.curHeroes do
        local uuid = self.curHeroes[i]
        local tempHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
        if tempHeroData ~= nil then
            if index == i then
                EventManager:GetInstance():Broadcast(EventId.OnCancelPVEHeroSelect, tempHeroData.heroId)
            else
                local idx = #newList + 1
                newList[idx] = uuid
            end
        end
    end
    self.curHeroes = newList
    self:OnOneKeyFillClick()
    PveActorMgr:GetInstance():SetHeros(self.curHeroes)
    self:SaveSelection(self.curHeroes)
end

local function GetArmyIdList(self)
    return table.keys(self.maxSoldiers)
end

local function GetArmyData(self,armyId, isEm)
    local oneData ={}
    oneData.name =""
    oneData.armyId = armyId
    oneData.maxNum = self.maxSoldiers[armyId]
    oneData.icon =""
    oneData.level = 0
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
    if template ~= nil then
        oneData.name = template.name
        oneData.level = template.level
        if isEm ~= nil and isEm then
            local icon = template.icon
            oneData.icon = string.format(LoadPath.SoldierIcons, icon)
        else
            local icon = template.icon
            if template.arm == 3 then
                icon = "UInewbie_img_head2"
            elseif template.arm == 2 then
                icon = "UInewbie_img_head3"
            elseif template.arm == 1 then
                icon = "UInewbie_img_head1"
            end

            oneData.icon = string.format(LoadPath.Guide, icon)
        end
    end
    return oneData
end

local function GetCurrentSoldierNum(self,armyId)
    local num =0
    if self.curSoldiers[armyId]~=nil and self.curSoldiers[armyId]>0 then
        num = self.curSoldiers[armyId]
    end
    return num
end

local function OnOneKeyFillClick(self)
    self.curSoldiers ={}
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.ArenaBattle or entranceType == PveEntrance.ArenaSetting then
        local max = self:GetMaxNum()
        --local armsConf = LuaEntry.DataConfig:TryGetStr("arena", "k10")
        --local arrArmsConf = string.split(armsConf, ";")
        local arrArmsConf = DataCenter.ArenaManager:GetFillArmyConf()
        local perCount = math.modf(max / #arrArmsConf)
        local leftNum = max
        for i, v in ipairs(arrArmsConf) do
            if i == #arrArmsConf then
                self:SetCurrentSoldierNum(tonumber(v),leftNum)
            else
                self:SetCurrentSoldierNum(tonumber(v),perCount)
                leftNum = leftNum - perCount
            end
        end
    elseif entranceType == PveEntrance.Test or entranceType == PveEntrance.Story or entranceType == PveEntrance.LandBlock then
        local armyStr = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k14")
        local armySpls = string.split(armyStr, ";")
        local armyId = armySpls[1]
        local count = self:GetMaxNum()
        self:SetCurrentSoldierNum(armyId, count)
    else
        table.walksort(self.maxSoldiers,function (leftKey,rightKey)
            local aData = DataCenter.ArmyManager:FindArmy(leftKey)
            local bData = DataCenter.ArmyManager:FindArmy(rightKey)
            if aData.level ~= bData.level then
                return aData.level > bData.level
            end
            return aData.id > bData.id
        end, function (k,v)
            local num = self:CheckMax(k,v)
            self:SetCurrentSoldierNum(k,num)
        end)
    end
end

local function CheckMax(self,armyId,num)
    local oneMaxNum = self.maxSoldiers[armyId]
    local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
    local currentTotalNum = self:GetTotalSoldierNum()
    local restNum = currentTotalNum - oneCurrentNum

    local checkMax = math.min(oneMaxNum, num)
    local totalRest = self:GetMaxNum() - restNum

    local final = math.min(totalRest, checkMax)
    if final<0 then
        final =0
    end
    return final
end

local function GetTotalSoldierNum(self)
    local count =0
    table.walk(self.curSoldiers,function (k,v)
        count = count +v
    end)
    return count
end

local function GetCurSoldierList(self)
    return self.curSoldiers
end
local function SetCurrentSoldierNum(self,armyId,num)
    if num>0 then
        self.curSoldiers[armyId] = num
    else
        self.curSoldiers[armyId] = nil
    end
end

local function GetMaxNum(self)
    --if table.count(self.curHeroes) == 0 then
    --    return 0
    --end
    local heroes = {}
    table.walk(self.curHeroes,function(k,v)
        if v~=nil then
            heroes[v] = k
        end
    end)
    local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
    local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
    local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
    asPlayerMaxSoldiers = asPlayerMaxSoldiers + math.floor(baseSize+0.5)
    local campAdd= 0
    if heroes~=nil then
        table.walk(heroes,function(k,v)
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
            if heroData~=nil then
                local config = heroData:GetConfig()
                local rankId = heroData:GetCurMilitaryRankId()
                local armyAdd = HeroUtils.GetArmyLimit(heroData.level, rankId, config['rarity'], heroData.heroId,heroData.quality)
                asPlayerMaxSoldiers = asPlayerMaxSoldiers+armyAdd
                local heroBaseSize = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE)
                local heroSizeEnhance = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
                local campAddEffect = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraTroopByCamp(heroData:GetCamp()))
                campAdd = campAddEffect+campAdd
                asPlayerMaxSoldiers = asPlayerMaxSoldiers + heroBaseSize
                sizeEnhance = sizeEnhance + heroSizeEnhance
            end
        end)
    end
    local formationIndex = 1
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave then
        local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
        local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
        formationIndex = formationInfo.index
    end
    local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(formationIndex)
    asPlayerMaxSoldiers = asPlayerMaxSoldiers + finalAddNumByIndex+ campAdd
    asPlayerMaxSoldiers = asPlayerMaxSoldiers*(1+(sizeEnhance/100))
    local campFinalAdd = MarchUtil.GetHeroCampAddArmyCount(HeroUtils.GetPveHeroDataListByUuids(self.curHeroes))
    asPlayerMaxSoldiers = asPlayerMaxSoldiers + campFinalAdd
    return math.floor(asPlayerMaxSoldiers)
end



UIPVESceneCtrl.Close = Close
UIPVESceneCtrl.InitData = InitData
UIPVESceneCtrl.GetCurrentHeroDataList = GetCurrentHeroDataList
UIPVESceneCtrl.GetHeroDataByUuid = GetHeroDataByUuid
UIPVESceneCtrl.SelectHeroByUuid = SelectHeroByUuid
UIPVESceneCtrl.OnDeleteHeroByIndex = OnDeleteHeroByIndex
UIPVESceneCtrl.GetArmyIdList = GetArmyIdList
UIPVESceneCtrl.GetArmyData = GetArmyData
UIPVESceneCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIPVESceneCtrl.OnOneKeyFillClick = OnOneKeyFillClick
UIPVESceneCtrl.CheckMax = CheckMax
UIPVESceneCtrl.GetTotalSoldierNum = GetTotalSoldierNum
UIPVESceneCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIPVESceneCtrl.GetMaxNum = GetMaxNum
UIPVESceneCtrl.SaveSelection = SaveSelection
UIPVESceneCtrl.GetCurHeroNum =GetCurHeroNum
UIPVESceneCtrl.GetMaxHeroNum =GetMaxHeroNum
UIPVESceneCtrl.GetCurSoldierList =GetCurSoldierList
return UIPVESceneCtrl