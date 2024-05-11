--- Created by shimin
--- DateTime: 2021/6/8 10:40
local ScienceTemplate = {}

function ScienceTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if ScienceTemplate[key] ~= nil then
            return ScienceTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

--获得所需资源
function ScienceTemplate:GetNeedResource()
    local result = {}
    for k,v in ipairs(self.research_need) do
        if v[2] > 0 then
            table.insert(result, {resourceType = v[1], count = v[2]})
        end
    end
    return result
end
--获得所需道具
function ScienceTemplate:GetNeedItem()
    local result = {}
    for k,v in ipairs(self.goods_need) do
        if v[2] > 0 then
            local param = {}
            param.itemId = v[1]
            param.count =  v[2]
            if param.itemId == 200034 then-- 齿轮消耗减少
                param.count = math.floor(param.count * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.DECREASE_GEAR_COST) / 100))
            end
            table.insert(result, param)
        end
    end
    return result
end
--获得所需前置建筑
function ScienceTemplate:GetNeedBuild()
    local result = {}
    for k,v in ipairs(self.building_condition) do
        table.insert(result, {buildId = CommonUtil.GetBuildBaseType(v), level = CommonUtil.GetBuildLv(v)})
    end
    return result
end

--获取科技研究时间
function ScienceTemplate:GetScienceTime()
    local effectAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.SCIENCE_SPEED_ADD)
    local dec = LuaEntry.Effect:GetGameEffect(EffectDefine.THRONE_EFFECT_35311)
    effectAdd = effectAdd-dec
    local x,y = math.modf(self.time / (1 + effectAdd / 100))
    return x
end

return ScienceTemplate