using System.Collections.Generic;
using UnityEngine;

public static class GameDefines
{
    public static readonly Vector2 ScreenScaler = new Vector2(1920,1080);
    public const string NoChannelParam = "FB_BTN_youjian";
    public const string UndisposedMail = "no_mail_channel";
    public const string GreenBlockFree = "Assets/Main/Sprites/Scene/road/green_block_free";
    public const string RedBlockFree = "Assets/Main/Sprites/Scene/road/red_block_free";
    public const string GreenFreeMoveKuang = "free_move_kuang_green";
    public const string RedFreeMoveKuang = "free_move_kuang_red";
    public const string DefaultDialog = "Assets/Main/Localization/English/Dictionaries/Dialog.txt";

    public const int EQUIP_SOLTCOUNT = 6;
    public const int AreaXSize = 8;
    public const int AreaYSize = 8;
    public const int TileXInArea = 8;
    public const int TileYInArea = 8;
    public const int MaxShowBuildBlockRange = 20;

    //一下都是以主城为中心的偏移
    public static Vector2Int GuideBoardPos = new Vector2Int(-1, 2);
    //结束

    public static Vector3 WorldCityNameBGScale = new Vector3(0.8f, 0.6f, 1f);
    public static int SkyBoxPosZ = 51;
    public static int SkyBoxPosZFreeGrass = SkyBoxPosZ + 14;
    public const int ITEM_TYPE_SPD = 2;                 // 加速道具类型

    public const string MAIN_CITY_ID = "10000";
    public const string MONTH_CARD_ID = "9007";         // 月卡ID
    public const string SUB_MONTH_CARD_ID = "9012";     //订阅ID
    public const int MONTH_CARD_REWARD_COUNT = 10;      //月卡奖品个数

    public const string KINGDOM_KING_ID = "216000";             //国王
    public const string GREAT_KINGDOM_KING_ID = "222000";       //大王座 大帝ID
    public const string INTRODE_KING_ID = "216017";             //入侵者

    public const string FIRST_GIVE_HERO_ID = "10009";//第一个赠送的英雄的ID
    public const string SECOND_GIVE_HERO_ID = "10010";//第二个赠送的英雄的ID

    public const int ITEM_GENE = 212005; //基因片段
    public const int ITEM_RENAME = 200021; //改名


    public const float FLT_EPSILON = 1.192092896e-07F;//public string FLT_EPSILON     1.192092896e-07F

    public const string WB_SEASON_ACTIVITY = "57062";         //末日争霸
    public const string WB_DECLARE_ACTIVITY = "57088";         //宣战
    public const string ALLIANCE_NOTICE_KEY = "notice_0123456789";

    public const int MIN_NAME_CHAR = 3;     //名字最小3个字符
    public const int MAX_NAME_CHAR = 16;    //名字最多16字符
    public const int MAX_MOOD_CHAR = 50;    //心情最多50字符

    public const string FBLuckyDrawKey = "fbluckydrawkey";
    public const string DefaultMissile = "53301";
    public static Vector3 BlockPos = new Vector3(0,0.25f,0);

    // 随机城内运输车参数
    public const int RandomTruckTargetMin = 3;
    public const float RandomTruckInterval = 3f;
    public const int RandomPeopleTargetMin = 2;
    public const float RandomPeopleInterval = 5f;

    public const int QualityLevel_Off = 0;
    public const int QualityLevel_Low = 1;
    public const int QualityLevel_Middle = 2;
    public const int QualityLevel_High = 3;

    public const float RenderScaleLow = 0.8f;


    public const string GrayMaterialName = "SpriteGray";
    public const float LookAtFocusTime =  0.4f;
    public const int FindCanBuildPointRange = 7;
    public const string SaveGuideDoneValue = "1";

    public static Vector3[] BuildTileCenterDelta =
        {new Vector3(0, 0, 0), new Vector3(-1f, 0, -1f), new Vector3(-2, 0, -2)};
    public static List<DirectionType> ConnectDirList = new List<DirectionType>()
    {
        DirectionType.Down,
        DirectionType.Left,
        DirectionType.Right,
        DirectionType.Top,
    };
    public const int Int32Bit = 32;
    public const int ByteSize = 8;


    public static Dictionary<Vector2Int, Direction> OffsetToDirectionMap = new Dictionary<Vector2Int, Direction>()
    {
        {new Vector2Int(1,0), Direction.SE},
        {new Vector2Int(2,0), Direction.SE},
        {new Vector2Int(-1,0), Direction.NW},
        {new Vector2Int(-2,0), Direction.NW},
        {new Vector2Int(0,1), Direction.SW},
        {new Vector2Int(0,2), Direction.SW},
        {new Vector2Int(0,-1), Direction.NE},
        {new Vector2Int(0,-2), Direction.NE},
        {new Vector2Int(1, 1), Direction.S},
        {new Vector2Int(2, 1), Direction.S},
        {new Vector2Int(1, 2), Direction.S},
        {new Vector2Int(2, 2), Direction.S},
        {new Vector2Int(-1, -1), Direction.N},
        {new Vector2Int(-2, -1), Direction.N},
        {new Vector2Int(-1, -2), Direction.N},
        {new Vector2Int(-2, -2), Direction.N},
        {new Vector2Int(1, -1), Direction.E},
        {new Vector2Int(2, -1), Direction.E},
        {new Vector2Int(1, -2), Direction.E},
        {new Vector2Int(2, -2), Direction.E},
        {new Vector2Int(-1, 1), Direction.W},
        {new Vector2Int(-2, 1), Direction.W},
        {new Vector2Int(-1, 2), Direction.W},
        {new Vector2Int(-2, 2), Direction.W},
    };

    public const string Player_CareerID = "222000";
    
    public class EntityAssets
    {
        public const string Building = "Assets/Main/Prefabs/Building/{0}.prefab";
        public const string AllianceBuilding = "Assets/Main/Prefabs/AllianceBuilding/{0}.prefab";
        public const string TouchTerrainEffect = "Assets/Main/Prefabs/World/TouchTerrainEffect.prefab";
        public const string WorldCityGrass = "Assets/Main/Prefabs/World/WorldCityGrass.prefab";
        public const string BatteryAttackRange = "Assets/_Art/Effect/prefab/scene/Build/V_paota_fanwei.prefab"; //炮台攻击范围特效
        public const string QuanEffectRange = "Assets/Main/Prefabs/BuildEffect/V_zdbx_quan.prefab"; //炮台攻击范围特效

        //世界
        public const string World = "Assets/Main/Prefabs/World/Scene_World.prefab";
        public const string City = "Assets/Main/Prefabs/World/Scene_City.prefab";
        public const string Wasteland_City = "Assets/Main/Prefabs/World/Scene_City2.prefab";
        public const string Wasteland_City_Dig = "Assets/Main/Prefabs/World/Scene_City_Dig.prefab";
        public const string WorldSceneDesc = "Assets/Main/Scenes/WorldSceneDesc.bytes";
        public const string WorldEdenSceneDesc = "Assets/Main/Scenes/WorldEdenSceneDesc.bytes";
        public const string WorldSceneAllianceCityDesc = "Assets/Main/Scenes/WorldSceneAllianceCityDesc.bytes";
        public const string WorldMapZone = "Assets/Main/Scenes/Zone/zone.bytes";
        public const string WorldEdenMapZone = "Assets/Main/Scenes/EdenZone/zone.bytes";
        public const string WorldEdenMapArea = "Assets/Main/Scenes/EdenZone/area.bytes";
        public const string Terrain_World0_Low = "Assets/Main/Prefabs/World/Terrain_0.prefab";
        public const string Terrain_World0_High = "Assets/Main/Prefabs/World/Terrain_0_High.prefab";
        public const string TerrainSetting_Low = "Assets/Main/Prefabs/World/TerrainSetting_Low.asset";
        public const string TerrainSetting_High = "Assets/Main/Prefabs/World/TerrainSetting_High.asset";
        public const string Terrain_Eden_World_Low = "Assets/Main/Prefabs/World/Terrain_Eden.prefab";
        public const string Terrain_Eden_World_High = "Assets/Main/Prefabs/World/Terrain_Eden_High.prefab";
        public const string EdenTerrainSetting_Low = "Assets/Main/Prefabs/World/EdenTerrainSetting_Low.asset";
        public const string EdenTerrainSetting_High = "Assets/Main/Prefabs/World/EdenTerrainSetting_High.asset";
        public const string Terrain_City_Low = "Assets/Main/Prefabs/World/Terrain_City.prefab";
        public const string Terrain_City_High = "Assets/Main/Prefabs/World/Terrain_City_High.prefab";
        public const string TerrainSetting_City_Low = "Assets/Main/Prefabs/World/TerrainSetting_City_Low.asset";
        public const string TerrainSetting_City_High = "Assets/Main/Prefabs/World/TerrainSetting_City_High.asset";
        public const string TroopLine = "Assets/Main/Prefabs/March/TroopLine.prefab";
        public const string TroopDestinationSignal = "Assets/Main/Prefabs/March/TroopDestinationSignal.prefab";
        public const string TroopLineDrag = "Assets/Main/Prefabs/March/TroopLineDrag.prefab";
        public const string WorldTroop = "Assets/Main/Prefabs/March/WorldTroop.prefab";
        public const string WorldTroopSample = "Assets/Main/Prefabs/March/WorldTroopSample.prefab";
        public const string MonsterActBoss = "Assets/Main/Prefabs/Monsters/MonsterActBoss.prefab";
        public const string WorldTroopAlliance = "Assets/Main/Prefabs/March/WorldTroopAlliance.prefab";
        public const string WorldTroopOther = "Assets/Main/Prefabs/March/WorldTroopOther.prefab";
        public const string WorldTroopYellow = "Assets/Main/Prefabs/March/WorldTroopYellow.prefab";
        public const string WorldVirtualTroop = "Assets/Main/Prefabs/March/WorldVirtualTroop.prefab";
        public const string ScoutTroop = "Assets/Main/Prefabs/March/WorldTroopScout.prefab";
        public const string ResTransTroop = "Assets/Main/Prefabs/March/WorldTroop.prefab";
        public const string GolloesExploreTroop = "Assets/Main/Prefabs/March/GolloesExploreTroop.prefab";
        public const string GolloesTradeTroop = "Assets/Main/Prefabs/March/GolloesTradeTroop.prefab";
        public const string WorldRallyTroop = "Assets/Main/Prefabs/March/WorldTroop.prefab";
        public const string FieldMonster = "Assets/Main/Prefabs/Monsters/FieldMonster.prefab";
        public const string FieldBoss = "Assets/Main/Prefabs/Monsters/FieldBoss.prefab";
        public const string ConstructMaterial = "Assets/Main/Material/building_construct.mat";
        public const string TileUnlocked = "Assets/Main/Prefabs/World/TileUnlocked.prefab";
        public const string TileLocked = "Assets/Main/Prefabs/World/TileLocked.prefab";
        public const string BuildGrid = "Assets/Main/Prefabs/Building/BuildGrid{0}.prefab";
        public const string MonsterPath = "Assets/Main/Prefabs/Monsters/{0}.prefab";
        public const string BuildBlock = "Assets/Main/Prefabs/Building/BuildBlock.prefab";
        public const string WorldTroopSoldier = "Assets/Main/Prefabs/March/WorldTroopSoldier.prefab";
        public const string WorldTroopTank = "Assets/Main/Prefabs/March/WorldTroopTank.prefab";
        public const string WorldTroopPlane = "Assets/Main/Prefabs/March/WorldTroopPlane.prefab";
        public const string WorldTroopJunkman = "Assets/Main/Prefabs/March/WorldTroopJunkman.prefab";
        public const string BuildMetalFew = "Assets/Main/Prefabs/Building/BuildMetalFew.prefab";
        public const string BuildMetalMiddle = "Assets/Main/Prefabs/Building/BuildMetalMiddle.prefab";
        public const string BuildMetalMax = "Assets/Main/Prefabs/Building/BuildMetalMax.prefab";
        public const string BuildWoodFew = "Assets/Main/Prefabs/Building/BuildWoodFew.prefab";
        public const string BuildWoodMiddle = "Assets/Main/Prefabs/Building/BuildWoodMiddle.prefab";
        public const string BuildWoodMax = "Assets/Main/Prefabs/Building/BuildWoodMax.prefab";
        public const string DetectEventUI = "Assets/Main/Prefabs/March/WorldDetectInfo.prefab";
        public const string CollectGarbageUI = "Assets/Main/Prefabs/March/CollectGarbageUI.prefab";
        public const string CityWorkMan = "Assets/Main/Prefabs/CityScene/CityWorkMan.prefab";
        public const string FogPath = "Assets/Main/Prefabs/FogOfWar/{0}.prefab";
        public const string CityCameraSand = "Assets/Main/Prefabs/CityScene/CityCameraSand.prefab";
        public const string WorldCityTreeHigh = "Assets/Main/Prefabs/World/WorldCityTreeHigh{0}.prefab";
        public const string WorldCityTree = "Assets/Main/Prefabs/World/WorldCityTree{0}.prefab";
        public const string FocusCurve = "Assets/Main/Prefabs/CityScene/FocusCurve{0}.prefab";
        public const string GarbageStone = "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_rock_1.prefab";
        public const string GarbageCrystal= "Assets/_Art/Models/Soldier/ShiHuangXiaoRen/prefab/A_soldie_shxr_tuohuang_crystal_1.prefab";
        public const string CollectBuildModelSelf = "Assets/Main/Prefabs/Building/building_collect.prefab";
        public const string CollectBuildModelAlliance = "Assets/Main/Prefabs/Building/building_collect_alliance.prefab";
        public const string CollectBuildModelEnemy = "Assets/Main/Prefabs/Building/building_collect_enemy.prefab";
        public const string AllianceBossModel = "Assets/Main/Prefabs/Monsters/AllianceBoss.prefab";
        
    }

    public class UIAssets
    {
        public const string UILoading = "Assets/Main/Loading/UILoading.prefab";
        public const string ProfileGraphy = "Assets/Main/Prefab_Dir/Debug/Graphy.prefab";
        public const string GFXConsole = "Assets/Main/Prefab_Dir/Debug/GFXConsole.prefab";
        // 城市小车
        public const string UIPartsMaterialInfo = "Assets/Main/Prefabs/UI/Parts/UIPartsMaterialInfo.prefab";
        public const string UITokenShop = "Assets/Main/Prefabs/UI/Shop/UITimeLimitShop.prefab";
        public const string UIMultipleShop = "Assets/Main/Prefabs/UI/MilitaryInformation/UIMultipleShop.prefab";
        
        public const string SceneRocketFireEffect = "Assets/Main/Prefabs/RocketEffect/SceneRocketFireEffect.prefab";
        public const string SceneRocketSmokeEffect = "Assets/Main/Prefabs/RocketEffect/SceneRocketSmokeEffect.prefab";

    }

    public class SettingKeys
    {
        /// <summary>
        /// 内网测试账号列表
        /// </summary>
        public const string ACCOUNT_LIST_DEBUG = "ACCOUNT_LIST_DEBUG";
        
        
        public const string LAST_SERVER_KEY = "DEBUG_LAST_SERVERID";

        /// 系统相关
        public const string GAME_UID = "Setting.GAME_UID";                                      // 用户id（使用这个）
        public const string GM_FLAG = "Setting.GM_FLAG";
        public const string UUID = "Setting.UUID";                                              // 用户uuid
        public const string DEVICE_ID = "DEVICE_ID";                                            // 设备保存ID，真机测试用
        public const string SERVER_IP = "SERVER_IP";
        public const string SERVER_PORT = "SERVER_PORT";
        public const string SERVER_ZONE = "SERVER_ZONE";


        /// 账号相关
        public const string ACCOUNT_LIST = "Setting.ACCOUNT_LIST";                              // 登录过的账号列表
        public const string IM30_ACCOUNT = "Setting.IM30_ACCOUNT";                              // IM30账号，本地缓存
        public const string IM30_PWD = "Setting.IM30_PWD";                                      // IM30密码，本地缓存
        public const string ACCOUNT_STATUS = "Setting.ACCOUNT_STATUS";                          // IM30账号，验证状态
        public const string ACCOUNT_SENDMIL_AGAINTIME = "Setting.ACCOUNT_SENDMIL_AGAINTIME";    // 记录验证邮件发送时间
        public const string WX_APPID_CACHE = "Setting.WX_APPID_CACHE";                          //微信账号
        public const string WX_USERNAME_CACHE = "Setting.WX_USERNAME_CACHE";                          //微信账号
        public const string FB_USERID = "Setting.FB_USERID";                                     //Facebook账号
        public const string FB_USERNAME = "Setting.FB_USERNAME";                                   //Facebook账号名字
        public const string DEVICE_UID = "Setting.DEVICE_UID";                                   //设备ID
        public const string CUSTOM_UID = "Setting.CUSTOM_UID";                                    //邮件
        public const string EMAIL_CONFIRM = "Setting.EMAIL_CONFIRM";                              //邮件确认
        public const string OICQ_USERID = "Setting.OICQ_USERID";                                    //OICQ
        public const string OICQ_USERNAME = "Setting.OICQ_USERNAME";                          //OICQ
        public const string WEIBO_USERID = "Setting.WEIBO_USERID";                                 //微博
        public const string WEIBO_USERNAME = "Setting.WEIBO_USERNAME";                          //微博
        public const string AZ_ACCOUNT = "Setting.AZ_ACCOUNT";
        public const string AZ_ACCOUNTSTATUS = "Setting.AZ_ACCOUNTSTATUS";





        //支付相关
        public const string COK_PURCHASE_SUCCESSED_KEY = "Setting.COK_PURCHASE_SUCCESSED_KEY";  //已成功订单号存放的key
        public const string COK_PURCHASE_KEY = "Setting.COK_PURCHASE_KEY";                      //订单信息存放的key
        public const string GP_USERID = "Setting.GooglePlayID";
        public const string GP_USERNAME = "Setting.GooglePlayName";

        public const string CATCH_ITEM_ID = "Setting.CATCH_ITEM_ID";

        public const string EFFECT_MUSIC_ON = "isEffectMusicOn";                                //音效
        public const string BG_MUSIC_ON = "isBGMusicOn";                                        //音乐
        public const string ThreeDWORLD_SWITCH = "3dworld_switch";                              //3d界面显示
        public const string SHOW_FAVORITE = "show_favorite";                                    //显示最爱
        public const string TASK_TIPS_ON = "isTaskTipsOn";                                      //任务
        public const string WORLD_SCROLL_UI = "world_scroll_gameui";

        public const string TOUCH_SP_FUN = "touch_sp_fun"; //
        public const string COORDINATE_ON_SHOW = "COORDINATE_ON_SHOW";                           //坐标提示
        public const string Transporter_Hidden = "transporter_hidden";                          //选中顺序是否开放
        public const string ISETTING_CASTLE_CLICK_PRIORITY = "ISetting_CastleClickPriority";

        public const string USER_LANGUAGE = "Setting.USER_LANGUAGE";                           //用户自定义语言


        public const string RECHARGE_ACTV_TOMORROW_TIME = "recharge.actv.tomorrow.time.mark";  //礼包相关
        public const string GUIDE_STEP = "guideStep";  //新引导当前引导步骤（用于重登）
        public const string GUIDE_MP4 = "guideMp4";  //新引导播放MP4

        public const string GUIDE_FOR_TERRITORY = "Setting.Armygroup_Territory6"; // 军团引导
        public const string GUIDE_FOR_MARCH = "Setting.Armygroup_Over6"; // 军团出征引导

        // 画面效果开关
        public const string POST_PROCESSING_BLOOM = "POST_PROCESSING_BLOOM"; // 后处理-Bloom
        public const string POST_PROCESSING_VIGNETTE = "POST_PROCESSING_VIGNETTE"; // 后处理-Vignette
        public const string SCENE_PARTICLES = "SCENE_PARTICLES"; // 场景粒子
        public const string RESOURCE_LOGGER = "Setting.Resource.Logger";
        
        public const string SCENE_GRAPHIC_LEVEL = "SCENE_GRAPHIC_LEVEL";
        public const string SCENE_FPS_LEVEL = "SCENE_FPS_LEVEL";
        
        //
        public const string SHOW_DEBUG_CHOOSE_SERVER = "SHOW_DEBUG_CHOOSE_SERVER";

        public const string MAIL_LAST_OPEN_TIME_BY_GROUP = "MAIL_LAST_OPEN_TIME_BY_GROUP_";

        public const string ALLIANCE_WAR_OLD_DATA = "ALLIANCE_WAR_OLD_DATA";
    }

    public class SoundAssets
    {
        public const string Music_M_city_1 = "m_city";//播放背景主界面声音
        public const string Music_M_city_3 = "m_field";//播放背景地图声音
        public const string Music_Sfx_logo_loading = "sfx_logo_loading";//播放登录LOGO背景音乐
        public const string Music_M_battle_1 = "m_city";//战斗场景背景音乐(野地，竞技场，藏宝图)
        // //
        public const string Video_bg_1 = "vedio_bg_1";//开场动画音乐
        //
        public const string Music_Bgm_night = "background_night";//主场景背景音乐
        public const string Music_Bgm_day = "background_daytime";//主场景背景音乐
        public const string Music_Effect_Open = "effect_open"; //打开界面
        public const string Music_Effect_Close = "effect_close"; //关闭界面
        public const string Music_Effect_Ground = "effect_ground"; //选中地块
        public const string Music_Effect_Mist = "effect_mist"; //选中迷雾
        public const string Music_Effect_Building = "effect_building"; //选中建筑
        public const string Music_Effect_Ranch = "effect_ranch"; //选中牧场
        public const string Music_Effect_Creeps = "effect_creeps"; //选中野怪/采集物
        public const string Music_Effect_Army = "effect_army"; //选中部队
        public const string Music_Effect_Electric = "effect_electric"; //收取电力
        public const string Music_Effect_Crystal = "effect_crystal"; //收取水晶
        public const string Music_Effect_Water = "effect_water"; //收取净水
        public const string Music_Effect_Gas = "effect_gas"; //收取瓦斯
        public const string Music_Effect_Coin = "effect_coin"; //收取金币
        public const string Music_Effect_Product1 = "effect_product1"; //收取农田作物
        public const string Music_Effect_Product2 = "effect_product2"; //收取畜牧产品
        public const string Music_Effect_Product3 = "effect_product3"; //收取加工品
        public const string Music_Effect_Trained = "effect_trained"; //收取士兵
        public const string Music_Effect_Plant = "effect_plant"; //播种
        public const string Music_Effect_Feed = "effect_feed"; //喂饲料
        public const string Music_Effect_Produce_Put ="effect_produce_put";//开始加工,拿起
        public const string Music_Effect_Produce_Box ="effect_produce_box";//开始加工,关上纸箱
        public const string Music_Effect_Bill = "effect_bill"; //交付订单
        public const string Music_Effect_Button = "effect_button"; //点击按钮
        public const string Music_Effect_Message = "effect_message"; //战斗胜利
        public const string Music_Effect_Finish = "effect_finished"; //建造/升级完成
        public const string Music_Effect_Rocket = "effect_rocket"; //火箭发射
        public const string Music_Effect_Rocket_Land = "effect_rocket_land"; //火箭发射
        public const string Music_Effect_Radar = "effect_radar"; //雷达扫描
        public const string Music_Effect_Alliance = "effect_alliance"; //联盟帮助
        public const string Music_Effect_Attack = "effect_attack"; //攻击
        public const string Music_Effect_Skill_Attack = "effect_skill";//技能攻击
    }

    public class BuildingTypes
    {
        public const int FUN_BUILD_MAIN = 400000; // 基地 总部大楼 (限制其他建筑的等级上限，本身受玩家殖民等级限制，兵力上限)
        public const int FUN_BUILD_BUSINESS_CENTER = 401000; // 商业中心 (提供居民订单列表入口、钻石商店、同盟援助商队)
        public const int FUN_BUILD_STABLE = 402000; // 联合太空中心 (援助盟友，链接侦察卫星（科技解锁相关数值）)
        public const int FUN_BUILD_SCIENE = 403000; // 科研中心 (研究科技)
        public const int FUN_BUILD_SMITHY = 407000; // 联合指挥中心 (集结兵力)
        public const int FUN_BUILD_CONDOMINIUM = 409000; // 公寓 (提供工人数量、居民（工人）订单气泡)
        public const int FUN_BUILD_HOSPITAL = 411000; // 维修站 (维修武器)
        public const int FUN_BUILD_STONE = 412000; // 采矿场 (采集面板资源矿)
        public const int FUN_BUILD_OIL = 413000; // 油井 (采集面板资源原油)
        public const int FUN_BUILD_ARROW_TOWER = 418000; // 炮台 (防御物)
        public const int FUN_BUILD_CAR_BARRACK = 423000;//车辆制造厂 (生产车辆类的武器) 
        public const int FUN_BUILD_INFANTRY_BARRACK = 424000;//轻武器工厂 (生产步兵类的武器) 
        public const int FUN_BUILD_AIRCRAFT_BARRACK = 425000;//飞机制造厂 (生产飞行类的武器) 
        public const int FUN_BUILD_TRAINFIELD_1 = 427000; //兵营1
        public const int FUN_BUILD_TRAINFIELD_2 = 793000; //兵营2
        public const int FUN_BUILD_TRAINFIELD_3 = 794000; //兵营3
        public const int FUN_BUILD_TRAINFIELD_4 = 795000; //兵营4
        public const int FUN_BUILD_WATER = 432000;//抽水站 (采集面板资源水)
        public const int FUN_BUILD_MARKET = 435000;//火箭发射场 交易中心 (火箭发射点，贸易，更换火箭皮肤)
        public const int FUN_BUILD_ROAD = 436000;//路 (由于火星地面土质较松、需要一种特殊的路)
        public const int FUN_BUILD_ELECTRICITY_STORAGE = 437000;//蓄电站 (储存电，通过科技解锁生产高能电池)
        public const int FUN_BUILD_WATER_STORAGE = 438000;//蓄水罐 (存放水)
        public const int FUN_BUILD_OIL_STORAGE = 439000;//储油罐 (储存原油)
        public const int FUN_BUILD_IRON_STORAGE = 441000;//矿石仓库 (储存矿石)
        public const int FUN_BUILD_WIND_TURBINE = 444000;//风力电站 (全天工作，初级电站，风沙时产量提升)
        public const int FUN_BUILD_SOLAR_POWER_STATION = 447000; // 太阳能发电站 (在白天工作，初级电站)
        public const int FUN_BUILD_DRONE = 477000; // 无人机平台 (提供建造队列)
        
        public const int FUN_BUILD_VILLA = 700000; // 别墅 (提升工程师数量，提升居民订单所需物品数量)
        public const int FUN_BUILD_OXYGEN = 705000; // 制氧站 (消耗水生产氧气供给居民订单
        public const int FUN_BUILD_INTEGRATED_FACTORY = 709000; // 综合工厂 (生产工业类二级产品，通过科技解锁产物种类)
        public const int FUN_BUILD_TRADING_CENTER = 710000; // 贸易中心 (地球火箭停靠点，提供地球订单、黑市商人)
        public const int FUN_BUILD_INFORMATION_CENTER = 713000; // 信息中心 (新闻玩法、服务器大事、纪念碑)
        public const int FUN_BUILD_COLD_STORAGE = 714000; // 冷库 (冷库、用来放置水果果蔬等需要保鲜的产品)
        public const int FUN_BUILD_COMPREHENSIVE_STORAGE = 715000; // 综合仓库 (大型物流仓库可以放置各种商品)
        public const int FUN_BUILD_DEFENCE_CENTER = 716000; // 备战中心
        public const int FUN_BUILD_DOME= 449000; // 苍穹
            
        
        public const int FUN_BUILD_FORGE = 429000; //装备制造//配件工厂
        public const int FUN_BUILD_ELECTRICITY = 431000; //发电厂
        public const int FUN_BUILD_RECHARGE_GARAGE = 445000; // 充值获得的车库
        public const int FUN_BUILD_HONOR_HALL = 446000;// 荣誉大厅
        public const int FUN_BUILD_BUILDING_CENTER = 448000; // 建造中心
        public const int FUN_BUILD_OFFICER = 483000;// 英雄大厅

        public const int APS_BUILD_WORMHOLE_MAIN = 791000;//虫洞-主
        public const int APS_BUILD_WORMHOLE_SUB = 792000;//虫洞-副
        public const int WORM_HOLE_CROSS = 735000; //跨服虫洞
        public const int FUN_BUILD_RADAR_CENTER = 417000; // 雷达
        public const int FUN_BUILD_TEMP_WIND_POWER_PLANT = 796000;//新手引导风力电站
        public const int FUN_BUILD_OUT_WOOD = 736000;//伐木场(生产资源道具)
        public const int FUN_BUILD_OUT_STONE = 737000;//(生产资源道具)


        public const int EDEN_WORM_HOLE_1 = 757000;//--伊甸园虫洞1 
        public const int EDEN_WORM_HOLE_2 = 758000;//--伊甸园虫洞2 
        public const int EDEN_WORM_HOLE_3 = 759000; //--伊甸园虫洞3
    }

    // 表名称
    public class TableName
    {
        public const string APSMonster = "APS_monster";     // 野战怪物
        public const string APSHeros = "aps_new_heroes";
        public const string GuideTab = "guide";                 // 引导配置表
        public const string PlotTab = "plot";                   // 剧情配置表
        public const string FieldMonster = "field_monster";     // 野战怪物
        public const string HeroTab = "new_heroes";             // 英雄
        public const string GoodsTab = "goods";                 // 物品
        public const string SkillTab = "skill";                 // 技能
        public const string BattleAnimation = "battle_animation";             // 战斗性效果
        public const string StatusTab = "status";
        public const string EquipRandomEffect = "equip_random_effect";        // 装备效果
        public const string AllianceGift = "alliance_gift";     // 联盟礼包
        public const string AllianceGiftGroup = "alliance_gift_group";
        public const string AllianceItemWarehouse = "alliance_item_warehouse"; // 联盟中心原材料
        public const string Territory = "territory";            // 联盟领地
        public const string TerritoryEffect = "territory_effect";            // 联盟领地
        public const string GoldrushBuilding = "goldrush_building";
        public const string ServerPos = "serverpos";//服务器世界联通
        public const string SiegeNPC = "siegeNPC";//NPC
        public const string Diary = "diary";//diary Diary_Xml 末日笔记
        public const string ActivityShow = "activity_show";//activity_show 活动数据
        public const string RightsEffectLevel = "rights_effect_level";//特权权益等级
        public const string RightsEffect = "rights_effect";//特权权益
        public const string VipStoreUnlock = "vip_store_unlock";//vip商店解锁
        public const string VipDetails = "vipdetails";//vip详情
        public const string WorldSeason = "world_season";  // 末日争霸-英雄预览
        public const string WorldBuilding = "building_world"; // 世界建筑
        public const string DesertTalent = "DesertTalent_DesertTalent";    // 专精
        public const string TalentShading = "DesertTalent_Shading";  // 专精
        public const string TalentHome = "talentHome";        // 专精类型
        public const string DesertGoldmineWar = "DesertGoldmineWar";
        public const string DesertTalentStats = "DesertTalentStats";    // 专精统计
        public const string Decompose = "decompose";                    // 加工厂原材料
        public const string Missile = "missile";//activity_panel 活动面板数据
        public const string LoadingTips = "loadingTips";//loading时的文字描述
        public const string Mail_ChannelID = "Mail_ChannelID"; //邮件列表排序
        public const string QuestXml = "quest";//任务队列表
        public const string DesertSkillXml = "desertSkill";
        public const string GuideStep = "guide_step_GuideStep";
        public const string GuideStepContentInfo = "guide_step_ContentInfo";
        public const string Office = "office";
        public const string DoomsDayNote = "doomsdaynote_doomsdaynote";
        public const string DD_Season_Group = "DD_season_group";
        public const string Building = "building";//建筑信息
        public const string BuildingDes = "building_des";//建筑信息
        public const string Chapter = "chapter_1";//章节任务信息
        public const string EffectName = "APS_effect_name";//作用号表
        public const string Global = "APS_global";//全局表（替代现有item）
        public const string Talent = "APS_talent";//天赋表
        public const string ResourceItem = "aps_resource_item";//资源道具表
        public const string GatherResource = "aps_gather_resource";//时间资源点
        public const string WorldCity = "worldcity"; //世界城市表
        public const string CityJunk = "aps_singlemap_junk"; //主城垃圾
        public const string Item = "item";
        public const string Decoration = "decoration";
        public const string Desert = "desert";
    }

    // 特殊ItemId
    public class SpecialItemID
    {
        public const int ITEM_MOVE_RANDOM = 200001;         // 随机迁城
        public const int ITEM_MOVE_CITY = 200002;           // 高级迁城
        public const int ITEM_FREE_MOVE_CITY = 200005;      // 免费迁城
        public const int ITEM_ALLIANCE_CITY_MOVE = 200008;  // 联盟迁城
        public const int ITEM_MERGESERVER_MOVECITY = 200453; //战区移民道具
        public const int ITEM_CROSS_MOVE_CITY = 200002; //跨服
        public const int ITEM_CROSS_FREE_CITY = 200005; //免费跨服
        public const int RECRUIT_TYPE_HERO_ACTIVITY = 200070;//限时招募
    }

    public class SoundGround
    {
        public const string Music = "Music";
        public const string Sound = "Sound";
        public const string Effect = "Effect";
        public const string Dub = "Dub";
    }

    public class AtlasAssets
    {
        public const string PlayerHeadIcons = "PlayerHeadIcons";

    }
    
    public static class UILayer
    {
        public const string Scene = "Scene";
        public const string Background = "Background";
        public const string UIResource = "UIResource";
        public const string Normal = "Normal";
        public const string Info = "Info";
        public const string Dialog = "Dialog";
        public const string Guide = "Guide";
        public const string TopMost = "TopMost";
        public const string Battle3D = "3DUIContainer";
    }
    

    public static class FontPath
    {
        public static string Japanese = "Assets/fonts_2/Murecho-SemiBold.ttf";
        public static string Title = "Assets/fonts/domyouji-regular.otf";
    }

    public static class SpritePath
    {
        public const string HeroIconSmall = "Assets/Main/Sprites/HeroIconsSmall/";
        public const string UITitleTag = "Assets/Main/Sprites/UI/UITitleTag/";
    }

    public static class QualitySetting
    {
        public const string PostProcess_Bloom = "QualitySetting.PostProcess.Bloom";
        public const string PostProcess_ColorAdjustments = "QualitySetting.PostProcess.ColorAdjustments";
        public const string PostProcess_Vignette = "QualitySetting.PostProcess.Vignette";
        public const string PostProcess_Tonemapping = "QualitySetting.PostProcess.Tonemapping";
        public const string PostProcess_LiftGammaGain = "QualitySetting.PostProcess.LiftGammaGain";
        public const string PostProcess_DepthOfField = "QualitySetting.PostProcess.DepthOfField";
        public const string Resolution = "QualitySetting.Resolution";
        public const string FPS = "QualitySetting.FPS";
        public const string Terrain = "QualitySetting.Terrain";
    }

    //引导类型
    public static class GuideType
    {
        public const int None = 0;
        public const int ClickButton = 1;//点击按钮
        public const int ShowTalk = 2;//人物对话
        public const int ClickBuild = 3;//点击建筑
        public const int BuildPlace = 4;//建筑建造
        public const int QueueBuild = 8;//跳转队列所在建筑
        public const int Bubble = 11;//气泡
        public const int GotoMoveBubble = 13;//点击垃圾点和迷雾弹出确认前往的气泡
        public const int OpenFog = 14;//迷雾
        public const int PlayMovie = 17;//播放timeline剧情
        public const int WaitMovieComplete = 18;//等待timeline剧情播放结束
        public const int ClickQuest = 19;//点击任务
        public const int WaitPlaceBuilding = 20;//等待建筑放置
        public const int WaitTroopArrive = 21;//等待行军到达目标点
        public const int WaitGarbageTroopMoveLeft = 22;//等待行军到达目标点剩余距离
        public const int WaitCloseUI = 23;//等待UI关闭
        public const int ClickBuildFinishBox = 24;//点击建筑完成的箱子
    }

    public static class CityLabelTextColor
    {
        public static Color32 Green = new Color32(181,248,49,255);
        public static Color32 Blue = new Color32(84,196,242,255);
        public static Color32 White = new Color32(228,228,228,255);
        public static Color32 Yellow = new Color32(255,133,39,255);
        public static Color32 Red = new Color32(252,81,77,255);
        public static Color32 Purple = new Color32(167,108,240,255);
    }

    public const string CityPathFile = "Assets/Main/Prefab_Dir/Home/CityPath/{0}.txt";
}

public enum PushType
{
    PUSH_GM = 0,
    PUSH_QUEUE = 1,         //队列
    PUSH_WORLD = 2,         //世界地图,拆分被攻击和被侦查
    PUSH_MAIL = 3,          //联盟
    PUSH_STATUS = 4,        //状态
    PUSH_ALLIANCE = 5,      //社交（聊天） 去掉联盟邮件
    PUSH_ACTIVITY = 6,      //活动 5的联盟邮件加进来
    PUSH_RESOURCE = 7,      //7资源满仓
    PUSH_CHAT = 8,          //8聊天
    PUSH_REWARD = 9,        //9礼包...音乐杀僵尸、食堂开餐等
    PUSH_WEB_ONLINE = 10,   //web在线?
    PUSH_ATTACK = 11,       //从2拆分出来,被攻击
    PUSH_SCOUT = 12,        //从2拆分出来,被侦察
    NOT_CHECK = 99,  //不用检查
};

public enum LodType
{
    None = 0,
    Custom = 1,
    MainSelf = 1001,
    MainAlly = 1002,
    MainOther = 1003,
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
    NPCCity = 5006,
    MainEnemy = 5007,
    WormHoleEnemy = 5008,
}

public enum SkinType
{
    BASE_SKIN = 1, //基地皮肤
    HEAD_SKIN = 2, //头像框
    TITLE_NAME = 3, //称号
}