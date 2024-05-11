--- Created by shimin
--- DateTime: 2021/5/10 19:20
---
local BuildingDesTemplate = {}

function BuildingDesTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if BuildingDesTemplate[key] ~= nil then
            return BuildingDesTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

--获取该建筑最大可建造的数量
function BuildingDesTemplate:GetMaxCanBuildNum()
    local result = 0
    if self.unlock_num[1] ~= nil then
        local maxData = self.unlock_num[#self.unlock_num]
        if maxData ~= nil and maxData[1] ~= nil then
            --每一个离谱的写法背后都有一个更离谱的需求
            result = maxData[1][1][1]
        end
    end
    return result
end

--获取该建筑当前最大可建造的数量
function BuildingDesTemplate:GetCurMaxCanBuildNum()
    local result = 0
    for k,v in ipairs(self.unlock_num) do
        if v[2] ~= nil then
            local own = true
            for k1, v1 in ipairs(v[2]) do
                if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
                    own = false
                end
            end
            if own then
                result = v[1][1][1]
            else
                return result
            end
        end
    end
    return result
end

--获取该建筑不可建造的条件
function BuildingDesTemplate:GetCurNoBuildUnlockBuildInfo()
    for k,v in ipairs(self.unlock_num) do
        for k1, v1 in pairs(v[2]) do
            if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
                local result = {}
                result.buildId = v1[1]
                result.level = v1[2]
                result.canBuildNun = v[1][1][1]
                return result
            end
        end
    end
    return nil
end

function BuildingDesTemplate:GetReCommendPosition()
    local result = {}
    if self.recommended_location[1] ~= nil then
        for k, v in ipairs(self.recommended_location) do
            table.insert(result, SceneUtils.TileXYToIndex(DataCenter.BuildManager.main_city_pos.x + v[1],
                    DataCenter.BuildManager.main_city_pos.y + v[2], ForceChangeScene.City))
        end
    end
    return result
end

function BuildingDesTemplate:GetLevelRange(level)
    local max = self:GetBuildMaxLevel()
    local min = 1
    return min, max
end


function BuildingDesTemplate:CanMove()
    if self:IsSeasonBuild() then
        return false
    end
    return false
end

function BuildingDesTemplate:IsSeasonBuild()
    return self.tab_type == UIBuildListTabType.SeasonBuild
end

function BuildingDesTemplate:GetBuildMaxLevel()
    local retLv = 1
    local count = #self.max_level
    if count > 0 then
        local season = DataCenter.SeasonDataManager:GetSeason() or 0
        if season + 1 < count then
            retLv = self.max_level[season + 1]
        else
            retLv = self.max_level[count]
        end
    end

    if self.id == BuildingTypes.SEASON_DESERT_ARMY_ATTACK_1 or self.id == BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2 then
        local effNum = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_MAXLV_1)
        retLv = retLv + effNum
    elseif self.id == BuildingTypes.SEASON_DESERT_ARMY_DEFEND_1 or self.id == BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2 then
        local effNum = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_BUILDING_MAXLV_2)
        retLv = retLv + effNum
    elseif self.id == BuildingTypes.SEASON_DESERT_MAX_FORMATION_SIZE_1 then
        local effNum = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_LV_SEASON_DESERT_MAX_FORMATION_SIZE_1)
        retLv = retLv + effNum
    end
    return retLv
end

--是否可以显示该建筑（判开关）
function BuildingDesTemplate:CanShow()
    if self.function_on ~= nil and self.function_on ~= "" then
        if not LuaEntry.DataConfig:CheckSwitch(self.function_on) then
            return false
        end
    end
    return true
end

--获取显属性（没达到条件不显示）
function BuildingDesTemplate:GetShowLocalEffect(index)
    local param = self.effect_local[index]
    if param ~= nil and DataCenter.BuildManager.MainLv >= (param[3] or 0) then
        return param
    end
    return nil
end

--获取建筑位置
function BuildingDesTemplate:GetPosIndex()
    if self.build_type == BuildType.Furniture or self:IsSeasonBuild() or self.pos[1] == nil then
        return 0
    end
    return SceneUtils.WorldToTileIndex(self:GetPosition(), ForceChangeScene.City)
end

--获取建筑位置
function BuildingDesTemplate:GetPosition()
    if self.pos[1] == nil then
        return Vector3.New(0, 0, 0)
    end
    return Vector3.New(self.pos[1], self.pos[2], self.pos[3])
end

--获取建筑位置
function BuildingDesTemplate:GetRotation()
    return self.rotation
end

--是否显示模型
function BuildingDesTemplate:IsShowModel()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.id)
    if buildData ~= nil then
        return true
    else
        --判断前置建筑
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.id, 0)
        if levelTemplate ~= nil then
            if levelTemplate.model == "" then
                return false
            end
            local preBuild =  levelTemplate:GetPreBuild()
            if preBuild ~= nil then
                for k1, v1 in ipairs(preBuild) do
                    if not DataCenter.BuildManager:IsExistBuildByTypeLv(v1[1], v1[2]) then
                        return false
                    end
                end
            end
        end
    end
    
    return true
end


return BuildingDesTemplate