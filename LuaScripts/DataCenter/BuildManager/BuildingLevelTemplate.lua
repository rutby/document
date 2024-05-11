--- Created by shimin
--- DateTime: 2023/12/4 20:42
---
local BuildingLevelTemplate = {}

function BuildingLevelTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if BuildingLevelTemplate[key] ~= nil then
            return BuildingLevelTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

--获得所需资源
function BuildingLevelTemplate:GetNeedResource()
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
    local result = {}
    for k, v in ipairs(self.cost_consume) do
        if v[2] ~= nil and v[2] > 0 then
            local param = {}
            param.resourceType = v[1]
            param.count = v[2]
            if v[1] == ResourceType.Oil then -- 黑曜石
                if template:IsSeasonBuild() then
                    param.count = math.floor(v[2] * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_OBSIDIAN_DEC) / 100))
                end
            elseif v[1] == ResourceType.FLINT then -- 火晶石
                if template:IsSeasonBuild() then
                    param.count = math.floor(v[2] * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_FLINT_DEC) / 100))
                end
            end
            table.insert(result, param)
        end
    end
    return result
end
--获得前置建筑
function BuildingLevelTemplate:GetPreBuild()
    return self.building
end
--获得所需道具
function BuildingLevelTemplate:GetNeedItem()
    return self.item
end

--获得所需资源道具
function BuildingLevelTemplate:GetNeedResourceItem()
    return self.cost_resource
end

--获取采集速度
function BuildingLevelTemplate:GetCollectSpeed()
    if self.para1 ~= nil and self.para1 ~= "" then
        local original = tonumber(self.para1)
        local addRate = 0 --速度增加百分比
        local add = 0 --每小时速度增加
        local buildType = DataCenter.BuildManager:GetBuildId(self.id)
        if buildType == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildType == BuildingTypes.FUN_BUILD_GROCERY_STORE then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOTEL_MONEY_SPEED_ADD)
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_SPEED_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_VILLA  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOUSE_MONEY_SPEED_ADD)
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_SPEED_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_OIL  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GAS_BUILD_COLLECT_SPEED_ADD)
            add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.OIL_SPEED)
        elseif buildType == BuildingTypes.FUN_BUILD_STONE  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_SPEED_ADD)
            add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_SPEED)
        elseif buildType == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.SOLAR_ELECTRICITY_SPEED_ADD)
            add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_SPEED)
        elseif buildType == BuildingTypes.FUN_BUILD_ELECTRICITY  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.FIRE_ELECTRICITY_SPEED_ADD)
            add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.FOOD_SPEED)
        elseif buildType == BuildingTypes.FUN_BUILD_WATER  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_BUILD_COLLECT_SPEED_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_GREEN_CRYSTAL  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GREEN_CTRSTAL_SPEED_ADD)
        end
        
        return original * ( 1 + addRate / 100) + (add / 3600)
    end
    return 0
end
--获取最大采集量
function BuildingLevelTemplate:GetCollectMax()
    if self.para2 ~= nil and self.para2 ~= "" then
        local original = tonumber(self.para2)
        local addRate = 0
        local buildType = DataCenter.BuildManager:GetBuildId(self.id)

        if buildType == BuildingTypes.FUN_BUILD_WATER  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_CAPACITY_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_STONE  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_CAPACITY_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_OIL  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GAS_CAPACITY_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.FIRE_ELECTRICITY_CAPACITY_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildType == BuildingTypes.FUN_BUILD_GROCERY_STORE then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOTEL_MONEY_CAPACITY_ADD)
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_CAPACITY_ADD)
        elseif buildType == BuildingTypes.FUN_BUILD_VILLA  then
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOUSE_MONEY_CAPACITY_ADD)
            addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_CAPACITY_ADD)
        end
        local x,y = math.modf(original * ( 1 + addRate / 100))
        return x
    end
    return 0
end

function BuildingLevelTemplate:GetCollectMaxOthers()
    if self.para2 ~= nil and self.para2 ~= "" then
        local original = tonumber(self.para2)
        return original
    end
    return 0
end
--获取消耗速度
function BuildingLevelTemplate:GetCostSpeed()
    if self.para5 ~= nil and self.para5 ~= "" then
        return tonumber(self.para5)
    end
    return 0
end
--获取消耗最大容量
function BuildingLevelTemplate:GetCostMax()
    if self.para4 ~= nil and self.para4 ~= "" then
        return tonumber(self.para4)
    end
    return 0
end

--生产道具的速度
function BuildingLevelTemplate:GetOutItemSpeed()
    if self.para4 ~= nil and self.para4 ~= "" then
        return tonumber(self.para4)
    end
    return 0
end
--生产道具需要的值
function BuildingLevelTemplate:GetOutItemNeedValue()
    if self.para5 ~= nil and self.para5 ~= "" then
        return tonumber(self.para5)
    end
    return 1
end

--大本城防值上限
function BuildingLevelTemplate:GetDefenceWallMax()
    if self.max_hp ~= nil and self.max_hp ~= "" then
        return tonumber(self.max_hp)
    end
    return 0
end
--大本城防值恢复速度
function BuildingLevelTemplate:GetDefenceWallCoverSpeed()
    if not string.IsNullOrEmpty(self.para1) then
        local speed = tonumber(self.para1)
        if speed == nil then
            speed = 0
        end
        return speed
    end
    return 0
end

--获取道具收取后显示的多语言id
function BuildingLevelTemplate:GetShowTalkAfterGetItem()
    if self.para7 ~= nil and self.para7 ~= "" then
        local vec = string.split(self.para7,";")
        local index = math.random(1,#vec)
        return vec[index]
    end
    return ""
end

--获取建筑升级时间毫秒(与服务器保持一致)
function BuildingLevelTemplate:GetBuildTime()
    local effectAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_SPEED_ADD)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
    if template:IsSeasonBuild() then
        effectAdd = effectAdd + LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_BUILD_SPEED_INC)
    end
    local decEffect  = LuaEntry.Effect:GetGameEffect(EffectDefine.THRONE_EFFECT_35301)
    effectAdd = effectAdd-decEffect
    return math.floor(self.time * 1000 / (1 + effectAdd / 100)) 
end

--获取显示气泡的百分比
function BuildingLevelTemplate:GetShowBubblePercent()
    if self.para3 ~= nil and self.para3 ~= "" then
        local num = tonumber(self.para3)
        if num > 100 then
            num = 100
        end
        return num / 100
    end
    return 0.05
end

function BuildingLevelTemplate:GetLevelRange()
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
    return template:GetLevelRange()
end

--获取生产资源道具的id
function BuildingLevelTemplate:GetOutResourceItemId()
    if self.para4 ~= nil and self.para4 ~= "" then
        return tonumber(self.para4)
    end
end

--获得所需人口
function BuildingLevelTemplate:GetRewardNeedTalent()
    return self.rewardNeedTalentId
end

-- 获取最大生命值
function BuildingLevelTemplate:GetMaxHp(includeEquipment)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
    local maxHp = tonumber(self.max_hp) or 0
    if template:IsSeasonBuild() then
        maxHp = toInt(maxHp + LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_HP_INC))
    elseif includeEquipment == true and template.id == BuildingTypes.WORM_HOLE_CROSS then
        local carIndex = DataCenter.EquipmentDataManager:GetCarIndexByBuildingId(BuildingTypes.WORM_HOLE_CROSS)
        maxHp = Mathf.Round(maxHp + DataCenter.EquipmentDataManager:GetEffectValue(carIndex, EffectDefine.BUILDING_HP_EFFECT))
    end
    return maxHp
end

--获得城内模型名字
function BuildingLevelTemplate:GetCityModelName()
    return self.model
end

--获得城内模型名字
function BuildingLevelTemplate:GetWorldModelName()
    return self.model_world
end

--获取显示的家具列表
function BuildingLevelTemplate:GetFurnitureList()
    return self.furniture
end

--是否有这个家具
function BuildingLevelTemplate:HaveFurniture(fId, index)
    local curIndex = 0
    for k,v in ipairs(self.furniture) do
        if v == fId then
            curIndex = curIndex + 1
            if curIndex == index then
                return true
            end
        end
    end
    return false
end


---------
--获取产出资源建筑显示棋牌颜色的最大百分比
function BuildingLevelTemplate:GetOutResourceMaxColorPercent()
    if self.para2 ~= nil and self.para2 ~= "" then
        local num = tonumber(self.para2)
        if num > 100 then
            num = 100
        end
        return num / 100
    end
    return 1
end

--获得前置科技
function BuildingLevelTemplate:GetNeedScience()
    local result = {}
    if self.need_science ~= nil then
        for k,v in ipairs(self.need_science) do
            local param = {}
            param.scienceId = CommonUtil.GetScienceBaseType(v)
            param.level = CommonUtil.GetScienceLv(v)
            table.insert(result, param)
        end
    end
    return result
end

-- 通过建造数量获得所需人口
function BuildingLevelTemplate:GetNeedPeopleNumByBuildNum(buildNum)
    return self.people[buildNum] or 0
end

--获得当前建筑所需人口
function BuildingLevelTemplate:GetNeedPeopleNum()
    if self.people[2] ~= nil then
        local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(self.id)
        return self:GetNeedPeopleNumByBuildNum(buildNum + 1)
    end
    return self.people[1] or 0
end

function BuildingLevelTemplate:GetGuideCanBuildMaxNum()
    local result = 999
    if LuaEntry.DataConfig:CheckSwitch("building_boot_switch") then
        if self.need_boot ~= nil and self.need_boot[1] ~= nil then
            for k,v in ipairs(self.need_boot) do
                if not DataCenter.GuideManager:IsDoneThisGuide(v.needGuideId) then
                    return v.canBuildNun - 1
                else
                    result = v.canBuildNun
                end
            end
        end
    end

    return result
end


function BuildingLevelTemplate:GetQuestCanBuildMaxNum()
    local result = 999
    if self.need_quest ~= nil and self.need_quest[1] ~= nil then
        for k,v in ipairs(self.need_quest) do
            if not DataCenter.TaskManager:IsFinishTask(v.needQuestId) then
                return v.canBuildNun - 1
            else
                result = v.canBuildNun
            end
        end
    end
    return result
end

function BuildingLevelTemplate:GetChapterCanBuildMaxNum()
    local result = 999
    return result
end

--是否是家具主建筑
function BuildingLevelTemplate:IsFurnitureBuild()
    return self.furniture[1] ~= nil
end

--获取家具模型的index
function BuildingLevelTemplate:GetFurnitureModelIndex(fId, index)
    local curIndex = FurnitureIndex
    for k, v in ipairs(self.furniture) do
        if v == fId then
            if curIndex == index then
                return k
            else
                curIndex = curIndex + 1
            end
        end
    end
end

--获取家具升级需要的主建筑等级
function BuildingLevelTemplate:GetFurnitureNeedMainLevel()
    if self.building[1] ~= nil and self.building[1][1] ~= nil then
        return self.building[1][1]
    end
    return 0
end

return BuildingLevelTemplate