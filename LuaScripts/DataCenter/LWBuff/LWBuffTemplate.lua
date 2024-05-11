---
--- Pve 丧尸配置
---
---@class DataCenter.LWBuff.LWBuffTemplate
local LWBuffTemplate = BaseClass("LWBuffTemplate")

local function __init(self)
    
end

local function __delete(self)
    if self.active_effect_sound then
        self.active_effect_sound:Delete()
        self.active_effect_sound = nil
    end
end

local function InitData(self, row)
    if row == nil then
        return
    end

    self.id = tonumber(row:getValue("id")) or 0
    self.type = tonumber(row:getValue("type")) or 0
    -- self.para = row:getValue("para")
    self.buff_time = tonumber(row:getValue("buff_time")) or 0
    self.buff_time = self.buff_time * 0.001
    self.additive_type = tonumber(row:getValue("additive_type")) or 0
    self.max_level = tonumber(row:getValue("max_level")) or 0
    self.group = tonumber(row:getValue("group")) or 0
    self.active_effect = row:getValue("active_effect")
    self.activing_effect = row:getValue("activing_effect")
    self.ignore_rotate = row:getValue("ignore_rotate") == "1"
    self.sub_type = tonumber(row:getValue("sub_type")) or 0
    self.para = {}
    self.sortedParaKey = {}
    self.diffValue = {}
    local para = row:getValue("para")
    if (self.sub_type == BuffSubType.ShieldFromCasterHp) or (self.sub_type == BuffSubType.ShieldFromValue) then
        self.para = tonumber(para)
    else
        if not string.IsNullOrEmpty(para) then
            local strs = string.split(para, ",")
            for _,str in pairs(strs) do
                local pair= string.split(str, ";")
                self.para[tonumber(pair[1])]=tonumber(pair[2])
                table.insert(self.sortedParaKey,tonumber(pair[1]))
                if pair[3] then
                    self.diffValue[tonumber(pair[1])]=tonumber(pair[3])
                end
            end
        end
    end
    self.active_effect_sound = StringPool.New(row:getValue("active_effect_sound"),";")
end

--- 根据Buff等级返回对应的参数"列表"
--- 作用号值 =基础值 + 当前技能等级*差值
local function GetParaByLevel(self,level)
    if not level then
        level = 1
    end

    if not table.IsNullOrEmpty(self.para) then
        local para = {}
        for __,paraKey in pairs(self.sortedParaKey) do
            local effectId = paraKey
            local value = self.para[effectId]
            local effect = {}
            effect.key = effectId
            effect.value = value
            if self.diffValue[effectId] then
                effect.value = effect.value + level * self.diffValue[effectId]
            end
            table.insert(para,effect)
        end
        return para
    else
        return {}
    end
    
end

--- 根据Buff等级返回对应的参数"字典"
--- 作用号值 =基础值 + 当前技能等级*差值
local function GetParaDictByLevel(self,level)
    level = level or 0
    local ret = {}
    if self.para then
        for key,value in pairs(self.para) do
            ret[key]=value + level * self.diffValue[key]
        end
    end
    return ret
end

--- 根据Buff等级返回对应的参数
--- 作用号值 =基础值 + 当前技能等级*差值
local function GetParaByLevelIndex(self,level,index)
    local level = level
    if not level then
        level = 1
    end

    if not table.IsNullOrEmpty(self.para) then
        local para = {}
        if self.sortedParaKey[index] then
            local effectId = self.sortedParaKey[index]
            local value = self.para[effectId]
            local effect = {}
            effect.key = effectId
            effect.value = value
            if self.diffValue[effectId] then
                effect.value = effect.value + level * self.diffValue[effectId]
            end
            return effect
        end
        return nil
    else
        return nil
    end
    
end

LWBuffTemplate.__init = __init
LWBuffTemplate.__delete = __delete
LWBuffTemplate.InitData = InitData
LWBuffTemplate.GetParaByLevel = GetParaByLevel
LWBuffTemplate.GetParaDictByLevel = GetParaDictByLevel
LWBuffTemplate.GetParaByLevelIndex = GetParaByLevelIndex

return LWBuffTemplate