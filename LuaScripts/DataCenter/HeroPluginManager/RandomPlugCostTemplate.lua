--- Created by shimin
--- DateTime: 2023/6/6 11:36
--- 随机英雄插件消耗表

local RandomPlugCostTemplate = BaseClass("RandomPlugCostTemplate")
local Localization = CS.GameEntry.Localization

function RandomPlugCostTemplate:__init()
    self.id = 0--id
    self.lv = 0--等级
    self.cost = 0--升级消耗数量
    self.random_cost = 0--随机消耗数量
    self.item = {}--每个阵营消耗的道具id
end

function RandomPlugCostTemplate:__delete()
    self.id = 0--id
    self.lv = 0--等级
    self.cost = 0--升级消耗数量
    self.random_cost = 0--随机消耗数量
    self.item = {}--每个阵营消耗的道具id
end

function RandomPlugCostTemplate:InitData(row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id") or 0
    self.lv = row:getValue("lv") or 0
    self.cost = row:getValue("cost") or 0
    self.random_cost = row:getValue("random_cost") or 0

    self.item = {}
    local item = row:getValue("item") or ""
    if item ~= "" then
        local spl = string.split_ss_array(item, "|")
        for k,v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ";")
            if spl1[2] ~= nil then
                self.item[spl1[2]] = spl1[1]
            end
        end
    end
end

--获取消耗的道具id
function RandomPlugCostTemplate:GetCostItemId(campType)
    if self.item[campType] ~= nil then
        return self.item[campType]
    end
    return 0
end

--获取升级消耗的数量
function RandomPlugCostTemplate:GetUpgradeCostNum(campType)
    local result = self.cost
    --联邦阵营英雄插件升级消耗减少		百分比	对应阵营英雄插件，升级消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容	
    if campType == HeroCamp.MAFIA then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UPGRADE_COST_MAFIA) / 100)
    elseif campType == HeroCamp.NEW_HUMAN then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UPGRADE_COST_NEW_HUMAN) / 100)
    elseif campType == HeroCamp.UNION then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UPGRADE_COST_UNION) / 100)
    elseif campType == HeroCamp.ZELOT then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_UPGRADE_COST_ZEALOT) / 100)
    end
    --结果四舍五入
    return Mathf.Round(result)
end

--获取升随机消耗的数量
function RandomPlugCostTemplate:GetRefineCostNum(campType)
    local result = self.random_cost
    --联邦阵营英雄插件随机消耗减少		百分比	对应阵营英雄插件，随机消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    if campType == HeroCamp.MAFIA then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_REFINE_COST_MAFIA) / 100)
    elseif campType == HeroCamp.NEW_HUMAN then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_REFINE_COST_NEW_HUMAN) / 100)
    elseif campType == HeroCamp.UNION then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_REFINE_COST_UNION) / 100)
    elseif campType == HeroCamp.ZELOT then
        result = result * (1 - LuaEntry.Effect:GetGameEffect(EffectDefine.HERO_PLUG_REFINE_COST_ZEALOT) / 100)
    end
    --结果四舍五入
    return Mathf.Round(result)
end

return RandomPlugCostTemplate