---
--- Pve 丧尸配置
---
---@class DataCenter.PveSkill.PveSkillEffectTemplate
local PveSkillEffectTemplate = BaseClass("PveSkillEffectTemplate")

local function __init(self)
    
end

local function __delete(self)
    if self.fire_audio then
        self.fire_audio:Delete()
        self.fire_audio = nil
    end
    self.fireShakeParam = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end
    
    self.id = tonumber(row:getValue("id")) or 0
    self.fire_action = row:getValue("fire_action")
    self.fire_effect = row:getValue("fire_effect")
    self.cast_effect = row:getValue("cast_effect")
    self.fire_effect_time = tonumber(row:getValue("fire_effect_time")) or 0
    self.cast_effect_time = tonumber(row:getValue("cast_effect_time")) or 0
    self.fire_effect_time = self.fire_effect_time * 0.001
    self.cast_effect_time = self.cast_effect_time * 0.001
    self.fire_delay = tonumber(row:getValue("fire_delay")) or 0
    self.fire_delay = self.fire_delay * 0.001

    self.fire_audio = StringPool.New(row:getValue("fire_audio"),";")
    
    local shake=row:getValue("fire_shake")
    if string.IsNullOrEmpty(shake) then
        self.fireShakeParam = nil
    else
        local strs = string.split(shake, "|")
        self.fireShakeParam = {
            ["duration"]=tonumber(strs[1]),
            ["strength"]=Vector3.New(tonumber(strs[2]),tonumber(strs[3]),tonumber(strs[4])),
            ["vibrato"]=tonumber(strs[5]),
        }
    end
    
    
end


PveSkillEffectTemplate.__init = __init
PveSkillEffectTemplate.__delete = __delete
PveSkillEffectTemplate.InitData = InitData


return PveSkillEffectTemplate