---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2023/1/7 16:11
---

local TriggerEnum = {}

--事件类型 对应lw_trigger_item的type列
TriggerEnum.EventType = {
   -- AddBuff =1,
    CastSkill = 2,
    AddBuff = 10,
    AddSingleHeroBuff = 11, --增加队伍中随机一个英雄的属性（怪物创建时就选好英雄）
    AddSkill = 20,
    AddSingleHeroSkill = 21,--增加队伍中随机一个英雄的技能（怪物创建时就选好英雄）
    AddSingleHeroIdBuff = 22, --增加队伍中指定heroId英雄的Buff
    ReplaceSingleHeroNormalAttack = 32, --将单个英雄的普攻替换为技能
    ReplaceHeroIdNormalAttack = 34, --将小队中全部英雄id的普攻替换为技能
    ReplaceHeroIdAppearance = 35, --将小队中全部英雄id换肤为新id
    AddHero = 40,       -- 小队增加指定ID的英雄
    AddTrialHero = 41,  -- 小队增加指定Id试用英雄（有技能图标显示，有伤害统计）
    RemoveHero = 50,    -- 小队随机移除一个英雄
    SaveHero = 60,    -- 拯救英雄，和AddHero区别在于，满员后可以顶掉原来的hero
    SaveWorker = 70,    -- 拯救工人，工人跟着队伍走，不能打也不能被打
    GetGoods = 80,    -- 获得物品
    ThreeChoices = 90,  --效果三选一
    StageEffectAttackSpeed = 101, -- 全队攻速
    StageEffectDamage = 102, -- 全队伤害
    StageEffectCriticalRate = 103, -- 全队暴击率
    StageEffectCriticalDamage = 104, -- 全队暴击伤害
}

return TriggerEnum