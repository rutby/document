---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/7/26 18:25
---

local HeroOfficialManager = BaseClass("HeroOfficialManager")
local HeroOfficialTemplate = require "DataCenter.HeroOfficial.HeroOfficialTemplate"
local HeroOfficialData = require "DataCenter.HeroOfficial.HeroOfficialData"
local Localization = CS.GameEntry.Localization

local EXTRA_CONDITION_COUNT = 2

local function CampPosToKey(camp, pos)
    return camp * 1000 + pos
end

local function __init(self)
    self.camps = {} -- List<camp>
    self.templateDict = {} -- Dict<id, HeroOfficialTemplate>
    self.dataDict = {} -- Dict<id, HeroOfficialData>
    self.minUnlockLvDict = {} -- Dict<key, unlockLv>

    LocalController:instance():visitTable(TableName.HeroOfficial, function(id, line)
        -- templateDict
        local template = HeroOfficialTemplate.New()
        template:InitData(line)
        self.templateDict[id] = template

        -- camps
        if not table.hasvalue(self.camps, template.camp) then
            table.insert(self.camps, template.camp)
        end

        -- minUnlockLvDict
        local key = CampPosToKey(template.camp, template.pos)
        if self.minUnlockLvDict[key] == nil then
            self.minUnlockLvDict[key] = template.unlockLv
        else
            self.minUnlockLvDict[key] = math.min(self.minUnlockLvDict[key], template.unlockLv)
        end
    end)

    self:AddListeners()
end

local function __delete(self)
    self.camps = nil
    self.templateDict = nil
    self.dataDict = nil
    self.minUnlockLvDict = nil
    self:RemoveListeners()
end

local function AddListeners(self)
    
end

local function RemoveListeners(self)
    
end

local function Enabled(self)
    return LuaEntry.DataConfig:CheckSwitch("hero_official_switch")
end

local function GetData(self, id)
    local data = self.dataDict[id]
    if data and data.heroUuid and DataCenter.HeroDataManager:GetHeroByUuid(data.heroUuid) == nil then
        data.heroUuid = nil
    end
    return data
end

local function GetCamps(self)
    return self.camps
end

-- 获取最高且满足等级的 template，如果没有，则获取最低级的
local function GetTemplate(self, camp, pos)
    local key = CampPosToKey(camp, pos)
    local lv = math.max(self.minUnlockLvDict[key], self:GetBuildingLv())
    local template = nil
    for _, t in pairs(self.templateDict) do
        if t.camp == camp and t.pos == pos and lv >= t.unlockLv then
            if template == nil or t.unlockLv > template.unlockLv then
                template = t
            end
        end
    end
    return template
end

-- 获取 template，无论等级是否满足
local function GetTemplateList(self, camp, pos)
    local list = {}
    for _, t in pairs(self.templateDict) do
        if t.camp == camp and t.pos == pos then
            table.insert(list, t)
        end
    end
    table.sort(list, function(tA, tB)
        return tA.buffLv < tB.buffLv
    end)
    return list
end

local function GetBuildingLv(self)
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_HERO_OFFICE)
    if buildData ~= nil then
        return buildData.level
    else
        return 0
    end
end

local function UpdateData(self, id, heroUuid)
    local data = self.dataDict[id] or HeroOfficialData.New()
    data.id = id
    data.heroUuid = heroUuid
    self.dataDict[id] = data
end

local function GetEffectVal(self, camp, pos, heroUuid)
    local val = 0
    if heroUuid ~= nil then
        val = val + self:GetEffectBaseVal(camp, pos, heroUuid)
        val = val + self:GetEffectExtraVal(camp, pos, heroUuid)
    end
    val = Mathf.Round(val * 10) / 10
    val = math.tointeger(val) or val
    return val
end

local function GetEffectBaseVal(self, camp, pos, heroUuid)
    local template = self:GetTemplate(camp, pos)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local atk, def = heroData:GetAttrByQuality()
    local skl = heroData:GetSkillPower()
    local k = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
    local k5 = LuaEntry.DataConfig:TryGetNum("power_setting", "k5")
    if k5 <=0 then
        k5 = 1
    end
    local power = Mathf.Round(Mathf.Pow((atk + def),k5) * k) + skl
    local m = LuaEntry.DataConfig:TryGetNum("hero_official", "k1")
    local val = (math.min(power, template.maxHeroPower) / template.maxHeroPower) ^ m * template.maxVal
    return val
end

local function GetEffectExtraVal(self, camp, pos, heroUuid)
    local template = self:GetTemplate(camp, pos)
    local val = 0
    for i = 1, EXTRA_CONDITION_COUNT do
        if template.extraCondition[i] ~= 0 then
            val = template.extraVal
            if not self:CheckHeroExtraCondition(camp, pos, heroUuid, i) then
                val = 0
                break
            end
        end
    end
    return val
end

local function GetEffectMaxVal(self, camp, pos)
    local template = self:GetTemplate(camp, pos)
    local maxVal = template.maxVal
    for _, condition in ipairs(template.extraCondition) do
        if condition ~= 0 then
            maxVal = maxVal + template.extraVal
            break
        end
    end
    return maxVal
end

local function CheckHeroExtraCondition(self, camp, pos, heroUuid, i)
    if heroUuid == nil then
        return false
    end

    local template = self:GetTemplate(camp, pos)
    local condition = template.extraCondition[i]
    if condition == 0 then
        return false
    end

    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData == nil then
        return false
    end

    if i == 1 then
        return heroData.rarity <= condition
    elseif i == 2 then
        local tags = HeroUtils.GetTagsByHeroId(heroData.heroId)
        return table.hasvalue(tags, condition)
    end

    return false
end

local function GetHeroPos(self, heroUuid)
    for _, data in pairs(self.dataDict) do
        if data.heroUuid == heroUuid then
            local template = self.templateDict[data.id]
            return template.pos
        end
    end
    return nil
end

local function GetNextTemplate(self)
    local lv = DataCenter.HeroOfficialManager:GetBuildingLv()
    local nextTemplate = nil
    local nextLv = IntMaxValue
    for _, template in pairs(self.templateDict) do
        if lv < template.unlockLv and template.unlockLv < nextLv then
            nextLv = template.unlockLv
            nextTemplate = template
        end
    end
    return nextTemplate
end

local function CanShowBubble(self)
    for _, camp in pairs(self.camps) do
        if self:HaveEmptySlotAndAvailableHero(camp) then
            return true
        end
    end
    return false
end

local function HaveEmptySlotAndAvailableHero(self, camp)
    local emptySlots = {} -- List<pos>
    local heroUuids = {} -- List<heroUuid>

    local dict = DataCenter.HeroDataManager:GetMasterHeroList()
    local campType = nil
    for k, v in pairs(dict) do
        campType = GetTableData(HeroUtils.GetHeroXmlName(), v.heroId, "camp")
        if campType == camp then
            table.insert(heroUuids, v.uuid)
        end
    end

    local buildingLv = DataCenter.HeroOfficialManager:GetBuildingLv()
    for _, template in pairs(self.templateDict) do
        if template.camp == camp and template.type == 1 and buildingLv >= template.unlockLv then
            local data = self:GetData(template.id)
            if data == nil or data.heroUuid == nil then
                table.insert(emptySlots, template.pos)
            else
                if table.hasvalue(heroUuids, data.heroUuid) then
                    table.removebyvalue(heroUuids, data.heroUuid)
                end
            end
        end
    end

    return table.count(emptySlots) > 0 and table.count(heroUuids) > 0
end

-- 获取阵营克制值
local function GetCampCounterVal(self, camp)
    local val = 0
    local buildingLv = DataCenter.HeroOfficialManager:GetBuildingLv()
    for _, template in pairs(self.templateDict) do
        if template.camp == camp and template.type == 3 and buildingLv >= template.unlockLv then
            val = math.max(val, template.maxVal)
        end
    end
    return val
end

local function InitHandle(self, message)
    if message["heroOfficials"] then
        for _, serverData in ipairs(message["heroOfficials"]) do
            self:UpdateData(serverData.officialId, serverData.heroUuid)
        end
    end
end

local function SetHeroOfficialHandle(self, message)
    if message["heroOfficial"] then
        local serverData = message["heroOfficial"]
        self:UpdateData(serverData.officialId, serverData.heroUuid)
    end
    if message["originOfficial"] then
        local serverData = message["originOfficial"]
        self:UpdateData(serverData.officialId, nil)
    end
    EventManager:GetInstance():Broadcast(EventId.SetHeroOfficial)
end

HeroOfficialManager.__init = __init
HeroOfficialManager.__delete = __delete
HeroOfficialManager.AddListeners = AddListeners
HeroOfficialManager.RemoveListeners = RemoveListeners

HeroOfficialManager.Enabled = Enabled
HeroOfficialManager.GetData = GetData
HeroOfficialManager.GetCamps = GetCamps
HeroOfficialManager.GetTemplate = GetTemplate
HeroOfficialManager.GetTemplateList = GetTemplateList
HeroOfficialManager.GetBuildingLv = GetBuildingLv
HeroOfficialManager.UpdateData = UpdateData
HeroOfficialManager.GetEffectVal = GetEffectVal
HeroOfficialManager.GetEffectBaseVal = GetEffectBaseVal
HeroOfficialManager.GetEffectExtraVal = GetEffectExtraVal
HeroOfficialManager.GetEffectMaxVal = GetEffectMaxVal
HeroOfficialManager.CheckHeroExtraCondition = CheckHeroExtraCondition
HeroOfficialManager.GetHeroPos = GetHeroPos
HeroOfficialManager.GetNextTemplate = GetNextTemplate
HeroOfficialManager.CanShowBubble = CanShowBubble
HeroOfficialManager.HaveEmptySlotAndAvailableHero = HaveEmptySlotAndAvailableHero
HeroOfficialManager.GetCampCounterVal = GetCampCounterVal

HeroOfficialManager.InitHandle = InitHandle
HeroOfficialManager.SetHeroOfficialHandle = SetHeroOfficialHandle

return HeroOfficialManager