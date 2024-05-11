using System;

public enum BuildingState
{
    None,//
    FindingPathState,//寻找路
    PrepareBuild,//准备阶段
    Building,//建设中--没用
    Upgrading,//升级中
    Idle,//等待状态
    Moving,//移动状态
    Producting,//生产
    WaitCollecting,//未用到
    //Healing,//医院治疗中
}

//这个资源类型和下面的类型对不上，10以后的会有问题，所以我写了一个映射，用来之间转换  by shimin 2019.3.21
public enum ResourceType
{
    None = -1,//默认值，只前端要用
    // 0 燃油
    Oil=0,
    // 1 金属
    Metal=1,
    // // 2 核燃料
    // Nuclear,
    // // 3 粮食
    // Food,
    // // 4 氧气
    // Oxygen,
    // // 5 贸易压力
    // Trade,
    // // 6 住房压力
    // House,
    // // 7 医疗压力
    // Hospital,
    // // 8 科技压力
    // Science,
    // // 9 建设压力
    // Build,
    // // 10 环境值
    // Environment,
    // 11 水
    Water =11,
    // 12 电
    Electricity =12,
    // // 13 人口
    // People,
    // 14 钞票
    Money=14,
    // 15钻石
    GOLD =15,
    // // 16受伤人口
    // WoundedPeople,
}

//新队列状态
public enum NewQueueState
{
    Free,//空闲
    Prepare,//准备
    Work,//工作
    Finish//完成（状态为客户端倒计时结束但未向服务器发送队列消息的状态）
}

public enum QueueProductState
{
    DEFAULT = 0,
}

public enum GlobalShaderLod
{
    LOW =0,
    MIDDLE =1,
    HIGH =2
}
//新队列类型
public enum NewQueueType
{
    Default = 0,//
    FootSoldier = 8,//机器人兵
    Hospital = 3,//急救帐篷
    Science = 6,//科技
    CarSoldier = 1,//坦克兵
    BowSoldier = 9,//飞机手
    ArmyUpgrade = 34,//士兵升级
    DomainHospital = 35,//地块医院
    EquipMaterial = 36,//配件中心材料
    Field = 39,//农田
    Barn = 40,//牧场
    TransportRes = 104,//资源运输
    Equip = 107,//配件中心装备
    BlastMissile = 111,//爆破飞弹
    GasMissile = 112,//毒气飞弹
    FreezingMissile = 113,//急冻飞弹
    CombustionMissile = 114,//燃烧飞弹
    IlluminationMissile = 115,//照明飞弹
}

//世界行军目的类型
public enum MarchTargetType
{
    STATE,//驻守
    ATTACK_MONSTER,//攻击
    COLLECT,//采集
    BACK_HOME,//回城
    ATTACK_BUILDING, // 4 攻击玩家建筑
    ATTACK_ARMY, // 5 攻击玩家编队
    JOIN_RALLY, //6 参加集结
    RALLY_FOR_BOSS, //7 集结打怪
    RALLY_FOR_BUILDING, //8 集结打建筑
    RANDOM_MOVE, //9 野怪状态，随便走走
    ATTACK_ARMY_COLLECT, //10 打采集编队，打完了采集
    ATTACK_CITY, //11 攻击大本
    RALLY_FOR_CITY, //12 集结大本
    ASSISTANCE_BUILD, //13 援助建筑
    ASSISTANCE_CITY, //14 援助大本
    GO_WORM_HOLE, // 16 进虫洞
    SCOUT_CITY,// 17 侦察城市
    SCOUT_BUILDING,// 18 侦察建筑
    SCOUT_ARMY_COLLECT,// 19 侦查部队
    EXPLORE,   //20小队探测
    SAMPLE,//21采样
    SCOUT_TROOP = 22,//侦查部队
    PICK_GARBAGE = 23,//捡垃圾
    RESOURCE_HELP = 24,//资源援助
    ATTACK_ALLIANCE_CITY,// 25 攻击联盟城市
    ASSISTANCE_ALLIANCE_CITY,// 26 防御联盟城市
    RALLY_FOR_ALLIANCE_CITY,// 27 集结攻打联盟城市
    SCOUT_ALLIANCE_CITY,//侦察建筑
    GOLLOES_EXPLORE,//29咕噜探索
    GOLLOES_TRADE,//30咕噜商队
    BUILD_WORM_HOLE, //31 建设虫洞
    TRANSPORT_ACT_BOSS, //32 传送活动boss
    DIRECT_ATTACK_ACT_BOSS,//33 直接攻击活动boss
    BUILD_ALLIANCE_BUILDING, // 34 建造联盟建筑
    COLLECT_ALLIANCE_BUILD_RESOURCE, // 35 采集联盟建筑资源
    CROSS_SERVER_WORM, // 36 跨服
    ATTACK_DESERT, //37 攻击地块
    ASSISTANCE_DESERT,//38 驻守地块
    SCOUT_DESERT,//39 侦察地块
    TRAIN_DESERT,//40 地块训练  Target
    DIRECT_ATTACK_CITY,//41奇袭大本
    ATTACK_ALLIANCE_BUILDING, // 42 攻击联盟建筑
    RALLY_ALLIANCE_BUILDING, // 43 集结联盟建筑
    SCOUT_ALLIANCE_BUILDING, // 44 侦察联盟建筑
    ASSISTANCE_ALLIANCE_BUILDING, // 45 援助联盟建筑
    DIRECT_ATTACK_NPC_CITY, //46 奇袭NPC城市
    ATTACK_NPC_CITY, // 47 攻击NPC城市
    RALLY_NPC_CITY, // 48 集结NPC城市
    SCOUT_NPC_CITY, // 49 侦察NPC城市
    RALLY_THRONE, // 50 集结王座
    RALLY_ASSISTANCE_THRONE, // 51 集结援助王座
    SCOUT_THRONE,// 52 侦察王座
    ATTACK_ALLIANCE_BOSS, //53 攻击联盟boss
    ATTACK_ACT_ALLIANCE_MINE,//54 攻击活动联盟矿
    RALLY_FOR_ACT_ALLIANCE_MINE,//55 集结攻击联盟活动矿F
    ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE,//56 采集联盟活动矿
    SCOUT_ACT_ALLIANCE_MINE,//57 侦察联盟活动矿
    
    ATTACK_DRAGON_BUILDING, // 58 攻击战场建筑
    RALLY_DRAGON_BUILDING, // 59 集结战场建筑
    SCOUT_DRAGON_BUILDING, // 60 侦察战场建筑
    ASSISTANCE_DRAGON_BUILDING, // 61 援助战场建筑
    TAKE_SECRET_KEY, //62 获取战场密钥
    PICK_SECRET_KEY, //63 拾取战场密钥
    TRANSPORT_SECRET_KEY, //64 运送战场密钥
    TRIGGER_DRAGON_BUILDING,//65 攻击/援助战场建筑
    TRIGGER_CROSS_THRONE_BUILDING, // 66 攻击/援助王座建筑
    RALLY_CROSS_THRONE_BUILDING, // 67 集结王座建筑
    SCOUT_CROSS_THRONE_BUILDING, // 68 侦察王座建筑
    ASSISTANCE_CROSS_THRONE_BUILDING, // 69 援助王座建筑
}

public enum MarchStatus
{
    DEFAULT =-1,//初始状态
    STATION, // 0 驻军
    MOVING, // 1 行军中
    ATTACKING, // 2 攻击中
    COLLECTING, // 3 采集中
    BACK_HOME, // 4 到家
    CHASING, //5 追逐
    WAIT_RALLY, //6 等待集结中
    IN_TEAM, //7 在集结中
    ASSISTANCE, //8 在援助单位中
    IN_WORM_HOLE, //9 在虫洞中    
    SAMPLING,//10采样中
    PICKING,//11捡垃圾
    GOLLOES_EXPLORING,//12咕噜探索中//DEATH,//12 死亡
    BUILD_WORM_HOLE, //13 建设虫洞中
    DESTROY_WAIT, //14 等待拆除耐久
    BUILD_ALLIANCE_BUILDING, //15 建造联盟建筑中
    TRANSPORT_BACK_HOME, // 16 传送回家
    CROSS_SERVER, // 17 跨服虫洞中
    WAIT_THRONE, // 18 王座排队中
    COLLECTING_ASSISTANCE,//19 活动联盟矿专用，采集并在援助中
    WAIT_DRAGON_BUILD, // 20 等待巨龙建筑中
    WAIT_CROSS_THRONE, // 21 等待跨服王座建筑中
}
 
public enum NewMarchType
{
    DEFAULT =-1,//初始状态
    NORMAL, // 0 普通出征
    ASSEMBLY_MARCH, // 1 联盟出征
    MONSTER, // 2 怪物
    BOSS, // 3 BOSS
    SCOUT,//4 侦查
    EXPLORE,//5 探索
    RESOURCE_HELP,//6资源援助
    GOLLOES_EXPLORE,//7咕噜探索
    GOLLOES_TRADE,//8咕噜商队
    ACT_BOSS, //9 活动BOSS
    PUZZLE_BOSS, //10 拼图BOSS
    DIRECT_MOVE_MARCH, //11 非自由行军，不可操作
    CHALLENGE_BOSS,//12 挑战BOSS
    MONSTER_SIEGE,//13 黑骑士攻城
    ALLIANCE_BOSS, //14 联盟boss
}

public enum DamageType
{
    /**
        * 0 默认
        */
    DEFAULT,
    /**
     * 1 普通攻击
     */
    ATTACK,
    /**
     * 2 反击
     */
    COUNTER_ATTACK,
    /**
     * 3 护盾攻击
     */
    SHIELD_ATTACK,
    /**
     * 4 护盾
     */
    SHIELD,
    /**
     * 5 恢复伤兵
     */
    RECOVER_DAMAGE,
    /**
     * 6 添加Buff
     */
    ADD_EFFECT,
    /**
     * 7 使用技能
     */
    USE_SKILL,
    /**
     * 8 怒气
     */
    ADD_ANGER,
    /**
 * 9 根据攻击目标个数增加怒气
 */
    ADD_ANGER_BY_TARGET_NUM,
    /**
 * 10 反击到护盾攻击
 */
    SHIELD_COUNTER_ATTACK,

}
public enum CombatUnitType
{
    /**
     * 0 默认
     */
    DEFAULT,
    /**
     * 1 编队
     */
    ARMY,
    /**
     * 2 普通建筑
     */
    BUILDING,
    /**
     * 3 箭塔
     */
    TOWER,
    /**
     * 4 怪物
     */
    MONSTER,
    /**
     * 5 集结编队
     */
    RALLY_TEAM,
    /**
     * 6 BOSS
     */
    BOSS,
    /**
     * 7 大本
     */
    CITY,
    /**
     * 8 路
     */
    ROAD,
    /**
     * 9 探索点
     */
    EXPLORE_POINT,
    /**
     * 10 联盟中立城
     */
    ALLIANCE_NEUTRAL_CITY,
    /**
     * 11 联盟占领城
     */
    ALLIANCE_OCCUPIED_CITY,
    /**
     * 12 冠军对决
     */
    ELITE,
    /**
     * 13 PVE玩家编队
     */
    PVE_MARCH,
    /**
     * 14 PVE怪物
     */
    PVE_MONSTER,
    /**
     * 15 活动boss
     */
    ACT_BOSS,
    /**
     * 16 活动boss
     */
    PUZZLE_BOSS,
    /**
    * 17  挑战BOSS
    */
    CHALLENGE_BOSS,
    /**
    * 18  地块
    */
    Desert,
    /**
 * 19 训练地块
 */
    TRAIN_DESERT,
    /**
 * 20 联盟建筑
 */
    ALLIANCE_BUILDING,
    /**
 * 21 NPC城
 */
    NPC_CITY,
    /**
    * 22 联盟城守备军
    */
    ALLIANCE_CITY_GUARD,
    /**
 * 23 玩家大本守备军
 */
    CITY_GUARD,
    /**
 * 24 联盟建筑守备军
 */
    ALLIANCE_BUILD_GUARD,
    /**
 * 25 NPC城市守备军
 */
    NPC_CITY_GUARD,
    
    // 26 黑骑士
    MONSTER_SIEGE,
    //27 王座军队
    THRONE_ARMY,
    // 28 跨服虫洞
    CROSS_WORM,

    // 30 联盟boss
    ALLIANCE_BOSS = 30,
    /**
     * 31 陷阱
     */
    CITY_TRAP,
    /**
     * 32 活动联盟矿
     */
    ACT_ALLIANCE_MINE,
    
    DRAGON_BUILDING, // 33 巨龙建筑
    
    CROSS_THRONE,//34 跨服王座建筑
}

public enum APSSpecialUnitType
{
    // 0 无
    NONE,

    // 1 联盟城NPC怪物
    ALLIANCE_CITY_NPC,

    // 2 建筑守军
    BUILDING_STATION,

    // 3 城市守军
    CITY_STATION,

    // 4 集结队长
    TEAM_LEADER,

    // 5 集结成员
    TEAM_MEMBER,

    // 6 PVE行军
    PVE_MARCH,

    // 7 PVE怪物
    PVE_MONSTER,

    // 8 活动BOSS
    ACT_BOSS,

    // 9 竞技场NPC
    ARENA_NPC,

    // 10 拼图BOSS
    PUZZLE_BOSS,

    // 11 挑战BOSS
    CHALLENGE_BOSS,

    // 12 地块NPC
    DESERT_NPC,

    // 13 联盟城警备队
    ALLIANCE_CITY_POLICE_NPC,
    // 14 联盟建筑警备队
    ALLIANCE_BUILD_POLICE_NPC,
// 15 大本守军
    CITY_POLICE_NPC,
    // 16 跨服虫洞守军
    CROSS_WORM_STATION,
    // 17 黑骑士
    MONSTER_SIEGE,
    // 18 炮塔
    TOWER,
    // 19 联盟Boss
    ALLIANCE_BOSS,
    // 20 陷阱
    TRAP,
    // 21 活动联盟矿守军
    ACT_ALLIANCE_MINE_GUARD,

}

public enum HeroSkillType
{
    //0 默认
    DEFAULT = 0,

    //1 全局生效技能
    GLOBAL_SKILL = 1,

    //2 编队中生效技能
    FORMATION_SKILL = 2,

    //3 机器人生效技能
    ROBOT_SKILL = 3,

    //10 普通攻击
    NORMAL_SKILL = 10,

    //11 怒气攻击(主动技能)
    RAGE_SKILL = 11,

    //12 进入战斗释放技能
    START_BATTLE_SKILL = 12,

    //13 特定英雄加成技能
    SPECIAL_HERO_ADD_SKILL = 13,

    //14 子技能
    SUB_SKILL = 14,
}

public enum APSDamageEffectType {
    //0 默认
    DEFAULT = 0,
    //1 暴击
    CRIT= 1,
    //2 闪避
    MISS =2,
}

public enum ArmyBattleStatus
{
    NONE,//无状态
    START_BATTLE,//开始战斗
    BATTLEING,//战斗中
    END_BATTLE//结束战斗
}

//小车探索状态
public enum Explore_State
{
    Explore_None,
    Explore_Ing = 3,
};

public enum Explore_Queue_State
{
    Explore_Queue_None,//小车无行进动作
    Explore_Queue_GO,//小车出发中
    Explore_Queue_Work,//在目的地正在进行探索
    Explore_Queue_Move,//在目的地切换探索点
    Explore_Queue_Back,//探索解说返回中
};

public enum Explore_Mode
{
    Explore_Mode_Normal,
    Explore_Mode_Grade,
};

public enum LookAtFocusState
{
    None = 0,//无聚焦
    PlaceBuild = 2,//聚焦放置普通建筑
    Dome = 4,//聚焦苍穹
    MoveCity = 5,//聚焦迁城
    Formation = 6,//聚焦出征
}

public enum ItemType
{
    SUNDRIES, // 0
    OPEN_QUEUE, // 1
    SPD, // 2
    USE, // 3
    STATE, // 4
    REWARD, // 5
    AUTO, // 6
    EQUIPMENT, // 7
    ADD_SOLDIER, // 8
    UNKNOWN1, // 9
    UNKNOWN2, // 10
    SUMMON_RESOURCE, // 11 召唤资源
    SUMMON_MONSTER, // 12 召唤怪物
    SYN_USE, // 13
    UNKNOWN3, // 14
    RED_PACKETS, // 15
    INCREASE_MARCH_LIMIT_PERCENT, // 16
    SUPPLIES, // 17
    TALISMAN, // 18
    HEART, // 19
    JUST_USE, // 20
    SUGGEST_ITEM, // 21
    STATEORCOMBINE, // 22
    INCREASE_MARCH_LIMIT, // 23
    UNKNOWN4, // 24
    NEWEXTRA, // 25
    perch1, // 26
    perch2, // 27
    perch3, // 28
    perch4, // 29
    CLEAR_CDTIME, // 30
    POS_31, // 31
    PRESENT_ARMY, // 32
    AIRBORNE_TROOPS_ITEM, // 33 空降兵道具
    SEVENDAY_LOTTERY_TIMES, // 34
    MISSILE_ADD, // 35 增加导弹道具
    PROTECT, // 36 开罩道具
    PRESENT_MONTH_CARD, // 37 送月卡道具
    RESCUE_CENTER, // 38 救护中心道具
    PREVENT_CITY_STOP_FIRE, // 39 炼狱燃烧道具
    ADD_SOLDIER_MULTIPLE, // 40 练兵数量翻倍道具
    MISSILE_PLUGIN, // 41 导弹插件
    INCREASE_MARCH_LIMIT_REINFORCE, // 42 单次提高援兵上限道具
    MARCH_REINFORCE_LOCK, // 43 援军锁定，迁城不回城
    DESTROY_BUILDING, // 44 拆特定建筑如
    SEND_GIFT, //45 赠送礼品
    EQUIP_MATERIAL_BOX, //46 可以选择的装备材料道具箱
    HERO_ACTIVITY_UPGRADE, //47 高级军备竞赛邀请函
    RESET_DESERT_TALENT, //48 重置沙漠天赋
    ADD_DESERT_TALENT_POINT, //49 获取沙漠天赋能力点数
    DESERT_STATEORCOMBINE, //50 沙漠积分卡
    BF_HOSPITAL_SPEED, //51 竞技场医院加速道具(按数量治愈)
    KINGDOM_MEDAL, //52 大帝勋章
    ITEM_TYPE_53,
    ITEM_TYPE_54,
    CHILDREN_DAY_GIFT, //55 儿童节礼物
    ITEM_TYPE_56,
    DESERT_EXP_ADD_CARD, //57  沙漠经验卡
    EQUIP_TRAN_FREE_TIMES, //58  勋章改良次数
    ITEM_BOX, //59 道具组合选择箱
    BF_BADGE, //60 竞技场徽章
    FOR_NEW_BUILDING, //61 兑换建筑
    HERO_MEDAL, //62 英雄勋章
    HERO_SKILL_BOOK, // 63 英雄技能书
    CHOOSE_CAREER, // 64 切换玩家职业道具
    OCCUPY_DOMAIN, //65 占地块
    ITEM_TYPE_66, // 66 不知道是什么 要找策划问
    ITEM_TYPE_67, // 67 不知道是什么 要找策划问
    ADD_DOMAIN_LIMIT, // 68 指定数量的土地上限，数值读取para1，效果持续到赛季结束
    ADD_DURABLE_VALUE, // 69 为运兵车耐久恢复道具
    HERO_DEBRIS, // 70 英雄碎片
    ITEM_TYPE_71,
    CROSS_OCCUPY_DOMAIN, // 72 跨服占地块
    CLASH_MEDAL //73 赛季奖章
}

public enum RewardType
{
    OIL = 0,//0
    METAL,//1
    NUCLEAR,//2
    FOOD,//3
    OXYGEN,//4
    TRADE,//5
    EXP,//6
    GOODS,//7
    GENERAL,//8
    POWER,//9
    HONOR,//10
    ALLIANCE_POINT,//11
    HOUSE,//12
    HOSPITAL,//13
    EQUIP,//14
    MATERIAL,//15
    PART,//16
    ITEM_EFFECT,//17
    BATTLE_HONOR,//18
    WATER,//19
    MONEY,//20
    ELECTRICITY,//21
    PEOPLE,//22
    ARM,//23
    MANOR,//24
    HERO,//25
    PTGOLD,//26
    RESOURCE_ITEM,//27
    PVE_POINT,//28
    DETECT_EVENT,//29
    FORMATION_STAMINA,//30
    WOOD,//31
    PVE_STAMINA,//32
    PVE_MONUMENT_TIME,//33
}

public enum OriginRewardType
{
    R_OIL
    , R_IRON
    , R_WOOD
    , R_FOOD
    , R_SILVER
    , R_GOLD
    , R_EXP
    , R_GOODS
    , R_GENERAL
    , R_POWER
    , R_HONOR
    , R_ALLIANCE_POINT
    , R_CHIP
    , R_DIAMOND
    , R_EQUIP
    , R_BOX
    ,ITEM_EFFECT = 17//17 这个ls没有是我加的，方便显示(..前面的兄弟虽然注释是17，但是实际是16，所以这样改了。。)
    , R_AREA_HONOR = 18
    , R_WATER
    , R_MONEY
    , R_Electricity
    , R_People
    , R_Army
    , R_Manor //地块 邮件用
    , R_Hero
    , R_PtGold  // 平台币
    , R_PROFESSIONA_EXP //国家任务经验
}

public enum SpecialType
{
    S_NONE,
    S_TOTALCHARGE
}

// 士兵枚举类型
public enum ArmEnumType
{
    ARM_BU = 1,
    ARM_QIANG,
    ARM_RIDE,
    ARM_RIDE_SHE,
    ARM_GONG,
    ARM_NU,
    ARM_TOU_SHI_BING,
    ARM_CHE,
};

public enum ArmType
{
    ARMY,
    FORT,
    TREAT_ARMY,
};

public enum Direction
{
    N,
    NW,
    W,
    SW,
    S,
    SE,
    E,
    NE
}

public enum GridType
{
    NEUTRALLY,
    STOP,
    SPACE
};

public enum WorldTileType
{
    OriginTile = 0 //0
    , CityTile//世界城市
    , CampTile//2 扎营地
    , ResourceTile// 3 资源
    , KingTile//// 4 遗迹
    , BattleTile// 5 塔
    , MonsterTile// 6 地宫
    , MonsterRange
    , CityRange// 8 玩家周边
    , FieldMonster // 9 野怪
    , Throne //王座
    , ThroneRange //王座周边
    , Trebuchet //投石机
    , TrebuchetRange //投石机周边
    , Tile_allianceArea //联盟主堡 14
    , ActBossTile// 15 活动怪物boss
    , Tile_allianceRange//领地周边16
    , ActBossTileRange
    , tile_superMine//18
    , tile_superMineRange//19
    , TERRITORY_BUILDING //20
    , title_Armory//21军械库
    , title_Prison//22监狱
    , title_Laboratory//23实验室
    , title_SuperMarket//24超市
    , tile_banner//联盟国旗25
    , tile_resBuilding//26
    , tile_disScout//27挖
    , tile_disOccupy//28
    , tile_siege//29征服岛建筑
    , tile_siegeRange//30征服岛周边
    , tile_Npc = 31//31
    , tile_NpcRange = 32//32
    , Tile_allianceSolder = 33 //联盟兵营
    , tile_wheelfight_building = 34 //34 车轮战建筑
    , tile_wheelfight_range = 35 // 车轮战建筑周边
    , Tile_kingdomMedal = 36 //大王座雕像
    , tile_desert_throne //沙漠里的王座
    , tile_desert_pyramid//
    , tile_build_city //副堡
    , tile_desert_goldrush = 41//淘金者营地
    , tile_desert_goldrush_range = 42//淘金者营地周边
    , tile_desert_gold_resource = 43/**43 沙漠金币矿*/
    , tile_desert_alliance_fight_space = 44/**44 沙漠争夺中的 地块标记*/
    , tile_build_corps = 45 //边境战基地
    , tile_build_corps_range = 46 //边境战基地周边
    , tile_NOT_COVERED_DOMAIN = 47 // 不可压的地块儿
    , tile_FIGHT_FOR_DOMAIN_MARK = 48 // 此地块儿被兵占着
    , tile_USER_WORLD_BUILDING = 49 // 玩家的世界建筑
    , tile_TERRITORY_ASSEMBLE = 53 // 联盟跨服集结点
    , tile_TERRITORY_ASSEMBLE_RANGE = 54 // 联盟跨服集结点周边
    , tile_city_ruins = 55 // 55 城市飞之后的废墟
    , tile_USER_WORLD_PRISON = 56 //56 世界监狱
    , tile_USER_WORLD_PRISON_RANGE = 57 //57 世界监狱周边
    , tile_ALLIANCE_WAR_FORTRESS = 61 //61驻军基地
    , tile_ALLIANCE_WAR_FORTRESS_RANGE = 62 //62驻军基地周边
    , tile_ALLIANCE_TEMPORARY_LAND = 63 //63临时地皮
    , tile_FBCareer_1 = 64 //职业
    , tile_FBCareer_2 = 65 //职业
    , tile_FBCareer_3 = 66 //职业
    , tile_FBCareer_4 = 67 //职业
    , tile_FBCareer_5 = 68 //职业
    , tile_FBCareer_6 = 69 //职业
    , tile_FBCareer_7 = 70 //职业
    , tile_FBCareer_8 = 71 //职业
    , tile_DOMAIN_CITY = 80 //中立城市
    , tile_DOMAIN_CITY_WALL = 81 //中立城市围墙
    , tile_MOVE_PLAY_CITY_MACHINE = 82 //迁城中的地表类型
        , tile_SnowMan = 105 //雪人BOSS
}
public enum PlayerType
{
    PlayerNone = -1, // 无
    PlayerSelf = 0, // 自己
    PlayerAlliance = 1, // 盟友
    PlayerOther = 2, // 敌人
    PlayerAllianceLeader = 3, // 盟主
};

public enum MainBuildOrder
{
    Other = 21, // 其他
    Enemy = 22, // 敌人
    Ally = 23, // 盟主
    Leader = 24, // 盟友
    Self = 25, // 自己
}

public enum BuildIconType
{
    /// <summary>
    /// 升级
    /// </summary>
    BuildState_Upgrading,
    /// <summary>
    ///建筑的类型
    /// </summary>
    BuildType,
    /// <summary>
    /// 其他位置
    /// </summary>
    CityTilePos,

    /// <summary>
    /// 收兵
    /// </summary>
    Training,
    /// <summary>
    /// Vip
    /// </summary>
    Vip,
    /// <summary>
    /// 加速
    /// </summary>
    ProduceCenter,//这个是生产中心的加速

    SoliderUp,

    VipLock,

    Troop,

    WeaponSupply,

    PartsEquipComplete,

    Manage,

    Landscape,

    HeroHall,

    /// <summary>
    /// 请求帮助-BuildingQueue
    /// </summary>
    HelpBQ,
    /// <summary>
    /// 请求帮助-BuildingQueueFB
    /// </summary>
    Help,
    /// <summary>
    /// 帮助所有
    /// </summary>
    AllianceHelp,

    Energy,

    CollectMissile,

    ClashNews,

    Chip,

    Career,

    AllianceMoney,

    Clone,

    RapidProduce,

    CollectEquip,

    Matirial,

    EquipCenter,
    /// <summary>
    /// 未选司机气泡
    /// </summary>
    GarageNoChooseDriver,
    /// <summary>
    /// 圣诞礼物
    /// </summary>
    ChristmasGift,
    /// <summary>
    /// 圣诞气泡
    /// </summary>
    ChristmasCard
};

//建筑时间进度条类型
public enum BuildTimeType
{
    BuildTime_Move,//建筑移动
    BuildTime_Transport,//运输状态
    BuildTime_Upgrading,//建筑升级
    BuildTime_FootSoldier,//步兵
    BuildTime_CarSoldier,//车兵
    BuildTime_BowSoldier,//射手
    BuildTime_ArmyUpgrade,//士兵升级
    BuildTime_Matirial,//生产材料
    BuildTime_Equip,//生产装备
    BuildTime_Missile,//生产导弹
    BuildTime_Injuries,//伤病恢复
    BuildTime_Science//科研中心研究
}

public enum TruckTalkType
{
    Talk_None,//平时说的话0
    Talk_NO_Electricity,//确定1
    Talk_NO_FoodShop,//餐车缺粮和水2
    Talk_Wounded_Soldier,//帐篷有伤病3
    Talk_Night_Working,//夜间出车4
    Talk_Uping_FoodShop,//给餐车升级5
    Talk_Transport_Electricity,//给发电站运油6
    Talk_Transport_FoodShop,//给餐车运缺粮和水7
    Talk_Uping_HeroOfficer,//英雄建筑升级8
    Talk_Uping_ResourceBuild,//有资源建筑在升级9
    Talk_Training_Soldier,//训练营正在训练士兵10
    Talk_NO_ScienceQueue,//科技队列处于空闲11
    Talk_NO_TrainQueue,//训练营没在练兵12
    Talk_Finish_Rapid,//科技解锁极速模式13
    Talk_Hight_SpeedProduct,//急速生产概率已满14
    Talk_Give_Hero,//诺拉在路上15
    Talk_Knocked_Zombie,//撞死丧尸16
    Talk_Meet_Cars,//两车相会17
    Talk_Meet_Car_People,//车人相会18
    Talk_Uping_BrokenWall,//升级城墙19
    Talk_Uping_BaseInGuide,//新手期间升级大本到1级20
    Talk_Uping_Barrack1InGuide,//新手期间升级勇士训练营到1级21
    Talk_Uping_ElectricityInGuide,//新手期间升级燃油发电厂到1级22
    Talk_Uping_OilInGuide,//新手期间升级油井到1级23
    Talk_Transport_ElectricityInGuide//新手期间运油24
}

public enum MailType
{
    //-后为服务器type
    MAIL_SELF_SEND = 0, //0-21
    MAIL_USER,      //1-22
    MAIL_SYSTEM,    //2
    MAIL_SERVICE,   //3
    MAIL_BATTLE_REPORT,//4-7
    MAIL_RESOURCE,     //5
    MAIL_DETECT,        //6
    MAIL_GENERAL_TRAIN,//7
    MAIL_DETECT_REPORT,//8
    MAIL_ENCAMP,//9
    MAIL_FRESHER,//10-14
    MAIL_WOUNDED,//11
    MAIL_DIGONG,//12
    ALL_SERVICE,//13
    WORLD_NEW_EXPLORE,//14-12
    MAIL_SYSNOTICE,//15
    MAIL_SYSUPDATE,//16
    MAIL_ALLIANCEINVITE,//17
    MAIL_ATTACKMONSTER,//18
    WORLD_MONSTER_SPECIAL,//19
    MAIL_ALLIANCE_ALL, //20
    MAIL_RESOURCE_HELP,//21-10

    MAIL_PERSONAL,
    MAIL_MOD_PERSONAL,
    MAIL_MOD_SEND,
    MAIL_ALLIANCEAPPLY,//25
    MAIL_INVITE_TELEPORT,//26
    MAIL_ALLIANCE_KICKOUT,//27
    MAIL_GIFT,//28
    MAIL_DONATE,// 29
    MAIL_WORLD_BOSS,//30
    MAIL_UNSIGN_ALLIANCE,//31
    MAIL_OFFICAL,//32联盟官职
    MAIL_PRISON, //33监狱释放邮件
    GIFT_BUY_EXCHANGE,   //34购买礼包给玩家发的邮件
    CHAT_ROOM,   //35
    MAIL_ACTIVITY,//36
    MAIL_REFUSE_ALL_APPLY, //37 拒绝申请加入联盟
    MAIL_ALLIANCE_PACKAGE, //38 联盟礼包
    MAIL_SHAMOEXPLORE = 39,  //沙漠探索
    MAIL_MISSILE = 40, //导弹邮件
    MAIL_GIVE_SOLDIER = 41, //盟友赠兵邮件
    MAIL_ALLIANCE_DONATE = 42, //联盟捐献邮件
    MAIL_MOVE_FORTRESS = 44, //邀请前往要塞
    MAIL_PRESIDENT_SEND = 45, //总统发本要塞所有指挥官邮件
    MAIL_GIFT_RECEIVE = 46, //收到礼品邮件
    MAIL_VOTE = 47,// 可投票邮件
    MAIL_CASTLE_ACCOUNT = 48,// 副堡结算邮件
    MAIL_BORDER_FIGHT = 49,// 边境战邮件
    MAIL_CITY_FIGHT_FB = 50, // 自由城建战报 Mail_CityFight_FB
	MAIL_MONSTER_FIGHT_FB = 51, // 城市丧尸攻城 MAIL_MONSTERATTACKCITYFIGHT_FB
	MAIL_RESOURCE_FIGHT_FB = 52, // 资源战斗 Mail_ResourceFight_FB
	MAIL_SPACE_FIGHT_FB = 53, // 空地战斗
    MAIL_ATTACKMONSTER_FIGHT_FB = 54,///*54 普通打怪 **/
    MAIL_MANOR_FIGHT_FB = 55, ///*55 LS 地块战斗 **/
    MAIL_activity_FIGHT_FB = 56,// 自由城建未知（未用）
    MAIL_USER_WORLD_BUILDING_FIGHT_FB = 57,///*57 玩家世界建筑 **/
    MAIL_NEW_SCOUT_REPORT_FB = 58, ///*58 自由城建侦查邮件 **/
    MAIL_CONTRAST_WORLD_BOSS = 59, ///*59 野怪集结战报 **/
    MAIL_ALLIANCE_RECOMMEND = 60,///*60 联盟推荐 **/
    MAIL_WARZONE_FB = 61,///*61 最强战区 **/
    MAIL_SEASONWARZONE_FB = 62, ///*62 最强战区赛季 **/
    MAIL_HEROBATTLE_FB = 63, ///*63 英雄对决 保存战报 **/
    MAIL_CITYLV_UP = 64,//基地升级提示
    MAIL_CLONE_SOLDIERS = 65,////克隆中心复活兵
    MAIL_ACTIVITY_COMMON = 66, //通用活动邮件
	MAIL_EXPLORE_CITY_REPORT = 67, //基地探索奖励报告邮件
	MAIL_PRESIDENT_WORK_REPORT = 68,//总统
	MAIL_MANOR_SYS_REPORT = 69 //末日争霸普通通知邮件
    ,BOMB_ATTACK/**70 炸弹人*/
    ,ESPIONAGE_ATTACK/**71 间谍*/
    ,NEW_FIGHT_BUILDING/**72 打玩家建筑*/
    ,NEW_FIGHT_ARMY/**73 编队打编队*/
};

// Null1(false),                    /*废弃00*/
//     Null2(false),                    /*废弃 01*/
//     System(false),                    /*系统栏 02*/
//     Null3(false),                    /*废弃 03*/
//     Null4(false),                    /*废弃 04*/
//     Resource(true, DELETE_ALL, false),                    /*系统栏 05*/
//     Detect(false),                    /*系统栏 被侦查邮件类型 06*/
//     Fight(true, DELETE_EXCEPT_RESERVE, true),                    /*系统栏 07*/  //4 => 7
//     Detect_Report(true, DELETE_EXCEPT_RESERVE, false),            /*系统栏 侦查别人邮件类型 08*/
//     ENCAMP(true),                    /*系统栏 09*/
//     TradeResource(true, DELETE_ALL, false),            /*资源援助 10*/    //世界探险邮件旧格式 12
//     Cure_Soldier(false, DELETE_ALL, false),            /*系统栏 11*/
//     WORLD_NEW_EXPLORE(true),        /*系统栏 12*/    //世界探险邮件新格式 14=>12
//     AllServerWithPush(false),        /*公告栏 13*/    //可回复(GM 回复个人/全服)
//     MAIL_FRESHER(false),            /*公告栏 14*/    //10 => 14
//     SysNotice(false),                /*公告栏 15*/    //不可回复(XML - MAIL)
//     UpNotice(false),                /*公告栏 16*/
//     AllianceInvite(true),            /*个人栏 17*/
//     WORLD_MONSTER(true, DELETE_ALL, true),            /*世界野外打怪 18*/
//     Null6(false),                    /*废弃 19*/
//     Alliance_ALL(false),            /*联盟邮件 20*/
//     Send(false),                    /*个人栏 21*/ //0 => 21
//     Personal(false),                /*个人栏 22*/ //1 => 22
//     ModSend(false)                    /*MOD 23*/
//     , ModPersonal(false)                /*MOD 24*/
//     , AllianceApply(true)            /*申请加入联盟 25*/
//     , InviteMovePoint(true)          /*邀请迁城 26*/
//     , KickAllianceUser(true)         /*踢出联盟成员 27*/
//     , GIFT(false)                    /*邮件送礼 28*/
//     , GIFT_EXCHANGE(false)           /*礼包赠送 29*/
//     , MONSTER_BOSS(true)          /*世界BOSS战报 30*/
//     , Alliance_Unsign(false)            /*联盟邮件发给今天未签到成员 31*/
//     , AllianceOfficalApply(true)   // 申请联盟官职32
//     , UserHeroMail(true)   // 英雄系统的邮件类型33
//     , GIFT_BUY_EXCHANGE(false)           /*礼包购买 34*/
//     //合并自cok邮件代码 start 前一个注释为cok中的序号,后一个注释为mori的序号
//     , CHAT_ROOM(true)          /**//*35*/
//     , MONSTER_BOSS_REWARD(true)  /*世界BOSS奖励邮件 32*//*36*/
//     , RefuseAllianceApply(true)  /*拒绝申请加入联盟 33*//*37*/
//     , GIFT_ALLIANCE(false)           /*联盟充值礼包 34*//*38*/
//     //合并自cok邮件代码 end
//     , WORLD_DISCOVETY(false) /*39 世界探索点*/
//     , MISSILE_ATTACK(true, DELETE_EXCEPT_RESERVE, false) /*40 导弹攻击邮件*/
//     , PRESENT_ARMY(true, DELETE_ALL, false) /*41 赠送兵力*/
//     , AL_DONATE_REWARD(true) /*42 联盟捐献排行奖励*/
//     , ALLIACNE_COMPENSATION(true) /*43 联盟伤兵资源援助*/
//     , MV_CROSS_INVITE(true) /*44 跨服迁城邀请邮件*/
//     , TO_ALL(false) /*45 总统发送全服邮件*/
//     , RECEIVE_Gift(true) /*46 收礼物*/
//     , VOTE(true) /*47 投票*/
//     , WORLD_FORTRESS(true, DELETE_EXCEPT_RESERVE) /*48 堡垒战斗总结*/
//     , AC_WHEEL_FIGHT(true, DELETE_EXCEPT_RESERVE) /*49 军团远征战斗邮件*/
//     , LS_PLAYER_CITY(true, DELETE_EXCEPT_RESERVE, true) /*50 LS 城市战包 **/
//     , LS_MONSTER_SIEGE(true, DELETE_EXCEPT_RESERVE, true) /*51 LS 城市丧尸攻城 **/
//     , LS_RESOURCE_FIGHT(true, DELETE_EXCEPT_RESERVE, true) /*52 LS 资源战斗 **/
//     , LS_SPACE_FIGHT(true, DELETE_EXCEPT_RESERVE, true) /*53 LS 空地战斗 **/
//     , LS_FIELD_MONSTER_FIGHT(true, DELETE_EXCEPT_RESERVE, true) /*54 LS 普通打怪 **/
//     , LS_DOMAIN_FIGHT(true, DELETE_EXCEPT_RESERVE, true) /*55 LS 地块战斗 **/
//     , ACTIVITY(true) /*56活动分类邮件*/
//     , LS_USER_WORLD_BUILDING(true, DELETE_EXCEPT_RESERVE, true) /*57 玩家世界建筑 **/
//     , LS_NEW_SCOUT(true, DELETE_EXCEPT_RESERVE, false) /*58 lS 侦查 **/
//     , LS_MONSTER_BOSS(true, DELETE_EXCEPT_RESERVE, true)  /*59 lS s世界boss**/
//     , MAIL_ALLIANCE_RECOMMEND(true)  /*60 建议R3R4成员替换盟主**/
//     , KINGDOM_REWARD(false) /*61 最强战区胜利失败邮件 **/
//     , LS_KINGDOM_SEASON(true, DELETE_EXCEPT_RESERVE) /*62 战区赛季结算邮件 */
//     , MAIL_HEROBATTLE_FB(true, DELETE_EXCEPT_RESERVE)//63 英雄对决 保存邮件
//     , MAIN_CITY_LV_UP(true, DELETE_EXCEPT_RESERVE) /*64 基地升级邮件*/
//     , ARMY_DETAIL(true, DELETE_EXCEPT_RESERVE) /*65 克隆中心克隆兵力详情邮件*/
//     , LS_ACTIVITY(false) /*66 ls邮件活动分栏*/, LS_CITY_EXPLORE(true) /*67 城市探索*/
//     , OFFICE_MAIL(true) /* 68 职业总统邮件*/
//     , LS_DOMAIN_OCCUPY_CITY(false) /* 69 占领中立城市*/
//     , BOMB_ATTACK(true, DEFAULT, true)/* 70 炸弹人*/
//     , ESPIONAGE_ATTACK(true, DEFAULT, true)/* 71 间谍*/
//     , NEW_FIGHT_MAIL(true, DELETE_EXCEPT_RESERVE, true)/*72 新战斗邮件*/
//     ;
//细分各种战斗子类，重新定义了一个枚举，防止影响之前战斗加成
public enum BattleMailType
{
    BATTLE_DEFAULT = 0,         // 0 默认
    BATTLE_PLAYER_CITY,         // 1 城市攻防战
    BATTLE_RESOURCE,            // 2 资源战
    BATTLE_CAMP,                // 3 营地战
    BATTLE_TERRITORY_MAIN,      // 4 联盟中心战
    BATTLE_TERRITORY_TOWER,     // 5 联盟哨塔战
    BATTLE_KING,                // 6 总统战
    BATTLE_BUILDING_NPC,        // 7 建筑NPC
    BATTLE_ATT_CITY_INVADE = 9, // 9 攻城略地
    BATTLE_WHEEL_FIGHT,         // 10 车轮战
    BATTLE_BF_KING              // 11 竞技场总统战
};

public enum UserHeroStateType
{
    /**空闲中*/
    Free,
    /**出征中,各种行军，各种采集，各种探险。一句话，玩家不在城里。*/
    March,
    /** 被俘坐牢中*/
    Prison,
    /**被屠杀*/
    Death,
    /**释放回程中。*/
    GoHome,
    /** 复活中*/
    Revival,
    /** 堡垒监狱*/
    Prison_PickDNA,
    /*驻扎*/
    StationBuilding,
    /*编队*/
    Formation,
}

public enum BattleResult
{
    LOOSE,       // 失败
    WIN,        // 胜利
    DRAW,
    
}

public enum SType
{
    STYPE_NONE,
    STYPE_REINFORCE,
    STYPE_TRADE
}

// battle side
public enum SideType
{
    AttackSide = 1,
    DefenceSide
}

// 兵种UI类型
public enum SoldierType
{
    WARRIOR = 1,    // 勇士
    BATTLECAR,      // 战车
    SHOOTER,        //  射手
    ZOMBIE,         // 僵尸
    SENG,
    LEADER,         // 指挥官
    BOSS = 9        // 地块解锁的boss
}

public enum BattleRoleState
{
    None = 0,
    Idle,   //1
    Attack, //2
    BeAttack,  //3
    Death,  //4
    MoveForward,  //5
    Discard,        // 丢弃 6
    Escape,         // 逃跑 7
    Poison,         // 中毒 8
}

public enum BattleGroupHandleState
{
    NONE = 0,
    TROOP_ATTACK,
    TROOP_STATUS,
    OFFICER_ATTACK,
    OFFICER_PREPARE_STATUS,
    OFFICER_STATUS,
    OFFICER_STATUS_GROUP,
    OFFICER_ATTACK_PREPARE,
    STATUS_TRIGGER,
    AOE,

    IDLE,
    ATTACK,
    BEATTACK,
    DEATH,
    MOVE_FORWARD,           // 向前移动
    DISCARD,                // 丢弃兵器
    POISON,                 // 中毒
    ATTACK_ACTION //状态提示
}

public enum ReportType
{
    ROUND = 1,//回合                                生效中
    MOVE,//移动                                     没毛用
    ATTACK,//攻击                                   没毛用
    STATUS,//状态                                   没毛用
    STATUS_VANISH,//状态消失                         没毛用
    TROOP_ATTACK,//兵种攻击                          生效中
    TROOP_STATUS,//兵种状态                          生效中
    HERO_ATTACK,//军官攻击                           生效中
    HERO_STATUS,//军官状态                           生效中 显示光
    HERO_STATUS_CHANGE,//军官状态组  军官状态改变      有用
    HERO_ATTACK_PREPARE,//军官准备攻击                生效中 放技能
    HERO_STATUS_TRIGGER,//军官状态触发                生效了但没实质作用
    ROLE_START,//变更焦点                            没毛用
    POISON_HURT,//中毒
    ATTACK_ACTION, //状态提示
    STATUS_NUM_UPDATE,//更新状态回合数
}

public enum FightReportAttackType
{
    Miss = 0,//0 闪避
    Normal,//1 命中
    Crit,//2 暴击
    Shield,//3 无敌
    Explode,//4 爆炸
    ExplodeSelf,//5 爆炸自损
    Assist,//6 援护
    Revive,//7 复活
    Sputter,//8 溅射
    Heal,//9 治疗
    Poison,//10 中毒
}

public enum AttackPrepareType
{
    DEFAULT,      // 0 默认
    START,        // 1 开始
    CANCEL,       // 2 取消/打断
    FIRE,         // 3 发射
    NoTarget,     // 4 没有目标
}

public enum BattleOfficerSkillStatusAction
{
    DEFAULT = 0,//0 默认
    PUSH,//1 添加
    POP,//2 移除
    PUSH_FAIL,//3 添加失败
};
public enum BattleOfficerSkillStatusActive
{
    DEFAULT,//0 默认
    ACTIVE,//1 生效
    INVACTIVE,//2 失效
};
public enum BattleOfficerSkillStatusStackChangeType
{
    DEFAULT = 0,//0 默认
    INCREASE,//1 叠加
    DECREASE,//2 衰减
    MAINTAIN,//3 不变
};

public enum BattleOfficerSkillActiveType
{
    DEFAULT = 0,
    Active,//    1:主动
    Command,//    2：指挥
    Append,//    3：追击
    Trigger,//    4：触发被动
    Aura,//    5：光环被动
};

public enum StatusDamageType
{
    DEFAULT,//0 默认
    HOT,//1 加血
    DOT,//2 减血
};

public enum MissilePathType
{
    LEFT = 0,
    MIDDLE,
    RIGHT
};

public enum GOODS_TYPE
{
    GOODS_TYPE_0 = 0,
    GOODS_TYPE_1 = 1,
    GOODS_TYPE_2 = 2,
    GOODS_TYPE_3 = 3,
    GOODS_TYPE_4 = 4,
    GOODS_TYPE_5 = 5,   //宝箱
    GOODS_TYPE_6 = 6,
    GOODS_TYPE_7 = 7,   //装备材料
    GOODS_TYPE_8 = 8,   //随机给1000兵
    GOODS_TYPE_9 = 9,   //装备配件
    GOODS_TYPE_13 = 13, //道具合成
    GOODS_TYPE_15 = 15, // 红包道具
    GOODS_TYPE_16 = 22, //道具合成+最强要塞积分buffer,16 occupy ，manager change it to 22
    GOODS_TYPE_23 = 23, //军队扩充道具
    GOODS_TYPE_35 = 35, //导弹
    GOODS_TYPE_39 = 39, //
    GOODS_TYPE_41 = 41, //
    GOODS_TYPE_45 = 45, //礼品赠送
    GOODS_TYPE_46 = 46, //可以产生多个reward的道具
    GOODS_TYPE_50 = 50, //沙漠积分
    GOODS_TYPE_57 = 57, //能力强化经验道具
    GOODS_TYPE_59 = 59, //可以产生多个reward的道具
    GOODS_TYPE_62 = 62, //勋章
    GOODS_TYPE_63 = 63, // 技能书，用来学习技能用，在道具列表中不显示
    GOODS_TYPE_66 = 66, //治疗沙漠淘金者伤兵的道具

    GOODS_TYPE_70 = 70, //英雄碎片
    GOODS_TYPE_79 = 79, //vip赠送礼物
    GOODS_TYPE_80 = 80, //金币宝箱
};

public enum HeroFrameType
{
    Hero = 0,//英雄碎片
    Common = 1,//通用碎片
};

public enum ItemColor
{
    WHITE,
    GREEN,
    BLUE,
    PURPLE,
    ORANGE,
    GOLDEN,
    RED,
};

//detect_event和物品颜色的对应关系不一样
public enum DetectEventColor
{
    DETECT_EVENT_WHITE = 1,
    DETECT_EVENT_GREEN = 2,
    DETECT_EVENT_BLUE = 3 ,
    DETECT_EVENT_PURPLE = 4,
    DETECT_EVENT_ORANGE = 5,
    DETECT_EVENT_GOLDEN = 6,
}


// 英雄的颜色
public enum HeroColor
{
    WHITE,
    GREEN,
    BLUE,
    PURPLE,
    ORANGE,
    GOLDEN,
    RED,
};

// 世界活动类型
public enum WorldActivityType
{
    FIGHT_OF_KING,//国王争夺
    FIGHT_OF_ARMORY = 7, // 7 争夺军械库活动
    FIGHT_OF_PRISON = 8, // 8 争夺监狱活动
    FIGHT_OF_LABORATORY = 9, // 9 争夺实验室活动
    FIGHT_OF_SUPERMARKET = 10, // 10 争夺超市活动
    FIGHT_OF_GREATKING = 11, // 11 大帝争夺
    FIGHT_OF_DESERT_THRONE = 12, // 12 沙漠王座争夺
};

// 活动状态
public enum WorldActivityState
{
    NotOpen,
    OpenNoKing,     // 开始战争没有国王
    PeaceTime,      // 和平状态
    WarTime,        // 战争状态
    AddTime,        // 加时状态
};

public enum AreaState
{
    None = -1,
    Building,       // 建造中
    BeforeBuild,    // 未出兵建造
    Garrison,       // 已驻防
    UnGarrison,     // 未驻防
    Damaged,        // 破损-未采集
    FixIng,         // 修理中
    Destroy,        // 被摧毁中-采集中
    Relic = 8       // 废墟
}

/// 排行榜类型
public enum RankingType
{
    /// 战斗力排行榜
    CommanderPower = 1,
    /// 杀敌排行榜
    CommanderKill = 2,
    /// 指挥官 基地排行榜
    CommanderBase = 3,
    /// 指挥官 等级排行榜
    CommanderLevel = 4,
    /// 联盟战斗力排行榜
    AlliancePower = 20,
    /// 联盟 杀敌排行榜
    AllianceKill = 21,
    /// 指挥官科技排行榜
    CommanderTech = 29,
    /// 沙漠竞赛 排行榜
    DesertCompetition = 31,
    ///  末日角斗场 排行榜
    DoomsdayCompetition = 32,
    /// 最强要塞排行榜
    ClashOfZones = 30,
    /// 末日争霸奖发励排行榜
    DoomsdayReward = 35,

};

public enum InvitePanelType
{
    INVITE,
    OFFICIAL,
    UN_KINGDOM_OFFICIAL,//大王座 官职
    KINGSGIFT,
    UN_KINGDOM_KINGSGIFT,//大王座 礼包
    ITEM_GIFT,//火漆信送礼
    ITEM_DONATE, //礼包赠送
    ARMORY_GIFT = 21,//军械所
    PRISON_GIFT = 22,//监狱
    LABORATORY_GIFT = 23,//实验室
    SUPER_MARKET_GIFT = 24,//超市
    SEND_SCORE = 25,//分发积分

    SEND_GIFT = 26, //送礼物anning //例如戒指

    ARENA_INVITE = 27,//竞技场邀请

    UN_KINGDOM_Medal,//大王座徽章

    CROSS_OFFICIAL//跨服任命

};
// 服务器类型
public enum ServerType
{
    /**
 * 0:普通服
 */
    NORMAL,
    /**
 * 1:外网测试服
 */
    TEST,
    /**
 * 2:合服活动服务器
 */
    MERGE,
    /**
 * 3:大王座
 */
    KINGDOM,
    /**
 * 4:攻城略地服务器
 */
    SIEGESERVER,
    /**
 * 5:竞技场服务器
 */
    BATTLEFIELD,
    /**
 * 6:精英对决服务器
 */
    ELITE,
    /**
 * 7;地块赛季服
 */
    WORLD_SEASON,
    /**8;极地战役服*/
    DRAGON_BATTLE_FIGHT_SERVER,
    /**9;伊甸园*/
    EDEN_SERVER,
    /**
     * 10;跨服王座
     */
    CROSS_THRONE,
}

//王座状态
public enum KingdomViewType
{
    NormalKindomType,//普通要塞总统
    GreatLaunchCenterKindomType,//大王座要塞总统
    GiveItemType,//anning 送礼item的type 例如戒指
    DomainRewardHistory//末日争霸发奖
}

public enum SkillPopViewShowType
{
    OLDVERSION,//老版本
    SHOWALL,//显示所有
    SHOWOFFICER,//显示军官技能
    SHOWACOMBAT,//显示战斗
    SHOWDEVELOP,//显示发展
    SHOWSUPPORT//显示辅助
}

public enum BuffType
{
    Buff_Type2_Glory = 39,
    Buff_Type2_Week = 503000,
}

// 地图类型
public enum MapType
{
    DEFAULT_MAP,
    NORMAL_MAP,
    SERVERFIGHT_MAP,
    DRAGON_MAP,
};

// 小地图打开类型
public enum MiniMapType
{
    NORMAL_TYPE = 0,
    DRAGON_TYPE,
    ALLIANCE_TYPE, // 用于放置联盟建筑，该情况下需要显示可放置的环
    RALLY_TYPE,  // 用于放置集结点
    HIDE_TYPE, //不显示小地图
}


public enum MSG_BALL
{
    NEWS_BALL_WARNING,
    NEWS_BALL_MAIL,
    NEWS_BALL_FUNCTIONAL,
    NEWS_BALL_ALLIANCESANBUQU,
}

//消息球类型：1.道路未连接，2.建筑小仓库状态，3，交易中心状态，4，打怪消息球，5，丧尸攻城消息球，6，联盟三部曲消息球，7，月卡消息球，8，送第二个英雄消息球, 9,累充提示消息球
public enum MSG_BALL_TYPES
{
    NONE = 0,
    BALL_ROADUNCONNECT = 1,//道路未连接
    BALL_BUILDSTORAGE = 2,//建筑小仓库状态
    BALL_EXCHANGE = 3,//交易中心状态
    BALL_KILLMONSTER = 4,//打怪消息球
    BALL_ZOMBIEATTACT = 5,//丧尸攻城消息球
    BALL_ALLIANCESANBUQU = 6,//联盟三部曲消息球
    BALL_MONTHCARD = 7,//月卡消息球
    BALL_SECONDHERO = 8,//送第二个英雄消息球
    BALL_CAREER = 9, // 玩家职业
    BALL_TREAT = 10, //治疗伤兵
    BALL_UPARMY = 11, // 兵种升级
    BALL_BATTLEMAIL = 12,//战斗邮件
    BALL_MONSTERATTACKACTIVITY = 13,//丧尸攻城活动
    BALL_DESERT_TALENT_POWER = 14, //消息球-可以分配新的专精点数
    BALL_DESERT_CAN_BEGIN_PRODUCT = 15, //消息球-可以开始新的生产
    BALL_DESERT_PRODUCT_DONE = 16, //消息球-生产队列完成
    BALL_DESERT_LACK_DURABLE = 17, //消息球-建筑耐久不满
    BALL_DESERT_NOT_IN_ALLIANCE_AREA = 18, //消息球-建筑不在联盟领地
    BALL_DESERT_CAN_COLLECT_SOLDIER = 19, //消息球 - 可以收集士兵
    BALL_DESERT_FIRST_IN_HOSPITAL = 20, //消息球 - 第一次进医院
    BALL_DESERT_ATTACK_TILE = 21, //消息球 - 攻打地块
    BALL_DESERT_SOLDIER_TO_SECURE = 22, //消息球 - 在沙漠中有兵可以治疗
    BALL_DESERT_ACTIVITY_TO_GET = 23, //消息球 - 活动中有奖励可以领取
    BALL_COUNTRY_ACTIVITY = 24, //消息球 -- 最强要塞消息球
    BALL_PRODUCT_SOLDIER = 25, //消息球 -- 造兵消息球
    BALL_BIND_ACCOUNT = 26, //消息球 -- 绑定账号消息球
    BALL_RUINS = 27, //消息球 -- 废墟建筑
    BALL_WB_NO_POINT = 28, //消息球 -- 荣誉建筑被攻击飞起
    BALL_HERO_CARD = 29,    //消息球 -- 军官碎片
    BALL_DRUG = 30,    //消息球 -- 末日研究所
    BALL_ELITE = 31,    //消息球 -- 堡垒精英/英雄对决
    BALL_ADDUP_RECHARGE = 32, //消息球 -- 累计充值
    BALL_ZONE_CLEAR = 33, //消息球 -- 区域扫荡
    BALL_ALLIANCE_RACE = 34,//消息球 -- 联盟军备
    BALL_FBTILE_DECLARE = 35,//消息球 -- 地块宣战
    BALL_FBTILE_ASSEMBLY_SERVERLIST = 36,//消息球 -- 地块集结点消息球
    BALL_TREAT_WOUNDED = 37, //消息球 -- 伤兵容量
    BALL_NEW_TREAT_WOUNDED = 38,
    BALL_ZONE_PRE_SELECT = 39, //消息球 -- 最强战区预选预告
    BALL_OPEN_WB_SEASON = 40, //消息球 -- 末日争霸活动开启
    BALL_HERO_LOTTERY = 41, //消息球 -- 英雄招募
    BALL_ALLIANCE_CHANGE = 42, //消息球 -- 联盟归属
    BALL_SCIENCE = 43, //消息球 -- 科技研究空闲
}


public enum OfficerRecruitType
{
    RECRUIT_TYPE_COMMON = 1,//普通招募<常驻显示>普通招募每天
    RECRUIT_TYPE_SENIOT = 2,//高级招募<常驻显示>
    RECRUIT_TYPE_ACTIVITY = 3,//活动招募<受时间控制>
    RECRUIT_TYPE_FREE = 4,//免费招募
    RECRUIT_TYPE_SPECIAL = 5,//根据道具显示
    RECRUIT_TYPE_HERO_ACTIVITY = 6,//限时招募 ，不显示在界面中
    RECRUIT_TYPE_HERO_OPTIONAL_ALL = 7,//自选招募,将库里的英雄全部都能招募
    RECRUIT_TYPE_HERO_OPTIONAL_OWN = 8,//自选招募，只能招募自己已经有的英雄
}

public enum FreeQueueType
{
    FreeQueueType_Default = 0,
    FreeQueueType_Science = 1,
    FreeQueueType_Building = 2,
    FreeQueueType_Scavenge = 3,
    FreeQueueType_Transport = 4,
    FreeQueueType_WORLD_BUILDING = 5, // 建造世界建筑
    FreeQueueType_Missile = 6, // 导弹
    FreeQueueType_ForgeEquip = 7, //打造装备
}

// 世界建筑状态
public enum WorldBuildState
{
    Normal,
    NeedRepair,
    Uping,
    UpingFrozen,
}

enum PeopleChangeStage
{
	UP_BELOW_HISTORY_MAX,
	UP_ABOVE_HISTORY_MAX,
	MAX_STORAGE,
	DOWN_BELOW_HISTORY_MAX,
	MIN,
}





public enum AllianceFunBtnType
{
    A_NAME_MODIFY = 0,
    A_FLAG_MODIFY = 1,
    A_ALLIANCE_SEARCH = 2,
    A_ALLIANCE_VIEW = 3,
    A_ALLIANCE_PAI_HANG = 4,
    A_ALLIANCE_COMMENT = 5,
    A_ALLIANCE_BLOCK = 6,
    A_ALLIANCE_COMBINE = 7,
    A_QUIT = 8,
    A_DISMISS = 9,
};

public enum AllianceManageBtnType
{
    A_INVITE_TELEPORT = 0,//邀请迁城
    A_TRAN_LEADER = 1,//盟主转让
    A_REPLACE_LEADER = 2,//取代盟主
    A_PROMOTE_MEMBERS = 3,//提升等级
    A_DEMOTE_MEMBERS = 4,//降低等级
    A_KICK_MEMBERS = 5,//踢出联盟
};

public enum RankType
{
    CHANGE_RANK_TITLE,//0 更换阶级名称
    CHANGE_BANNER,//1 修改联盟旗帜
    CHANGE_BRIEF_NAME,//2 修改联盟简称
    CHANGE_NAME,//3 修改联盟名称
    DISBAND_ALLIANCE,//4 弃用
    TRANSFER_LEADERSHIP,//5弃用
    KICK_MEMBERS,//6 踢人
    CHANGE_SLOGAN,//7 修改联盟宣言
    OPEN_RECRUITMENT,//8 修改公开招募
    SEND_ALLIANCE_INVITE,//9 发送联盟邀请
    EDIT_ALLIANCE_NOTICE,//10
    SHOW_ALLIANCE_LANGUAGE,//11 修改联盟语言
    SHOW_ALLIANCE_SHOP,//12弃用
    RESEARCH_ALLIANCE_SCIENCE,//13 弃用
    OPEN_ALLIANCE_ACTIVITY,//14 世界联盟活动
    ALLIANCE_COMMENT,//15屏蔽联盟留言
    DEMOTE_MEMBERS,//16 rank down
    PROMOTE_MEMBERS,//17 rank up
    QUIT,//18
    CHECK_RANK_DETAIL,//19弃用
    ALLIANCE_HELP,//20弃用
    RESOURCE_TRADE,//21弃用
    CHECK_ALLIANCE_MEMBER,//22弃用
    MAIL_ALL,//23弃用
};

public enum eBattleRoleType
{
	TROOP_TYPE = 2,
	TOWER_TYPE = 3,
	TRAP_TYPE = 4,
	LEADER_TYPE = 6,        
	HERO_TYPE = 7            //英雄
}

public enum BattleStatusType
{
    Suppressed, //被压制
    Silent,     //被沉默
    CanNotAttack,  //不可攻击
    BeCursed ,//被诅咒
    BeFired  = 5,//火攻
}

public enum UIMainBottomBuildType
{
    None = 0,
    Build,//建设类
    People,//民生类
    Electricity,//电能
    Nuclear,//核能
    Water,//水源
    Oil,//油
    Food,//食物
    Metal,//矿
    Military,//军事
    Defence,//防御
    Oxygen,//氧气
}

//大本罩子尺寸
public enum DomeSize
{
    Small = 1,
    Middle = 2,
    Large = 3,
}

public enum　WarningType 
{
    Meteorite = 1,//陨石来临
    Attack = 2 ,//攻击
    Scout = 3,//侦查
    Assistance = 4 ,//援助
}

[Flags]
// 下 上 右 左
public enum ShapeFlag
{
    NX = 0x01,
    PX = 0x02,
    PZ = 0x04,
    NZ = 0x08,
}

public enum GameEffect{
    //燃油每秒产量
    OIL_SPEED = 30000,
    //金属每秒产量
    METAL_SPEED = 30001,
    //核燃料每秒产量
    NUCLEAR_SPEED = 30002,
    //粮食每秒产量
    FOOD_SPEED = 30003,
    //水每秒产量
    WATER_SPEED = 30004,
    //氧气每秒产量
    OXYGEN_SPEED = 30005,
    //自然电每秒产量
    ELECTRICITY_SPEED = 30006,
    //油电每秒产量
    OIL_ELECTRICITY_SPEED = 30008,
    //核电每秒产量
    NUCLEAR_ELECTRICITY_SPEED = 30010,
    //人口上限增加
    PEOPLE_MAX = 30007,
    //医疗上限增加
    HOS_MAX = 30009,
    //贸易度上限增加(值)
    TRAD_MAX = 30011,
    //研发值增加(值)
    RD_ADD = 30013,
    //研发值增加(值)
    OPERA_ADD = 30014,
    //维护度上限(值)
    MAINTAIN_MAX_ADD = 30016,
    //建造值增加(值)
    BUILD_ADD = 30017,
    //环境值指数、每分钟对环境值进行加减值
    ENVIR_SPEED = 30020,
    //人口每分钟增长值(数值)
    PEOPLE_SPEED = 30021,
    //人口增长加成(千分比)1000=1
    PEOPLE_SPEED_PER = 30022,
    //资金每秒增长(值)
    MONEY_SPEED = 30023,
    //资金增长加成(千分比)
    MONEY_SPEED_PER = 30024,
    //燃油上限
    OIL_MAX_LIMIT = 30030,
    //金属上限
    METAL_MAX_LIMIT = 30031,
    //核燃料上限
    NUCLEAR_MAX_LIMIT = 30032,
    //粮食上限
    FOOD_MAX_LIMIT = 30033,
    //水上限
    WATER_MAX_LIMIT = 30034,
    //氧气上限
    OXYGEN_MAX_LIMIT = 30035,
    //电上限
    ELECTRICITY_MAX_LIMIT = 30036,
    //电消耗
    ELECTRICITY_DEC = 30037,
    //核燃料消耗
    NUCLEAR_DEC = 30038,
    //燃油消耗
    OIL_DEC = 30039,
    //受伤人口恢复速度（分钟）
    PEOPLE_REC_SPEED = 30040,
    //冷库存储上线
    FREEZER_STORAGE_MAX_LIMIT = 30044,
    //综合仓库存储上线
    WAREHOUSE_STORAGE_MAX_LIMIT = 30045,
    //冷库保护上线  已经去掉
    //FREEZER_PROTECT_MAX_LIMIT = 30046,
    // 地球订单额外加成提升百分比
    EARTH_ORDER_EXTRA_MONEY_ADD_PERCENT = 30046,
    // 地球订单额外加成值百分比
    EARTH_ORDER_EXTRA_MONEY_ADD_VALUE = 30093,
    //综合仓库保护上线
    WAREHOUSE_PROTECT_MAX_LIMIT = 30047,
    
    WATER_CAPACITY_ADD = 30064,//30064	抽水站储量提升	储量=建筑para2*(1+【30064】/100)
    METAL_CAPACITY_ADD = 30065,//30065	水晶采集场储量提升	储量=建筑para2*(1+【30065】/100)
    GAS_CAPACITY_ADD = 30066,//30066	瓦斯收集器储量提升	储量=建筑para2*(1+【30066】/100)
    BUILD_SPEED_ADD = 30070,//30070	建造建筑速度	建筑建造时间=building.xml time/(1+【30070】/ 100)
    SCIENCE_SPEED_ADD = 30071,// 30071	科研速度	科研时间=science.xml time/(1+【30071】/ 100)
    WIND_ELECTRICITY_SPEED_ADD = 30072,// 风力发电站速度提升	速度=建筑para1*(1+【30072】/100)
    WIND_ELECTRICITY_CAPACITY_ADD = 30073,// 风力发电站储量提升	储量=建筑para2*(1+【30073】/100)
    HOTEL_MONEY_SPEED_ADD = 30074,// 公寓钞票产出速度提升	速度=建筑para1*(1+【30074】/100)
    HOUSE_MONEY_SPEED_ADD = 30075,// 别墅钞票产出速度提升	速度=建筑para1*(1+【30075】/100)
    METAL_SPEED_ADD = 30076,//水晶采集场速度提升	  速度=建筑para1*(1+【30076】/100)	
    SOLAR_ELECTRICITY_SPEED_ADD = 30077,//太阳能发电站速度提升	速度=建筑para1*(1+【30077】/100)
    RESOURCE_PROTECT_CAPACITY_ADD = 30078,//资源仓库保护上限提升	保护上限=基础值*(1+【30078】/100)
    BUILD_ROAD_NUM_ADD = 30079,//建造道路的数量提升		数量=基础值+【30079】
    FREEZER_STORAGE_ADD = 30080,//冷库上限提升	容量=【30044】+【30080】
    MONEY_SPEED_ADD = 30081,//钞票产出速度提升
    SOLAR_ELECTRICITY_CAPACITY_ADD = 30082,//太阳能发电站储量提升	储量=建筑para2*(1+【30082】/100)
    FIRE_ELECTRICITY_CAPACITY_ADD = 30083,//火力发电站储量提升	储量=建筑para2*(1+【30083】/100)
    FIRE_ELECTRICITY_SPEED_ADD = 30084,//火力发电站速度提升	速度=建筑para1*(1+【30084】/100)
    HOTEL_MONEY_CAPACITY_ADD = 30085,//公寓钞票储量提升	储量=建筑para2*(1+【30085】/100)
    HOUSE_MONEY_CAPACITY_ADD = 30086,//别墅钞票储量提升	储量=建筑para2*(1+【30086】/100)
    MONEY_CAPACITY_ADD = 30087,//钞票储量提升		公寓储量=建筑para2*(1+【30086】/100+【30084】/100)  别墅储量=建筑para2*(1+【30086】/100+【30085】/100)	
    GAS_BUILD_COLLECT_SPEED_ADD = 30091,//瓦斯收集器速度提升		百分比	速度=建筑para1*(1+【30091	】/100)	
    WATER_BUILD_COLLECT_SPEED_ADD = 30092,//抽水站速度提升		百分比	速度=建筑para1*(1+【30092	】/100)
    UNLOCK_WATER_GET= 30088,//解锁部队采集水
    UNLOCK_GAS_GET= 30089,//解锁部队采集瓦斯
    UNLOCK_METAL_GET= 30090,//解锁部队采集水晶
    
    ADD_FIELD_NUM = 30094, // 702000可建造农田数量加成
    ADD_CAN_BUILD_NUM = 30095, // 可建造建筑范围
    ADD_WATER_BUILD_NUM = 30096, // 432000可建造净水罐数量加成
    ADD_HOTEL_NUM = 30097, // 409000可建造公寓数量加成
    ADD_METAL_COLLECT_NUM = 30098, // 412000可建造水晶采集场数量加成
    TANK_TRAIN_SPEED_ADD = 31000,//31000	坦克训练速度提升	训练士兵时间=arms.xml time/（1+【31000】/100）
    ROBOT_TRAIN_SPEED_ADD = 31001,//31001	轻武器训练速度提升	训练士兵时间=arms.xml time/（1+【31001】/100）
    PLANE_TRAIN_SPEED_ADD = 31002,//31002	飞机训练速度提升	训练士兵时间=arms.xml time/（1+【31002】/100）
    TANK_TRAIN_NUM_ADD = 31003,//31003	坦克训练量提升	训练量=arms.xml max_train +【31003】
    ROBOT_TRAIN_NUM_ADD = 31004,//31004	轻武器训练量提升	训练量=arms.xml max_train +【31004】
    PLANE_TRAIN_NUM_ADD = 31005,//31005	飞机训练量提升	训练量=arms.xml max_train +【31005】
    DETECT_ARMY_SPEED = 31006,//侦察行军速度 行军速度=基础值*(1+【31006】/100)
    REPAIR_SPEED_ADD = 31007,//维修速度提升		维修速度=arms.xml treat_time/（1+【31007】/100）
    ARMY_TRAIN_SPEED_ADD = 31008,//部队训练速度提升	训练士兵时间=arms.xml time/（1+【31008】/100）
    ARMY_TRAIN_MAX_ADD = 31009,//部队训练上限提升	坦克训练量=arms.xml max_train +【31003】 +【31009】 轻武器训练量=arms.xml max_train +【31004】 +【31009】 飞机训练量=arms.xml max_train +【31005】 +【31009】）
    ATTACK_ADD_BASE_ALL_ARMY = 35000,//全体兵种基础攻击加成
    ATTACK_ADD_BASE_ARM_1= 35001,//兵种1基础攻击加成
    ATTACK_ADD_BASE_ARM_2= 35002,//兵种2基础攻击加成
    ATTACK_ADD_BASE_ARM_3= 35003,//兵种3基础攻击加成
    ATTACK_ADD_BUILD_ALL_ARMY = 35048,//驻守建筑前台兵种总攻击加成
    ATTACK_ADD_BUILD_ARM_1 = 35049,//驻守建筑前台兵种1攻击加成
    ATTACK_ADD_BUILD_ARM_2 = 35050,//驻守建筑前台兵种2攻击加成
    ATTACK_ADD_BUILD_ARM_3 = 35051,//驻守建筑前台兵种3攻击加成
    
    DEFENCE_ADD_BASE_ALL_ARMY = 35004,//全体兵种基础防守加成
    DEFENCE_ADD_BASE_ARM_1 = 35005,//兵种1基础防守加成
    DEFENCE_ADD_BASE_ARM_2= 35006,//兵种2基础防守加成
    DEFENCE_ADD_BASE_ARM_3= 35007,//兵种3基础防守加成
    DEFENCE_ADD_BUILD_ALL_ARMY = 35052,//驻守建筑前台兵种总防守加成
    DEFENCE_ADD_BUILD_ARM_1 = 35053,//驻守建筑前台兵种1防守加成
    DEFENCE_ADD_BUILD_ARM_2 = 35054,//驻守建筑前台兵种2防守加成
    DEFENCE_ADD_BUILD_ARM_3 = 35055,//驻守建筑前台兵种3防守加成
    ATTACK_MONSTER = 35056,//打怪攻击力
    DEFENCE_MONSTER = 35057,//打怪防御力
    GAS_COLLECT_SPEED = 30058,//瓦斯采集速度
    WATER_COLLECT_SPEED = 30059,//水源采集速度
    CRYSTAL_COLLECT_SPEED = 30060,//水晶采集速度
    WAR_ATTACK = 35064,//战斗伤害加成
    WAR_DEFENCE = 35065,//战斗防御加成
    
    APS_FORMATION_SIZE = 40001,
    APS_FORMATION_SIZE_ENHANCE = 40002,
    
    APS_DEFENCE_FORMATION_SIZE = 40003,//守城编队数量
    APS_DEFENCE_FORMATION_FIRST_HERO_COUNT = 40004,//守城第一编队可上阵英雄数量
    APS_DEFENCE_FORMATION_SECOND_HERO_COUNT = 40005,//守城第二编队可上阵英雄数量
    APS_DEFENCE_FORMATION_THIRD_HERO_COUNT = 40006,//守城第三编队可上阵英雄数量
    APS_DEFENCE_DOME_NUM = 40007,//防护罩耐久
    APS_DEFENCE_DOME_SPEED = 40008,//防护罩耐久回复速度
    ARMY_CARRY_WEIGHT_ADD_PERCENT = 40010, // 负重上线百分比
    SIEGE_DAMAGE_ADD_PERCENT = 40011, // 单兵攻城值增加百分比
    APS_ALLIANCE_TEAM_MAX_ARMY = 40014,// 最大集结上限
    

    APS_FORMATION_FIRST_HERO_COUNT = 40016,//第一编队可上阵英雄数量
    APS_FORMATION_SECOND_HERO_COUNT = 40017,//第二编队可上阵英雄数量
    APS_FORMATION_THIRD_HERO_COUNT = 40018,//第三编队可上阵英雄数量
    APS_FORMATION_FORTH_HERO_COUNT = 40019,//第四编队可上阵英雄数量
    ARMY_SPEED_ADD = 40020,//部队行军速度提升	行军速度=基础值*(1+【40020】/100)
    APS_SCOUT_FORMATION_SIZE = 40022,//侦查队列最大数量
    APS_NORMAL_FORMATION_1_ATK =40036, // 普通编队1攻击力提升
    APS_NORMAL_FORMATION_2_ATK = 40037, // 普通编队2攻击力提升
    APS_NORMAL_FORMATION_3_ATK = 40038, // 普通编队3攻击力提升
    APS_NORMAL_FORMATION_4_ATK = 40039, // 普通编队4攻击力提升
    APS_NORMAL_FORMATION_1_DEF = 40040, // 普通编队1防御力提升
    APS_NORMAL_FORMATION_2_DEF = 40041, // 普通编队2防御力提升
    APS_NORMAL_FORMATION_3_DEF = 40042, // 普通编队3防御力提升
    APS_NORMAL_FORMATION_4_DEF = 40043, // 普通编队4防御力提升
    APS_NORMAL_FORMATION_1_FORMATION_COUNT = 40044, // 普通编队1编队出征数量增加
    APS_NORMAL_FORMATION_2_FORMATION_COUNT = 40045, // 普通编队2编队出征数量增加
    APS_NORMAL_FORMATION_3_FORMATION_COUNT = 40046, // 普通编队3编队出征数量增加
    APS_NORMAL_FORMATION_4_FORMATION_COUNT = 40047, // 普通编队4编队出征数量增加
}

//放置建筑界面打开类型
public enum PlaceBuildType
{
    None = 0,
    Build = 1,
    Move = 2,
    Replace = 3,
    MoveCity = 4,
}
//点击世界类型
public enum ClickWorldType
{
    Ground = 0,
    Collider = 1,
}

public enum PutState
{
    None,
    Ok,//可以放置
    Collect,//矿根
    CollectRange,//矿根周边
    OtherCollectRange,//其他矿根周边
    NoCollectRange,//没有矿根周边
    OutMyRange,//超出自己限制范围
    InOtherBaseRange,//在他人大本范围内
    StaticPoint,//静态点
    Building,//建筑
    OutUnlockRange,//不在已经锁范围内,解锁范围:({0},{1}) - ({2},{3})
    WorldBoss,//世界Boss
    WorldMonster,//世界野怪
    CollectTimeOver,//矿跟正在销毁中
    OutMyInside,//不在苍穹内
    InMyInside,//不在苍穹外
    OutMainSubRange,//超出主建筑范围
    OnWorldResource,//世界资源点
    ReachBuildMax,//达到建造最大值
    OnExplore,//小队探索点
    OnSample,//小队采样点
    MONSTER_REWARD
}

public enum BuildingConnectState
{
    UnConnect = 0, //没有联通
    Connect,//联通
}

public enum BuildingStateType
{
    /*普通*/
    Normal = 0,

    /*升级中*/
    Upgrading,

    /*收起*/
    FoldUp,
}

public enum BuildType
{
    Normal = 0, //一般建筑
    Main = 1,//主建筑
    Second = 2,//辅建筑
    Third = 3,//次建筑
}

public enum BuildTilesType
{
    One = 1,//1格
    Two = 2,//2格
    Three = 3,//3格
}

//建筑扫描动画
public enum BuildScanAnim
{

    No = 0,//没有飞行时间，不播放建筑扫描动画
    Play = 1,//有飞行时间，播放建筑扫描动画
    NoFly = 2,//没有飞行时间，播放建筑扫描动画
}

//运兵车预制体的类型
public enum MarchPrefabType
{
    Self = 1,//自己（绿色）
    Alliance = 2,//盟友（蓝色）
    Camp = 3,//同阵营（黄色）
    Other = 4,//敌人（红色）
}
