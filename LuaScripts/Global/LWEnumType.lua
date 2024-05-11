--[[
-- Last War 枚举类
--]]

local LWEnumType = {}

BULLET_LOG = false
DAMAGE_LOG = false
LOCAL_HERO_SKILL_OVERRIDE = false
INVINCIBLE = false
PVE_TEST_MODE = false--关闭？
DEFAULT_BULLET_MOTION_STRING = "0,0,2,2|1,1,0,0"
TIME_STOP_DURATION = 3
SKILL_PUBLIC_CD = 0.01
TIME_STOP_CD = 0.1
TIME_STOP_CD_AI = 1
HALO_SKILL_CD = -1--光环型技能刷新间隔
HALO_BUFF_DURATION = -1--光环型buff持续时间
ULTIMATE_SKILL_SLOT_INDEX = 2 --大招是2技能
DIE_PERCENT = 0.99 --认为追踪弹运动到全程的99%时碰撞到目标，该值必须小于1，因为等于1代表子弹与目标重合，此时击退方向、受击特效方向都是零向量
ZOMBIE_REMOVE_DISTANCE_Z = 25--丧尸到小队的z轴距离超出25米时，移除以节省性能
BARRAGE_SCENE_CENTER = 36--推图场景中轴线x坐标
EXIT_SPEED = 24--退场速度
EXIT_CTRL_POINT_OFFSET = 5
WHITE_MAT = nil
RED_MAT = nil
PVE_RAGDOLL = false

--玩法类型，也是LWBattleLogic类型
PVEType =
{
    None = -1,--没有进入任何战斗
    Barrage = 0,--推图  -- ZombieBattleManager
    Parkour = 1,--倍增门跑酷 -- ParkourBattleLogic
    Skirmish = 2,--战斗回放 -- SkirmishLogic
    Preview = 3,--技能预览 -- PreviewSkillEffectManager
    World = 4,--大世界战斗 -- WorldBattleManager
    Count = 5, -- CountMasters战斗 -- CountBattleLogic
    FakePVP = 6, -- 假PVP战斗：爬塔、大世界雷达、抢卡车，竞技场---@class DataCenter.LWFakePVPBattle.FakePVPLogic
    Arena3V3 = 7, -- 3v3竞技场战斗、抢火车
}

PVPType =
{
    [PVEType.Skirmish]=1,
    [PVEType.FakePVP]=2,
}

-- 单位类型
UnitType =
{
    None=0,
    Zombie=1,--丧尸（可以移动和攻击的）
    Member=1<<1,--队员
    Junk=1<<2,--杂物，不能移动攻击的，可以互动的东西。如油桶、路障
    Plot=1<<3,--剧情单位，纯表现，无互动，如工人
    TacticalWeapon=1<<4,--战术武器，无互动
    All=31,--全集
}

UnitType2String =
{
    [1]="丧尸",
    [2]="英雄",
    [4]="杂物",
    [8]="NPC",
    [16]="战术武器",
}

--动画名（通用）
AnimName={
    Idle = "idle",
    Run = "run",
    Walk = "walk",
    Attack = "attack",
    AttackMove = "attack_move",
    Dead="dead",
    Dead_Fire="dead_fire",
    Born="born",
    Hurt="hurt",
    Aim="idle",--瞄准
    Stun="stun",
    SpecialMove = "specialMove",
    Skill = "skill",
}


--队员动画
MemberAnim = {
    Idle = "idle",
    Run = "run",
    Attack = "attack",
    Dead="dead",
    Aim="idle"--瞄准
}

ZombieAnim =
{
    Idle = "idle",
    Run = "run",
    Walk = "walk",
    Attack = "attack",
    Dead="dead",
    Dead_Fire="dead_fire",
    Born="born",
    Hurt="hurt",
}

--子弹耐久类型
BulletDurabilityType= {
    Time=0,--持续型子弹：每隔一定时间做一次碰撞检测，可以对同一个目标造成多次伤害
    Collide=1,--有限次碰撞型子弹：每帧做碰撞检测，不会对碰过的目标造成伤害，碰过的目标数达到上限后销毁
    CollideInfinity=-1,--无限次碰撞型子弹：每帧做碰撞检测，不会对碰过的目标造成伤害，目标数无上限
}

--阵营
PVECamp={
    Enemy=0,--敌
    Ally=1,--友（不包含自己）
    Neutral=2,--中立
    Self=3,--自己
}

SkillType={
    Bullet=1,--子弹型技能，必须要有一个目标才能施放
    Buff=2,--buff型技能，没有目标也能施放
    Halo=3,--光环型技能，无限时长的作用号修改
    PassiveDeath=4,--被动技能：死亡时触发
    CityIdle = 5,--城内放置技能：提供作用号属性加成
    Expert = 6,--专家技能
}
--技能作用类型，技能释放后产生的效果
SkillActionType={
    Bullet=1,--创建子弹
    Buff=2,--创建buff
    Halo=3,--创建光环（无限时长的作用号修改）
    Summon=4,--创建单位
}

--技能主被动
SkillAPType={
    Active=0,--主动技能，cd好了就释放
    Passive=1,--被动技能，分两种：一种是光环，初始化时生效；另一种由特定时机触发
}
--技能触发条件（仅对被动技能有效）
SkillTriggerType={
    Active=0,--主动技能（对应于SkillAPType.Active）
    IdleOutside=1,--战斗外放在车库里
    AlwaysOutside=2,--战斗外无条件触发
    AlwaysInside=3,--战斗内无条件触发
    Death=4,--死亡时
    BeHit=5,--受击时
    Cast=6,--施法完成时

}

BulletMoveType={
    Static = 0,--不运动
    Straight = 1,--直线运动
    Parabola = 2,--抛物线
    Follow = 4,--挂在枪口
    Ray = 5,--高速直线子弹，射线检测
}

--站位条件
LocationCondition={
    None=0,--无条件
    Self=1,--自己 
    Same=2,--对位
    Default=3,
    Random=4,--随机n个
    FrontOnly=5,--仅前排
    BackOnly=6,--仅后排
}

--站位
LocationType={
    None=0,--无排
    Front=1,--前排
    Back=2,--后排
}


--英雄阵营
HeroType =
{
    None = -1,--不属于任何阵营
    All = 0,
    Tank = 1,--坦克
    Missile = 2,--导弹
    Aircraft = 3,--飞机
}

HeroJob = {
    Defense = 1,    --防护
    exportation = 2,--输出
    subsidiary = 3,--辅助
}

--碰撞盒类型
ColliderType= {
    Sphere=1,
    Capsule=2,
}

--索敌AI
PriorityType={
    All=0,
    Nearest=1,
    LowestHP=2,
    Farthest=3,
    Random=4,
    HighestMaxHP = 5, --满血最高
    HighestDefense = 6, --防御最高
}

--携带buff的子弹
BulletBuffType={
    None=0,
    OnHit=1,--命中后对命中目标施加buff
    OnHitByChance=2,--命中后有概率对命中目标施加buff
    OnKill=3,--杀敌后对自己施加buff
    OnCastToCaster=4,--施放技能后对自己施加buff
}

--GameObject Layer
LayerType={
    Member="Member",
    Zombie="Zombie",
    Junk="Junk",
}


BuffType={
    Halo=0,
    Property=1,
    Dot=2,
    Hot=3,
    Stun=4,
    Imprison=5, --禁锢
    BeTaunt=7,
    Shield=9, --护盾
    SpecialMove=10, --特殊移动
}

BuffSubType={
    Default=0,
    ReduceDamage=1,--减伤
    ShieldFromCasterHp = 2,    --护盾值根据释放者血量计算
    --ShieldFromCasterProperty = 3,   --护盾值根据释放者属性计算
    ShieldFromValue = 3,            --护盾值固定
}

BarrageState={--推图玩法状态
    Push=1,--推进
    PreExit=2,--准备退场
    Exit=3,--狂飙退场
    Lose=4,--失败
}

SkirmishStage ={--战斗回放状态
    Load=1,--加载
    Opening=2,--开场
    Fight=3,--互殴
    End=4,--结算
}

FakePVPStage ={--fake PVP
    Lineup = 0, --阵容
    Load=1,--加载
    Opening=2,--开场
    Fight=3,--互殴
    End=4,--结算
}

ActionPhase ={--skirmish行为类型
    Prepare=0,--蓄力，目前没有
    Cast=1,--播放施法动作：如果是子弹型技能，会创建无伤害子弹；如果是buff技能，不会创建buff
    Damage=2,--造成伤害
    Buff=3,--添加buff
    Dot=4,--dot伤害，目前没有
    FIRE_BULLET=5--创建子弹，用于多段伤害型技能释放
}


SkirmishMoveState={--战斗回放运动状态
    Stay=1,--不动
    Path=2,--路径点模式
}

SkirmishFireState={--战斗回放攻击状态
    Aim=1,--瞄准
    Casting=2,--施法中
    Idle=3,--发呆
    Die=4,--死亡
    Auto=5,--自动开火（小兵专用）
}

SquadState = {
    Stay = 1, --不动
    Move = 2, --移动
    Exit = 3, --狂飙退场
}

MemberCommand = {
    Stay=1,--不动
    Move=2,--移动
    AutoAttack=3,--自由开火
    StationAttack=4,--瞄准开火
    Ultimate=5,--放大招
}

MemberState={
    Stay=1,--不动
    Move=2,--移动
    Dead=3,--死亡
}

AttackState={
    AutoAttack=1,--自由开火
    StationAttack=2,--瞄准开火
    HoldFire=3,--不开火
    Ultimate=4,--释放大招
}

ZombieState =
{
    Born = 0,
    Idle = 1,
    Run = 2,
    Attack = 3,
    Die = 4,
    HardControl = 5,--硬控
}

--硬控：禁止攻击和移动
HardControlType = {
    Stiff = 1,--硬直，动画暂停
    Imprison = 2,--禁锢，不影响动画
    Hurt = 3,--受击，播受击动画
    Stun = 4,--眩晕，播眩晕动画
}

DamageTextType =
{
    HeroNormalAttack=1,--伤害来源：英雄普攻
    HeroUltimate=2,--伤害来源：英雄大招
    ZombieNormalAttack=3,--伤害来源：丧尸普攻
    ZombieUltimate=4,--伤害来源：丧尸大招
    ReduceDamageBuff=5,--承伤者拥有减伤buff
    Miss=6,--未命中
    GetBuff=7,--吃buff
    Drone=8,--无人机
}

-- 伤害类型
DamageType =
{
    Physics=0,
    Magic=1,
}

ExDamageType={
    attackPercent=1,
    hpPercent=2,
}

EffectObjType={
    Normal=0,
    Sprite=1,
}

SkillCastState={
    Cooldown=0,--冷却中
    Ready=1,--冷却完成
    FrontSwing=2,--前摇
    Chant=3,--吟唱（只有持续施法型技能有）
    BackSwing=4,--后摇
}

SoundLimitType={
    UnitDeath = 1,
    BulletHit = 2,
    BulletCreate = 3,
    TroopAttackCity = 4,
    TroopMarching = 5,
    MAX = 5,
}

EnterHeroSquadPanelWay = {
    ParkingLotBuilding = 1,--停车场
    ToMarch = 2,--将要出征
    MainUI = 3,--主界面
    Gate = 4,--城防
    Marching = 5,--出征中
    TruckDeparture = 6,--卡车发车

    PVE = 10,--pve分隔线，小于10的都是pvp，大于10的都是pve

    PveEditSquad = 11,
    PveEnterBattle = 12,
    PveBattleEditSquad = 13, --战斗中编辑

    DetectEventPVE = 14, --雷达战斗
    TowerupJeepAdventure = 15, --爬塔吉普冒险 300关
    TruckRob = 16,--抢劫卡车

    PVPArena = 17,--竞技场战斗
    PVPArenaDefence = 18,--竞技场防守阵容设置
    Arena3V3Attack = 19,--竞技场3v3战斗
    Arena3V3Defence = 20,--竞技场3v3防守阵容设置(火车3v3也是这个)
    ActivityArena = 21, --活动竞技场
    ActivityArenaDefence = 22,--活动竞技场防守阵容设置
    ActivityArenaV2 = 23, --活动竞技场 V2
    ActivityArenaV2Defence = 24,--活动竞技场V2 防守阵容设置
    TrailTower=25       --试炼塔

}

HeroEffectDefine =
{
    --Strength = 50001,--力量
    --Vitality = 50002,--体质
    --Agility = 50003,--敏捷
    --Produce = 50004,--工作
    --Trade = 50005,--商业
    EquipHealthPoint = 50005,--装备生命
    HealthPoint = 50006,--生命
    PhysicalAttack = 50007,--物理攻击
    EquipPhysicalAttack = 50008,--装备攻击
    --MagicAttack = 50008,--战术攻击
    PhysicalDefense = 50009,--物理防御
    EquipPhysicalDefense = 50010,--装备防御
    --MagicDefense = 50010,--战术防御
    CriticalRate_Result = 50011,--暴击率结果
    CriticalDamage_Result = 50012,--暴击伤害结果
    ChanceToHit_Result = 50013,--命中率结果
    HealPoint_Result = 50014,--生命值结果
    PhysicalAttack_Result = 50015,--物理攻击结果
    Hero_ATK_Result = 50016,--英雄攻击结果
    PhysicalDefense_Result = 50017,--物理防御结果
    Hero_DEF_Result = 50018,--英雄防御结果
    Hero_HP_Result = 50019,--英雄生命值结果
    Equip_HP_Result = 50020,--装备生命值结果
    Equip_ATK_Result = 50021,--装备攻击结果
    Equip_DEF_Result = 50022,--装备防御结果

    PhysicalDamageReduce_Result = 50030,--物理减伤结果
    MagicDamageReduce_Result = 50031,--战术减伤结果
    PhysicalDamageAdd_Result = 50032,--物理增伤结果
    MagicDamageAdd_Result = 50033,--战术增伤结果
    TankBuildingLife = 50039, --建筑对坦克增加的生命
    TankBuildingAttack = 50041,--建筑对坦克增加的攻击力
    TankBuildingDefence = 50043,--建筑对坦克增加的防御力

    TankBuildingLastLife = 50040,--最终建筑坦克增加的生命
    TankBuildingLastAttack = 50042,--最终建筑坦克增加的攻击
    TankBuildingLastDefence = 50044, --最终建筑坦克增加的防御

    MissileBuildingLife = 50046,--建筑对导弹增加的生命
    MissileBuildingAttack = 50048,--建筑对导弹增加的攻击力
    MissileBuildingDefence = 50050,--建筑对导弹增加的防御力

    MissileBuildingLastLife = 50047,--最终建筑导弹增加的生命
    MissileBuildingLastAttack = 50049,--最终建筑导弹增加的攻击
    MissileBuildingLastDefence = 50051, --最终建筑导弹增加的防御
    AircraftBuildingLife = 50052,--建筑对飞机增加的生命
    AircraftBuildingAttack = 50054,--建筑对飞机增加的攻击力
    AircraftBuildingDefence = 50056,--建筑对飞机增加的防御力
    AircraftBuildingLastLife = 50053,--最终建筑飞增加的生命
    AircraftBuildingLastAttack = 50055,--最终建筑飞机增加的攻击
    AircraftBuildingLastDefence = 50057, --最终建筑飞机增加的防御
    Honor_HP_Result = 50064,--荣誉生命值结果
    TankBuildingLastSoldierCapacity = 50072, --最终建筑坦克增加的带兵量
    MissileBuildingLastSoldierCapacity = 50073, --最终建筑导弹增加的带兵量
    AircraftBuildingLastSoldierCapacity = 50074, --最终建筑飞机增加的带兵量
    HeroSoldierCapacity = 50079, --英雄带小兵结果
    HeroSoldierMorale = 50080, --英雄所带小兵士气加成

    TacticalWeaponHp = 50081, --战术武器生命值
    TacticalWeaponAtk = 50082, --战术武器攻击力
    TacticalWeaponDef = 50083, --战术武器防御力
    TacticalWeaponHp_Result = 50084, --战术武器生命值
    TacticalWeaponAtk_Result = 50085, --战术武器攻击力结果
    TacticalWeaponDef_Result = 50086, --战术武器防御力结果
    TacticalWeaponAll_Ratio = 50090, --战术武器全属性转化率
    TacticalWeaponHp_Ratio = 50091, --战术武器生命值转化率
    TacticalWeaponAtk_Ratio = 50092, --战术武器攻击力转化率
    TacticalWeaponDef_Ratio = 50093, --战术武器防御力转化率

    TacticalWeaponHp_Battle_Add = 50098, --战术武器生命值战斗加成
    TacticalWeaponAtk_Battle_Add = 50099, --战术武器攻击力战斗加成
    TacticalWeaponDef_Battle_Add = 50100, --战术武器防御力战斗加成


    ProductivityRate = 71000,--工作生产效率
    CommercialRate = 71001,--商业加工效率
    AgilityRate = 71002,--灵巧修炼效率

    ConstitutionAddRate = 75000,--体质提升
    HpAddRate = 75050,--生命值提升
    BuffHpAddRate = 75051,--buff生命值提升
    TankHeroHpAddRate = 75053,--坦克英雄生命值提升
    MissileHeroHpAddRate = 75054,--导弹英雄生命值提升
    AircraftHeroHpAddRate = 75055,--飞机英雄生命值提升
    LineupHpAddRate = 75060,--阵容生命值提升

    StrengthAllAttackAddRate = 75100,--力量攻击提升
    AllAttackAddRate = 75150,--全攻击提升
    BuffAttackAddRate = 75151,--Buff攻击力提升
    TankAttackAddRate = 75153,--坦克攻击力提升
    MissileAttackAddRate = 75154,--导弹攻击力提升
    AircraftAttackAddRate = 75155,--飞机攻击力提升
    LineupAttackAddRate = 75160,--阵容攻击力提升


    BuffAttackReduceRate = 75200,--Buff攻击力降低
    AllDefenseAddRate = 75250,--全防御提升
    BuffDefenseAddRate = 75251,--Buff防御力提升
    TankDefenseAddRate = 75253,--Buff防御力提升
    MissileDefenseAddRate = 75254,--Buff防御力提升
    AircraftDefenseAddRate = 75255,--Buff防御力提升


    LineupDefenseAddRate = 75260,--阵容防御力提升

    BuffDefenseReduceRate = 75300,--Buff防御力降低
    AllCriticalDamageAddRate = 75400,--全暴击伤害提升
    AllHitChanceAddRate = 75500,--全命中率提升
    AllAttackSpeedAddRate = 75650,--全攻击速度提升

    AttackAgainstZombieAddRate = 75953,--伤害提升打野


    --AttackRate = 25100,--全攻击百分比
    --DefenseRate = 25200,--全防御百分比
    --HealthPointRate = 25000,--全生命百分比

    UnlockEquipSlotLimit = 90002,--解锁装备槽位限制
    UnlockStrengthenWeaponLimit = 90003,--解锁专武强化限制

    AllCriticalChanceAddRate = 75300 ,--全暴击率提升
    AllCdReduceRate = 75750 ,--全冷却缩减提升
    AllHealAddRate = 75800 ,--全释放治疗效果提升
    AllBeHealedAddRate = 75850 ,--全受到治疗效果提升
    SkillAllDamageAddRate = 75950 ,--技能伤害提升
    SkillPhysicalDamageAddRate = 75951 ,--技能物理伤害提升
    SkillMagicDamageAddRate = 75952 ,--技能战术伤害提升

    TankDamageAddRate = 75957 ,--坦克伤害提升
    MissileDamageAddRate = 75958 ,--导弹伤害提升
    AircraftDamageAddRate = 75959 ,--飞机伤害提升


    SkillDamageReduceRate = 76000 ,--技能伤害降低
    SkillPhysicalDamageReduceRate = 76001 ,--技能物理伤害降低
    SkillMagicDamageReduceRate = 76002 ,--技能战术伤害降低

    SkillTakenDamageReduceRate = 76050 ,--技能受到伤害减免提升
    SkillPhysicalTakenDamageReduceRate = 76051 ,--技能受到物理伤害减免提升
    SkillMagicTakenDamageReduceRate = 76052 ,--技能受到战术伤害减免提升
    DefenceAgainstZombieReduceRate = 76053,--受到伤害降低打野

    EquipDamageReduceRateBase = 76057,--装备基础减伤
    EquipDamageReduceRatePhysics = 76058,--装备物理减伤
    EquipDamageReduceRateMagic = 76059,--装备魔法减伤


    SkillTakenDamageAddRate = 76100 ,--技能受到伤害提升
    SkillPhysicalTakenDamageAddRate = 76101 ,--技能受到物理伤害提升
    SkillMagicTakenDamageAddRate = 76102 ,--技能受到战术伤害提升
    BattleHeroMoveSpeed = 80000 ,--战斗移速增加百分比
    SuperArmor = 80001 ,--霸体，同时禁用大招

    HeroPower = 100000 ,--英雄战力,=100001+100002+100003
    HeroPowerLevel = 100001 ,--英雄等级战力
    HeroPowerSkill = 100002 ,--英雄技能战力
    HeroPowerEquip = 100003 ,--英雄装备战力
}

-- 关卡类型
-- 1：单人关卡
-- 2：雷达关卡
-- 3: 爬塔冒险300关
LWStageType = {
    SingleBattle = 1,
    DetectEvent = 2,
    TowerupAdvanture = 3,
}

StageEffectType =
{
    AttackSpeed = 101,
    Damage = 102,
    CriticalRate = 103,
    CriticalDamage = 104,
}

return ConstClass("LWEnumType", LWEnumType)