---
--- Pve 子弹配置
---
---@class DataCenter.PveBullet.PveBulletTemplate
local PveBulletTemplate = BaseClass("PveBulletTemplate")

local function __init(self)
    
end

local function __delete(self)
    if self.hit_sound then
        self.hit_sound:Delete()
        self.hit_sound = nil
    end
    if self.create_sound then
        self.create_sound:Delete()
        self.create_sound = nil
    end
    self.target_type = nil
    self.hitShakeParam = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end

    self.id = tonumber(row:getValue("id")) or 0
    self.base_type = tonumber(row:getValue("base_type")) or 0
    self.damage_type = tonumber(row:getValue("damage_type")) or 0
    self.damage = tonumber(row:getValue("damage")) or 0
    self.damage = self.damage * 0.01
    self.mvt_type = tonumber(row:getValue("mvt_type")) or 0
    self.melee_angle = tonumber(row:getValue("melee_angle")) or 0
    self.spiral_loops = tonumber(row:getValue("spiral_loops")) or 0
    self.spiral_radius = tonumber(row:getValue("spiral_radius")) or 0
    self.is_following = tonumber(row:getValue("is_following")) == 1

    self.lifetime_world = tonumber(row:getValue("lifetime_world")) or 0
    if self.lifetime_world==0 then
        self.lifetime_world=0.2
    end

    self.lifetime = tonumber(row:getValue("lifetime")) or 0
    if self.lifetime==0 then
        self.lifetime=0.2
    end

    self.bullet_fly_speed = tonumber(row:getValue("bullet_fly_speed")) or 0
    self.bullet_fly_speed_world = tonumber(row:getValue("bullet_fly_speed_world")) or self.bullet_fly_speed

    self.bullet_collide_limit = tonumber(row:getValue("bullet_collide_limit")) or 0
    self.bullet_collide_limit = self.bullet_collide_limit<=-1 and 64 or self.bullet_collide_limit
    self.target_type = {}
    local strs = string.split(row:getValue("target_type"), "|")
    for _, v in ipairs(strs) do
        table.insert(self.target_type,tonumber(v))
    end
    self.bullet_angle_diff = tonumber(row:getValue("bullet_angle_diff")) or 0
    self.random_angle_range = tonumber(row:getValue("random_angle_range")) or 0
    self.random_ring_range = tonumber(row:getValue("random_ring_range")) or 0
    self.mvt_type_para = tonumber(row:getValue("mvt_type_para")) or 0
    self.mvt_type_para = self.mvt_type_para<=0 and 0.4 or self.mvt_type_para--默认高宽比0.4
    self.mvt_type_para_2 = tonumber(row:getValue("mvt_type_para_2")) or 0
    self.bullet_row_count = tonumber(row:getValue("bullet_row_count")) or 0
    self.bullet_row_count_replay = tonumber(row:getValue("bullet_row_count_replay")) or 0
    self.bullet_diff_time = tonumber(row:getValue("bullet_diff_time")) or 0
    self.bullet_diff_time = self.bullet_diff_time * 0.001--毫秒转秒
    self.bullet_diff_time_replay = tonumber(row:getValue("bullet_diff_time_replay")) or 0
    self.bullet_diff_time_replay = self.bullet_diff_time_replay * 0.001--毫秒转秒
    self.bullet_wave_count = tonumber(row:getValue("bullet_wave_count")) or 0
    self.bullet_wave_count_replay = tonumber(row:getValue("bullet_wave_count_replay")) or 0
    self.bullet_wave_diff_time = tonumber(row:getValue("bullet_wave_diff_time")) or 0
    self.bullet_wave_diff_time = self.bullet_wave_diff_time * 0.001
    self.bullet_wave_diff_time_replay = tonumber(row:getValue("bullet_wave_diff_time_replay")) or 0
    self.bullet_wave_diff_time_replay = self.bullet_wave_diff_time_replay * 0.001
    self.bullet_damage_count = tonumber(row:getValue("bullet_damage_count")) or 0
    self.bullet_damage_attenuation = tonumber(row:getValue("bullet_damage_attenuation")) or 100
    self.bullet_damage_attenuation = self.bullet_damage_attenuation * 0.01
    self.continuous_gap = tonumber(row:getValue("continuous_gap")) or 0
    self.continuous_gap = self.continuous_gap * 0.001--毫秒转秒
    self.second_attack = tonumber(row:getValue("second_attack")) or 0
    self.second_attack_rate = tonumber(row:getValue("second_attack_rate")) or 0
    self.second_attack_count = tonumber(row:getValue("second_attack_count")) or 1
    self.second_attack_repeat = (tonumber(row:getValue("second_attack_repeat")) or 0) == 1
    self.dead_delay = tonumber(row:getValue("dead_delay")) or 0
    self.death_rattle_bullet = tonumber(row:getValue("death_rattle_bullet")) or 0
    self.disable_bullet_rate = tonumber(row:getValue("disable_bullet_rate")) or 0
    self.bullet_effect = row:getValue("bullet_effect")
    local appears = row:getValue("bullet_effect_appear")
    if not string.IsNullOrEmpty(appears) then
        self.bullet_effect_appear={}
        appears = string.split(appears, "|")
        for i = 1, #appears do
            local appear = string.split(appears[i], ",")
            self.bullet_effect_appear[tonumber(appear[1])]=appear[2]
        end
    end
    local bullet_effect_size = tonumber(row:getValue("bullet_effect_size")) or 100
    self.bullet_effect_size = bullet_effect_size * 0.01

    local bullet_effect_size_world = tonumber(row:getValue("bullet_effect_size_world")) or bullet_effect_size
    self.bullet_effect_size_world = bullet_effect_size_world * 0.01

    self.hit_effect = row:getValue("hit_effect")
    self.warning_effect = row:getValue("warning_effect")
    self.hit_stiff_time = tonumber(row:getValue("hit_stiff_time")) or 0
    self.hit_back_distance = tonumber(row:getValue("hit_back_distance")) or 0
    self.white_time = tonumber(row:getValue("white_time")) or 0
    local shake=row:getValue("hit_shake")
    if string.IsNullOrEmpty(shake) then
        self.hitShakeParam = nil
    else
        local strs = string.split(shake, "|")
        self.hitShakeParam = {
            ["duration"]=tonumber(strs[1]), 
            ["strength"]=Vector3.New(tonumber(strs[2]),tonumber(strs[3]),tonumber(strs[4])),
            ["vibrato"]=tonumber(strs[5]),
        }
    end
    self.motion_curve = row:getValue("motion_curve")
    if string.IsNullOrEmpty(self.motion_curve) then
        self.motion_curve = nil
    end
    if (self.mvt_type == BulletMoveType.Straight and self.is_following) 
            or self.mvt_type == BulletMoveType.Parabola then
        self.hasRangeLimit=true--直线追踪弹和抛物线子弹拥有射程限制
    end
    self.hit_sound = StringPool.New(row:getValue("hit_sound"),";")
    self.create_sound = StringPool.New(row:getValue("create_sound"),";")
    
    self.hit_clear_buff = row:getValue("hit_clear_buff")
    
    self.hit_monster_born = nil
    local summonBorn = row:getValue("hit_monster_born")
    if not string.IsNullOrEmpty(summonBorn) then
        local summonArray = string.split(summonBorn, ",")
        if #summonArray == 3 then
            self.hit_monster_born = {}
            for i = 1, 3 do
                table.insert(self.hit_monster_born, tonumber(summonArray[i]))
            end
        end
    end
end

local function GetBulletEffect(self, appearanceId)
    if appearanceId and self.bullet_effect_appear and self.bullet_effect_appear[appearanceId] then
        return self.bullet_effect_appear[appearanceId]
    end
    return self.bullet_effect
end


PveBulletTemplate.__init = __init
PveBulletTemplate.__delete = __delete
PveBulletTemplate.InitData = InitData
PveBulletTemplate.GetBulletEffect = GetBulletEffect


return PveBulletTemplate