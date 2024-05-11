---
--- Pve 丧尸配置
---
---@class DataCenter.PveSkill.PveHeroEffectTemplate
local PveHeroEffectTemplate = BaseClass("PveHeroEffectTemplate")

local function __init(self)
    
end

local function __delete(self)
    if self.death_sound then
        self.death_sound:Delete()
        self.death_sound = nil
    end
end

local function InitData(self, row)
    if row == nil then
        return
    end
    
    self.id = tonumber(row:getValue("id")) or 0
    self.hit_effect = row:getValue("hit_effect")
    self.hit_effect_direction = tonumber(row:getValue("hit_effect_direction")) or 0
    self.death_effect_nomal = row:getValue("death_effect_nomal")
    local death_blood_path = row:getValue("death_blood_path")
    if not string.IsNullOrEmpty(death_blood_path) then
        local strList = string.split(death_blood_path, "|")
        self.death_blood_path={}
        for i, v in ipairs(strList) do
            self.death_blood_path[i]="Assets/Main/Prefabs/LWBattle/"..v..".prefab"
        end
    else
        self.death_blood_path = nil
    end
    self.hit_sound = row:getValue("hit_sound")
    if self.hit_sound=="" then
        self.hit_sound=nil
    end
    
    local shake=row:getValue("death_shake")
    if string.IsNullOrEmpty(shake) then
        self.deathShakeParam = nil
    else
        local strs = string.split(shake, "|")
        self.deathShakeParam = {}
        self.deathShakeParam.duration=tonumber(strs[1])
        self.deathShakeParam.strength=Vector3.New(tonumber(strs[2]),tonumber(strs[3]),tonumber(strs[4]))
        self.deathShakeParam.vibrato=tonumber(strs[5])
    end
    self.death_sound = StringPool.New(row:getValue("death_sound"),";")
    self.hit_action = row:getValue("hit_action")
end

local function GetRandomBlood(self)
    if self.death_blood_path then
        local rand=math.random(#self.death_blood_path)
        return self.death_blood_path[rand]
    end
    return nil
end


PveHeroEffectTemplate.__init = __init
PveHeroEffectTemplate.__delete = __delete
PveHeroEffectTemplate.InitData = InitData
PveHeroEffectTemplate.GetRandomBlood = GetRandomBlood


return PveHeroEffectTemplate