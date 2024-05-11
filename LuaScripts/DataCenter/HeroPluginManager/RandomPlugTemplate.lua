--- Created by shimin
--- DateTime: 2023/6/5 15:20
--- 随机英雄插件表

local RandomPlugTemplate = BaseClass("RandomPlugTemplate")
local Localization = CS.GameEntry.Localization

local HandBookType =
{
    No = 0,
    Show = 1,
}

function RandomPlugTemplate:__init()
    self.id = 0--插件id
    self.name = 0--插件名字
    self.value_type = {}--显示属性数值类型
    self.value = {}--显示属性数值
    self.lv = 0--等级
    self.unlock_lv = 0--显示属性的等级
    self.type = HeroPluginActiveType.Army--生效范围，0或空为编队生效，1为英雄自身生效，用在属性大列表里显示用
    self.sp_tag = 0--填1，表示这个属性为稀有属性，洗到这个属性没保存的话，再点洗，要先提示玩家有稀有属性，是否继续洗练
    self.effect_group = 0--属性组，按这个大小排序
    self.rarity = HeroPluginQualityType.White--品质
    self.type1 = HeroPluginOutType.Random--插件来源
    self.score = 0--基础分数
    self.score_add = 0--倍率分数
    self.effect_level = 0--随机的最高数值（判断顶级）
    self.effect_level_add = {}--每个等级每个作用号的倍率数值
    self.value_norandom = {}--不随机的值填在value_norandom字段中，多个值用竖线分割
    self.value_para = 0--value_para=1，将value和value_norandom中的值，依次传入文本的多个参数中如果value=0或不填，则将value和value_norandom中的值直接拼在文本后方
    self.handbook = HandBookType.No--handbook=1的词条才显示在属性详情界面
end

function RandomPlugTemplate:__delete()
    self.id = 0--插件id
    self.name = 0--插件名字
    self.value_type = {}--显示属性数值类型
    self.value = {}--显示属性数值
    self.lv = 0--等级
    self.unlock_lv = 0--显示属性的等级
    self.type = HeroPluginActiveType.Army--生效范围，0或空为编队生效，1为英雄自身生效，用在属性大列表里显示用
    self.sp_tag = 0--填1，表示这个属性为稀有属性，洗到这个属性没保存的话，再点洗，要先提示玩家有稀有属性，是否继续洗练
    self.effect_group = 0--属性组，按这个大小排序
    self.rarity = HeroPluginQualityType.White--品质
    self.type1 = HeroPluginOutType.Random--插件来源
    self.score = 0--基础分数
    self.score_add = 0--倍率分数
    self.effect_level = 0--随机的最高数值（判断顶级）
    self.effect_level_add = {}--每个等级每个作用号的倍率数值
    self.value_norandom = {}--不随机的值填在value_norandom字段中，多个值用竖线分割
    self.value_para = 0--value_para=1，将value和value_norandom中的值，依次传入文本的多个参数中如果value=0或不填，则将value和value_norandom中的值直接拼在文本后方
    self.handbook = HandBookType.No--handbook=1的词条才显示在属性详情界面
end

function RandomPlugTemplate:InitData(row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id") or 0
    self.name = row:getValue("name") or 0
    self.value_type = row:getValue("value_type") or {}
    self.value = row:getValue("value") or {}
    self.lv = row:getValue("lv") or 0
    self.unlock_lv = row:getValue("unlock_lv") or 0
    self.type = row:getValue("type") or HeroPluginActiveType.Army
    self.sp_tag = row:getValue("sp_tag") or 0
    self.effect_group = row:getValue("effect_group") or 0
    self.rarity = row:getValue("rarity") or HeroPluginQualityType.White
    self.type1 = row:getValue("type1") or HeroPluginOutType.Random
    self.score = row:getValue("score") or 0
    self.score_add = row:getValue("score_add") or 0
    self.effect_level = row:getValue("effect_level") or 0
    self.effect_level_add = row:getValue("effect_level_add") or {}
    self.value_norandom = row:getValue("value_norandom") or {}
    self.value_para = row:getValue("value_para") or 0
    self.handbook = row:getValue("handbook") or HandBookType.No
end

--获取显示的描述
function RandomPlugTemplate:GetDesc(level)
    local count = #self.value
    local para = {}
    if count > 0 then
        for i = 1, count, 1 do
            local num = self.value[i]
            if self.effect_level_add[i] ~= nil then
                num = num + level * self.effect_level_add[i]
            end
            local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i])
            table.insert(para, des)
        end
    end

    local no_count = #self.value_norandom
    if no_count > 0 then
        for i = 1, no_count, 1 do
            local num = self.value_norandom[i]
            local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i + count])
            table.insert(para, des)
        end
    end
    local result = ""
    if self.value_para == HeroPluginShowDesType.Behind then
        result = Localization:GetString(self.name)
        if para[1] ~= nil then
            for k, v in ipairs(para) do
                result = result .. v
            end
        end
    elseif self.value_para == HeroPluginShowDesType.Middle then
        result = Localization:GetString(self.name, table.unpack(para))
    end
    if self:IsSpecialShow() then
        return result
    end
    return string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(self.rarity), result)
end

--是否是稀有属性
function RandomPlugTemplate:IsSpecialTag()
    return self.sp_tag ~= 0
end

--获取插件的分数
function RandomPlugTemplate:GetScore(level)
    return self.score + self.score_add * level
end

--获取显示的描述(范围)
function RandomPlugTemplate:GetDescRange()
    local count = #self.value
    local para = {}
    if count > 0 then
        for i = 1, count, 1 do
            local num = self.value[i]
            local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i])

            if self.effect_level_add[i] ~= nil then
                num = num + self.effect_level * self.effect_level_add[i]
                des = des .. "~" .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i])
            end
            table.insert(para, des)
        end
    end
    local no_count = #self.value_norandom
    if no_count > 0 then
        for i = 1, no_count, 1 do
            local num = self.value_norandom[i]
            local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i + count])
            table.insert(para, des)
        end
    end
    local result = ""
    if self.value_para == HeroPluginShowDesType.Behind then
        result = Localization:GetString(self.name)
        if para[1] ~= nil then
            for k, v in ipairs(para) do
                result = result .. v
            end
        end
    elseif self.value_para == HeroPluginShowDesType.Middle then
        result = Localization:GetString(self.name, table.unpack(para))
    end
    if self:IsSpecialShow() then
        return result
    end
    return string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(self.rarity), result)
end

--获取固定插件的分数
function RandomPlugTemplate:GetConstScore()
    return self.score
end

--获取显示固定描述的名字
function RandomPlugTemplate:GetConstName()
    return Localization:GetString(self.name)
end

--获取显示固定描述的值
function RandomPlugTemplate:GetConstValue()
    if self.value[1] ~= nil then
        return DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(self.value[1], self.value_type[1])
    end
    if self.value_norandom[1] ~= nil then
        return DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(self.value_norandom[1], self.value_type[1])
    end
    return ""
end

--是否是稀有属性
function RandomPlugTemplate:GetRhombusNameByQuality()
    return DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.rarity)
end

--是否是特殊属性展示
function RandomPlugTemplate:IsSpecialShow()
    return self.rarity == HeroPluginQualityType.Gold
end

--是否是特殊属性展示
function RandomPlugTemplate:IsMax(level)
    return self.rarity >= HeroPluginQualityType.Orange and self.effect_level > 0 and self.effect_level <= level
end

--获取显示的名字部分（带颜色）
function RandomPlugTemplate:GetRangeName()
   local result = Localization:GetString(self.name)
    if self:IsSpecialShow() then
        return result
    end
    return string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(self.rarity), result)
end

--获取显示的名字（不带颜色）
function RandomPlugTemplate:GetRangeValue()
    local result = ""
    if self.value_para == HeroPluginShowDesType.Behind then
        local count = #self.value
        local para = {}
        if count > 0 then
            for i = 1, count, 1 do
                local num = self.value[i]
                local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i])
                if self.effect_level_add[i] ~= nil then
                    num = num + self.effect_level * self.effect_level_add[i]
                    des = des .. "~" .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i])
                end
                table.insert(para, des)
            end
        end
        local no_count = #self.value_norandom
        if no_count > 0 then
            for i = 1, no_count, 1 do
                local num = self.value_norandom[i]
                local des = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(num, self.value_type[i + count])
                table.insert(para, des)
            end
        end
        if para[1] ~= nil then
            for k, v in ipairs(para) do
                result = result .. v
            end
        end
    end
    return result
end

--是否在属性详情中展示
function RandomPlugTemplate:IsShowInDetail()
    return self.handbook == HandBookType.Show
end

return RandomPlugTemplate