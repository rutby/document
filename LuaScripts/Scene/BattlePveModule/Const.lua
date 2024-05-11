---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 3/24/22 8:24 PM
---
local Const = {}

Const.CampType = {
    Player = 1,
    Target = 2
}

Const.SkillType = {
    ATTACK = 1,  -- 普攻
    COUNTER_ATTACK = 2,  -- 反击
    SHIELD_ATTACK = 3,  -- 护盾攻击
    SHIELD = 4,   -- 护盾
    RECOVER_DAMAGE = 5,  -- 恢复伤兵
    ADD_EFFECT = 6,  -- 添加BUFF
    USE_SKILL = 7,  -- 使用技能
    ADD_ANGER = 8  -- 怒气
}

Const.Define = {
    BUFF = "Buff", 
    SKILL = "Skill",
    NORMAL_ATK = "Normal_Atk",
    NORMAL = "NORMAL",
}

Const.Color = {
    Red = Color32.New(255, 0, 0, 255),
    Green = Color32.New(0, 139, 69, 255),
    White = Color32.New(255, 255, 255, 255),
}

Const.AniName = {
    Idle = "ready",
    Attack = "attack01",
    Weaken = "weaken",
}

Const.WeaponType = {
    Gun = 1, -- 枪
}

Const.Result = {
    NoWar = 1, --没有战斗
    Win = 2, 
    Fail = 3
}

return Const