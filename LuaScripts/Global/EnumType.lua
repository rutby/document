--[[
-- 枚举类
--]]
UIWindowNames = require "UI.Config.UIWindowNames"
--为方便在全局都能调用UI或是Data中枚举值，把枚举都写到EnumType中



ProxyList =
{
    "game-ds-aws-r1.metapoint.club",
    "game-ds-r1.metapoint.club",
};
ProxyName =
{
    "aws",
    --"cloudfare",
    "direct"
};

CheckVersionUrlList = 
{
    { cv = "http://gsl-ds.metapoint.club",gsl = "http://gsl-ds.metapoint.club",lineName = "cf"},
    { cv = "http://gsl-ds-aws.metapoint.club",gsl = "http://gsl-ds-aws.metapoint.club",lineName = "aws"},
}
DebugCheckVersionUrlList = 
{
    { cv = "http://10.7.88.142:82",gsl = "http://10.7.88.182:82",lineName = "direct"},
}
CDNUrlList = 
{
    "https://cdn-ds.readygo.tech/hotupdate/",
}

DebugCDNUrlList = 
{
    "http://10.7.88.142:82/gameservice/get3dfile.php?file=",
    "http://10.7.88.142:82/gameservice/get3dfile.php?file=",
}

-- 网络出错列表
LoginErrorCode =
{
    ERROR_CONN_LOST = "error connect lost", -- 连接丢失
    ERROR_LOGOUT = "error logout", -- 登出
    ERROR_NO_NET = "error no net", -- 没有网络
    ERROR_CONNECT = "error connect error",   -- 连接错误

    ERROR_BANID = "4",              -- 封号
    ERROR_IPBLACK = "43",           -- ip黑名单
    ERROR_DEVICEBLACK = "44",       -- device黑名单

    ERROR_SUCCESS = "E000",    -- 成功
    ERROR_NETWORK = "E101",    -- 网络错误
    ERROR_HTTP = "E102",        -- Http错误
    ERROR_JSON = "E103",        -- Json格式错误
    ERROR_DATA = "E104",        -- 数据错误
    ERROR_UNREACHABLE = "E105", -- 网络不可达
    ERROR_INIT = "E106",        -- PushInit 错误
    ERROR_INIT_TIMEOUT = "E107",-- PushInit 超时
    ERROR_TIMEOUT = "E108",     -- 网络超时
    ERROR_MAINTENANCE = "E109", -- 服务器维护
    ERROR_SERVER_STATE = "E110",
    ERROR_LOAD_DATATABLE = "E111", -- 加载配置表错误
    ERROR_LOAD_DATATABLE_TIMEOUT = "E112", -- 加载配置表超时
    ERROR_LOGIN_TIMEOUT = "E113", -- login超时
    ERROR_UPDATE_MANIFEST = "E114", -- 下载Manifest错误
    ERROR_DOWNLOAD_UPDATE = "E115", -- 下载更新错误
    ERROR_SERVER_LIST = "E116", -- 没有返回server list
    ERROR_LOGIN_ERROR = "E117", -- 登陆错误
}

ResourceType =
{
    None = -1,--默认值，只前端要用
    -- 0 黑曜石
    Oil = 0,
    -- 1 石头
    Metal = 1,
    -- 2 木头
    Wood = 2,
    --4 人口
    People = 4,
    -- 11 水
    Water = 11,
    -- 12 铁
    Electricity = 12,

    FLINT = 13,--13 火晶石
    -- 14 钞票
    -- 15 钻石
    Money = 14,
    Gold = 15,
    -- 17 PVE Point
    PvePoint = 17,

    --GreenCrystal = 18,--绿水晶
    MedalOfWisdom = 18,--智慧勋章,GreenCrystal这个已经被废除了
    FarmBox = 19,--农业补给箱
    DETECT_EVENT = 20,--
    FORMATION_STAMINA = 21,--体力
    BattlePass = 22,--战令经验
    Nitrogen = 23,--氮气
    Food = 24,--食物
    Plank = 25,--木板
    Steel = 26,--电
    Meal = 27,--餐饮
    Max = 100, --资源区间预留
    BlackKnight = 9001, --黑骑士积分(战报专用)
    MasteryPoint = 9002, -- 专精点数
    AllianceDragonPoint = 9003,--战场积分
}

GlobalShaderLod =
{
    LOW =0,
    MIDDLE =1,
    HIGH =2
}

HeroBountyRarity =
{
    White = 1,
    Green =2,
    Blue = 3,
    Purple = 4,
    Orange = 5,
    Red = 6,
    Special = 7,
}
HeroBountyRarityColor =
{
    [HeroBountyRarity.White] = Color.New(254/255, 240/255, 217/255,1),
    [HeroBountyRarity.Green] = Color.New(148/255, 225/255, 56/255,1),
    [HeroBountyRarity.Blue] = Color.New(95/255, 163/255, 237/255,1),
    [HeroBountyRarity.Purple] = Color.New(201/255, 108/255, 240/255,1),
    [HeroBountyRarity.Orange] = Color.New(250/255, 136/255, 67/255,1),
    [HeroBountyRarity.Red] = Color.New(242/255, 106/255, 103/255,1),
    [HeroBountyRarity.Special] = Color.New(242/255, 106/255, 103/255,1),
}

RewardType =
{
    OIL = 0,--0 --燃油/瓦斯 黑曜石 
    METAL = 1,--1 -- 金属/水晶
    PLANK = 2,--2 木板
    FOOD = 3,--3 肉
    GOLD = 5,--5 钻石
    EXP = 6,--6
    GOODS = 7,--7 -- 道具
    GENERAL = 8,--8
    POWER = 9,--9
    HONOR = 10,--10
    ALLIANCE_POINT = 11, --11 联盟积分
    HOUSE = 12,--12
    HOSPITAL = 13,--13
    EQUIP = 14,--14
    MATERIAL = 15,--15
    PART = 16,--16
    ITEM_EFFECT = 17,--17
    BATTLE_HONOR = 18,--18
    WATER = 19,--19 --水
    MONEY = 20,--20 --钱
    ELECTRICITY = 21,--21--铁
    PEOPLE = 22,--22--人口
    ARM = 23,--23
    MANOR = 24,--24
    HERO = 25,--25
    PTGOLD = 26,--26
    RESOURCE_ITEM = 27,--27 资源道具
    PVE_POINT = 28,--pve积分
    DETECT_EVENT = 29,--雷达事件
    FORMATION_STAMINA = 30,--体力
    WOOD = 31,--木头
    PVE_STAMINA = 32,--pve体力(弃用)
    PVE_ACT_SCORE = 34,--pve活动积分
    FLINT = 36,--火晶石
    CAR_EQUIP = 37,--装备
    STEEL = 38,--电
    DECORATION = 39,--装扮
    HERO_EQUIP = 40,--英雄装备
    ---1000以后为客户端使用
    SEVENDAY_SCORE = 1001,--七日积分
    Golloes = 1002,--咕噜
    SAPPHIRE = 1003,--蓝宝石（联盟资源）
    ALLIANCE_DONATE = 1004, -- 联盟贡献
    ALLIANCE_SCIENCE_TECH_POINT = 1005, -- 捐献进度
    UnlockModule = 1007,--解锁功能（暂时联盟任务用）
    HERO_EXP = 1008,--英雄经验
    BATTLE_PASS = 1009,--战令积分
    TALENT = 1010,--天赋
    BUILD = 1011,--建筑
    ActGiftBox = 1012,--礼盒活动
    MASTERY_POINT = 1013,--专精点数
    PERSON_POINT = 1014,--军备功勋
    ALLIANCE_BOSS_DONATE = 1015,--联盟Boss捐献
    HeroPlugin = 1016,--英雄插件
    MEAL = 1019,--餐
    RESIDENT = 1020,--幸存者
}
--奖励对应资源
RewardToResType =
{
    --0=》0
    [RewardType.OIL] = ResourceType.Oil,
    --1=》1
    [RewardType.METAL] = ResourceType.Metal,
    --19=》11
    [RewardType.WATER] = ResourceType.Water,
    --21=》12
    [RewardType.ELECTRICITY] = ResourceType.Electricity,
    --20=》14
    [RewardType.MONEY] = ResourceType.Money,
    [RewardType.FOOD] = ResourceType.Food,
    [RewardType.PLANK] = ResourceType.Plank,
    [RewardType.STEEL] = ResourceType.Steel,
    [RewardType.MEAL] = ResourceType.Meal,
    --5=》15
    [RewardType.GOLD] = ResourceType.Gold,
    --33=》17
    [RewardType.FLINT] = ResourceType.FLINT,
    [RewardType.PVE_POINT] = ResourceType.PvePoint,
    [RewardType.DETECT_EVENT] = ResourceType.DETECT_EVENT,
    [RewardType.FORMATION_STAMINA] = ResourceType.FORMATION_STAMINA,
    [RewardType.WOOD] = ResourceType.Wood,
    [RewardType.PVE_STAMINA] = ResourceType.FORMATION_STAMINA,
    [RewardType.PEOPLE] = ResourceType.People,
    [RewardType.MASTERY_POINT] = ResourceType.MasteryPoint,
}
--资源对应奖励
ResTypeToReward =
{
    [ResourceType.Oil] = RewardType.OIL,
    [ResourceType.Metal] = RewardType.METAL,
    [ResourceType.Water] = RewardType.WATER,
    [ResourceType.Electricity] = RewardType.ELECTRICITY,
    [ResourceType.Money] = RewardType.MONEY,
    [ResourceType.Food] = RewardType.FOOD,
    [ResourceType.Plank] = RewardType.PLANK,
    [ResourceType.Steel] = RewardType.STEEL,
    [ResourceType.Meal] = RewardType.MEAL,
    [ResourceType.Gold] = RewardType.GOLD,
    [ResourceType.PvePoint] = RewardType.PVE_POINT,
    [ResourceType.DETECT_EVENT] = RewardType.DETECT_EVENT,
    [ResourceType.FORMATION_STAMINA] = RewardType.FORMATION_STAMINA,
    [ResourceType.Wood] = RewardType.WOOD,
    [ResourceType.People] = RewardType.PEOPLE,
    [ResourceType.FLINT] = RewardType.FLINT,
}

GOODS_TYPE =
{
    GOODS_TYPE_0 = 0,
    GOODS_TYPE_1 = 1,
    GOODS_TYPE_2 = 2,   --加速道具
    GOODS_TYPE_3 = 3,   --资源道具  20英雄经验
    GOODS_TYPE_4 = 4,   --buff道具
    GOODS_TYPE_5 = 5,   --宝箱
    GOODS_TYPE_6 = 6,
    GOODS_TYPE_7 = 7,   --装备材料
    GOODS_TYPE_8 = 8,   --随机给1000兵
    GOODS_TYPE_9 = 9,   --装备配件
    GOODS_TYPE_13 = 13, --道具合成
    GOODS_TYPE_15 = 15, -- 红包道具
    GOODS_TYPE_16 = 22, --道具合成+最强要塞积分buffer,16 occupy ，manager change it to 22
    GOODS_TYPE_23 = 23, --军队扩充道具
    GOODS_TYPE_35 = 35, --导弹
    GOODS_TYPE_39 = 39, --
    GOODS_TYPE_41 = 41, --
    GOODS_TYPE_45 = 45, --礼品赠送
    GOODS_TYPE_46 = 46, --可以产生多个reward的道具
    GOODS_TYPE_48 = 48,
    GOODS_TYPE_50 = 50, --沙漠积分
    GOODS_TYPE_57 = 57, --能力强化经验道具
    GOODS_TYPE_59 = 59, --可以产生多个reward的道具
    GOODS_TYPE_62 = 62, --勋章
    GOODS_TYPE_63 = 63, -- 技能书，用来学习技能用，在道具列表中不显示
    GOODS_TYPE_66 = 66, --治疗沙漠淘金者伤兵的道具

    GOODS_TYPE_70 = 70, --英雄碎片
    GOODS_TYPE_79 = 79, --vip赠送礼物
    GOODS_TYPE_80 = 80, --金币宝箱
    GOODS_TYPE_90 = 90, --天赋重置卷
    GOODS_TYPE_91 = 91, --英雄经验书
    GOODS_TYPE_93 = 93, --英雄勋章
    GOODS_TYPE_98 = 98, --英雄碎片
    GOODS_TYPE_99 = 99, --特定英雄碎片
    GOODS_TYPE_102 = 102,--英雄组合选择箱
    GOODS_TYPE_106 = 106,--
    GOODS_TYPE_107 = 107,--资源道具选择箱子
    GOODS_TYPE_108 = 108,--晶体箱
    GOODS_TYPE_109 = 109,--编队buff
    GOODS_TYPE_110 = 110,--装扮道具
    GOODS_TYPE_112 = 112,--赛季经验道具
    FILL_UP_EVENT_NUM =113,      --113补满雷达事件
    SPEED_WORLD_MARCH = 116, -- 116 行军加速道具
    MIGRATE_ITEM = 117, -- 移民道具
    LANDMINE = 118, -- 地雷
    BUILD_BAUBLE = 120,      --120装饰建筑
    GOODS_TYPE_122 = 122,--士兵自选箱子
    GOODS_TYPE_123 = 123,--雇佣兵自选箱子
    Password = 124,--密码道具
    CALL_BOSS_OR_REWARD = 126,--呼叫boss或者获得奖励
    GOODS_TYPE_201 = 201,--英雄海报道具
    GOODS_TYPE_202 = 202,--增加vip时间
    GOODS_TYPE_204 = 204,--自适应资源箱子的道具类型
}

GOODS_TYPE2 =
{
    PVEEnergy = 3,--pve体力
    HeroExp = 20,-- type == 3为英雄经验 
    StaminaItem = 21, --good_type == 3运兵车燃料
    MarchSpeedItem = 22,--good_type == 116行军加速道具
}

-- 作用状态
EffectStateDefine =
{
    LORD_SKILL_PROTECTED = 501051,         -- 资源保护
    PLAYER_PROTECTED_TIME1 = 500000,       -- 鸡蛋壳
    PLAYER_PROTECTED_TIME2 = 500001,
    PLAYER_PROTECTED_TIME3 = 500002,
    PLAYER_PROTECTED_TIME4 = 500003,
    PLAYER_PROTECTED_TIME5 = 500004,
    NEW_PLAYER_PROTECTED = 500009,         -- 新手鸡蛋壳
    CHINESE_WIND_SKIN = 500526,            -- 中国风皮肤（1天）表格里的说明

}

PushType =
{
    PUSH_GM = 0,
    PUSH_QUEUE = 1,         --队列
    PUSH_WORLD = 2,         --世界地图,拆分被攻击和被侦查
    PUSH_MAIL = 3,          --联盟
    PUSH_STATUS = 4,        --状态
    PUSH_ALLIANCE = 5,      --社交（聊天） 去掉联盟邮件
    PUSH_ACTIVITY = 6,      --活动 5的联盟邮件加进来
    PUSH_RESOURCE = 7,      --7资源满仓
    PUSH_CHAT = 8,          --8聊天
    PUSH_REWARD = 9,        --9礼包...音乐杀僵尸、食堂开餐等
    PUSH_WEB_ONLINE = 10,   --web在线?
    PUSH_ATTACK = 11,       --从2拆分出来,被攻击
    PUSH_SCOUT = 12,        --从2拆分出来,被侦察
    NOT_CHECK = 99,  --不用检查
}

--缺少道具 补充显示排序  354
ResLackResTypeOrder =
{
    Normal = 1, --常规资源补充
    Custom = 2, --自选宝箱
    Adapt = 3, --自适应宝箱
}

SurvivalEquipType =
{
    Hat = "hat",
    Cloth = "cloth",
    Trousers = "trousers",
    Shoe = "shoe",
    Weapon = "weapon",
    Bag = "bag",
}

EquipSlotReq =
{
    [0] = SurvivalEquipType.Hat,
    [1] = SurvivalEquipType.Cloth,
    [2] = SurvivalEquipType.Trousers,
    [3] = SurvivalEquipType.Shoe,
    [4] = SurvivalEquipType.Weapon,
    [5] = SurvivalEquipType.Bag
}


AtlasAssets =
{
    ItemAtlas = "ItemIcons",
    ItemAtlas1 = "ItemIcons1",
    ResourceAtlas = "Resource",
    SoldierIcons = "SoldierIcons",
    MonsterBodyAtlas = "MonsterBody",
    UIAllianceFlag = "AllianceFlags",
    UIAllianceWar = "AllianceWar",
    UIWorldCity = "Scene_WorldCity",
    CountryFlag = "CountryFlag",
    SceneMiniMap = "Scene_MiniMap",
    UIBuildBtns = "UI_UIBuildBtns",
    UICommon = "UI_Common",
    UICommonBG = "UI_CommonBG",
    WorldResource = "Scene_WorldResource",
    UIMail = "UI_UIMail",
    UIFormation = "UI_UIFormation",
    UIActivityPreView = "UI_UIActivityPreView",
    EquipAtlas = "Equip",
    SceneWorld = "Scene_World",
    ServerMap = "Scene_ServerMap",
    TalentIcon = "UI_TalentIcon",
    CommonDefault = "UI_CommonDefault",
    UIBattle = "UI_Battle_BattleUI",
    WorldBuild = "WorldBuild",
    UI_DoomsdayBattleGuide = "UI_DoomsdayBattleGuide",
    UI_WelfareCenter = "UI_WelfareCenter",
    UI_KingdomFace = "UI_KingdomFace",
    UI_NoteBook = "UI_UINoteBook",
    UI_BuildMenu = "UI_BuildMenu",
    UI_UIMissile = "UI_UIMissile",
    UI_Decoration = "UI_Decoration",
    DynamicAtlas = "DynamicAtlas0",
    UI_UITilepop = "UI_UITilepop",
    UI_UIResourceProduction = "UI_UIResourceProduction",
    HUP = "HUP",
    UI_UIMain = "UI_UIMain",
    UI_GiftPackage = "UI_GIftPackage_GiftCommon",
    Science = "UI_UIScience",
    ScienceIcons = "ScienceIcons",
    UI_UIHeroInfo = "UI_UIHeroInfo",
    UITask = "UI_UITask",
    UISet = "UI_UISet",
    UI_UIHeroTalent = "UI_UIHeroTalent",

}

UIAssets =
{
    UIDropCell = "Assets/Main/Prefabs/UI/UIHero/New/UIDropCell.prefab",
    UIDropAttrCell = "Assets/Main/Prefabs/UI/UIHero/New/UIDropAttrCell.prefab",
    BuildingDes = "Assets/Main/Prefabs/UI/Build/BuildingDes.prefab",
    LUAGiftPackagePagePanel = "Assets/Main/Prefab_Dir/UI/GiftPackage/GiftPackagePagePanel.prefab",
    LUAGoldExchangeNormalLuaView = "Assets/Main/Prefab_Dir/UI/GiftPackage/GoldExchangeNormalLuaView.prefab",
    UITradeCenter = "Assets/Main/Prefabs/UI/UITradingCenter/UITradeCenter.prefab",
    UIBookMarkPositionCollect = "Assets/Main/Prefabs/UI/BookMark/UIBookMarkPositionCollect.prefab",
    BuildTimeTip = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip2.prefab",
    BuildTimeTip1 = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip1.prefab",
    BuildTimeTip2 = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTip3.prefab",
    BuildTimeTipTrainField = "Assets/Main/Prefabs/UI/Build/BuildTimeTipTrainField.prefab",
    SceneBuildBloodTip = "Assets/Main/Prefabs/UI/Build/SceneBuildBloodTip.prefab",
    WorldNewsTips = "Assets/Main/Prefabs/UI/World/WorldNewsTips.prefab",
    SceneAllianceBuildBloodTip =  "Assets/Main/Prefabs/UI/Build/SceneAllianceBuildBloodTip.prefab",
    BuildStateIcon = "Assets/Main/Prefabs/UI/State/BuildStateIcon.prefab",
    BuildStateIcon2 = "Assets/Main/Prefabs/UI/State/BuildStateIcon2.prefab",
    BuildStateIcon3 = "Assets/Main/Prefabs/UI/State/BuildStateIcon3.prefab",
    BuildStateIcon4 = "Assets/Main/Prefabs/UI/State/BuildStateIcon4.prefab",
    BuildStateIcon5 = "Assets/Main/Prefabs/UI/State/BuildStateIcon5.prefab",
    BuildStateIcon6 = "Assets/Main/Prefabs/UI/State/BuildStateIcon6.prefab",
    UIMainTopResourceCell = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainTopResourceCell.prefab",
    UIMainMarchCell = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainMarchCell.prefab",
    UIMainFunctionItem = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainFunctionItem.prefab",
    UIChatTimeCell = "Assets/Main/Prefabs/UI/Chat/UIChatTimeCell.prefab",
    UIChatLeftTextCell = "Assets/Main/Prefabs/UI/Chat/UIChatLeftTextCell.prefab",
    UIChatRightTextCell = "Assets/Main/Prefabs/UI/Chat/UIChatRightTextCell.prefab",
    AllianceGiftItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceGiftItem.prefab",
    UIAllianceCollectItem = "Assets/Main/Prefab_Dir/UI/UIAllianceCitySelect/UIAllianceCollectItem.prefab",
    MailScoutResourceItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailScoutResourceItem.prefab",
    MailResSupportItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailResSupportItem.prefab",
    MailScoutTroopWave = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailScoutTroopWave.prefab",
    MailScoutHeroItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailScoutHeroItem.prefab",
    MailScoutTroopItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailScoutTroopItem.prefab",
    MailScoutFortItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailScoutFortItem.prefab",
    UIRateTipItem = "Assets/Main/Prefabs/UI/UIRateTip/UIRateTipItem.prefab",
    RuinsRewardItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/RuinsKillingEnemy/RuinsRewardItem.prefab",
    LeagueMatchAlRankItem = "Assets/Main/Prefab_Dir/UI/UIAllianceCompeteNew/LeagueMatchAlRankItem.prefab",
    LeagueMatchRewardItem = "Assets/Main/Prefab_Dir/UI/LeagueMatch/UILeagueMatchReward/LeagueMatchRewardItem.prefab",
    LeagueMatchResultVsItem = "Assets/Main/Prefab_Dir/UI/LeagueMatch/UILeagueMatchResult/LeagueMatchResultVsItem.prefab",
    WeekCardSelectRewardItem = "Assets/Main/Prefab_Dir/UI/UIWeekCardSelectReward/WeekCardSelectRewardItem.prefab",
    UIJigsawRankItem = "Assets/Main/Prefab_Dir/UI/UIJigsawRank/UIJigsawRankItem.prefab",
    AllianceCompeteScheduleItem = "Assets/Main/Prefab_Dir/UI/UIAllianceCompete/AllianceCompeteScheduleItem.prefab",
    AllianceCompetePerRewardITem = "Assets/Main/Prefab_Dir/UI/UIAllianceCompete/UIAllianceCompetePerRewardItem.prefab",
    MailAlElectResultItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/AlElect/MailAlElectResultItem.prefab",
    FlyResourceEffect = "Assets/Main/Prefabs/FlyResourceEffect/FlyResourceEffect.prefab",
    FlyFoldUpBuildEffect = "Assets/Main/Prefabs/FlyResourceEffect/FlyFoldUpBuildEffect.prefab",
    DesCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/DesCell.prefab",
    NeedResourceCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/NeedResourceCell.prefab",
    ResourceLackItem = "Assets/Main/Prefab_Dir/UI/UIResource/ResourceLackItem.prefab",
    PowerLackItem = "Assets/Main/Prefabs/UI/World/PowerLackItem.prefab",
    NeedBuildCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/NeedBuildCell.prefab",
    UIResourceBagTab = "Assets/Main/Prefab_Dir/UI/UIResource/UIResourceBagTab.prefab",
    BuildBlock = "Assets/Main/Prefabs/Building/BuildBlock.prefab",
    BuildCollect = "Assets/Main/Prefabs/Building/BuildCollect.prefab",
    UIWorldTileTopBtn = "Assets/Main/Prefabs/UI/World/UIWorldTileTopBtn.prefab",
    UIWorldTileBuildBtn = "Assets/Main/Prefabs/UI/World/UIWorldTileBuildBtn.prefab",
    UICityTileBuildBtn = "Assets/Main/Prefabs/UI/World/UICityTileBuildBtn.prefab",
    DecResourceEffect = "Assets/Main/Prefabs/UI/Build/DecResourceEffect.prefab",
    UIMainGatherItem ="Assets/Main/Prefab_Dir/UI/UIMain/UIMainGatherItem.prefab",
    BuildCanUpgradeEffect ="Assets/Main/Prefabs/UI/Build/BuildCanUpgradeEffect.prefab",
    UIMainWarningGoBtn ="Assets/Main/Prefab_Dir/UI/UIMain/UIMainWarningGoBtn.prefab",
    UIWarningEffect ="Assets/Main/Prefabs/UI/UIWarningEffect/UIWarningEffect.prefab",
    AllianceFunItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceFunItem.prefab",
    AllianceManageButton = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceManageButton.prefab",
    AllianceMemberRankSimple ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceMemberRankSimple.prefab",
    AllianceMemberRankSpecial ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceMemberRankSpecial.prefab",
    AllianceMemberBtnItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceMemberBtnItem.prefab",
    AllianceLanguageItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceLanguageItem.prefab",
    CommonGoodsShopItem = "Assets/Main/Prefab_Dir/UI/UICommonShop/CommonGoodsShopItem.prefab",
    AllianceStorageResItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceStorageResItem.prefab",
    GolloesCampItem = "Assets/Main/Prefabs/UI/UIGolloesCamp/GolloesCampItem.prefab",
    UIScienceTopBtnCell ="Assets/Main/Prefabs/UI/UIScience/UIScienceTopBtnCell.prefab",
    UIScienceNeedResCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceNeedResCell.prefab",
    UIScienceCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceCell.prefab",
    CapacityTab = "Assets/Main/Prefab_Dir/UI/UICapacity/CapacityTab.prefab",
    UIBuildUpgradeAddDesCell = "Assets/Main/Prefabs/UI/Build/UIBuildUpgradeAddDesCell.prefab",
    UIScienceInfoNeedBuildCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceInfoNeedBuildCell.prefab",
    UIScienceInfoDesCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceInfoDesCell.prefab",
    UIScienceInfoPreCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceInfoPreCell.prefab",
    UIBagTab = "Assets/Main/Prefabs/UI/UIBag/UIBagTab.prefab",
    UIBuildQueuePanelCell = "Assets/Main/Prefabs/UI/Build/UIBuildQueuePanelCell.prefab",
    UIRepairNeedResCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairNeedResCell.prefab",
    UIRepairPanelCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairPanelCell.prefab",
    UIRepairPanelTitleCell = "Assets/Main/Prefabs/UI/UIRepair/UIRepairPanelTitleCell.prefab",
    --OstrichModel = "Assets/Main/Prefabs/World/OstrichModel.prefab",
    UITrainNeedResCell = "Assets/Main/Prefabs/UI/UITrain/UITrainNeedResCell.prefab",
    UITrainDetailCell = "Assets/Main/Prefabs/UI/UITrain/UITrainDetailCell.prefab",
    BuildCanUpgradeEffect ="Assets/Main/Prefabs/UI/Build/BuildCanUpgradeEffect.prefab",
    BuildTrainCompleteEffect ="Assets/Main/Prefabs/BuildEffect/BuildTrainCompleteEffect.prefab",
    BuildTrainTimeFinishEffect ="Assets/Main/Prefabs/BuildEffect/BuildTrainTimeFinishEffect.prefab",
    RankSimpleItem = "Assets/Main/Prefabs/UI/Set/RankSimpleItem.prefab",
    FormationAddHero = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationAddHero.prefab",
    FormationHero = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationHero.prefab",
    FormationHeroNew = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationHeroNew.prefab",
    FormationHeroSelectList = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationHeroSelectList.prefab",
    FormationHeroSelectCell = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationHeroSelectCell.prefab",
    FormationSoldierSelect = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSoldierSelect.prefab",
    FormationSoldierItem = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSoldierItemNew.prefab",
    UIPveBattleSoliderItem = "Assets/Main/Prefab_Dir/Guide/UIPveBattleSoliderItem.prefab",
    FormationSoldierChooseCell = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSoldierChooseCell.prefab",
    FormationSoldierChooseCellNew = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSoldierChooseCellNew.prefab",
    FormationCampListCell = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationCampListCell.prefab",
    AllianceWarItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceWarItem.prefab",
    UIPersonalWarning = "Assets/Main/Prefab_Dir/UI/Alliance/UIPersonalWarning.prefab",
    AllianceWarPlayerItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceWarPlayerItem.prefab",
    UIFormationAssistanceItem = "Assets/Main/Prefab_Dir/UI/UIFormationDefence/UIFormationAssistanceItem.prefab",
    AllianceAlertPlayerItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceAlertPlayerItem.prefab",
    UIPersonalWarPlayerItem = "Assets/Main/Prefab_Dir/UI/Alliance/UIPersonalWarPlayerItem.prefab",
    AllianceAllyItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceAllyItem.prefab",
    FormationDefenceCell ="Assets/Main/Prefab_Dir/UI/UIFormationDefence/FormationDefenceCell.prefab",
    FormationDefenceUnlock = "Assets/Main/Prefab_Dir/UI/UIFormationDefence/FormationDefenceUnlock.prefab",
    FormationDefenceHeroItem = "Assets/Main/Prefab_Dir/UI/UIFormationDefence/FormationDefenceHeroItem.prefab",
    FormationHeroAdd = "Assets/Main/Prefab_Dir/UI/UIFormationDefence/FormationHeroAdd.prefab",
    Effectpath = "Assets/_Art/Effect/prefab/scene/Common/VFX_ziyuancaiji.prefab",
    FormationHeroItem = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSelectHeroItem.prefab",
    FormationSelectHeroAdd = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSelectHeroAdd.prefab",
    AllianceWarPlayerSoliderItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceWarPlayerSoliderItem.prefab",
    AllianceHeroCell = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceHeroCell.prefab",
    UIScienceLine = "Assets/Main/Prefabs/UI/UIScience/UIScienceLine.prefab",
    BuildFireEffect = "Assets/Main/Prefabs/World/BuildFireEffect.prefab",
    BuildFireEffectMainBuild = "Assets/Main/Prefabs/World/BuildFireEffectMainBuild.prefab",
    SceneBuildBloodTip = "Assets/Main/Prefabs/UI/Build/SceneBuildBloodTip.prefab",
    BuildLabelTip = "Assets/Main/Prefabs/World/BuildLabelTip.prefab",
    WorldMarchTileUI = "Assets/Main/Prefabs/UI/World/WorldMarchTileUI.prefab",
    WorldMarchEmotionPanel = "Assets/Main/Prefabs/UI/World/WorldMarchEmotionPanel.prefab",
    WorldTroopHeadUI = "Assets/Main/Prefabs/March/WorldTroopHeadUI.prefab",
    WorldTroopMonsterPro =  "Assets/Main/Prefabs/March/WorldTroopMonsterPro.prefab",
    ThroneBuildBloodTip = "Assets/Main/Prefabs/UI/Build/ThroneBuildBloodTip.prefab",
    AllianceMineBloodTip = "Assets/Main/Prefabs/UI/Build/AllianceMineBloodTip.prefab",
    PveHeroBloodBar =  "Assets/Main/Prefabs/PVE/Hero_Blood.prefab",
    WorldTroopName = "Assets/Main/Prefabs/March/WorldTroopName.prefab",
    TroopAttackBuildUI = "Assets/Main/Prefabs/March/TroopAttackBuildUI.prefab",
    TroopTransUI = "Assets/Main/Prefabs/March/TroopTransUI.prefab",
    AllianceCityTip = "Assets/Main/Prefab_Dir/UI/AllianceCityTip/AllianceCityTip.prefab",
    AlliancePassTip = "Assets/Main/Prefab_Dir/UI/AllianceCityTip/AlliancePassTip.prefab",
    EdenAllianceCityTip = "Assets/Main/Prefab_Dir/UI/AllianceCityTip/EdenAllianceCityTip.prefab",
    WorldBuildHeadUI = "Assets/Main/Prefabs/March/WorldBuildHeadUI.prefab",
    WorldDesertHeadUI = "Assets/Main/Prefabs/March/WorldDesertHeadUI.prefab",
    WorldDesertBloodPro = "Assets/Main/Prefabs/March/WorldDesertBloodPro.prefab",
    ThroneBuildBloodTip = "Assets/Main/Prefabs/UI/Build/ThroneBuildBloodTip.prefab",
    AllianceLogCell = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceLogCell.prefab",
    BattleBuffTip = "Assets/Main/Prefabs/UI/BattleWord/BattleBuffTip.prefab",
    BattleSiegeTip = "Assets/Main/Prefabs/UI/BattleWord/BattleSiegeTip.prefab",
    BattleDamageDesTip = "Assets/Main/Prefabs/UI/BattleWord/BattleDamageDesTip.prefab",
    BattleMineDamageTip = "Assets/Main/Prefabs/UI/BattleWord/BattleMineDamageTip.prefab",
    ActBossBloodTip = "Assets/Main/Prefabs/March/ActBossBloodTip.prefab",
    AllianceBossBloodTip = "Assets/Main/Prefabs/March/AllianceBossBloodTip.prefab",
    FlyBoard = "Assets/Main/Prefabs/World/FlyBoard.prefab",
    UISelectPoint = "Assets/Main/Prefabs/UI/Common/UISelectPoint.prefab",
    UICampBonusItem = "Assets/Main/Prefab_Dir/UI/UICamp/UICampBonusItem.prefab",
    UIMasteryOverviewItem = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasteryOverviewItem.prefab",
    UIMasterySkillItem = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasterySkillItem.prefab",
    --[[
         聊天部分
    ]]
    UIChatRoomCell = "Assets/Main/Prefab_Dir/ChatNew/ChatRoomCell.prefab",
    UIChatSearchPersonItem = "Assets/Main/Prefab_Dir/ChatNew/SearchPerson/UIChatSearchPersonItem.prefab",
    UIChatHead = "Assets/Main/Prefab_Dir/ChatNew/ChatHead.prefab",
    ObjHeroAddExp = "Assets/Main/Prefab_Dir/UI/UIMain/ObjHeroAddExp.prefab",
    BatteryAttackRange = "Assets/_Art/Effect/prefab/scene/Build/V_paota_fanwei.prefab",
    FoodShouqu = "Assets/_Art/Effect/prefab/ui/Common/VFX_food_shouqu.prefab",

    UICommonNeedResourceCell = "Assets/Main/Prefabs/UI/Common/UICommonNeedResourceCell.prefab",

    -- 城市管理
    UICityManageCell = "Assets/Main/Prefab_Dir/UI/CityManage/UICityManageCell.prefab",
    UICityManageCellItemCell = "Assets/Main/Prefab_Dir/UI/CityManage/UICityManageCellItemCell.prefab",
    WarFeverItemCell = "Assets/Main/Prefab_Dir/UI/CityManage/WarFeverItemCell.prefab",
    DetectEventItem = "Assets/Main/Prefab_Dir/UI/UIRadarCenter/DetectEventItem.prefab",
    NewsEventItem = "Assets/Main/Prefab_Dir/UI/UIRadarCenter/NewsEventItem.prefab",
    SceneBuildTimeTipCircle = "Assets/Main/Prefabs/UI/Build/SceneBuildTimeTipCircle.prefab",
    DetectEventRewardEffect = "Assets/Main/Prefab_Dir/UI/UIRadarCenter/DetectEventRewardEffect.prefab",
    HeroDamageItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/HeroDamageItem.prefab",

    --活动
    ActivityRewardTipCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/ActivityRewardTipCell.prefab",
    UIActivityListItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/ActivityListItem.prefab",
    ActivityTabGroupItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/ActivityGroupCell.prefab",
    ActivityCurrenReward = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/ActivityCurrenRewardItem.prefab",
    --战力提升活动
    LeadingQuest = "Assets/Main/Prefab_Dir/UI/ActivityCenter/LeadingQuest/LeadingQuestMain.prefab",
    LeadingQuestResItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/LeadingQuest/LeadingQuestResItem.prefab",
    --拼图活动
    JigsawPuzzle = "Assets/Main/Prefab_Dir/UI/ActivityCenter/JigsawPuzzle/JigsawPuzzleMain.prefab",
    AllianceActMine = "Assets/Main/Prefab_Dir/UI/ActivityCenter/AllianceActMine/AllianceActMine.prefab",
    AlContributeMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/AlContribute/AlContributeMain.prefab",
    --赛季12主界面
    RobotWars = "Assets/Main/Prefab_Dir/UI/ActivityCenter/RobotWars/RobotWarsMain_%s.prefab",
    --任务活动
    BarterShop = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BarterShop/BarterShopMain.prefab",
    MineCave = "Assets/Main/Prefab_Dir/UI/ActivityCenter/MineCave/MineCaveMain.prefab",
    PersonalArms = "Assets/Main/Prefab_Dir/UI/ActivityCenter/PersonalArms/PersonalArms.prefab",
    PersonalArmsNew = "Assets/Main/Prefab_Dir/UI/ActivityCenter/PersonalArms/PersonalArmsNew.prefab",
    UIActivityTargetItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/PersonalArms/UIActivityTargetItem.prefab",
    --联盟对决
    AllianceArms = "Assets/Main/Prefab_Dir/UI/ActivityCenter/AllianceCompete/AllianceArms.prefab",
    UIActivitySevenDay = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenDay/UIActivitySevenDay.prefab",
    UIActivitySevenDayVip = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenDay/UIActivitySevenDayVip.prefab",
    UIActSevenDayNew = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenDay/UIActSevenDayNew.prefab",
    UIActivitySevenDayItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenDay/UIActivitySevenDayItem.prefab",
    UIActSevenDayNewItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenDay/UIActSevenDayNewItem.prefab",
    --世界争霸
    UIActivityEdenWar = "Assets/Main/Prefab_Dir/UI/ActivityCenter/EdenWar/UIActivityEdenWar.prefab",
    UIActivityPirates = "Assets/Main/Prefab_Dir/UI/ActivityCenter/WorldBoss/UIActivityPirates.prefab",
    UIActivityPuzzle = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Puzzle/UIActivityPuzzle.prefab",
    ActivityRewardItem = "Assets/Main/Prefab_Dir/UI/GiftPackage/UIGiftPackageCell.prefab",
    RewardPreviewCell = "Assets/Main/Prefab_Dir/UI/UIActivitySummary/UIRewardPreviewCell.prefab",
    BarterShopNotice = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BarterShopNotice/BarterShopNotice.prefab",
    BarterShopCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BarterShopNotice/BarterShopCell.prefab",
    UIDailyPackageCell = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyPackage/UIDailyPackageCell.prefab",
    ArenaMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Arena/ArenaMain.prefab",
    DigActivityMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Dig/DigActivityMain.prefab",
    SeasonPassMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonPass/SeasonPassMain.prefab",
    ThroneMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIThrone/UIThroneMainView.prefab",
    --英雄试炼
    HeroGrowthMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroGrowth/HeroGrowthMain.prefab",
    HeroGrowthMain_Box = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroGrowth/HeroGrowthMain_Box.prefab",
    HeroTrial = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroTrial/HeroTrialMain.prefab",
    --圣诞节活动
    ChristmasCelebrateMain = "Assets/Main/Prefab_Dir/UI/ActivityCenter/ChristmasCelebrate/ChristmasCelebrate.prefab",
    --幸运转盘
    LuckyRoll = "Assets/Main/Prefab_Dir/UI/ActivityCenter/LuckyRoll/UILuckyRoll.prefab",
    --刮刮乐
    ScratchOffGame = "Assets/Main/Prefab_Dir/UI/ActivityCenter/ScratchOffGame/ScratchOffGame.prefab",
    Mining = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Mining/Mining.prefab",
    --数字寻宝
    Mysterious = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Mysterious/Mysterious.prefab",
    UIMysteriousScoreGlow = "Assets/_Art/Effect/prefab/ui/Mysterious/VFX_ui_mysterious_glow.prefab",
    UIMysteriousScoreFly = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Mysterious/MysteriousScoreFly.prefab",
    UIMysteriousRewardItem = "Assets/Main/Prefabs/UI/UIMysteriousRewardPreview/UIMysteriousRewardItem.prefab",
    SeasonShop = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonShop/SeasonShop.prefab",
    SeasonShopItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonShop/SeasonShopGoodsItem.prefab",
    UIActivityDispatchTask = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DispatchTask/UIActivityDispatchTask.prefab",
    --战令
    MiningRewardPreviewItem = "Assets/Main/Prefab_Dir/UI/UIMiningRewardPreview/MiningRewardPreviewItem.prefab",
    UIBattlePass = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BattlePass/UIBattlePass.prefab",
    UIBattlePassRewardCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BattlePass/UIBattlePassRewardCell.prefab",
    UIBPTaskRewardCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BattlePass/UIBPTaskRewardCell.prefab",
    BattlePassEffect = "Assets/Main/Prefab_Dir/UI/ActivityCenter/BattlePass/BattlePassEffect.prefab",
    --咕噜翻牌
    UIGolloesCards = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GolloesCards/UIGolloesCards.prefab",
    UIGolloesCardsRPCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GolloesCards/UIGolloesCardsRPCell.prefab",
    --怪物爬塔
    UIMonsterTower = "Assets/Main/Prefab_Dir/UI/ActivityCenter/MonsterTower/%s.prefab",
    SelectDiffCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/MonsterTower/SelectDiffCell.prefab",
    UILuckyShop = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UILuckyShop/UILuckyShop.prefab",
    SevenLogin = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SevenLogin/SevenLogin.prefab",
    SevenLoginCellOrBack = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_chengse.prefab",
    SevenLoginCellOrFront = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_chengse_front.prefab",
    SevenLoginCellPuBack = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_purple.prefab",
    SevenLoginCellPuFront = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_purple_front.prefab",
    SevenLoginCellNo = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_putong.prefab",
    SevenLoginCellPuRece = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_purple_dailingqu.prefab",
    SevenLoginCellOrRece = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_7day_chengse_dailingqu.prefab",
    UISeasonWeekCard = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonWeekCard/UISeasonWeekCard.prefab",
    UISeasonWeekReward = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonWeekCard/UISeasonWeekReward.prefab",
    --赛季地块排行榜
    UISeasonRank = "Assets/Main/Prefab_Dir/UI/ActivityCenter/SeasonRank/UISeasonRank.prefab",
    --皮肤礼包活动
    UIDecorationGiftPackage = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDecorationGiftPackage/UIDecorationGiftPackage.prefab",
    UIDecorationGiftPackageCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDecorationGiftPackage/UIDecorationGiftPackageCell.prefab",
    --英雄特训
    HeroEvolve = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroEvolve/HeroEvolve.prefab",
    HeroEvolveGiftCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroEvolve/HeroEvolveGiftCell.prefab",
    --总统特权
    PresidentAuthority = "Assets/Main/PresidentAuthority/UI/ActivityCenter/PresidentAuthority/PresidentAuthority.prefab",
    --娃娃机
    UIGiftBox = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GiftBox/UIGiftBox.prefab",
    GiftBoxCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GiftBox/GiftBoxCell.prefab",
    GiftBoxRewardCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GiftBox/GiftBoxRewardCell.prefab",
    UIAllianceSeasonForce = "Assets/Main/Prefab_Dir/UI/ActivityCenter/AllianceSeasonForce/UIAllianceSeasonForce.prefab",
    --天下大势
    UIWorldTrend = "Assets/Main/Prefab_Dir/UI/ActivityCenter/WorldTrend/UIWorldTrend.prefab",
    WorldTrendWeekCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/WorldTrend/WorldTrendWeekCell.prefab",
    UIChaseDeer = "Assets/Main/Prefab_Dir/UI/UIChaseDeer/UIChaseDeer.prefab",
    --双倍赛季积分
    UIDoubleSeasonScore = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DoubleSeasonScore/UIDoubleSeasonScore.prefab",
    DoubleActEffectCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DoubleSeasonScore/DoubleActEffectCell.prefab",
    --个人势力排行榜
    UIPersonSeasonRank = "Assets/Main/Prefab_Dir/UI/ActivityCenter/PersonSeasonRank/UIPersonSeasonRank.prefab",
    --巨龙
    UIActDragon = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragon.prefab",
    UIActDragonRewardCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragonRewardCell.prefab",
    PersonRewardCell = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/PersonRewardCell.prefab",
    UIActDragonNotice = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragonNotice.prefab",
    --跨服打地
    UICrossDesert = "Assets/Main/Prefab_Dir/UI/ActivityCenter/CrossServerDesert/UICrossDesert.prefab",
    UIActMineCave = "Assets/Main/Prefab_Dir/UI/ActivityCenter/ActMineCave/UIActMineCave.prefab",
    --殖民战争排行榜
    UIColonizeWarRank = "Assets/Main/Prefab_Dir/UI/ActivityCenter/ColonizeWarRank/UIColonizeWarRank.prefab",
    MiningReward = "Assets/Main/Prefabs/UI/ActivityCenter/Mining/MiningReward.prefab",
    --咕噜专精
    GolloBox = "Assets/Main/Prefab_Dir/UI/ActivityCenter/GolloBox/GolloBox.prefab",
    --联盟boss
    AllianceBossPrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIAllianceBoss/UIActivityAllianceBoss.prefab",
    AllianceBossRewardPrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIAllianceBoss/UIAllianceBossReward.prefab",
    UIPveActStageItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIAllianceBoss/UIPveActStageItem.prefab",
    UIPveActStageRewardItem = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIAllianceBoss/UIPveActStageRewardItem.prefab",
    --捐兵打联盟
    ALVSDonateSoldierPrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/UIALVSActivityDonateSoldier.prefab",
    ALVSBattlePrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/AttackStateSafeArea.prefab",
    ALVSDonatePrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/DonateStateSafeArea.prefab",
    UICollectRewardCell = "Assets/Main/Prefab_Dir/UI/UICollectReward/UICollectRewardCell.prefab",
    UIQuestCellNew = "Assets/Main/Prefab_Dir/UI/UIMainTask/UIQuestCellNew.prefab",
    UIQuestRewardCell = "Assets/Main/Prefab_Dir/UI/UIMainTask/UIQuestRewardCell.prefab",
    UIVipCellEffectItem = "Assets/Main/Prefab_Dir/UI/UIVip/CellEffect.prefab",

    SoliderDetailItem = "Assets/Main/Prefab_Dir/UI/UIArmyInfo/SoliderDetailItem.prefab",
    UIArmyInfoTroopItem = "Assets/Main/Prefab_Dir/UI/UIArmyInfo/UIArmyInfoTroopItem.prefab",
    UITaskChapterRewardItem = "Assets/Main/Prefabs/UI/UITask/RewardCell.prefab",
    UITaskChapterRewardSmallItem = "Assets/Main/Prefabs/UI/UITask/RewardCellSmall.prefab",
    UIMainNoticeGroup =  "Assets/Main/Prefab_Dir/UI/UIMainNotice/UIMainNoticeGroup.prefab",
    NoticeListItem =  "Assets/Main/Prefab_Dir/UI/UIMainNotice/NoticeListItem.prefab",
    UIHeroCellSmall = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellSmall.prefab",
    UIHeroCellBig = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellBig.prefab",
    UIHeroCellBigPiece = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCellBigPiece.prefab",
    UICapacityBoxHeroItem = "Assets/Main/Prefab_Dir/UI/UICapacity/UICapacityBoxHeroItem.prefab",
    UICapacityBoxItem = "Assets/Main/Prefab_Dir/UI/UICapacity/UICapacityBoxItem.prefab",
    UICapacityBoxSolderItem = "Assets/Main/Prefab_Dir/UI/UICapacity/UICapacityBoxSolderItem.prefab",
    UIRadarSoliderICell = "Assets/Main/Prefab_Dir/ChatNew/UIRadarSoliderICell.prefab",
    --部队信息
    TotalItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TotalItem.prefab",
    TroopItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TroopItem.prefab",
    TurretItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TurretItem.prefab",
    TurretDetailItem = "Assets/Main/Prefabs/UI/UIForcesDetail/TurretDetailItem.prefab",
    SceneRobotBuildTip = "Assets/Main/Prefabs/UI/Build/RobotBuildTip.prefab",
    --奖励飞上去消失
    UIDetectEventRewardFlyItem = "Assets/Main/Prefabs/UI/UIDetectEventRewardFly/UIDetectEventRewardFlyItem.prefab",

    GoToMoveBubble = "Assets/Main/Prefabs/CityScene/GoToMoveBubble.prefab",
    UIGuideTalkSelectBtn = "Assets/Main/Prefab_Dir/Guide/UIGuideTalkSelectBtn.prefab",
    BuildCancelEffect ="Assets/Main/Prefabs/BuildEffect/BuildTrainCompleteEffect.prefab",
    UIGuideTalkScene ="Assets/Main/Prefab_Dir/Guide/UIGuideTalkScene.prefab",
    FormationSelectListCellNew = "Assets/Main/Prefab_Dir/UI/UIFormation/FormationSelectCellNew.prefab",
    UIMainFormationSelectListCellNew = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainFormationSelectCellNew.prefab",
    UIMainFormStatusItem = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainFormStatusItem.prefab",
    UIMainMasteryStatusItem = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainMasteryStatusItem.prefab",
    UIGuideJianzhangTimeline = "Assets/_Art/Models/Npc/jianzhang/prefab/GuideJianzhangTimeline.prefab",
    NextGarbagePoint = "Assets/Main/Prefabs/CityScene/NextGarbagePoint.prefab",
    UIGuideMoveEndFlag = "Assets/Main/Prefab_Dir/Guide/UIGuideMoveEndFlag.prefab",
    WorldPointRewardItem = "Assets/Main/Prefabs/UI/World/WorldPointRewardItem.prefab",
    MonthCardBenefitItem = "Assets/Main/Prefab_Dir/UI/GiftPackage/MonthCardBenefitItem.prefab",
    WorldArrow = "Assets/Main/Prefab_Dir/Guide/WorldArrow.prefab",
    WorldYellowArrow = "Assets/Main/Prefab_Dir/Guide/WorldYellowArrow.prefab",
    WorldCanBuildEffect = "Assets/_Art/Effect/prefab/scene/Build/DaBen_GNXQ/VFX_cangqiongkuojian_f.prefab",
    CityCameraSand = "Assets/Main/Prefabs/CityScene/CityCameraSand.prefab",
    UIChatHeroCell = "Assets/Main/Prefab_Dir/ChatNew/UIChatHeroCell.prefab",
    BuildGrid = "Assets/Main/Prefabs/Building/BuildGrid%s.prefab";
    BuildSelect = "Assets/Main/Prefabs/Building/BuildSelect%s_%s.prefab";
    WorldSiegeUserCell = "Assets/Main/Prefabs/UI/World/WorldSiegeUserCell.prefab",
    WorldSiegeThroneUserCell = "Assets/Main/Prefabs/UI/World/WorldSiegeThroneUserCell.prefab",
    WorldSiegeRewardCell = "Assets/Main/Prefabs/UI/World/WorldSiegeRewardCell.prefab",
    WorldSiegeRewardItem = "Assets/Main/Prefabs/UI/World/WorldSiegeRewardItem.prefab",
    GuideGM = "Assets/Main/Prefab_Dir/Guide/GuideGM.prefab",
    UIShowBlackCell = "Assets/Main/Prefab_Dir/Guide/UIShowBlackCell.prefab",
    UIMainStorageMaxEffect = "Assets/_Art/Effect/prefab/ui/VFX_flyBox_glow.prefab",
    UIHeroStationSkill = "Assets/Main/Prefabs/UI/UIHeroStation/UIHeroStationSkill.prefab",

    WarningBlue = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_blue.prefab",
    WarningGreen = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_green.prefab",
    WarningRed = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_red.prefab",
    WarningYellow = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_yellow.prefab",
    WarningAllianceColor = "Assets/_Art/Effect/prefab/ui/VFX_ui_wardetail_jg_alliance.prefab",
    ShowMigrateScene = "Assets/Main/Prefabs/CityScene/ShowMigrateScene.prefab",
    UIHeroStationValUpItem = "Assets/Main/Prefabs/UI/UIHeroStation/UIHeroStationValUpItem.prefab",
    MonsterRewardBoxEffect = "Assets/_Art/Effect/prefab/scene/VFX_xiangzi_open_01.prefab",
    CitySpaceManFlyText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyText.prefab",
    CitySpaceManFlyWithBloodText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyWithBloodText.prefab",
    FlyText = "Assets/Main/Prefabs/CityScene/FlyText.prefab",
    UIComplexTipItem = "Assets/Main/Prefabs/UI/UIComplexTip/UIComplexTipItem.prefab",

    --冠军对决阶段ui item
    ResChampionBattleItem_signUp = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/ChampionBattleItem_signUp.prefab",
    ResChampionBattleItem_auditions = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/ChampionBattleItem_auditions.prefab",
    ResChampionBattleItem_strongest = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/ChampionBattleItem_strongest.prefab",
    ResChampionBattleItem_strongest64 = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/ChampionBattleItem_strongest64.prefab",
    GroupEighthFinalsCell = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/GroupEighthFinalsCell.prefab",
    GroupHonorListCell = "Assets/Main/Prefab_Dir/UI/UIChampionBattle/GroupHonorListCell.prefab",
    UIPiggyBankDropCoin = "Assets/Main/Prefabs/UI/UIPiggyBank/UIPiggyBankDropCoin.prefab",
    UIEnergyBankDropCoin = "Assets/Main/Prefabs/UI/UIEnergyBank/UIEnergyBankDropCoin.prefab",
    UISubWayItem = "Assets/Main/Prefab_Dir/UI/UISubWay/UISubWayItem.prefab",
    UITroopDetailItem = "Assets/Main/Prefabs/UI/UIForcesDetail/UITroopDetailItem.prefab",
    SeasonAllianceRewardItem = "Assets/Main/Prefabs/UI/UISeason/seasonAllianceRewardItem.prefab",
    SeasonGroundAttrItem = "Assets/Main/Prefabs/UI/UISeason/seasonGroundAttrItem.prefab",
    UIScrollPackPoint = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackPoint.prefab",
    GuideAllianceMemberEffect = "Assets/Main/Prefab_Dir/Guide/GuideAllianceMemberEffect.prefab",
    UIAllianceScienceCell = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceScience/UIAllianceScienceCell.prefab",
    MailDestroyRankItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/MailDestroyRankItem.prefab",
    UIPoliceStationCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIPoliceStationCell.prefab",
    ShowRobotScene = "Assets/Main/Prefabs/CityScene/ShowRobotScene.prefab",
    MailBattleAttrDetailTitle = "Assets/Main/Prefab_Dir/Mail/ObjMail/PlayerReport/MailPlayerReportInfoCell1.prefab",
    MailBattleAttrDetailCell = "Assets/Main/Prefab_Dir/Mail/ObjMail/PlayerReport/MailPlayerReportInfoCell2.prefab",
    UIShowReasonDesCell = "Assets/Main/Prefab_Dir/UI/UIShowReason/UIShowReasonDesCell.prefab",
    UIGarageRefitItemTipLine = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitItemTipLine.prefab",
    UIGarageRefitUpgradeLine = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeLine.prefab",
    UIGarageRefitUpgradeLine2 = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeLine2.prefab",
    UISkillAdvanceSuccessCell = "Assets/Main/Prefabs/UI/UIHero/New/UISkillAdvanceSuccessCell.prefab",

    AllianceFlagBgItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceFlagBgItem.prefab",
    AllianceFlagFgItem = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceFlagFgItem.prefab",
    JigsawAreaBlockItem = "Assets/Main/Prefab_Dir/UI/UIJigsawArea/JigsawAreaBlockItem.prefab",

    SetAlOfficialPosItem = "Assets/Main/Prefab_Dir/UI/Alliance/AlliancePosition/SetAlOfficialPosItem.prefab",
    UIAllianceCareerRow ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerRow.prefab",
    UIAllianceCareerInfoCell ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerInfoCell.prefab",
    UIAllianceCareerAddCell ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerAddCell.prefab",
    UIAllianceCareerEffectCell ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerEffectCell.prefab",
    UIAllianceCareerChangeCell ="Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerChangeCell.prefab",
    WorldBattleAbbr = "Assets/Main/Prefabs/UI/World/WorldBattleAbbr.prefab",
    HeroBountyItem = "Assets/Main/Prefabs/UI/UIHero/New/HeroBountyItem.prefab",
    MailPlayerHeroItem = "Assets/Main/Prefab_Dir/Mail/ObjMail/PlayerReport/MailPlayerHeroItem.prefab",
    UITroopSkillItem = "Assets/Main/Prefab_Dir/UI/UIMain/UITroopSkillItem.prefab",
    FromMjBuildMainBuildScene = "Assets/Main/Prefabs/CityScene/FromMjBuildMainBuildScene.prefab",
    MainZeroUpgradeScene = "Assets/Main/Prefabs/CityScene/MainZeroUpgradeScene.prefab",
    UIMainQuestObj = "Assets/Main/Prefab_Dir/UI/UIMain/questObj.prefab",
    UIPveQuestObj = "Assets/Main/Prefab_Dir/UI/UIMain/questPveObj.prefab",
    UIPveBuffCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPveBuffCell.prefab",
    UIPVEShopCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVEShopCell.prefab",
    UIPVEShopCostCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVEShopCostCell.prefab",
    UIPVESceneBuffCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVESceneBuffCell.prefab",
    UIPveNeedResourceCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPveNeedResourceCell.prefab",
    UIPVESelectBuffCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVESelectBuffCell.prefab",
    UIPVESelectBattleBuffCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVESelectBattleBuffCell.prefab",
    UIPVESelectDiffCell = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVESelectDiffCell.prefab",
    SecondMigrateScene = "Assets/Main/Prefabs/CityScene/SecondMigrateScene.prefab",
    XuanFengZhanEffect = "Assets/Main/Prefabs/Effect/XuanFengZhanEffect.prefab",
    TilePlaneRuin = "Assets/Main/Prefabs/CityScene/TilePlaneRuin.prefab",
    UIPVEBloodLayerItem = "Assets/Main/Prefab_Dir/Guide/pveBloodTipItem.prefab",
    UIPVEBloodItem = "Assets/Main/Prefab_Dir/Guide/UIPveBloodItem.prefab",
    SaveBobScene = "Assets/Main/Prefabs/CityScene/SaveBobScene.prefab",
    UIPVEBattleBuffItem = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVEBattleBuffItem.prefab",
    UIPVEPackItem = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVEPackItem.prefab",
    UIPVEUseSkillItem = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVEUseSkillItem.prefab",
    PirateFightBobScene = "Assets/Main/Prefabs/CityScene/PirateFightBobScene.prefab",
    PirateComeScene = "Assets/Main/Prefabs/CityScene/PirateComeScene.prefab",
    PirateAwayScene = "Assets/Main/Prefabs/CityScene/PirateAwayScene.prefab",
    UINpcTalkBubbleLeft = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleLeft.prefab",
    UINpcTalkBubbleRight = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleRight.prefab",
    UINpcTalkBubbleHeroEntrust = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleHeroEntrust.prefab",
    UINpcTalkBubbleHeroEntrustCell = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkBubbleHeroEntrustCell.prefab",
    UIHeroEntrustCell = "Assets/Main/Prefabs/UI/UIHeroEntrust/UIHeroEntrustCell.prefab",
    PirateShowScene = "Assets/Main/Prefabs/CityScene/PirateShowScene.prefab",
    NpcTalkBubbleHeroEntrust = "Assets/Main/Prefabs/CityScene/HeroEntrustBubble%s.prefab",
    RadarScanScene = "Assets/Main/Prefabs/CityScene/RadarScanScene.prefab",
    UITalentChooseCell = "Assets/Main/Prefabs/UI/UITalent/UITalentChooseCell.prefab",
    UITalentIcon = "Assets/Main/Prefabs/UI/UITalent/UITalentIcon.prefab",
    TalentGroupInfoCell = "Assets/Main/Prefabs/UI/UITalent/TalentGroupInfoCell.prefab",
    ShowFakePlayerFlagScene = "Assets/Main/Prefabs/CityScene/ShowFakePlayerFlagScene.prefab",
    RadarWorldScanScene = "Assets/Main/Prefabs/CityScene/RadarWorldScanScene.prefab",
    PickUpWeaponNewABanScene = "Assets/Main/Prefabs/CityScene/PickUpWeaponNewABanScene.prefab",
    TankScene = "Assets/Main/Prefabs/CityScene/TankScene.prefab",
    CitySpaceManFlyBloodText = "Assets/Main/Prefabs/CityScene/CitySpaceManFlyBloodText.prefab",
    CollectionBlood = "Assets/Main/Prefabs/PVE/CollectionBlood.prefab",
    PveHeroSummon = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_hero_zhaohuan.prefab",
    UIHeroOfferRewardFirstCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroOfferRewardFirstCell.prefab",
    UIHeroOfficialFetterItem = "Assets/Main/Prefabs/UI/UIHeroOfficial/UIHeroOfficialFetterItem.prefab",
    UIHeroIntensifyItem = "Assets/Main/Prefab_Dir/UI/UIHeroIntensify/UIHeroIntensifyItem.prefab",
    PveThreeBombsScene = "Assets/Main/Prefabs/CityScene/PveThreeBombsScene.prefab",
    PveDestroyHdc1Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc1Scene.prefab",
    PveDestroyHdc2Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc2Scene.prefab",
    PveDestroyHdc3Scene = "Assets/Main/Prefabs/CityScene/PveDestroyHdc3Scene.prefab",
    PveDestroyMountainScene = "Assets/Main/Prefabs/CityScene/PveDestroyMountainScene.prefab",
    PveHdcEscapeScene = "Assets/Main/Prefabs/CityScene/PveHdcEscapeScene.prefab",
    PveTurretMissile = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_dapao_trail.prefab",
    PveSkyMissile = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_liudan_trail.prefab",
    WeaponMuchEffectTrail = "Assets/Main/Prefab_Dir/Solider/ShiHuangXiaoRen/prefab/WeaponMuchEffectTrail.prefab",
    PveTriggerPointBubble = "Assets/Main/Prefabs/CityScene/PveTriggerPointBubble%s.prefab",
    PingItem = "Assets/Main/Prefabs/UI/Common/PingItem.prefab",
    UIPveMonsterHpBar = "Assets/Main/Prefabs/PVE/PveMonster_HpBar.prefab",
    UIHeroRaritySquare = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_dikuai_blue.prefab",
    GuluOutFromBaseScene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_1.prefab",
    GuideTimeline2Scene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_2.prefab",
    DefendWallScene = "Assets/Main/Prefabs/CityScene/DefendWallScene.prefab",
    PveDropRewardBox = "Assets/Main/Prefabs/PVELevel/PveDropRewardBox.prefab",
    PveDropRewardBubble = "Assets/Main/Prefabs/CityScene/PveDropRewardBubble.prefab",
    GuideTimeline3Scene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_3.prefab",
    GatherEffectStar = "Assets/_Art/Effect/prefab/scene/VFX_shouge_xingxing.prefab",
    ChallengeBossEffect = "Assets/_Art/Effect/prefab/monster/Dashachong/VFX_shachong_zhaohuan.prefab",
    UIShowDetailCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIShowDetailCell.prefab",
    UIBuildUpgradeSuccessCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgradeSuccess/UIBuildUpgradeSuccessCell.prefab",
    ConnectElectricityScene = "Assets/Main/Prefabs/CityScene/ConnectElectricityScene.prefab",
    UIScrollPackPoint = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackPoint.prefab",
    Chapter2CameraMoveScene = "Assets/Main/Prefabs/GuideTimeline/GuideTimeline_5.prefab",
    Scene_City_Dig = "Assets/Main/Prefabs/World/Scene_City_Dig.prefab",
    Scene_City_Dig_B = "Assets/Main/Prefabs/World/Scene_City_Dig_b.prefab",
    UIChapterTaskCell = "Assets/Main/Prefab_Dir/UI/UIMainTask/UIChapterTaskCell.prefab",
    SmallDomeMigrateScene = "Assets/Main/Prefabs/CityScene/SmallDomeMigrateScene.prefab",
    UIMainPanelSpecialCell = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainPanelSpecialCell.prefab",
    WorldDesertCityEffectScene = "Assets/Main/Prefabs/CityScene/WorldDesertCityEffectScene.prefab",
    WorldAttackPlayerScene = "Assets/Main/Prefabs/CityScene/WorldAttackPlayerScene.prefab",
    UIDeadArmyRecordIconCell = "Assets/Main/Prefabs/UI/UIRepair/UIDeadArmyRecordIconCell.prefab",
    WorldAttackPlayerSubMonster = "Assets/Main/Prefabs/CityScene/WorldAttackPlayerSubMonster.prefab",
    WorldAttackPlayerMainMonster = "Assets/Main/Prefabs/CityScene/WorldAttackPlayerMainMonster.prefab",
    WorldNewsAbbrCell = "Assets/Main/Prefabs/UI/World/WorldNewsAbbrCell.prefab",
    --黑骑士
    UIBlackKnight = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIBlackKnight/UIBlackKnight.prefab",
    UIGloryPreview = "Assets/Main/Prefabs/UI/UIGlory/UIGloryMain/UIGloryMainPreview.prefab",
    UICampScore = "Assets/Main/Prefabs/UI/UIGlory/UIGloryMain/UICampScore.prefab",
    
    UIThroneRewardSelectMemberCell = "Assets/Main/Prefabs/UI/UIThrone/UIThroneRewardSelectMemberCell.prefab",
    SeasonEndIntroCell = "Assets/Main/Prefabs/UI/UIGlory/UIGlorySeasonEnd/SeasonEndIntroCell.prefab",
    SeasonEndTxt = "Assets/Main/Prefabs/UI/UIGlory/UIGlorySeasonEnd/SeasonEndTxt.prefab",
    UIScrollPackContentType = "Assets/Main/Prefab_Dir/UI/UIScrollPack/UIScrollPackContentType%s.prefab",
    MiniMapDragonItem = "Assets/Main/Prefab_Dir/UI/UIMiniMap/MiniMapDragonItem.prefab",
    --捐兵活动
    UIMasteryNode = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasteryNode.prefab",
    UIMasteryLine = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasteryLine.prefab",
    UIMasteryOverviewLine = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasteryOverviewLine.prefab",
    UIMasteryPageCell = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasteryPageCell.prefab",
    DonateSoldierPrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIActivityDonateSoldier.prefab",
    DonateSoldierRewardItemCover = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIDonateSoldierRewardPanelItemCell.prefab",
    -- 英雄勋章商店的itemcell
    UIHeroMedalShopItem = "Assets/Main/Prefab_Dir/UI/UIHeroMedalShop/UIHeroMedalShopItem.prefab",
    
    UIStoryStageItem = "Assets/Main/Prefab_Dir/UI/UIStory/UIStoryStageItem.prefab",
    
    AllianceHelpVirtualMarch = "Assets/Main/Prefabs/March/WorldVirtualTroop.prefab",
    TroopLine = "Assets/Main/Prefabs/March/TroopLine.prefab",
    FromCarBuildMainBuildScene = "Assets/Main/Prefabs/CityScene/FromCarBuildMainBuildScene.prefab",
    UIDecorationWorldScene = "Assets/Main/Prefab_Dir/UI/UIDecoration/UIDecorationWorldScene.prefab",
    UIHeroPluginTipCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginTipCell.prefab",
    UIHeroPluginUpgradeInfoCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeInfoCell.prefab",
    UIHeroPluginQualityCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginQualityCell.prefab",
    UIHeroPluginQualityTipCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginQualityTipCell.prefab",
    UIHeroPluginDesConstCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginDesConstCell.prefab",
    UIHeroPluginDesRandomWithoutCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginDesRandomWithoutCell.prefab",
    UIHeroPluginRankConstCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRankConstCell.prefab",
    UIHeroPluginRankRandomCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRankRandomCell.prefab",
    UIHeroPluginDesRandomWithCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginDesRandomWithCell.prefab",
    UIHeroPluginUpgradeRandomWithCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeRandomWithCell.prefab",
    UIHeroPluginUpgradeConstCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeConstCell.prefab",
    UIHeroPluginInfoRandomWithoutCell = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginInfoRandomWithoutCell.prefab",
    UIHeroPluginUpgradeEffectGold = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeEffectGold.prefab",
    UIHeroPluginUpgradeEffectOrange = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeEffectOrange.prefab",
    UIHeroPluginUpgradeEffectPurple = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeEffectPurple.prefab",
    UIHeroPluginRefineEffectGold = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRefineEffectGold.prefab",
    UIHeroPluginRefineEffectOrange = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRefineEffectOrange.prefab",
    UIHeroPluginRefineEffectPurple = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRefineEffectPurple.prefab",
    
    UICrossWonderAct = "Assets/Main/Prefab_Dir/UI/UICrossWonder/UICrossWonderAct/UICrossWonderAct.prefab",
    UICrossWonderRuleSubtitle = "Assets/Main/Prefab_Dir/UI/UICrossWonder/UICrossWonderRule/UICrossWonderSubtitle.prefab",
    UICrossWonderRuleDesc = "Assets/Main/Prefab_Dir/UI/UICrossWonder/UICrossWonderRule/UICrossWonderRuleDesc.prefab",
    UICrossWonderRewardHead = "Assets/Main/Prefab_Dir/UI/UICrossWonder/UICrossWonderReward/UICrossWonderRewardHead.prefab",
    UICrossWonderRewardItem = "Assets/Main/Prefab_Dir/UI/UICrossWonder/UICrossWonderReward/UICrossWonderRewardItem.prefab",
    
    UIEdenKill = "Assets/Main/Prefab_Dir/UI/UIEdenKill/UIEdenKill.prefab",
    UIEdenCrossWar = "Assets/Main/Prefab_Dir/UI/ActivityCenter/EdenCrossWar/UIEdenCrossWar.prefab",
    RuinsKillingEnemy = "Assets/Main/Prefab_Dir/UI/ActivityCenter/RuinsKillingEnemy/RuinsKillingEnemyView.prefab",
    UITurfWar = "Assets/Main/Prefab_Dir/UI/UITurfWar/UITurfWar.prefab",
    March = "Assets/Main/Prefabs/March/%s.prefab",
    
    UIMoreBtn = "Assets/Main/Prefabs/UI/Common/MoreBtn.prefab",
    UIMoreBtn = "Assets/Main/Prefabs/UI/Common/MoreBtn.prefab",
    HeroAdvanceEffect = "Assets/Main/Prefabs/Effect/HeroAdvanceEffect.prefab",
    UIHeroChooseCampCell = "Assets/Main/Prefab_Dir/UI/UIHero/New/UIHeroChooseCampCell.prefab",
    
    UIEveryDayHead = "Assets/Main/Prefab_Dir/UI/UIEveryDay/UIEveryDayHead.prefab",
    UIEveryDayItem = "Assets/Main/Prefab_Dir/UI/UIEveryDay/UIEveryDayItem.prefab",
    UIEveryDayItem = "Assets/Main/Prefab_Dir/UI/UIEveryDay/UIEveryDayItem.prefab",
    UIChangeNameAndPic = "Assets/Main/Prefab_Dir/UI/ActivityCenter/ChangeNameAndPic/UIChangeNameAndPic.prefab",
    UIGuidePioneerResultArenaCell = "Assets/Main/Prefab_Dir/Guide/UIGuidePioneerResultArenaCell.prefab",
    --国家评分
    CountryRating = "Assets/Main/Prefab_Dir/UI/ActivityCenter/CountryRating/CountryRating.prefab",
    UICommonItem = "Assets/Main/Prefab_Dir/UI/Common/UICommonItem.prefab",
    UICommonItemAct = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemAct.prefab",
    UICommonItem_TextMeshPro = "Assets/Main/Prefab_Dir/UI/Common/UICommonItem_TextMeshPro.prefab",
    UICommonItemSize = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemSize.prefab",
    UICommonItemChange75 = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemChange75.prefab",
    UICommonItemChange90 = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemChange90.prefab",
    UICommonItemChange114 = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemChange114.prefab",
    UICommonItemChange97 = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemChange97.prefab",
    UICommonItemChange84 = "Assets/Main/Prefab_Dir/UI/Common/UICommonItemChange84.prefab",
    UIBuildUpgradeAttrCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildUpgradeAttrCell.prefab",
    
    UIVitaResidentItem = "Assets/Main/Prefab_Dir/UI/UIVita/UIVitaResidentItem.prefab",
    UIVitaResidentDeadItem = "Assets/Main/Prefab_Dir/UI/UIVita/UIVitaResidentDeadItem.prefab",
    UIVitaMatter = "Assets/Main/Prefab_Dir/UI/UIVita/UIVitaMatter.prefab",
    UIFurnitureUpgradeAttrCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeAttrCell.prefab",
    UIFurnitureUpgradeWorkSlot = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeWorkSlot.prefab",
    Furniture = "Assets/Main/Prefab_Dir/Furniture/%s.prefab",
    UIFurnitureTrailEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureTrailEffect.prefab",
    UIFurnitureTrailFinishEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureTrailFinishEffect.prefab",
    UIFurnitureUpgradeIconEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeIconEffect.prefab",
    BuildUpgradeFinishEffect = "Assets/Main/Prefab_Dir/Effect/BuildUpgradeFinishEffect.prefab",
    UIBuildCreateDesCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildCreateDesCell.prefab",
    UIBuildCreateCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildCreateCell.prefab",
    UIFurnitureUpgradeFurnitureCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeFurnitureCell.prefab",
    SceneBuildTime = "Assets/Main/Prefabs/UI/Build/BuildTimeUI.prefab",
    UIGuideSpeechTalkLeftCell = "Assets/Main/Prefab_Dir/Guide/UIGuideSpeechTalkLeftCell.prefab",
    UIGuideSpeechTalkRightCell = "Assets/Main/Prefab_Dir/Guide/UIGuideSpeechTalkRightCell.prefab",
    UIBuildCanCreateEffect = "Assets/Main/Prefabs/Building/buildable.prefab",
    Common_Empty = "Assets/Main/Prefab_Dir/Home/Terrian/Common_Empty.prefab",
    FlyUnlockBtn = "Assets/Main/Prefab_Dir/Guide/FlyUnlockBtn.prefab",
    UIFurnitureUpgradeBtnEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeBtnEffect.prefab",
    UIScienceTabCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceTabCell.prefab",
    UIScienceDetailTitleCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceDetailTitleCell.prefab",
    UIScienceDetailDesCell = "Assets/Main/Prefabs/UI/UIScience/UIScienceDetailDesCell.prefab",
    UIShowPowerCell = "Assets/Main/Prefab_Dir/UI/UIShowPower/UIShowPowerCell.prefab",
    UIShowPowerFinishEffect = "Assets/Main/Prefab_Dir/UI/UIShowPower/UIShowPowerFinishEffect.prefab",
    UIScienceUpgradeEffect = "Assets/Main/Prefabs/UI/UIScience/UIScienceUpgradeEffect.prefab",
    UIScienceTabUpgradeEffect = "Assets/Main/Prefabs/UI/UIScience/UIScienceTabUpgradeEffect.prefab",
    UIBuildUpgradeDesCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildUpgradeDesCell.prefab",
    UIBuildUpgradeCell = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildUpgradeCell.prefab",
    UIBuildDetailTitleCell = "Assets/Main/Prefab_Dir/UI/UIBuildDetail/UIBuildDetailTitleCell.prefab",
    UIBuildDetailDesCell = "Assets/Main/Prefab_Dir/UI/UIBuildDetail/UIBuildDetailDesCell.prefab",
    UIAllianceScienceInfoDesCell = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceScience/UIAllianceScienceInfoDesCell.prefab",
    UIAllianceScienceInfoPreCell = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceScience/UIAllianceScienceInfoPreCell.prefab",
    UIAllianceScienceInfoRewardCell = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceScience/UIAllianceScienceInfoRewardCell.prefab",
    UIBubbleBuildCell = "Assets/Main/Prefab_Dir/UI/UIBubble/UIBubbleBuildCell.prefab",
    UIDrakeBoss = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DrakeBoss/UIDrakeBoss.prefab",
    QueueItem = "Assets/Main/Prefab_Dir/UI/UIQueueList/QueueItem.prefab",
    TroopQueueItem = "Assets/Main/Prefab_Dir/UI/UIQueueList/troopQueueItem.prefab",
    UISpeedCell = "Assets/Main/Prefabs/UI/UISpeed/UISpeedCell.prefab",
    UISpeedItem = "Assets/Main/Prefabs/UI/UISpeed/UISpeedItem.prefab",
    SpeedLackItem = "Assets/Main/Prefabs/UI/UISpeed/SpeedLackItem.prefab",
    VFX_idle_zzz = "Assets/Main/Prefab_Dir/Effect/VFX_idle_zzz.prefab",
    UIGarageRefitUpgradeTipCell = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeTipCell.prefab",
    UINumHitEffect = "Assets/Main/Prefab_Dir/Effect/UINumHitEffect.prefab",
    UnlockLandScene = "Assets/Main/Prefab_Dir/AnimScene/UnlockLandScene.prefab",
    BuildUpgradingEffect = "Assets/Main/Prefab_Dir/Effect/BuildUpgradingEffect.prefab",
    UIMainPopupPackageBtn = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainPopupPackageBtn.prefab",
    BuildMainGuideLight = "Assets/Main/Prefab_Dir/Effect/BuildMainGuideLight.prefab",
    Eff_dafuw_jiaozhan_X = "Assets/Main/Prefab_Dir/Land/ObjectModel/Eff_dafuw_jiaozhan_X.prefab",
    SecondNightScene = "Assets/Main/Prefab_Dir/AnimScene/SecondNightScene.prefab",
    HuntLodgeScene = "Assets/Main/Prefab_Dir/AnimScene/HuntLodgeScene.prefab",
    UIAnimEmoji = "Assets/Main/Prefab_Dir/UI/UIAnimEmoji/%s.prefab",
    BuildUpgradeJiaZi = "Assets/Main/Prefab_Dir/Effect/BuildUpgradeJiaZi.prefab",
    UIFurnitureCanAddExpEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureCanAddExpEffect.prefab",
    ResidentEnterCityScene = "Assets/Main/Prefab_Dir/AnimScene/ResidentEnterCityScene.prefab",
    ResidentComeScene = "Assets/Main/Prefab_Dir/AnimScene/ResidentComeScene.prefab",
    BaseBuildLightRangeScene = "Assets/Main/Prefab_Dir/AnimScene/BaseBuildLightRangeScene.prefab",
    UIGuideVitaDead = "Assets/Main/Prefab_Dir/Guide/UIGuideVitaDead.prefab",
    ResidentScene = "Assets/Main/Prefab_Dir/AnimScene/ResidentScene.prefab",
    UIFurnitureUpgradeExpEffect = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIFurnitureUpgradeExpEffect.prefab",
    UIHeroStarStoryBoxEffect = "Assets/_Art/Effect/prefab/ui/VFX_ui_box_light.prefab",
    SecondNightBScene = "Assets/Main/Prefab_Dir/AnimScene/SecondNightBScene.prefab",
    BuildHitEffect = "Assets/Main/Prefab_Dir/Effect/BuildHitEffect.prefab",
    UICommonResItem = "Assets/Main/Prefab_Dir/UI/UICommonResItem/UICommonResItem.prefab",
    QuestAnimScene = "Assets/Main/Prefab_Dir/Quest/QuestAnimScene.prefab",
    UIHeroSkillUnlockDesNode = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroSkillUnlockDesNode.prefab",
    UIMailHeroEquipLeftCell = "Assets/Main/Prefab_Dir/Mail/UIMailHeroEquipLeftCell.prefab",
    UIMailHeroEquipRightCell = "Assets/Main/Prefab_Dir/Mail/UIMailHeroEquipRightCell.prefab",
    UIWelfareTabCell = "Assets/Main/Prefab_Dir/UI/UIWelfareCenter/UIWelfareTabCell.prefab",
    LandLockSmokeEffect = "Assets/Main/Prefab_Dir/Effect/LandLockSmokeEffect.prefab",
}


SettingKeys =
{
    COK_PURCHASE_KEY = "Setting.COK_PURCHASE_KEY",                      --订单信息存放的key
    CATCH_ITEM_ID = "Setting.CATCH_ITEM_ID",
    COK_PURCHASE_SUCCESSED_KEY = "Setting.COK_PURCHASE_SUCCESSED_KEY",   --已成功订单号存放的key
    COK_PURCHASE_KEY = "Setting.COK_PURCHASE_KEY",                      --订单信息存放的key
    EFFECT_MUSIC_ON = "isEffectMusicOn",                                --音效
    BG_MUSIC_ON = "isBGMusicOn",                                        --音乐
    VIBRATE = "Setting.Vibrate",                                        --震动
    TOUCH_SP_FUN = "touch_sp_fun",                                      --问题反馈
    TASK_TIPS_ON = "isTaskTipsOn",                                      --任务提示
    COORDINATE_ON_SHOW = "COORDINATE_ON_SHOW",                          --坐标提示
    SETTING_ACCOUNT = "Setting.ACCOUNT",                              	--账号，本地缓存
    ACCOUNT_STATUS = "Setting.ACCOUNT_STATUS",                          --账号，验证状态
    GP_USERID = "Setting.GooglePlayID",                                 --谷歌账号
    FB_USERID = "Setting.FB_USERID",                                    --Facebook账号
    WX_APPID_CACHE = "Setting.WX_APPID_CACHE",                          --微信账号
    FB_USERNAME = "Setting.FB_USERNAME",                                --Facebook账号名字
    UUID = "Setting.UUID",                                              --用户uuid
    GAME_UID = "Setting.GAME_UID",                                      --用户id（使用这个）
    GM_FLAG = "Setting.GM_FLAG",
    SERVER_IP = "SERVER_IP",
    SERVER_PORT = "SERVER_PORT",
    SERVER_ZONE = "SERVER_ZONE",
    FUN_BUILD_MAIN_LEVEL = "FUN_BUILD_MAIN_LEVEL",
    CUSTOM_UID = "Setting.CUSTOM_UID",                                  --邮件
    AZ_ACCOUNT = "Setting.AZ_ACCOUNT",
    AZ_ACCOUNTSTATUS = "Setting.AZ_ACCOUNTSTATUS",
    DEVICE_UID = "Setting.DEVICE_UID",                                  --设备ID
    ACCOUNT_LIST = "Setting.ACCOUNT_LIST",                              --登录过的账号列表
    ACCOUNT_PWD = "Setting.ACCOUNT_PWD",                                --密码，本地缓存
    --ACCOUNT_PWD = "Setting.ACCOUNT_PWD",                                --密码，本地缓存
    DEVICE_ID = "DEVICE_ID",
    ACCOUNT_SENDMIL_AGAINTIME = "Setting.ACCOUNT_SENDMIL_AGAINTIME",    --记录验证邮件发送时间
    HERO_LIST_SORT_TYPE = "HERO_LIST_SORT_TYPE",                        --英雄界面排序设置
    CHAT_SHOW_ROOM_LIST = "CHAT_SHOW_ROOM_LIST",                        --聊天界面是否显示左边房间列表
    POST_PROCESSING = "POST_PROCESSING",                                --后处理
    HEIGHT_FOG = "HEIGHT_FOG",                                          --高度雾
    SCENE_PARTICLES = "SCENE_PARTICLES",                                --场景粒子
    SCENE_SURFACE = "SCENE_SURFACE",                                    --地表
    SCENE_BUILD = "SCENE_BUILD",                                        --建筑
    SCENE_DECORATIONS = "SCENE_DECORATIONS",                            --装饰物
    SCENE_MONSTER = "SCENE_MONSTER",                                    --野怪
    SCIENCE_TAB_UNLOCK = "SCIENCE_TAB_UNLOCK",                          --科技Tab已解锁
    SEARCH_MONSTER_LEVEL = "Setting.SEARCH_MONSTER_LEVEL",              --上次搜怪等级
    GAME_ACCOUNT = "GAME_ACCOUNT",
    GAME_PWD = "GAME_PWD",
    ACCOUNT_LIST_DEBUG = "ACCOUNT_LIST_DEBUG",							-- 内网测试账号列表
    ALLOW_TRACKING_CLICK = "ALLOW_TRACKING_CLICK",                      -- 点击“允许跟踪”
    LAST_ALLOW_TRACKING = "LAST_ALLOW_TRACKING",

    MAIL_COLLECT_LAST_OPEN = "MAIL_COLLECT_LAST_OPEN",                  -- 采集邮件上次打开的时间
    MAIL_MONSTER_REWARD_LAST_OPEN = "MAIL_MONSTER_REWARD_LAST_OPEN",    -- 怪物奖励邮件上次打开的时间
    SHOW_DEBUG_CHOOSE_SERVER = "SHOW_DEBUG_CHOOSE_SERVER",               -- 是否有选服界面
    CANCEL_MARCH_ALERT_UUIDS = "CANCEL_MARCH_ALERT_UUIDS",              --取消的行军警报
    MAIL_LAST_OPEN_TIME_BY_GROUP = "MAIL_LAST_OPEN_TIME_BY_GROUP_",     --上次打开邮件时间
    SHOW_USE_DIAMOND_ALERT = "SHOW_USE_DIAMOND_ALERT",                  --是否有使用钻石提示
    GOTO_POSITION_X = "GOTO_POSITION_X",--跳转的x坐标
    GOTO_POSITION_Y = "GOTO_POSITION_Y",--跳转的y坐标
    ALLIANCE_WAR_OLD_DATA = "ALLIANCE_WAR_OLD_DATA",--已查看过的联盟战争id
    SCENE_GRAPHIC_LEVEL = "SCENE_GRAPHIC_LEVEL",
    SCENE_FPS_LEVEL = "SCENE_FPS_LEVEL",
    BUILD_NO_SHOW_UNLOCK = "BUILD_NO_SHOW_UNLOCK", -- 已查看过的建筑解锁动画
    ACTIVITY_VISITED_END_TIME = "ACTIVITY_VISITED_END_TIME", -- 上次访问活动界面的endTime
    WORLDARROW_TYPE_BUILD_NUM = "WORLD_ARROW_TYPE_BUILD_NUM",--建筑arrow出现的次数
    FIRST_INCITY_CHAT_SHOW = "FIRST_INCITY_CHAT_SHOW",--第一次显示任务
    ALLIANCE_ORDER_WELCOME = "ALLIANCE_ORDER_WELCOME", --首次进入联盟农场活动，显示过场
    WORLDARROW_TYPE_NUM = "WORLDARROW_TYPE_NUM_",--arrow出现的次数
    LOGIN_SECOND_DAYS = "LOGIN_SECOND_DAYS", -- 第二天登录游戏
    HERO_STATION_VIEWED = "HERO_STATION_VIEWED", -- 玩家已经看过的英雄驻扎面板, StationId
    HERO_STATION_VAL_CACHE = "HERO_STATION_VAL_CACHE", -- 英雄驻扎面板保存值
    REGISTER_TIME_REACH = "REGISTER_TIME_REACH",--第一次登陆游戏记录
    FIRST_PAY_BUY_CLICK = "FIRST_PAY_BUY_CLICK",--首冲按钮点击
    CAMP_RECRUIT_BUBBLE_TIP = "CAMP_RECRUIT_BUBBLE_TIP", --阵营招募建筑气泡提示
    DigCameraHeightSnap = "DigCameraHeightSnap",
    LOGIN_POP_K = "LOGIN_POP_K", --登录弹出轮到第几个了
    LOGIN_POP_LAST_TIME = "LOGIN_POP_LAST_TIME", --登录弹出上次记录时间
    FIRST_PAY_SHOWN = "FIRST_PAY_SHOWN", -- 首充是否显示过
    FIRST_ACCOUNTBIND_SHOW = "FIRST_ACCOUNTBIND_SHOW",--首次绑定账号是否显示过
    CAREER_CHANGE_CHECK_TIME = "CAREER_CHANGE_CHECK_TIME",
    PVE_EXP_HEROES = "PVE_EXP_HEROES", -- PVE经验关上阵英雄
    PVE_HEROES = "PVE_HEROES", -- PVE上阵英雄
    PVE_SPEED_OFFSET = "PVE_SPEED_OFFSET",   -- PVE战报速度
    ActLuckyRollJumpAnim = "Act_LuckyRoll_JumpAnim",
    ACT_GOLLOESCARD_JUMP_ANIM = "Act_GolloesCard_JumpAnim",
    FREE_SOLDIER_HIDE_WHEN_MAX = "FREE_SOLDIER_HIDE_WHEN_MAX", -- 兵营满时，免费收兵隐藏
    PVE_HERO_POWER_CONFIG_CACHE = "PVE_HERO_POWER_CONFIG_CACHE",
    PVE_HERO_POWER_CACHE = "PVE_HERO_POWER_CACHE",
    PVE_SPEED_SHOW_RED_DOT = "PVE_SPEED_SHOW_RED_DOT",
    CHAPTER_FIRST_SHOW = "CHAPTER_FIRST_SHOW",
    PVE_SPEED_SHOW_EFFECT  = "PVE_SPEED_SHOW_EFFECT",
    PVE_LV_POINT = "PVE_LV_POINT",
    LAST_WORLD_TREDN = "LAST_WORLD_TREDN" ,
    PVE_AUTO_PLAY = "PVE_AUTO_PLAY_V1" ,
    KEEP_PAY_VISIT_TIME = "KEEP_PAY_VISIT_TIME",
    CHAIN_PAY_VISIT_TIME = "CHAIN_PAY_VISIT_TIME",
    ActGiftBoxJumpAnim = "Act_GiftBox_JumpAnim",
    DEAD_ARMY_READ_TIME = "DEAD_ARMY_READ_TIME", --士兵死亡记录阅读时间
    GROWTH_PLAN_VISITED = "GROWTH_PLAN_VISITED",
    GROWTH_PLAN_VISITED_RED = "GROWTH_PLAN_VISITED_RED",
    SEASON_FORCE_REWARD = "SEASON_FORCE_REWARD",
    CHAT_GROUP_SHIELD = "CHAT_GROUP_SHIELD",--聊天屏蔽红点
    MAIL_MAIN_FIRST = "MAIL_MAIN_FIRST",
    BLACK_KNIGHT_CANCEL_WARNING = "BLACK_KNIGHT_CANCEL_WARNING",--黑骑士关闭预警
    BLACK_KNIGHT_RED_NEW = "BLACK_KNIGHT_RED_NEW",--黑骑士红点
    THRONE_ACT_TIME = "THRONE_ACT_TIME",
    CROSS_WORM_ADD_ARMY_NO_TIP = "CROSS_WORM_ADD_ARMY_NO_TIP",
    DONATE_SOLDIER_ACTIVITY_RED_NEW = "DONATE_SOLDIER_ACTIVITY_RED_NEW",--捐兵活动new红点
    DONATE_SOLDIER_ACTIVITY_NEW_TASK_RED = "DONATE_SOLDIER_ACTIVITY_NEW_TASK_RED",--捐兵活动新任务红点
    DONATE_SOLDIER_ALVS_ACTIVITY_RED_NEW = "DONATE_SOLDIER_ALVS_ACTIVITY_RED_NEW",
    ALLIANCE_BOSS_ACTIVITY_RED_NEW = "ALLIANCE_BOSS_ACTIVITY_RED_NEW",-- 联盟boss活动new红点
    CHAT_CONNECT_SERVER_INDEX = "CHAT_CONNECT_SERVER_INDEX",
    LAST_DRAGON_BATTLE_TIME = "LAST_DRAGON_BATTLE_TIME",
    MINING_CLICK_SWITCH = "MINING_CLICK_SWITCH",--矿产大亨点击切换英雄
    MINING_SKIP_ANIM = "MINING_SKIP_ANIM",--矿产大亨跳过动画
    SCRATCH_SKIP_ANIM = "SCRATCH_SKIP_ANIM",--刮刮卡跳过动画
    MYSTERIOUS_SKIP_ANIM = "MYSTERIOUS_SKIP_ANIM",--数字寻宝跳过动画
    MYSTERIOUS_VISIT = "MYSTERIOUS_VISIT",
    GLORY_PREVIEW_FIVE_GROUP = "GLORY_PREVIEW_FIVE_GROUP",--赛季5预告分组
    ActDigJumpAnim = "Act_Dig_JumpAnim",
    HeroCampRed = "HeroCampRed",
}
SoundGround =
{
    Music = "Music",
    Sound = "Sound",
    Effect = "Effect",
    Dub = "Dub",
}

SoundAssets =
{
    --Music_Sfx_click_hotgift = "ui_hotgift", --热推礼包音效
    --Music_Effect_CLICK_UPDATE_COMMON = "click_update_common",   --建造界面点击钻石升级
    --Music_Effect_CLICK_BUILDING = "click_building", --建造界面点击建造
    --Music_Effect_WARNING_COMMON = "warning_common",--警告类通知通用
    --Music_Effect_WARNING = "warning",--红屏警报音效（播放一次即可
    --Music_Effect_UI_BUTTON_COMMON = "ui_button_common",  --通用点击按钮
    --Music_bg_pve_battle = "bgm_base_night", --pve战斗
    --Music_bg_pve_exp = "bgm_base_night_01", --pve经验关
    --Music_bg_pve_wood = "m_field", --pve砍树
    Music_Bgm_night = "background_night",--主场景背景音乐
    Music_Bgm_day = "background_daytime",--主场景背景音乐
    Music_Bgm_world = "background_world",--世界背景音乐
    Music_Bg_loading = "background_loading",--loading
    Music_Effect_Loading_Light = "Effect_loading_light",--loading灯亮
    Music_bg_dragon_prepare = "bgm_dragon_prepare",--巨龙准备期
    Music_bg_dragon_war = "bgm_dragon_war",--巨龙战斗期
    Music_bg_eden_war = "bgm_pve_30034",--伊甸园背景乐
    Music_bg_pve = "background_pve",--pve场景音乐
    Music_Boss_Siege_1 = "background_boss_siege",--丧尸围城音乐 1
    Music_Boss_Siege_2 = "background_boss_siege_2",--丧尸围城音乐 2
    Music_Effect_Fire_Open ="Effect_fire_open",
    Music_Effect_Fire_Close ="Effect_fire_close",
    Music_Effect_Furniture_Trail = "Effect_furniture_trail",
    Music_Effect_Add = "Effect_add",
    Music_Effect_Dec = "Effect_dec",
    Music_Effect_Build_Upgrade ="Effect_Build_Upgrade"    ,--点击建筑升级
    Music_Effect_Furniture_Upgrade ="Effect_Furniture_Upgrade"    ,--点击家具升级
    Music_Effect_change_toggle = "Effect_change_toggle", --切页
    Music_Effect_Upgrade_Furniture_Click = "Effect_upgrade_furniture_click",
    Music_Effect_fireplace = "Effect_fireplace",--篝火燃烧
    Music_Effect_Guide_Talk = "Effect_guide_talk",--
    Music_Effect_Change_Day = "Effect_change_day",
    Music_Effect_Change_Night = "Effect_change_night",
    Music_Effect_Long_Night = "Effect_long_night",
    Music_Effect_Open ="effect_open"	,--打开界面
    Music_Effect_Close ="effect_close"	,--关闭界面
    Music_Effect_Ground ="effect_ground"	,--选中地块
    Music_Effect_Mist ="effect_mist"	,--选中迷雾
    Music_Effect_Building ="effect_building"	,--选中建筑
    Music_Effect_Ranch ="effect_ranch"	,--选中牧场
    Music_Effect_Creeps ="effect_creeps"	,--选中野怪/采集物
    Music_Effect_Army ="effect_army"	,--选中部队
    Music_Effect_Electric ="effect_electric"	,--收取电力
    Music_Effect_Crystal = "effect_crystal"	,--收取水晶
    Music_Effect_Stamina = "effect_stamina"	,--收取体力--MK_缺音效
    Music_Effect_Water ="effect_water"	,--收取净水
    Music_Effect_Gas = "effect_gas",--收取瓦斯
    Music_Effect_Coin ="effect_coin"	,--收取金币
    Music_Effect_Product1 ="effect_product1"	,--收取农田作物
    Music_Effect_Product2 ="effect_product2"	,--收取畜牧产品
    Music_Effect_Product3 ="effect_product3"	,--收取加工品
    Music_Effect_Plant ="effect_plant"	,--播种
    Music_Effect_Produce_Put ="effect_produce_put"	,--开始加工,拿起
    Music_Effect_Produce_Box ="effect_produce_box"	,--开始加工,关上纸箱
    Music_Effect_Produce_Work ="effect_produce_work"	,--机器手臂
    Music_Effect_Produce_Transport ="Effect_Produce_Transport"	,--机器手臂
    Music_Effect_Bill ="effect_bill"	,--交付订单
    Music_Effect_Button ="effect_button"	,--点击按钮
    Music_Effect_Gulu_Order_Button ="Effect_Gulu_Order_Button"	,--点击咕噜订单按钮
    Music_Effect_Gulu_Get_Reward ="Effect_Gulu_Get_Reward"	,--点击咕噜订单获得奖励
    Music_Effect_Message ="effect_message"	,--战斗胜利
    Music_Effect_Finish ="effect_finished"	,--建造/升级完成
    Music_Effect_Rocket ="effect_rocket"	,--火箭发射
    Music_Effect_Rocket_Land = "effect_rocket_land",--火箭落地
    Music_Effect_Plane_Arrive = "Effect_Plane_Arrive",--订单飞机到达
    Music_Effect_Plane_Leave = "Effect_Plane_Leave",--订单飞机起飞
    Music_Effect_Radar ="effect_radar"	,--雷达扫描
    Music_Effect_Radar_Item_Appear ="effect_radar_item_appear"	,--雷达物品出现
    Music_Effect_Alliance ="Effect_Bubble1"	,--联盟帮助
    Music_Effect_Collect_Crystal = "Effect_Collect_Crystal",--收取水晶的音效
    Music_Effect_Train_Soldiers = "Effect_Train_Soldiers",--点击收取士兵部队时播放
    Music_Effect_Train_Tank = "Effect_Train_Tank",--点击收取坦克部队时播放
    Music_Effect_Train_Aircraft = "Effect_Train_Aircraft",--点击收取飞机部队时播放
    Music_Effect_Train_Trap = "Effect_Train_Soldiers",--点击收取陷阱部队时播放 TODO: Beef
    Music_Effect_Start_Train_Soldiers = "Effect_Start_Train_Soldier",--点击训练士兵部队时播放
    Music_Effect_Start_Train_Tank = "Effect_Start_Train_Tank",--点击训练坦克部队时播放
    Music_Effect_Start_Train_Aircraft = "Effect_Start_Train_Aricraft",--点击训练飞机部队时播放
    Music_Effect_Hero_Upgrade1 = "Effect_Hero_Upgrade1",--英雄进阶时播放
    Music_Effect_Hero_Upgrade3 = "Effect_Hero_Upgrade3",--英雄突破
    Music_Effect_Science_Finish = "Effect_Science_Finish",--屏幕顶部弹出 研究完成 的提示时播放
    Music_Effect_Ue_Unclock ="Effect_Ue_Unclock",--弹出解锁某个功能时的窗口时播放
    Music_Effect_Science_Start = "Effect_Science_Start",--点击研究按钮时播放,此时开始研究科技
    Music_Effect_Click_Add_Cattle= "Effect_Click_Add_Cattle",--创建牛
    Music_Effect_Click_Add_Ostrich= "Effect_Click_Add_Ostrich",--创建鸵鸟
    Music_Effect_Click_Apartment = "Effect_Click_Apartment",--点击公寓
    Music_Effect_Click_Army1 = "Effect_Click_Army1",--点击坦克的音效
    Music_Effect_Click_Enemy1 = "Effect_Click_Enemy1",--点击野怪的音效
    Music_Effect_Click_Gulu = "Effect_Click_Gulu",--点击咕噜的音效
    Music_Effect_Click_GroundGoods = "Effect_Click_GroundGoods",--点击野外物品的音效
    Music_Effect_Ue_OneGood = "Effect_Ue_OneGood",--在获得奖励界面中，物品单个获得弹出的音效
    Music_Effect_Ue_GetPayReward = "Effect_Ue_GetPayReward",--弹出支付成功界面时的音效
    Music_Effect_Common_GetReward = "Effect_GetTaskReward",--点击任务交付按钮时播放
    Music_Effect_Build_Unclock = "Effect_Build_Unclock",--播放解锁建筑的特效同时播放
    Music_Effect_Ue_CombatPowerUp = "Effect_Ue_CombatPowerUp",--播放获得星星的动画同时播放
    Music_Effect_Ue_BuildList= "Effect_Ue_BuildList",--点击建造按钮后，弹出建造列表
    Music_Effect_Build_SelectTab1 ="Effect_Build_SelectTab1", --点击机器人按钮时播放
    Music_Effect_Build_SelectTab2= "Effect_Build_SelectTab2",--点击生活按钮时播放
    Music_Effect_Build_SelectTab3= "Effect_Build_SelectTab3",--点击军事按钮时播放
    Music_Effect_Build_SelectTab4 = "Effect_Build_SelectTab4",--点击基建按钮时播放
    Music_Effect_Build_SelectCard = "Effect_Build_SelectCard",--点击建筑卡片时播放
    Music_Effect_Common_SelectGoods = "Effect_Common_SelectGoods",--点击仓库内物品时播放
    Music_Effect_Common_ChangeNum = "Effect_Common_ChangeNum",--点击按钮导致数量变化时播放
    Music_Effect_Ue_GetReward = "Effect_Ue_GetReward",--弹出获得奖励窗口时播放
    Music_Effect_Start_March = "Effect_Start_March",--点击行军出征
    Effect_Recruit_Card_Befall = "Effect_GetHero_card", --卡牌掉落音效
    Effect_Recruit_Card_Flip1 = "Effect_GetHero_card1", --普通卡牌翻转音效
    Effect_Recruit_Card_Flip2 = "Effect_GetHero_card2", --紫色卡牌翻转音效
    Effect_Recruit_Card_Click = "Effect_GetHero_card1", --卡牌点击音效
    Music_Effect_Click_Building = "Effect_Click_Building",--点击建筑
    Music_Effect_Click_Building_In_Upgrade = "Effect_Click_Building_In_Upgrade",--点击建筑升级
    Music_Effect_Common_FailClick = "Effect_Common_FailClick",--订单非提交点击
    Music_Effect_Speed_Button ="Effect_SpeedUp_goods",--点击加速按钮(未直接完成)
    Music_Effect_Speed_Button2 ="Effect_SpeedUp_goods2",--点击加速按钮(直接完成)
    Music_Effect_Hit_Base ="Effect_Hit_Base",--陨石撞大本
    Music_Effect_Click_Formula= "Effect_Click_Formula",--加工厂内点击配方的音效：
    Music_Effect_Click_Bakery = "Effect_Click_Bakery",--点击建筑时播放 - 面包店
    Music_Effect_Click_TuckerStore = "Effect_Click_TuckerStore",--点击建筑时播放 - 塔可店
    Music_Effect_Click_Bar = "Effect_Click_Bar",--点击建筑时播放 - 酒吧
    Music_Effect_Click_JewelryStore = "Effect_Click_JewelryStore",--点击建筑时播放 - 珠宝店
    Music_Effect_Put_Formula = "Effect_Put_Formula",--加工厂内确认产物的音效：
    Music_Effect_Click_Ground2 = "Effect_Click_Ground2",--点击农田，如果有农作物时，使用音效
    Music_Effect_Click_Radar = "Effect_Click_Radar",--点击雷达建筑
    Music_Effect_Click_Main_City = "Effect_Click_Main_City",--点击大本
    Music_Effect_Click_Hero_Build = "Effect_Click_Hero_Build",--点击抽卡星门
    Music_Effect_Click_INFANTRY_BARRACK = "Effect_Click_INFANTRY_BARRACK",--点击建筑-机械兵营
    Music_Effect_Click_AIRCRAFT_BARRACK= "Effect_Click_AIRCRAFT_BARRACK",--点击建筑--空港
    Music_Effect_Click_TRAP_BARRACK= "Effect_Click_INFANTRY_BARRACK",--点击建筑--陷阱工厂 TODO: Beef
    Music_Effect_Click_BARRACKS = "Effect_Click_BARRACKS",--点击建筑-军营
    Music_Effect_Click_DRONE = "Effect_Click_DRONE",--点击建筑-无人机平台
    Music_Effect_Click_LIBRARY = "Effect_Click_LIBRARY",--点击建筑--图书馆
    Music_Effect_Click_ALLIANCE_CENTER ="Effect_Click_ALLIANCE_CENTER",--点击建筑-联盟大厅
    Music_Effect_Click_POLICE_STATION = "Effect_Click_POLICE_STATION",--点击建筑-太空警署
    Music_Effect_Click_CAR_BARRACK = "Effect_Click_CAR_BARRACK",--点击建筑-重工厂
    Music_Effect_Click_TRAINFIELD = "Effect_Click_TRAINFIELD",--点击车库
    Music_Effect_Click_COLD_STORAGE= "Effect_Click_COLD_STORAGE",--点击资源仓库
    Music_Effect_Click_SCIENE = "Effect_Click_SCIENE",--点击科研中心
    Music_Effect_Repair = "Effect_Repair",--点击维修
    Music_Effect_Hero_Skill = "Effect_Hero_Skill",--点击主建筑获取金币
    Effect_Exp_FarmSystem = "Effect_Exp_FarmSystem", --玩家获得经验
    Music_Effect_player_bag = "Effect_player_bag",--资源进入背包

    Music_Effect_Golloes_Trader = "Effect_Golloes_trader",
    Music_Effect_Golloes_Warrior = "Effect_Golloes_warrior",
    Music_Effect_Golloes_Explorer = "Effect_Golloes_explorer",
    Music_Effect_Golloes_Worker = "Effect_Golloes_worker",
    Music_Effect_Golloes_Build = "Effect_Golloes_build",

    Music_Effect_dig_blocksDropDown = "Effect_dig_blocksDropDown",
    Music_Effect_dig_digOneBlock1 = "Effect_dig_digOneBlock1",
    Music_Effect_dig_digOneBlock2 = "Effect_dig_digOneBlock2",
    Music_Effect_dig_doorOpenClose = "Effect_dig_doorOpenClose",
    Music_Effect_dig_getFinalReward = "Effect_dig_getFinalReward",

    --新手节点音效
    Music_Effect_PlantFlag = "Effect_PlantFlag",--插旗音效
    Music_Effect_Dome_Scan = "Effect_Dome_Scan",--苍穹扫描
    Music_Effect_show_to_plant = "show_to_plant",--播种
    Music_Effect_show_to_water = "show_to_plant",--浇水
    Music_Effect_guide_plane_arrive = "Effect_guide_plane_arrive",--引导飞机第一次落地
    Music_Effect_guide_air_drop = "Effect_guide_air_drop",--引导空投
    Music_Effect_guide_robot = "Effect_guide_robot",--引导机器人
    Music_Effect_guide_migrate = "Effect_guide_migrate",--引导移民
    Music_Effect_guide_ostrich = "Effect_guide_ostrich",--引导出现鸵鸟
    Music_Effect_guide_cattle = "Effect_guide_cattle",--引导出现牛
    Music_Effect_guide_pick_weapon = "Effect_guide_pick_weapon",--引导捡起斧头
    Music_Effect_enter_pve = "Effect_enter_pve",--点击pve按钮入口
    Music_Effect_pve_finish = "Effect_pve_finish",--pve完成
    Music_Effect_Attack = "effect_attack",--行军攻击
    Music_Effect_self_attack_low = "Effect_self_attack_low",
    Music_Effect_self_attack_high = "Effect_self_attack_high",
    Music_Effect_other_attack_low = "Effect_other_attack_low",
    Music_Effect_other_attack_high = "Effect_other_attack_high",
    Music_Effect_self_attack_mid = "Effect_self_attack_mid",
    Music_Effect_other_attack_mid = "Effect_other_attack_mid",
    Music_Effect_pve_box_appear = "Effect_pve_box_appear",--pve箱子出现
    Music_Effect_pve_box_get = "Effect_pve_box_get",--获取箱子
    Music_Effect_guide_second_migrate = "Effect_guide_second_migrate",--第二次移民
    Music_Effect_pve_debuff = "Effect_pve_debuff",--pve debuff
    Music_Effect_pve_buff = "Effect_pve_debuff",--pve buff
    Music_Effect_pve_gunAttack = "Effect_pve_gunAttack",--开枪
    Music_Effect_pve_skill = "Effect_pve_skill",--技能
    Music_Effect_pve_hero_weak = "Effect_pve_hero_weak",--英雄虚弱
    Music_Effect_pve_lost = "Effect_pve_lost",--pve失败
    Music_Effect_pve_call_reward = "Effect_pve_call_reward",--呼叫空投
    Music_Effect_pve_reward_land_lock = "Effect_pve_reward_land_lock",--降落伞
    Music_Effect_hero_box_open = "Effect_hero_box_open",--英雄抽卡宝箱
    Music_Effect_Task_Show = "Effect_Task_Show",--任务弹板出现
    Music_Effect_Guide_Get_New_Hero = "Effect_Guide_Get_New_Hero",--引导获取新英雄
    Music_Effect_Pirate_Fight_Bob = "Effect_Pirate_Fight_Bob",--海盗船和Bob打架
    Music_Effect_guide_show_build = "Effect_guide_show_build",--完成解锁建筑
    Music_Effect_pve_hero_vortex = "Effect_pve_hero_vortex_",--旋风斩
    Music_Effect_Pirate_Show = "Effect_Pirate_Show",--海盗出现
    Music_Effect_show_pve_effect = "Effect_show_pve_effect",
    Music_Effect_select_pve_effect = "Effect_select_pve_effect",
    Music_Effect_trigger_finish = "Effect_trigger_finish",
    Music_Effect_Golloes_Sort_Card = "Effect_Golloes_Sort_Card",--咕噜翻卡洗牌
    Music_Effect_Golloes_Show_All_Card = "Effect_Golloes_Show_All_Card",--咕噜一键翻卡
    Music_Effect_Golloes_Show_One_Card = "Effect_Golloes_Show_One_Card",--咕噜单张翻卡
    Music_Effect_Golloes_Refresh_Card = "Effect_Golloes_Refresh_Card",--咕噜刷新

    Music_Effect_Lucky_Roll_Click = "Effect_Lucky_Roll_Click",--点击转盘
    Music_Effect_Lucky_Select = "Effect_Lucky_Select",--转盘轮换
    Music_Effect_Sweep_Main = "Effect_Sweep_Main",--扫荡关最外层界面按钮点击
    Music_Effect_Sweep_Finish = "Effect_Sweep_Finish",--扫荡关内层界面按钮点击
    Music_Effect_Hero_Up = "Effect_Hero_Up",--上英雄音效
    Music_Effect_Hero_Down = "Effect_Hero_Down",--下英雄音效

    Music_Effect_pve_trigger_1 = "Effect_pve_trigger_1",--与气泡Trigger交互
    --装备音效
    Music_Effect_Click_Equipment_Upgrade = "Effect_Click_Equipment_Upgrade",--点击“升级”音效
    Music_Effect_Click_Equipment_Take_Off = "Effect_Click_Equipment_Take_Off",--点击“卸下”音效
    Music_Effect_Click_Equipment_Put_On = "Effect_Click_Equipment_Put_On",--点击“装备”音效
    Music_Effect_Click_Open_Equipment_Factory = "Effect_Click_Open_Equipment_Factory",--点击建筑上的图标打开“部件”界面-02
    Music_Effect_Click_Equipment_InUpgrade = "Effect_Click_Equipment_InUpgrade",--升级过程音效
    Music_Effect_Click_Equipment_Quality_Up = "Effect_Click_Equipment_Quality_Up",--提升品质音
    
    --矿产大亨挖矿音效
    Music_Effect_Mining01 = "mining01",
    Music_Effect_Mining02 = "mining02",
    Music_Effect_HERO_PLUGIN_SHOW_GOLD = "Effect_hero_plugin_show_gold",
    Music_Effect_HERO_PLUGIN_SHOW_ORANGE = "Effect_hero_plugin_show_orange",
    Music_Effect_HERO_PLUGIN_SHOW_NORMAL = "Effect_hero_plugin_show_normal",

    Music_Effect_Car_Move ="Bridge_Passing"    ,--序章小车移动音效
    Music_Effect_HERO_Upgrade = "hero_common_upgrade",
    Music_Effect_Alliance_Help = "Effect_alliance_help",--联盟帮助帮助别人音效
    Music_Effect_Open_Science_Tab ="Effect_open_science_tab"	,--打开科技tab界面音效
    Music_Effect_Open_Science_Tree ="Effect_open_science_tree"	,--打开科技树界面音效
    Music_Effect_Click_Science_Research ="Effect_science_research"	,--点击研究科技按钮
    Music_Effect_Click_Train_Btn ="Effect_click_train_btn"	,--点击 训练士兵按钮
    Music_Effect_Open_Common_Shop ="Effect_open_common_shop"	,--打开商店界面音效
    Music_Effect_Bell ="zhongsheng"	,--敲钟音效
    Music_Effect_Guide_Zombie_Coming ="guide_zombie_coming"    ,--丧尸来袭页面音效
    Music_Effect_Guide_Zombie_Boss_Show ="guide_zombie_boss_show"    ,--丧尸来袭boss出现
    Music_Effect_Guide_Zombie_Build_Upgrade ="guide_zombie_build_upgrade"    ,--丧尸来袭火堆升级
    Music_Effect_Guide_Zombie_Sing ="guide_zombie_zombie_sing"    ,--丧尸来袭僵尸吼叫
    Music_Effect_Guide_Start_Timeline ="guide_start_timeline"    ,--引导开始timeline声音
    Music_Effect_Guide_Start_Fire_Light ="guide_start_fire_light"    ,--引导开始timeline点火吓退丧尸声音
    Music_Effect_Guide_Start_Round ="Effect_zombie_round"    ,--引导开始timeline丧尸吼叫声音
    Music_Effect_Guide_Start_Zombie_Roar ="Zombie_roar"    ,--引导开始timeline丧尸吼叫声音
    Music_Effect_Guide_Finger = "Effect_Guide_Finger", --新手引导手指
    Music_Effect_Click_Task_Goto = "Effect_Click_Task_Goto",--任务跳转
    Music_Effect_Wind = "Effect_wind",--风沙
    Music_Effect_Paper = "Effect_paper",--纸张
    Music_Effect_Preview_Storm = "Effect_preview_storm",--丧尸来袭
    Music_Effect_Chapter_Flip = "Effect_chapter_flip",--翻页音效
    Music_Effect_Chapter_Print = "Effect_chapter_print",--手写文字音效
    Music_Effect_Pve_Show_Area_Open = "Effect_pve_show_area_open",--区域解锁提示的音效
    Music_Effect_Pve_Get_Area = "Effect_pve_get_area",--收复区域时的音效
    Music_Effect_Pve_Open_Fog = "Effect_pve_open_fog",--驱散迷雾的音效
    Music_Effect_Pve_Open_Block = "Effect_pve_open_block",--翻地块的音效
    Music_Effect_Pve_Wall_Fall = "Effect_pve_wall_fall",--围栏落下的音效
    Music_Effect_Light_Range = "Effect_light_range",--大本光照范围扩张音效
    Music_Effect_Power_Up= "Effect_Power_Up",--战斗力提升
    Music_Effect_Resident_Level_Up = "Effect_Resident_Level_Up",--NPC升级成功
    Music_Effect_Resident_Unlock = "Effect_Resident_Unlock",--NPC特性解锁
    Music_Effect_GetHero_One = "Effect_GetHero_One",--单抽
    Music_Effect_GetHero_Ten = "Effect_GetHero_Ten",--十连
    Music_Effect_First_Pay = "Effect_First_Pay",--首充
    Music_Effect_Main_Bag = "Effect_main_bag",--背包
    Music_Effect_Main_Alliance = "Effect_Main_Alliance",--联盟
    Music_Effect_Main_Hero = "Effect_Main_Hero",
    Music_Effect_Main_GiftPack = "Effect_Main_GiftPack",
    Music_Effect_Main_Task = "Effect_Main_Task",
    Music_Effect_Main_ChangeScene = "Effect_Main_ChangeScene",
    Music_Effect_Main_Activity = "Effect_Main_Activity",
    Music_Effect_Main_AlHelp = "Effect_Main_AlHelp",
    Music_Effect_Main_Mail = "Effect_Main_Mail",
    Music_Effect_AlHelp_otherHelpMe ="Effect_AlHelp_otherHelpMe",
    Music_Effect_Offline_Reward = "Effect_Offline_Reward",
    Music_Effect_Chapter_Reward = "Effect_Chapter_Reward",
    Music_Effect_PVE_Loading = "Effect_PVE_Loading",
    Music_Effect_Bubble_Soldier = "Effect_Bubble_Soldier",
    Music_Effect_Bubble_Science = "Effect_Bubble_Science",
    Music_Effect_Bubble_Arena = "Effect_Bubble_Arena",
    Music_Effect_Bubble_Build_Finish = "Effect_Bubble_Build_Finish",
    Music_Effect_Ready_Queue = "Effect_Ready_Queue", --幸存者到来给小人食物
    Music_Effect_Guide_Resident_Timeline ="guide_resident_scene_timeline",--餐厅timeline声音
    Music_Effect_Guide_Hunt_lodge_Timeline ="guide_hunt_lodge_scene_timeline",--打猎timeline声音
    Music_Effect_Chapter_Flip_Camera ="Effect_chapter_flip_camera",--打猎timeline声音
    Music_Effect_Garage_Upgrade = "Effect_Garage_Upgrade",--车库编队升级
    Music_Effect_Alliance_Science_Donate = "Effect_Alliance_Science_Donate",--联盟科技捐献
    Music_Effect_Click_Empty = "Effect_Click_Empty",
    Music_Effect_Resident_Change = "Effect_Resident_Change",--小人到来弹板
    Music_Effect_common_switch = "Effect_common_switch",--新页签切换音效
    Music_Effect_common_switch_2 = "Effect_common_switch_2",--子页签切换音效
}

TableName =
{
    Res_Lack_Tips = "res_lack_tips",   -- 资源不足提示
    ScienceNew = "APS_science",             -- 科技表
    ScienceTab = "scienceTab",             -- 科技Tab表
    APSScienceTab = "aps_science_tab",             -- 科技Tab表
    Science = "science2",             -- 科技表
    ArmsTab = "APS_arms",                   -- 士兵表
    GuideTab = "guide",                 -- 引导配置表
    PlotTab = "plot",                   -- 剧情配置表
    FieldMonster = "field_monster",     -- 野战怪物
    HeroTab = "new_heroes",             -- 英雄
    Robot = "robot",                    --机器人
    NewHeroes = "aps_new_heroes",                  --新英雄表
    NewHeroesB = "aps_new_heroes_B",                  --新英雄表B
    HeroBounty = "hero_bounty", --英雄悬赏
    NewHeroesQuality = "aps_heroes_quality",       --新英雄品质表
    NewHeroesLevelUp = "heroes_levelup",           --新英雄升级表
    NewHeroesLevelUp_B = "heroes_levelup_B",           --新英雄升级表B
    NewHeroesTag = "hero_tag",                     --新英雄tag表
    HeroMilitaryRank = "aps_heroes_rank",          --英雄军阶表
    HeroMilitaryRankLv = "aps_heroes_rankLv",          --英雄军阶表
    WorldLod = "world_scene",

    HeroRecruit = "officer_recruit",                --英雄招募表
    EffectNumDesc = "effect_num_des",
    HeroArkCore   = 'hero_core',

    GoodsTab = "goods",                 -- 物品
    SkillTab = "skill",                 -- 技能
    BattleAnimation = "battle_animation",             -- 战斗性效果
    StatusTab = "status",
    EquipRandomEffect = "equip_random_effect",        -- 装备效果
    Recharge = "recharge",        -- 福利中心,金币宝藏使用
    AllianceGift = "alliance_gift",     -- 联盟礼包
    AllianceGiftGroup = "alliance_gift_group",
    AllianceItemWarehouse = "alliance_item_warehouse", -- 联盟中心原材料
    Territory = "territory",            -- 联盟领地
    TerritoryEffect = "territory_effect",            -- 联盟领地
    GoldrushBuilding = "goldrush_building",
    ServerPos = "serverpos",--服务器世界联通
    SiegeNPC = "siegeNPC",--NPC
    Diary = "diary",--diary Diary_Xml 末日笔记
    ActivityShow = "activity_show",--activity_show 活动数据
    HeroSkill = "new_hero_skills",      --英雄技能
    RightsEffectLevel = "rights_effect_level",--特权权益等级
    RightsEffect = "rights_effect",--特权权益
    VipStoreUnlock = "vip_store_unlock",--vip商店解锁
    VipDetails = "vipdetails",--vip详情
    Vip = "vip",
    VipTemp = "vip_temp",
    Affect_Num = "affect_num",
    WorldSeason = "world_season",  -- 末日争霸-英雄预览
    WorldBuilding = "building_world", -- 世界建筑
    DesertTalent = "DesertTalent_DesertTalent",    -- 专精
    TalentShading = "DesertTalent_Shading",  -- 专精
    TalentHome = "talentHome",        -- 专精类型
    DesertGoldmineWar = "DesertGoldmineWar",
    DesertTalentStats = "DesertTalentStats",    -- 专精统计
    Decompose = "decompose",                    -- 加工厂原材料
    ActivityPanel = "activity_panel",--activity_panel 活动面板数据
    Missile = "missile",--activity_panel 活动面板数据
    DateBaseOtherLoadingTips = "loadingTips",--loading时的文字描述
    LoadingTips = "loadingTips",--loading时的文字描述
    Mail_ChannelID = "Mail_ChannelID", --邮件列表排序
    QuestXml = "quest",--任务队列表
    DesertSkillXml = "desertSkill",
    GuideStep = "guide_step_GuideStep",
    GuideStepContentInfo = "guide_step_ContentInfo",
    Office = "office",
    DayAct = "DayAct",
    ActSeven = "AcitivitySeven_New",
    DoomsDayNote = "doomsdaynote_doomsdaynote",
    DD_Season_Group = "DD_season_group",
    Building = "building",--建筑信息
    BuildingDes = "building_des",--建筑信息
    Chapter = "chapter_1",--章节任务信息
    ScienceShow = "scienceShow",
    Global = "APS_global", --全局表
    DailyQuest = "daily_quest", --每日任务
    Role = "role",--英雄经验
    HeroColor = "APS_hero_color",--英雄品质表
    Score ="score",
    TalentType = "APS_talent_type",--英雄天赋类型表
    Talent = "APS_talent",--天赋表
    TalentType = "talent_type", --大本天赋
    Talent_New = "talent",--大本天赋
    Order = "aps_purchase_order",--订单表
    LevelUp = "level_up",--建筑升级解锁表
    UavDialogue = "aps_uav_dialogue",--建筑队列对话表
    Monster = "APS_monster",                   -- 怪物表
    ResourcesCollect = "resources_collect",  --采集资源
    AllianceResource = "alliance_resource",  --联盟资源点
    Resource = "aps_resources",                   -- 资源表
    BirthPoint = "birth_coordinate_0",                   -- 出生点表
    DetectEvent = "detect_event",                --探测事件表
    CityManage = "aps_city_buff",                --城市管理表
    Rocket_Order = "rocket_order", -- 火箭订单表
    MineCave = "mine",--次元矿洞
    DigActivityDig = "activity_dig",
    DigActivityPara = "activity_dig_para",
    JigsawPuzzle = "activity_jigsaw",--拼图
    SpeedUpConfig = "speedup_config",                --通用加速表
    Guide = "noviceboot",                --引导表
    BuildQueue = "aps_build_queue",                --建造队列表
    APS_PUSH = "APS_push",      -- 消息推送
    APS_SINGLEMAP_JUNK = "aps_singlemap_junk",  --新手用单人垃圾表
    APS_SINGLEMAP_PIONEER = "aps_singlemap_pioneer",
    WorldCity = "worldcity",                  --联盟城点
    EdenPass = "eden_pass",                  --联盟城点
    EdenArea = "eden_area",
    DesertRefresh = "desert_refresh",                  --地块刷新规则
    Desert = "desert", --地块信息列表
    ActivityOverview = "activity_showlist",                  --活动总览
    Announcement = "scrolling_announcement", --滚动条消息
    UnlockBtn = "interfaceSetting",                   --解锁按钮表
    CityJunk = "aps_singlemap_junk",
    ArrowTip = "arrow_tips",
    SingleMapPosition = "aps_singlemap_position",--苍穹内可以建造和不可建造点信息
    GuideB = "noviceboot_B",                --引导表测试B
    HeroStation = "hero_station", --英雄驻扎
    Trends = "trends" ,--天下大势
    TrendsFunction = "trends_function",
    Warning = "aps_warning", --
    Farming = "aps_farming", --
    SysRedPacket = "sys_red_packet",
    GarageModify = "car_modify",
    GaragePart = "car_transform",
    AlScienceTab = "alScienceTab",
    AlScience = "alScience",
    AlEffect = "alliance_effect",--联盟职务表
    PVEZombie = "aps_pve_zombie",
    SteamPrice = "aps_steam_price",
    Army = "army",
    Army_B = "army_b",
    AllianceTask = "alliance_task",
    HeroOfficial = "hero_official",
    HeroIntensify = "hero_camp_intensify",
    HeroIntensifyRandomEffect = "hero_camp_random",
    QuestionAndAnswer = "questionAndAnswer",
    PveBuff = "aps_pve_buff",
    ActivityPuzzleMonster = "activity_puzzle_monster",
    NationConf = "aps_country",
    HeroEntrust = "hero_entrust",--英雄委托表
    BattlePass  = "battlepass",
    PVEAtom = "aps_pve_atom",
    BattleBuff = "aps_pve_battlebuff",
    ActivityMonster = "activity_monster",--activity_monster 打怪爬塔数据
    GatherResource = "aps_gather_resource",
    CollectResource = "aps_collect_resource",
    BuildZone = "aps_buildzone",
    Aps_Resource_Item = "aps_resource_item",
    Hero_Lack_Tips = "hero_lack_tips",
    Decoration = "decoration",--装扮表
    APS_Season = "aps_season",
    AllianceMine = "alliance_res_build",
    DragonBuilding = "dragon_building",
    FormStatus = "formation_status",
    BuildStatus = "building_status",
    CampEffect = "camp_effect",
    CampEffect_B = "camp_effect_b",
    SeasonWeek = "season_week",
    ActivityBoxOpen = "activity_boxopen",
    ActivityBoxOpenPara = "activity_boxopen_para",
    Equip = "equip",
    Equip_Suit = "suit_equip",
    SeasonGroup = "aps_season_group",
    Mastery = "season_mastery",
    MasterySkill = "season_active_skill",
    MasteryExp = "masteryExp",
    Government = "government",
    WonderGift = "wonder_gift",--王座礼包表
    OfficerList = "officer_list",
    RandomPlug = "random_plug",--随机英雄插件表
    RandomPlugCost = "random_plug_cost",--随机英雄插件消耗表
    MergeOrder = "merge_order",--合成表
    StoryMap = "push_map",--推图关地图表
    WatchAd = "watch_ad",
    VitaResident = "people",
    VitaResidentFeature = "people_talent",
    Opinion = "opinion",
    ResidentTalk = "opinion_raise",
    OpinionMail = "opinion_mail",
    ResidentStrike = "opinion_strike",
    PveHero = "pve_heroes",
    Pve = "pve",
    PveRolePart = "aps_pve_part_zombie",
    PveVFX = "c_vfx",
    PveActVFX = "c_vfx_act",
    C_Animations = "c_animations", -- 武器动作表
    C_Equips = "c_equips",    -- 装备
    LandZone = "land_lock",
    LandBlock = "land_block",
    LandReward = "land_reward",
    CityZombieSpawn = "city_zombie_spawn",
    CitySiegeAttack = "city_zombie_attack",
    CitySiegeZombie = "city_zombie_details",

    LwDispatchTask = "aps_dispatch_tasks",    --派遣任务
    LwDispatchSetting = "aps_dispatch_settings",    --派遣任务各种限制
    -- LW PVE
    HeroAppearance = "lw_hero_appearance",
    LW_Stage = "lw_stage",
    LW_Stage_Feature = "lw_stage_feature",
    LW_StageGroup = "lw_stage_group",
    LW_Count_Stage = "lw_count_stage",
    LW_Count_Stage_Group = "lw_count_stage_group",
    LW_Count_Stage_Trap = "lw_count_stage_trap",
    LW_Count_Stage_Soilder = "lw_count_stage_soilder",
    LW_Scene = "lw_scene",
    LW_Sound = "lw_sound",
    LW_PathPoint = "lw_path_point",
    LW_Trigger_Item = "lw_trigger_item",
    LW_Hero_Effect = "lw_hero_effect",
    LW_Hero_Skill = "lw_hero_skill",
    LW_Monster = "lw_monster",
    LW_Buff = "lw_buff",
    LW_Bullet = "lw_bullet",
    LW_Skill_Effect = "lw_hero_skill_effect",
    LW_Monster_Born = "lw_monster_born",
    -- LW PVE end
    Equip = "ds_equip";
    EquipAttribute = "ds_equip_attribute";
    EquipMaterial = "ds_equip_material";
    EquipPromote = "ds_equip_promote";
    EquipUpgrade = "ds_equip_upgrade";
    Adaptive_Box = "adaptive_box";
    ActivityTip = "activity_tips";
}

NewQueueType =
{
    Default = 0,
    FootSoldier = 8,--机器人队列
    Hospital = 3,--急救帐篷
    Science = 6,--科技
    CarSoldier = 1,--坦克队列
    BowSoldier = 9,--飞机队列
    ProductEquip = 11, --英雄装备
    ArmyUpgrade = 34,--士兵升级
    DomainHospital = 35,--地块医院
    EquipMaterial = 36,--配件中心材料
    Trap = 44,--陷阱工厂
    TransportRes = 104,--资源运输
    Equip = 107,--配件中心装备
    BlastMissile = 111,--爆破飞弹
    GasMissile = 112,--毒气飞弹
    FreezingMissile = 113,--急冻飞弹
    CombustionMissile = 114,--燃烧飞弹
    IlluminationMissile = 115,--照明飞弹

}

QueueProductState =
{
    DEFAULT = 0,
}

TroopIconShowState =
{
    Hide = 0,
    Idle = 1,
    Broken = 2,
    Wait = 3,

}
ItemSpdMenu =
{
    ItemSpdMenu_ALL = 1, --——城建，造兵，科技，造陷阱，治疗
    ItemSpdMenu_Troop = 2,  --——行军
    ItemSpdMenu_Soldier = 3, --——造兵
    ItemSpdMenu_Heal = 4, -- 治疗
    ItemSpdMenu_Trap = 5, -- 造陷阱
    ItemSpdMenu_Science = 6, -- 科技
    ItemSpdMenu_City = 7, -- 城建
    ItemSpdMenu_DuanZao = 8, --锻造
    ItemSpdMenu_Helicopter = 9, --直升机
    ItemSpdMenu_Missile = 10, --导弹
    ItemSpdMenu_RemoveCity = 11, -- 拆除建筑
    ItemSpdMenu_Siege_Heal = 20, -- 征服岛治疗
    ItemSpdMenu_Desert_Heal = 21,--沙漠中治疗
    ItemSpdMenu_Fix_Ruins =22,--修复废墟
    ItemSpdMenu_HeroEquip =23,--英雄装备
}

--c_animations表中的类型
AnimationType = {
    Idle = "idle",
    Move = "move",
    Attack = "attack",
    SneakIdle = "sneakIdle",
    SneakMove = "sneakMove",
    InertialIdle = "intertialIdle",
    Sneak = "sneak",
    Run = "walk",
    WeakenWalk = "weakenWalk",
    Dead = "dead",
    DeadEnd = "deadEnd"
}

--新队列状态
NewQueueState =
{
    Free = 0,--空闲
    Prepare = 1,--准备
    Work = 2,--工作
    Finish = 3,--完成（状态为客户端倒计时结束但未向服务器发送队列消息的状态）
}

BuildType=
{
    Normal = 0, --一般建筑
    Main = 1,--主建筑
    Second = 2,--辅建筑
    Third = 3,--次建筑
    Furniture = 4,--家具
}
BuildingStateType =
{
    Normal = 0, --普通
    Upgrading = 1, --升级中
    FoldUp = 2,     --收起
    PAUSE_Upgrading = 3 ,--暂停升级
}

EffectLocalType =
{
    Num = 1,              --数字
    Time = 2,             --时间
    Percent = 3,          --百分比
    Dialog = 4,           --多语言
    PositiveNum = 5,      --正数
    NegativeNum = 6,      --负数
    PositiveTime = 7,     --正时间
    NegativeTime = 8,     --负时间
    PositivePercent = 9,  --正百分比
    NegativePercent = 10, --负百分比
}

EffectLocalTypeInEffectDesc = {
    Num = 0,--数值
    Percent = 1,--百分比
    Thousandth = 2,--千分比
    NegativePercent = 4,--负百分比
}

UIMainLeftButtonType = {
    None = 0,
    March = 1,      --行军
}

UIMainLeftButtonTypeSortList = {
    UIMainLeftButtonType.March,
}

UIMainTopResourceChangeType = {
    Normal = 0,           --正常状态，被Normal层页面压住
    ChangeLevel = 1,      --高层级状态，可以压住Normal层页面
}

UIGiftTypeButtonType = {
    Hot = "Hot",           --热销礼包
    Diamond = "Diamond",       --钻石
}

BattleType =
{
    None =0,
    Formation =1,--编队攻击
    Building =2,--建筑攻击
    Turret =3,--箭塔攻击
    Monster =4, -- 野怪
    RallyFormation=5,--集结编队攻击
    Boss =6,--集结怪
    City = 7,--大本
    Explore = 9, -- 探索点攻击
    ALLIANCE_NEUTRAL_CITY = 10, -- 联盟中立城
    ALLIANCE_OCCUPIED_CITY = 11, -- 联盟占领城
    ELITE_FIGHT_MAIL = 12,--冠军对决
    PVE_MARCH = 13, -- PVE玩家编队
    PVE_MONSTER = 14, -- PVE怪物
    ACT_BOSS =15, -- 活动boss
    PUZZLE_BOSS = 16,
    CHALLENGE_BOSS = 17,--挑战BOSS
    Desert = 18,--地块
    TRAIN_DESERT = 19,--19 训练地块
    ALLIANCE_BUILDING = 20,--20 联盟建筑
    ALLIANCE_CITY_GUARD = 22, --22 联盟城守备军
    CITY_GUARD = 23, --23 玩家大本守备军
    ALLIANCE_BUILD_GUARD = 24, --24 联盟建筑守备军
    BLACK_KNIGHT = 26, --26 黑骑士活动战报
    THRONE_ARMY = 27, --//27 王座军队
    CROSS_WORM = 28, -- 跨服虫洞
    AllianceBoss = 30, -- 联盟boss
    CITY_TRAP = 31, -- 陷阱
    ACT_ALLIANCE_MINE = 32,--32 活动联盟矿
    DRAGON_BUILDING = 33,-- 巨龙建筑
}

PlayerDesertAttr =
{
    SelfCount = 1,
    OtherCount = 2,
    Buff = 3,
    ResSpeedGas = 4,
    ResNum  = 5,
    ResSpeedFlint = 6,
    Force = 7,
    ForceRank = 8,
}

ActivityShowLocation = {   -- activity_daily 显示位置
    welfareCenter = 10  --   福利中心
}
ActivitySource = {
    activity = 1,
    shop = 2,
}

UIBagBtnType =
{
    Hot = 0,
    War = 1,
    Buff = 2,
    Resource = 3,
    Other = 4,
    HeroEquip = 5,
}

GoToType =
{
    None = -1,
    GotoBuilding = 0,
    GotoUI = 1

}

UIMainFunctionInfo = {
    None = 0,
    Report = 1, --报表
    Goods = 2, --物品
    Store = 3, --商城
    Info = 4, --个人信息
    Alliance = 5, --联盟
    Search = 6, --查找
    Task = 7, --任务
    Activity = 8, --活动中心
    Hero = 9, --英雄
    Mail = 10, --邮件
    Chat = 11, --聊天
    Story = 12, -- 推图关
    Radar = 13,--雷达
    Notice = 14,--公告
    MonsterReward = 15,--打怪奖励
}

UIMainBtnIconName =
{
    [UIMainFunctionInfo.Hero] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_hero",
    [UIMainFunctionInfo.Goods] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_bag",
    [UIMainFunctionInfo.Store] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_shop",
    [UIMainFunctionInfo.Alliance] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_alliance",
    [UIMainFunctionInfo.Task] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_task",
    [UIMainFunctionInfo.Activity] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_activity",
    [UIMainFunctionInfo.Chat] = "Assets/Main/Sprites/UI/UIMain/but_da_1",
    [UIMainFunctionInfo.Story] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_story",
    [UIMainFunctionInfo.Search] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_search",
    [UIMainFunctionInfo.Radar] = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_radar",
}

ScienceTab =
{
    Resource = 1,
    Fight = 2,
    --联盟
    AllianceDevelop = 101,
    AllianceFight = 102,
    AllianceDefense = 103,
    AllianceBuild = 104,

}

--资源部队采集对应科技
ResourceTypeScience =
{
    [ResourceType.Metal] = 731000,
    [ResourceType.Oil] = 751000,
    [ResourceType.Water] = 732000,
}

ResourceTypeTxt =
{
    [RewardType.METAL] = "100013",
    [RewardType.OIL] = "100014",
    [RewardType.PLANK] = "180265",
    [RewardType.FOOD] = "100909",
    [RewardType.WATER] = "100546",
    [RewardType.ELECTRICITY] = "100002",
    [RewardType.FLINT] = "110353",
    [RewardType.MONEY] = "100000",
    [RewardType.GOLD] = "100183",
    [RewardType.SAPPHIRE] = "390967",
    [RewardType.PVE_POINT] = "400011",
    [RewardType.DETECT_EVENT] = "140073",
    [RewardType.FORMATION_STAMINA] = "100510",
    [RewardType.WOOD] = "180265",
    [RewardType.PVE_STAMINA] = "100510",
    [RewardType.ELECTRICITY] = "100911",
    [RewardType.STEEL] = "100002",
    [ResourceType.Gold] = "100183",
}

UIScienceSortList =
{
    ScienceTab.Resource,
    ScienceTab.Fight,
}

ScienceResearchUseGold =
{
    NoUseGold = 0,--不使用钻石升级
    UseGold = 1,--使用钻石秒时间升级
    Free = 2,--免费升级(英雄加持)
}

IsGold =
{
    NoUseGold = 0,--不使用钻石
    UseGold = 1,--使用钻石
}

AllianceButtonType =
{
    None =0,
    AllianceBattle = 1,
    AllianceBuilding=2,
    AllianceHelp =3,
    AllianceGift =4,
    AllianceSalary = 5,
    AllianceScience =6,
    AllianceShop =7,
    AllianceSetting =8,
    AllianceList =9,
    AllianceRank =10,
    AllianceCheck =11,
    AllianceInvite =12,
    AllianceQuit =13,
    AllianceMail =14,
    AllianceAnnounce= 15,
    AllianceMember = 16,
    EverydayTask = 17,
    AllianceCity = 18,
    BecomeLeader = 19,
    AlLeaderElect = 20,
    AllianceTask = 21,
    AllianceMoveInvite = 22,
    AllianceMerge = 23,
}

PLayerInfoButtonType =
{
    None =0,
    MoreMessage =1,
    RankList =2,
    Setting =3,
    ActivityCenter = 4,
    Account = 5,
    Faq = 6,
    Talk=7,--聊天
    Alliance = 8,--联盟
    Citybuff = 9,
}

SoldierType =
{
    FootSoldier = 1,--机器人兵
    BowSoldier = 2,--飞机兵
    CarSoldier = 3,--坦克兵
    Trap = 4,--陷阱
}

BuildingTypes =
{
    FUN_BUILD_MAIN = 400000; -- 基地 总部大楼 (限制其他建筑的等级上限，本身受玩家殖民等级限制，兵力上限)
    FUN_BUILD_ARENA = 401000; -- 竞技场
    FUN_BUILD_SCIENE = 403000; -- 科研中心 (研究科技)
    FUN_BUILD_SMITHY = 407000; -- 联合指挥中心 (集结兵力)
    FUN_BUILD_CONDOMINIUM = 409000; -- 银行 (提供工人数量、居民（工人）订单气泡)
    FUN_BUILD_HOSPITAL = 411000; -- 维修站 (维修武器)
    FUN_BUILD_STONE = 412000; -- 采矿场 (采集面板资源矿)
    FUN_BUILD_OIL = 413000; -- 油井 (采集面板资源原油)
    FUN_BUILD_RADAR_CENTER = 417000; --雷达中心
    FUN_BUILD_ARROW_TOWER = 418000; -- 炮台 (防御物)
    FUN_BUILD_MASTERY_ARROW_TOWER = 419000; -- 专精炮台 (防御物)
    FUN_BUILD_CAR_BARRACK = 423000;--坦克制造厂 (生产车辆类的武器)
    FUN_BUILD_INFANTRY_BARRACK = 424000;--机器人工厂 (生产步兵类的武器)
    FUN_BUILD_AIRCRAFT_BARRACK = 425000;--飞机制造厂 (生产飞行类的武器)
    FUN_BUILD_TRAP_BARRACK = 778000;--陷阱工厂 (生产陷阱)
    FUN_BUILD_TRAINFIELD_1 = 427000; --兵营1
    FUN_BUILD_TRAINFIELD_2 = 793000; --兵营2
    FUN_BUILD_TRAINFIELD_3 = 794000; --兵营3
    FUN_BUILD_TRAINFIELD_4 = 795000; --兵营4
    FUN_BUILD_WATER = 432000;--抽水站 (采集面板资源水)
    FUN_BUILD_MARKET = 435000;--火箭发射场 交易中心 (火箭发射点，贸易，更换火箭皮肤)
    FUN_BUILD_BELL = 437000;--钟
    FUN_BUILD_WATER_STORAGE = 438000;--蓄水罐 (存放水)
    FUN_BUILD_OIL_STORAGE = 439000;--储油罐 (储存原油)
    FUN_BUILD_IRON_STORAGE = 441000;--矿石仓库 (储存矿石)
    FUN_BUILD_MILESTONE = 444000,--里程碑
    FUN_BUILD_SOLAR_POWER_STATION = 447000; -- 挖铁场
    FUN_BUILD_DRONE = 477000; -- 无人机平台 (提供建造队列)

    FUN_BUILD_VILLA = 700000; -- 别墅 (提升工程师数量，提升居民订单所需物品数量)
    FUN_BUILD_INFORMATION_CENTER = 713000; -- 信息中心 (新闻玩法、服务器大事、纪念碑)
    FUN_BUILD_COLD_STORAGE = 714000; -- 冷库 (冷库、用来放置水果果蔬等需要保鲜的产品)
    FUN_BUILD_COMPREHENSIVE_STORAGE = 715000; -- 综合仓库 (大型物流仓库可以放置各种商品)
    FUN_BUILD_DEFENCE_CENTER =716000;--备战中心
    APS_BUILD_PUB = 722000; --星际酒馆
    FUN_BUILD_FORGE = 429000; --装备制造--配件工厂
    FUN_BUILD_ELECTRICITY = 431000; --火力发电厂
    FUN_BUILD_HONOR_HALL = 446000;-- 荣誉大厅
    FUN_BUILD_BUILDING_CENTER = 448000; -- 建造中心
    FUN_BUILD_OFFICER = 483000;-- 英雄大厅
    FUN_BUILD_RECHARGE_GARAGE = 445000; -- 充值获得的车库
    FUN_BUILD_DOME = 449000;--苍穹
    FUND_BUILD_ALLIANCE_CENTER = 402000;--联盟太空中心
    APS_BUILD_WORMHOLE_MAIN = 791000;--虫洞（主
    APS_BUILD_WORMHOLE_SUB = 792000;--虫洞（副
    APS_BUILD_WORMHOLE_EXPORT = 792001, --虫洞出口
    FUN_BUILD_TEMP_WIND_POWER_PLANT = 796000, --新手引导风车
    FUN_BUILD_GROCERY_STORE = 724000, --咕噜营地
    FUN_BUILD_SCIENCE_PART = 725000,
    FUN_BUILD_BARRACKS = 797000,--军营
    FUN_BUILD_POLICE_STATION = 726000,--警察局

    FUN_BUILD_MARS_CAMP = 727000,--火星营地
    FUN_BUILD_LIBRARY= 728000,--公寓
    FUN_BUILD_GREEN_CRYSTAL = 730000,--小生产绿水晶建筑
    FUN_BUILD_HERO_BOUNTY = 732000,--英雄赏金工会
    FUN_BUILD_HERO_OFFICE = 733000,--英雄议会
    FUN_BUILD_HERO_BAR = 734000,--英雄酒吧
    WORM_HOLE_CROSS =735000, --跨服虫洞
    FUN_BUILD_OUT_WOOD =736000, --伐木场(生产资源道具)
    FUN_BUILD_OUT_STONE =737000, --(生产资源道具)
    FUN_BUILD_BOOK = 738000,--真正的图书馆

    --世界上的建筑
    SEASON_DESERT_RESISTANCE_1 = 741000,--抗性建筑1
    SEASON_DESERT_MAX_DESERT_1 = 742000,--地块上限建筑1
    SEASON_DESERT_MAX_FORMATION_SIZE_1 = 743000,--出征上限建筑1
    SEASON_DESERT_ARMY_ATTACK_1 = 744000,--部队攻击建筑1
    SEASON_DESERT_ARMY_DEFEND_1 = 745000,--部队防御建筑1
    SEASON_DESERT_RESISTANCE_2 = 746000,--抗性建筑2
    SEASON_DESERT_RESISTANCE_3 = 747000,--抗性建筑3
    SEASON_DESERT_RESISTANCE_4 = 748000,--抗性建筑4
    SEASON_DESERT_MAX_DESERT_2 = 749000,--地块上限建筑2
    SEASON_DESERT_MAX_FORMATION_SIZE_2 = 750000,--出征上限建筑2
    SEASON_DESERT_ARMY_ATTACK_2 = 751000,--部队攻击建筑2
    SEASON_DESERT_ARMY_DEFEND_2 = 752000,--部队防御建筑2
    SEASON_DESERT_BUILD_DRONE_1 = 753000,--世界工作台1
    SEASON_DESERT_BUILD_DRONE_2 = 754000,--世界工作台2
    SEASON_DESERT_NEW_MAX_DESERT_1= 755000,--新地块上限建筑1
    SEASON_DESERT_NEW_MAX_DESERT_2= 756000,--新地块上限建筑2
    
    EDEN_WORM_HOLE_1 = 757000,--伊甸园虫洞1 
    EDEN_WORM_HOLE_2 = 758000,--伊甸园虫洞2 
    EDEN_WORM_HOLE_3 = 759000,--伊甸园虫洞3
    --联盟矿
    ALLIANCE_RES_1 = 10000,
    ALLIANCE_RES_2 = 11000,
    ALLIANCE_RES_3 = 12000,
    ALLIANCE_RES_4 = 20000,
    ALLIANCE_RES_5 = 21000,
    ALLIANCE_RES_6 = 22000,
    ALLIANCE_RES_7 = 30000,
    ALLIANCE_RES_8 = 31000,
    ALLIANCE_RES_9 = 32000,
    --联盟建筑
    ALLIANCE_FLAG_BUILD = 40000,--联盟旗帜
    ALLIANCE_CENTER_1 = 41000,--联盟中心1
    ALLIANCE_CENTER_2 = 42000,--联盟中心2
    ALLIANCE_CENTER_3 = 43000,--联盟中心3
    ALLIANCE_CENTER_4 = 44000,--联盟中心4

    ALLIANCE_FRONT_BUILD_1 = 45000,--前线阵地1
    ALLIANCE_FRONT_BUILD_2 = 46000,--前线阵地2
    ALLIANCE_FRONT_BUILD_3 = 47000,--前线阵地3
    
    ALLIANCE_ACT_RES_1 = 50000,--活动矿小型
    ALLIANCE_ACT_RES_2 = 51000,--活动矿中型
    ALLIANCE_ACT_RES_3 = 52000,--活动矿大型

    EDEN_ALLIANCE_ACT_RES_1 = 60000,--s5活动矿小型
    EDEN_ALLIANCE_ACT_RES_2 = 61000,--s5活动矿中型
    EDEN_ALLIANCE_ACT_RES_3 = 62000,--s5活动矿大型

    EDEN_CROSS_ALLIANCE_ACT_RES_1 = 70000,--s5伊甸园活动矿小型
    EDEN_CROSS_ALLIANCE_ACT_RES_2 = 71000,--s5伊甸园活动矿中型
    EDEN_CROSS_ALLIANCE_ACT_RES_3 = 72000,--s5伊甸园活动矿大型

    FUN_BUILD_Reserve = 739000,--预备兵营
    FUN_BUILD_BAUBLE = 740000, -- 装饰公司

    FUN_BUILD_SECOND_BARRACKS = 770000, --第二兵营
    FUN_BUILD_MEDICAL_CENTER = 771000, --医疗中心
    FUN_BUILD_COMMAND_CENTER = 772000, --指挥中心
    FUN_BUILD_TRAINING_CAMP = 773000, --集训营
    FUN_BUILD_LOGISTICS_CENTER = 774000, --物流中心
    FUN_BUILD_CONSTRUCTION_CENTER = 775000, --建设中心
    FUN_BUILD_SPEED = 776000, --氮气加速器
    FUN_BUILD_SCIENCE_1 = 777000, -- 研究所
    FUN_BUILD_DEFENCE_CENTER_NEW = 779000, -- 防御中心
    
    --最新建筑
    DS_RESTAURANT = 780000, -- 餐厅
    DS_COAL_YARD = 781000, -- 发电厂
    DS_FACTORY = 782000, -- 伐木场
    DS_HOSPITAL_1 = 783000, -- 医院1
    DS_FARM = 784000, -- 猎人小屋
    FUN_BUILD_OPINION_BOX = 785000, -- 民意信箱
    DS_HOSPITAL_3 = 786000, -- 医院3
    DS_BAR = 787000, -- 酒吧
    DS_HOUSE_1 = 801000, -- 民居1
    DS_HOUSE_2 = 802000, -- 民居2
    DS_HOUSE_3 = 803000, -- 民居3
    DS_HOUSE_4 = 804000, -- 民居4
    DS_HOUSE_5 = 805000, -- 民居5
    DS_HOUSE_6 = 806000, -- 民居6
    DS_HOUSE_7 = 807000, -- 民居7
    DS_HOUSE_8 = 808000, -- 民居8
    DS_EXPLORER_CAMP = 731000, -- 探险者营地

    DS_EQUIP_FACTORY = 811000, -- 装备工厂
    DS_EQUIP_SMELTING_FACTORY = 812000, -- 熔炼厂
    DS_EQUIP_MATERIAL_FACTORY = 813000, -- 材料加工厂
    DS_EQUIP_SMELTING_FACTORY_2 = 814000, -- 熔炼厂
}

FurnitureType =
{
    Bed = 500000, -- 床
    Desk = 501000, -- 书桌
    Pool = 502000, -- 民居洗手台
    Bookshelf = 503000, -- 书架
    Heater = 504000, -- 暖炉
    Shower = 505000, -- 淋浴间
    Guestbook = 506000, -- 留言板
    Floodlight = 507000, -- 照明灯
    CookingBench = 508000, -- 灶台
    DiningTable = 509000, -- 餐桌
    FoodCupboard = 510000, -- 食品柜
    FoodWindow = 511000, -- 取餐台
    Fireplace = 512000, -- 壁炉
    TrashCan = 513000, -- 垃圾桶
    WaterTank = 514000, -- 储水罐
    Cask = 515000, -- 酒桶
    KitchenPool = 516000, -- 厨房洗手台
    HuntingTool = 517000, -- 打猎工具
    Trophy = 518000, -- 战利品
    Brazier = 519000, -- 火盆
    Trap = 520000, -- 陷阱
    ToolShelf = 521000, -- 工具架
    CleaningTank = 522000, -- 清洗槽
    SawingTable = 523000, -- 锯木台
    DesignTable = 524000, -- 设计桌
    SteamEngine = 525000, -- 蒸汽机
    BlowingMachine = 526000, -- 鼓风机
    ChangingRoom = 527000, -- 更衣室
    ForgingTable = 528000, -- 锻造台
    Furnace = 529000, -- 熔炉
    Mold = 530000, -- 模具
    HydraulicPress = 531000, -- 液压器
    IronChangingRoom = 532000, -- 铁更衣室
    IronGuestbook = 533000, -- 铁留言板
    ElectricGenerator = 534000, -- 发电机
    Battery = 535000, -- 蓄电池
    InsulatingGloves = 536000, -- 绝缘手套
    PowerTransmitter = 537000, -- 输电设备
    VoltageTransformer = 538000, -- 变压器
    SafetyValve = 539000, -- 安全阀
    
    -- 医院
    ConsultationDesk = 540000, -- 问诊台
    Sickbed = 541000, -- 病床
    MedicineCabinet = 542000, -- 药品柜
    HospitalPool = 543000, -- 医院洗手池
    Cart = 544000, -- 推车
    WashroomHospital = 545000, -- 洗漱间(医院)
    CabinetHospital = 546000, -- 消毒柜(医院)
    
    -- 酒吧
    BarCounter = 547000, -- 吧台
    BarSeat = 548000, -- 卡座
    WineCabinet = 549000, -- 酒柜
    NeonLamp = 550000, -- 霓虹灯
    ConcertStand = 551000, -- 舞池
    CabinetBar = 552000, -- 消毒柜(酒吧)
    Toilet = 553000, -- 马桶
}

DragonBuildingTypes = 
{
    DragonEmptyBuild = 10000,
    DragonWarBuild = 10010,
    DragonCenterBuild = 10020,
    DragonAllianceFlagSelf = 10030,
    DragonAllianceFlagOther = 10040,
    DragonHospitalBuild = 10050,
}

DragonPlayerState = --0未指派 1主力 2替补
{
    None = 0,
    Main = 1,
    Sub =2,
}

ServerType = 
{
    NORMAL = 0,
    DRAGON_BATTLE_FIGHT_SERVER = 8,
    EDEN_SERVER = 9,
    CROSS_THRONE = 10,
}

EdenCamp = 
{
    DEFAULT = 0,
    NORTH = 1, --北方阵营
    SOUTH = 2, --南方阵营
}

EdenAreaType = 
{
    DEFAULT = 0,
    FIGHT_AREA = 1, -- 1 战斗区域
    NORTH_BORN_AREA = 2, --2 北方出生区域
    SOUTH_BORN_AREA = 3, --3 南方出生区域
}

PassType = 
{
    DEFAULT = 0,
    NONE_CITY_PASS = 1,
    ALLIANCE_CITY_PASS = 2,
}

WorldCityType = 
{
    AllianceCity = 0,--联盟城
    AlliancePass = 1,--关卡
    StrongHold = 2,--据点
}


--赛季建筑 在世界上的建筑 
WorldSeasonBuild = 
{
    --世界上的建筑
    [BuildingTypes.SEASON_DESERT_RESISTANCE_1] = 1,
    [BuildingTypes.SEASON_DESERT_MAX_DESERT_1] = 2,
    [BuildingTypes.SEASON_DESERT_MAX_FORMATION_SIZE_1] = 3,
    [BuildingTypes.SEASON_DESERT_ARMY_ATTACK_1] = 4,
    [BuildingTypes.SEASON_DESERT_ARMY_DEFEND_1] = 5,
    [BuildingTypes.SEASON_DESERT_RESISTANCE_2] = 6,
    [BuildingTypes.SEASON_DESERT_RESISTANCE_3] = 7,
    [BuildingTypes.SEASON_DESERT_RESISTANCE_4] = 8,
    [BuildingTypes.SEASON_DESERT_MAX_DESERT_2] = 9,
    [BuildingTypes.SEASON_DESERT_MAX_FORMATION_SIZE_2] = 10,
    [BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2] = 11,
    [BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2] = 12,
    [BuildingTypes.SEASON_DESERT_BUILD_DRONE_1] = 13,
    [BuildingTypes.SEASON_DESERT_BUILD_DRONE_2] = 14,
    [BuildingTypes.SEASON_DESERT_NEW_MAX_DESERT_1] = 15,
    [BuildingTypes.SEASON_DESERT_NEW_MAX_DESERT_2] = 16,
}

HeroCamp =
{
    All = -1,
    NEW_HUMAN = 0,
    MAFIA = 1,
    UNION=2,
    ZELOT = 3,
}

--兵营类建筑
BarracksBuild =
{
    BuildingTypes.FUN_BUILD_CAR_BARRACK,
    BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,
    BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK,
    BuildingTypes.FUN_BUILD_TRAP_BARRACK,
}
--采集类建筑
CollectBuild =
{
    BuildingTypes.FUN_BUILD_CONDOMINIUM,
    BuildingTypes.FUN_BUILD_STONE,
    BuildingTypes.FUN_BUILD_OIL,
    BuildingTypes.FUN_BUILD_WATER,
    BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION,
    BuildingTypes.FUN_BUILD_ELECTRICITY,
    BuildingTypes.FUN_BUILD_GROCERY_STORE,
    --BuildingTypes.FUN_BUILD_GREEN_CRYSTAL,
}

AllianceTeamType =
{
    ATTACK_BOSS=0,--集结怪物
    ATTACK_BUILDING=1,--集结建筑
    ATTACK_CITY = 2,--集结大本
    ATTACK_AL_CITY = 3,--集结联盟城
    ATTACK_AL_BUILD = 4,--集结联盟建筑
    ATTACK_THRONE = 6,--集结王座
    ASSISTANCE_THRONE = 7,--援助王座
    ATTACK_DRAGON_BUILDING= 8,--集结战场建筑
}

MarchStatus=
{
    DEFAULT =-1,--初始状态
    STATION=0, --驻军
    MOVING=1, --行军中
    ATTACKING=2, --攻击中
    COLLECTING=3, --采集中
    BACK_HOME=4, --到家
    CHASING=5, --追逐
    WAIT_RALLY=6, --等待集结中
    IN_TEAM=7, --在集结中
    ASSISTANCE =8, --在援助单位中
    IN_WORM_HOLE = 9, -- 在虫洞中
    SAMPLING = 10,--采样中
    PICKING = 11,--捡垃圾
    GOLLOES_EXPLORING = 12,--咕噜探索中
    BUILD_WORM_HOLE = 13,-- 建设虫洞中
    DESTROY_WAIT = 14, --等待拆除耐久
    BUILD_ALLIANCE_BUILDING = 15, --建造联盟建筑中
    TRANSPORT_BACK_HOME = 16, --传送回家
    CROSS_SERVER = 17, --跨服虫洞中
    WAIT_THRONE =18, --18 王座排队中
    COLLECTING_ASSISTANCE = 19, --活动联盟矿专用，采集并在援助中
}

GotoType =
{
    Build = 1,
    Science = 2,
    Package = 3,
    Activity = 4,
}

MarchTargetType =
{
    STATE =0,--驻守
    ATTACK_MONSTER=1,--攻击
    COLLECT=2,--采集
    BACK_HOME=3,--回城
    ATTACK_BUILDING=4,--攻击玩家建筑
    ATTACK_ARMY=5, --攻击玩家编队
    JOIN_RALLY=6, --参加集结
    RALLY_FOR_BOSS=7, --集结打怪
    RALLY_FOR_BUILDING=8, --集结打建筑
    RANDOM_MOVE = 9, --野怪状态，随便走走
    ATTACK_ARMY_COLLECT=10 ,--打采集编队，打完了采集
    ATTACK_CITY = 11, --攻击大本
    RALLY_FOR_CITY=12, --集结大本
    ASSISTANCE_BUILD=13, --援助建筑
    ASSISTANCE_CITY=14, --援助大本
    GO_WORM_HOLE = 16, -- 进虫洞
    SCOUT_CITY = 17,-- 17 侦察城市
    SCOUT_BUILDING = 18,-- 18 侦察建筑
    SCOUT_ARMY_COLLECT = 19,-- 19 侦查部队
    EXPLORE = 20,   --20小队探测
    SAMPLE = 21,--21采样
    SCOUT_TROOP = 22,--侦查部队
    PICK_GARBAGE = 23,--捡垃圾
    RESOURCE_HELP = 24,--资源援助
    ATTACK_ALLIANCE_CITY =25,-- 25 攻击联盟城市
    ASSISTANCE_ALLIANCE_CITY =26,-- 26 防御联盟城市
    RALLY_FOR_ALLIANCE_CITY =27,-- 27 集结攻打联盟城市
    SCOUT_ALLIANCE_CITY = 28,--侦察建筑
    GOLLOES_EXPLORE = 29,--咕噜探索
    GOLLOES_TRADE = 30,--咕噜商队
    BUILD_WORM_HOLE = 31,-- 建设虫洞
    TRANSPORT_ACT_BOSS = 32, --传送活动boss
    DIRECT_ATTACK_ACT_BOSS = 33, --直接攻击活动boss
    BUILD_ALLIANCE_BUILDING = 34, --建造联盟建筑
    COLLECT_ALLIANCE_BUILD_RESOURCE = 35, --采集联盟建筑资源
    CROSS_SERVER_WORM = 36, --跨服
    ATTACK_DESERT = 37, -- 攻击地块
    ASSISTANCE_DESERT = 38, --驻守地块
    SCOUT_DESERT = 39, --侦察地块
    TRAIN_DESERT = 40, --地块训练  Target
    DIRECT_ATTACK_CITY = 41, --奇袭
    ATTACK_ALLIANCE_BUILDING = 42, --攻击联盟建筑
    RALLY_ALLIANCE_BUILDING = 43, --集结联盟建筑
    SCOUT_ALLIANCE_BUILDING = 44, --侦察联盟建筑
    ASSISTANCE_ALLIANCE_BUILDING = 45, --援助联盟建筑
    RALLY_THRONE = 50,-- 集结王座
    RALLY_ASSISTANCE_THRONE = 51, --集结援助王座
    SCOUT_THRONE = 52, --侦察王座
    ATTACK_ALLIANCE_BOSS = 53, -- 攻击联盟boss
    ATTACK_ACT_ALLIANCE_MINE = 54, --攻击活动联盟矿
    RALLY_FOR_ACT_ALLIANCE_MINE = 55, --集结攻击联盟活动矿
    ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE = 56, --采集联盟活动矿
    SCOUT_ACT_ALLIANCE_MINE = 57, --侦察联盟活动矿
    ATTACK_DRAGON_BUILDING = 58,-- 攻击战场建筑
    RALLY_DRAGON_BUILDING = 59, -- 集结战场建筑
    SCOUT_DRAGON_BUILDING = 60, -- 侦察战场建筑
    ASSISTANCE_DRAGON_BUILDING = 61, -- 援助战场建筑
    TAKE_SECRET_KEY = 62, --获取战场密钥
    PICK_SECRET_KEY = 63, --拾取战场密钥
    TRANSPORT_SECRET_KEY = 64, --运送战场密钥
    TRIGGER_DRAGON_BUILDING = 65, --攻击/援助战场建筑
    TRIGGER_CROSS_THRONE_BUILDING = 66, --攻击/援助王座建筑
    RALLY_CROSS_THRONE_BUILDING = 67, --集结王座建筑
    SCOUT_CROSS_THRONE_BUILDING = 68, --侦察王座建筑
    ASSISTANCE_CROSS_THRONE_BUILDING = 69, --援助王座建筑
    --客户端用
    PUZZLE_BOSS = 101,--puzzle monster
    DISPATCH_TASK = 105, --派遣任务
    NORMAL_FAKE_MARCH = 106, -- 通用假行军队列，只有移动逻辑
}

HospitalPanelStateType =
{
    NoSoldier = 0,
    Treating = 1,--正在治疗
    Select = 2,--选择
}

--作用号值
EffectDefine =
{
    TREAT_NUM_MAX_EFFECT_ADD = 73, --医院伤兵上限数量
    TREAT_NUM_MAX_EFFECT = 57, --医院伤兵上限增加百分比
    CURE_RESOURCE_REDUCE = 108,--治疗消耗减少百分比
    CHAT_ROOM_MAX = 310, -- 可创建聊天室数量
    TRADE_TEX_DECREASE_938 = 938, --交易税率
    BUILD_QUEUE_NUM = 30050, --建造队列数量

    --燃油每小时产量
    OIL_SPEED = 30000,
    --水晶每小时产量
    METAL_SPEED = 30001,
    --风力发电站每小时产量
    NUCLEAR_SPEED = 30002,
    --火力发电站每小时产量
    FOOD_SPEED = 30003,
    --水每小时产量
    WATER_SPEED = 30004,
    --氧气每秒产量
    HERO_ONE_KEY_OPEN = 30005,--一键进阶开关
    --OXYGEN_SPEED = 30005,
    --太阳能电每小时产量
    ELECTRICITY_SPEED = 30006,
    --油电每秒产量
    OIL_ELECTRICITY_SPEED = 30008,
    --核电每秒产量
    NUCLEAR_ELECTRICITY_SPEED = 30010,
    --人口上限增加
    PEOPLE_MAX = 30007,
    --医疗上限增加
    HOS_MAX = 30009,
    --贸易度上限增加(值)
    TRAD_MAX = 30011,
    --研发值增加(值)
    RD_ADD = 30013,
    --研发值增加(值)
    OPERA_ADD = 30014,
    --维护度上限(值)
    MAINTAIN_MAX_ADD = 30016,
    --建造值增加(值)
    BUILD_ADD = 30017,
    --环境值指数、每分钟对环境值进行加减值
    ENVIR_SPEED = 30020,
    --人口每分钟增长值(数值)
    PEOPLE_SPEED = 30021,
    --人口增长加成(千分比)1000=1
    PEOPLE_SPEED_PER = 30022,
    --资金每秒增长(值)
    MONEY_SPEED = 30023,
    --资金增长加成(千分比)
    MONEY_SPEED_PER = 30024,
    --燃油上限
    OIL_MAX_LIMIT = 30030,
    --金属上限
    METAL_MAX_LIMIT = 30031,
    --核燃料上限
    NUCLEAR_MAX_LIMIT = 30032,
    --粮食上限
    FOOD_MAX_LIMIT = 30033,
    --水上限
    WATER_MAX_LIMIT = 30034,
    --氧气上限
    OXYGEN_MAX_LIMIT = 30035,
    --电上限
    ELECTRICITY_MAX_LIMIT = 30036,
    --电消耗
    ELECTRICITY_DEC = 30037,
    --核燃料消耗
    NUCLEAR_DEC = 30038,
    --燃油消耗
    OIL_DEC = 30039,
    --PVE入场券上限
    PVE_POINT_MAX_LIMIT = 30019,
    --受伤人口恢复速度（分钟）
    PEOPLE_REC_SPEED = 30040,
    --冷库存储上线
    FREEZER_STORAGE_MAX_LIMIT = 30044,
    --综合仓库存储上线
    WAREHOUSE_STORAGE_MAX_LIMIT = 30045,
    --[[    --冷库保护上线
        FREEZER_PROTECT_MAX_LIMIT = 30046,]]

    --综合仓库保护上线
    WAREHOUSE_PROTECT_MAX_LIMIT = 30047,



    WATER_CAPACITY_ADD = 30064, --30064	抽水站储量提升	储量=建筑para2*(1+【30064】/100)
    METAL_CAPACITY_ADD = 30065, --30065	水晶采集场储量提升	储量=建筑para2*(1+【30065】/100)
    GAS_CAPACITY_ADD = 30066, --30066	瓦斯收集器储量提升	储量=建筑para2*(1+【30066】/100)
    BUILD_SPEED_ADD = 30070, --30070	建造建筑速度	建筑建造时间=building.xml time/(1+【30070】/ 100)
    SCIENCE_SPEED_ADD = 30071, -- 30071	科研速度	科研时间=science.xml time/(1+【30071】/ 100)
    WIND_ELECTRICITY_SPEED_ADD = 30072, -- 风力发电站速度提升	速度=建筑para1*(1+【30072】/100)
    WIND_ELECTRICITY_CAPACITY_ADD = 30073, -- 风力发电站储量提升	储量=建筑para2*(1+【30073】/100)
    HOTEL_MONEY_SPEED_ADD = 30074, -- 公寓钞票产出速度提升	速度=建筑para1*(1+【30074】/100)
    HOUSE_MONEY_SPEED_ADD = 30075, -- 别墅钞票产出速度提升	速度=建筑para1*(1+【30075】/100)
    METAL_SPEED_ADD = 30076, --水晶采集场速度提升	  速度=建筑para1*(1+【30076】/100)
    SOLAR_ELECTRICITY_SPEED_ADD = 30077, --太阳能发电站速度提升	速度=建筑para1*(1+【30077】/100)
    RESOURCE_PROTECT_CAPACITY_ADD = 30078, --资源仓库保护上限提升	保护上限=基础值*(1+【30078】/100)
    FREEZER_STORAGE_ADD = 30080, --冷库上限提升	容量=【30044】+【30080】
    MONEY_SPEED_ADD = 30081, --钞票产出速度提升
    SOLAR_ELECTRICITY_CAPACITY_ADD = 30082, --太阳能发电站储量提升	储量=建筑para2*(1+【30082】/100)
    FIRE_ELECTRICITY_CAPACITY_ADD = 30083, --火力发电站储量提升	储量=建筑para2*(1+【30083】/100)
    FIRE_ELECTRICITY_SPEED_ADD = 30084, --火力发电站速度提升	速度=建筑para1*(1+【30084】/100)
    HOTEL_MONEY_CAPACITY_ADD = 30085, --公寓钞票储量提升	储量=建筑para2*(1+【30085】/100)
    HOUSE_MONEY_CAPACITY_ADD = 30086, --别墅钞票储量提升	储量=建筑para2*(1+【30086】/100)
    MONEY_CAPACITY_ADD = 30087, --钞票储量提升		公寓储量=建筑para2*(1+【30086】/100+【30084】/100)  别墅储量=建筑para2*(1+【30086】/100+【30085】/100)

    UNLOCK_WATER_GET = 30088, --解锁部队采集水
    UNLOCK_GAS_GET = 30089, --解锁部队采集瓦斯
    UNLOCK_METAL_GET = 30090, --解锁部队采集水晶
    GAS_BUILD_COLLECT_SPEED_ADD = 30091, --瓦斯收集器速度提升		百分比	速度=建筑para1*(1+【30091	】/100)
    WATER_BUILD_COLLECT_SPEED_ADD = 30092, --抽水站速度提升		百分比	速度=建筑para1*(1+【30092	】/100)

    STORAGE_SHOP_REFRESH_TIME_REDUCE = 30026,--交易行刷新减少时间

    ADD_FIELD_NUM = 30094, -- 702000可建造农田数量加成
    ADD_CAN_BUILD_NUM = 30095, -- 可建造建筑范围
    ADD_WATER_BUILD_NUM = 30096, -- 432000可建造净水罐数量加成
    ADD_HOTEL_NUM = 30097, -- 409000可建造公寓数量加成
    ADD_METAL_COLLECT_NUM = 30098, -- 412000可建造水晶采集场数量加成

    BUILD_TIME_REDUCE = 30099,--建筑时间减少
    RESEARCH_TIME_REDUCE = 30100,--科技时间减少
    SEASON_BUILD_TIME_REDUCE = 30270,--赛季建筑时间减少

    AlContributeMonthCard = 30266,--功勋积分双倍

    ADD_SCIENCE_QUEUE = 30104,	--可建造科研部件数量增加
    EFFECT_ONE_MORE_TIMES = 30132,--再来一份
    GLOBAL_MONEY_EXTRA_PERCENT = 30109, -- 全局金币收益加成 百分比
    GLOBAL_HERO_EXP_EXTRA_PERCENT = 30111, -- 全局英雄经验获得加成 百分比
    TROOP_LIMIT_EXTRA = 30018, -- 带兵上限
    STORAGE_MAX_EXTRA = 30112, -- 仓库上限
    CAREER_ATTACK_CITY_COLLECT_ADD_PERCENT = 30137,--30137 攻城时编队负重 百分比 攻城时生效
    CAREER_COLLECT_ADD_PERCENT = 30138, --30138 采集时负重 百分比 采集时生效
    CAREER_JOIN_TEAM_SPEED_ADD_PERCENT = 30139, --30139 参与组队时的行军速度 百分比 前往参加组队时的行军速度
    STORAGE_SHOP_ADD_MAX_NUM = 30191,--交易行最大上架数量增加值
    HAS_UNCLAIMED_FREE_GOLLOES = 30192,--当日有免费咕噜没领取
    MINE_CAVE_CAN_PREVIEW = 30203,--矿洞是否可刷出（是否需要预览）

    REPAIR_SPEED_ADD_TANK = 30395, --30395	坦克治疗速度提升	治疗士兵时间=arms.xml time/（1+【30395】/100）
    REPAIR_SPEED_ADD_ROBOT = 30396, --30396	轻武器治疗速度提升	治疗士兵时间=arms.xml time/（1+【30396】/100）
    REPAIR_SPEED_ADD_PLANE = 30397, --30397	飞机治疗速度提升	治疗士兵时间=arms.xml time/（1+【30397】/100）
    
    TANK_TRAIN_SPEED_ADD = 31000, --31000	坦克训练速度提升	训练士兵时间=arms.xml time/（1+【31000】/100）
    ROBOT_TRAIN_SPEED_ADD = 31001, --31001	轻武器训练速度提升	训练士兵时间=arms.xml time/（1+【31001】/100）
    PLANE_TRAIN_SPEED_ADD = 31002, --31002	飞机训练速度提升	训练士兵时间=arms.xml time/（1+【31002】/100）
    TRAP_TRAIN_SPEED_ADD = 30322, --30322	陷阱训练速度提升	训练士兵时间=arms.xml time/（1+【30322】/100）
    TANK_TRAIN_NUM_ADD = 31003, --31003	坦克训练量提升	训练量=arms.xml max_train +【31003】
    ROBOT_TRAIN_NUM_ADD = 31004, --31004	轻武器训练量提升	训练量=arms.xml max_train +【31004】
    PLANE_TRAIN_NUM_ADD = 31005, --31005	飞机训练量提升	训练量=arms.xml max_train +【31005】
    TRAP_TRAIN_NUM_ADD = 30321, --30321	陷阱练量提升	训练量=arms.xml max_train +【30321】
    DETECT_ARMY_SPEED = 31006,--侦察行军速度 行军速度=基础值*(1+【31006】/100)
    REPAIR_SPEED_ADD = 31007, --维修速度提升		维修速度=arms.xml treat_time/（1+【31007】/100）
    ARMY_TRAIN_SPEED_ADD = 31008, --部队训练速度提升	训练士兵时间=arms.xml time/（1+【31008】/100）
    ARMY_TRAIN_MAX_ADD = 31009, --部队训练上限提升	坦克训练量=arms.xml max_train +【31003】 +【31009】 轻武器训练量=arms.xml max_train +【31004】 +【31009】 飞机训练量=arms.xml max_train +【31005】 +【31009】）

    INFANTRY_UPGRADE_SWITCH = 31010, --步兵可晋升
    TANK_UPGRADE_SWITCH = 31011,--坦克可晋升
    PLANE_UPGRADE_SWITCH = 31012,--飞机可晋升
    TRAP_UPGRADE_SWITCH = 30327,-- 陷阱可晋升

    ATTACK_ADD_BASE_ALL_ARMY = 35000, --全体兵种基础攻击加成
    ATTACK_ADD_BASE_ARM_1 = 35001, --兵种1基础攻击加成
    ATTACK_ADD_BASE_ARM_2 = 35002, --兵种2基础攻击加成
    ATTACK_ADD_BASE_ARM_3 = 35003, --兵种3基础攻击加成
    HEALTH_ADD_BASE_ALL_ARMY = 35012,--全局生命加成
    ATTACK_ADD_BUILD_ALL_ARMY = 35048, --驻守建筑前台兵种总攻击加成
    ATTACK_ADD_BUILD_ARM_1 = 35049, --驻守建筑前台兵种1攻击加成
    ATTACK_ADD_BUILD_ARM_2 = 35050, --驻守建筑前台兵种2攻击加成
    ATTACK_ADD_BUILD_ARM_3 = 35051, --驻守建筑前台兵种3攻击加成

    DEFENCE_ADD_BASE_ALL_ARMY = 35004, --全体兵种基础防守加成
    DEFENCE_ADD_BASE_ARM_1 = 35005, --兵种1基础防守加成
    DEFENCE_ADD_BASE_ARM_2 = 35006, --兵种2基础防守加成
    DEFENCE_ADD_BASE_ARM_3 = 35007, --兵种3基础防守加成
    DEFENCE_ADD_BUILD_ALL_ARMY = 35052, --驻守建筑前台兵种总防守加成
    DEFENCE_ADD_BUILD_ARM_1 = 35053, --驻守建筑前台兵种1防守加成
    DEFENCE_ADD_BUILD_ARM_2 = 35054, --驻守建筑前台兵种2防守加成
    DEFENCE_ADD_BUILD_ARM_3 = 35055, --驻守建筑前台兵种3防守加成
    ATTACK_MONSTER = 35056, --打怪攻击力
    DEFENCE_MONSTER = 35057, --打怪防御力
    GAS_COLLECT_SPEED = 30058, --瓦斯采集速度
    WATER_COLLECT_SPEED = 30059, --水源采集速度
    CRYSTAL_COLLECT_SPEED = 30060, --水晶采集速度
    OIL_COLLECT_SPEED_PERCENT = 30061, --瓦斯采集速度增加百分比
    WATER_COLLECT_SPEED_PERCENT = 30062, --水源采集速度增加百分比
    CRYSTAL_COLLECT_SPEED_PERCENT = 30063, --水晶采集速度增加百分比
    ELECTRICITY_COLLECT_SPEED_PERCENT = 30238,--电采集速度增加百分比
    ELECTRICITY_COLLECT_SPEED_PERCENT_2 = 30239,--电采集速度增加百分比2
    MONEY_COLLECT_SPEED_PERCENT = 35109,--金币采集速度增加百分比
    PURPLE_CRYSTAL_COLLECT_SPEED_PERCENT = 30245,--紫水晶采集速度增加百分比
    WAR_ATTACK = 35064, --战斗伤害加成
    WAR_DEFENCE = 35065, --战斗防御加成
    APS_BATTLE_HERO_TOTAL_ATK_PERCENT_INCR = 35067,--英雄攻击力加成
    APS_BATTLE_HERO_TOTAL_DEF_PERCENT_INCR = 35068,--英雄防御力加成
    APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT = 35073,--全体兵种攻击
    APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT = 35074,--全体兵种防御
    STAMINA_COST_DEC = 35111,--行军体力消耗减少
    STAMINA_MAX_LIMIT = 35117,--车库燃料上限
    TOWER_RANGE_ADD = 35122,--炮台攻击范围
    TOWER_ATTACK_ADD = 35123,--炮台攻击力提升
    APS_FORMATION_SIZE = 40001,
    APS_FORMATION_SIZE_ENHANCE = 40002,

    APS_DEFENCE_FORMATION_SIZE = 40003, --守城编队数量
    APS_DEFENCE_FORMATION_FIRST_HERO_COUNT = 40004, --守城第一编队可上阵英雄数量
    APS_DEFENCE_FORMATION_SECOND_HERO_COUNT = 40005, --守城第二编队可上阵英雄数量
    APS_DEFENCE_FORMATION_THIRD_HERO_COUNT = 40006, --守城第三编队可上阵英雄数量
    APS_DEFENCE_DOME_NUM = 40007, --防护罩耐久
    APS_DEFENCE_DOME_SPEED = 40008, --防护罩耐久回复速度
    ARMY_CARRY_WEIGHT_ADD_PERCENT = 40010, -- 负重上线百分比
    SIEGE_DAMAGE_ADD_PERCENT = 40011, -- 单兵攻城值增加百分比
    APS_ALLIANCE_TEAM_MAX_ARMY = 40014, -- 最大集结上限


    APS_FORMATION_FIRST_HERO_COUNT = 40016, --第一编队可上阵英雄数量
    APS_FORMATION_SECOND_HERO_COUNT = 40017, --第二编队可上阵英雄数量
    APS_FORMATION_THIRD_HERO_COUNT = 40018, --第三编队可上阵英雄数量
    APS_FORMATION_FORTH_HERO_COUNT = 40019, --第四编队可上阵英雄数量
    ARMY_SPEED_ADD = 40020, --部队行军速度提升	行军速度=基础值*(1+【40020】/100)
    APS_WORM_SPEED_ADD_PERCENT = 40021, --行军虫洞速度增加百分比
    APS_SCOUT_FORMATION_SIZE = 40022, --侦查队列最大数量
    APS_NORMAL_FORMATION_1_ATK =40036, -- 普通编队1攻击力提升
    APS_NORMAL_FORMATION_2_ATK = 40037, -- 普通编队2攻击力提升
    APS_NORMAL_FORMATION_3_ATK = 40038, -- 普通编队3攻击力提升
    APS_NORMAL_FORMATION_4_ATK = 40039, -- 普通编队4攻击力提升
    APS_NORMAL_FORMATION_1_DEF = 40040, -- 普通编队1防御力提升
    APS_NORMAL_FORMATION_2_DEF = 40041, -- 普通编队2防御力提升
    APS_NORMAL_FORMATION_3_DEF = 40042, -- 普通编队3防御力提升
    APS_NORMAL_FORMATION_4_DEF = 40043, -- 普通编队4防御力提升
    APS_NORMAL_FORMATION_1_FORMATION_COUNT = 40044, -- 普通编队1编队出征数量增加
    APS_NORMAL_FORMATION_2_FORMATION_COUNT = 40045, -- 普通编队2编队出征数量增加
    APS_NORMAL_FORMATION_3_FORMATION_COUNT = 40046, -- 普通编队3编队出征数量增加
    APS_NORMAL_FORMATION_4_FORMATION_COUNT = 40047, -- 普通编队4编队出征数量增加
    STAMINA_RECOVER_SPEED_ADD = 40050,--行军体力回复速度提升
    APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_PERCENT = 40083,--普通编队1负重增加百分比
    APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_PERCENT = 40084, --普通编队2负重增加百分比
    APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_PERCENT = 40085, --普通编队3负重增加百分比
    APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_PERCENT = 40086, --普通编队4负重增加百分比
    APS_NORMAL_FORMATION_1_MARCH_SPEED_ADD_PERCENT = 40087,--普通编队1行军速度增加百分比
    APS_NORMAL_FORMATION_2_MARCH_SPEED_ADD_PERCENT = 40088, --普通编队2行军速度增加百分比
    APS_NORMAL_FORMATION_3_MARCH_SPEED_ADD_PERCENT = 40089, --普通编队3行军速度增加百分比
    APS_NORMAL_FORMATION_4_MARCH_SPEED_ADD_PERCENT = 40090, --普通编队4行军速度增加百分比
    APS_NORMAL_FORMATION_1_CARRY_WEIGHT_ADD_NUM = 40091,--普通编队1负重增加值
    APS_NORMAL_FORMATION_2_CARRY_WEIGHT_ADD_NUM = 40092, --普通编队2负重增加值
    APS_NORMAL_FORMATION_3_CARRY_WEIGHT_ADD_NUM = 40093, --普通编队3负重增加值
    APS_NORMAL_FORMATION_4_CARRY_WEIGHT_ADD_PNUM = 40094, --普通编队4负重增加值
    APS_SEASON_DESERT_NUM_ADD = 41000, -- 赛季地块额外上限
    APS_SEASON_DESERT_RESISTANCE = 41001, --赛季地块抗性
    APS_ALLIANCE_ARMS_USE_NUM = 220,--联盟军备活动
    APS_ARMY_NUM_MAX = 40049, -- 士兵数量上限
    APS_TRAP_NUM_MAX = 30323, -- 陷阱数量上限
    APS_ALCOMPETE_ACT_UNLOCK_BOX_2 = 30121,
    APS_ALCOMPETE_ACT_UNLOCK_BOX_3 = 30123,

    GREEN_CTRSTAL_SPEED_ADD = 30118,--绿水晶生产速度增加  百分比	速度=建筑para1*(1+【30118】/100)

    TRADER_EXTRA_FARM_BOX = 30151,--商人技能-农业补给箱

    ALLIANCE_STORAGE_MAX = 30143,--联盟仓库上限
    SAPPHIRE_PRODUCT_SPEED_PERCENT = 30144,--蓝宝石增长百分比
    SAPPHIRE_PRODUCT_SPEED_NUM = 30145,--蓝宝石增长数值
    
    EFFECT_ROCKET_NUM = 30027,--火箭次数加成

    ALLIANCE_SCIENCE_RESEARCH_CONSUME = 30159,
    ALLIANCE_CITY_MAX_NUM = 30160,
    ASSIST_SPEED_ADD = 30158,
    PLUNDER_REST_COUNT = 30152, -- 剩余掠夺次数
    EFFECT_PRODUCT_QUEUE_ADD_711000 = 30113,
    EFFECT_PRODUCT_QUEUE_ADD_707000 = 30114,
    EFFECT_PRODUCT_QUEUE_ADD_717000 = 30115,
    EFFECT_PRODUCT_QUEUE_ADD_718000 = 30116,
    EFFECT_PRODUCT_QUEUE_ADD_708000 = 30117,
    EFFECT_PRODUCT_QUEUE_ADD_709000 = 30119,
    ADD_BUILD_ARROW_TOWER_NUM = 31013,	--炮台数量增加
    DEC_UPGRADE_BUILD_ARROW_TOWER_ITEM = 30162,	--当此作用号生效，升级炮台时，消耗的道具读取418000的para2，格式与item字段一致
    EFFECT_GULU_STORE_OPEN = 30041,--咕噜商店开放

    GARAGE_REFIT_FREE_EXTRA = 30176, -- 改装车免费次数增加
    GARAGE_REFIT_X2_PROB_EXTRA = 30177, -- 改造2倍概率增加
    GARAGE_REFIT_X3_PROB_EXTRA = 30178, -- 改造3倍概率增加
    GARAGE_REFIT_X5_PROB_EXTRA = 30179, -- 改造5倍概率增加
    GARAGE_REFIT_X10_PROB_EXTRA = 30181, -- 改造10倍概率增加

    ATTACK_DESERT_STAMINA_DECREASE = 30281, -- 玩家打地时体力消耗减少

    -- 每日免费
    DAILY_FREE_INFANTRY = 30167, -- 每日免费步兵
    DAILY_FREE_TANK = 30168, -- 每日免费坦克
    DAILY_FREE_PLANE = 30169, -- 每日免费飞机
    DAILY_FREE_TRAP = -1, -- 每日免费陷阱
    DAILY_FREE_MAIN_PAPER = 30170, -- 每日免费总部图纸
    DAILY_FREE_TRADE_PAPER = 30172, -- 每日免费贸易中心图纸
    DAILY_FREE_BARRACKS_PAPER = 30173, -- 每日免费军事中心图纸
    DAILY_FREE_GARAGE_REFIT_ITEM = 30174, -- 每日免费车库改装齿轮
    DAILY_FREE_TREAT = 30175, -- 每日免费恢复伤兵
    SEASON_BUILDING_MAXLV_1 = 30243,--赛季建筑等级上限
    SEASON_BUILDING_MAXLV_2 = 30244,--赛季建筑等级上限

    -- 2023/1/13 New
    DAILY_FREE_ENERGY = 30301, -- 每日免费体力
    DAILY_FREE_MERCENARY_INFANTRY = 30402, -- 每日免费雇佣兵步兵
    DAILY_FREE_MERCENARY_TANK = 30403, -- 每日免费雇佣兵坦克
    DAILY_FREE_MERCENARY_PLANE = 30404, -- 每日免费雇佣兵飞机
    DAILY_FREE_MERCENARY_TRAP = -1, -- 每日免费雇佣兵陷阱
    DECREASE_ENERGY_COST = 35113, -- 体力消耗减少
    DECREASE_GEAR_COST = 30304, -- 车库改装齿轮消耗减少
    SEASON_WEEK_CARD_FLINT_ADD_PERCENT = 30305,--地块黑曜石产量增加
    SEASON_WEEK_CARD_DESERT_SWEEP_FIELD = 30308,--地块可以进行连续扫荡 开关 1开0关
    DECREASE_TRAIN_COIN_COST = 30401, -- 训练消耗金币减少
    PVE_EXP_LEVEL_MORE_HERO = 30302, -- 经验关额外上阵英雄
    PVE_EXP_LEVEL_MORE_ENTER = 30303, -- 经验关额外进入次数

    -- 2023/3/15 New
    WOOD_PRODUCT_ADD = 30226, -- 伐木场木头产量增加
    STONE_PRODUCT_ADD = 30228, -- 采石场石头产量增加
    RALLY_FOR_BOSS_ADD = 30254,--集结bossx倍消耗
    UPGRADE_BUILD_EXP_ADD = 30257, -- 升建筑获得专精经验增加
    ATTACK_DESERT_EXP_ADD = 30258, -- 打地获得专精经验增加
    WOOD_BUILD_COUNT_ADD = 30279, -- 伐木场数量增加
    STONE_BUILD_COUNT_ADD = 30280, -- 采石场数量增加

    ALLOW_FORCE_END_PVE = 30180,--天赋允许强制结束pve
    ALLOW_DRAG_MARCH = 30186,--天赋允许拖拽行军
    ALLOW_ATTACK_SAME_MONSTER = 30193, --天赋允许同时打同一个野怪
    AUTO_RALLY_REWARD_NUM_ADD = 30195, -- 自动集结攻击沙虫额外奖励次数
    REFRESH_MINE_CAVE_REFRESH_TIME_ADD = 30198,--矿洞活动界面额外攻击次数
    UNLOCK_PUZZLE_BOSS_2 = 30199,--解锁拼图活动id=2的boss  1开0关
    UNLOCK_PUZZLE_BOSS_3 = 30200,--解锁拼图活动id=3的boss  1开0关
    TALENT_REFRESH_TIME = 30209,-- 重新随机可选天赋的次数
    UNLOCK_ARM_ACT_BUILD = 30210,--解锁个人军备替换城市建筑 1开0关
    UNLOCK_ARM_ACT_SCIENCE = 30211,--解锁个人军备替换科技研发 1开0关
    UNLOCK_ARM_ACT_HERO = 30212,--解锁个人军备替换英雄试炼 1开0关
    INDIVIDUAL_ORDER_REFRESH_TIME = 30214, -- 商业大亨刷新次数
    DETECT_EVENT_FUNCTION_OPEN = 30215,--雷达事件功能解锁
    PVE_STAMINA_MAX = 30216,--关卡体力上限 数值    体力上限=原上限+作用号
    PVE_ATTACK_WOOD_OUT_NUM = 30217,--砍树获得木头        数值    砍一个树获得木头=原产出+作用号
    PVE_ATTACK_STONE_OUT_NUM = 30218,--采矿获得石头        数值    砍一个石头获得石头=原产出+作用号    
    PVE_START_ATTACK_SKILL = 30221,--开启旋风斩	开关	1开0关
    GAME_EFFECT_30224 = 30224, --连续打怪体力消耗减少	百分比	连续打怪时体力消耗=原消耗*（1-作用号/100）刘文
    GAME_EFFECT_30241 = 30241,-- 势力值金币奖励百分比增加
    GAME_EFFECT_30242 = 30242,--势力值资源道具箱奖励百分比增加
    APS_MONEY_WEIGHT_PERCENT = 35112,--金币资源重量减重百分比
    APS_HERO_CAMP_COUNTER_INCR_PERCENT = 35115,--克制百分比加成
    APS_HERO_CAMP_COUNTER_BY_INTENSIFY = 35272,--克制百分比加成（阵营加成）
    ADD_FORMATION_ATTACK_BY_CAMP_35320 = 35320,--全阵营加成/部队攻击
    
    ADD_FORMATION_ATTACK_BY_CAMP_35160 = 35160,--同时上阵2个黑手党英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35161 = 35161,--同时上阵3个黑手党英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35162 = 35162,--同时上阵4个黑手党英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35163 = 35163,--同时上阵5个黑手党英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35164 = 35164,--同时上阵2个联邦卫队英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35165 = 35165,--同时上阵3个联邦卫队英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35166 = 35166,--同时上阵4个联邦卫队英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35167 = 35167,--同时上阵5个联邦卫队英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35168 = 35168,--同时上阵2个狂热者英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35169 = 35169,--同时上阵3个狂热者英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35170 = 35170,--同时上阵4个狂热者英雄，部队攻击增加
    ADD_FORMATION_ATTACK_BY_CAMP_35171 = 35171,--同时上阵5个狂热者英雄，部队攻击增加
    
    ADD_FORMATION_DAMAGE_BY_CAMP_35200 = 35200,--同时上阵2个联邦卫队英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35201 = 35201,--同时上阵3个联邦卫队英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35202 = 35202,--同时上阵4个联邦卫队英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35203 = 35203,--同时上阵5个联邦卫队英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35204 = 35204,--同时上阵2个狂热者英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35205 = 35205,--同时上阵3个狂热者英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35206 = 35206,--同时上阵4个狂热者英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35207 = 35207,--同时上阵5个狂热者英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35208 = 35208,--同时上阵2个黑手党英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35209 = 35209,--同时上阵3个黑手党英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35210 = 35210,--同时上阵4个黑手党英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35211 = 35211,--同时上阵5个黑手党英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35212 = 35212,--同时上阵2个新人类英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35213 = 35213,--同时上阵3个新人类英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35214 = 35214,--同时上阵4个新人类英雄，伤害增加
    ADD_FORMATION_DAMAGE_BY_CAMP_35215 = 35215,--同时上阵5个新人类英雄，伤害增加

    ADD_UNION_HERO_ATK = 35216,--联邦英雄攻击力增加
    ADD_UNION_HERO_DEF = 35217,--联邦英雄防御力增加
    ADD_UNION_HERO_TRP = 35218,--联邦英雄带兵量增加
    ADD_ZEALOT_HERO_ATK = 35219,--狂热者英雄攻击力增加
    ADD_ZEALOT_HERO_DEF = 35220,--狂热者英雄防御力增加
    ADD_ZEALOT_HERO_TRP = 35221,--狂热者英雄带兵量增加
    ADD_MAFIA_HERO_ATK = 35222,--黑手党英雄攻击力增加
    ADD_MAFIA_HERO_DEF = 35223,--黑手党英雄防御力增加
    ADD_MAFIA_HERO_TRP = 35224,--黑手党英雄带兵量增加
    ADD_NEW_HUMAN_HERO_ATK = 35225,--新人类英雄攻击力增加
    ADD_NEW_HUMAN_HERO_DEF = 35226,--新人类英雄防御力增加
    ADD_NEW_HUMAN_HERO_TRP = 35227,--新人类英雄带兵量增加

    APS_HERO_MAFIA_ATK_ADD_PERCENT = 40100, --黑手党英雄攻击力增加
    APS_HERO_MAFIA_DEF_ADD_PERCENT = 40101, --黑手党英雄防御力增加
    APS_HERO_UNION_ATK_ADD_PERCENT = 40102, --联邦英雄攻击力增加
    APS_HERO_UNION_DEF_ADD_PERCENT = 40103, --联邦英雄防御力增加
    APS_HERO_ZELOT_ATK_ADD_PERCENT = 40104, --狂热者英雄攻击力增加
    APS_HERO_ZELOT_DEF_ADD_PERCENT = 40105, --狂热者英雄防御力增加
    APS_HERO_NEW_HUMAN_ATK_ADD_PERCENT = 40106, --新人类英雄攻击力增加
    APS_HERO_NEW_HUMAN_DEF_ADD_PERCENT = 40107, --新人类英雄防御力增加

    ADD_CAMP_RESTRAINT_35228 = 35228,--联邦卫队 对  黑手党 阵营额外造成 伤害
    ADD_CAMP_RESTRAINT_35229 = 35229,--黑手党 对  狂热者  阵营额外造成 伤害
    ADD_CAMP_RESTRAINT_35230 = 35230,--狂热者   对  机器人 阵营额外造成 伤害
    ADD_CAMP_RESTRAINT_35231 = 35231,--机器人 对 联邦卫队  阵营额外造成 伤害

    CAMP_BONUS_ADD_35240 = 35240,--每上阵1名黑手党英雄，部队生命增加
    CAMP_BONUS_ADD_35241 = 35241,--每上阵1名狂热者英雄，部队生命增加
    CAMP_BONUS_ADD_35242 = 35242,--每上阵1名联邦英雄，部队生命增加
    CAMP_BONUS_ADD_35243 = 35243,--每上阵1名新人类英雄，部队生命增加
    APS_HERO_ADD_TROOP_ATK_35248 = 35248,--每上阵1名黑手党英雄，部队攻击增加
    APS_HERO_ADD_TROOP_ATK_35249 = 35249,--每上阵1名狂热者英雄，部队攻击增加
    APS_HERO_ADD_TROOP_ATK_35250 = 35250,--每上阵1名联邦英雄，部队攻击增加
    APS_HERO_ADD_TROOP_DEF_35252 = 35252,--每上阵1名黑手党英雄，部队防御增加
    APS_HERO_ADD_TROOP_DEF_35253 = 35253,--每上阵1名狂热者英雄，部队防御增加
    APS_HERO_ADD_TROOP_DEF_35254 = 35254,--每上阵1名联邦英雄，部队防御增加
    
    EXTRA_WOOD = 30219,--额外木头
    EXTRA_STONE = 30220,--额外石头

    MONSTER_EXTRA_REWARD = 30204,
    BOSS_EXTRA_REWARD = 30205,
    UPGRADE_ADD_RES_CONDOMINIUM = 30182,--公寓升级之后会增加资源
    UPGRADE_ADD_RES_WIND = 30184,--电力升级之后会增加资源

    FLINT_PROTECT_BASE = 30230,--火晶石保护基础值
    FLINT_PROTECT_PERCENT = 30231, --火晶石保护百分比
    FLINT_GATHER_ADD_PERCENT = 30232, --火晶石收取额外加成百分比
    FLINT_MAX_LIMIT = 30234,--火晶石数量上限
    FLINT_MAX_LIMIT_ADD_PERCENT = 30235, --火晶石数量上限增加百分比
    OIL_MAX_LIMIT_ADD_PERCENT = 30236, --燃油上限增加百分比
    PVE_AUTO_PLAY = 30233,

    SK_SURPRISE_ATTACK = 30237, -- 技能：奇袭
    APS_ELECTRICITY_WEIGHT_PERCENT = 30240,--电资源重量减重百分比

    SEASON_FORCE_REWARD_MONEY = 30241, --势力值金币奖励增加百分比
    SEASON_FORCE_REWARD_BOX = 30242, --势力值资源道具箱奖励增加百分比

    HERO_CAMP_ADD_ARMY_UNION_2 = 35256, -- 同时上阵2个联邦卫队英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_UNION_3 = 35257, -- 同时上阵3个联邦卫队英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_UNION_4 = 35258, -- 同时上阵4个联邦卫队英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_UNION_5 = 35259, -- 同时上阵5个联邦卫队英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_ZEALOT_2 = 35260, -- 同时上阵2个狂热者英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_ZEALOT_3 = 35261, -- 同时上阵3个狂热者英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_ZEALOT_4 = 35262, -- 同时上阵4个狂热者英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_ZEALOT_5 = 35263, -- 同时上阵5个狂热者英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_MAFIA_2 = 35264, -- 同时上阵2个黑手党英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_MAFIA_3 = 35265, -- 同时上阵3个黑手党英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_MAFIA_4 = 35266, -- 同时上阵4个黑手党英雄，带兵量增加
    HERO_CAMP_ADD_ARMY_MAFIA_5 = 35267, -- 同时上阵5个黑手党英雄，带兵量增加

    SEASON_BUILDING_FLINT_DEC = 30259, -- 赛季建筑火晶石消耗降低
    SEASON_BUILDING_OBSIDIAN_DEC = 30260, -- 赛季建筑黑曜石消耗降低
    SEASON_BUILDING_BUILD_SPEED_INC = 30261, -- 赛季建筑速度增加
    SEASON_BUILDING_HP_INC = 30262, -- 赛季建筑耐久上限增加
    HEAL_MONEY_DEC = 30263, -- 医院消耗金币减少
    GAME_EFFECT_30317 = 30317,--巨龙治疗时间减少
    GAME_EFFECT_30318 = 30318,--巨龙治疗消耗减少
    
    TO_DESERT_ATK_INC = 30268, -- 对地块守军的攻击提升
    TO_DESERT_DEF_INC = 30269, -- 对地块守军的防御提升
    GAIN_HEAL_ITEM_WHEN_SEASON_BUILDING_LV_UP = 30281, -- 升级赛季建筑，获得伤兵加速道具
    ADD_SEASON_DESERT_ARMY_ATTACK_2 = 30288, --751000 建造上限
    ADD_SEASON_DESERT_ARMY_DEFEND_2 = 30289, --752000 建造上限
    ADD_SEASON_DESERT_BUILD_DRONE_1 = 30290, --753000 建造上限
    ADD_SEASON_DESERT_BUILD_DRONE_2 = 30291, --754000 建造上限
    MAX_LV_SEASON_DESERT_MAX_FORMATION_SIZE_1 = 30285, --743000 等级上限
    PROTECT_PLUNDER = 30294, -- 全资源不被掠夺
    THRONE_EFFECT_30252 = 30252, --资源产量增速
    THRONE_EFFECT_35121 = 35121, --资源产量减速
    THRONE_EFFECT_35127 = 35127, --采集速度增加
    THRONE_EFFECT_35301 = 35301, --建筑速度降低
    THRONE_EFFECT_35311 = 35311, --科研速度降低
    THRONE_EFFECT_30309 = 30309, --仓库保护降低

    CAMP_BONUS_ADD = 35322,--全阵营加成效果/部队攻击
    CAMP_BONUS_ADD_35306 = 35306,--黑手党阵营加成效果增加/部队攻击
    CAMP_BONUS_ADD_35307 = 35307,--联盟卫队阵营加成效果增加/部队攻击
    CAMP_BONUS_ADD_35308 = 35308,--狂热者阵营加成效果增加/部队攻击
    CAMP_BONUS_ADD_35309 = 35309,--新人类阵营加成效果增加/部队攻击

    CAMP_RESTRAINT_ADD = 35325,--全阵营加成效果/部队攻击
    CAMP_RESTRAINT_ADD_35288 = 35288,--黑手党阵营加成效果增加/部队攻击
    CAMP_RESTRAINT_ADD_35289 = 35289,--联盟卫队阵营加成效果增加/部队攻击
    CAMP_RESTRAINT_ADD_35290 = 35290,--狂热者阵营加成效果增加/部队攻击
    CAMP_RESTRAINT_ADD_BASE = 35284,--阵营克制/部队防御增加

    HOS_MAX_ADD = 30298,  --每当城内维修站达到上限时，维修厂容量增加
    
    UNLOCK_MORE_EXPLOIT_REWARDS = 30299,    --功勋解锁更多奖励
    Effect_Reserve_Max = 30313,--预备兵上限
    FREEZER_STORAGE_PERCENT = 30364, --仓库容量百分比
    EASY_GOLLOES_SEND = 30365, -- 一键派遣咕噜
    STAMINA_COST_ADD = 30368,--增加体力消耗
    GAME_EFFECT_30273 = 30273,--体力相关
    GAME_EFFECT_30274 = 30274,--体力相关
    GAME_EFFECT_30275 = 30275,--体力相关
    
    ROCKET_BATCH = 30369,--火箭一键提交
    
    NITROGEN_MAX = 30325,--氮气上限
    NITROGEN_SPEED = 30326,--氮气每秒产出
    BUILDING_HP_EFFECT = 30314,-- 建筑耐久值（装备）
    BUILDING_HP_REC_SPEED_EFFECT = 30315,-- 建筑耐久恢复速度（装备）

    HERO_PLUG_UNLOCK_UNION = 30386,-- 解锁对应阵营英雄的插件（联邦）
    HERO_PLUG_UNLOCK_MAFIA = 30375,-- 解锁对应阵营英雄的插件（黑手党）
    HERO_PLUG_UNLOCK_ZEALOT = 30376,-- 解锁对应阵营英雄的插件（狂热者）
    HERO_PLUG_UNLOCK_NEW_HUMAN = 30377,-- 解锁对应阵营英雄的插件（机械之心）
    HERO_PLUG_LEVEL_MAX_UNION = 30378,-- 插件等级上限（联邦）
    HERO_PLUG_LEVEL_MAX_MAFIA = 30379,-- 插件等级上限（黑手党）
    HERO_PLUG_LEVEL_MAX_ZEALOT = 30380,-- 插件等级上限（狂热者）
    HERO_PLUG_LEVEL_MAX_NEW_HUMAN = 30381,-- 插件等级上限（机械之心）
    HERO_PLUG_LOCK_NUM_UNION = 30382,-- 联邦阵营英雄插件解锁锁定功能 数值	可锁定属性数目=作用号
    HERO_PLUG_LOCK_NUM_MAFIA = 30383,-- 黑手党阵营英雄插件解锁锁定功能		数值	可锁定属性数目=作用号
    HERO_PLUG_LOCK_NUM_ZEALOT = 30384,-- 狂热者阵营英雄插件解锁锁定功能		数值	可锁定属性数目=作用号
    HERO_PLUG_LOCK_NUM_NEW_HUMAN = 30385,-- 机械之心阵营英雄插件解锁锁定功能		数值	可锁定属性数目=作用号
  
    HERO_PLUG_UPGRADE_COST_UNION = 30387,-- 联邦阵营英雄插件升级消耗减少		百分比	对应阵营英雄插件，升级消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_UPGRADE_COST_MAFIA = 30388,-- 黑手党阵营英雄插件升级消耗减少		百分比	对应阵营英雄插件，升级消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_UPGRADE_COST_ZEALOT = 30389,-- 狂热者阵营英雄插件升级消耗减少		百分比	对应阵营英雄插件，升级消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_UPGRADE_COST_NEW_HUMAN = 30390,-- 机械之心阵营英雄插件升级消耗减少		百分比	对应阵营英雄插件，升级消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容

    HERO_PLUG_REFINE_COST_UNION = 30391,-- 联邦阵营英雄插件随机消耗减少		百分比	对应阵营英雄插件，随机消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_REFINE_COST_MAFIA = 30392,-- 黑手党阵营英雄插件随机消耗减少		百分比	对应阵营英雄插件，随机消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_REFINE_COST_ZEALOT = 30393,-- 狂热者阵营英雄插件随机消耗减少		百分比	对应阵营英雄插件，随机消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    HERO_PLUG_REFINE_COST_NEW_HUMAN = 30394,-- 机械之心阵营英雄插件随机消耗减少		百分比	对应阵营英雄插件，随机消耗=原消耗*（1-作用号/100)，不影响锁定属性后额外消耗的内容
    
    TRAIN_FINISH_INFANTRY = 35329,-- 步兵30328：每次训练时，有【35329】的概率立即完成（不消耗资源和加速）
    TRAIN_FINISH_TANK = 35330,-- 坦克30329：每次训练时，有【35330】的概率立即完成（不消耗资源和加速）
    TRAIN_FINISH_PLANE = 35331,-- 飞机30330：每次训练时，有【35331】的概率立即完成（不消耗资源和加速）
    TRAIN_FINISH_INFANTRY = 30328,-- 步兵30328：每次训练时，有【35329】的概率立即完成（不消耗资源和加速）
    TRAIN_FINISH_TANK = 30329,-- 坦克30329：每次训练时，有【35330】的概率立即完成（不消耗资源和加速）
    TRAIN_FINISH_PLANE = 30330,-- 飞机30330：每次训练时，有【35331】的概率立即完成（不消耗资源和加速）
    --专精
    MASTERY_EFFECT_30413 = 30413,--普通地雷开关
    MASTERY_EFFECT_30414 = 30414,--高级地雷开关
    MASTERY_EFFECT_30415 = 30415,--增加地雷上限
    MASTERY_EFFECT_30416 = 30416,--狂战士buff开关

    FURNITURE_FOOD_ADD = 30500, -- 每个产食物的家具每次生产增加
    FURNITURE_PLANK_ADD = 30501, -- 每个产木头的家具每次生产增加
    FURNITURE_STEEL_ADD = 30502, -- 每个产钢铁的家具每次生产增加
    FURNITURE_ELECTRICITY_ADD = 30503, -- 每个产电的家具每次生产增加
    FURNITURE_MONEY_ADD = 30504, -- 每个产金币的家具每次生产增加
    MEAL_HUNGER_ADD = 30505, -- 每个食物饱腹度增加
    FURNITURE_SLEEP_ADD = 30506, -- 每个恢复睡眠值的家具每次恢复增加
    FURNITURE_HEALTH_ADD = 30507, -- 每个恢复健康值的家具每次恢复增加
    FURNITURE_COMFORT_ADD = 30508, -- 每个恢复舒适值的家具每次恢复增加
    VITA_TEMPERATURE_ADD = 30509, -- 温度值增加
    RESIDENT_CURE_ADD = 30510, -- 治愈率增加
    FURNITURE_MOOD_ADD = 30511, -- 每个恢复心情值的家具每次恢复增加
    RESIDENT_CAPACITY = 30512, -- 人口上限
    RESIDENT_RIOT = 30513, -- 暴动 1开启 0关闭
    FURNITURE_FOOD_ADD_PERCENT = 30519, --每个产食物的家具每次生产增加（百分比）
    FURNITURE_PLANK_ADD_PERCENT = 30520, --每个产木头的家具每次生产增加（百分比）
    FURNITURE_STEEL_ADD_PERCENT = 30521, --每个产铁的家具每次生产增加（百分比）
    FURNITURE_ELECTRICITY_ADD_PERCENT = 30522, --每个产电的家具每次生产增加（百分比）
    MEAL_WORK_FASTER = 30526, -- 做饭时间缩短
    ELECTRICITY_WORK_FASTER = 30527, -- 电采集时间缩短
    STEEL_WORK_FASTER = 30528, -- 铁采集时间缩短
    PLANK_WORK_FASTER = 30535, -- 木头采集时间缩短
    PLANK_WORK_SLOWER = 30543, -- 木头采集时间延长
    STEEL_WORK_SLOWER = 30544, -- 铁采集时间延长
    
    -- 小人特性相关
    FEATURE_SCARE_MOVE_SPD_INC = 30540, -- 遇到丧尸后的逃跑速度提高
    FEATURE_DAY_MOVE_SPD_INC = 30545, -- 白天移动速度提高
    FEATURE_DAY_MOVE_SPD_DEC = 30546, -- 白天移动速度降低
    FEATURE_NIGHT_MOVE_SPD_INC = 30547, -- 夜晚移动速度提高
    FEATURE_NIGHT_MOVE_SPD_DEC = 30548, -- 夜晚移动速度降低
    FEATURE_DAY_WORK_SPD_INC = 30549, -- 白天工作速度提高
    FEATURE_DAY_WORK_SPD_DEC = 30550, -- 白天工作速度降低
    FEATURE_NIGHT_WORK_SPD_INC = 30551, -- 夜晚工作速度提高
    FEATURE_NIGHT_WORK_SPD_DEC = 30552, -- 夜晚工作速度降低
    MEAL_CAPACITY = 30553, -- 工作餐上限
    RESIDENT_DODGE_RATE = 30559, -- 小人闪避率
    LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN = 30319,--一键派遣上阵
}

HeroCampAddArmyEffects =
{
    [HeroCamp.MAFIA] =
    {
        [2] = EffectDefine.HERO_CAMP_ADD_ARMY_MAFIA_2,
        [3] = EffectDefine.HERO_CAMP_ADD_ARMY_MAFIA_3,
        [4] = EffectDefine.HERO_CAMP_ADD_ARMY_MAFIA_4,
        [5] = EffectDefine.HERO_CAMP_ADD_ARMY_MAFIA_5,
    },
    [HeroCamp.ZELOT] =
    {
        [2] = EffectDefine.HERO_CAMP_ADD_ARMY_ZEALOT_2,
        [3] = EffectDefine.HERO_CAMP_ADD_ARMY_ZEALOT_3,
        [4] = EffectDefine.HERO_CAMP_ADD_ARMY_ZEALOT_4,
        [5] = EffectDefine.HERO_CAMP_ADD_ARMY_ZEALOT_5,
    },
    [HeroCamp.UNION] =
    {
        [2] = EffectDefine.HERO_CAMP_ADD_ARMY_UNION_2,
        [3] = EffectDefine.HERO_CAMP_ADD_ARMY_UNION_3,
        [4] = EffectDefine.HERO_CAMP_ADD_ARMY_UNION_4,
        [5] = EffectDefine.HERO_CAMP_ADD_ARMY_UNION_5,
    },
}

CheckHeroRestraintEffectList =
{
    EffectDefine.CAMP_RESTRAINT_ADD,
    EffectDefine.CAMP_RESTRAINT_ADD_35288,
    EffectDefine.CAMP_RESTRAINT_ADD_35289,
    EffectDefine.CAMP_RESTRAINT_ADD_35290,
    EffectDefine.CAMP_RESTRAINT_ADD_BASE,
}

CheckHeroCampAddEffectList =
{
    EffectDefine.CAMP_BONUS_ADD_35306,
    EffectDefine.CAMP_BONUS_ADD_35307,
    EffectDefine.CAMP_BONUS_ADD_35308,
    EffectDefine.CAMP_BONUS_ADD_35309,
    EffectDefine.CAMP_BONUS_ADD,
}
PlayBackEndJumpType =
{
    Mail=1,
    Chat =2,
    Arena=3,
    MineCave = 4,
}
ExchangeDefine =
{
    MONTH_CARD_ID = "9007",--月卡ID
    SUB_MONTH_CARD_ID = "9012",--订阅ID
}

ItemColor =
{
    WHITE = 0,
    GREEN = 1,
    BLUE = 2 ,
    PURPLE = 3,
    ORANGE = 4,
    GOLDEN = 5,
}

HeroColor =
{
    ORANGE = 1,
    PURPLE = 2,
    BLUE = 3,
    GREEN = 4,
}

--detect_event和物品颜色的对应关系不一样
DetectEventColor =
{
    DETECT_EVENT_WHITE = 1,
    DETECT_EVENT_GREEN = 2,
    DETECT_EVENT_BLUE = 3 ,
    DETECT_EVENT_PURPLE = 4,
    DETECT_EVENT_ORANGE = 5,
    DETECT_EVENT_GOLDEN = 6,
    DETECT_EVENT_RED = 7,
}

CheckNameType ={
    None =0, --通过
    MinNameChar =1,--少于最小字符数量
    MaxNameChar = 2,--大于最大字符数量
    IllegalChar = 3,--非法字符
    SensitiveWords =4,---敏感词汇
    Exist =5,--已存在
    Unchanged = 6,--无变化
}

RankType = {
    None = 0,
    AllianceKill = 1, --联盟杀敌排行榜
    AlliancePower = 2, --联盟战力排行榜
    CommanderKill = 3, --杀敌排行榜
    CommanderPower = 4, --战斗力排行榜
    CommanderBase = 5, --指挥官基地排行榜
    SeasonForce = 13,--赛季势力排行榜
    SeasonDesert = 14,--赛季地块排行榜
    AllianceSeasonForce = 15,--赛季联盟积分排行榜
    MONSTER_SIEGE_USER = 17,--黑骑士个人杀怪排行榜
    MONSTER_SIEGE_ALLIANCE = 18,--黑骑士联盟杀怪排行榜
    OtherServerAlliancePower = 19,--其他服务器联盟战力排行榜
    ActLeadingQuestAllianceRank = 26,-- 任务活动联盟占领城市排行榜   
    HeroPluginRank = 31,-- 插件排行榜   
}

--联盟贡献排行榜
AllianceDonateRankType = {
    None = 0,
    RankDay = 1, --每日排行榜
    RankWeek = 2, --每周排行榜
    RankHistory = 3, --总排行榜
}

--建筑时间进度条类型
BuildTimeType =
{
    BuildTime_Upgrading = 0,--建筑升级
    BuildTime_FootSoldier = 1,--机器人兵
    BuildTime_CarSoldier = 2,--坦克兵
    BuildTime_BowSoldier = 3,--飞机兵
    BuildTime_Injuries = 4,--伤兵恢复
    BuildTime_Science = 5,--科研中心研究
    BuildTime_Fixing = 9,--废墟重建
    BuildTime_Trap = 10,--陷阱
}

--建筑气泡类型(小的在前)
BuildBubbleType =
{
    BuildFixFinishEnd = 0,--建筑废墟修复完成
    DetectEventFinished = 2,--探测事件完成（雷达黄底气泡）
    HeroStationAvailable = 4,--英雄驻扎可用
    UpgradeAllianceHelp = 5,--升级联盟帮助
    ScienceAllianceHelp = 6,--科技研究联盟帮助
    HospitalAllianceHelp = 7,--治疗伤兵联盟帮助
    FootSoldierFree = 8,--机器人可以造兵
    FootSoldierEnd = 9,--机器人收兵
    CarSoldierFree = 10,--坦克可以造兵
    CarSoldierEnd = 11,--坦克收兵
    BowSoldierFree = 12,--飞机可以造兵
    BowSoldierEnd = 13,--飞机收兵
    HospitalFree = 14,--医院可以救治
    HospitalEnd = 15,--医院收兵
    ScienceFree = 16,--可以研究科技
    ScienceEnd = 17,--收取科技
    UpgradeFinish = 20,--建筑盒子
    GetItem = 22,--收取道具
    GetResource = 23,--收取资源
    NoGetResource = 24,--资源点枯竭
    NeedTransport = 25,--火力发电站中资源为空
    AllianceHelp = 26,--联盟帮助
    DetectEvent = 28,--探测事件（雷达白底气泡）
    HeroAdvance = 29,--英雄进阶
    HeroRecruit = 30,--英雄招募
    BuildZeroUp = 31,--主城建筑0级需要升级的材料
    AllianceBattle = 32,--联盟战争
    AllianceTask = 33,--联盟任务
    AllianceGift = 34,--联盟礼物
    GolloesGift = 35,--咕噜营地奖励
    GolloesMonthCard = 36,--购买咕噜月卡
    NoAlliance = 38,--无联盟
    HeroStationSkill = 39,--英雄驻扎技能
    Assistance = 40,--援助
    FixBuildingAllianceHelp = 43,--废墟恢复联盟帮助
    HeroFreeScienceAddTime = 45,--英雄科技加速时间
    HeroFreeBuildAddTime = 46,--英雄建筑加速时间
    --WorldTrendStateRefresh = 47,--天下大势刷新，可领奖
    AllianceCareer = 48,--联盟职业有空位可以任命
    AllianceApply = 49,--加入联盟申请
    GarageRefitFree = 50,--车库改装免费次数
    InactivePlayer = 51,--有非活跃玩家
    WormHoleSub = 52,--有虫洞出口  有部队在虫洞中
    WormHoleSubZero = 53,--虫洞出口还未建造 0级
    BuildingLv0Ruins = 55,--0级废墟建筑
    BuildCanUpgrade = 56,
    AllianceCityDeclareWar = 57,--联盟宣战
    BuildUpgradeReward = 58,--建筑升级领奖
    CanUseHeroEffectSkill = 59,
    HeroRecruitOther = 60,--除了普通招募的英雄招募
    CommonShopFree = 61,--通用道具商店免费红点
    Talent = 62,--天赋
    HeroBountyFree = 63,--英雄悬赏开始
    HeroBountyFinish = 64,--英雄悬赏结束
    HeroOfficialEmpty = 65,--英雄议会有空位
    FootSoldierUnlock = 66,--新步兵解锁
    CarSoldierUnlock = 67,--新坦克解锁
    BowSoldierUnlock = 68,--新飞机解锁
    CrossWormHoleSub = 71,--跨服虫洞有行军
    EnergyTreasure = 73,--体力宝物
    PubFreeEnergy = 74,--酒馆有免费体力
    HeroIntensifyAvailable = 75,--英雄议会 阵营强化
    EquipmentCanUpgrade = 76,--装备的部件可以升级时候
    EquipmentSlotCanPutOn = 77,--有可穿的部件
    HeroMedalShop = 78,--英雄勋章商店
    Reserve = 79,--预备兵
    TrapFree = 80,--陷阱可以造兵
    TrapEnd = 81,--陷阱收兵
    TrapUnlock = 82,--新陷阱解锁
    ArenaFreeTime = 83,--竞技场有免费次数显示
    HospitalTreating = 84,--医院救治中
    OpinionBox = 85,--民意信箱
    HangupReward = 86,--挂机奖励
    HeroEquip = 87,--英雄装备
}

BuildBubbleTypeOrder =
{
    [BuildBubbleType.BuildFixFinishEnd] = 0,--建筑废墟修复完成
    [BuildBubbleType.BuildingLv0Ruins] = 1.1,--需要升级0级废墟建筑至1级
    [BuildBubbleType.UpgradeFinish] = 1.2,
    [BuildBubbleType.CanUseHeroEffectSkill] = 1.5,
    [BuildBubbleType.CrossWormHoleSub] = 1.6,
    [BuildBubbleType.DetectEventFinished] = 2,--探测事件完成（雷达黄底气泡）
    [BuildBubbleType.HeroStationAvailable] = 4,--英雄驻扎可用
    [BuildBubbleType.HeroFreeScienceAddTime] = 4.5,--英雄科技加速时间
    [BuildBubbleType.HeroFreeBuildAddTime] = 4.6,--英雄建筑加速时间
    [BuildBubbleType.UpgradeAllianceHelp] = 5,--升级联盟帮助
    [BuildBubbleType.ScienceAllianceHelp] = 6,--科技研究联盟帮助
    [BuildBubbleType.HospitalAllianceHelp] = 7,--治疗伤兵联盟帮助
    [BuildBubbleType.FootSoldierFree] = 8,--机器人可以造兵
    [BuildBubbleType.FootSoldierEnd] = 9,--机器人收兵
    [BuildBubbleType.FootSoldierUnlock] = 9.1,--
    [BuildBubbleType.CarSoldierFree] = 10,--坦克可以造兵
    [BuildBubbleType.CarSoldierEnd] = 11,--坦克收兵
    [BuildBubbleType.CarSoldierUnlock] = 11.1,--
    [BuildBubbleType.BowSoldierFree] = 12,--飞机可以造兵
    [BuildBubbleType.BowSoldierEnd] = 13,--飞机收兵
    [BuildBubbleType.BowSoldierUnlock] = 13.1,--
    [BuildBubbleType.TrapFree] = 13.5,--陷阱可以造兵
    [BuildBubbleType.TrapEnd] = 13.6,--陷阱收兵
    [BuildBubbleType.TrapUnlock] = 13.7,--
    [BuildBubbleType.HospitalFree] = 14,--医院可以救治
    [BuildBubbleType.HospitalEnd] = 15,--医院收兵
    [BuildBubbleType.ScienceFree] = 16,--可以研究科技
    [BuildBubbleType.ScienceEnd] = 17,--收取科技
    [BuildBubbleType.Talent] = 19.9,--天赋
    --[BuildBubbleType.ExtendDome] = 20,--苍穹扩建
    [BuildBubbleType.GetItem] = 22,--收取道具
    [BuildBubbleType.GolloesGift] = 22.6,--咕噜营地奖励
    [BuildBubbleType.CommonShopFree] = 22.8,--联盟宣战
    [BuildBubbleType.GolloesMonthCard] = 22.9,--购买咕噜月卡
    [BuildBubbleType.GetResource] = 23,--收取资源
    [BuildBubbleType.NoGetResource] = 24,--资源点枯竭
    [BuildBubbleType.NeedTransport] = 25,--火力发电站中资源为空
    [BuildBubbleType.AllianceHelp] = 26,--联盟帮助
    [BuildBubbleType.DetectEvent] = 28,--探测事件（雷达白底气泡）
    [BuildBubbleType.PubFreeEnergy] = 28.5,--酒馆有免费道具
    [BuildBubbleType.HeroRecruitOther] = 29,--英雄招募
    [BuildBubbleType.HeroAdvance] = 29.2,--英雄进阶
    [BuildBubbleType.HeroMedalShop] = 28.75,--英雄勋章商店
    [BuildBubbleType.HeroRecruit] = 29.1,--英雄招募
    [BuildBubbleType.BuildZeroUp] = 31,--主城建筑0级需要升级的材料
    [BuildBubbleType.AllianceBattle] = 32,--联盟战争
    [BuildBubbleType.AllianceGift] = 33,--联盟礼物
    [BuildBubbleType.AllianceApply] = 34,--联盟申请
    [BuildBubbleType.NoAlliance] = 38,--无联盟
    [BuildBubbleType.HeroStationSkill] = 39,--英雄驻扎技能
    [BuildBubbleType.Assistance] = 40,--援助
    [BuildBubbleType.FixBuildingAllianceHelp] = 43,--废墟恢复联盟帮助
    [BuildBubbleType.EnergyTreasure] = 43.3,--体力宝物
    [BuildBubbleType.BuildUpgradeReward] = 43.5,--建筑升级领奖
    [BuildBubbleType.BuildCanUpgrade] = 43.6,--建筑升级气泡
    --[BuildBubbleType.HeroFreeScienceAddTime] = 45,--英雄科技加速时间
    --[BuildBubbleType.HeroFreeBuildAddTime] = 46,--英雄建筑加速时间
    --[BuildBubbleType.WorldTrendStateRefresh] = 47,--天下大势刷新，可领奖
    [BuildBubbleType.AllianceTask] = 48,--联盟任务
    [BuildBubbleType.InactivePlayer] = 48.1,--有非活跃玩家
    [BuildBubbleType.AllianceCareer] = 49,--联盟职业有空位可以任命
    [BuildBubbleType.GarageRefitFree] = 50,--车库改装免费次数
    [BuildBubbleType.WormHoleSub] = 51,--有虫洞出口
    [BuildBubbleType.WormHoleSubZero] = 52,--虫洞出口还未建造 0级
    [BuildBubbleType.AllianceCityDeclareWar] = 56,--联盟宣战
    [BuildBubbleType.HeroBountyFinish] = 58,--英雄悬赏结束
    [BuildBubbleType.HeroBountyFree] = 59,--英雄悬赏开始
    [BuildBubbleType.HeroOfficialEmpty] = 60,--英雄议会有空位
    [BuildBubbleType.HeroIntensifyAvailable] = 60.5,--英雄议会 阵营强化
    [BuildBubbleType.EquipmentCanUpgrade] = 65,--
    [BuildBubbleType.EquipmentSlotCanPutOn] = 66,--
    [BuildBubbleType.Reserve] = 67,--
    [BuildBubbleType.ArenaFreeTime] = 68,--
    [BuildBubbleType.HospitalTreating] = 69,--
    [BuildBubbleType.OpinionBox] = 70,--
    [BuildBubbleType.HangupReward] = 71,--
    [BuildBubbleType.HeroEquip] = 72,
}

--建筑气泡类型
BuildBubbleIconName =
{
    BuildUpgradeFinish = "bubble_icon_hero_finish",
    BuildFixFinishEnd = "bubble_icon_build_repair",
    DomeExtend ="bubble_icon_dome",
    BuildUpgrade ="bubble_bg_build_upgrade",
    ScienceAllianceHelp = "bubble_icon_alliance_help_me",
    HospitalAllianceHelp = "bubble_icon_alliance_help_me",
    UpgradeAllianceHelp = "bubble_icon_alliance_help_me",
    ScienceFree = "bubble_icon_science_free",
    HospitalFree = "bubble_icon_hospital",
    NoGetResource = "bubble_icon_warning",
    AllianceHelpOthers = "bubble_icon_alliance_help_others",
    AllianceTask = "bubble_icon_alliance_task",
    AllianceGift = "bubble_icon_alliance_award",
    CommonShopFree = "bubble_icon_alliance_award",
    BgCircle = "bubble_bg_circle",
    BgUnSelect = "bubble_bg_unselect",
    BgSelect = "bubble_bg_select",
    BgSelect2 = "bubble_bg_select2",
    GetItem = "bubble_icon_alliance_gift",
    HeroAdvance  = "bubble_icon_hero_advance",
    HeroRecruit  = "bubble_icon_hero_recruit",
    DetectEvent = "bubble_icon_detect_event",
    DetectEventComplete = "bubble_icon_detect_complete",
    AllianceBattle = "bubble_icon_alliance_battle",
    GolloesGift = "bubble_icon_golloes_gift",
    NoAlliance = "bubble_icon_no_alliance",
    AllianceApply = "bubble_icon_alliance_apply",
    HeroStationAvailable = "bubble_icon_hero_station_available",
    HeroStationSkill = "bubble_icon_hero_station_skill",
    WorldTrendStateRefresh = "bubble_icon_Mars",
    Mars = "bubble_icon_plane",
    GolloesMc = "bubble_icon_golloes_mc",
    AllianceCareer = "bubble_icon_alliance_career",
    InactivePlayer = "bubble_icon_alliance_inactive",
    GarageRefitFree = "bubble_icon_chilun",
    BuildingLv0RuinsWhite = "bubble_bg_landlock_white",
    BuildingLv0RuinsYellow = "bubble_bg_landlock_yellow",
    AllianceCityDeclareWar = "bubble_icon_declare",
    BuildUpgradeReward = "bubble_icon_alliance_award",
    Talent = "bubble_icon_talent",
    HeroBounty = "bubble_icon_reward",
    HeroOfficialEmpty = "bubble_icon_hero_official_empty",
    HeroIntensifyAvailable = "bubble_icon_hero_intensity",
    EquipmentCanUpgrade = "bubble_icon_tank",--
    EquipmentSlotCanPutOn = "bubble_icon_tank",--
    HeroMedalShop = "bubble_icon_exchange",
    Reserve = "bubble_icon_reservists",
    Default = "bubble_bg",
    DefaultYellow = "bubble_bg_yellow",
    ShopFree = "bubble_icon_decorate_shop",
    HospitalTreating = "bubble_icon_build_repair",
    OpinionBox = "bubble_icon_opinion",
    HangupReward = "bubble_icon_golloes_gift",
    Energy = "bubble_icon_energy_order",
    HeroEquip = "bubble_icon_tank",
}

PickResEffectLevel=
{
    Low=1,
    Middle=2,
    High=3

}

TaskState =
{
    NoComplete = 0, --未完成
    CanReceive = 1, --已经完成但是未领取
    Received = 2,--已经领取
    Lock = 3,--未解锁
}

TaskStateOrder =
{
    [TaskState.CanReceive] = 1,
    [TaskState.NoComplete] = 2,
    [TaskState.Received] = 3,
}

AllianceHelpType =
{
    None =-1,
    Building =0,
    Queue = 1,
    FIX_BUILDING =2,
}

DailyBoxActive =
{
    30,70,120,180,260
}

--任务跳转类型
GoType =
{
    None= 0,--空
    Go = 2,--跳转到指定建筑
    BuildList = 5,--跳转到建筑列表
    Science = 8,--跳转任务科技所在界面
    Hero = 13,--英雄升级 跳转英雄背包主界面
    Searching = 44,--跳转到搜索界面
    CollectResource = 45, --跳转到对应矿根

    --50-59 每日任务
    DailyBuildUp = 51,--每日任务建筑升级
}

--当GoType=2时
TaskGoBuild =
{
    None = 0,--空
    Upgrade = 1,--表示建筑升级
    Train = 2,--表示练兵
    Treat = 3,--表表示治疗伤兵
    Plant = 4,--表示种植
    HeroGet = 13,--表示招募
    HeroUpStar = 14,--表示英雄升阶
    GetResource = 17,--表示收取某种资源(固定)
    GetResourceRandom = 18,--表示收取某种资源(随机)

}

--任务跳转类型
QuestGoType =
{
    None = 0,
    BuildBtn = 1,--跳到建筑并打开建筑按钮
    GetResource = 5,--跳转收取某种资源(固定)
    GetResourceRandom = 6,--跳转收取某种资源(随机)
    BuildList = 7,--跳转去建造列表
    Science = 8,--跳转去科技
    HeroUpgrade = 9,--跳转英雄升级
    Searching = 11,--跳转搜索界面
    CollectResource = 12,--跳转到对应矿根
    DailyBuildUp = 13,--跳转每日任务建筑升级
    AttackMonster = 16,--跳转每日任务集结怪
    AllianceHelp = 17,--跳转联盟帮助
    RadarProbe = 18,--每日任务雷达探测
    ChangePlayerName = 19,--玩家改名
    CollectGarbage = 21,--大本附近垃圾
    GoRobot = 23,--跳转机器人
    GoBarracks = 24,--跳转训练营
    GoBindAccount = 25,--绑定账号
    GoConnectBuild = 26,--连接建筑道路
    MonsterReward = 27,--拾取野怪奖励箱子
    GoHeroStation = 28,--英雄驻守
    GoGiftMall = 29,--礼包商城
    GoBagPackUseItem = 30,--跳转到背包使用道具
    GoSearchEnemy = 31,--寻找附近敌人
    GoGarageUpgrade = 32,--跳转车库升级改装
    GoHeroStationScores = 33,--跳转驻守目标增益
    GoHospital = 34,--跳转医院救治
    GoHeroTrust = 39, --英雄委托
    GoTriggerPve = 41,--pve任务专用 指定trigger
    GoFelledTree = 44,--砍树
    GoPveAutoTo = 45,
    GoActUI = 46,--跳转活动界面
    GoCityCollect = 47,--跳转城内矿
    GoFormation = 48,--指向快捷编队
    GoTaskToBuild = 49,--任务跳转建筑
    GoCheckBuild = 50,--可建造优先建造，不可建造最低等级
    GoHeroBag = 51,--英雄碎片兑换智慧勋章
    GoHeroSkill = 52,--英雄界面升级
    GoBuildOpenUpgrade = 53,--跳转到某个建筑打开升级界面
    GoWorldToSearch = 54,--跳转到世界指引搜索
    HeroStar = 55,--跳转英雄升星
    GoWorldCity = 56,--跳转遗迹城点
    GoFlint = 57,--前往火晶石
    GoWorldBuildList = 58,--跳转赛季建筑
    GoDailyUI = 59,--跳转到每日活动
    GoSeasonDesertMaxLv = 60,--赛季最高等级地块
    GoSelfDesert = 61,--赛季自己最低等级地块
    GoSeasonManager = 62,--前往地块管理
    GoActWindowByType = 63,--根据活动类型跳转
    GOGiftPackageView = 64,--根据礼包id跳转到礼包
    GoGuidEventToWorld = 65,--引导用 事件id跳转到世界海盗船
    GoHeroBagRankUp = 66,--英雄升阶
    GoMastery = 69,--跳转到专精页面
    GoHeroPlugin = 70,--跳转到战力最大英雄插件
    GoStory = 72,--跳转到推图关
    GoAddWork = 74,--镜头移动至建筑，打开工人派遣界面，手指指向加号
    GoUpgradeFurniture = 75,--镜头移动至建筑，打开升级家具界面跳转至该家具，手指指向升级按钮
    GoUpgradeFurnitureBuild = 76,--镜头移动至建筑，打开升级家具界面跳转至建筑内等级最低的家具（升级必须升的家具），手指指向家具按钮
    GoArena = 77,--跳转到竞技场
    GoLand = 78,--跳转到当前进度的地块，手指引地块的交互按钮。
    AllianceScience = 79,--跳转联盟科技
}

--任务描述类型
QuestDescType =
{
    Normal = 1,
    Build = 2,
    Train = 3,
    HeroUpStar = 7,
    Resource = 8,
    Science = 9,
    Monster = 10,
    Robot = 11,
    HeroQuality = 13,
    HeroName = 14,
    HeroSkill = 15,
    Season = 16,
    SeasonHero = 17,
    HeroRank = 18,
}

--当GoType=44时
TaskGoBuild44Type =
{
    Monster =  1,--代表搜怪
    Gas =  2,--代表搜瓦斯
    Metal =  3,--代表搜水晶
    Water =  4,--代表搜水源
}

--当GoType=45时
TaskResourceType =
{
    [1] = ResourceType.Oil,
    [2] = ResourceType.Metal,
    [3] = ResourceType.Water,
    [4] = ResourceType.Electricity
}

--界面中任务类型排序 ，并非表中任务type
TaskType =
{
    Chapter = 1,--章节任务
    Main = 2,--主线任务
    Daily = 3,--日常任务
}

TaskTypeSort =
{
    TaskType.Chapter,
    --TaskType.Main,
    --TaskType.Daily,
}

SettingType =
{
    Notice = 1,--消息通知
    Setting = 2,--通用设置
    --Account = 3,--账号
    Description = 4,--说明
    Language = 5,--语言
    --RedemptionCode = 6, --兑换码
    Ban = 7, --屏蔽用户
    --Flag = 8,--国旗
    --GM = 9,--gm
    --Service = 10,--服务条款
    NewGame = 11,--开始新游戏
    --GM_Talk = 14, --GM聊天
    --Vip = 15
    ChangeId = 16,--切号
    PVE = 17, -- 进入pve
    PVEFreeCamera = 18,  -- PVE相机自由移动
    AllowTracking = 19, -- iOS授权允许跟踪
    PlayerNation = 20,--玩家国家
    Roles = 21,
    Ping = 22,
    ChangeScene = 23,
    GameNotice = 24,
    DeleteAccount = 26,
}

SettingShowTypes = {
    SettingType.Notice,
    SettingType.Setting,
    SettingType.Language,
    SettingType.NewGame,
}

SettingTypeSort =
{
    --SettingType.Notice,
    SettingType.Setting,
    --SettingType.Account,
    --SettingType.Description,
    SettingType.Language,
    --SettingType.RedemptionCode,
    SettingType.Ban,
    SettingType.DeleteAccount,
    --SettingType.Flag,
    --SettingType.Service,
    SettingType.NewGame,
    --SettingType.Vip,
    --SettingType.GM_Talk,
    SettingType.ChangeId,
    SettingType.PVE,
    SettingType.PVEFreeCamera,
    SettingType.AllowTracking,
    SettingType.PlayerNation,
    --SettingType.Ping,
    --    SettingType.Roles,
    SettingType.GameNotice,
}

AllianceMemberManageType = {
    MemberData = 1,
    MemberRankChange = 2,
    LeaderTrans = 3,
    LeaderReplace = 4,
    MemberQuit = 5,
    Mail = 6,
    ResSupport = 7,
    GolloesTrade = 8,
}
--消息推送
SettingNoticeType =
{
    PUSH_GM = 0,
    PUSH_QUEUE = 1,         --队列
    PUSH_WORLD = 2,         --世界地图,拆分被攻击和被侦查
    PUSH_MAIL = 3,          --联盟
    PUSH_STATUS = 4,        --状态
    PUSH_ALLIANCE = 5,      --社交（聊天） 去掉联盟邮件
    PUSH_ACTIVITY = 6,      --活动 5的联盟邮件加进来
    PUSH_RESOURCE = 7,      --7资源满仓
    PUSH_CHAT = 8,          --8聊天
    PUSH_REWARD = 9,        --9礼包...音乐杀僵尸、食堂开餐等
    PUSH_WEB_ONLINE = 10,   --web在线?
    PUSH_ATTACK = 11,       --从2拆分出来,被攻击
    PUSH_SCOUT = 12,        --从2拆分出来,被侦察
    NOT_CHECK = 99,         --不用检查
}

SettingNoticeTypeSort =
{
    SettingNoticeType.PUSH_WORLD,
    SettingNoticeType.PUSH_MAIL,
    SettingNoticeType.PUSH_ALLIANCE,
    SettingNoticeType.PUSH_ACTIVITY,
    SettingNoticeType.PUSH_RESOURCE,
    SettingNoticeType.PUSH_CHAT,
    SettingNoticeType.PUSH_REWARD,
    SettingNoticeType.PUSH_ATTACK,
    SettingNoticeType.PUSH_SCOUT,
}

SettingNoticeStatus =
{
    Off = 0,    --关闭状态
    On = 1,   --开启状态
}

SettingNoticeUnlock =
{
    Lock = 0,       --锁住
    UnLock = 1,     --解锁
}

--推送类型
NoticeType =
{
    LoginNotice =  20151020, --用于登陆之后设置时间，长时间不登录进行提示
    FreeHero =  4100109,--免费抽英雄
}

Language =
{
    Unspecified = 0,                -- 未指定。
    Afrikaans = 1,                  -- 南非荷兰语。
    Albanian = 2,                   -- 阿尔巴尼亚语。
    Arabic = 3,                     -- 阿拉伯语。
    Basque = 4,                     -- 巴斯克语。
    Belarusian = 5,                 -- 白俄罗斯语。
    Bulgarian = 6,                  -- 保加利亚语。
    Catalan = 7,                    -- 加泰罗尼亚语。
    ChineseSimplified = 8,          -- 简体中文。
    ChineseTraditional = 9,         -- 繁体中文。
    Croatian = 10,                  -- 克罗地亚语。
    Czech = 11,                     -- 捷克语。
    Danish = 12,                    -- 丹麦语。
    Dutch = 13,                     -- 荷兰语。
    English = 14,                   -- 英语。
    Estonian = 15,                  -- 爱沙尼亚语。
    Faroese = 16,                   -- 法罗语。
    Finnish = 17,                   -- 芬兰语。
    French = 18,                    -- 法语。
    Georgian = 19,                  -- 格鲁吉亚语。
    German = 20,                    -- 德语。
    Greek = 21,                     -- 希腊语。
    Hebrew = 22,                    -- 希伯来语。
    Hungarian = 23,                 -- 匈牙利语。
    Icelandic = 24,                 -- 冰岛语。
    Indonesian = 25,                -- 印尼语。
    Italian = 26,                   -- 意大利语。
    Japanese = 27,                  -- 日语。
    Korean = 28,                    -- 韩语。
    Latvian = 29,                   -- 拉脱维亚语。
    Lithuanian = 30,                -- 立陶宛语。
    Macedonian = 31,                -- 马其顿语。
    Malayalam = 32,                 -- 马拉雅拉姆语。
    Norwegian = 33,                 -- 挪威语。
    Persian = 34,                   -- 波斯语。
    Polish = 35,                    -- 波兰语。
    PortugueseBrazil = 36,          -- 巴西葡萄牙语。
    PortuguesePortugal = 37,        -- 葡萄牙语。
    Romanian = 38,                  -- 罗马尼亚语。
    Russian = 39,                   -- 俄语。
    SerboCroatian = 40,             -- 塞尔维亚克罗地亚语。
    SerbianCyrillic = 41,           -- 塞尔维亚西里尔语。
    SerbianLatin = 42,              -- 塞尔维亚拉丁语。
    Slovak = 43,                    -- 斯洛伐克语。
    Slovenian = 44,                 -- 斯洛文尼亚语。
    Spanish = 45,                   -- 西班牙语。
    Swedish = 46,                   -- 瑞典语。
    Thai = 47,                      -- 泰语。
    Turkish = 48,                   -- 土耳其语。
    Ukrainian = 49,                 -- 乌克兰语。
    Vietnamese = 50,                -- 越南语。
}

CountryCodeToLanguage =
{
    ["AE"] = Language.Arabic,
    ["AF"] = Language.Arabic,
    ["AR"] = Language.Spanish,
    ["BR"] = Language.PortuguesePortugal,
    ["CN"] = Language.ChineseSimplified,
    ["DE"] = Language.German,
    ["ENG"] = Language.English,
    ["ES"] = Language.Spanish,
    ["FR"] = Language.French,
    ["GB"] = Language.English,
    ["HK"] = Language.ChineseTraditional,
    ["IN"] = Language.English,
    ["IT"] = Language.Italian,
    ["JP"] = Language.Japanese,
    ["KR"] = Language.Korean,
    ["PH"] = Language.English,
    ["PT"] = Language.PortuguesePortugal,
    ["QA"] = Language.Arabic,
    ["RU"] = Language.Russian,
    ["TH"] = Language.Thai,
    ["TR"] = Language.Turkish,
    ["TW"] = Language.ChineseTraditional,
    ["US"] = Language.English,
}

SteamLanguageToPay = {
    ["arabic"] = "ar",
    ["bulgarian"] = "bg",
    ["schinese"] = "zh-CN",
    ["tchinese"] = "zh-TW",
    ["czech"] = "cs",
    ["danish"] = "da",
    ["dutch"] = "nl",
    ["english"] = "en",
    ["finnish"] = "fi",
    ["french"] = "fr",
    ["german"] = "de",
    ["greek"] = "el",
    ["hungarian"] = "hu",
    ["italian"] = "it",
    ["japanese"] = "ja",
    ["koreana"] = "ko",
    ["norwegian"] = "no",
    ["polish"] = "pl",
    ["portuguese"] = "pt",
    ["brazilian"] = "pt-BR",
    ["romanian"] = "ro",
    ["russian"] = "ru",
    ["spanish"] = "es",
    ["latam"] = "es-419",
    ["swedish"] = "sv",
    ["thai"] = "th",
    ["turkish"] = "tr",
    ["ukrainian"] = "uk",
    ["vietnamese"] = "vn",
}

LanguageName =
{
    [Language.Afrikaans] = "Afrikaans",
    [Language.Albanian] = "Albanian",
    [Language.Arabic] = "Arabic",
    [Language.Basque] = "Basque",
    [Language.Belarusian] = "Belarusian",
    [Language.Bulgarian] = "Bulgarian",
    [Language.Catalan] = "Catalan",
    [Language.ChineseSimplified] = "ChineseSimplified",
    [Language.ChineseTraditional] = "ChineseTraditional",
    [Language.Croatian] = "Croatian",
    [Language.Czech] = "Czech",
    [Language.Danish] = "Danish",
    [Language.Dutch] = "Dutch",
    [Language.English] = "English",
    [Language.Estonian] = "Estonian",
    [Language.Faroese] = "Faroese",
    [Language.Finnish] = "Finnish",
    [Language.French] = "French",
    [Language.Georgian] = "Georgian",
    [Language.German] = "German",
    [Language.Greek] = "Greek",
    [Language.Hebrew] = "Hebrew",
    [Language.Hungarian] = "Hungarian",
    [Language.Icelandic] = "Icelandic",
    [Language.Indonesian] = "Indonesian",
    [Language.Italian] = "Italian",
    [Language.Japanese] = "Japanese",
    [Language.Korean] = "Korean",
    [Language.Latvian] = "Latvian",
    [Language.Lithuanian] = "Lithuanian",
    [Language.Macedonian] = "Macedonian",
    [Language.Malayalam] = "Malayalam",
    [Language.Norwegian] = "Norwegian",
    [Language.Persian] = "Persian",
    [Language.Polish] = "Polish",
    [Language.PortugueseBrazil] = "PortugueseBrazil",
    [Language.PortuguesePortugal] = "PortuguesePortugal",
    [Language.Romanian] = "Romanian",
    [Language.Russian] = "Russian",
    [Language.SerboCroatian] = "SerboCroatian",
    [Language.SerbianCyrillic] = "SerbianCyrillic",
    [Language.SerbianLatin] = "SerbianLatin",
    [Language.Slovak] = "Slovak",
    [Language.Slovenian] = "Slovenian",
    [Language.Spanish] = "Spanish",
    [Language.Swedish] = "Swedish",
    [Language.Thai] = "Thai",
    [Language.Turkish] = "Turkish",
    [Language.Ukrainian] = "Ukrainian",
    [Language.Vietnamese] = "Vietnamese",
}

SuportedLanguages =
{
    Language.English,
    --Language.French,
    --Language.German,
    --Language.Russian,
    --Language.Korean,
    --Language.Thai,
    --Language.Japanese,
    --Language.PortuguesePortugal,
    --Language.Spanish,
    --Language.Turkish,
    ----Language.Indonesian,
    --Language.ChineseTraditional,
    Language.ChineseSimplified,
    --Language.Italian,
    ----Language.Polish,
    ----Language.Dutch,
    --Language.Arabic,
}

OnlineSuportedLanguages =
{
    Language.English,
    Language.ChineseSimplified,
}

SuportedLanguagesName = {}
SuportedLanguagesName[Language.English] = "English"
SuportedLanguagesName[Language.French] = "Français"
SuportedLanguagesName[Language.German] = "Deutsch"
SuportedLanguagesName[Language.Russian] = "Pусский"
SuportedLanguagesName[Language.Korean] = "한국어"
SuportedLanguagesName[Language.Thai] = "ไทย"
SuportedLanguagesName[Language.Japanese] = "日本語"
SuportedLanguagesName[Language.PortuguesePortugal] = "Português"
SuportedLanguagesName[Language.Spanish] = "Español"
SuportedLanguagesName[Language.Turkish] = "Türkçe"
SuportedLanguagesName[Language.Indonesian] = "Indonesia"
SuportedLanguagesName[Language.ChineseTraditional] = "繁體中文"
SuportedLanguagesName[Language.ChineseSimplified] = "简体中文"
SuportedLanguagesName[Language.Italian] = "Italiano"
SuportedLanguagesName[Language.Polish] = "Polski"
SuportedLanguagesName[Language.Dutch] = "Nederlands"
SuportedLanguagesName[Language.Arabic] = "العربية"

SuportedLanguagesLocalName = {}
SuportedLanguagesLocalName[Language.English] = "390752"
SuportedLanguagesLocalName[Language.French] = "390754"
SuportedLanguagesLocalName[Language.German] = "390756"
SuportedLanguagesLocalName[Language.Russian] = "390757"
SuportedLanguagesLocalName[Language.Korean] = "390758"
SuportedLanguagesLocalName[Language.Thai] = "390780"
SuportedLanguagesLocalName[Language.Japanese] = "390766"
SuportedLanguagesLocalName[Language.PortuguesePortugal] = "390755"
SuportedLanguagesLocalName[Language.Spanish] = "390753"
SuportedLanguagesLocalName[Language.Turkish] = "390773"
SuportedLanguagesLocalName[Language.Indonesian] = "115625"
SuportedLanguagesLocalName[Language.ChineseTraditional] = "391083"
SuportedLanguagesLocalName[Language.ChineseSimplified] = "390759"
SuportedLanguagesLocalName[Language.Italian] = "390760"
SuportedLanguagesLocalName[Language.Polish] = "390769"
SuportedLanguagesLocalName[Language.Dutch] = "390768"
SuportedLanguagesLocalName[Language.Arabic] = "390782"

SettingSetType =
{
    Effect = 0,--音效
    Sound = 1,--声音
    Message = 2,--消息
    Game = 3,--游戏
    Task = 4,--任务
    Question = 5,--反馈
    Position = 6,--位置
    DebugChooseServer = 7,--Loading是否显示选服界面
    SceneParticles = 9,--场景粒子
    Resolution = 10,--场景相机分辨率
    FPS = 11,--帧率
    Surface = 12,--地表
    Build = 13,--建筑
    Decorations = 14,--装饰物
    Monster = 15,--野怪
    SkyBox = 16,--天空盒
    ShaderLod = 17,--设置shader LOD级别
    Diamond = 18,--使用钻石提示
    Vibrate = 21,
    SendNotice = 22,--发推送
    PveResetPos = 23,--PVE 脱离卡死
    ShowTroopName = 24,--显示行军名称
    ShowTroopHead = 25,--显示行军头像
    ShowTroopDestroyIcon = 26,--显示行军拆耐久进度
    ShowTroopBloodNum = 27,--显示掉血
    ShowTroopAttackEffect = 28,--显示攻击效果
    ShowTroopGunAttackEffect = 29,--显示炮口效果
    ShowTroopDamageAttackEffect = 30,--显示爆炸效果
    FullScreen = 31,--全屏显示
    ScreenResolution = 32,--设置窗口分辨率
    SetGoogleAdsReward = 33,--谷歌广告激励式测试
    SetUnityAdsReward = 34,--unity广告激励式测试
    SetUseContentSizeFitter = 35,
    PveShowHp = 36,
    UseLuaLoading = 37,
    PveOldDetect = 38,
}

SettingSetSoundTypeSort =
{
    SettingSetType.Effect,
    SettingSetType.Sound,
    SettingSetType.Vibrate,
}


SettingSetClearTypeSort =
{
    --SettingSetType.Message,
    SettingSetType.Game,
}


SettingSetPromptTypeSort =
{
    SettingSetType.Diamond,
    --SettingSetType.Task,
    --SettingSetType.Question,
    --SettingSetType.Position,
}

SettingSetPerformanceTypeSort =
{
    SettingSetType.ShaderLod,
    SettingSetType.PveResetPos,
    SettingSetType.DebugChooseServer,
    --SettingSetType.SceneParticles,
    --SettingSetType.Surface,
    --SettingSetType.Build,
    --SettingSetType.Decorations,
    SettingSetType.Monster,
    SettingSetType.SendNotice,
    SettingSetType.ShowTroopName,
    SettingSetType.ShowTroopHead,
    SettingSetType.ShowTroopDestroyIcon,
    SettingSetType.ShowTroopBloodNum,
    SettingSetType.ShowTroopAttackEffect,
    SettingSetType.ShowTroopGunAttackEffect,
    SettingSetType.ShowTroopDamageAttackEffect,
    SettingSetType.SetGoogleAdsReward,
    SettingSetType.SetUnityAdsReward,
    SettingSetType.SetUseContentSizeFitter,
    --SettingSetType.SkyBox,
    SettingSetType.PveShowHp,
    SettingSetType.PveOldDetect,
    SettingSetType.UseLuaLoading
}

SettingSetResolutionTypeSort =
{
    SettingSetType.Resolution,
    SettingSetType.FPS,
}

SettingScreenResolutionTypeSort =
{
    SettingSetType.FullScreen,
    SettingSetType.ScreenResolution,
}

CountryCode =
{
    "AE", "AL", "AM", "AO", "AR", "AT", "AU", "AZ", "AW",
    "BD", "BE", "BG", "BH", "BR", "BY", "BL", "BIH",
    "CA", "CH", "CL", "CN", "CP", "CZ", "CU", "CY", "CR",
    "DE", "DK", "DZ", "DO",
    "EC", "EE", "EG", "ES", "ENG",
    "FI", "FR",
    "GB", "GR", "GE", "GH",
    "HK", "HR", "HU", "HN",
    "ID", "IE", "IL", "IN", "IR", "IT", "IQ",
    "JP", "JO", "JM",
    "KH", "KR", "KW", "KZ", "KE",
    "LA", "LB", "LI", "LT", "LU", "LV", "LK", "LY",
    "MK", "MM", "MX", "MY", "MN", "MA", "ME", "MD",
    "NG", "NL", "NO", "NZ", "NP",
    "OM",
    "PA", "PE", "PH", "PK", "PL", "PT", "PR",
    "QA",
    "RO", "RS", "RU",
    "SA", "SE", "SG", "SI", "SK", "SY", "SCO", "SV",
    "TH", "TN", "TR", "TW",
    "UA", "UN", "US", "UZ", "UKL",
    "VE", "VN",
    "YE", "YU",
    "ZA"
}

--账号绑定状态
AccountBandState =
{
    UnBand = 0,                 --未绑定账号
    UnCheck = 1,                --未验证
    Band = 2,                   --已验证、即已绑定
}

--账号验证状态
AccountCheckState =
{
    UnCheck = 0,                 --未验证
    Check = 1,                   --已验证
}

--打开绑定账号页面类型
AccountBindType =
{
    Bind = 1,                     --绑定账户
    Change = 2,                   --改变账户
}

--平台
RuntimePlatform =
{
    OSXEditor = 0,
    OSXPlayer = 1,
    WindowsPlayer = 2,
    WindowsEditor = 7,
    IPhonePlayer = 8,
    Android = 11,
    LinuxPlayer = 13,
    LinuxEditor = 16,
    WebGLPlayer = 17,
    WSAPlayerX86 = 18,
    WSAPlayerX64 = 19,
    WSAPlayerARM = 20,
    PS4 = 25,
    XboxOne = 27,
    tvOS = 31,
    Switch = 32,
    Lumin = 33,
}

BIND_TYPE =
{
    DEVICE = 0,
    FACEBOOK = 1,
    GOOGLEPLAY = 2,
    CUSTOM = 3,
    APPSTORE = 4,
    OICQ = 6,
    WEIBO = 7,
    WX = 8,
}

PinPwdStatus =
{
    NoHave = 0,
    Have = 1,
}

AccountCreateType =
{
    Register = 0,
    ChangePassword = 1,
}

UIPinInputType =
{
    Enter = 0,      --进入游戏
    Set = 1,        --设置PIN码
    Change = 2,     --修改PIN码
}

UIPinOpenState =
{
    Open = 0,        --开启Pin码
    Close = 2,      --关闭PIN码
}

BindSuccessType =
{
    BindAccount = 0,        --绑定账号成功
    ChangePassword = 1,     --修改密码成功
}

BuildState =
{
    BUILD_LIST_RECEIVED = 1,      --收起的建筑可以放置
    BUILD_LIST_STATE_OK = 2,      --满足建造条件
    BUILD_LIST_LACK_PEOPLE = 3,   --缺少人口
    BUILD_LIST_LACK_RESOURCE = 4,   --缺少资源
    BUILD_LIST_STATE_NEED_RESOURCE_ITEM = 5,  --缺少资源道具,
    BUILD_LIST_STATE_NEED_BUY_ITEM = 6,  --缺少物品,
    BUILD_LIST_STATE_NEED_ITEM_FORM_GIFT = 7,  --缺少物品,物品来自于礼包（目前用于机器人建筑）
    BUILD_LIST_STATE_BREAK = 8,      --建筑破损
    BUILD_LIST_SCIENCE = 9,   --缺少科技但有科技前置建筑
    BUILD_LIST_SCIENCE_BUILD = 10,   --缺少科技和前置建筑
    BUILD_LIST_STATE_VIP_LEVEL = 12,--vip等级不够
    BUILD_LIST_NEED_GUIDE = 13,      --建造需要完成引导
    BUILD_LIST_REACH_CUR_MAX = 14,      --建造达到当前可解锁最大
    BUILD_LIST_PREBUILD = 15,--前置建筑
    BUILD_LIST_STATE_NEED_BUY = 16,  --需要礼包购买
    BUILD_LIST_STATE_NEED_BUY_MONTH = 17,  --缺少月卡,
    BUILD_LIST_REACH_MAX = 18,      --建造达到最大
    BUILD_LIST_NEED_PARA3_SCIENCE = 19,      --建造需要para3科技
    BUILD_LIST_NEED_UNLOCK_TALENT = 21,      --建造需要解锁天赋
    BUILD_LIST_NEED_QUEST = 22,      --建造需要完成任务
    BUILD_LIST_NEED_CHAPTER = 23,      --建造需要完成章节
    BUILD_LIST_NEED_ALLIANCE_CITY_BUILD = 24,      --建造需要赛季城
    BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_REPLACE = 25, --重放赛季建筑需要联盟中心前置条件
    BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD = 26, --建造赛季建筑需要联盟中心前置条件
    BUILD_LIST_NEED_MASTERY = 27, --建造需要学习专精
    BUILD_LIST_NEED_DIRECTION = 28,--建造需要突破指定的方向
}


HeroListSortType =
{
    Quality = 0,   --品质  --dropdown 从0开始
    Level = 1,     --等级排序
    Power = 2,     --战力排序
}

HeroListSortTypeSort =
{
    HeroListSortType.Quality,
    HeroListSortType.Level,
    HeroListSortType.Power,
}

HeroState =
{
    Free = 0,           --空闲中
    FormationMarch = 1,   --跟随编队出征中
    StationBuilding = 7,    --驻扎在建筑上
    FormationInCity = 8,    --在城内的编队里  没有出征
}

SlotState =
{
    Lock = 0,           --锁住
    UnLock = 1,         --已解锁
}

ShowHeroListType =
{
    OwnTitle = 1,
    Own = 2,
    UnOwnTitle = 3,
    UnOwn = 4,
}

HeroXmlState =
{
    HeroXMLState_Normal = 1, -- 正常显示
    HeroXMLState_Prepare = 2, -- 准备中
    HeroXMLState_Hide = 3, --不对玩家开放
    HeroXMLState_NeverGet = 4, --玩家永远不会获得的英雄 英雄是存在的 英雄列表里没有
    HeroXMLState_Max = 5,
}

HeroSkillState =
{
    Unlock = 0,             --已解锁
    Lock = 1,               --未解锁
    CanLock = 2,            --可解锁
}

HeroStarUseType =
{
    UseSelf = 1,                            --使用自己的英雄碎片
    SameCampAndSameColor = 2,               --表示使用碎片对应英雄同阵营同品质碎片
    OnlySameColor = 3,                      --表示使用碎片对应英雄同品质碎片
}

HeroStarUseCommon =
{
    No = 0,                             --不可以使用通用碎片
    Yes = 1,                            --可以使用通用碎片
}

FrameType =
{
    HeroFrame = 0,                              --英雄碎片
    Common = 1,                                 --通用碎片
}

--英雄列表状态
UIHeroListState =
{
    HeroList = 0,                               --英雄列表状态
    Star = 1,                                   --升星状态
}

--升星界面星星状态
UIHeroListUpStarStarState =
{
    Yes = 0,                                  --已达成
    No = 1,                                   --未达成
}

ActivityEventType =
{
    NULL =0, --0
    PERSONAL=1, --1个人军备
    ALLIANCE=2, --2联盟军备
    KINGDOM_PERSONAL=3, --3 最强要塞个人
    KINGDOM_ALLIANCE =4, --4 最强要塞联盟
    MERGE_PERSONAL =5, --5 沙漠个人
    MERGE_ALLIANCE =6, --6 沙漠联盟
    BF_PERSONAL =7,--7 竞技场日常奖励
    LS_WORLD_PERSONAL =8, --8 LS世界活动赛季积分 个人
    LS_WORLD_ALLIANCE =9,--9 LS世界活动赛季积分 联盟
    LS_WORLD_ALLIANCE_TO_ALLIANCE =10, --10 世界地块 联盟对联盟
    PERSONAL_LIMITTIME =11,    --11 个人限时活动
    KINGDOM_WARMUP_PERSONAL =12, --12 最强要塞热身赛赛个人
    KINGDOM_WARMUP_ALLIANCE =13, --13 最强要塞热身赛联盟
    ALLIANCE_ORDER = 16, --16 联盟农场
    INDIVIDUAL_ORDER = 19, --19 个人农场
}

-- 活动中心-相关枚举
ActivityEnum =
{
    ActivitySubType = {
        ActivitySubType_1 = 1,--活动类型 type=18 任务活动. 当sub_type=1时表示任务进度不累计，不可领奖。 活动类型 type=20 兑换活动当 sub_type=1时表示不可兑换。
        ActivitySubType_2 = 2,--活动类型 type=18 任务活动. 当sub_type=2时表示任务可跳转，显示前往
        DrakeBoss = 3,--活动类型 type=18 任务活动. 当sub_type=3时表示德雷克活动
    },
    --活动类型
    ActivityType ={
        None = 0,
        BlackKnight = 3,--黑骑士活动
        ----开服-战力活动
        --NewServer = 8,
        --开服-平民活动
        Farmer = 9,
        --转盘活动
        TurntableActivity = 10,
        --英雄活动
        HeroActivity = 11,
        --个人军备活动
        Arms = 12,
        --联盟军备
        AllianceArmRaceAct = 14,
        --怪物活动
        MonsterActivity = 100,
        --世界 Boss 活动
        WorldBoss = 23,
        --伊甸园
        EdenWar = 13,
        --雷达集结
        RadarRally = 17,    --ps：弃用
        --拼图活动
        Puzzle = 22,
        --幸运转盘
        LuckyRoll = 24,
        --战令
        BattlePass = 27,
        --咕噜翻牌
        GolloesCards = 29,
        MonsterTower = 33,--怪物爬塔
        ActSevenDay = 34,--活动七日 ps:有两个七日 一个是属于活动的，一个是不属于的
        GiftBox = 36,
        ActSevenLogin = 41,--七日登陆
        LuckyShop = 44,--幸运商店
        SeasonWeekCard = 46,--赛季周卡
        SeasonRank = 48,--赛季打地块排行榜
        DecorationGiftPackage = 49,--皮肤礼包活动
        AllianceSeasonForce = 50,--赛季联盟积分排行榜
        WorldTrend = 51,--天下大势，移到活动中了
        GloryPreview = 55,--S3星球大战预告
        DonateSoldierActivity = 56,--捐兵活动
        HeroEvolve = 57,--英雄特训
        ChaseDeer = 58,--群雄逐鹿
        PersonSeasonRank = 59,--个人势力排行榜
        PresidentAuthority = 60,--总统特权
        ALVSDonateSoldier = 61,--捐兵打联盟
        AllianceBoss = 62,--联盟boss
        DoubleSeasonScore = 63,--双倍赛季积分活动
        Mastery = 67,--专精手册
        ActNoOne = 68,--假活动    只需活动时间的活动，此活动不显示在页签
        AllianceActMine = 69,--活动联盟矿
        ScratchOffGame = 64,-- 刮刮卡
        Mining = 65,--矿产大亨
        SeasonShop = 74,--赛季商店
        Mysterious = 72,--数字寻宝
        AllianceOccupy = 70,--联盟占领城市活动
        ActDragon = 71,--巨龙活动
        GolloBox = 73,--咕噜专精
        DragonNotice = 76,--巨龙预告
        CrossDesert = 75,--跨服打地
        ActMineCave = 77,--矿脉增殖
        StaminaBall = 78,--体力球
        ColonizeWarRank = 79,--殖民战争排行榜
        EquipIntensify = 80, --运兵车强化
        EquipGift = 81,--同80配套礼包活动
        CampScore = 82,--阵营分数活动
        CrossWonder = 83, -- 跨服王座
        EdenKill = 84, -- 伊甸园杀敌活动
        TurfWar = 85, -- 七级城占领活动
        EdenAllianceActMine = 86,--伊甸园联盟矿
        CrossCityWar = 87,--跨服战--一般和伊甸园联盟对决绑定
        AllianceCityRecord = 88,--玩家打城记录
        ChangeNameAndPic = 89,--改名/换头像活动
        CountryRating = 90,--国家评分
        EdenAllianceCrossActMine = 91,--伊甸园跨服联盟金矿
        --七日 ps:七日不算活动，在这为手动添加活动ID
        SevenDay = 999,
    };
}

--个人军备活动类型
PersonalEventType = 
{
    Daily = 1,  --日常军备
    Kill = 2,   --杀敌活动
    Permanent = 3,--常驻军备(持续一天)
}

--冠军对决活动不同阶段状态
Activity_ChampionBattle_Stage_State =
{
    None = 0,
    SingUp = 1, --报名阶段
    Auditions = 2, --海选阶段
    Strongest_64 = 3,--巅峰对决64强赛
    Strongest = 4,--巅峰对决8强赛
};

--冠军对决-海洗赛阶段各宝箱状态
AuditionsBoxState =
{
    Fail = -1,      --海选单局失败
    NotStart = 0,   --海选此局未开始
    CanReceive = 1, --海选胜利未领奖
    HasReceived = 2, --海选已领奖
};

--冠军对决海报类型(冠军对决争霸赛阶段状态，1，2，3服务器同步状态，4为客户根据结果补充状态)
ChampionBattlePosterType =
{
    None = 0,
    Strongest_Eight = 1, --8强
    Strongest_Four = 2,  --4强
    Strongest_Two = 3,   --2强
    Strongest_King = 4,  --冠军
};

SeasonStage = {
    None = 0,
    Preview = 1,
    Open = 2,
    toSettle = 3,
    ToFinish = 4,
    Finished = 5,
}

GetRewardTitleType = {
    Common = 1,
    BattleFail = 2,
}

EnumActivity = {
    AllianceCompete = {
        Type = 14,
        ActId = "55000",
        EventType = 15,
    },
    LeadingQuest = {
        Type = 18,
    },
    BarterShop = {
        Type = 20,
    },
    BarterShopNotice = {--属于活动中心
        Type = 21,
    },
    RallyBossAct = {--属于日常活动
        Type = 21,
        ActId = "40005",
    },
    MineCave = {
        Type = 25,
        ActId = "20001",
    },
    Arena = {
        Type = 26,
        ActId = "30000"
    },
    ActivitySummary = {
        Type = 30,
    },
    JigsawPuzzle = {
        Type = 31,
    },
    DigActivity =
    {
        Type = 35,
    },
    RobotWars = {
        Type = 38,
    },
    ThemeChristmas = {
        Type = 39,
    },
    ChristmasCelebrate = {
        Type = 40,
    },
    PaidLottery = {
        Type = 42,
    },
    ChainPay = {
        Type = 43,
    },
    SeasonPass = {
        Type = 45,
    },
    AlContribute = {
        Type = 53,
        EventType = 16,
    },
    Throne = {
        Type = 54,
    },
    DispatchTask = {
        Type = 201, -- 派遣任务
    },
    HeroGrowth = {
        Type = 998, --英雄试炼
    }
}

EnumActivityStatus = {
    Preview = 1,
    Open = 2,
    Close = 3,
}

HeroGrowthTaskStatus = {
    LackHero = 1,--没有英雄
    LackSkill = 2,--技能未解锁
    SkillLvUnfit = 3,--技能等级不足
    Complete = 4,--完成未领奖
    Rewarded = 5,--已领奖
}

EnumActivityNoticeInfo = {
    EnumActivityNoticeInfo_Hero = "hero",
}

SeasonPassRewardType = {
    NormalReward = 0,--普通奖励
    SpecialReward = 1,--付费奖励
}

HeroTalentColor =
{
    Red = 1,
    Orange = 2,
    Blue = 3,
}

HeroTalentCellIconType =
{
    Big = 1,
    Small = 2,
}


HeroTalentCellState =
{
    NoPre = 0,--等级0 不满足前置要求
    Pre = 1, --等级0 满足前置要求
    Yes = 2,--等级大于1
}

HeroTalentLineCellState =
{
    Gray = 0,--暗
    Light = 1, --亮
}

HeroTalentUseType =
{
    Reset = 1,
    Change = 2,
}

--加载路径
LoadPath =
{
    SoundEffect = "Assets/Main/Sound/Effect/%s.ogg",
    HeroIconsSmallPath = "Assets/Main/Sprites/HeroIconsSmall/",
    HeroIconsBigPath = "Assets/Main/Sprites/HeroIconsBig/",
    HeroListPath = "Assets/Main/Sprites/UI/UIHeroList/%s",
    HeroDetailPath = "Assets/Main/Sprites/UI/UIHeroDetail/%s",
    HeroAdvancePath = "Assets/Main/Sprites/UI/UIHeroAdvance/%s",
    HeroRecruitPath = "Assets/Main/Sprites/UI/UIHeroRecruit/%s",
    HeroBodyPath = "Assets/Main/Sprites/HeroBody/%s",
    SkillIconsPath = "Assets/Main/Sprites/SkillIcons/",
    SkillBigIconsPath = "Assets/Main/Sprites/UI/UIPveHeroAppear/",

    GarbageIconsPath = "Assets/Main/Sprites/UI/UIGarbage/",

    GolloesCampPath = "Assets/Main/Sprites/UI/UIGolloesCamp/%s",
    ActivityIconPath = "Assets/Main/Sprites/ActivityIcons/%s",
    HeroIconPath = "Assets/Main/Sprites/HeroIcons/%s",
    TalentPath = "Assets/Main/Sprites/HeroTalent/%s",
    UIHeroInfoPath = "Assets/Main/Sprites/UI/UIHeroInfo/%s",
    CommonApsNewPath = "Assets/Main/Sprites/UI/UIRank/%s",
    ItemPath = "Assets/Main/Sprites/ItemIcons/%s",
    UIChatChat = "Assets/Main/Sprites/UI/UIChat/Chat/%s",
    BuildIconOutCity = "Assets/Main/Sprites/BuildIconOutCity/%s",
    SeasonDesert = "Assets/Main/Sprites/SeasonDesert/%s",
    DailyActivityUnlock = "Assets/Main/Sprites/DailyActivityUnlock/%s",
    ResLackIcons = "Assets/Main/Sprites/ResLackIcons/%s",
    ResourceIcons = "Assets/Main/Sprites/Resource/%s",
    UIBuildBtns = "Assets/Main/Sprites/UI/UIBuildBtns/%s",
    UIBuildBubble = "Assets/Main/Sprites/UI/UIBuildBubble/%s",
    UINPCPath = "Assets/Main/Sprites/UI/UINPC/%s",
    CommonPath = "Assets/Main/Sprites/UI/Common/%s",
    ScienceIcons = "Assets/Main/Sprites/ScienceIcons/%s",
    SoldierIcons = "Assets/Main/Sprites/SoldierIcons/%s",
    UIScience = "Assets/Main/Sprites/UI/UIScience/%s",
    UISciencePrefab = "Assets/Main/Prefabs/UI/UIScience/%s",
    Soldier = "Assets/Main/Sprites/Soldier/%s",
    UISoldier = "Assets/Main/Sprites/UI/UISoildier/%s",
    AvatorFolder = "Assets/Main/Sprites/UI/UIChatNew/%s",
    ChatFolder = "Assets/Main/Sprites/UI/UIChatNew2/%s",
    CommonNewPath = "Assets/Main/Sprites/UI/Common/New/%s",
    UIFormationDefencePath = "Assets/Main/Sprites/UI/UIFormationDefence/%s",
    UIChatNew1 = "Assets/Main/Sprites/UI/UIChatNew1/%s",
    UIMainNew = "Assets/Main/Sprites/UI/UIMain/UIMainNew/%s",
    UIPopupPackage = "Assets/Main/Sprites/UI/UIMain/UIPopupPackage/%s",
    RadarCenterPath = "Assets/Main/Sprites/UI/UIRadarCenter/%s",
    UITroops = "Assets/Main/Sprites/UI/UITroops/%s",
    UITroopsNew = "Assets/Main/Sprites/UI/UITroopsNew/%s",
    Guide = "Assets/Main/Sprites/Guide/%s",
    UITask = "Assets/Main/Sprites/UI/UITask/%s",
    UIPlayerIcon ="Assets/Main/Sprites/UI/UIHeadIcon/%s",
    UserHeadPath = "Assets/Main/Sprites/UI/UIHeadIcon/%s",
    UIActivity = "Assets/Main/Sprites/UI/UIActivity/%s",
    UIPersonalArms = "Assets/Main/Sprites/UI/UIPersonalArms/%s",
    UIAllianceArmament = "Assets/Main/Sprites/UI/UIAllianceArmament/%s",
    UISevenDay = "Assets/Main/Sprites/UI/UISevenDay/%s",
    UISevenLogin = "Assets/Main/Sprites/UI/UISevenLogin/%s",
    UIAlliance = "Assets/Main/Sprites/UI/UIAlliance/%s",
    UIAllianceGift = "Assets/Main/Sprites/UI/UIAllianceGift/%s",
    NPCModel = "Assets/Main/Prefab_Dir/NPCModel/%s.prefab",
    UIMail = "Assets/Main/Sprites/UI/UIMail/%s",
    AllianceMark = "Assets/Main/Sprites/UI/UIAllianceMark/%s",
    GuideTipSpine = "Assets/Main/Prefab_Dir/Guide/%s.prefab",
    DecorationTreePath = "Assets/Main/Prefabs/World/WorldCityTree%s.prefab",
    UIVipPath = "Assets/Main/Sprites/UI/UIVip/%s",
    UIHeroMonthCard = "Assets/Main/Sprites/UI/UIHeroMonthCard/%s",
    Resident = "Assets/Main/Sprites/UI/Resident/%s",
    UIVita = "Assets/Main/Sprites/UI/UIVita/%s",
    UIFeature = "Assets/Main/Sprites/UI/UIFeature/%s",
    UIOpinion = "Assets/Main/Sprites/UI/UIOpinion/%s",

    WarDetail = "Assets/Main/Sprites/UI/UIAllianceWarDetail/%s",
    UIRobotPack = "Assets/Main/TextureEx/UIDronePack/UIrobot_img_%s",
    UIHeroStation = "Assets/Main/Sprites/UI/UIHeroStation/%s",
    UIChampionBattle = "Assets/Main/Sprites/UI/UIChampion/%s",
    UIMainQuest = "Assets/Main/Sprites/UI/UITask/%s",
    UILuckyRoll = "Assets/Main/Sprites/UI/UILuckyRoll/%s",
    UIGolloesCards = "Assets/Main/Sprites/UI/UIGolloesCards/%s",
    UIChronicle = "Assets/Main/Sprites/UI/UIChronicle/%s",
    UIWorldTrend = "Assets/Main/Sprites/UI/UIWorldTrend/%s",
    UIWorldTrendNew = "Assets/Main/Sprites/UI/UIWorldTrendNew/%s",
    UIMonsterTower = "Assets/Main/Sprites/UI/UIMonsterTower/%s",
    LodIcon = "Assets/Main/Sprites/LodIcon/%s",
    UIPveLoading = "Assets/Main/Sprites/UI/UIPveLoading/%s",
    UImystery = "Assets/Main/Sprites/UI/UImystery/%s",
    UIHeroIntensify = "Assets/Main/Sprites/UI/UIHeroIntensify/%s",

    -- 砍伐相关
    CityScene = "Assets/Main/Prefabs/CityScene/%s.prefab",
    Building = "Assets/Main/Prefabs/Building/%s.prefab",
    DyHero = "Assets/Main/Prefabs/PVE/DyHeroes/%s.prefab",
    UICommonPackageBig = "Assets/Main/Sprites/UI/UICommonPackageBig/CommonPackageBig_img_%s",
    UIGarageRefitUIRetrofit_ = "Assets/Main/Sprites/UI/UIGarageRefit/UIRetrofit_%s",
    UIGarageRefit = "Assets/Main/Sprites/UI/UIGarageRefit/%s",
    UIChapter = "Assets/Main/Sprites/UI/UIChapter/%s",
    UIChapterTask = "Assets/Main/Sprites/UI/UIChapterTask/%s",
    PVEScene = "Assets/Main/Sprites/pve/%s",
    UIPveBattleBuff = "Assets/Main/Sprites/UI/UIPveBattleBuff/%s",
    UITreasurePuzzle = "Assets/Main/Sprites/UI/UITreasurePuzzle/%s",
    PVELevel = "Assets/Main/Prefabs/PVELevel/%s.prefab",
    PVETriggerIcons = "Assets/Main/Sprites/PVETriggerIcons/%s",
    CollectResource = "Assets/Main/Prefabs/CollectResource/%s.prefab",
    UIBuildUpgrade = "Assets/Main/Sprites/UI/UIBuildUpgrade/%s",
    UIDecoration = "Assets/Main/Sprites/UI/UIDecoration/%s",
    UIDecorationBG = "Assets/Main/TextureEx/UIDecoration/%s",
    UILuckyShop = "Assets/Main/Sprites/UI/UIGroceryStore/%s",
    UISeasonIntro = "Assets/Main/Sprites/UI/UISeasonIntro/%s",
    UISeasonHint = "Assets/Main/Sprites/UI/UISeasonHint/%s",
    UISeasonWeek = "Assets/Main/Sprites/UI/UISeasonWeek/%s",
    UITextureExActivity = "Assets/Main/TextureEx/UIActivity/%s",
    UIEquipmentIcons = "Assets/Main/Sprites/EquipmentIcons/%s",
    UIGlory = "Assets/Main/Sprites/UI/UIGloryLeague/%s",
    UIMastery = "Assets/Main/Sprites/UI/UIMastery/",
    UIGovernment = "Assets/Main/Sprites/UI/UIGovernment/%s",
    UIGovernmentBig = "Assets/Main/TextureEx/UIGovernment/%s",
    UIHeroEvolve = "Assets/Main/Sprites/UI/UIHeroEvolve/%s",
    UIHeroEvolveEx = "Assets/Main/TextureEx/UIHeroEvolve/%s",
    UIWorldTrendBg = "Assets/Main/TextureEx/UIWorldTrend/%s",
    UIMysterious = "Assets/Main/Sprites/UI/UIMysterious/%s",
    UIStory = "Assets/Main/Sprites/UI/UIStory/%s",
    
    UITitleIcon = "Assets/Main/Sprites/UI/UITitleTag/%s",
    UIMasteryEx = "Assets/Main/TextureEx/UIMastery/UIMastery_%s",
    UIGiftPackage = "Assets/Main/Sprites/UI/UIGiftPackageNew/%s",
    UIGiftPackageEx = "Assets/Main/TextureEx/UIGiftPackage/%s",
    UIScratchOffLuckyIcon = "Assets/Main/Sprites/UI/UIScratchOff/%s",
    UISeasonRobots = "Assets/Main/Sprites/UI/UISeasonRobots/%s",
    UIMiningCarImg = "Assets/Main/Sprites/UI/UIMine/%s",
    UIDragon = "Assets/Main/Sprites/UI/UIDragon/%s",
    SoldierSkillIcons = "Assets/Main/Sprites/SoldierSkillIcons/%s",
    UIFirstCharge = "Assets/Main/Sprites/UI/UIFirstCharge/%s",
    UIFirstChargeEx = "Assets/Main/TextureEx/UIFirstCharge/UIfirstcharge_bg_%s",
    UIEveryDay = "Assets/Main/Sprites/UI/UIEveryDay/%s",
    UIInterstellarMigration = "Assets/Main/Sprites/UI/UIInterstellarMigration/%s",
    UICountryRating = "Assets/Main/Sprites/UI/UICountryRating/%s",
    Furniture = "Assets/Main/Sprites/Furniture/%s",
    UIFurniture = "Assets/Main/Sprites/UI/UIFurniture/%s",
    
    UIResource = "Assets/Main/Sprites/Resource/%s",
    UIMain = "Assets/Main/Sprites/UI/UIMain/%s",
    UIJeepAdventure = "Assets/Main/Sprites/UI/UIJeepAdventure/%s.png",
    UIPve = "Assets/Main/Sprites/UI/UIPve/%s.png",
    UINewHero = "Assets/Main/TextureEx/UINewHero/%s",
    HeroSpine = "Assets/_Art/Spine/%s/%s_SkeletonData.asset",
    WeaponPrefabPath = "Assets/Main/Prefab_Dir/Weapon/%s.prefab",
    ZombiePartPrefabPath = "Assets/_Art/Models/zombie/A_Monster_Zombie01/prefab/%s.prefab",
    Land = "Assets/Main/Prefab_Dir/Land/%s.prefab",
    LandObjectModel = "Assets/Main/Prefab_Dir/Land/ObjectModel/%s.prefab",
    UIGuideTalk = "Assets/Main/Sprites/UI/UIGuideTalk/%s",
    UIGuideEx = "Assets/Main/TextureEx/UIGuide/%s",
    UIAnimEmoji = "Assets/Main/Sprites/UI/UIAnimEmoji/%s",
    ZombiePath = "Assets/Main/Prefab_Dir/Home/Zombie/%s.prefab",
    UITaskMainTexture = "Assets/Main/TextureEx/UITaskMain/%s",
    UIHeroEquipIcons = "Assets/Main/Sprites/HeroEquipIcons/%s",
    UIHeroEquipPath = "Assets/Main/Sprites/UI/UIHeroEquip/%s",
    UIDailyMustBuy = "Assets/Main/Sprites/UI/UIDailyMustBuy/%s",
    UIDailyMustBuyBackGround = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyMustBuy/BackGround/%s.prefab",
    UIChapterBgTexture = "Assets/Main/TextureEx/UIChapterBg%s/%s",
    UIBattlePassBgPath = "Assets/Main/TextureEx/UIActivity/",
}

--	聊天频道的类型
ChatChannelType = {
    CHAT_CHANNEL_COUNTRY  = 0, -- 国家
    CHAT_CHANNEL_ALLIANCE = 1, -- 联盟
    CHAT_CHANNEL_USER 	  = 2, -- 个人（邮件）
    CHAT_CHANNEL_ROOM     = 3, -- 新建聊天室
}


----聊天组类别
--ChatGroupType =
--{
--    GROUP_COUNTRY  = "country",	  --战区
--    GROUP_ALLIANCE = "alliance",  --联盟
--    GROUP_CROSS_SERVER = "custom_crossbattle_",--跨服联盟战争
--    GROUP_DRAGON_SERVER = "custom_starwar_",--巨龙聊天
--    GROUP_EDEN_CAMP = "custom_eden_camp_",--伊甸园阵营
--    GROUP_WARZONE  = "warzone",   --没用了
--    GROUP_CUSTOM   = "custom",	  --自定义聊天室
--    GROUP_FORCE    = "force", 	  --现在的伊甸园用的一个聊天室，俗称公会
--    GROUP_MAILCHAT = "mailChat",  --邮件聊天
--}

--	红包类型
ChatMessageType = {
    COMMON		    = 0,   	-- 普通
    SYSTEM 	   		= 1, 	-- 系统消息
    FESTIVAL	    = 2, 	-- 系统节日
}

--分享到聊天的频道类型
ChatShareChannel = {
    TO_COUNTRY  = 0,  -- 国家
    TO_ALLIANCE = 1,  -- 联盟
    TO_PERSON   = 2,  -- 私聊
}

----发送聊天的类型
--PostType = {
--    Text_Normal 			= 0,   		-- 普通聊天消息
--    Text_AllianceCreated 	= 1, 	-- 联盟创建消息 
--    Text_AllianceAdded		   = 2, 	-- 加入联盟系统邮件
--    Text_AllianceInvite    	= 3,  -- 联盟邀请的系统邮件
--    Text_FightReport 		= 4,  --战报分享 
--    Text_InvestigateReport  = 5,  --侦查战报分享
--    Text_Loudspeaker 		= 6,  -- 喇叭消息
--    Text_EquipShare 		= 7,  -- 装备分享
--    Text_SayHello 			= 8,  -- 打招呼
--    Text_AllianceRally   = 9,  -- 联盟集结
--    Text_TurntableShare     = 10, -- 轮盘分享
--    Text_AllianceTask 		= 11, --联盟任务
--    RedPackge      			= 12, -- 红包
--    Text_PointShare			= 13, -- 坐标分享
--    Text_AllianceTaskHelper = 14, -- 联盟宝藏求助
--    Text_Media 				= 15, -- 语音消息 这个C++层也没定义 不知道有没有用了
--    Text_Alliance_MonthCardBox = 18, -- 月卡随机宝箱分享
--    Text_SevenDayShare  	= 19, -- 七日分享
--    Text_MissileShare       = 20, --导弹分享
--    Text_AllianceGroupBuyShare = 21, -- 联盟团购分享
--    Text_Create_EquipShare  = 22, --打造装备分享
--    Text_Create_New_EquipShare = 23,--新打造装备分享
--    Text_Use_Item_Share  		= 24, --使用道具分享
--    Text_Gift_Mail_Share 		= 25, -- 赠送礼品邮件分享
--    Text_Favour_Point_Share     = 26, -- 收藏坐标点
--    Text_GoTo_Wounded_Share 	= 27, -- 治疗伤病分享
--    Text_GoTo_Medal_Share		= 28, -- 装备勋章分享
--    Text_Shamo_Inhesion_Share   = 29, -- 沙漠天赋分享
--    Text_Formation_Fight_Share  = 30, -- 新的地块战斗战报分享
--    Text_FBScoutReport_Share    = 31, -- 新的侦查邮件分享
--    Text_FBActivityhero_Share   = 32, -- 自由城建积分兑换英雄的分享
--    Text_FBFormation_Share		= 33, -- 自由城建编队分享
--
--
--    Text_ScienceMaxShare 		= 34, -- 科技MAX分享
--    Text_AllianceCommonShare 	= 35, -- 新联盟转盘分享
--    Text_SevenDayNewShare 		= 36, -- 新末日投资分享
--    Text_AllianceAttackMonsterShare = 37, --  联盟集结BOSS
--    Text_AllianceArmsRaceShare  = 38, -- 联盟军备竞赛活动分享
--    Text_EnemyPutDownPointShare = 39, -- 敌方在本方放下集结点分享
--    Text_FBAllianceGift_Share   = 40, -- 自由城建联盟礼物分享
--    Text_FBAlliance_missile_share = 41,--分享联盟导弹攻击信息
--
--    Text_Dommsday_Missile_Share = 42,  --末日导弹
--    Text_Audio_Message 			= 43,  -- 语音消息
--    Text_Visit_Base_Message 	= 44,  --参观基地建设
--    Text_Send_Flower 			= 45,  --送花界面
--
--    Text_ChatRoomSystemMsg 		= 100, -- 聊天室系统消息
--    Text_ChatWarnningSysMsg 	= 110, --世界频道i政治敏感信息警告系统消息
--    Text_AD_Msg 				= 150, --个人信息邮件广告友情提示
--    Text_AreaMsg  				= 180, --竞技场伪造的消息
--    Text_ModMsg 				= 200, --mod邮件
--    Text_Alliance_ALL_Msg       = 250,
--
--    NotCanParse 				= 300,
--
--
--}

--聊天限制玩家类型
RestrictType = {
    BLOCK 	= 1,  -- 屏蔽
    BAN 	= 2,  -- 禁言
}

--发送状态的类型
SendStateType = {
    OK 		= 0,
    PENDING = 1,
    FAILED  = 2,

}

ScreenType =
{
    Portrait = 0,--竖屏
    Landscape = 1,--横屏
}

--语音保存结果
RecordResultState =
{
    RECORD_SAVE_ERROR = -4,
    RECORD_USER_CANCELED = -3,
    RECORD_TOO_SHORT = -2,
    MICROPHONE_UNAVAILABLE = -1,
    OK = 0,
}

--编队状态
ArmyFormationState =
{
    Free = 0,--空闲中
    March = 1,--出征中
}

--编队出征状态
MarchArmsType =
{
    Free = 0,--普通出征
    Cross = 1,--跨服出征
    CROSS_DRAGON =2,
}

--建筑占格子大小
BuildTilesSize =
{
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Seven = 7,
}

BuildNeedMonth =
{
    No = 0,--不需要
    Yes = 1,--需要
}

--建筑放置条件
BuildInside =
{
    In = 0,--苍穹内建筑
    Out = 1,--苍穹外建筑
    All = 2,--所有都可以放置
}

--建造列表界面类型枚举
UIBuildListTabType =
{
    InBuild = 1,--苍穹内建筑
    OutBuild = 2,--苍穹外
    SeasonBuild = 4,--赛季建筑
    EdenSubway = 6,--伊甸园虫洞
    Robot = 10,--机器人
    SeasonRobot = 11,--赛季机器人
}
--建造列表界面类型枚举排序
UIBuildListTabTypeSort =
{
    UIBuildListTabType.Robot,
    UIBuildListTabType.InBuild,
    UIBuildListTabType.OutBuild,
}

UIBuildListBuildType =
{
    Build = 3,--建筑
    Robot = 4,--无人机
}

--主界面动画类型
UIMainAnimType =
{
    AllHide = "OutWithResource",--:主界面上下左右全部隐藏
    LeftRightBottomHide = "OutWithoutResource",--:主界面上部保留（资源条和头像），下左右全部隐藏
    AllShow = "EnterWithResource",--:主界面上下左右全部隐藏
    LeftRightBottomShow = "EnterWithoutResource",--:主界面上部保留（资源条和头像），下左右全部隐藏
    ChangeAllShow = "ChangeAllShow",--:无论什么状态，变成全部显示状态
    OutStayTopLeft = "OutStayTopLeft",--:上左显示剩下隐藏
}

ResourceTabSelectImage = {}
ResourceTabSelectImage[ResourceType.Oil] = "Assets/Main/Sprites/Resource/Oil_select"
ResourceTabSelectImage[ResourceType.Metal] = "Assets/Main/Sprites/Resource/Metal_select"
ResourceTabSelectImage[ResourceType.Water] = "Assets/Main/Sprites/Resource/Water_select"
ResourceTabSelectImage[ResourceType.Electricity] = "Assets/Main/Sprites/Resource/Electricity_select"
ResourceTabSelectImage[ResourceType.Money] = "Assets/Main/Sprites/Resource/Money_select"
ResourceTabSelectImage[ResourceType.Wood] = "Assets/Main/Sprites/Resource/Wood_select"

ResourceTabUnSelectImage = {}
ResourceTabUnSelectImage[ResourceType.Oil] = "Assets/Main/Sprites/Resource/Oil_unSelect"
ResourceTabUnSelectImage[ResourceType.Metal] = "Assets/Main/Sprites/Resource/Metal_unSelect"
ResourceTabUnSelectImage[ResourceType.Water] = "Assets/Main/Sprites/Resource/Water_unSelect"
ResourceTabUnSelectImage[ResourceType.Electricity] = "Assets/Main/Sprites/Resource/Electricity_unSelect"
ResourceTabUnSelectImage[ResourceType.Money] = "Assets/Main/Sprites/Resource/Money_unSelect"
ResourceTabUnSelectImage[ResourceType.Wood] = "Assets/Main/Sprites/Resource/Wood_unSelect"

ResourceTabName = {}
ResourceTabName[ResourceType.Oil] = "100020"
ResourceTabName[ResourceType.Metal] = "100020"
ResourceTabName[ResourceType.Water] = "100546"
ResourceTabName[ResourceType.Electricity] = "100002"
ResourceTabName[ResourceType.Money] = "100000"
ResourceTabName[ResourceType.Wood] = "104283"

UICapacityTableTab=
{
    Farming = 0,--农业
    Industry = 1,--工业
    Resource = 2,--资源
    Item = 3,   --道具
}

CapacityTabSelectImage ={}
CapacityTabSelectImage[UICapacityTableTab.Farming] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_warehouse"
CapacityTabSelectImage[UICapacityTableTab.Industry] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_select"
CapacityTabSelectImage[UICapacityTableTab.Resource] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_resentrepot"
CapacityTabSelectImage[UICapacityTableTab.Item] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_prop"

CapacityTabName ={}
CapacityTabName[UICapacityTableTab.Farming] = "100076"
CapacityTabName[UICapacityTableTab.Industry] = "100080"
CapacityTabName[UICapacityTableTab.Resource] = " 100076"
CapacityTabName[UICapacityTableTab.Item] = "100080"

CapacityTabUnSelectImage ={}
CapacityTabUnSelectImage[UICapacityTableTab.Farming] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_warehouse_unchecked"
CapacityTabUnSelectImage[UICapacityTableTab.Industry] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_unselect"
CapacityTabUnSelectImage[UICapacityTableTab.Resource] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_resentrepot_unchecked"
CapacityTabUnSelectImage[UICapacityTableTab.Item] = "Assets/Main/Sprites/UI/UICapacity/Common_btn_prop_unchecked"

UIWorldTileTopBtnType =
{
    Share = 1,  --分享
    Book = 2,   --收藏
    Emoji = 3,  --表情
    PackUp = 4, --收起
}

UIWorldTileTopBtnSort =
{
    UIWorldTileTopBtnType.Share,
    UIWorldTileTopBtnType.Book,
    --UIWorldTileTopBtnType.Emoji,
    --UIWorldTileTopBtnType.PackUp,
}

UIWorldTileTopBtnImage = {}
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Share] = "Assets/Main/Sprites/UI/UISearch/UISearch_btn_link"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Book] = "Assets/Main/Sprites/UI/UISearch/UISearch_btn_collect"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.Emoji] = "Assets/Main/Sprites/UI/Common/New/Common_btn_meme"
UIWorldTileTopBtnImage[UIWorldTileTopBtnType.PackUp] = "Assets/Main/Sprites/UI/Common/New/Common_btn_recycle"

--排序规则 大的在右边
WorldTileBtnType = {
    Furnace = 0, -- 熔炉
    City_Repair = 1, --- 维修
    City_Robot_Set = 2,--设置机器人
    AssistanceSeasonBuild = 3,--援助赛季建筑
    City_Details = 4, -- 建筑详情
    City_Assistance = 5, --援助
    City_Upgrade = 6, -- 城市升级
    City_MyProfile = 7, -- 我的详情
    City_Attack = 8, -- 攻击
    City_Science = 10, --科研
    City_Call = 11, --呼叫直升机
    City_QiFei = 12, --起飞
    City_SpeedUp = 13, --加速建造
    March_ViewTroop = 14, --查看行军部队
    March_SpeedUp = 15, --行军加速
    March_Callback = 16, --行军召回
    March_Rally = 17, --集结
    March_Attack = 18, --攻击
    City_PickUp = 19, --收起建筑
    City_Recovery = 20, --治疗伤兵
    City_ColdCapacity = 22, --冷库
    City_IntegratedWarehouse = 23, --综合仓库
    City_ResourceTransport = 24, --资源运输
    City_SpeedUpTrain = 25, --加速训练
    City_SpeedUpScience = 26, --加速科技
    City_SpeedUpHospital = 27, --加速治疗
    City_TrainingAircraft = 28, --训练飞机
    City_TrainingInfantry = 29, --训练机器人
    City_TrainingTank = 30, --训练坦克
    City_Defence = 31, --防守编队
    Poster_Exchange = 32, --英雄海报兑换勋章
    Hero_Advance = 33, --英雄进阶
    --Hero_Bag = 33, --英雄背包
    City_BatteryrAttack = 34, --炮台攻击
    City_Garrison = 35, --炮台驻扎
    WormHole_Enter = 36, --进入虫洞
    RadarCenter_Alert = 37, --雷达中心预警
    RadarCenter_Detective = 38, --雷达中心探测
    AllianceResSupport = 39, --资源援助
    AllianceEntrance = 40,--联盟入口
    AllianceBattle = 41,--联盟战争
    ARMY = 44,--部队
    WormHole_Create = 45, --虫洞创造
    WormHole_Dismantle = 46, --虫洞拆除
    GolloesCamp = 47,--咕噜营地
    City_GROCERY_STORE = 48,--杂货店订单
    Hero_Station = 49,--英雄驻扎
    City_SpeedUpRuins = 50, --加速建造废墟
    --GarageRefit = 53, --车库改造
    PoliceStation=54,--警察局入口
    --WorldTrend = 55,--天下大势
    WormHoleToB = 56,--虫洞前往B口
    WormHoleToC = 57,--虫洞前往C口
    CommonShop = 59, --通用商店
    HeroResetShop = 60,--海报商店
    WorldNews = 61,--世界新闻
    Talent = 62,--天赋
    HeroBounty = 63,--英雄悬赏
    HeroOfficial = 64,--英雄官职
    CrossWormHoleEnter= 67,--进入跨服虫洞
    Hero_Recruit = 70, --英雄招募
    Poster_Exchange = 71, --英雄海报兑换勋章
    Decoration = 72, --皮肤
    SeasonBuildPickUp = 73,--收起城内建筑

    GarageEquipment = 75, --装备
    GarageRefit = 76, --车库改造

    EquipmentBag = 77, --装备仓库
    CrossWormHero = 79, --跨服虫洞进驻英雄
    DesertOperate = 80,
    HeroMedalShop = 81, --英雄勋章商店
    City_TrainingTrap = 83, --训练陷阱
    BuildNitrogen = 84,
    DefenceSuitEquipment = 85,--
    DefenceSuitEquipmentCross = 86,--
    HeroMetalRedemption = 92, --英雄海报兑换代币
    HeroEquip = 93, --英雄装备
}

WorldTileBtnTypeImage = {}
WorldTileBtnTypeImage[WorldTileBtnType.City_Repair] = "uibuild_btn_repair"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpRuins] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_MyProfile] = "uibuild_btn_info_des"
WorldTileBtnTypeImage[WorldTileBtnType.City_Attack] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_Upgrade] = "uibuild_btn_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_Science] = "uibuild_btn_science"
WorldTileBtnTypeImage[WorldTileBtnType.City_Call] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_QiFei] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUp] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_Recovery] = "uibuild_btn_repair"
WorldTileBtnTypeImage[WorldTileBtnType.March_ViewTroop] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_SpeedUp] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.March_Callback] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_Rally] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.March_Attack] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_PickUp] = "uibuild_btn_pickup"
WorldTileBtnTypeImage[WorldTileBtnType.City_Details] = "uibuild_btn_info_des"
WorldTileBtnTypeImage[WorldTileBtnType.City_ColdCapacity] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Advance] = "UIreset_icon_degree"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Recruit] = "UIreset_icon_recruit"
WorldTileBtnTypeImage[WorldTileBtnType.City_IntegratedWarehouse] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_ResourceTransport] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpTrain] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpScience] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_SpeedUpHospital] = "uibuild_btn_speed_up"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingAircraft] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingInfantry] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingTank] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_TrainingTrap] = "uibuild_btn_trap"
WorldTileBtnTypeImage[WorldTileBtnType.City_Defence] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.City_BatteryrAttack] = "uibuild_btn_infantry"
WorldTileBtnTypeImage[WorldTileBtnType.City_Garrison] = "uibuild_btn_tank"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Enter] = "uibuild_btn_transmit"
WorldTileBtnTypeImage[WorldTileBtnType.City_Assistance] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.RadarCenter_Alert] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.RadarCenter_Detective] = "uibuild_btn_detect_event"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceResSupport] = "uibuild_btn_al_help"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceEntrance] = "uibuild_btn_al_entrance"
WorldTileBtnTypeImage[WorldTileBtnType.AllianceBattle] = "uibuild_btn_al_battle"
WorldTileBtnTypeImage[WorldTileBtnType.City_GROCERY_STORE] = "uibuild_btn_build"
WorldTileBtnTypeImage[WorldTileBtnType.City_Robot_Set] = "uibuild_btn_robot"
WorldTileBtnTypeImage[WorldTileBtnType.ARMY] = "uibuild_btn_al_troop"
WorldTileBtnTypeImage[WorldTileBtnType.WorldNews] = "uibuild_btn_worldNews"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Create] = "uibuild_btn_xiujian"
WorldTileBtnTypeImage[WorldTileBtnType.WormHole_Dismantle] = "uibuild_btn_chaichu"
WorldTileBtnTypeImage[WorldTileBtnType.WormHoleToB] = "uibuild_btn_shachong_b"
WorldTileBtnTypeImage[WorldTileBtnType.WormHoleToC] = "uibuild_btn_shachong_c"
WorldTileBtnTypeImage[WorldTileBtnType.GolloesCamp] = "uibuild_btn_golloesCamp"
WorldTileBtnTypeImage[WorldTileBtnType.Hero_Station] = "uibuild_btn_hero_station"
WorldTileBtnTypeImage[WorldTileBtnType.CommonShop] = "uibuild_btn_commonShop"
WorldTileBtnTypeImage[WorldTileBtnType.GarageRefit] = "uibuild_btn_garagerefit"
WorldTileBtnTypeImage[WorldTileBtnType.PoliceStation] = "uibuild_btn_police_station"
--WorldTileBtnTypeImage[WorldTileBtnType.WorldTrend] = "uibuild_btn_mars"
WorldTileBtnTypeImage[WorldTileBtnType.Talent] = "uibuild_btn_Talent"
WorldTileBtnTypeImage[WorldTileBtnType.HeroResetShop] = "uibuild_btn_heroShop"
WorldTileBtnTypeImage[WorldTileBtnType.HeroBounty] = "uibuild_btn_reward"
WorldTileBtnTypeImage[WorldTileBtnType.HeroOfficial] = "uibuild_btn_hero_official"
WorldTileBtnTypeImage[WorldTileBtnType.CrossWormHoleEnter] = "uibuild_btn_cross"
WorldTileBtnTypeImage[WorldTileBtnType.CrossWormHero] = "uibuild_btn_defences"
WorldTileBtnTypeImage[WorldTileBtnType.Decoration] = "uibuild_btn_skin"
WorldTileBtnTypeImage[WorldTileBtnType.Poster_Exchange] = "uibuild_btn_badge"
WorldTileBtnTypeImage[WorldTileBtnType.SeasonBuildPickUp] = "uibuild_btn_pickup"
WorldTileBtnTypeImage[WorldTileBtnType.AssistanceSeasonBuild] = "uibuild_btn_reinforce"
WorldTileBtnTypeImage[WorldTileBtnType.DesertOperate] = "uibuild_btn_operate"
WorldTileBtnTypeImage[WorldTileBtnType.GarageEquipment] = "common_btn_formation"
WorldTileBtnTypeImage[WorldTileBtnType.EquipmentBag] = "common_btn_formation"
WorldTileBtnTypeImage[WorldTileBtnType.HeroMedalShop] = "common_btn_exchange"
WorldTileBtnTypeImage[WorldTileBtnType.BuildNitrogen] = "uibuild_btn_nitrogen"
WorldTileBtnTypeImage[WorldTileBtnType.DefenceSuitEquipment] = "common_btn_formation"
WorldTileBtnTypeImage[WorldTileBtnType.DefenceSuitEquipmentCross] = "common_btn_formation"
WorldTileBtnTypeImage[WorldTileBtnType.HeroMetalRedemption] = "uibuild_btn_plugin"
WorldTileBtnTypeImage[WorldTileBtnType.Furnace] = "uibuild_btn_temperature"
WorldTileBtnTypeImage[WorldTileBtnType.HeroEquip] = "uibuild_btn_hero_equip"

WorldTileBtnTypName = {}
WorldTileBtnTypName[WorldTileBtnType.City_Details] = 100092
WorldTileBtnTypName[WorldTileBtnType.City_Upgrade] = 100091
WorldTileBtnTypName[WorldTileBtnType.SeasonBuildPickUp] = 104319
WorldTileBtnTypName[WorldTileBtnType.AssistanceSeasonBuild] = 300516
WorldTileBtnTypName[WorldTileBtnType.DesertOperate] = 110728
WorldTileBtnTypName[WorldTileBtnType.WormHole_Create] = 104317
WorldTileBtnTypName[WorldTileBtnType.WormHole_Dismantle] = 130242
WorldTileBtnTypName[WorldTileBtnType.WormHole_Enter] = 104318
WorldTileBtnTypName[WorldTileBtnType.CrossWormHoleEnter] = 143584
WorldTileBtnTypName[WorldTileBtnType.CrossWormHero] = 143655
WorldTileBtnTypName[WorldTileBtnType.City_SpeedUp] = 100159
WorldTileBtnTypName[WorldTileBtnType.BuildNitrogen] = 143677
WorldTileBtnTypName[WorldTileBtnType.City_Recovery] = 150086
WorldTileBtnTypName[WorldTileBtnType.DefenceSuitEquipmentCross] = 270000
WorldTileBtnTypName[WorldTileBtnType.City_TrainingInfantry] = 130061
WorldTileBtnTypName[WorldTileBtnType.City_TrainingAircraft] = 130061
WorldTileBtnTypName[WorldTileBtnType.City_TrainingTank] = 130061
WorldTileBtnTypName[WorldTileBtnType.City_Science] = 100094
WorldTileBtnTypName[WorldTileBtnType.AllianceEntrance] = 241023
WorldTileBtnTypName[WorldTileBtnType.CommonShop] = 104241
WorldTileBtnTypName[WorldTileBtnType.GarageRefit] = 450036
WorldTileBtnTypName[WorldTileBtnType.City_SpeedUpTrain] = 100159
WorldTileBtnTypName[WorldTileBtnType.City_SpeedUpHospital] = 100159
WorldTileBtnTypName[WorldTileBtnType.City_SpeedUpScience] = 100159
WorldTileBtnTypName[WorldTileBtnType.HeroBounty] = 132200
WorldTileBtnTypName[WorldTileBtnType.HeroEquip] = 321471

WorldPointBtnType =
{
    PlayerInfo = -3,
    Decoration = -2,
    Detail = -1,
    None =0,
    AttackMonster = 1,
    RallyBoss = 2,
    AttackCity = 3,
    AttackBuild =4,
    RallyCity = 6,
    RallyBuild = 7,
    AssistanceCity = 8,
    AssistanceBuild = 9,
    ScoutCity = 10,
    ScoutBuild = 11,
    ScoutArmyCollect = 12,
    ResourceHelp = 13,
    Collect = 14,
    CallBack = 15,
    AttackArmyCollect = 16,
    Search = 17,
    Explore = 18,
    GetReward =19,
    Sample = 20,
    PickGarbage = 21,
    SingleMapGarbage = 22,
    BlackKnight = 24,--黑骑士活动
    AllianceCollect = 25,
    TransPos = 26,
    AttackActBoss = 27,
    CheckActBossRank = 28,
    DeclareWar = 29,
    AttackPuzzleBoss = 31,
    CheckPuzzleBossRank = 32,
    ChallengeHelp = 33,
    AttackActChallenge = 34,
    GoBackToCity = 35,
    AssistanceDesert = 36,
    DesertBuildList = 37,
    AttackDesert = 38,
    ScoutDesert = 39,
    GiveUpDesert = 40,
    CancelGiveUpDesert = 41,
    CheckDesert = 42,
    AllianceMine_Construct = 43,
    AllianceMine_Collect = 44,
    AllianceMineDetail = 45,
    AllianceMineCallback = 46,
    TrainDesert = 47,
    GuideEventMonster = 48,--引导世界事件怪
    AttackAllianceBuild = 49,
    ScoutAllianceBuild = 50,
    AssistanceAllianceBuild  =51,
    RallyAllianceBuild = 52,
    ReBuildAllianceRuin = 53,
    BuildAllianceCenter = 54,
    City_Defence = 55, --防守编队
    FoldUpAllianceBuild = 56,
    AppointPosition = 57,
    RallyThrone = 58,
    RallyAssistanceThrone = 59,
    ScoutThrone = 60,
    DonateSoldier = 61,--捐兵活动
    DesertOperate = 62,
    ALVSDonateSoldier = 63,--新捐兵活动
    Missile = 64,--导弹
    AttackAllianceBoss = 65,
    AllianceBossRank = 66,
    AllianceActMineDetail = 67,
    AllianceActMine_Collect = 68,
    AttackAllianceActMine = 69,
    RallyAllianceActMine = 70,
    ScoutAllianceActMine = 71,
    AttackDragonBuild = 72,
    ScoutDragonBuild = 73,
    AssistanceDragonBuild  =74,
    GetSecretKey = 75,
    Emotion = 76,
    AllianceCityRank = 81,
    EdenAllianceMissile = 82,
    DispatchTask = 83,-- 派遣任务
    DispatchTaskHelp = 84,  -- 派遣任务帮助
    DispatchTaskSteal = 85, -- 派遣任务偷取
    HelperDetect = 86,-- 帮助雷达事件
    RecuseDetect = 87,-- 救援雷达事件
}

--按钮顺序以后放在这里,号段间隔预留位置
WorldPointBtnSortType = {}
WorldPointBtnSortType[WorldPointBtnType.Emotion] = -4
WorldPointBtnSortType[WorldPointBtnType.PlayerInfo] = -3
WorldPointBtnSortType[WorldPointBtnType.Decoration] = -2
WorldPointBtnSortType[WorldPointBtnType.Detail] = -1
WorldPointBtnSortType[WorldPointBtnType.None] = 0
WorldPointBtnSortType[WorldPointBtnType.AttackMonster] = 10
WorldPointBtnSortType[WorldPointBtnType.RallyBoss] = 20
WorldPointBtnSortType[WorldPointBtnType.AttackCity] = 30
WorldPointBtnSortType[WorldPointBtnType.AttackBuild] = 40
WorldPointBtnSortType[WorldPointBtnType.RallyCity] = 60
WorldPointBtnSortType[WorldPointBtnType.RallyBuild] = 70
WorldPointBtnSortType[WorldPointBtnType.AssistanceCity] = 80
WorldPointBtnSortType[WorldPointBtnType.AssistanceBuild] = 90
WorldPointBtnSortType[WorldPointBtnType.ScoutCity] = 100
WorldPointBtnSortType[WorldPointBtnType.ScoutBuild] = 110
WorldPointBtnSortType[WorldPointBtnType.ScoutArmyCollect] = 120
WorldPointBtnSortType[WorldPointBtnType.ResourceHelp] = 130
WorldPointBtnSortType[WorldPointBtnType.Collect] = 140
WorldPointBtnSortType[WorldPointBtnType.CallBack] = 150
WorldPointBtnSortType[WorldPointBtnType.AttackArmyCollect] = 160
WorldPointBtnSortType[WorldPointBtnType.Search] = 170
WorldPointBtnSortType[WorldPointBtnType.Explore] = 180
WorldPointBtnSortType[WorldPointBtnType.GetReward] = 190
WorldPointBtnSortType[WorldPointBtnType.Sample] = 200
WorldPointBtnSortType[WorldPointBtnType.PickGarbage] = 210
WorldPointBtnSortType[WorldPointBtnType.SingleMapGarbage] = 220
WorldPointBtnSortType[WorldPointBtnType.BlackKnight] = 240
WorldPointBtnSortType[WorldPointBtnType.AllianceCollect] = 250
WorldPointBtnSortType[WorldPointBtnType.TransPos] = 260
WorldPointBtnSortType[WorldPointBtnType.AttackActBoss] = 270
WorldPointBtnSortType[WorldPointBtnType.CheckActBossRank] = 280
WorldPointBtnSortType[WorldPointBtnType.DeclareWar] = 290
WorldPointBtnSortType[WorldPointBtnType.AttackPuzzleBoss] = 310
WorldPointBtnSortType[WorldPointBtnType.CheckPuzzleBossRank] = 320
WorldPointBtnSortType[WorldPointBtnType.ChallengeHelp] = 330
WorldPointBtnSortType[WorldPointBtnType.AttackActChallenge] = 340
WorldPointBtnSortType[WorldPointBtnType.GoBackToCity] = 350
WorldPointBtnSortType[WorldPointBtnType.AssistanceDesert] = 360
WorldPointBtnSortType[WorldPointBtnType.TrainDesert] = 370
WorldPointBtnSortType[WorldPointBtnType.DesertBuildList] = 380
WorldPointBtnSortType[WorldPointBtnType.AttackDesert] = 390
WorldPointBtnSortType[WorldPointBtnType.ScoutDesert] = 400
WorldPointBtnSortType[WorldPointBtnType.GiveUpDesert] = 410
WorldPointBtnSortType[WorldPointBtnType.CancelGiveUpDesert] = 420
WorldPointBtnSortType[WorldPointBtnType.CheckDesert] = 430
WorldPointBtnSortType[WorldPointBtnType.AllianceMine_Construct] = 440
WorldPointBtnSortType[WorldPointBtnType.AllianceMine_Collect] = 450
WorldPointBtnSortType[WorldPointBtnType.AllianceMineDetail] = 460
WorldPointBtnSortType[WorldPointBtnType.AllianceMineCallback] = 470
WorldPointBtnSortType[WorldPointBtnType.GuideEventMonster] = 480
WorldPointBtnSortType[WorldPointBtnType.AttackAllianceBuild] = 490
WorldPointBtnSortType[WorldPointBtnType.ScoutAllianceBuild] = 500
WorldPointBtnSortType[WorldPointBtnType.AssistanceAllianceBuild] = 510
WorldPointBtnSortType[WorldPointBtnType.RallyAllianceBuild] = 520
WorldPointBtnSortType[WorldPointBtnType.ReBuildAllianceRuin] = 530
WorldPointBtnSortType[WorldPointBtnType.BuildAllianceCenter] = 540
WorldPointBtnSortType[WorldPointBtnType.City_Defence] = 550
WorldPointBtnSortType[WorldPointBtnType.FoldUpAllianceBuild] = 560
WorldPointBtnSortType[WorldPointBtnType.AppointPosition] = 570
WorldPointBtnSortType[WorldPointBtnType.RallyThrone] = 580
WorldPointBtnSortType[WorldPointBtnType.RallyAssistanceThrone] = 590
WorldPointBtnSortType[WorldPointBtnType.ScoutThrone] = 600
WorldPointBtnSortType[WorldPointBtnType.DonateSoldier] = 610
WorldPointBtnSortType[WorldPointBtnType.DesertOperate] = 620
WorldPointBtnSortType[WorldPointBtnType.Missile] = 630
WorldPointBtnSortType[WorldPointBtnType.EdenAllianceMissile] = 635
WorldPointBtnSortType[WorldPointBtnType.AttackAllianceBoss] = 640
WorldPointBtnSortType[WorldPointBtnType.AllianceBossRank] = 650
WorldPointBtnSortType[WorldPointBtnType.AllianceActMineDetail] = 700
WorldPointBtnSortType[WorldPointBtnType.AllianceActMine_Collect] = 710
WorldPointBtnSortType[WorldPointBtnType.AttackAllianceActMine] = 720
WorldPointBtnSortType[WorldPointBtnType.RallyAllianceActMine] = 730
WorldPointBtnSortType[WorldPointBtnType.ScoutAllianceActMine] = 740
WorldPointBtnSortType[WorldPointBtnType.AssistanceDragonBuild] = 750
WorldPointBtnSortType[WorldPointBtnType.AttackDragonBuild] = 760
WorldPointBtnSortType[WorldPointBtnType.ScoutDragonBuild] = 770
WorldPointBtnSortType[WorldPointBtnType.GetSecretKey] = 780
WorldPointBtnSortType[WorldPointBtnType.AllianceCityRank] = 810
WorldPointBtnSortType[WorldPointBtnType.DispatchTask] = 830
WorldPointBtnSortType[WorldPointBtnType.DispatchTaskHelp] = 840
WorldPointBtnSortType[WorldPointBtnType.DispatchTaskSteal] = 850
WorldPointBtnSortType[WorldPointBtnType.HelperDetect] = 860
WorldPointBtnSortType[WorldPointBtnType.RecuseDetect] = 870

WorldPointBtnTypeImage = {}
WorldPointBtnTypeImage[WorldPointBtnType.AttackMonster] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackCity] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackDesert] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAllianceBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.TrainDesert] = "uibuild_btn_saodang"
WorldPointBtnTypeImage[WorldPointBtnType.AttackArmyCollect] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.RallyBoss] = "uibuild_btn_rally"
WorldPointBtnTypeImage[WorldPointBtnType.RallyCity] = "uibuild_btn_rally"
WorldPointBtnTypeImage[WorldPointBtnType.RallyBuild] = "uibuild_btn_rally"
WorldPointBtnTypeImage[WorldPointBtnType.RallyAllianceBuild] = "uibuild_btn_rally"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceCity] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceBuild] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceDesert] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceAllianceBuild] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.AssistanceDragonBuild] = "uibuild_btn_reinforce"
WorldPointBtnTypeImage[WorldPointBtnType.FoldUpAllianceBuild] = "uibuild_btn_pickup"
WorldPointBtnTypeImage[WorldPointBtnType.DesertOperate] = "uibuild_btn_operate"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutCity] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutArmyCollect] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutDesert] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutAllianceBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.ResourceHelp] = "uibuild_btn_help"
WorldPointBtnTypeImage[WorldPointBtnType.Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceCollect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.CallBack] = "uibuild_btn_return"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMine_Construct] = "uibuild_btn_xiujian"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMine_Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMineDetail] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.Search] = "uibuild_btn_search"
WorldPointBtnTypeImage[WorldPointBtnType.Explore] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.GetReward] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.Sample] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.PickGarbage] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.SingleMapGarbage] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.Detail] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.TransPos] = "uibuild_btn_aircraft"
WorldPointBtnTypeImage[WorldPointBtnType.AttackActBoss] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.CheckActBossRank] = "uibuild_btn_bossRank"
WorldPointBtnTypeImage[WorldPointBtnType.DeclareWar] = "uibuild_btn_declare"
WorldPointBtnTypeImage[WorldPointBtnType.AttackPuzzleBoss] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.CheckPuzzleBossRank] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceCityRank] = "uibuild_btn_bossreward"
WorldPointBtnTypeImage[WorldPointBtnType.AttackActChallenge] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ChallengeHelp] = "uibuild_btn_alliancehelp"
WorldPointBtnTypeImage[WorldPointBtnType.GoBackToCity] = "uibuild_btn_maincity"
WorldPointBtnTypeImage[WorldPointBtnType.GiveUpDesert] = "uibuild_btn_dismantle"
WorldPointBtnTypeImage[WorldPointBtnType.CancelGiveUpDesert] = "uibuild_btn_canceldismantle"
WorldPointBtnTypeImage[WorldPointBtnType.CheckDesert] = "uibuild_btn_level_explore"
WorldPointBtnTypeImage[WorldPointBtnType.Decoration] = "uibuild_btn_skin"
WorldPointBtnTypeImage[WorldPointBtnType.PlayerInfo] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.DesertBuildList] = "uibuild_btn_tacticalbuilding"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMine_Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceMineCallback] = "uibuild_btn_return"
WorldPointBtnTypeImage[WorldPointBtnType.GuideEventMonster] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ReBuildAllianceRuin] = "uibuild_btn_repair"
WorldPointBtnTypeImage[WorldPointBtnType.BuildAllianceCenter] = "uibuild_btn_tacticalbuilding_r4"
WorldPointBtnTypeImage[WorldPointBtnType.City_Defence] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.BlackKnight] = "uibuild_btn_jump"
WorldPointBtnTypeImage[WorldPointBtnType.DonateSoldier] = "uibuild_btn_jump"

WorldPointBtnTypeImage[WorldPointBtnType.AppointPosition] = "uibuild_btn_jump"
WorldPointBtnTypeImage[WorldPointBtnType.RallyThrone] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.RallyAssistanceThrone] = "uibuild_btn_defences"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutThrone] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.Missile] = "uibuild_btn_daodan_purple"
WorldPointBtnTypeImage[WorldPointBtnType.EdenAllianceMissile] = "uibuild_btn_daodan_purple"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceBossRank] = "uibuild_btn_bossRank"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAllianceBoss] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTask] = "lyp_daditu_paiqian"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTaskHelp] = "od_zhujiemian_yuanzhu"
WorldPointBtnTypeImage[WorldPointBtnType.DispatchTaskSteal] = "od_zhujiemian_touqu"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceActMineDetail] = "uibuild_btn_info_des"
WorldPointBtnTypeImage[WorldPointBtnType.AllianceActMine_Collect] = "uibuild_btn_collect"
WorldPointBtnTypeImage[WorldPointBtnType.AttackAllianceActMine] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.RallyAllianceActMine] = "uibuild_btn_rally"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutAllianceActMine] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.AttackDragonBuild] = "uibuild_btn_attack"
WorldPointBtnTypeImage[WorldPointBtnType.ScoutDragonBuild] = "uibuild_btn_scout"
WorldPointBtnTypeImage[WorldPointBtnType.GetSecretKey] = "uibuild_btn_help"
WorldPointBtnTypeImage[WorldPointBtnType.Emotion] = "uibuild_btn_emotion"
WorldPointBtnTypeImage[WorldPointBtnType.HelperDetect] = "od_zhujiemian_yuanzhu"
WorldPointBtnTypeImage[WorldPointBtnType.RecuseDetect] = "od_zhujiemian_yuanzhu"

WorldPointBtnName = {}
WorldPointBtnName[WorldPointBtnType.AttackMonster] = 100150
WorldPointBtnName[WorldPointBtnType.AttackCity] = 100150
WorldPointBtnName[WorldPointBtnType.AttackBuild] = 100150
WorldPointBtnName[WorldPointBtnType.AttackDesert] = 100150
WorldPointBtnName[WorldPointBtnType.AttackAllianceActMine] = 100150
WorldPointBtnName[WorldPointBtnType.AttackAllianceBuild] = 100150
WorldPointBtnName[WorldPointBtnType.AttackDragonBuild] = 100150
WorldPointBtnName[WorldPointBtnType.TrainDesert] = 302253
WorldPointBtnName[WorldPointBtnType.AttackArmyCollect] = 100150
WorldPointBtnName[WorldPointBtnType.RallyBoss] = 300038
WorldPointBtnName[WorldPointBtnType.RallyCity] = 300038
WorldPointBtnName[WorldPointBtnType.RallyBuild] = 300038
WorldPointBtnName[WorldPointBtnType.RallyAllianceActMine] = 300038
WorldPointBtnName[WorldPointBtnType.RallyAllianceBuild] = 300038
WorldPointBtnName[WorldPointBtnType.AssistanceCity] = 300516
WorldPointBtnName[WorldPointBtnType.AssistanceBuild] = 300516
WorldPointBtnName[WorldPointBtnType.AssistanceDesert] = 300516
WorldPointBtnName[WorldPointBtnType.AssistanceAllianceBuild] = 300516
WorldPointBtnName[WorldPointBtnType.AssistanceDragonBuild] = 300516
WorldPointBtnName[WorldPointBtnType.FoldUpAllianceBuild] = 104319
WorldPointBtnName[WorldPointBtnType.DesertOperate] = 110728
WorldPointBtnName[WorldPointBtnType.ScoutCity] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutBuild] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutArmyCollect] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutDesert] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutAllianceBuild] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutAllianceActMine] = 300037
WorldPointBtnName[WorldPointBtnType.ScoutDragonBuild] = 300037
--WorldPointBtnName[WorldPointBtnType.ResourceHelp] = "uibuild_btn_help"
WorldPointBtnName[WorldPointBtnType.Collect] = 128012
WorldPointBtnName[WorldPointBtnType.AllianceCollect] = 128012
WorldPointBtnName[WorldPointBtnType.CallBack] = 300520
WorldPointBtnName[WorldPointBtnType.AllianceMine_Construct] = 110015
WorldPointBtnName[WorldPointBtnType.AllianceMine_Collect] = 128012
WorldPointBtnName[WorldPointBtnType.AllianceMineDetail] = 100092
WorldPointBtnName[WorldPointBtnType.AllianceActMine_Collect] = 128012
WorldPointBtnName[WorldPointBtnType.AllianceActMineDetail] = 100092
WorldPointBtnName[WorldPointBtnType.Search] = 100192
WorldPointBtnName[WorldPointBtnType.Explore] = 100150
WorldPointBtnName[WorldPointBtnType.GetReward] = 128012
WorldPointBtnName[WorldPointBtnType.Sample] = 128012
WorldPointBtnName[WorldPointBtnType.PickGarbage] = 128012
WorldPointBtnName[WorldPointBtnType.SingleMapGarbage] = 128012
WorldPointBtnName[WorldPointBtnType.Detail] = 100092
--WorldPointBtnName[WorldPointBtnType.TransPos] = "uibuild_btn_aircraft"
WorldPointBtnName[WorldPointBtnType.AttackActBoss] = 100150
WorldPointBtnName[WorldPointBtnType.CheckActBossRank] = 390040
WorldPointBtnName[WorldPointBtnType.DeclareWar] = 302812
WorldPointBtnName[WorldPointBtnType.AttackPuzzleBoss] = 100150
WorldPointBtnName[WorldPointBtnType.CheckPuzzleBossRank] = 130065
WorldPointBtnName[WorldPointBtnType.AllianceCityRank] = 130065
WorldPointBtnName[WorldPointBtnType.AttackActChallenge] = 100150
WorldPointBtnName[WorldPointBtnType.ChallengeHelp] = 372472
WorldPointBtnName[WorldPointBtnType.GoBackToCity] = 104315
WorldPointBtnName[WorldPointBtnType.GiveUpDesert] = 130242
WorldPointBtnName[WorldPointBtnType.CancelGiveUpDesert] = 110106
WorldPointBtnName[WorldPointBtnType.Decoration] = 320557
WorldPointBtnName[WorldPointBtnType.PlayerInfo] = 100092
WorldPointBtnName[WorldPointBtnType.DesertBuildList] = 110015
WorldPointBtnName[WorldPointBtnType.AllianceMine_Collect] = 128012
WorldPointBtnName[WorldPointBtnType.AllianceMineCallback] = 300520
WorldPointBtnName[WorldPointBtnType.GuideEventMonster] = 100150
WorldPointBtnName[WorldPointBtnType.BlackKnight] = 372700
WorldPointBtnName[WorldPointBtnType.DonateSoldier] = 372700
--WorldPointBtnName[WorldPointBtnType.ReBuildAllianceRuin] = "uibuild_btn_repair"
--WorldPointBtnName[WorldPointBtnType.BuildAllianceCenter] = "uibuild_btn_tacticalbuilding_r4"
WorldPointBtnName[WorldPointBtnType.City_Defence] = 104321
WorldPointBtnName[WorldPointBtnType.AppointPosition] = 250005
WorldPointBtnName[WorldPointBtnType.RallyThrone] = 300038
WorldPointBtnName[WorldPointBtnType.RallyAssistanceThrone] = 300516
WorldPointBtnName[WorldPointBtnType.ScoutThrone] = 300037
WorldPointBtnName[WorldPointBtnType.Missile] = 300037
WorldPointBtnName[WorldPointBtnType.AllianceBossRank] = 390040
WorldPointBtnName[WorldPointBtnType.AttackAllianceBoss] = 100150
WorldPointBtnName[WorldPointBtnType.GetSecretKey] = 100547
WorldPointBtnName[WorldPointBtnType.Emotion] = 111080
WorldPointUIType =
{
    None=0,
    Monster=1,
    Boss=2,
    City=3,
    Build=4,
    CollectPoint=5,
    CollectArmy=6,
    Explore = 8,
    MonsterReward = 9,
    Sample = 10,
    PickGarbage = 11,
    SingleMapGarbage = 12,
    -- 13
    AllianceCollectPoint = 14,
    ActBoss = 15,

    PuzzleBoss = 17,
    ChallengeBoss = 18,
    CityResPoint = 19,
    Desert =20,
    AllianceMine = 21,
    GuideEventMonster = 22,
    AllianceBuild = 23,
    Ruin = 24,
    AllianceBoss = 25,
    AllianceActMine = 26,
    DragonBuild = 27, --巨龙中立建筑
    DragonSecretKey = 28, --密钥
    DispatchTask = 29,  --派遣任务
}

WorldBuildTopBubbleType = {
    None = 0,
    HelperDetect = 2,
}

WorldBuildTopBubbleTypeData = {
    [WorldBuildTopBubbleType.HelperDetect] = {
        assert = "Assets/Main/Prefabs/March/WorldHelperDetectInfo.prefab",
        script = "Scene.BuildTopBubble.HelperDetectWorldBuildBubble",
    },
}

WorldMarchTileBtnType =
{
    None = 0,
    March_ViewTroop = 1,    -- 查看行军部队
    March_Stop = 2,      -- 暂停
    March_Emotion = 3, -- 表情
    March_Callback = 4,     -- 召回
    March_Rally = 5,      -- 集结
    March_Attack = 6,       -- 攻击
    March_Scout = 7,        --侦查
    March_Speed = 8,        --行军加速
    March_Operate = 9,--行军专精操作
}
WorldMarchBtnTypeImage = {}
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_ViewTroop] = "uibuild_btn_info_des"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Stop] = "uibuild_btn_station"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Callback] = "uibuild_btn_return"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Rally] = "uibuild_btn_rally"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Attack] = "uibuild_btn_attack"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Scout] = "uibuild_btn_scout"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Speed] = "uibuild_btn_speed_purple"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Operate] = "uibuild_btn_operate"
WorldMarchBtnTypeImage[WorldMarchTileBtnType.March_Emotion] = "uibuild_btn_emotion"
WorldMarchBtnTypeName = {}
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_ViewTroop] = 100092
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Stop] = 400069
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Callback] = 300520
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Rally] = 300038
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Attack] = 100150
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Scout] = 300037
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Speed] = 100159
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Operate] = 110728
WorldMarchBtnTypeName[WorldMarchTileBtnType.March_Emotion] = 111080

--按钮宽度
BtnWidth =
{
    380,320
}

--点击世界需要关闭的世界上UI
ClickWorldNeedCloseWorldUI =
{
    UIWindowNames.UIWorldBlackTile,
    UIWindowNames.UIArrow,
    UIWindowNames.UIWorldExplorePointUI,
    UIWindowNames.UIWorldSamplePointUI,
    UIWindowNames.UIWorldGarbagePointUI,
    UIWindowNames.UIGuideGarbage,
}

--点击UI需要关闭的额外的世界上UI
ClickUINeedCloseExtraWorldUI =
{
    UIWindowNames.UIWorldTileUI,
    UIWindowNames.UIResourceCost,
    UIWindowNames.UIWorldSiegePoint,
    UIWindowNames.UIFormationSelectListNew,
    UIWindowNames.UIQueueList,
    UIWindowNames.UIDayNightChange,
}

--点击UI需要关闭的额外的世界上UI
DragWorldNeedCloseExtraWorldUI =
{
    UIWindowNames.UIWorldSiegePoint,
    UIWindowNames.UIWorldNewsTips,
    UIWindowNames.UIWorldPoint,
    UIWindowNames.UIWorldNewsAbbrDetail,
    UIWindowNames.UIActBossTips,
}

--兵营类建筑对应训练按钮
BarracksBuildToBtnType =
{
    [BuildingTypes.FUN_BUILD_CAR_BARRACK] = WorldTileBtnType.City_TrainingTank,
    [BuildingTypes.FUN_BUILD_INFANTRY_BARRACK] = WorldTileBtnType.City_TrainingInfantry,
    [BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK] = WorldTileBtnType.City_TrainingAircraft,
    [BuildingTypes.FUN_BUILD_TRAP_BARRACK] = WorldTileBtnType.City_TrainingTrap,
}

MessageBarType = {
    Get =0,
    Cost = 1,
    Lack = 2
}


BuildUpgradeUseGoldType =
{
    No = 0,--直接升级
    Yes = 2,--使用钻石升级
    Free = 3,--免费升级
}

WarningType =
{
    Meteorite = 1,--陨石来临
    Attack = 2 ,--攻击
    Scout = 3,--侦查
    Assistance = 4 ,--援助
    ResourceAssistance = 5,--资源援助
    AllianceAttack = 6,--集结
}
WarningTypeIcon = {}
WarningTypeIcon[WarningType.Meteorite] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_warning_btn_meteorite"

UIScienceTopBtnType =
{
    Electricity = 1,--资源电
    Money = 2,--资源钱
    Gold = 3,--钻石
}


ScienceType =
{
    Build = 1,
    Alliance = 2,
}

ScienceTabState =
{
    Lock = 0,           --锁住
    UnLock = 1,         --已解锁
    CanUnlock = 2,      --可解锁
    LockShow = 3,--锁定但显示
}


ScienceTabUnlockType =
{
    PreScienceTreePro = 1,       -- 前置科技树进度
    PreScienceLevel   = 2,       -- 前置科技等级
    PreBuildingLevel  = 3,       -- 前置建筑等级
    RequireActivityId = 4,       -- 前置活动id
}

AllianceOfficialPos = {
    Pos1 = 1,
    Pos2 = 2,
    Pos3 = 3,
    Pos4 = 4,
}

AllianceOfficialPosConf = {
    [AllianceOfficialPos.Pos1] = {
        name = 391063,
        icon = "UIallianceposition_icon_Waekord",
        tip = 391067,
    },
    [AllianceOfficialPos.Pos2] = {
        name = 391064,
        icon = "UIallianceposition_icon_recruiter",
        tip = 391068,
    },
    [AllianceOfficialPos.Pos3] = {
        name = 391065,
        icon = "UIallianceposition_icon_Muse",
        tip = 391069,
    },
    [AllianceOfficialPos.Pos4] = {
        name = 391066,
        icon = "UIallianceposition_icon_Butler",
        tip = 391070,
    },
}

MessageBallType = {
    None = 0,
    BuildingUpgrade =1,

    MoneyFull = 11,--金币建筑满
    WaterFull = 12,--水满
    OilFull = 13,--水晶满
    MetalFull = 14,--瓦斯满
    ElectricityFull=15,--电满

    BuildingComplete = 16,--建筑完成，待点击
    SoldierTrainComplete = 17,--士兵训练完成，待点击
    ScienceSearchComplete = 18,--科技完成

    ArmyQueueFree = 19,--兵营队列空闲
    --ScienceQueueFree = 20,--科研队列空闲

    HeroStationWarning = 21,--英雄驻扎效果值增加
    BagMax = 23,
    SeasonQueue = 24,--赛季队列空闲
}

BuildRedDotType =
{
    No = 0,--不显示
    AllShow = 1,--一直显示
    Once = 2,--只显示一次
}

--建筑升级解锁显示类型
BuildLevelUpShowType =
{
    New = 1,--新品
    Unlock = 2,--解锁
    AddNum = 3,--数量增加
}

--建筑升级解锁类型
BuildLevelUpUnlockType =
{
    Build = 1,--
}

ScienceShowTag =
{
    No = 0,
    Recommend = 1,--推荐科技
}

--热销道具类型
ItemHotPage =
{
    No = 0,--不是热销道具
    Yes = 1,--热销道具
}

BagTabSelectImage ={}
BagTabSelectImage[UIBagBtnType.Hot] = "Assets/Main/Sprites/UI/Common/Common_img_freeze_select"
BagTabSelectImage[UIBagBtnType.War] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_select"
BagTabSelectImage[UIBagBtnType.Buff] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_select"
BagTabSelectImage[UIBagBtnType.Resource] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_select"
BagTabSelectImage[UIBagBtnType.Other] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_select"

BagTabUnSelectImage ={}
BagTabUnSelectImage[UIBagBtnType.Hot] = "Assets/Main/Sprites/UI/Common/Common_img_freeze_unselect"
BagTabUnSelectImage[UIBagBtnType.War] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_unselect"
BagTabUnSelectImage[UIBagBtnType.Buff] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_unselect"
BagTabUnSelectImage[UIBagBtnType.Resource] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_unselect"
BagTabUnSelectImage[UIBagBtnType.Other] = "Assets/Main/Sprites/UI/Common/Common_img_warehouse_unselect"

UIBuildQueueState =
{
    None = 0,
    Free = 1,
    Work = 2,
}

BuildNoQueue =
{
    No = 0,--占用
    Yes = 1,--不占用建造队列
}
UICapacityTableResourceType=
{
    ResourceType.Water,
    ResourceType.Electricity,
}

UIBuildQueueEnterType =
{
    None = 0,--无
    Build = 1,--建造
    Upgrade = 2,--升级
    Science = 3,--科技
}

UIMainBuildQueueAnimState =
{
    Empty = 0,--静止
    Free = 1,--空闲
}

UIMainBuildQueueAnimName = {}
UIMainBuildQueueAnimName[UIMainBuildQueueAnimState.Empty] = "BuildQueueEmpty"
UIMainBuildQueueAnimName[UIMainBuildQueueAnimState.Free] = "BuildQueueFree"

BuildQueueTalkShowType =
{
    Free = 1,--有空闲时触发
    StartQueue = 2,--开始队列时触发
    EndQueue = 3,--结束队列时触发
}

UITrainState =
{
    Select = 1,--选择状态
    Training = 2,--正在训练状态
    Lock = 3,--锁住状态
    Upgrade = 4,--晋级状态
    Info = 5,--详情状态
}
UITrainDetailType =
{
    Attack = 1,
    Defense = 2,
    Blood = 3,
    Speed = 4,
    Load = 5,
    Power = 6,
    TrapAttack = 7,
}
UITrainDetailTypeList =
{
    UITrainDetailType.Attack,
    UITrainDetailType.Defense,
    UITrainDetailType.Blood,
    UITrainDetailType.Speed,
    UITrainDetailType.Load,
    UITrainDetailType.Power,
}
UITrainTrapDetailTypeList =
{
    UITrainDetailType.TrapAttack,
    UITrainDetailType.Power,
}
UITrainDetailTypeIcon = {}
UITrainDetailTypeIcon[UITrainDetailType.Attack] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_gongjili"
UITrainDetailTypeIcon[UITrainDetailType.Defense] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_fangyu"
UITrainDetailTypeIcon[UITrainDetailType.Blood] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_shengmingzhi"
UITrainDetailTypeIcon[UITrainDetailType.Speed] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_xingjunsudu"
UITrainDetailTypeIcon[UITrainDetailType.Load] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_fuzai"
UITrainDetailTypeIcon[UITrainDetailType.Power] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_power"
UITrainDetailTypeIcon[UITrainDetailType.TrapAttack] = "Assets/Main/Sprites/UI/UISoildier/SoldierIcons_icon_gongjili"

UISearchType =
{
    Monster = 1,
    Boss = 2,
    Food = 3,
    Wood = 4,
    Electricity = 5,
    Metal = 6,
    Money = 7,
}

WarningBallState =
{
    Free = 0,
    Cold = 1,--冷却
    Wait = 2,--等待
    Show = 3,--显示
    ShowOnce = 4, -- 只显示一次
}

EffectCoupleType =
{
    BASE_ATTACK = 100001,
    BASE_DEFEND = 100002,
    BASE_HEALTH =100003,
    BASE_HEALTH_PERCENT = 100004,
    COLLECT_ATTACK =100101,
    COLLECT_DEFEND =100102,
    OUTSIDE_ATTACK = 100201,
    OUTSIDE_DEFEND = 100202,
    TEAM_ATTACK = 100301,
    TEAM_DEFEND = 100302,
    ATTACK_BUILD_ATTACK = 100401,
    ATTACK_BUILD_DEFEND = 100402,
    STATE_BUILD_ATTACK = 100501,
    STATE_BUILD_DEFEND = 100502,
    ATTACK_MONSTER_ATTACK = 100601,
    ATTACK_MONSTER_DEFEND = 100602,
    ATTACK_ALLIANCE_NEUTRAL_CITY_ATTACK = 100701,
    ATTACK_ALLIANCE_NEUTRAL_CITY_DEFEND = 100702,
}
UIMainResourceSort = {}
--UIMainResourceSort[ResourceType.Wood] = 1
--UIMainResourceSort[ResourceType.Metal] = 2
UIMainResourceSort[ResourceType.Water] = 3
UIMainResourceSort[ResourceType.Electricity] = 4
UIMainResourceSort[ResourceType.Money] = 5

--罗马数字
RomeNum = {}
for i = 1, 1000 do
    RomeNum[i] = NumToRoman(i)
end

--产出资源气泡图片名字
OutResourceTypeIconName = {}
OutResourceTypeIconName[ResourceType.Electricity] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_electricity"
OutResourceTypeIconName[ResourceType.Metal] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_metal"
OutResourceTypeIconName[ResourceType.Oil] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_oil"
OutResourceTypeIconName[ResourceType.Water] = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_water"
OutResourceTypeIconName[ResourceType.Money] = "Assets/Main/Sprites/UI/Common/Common_icon_money"

--时间条切换显示的类型
UIBuildTimeTextShowType =
{
    Time = 1,--时间
    Des = 2,--描述
}

UIResourceCostState =
{
    Normal = 1,--正常状态
    Animation = 2,--做动画
}

WorldPointType =
{
    Other = 0,                     -- 空地
    WorldCollectResource = 1,           -- 世界矿根（玩家资源站建筑用）
    WorldMonster = 4,              --世界怪物
    WorldBoss = 5,                 -- 世界Boss
    PlayerBuilding = 6,            -- 玩家建筑
    WorldResource = 7,             -- 世界资源
    EXPLORE_POINT = 8,             --小队探测点
    SAMPLE_POINT = 9,              --采样点
    GARBAGE = 10,                   --垃圾点
    WORLD_ALLIANCE_CITY =11,      --联盟城市
    MONSTER_REWARD  =12,         --野怪箱子
    SAMPLE_POINT_NEW = 13,      --新采样点
    DETECT_EVENT_PVE = 14,      --雷达pve
    WORLD_ALLIANCE_BUILD = 15,  --联盟建筑
    WorldRuinPoint = 17,        --17废墟
    DRAGON_BUILDING = 18, --巨龙中立建筑
    SECRET_KEY = 19, --密钥
    HERO_DISPATCH = 21,            --英雄派遣任务点
}
PlayerType = {
    PlayerNone = -1, -- 无
    PlayerSelf = 0, -- 自己
    PlayerAlliance = 1, -- 盟友
    PlayerOther = 2, -- 敌人
    PlayerAllianceLeader = 3, -- 盟主
}
UIResourceBagBtnType =
{
    Use = 1,--使用道具
    Buy = 2,--购买并使用
    PickUp = 3,--收取道具
    Build = 4,--去建造
    Go = 5,--跳转
    LackResMode = 6, -- 资源不足情况下跳转

}

--特殊道具id
SpecialItemId =
{
    ITEM_MOVE_RANDOM = "200001",--随机迁城
    ITEM_MOVE_CITY = "200002",--高级迁城
    --ITEM_FREE_MOVE_CITY = 200005,--免费迁城
    ITEM_ALLIANCE_CITY_MOVE = "200005",--联盟迁城
    ITEM_BLACK_DESERT_CITY_MOVE ="200003",--黑土地迁城
}

MoveCityUseItemIds =
{
    --SpecialItemId.ITEM_FREE_MOVE_CITY,
    SpecialItemId.ITEM_MOVE_CITY,
}

--兵种类型
ArmType =
{
    None = 0,
    Tank = 1,--坦克兵种
    Robot = 2,--机器人兵种
    Plane = 3,--飞机兵种
    Trap = 4,--陷阱兵种
}

--收资源建筑气泡状态
BuildGetResourceState =
{
    No = 1,--不显示
    Add = 2,--正在增长
    Full = 3,--满了
}

QuestType =
{
    Main = 1,--主线任务
    Chapter = 2,--章节任务
    Daily = 3,--日常任务
    PVE = 9,--关卡任务
    SeasonChapter = 99,
}

UIMainLeftBottomState =
{
    WarningBall = 1,--显示消息求
    RewardQuest = 2,--显示可以领奖的任务
    ChatAndQuest = 3,--任务和聊天切换
    OnlyChat = 4,--只显示聊天
    radarAlarm = 5, --显示警报
    ChapterReward = 6,--章节礼包领奖
    AllianceWar = 7,--联盟战争
    Quest = 8,--任务
    --HeroStation = 9,--英雄驻扎
    RedPacket = 10,--红包
    AllianceTaskShare = 11,--联盟任务分享
    BubbleQuest = 12,
}

UIMainShowTextType =
{
    Quest = 1,
    Chat = 2,
    radarAlarm = 3,
    RedPacket = 4,
}

UIMainLeftBottomType =
{
    WarningBall = 1,--消息求
    Quest = 2,--任务
    Chat = 3,--任务
    radarAlarm = 4, --雷达警报
    AllianceWar = 5,--联盟战争
    HeroStation = 6,--英雄驻扎
}
CityManageBuffType =
{
    CityFever = 100001, -- 城市狂热
    WarGuard = 100002, -- 战争守护
    GolloesFever = 100003,--咕噜狂热
    GolloesGuard = 100004,--咕噜守护
    DirectAttackCity = 100005, -- 奇袭
    AlCompeteScoreAdd1 = 100006,--联盟军备积分加成1
    AlCompeteScoreAdd2 = 100007,--联盟军备积分加成2
    EdenWarGuard = 100008,
}
CityWarFeverStatu = -- 城市狂热等级 staus表中配置，配置更改这里也要更改
{
    CityWarFeverMin = 500172,
    CityWarFeverMax = 500192,
}


DetectEvenColorImage = {
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_white",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_green",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_blue",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_purple",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_orange",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_golden",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_color_red",
}
DetectEvenColorSpecialImage = {
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
    "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold",
}
DetectEvenSpecialColorImage = {
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_white",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_green",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_blue",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_purple",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_orange",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_golden",
    "Assets/Main/Sprites/UI/UIRadarCenter/UIDetectEven_img_special_color_red",
}

DetectEventState = {
    DETECT_EVENT_STATE_NOT_FINISH = 0, --未完成
    DETECT_EVENT_STATE_FINISHED = 1, --已完成未领奖励
    DETECT_EVENT_STATE_REWARDED = 2, --已领奖
}

ScoutReportVisibleState = {
    DEFAULT = 0,
    ENABLE = 1,
    DISABLE = 2,
    NOT_MATCH = 3,
}

--建造队列获取方式
BuildQueueUnlockType =
{
    Free = 0,--免费 永久解锁
    Gold = 1,--钻石解锁
    Building = 2,--建筑永久解锁
    Other = 3,--其他(不主动解锁)
}

--坐标类型
PositionType =
{
    World = 1,--世界坐标
    Screen = 2,--屏幕坐标
    PointId = 3,--坐标id
}

ArrowType =
{
    Normal = 0,
    Monster = 1,--指示野怪
    Capacity = 2,--指示仓库里面的cell
    Building =3, -- 指示建筑
    Guide_Garbage = 4, --新手期间垃圾
    BuildBox = 5,--建筑升级盒子
    Chapter = 8,--章节任务
    LackResource = 10,--升级界面缺少资源
    ChapterGetReward = 11, --章节任务领奖触发
    WaitTimeChapter = 12, --等待时间过长提示章节
    WaitTimeChapterNew = 13,--等待时间过长提示任务
    CollectMoney = 15,--指向金矿
}

DetectEventType = {
    DetectEventTypeSpecial = 1,
    DetectEventTypeNormal = 2,
    DetectEventRadarRally = 5, -- 雷达集结活动
    DetectEventPickGarbage = 6, -- 纯前台行军表现的捡垃圾
    DetectEventPVE = 7,
    DetectEventTypeBoss = 8,
    HeroTrial = 9,--英雄试炼时间
    SPECIAL_OPS = 10,--10 特别行动
    SWEEP_FIELD = 11,--11 扫荡地块
    OCCUPY_FIELD = 12,--12 占领地块
    GUIDE_PVE_LEVEL = 13,--引导关卡船
    GUIDE_MONSTER = 14,--引导大野怪（胡蒂尔)
    PLOT = 15, --剧情对话
    HELP = 16, --帮助
    RESCUE = 17, --救援
    COLLECT = 18, --采集
}

--引导触发方式
GuideTriggerType =
{
    None = 0,--无
    Quest = 1,--任务领奖触发
    UIPanel = 2 ,--打开界面时触发
    Plot = 3,--剧情触发
    Queue = 4,--队列完成触发
    OwnQueue = 5,--第一次获得队列时触发
    OpenFog = 7,--解锁迷雾触发
    BuildUpgrade = 8,--升级完建筑触发 建筑id，等级；第几个（大于等于等级）
    QuestGoto = 9,--任务跳转触发
    ChapterQuestCanReward = 10,--可领章节任务奖触发
    QuestTriggerBuild = 11,--任务引导建筑建造（无限次触发，下线上线不引导）
    FirstJoinAlliance = 12,--第一次加入联盟引导
    TaskFinish = 13,--任务完成触发
    NoFreeQueue = 14,--没有空闲队列
    ChapterQuestAfterReward = 15,--章节任务领奖触发
    OpenSpecialPanel = 16,--用于加工厂，不同建筑打开同意界面的情况
    MonsterGetReward = 18,--领取怪物奖励
    PickUpGarbageItem = 19,--捡垃圾获得物品触发
    AllianceAutoMoveCity = 21,--加入联盟自动迁城触发
    MoveToWorldJoinAlliance = 22,--主城迁到世界自动加盟引导
    BuildUpgradeStart = 27,--开始升级建筑触发
    Science = 31,--成功收取科技
    ClickBubble = 33,--点击气泡触发
    UseHeroExp = 34,--使用英雄道具引导
    MarchHeroQuality = 35,--上阵高品质英雄引导
    TreatSoldier = 37,--有伤兵触发
    ShowNewQuest = 38,--出现新任务触发
    ClearAllianceMember = 40,--清理不活跃玩家触发引导触发
    FinishBattleLevel = 41,--完成关卡回到主城/世界 触发引导
    PveEnterBattle = 43,--pve进入战斗触发
    PveShopBuyItem = 44,--pve商店成功购买一次道具触发
    BackCityAfterRecruit = 46,--招募英雄后，返回到主城内，触发引导
    ClickRocketLaunch = 47,--完成火箭订单后，点击提交按钮后，触发引导
    PveOwnRes = 48,--pve拥有资源大于等于配置数量后触发
    StartScience = 50,--开始研究科技触发
    ClickRadarMonster = 51,--点击雷达怪触发
    ClickHeroRecruit = 52,--点击招募按钮触发
    HeroEntrustComplete = 53,--英雄委托点击最后一次提交按钮
    PrologueStartMove = 54,--序章开始移动3秒后触发
    PveEndBattle = 55,--pve战斗结束触发
    ResourceLackShowGoto = 56,--资源不足，显示关卡跳转时触发
    ClickMonster = 60,--点击野怪触发
    ClickPveBackBtn = 61,--点击Pve返回按钮触发引导
    UIBuildUpgradeLackResource = 62,--升级界面，升级条件不满足，则触发引导
    EnterPve = 63,--进入pve触发
    OpenBuyBuffShop = 64,--打开购买buff商店界面
    PveEnterSubmitResource = 65,--pve踩到交资源白块触发
    PveStaminaZero = 66,--pve当体力为0时触发
    OpenActivityPanel = 67,--打开活动页面触发
    BuildWarmHoleCross = 68,--造虫洞触发
    DefendWall = 69,--被攻击触发
    OpenBuildUpgrade = 70,--打开升级界面触发引导
    BagFullInPve = 71,--在pve中背包满了
    UIPlaceBuild = 72,--在预放置建筑界面内，准备放下某建筑时触发
    PrologueOwnNum = 73,--序章背的资源大于等于配置数量时触发
    PlaceBuild = 74,--放建筑触发
    ClickWorldCollectPoint = 75,--点击世界上资源点触发
    FightLevelLackPanel = 77,--打怪条件不足触发
    UIBuildUpgradeEveryLackResource = 78,--升级界面，升级条件不满足，每一个不满足都触发引导
    PveBattleShowResult = 79,--pve战斗结束弹出结果面板触发
    ClickBagFullBtn = 80,--点击仓库已满tips按钮触发
    TaskToUpgradeView = 82,--任务跳转升级界面触发
    SeasonLogin = 85,--赛季登录触发引导
    ClickAttackDesert = 86,--赛季点击占领按钮触发
    ClickNoConnectAttackDesert = 87,--赛季点击与自己或盟友不相邻的空地占领按钮触发
    ClickOutValueDesertTile = 88,--赛季点击辐射值大于抗性值地块触发
    OwnDesert = 89,--占领配置个配置等级地块后触发
    ClickDesertCity = 90,--点击遗迹城触发：我方/敌方/无主
    ClickMarchNeedChangeHero = 91,--点击行军弹出替换英雄提示触发
    OpenHeroListPanel = 92,--打开英雄界面特殊触发
    BuildAllianceFlag = 93,--造联盟旗帜触发
    ClickAttackGuideMonster = 94,--点击攻击引导雷达怪触发
    GotoBuildAllianceCenter = 95,--造联盟中心
    WaitRallyTeamMarch = 96,--点击排队中飞碟
    ClickProtectThrone = 97,--点击保护中的王座
    ClickWarThrone = 98,--点击争夺中的王座
    Login = 200,--登录触发检测是否保存引导id

    PrologueCityUnlock = 100,--序章交完材料触发引导
    PrologueErrorGuide = 110,--序章出现错误导致卡死，触发
    MergeExitFinishOrder = 116,--成功完成订单退出合成关触发
    MergeEnterOrder = 117,--进入合成关显示订单触发
    MergeOrderFinish = 118,--完成订单触发
    CloseNewHero = 119,--关闭新英雄界面触发
    CanUnlockNewArmyWhenEnterPve = 122,--进入pve,当战力小于怪物战力并且兵营可以升级到解锁高等级士兵时触发
    FurnitureUpgradeLevel = 123,--当配置建筑中的配置家具升到配置等级时触发
    FirstNight = 124,--18点天黑时触发时触发
    StormGetRewardBtn = 125,--点击暴风雪预览界面领奖按钮触发
    PveBattleShowResultWin = 127,--pve战斗结束弹出结果面板胜利触发
    PveBattleShowResultFail = 128,--pve战斗结束弹出结果面板失败触发
    ClickLand = 129,--点击地块触发
    LandReward = 130,--地块领奖触发
    MoreRarityHero = 131,--更高品质英雄上阵触发
    ParkourBattleEnter = 132,--新版战斗进入触发
    ParkourBattleFreeHeroUse = 133,--新版战斗有空闲英雄可以上阵触发
    ParkourBattleExit = 134,--新版战斗战斗胜利回到主城触发
    UIFormationSelectListNewCreate = 135,--打开行军选择界面创建队伍面板触发
    UIFormationSelectListNewFree = 136,--打开行军选择界面当有空闲英雄可以上阵触发
    ParkourBattleResultFail = 137,--新版战斗结束弹出结果面板失败触发
    ParkourBattleInLevelResultFail = 138,--新版战斗在配置关卡结束弹出结果面板失败触发
    ClickRadarEvent = 139,--点击雷达事件触发
    
    EnterSeasonOpenIntro = 201,--进入S5赛季后点击触发
    EnterSeasonOpenAllianceSiege = 202,--进入S5赛季后点击联盟城打开界面后触发
    
    
}

--引导跳转类型
GuideGoType =
{
    None = 0,--无
    Build = 1,--建筑
}

--引导类型(强/软)
GuideForceType =
{
    Soft = 0,--软引导
    Force = 1,--强引导
}

--引导对话NPC位置
GuideNpcPosition =
{
    Left = 1,--左侧
    Right = 2,--右侧
}

--引导类型
GuideType =
{
    None = 0,--无
    ClickButton = 1,--点击按钮
    ShowTalk = 2,--对话
    ClickBuild = 3,--点击建筑
    BuildPlace = 4,--建筑建造
    QueueBuild = 8,--跳转队列所在建筑
    Bubble = 11,--气泡
    GotoMoveBubble = 13,--点击垃圾点和迷雾弹出确认前往的气泡
    OpenFog = 14,--迷雾
    PlayMovie = 17,--播放timeline剧情
    WaitMovieComplete = 18,--等待timeline剧情播放结束
    WaitTroopArrive = 21,--等待行军到达目标点
    WaitGarbageTroopMoveLeft = 22,--等待行军到达目标点剩余距离ClickBuildFinishBox
    WaitCloseUI = 23,--等待UI关闭
    ClickBuildFinishBox = 24,--点击建筑完成的箱子
    WaitMessageFinish = 25,--等待服务器消息回来
    ShowBlackUI = 26,--显示黑屏文本
    MoveCamera = 27,--镜头移动
    ClickTime = 28,--点击时间条加速按钮
    CloseAllUI = 29,--关闭所有UI
    UnlockBtn = 32,--解锁按钮
    ShowTroopTalk = 33,--显示右下角人物对话
    ShowGuideTip = 34,--显示引导tip说明
    PlayEffectSound = 35,--播放音效
    ShowChapterAnim = 36,--显示章节动画页面
    ClickQuickBuildBtn = 37,--点击主UI快速建造按钮
    StopAllEffectSound = 38,--停止所有引导加载的音效
    ClickMonster = 39,--点击野怪
    ClickTimeLineBubble = 40,--点击气泡后开始timeline
    ClickCityPointType = 41,--点击垃圾奖励的气泡
    DoUIMainAnim = 44,--做uimain动画
    ClickRadarBubble = 45,--指向雷达特殊气泡
    ClickUISpecialBtn = 46,--指向UI上有button组件，但是有选择条件的按钮
    ShowAllianceCityEffect = 47,--显示周围盟友的特效
    WaitQuestionEnd = 48,--等待答题结束
    WaitTime = 49,--等待时间然后做下一步
    ShowCommunicationTalk = 51,--通讯界面
    ClickCollectResource = 53,--点击矿根
    CollectUISpecialGuide = 54,--采集出征界面特殊引导
    PveShowYellowArrow = 57,--pve中显示黄色箭头
    PveShowBattleSpeedBtn = 58,--pve显示战斗加速按钮
    PveShowBattleFinishBtn = 59,--pve显示战斗直接完成按钮
    PveShowBattlePowerLight = 60,--pve显示战斗兵力高亮引导
    ShowUIBlackChangeMask = 61,--显示过渡动画
    PveShowBattleBloodLight = 62,--pve显示血条高亮引导
    PveHideYellowArrow = 63,--隐藏所有黄色箭头
    WaitMarchFightEnd = 64,--等待行军战斗结束，期间镜头一直锁定在行军车上
    ClickRadarMonster = 65,--点击雷达怪
    OpenSelectQuestionPanel = 66,--弹出选择成为盟主答题界面
    NoNpcTalk = 67,--弹出旁白界面
    ShowFakeHero = 68,--展示假英雄
    ClickMonsterReward = 69,--点击任意一个野怪箱子
    SetAttackSpecialStateFlag = 70,--引导设置出征特殊状态
    WaitPanelOpen = 71,--等待界面打开（加载完）
    SetBubbleShow = 73,--设置所有气泡显示/隐藏
    AlliancePanelGuide = 74,--联盟界面特殊引导  
    DoQuestJump = 75,--任务跳转  
    CheckBecomeAllianceLeader = 76,--检测是否能成为盟主
    ShowLoadMask = 77,--出世界/联盟迁城遮罩
    ChangeBgm = 79,--改变Bgm
    ChangeBgmVolume = 80,--修改Bgm音量
    WaitGolloesArrived = 81,--等待咕噜探索到达，期间镜头一直锁定在咕噜行军
    SetRadarMonsterVisible = 82,--隐藏/显示世界雷达怪
    SetCityPeopleAndCarVisible = 83,--隐藏/显示城内车和行人
    WaitBackCity = 84,--等待从pve返回到主场景
    PveSkillVisible = 85,--旋风斩按钮显示/隐藏
    PveShowStaminaLight = 86,--pve显示血条高亮引导
    SetPveStaminaNpcVisible = 87,--控制买体力小人显示/隐藏
    FullPveSkill = 88,--一键加满旋风斩能量
    ClickLandZoneBubble = 89,--引导手指地块的气泡（感叹号）
    WaitPveEnterComplete = 90,--等待pve进入loading结束
    SetPveBuyBuffShopEffectActive = 91,--pve购买buff商店页面黑色遮罩显示/隐藏
    SetPveStopRefreshStamina = 92,--pve设置停止刷新体力
    SetPveNoClickStamina = 93,--pve设置不能点击体力条
    OpenHeadTalkPanel = 94,--打开头像对话页面
    CloseHeadTalkPanel = 95,--关闭头像对话页面
    SetPveBagGuide = 96,--pve背包引导
    HeroAdvanceGuide = 97,--英雄晋级引导
    SetHeroAdvanceGuideHeroVisible = 98,--英雄晋级引导晋级英雄置黑
    SetHeroAdvanceGuideSubHeroVisible = 99,--英雄晋级引导海报英雄置黑
    SetAllVisible = 100,--隐藏所有UI（界面ui，女npc的每日任务，格鲁的修理气泡，建筑气泡，问答小人气泡）

    PrologueShowNpc = 104,--引导序章显示NPC
    PrologueShowSetManPosition = 106,--在pve控制主角 在序章控制小人 para1 调位置  para2填 旋转  都可以不填
    ShowUIWindow = 111,  -- 显示UI界面

    PrologueHideNpc = 122,--引导序章删除NPC
    PVEFinishOneTrigger = 125,--引导关卡完成一个触发点
    PVESetTriggerVisible = 127,--pve隐藏/显示触发点
    ShakeCamera = 128,--晃动相机
    SetWoundedBubbleVisible = 129,--隐藏/显示格鲁的修理气泡
    ClickWoundedCompensateBubble = 130,--引导手指指向pve伤兵爆仓气泡
    SetGuideQuestVisible = 131,--引导期间任务气泡弹出/不弹出
    ShowCurtain = 132,
    UIBuildListSpecial = 133,--建造列表特殊的引导
    BackBuildCollectTime = 134,--特殊处理让银行获得金币
    SetHeroAdvanceMaskVisible = 135,--隐藏/显示英雄升星遮罩
    SetPveOutBagGuide = 136,--pve爆仓引导黑色遮罩
    OpenPanel = 138,--打开页面
    UIScrollToSomeWhere = 139,--当前打开界面滑动到指定位置
    ShowJumpBtn = 140,--timeline显示跳过按钮
    BlackHoleMask = 141,--通用黑色扣洞遮罩
    UIPathArrow = 142,--通用ui上黄色箭头
    BuildCanDoAnim = 143,--建筑做动画
    ShowNewHero = 144,--展示一个新英雄
    SetWorldArrowVisible = 145,--控制世界上箭头显示
    ShowWorldArrow = 146,--显示黄色箭头
    ShowGuideDetectEventMonster = 147,--引导显示世界胡蒂尔雷达怪
    JumpPrologue = 151,--跳过序章，大本1级
    ControlTimelinePause = 153,--控制timeline暂停/恢复
    OpenSeasonIntro = 156,-- 打开赛季简介UI
    ControlUISeasonIntro = 157,-- 引导控制赛季简介UI
    ClickGuideHdcBubble = 158,--指向引导海盗船上气泡
    NewbieResident = 161,--召唤新手幸存者
    ClickOpinionBox = 162,--点击民意信箱
    ShowTopDes = 163,--显示顶部文字提示
    ShowSpeechTalk = 164,--显示连续对话
    ChangeDayTime = 165,--改变时间(控制黑天白天)
    WaitBuildUpgradeFinish = 166,--等待建筑升到配置等级
    ShowOneCreateEffect = 167,--显示一个建筑建造白色特效
    ClickLandLock = 168,--手指指向地块
    ShowLand = 169,--显示地块
    PeopleDead = 170,--控制小人死亡
    PeopleMove = 171,--控制城内小人移动
    PeopleAnim = 172,--控制城内小人做动作/出现气泡
    HeroMove = 173,--控制城内英雄移动
    GuideEnterPve = 174,--引导进战斗
    ControlResidentPause = 175,--控制所有小人暂停/继续
    ShowResidentEmoji = 176,--显示emoji
    ShowTalkBubble = 177,--显示对话气泡
    ControlLightRange = 178,--控制大本灯光范围
    ControlComeResident = 179,--控制到来的小人和气泡
    AddZombie = 180,--生成僵尸
    ShowGuideEffect = 181,--显示/隐藏红色警告/风沙
    WaitRadarTaskFinish = 182,--等待配置雷达任务完成
    RemoveZombie = 183,--销毁180类型生成的僵尸
    ControlNewAddBuildVisible = 184,--控制新获得的建筑隐藏/显示
    OpenWithBooster = 185,  --开启最大功率
    ChangeSafeArea = 186,  --改变安全区半径
    
    GuideStart = 500,--引导开始
    NetUnConnect = 1000,--测试类型，断线重连
}

--引导对话NPC位置
GuideArrowStyle =
{
    Finger = 0,--手指
    Yellow = 1,--黄色箭头
    Green = 2,--绿色箭头
    ClickCallAirDrop = 3,--快速点击召唤空投按钮
}

SceneType =
{
    None = 0,
    City = 1,
    World = 2,
}

CloseUIType =
{
    ClickWorld = 1,
    ClickUI = 2,
    DragWorld = 3,
}

CityPointType =
{
    Other = 0, --0 空地

    Building = 100,--建筑
    Collect = 104, -- 矿根
    CollectRange = 105, -- 矿根周边
    ZeroFakeBuild = 107,--0级假建筑
}

OrderItemType = {
    ORDER_ITEM_TYPE_RESOURCE_ITEM = 0,
    ORDER_ITEM_TYPE_GOODS = 1,
    ORDER_ITEM_TYPE_RESOURCE = 2,
    ORDER_ITEM_TYPE_MONSTER = 3,
    ORDER_ITEM_TYPE_SPECIAL_MONSTER = 4,
}


local EnumType = {

}

--设置中部队详情中tab
TroopType =
{
    Total = 1,
    Inside = 2 ,
    Outside = 3 ,
    Turret = 4 ,
    Reserve = 5,
}

--连接方向（双向）
ConnectDirection =
{
    TopToLeft = 1,
    TopToDown = 2,
    TopToRight = 3,
    LeftToDown = 4,
    LeftToRight = 5,
    LeftToTop = 6,
    DownToLeft = 7,
    DownToTop = 8,
    DownToRight = 9,
    RightToTop = 10,
    RightToLeft = 11,
    RightToDown = 12,
    Left = 13,
    Right = 14,
    Top = 15,
    Down = 16,
}

VipPayGoodState =
{
    Lock = 1,
    CanBuy = 2,
    CanGet = 3,
    HasGet = 4,
}

GuidePlayMovieType =
{
    MoveToWorld = 13,--主城去世界
    TrainSpeedFree = 67,--士兵训练加速按钮变成免费
    StartStormScene = 72,--开启引导暴风雪
    WorkEnterCity = 100,--引导开始小人进村
    FireAndZombieOut = 101,--点燃火堆丧尸离开
    ResetGuideControlWork = 102,--解除引导控制工人
    SawyerWork = 103,--工人砍树
    ChefWork = 104,--工人做饭
    ResidentEat = 105,--工人吃饭
    UnlockTaskBtn = 106,--解锁任务按钮
    ResidentHide = 107,--僵尸来之前小人跑开
    ZombieCome = 108,--僵尸到来吓小人
    HeroAttack = 109,--英雄打僵尸
    UnlockStatsBtn = 110,--解锁状态按钮
    ResidentCome = 111,--小人到达
    ShowRandomZombie = 112,--出现随机僵尸
    UnlockLandScene = 113,--解锁地块表演
    BaseLightRangeScene = 114,--大本光照范围扩散
    BellScene = 115,--敲钟后小人聚集,丧尸爬出来
    HuntLodgeScene = 116,--猎人小屋
    SecondNightScene = 117,--第二天晚上，丧尸跑过来咬死一个变成丧尸
    ShowSecondNightZombieScene = 118,--生成两个第二晚的僵尸
    BurnResidentScene = 119,--烧毁死亡的居民
    ResidentEnterCityScene = 120,--引导开始小人进村Timeline
    ResidentComeScene = 121,--工程师到来Timeline
    TollScene = 122,--敲钟
    BaseBuildLightRangeScene = 123,--大本升级后光范围变化
    UIResidentDeadScene = 124,--ui上小人死亡动画
    ChapterBgScene = 125,--设置在最上方的章节任务图
    ResidentScene = 126,--餐厅timeline
    SecondNightBScene = 127,--第二夜timeline B段
    PausePve = 128,--暂停Pve
    ControlWallAnim = 129,--控制城墙隐藏/显示
    SetLandBlockCallBoss = 130,--控制地块出来召唤城内boss
}

--标记(个人，联盟）
MarkType = {
    Special = 0,
    Friend = 1,
    Enemy = 2,
    Alliance_Attack = 3,
    Alliance_Sun = 4,
    Alliance_LuckyClover = 5,
    Alliance_6 = 6,
    Alliance_7 = 7,
    Alliance_8 = 8,
    Alliance_9 = 9,
    Alliance_10 = 10,
    Alliance_11 = 11,
    Alliance_12 = 12,
}


AllianceMarkName = {
    [MarkType.Alliance_Attack] = "100150",
    [MarkType.Alliance_Sun] = "391106",
    [MarkType.Alliance_LuckyClover] = "391107",
    [MarkType.Alliance_6] = "391108",
    [MarkType.Alliance_7] = "391109",
    [MarkType.Alliance_8] = "130066",
    [MarkType.Alliance_9] = "390817",
    [MarkType.Alliance_10] = "391110",
    [MarkType.Alliance_11] = "391111",
    [MarkType.Alliance_12] = "391112",
}

--LoadPath.AllianceMark
AllianceMarkIconName = {
    [MarkType.Alliance_Attack] = "UIAlliance_mark_03",
    [MarkType.Alliance_Sun] = "UIAlliance_mark_04",
    [MarkType.Alliance_LuckyClover] = "UIAlliance_mark_05",
    [MarkType.Alliance_6] = "UIAlliance_mark_06",
    [MarkType.Alliance_7] = "UIAlliance_mark_07",
    [MarkType.Alliance_8] = "UIAlliance_mark_08",
    [MarkType.Alliance_9] = "UIAlliance_mark_09",
    [MarkType.Alliance_10] = "UIAlliance_mark_10",
    [MarkType.Alliance_11] = "UIAlliance_mark_11",
    [MarkType.Alliance_12] = "UIAlliance_mark_12",
}

AllianceMarkPrefabPath = {
    [MarkType.Alliance_Attack] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_3.prefab",
    [MarkType.Alliance_Sun] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_4.prefab",
    [MarkType.Alliance_LuckyClover] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_5.prefab",
    [MarkType.Alliance_6] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_6.prefab",
    [MarkType.Alliance_7] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_7.prefab",
    [MarkType.Alliance_8] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_8.prefab",
    [MarkType.Alliance_9] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_9.prefab",
    [MarkType.Alliance_10] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_10.prefab",
    [MarkType.Alliance_11] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_11.prefab",
    [MarkType.Alliance_12] = "Assets/Main/Prefab_Dir/UI/AllianceWorldMark/AllianceWorldMark_12.prefab",
}

GuideMoveArrowPlayAnimName =
{
    Down = 1,--按下
    Up = 2,--抬起
}

GuideAnimObjectType =
{
    ShowMigrateScene = 6,--出现移民
    ShowRobotScene = 9,--出现机器人
    ShowFromMjBuildMainBuildScene = 10,--出现工人从民居出来修建大本timeline
    MainZeroUpgradeScene = 11,--大本0升1 
    SecondMigrateScene = 12,--第二次出现移民
    TilePlaneRuin = 13,--飞机坠毁
    SaveBobScene = 14,--拯救Bob
    PirateFightBobScene = 15,--海盗船和Bob打架
    PirateComeScene = 16,--海盗船到来
    PirateAwayScene = 17,--海盗船离开
    PirateShowScene = 18,--海盗出现
    RadarScanScene = 19,--雷达扫描动画
    ShowFakePlayerFlagScene = 20,--显示假玩家标志
    RadarWorldScanScene = 21,--世界雷达扫描动画
    ShowTankScene = 23,--显示假坦克
    ShowRadarMonsterScene = 25,--播放雷打怪出现动画
    PveThreeBombs = 26,--pve降落3颗炸弹
    PveDestroyHdc1 = 27,--pve摧毁海盗船1
    PveDestroyHdc2 = 28,--pve摧毁海盗船2
    PveDestroyHdc3 = 29,--pve摧毁海盗船3
    PveMissileInSky = 30,--pve摧毁海盗船3
    PveDestroyMountain = 31,--pve摧毁山石
    GuluOutFromBaseScene = 32,--timeline_1
    GuideTimeline2Scene = 33,--GuideTimeline2Scene   不删除
    PveHdcEscape = 34,--pve海盗船逃跑
    DefendWallScene = 35,--
    GuideTimeline3Scene = 36,--GuideTimeline3Scene
    PveHdcEscape31014 = 37,--pve海盗船逃跑
    ConnectElectricityScene = 39,--连电动画
    Chapter2CameraMoveScene = 40,-- 第二章播完章节图，镜头移动
    SmallDomeMigrateScene = 42,--小苍穹移民timeline
    WorldDesertCityEffectScene = 43,--赛季世界城特效
    WorldAttackPlayerScene = 44,--世界上出现海盗船袭击大本
    FromCarBuildMainBuildScene = 47,--从车里出来建造大本
    UnlockLandScene = 48,--开启地块功能表演
    BellScene = 115,--敲钟后小人聚集,丧尸爬出来
    HuntLodgeScene = 116,--猎人小屋
    SecondNightScene = 117,--第二天晚上，丧尸跑过来咬死一个变成丧尸
    BurnResidentScene = 119,--烧毁死亡的居民
    ResidentEnterCityScene = 120,--引导开始小人进村Timeline
    ResidentComeScene = 121,--工程师到来Timeline
    BaseBuildLightRangeScene = 123,--大本升级后光范围变化
    ResidentScene = 126,--餐厅timeline
    SecondNightBScene = 127,--第二夜timeline B段
}

--引导TimeLine信号类型
GuideTimeLineShowMarkerType =
{
    Zero = 0,
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    End = 999,
}

ShowCircleType =
{
    Show = 0,--显示引导圆圈
    No = 1,--不显示引导圆圈
}

--建筑扫描动画
BuildScanAnim =
{
    No = 0,--没有飞行时间，不播放建筑扫描动画
    Play = 1,--有飞行时间，播放建筑扫描动画
    NoFly = 2,--没有飞行时间，播放建筑扫描动画
}

--第一次键入联盟标志
FirstJoinAllianceType =
{
    No = 0,
    Yes = 1,
}

--解锁弹窗类型
UnlockWindowType =
{
    None = 0,
    Product = 1,
    Building = 2,
    GuideBtn = 3,--引导按钮
    Activity = 4,--解锁新日常活动
    Item = 6,--道具（密码）
}

--引导是否可以做的状态
GuideCanDoType =
{
    Yes = 1,--可以正常进行
    No = 2,--缺少条件不能做，如果做会卡住
}

WaitMessageFinishType =
{
    AllianceMember = 5,--等待联盟成员信息返回
    FirstJoinAlliance = 7,--等待答题成为盟主返回
    MoveCityToWorld = 8,--去世界消息返回
    TaskRewardGet = 10,--等待领奖消息返回
    TrainSoldier = 11,--等待训练士兵消息返回
    UIMainChapterTaskRefresh = 13,--等待章节任务界面刷新
    LotteryHeroCard = 14,--等待英雄抽奖消息返回
    UIDetectEvent = 15,--等待雷达界面事件加载完
    BackCitySceneFinish = 16,--等待回到主城
    ResidentSetWork = 17,--等待添加工人消息返回
    UpgradeFurniture = 18,--等待建造/升级家具消息返回
    PveEnter = 19,--等待pve完全加载完进入
    LandBlockOne = 20,--等待解锁地块，小人往前走，如果是区域解锁，到出现解锁气泡结束
    LandBlockTwo = 21,--等待解锁地块点击气泡后表现，到出现建筑结束
    ResidentLoad = 22,--等待小人/英雄加载完毕
    BackWorldSceneFinish = 23,--等待回到世界
    ParkourBattleEnter = 24,--等待新版战斗完全进入
    UITaskMainAnimBg = 25,--等待任务做完翻页动画
    StartNewbieStorm = 26,--等待开启暴风雪消息返回
    DetectEventRewardReceive = 27,--等待雷达领奖消息返回
    LandBlockShowReward = 28,--等待解锁地块弹出奖励
}

--放置建筑界面打开类型
PlaceBuildType =
{
    None = 0,
    Build = 1,
    Move = 2,
    Replace = 3,
    MoveCity = 4,--迁城，根据情况选择道具
    MoveCity_Al = 5,--联盟迁城
    MoveCity_Cmn = 6,--高级迁城
}
AllianceCityState = {
    NEUTRAL = 0,--中立
    OCCUPIED =1,--占领
    InProgress = 2,--王座积分增长中
}

BuildPutState =
{
    None = 0,
    Ok = 1,--可以放置
    Collect = 2,--矿根
    CollectRange = 3,--矿根周边
    OtherCollectRange = 4,--其他矿根周边
    NoCollectRange = 5,--没有矿根周边
    OutMyRange = 6,--超出自己限制范围
    InOtherBaseRange = 7,--在他人大本范围内
    StaticPoint = 8,--静态点
    Building = 9,--建筑
    OutUnlockRange = 11,--不在已经锁范围内,解锁范围:({0},{1}) - ({2},{3})
    WorldBoss = 13,--世界Boss
    WorldMonster = 14,--世界野怪
    CollectTimeOver = 15,--矿跟正在销毁中
    OutMyInside = 16,--不在苍穹内
    InMyInside = 17,--不在苍穹外
    OutMainSubRange = 18,--超出主建筑范围
    OnWorldResource = 20,--世界资源点
    ReachBuildMax = 22,--达到建造最大值
    OnExplore = 23,--小队探索点
    OnSample = 24,--小队采样点
    OnGarbage = 25,--垃圾点
    MONSTER_REWARD = 27,--野怪奖励
    NoBuildInMyInside = 28,--苍穹内不能建造道路
    NoRemoveInMyInside = 29,--苍穹内的道路不可拆除
    OnDesert = 30,--地块未解锁
    OutBuildZone = 32,--不在建筑可建造区域内
    ItemLack = 33,--道具不足
    NotInAlArea = 34,--不可联盟迁城
    NotNearAlRuin = 35,--不在联盟遗迹附近
    AlResNotEnough = 36,--联盟资源不足
    AlCityBuilding = 37,--在联盟城附近
    NoInAllianceCenterRange = 38,--超出联盟中心范围
    NotConnectDesert = 39,--地块未相连
    InBlackLandRange = 40,--在黑土地范围
    MoveCityNotInUnLockRange = 41,--当前区域尚未解锁迁城
    CanNotPlaceEdenSubway = 42,--沙虫地铁只能放置在自己地块上
    AllianceBuildNotInBirthRange = 43,--联盟中心只能放置在初始区域范围内
    AllianceMineNotInBirthRange = 44,--联盟矿只能放置在初始区域范围内
    AllianceEdenMineCanNotReach = 45,--无法放置在部队不可抵达区域
}

AllianceCityShowTimeState = {
    None = 0,
    Lock = 1,--未开启
    UnAttack =2,--休战
    Recover = 3,--恢复
    ThroneProtect = 4,
    ThroneAttack = 5,
    ThroneNotOpen = 6,
}

PackageImgPath = {
    PackageBg = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_bg01",
    PackageTitle = "Assets/Main/Prefab_Dir/UI/UIPopupPackage/UIPopupPackage_name_%s.prefab",
    RewardBg = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_bg02",
    EntranceIcon = "Assets/Main/TextureEx/UIPopupPackage/%s/UIPopupPackage_icon",
    ScrollPack = "Assets/Main/TextureEx/UICommonPackageBig/CommonPackageBig_img_%s",
    WeeklyPackageItem = "Assets/Main/TextureEx/UIWeeklyPackage/"
}

NoticeType = {
    RecruitHero = 1,    -- 招募英雄
    FirstKill = 2,      -- 首次击杀怪物
    FirstOccupyCity = 3,     -- 首次占领城市
    ChangeOccupyCity = 4,    --抢夺城市
    HeroCard_Use = 5,   --紫将使用
    OccupyEmptyCity = 6, --占领空城
    NewServer_Act_Reward = 7, --开服活动领奖公告
    RadarRally = 8, -- 雷达集结活动 首次击杀沙虫暴君
    AcquireHero = 9,--英雄品质升阶
    AlElectResult = 10,--联盟盟主选举
    ActBossOpen = 11,--活动boss出现
    ActBossClose = 12,--活动boss消失
    CrossServer = 13,--有人跨服
    AllianceCityBegin =14,--七级城解锁
    DecorationItemGet = 15,--获取装扮物品
    DecorationSend = 16,--赠送装扮物品
    OccupyThrone = 17,--占领王座
    KingSetPosition = 18,--授予官职
    KingRefreshDesert = 19,--国王刷矿
    OccupyDragonBuild =20,--占领巨龙建筑
    GetSecretKey = 21,--获取圣物
    SecretAppear = 22,--圣物出现
    DragonTime = 23,--巨龙倒计时
    SecretAppearAdv = 24,--圣物出现预告
}

GiftPackageTab =
{
    MonthCard = 1,

}

ClickWorldType =
{
    Ground = 0,
    Collider = 1,
}

RobotState =
{
    -- 0 空闲
    FREE=0,
    -- 1 升级/建造中
    BUILD=1,
}

RobotSkillType =
{
    -- 0 默认
    DEFAULT=0,
    -- 1 建造
    BUILD=1,
    -- 2 科技
    SCIENCE=2,
}

RecommendShowState =
{
    ShowBuild = 1,--显示建筑上的箭头
    ShowPanel = 2--显示页面中的箭头
}

--咕噜月卡,value1-4不可变
GolloesType = {
    Worker = 1,
    Explorer = 2,
    Trader = 3,
    Warrior = 4,
}

GolloesSound = {
    [GolloesType.Worker] = SoundAssets.Music_Effect_Golloes_Worker,
    [GolloesType.Explorer] = SoundAssets.Music_Effect_Golloes_Explorer,
    [GolloesType.Trader] = SoundAssets.Music_Effect_Golloes_Trader,
    [GolloesType.Warrior] = SoundAssets.Music_Effect_Golloes_Warrior,
}

GolloesTypeOrderList =
{
    GolloesType.Worker,GolloesType.Explorer,GolloesType.Trader,GolloesType.Warrior
}

--aps_shop.shop_id
CommonShopType = {
    Goods = 1,
    Vip = 2,
    LimitTime = 3,
    HeroReset = 4,
    GolloesShop = 6,
    DiscountShop = 7,--折扣商店？
    AlContribute = 8,
    SeasonShop = 10,--赛季商店
    HeroMetalRedemption = 11,--代币商店
}

AllianceMemberOpenType = {
    AllianceMember = 1,
    ResSupport = 2,
    GolloesTrande = 3,
    OtherAlMember = 4,
}

GolloesShow = {
    [GolloesType.Worker] = {
        name = "320246",
        nameBg = "UI_dispatch_namebg_blue",
        desc = "320216",
        icon = "UI_dispatch_blue",
        bg = "UI_dispatch_bg_blue",
        costBg = "UI_dispatch_consumebg_blue",
        costIcon = "UI_dispatch_consumeIcon_blue",
        claimBg = "UI_dispatch_receive_blue",
        color = Color.New(0.1, 0.9, 1,1),
        tipOffsetX = 50,
        rewardIcon = "UI_dispatch_icon_01",
    },
    [GolloesType.Explorer] = {
        name = "320247",
        nameBg = "UI_dispatch_namebg_red",
        desc = "320217",
        icon = "UI_dispatch_red",
        bg = "UI_dispatch_bg_red",
        costBg = "UI_dispatch_consumebg_red",
        costIcon = "UI_dispatch_consumeIcon_red",
        claimBg = "UI_dispatch_receive_red",
        color = Color.New(1, 0.51, 0.51,1),
        tipOffsetX = 0,
        rewardIcon = "UI_dispatch_icon_02",
    },
    [GolloesType.Trader] = {
        name = "320248",
        nameBg = "UI_dispatch_namebg_yellow",
        desc = "320218",
        icon = "UI_dispatch_yellow",
        bg = "UI_dispatch_bg_yellow",
        costBg = "UI_dispatch_consumebg_yellow",
        costIcon = "UI_dispatch_consumeIcon_yellow",
        claimBg = "UI_dispatch_receive_yellow",
        color = Color.New(1, 0.91, 0.45,1),
        tipOffsetX = 0,
        rewardIcon = "UI_dispatch_icon_03",
    },
    [GolloesType.Warrior] = {
        name = "320249",
        nameBg = "UI_dispatch_namebg_purple",
        desc = "320219",
        icon = "UI_dispatch_purple",
        bg = "UI_dispatch_bg_purple",
        costBg = "UI_dispatch_consumebg_purple",
        costIcon = "UI_dispatch_consumeIcon_purple",
        claimBg = "UI_dispatch_receive_purple",
        color = Color.New(1, 0.52, 0.95,1),
        tipOffsetX = -50,
        rewardIcon = "UI_dispatch_icon_04",
    },
}

RecommendShowAnimType = {
    Default = 1,
    Show = 2,
}

RecommendShowAnimName = {
    [RecommendShowAnimType.Default] = "UIRecommendDefault",
    [RecommendShowAnimType.Show] = "UIRecommendShow",
}

RecommendShowImgAnimName = {
    [RecommendShowAnimType.Default] = "UIRecommendLightDefault",
    [RecommendShowAnimType.Show] = "UIRecommendLightShow",
}


AssistanceType =
{
    Build = 0,
    MainCity = 1,
    AllianceCity = 2,
    Desert = 3,
    AllianceBuild = 4,
    Throne =5,
    ActAllianceMine = 6,
    DragonBuilding = 7,
}

--引导tip位置
GuideTipPosition =
{
    LeftUp = 1,--左上
    RightUp = 2,--右上
    LeftDown = 3,--左下
    RightDown = 4,--右下
}

--引导移动镜头类型
GuideMoveCameraType =
{
    Point = 1,--移动到固定点
    Build = 2,--移动到建筑
    AllianceChief = 4,--移动到盟主
    AllianceMember = 5,--移动到周围8个点中任意盟友位置
    NewbieSpaceMan = 6,--镜头重新跟随小人
    Npc = 7,--镜头移动到NPC
    FollowNpc = 8,--跟随NPC
    CollectResource = 9,--矿根
    Garbage = 10,--世界空投垃圾点
    MonsterReward = 11,--野怪箱子
    RadarMonster = 12,--移动到雷达
    WorldCity = 13,--移动世界大本
    SeasonCity = 15,--移动到最近的赛季城
    SeasonDesert = 16,--移动到赛季地块
    RadarEvent = 19,--移动到雷达野怪
    LandPeople = 20,--移动到城内地块已解锁的小人
    Land = 21,--移动到城内地块
    Position = 100,--移动到固定点绝对坐标
}

--解锁类型
TemplateUnlockType =
{
    Build = 0,--建筑解锁
    Science = 1,--科技解锁
    MonthCard = 2,--(农场产物月卡解锁) 
    Career = 2,--(工厂产物的职业解锁)
    Talent = 4,--(天赋解锁)
    Mastery = 5,--专精解锁
}

---解锁按钮类型
UnlockBtnType =
{
    Quest = 1,--任务按钮
    Story = 2,--探险
    Hero = 3,--英雄
    Bag = 4,--背包
    Shop = 5,--商店
    Alliance = 6,--联盟
    Chat = 7,--聊天
    SevenLogin = 8,--七日签到
    SevenActivity = 9,--七天帝王路
    FirstPay = 10,--首充
    VIP = 11,--VIP
    DiamondShop = 12,--宝石商店
    World = 13,--世界
    Power = 14,--战斗力
    Resource = 15,--顶部资源按钮
    DiamondAdd = 16,--点击钻石弹礼包功能
    Mail = 17,--邮件
    Stamina = 18,--体力条
    PeopleCome = 19,--小人到来
    Activity = 20,--活动中心
}

--解锁按钮类型
UnlockBtnLockType =
{
    Hide = 0,--直接隐藏
    Lock = 1,--上面有锁，点了告诉解锁条件（不填不显示条件）
    Normal = 2,--未解锁但正常显示，点击显示条件（不填不显示条件）。【世界】,当满足任意条件显示按钮，全部满足点击正常
    Show = 10,--正常显示
}

GuideUnlockBtnNextType =
{
    WaitAnim = 0,--等待动画完成
    Next = 1,--不做动画直接下一步
    Fly = 2,--等待飞动画完成在下一步
}

UnlockBtnIconPath = {
}
UserSayCodeMap = {}
UserSayCodeMap["en"] = "Account Banned"
UserSayCodeMap["ru"] = "Аккаунт под баном"
UserSayCodeMap["ja"] = "アカウント凍結"
UserSayCodeMap["cn"] = "账号被封停___*禁言*___*封号*"
UserSayCodeMap["tw"] = "帳號被封停"
UserSayCodeMap["ar"] = "تم حظر الحساب"
UserSayCodeMap["de"] = "Konto verbannt"
UserSayCodeMap["fr"] = "Compte bloqué"
UserSayCodeMap["ko"] = "계정이 차단됨"
UserSayCodeMap["pt"] = "Conta foi congelada"
UserSayCodeMap["th"] = "บัญชีโดนแบน"
UserSayCodeMap["tr"] = "Hesap donduruldu"
UserSayCodeMap["id"] = "Akun Diblokir"
UserSayCodeMap["es"] = "Cuenta bloqueada"
UserSayCodeMap["it"] = "Account bloccato"

--主UI需要保存的位置，用于飞图标，主界面隐藏的情况
UIMainSavePosType =
{
    Quest = 1,--任务按钮
    LaDar = 2,--雷达任务
    People = 3,--人口
    Goods = 5,--物品
    Search = 7,--搜索按钮
    StorageLimit = 9,--仓库上限
    Power = 10,--战力
    Gold = 11,--钻石
    Stamina = 12,--体力
    Resource = 13,--资源
    VitaResident = 15,--人口
    
    Story = 16,--探险
    Hero = 17,--英雄
    Shop = 18,--商店
    Alliance = 19,--联盟
    Chat = 20,--聊天
    SevenLogin = 21,--七日签到
    SevenActivity = 22,--七天帝王路
    FirstPay = 23,--首充
    VIP = 24,--VIP
    World = 25,--世界
    VitaMessage = 26,--幸存者消息
    Activity = 27,--活动中心
    WelfareCenter = 28,--福利中心
}

--活动提示入口类型   7087
ActivityTipEntranceType =
{
    activityEntrance = 1, --日常活动入口
    welfareCenterEntrance = 2, -- 福利中心入口
    Another = 100, --未知
}
ActivityTipConditionType =
{
    FirstActivityId = 0,  --活动id首次
    FirstActivityType =1, --活动类型首次
    LoginInEveryDay = 2, --每日登录
    EveryTime = 3,  --每次
    CycleActivityEveryTime = 4,--周期活动每次开启
}


--移动到世界自动加联盟类型
MoveToWorldJoinAllianceType =
{
    Join = "1",--加入
    No = "2",--未加入
}

--方向
DirectionType =
{
    Top = 1,
    Down = 2,
    Left = 3,
    Right = 4,
}

EnumQualitySetting =
{
    PostProcess_Bloom = "QualitySetting.PostProcess.Bloom",
    PostProcess_ColorAdjustments = "QualitySetting.PostProcess.ColorAdjustments",
    PostProcess_Vignette = "QualitySetting.PostProcess.Vignette",
    PostProcess_Tonemapping = "QualitySetting.PostProcess.Tonemapping",
    PostProcess_LiftGammaGain = "QualitySetting.PostProcess.LiftGammaGain",
    PostProcess_DepthOfField = "QualitySetting.PostProcess.DepthOfField",
    Resolution = "QualitySetting.Resolution",
    FPS = "QualitySetting.FPS",
    Terrain = "QualitySetting.Terrain"
}

EnumQualityLevel =
{
    Off = 0,
    Low = 1,
    Middle = 2,
    High = 3,
}
BuildTilesType =
{
    One = 1, --1格
    Two = 2, --2格
    Three = 3, --3格
}

StatTTType =
{
    Guide = "noviceboot",
    Quest = "quest",
    Special = "special",
    JumpGuideId = "jump",
    FinishTrigger = "finishTrigger",
    FinishLevel = "finishLevel",
    CreateLevelStart = "createLevelStart",
    CreateLevelComplete = "createLevelComplete",
    EngeryNotEnough = "engery_not_enough",
    PveBattleStart = "pveBattleStart",
    PveBattlePowerLack = "pveBattlePowerLack",
    PveBattleFail = "pveBattleFail",
    FiveStarJump = "fiveStarJump",
    FiveStarReceive = "fiveStarReceive",
}
--引导镜头移动显示主UI类型
GuideCameraShowUIMainType =
{
    None = 0,
    Hide = 1,
    Show = 2,
}

--场景数据标志
NewUserWorld =
{
    Skip = 0, --跳过新手世界
    Ing= 1,-- 正在新手世界中
    Pass= 2 ,--经历过新手世界
}
--建筑联盟帮助类型
AllianceHelpState =
{
    No = 0,
    UpgradeHelped = 1,
    RuinsHelped = 2,
    UpgradeAndRuinsHelped = 3,
}


--引导需要判断满足条件
GuideJumpType =
{
    BuildPlace = 1,--建筑建造
    QueueBuild = 2,--跳转队列所在建筑
    WaitMessageFinish = 4,--等服务器消息回来
    ClickTime = 5,--点击时间条加速
    ClickBuild = 7,--点击建筑
    TimelineJump = 9,--timeline对话等待时，需要播放下一个对话时跳转
    WaitCloseUI = 10,--等待UI关闭
    BuildLevel = 11,--要求建筑等级
    QueueState = 12,--当前队列是否是这个状态
    AllianceMember = 13,--周围8个点是否有盟友
    DoneGuide = 14,--如果该引导id做过就跳过
    CityPointType = 15,--坐标点是否为城市点类型
    HasBuild = 17,--这个位置是否有该建筑（不判断联通）
    RadarEvent = 19,--没有配置雷达事件(或雷达事件已领奖),走跳过
    IsHaveCanShopItem = 20,--是否有可以上架的物品
    AllianceLeader = 23,--是否是盟主
    TreatSoldier = 24,--是否有伤兵
    BuildState = 25,--建筑状态
    PveHasUseBattleHero = 29,--pve是否有可上阵英雄
    PveBattleMinHeroRarity = 30,--pve上阵中等级最低的英雄是否低于或等于该稀有度
    HasCanAdvanceHero = 31,--当前是否有可突破的英雄,没有走跳过
    HasOutRangeLevelHero = 32,--当前是否有超过该等级的英雄,有走跳过
    HaveAlliance = 35,--不满足配置（1:有联盟 2：没有联盟）时,，走跳过
    IsFormationUnset = 36,--配置index未设置编队走跳过
    IsSuccessMarch = 37,--没有正常出征走跳过
    HaveMonsterReward = 38,--没有打怪的宝箱走跳过
    GetMonsterRewardBagFull = 39,--领取打怪宝箱背包满了走跳过
    Bubble = 40,--是否正在显示该气泡，没有走跳过
    AttackLevelMonster = 41,--配置等级野怪不能打走跳过
    FinishChapter = 42,--是否完成这个章节（该章节已领奖）
    HaveLeaderInAlliance = 43,--没有联盟或联盟中没有盟主走跳过
    UIResourceLackHaveLackTips = 47,--缺资源界面没有配置tips则走跳过
    OwnResourceNum = 48,--拥有的资源数量小于配置数量走跳过
    PveTaskNotUnCompleteState = 49,--pve任务不是未完成状态走跳过
    HaveUpgradeHero = 50,--没有可晋级的英雄走跳过
    HistoryUpgradeHero = 52,--晋升过走跳过
    BuildBubble = 53,--建筑没有该气泡走跳过
    SceneType = 54,--不在配置的场景内走跳过（主城/世界/pve）
    HasStarUpHero  = 55,--升过星走跳过
    HasCanStarUpHero    = 56,--没有可以升星的英雄走跳过
    PveBattleResult    = 57,--关卡战斗不是配置结果走跳过
    OwnItemNum = 58,--拥有的道具数量小于配置数量走跳过
    ShowQuestId = 59,--主UI左侧没有配置任务id的任务球显示走跳过
    WorldCollectPoint = 60,--该类型采集点不能采集走
    UIPVEPowerLack = 61,--pve战斗不能攻击面板，没有配置条件类型走跳过
    HasAlliance = 62,--没有联盟走跳过
    AllianceOwnCity = 63,--玩家所在联盟赛季占领城大于等于配置个数走跳过
    OwnDesertCount = 64,--玩家所在赛季占领地块大于等于配置个数走跳过
    Season = 65,--当前赛季不是配置赛季走跳过
    InPveLevelId = 66,--当前不是配置关卡id走跳过
    Activity = 67,--配置活动id没开走跳过
    HasAllianceCenter=68,--有联盟中心跳过
    IsR4OrR5 = 69,--是r4或r5跳过
    FirstPay = 71,--买过首充走跳过
    StoryReward = 72,--探险阶段宝箱不能领取奖励走跳过
    IsNewDailyActivity = 73,--老版本日常活动走跳过
    IsOpenBooster = 74,--大本不是最大功率走跳过
    IsFinishMeal = 75,--厨师全部做完饭走跳过
    IsFurnitureLevel = 76,--配置建筑中的配置家具是配置等级走跳过
    BuildWorkerNum = 77,--配置建筑中已上阵的工人数量是配置数量走跳过
    BetweenPveLevel = 78,--当前处于配置关卡之间走跳过
    NoFinishLandOrder = 79,--没完成配置地块走跳过
    FinishParkour = 80,--完成配置关卡走跳过
    IsResidentCome = 81,--没有小人到来走跳过
    HaveAnyPanel = 82,--当前有任意界面打开走跳过
    UIFormationTableNewViewNoAddHero = 83,--英雄编队界面没有可上阵英雄(或已上满)走跳过
    QuestHasReward = 84,--配置任务已领取奖励走跳过
    HeroLevel = 85,--配置英雄等级大于等于配置等级走跳过
    LandBlockState = 86,--配置地块不是配置状态走跳过
    ClickPay = 87,--点击支付按钮走跳过
    HeroCurLevelMax = 88,--配置英雄达到当前等级上限走跳过
    OwnHero = 89,--没有配置英雄走跳过
    HaveUpLevelHero = 90,--没有可升级英雄走跳过
}

--不可点击类型
UINoInputType =
{
    ShowNoScene = 1,
    ShowNoUI = 2,
    Close = 3,
}
UIMovingType =
{
    Open = 1,
    Close = 2,
}

UIMigrateType =
{
    Open = 1,
    Close = 2,
}

UIEnterDragonType =
{
    Open = 1,
    Close = 2,
}

UIQuitDragonType =
{
    Open = 1,
    Close = 2,
}

UISetEdenType =
{
    Open = 1,
    Close = 2,
}
--建造坐标点类型
PositionUnitType =
{
    InCityCanBuildPoint = 5,--城内的可建造点
    NoBuildPoint = 6,--不可建造点
}

SpecialGuideLogType =
{
    RocketLandingClickJump = 1103,--cs播放时，点击跳过按钮
    ShowFoodBoxFinger = 1110,--面包店，放下后变成盒子，出现手指时打点
    PlaneRuinTimelineJump = 1112,--火箭坠毁timeline点击跳过
    PlaneRuinTimelineShow = 1200,--火箭坠毁timeline刚开始播放
    PlaneRuinTimelineHello = 1201,--火箭坠毁timeline舰长打招呼
    PlaneRuinTimelineRuin = 1202,--火箭坠毁timeline坠落
}

ABTestType =
{
    A = "0",
    B = "1",
}
DestroyBuildType =
{
    Self = 0,
    Other = 1,
}
DestroyRankType =
{
    Blood = 0,--伤害排行
    Stamina = 1,--耐久排行
}

-- 英雄驻扎状态
HeroStationState =
{
    Current = 1, --已驻扎在当前建筑
    Idle = 2, -- 闲置
    Other = 3, -- 已驻扎在其他建筑
    Namesake = 4, -- 已有同名英雄驻扎
    Disabled = 5, -- 不可用
}

ArrowPrefabName =
{
    [GuideArrowStyle.Finger] = UIAssets.WorldYellowArrow,
    [GuideArrowStyle.Green] = UIAssets.WorldArrow,
    [GuideArrowStyle.Yellow] = UIAssets.WorldYellowArrow,
}
HeroStationEffectType =
{
    Normal = 0, -- 普通作用号

    -- 策划给了的
    GlobalMoney = 1, -- 全局金币产量
    StorageLimit = 2, -- 仓库上限
    HeroExp = 3, -- 英雄经验
    TroopLimit = 4, -- 带兵上限

    -- 策划没给的
    TradeCenterMoney = 10001, -- 火箭额外金币
}

HeroStationSkillEffectType =
{
    [1000] = HeroStationEffectType.GlobalMoney,
    [1001] = HeroStationEffectType.StorageLimit,
    [1002] = HeroStationEffectType.TroopLimit,
    [1003] = HeroStationEffectType.HeroExp,
}
FormationAddSoldierType =
{
    TrainSoldier = 13,--训练士兵
    ThirdHeroBuild =14,--上阵第三个英雄
    KillMonster = 15,--击杀低级怪物
    RadarMonster = 16,--雷达怪物
    FormationScience = 17,--车库科技
    HeroUpgrade = 24,---英雄升级
    HeroExchange = 25,--英雄替换
    TrainHighSoldier = 1004,--训练高级士兵
    HeroPowerAdd = 1005,--英雄提升实力
    GarageUpgrade = 1006,--车库改造
}

--播放timeline需要点击的气泡

GuideTimeLineBubbleType =
{
    OstrichEgg = 1,--鸵鸟蛋
    ZeroRocket = 2,--大本0升1火箭
    Migrate = 3,--移民气泡
    Cow = 4,--奶牛气泡
}

--引导主UI显示类型
GuideUIMainShowType =
{
    Hide = 1,
    Show = 2
}

--建筑中心区域类型
BuildZoneType =
{
    No = -1,--不可建造区域
    All = 0,--任意类型都可建造区域
    Tower = 1, -- 居民区
    Hero = 2, -- 工业区
    Trade = 3, -- 商业区 
    Military = 4, -- 军事区 
}

BuildZoneName =
{
    [BuildZoneType.Tower] = 100810,
    [BuildZoneType.Hero] = 100811,
    [BuildZoneType.Trade] = 100812,
    [BuildZoneType.Military] = 100813,
}

--建筑中心区主辅类型
BuildZoneMainType =
{
    Sub = 0,--普通建筑
    Main = 1,--中心建筑
}

StationIdList =
{
    BuildZoneType.Tower,
    BuildZoneType.Trade,
    BuildZoneType.Military,
    BuildZoneType.Hero,
}

StationBuildId =
{
    [BuildZoneType.Tower] = BuildingTypes.FUN_BUILD_MAIN,
    [BuildZoneType.Hero] = BuildingTypes.FUN_BUILD_RADAR_CENTER,
}

ComplexTipType =
{
    Text = 1,
    Image = 2,
    Hero = 3,
}

--建筑气泡状态
BubbleState =
{
    Normal = 1,
}

ClickUISpecialBtnType =
{
    UIFormationSelectHero = 1,
    UIFormationDeleteHero = 2,
    UIFormationTableAddHero = 3,
    UIPVESceneMinHeroRarity = 4,--手指指向上阵中稀有度最低的英雄
    UIPVESceneHeroId = 5,-- 表示手指指向配置英雄 para2填写英雄id
    UIPVESceneHeroRarity = 6,--表示手指指向未上阵中该品质英雄 para2填写英雄品质
    UIHeroListCanAdvanceHero = 7,--表示手指指向英雄列表可以突破的英雄
    UIScience = 8,--表示手指指向科技树界面配置科技
    UIBuildUpgradeLackResource = 9,--表示手指指向升级界面缺少的资源
    UIHeroAdvanceMainHero = 10,--表示手指指向英雄晋级界面晋级的英雄
    UIHeroAdvanceSubHero = 11,--表示手指指向英雄晋级界面消耗海报的英雄
    UIHeroListAdvanceHero = 12,--表示手指指向英雄列表界面可进阶英雄
    UIHeroListHeroId = 13,--表示手指指向英雄列表配置的英雄
    UIHeroListStarHero = 14,--表示手指指向英雄列表界面可升星英雄
    UITaskMainQuestBtn = 15,--表示手指指向任务界面任务按钮
    UIPVESceneMaxHeroRarity = 16,--表示手指指向pve未上阵中最强的英雄
    UIFormationTableNewFreeSlot = 17,--表示手指指向编队界面第一个空位
    UIFormationTableNewFreeHero = 18,--表示手指指向编队界面第一个可上阵空闲的英雄
}

--协议用了字符串，所以
NationType = {
    UnitedNations = "1",
    China = "2",
    America = "3",
}

PlayerNations = {
    {
        Nation = NationType.UnitedNations,
        Flag = "",
        Name = "",
    },
    {
        Nation = NationType.China,
        Flag = "",
        Name = "",
    },
    {
        Nation = NationType.America,
        Flag = "",
        Name = "",
    },
}

ChatReportType = {
    Politics = 1,
    Ads = 2,
    Gambling = 3,
    Gm = 4,
    Sexy = 5,
    Attack = 6,
    NickName = 7,
    HeadIcon = 8,
    Other = 9,
}

AllianceMineStatus = {
    Normal = 0,--正常
    Constructing = 1,--建造中
    Ruin = 2,--废墟态
}

--continuously
AlMineConditionType = {
    MemberCount = 1,
    Power = 2,
    RuinLv = 3,
    PreBuild = 4,
}

LeagueMatchTab = {
    Activity = 1,--活动
    Compete = 2,--对决
    AllianceRank = 3,--联盟排名
    DrawLots = 4,--抽签
    Notice = 5,--开启预告
    CrossServer = 6,--跨服
    CrossServerDesert = 7,--??
}

LeagueMatchStage = {
    None = 1,
    Notice = 2,
    DrawLots = 3,
    DrawLotsFinished = 4,
    Compete = 5,
    WeeklySummary = 6,
    FinalSummary = 7,
}

SegmentType = {
    None = 0,
    Silver = 1,
    Gold = 2,
    Diamond = 3,
}


ActivityOverviewType = {
    RallyBossAct = 2,--沙虫集结
    ChampionBattle = 4,--冠军对决
    MineCave = 5,--矿洞探险
    Puzzle = 6,--寻宝活动
    EverydayTask = 10,--每日任务
}

OverviewToActType = {
    [ActivityOverviewType.RallyBossAct] = EnumActivity.RallyBossAct.Type,--集结奖励
    [ActivityOverviewType.MineCave] = EnumActivity.MineCave.Type,--矿洞探险
    [ActivityOverviewType.Puzzle] = ActivityEnum.ActivityType.Puzzle,--星际寻宝
}

TreasureId = {
    EnergyTreasure = 10000,
}

MineCavePlunderType = {
    DefenseFail = 1,
    DefenseWin = 2,
    AttackWin = 3,
    AttackFail = 4,
}

--ThemeActivityIcon = {
--    ["1"] = "",
--    
--}

OverviewTypeToDailyActivity = {
    [2] = {
        Type = EnumActivity.RallyBossAct.Type,
        ActId = EnumActivity.RallyBossAct.ActId,
    },
    [5] = {
        Type = EnumActivity.MineCave.Type,
        ActId = EnumActivity.MineCave.ActId,
    },
    [6] = {
        Type = ActivityEnum.ActivityType.Puzzle,
        ActId = nil,
    },
}

AlMoveInviteType = {
    None = 0,
    SystemInvite = 1,
    LeaderInvite = 2,
    InviteTip = 3,
}

MoveCityTipType = {
    AlMoveInvite = 0,--邀请
    CommonMove = 1,--迁城确认
    SystemInvite = 2,
    LeaderInvite = 3,
    RallyCheck = 4,
}

ConsumeItemType = {
    AlMoveCity_LeaderInvite = 1,--联盟迁城
    AlMoveCity_SysInvite = 2,--联盟迁城
}


TranslateType = {
    MailInfo = 1,
    ChatMessage = 2,
}

WelfareMessageKey =
{
    GrowthPlanInfo = 1,
}

--今日不提示类型
TodayNoSecondConfirmType =
{
    UpgradeUseDiamond = "UpgradeUseDiamond",--升级使用钻石（秒建筑，秒科技，秒兵，秒伤兵）
    BuyUseDialog = "BuyUseDialog",--买加速，买资源
    AutoDig = "AutoDig",--挖掘寻宝自动挖掘
    LuckyShopRefresh = "LuckyShopRefresh",--幸运折扣商店刷新
    HeroPluginUpgradeSpecialTag = "HeroPluginUpgradeSpecialTag",--英雄插件升级特殊属性消失
    ResourceReplenish = "ResourceReplenish",--资源一键补齐
    MineCaveRefresh = "MineCaveRefresh",--矿洞刷新
    SpeedReplenish = "SpeedReplenish", --通用加速面板
    RefreshDispatchTask = "RefreshDispatchTask",-- 使用钻石刷新派遣任务
    RefreshBestDispatchTask = "RefreshBestDispatchTask", -- 如果玩家有未开始派遣的橙色任务，会弹出确认框让玩家二次确认
}

--不提示类型
NoSecondConfirmType =
{
    ProductReserve1 = "ProductReserve1",--造预备兵
    JoinAlliance = "JoinAlliance",--加入联盟
}

--任务显示类型
QuestShowType =
{
    No = 0,
    Show = 1,
}

RedPacketState = {
    ALREADY_GET  = 0, --已经获取
    VALID        = 1, --未获取
    COST_ALL     = 2, --领完了
    TIMEOUT      = 3, --超时
    PREPARE_SEND = 4, --待发送
}

-- 车库BuildId
GarageBuildIds =
{
    BuildingTypes.FUN_BUILD_TRAINFIELD_1,
    BuildingTypes.FUN_BUILD_TRAINFIELD_2,
    BuildingTypes.FUN_BUILD_TRAINFIELD_3,
    BuildingTypes.FUN_BUILD_TRAINFIELD_4,

}

PackTimeType =
{
    Regular = 1, -- 定时出现，定时消失
    Always = 2, -- 长期出现，永不消失
    Conditional = 3, -- 条件出现，定时消失
    -- 4
    ByTrigger = 5, -- 条件触发，定时消失，消失后可重复触发
    AlwaysByWeek = 6, -- 跨周的2，start同2，end为结算日
    Controlled = 7, -- 根据条件出现，条件不符合或者倒计时结束后消失
    AlwaysHideTime = 8, -- 长期出现，永不消失 不需要填start和time这样不会显示礼包消失时间
    Periodic = 9, -- 以一个周期循环出现，start填初始出现时间点;循环时间 如2021-09-10-00-00;86400 time填一次持续时间
}

ShareCheckType = {
    MailScoutResult = 1,--侦查邮件
    MailBattleReport = 2,--战报邮件
}

-- 主页礼包中心按钮
UIMainIconPrefab =
{
    ["PiggyBank"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_PiggyBank.prefab",
    ["EnergyBank"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_EnergyBank.prefab",
    ["SellCatgirl"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellCop"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellConsigliere"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellDetective"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellSumo"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellClown"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellMishu"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["SellWinterHouse"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_SellHero.prefab",
    ["Robot0"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["Robot1"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["Robot2"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["Robot3"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["Robot4"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["Robot5"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Robot.prefab",
    ["SellDiamond"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Packstore.prefab",
    ["SellCoin"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Packstore.prefab",
    ["SellHeroCommon"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Packstore.prefab",
    ["SellSpeedCommon"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Packstore.prefab",
    ["SellXmas"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Packstore.prefab",
    ["UIMain_icon_hero1"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_hero1.prefab",
    ["UIMain_icon_Onestepahead"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Onestepahead.prefab",
    ["UIMain_icon_HeroLegend"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_HeroLegend.prefab",
    ["UIMain_icon_Invincible"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_Invincible.prefab",
    ["UIMain_icon_firstPay"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_firstPay.prefab",
    ["UIMain_icon_HeroMedal"] = "Assets/Main/Prefab_Dir/UI/UIMain/UIMain_icon_HeroMedal.prefab",
}

ShowResTypes =
{
    ResourceType.Food,
    ResourceType.Plank,
    ResourceType.Electricity,
    ResourceType.Steel,
}

SysAlState = {
    WaitMerge = -2,--待合盟
    Normal = -1,--普通盟
    SignUp = 0,--报名参选盟主
    R4Elect = 1,--投票选择R4
    R4Reuslt = 2,--R4结果展示
    LeaderElect = 3,--票选盟主
    LeaderResult = 4,--盟主展示
    MergeTime_1 = 5,--合盟考察期1（修改宣言和盟名称）
    MergeTime_2 = 6,--合盟考察期2
}

EffectReasonType =
{
    Science = 0,--科技
    Building = 1,--建筑
    Hero = 2,    --英雄
    VIP = 3,--VIP
    MONTH_CARD = 4,--月卡
    PLAYER_LEVEL = 5,--玩家等级
    Hero_Station = 6,--英雄驻扎
    Science_Activity = 7,--科技活动（最强战区）
    Alliance_Science = 8,-- 联盟科技
    World_Alliance_City = 9, --联盟城市
    Status = 10,--buff
    Tank = 11,--车库改造
    Career = 12,--职业
    Alliance_Career = 13,--联盟职业
    Land = 14,--地块
    SERVER_EFFECT = 15,--服务器作用号
    BASE_TALENT = 16, --大本天赋
    Mastery = 17, -- 专精
}
BuffReasonIcon = {}
BuffReasonIcon[EffectReasonType.Science] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_technology"
BuffReasonIcon[EffectReasonType.Hero] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_hero"
BuffReasonIcon[EffectReasonType.VIP] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_vip"
BuffReasonIcon[EffectReasonType.BASE_TALENT] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_HQ-Talent"
BuffReasonIcon[EffectReasonType.Building] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_console"
BuffReasonIcon[-1] = "Assets/Main/Sprites/UI/UIBuild/UIBuild_icon_robot_other"

--AB测试可以开放的国家
UseABTestCountry =
{
    "IN","CN","PH","ID","GB",
}

-- 开荒种植状态
Wasteland_PlantState = {
    ToPlant = 1,  -- 需要播种
    ToWater = 2,  -- 需要浇水
    ToReap = 3,   -- 需要收割
}

--联盟职业位置
AllianceCareerPosType =
{
    No = 0,--未委任
    Yes = 1,--委任
}

--联盟职业作用值显示类型
AllianceCareerEffectDescriptionType =
{
    AddCount = 2,--加整数
    SubCount = 3,--减整数
    AddPercent = 4,--加百分比
    SubPercent = 5,--减百分比
}

AllianceCityNewsType = {
    OCCUPY_NEUTRAL_CITY = 0,--自然联盟城占领
    OCCUPY_OCCUPIED_CITY = 1,--抢夺联盟城占领
    FIRST_NEUTRAL_CITY  =2,--首次占领联盟城
}
AllianceCityRecordState = {

    CURRENT = 0, --// 0 当前记录
    HISTORY = 1, --// 1 历史记录
    HISTORY_FIRST_OCCUPY = 2, --// 2 历史首占
}

BattleNewsType={
    Battle = 0,
    AllianceCity = 1,
}

UITipDirection = {
    ABOVE  = 1,
    BELOW  = 2,
    LEFT   = 3,
    RIGHT  = 4,
}

AllianceAlertType  = {
    BUILDING = 0,  -- 建筑
    COLLECT = 1,  -- 采集
    ALLIANCE_CITY = 2,   -- 联盟城
    DESERT = 3, --地块
    ALLIANCE_BUILD = 4,--联盟建筑
    DRAGON_BUILDING = 5,--战场建筑
}

AllianceTaskFuncType = {
    AllianceMoveCity = 2,--联盟迁城
    AllianceScience = 3,--联盟科技
    AllianceCareer = 4,--联盟职业
}

GuidePrologueFlag =
{
    Start = 0,--开始
    End = 1,--结束
}

BuyFlag = {
    NOT_BUY = 0,--未购买
    BUY = 1,--已购买
}

HeroMonthCardRewardState = {
    REWARD_STATE_CAN_RECEIVE = 1,--可领取
    REWARD_STATE_LOCK = 2,--锁定状态
    REWARD_STATE_RECEIVED = 3,--已经领取
    REWARD_STATE_UNRECEIVED = 4,--已买但是不可领取
}

SeasonForceRewardStatus = {
    NOT_RECEIVE = 0,-- 0 未领取
    RECEIVED = 1, --1 已领取
    BATTLE_PASS_RECEIVED = 2, -- 2 battlepass已领取
}
SeasonForceRewardPackageType = {
    CRYSTAL_BOX = 0,
    MONEY = 1,

}

CareerType =
{
    None = 0,
    Admiral = 1, -- 总督
    Raider = 2, -- 掠夺者
    Merchant = 3, -- 商人
    Farmer = 4, -- 农民
    Guard = 5, -- 军人
}

QuestionAndAnswerType = {
    Q_A_TYPE_NPC = 2,
    Q_A_TYPE_NPC_ALL_RIGHT = 3,
}

GuideBuildState =
{
    Normal = 1, --正常状态-不在升级中、不需要连路、不是盒子状态、不是废墟
    Box = 3,--盒子状态-是盒子，不管是不是需要修路
}

GuideNpcDoNextType =
{
    Auto = 0,--立刻做下一步
    WaitWalk = 1,--等待走完/旋转完在做下一步
    WaitWalkDelete = 2,--立刻做下一步,等待走完/旋转完立刻删除
}

SceneManagerSceneID =
{
    None = 0,
    City = 1, -- 主城
    World = 2, -- 世界
    PVE = 3, -- PVE场景
}

PveStatus =
{
    FirstStart = 0, -- 首次开始
    MultiStart = 1, -- 多次开始
    Finish = 2, -- 结束
}

CurScene =
{
    PVEScene = -99,
}

PveType =
{
    C_5v5 = 1,
    B_Parkour = 2,
}

PveLevelType =
{
    NormalLevel = 1,
    HeroExpLevel = 2, -- 英雄经验
    FightLevel = 3,   -- 直接进入PVE战斗
    NormalExpLevel = 4, -- 有经验水晶的普通关
    BattleExpLevel = 5, -- 战斗经验关
    RadarExpLevel = 6, -- 雷达经验关 (直接进入PVE战斗)
    BattlePlayBackLevel = 7,--战斗回放关
    ZombieLevel = 9, -- 丧尸经验关
    SkillLevel = 10,--砍树放技能关
    ArmyLevel = 11, -- 带兵关卡
    CoinExpLevel = 12, -- 金币经验关
    StoryLevel = 13, -- 推图关
    GuideLevel = 14, -- 引导关卡
}

PveEntrance =
{
    Test = 0, -- 测试
    DetectEventPve = 3, -- 事件pve
    MineCave = 5,--矿洞
    ArenaBattle = 6,--竞技场战斗
    ArenaSetting = 7,--竞技场设置阵容
    BattlePlayBack = 8,--战斗邮件回放
    Story = 14, -- 推图
    Guide = 15, -- 引导进pve
    LandBlock = 16, -- 地块地格
    SiegeBoss = 17, -- 丧尸围城
}

PveSweepType =
{
    No = 0,
    Yes = 1,
}

ResPointType =
{
    Normal = 0,--普通矿
    Alliance = 1,--联盟矿
}

PuzzleTaskState = {
    PuzzleTaskState_UnComplete = 0,--0未完成
    PuzzleTaskState_Complete = 1,--已完成可领奖
    PuzzleTaskState_Reward_Get = 2,--已经领奖
}

PuzzleStageRewardState = {
    PuzzleStageRewardState_UnGet = 0,--0未领奖
    PuzzleStageRewardState_Get = 1,--已领奖
}

PveBuffType =
{
    No = 0,--不显示
    Speed = 1,--加移速
    AttackAnim = 2,--旋风斩
    WeaponBigger = 3,--武器变大
    Player = 4,--获得一个小人
    AttackQuick = 5,--频率上升
    AddAttack = 6,--攻击上升
    Stun = 7,--晕眩
}

AllianceFlagBgColor = {
    Color.New(0.4, 0.76, 0.99),
    Color.New(0.21, 0.86, 0.89),
    Color.New(0.65, 0.89, 0.23),
    Color.New(1, 0.78, 0),
    Color.New(0.99, 0.52, 0.15),
    Color.New(0.89, 0.35, 0.06),
    Color.New(0.99, 0.37, 0.78),
    Color.New(0.88, 0.42, 1),
    Color.New(0.56, 0.47, 0.9),
}

AllianceFlagFgColor = {
    Color.New(0.9, 0.95, 1),
    Color.New(0.9, 0.99, 0.9),
    Color.New(0.99, 0.98, 0.89),
    Color.New(1, 0.98, 0.87),
    Color.New(0.99, 0.93, 0.89),
    Color.New(0.99, 0.87, 0.87),
    Color.New(0.99, 0.90, 0.97),
    Color.New(0.9, 0.98, 0.9),
    Color.New(0.91, 0.94, 1),
}

PveBuffTimeType =
{
    Time = 1,--有持续时间
    Always = 2,--一直生效
}

UIPveSelectBuffOrder =
{
    PveBuffType.AddAttack,
    PveBuffType.Speed,
    PveBuffType.Player,
}

PveResultShowType =
{
    Normal = 0,
    Pass = 1,
}

LotteryTimeType = {
    LotteryTimeType_Normal = "0",--普通招募
    LotteryTimeType_Expert = "3",--高级招募
}

LotteryClassType = {
    LotteryClassType_NORMAL = 100,--普通招募
    LotteryClassType_Expert = 101,--高级招募
}

LotteryDisPlayType = {
    LotteryDisPlayType_Normal_And_Expert = 1,--普通,高级招募
}

SaveBobSceneState =
{
    NoSave = 1, --没救
    PlayTimeLine = 2, --正在救
    Saved = 3,--已经救完
}

PveHasUseBattleHeroType =
{
    Any = 1, --没有任何可上阵英雄跳过
    HeroId = 2, --该英雄不可上阵跳过（判断当前上阵最大数量）
    HeroQuality = 3,--没有该稀有度英雄可上阵跳过
    HeroIdWithoutMax = 4, --该英雄不可上阵跳过（不判断当前上阵最大数量）
    HeroQualityWithoutMax = 5, --没有该稀有度英雄可上阵跳过（不判断当前上阵最大数量）
    HeroMaxQualityWithoutMax = 6, --没有可替换更高品质英雄跳过（不判断当前上阵最大数量）
}

ExpSource =
{
    GM = 0,
    Building = 3, -- 建筑
    Science = 4, -- 科技
    Army = 5, -- 士兵
    Order = 6, -- 订单
    Reward = 7, -- 奖励
    KillMonster = 9, -- 打怪
}

--引导手指移动需不需要等待播1遍动画类型
UIGuideMoveArrowNeedWaitType =
{
    No = 0,--不需要等 直接可以点击
    Yes = 1,--需要等动画播放一遍后才可以点击
}

--建筑状态（位表示法）
BuildQueueState =
{
    DEFAULT = 0,--正常状态
    TRAINING = 1,--训练/晋级士兵状态
    CURE_ARMY = 2,--治疗伤兵
    RESEARCH = 3,--研究科技
    STORAGE_SHOP = 7,--交易行
    UPGRADE = 16,--建造/升级
    Ruins = 128,--废墟状态
}

ConsumeType = {
    ConsumeType_Nil = 0,
    ConsumeType_Resource_Item = 1,
    ConsumeType_Resource = 2,
    ConsumeType_Item = 3,
}

--英雄委托完成状态
HeroEntrustState =
{
    No = 0,--未完成
    Yes = 1,--全部完成
}

ResLackType = {
    Res  = 1,
    Item = 2,
    Speed = 3,
    HeroExp = 4,
    Percent = 5,
    DesertNum = 6,
    HeroEquip = 10,
}

ResLackGoToType =
{
    Monster = 6,--打怪
    Collect = 7,--采集
    Science = 10,--研究科技
    ResourceBagUse = 11,--资源背包(使用)
    TrainNewSoldier = 13,--训练新的士兵
    MarchMoreHero = 14,--上阵第三个英雄
    KillLevelMonster = 15,--击杀低等级怪物
    Radar = 16,--完成雷达
    UpgradeHero = 24,--升级英雄
    ChangeHero = 25,--替换高品质英雄
    Task = 26,--任务
    BuyGiftShop = 27,--购买礼包   跳转礼包商城
    MonthCard = 32,--开通月卡
    BuildBuyItem = 41,--紫水晶购买道具
    BuyGiftNew = 44,--购买礼包 道具不足   直接购买
    CommonShop = 45,--购买道具 目前是限时商店
    ActDaily = 46,--跳转日常
    BuyPveStamina = 48,-- 购买体力
    UseBuildGoods = 52,--使用建筑自选箱子开启指定资源道具
    HeroBreak = 60,--英雄突破
    BuyFirstPay = 61,--购买首充
    ActSevenDay = 66,-- 前往七日活动
    GotoBuildAndOpen = 67,-- 跳转到建筑，para1填建筑id;按钮id
    GoDayTask = 69,-- 前往每日任务
    RecruitHero = 71,-- 招募强力英雄
    GoSearchBoss = 72,-- 搜索集结怪
    HeroMonth = 74,-- 英雄月卡
    GoWindowAllianceBat = 75,-- 联盟对决
    GoDesert = 76,-- 跳转赛季地块、
    GoSeasonTask = 77,-- 跳转赛季任务
    GoActWin = 78,--跳转赛季
    DailyFreeEnergy = 79,--英雄技能 每日免费体力
    BuyGiftPackageByRechargeId = 80,--跳转礼包商城根据rechargeId
    SeasonPass = 81,--赛季pass
    SeasonWeek = 82,-- 赛季周卡
    SeasonGroundManage = 83,-- 赛季地块管理
    AllianceShop = 84,--  联盟迁城购买 联盟商店
    SeasonMasteryDesert = 85,--  赛季专精地块
    ActPersonalArmy = 86,--人军备宝箱奖励阶段
    BuyGiftGroup = 87,--多个道具礼包
    ActAllianceArmy = 88,--联盟军备宝箱奖励阶段
    ChampionBattle = 90,--冠军对决奖励
    ItemUseChoose = 92,--使用道具自选箱
    GoStoryMain = 93,--打开关卡界面

    Build = 1001,--去建筑（没有就建造， 如果家具建筑有空闲工作位，调去工作，没有就去升级）
    ResourceBuyItem = 1002,--钻石购买资源
    GoBuildGetStamina = 1003,--跳转建筑领取体力

    HeroEquip = 2003,--装备工厂合成
    HeroEquipItemCompose = 2004,--装备工厂合成
    HeroEquipItemCollect = 2005,--收取材料
    HeroEquipItemUse = 2006,--缺装备时使用道具
    GoChapterTask = 2007,--跳转章节任务
    BuyGiftResNew = 9999,--购买礼包 资源不足  直接购买  此类型手动添加
}

ResLackTypeNew =
{
    Equip = 1,          --装备
    MasteryPoint = 2,   --赛季专精
    TitleSkin = 3,      --称号
    HeroEquip = 10,         --英雄装备
}

--npc气泡对话框类型
NpcTalkType =
{
    Left = 1,--左侧
    Right = 2,--右侧
    HeroEntrust = 3,--英雄委托
}

--英雄委托消耗材料类型
HeroEntrustNeedType =
{
    Resource = 2,--资源
    Goods = 3,--道具
}
--编队出征打完是否回家
MarchAutoBackType =
{
    NoBack = 0,--不回家，停在原地
    Back = 1,--回家
}

--是否有联盟标志
HaveAllianceType =
{
    Yes = 1,
    No = 2,
}

--npc气泡持续类型
NpcBubbleStayType =
{
    Trigger = 1,--触发类型，靠近显示
    All = 2,--一直显示
    Time = 3,--过时间自动消失
}

BattleBuffGroup =
{
    Default = 0,
}

BattleBuffType =
{
    Effect = 0, -- 作用号
    Skill = 1, -- 技能
    DisableHero = 3, -- 禁用英雄
    HireHero = 4, -- 雇佣英雄
}

BattleBuffTimeType =
{
    Normal = 0, -- 永久
    Battle = 1, -- 战斗次数
    Time = 2, -- 时间限制
}

HeroAdvanceConsumeType = {
    ConsumeType_Same_Hero = 1,
    ConsumeType_Same_Camp = 2,
}

--资源采集特效名字
ResourceTypePickUpEffectName = {}
ResourceTypePickUpEffectName[ResourceType.Electricity] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shandian.prefab"
ResourceTypePickUpEffectName[ResourceType.Metal] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shuijing.prefab"
ResourceTypePickUpEffectName[ResourceType.Oil] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_wasi.prefab"
ResourceTypePickUpEffectName[ResourceType.Water] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_water.prefab"
ResourceTypePickUpEffectName[ResourceType.Money] = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_jinbi.prefab"

--成功出征的标志
SuccessMarchFlagType =
{
    No = 0,--未成功出征
    Yes = 1,--成功出征
}

--假玩家显示的类型
ShowFakePlayerFlagType =
{
    Show = 1,--显示
    Hide = 2,--删除
}

--pve建筑商店触发点方向
PveBuildTriggerDirection =
{
    Bottom = 1,--下方
    Left = 2,--左方
    Top = 3,--上方
    Right = 4,--右方
}

--世界垃圾点显示类型
ShowWorldCollectPointType =
{
    Show = 1,--显示
    Hide = 2,--隐藏
}

--引导设置出征特殊类型
SetAttackGuideFlag =
{
    NoBackAndWaitResult = 1,--攻击后不回家，直接出征省略最高等级判断并等待出征结果
    WaitResult = 2,--攻击后回家，直接出征省略最高等级判断并等待出征结果
}

--引导设置气泡显示/隐藏
BubbleShowType =
{
    Show = 1,--显示
    Hide = 2,--隐藏
}

AccountViewType =
{
    Bind = 1,--绑定账号
    Question = 2,--调查问卷
}


--引导设置坦克显示/隐藏
TankShowType =
{
    Show = 1,--显示
    Back = 2,--隐藏
}

--引导设置加载遮罩界面显示/消失
ShowLoadMaskType =
{
    Show = 1,--显示
    Hide = 2,--消失
    ClickNext = 3,--点击之后下一步
}

WeekType =
{
    "372307",
    "372308",
    "372309",
    "372310",
    "372311",
    "372312",
    "372313",
}

NoticeEquipDelays =
{
    [UIWindowNames.UIRecruitLotteryTip] = 3,
    [UIWindowNames.UISoliderGetTip] = 3,
    [UIWindowNames.UIGarageRefit] = 3,
}

--shader类型
ShaderEffectType =
{
    ShakeWhite = 1,--砍树闪白
    FurnitureFlash = 2,--家具选中变亮
}
--引导多语言参数特殊类型
GuideTalkDialogType =
{
    AllianceName = 1, --获取联盟名字
}

--引导设置触发点显示/消失
PveTriggerVisibleType =
{
    Show = 1,--显示
    Hide = 2,--消失
}
--引导设置物体显示通用枚举
GuideSetNormalVisible =
{
    Show = 1,--显示
    Hide = 2,--消失
}

NewMarchType =
{
    DEFAULT =-1,--初始状态
    NORMAL = 0, --0 普通出征
    ASSEMBLY_MARCH = 1, --1 联盟出征
    MONSTER = 2, -- 2 怪物
    BOSS = 3,-- 3 BOSS
    SCOUT = 4,--4 侦查
    EXPLORE = 5,--5 探索
    RESOURCE_HELP = 6,--6资源援助
    GOLLOES_EXPLORE = 7,--7咕噜探索
    GOLLOES_TRADE = 8,--8咕噜商队
    ACT_BOSS = 9, --9 活动BOSS
    PUZZLE_BOSS = 10, --10 拼图BOSS
    DIRECT_MOVE_MARCH = 11, --11 非自由行军，不可操作
    CHALLENGE_BOSS = 12,--12 挑战BOSS    
    MONSTER_SIEGE = 13,--13 黑骑士攻城
    ALLIANCE_BOSS = 14, --14 联盟boss
}

--主城内小车和人显示类型
CityPeopleAndCarVisibleType =
{
    AllShow = 1,--全部显示
    AllHide = 2,--全部隐藏
}

--pve触发点需要交付的类型
TriggerNeedType =
{
    Resource = 1,--资源
    Goods = 3,--物品
}

--小人攻击
AttackAnimDirection =
{
    LeftToRight = 1,--左到右
    RightToLeft = 2,--右到左
    Circle = 3,--旋风斩一圈
}

--pve砍的资源类型
PveAtomType =
{
    Tree = 0,--树
    Stone = 1,--石头
}

--引导设置物体显示通用枚举
PveShowBloodType =
{
    No = 0,--不显示
    Show = 1,--显示
}

--建筑最大可建造数量类型
BuildMaxNumType =
{
    Cur = 1,--当前可建造最大
    Guide = 2,--引导可建造最大
    Quest = 3,--任务可建造最大
    Chapter = 4,--章节可建造最大
}

--pve配置初始是否可以显示技能
PveShowSkill =
{
    Show = 0,--可以显示
    No = 1,--不显示
}

HeroAdvanceGuideSignalType =
{
    Enter = 1,--进入英雄进阶引导（重新布局、排序）
    ShowMainHeroBlack = 2,--显示进阶英雄黑色遮罩
    HideMainHeroBlack = 3,--隐藏进阶英雄黑色遮罩
    ShowSubHeroBlack = 4,--显示消耗海报黑色遮罩
    HideSubHeroBlack = 5,--隐藏消耗海报黑色遮罩
    ShowHeroStarUpBlack = 6,--显示升星黑色遮罩
    HideHeroStarUpBlack = 7,--隐藏升星黑色遮罩
}

FogType =
{
    Black = 0,--黑色迷雾（关卡规则默认都有迷雾）
    White = 1,--白色迷雾（关卡规则默认打开迷雾）
}

QuestBubbleType =
{
    None = 0,
    World = 1,  --世界
    Pve = 2,    --pve
}

ActMonsterTowerDiff =
{
    [1] = "tower_icon_green",
    [2] = "tower_icon_blue",
    [3] = "tower_icon_purple",
    [4] = "tower_icon_orange",
    [5] = "tower_icon_red",
}
--火箭状态
RocketStatus = {
    RocketStatus_Normal = 0,--正常可用状态
    RocketStatus_Preview = 1,--预览状态，只能看不能提交
}

ForceChangeScene = {
    City = 0,
    World = 1
}

PveSelectionType =
{
    Trigger = 1,
    DropReward = 2,
}

--客户端通用需要消耗材料类型
CommonCostNeedType =
{
    Resource = 1,--资源
    Goods = 3,--道具
    Build = 4,--建筑
    Science = 5,--科技
    AllianceScienceConsume = 6,--联盟科技蓝宝石
    Chapter = 7,--需要章节
    RefreshAll = 100,--刷新所有
}

UIBuildDetailTabType =
{
    Build = 1,--显示建筑页
    Detail = 2,--直接显示属性页
}

LodType =
{
    None = 0,
    Custom = 1,
    MainSelf = 1001,--自己的大本（绿色）
    MainAlly = 1002,--盟友的大本（蓝色）
    MainOther = 1003,--本服他人的大本（白色）
    WormHoleSelf = 1004,
    WormHoleAlly = 1005,
    WormHoleOther = 1006,
    Monster = 2001,
    Resource = 2002,
    Explore = 2003,
    Sample = 2004,
    Garbage = 2005,
    MonsterReward = 2006,
    RadarPve = 2007,
    WorldBoss = 2008,
    DisPatchTask =2009,
    TroopSelf = 3001,
    TroopAlly = 3002,
    TroopOther = 3003,
    Ground = 4001,
    Zone = 4002,
    CityLabel = 5001,
    WorldCity = 5002,
    Desert = 5003,
    WorldAllianceBuild = 5004,
    WorldAllianceFlag = 5005,
    MainEnemy = 5007,--敌人的大本（红色）
    WormHoleEnemy = 5008,
    DisPatchTaskEnemy = 5009,
}
SkinType = {
    BASE_SKIN = 1, --基地皮肤
    HEAD_SKIN = 2, --头像框
    TITLE_NAME = 3, --称号
}
MainBuildOrder = {
    Other = 21, --其他
    Enemy = 22, --敌人
    Ally = 23, --盟主
    Leader = 24, --盟友
    Self = 25, --自己
}
BuildBanMoveType =
{
    Yes = 0,--可以移动
    No = 1,--不可移动
}

UIHeroStarProgressType = {
    UIHeroStarProgressType_Slider = 1,
    UIHeroStarProgressType_Block = 2,
}

GuideSceneType = {
    City = 1,
    World = 2,
    Pve = 3,
}

GuideUIBuildListSpecialType = {
    OpenUI = 1,
    Move = 2,
}

GuideMaskType =
{
    UIPveMainResource = 1,
    UIPveMainStaminaSlider = 2,
    UIPveMainBag = 3,
}

GuideMaskTypeSignalType =
{
    UIPveMainResourceShow = 101,--显示pve主界面资源条黑色遮罩
    UIPveMainResourceHide = 102,--隐藏pve主界面资源条黑色遮罩
    UIPveMainStaminaSliderShow = 104,--显示pve主界面体力条黑色遮罩
    UIPveMainStaminaSliderHide = 105,--隐藏pve主界面体力条黑色遮罩
    UIPveMainBagShow = 106,--显示pve主界面背包黑色遮罩
    UIPveMainBagHide = 107,--隐藏pve主界面背包黑色遮罩
}

UIMainTopBtnType =
{
    Stamina = "Stamina",--体力条
    Goods = "Goods",--背包
    Gold = "Gold",--钻石
    Army = "Army",--士兵数量
    ArmyTrap = "ArmyTrap",--陷阱数量
    ArmyReserve = "ArmyReserve",--预备兵
}

GuideOpenPanelType =
{
    Common = 1,--不需要传入参数的页面
    Activity = 2,--活动界面
    FirstPay = 3,--首充界面
    GetNewItem = 4,--获得道具（密码）界面
    DailyActivity = 5,--日常活动界面
    ClickBuild = 6,--点击建筑打开界面
    Bubble = 7,--打开一个气泡
}

PvePowerLackType =
{
    None = 0,
    Power = 1,
    Army = 2,
    Hero = 3,
    Fail = 4,
}

PvePowerLackTipType =
{
    BuildingUpgrade = 4,
    HeroExpBook = 53,
    HeroUpgradeRank = 54,
    HeroUpgradeStar = 55,
    HeroUpgradeSkill = 56,
    TrainUnit = 57,
    HeroHigherLevel = 58,
    HeroHigherPower = 59,
    HeroStrengthen = 60,
    FirstPay = 61,
    MainQuest = 62,
    HeroExpLevel = 65,
    HeroRecruit = 71,
    HeroMonthCard = 74,
    HeroChange = 95,
    HeroEquip = 2009,
    DetectEvent = 2010,

    -- 前端自用，策划不配，-x 代表套用 x 的配置
    HeroExpOrBeyond = -53,
}

PvePowerLackShowTips =
{
    [PvePowerLackType.Power] =
    {
        PvePowerLackTipType.HeroExpBook,
        PvePowerLackTipType.HeroUpgradeRank,
        PvePowerLackTipType.HeroUpgradeStar,
        PvePowerLackTipType.HeroUpgradeSkill,
        PvePowerLackTipType.TrainUnit,
        PvePowerLackTipType.HeroHigherPower,
        PvePowerLackTipType.HeroStrengthen,
        PvePowerLackTipType.FirstPay,
        PvePowerLackTipType.HeroExpLevel,
        PvePowerLackTipType.HeroRecruit,
        PvePowerLackTipType.HeroMonthCard,
    },
    [PvePowerLackType.Army] =
    {
        PvePowerLackTipType.TrainUnit,
    },
    [PvePowerLackType.Hero] =
    {
        PvePowerLackTipType.HeroExpBook,
        PvePowerLackTipType.HeroUpgradeRank,
        PvePowerLackTipType.HeroHigherLevel,
        PvePowerLackTipType.HeroStrengthen,
        PvePowerLackTipType.HeroExpLevel,
    },
    [PvePowerLackType.Fail] =
    {
        PvePowerLackTipType.BuildingUpgrade,
        PvePowerLackTipType.HeroExpBook,
        PvePowerLackTipType.HeroStrengthen,
        PvePowerLackTipType.FirstPay,
        PvePowerLackTipType.HeroRecruit,
        PvePowerLackTipType.HeroEquip,
        PvePowerLackTipType.DetectEvent,
    },
}

BuildListBuffType = {
    BuildListBuffType_SpeedUp = 1,--加速
    BuildListBuffType_Free = 2,--免费时间
    BuildListBuffType_Max = 3,--终止
}

HeroLackTipsType = {
    HeroLackTipsType_Recruit = 1,--招募
    HeroLackTipsType_Debris_Exchange = 2,--碎片兑换
    HeroLackTipsType_First_Charge = 3,--首冲，大小姐
    HeroLackTipsType_Promotion_Gift_Bag = 4,--type16促销礼包
    HeroLackTipsType_Recharge_Gift_Bag = 5,--商城充值活动
    HeroLackTipsType_Activity = 6,--活动中心
    HeroLackTipsType_Detect_Event = 7,--雷达事件
    HeroLackTipsType_Vip = 8,--vip尊享
}

--装扮类型
DecorationType = {
    DecorationType_Main_City = 1,--大本
    DecorationType_Head_Frame = 2,--玩家头像框
    DecorationType_TittleName = 3,--玩家称号
    DecorationType_MarchSkin = 4,--玩家运兵车皮肤
}
--装扮获取类型
DecorationGainType = {
    DecorationGainType_Item_Exchange = 0,--物品兑换
    DecorationGainType_Default = 1,--默认拥有
    DecorationGainType_Month_Card = 2,--月卡使用获得
    DecorationGainType_Female = 3,--女性皮肤
    DecorationGainType_Champions = 4,--冠军对决
    DecorationGainType_Arena = 5,--竞技场
    DecorationGainType_OfficialPosition = 6,--官职
}
DecorationQuality = {
    DecorationQuality_Normal = 1,
    DecorationGainType_Rare = 2,
    DecorationGainType_Epic = 3,
    DecorationGainType_Legend = 4,

}

GuideMoveSeasonDesertType =
{
    OwnLevel = 1,--自己拥有配置等级地块
    Block = 2, --自身占领最近的空地
    AllianceBlock = 3, --视口联盟城最近的空地
    Any = 4,--任意自己拥有的地块
}

BuildStatusType =
{
    TimeBase = 0, -- 时间生效
    FrequencyBase = 1, -- 次数生效
}

BuildStatusType2 =
{
    Default = 0,
}

FormStatusType =
{
    TimeBase = 0, -- 时间生效
    FrequencyBase = 1, -- 次数生效
}

FormStatusType2 =
{
    Default = 0,
    DirectAttackCity = 1, -- 奇袭
    MarchBuff =2, --急救
    MadWarrior = 3,--狂战士
}

FormationName =
{
    [1] = "302032",
    [2] = "302033",
    [3] = "302034",
}

RechargeType =
{
    Normal = 0,
    KeepPay = 1,
    Daily = 2
}

ChainPayBoxState =
{
    Default = 0,
    Unlocked = 1,
    Received = 2,
}

---遗迹城归属：我方/敌方/无主
SeasonDesertCity =
{
    Alliance = "1",--我方
    Other = "2", --敌方
    Block = "3",--无主
}
LuckyShopItemType = {
    LuckyShopItemType_Resource = 1,--资源
    LuckyShopItemType_Item = 2,--物品
}

SpeedUpType =
{
    Build = 1,
    Science = 2,
}

--性别
SexType =
{
    None = 0,--没选性别
    Man = 1, -- 男性
    Woman = 2, -- 女性
}

--收藏名字显示类型
BookMarkNameArrCountType =
{
    Default = 1,--传啥显示啥
    WithDialog = 2,--使用多语言
    WithLevelDialog = 3,--使用带等级的多语言
}

CampEffectType =
{
    None = 0,
    Fetter_3 = 1,
    Fetter_3_2 = 2,
    Fetter_4 = 3,
    Fetter_5 = 4,
}

CampEffectKey =
{
    Damage = 1,
}

HeroIntensifySlotType =
{
    Normal = 0,
    Random = 1,
}

HeroIntensifyCostType =
{
    Poster = 1, -- 海报
    Medal = 2, -- 勋章
    Open = 3, -- 解锁
}

HeroIntensifyTabState =
{
    Normal = 1,
    Hide = 2,
    NeedBuildingLevel = 3,
    NeedSeason = 4,
    NeedHeroMaxed = 5,
}

HeroIntensifyState =
{
    Normal = 1,
    Unlocked = 2,
    ToRandom = 3,
    NeedBuildingLevel = 4,
    NeedSeason = 5,
}

--分享战报战斗结果类型
ShareFightMailResultState =
{
    Fail = "0",--输了
    Win = "1",--赢了
    Draw = "2",--平局
}
DecorationActivityRewardState = {
    DecorationActivityRewardState_Normal = 0,--
    DecorationActivityRewardState_Can_Receive = 1,--可领取
    DecorationActivityRewardState_Received = 2,--已经领取
}

GloryPeriod =
{
    None = 0,
    Unopened = 1, -- 未开始
    Prepare = 2, -- 准备期
    Start = 3, -- 入侵期
    Settle = 4, -- 结算期
}

GloryDeclareType =
{
    Match = 1, -- 匹配
    List = 2, -- 列表
}

GloryBattleState =
{
    None = 0, -- 未宣战
    Before = 1, -- 未开始
    Ongoing = 2, -- 正在进行
    After = 3, -- 已结束
}

GloryBattleResult =
{
    None = 0,
    Win = 1,
    Lose = 2,
}

GloryBattleDetailType =
{
    Default = 0, -- 默认
    PlaceFlag = 1, -- 放置前线阵地
    FoldUpFlag = 2, -- 收起前线阵地
    Occupy = 3, -- 战力土地
    CrashBuilding = 4, -- 摧毁建筑
    CrashCenter = 5, -- 摧毁联盟中心
    Win = 6, -- 胜利
    MISSILE_ATTACK_MAIN = 7,--7 导弹炸大本
}

CommonDirection =
{
    LeftDown = 1,--左下
    RightDown = 2,--右下
    RightTop = 3,--右上
    LeftTop = 4,--左上
}
--1授权  2拒绝(未设置)   3永久拒绝
PermissionType =
{
    Accept = 1,
    Request = 2,
    Refuse = 3

}

GlorySeverType =
{
    Self = 1,--自己的服务器
    Opponent = 2,--宣战的服务器
    Other = 3,--其他服务器

}

GloryScoreRankType =
{
    Season = 0,--查看赛季贡献
    Week = 1,--查看周贡献
}

--个人贡献详情类型
GloryContributionType =
{
    OCCUPY_DESERT = 1,--占领地块积分
    SEASON_BUILDING = 2,--升级赛季建筑积分
    DONATE_ALLIANCE_STORE = 3,--捐献联盟石头
    DECLARE_SCORE = 4,--宣战积分
    OCCUPY_ENEMY_DESERT = 5,--占领敌人地块
}

--宣战记录类型
DeclareRecordType =
{
    Alliance = 1,--本盟宣战记录
    ServerZone = 2,--战区宣战记录
}

GloryDeclareRecordWinType =
{
    Win = 1,
    Lose = 0
}

GloryDeclareRecordKoType =
{
    No = 0,
    Ko = 1,
}

GloryDeclareRecordAtkType =
{
    Attack = 1,--进攻方
    Defence = 2,--防守方
}

GloryInfoTab =
{
    None = 0,
    Summary = 1, -- 数据统计
    SummaryHistory = 2, -- 历史数据统计
    Rank = 3, -- 玩家排名
    RankHistory = 4, -- 历史玩家排名
    History = 5, -- 战斗详情
}

MasteryCondType =
{
    And = 0,
    Or = 1,
}

MasteryCdType =
{
    Countdown = 1, -- 冷却时间（秒）
    Everyday = 2, -- 每天重置
}

MasteryCdShow =
{
    Sec = 1,
    Min = 2,
    Hour = 3,
}

MasteryHome =
{
    Gather = 101,
    Build = 102,
    Battle = 103,
}

MasteryHomeTitle =
{
    [MasteryHome.Gather] = 110716,
    [MasteryHome.Build] = 110717,
    [MasteryHome.Battle] = 110718,
}

MasteryTipState =
{
    None = 0,
    CanLearn = 1,
    Maxed = 2,
    NeedLv = 3,
    NeedPoint = 4,
    NeedPrior = 5,
    Closed = 6,
}

MasteryNodeState =
{
    Hide = "hide",
    Off = "off",
    On = "on",
}

MasterySkillState =
{
    None = 0,
    Normal = 1,
    Locked = 2,
    CD = 3,
    Closed = 4,
    NoUse = 5,
}

MasterySkill =
{
    Thrive = 1001, -- 兴盛
    MasteryReward = 1002, -- 专精奖励
    RapidMine = 1004, -- 急速开采
    IndustrialDevelop = 1005, -- 工业开发
    Demolition = 1007, -- 强拆
    BuildingShield = 1009, -- 坚盾
    BattleSupply = 1010, -- 站场补给
    --Landmine = 1011, -- 地雷
    RapidRepair = 1013, -- 快速维修
    Harvest = 1018, -- 丰收
    QuickCollect = 1019, -- 强征
    ProductGarrison = 1020, -- 屯田
    RandomAddAttack = 1016, -- 振奋
    RecoverMarch = 1017, -- 急救
    UpgradeDesert = 1023, -- 升级地块
    MadWarrior = 1024,--狂战士

}
--非技能类专精id
MasteryIdEnum = 
{
    Landmine = 2310101,--地雷
    LandmineBig = 2110101, -- 高爆地雷
}

MineIdEnum = 
{
    Landmine = 1000,--地雷
    LandmineBig = 1100, -- 高爆地雷
}
MasterySkillLocation =
{
    None = 0,
    ActiveSkill = 1, -- 在主动技能中显示
    WorldBuild = 2, -- 在建筑弹板显示
    WorldDesert = 3, -- 在地块弹板显示
    WorldFormation = 4,--在编队上显示
}

DesertOperateBtnState =
{
    None = 0,
    Green = 1,
    Yellow = 2,
    Gray = 3,
}

DesertAnnexItemType =
{
    None = 0,
    Mine = 1,
    BuildStatus = 2,
}

WeekDayName =
{
    [1] = "302789",
    [2] = "302790",
    [3] = "302791",
    [4] = "302792",
    [5] = "302793",
    [6] = "302794",
    [7] = "302795",
}

--黑骑士活动状态
BlackKnightState =
{
    END = 0,-- 整体活动结束或未开始
    READY = 1, --1 整体活动开始，未开启迎战
    OPEN = 2, --2 联盟开启迎战
    CLOSING = 3, --3 联盟出怪结束等待发积分目标奖励邮件和活动结束邮件
    REWARD = 4, --4 等待发奖
    CLOSED = 5, --5 联盟的活动结束邮件和积分目标奖励邮件已发完

    --客户端显示用
    NoAlliance = 100,--没有联盟
}

--黑骑士活动玩家状态
BlackKnightUserState =
{
    NORMAL = 0,-- 本期未参加过活动
    ACTIVITY_JOIN = 1, --1 本期在本盟已参加活动（不区分活动是否结束，只要参加了就是1）
    ORDER_ALLIANCE_ACTIVITY = 2, --2 本期在别的盟已经参加过活动了（不区分之前那个盟的活动是否结束，只要参加了就是2）
}

--黑骑士活动警告状态
BlackKnightWarningState =
{
    Open = 0,                 --开启预警
    Close = 1,                  --关闭预警
}

--任务表list类型
QuestListType =
{
    None = 0,
    List1 = 1,
    List2 = 2,
}

--可跨服的建筑
CrossBuildType =
{
    BuildingTypes.WORM_HOLE_CROSS,
}

-- 联盟捐兵黑骑士活动状态
AllianceDonateState =
{
    Waiting = 0, --客户端用
    Attaking = 1,
    End = 2,
    Victory = 3,
    Lose = 4,
}

-- 怪物表special含义
MonsterSpecialType =
{
    None = 0, --
    PuzzleBoss = 3,--拼图活动怪物
    ChallengeBoss = 4,--挑战活动怪物
    BlackKnight = 5,--黑骑士活动怪物
    ExpeditionaryDuel = 6,--远征活动怪物
}

-- 士兵死亡原因类型
ArmyDeadType =
{
    Hospital = 0, --医院爆仓死亡
    Fight = 1,--战斗死亡
}

MissileIDs = {
    ALLIANCE_FIGHT_SEND_MISSILE = "53307",
}

MigrateApplyType = 
{
    APPLY = 0, --申请
    AGREE = 1, --批准
    REFUSE = 2, --拒绝
    MIGRATE = 3, --成功移民
}

ApproveMigrateState = {
    AGREE = 1,
    REFUSE = 2,
}

MigrateShowItem = 
{
    ServerName = 1,
    ServerOpenTime = 2,
    ServerSeason =3,
    ServerState = 4,
    ServerPower = 5,
    ServerPresident = 6,
}

MigrateConditionSetting = 
{
    Season = 1,
    Power =2,
    BuildLevel = 3,
    Alliance = 4,
}

OfficerListConditionType = {
    Condition_Hero = 1,
    Condition_Server = 2,
}

UIGuideCloseType =
{
    Click = 1,--点击关闭界面引导下一步
    Time = 2,--等待时间到引导下一步（点击不生效）
}

ArmyTrainType = {
    ArmyTrainType_Normal = 0,--正常训练
    ArmyTrainType_Reserve = 1,--预备兵训练
}

Activity_ChampionBattle_Elite_Stage_State =
{
    WAIT_START_PHASE = 0,--开始默认等待状态 等待小组赛开始
    GROUP_QUARTER_PHASE = 1, --小组赛四分之一开打 周四0点变化
    GROUP_SEMI_PHASE = 2, --小组赛半决赛开打 小组赛四分之一结束后变化
    GROUP_FINAL_PHASE = 3,--小组赛决赛开打 小组赛半决赛结束后变化
    QUARTER_PHASE = 4,--四分之决赛 小组赛结束变化
    SEMI_PHASE = 5,--半决赛 四分之一决赛结束变化
    FINAL_PHASE = 6,--冠军赛 半决赛结束变化
}

APSDamageEffectType =  {

    DEFAULT = 0, -- 默认
    CRIT = 1, --1 暴击
    MISS = 2, --2 闪避
}

HeroSkillType = {
    --0 默认
    DEFAULT = 0,

    --1 全局生效技能
    GLOBAL_SKILL = 1,

    --2 编队中生效技能
    FORMATION_SKILL = 2,

    --3 机器人生效技能
    ROBOT_SKILL = 3,

    --10 普通攻击
    NORMAL_SKILL = 10,

    --11 怒气攻击(主动技能)
    RAGE_SKILL = 11,

    --12 进入战斗释放技能
    START_BATTLE_SKILL = 12,

    --13 特定英雄加成技能
    SPECIAL_HERO_ADD_SKILL = 13,

    --14 子技能
    SUB_SKILL = 14,
}

SaveHeroPluginType =
{
    Save = 1,--保留
    Reset = 2,--丢弃
}


HeroPluginQualityType =
{
    White = 1,--白色
    Green = 2,--绿色
    Blue = 3,--蓝色
    Purple = 4,--紫色
    Orange = 5,--橙色
    Gold = 6,--金色
}

HeroPluginTabType =
{
    Upgrade = 1,--升级
    Refine = 2,--随机
}

--英雄插件生效范围
HeroPluginActiveType =
{
    Army = 0,--编队生效
    Self = 1,--自身生效
}
    
TrainFreeType =
{
    Bauble = 1,--来自装饰建筑
}

--科技树显示条件
ScienceTabShowConditionType =
{
    AllianceBattle = 1,--联盟对决时生效
    Season = 2,--赛季生效
}

TradeLimitType =
{
    Buy = 0,
    Sell = 1,
}

UseResType =
{
    None = 0,
    Reward = 1,
    MasteryExp = 2,
}

RewardNumControlNumType =
{
    Item = 0,
    UseGoods = 2,
}

APSDamageEffectType =  {

    DEFAULT = 0, -- 默认
    CRIT = 1, --1 暴击
    MISS = 2, --2 闪避
}

HeroPluginShowDesType =
{
    Behind = 0,--将value和value_norandom中的值直接拼在文本后方
    Middle = 1,--将value和value_norandom中的值，依次传入文本的多个参数中
}

UIHeroMetalRedemptionTabType =
{
    HeroPage = 1,--英雄海报兑换
    Metal = 2,--勋章兑换
    Shop = 3,--商店购买
}

StoryLevelState =
{
    None = 0,
    Normal = 1,
    Finished = 2,
    Locked = 3,
    NeedMainLevel = 4,
    NeedChapter = 5,
    NeedQuest = 6,
}

StoryStageRewardState =
{
    Normal = 0,
    Received = 1,
}

--描点类型
PivotType = 
{
    LeftCenter = Vector2.New(0, 0.5),--左中描点
    Center = Vector2.New(0.5, 0.5),--中心描点
    RightCenter = Vector2.New(1, 0.5),--右中描点
}
WorldMarchEmotionTargetType =
{
    None = -1,
    March = 0,
    Building = 1,
}

WorldMarchEmotionCommandType =
{
    None = 0,
    ShowBtns = 1,
    HideBtns = 2,
    ShowEmo = 3,
    HideEmo = 4,
}

--点击任务奖励弹版类型
QuestShowRewardType =
{
    Fly = 0,--飞资源
    RewardUI = 1,--弹通用奖励板子
}

--英雄插件来源
HeroPluginOutType =
{
    Random = 0,--随机产生
    Const = 1,--固定条目
}
    
HeroPluginUpgradeAnimName =
{
    Idle = "hero_plugin_upgrade_idle",
    Show = "hero_plugin_upgrade_show",
    Hide = "hero_plugin_upgrade_hide",
}

CrossWonderActState =
{
    None = 0,
    Preview = 1,
    Play = 2,
    Settle = 3,
}

--引导赛季简介类型
SeasonIntroType =
{
    Pass = 1,--关隘
    Stronghold = 2,--据点
    Morality = 3,--士气值
    EdenSubway = 4,--伊甸园虫洞
}

--引导控制赛季简介UI类型
ControlSeasonIntroType = 
{
    ScrollToNext = 1,-- 滑动至下一个简介图片
    ShowCloseBtn = 2,--显示UI关闭按钮
}

--联盟日志类型
AllianceLogMemberType =
{
    NULL = 0,--模板
    UPDATE_RANK = 1,--成员阶级调整 (1, "390903", 4), // xxx将xxx的成员等级由n调整为了n
    GET_ALLIANCE_CITY = 2,--获得遗迹(2, "390904", 2), //我方获得了联盟遗迹xxx(x:0000;y:0000)
    GIVE_UP_ALLIANCE_CITY = 3,--放弃遗迹(3,"390905",3), //xxx放弃了联盟遗迹xxx(x:0000;y:0000)
    AUTO_JOIN_ALLIANCE = 4,--不需要批准加入联盟(4, "128132", 1), //xxx加入了联盟
    AUTO_QUIT_ALLIANCE = 5,--退出联盟(5, "390180", 1), //xxx退出了联盟
    AGREE_JOIN_ALLIANCE = 6,--需要批准加入了联盟(6, "390908", 3), //xxx同意了xxx的申请，xxx成功加入了联盟
    REFUSE_JOIN_ALLIANCE = 7,--拒绝了加入申请(7, "390909", 2), //xxx拒绝了xxx的申请
    KICK_MEMBER = 8,--踢人(8,"390910",2),        //xxx将xxx移出了联盟
    TRANSFER_LEADER = 9,--转移盟主(9, "390911", 2),  // xxx将盟主职位转交给了xxx
    LOST_ALLIANCE_CITY_BY_BE_ATTACK = 10,--受到攻击导致失去联联盟遗迹(10,"390912", 2), //失去了联盟遗迹xxx(x:0000;y:0000)
    ALLIANCE_CITY_BE_ATTACK = 11,--联盟遗迹受到攻击(11, "390913", 3), // 联盟遗迹xxx受到xxx的攻击(x:0000;y:0000)
    ALLIANCE_CITY_BE_RALLY_ATTACK = 12,--联盟遗迹受到集结攻击(12, "390914", 3), //联盟遗迹xxx受到xxx发起的组队进攻(x:0000;y:0000)
    ALLIANCE_MEMBER_BE_ATTACK = 13,--联盟成员受到攻击(只记录建筑)(13, "390915", 3), //xxx受到xxx的攻击(x:0000;y:0000)
    ALLIANCE_MEMBER_BE_RALLY_ATTACK = 14,--联盟成员收到组队攻击(受到攻击时记录，只记录建筑)(14, "390916", 3), //xxx受到xxx发起的组队进攻(x:0000;y:0000)
    ALLIANCE_SET_OFFICAL = 15,--任命官职(15, "391061", 3),  //{玩家名称}被{玩家名称}任命为{职位名称}
    ALLIANCE_RM_OFFICAL = 16,--解除官职(16, "391062", 1),  //{玩家名称}已被解除联盟官职
    CANCEL_GIVE_UP_ALLIANCE_CITY = 17,--取消放弃联盟城(17,"390905",3);  ////xxx放弃了联盟遗迹xxx(x:0000;y:0000)
    
}

NpcMoveType =
{
    Normal = 1,--正常平面移动
    EnterBridge = 2,--上桥
    ExitBridge = 3,--下桥
    CrossBridge = 4,--上桥下桥
}

--引导开始显示CG类型
ShowCGType =
{
    Show = 1,--展示CG
    No = 2,--不展示CG
}

--引导开始跳过序章类型
JumpPrologueType =
{
    NoJump = 1,--不跳过
    Jump = 2,--跳过
}

--队列来源
QueueAddSourceType =
{
    Land = "land",--地块赠送
}

--行军预制体类型
MarchPrefabType =
{
    Self = 1,--自己（绿色）
    Alliance = 2,--盟友（蓝色）
    Camp = 3,--同阵营（黄色）
    Other = 4,--敌人（红色）
}

--召唤海盗船怪物类型
PuzzleMonsterType =
{
    Activity = 1,--拼图怪
    Radar = 2,--雷达怪
}

--雷达界面事件类型
DetectEventFromType = {
    Detect = 1, --雷达事件
    RadarBoss = 3, --雷达boss
}
EveryDayPriority =
{
    None = 0,
    Yellow = 1,
    Purple = 2,
    Blue = 3,
}

--引导等待资源加载结果类型
GuideWaitLoadCompleteResult =
{
    NoNeedTimeWait = 1,--没加载完（不需要计时器，死等，针对差手机，加载就是慢）
    Wait = 2,--没加载完（需要计时器放卡死）（绝大多数用这个）
    Finish = 3,--加载完毕
}

--改名活动通用类型
ChangeNameAndPicType =
{
    No = 0,
    Yes = 1,
}

--玩家信息页面箭头类型
PLayerInfoArrowType =
{
    ChangeName = 1,--改名
    BandAccount = 2,--绑定账号
    ChangePic = 3,--换头像
}

--引导等待资源加载结果类型
HideCountryFlag =
{
    "TW", "HK", "MO", "CN"
}

WatchAdType =
{
    Reward = 0,
}

WatchAdLocation =
{
    GiftPackage = 0,
}

--家具属性多语言类型
FurnitureAttrDialogType =
{
    Time = 100018,--时间
    Attr = 130063,--属性
    Product = 100214,--生产
}

FurniturePara4Type =
{
    Resource = 1,--资源
    FurniturePara1 = 2,--建筑特殊显示
}


--家具属性多语言类型
FurniturePara1Type =
{
    -- 前端自用
    Hunger = -1,--饥饿值
    ---------------------------
    Health = 1,--健康值
    Stamina = 2,--体力值
    Mood = 3,--心情值
    Comfort = 4,--舒适值
    Doctor = 5,--医院
}

--家具属性特殊功能
FurnitureSpecialType =
{
    Dining = 1,--餐厅
    Health = 2,--治疗
}

StormType =
{
    Normal = 0, -- 正常
    Guide1 = 1, -- 新手第一次
    Guide2 = 2, -- 新手第二次
}

--暴风雪阶段
StormState =
{
    No = 0,--没有暴风雪
    Alert = 1, -- 预告阶段
    Start = 2, -- 开始阶段
}

--火箭炸弹是否已领奖
StormRewardState =
{
    No = 1,-- 不能领取
    CanGet = 2,--可以获得
    Got = 3,--已经领取
}

CityHudType =
{
    ResidentSlider = "ResidentSlider",
    ResidentDanger = "ResidentDanger",
    ResidentStamina = "ResidentStamina",
    ResidentWant = "ResidentWant",
    ProductSlider = "ProductSlider",
    PopText = "PopText",
    IconAndText = "IconAndText",
    BuildLevel = "BuildLevel",
    BuildTime = "BuildTime",
    BuildStamina = "BuildStamina",
    RepairTime = "RepairTime",
    IconAndSlider = "IconAndSlider",
    FurnitureNeedWorker = "FurnitureNeedWorker",
    LandZoneBubble = "LandZoneBubble",
    Speak = "Speak",
    ReadyQueue = "ReadyQueue",
    Emoji = "Emoji",
    AnimEmoji = "AnimEmoji",--支持动画的emoji
    ResidentLevelUp = "ResidentLevelUp",
    ResidentGive = "ResidentGive",
    ResidentFireBody = "ResidentFireBody",
    ResidentBetray = "ResidentBetray",
    Repair = "Repair",
    RepairWall = "RepairWall",
    SiegeBoss = "SiegeBoss",
    SiegeBossTime = "SiegeBossTime",
    FireUnlock = "FireUnlock",
    FireLock = "FireLock",
    BuildCreate = "BuildCreate",
    WallHp = "WallHp",
}

CityHudLayer =
{
    Root = "Root",
    LevelUp = "LevelUp",
    Speak = "Speak",
}

CityHudLocation =
{
    World = "World",
    UI = "UI",
}

BuildLevelIcon =
{
    [BuildingTypes.FUN_BUILD_MAIN] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_furnace",
    [BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION] = "Assets/Main/Sprites/UI/Common/UIRes_icon_steal",
    [BuildingTypes.FUN_BUILD_WATER_STORAGE] = "Assets/Main/Sprites/UI/UIMain/icon_item_SmallIronFurnace",
    [BuildingTypes.DS_RESTAURANT] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_kitchen",
    [BuildingTypes.DS_COAL_YARD] = "Assets/Main/Sprites/UI/Common/Common_icon_electricity",
    [BuildingTypes.DS_FACTORY] = "Assets/Main/Sprites/UI/Common/UIRes_icon_wood",
    [BuildingTypes.DS_FARM] = "Assets/Main/Sprites/UI/Common/UIRes_icon_meat",
    [BuildingTypes.DS_BAR] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_hospital",
    [BuildingTypes.DS_HOSPITAL_1] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_hospital",
    [BuildingTypes.DS_HOSPITAL_3] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_hospital",
    [BuildingTypes.DS_HOUSE_1] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_2] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_3] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_4] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_5] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_6] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_7] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
    [BuildingTypes.DS_HOUSE_8] = "Assets/Main/Sprites/UI/UIMain/icon_sceneView_dorm",
}

--家具界面页签类型
UIFurnitureUpgradeTabType =
{
    Furniture = 1,--家具
    Work = 2,--工人
}

--家具界面箭头类型
UIFurnitureUpgradeArrowType =
{
    AddWork = 1,--工人界面可加号按钮
    UpgradeFurniture = 2,--家具升级按钮
    UpgradeBuild = 3,--建筑升级按钮
}

--主城建筑状态
BuildCityBuildState =
{
    None = 0,--未初始化
    Pre = 1,--前置不满足，不显示
    Fake = 2,--前置满足，显示假模型
    Own = 3,--有真实建筑
}

--主城建筑状态
BuildCityBuildPreState =
{
    Pve = 1,--地块
    Build = 2,--建筑
    Science = 3,--科技
    Vip = 4,--vip
    LandReward = 5,--领取地块奖励
    Land = 6,--地块解锁
}

--主城建筑状态
GuideMoveCameraNextType =
{
    Wait = 0,--等待镜头移动完毕在做下一步引导
    Next = 1,--立刻做下一步引导
}

--主城建筑状态
UIMainBtnType =
{
    StaticBtn = 1,--统计按钮
}

--主城建筑状态
ChangeDayTimeStopType =
{
    Stop = 1,--时间停止走动
    Resume = 2,--时间恢复走动
}

-- 英雄翻卡方式 状态
HeroRecruitState =
{
    PlayOpenAni = 1, -- 正在播放开始动画
    Manual = 2, -- 手动翻卡
    Auto = 3, -- 自动
    All = 4, -- 全翻
    Fin = 5, -- 翻卡结束

    -- 该界面第二次翻卡状态
    OpenWithoutAni = 6, -- 没有发牌动画的开始状态
    QuicklyAuto = 7, -- 快速自动翻卡，只播放新卡展示动画
}

eMailDetailActionType = {
    DEFAULT = 0,  --默认
    ATTACK = 1,     -- 普通攻击
    COUNTER_ATTACK = 2,  -- 反击
    SHIELD_ATTACK = 3,  -- 护盾攻击
    SHIELD = 4,   -- 护盾
    RECOVER_DAMAGE = 5,  -- 恢复伤兵
    ADD_EFFECT = 6,  -- 添加BUFF
    USE_SKILL = 7,  -- 使用技能
    ADD_ANGER = 8,  -- 怒气
    ADD_ANGER_BY_TARGET_NUM= 9,--根据攻击目标个数增加怒气
    SHIELD_COUNTER_ATTACK = 10, --反击到护盾攻击
}

ScienceLineState =
{
    No = 1,--没有
    Dark = 2,--暗
    Light = 3,--亮
}

ScienceLineDirectionState =
{
    Top = 1,--向上
    Down = 2,--向下
}

UIStormPanelType =
{
    Short = 1,--短的
    Long = 2,--长的
}

HeroInfoViewType =
{
    HeroList = 1,
    HeroPreview = 2,
}

--引导设置主UI动画
GuideSetUIMainAnim =
{
    Show = 1,--全部显示
    Hide = 2,--全部消失
    StayTop = 3,--主UI保留顶部，剩下隐藏
    StayTopLeft = 4,--主UI保留顶部，左部剩下隐藏
}

UIBuildAnimName =
{
    Hide = "hide",--隐藏
    Enter = "enter",--进入
    Show = "show",--显示
}

LandObjectType =
{
    Zone = "Zone",
    Block = "Block",
    Reward = "Reward",
}

LandObjectPrefab =
{
    [LandObjectType.Zone] = "Assets/Main/Prefab_Dir/Land/LandZone.prefab",
    [LandObjectType.Block] = "Assets/Main/Prefab_Dir/Land/LandBlock.prefab",
    [LandObjectType.Reward] = "Assets/Main/Prefab_Dir/Land/LandReward.prefab",
}

LandState =
{
    Hide = "Hide", -- 隐藏 (目前没用上)
    Unexplored = "Unexplored", -- 未探索
    Unaccessible = "Unaccessible", -- 条件未满足
    Accessible = "Accessible", -- 可进入
    Cleared = "Cleared", -- 已通过
    Unlocked = "Unlocked", -- 已解锁
    Finished = "Finished", -- 已完成，不再创建
}

LandBlockType =
{
    Empty = 0,
    Start = 1,
    Pve = 2,
    Perform = 3,
    Pickup = 4,
    Resident = 5,
    Fire = 6,
    Jump = 7,
}

LandFogType =
{
    Fog = 0,
    Half = 135,
    Clear = 255,
}

LandUniversalState =
{
    Uncreated = "Uncreated",
    Creating = "Creating",
    Created = "Created",
}

CityHubAnimName =
{
    DefaultShow = "DefaultShow",
    DefaultHide = "DefaultHide",
    ShowToHide = "ShowToHide",
    HideToShow = "HideToShow",
}

CallBossUseType =
{
    CallBoss = 0,--召唤Boss
    GetReward = 1,--获得奖励
}

--建筑特效类型
BuildEffectType =
{
    TrainZzz = 1,--训练空闲zzz特效
    Upgrading = 2,--升级中特效
    RuinFire = 3,--冒火
    SafeArea = 4,--安全区
}

--连续手指的类型
ArrowSecondType =
{
    AllianceScience = 1,--联盟科技（先指向主界面联盟按钮，点击后再指向页面中联盟科技）
    HeroList = 2,--英雄列表界面
    HeroInfo = 3,--英雄信息
    HeroStar = 4,--英雄升阶按钮
}

--英雄列表界面手指类型
HeroListArrowTypeHero = 
{ 
    HeroUid = 1,
    LvUpHero = 2,
    RankUp = 3,
    Star = 4,
}

CommonBtnName =
{
    BlueSmall = "Common_btn_blue_samll",
    YellowSmall = "common_btn_yellow71",
}

--联盟科技推荐
AllianceScienceRecommendState =
{
    No = 0,--不推荐
    Yes = 1,--推荐
}

--战令标题颜色设置
BattlePassTitleConfig = 
{
    ["PassBlackWoman"] =
    {
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 0.8392157, 0.3529412),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        OutlineNum = 1
    },
    ["PassDetective"] =
    {
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(205/255, 227/255, 223/255),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        OutlineNum = 0
    },
    ["PassSheriff"] =
    {
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 0.8392157, 0.3529412),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        OutlineNum = 1
    },
    ["PassSister"] =
    {
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 0.8392157, 0.3529412),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        OutlineNum = 1
    },
}

-- 弹出礼包显示配置
PopupPackageConfig =
{
    ["Default"] =
    {
        MainIcon = "UIMain_icon_xianshi",
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 1, 1),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        DescImage = "yellow",
        FrontBg = "Common_bg_empty_di",
        OutlineNum = 0
    },
    ["Onestepahead"] =
    {
        MainIcon = "UIMain_icon_dengta",
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 0.8392157, 0.3529412),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        DescImage = "yellow",
        FrontBg = "Common_bg_empty_di",
        OutlineNum = 1
    },
    ["HeroCome"] =
    {
        MainIcon = "UIMain_icon_xianshi",
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(0.9647059, 0.9058824, 1),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        DescImage = "yellow",
        FrontBg = "Common_bg_empty_di",
        OutlineNum = 1
    },
    ["KillerManGift"] =
    {
        MainIcon = "UIMain_icon_KillerManGift",
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(0.8156863, 0.9647059, 0.9843138),
        DescTextColor = Color.New(117/255, 42/255, 0/255, 1),
        DescImage = "yellow",
        FrontBg = "UIPopupPackage_di_SisterandKillerMan",
        OutlineNum = 2
    },
    ["OfficerWomanGift"] =
    {
        MainIcon = "UIMain_icon_OfficerWomanGift",
        TitleTopColor = Color.New(1, 1, 1),
        TitleBottomColor = Color.New(1, 0.9490197, 0.6196079),
        DescTextColor = Color.New(170/255, 85/255, 36/255, 1),
        DescImage = "yellow",
        FrontBg = "Common_bg_empty_di",
        OutlineNum = 1
    },
    ["SheriffGift"] =
    {
        MainIcon = "UIMain_icon_SheriffGift",
        TitleTopColor = Color.New(255/255, 242/255, 130/255),
        TitleBottomColor = Color.New(255/255, 160/255, 36/255),
        DescTextColor = Color.New(117/255, 42/255, 0/255, 1),
        DescImage = "yellow",
        FrontBg = "UIPopupPackage_di_SheriffGift",
        OutlineNum = 1
    },
    ["SisterGift"] =
    {
        MainIcon = "UIMain_icon_SisterGift",
        TitleTopColor = Color.New(255/255, 249/255, 219/255),
        TitleBottomColor = Color.New(255/255, 233/255, 128/255),
        DescTextColor = Color.New(43/255, 13/255, 84/255, 1),
        DescImage = "purple",
        FrontBg = "UIPopupPackage_di_SisterandKillerMan",
        OutlineNum = 1
    },
    ["BlackWomanGift"] =
    {
        MainIcon = "UIMain_icon_BlackWomanGift",
        TitleTopColor = Color.New(255/255, 249/255, 219/255),
        TitleBottomColor = Color.New(255/255, 233/255, 128/255),
        DescTextColor = Color.New(152/255, 35/255, 87/255, 1),
        DescImage = "pink",
        FrontBg = "UIPopupPackage_di_BlackWomanGift",
        OutlineNum = 1
    },
    ["MafiaGodfatherGift"] =
    {
        MainIcon = "UIMain_icon_MafiaGodfatherGift",
        TitleTopColor = Color.New(255/255, 249/255, 219/255),
        TitleBottomColor = Color.New(255/255, 233/255, 128/255),
        DescTextColor = Color.New(126/255, 68/255, 0/255, 1),
        DescImage = "yellow",
        FrontBg = "UIPopupPackage_di_SisterandKillerMan",
        OutlineNum = 1
    },
}

PirateDetailType =
{
    Reward = 1,
    Archive = 2,
}

UIBlackKnightRankType =
{
    PersonalRank = 1,--个人排行
    AllianceRank = 2,--联盟排行
}

GuideTriggerSaveType =
{
    InCity = "1",--回到主城，并没有UI打开
    InWorld = "2",--来到世界
    UI = "3",--打开某个UI的时候，prefab名字
}

--引导特殊Emoji类型
GuideResidentEmojiType =
{
    Img = 1,--单独一个img
    BgImg = 2,--带背景的img
    Anim = 3,--带动画的预制体（需要加载）
}

--引导小人物体类型
GuideResidentObjType =
{
    Resident = 1,--城内小人
    Timeline = 2,--Timeline中的小人
    Hero = 3,--英雄
}

--引导控制大本灯光亮度
GuideControlLightType =
{
    Change = 1,--改变亮度（白天晚上切换自动恢复默认值）
    Reset = 2,--恢复亮度
    ChangeCur = 3,--改变范围（不恢复，断线重登后才恢复）
    ResetCur = 4,--恢复范围
}

--引导特殊Emoji类型
GuideTempFlagType =
{
    VitaDead = 1,--UI小人死亡动画
    ChapterBg = 2,--章节图
    ClickPay = 3,--点击支付按钮
    NoShowFireLight = 4,--不显示火焰
    ChapterPlayFlip = 5,--章节任务播放撕页动画
    ChangeSafeArea = 6,--改变安全区域
}

--引导小人到来气泡判断类型
ResidentComeJumpType =
{
    Bubble = 1,--小人气泡是否出现
    People = 2,--小人是否出现
}

BuildingDestroyType =
{
    None = 0,
    Mild = 1,
    Moderate = 2,
    Severe = 3,
    Ruin = 4,
}

CityResidentZoom =
{
    Resident = 14,
    SiegeBoss = 36,
}

-- 前端状态
CitySiegeAttackState =
{
    None = 0, -- 未开启
    Pending = 1, -- 排队中
    PreTask = 2, -- 已激活，前置任务未完成
    Ready = 3, -- 前置任务完成，丧尸围城未开启
    Playing = 4, -- 丧尸围城开启
    Victory = 5, -- 已击杀所有BOSS
    Expired = 6, -- 超时
    Finish = 7, -- 结束
}

-- 后端状态
CitySiegeServerState =
{
    Pending = 0, -- 等待激活
    Active = 1, -- 激活
    ZombieActive = 2, -- 丧尸激活
    Pass = 3, -- 通关
    Expire = 4, -- 过期
    Finish = 5, -- 领奖，结束
}

CitySiegeType =
{
    None = 0,
    Normal = 1, -- 普通进攻
    Big = 2, -- 大举进攻
}

CityWallAnim =
{
    Create = "create",
    Idle = "idle",
    Fall = "fall",
    Fall2 = "fall2",
    Fallen = "fallen",
    Fallen2 = "fallen2",
    Up = "up",
    Up2 = "up2",
}

--章节任务播放翻页字段类型
ChapterFlipType =
{
    No = 0,--不播放翻页动画
    Pre = 1,--播放翻页动画
}

--对应C# TextAlignmentOptions
TextAlignmentType =
{
    TopLeft = 257, -- 上左
    Top = 258, -- 上中
    TopRight = 260, -- 上右
    Left = 513, -- 中左
    Center = 514, -- 中中
    Right = 516, -- 中右
    BottomLeft = 1025, -- 下左
    Bottom = 1026, -- 下中
    BottomRight = 1028, -- 下右
}

return ConstClass("EnumType", EnumType)