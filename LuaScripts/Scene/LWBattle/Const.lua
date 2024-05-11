
local Const = {}



Const.MEMBER_ALERT_RADIUS = 8
Const.MEMBER_HP = 100
Const.ZOMBIE_ALERT_RADIUS = 30
Const.BULLET_CURVE_MIN_RANGE = 3 --抛物线子弹最小射程


Const.UseTestModel=false--使用测试模型
Const.TestModel="Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"--army_t1_01小绿人
Const.TestCannon="army_t1_01/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1"--小绿人
Const.TestFirePoint="army_t1_01/Bip001/Bip001 Prop1/FirePoint"--小绿人



--Const.TestModel="Assets/_Art/Models/Cars/tanke/prefab/tank.prefab"--坦克
--Const.TestCannon="vehicle@tanke_skin/To_unity/Root/gun_a/gun"--坦克
--Const.TestFirePoint="vehicle@tanke_skin/To_unity/Root/gun_a/gun/gun_c/gun_d/guadian"--坦克

--Const.TestModel="Assets/_Art/Models/Cars/armour/armour.prefab"--装甲车
--Const.TestCannon="army_t2_05/root/Dummy002/Dummy004/Dummy008/controller"--装甲车
--Const.TestFirePoint="army_t2_05/root/Dummy002/Dummy004/Dummy008/controller/Dummy026/Dummy028/fire_point"--装甲车

Const.FeiXingYuan="A_Hero"
Const.ZombiePrefabPath="Assets/_Art/Models/Characters/Zombies/A_Monster_Zombie01/prefab/A_Monster_Zombie01.prefab"
Const.OilPrefabPath="Assets/_Art/Models/Environment/Prop/Bucket/prefab/O_Prop_Bucket_01.prefab"
Const.AK47BulletEffect="Assets/Main/Prefabs/Effect/AK47BulletEffect.prefab"
Const.AK47FireEffect="Assets/Main/Prefabs/Effect/AK47FireEffect.prefab"
Const.AK47HitEffect="Assets/Main/Prefabs/Effect/AK47HitEffect.prefab"

Const.ZombieAnim =
{
    Idle = "idle",
    Run = "run",
    Walk = "walk",
    Attack = "attack",
    Dead="dead",
    Dead_Fire="dead_fire",
    Born="born",
    Hurt="hurt",
    Stun="idle",
}

Const.ROTATE_SPEED=4--弧度/秒
Const.ROTATE_SPEED_SQUARE=Const.ROTATE_SPEED*Const.ROTATE_SPEED
Const.ROTATE_SPEED_DEG=Const.ROTATE_SPEED*60


Const.SceneObjType =
{
    Member=1,
    Zombie=2,
    Trigger=3,
    Collection=4,
}

Const.DamageTextStyle =
{
    Attack=1,--造成伤害
    BeAttack=2,--受到伤害
    Miss=3,--未命中
    GetBuff=4,--吃buff
}
Const.HPBarStyle =
{
    Self = 1,--敌方
    Enemy = 2,--我方
    Head = 3,--dai
}

-- 动画类型
Const.AnimationType = {
    Idle = "idle",
    IdleWithFlag = "idleWithFlag",
    Run = "run",
    StandAttack = "attack",
    RunAttack = "runAttack",
    RunWithFlag = "runWithFlag",
    WaveFlag = "waveFlag",
    Plant = "plant",
    RunPlant = "runPlant",
    Water = "water",
    RunWater = "runWater",
    Reap = "reap",
    RunReap = "runReap",
    StandAttackBuff = "buffAttack",
    BuffRunAttack = "buffRunAttack",
    Jump = "jump",
    Weaken = "weaken",
    Stun = "stun",
}


-- 触发点事件类型
Const.CommitType =
{
    Stone = 1,     -- 交石头
    Crystal = 2,   -- 交水晶
    Wood = 3,   -- 交木材
    GreenCrystal = 4,   -- 交绿水晶

    Brick = 11,     --砖头
    Glass = 12,     --玻璃
    Board = 13,     --木板
    UpgradeGreenCrystal = 207,   -- 升级交绿水晶

    Flag = 1006,	  -- 插旗帜
    HeroExp = 1007,   -- 英雄经验
    Person = 1008,
}

Const.PveResType =
{
    Stone = 1,
    Wood = 2,
}

-- 资源点类型
Const.CityCutResType =
{
    Stone = 21,     -- 石头
    Crystal = 22,   -- 水晶
    Cactus = 23,    -- 仙人掌
    Wood = 24,    -- 木材
    GreenCrystal = 25, -- 绿水晶

    Water = 31,     -- 水坑
    Worm = 32,      -- 沙虫

    Brick = 41,     --砖头
    Glass = 42,     --玻璃
    Board = 43,     --木板

    Flag = 101,		-- 旗，程序特殊处理
    HeroExp = 201,  -- 英雄经验
    Person = 202,
    Buff = 203,     --buff
    BuyResItem = 204,     --购买的道具
    Npc = 205,     --Npc
    SelectBuff = 206,--选择buff
    UpgradeGreenCrystal = 207,--升级使用绿水晶
    AttackBox = 208,--可以攻击的箱子

    lwWayPoint = 300,--路径点

    ResourceItemWood = 10000,--资源道具木头
    ResourceItemStone = 10001,--资源道具石头
}

Const.ResDropPrefabPath =
{
    [Const.CityCutResType.ResourceItemWood] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_wood.prefab",
    [Const.CityCutResType.ResourceItemStone] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_2.prefab",
}

Const.TriggerType =
{
    CommitRes = 1, -- 交关卡内获得的资源（交1级资源，石头，水晶，树木，交2级资源，砖头，玻璃，木板）
    CommitResource = 2, -- 交资源（交全局资源）
    Monster = 3,   -- 打怪
    RewardBox = 4, -- 宝箱
    CollectRes = 5,-- 经验
    Flag = 6,      -- 插旗  
    Person = 8,    -- 人走到白格子
    Player = 9,    -- 小白人
    Build = 11,     -- 建筑
    Buff = 12,      -- 购买Buff
    BuyResItem = 13, -- 购买道具
    Area = 14,      -- 隐形区域
    Npc = 15,       -- Npc
    Timeline = 16,  -- 推土车
    SelectBuff = 17, --选择buff
    AdvancedBuild = 18, --高级多形态建筑
    BuyWaitResItem = 19, -- 购买出现在地上的道具
    AutoFinish = 20, -- 自动完成的触发点，用来串流程（该触发点需要4个触发点都完成后播引导对话）
    BuyWaitMoveMan = 21, -- 购买搬运东西的小人
    DiffMonster = 22, -- 自选难度打怪
    BuffBox = 23, -- Buff宝箱
    RewardBoxUI = 24, -- 弹奖励界面的宝箱
    LevelLimitMonster = 25, -- 限制英雄等级的打怪
    AdventureSub = 26, -- 星珲探险活动子关卡
    DiffMonsterEasy = 27, -- 类似 22 自选难度打怪，但是默认最低难度
    Turret = 28, -- 箭塔
    BuyAttack = 30,--主UI购买攻击力
    FollowPlayer = 29, -- 打丧尸中的跟随小人
    AttackBox = 31,--可以砍的宝箱
    BanHero = 32, -- 禁用英雄
    MonsterWithHp = 33,--有血条的怪物
    CommitLvPoint = 34, -- 交关卡点数（退出清空的点数）
    Teleport = 35, -- 传送
    GotoOtherPve = 36, -- 进入其他关卡

    CommitResourceItem = 100, -- 交资源道具
    CommitGoods = 101, -- 交物品
    CommitAll = 102, -- 交资源和资源道具(以后应该加上交道具，先都支持了)
    GainBuff = 103, -- 获得buff (BattleBuff)
    HealArmy = 104, -- 恢复伤兵
    GainArmy = 105, -- 获得士兵
    HireHero = 106, -- 雇佣英雄
    TrapMine = 107, -- 陷阱地雷
    Portal = 108, -- 单向传送门
    BombArea = 700,-- 轰炸区
    ShowModel = 1000,--显示模型，不需要交东西，踩上后直接触发完成
    EmptyModel = 1001,--多状态模型，不需要交东西，通过配置完成
    CollectRewardMoreThanOneTime = 2000,--可重复领取奖励
    PVEFactory = 3000,--pve场景内工厂
    SpecialEnd = 10000,--特殊的结束trigger
}

Const.TriggerClearCDType = {
    TriggerClearCDType_Null = 0,
    TriggerClearCDType_Diamond = 1,
    TriggerClearCDType_Energy = 2,
}

-- 提交类型和到资源类型的映射
Const.UnlockToResType =
{
    [Const.CommitType.Stone] = Const.CityCutResType.ResourceItemStone,
    [Const.CommitType.Crystal] = Const.CityCutResType.Crystal,
    [Const.CommitType.GreenCrystal] = Const.CityCutResType.GreenCrystal,
    [Const.CommitType.Wood] = Const.CityCutResType.ResourceItemWood,
    [Const.CommitType.Flag] = Const.CityCutResType.Flag,
    [Const.CommitType.Person] = Const.CityCutResType.Person,
    [Const.CommitType.Brick] = Const.CityCutResType.Brick,
    [Const.CommitType.Glass] = Const.CityCutResType.Glass,
    [Const.CommitType.Board] = Const.CityCutResType.Board,
    [Const.CommitType.UpgradeGreenCrystal] = Const.CityCutResType.UpgradeGreenCrystal,
}

Const.GarbageRewardPath =
{
    [Const.CityCutResType.Stone] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
    [Const.CityCutResType.Crystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardCrystal.prefab",
    [Const.CityCutResType.GreenCrystal] = "Assets/Main/Prefabs/CityScene/GarbageRewardGreenCrystal.prefab",
    [Const.CityCutResType.Cactus] = "Assets/Main/Prefabs/CityScene/GarbageRewardCactus.prefab",
    [Const.CityCutResType.Water] = "Assets/Main/Prefabs/CityScene/GarbageRewardWater.prefab",
    [Const.CityCutResType.Worm] = "Assets/Main/Prefabs/CityScene/GarbageRewardWorm.prefab",
    [Const.CityCutResType.Wood] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
    [Const.CityCutResType.Brick] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
    [Const.CityCutResType.Glass] = "Assets/Main/Prefabs/CityScene/GarbageRewardCrystal.prefab",
    [Const.CityCutResType.Board] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
    [Const.CityCutResType.ResourceItemWood] = "Assets/Main/Prefabs/CityScene/GarbageRewardWood.prefab",
    [Const.CityCutResType.ResourceItemStone] = "Assets/Main/Prefabs/CityScene/GarbageRewardStone.prefab",
}

-- UI图片资源
Const.ResTypeIconPath =
{
    [Const.PveResType.Stone] = "Assets/Main/Sprites/pve/icon_stone.png",
    [Const.PveResType.Wood] = "Assets/Main/Sprites/pve/icon_wood.png",
    [Const.CityCutResType.Stone] = "Assets/Main/Sprites/pve/icon_stone.png",
    [Const.CityCutResType.Crystal] = "Assets/Main/Sprites/pve/icon_crystal.png",
    [Const.CityCutResType.GreenCrystal] = "Assets/Main/Sprites/pve/icon_green_crystal.png",
    [Const.CityCutResType.HeroExp] = "Assets/Main/Sprites/ItemIcons/item230001.png",
    [Const.CityCutResType.Person] = "Assets/Main/Sprites/pve/icon_people.png",
    [Const.CityCutResType.Cactus] = "Assets/Main/Sprites/pve/icon_berry.png",
    [Const.CityCutResType.Wood] = "Assets/Main/Sprites/pve/icon_wood.png",
    [Const.CityCutResType.Water] = "Assets/Main/Sprites/pve/icon_water.png",
    [Const.CityCutResType.Flag] = "Assets/Main/Sprites/pve/icon_flag.png",
    [Const.CityCutResType.Brick] = "Assets/Main/Sprites/ItemIcons/Common_icon_brick.png",
    [Const.CityCutResType.Glass] = "Assets/Main/Sprites/ItemIcons/Common_icon_glass.png",
    [Const.CityCutResType.Board] = "Assets/Main/Sprites/ItemIcons/Common_icon_board.png",
    [Const.CityCutResType.UpgradeGreenCrystal] = "Assets/Main/Sprites/pve/icon_green_crystal.png",
    [Const.CityCutResType.ResourceItemStone] = "Assets/Main/Sprites/pve/icon_stone.png",
    [Const.CityCutResType.ResourceItemWood] = "Assets/Main/Sprites/pve/icon_wood.png",
}

-- 飞的资源路径
Const.ResTypeFlyPrefabPath =
{
    [Const.CityCutResType.Stone] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    [Const.CityCutResType.Crystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.GreenCrystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.HeroExp] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.Wood] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    [Const.CityCutResType.UpgradeGreenCrystal] = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    --[Const.CityCutResType.Cactus] = "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    --[Const.CityCutResType.Water] = "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
}

Const.FlyPosDefaultPath = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/GoodsIcon"
Const.FlyPosPath =
{
    [RewardType.FOOD] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
    [RewardType.OIL] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
    [RewardType.METAL] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
    [RewardType.ELECTRICITY] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
    [RewardType.WATER] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/MoneyIcon",
    [ResourceType.Gold] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/resourceIcon/GoodsIcon",
    [RewardType.POWER] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/showObj/PowerIcon",
    [RewardType.HERO] = "GameFramework/UI/UIContainer/UIResource/UIMain/safeArea/bottomLayer/heroObj",
    [RewardType.FORMATION_STAMINA] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/topLayer/StaminaSliderGo/StaminaImage",
    [RewardType.PVE_ACT_SCORE] = "GameFramework/UI/UIContainer/Background/UIPVEMain/safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/resourceIcon/GoodsIcon",
}

Const.CarryResourceOrder =
{
    Const.CityCutResType.Crystal ,
    Const.CityCutResType.GreenCrystal ,
    Const.CityCutResType.Cactus,
    Const.CityCutResType.Water,
}

Const.ResourceOrder =
{
    Const.CityCutResType.Stone,
    Const.CityCutResType.Wood,
}

Const.ResItemOrder =
{
    Const.CommitType.Brick,
    Const.CommitType.Board,
    Const.CommitType.Glass ,
    Const.CommitType.GreenCrystal ,
    Const.CommitType.UpgradeGreenCrystal ,
}

Const.CarryResourceItemOrder =
{
    Const.CityCutResType.ResourceItemWood ,
    Const.CityCutResType.ResourceItemStone ,
}

Const.CityPrefabPath = "Assets/Main/Prefabs/World/Scene_City2.prefab"
Const.MainPlayerTag = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_zhuizi_biaoshi.prefab"

-- 触发点id区间
Const.TriggerIdMin = 100000
Const.TriggerIdMax = 200000

Const.ZombieIdMin = 300000
Const.ZombieIdMax = 400000

-- 相机参数
Const.LevelCameraHeight = 29.5
Const.CameraZoomMax = 40
Const.CameraZoomMin = 8
Const.FieldOfView = 14

Const.CameraParam =
{
    -- PVE战斗相机
    Battle =
    {
        [0] = { height = 8, rotation = 45, sen = 50 },
        [1] = { height = 33, rotation = 34, sen = 25 },
        [2] = { height = 80, rotation = 34, sen = 200 },
    },
    -- 关卡默认相机
    Level =
    {
        [0] = { height = 8, rotation = 45, sen = 50 },
        [1] = { height = 29.5, rotation = 34, sen = 25 },
        [2] = { height = 40, rotation = math.deg(math.atan(80, 30)), sen = 200 },
    },
    -- 英雄经验关卡默认相机
    HeroExp =
    {
        [0] = { height = 8, rotation = 45, sen = 50 },
        [1] = { height = 29.5, rotation = 34, sen = 25 },
        [2] = { height = 40, rotation = math.deg(math.atan(80, 30)), sen = 200 },
    },
    -- 世界相机
    World =
    {
        [0] = { height = 8, rotation = 45, sen = 50 },
        [1] = { height = 20, rotation = 45, sen = 25 },
        [2] = { height = 80, rotation = math.deg(math.atan(80, 30)), sen = 200 },
    },
    HighView =
    {
        [0] = { height = 32, rotation = math.deg(math.atan(80, 30)), sen = 25 },
        [1] = { height = 32, rotation = math.deg(math.atan(80, 30)), sen = 25 },
        [2] = { height = 32, rotation = math.deg(math.atan(80, 30)), sen = 25 },
    },
}

Const.DefinePlayerName = "CitySpaceMan"

-- UI图片资源
Const.SpecialTag =
{
    No = 0,--不显示
    MainBottom = 1,--显示在UIPveMain底部
}

Const.WaitMovePath =
{
    [Const.CityCutResType.Brick] = "Assets/Main/Prefabs/CityScene/WaitMoveBrick.prefab",
    [Const.CityCutResType.Glass] = "Assets/Main/Prefabs/CityScene/WaitMoveGlass.prefab",
    [Const.CityCutResType.Board] = "Assets/Main/Prefabs/CityScene/WaitMoveBoard.prefab",
}

-- 材料类型和资源类型的映射
Const.ResTypeToResourceType =
{
    [Const.CityCutResType.Stone] = ResourceType.Metal,
    [Const.CityCutResType.Wood] = ResourceType.Wood,
}

-- 资源类型和材料类型的映射
Const.ResourceTypeToResType =
{
    [ResourceType.Metal] = Const.CityCutResType.Stone,
    [ResourceType.Wood] = Const.CityCutResType.Wood,
}

Const.TriggerBubbleType =
{
    Direct = 0,--直接触发
    Bubble = 1,--点击气泡触发
    Bubble_Open_Panel = 2,--点击气泡触发面板
}

Const.CheckCollectType =
{
    Collect = 1,--资源点
    Trigger = 2,--触发点
}

Const.PlayerInteractCode = {
    InteractCode_Fail = -1,
    InteractCode_OK = 1,
    InteractCode_Already_Interact = 2,
}

-- 触发点任务类型
Const.SideQuestType =
{
    Main = 0,--主线
    Side = 1,--支线
}
Const.Interact_time = 2000
Const.LvPointIconPath = "Assets/Main/Sprites/pve/icon_trophy"
Const.EnenryIconPath = "Assets/Main/Sprites/pve/UIlevel_icon_Stamina.png"
Const.TeleportBackName = "TeleportBack"

--小人上坡类型
Const.YMoveType =
{
    No = 0,--不能上坡
    Yes = 1,--可以上坡
}

-- 暗角
Const.DarkCornerType =
{
    None = 0,
    Black = 1,
}

Const.WeaponType = {
    Gun = 1, -- 枪
}

--胜利条件
Const.StageWinType =
{
    KillTargetMonster = 1,  --击杀指定怪物
    KillMonster = 2,        --击杀怪物
    WayPoint = 3,           --完成路径点
    Time = 4,               --限时
    KillBoss = 5,            --击杀boss
    ClearLastTrigger = 6,   --清光最后一个触发点的僵尸
}
--怪物类型
Const.MonsterType =
{
    Normal = 0, --普通怪
    Boss = 1,   --Boss
    Elite = 2,  --精英
    Junk = 3,   --静物
    Table = 6,  --台子
    Car = 7,    --汽车类（直线运动，带碰撞）
}

Const.BattleType =
{
    Parkour = 1             --地铁跑酷
}

Const.ParkourBattleState =  --战斗状态
{
    Ready = 1,--选人准备阶段
    Farm = 2,--跑酷阶段
    Boss = 3,--boss战阶段（使用摇杆）
    BossStay = 4,--boss阶段（不使用摇杆，站立攻击）
    BossHorizontal = 5,--boss阶段（不使用摇杆，可以水平滑动）
    PreExit = 6,--准备谢幕阶段
    Exit = 7,--谢幕阶段
    Lose = 8,--战败阶段
}

Const.ParkourTeamBossControlState = --关低boss摇杆控制类型
{
    AllDirection = 0,   --可以万向控制小队
    Stay = 1,           --不可以控制小队
    Horizontal = 2,     --仅可以左右控制小队
}

Const.ParkourMoveState =  --运动状态
{
    Auto = 1,--自动移动
    LeftRight = 2,--左右移动
    AllDirection = 3,--万向移动
    BossStay = 4,--站立状态，不移动
}

Const.ParkourFireState =  --开火状态
{
    Stay = 1,   --准备阶段
    Straight =2,--正前方
    RotateAndShoot =3,--自由瞄准
    HoldFire =4,--不开火
    Dead =5,--死亡
}

Const.ParkourInput =  --输入类型
{
    FingerDown =1,--按下
    FingerHold =2,--按住
    FingerUp =3,--抬起
}

Const.ParkourUnitType =  --单位类型
{
    Hero =1,
    Monster=2,
    Trigger=3,
    Worker =4,
    Weapon=5,
}

Const.ParkourWinType = 
{
    KillTargetMonster = 1,  --击杀指定怪物
    KillMonster = 2,        --击杀怪物数量
    FinishPoint = 3,        --到终点
    KillBoss = 5,           --击杀boss数量
    SaveWorker = 6,         --营救工人
}

--跑酷关卡战斗类型
Const.ParkourBattleType = 
{
    Attack = 1,     --进攻模式
    Defense = 2,    --防守模式
}

--Count关卡战斗类型
Const.CountBattleType = {
    Attack = 1,     --进攻模式
    Defense = 2,    --防守模式
}

Const.CountBattleTrapDeadEffect = {
    ChangeWeapon = 1,
    AddSolider = 2
}

Const.ParkourSceneCenter = 36
Const.ParkourCollidEffectPath = "Assets/_Art/Effect_B/Prefab/Common/Eff_Metal_hit.prefab"
Const.ParkourAddMemberEffectPath = "Assets/_Art/Effect_B/Prefab/Common/Eff_guanqia_door_brith.prefab"
Const.ParkourAddSkillEffectPath = "Assets/_Art/Effect_B/Prefab/Arms/APS/VFX_animal_grow_big.prefab"

--Count关卡战斗类型
Const.BattleResult = {
    None = 0,--没有打，直接退出
    Win = 1,     --赢了
    Fail = 2,    --输了
}

return Const

