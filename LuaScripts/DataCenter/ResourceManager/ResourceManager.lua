local ResourceManager = BaseClass("ResourceManager")
local Localization = CS.GameEntry.Localization

local ResourceTypeIconName = {}
ResourceTypeIconName[ResourceType.Steel] = "Assets/Main/Sprites/UI/Common/Common_icon_electricity"
ResourceTypeIconName[ResourceType.Metal] = "Assets/Main/Sprites/UI/Common/Common_icon_metal"
ResourceTypeIconName[ResourceType.FLINT] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_massif3"
ResourceTypeIconName[ResourceType.Money] = "Assets/Main/Sprites/UI/Common/Common_icon_money"
ResourceTypeIconName[ResourceType.Food] = "Assets/Main/Sprites/UI/Common/Common_icon_water" -- TODO
ResourceTypeIconName[ResourceType.Plank] = "Assets/Main/Sprites/UI/Common/Common_icon_alCrystal" -- TODO
ResourceTypeIconName[ResourceType.Electricity] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_firecrystal" -- TODO
ResourceTypeIconName[ResourceType.Meal] = "Assets/Main/Sprites/UI/Common/Common_icon_pvecode" -- TODO
ResourceTypeIconName[ResourceType.Water] = "Assets/Main/Sprites/UI/Common/Common_icon_water"
ResourceTypeIconName[ResourceType.Oil] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_firecrystal"
ResourceTypeIconName[ResourceType.PvePoint] = "Assets/Main/Sprites/UI/Common/Common_icon_pvecode"
ResourceTypeIconName[ResourceType.MedalOfWisdom] = "Assets/Main/Sprites/ItemIcons/item210454"
ResourceTypeIconName[ResourceType.FarmBox] = "Assets/Main/Sprites/UI/Common/item200150"
ResourceTypeIconName[ResourceType.DETECT_EVENT] = "Assets/Main/Sprites/UI/Common/Common_icon_radar"
ResourceTypeIconName[ResourceType.FORMATION_STAMINA] = "Assets/Main/Sprites/UI/Common/Common_icon_stamina"
ResourceTypeIconName[ResourceType.Wood] = "Assets/Main/Sprites/UI/Common/Common_icon_wood.png"
ResourceTypeIconName[ResourceType.FORMATION_STAMINA] = "Assets/Main/Sprites/UI/Common/Common_icon_stamina"
ResourceTypeIconName[ResourceType.People] = "Assets/Main/Sprites/UI/Common/Common_icon_people"
ResourceTypeIconName[ResourceType.MasteryPoint] = "Assets/Main/Sprites/UI/UIMastery/UImaster_icon"

function ResourceManager:__init()
	
end

function ResourceManager:__delete()
	
end

--获取产出资源的建筑
function ResourceManager:GetResourceOutBuildings(resourceType) 
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
    if template ~= nil then
        return template.out_building
    end
    return nil
end
--获取产出资源所有建筑的uuid
function ResourceManager:GetResourceOutBuildingUids(resourceType)
    local result = {}
    local buildIds = self:GetResourceOutBuildings(resourceType)
    if buildIds ~= nil then
        for k,v in pairs(buildIds) do
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
            if list ~= nil then
                for k1,v1 in ipairs(list) do
                    table.insert(result, v1.uuid)
                end
            end
        end
    end
    return result
end

--统一接口获取资源名字（表里有去读表，没有读枚举,枚举暂时不需要表里都有）
function ResourceManager:GetResourceNameByType(resourceType)
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
    if template ~= nil then
        return Localization:GetString(template.name)
    end
    return ""
end

--统一接口获取资源图片（表里有去读表，没有读枚举,枚举暂时不需要表里都有）
function ResourceManager:GetResourceIconByType(resourceType)
    if resourceType == ResourceType.Meal then
        local config = DataCenter.VitaManager:GetCurSelectFoodParam()
        return string.format(LoadPath.UIMain, config.icon)
    end
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
    if template ~= nil then
        return string.format(LoadPath.CommonPath, template.icon)
    end
    return ResourceTypeIconName[resourceType]
end

local ResourceProductFurniture =
{
    [ResourceType.Food] = FurnitureType.HuntingTool,
    [ResourceType.Meal] = FurnitureType.CookingBench,
    [ResourceType.Plank] = FurnitureType.SawingTable,
    [ResourceType.Electricity] = FurnitureType.ForgingTable,
    [ResourceType.Steel] = FurnitureType.ElectricGenerator,
}

local FurnitureProductResource =
{
    [FurnitureType.HuntingTool] = ResourceType.Food,
    [FurnitureType.CookingBench] = ResourceType.Meal,
    [FurnitureType.SawingTable] = ResourceType.Plank,
    [FurnitureType.ForgingTable] = ResourceType.Electricity,
    [FurnitureType.ElectricGenerator] = ResourceType.Steel,
}

local ResourceAddEffect =
{
    [ResourceType.Food] = EffectDefine.FURNITURE_FOOD_ADD,
    [ResourceType.Plank] = EffectDefine.FURNITURE_PLANK_ADD,
    [ResourceType.Electricity] = EffectDefine.FURNITURE_STEEL_ADD,
    [ResourceType.Steel] = EffectDefine.FURNITURE_ELECTRICITY_ADD,
}

local ResourcePercentEffect =
{
    [ResourceType.Food] = EffectDefine.FURNITURE_FOOD_ADD_PERCENT,
    [ResourceType.Plank] = EffectDefine.FURNITURE_PLANK_ADD_PERCENT,
    [ResourceType.Electricity] = EffectDefine.FURNITURE_STEEL_ADD_PERCENT,
    [ResourceType.Steel] = EffectDefine.FURNITURE_ELECTRICITY_ADD_PERCENT,
}

local ResourceFasterEffect =
{
    [ResourceType.Meal] = EffectDefine.MEAL_WORK_FASTER,
    [ResourceType.Plank] = EffectDefine.PLANK_WORK_FASTER,
    [ResourceType.Electricity] = EffectDefine.STEEL_WORK_FASTER,
    [ResourceType.Steel] = EffectDefine.ELECTRICITY_WORK_FASTER,
}

local ResourceSlowerEffect =
{
    [ResourceType.Plank] = EffectDefine.PLANK_WORK_SLOWER,
    [ResourceType.Steel] = EffectDefine.ELECTRICITY_WORK_SLOWER,
}

-- 获取产出资源的家具
function ResourceManager:GetResourceProductFurniture(resourceType)
    return ResourceProductFurniture[resourceType]
end

-- 获取家具产出的资源
function ResourceManager:GetFurnitureProductResource(fId)
    return FurnitureProductResource[fId]
end

-- 获取资源产出数量增加作用号
function ResourceManager:GetResourceAddEffect(resourceType)
    return ResourceAddEffect[resourceType]
end

-- 获取资源产出数量百分比作用号
function ResourceManager:GetResourcePercentEffect(resourceType)
    return ResourcePercentEffect[resourceType]
end

-- 获取资源产出时间缩短作用号
function ResourceManager:GetResourceFasterEffect(resourceType)
    return ResourceFasterEffect[resourceType]
end

-- 获取资源产出时间延长作用号
function ResourceManager:GetResourceSlowerEffect(resourceType)
    return ResourceSlowerEffect[resourceType]
end

-- 小人在家具上工作一次增加多少
function ResourceManager:GetResidentProductCount(rUuid)
    local residentData = DataCenter.VitaManager:GetResidentData(rUuid)
    if residentData == nil or residentData:IsReady() or residentData:IsSick() then
        return 0
    end
    
    local fUuid = residentData.fUuid
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    if furnitureInfo == nil or furnitureInfo.lv <= 0 then
        return 0
    end
    
    local bUuid = furnitureInfo.bUuid
    local resType = DataCenter.ResourceManager:GetFurnitureProductResource(furnitureInfo.fId)
    if resType == nil then
        return 0
    end
    
    -- 基础值
    local baseCount = DataCenter.FurnitureManager:GetFurnitureLocalNum(fUuid, 2)
    
    -- 百分比加成
    local percentEffectId = DataCenter.ResourceManager:GetResourcePercentEffect(resType) or 0
    local globalPercent = LuaEntry.Effect:GetGameEffect(percentEffectId)
    local buildPercent = LuaEntry.Effect:GetBuildEffect(bUuid, percentEffectId)
    local residentPercent = residentData:GetEffectVal(percentEffectId)
    
    -- 数量加成
    local addEffectId = DataCenter.ResourceManager:GetResourceAddEffect(resType) or 0
    local globalAdd = LuaEntry.Effect:GetGameEffect(addEffectId)
    local buildAdd = LuaEntry.Effect:GetBuildEffect(bUuid, addEffectId)
    local residentAdd = residentData:GetEffectVal(addEffectId)
    
    local count = baseCount * (1 + (globalPercent + buildPercent + residentPercent) * 0.01) + (globalAdd + buildAdd + residentAdd)
    return count
end

-- 小人在家具上工作一次所需时间(秒)
function ResourceManager:GetResidentProductTime(rUuid)
    local residentData = DataCenter.VitaManager:GetResidentData(rUuid)
    if residentData == nil or residentData:IsReady() or residentData:IsSick() then
        return 0
    end
    
    local fUuid = residentData.fUuid
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    if furnitureInfo == nil or furnitureInfo.lv <= 0 then
        return 0
    end
    local furnitureLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
    if furnitureLevelTemplate == nil then
        return 0
    end
    
    local bUuid = furnitureInfo.bUuid
    local resType = DataCenter.ResourceManager:GetFurnitureProductResource(furnitureInfo.fId)
    if resType == nil then
        return 0
    end
    
    -- 基础值
    local baseTime = DataCenter.FurnitureManager:GetFurnitureLocalNum(fUuid, 1)
    
    -- 最小值
    local minTime = tonumber(furnitureLevelTemplate.para8) or 0
    
    -- 缩短
    local fasterEffectId = DataCenter.ResourceManager:GetResourceFasterEffect(resType) or 0
    local globalFaster = LuaEntry.Effect:GetGameEffect(fasterEffectId)
    local buildFaster = LuaEntry.Effect:GetBuildEffect(bUuid, fasterEffectId)
    local residentFaster = residentData:GetEffectVal(fasterEffectId)
    
    -- 延长
    local slowerEffectId = DataCenter.ResourceManager:GetResourceSlowerEffect(resType) or 0
    local globalSlower = LuaEntry.Effect:GetGameEffect(slowerEffectId)
    local buildSlower = LuaEntry.Effect:GetBuildEffect(bUuid, slowerEffectId)
    local residentSlower = residentData:GetEffectVal(slowerEffectId)
    
    local time = baseTime - (globalFaster + buildFaster + residentFaster) + (globalSlower + buildSlower + residentSlower)
    time = math.max(time, minTime, 0.1)
    return time
end

-- 获取资源产量/秒
function ResourceManager:GetResourceProduction(resType)
    local production = 0
    for rUuid, residentData in pairs(DataCenter.VitaManager:GetResidentDataDict()) do
        local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(residentData.fUuid)
        if furnitureInfo and furnitureInfo.lv > 0 and DataCenter.ResourceManager:GetFurnitureProductResource(furnitureInfo.fId) == resType then
            local count = DataCenter.ResourceManager:GetResidentProductCount(rUuid)
            local time = DataCenter.ResourceManager:GetResidentProductTime(rUuid)
            if count > 0 and time > 0 then
                production = production + count / time
            end
        end
    end
    return production
end

-- 获取资源消耗/秒
function ResourceManager:GetResourceCost(resourceType)
    return 0
end

function ResourceManager:GetResourceCanSearchLevelByType(resourceType)
    local level = 1
    if self.maxLevelDic == nil then
        self.maxLevelDic = {}
        local k1 = LuaEntry.DataConfig:TryGetStr("search_mine", "k1")
        local arr = string.split(k1,"|")
        if #arr>0 then
            for i=1,#arr do
                local arrTemp = string.split(arr[i],";")
                if #arrTemp ==2 then
                    local rType = toInt(arrTemp[1])
                    local lv = toInt(arrTemp[2])
                    self.maxLevelDic[rType] =lv
                end
            end
        end
    end
    if self.maxLevelDic[resourceType]~=nil then
        level = self.maxLevelDic[resourceType]
    end
    return level
end
return ResourceManager