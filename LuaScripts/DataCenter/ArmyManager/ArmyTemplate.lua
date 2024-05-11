---
--- Created by shimin
--- DateTime: 2021/6/30 21:08
---

local ArmyTemplate = {}

function ArmyTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if ArmyTemplate[key] ~= nil then
            return ArmyTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

--获取攻击增加值
function ArmyTemplate:GetAttackAddValue()
    return 0
end

--获取防御增加值
function ArmyTemplate:GetDefenceAddValue()
    return 0
end

--获取血量增加值
function ArmyTemplate:GetHealthAddValue()
    return 0
end

--获取速度增加值
function ArmyTemplate:GetSpeedValue()
    return self.speed
end

--获取负重增加值
function ArmyTemplate:GetLoadAddValue()
    return 0
end

--获取减少治疗值
function ArmyTemplate:GetTreatValue()
    local result = LuaEntry.Effect:GetGameEffect(EffectDefine.REPAIR_SPEED_ADD)
    if self.arm == ArmType.Tank then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.REPAIR_SPEED_ADD_TANK)
    elseif self.arm == ArmType.Robot then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.REPAIR_SPEED_ADD_ROBOT)
    elseif self.arm == ArmType.Plane then
        result = result + LuaEntry.Effect:GetGameEffect(EffectDefine.REPAIR_SPEED_ADD_PLANE)
    end
    return result
end

--获取实际治疗消耗的时间
function ArmyTemplate:GetTreatTime()
    local value = self.treat_time / (1 + self:GetTreatValue() / 100)
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        local extraAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.GAME_EFFECT_30317)
        local percent = (1 + (extraAdd / 100))
        value = value/percent
    end
    return value
end

--获取实际治疗消耗的材料
function ArmyTemplate:GetTreatResource()
    local result = {}
    for k,v in ipairs(self.treat_resource) do
        local param = {}
        param.resourceType = v[1]
        param.count = v[2]
        table.insert(result,param)
    end
    return result
end

--获取训练时间
function ArmyTemplate:GetTrainTime()
    local original = self.time
    local effectAdd = 0
    local effect = self:GetTrainTimeEffect()
    if effect ~= nil then
        if self.arm == ArmType.Trap then
            effectAdd = LuaEntry.Effect:GetGameEffect(effect)
        else
            effectAdd = LuaEntry.Effect:GetGameEffect(effect) + LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_TRAIN_SPEED_ADD)
        end
    end
    return original / (1 + effectAdd / 100)
end

--获取最大训练量
function ArmyTemplate:GetMaxTrainValue()
    local original = self.max_train
    local effectAdd = 0
    local effect = self:GetTrainMaxNumEffect()
    if effect ~= nil then
        if self.arm == ArmType.Trap then
            effectAdd = LuaEntry.Effect:GetGameEffect(effect)
        else
            effectAdd = LuaEntry.Effect:GetGameEffect(effect) + LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_TRAIN_MAX_ADD)
        end
    end
    return math.floor(original  + effectAdd)
end

function ArmyTemplate:GetTrainTimeEffect()
    if self.arm == ArmType.Tank then
        return EffectDefine.TANK_TRAIN_SPEED_ADD
    elseif self.arm == ArmType.Robot then
        return EffectDefine.ROBOT_TRAIN_SPEED_ADD
    elseif self.arm == ArmType.Plane then
        return EffectDefine.PLANE_TRAIN_SPEED_ADD
    elseif self.arm == ArmType.Trap then
        return EffectDefine.TRAP_TRAIN_SPEED_ADD
    end
end

function ArmyTemplate:GetUpgradeStateEffect()
    if self.arm == ArmType.Tank then
        return EffectDefine.TANK_UPGRADE_SWITCH
    elseif self.arm == ArmType.Robot then
        return EffectDefine.INFANTRY_UPGRADE_SWITCH
    elseif self.arm == ArmType.Plane then
        return EffectDefine.PLANE_UPGRADE_SWITCH
    elseif self.arm == ArmType.Trap then
        return EffectDefine.TRAP_UPGRADE_SWITCH
    end
end
function ArmyTemplate:GetTrainMaxNumEffect()
    if self.arm == ArmType.Tank then
        return EffectDefine.TANK_TRAIN_NUM_ADD
    elseif self.arm == ArmType.Robot then
        return EffectDefine.ROBOT_TRAIN_NUM_ADD
    elseif self.arm == ArmType.Plane then
        return EffectDefine.PLANE_TRAIN_NUM_ADD
    elseif self.arm == ArmType.Trap then
        return EffectDefine.TRAP_TRAIN_NUM_ADD
    end
end
--兵种类型和effect.lua表字段映射关系
function ArmyTemplate:GetAddValueEffectName()
    if self.arm == ArmType.Tank then
        return "arm_1"
    elseif self.arm == ArmType.Robot then
        return "arm_2"
    elseif self.arm == ArmType.Plane then
        return "arm_3"
    elseif self.arm == ArmType.Trap then
        return "arm_4"
    end
end

--获取消耗的资源
function ArmyTemplate:GetNeedResource()
    local list = {}
    if self.arm ~= ArmType.Trap then
        for k,v in ipairs(self.resource_need) do
            local param = {}
            param.resourceType = v[1]
            param.count = v[2]
            if param.resourceType == ResourceType.Money then
                param.count = math.floor(param.count * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.DECREASE_TRAIN_COIN_COST) / 100))
            end
            table.insert(list, param)
        end
    end
    return list
end

--是否是雇佣兵
function ArmyTemplate:IsMercenary()
    return self.mercenary ~= nil and self.mercenary > 0
end

return ArmyTemplate