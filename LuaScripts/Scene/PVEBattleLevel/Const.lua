
local Const = {}

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
    Oil = 0,     -- 黑曜石
    Flint = 13,     -- 火晶石
    
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
    Npc = 205,     --Npc
    SelectBuff = 206,--选择buff
    UpgradeGreenCrystal = 207,--升级使用绿水晶
    AttackBox = 208,--可以攻击的箱子

    Obsidian = 2001,-- 黑曜石

    -- LW PVE
    lwWayPoint = 300,--路径点
    lwMonsterPoint = 310,--种怪点
    lwBlockPoint = 311,--路障点
    -- LW PVE end
}

Const.ResDropPrefabPath =
{
    [PveAtomType.Tree] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_wood.prefab",
    [PveAtomType.Stone] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_2.prefab",
}

Const.ResDropParticlePath =
{
    [PveAtomType.Tree] = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab",
    [PveAtomType.Stone] = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_shitoucaiji.prefab",
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
    Area = 14,      -- 隐形区域
    Npc = 15,       -- Npc
    Timeline = 16,  -- 推土车
    SelectBuff = 17, --选择buff
    AdvancedBuild = 18, --高级多形态建筑
    AutoFinish = 20, -- 自动完成的触发点，用来串流程（该触发点需要4个触发点都完成后播引导对话）
    BuyWaitMoveMan = 21, -- 购买搬运东西的小人
    DiffMonster = 22, -- 自选难度打怪
    BuffBox = 23, -- Buff宝箱
    RewardBoxUI = 24, -- 弹奖励界面的宝箱
    LevelLimitMonster = 25, -- 限制英雄等级的打怪
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
    TimeLimitFinish = 37, -- 限时关卡完成
    ExpCoin = 38, -- 经验金币
    Immediate = 40, -- 立刻完成
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
    [Const.CommitType.Crystal] = Const.CityCutResType.Crystal,
    [Const.CommitType.GreenCrystal] = Const.CityCutResType.GreenCrystal,
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
    [Const.CityCutResType.Oil] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_firecrystal",
    [Const.CityCutResType.Obsidian] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_firecrystal",
    [Const.CityCutResType.Flint] = "Assets/Main/Sprites/UI/Common/Common_icon_recruit_massif3",
}

-- 飞的资源路径
Const.ResTypeFlyPrefabPath =
{
    [Const.CityCutResType.Stone] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    [Const.CityCutResType.Crystal] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.GreenCrystal] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.HeroExp] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    [Const.CityCutResType.Wood] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    [Const.CityCutResType.UpgradeGreenCrystal] = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab",
    --[Const.CityCutResType.Cactus] = "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
    --[Const.CityCutResType.Water] = "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab",
}

Const.FlyPosDefaultPath = "GameFramework/UI/UIContainer/UIResource/UIPVEMain/safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/resourceIcon/GoodsIcon"
Const.FlyPosPath = 
{
    [RewardType.MONEY] = Const.FlyPosDefaultPath,
    [RewardType.OIL] = Const.FlyPosDefaultPath,
    [RewardType.METAL] = Const.FlyPosDefaultPath,
    [RewardType.ELECTRICITY] = Const.FlyPosDefaultPath,
    [RewardType.WATER] = Const.FlyPosDefaultPath,
    [ResourceType.Gold] = Const.FlyPosDefaultPath,
    [RewardType.POWER] = "GameFramework/UI/UIContainer/UIResource/UIPVEMain/safeArea/showObj/PowerIcon",
    [RewardType.HERO] = "GameFramework/UI/UIContainer/UIResource/UIMain/safeArea/bottomLayer/HeroBtn",
    [RewardType.FORMATION_STAMINA] = "GameFramework/UI/UIContainer/UIResource/UIPVEMain/safeArea/topLayer/StaminaSliderGo/StaminaImage",
    [RewardType.PVE_ACT_SCORE] = Const.FlyPosDefaultPath,
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
Const.FieldOfView = 18

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
    [Const.CityCutResType.Flint] = ResourceType.FLINT,
    [Const.CityCutResType.Oil] = ResourceType.Oil,
}

-- 资源类型和材料类型的映射
Const.ResourceTypeToResType =
{
    [ResourceType.Metal] = Const.CityCutResType.Stone,
    [ResourceType.Wood] = Const.CityCutResType.Wood,
    [ResourceType.Oil] = Const.CityCutResType.Oil,
    [ResourceType.FLINT] = Const.CityCutResType.Flint,
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

Const.ConfigTriggerState = {
    Normal = 0,  -- 正常
    Show_NotActive = 1, -- 显示但是不激活,只是用作显示
    Hide = 2, --隐藏
    DelayCreate = 3, --延迟创建
    Normal_WithoutCollect = 4, -- 可以选取,但是不直接发送消息  这个是针对于一个指定功能,不能采集但是需要执行noviceboot,对于为什么不做到trigger中类似于加个pre,暂时先不修改编辑器了,通过event来控制可能更灵活些
    Special = 5, --特殊用途，目前用于美女倒地状态，未来其他trigger可以定义自己的逻辑
    RemoteControlBoxOpen = 6,--eventtype 8类型被控制的trigger打开
    RemoteControlBoxEmpty = 7,--eventtype 8类型被控制的trigger奖励领完
}

return Const