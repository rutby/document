using System;
using System.Collections.Generic;
using GameFramework;
using Google.Protobuf;
using Protobuf;

public enum WorldPointType
{
    Other = 0,                     // 空地
    WorldCollectResource = 1, // 世界矿根（玩家资源站建筑用）
    WorldMonster = 4,              // 世界怪物
    WorldBoss = 5,                 // 世界Boss
    PlayerBuilding = 6,            // 玩家建筑
    WorldResource = 7,             // 世界资源
    EXPLORE_POINT = 8,             //小队探测点
    SAMPLE_POINT = 9,              //采样点
    GARBAGE = 10,                  //垃圾点
    WORLD_ALLIANCE_CITY =11,      //联盟城市
    MONSTER_REWARD  =12,         //野怪箱子
    SAMPLE_POINT_NEW = 13, //新采样点
    DETECT_EVENT_PVE = 14,      //雷达pve
    WORLD_ALLIANCE_BUILD = 15,//联盟建筑(矿）
    NPC_CITY = 16, // 16 npc城市
    WorldRuinPoint = 17,//17废墟
    DRAGON_BUILDING=18, // 18 巨龙中立建筑
    SECRET_KEY =19,      //19 密钥
    CROSS_THRONE_BUILD = 20,//20 跨服王座
    //客户端专用
    MarchSkinSelf = 1000,//运兵车皮肤（自己）
    MarchSkin_EFFECT_PK = 1001,//运兵车皮肤炮口特效（自己）
    MarchSkin_EFFECT_PD = 1002,//运兵车皮肤炮弹特效（自己）
    MarchSkin_EFFECT_HIT = 1003,//运兵车皮肤被攻击特效（自己）
    MarchSkin_ATTACK_HEIGHT = 1004,//运兵车皮肤飞行轨迹高度（自己）
    MarchSkinAlliance = 1005,//运兵车皮肤（盟友）
    MarchSkinCamp = 1006,//运兵车皮肤（同盟）
    MarchSkinOther = 1007,//运兵车皮肤（敌人）
}

//方向
public enum DirectionType
{
    Top = 1,
    Right = 2,
    Left = 3,
    Down = 4,
}

//建筑状态（位表示法）
public enum QueueState
{
    DEFAULT = 0,//正常状态
    TRAINING = 1,//训练/晋级士兵状态
    CURE_ARMY = 2,//治疗伤兵
    RESEARCH = 3,//研究科技
    FACTORY= 6,//食品加工厂加工
    STORAGE_SHOP = 7,//交易行
    UPGRADE = 16,//建造/升级
    Ruins = 128,//废墟状态
}

public class PointInfo
{
    public PointInfo()
    {
    }

    public PointInfo(WorldPointInfo pi)
    {
        uuid = pi.Uuid;
        pointIndex = pi.Id;
        mainIndex = pi.Id;
        pointType = (WorldPointType)pi.PointType;
        tileSize = 1;
        serverId = pi.ServerId;
        srcServerId = pi.SrcServerId;
        worldId = pi.WorldId;
        var temInfo = pi.ExtraInfo;
        if (temInfo != null)
        {
            extraInfo = temInfo.ToByteArray();
        }
    }

    public virtual PointInfo Clone()
    {
        var bi = new PointInfo();
        BaseClone(bi);
        return bi;
    }

    protected void BaseClone(PointInfo p)
    {
        p.pointIndex = pointIndex;
        p.mainIndex = mainIndex;
        p.pointType = pointType;
        p.ownerUid = ownerUid;
        p.tileSize = tileSize;
        p.uuid = uuid;
        p.extraInfo = extraInfo;
        p.serverId = serverId;
        p.srcServerId = srcServerId;
        p.worldId = worldId;
    }

    public int pointIndex;
    public int mainIndex;
    public WorldPointType pointType;
    public string ownerUid;
    public int tileSize;
    public long uuid;
    public byte[] extraInfo;
    public int serverId;
    public int srcServerId;
    public int worldId;
    public bool IsMine() //是自己的
    {
        return ownerUid == GameEntry.Data.Player.Uid; 
    } 
    
    public bool isMainPoint
    {
        get { return mainIndex == pointIndex; }
    }

    //lua调用
    public int PointType
    {
        get { return (int)pointType; }
    }
    
    public virtual PlayerType GetPlayerType()
    {
        return PlayerType.PlayerNone;
    }
    
}

// 建筑点信息
public class BuildPointInfo : PointInfo
{
    public long uuid;
    public int itemId;
    public int level;
    public int state; //建筑状态
    public string allianceId; //联盟id
    public int startTime; //开始升级时间
    public int endTime; //结束升级时间
    public int inside; //是否城内
    public int curHp;
    public int lastHpTime;//开始恢复时间
    public int protectEndTime;//罩子结束时间
    public string playerName;//玩家名称
    public string alAbbr;//联盟简称
    public long lastCollectTime;//资源建筑开始采集时间
    public long unavailableTime;//资源建筑停止采集时间
    public int queueItemId;//queue对应的资源道具id
    public long queueStartTime;// 队列开始时间
    public long queueUpdateTime;// 队列结束时间
    public long destroyStartTime;//废墟开始时间
    public long fireEndTime;//着火结束时间
    public int skinId;//皮肤
    public string positionId;//官职
    public List<BuildingBreak> buildBreaks;//突破数据
    public int titleNameSkinId;//称号
    public BuildPointInfo()
    {
    }

    public BuildPointInfo(WorldPointInfo pi) : base(pi)
    {
        var buildInfo = pi.BuildInfo;
        uuid = buildInfo.Uuid;
        itemId = buildInfo.BuildId;
        level = buildInfo.Level;
        state = buildInfo.QueueState;
        allianceId = buildInfo.AllianceId;
        startTime = buildInfo.UpdateStartTime;
        endTime = buildInfo.UpdateEndTime;
        inside = buildInfo.Inside;
        ownerUid = buildInfo.OwnerUid;
        curHp = buildInfo.CurrentHp;
        lastHpTime = buildInfo.LastHpTime;
        protectEndTime = buildInfo.ProtectEndTime;
        playerName = buildInfo.Name;
        alAbbr = buildInfo.AlAbbr;
        lastCollectTime = (long)buildInfo.LastCollectTime * 1000;
        unavailableTime = (long)buildInfo.UnavailableTime * 1000;
        queueItemId = buildInfo.QueueItemId;
        queueStartTime = (long)buildInfo.QueueStartTime * 1000;
        queueUpdateTime = (long)buildInfo.QueueUpdateTime * 1000;
        destroyStartTime = (long)buildInfo.DestroyStartTime * 1000;
        fireEndTime = (long)buildInfo.FireEndTime * 1000;
        tileSize = SceneManager.World.GetBuildTileByItemId(itemId);
        if (itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
        {
            var curTime = GameEntry.Timer.GetServerTime();
            var temp = buildInfo.Skins;
            foreach (var VARIABLE in temp)
            {
                if (VARIABLE.Type == (int)SkinType.BASE_SKIN && VARIABLE.SkinET > curTime)
                {
                    skinId = VARIABLE.SkinId;
                }
                else if (VARIABLE.Type == (int)SkinType.TITLE_NAME && VARIABLE.SkinET > curTime)
                {
                    titleNameSkinId = VARIABLE.SkinId;
                }
            }
        }

        positionId = buildInfo.PositionId;
        buildBreaks = new List<BuildingBreak>();
        var breaks = buildInfo.Breaks;
        if (breaks != null)
        {
            foreach (var per in breaks)
            {
                buildBreaks.Add(per);
            }
        }
    }

    public override PointInfo Clone()
    {
        var bi = new BuildPointInfo();
        BaseClone(bi);
        bi.uuid = uuid;
        bi.itemId = itemId;
        bi.level = level;
        bi.state = state;
        bi.allianceId = allianceId;
        bi.startTime = startTime;
        bi.endTime = endTime;
        bi.inside = inside;
        bi.ownerUid = ownerUid;
        bi.curHp = curHp;
        bi.lastHpTime = lastHpTime;
        bi.protectEndTime = protectEndTime;
        bi.alAbbr = alAbbr;
        bi.playerName = playerName;
        bi.lastCollectTime = lastCollectTime;
        bi.unavailableTime = unavailableTime;
        bi.queueItemId = queueItemId;
        bi.queueStartTime = queueStartTime;
        bi.queueUpdateTime = queueUpdateTime;
        bi.destroyStartTime = destroyStartTime;
        bi.fireEndTime = fireEndTime;
        bi.skinId = skinId;
        bi.positionId = positionId;
        bi.buildBreaks = buildBreaks;
        bi.titleNameSkinId = titleNameSkinId;
        return bi;
    }

    // 获得建筑显示状态
    public QueueState GetShowState()
    {
        return GetQueueStateFromMixValue(state, 0);
    }
    
    // 获得建筑第n个显示状态
    public QueueState GetShowStateByIndex(int index)
    {
        return GetQueueStateFromMixValue(state, index);
    }

    // 建筑是否处于该状态
    public bool IsThisState(QueueState needState)
    {
        if (needState == QueueState.DEFAULT)
        {
            return state == (int) QueueState.DEFAULT;
        }

        return ((state << (GameDefines.Int32Bit - 1 - (int) needState)) & Int32.MinValue) == Int32.MinValue;
    }

    //从左到右获取第stateLevel个位是1的状态
    private QueueState GetQueueStateFromMixValue(int queueMixState, int stateLevel)
    {
        int ignoreTime = 0;
        int index = GameDefines.Int32Bit;
        for (int i = 0; i < GameDefines.Int32Bit; ++i)
        {
            if (((queueMixState << i) & Int32.MinValue) == Int32.MinValue)
            {
                if (ignoreTime < stateLevel)
                {
                    ++ignoreTime;
                }
                else
                {
                    index = GameDefines.Int32Bit - 1 - i;
                    break;
                }
            }
        }

        if (index < GameDefines.Int32Bit)
        {
            return (QueueState) index;
        }

        return QueueState.DEFAULT;
    }

    public override PlayerType GetPlayerType()
    {
        string uid = GameEntry.Data.Player.GetUid();
        if (uid == ownerUid)
        {
            return PlayerType.PlayerSelf;
        }

        string myAllianceId = GameEntry.Data.Player.GetAllianceId();
        if (string.IsNullOrEmpty(myAllianceId))
        {
            return PlayerType.PlayerOther;
        }

        if (myAllianceId == allianceId)
        {
            string leaderUid = GameEntry.Lua.CallWithReturn<string>("CSharpCallLuaInterface.GetAllianceLeaderUid");
            if (ownerUid != leaderUid)
            {
                return PlayerType.PlayerAlliance;
            }
            else
            {
                return PlayerType.PlayerAllianceLeader;
            }
        }

        return PlayerType.PlayerOther;
    }

    public float GetResourcePercent()
    {
        return GameEntry.Lua.CallWithReturn<float, int, int,long,long>("CSharpCallLuaInterface.GetResourcePercent", itemId, level,unavailableTime,lastCollectTime);
    }
}

// 资源点
public class ResPointInfo : PointInfo
{
    public int id; //所属矿跟pointId
    //public int lifeEndTime;//资源过期时间
    // public int capacity; //初始容量
    // public int resCount; //剩余容量
    public int state; //状态 0空闲 1 采集中
    public long gatherMarchUuid;//采集编队uuid
    //public int level;
    public ResPointInfo()
    {
    }
    
    public ResPointInfo(WorldPointInfo pi) : base(pi)
    {
        var resPointInfo = pi.ResourceInfo;
        id = resPointInfo.ResourceId;
        //lifeEndTime = pi.PointIntParam2;
        // resCount = pi.PointIntParam4;
        // capacity = pi.PointIntParam3;
        state = resPointInfo.State;
        gatherMarchUuid = resPointInfo.GatherUuid;
        // var tpl = GameEntry.DataTable.GetGatherResourceTemplate(id);
        // if (tpl != null)
        // {
        //     tileSize = tpl.size;
        //     level = tpl.level;
        // }
    }
    
    public override PointInfo Clone()
    {
        var info = new ResPointInfo();
        BaseClone(info);
        info.id = id;
        info.state = state;
        // info.capacity = capacity;
        // info.resCount = resCount;
        //info.lifeEndTime = lifeEndTime;
        //info.level = level;
        info.gatherMarchUuid = gatherMarchUuid;
        return info;
    }
}
//联盟建筑
public class AllianceBuildPointInfo : PointInfo
{
    public AllianceBuildPointInfo()
    {
    }
    
    public AllianceBuildPointInfo(WorldPointInfo pi) : base(pi)
    {
    }
    public override PlayerType GetPlayerType()
    {
        string myAllianceId = GameEntry.Data.Player.GetAllianceId();
        if (string.IsNullOrEmpty(myAllianceId))
        {
            return PlayerType.PlayerOther;
        }
        var detail = AllianceBuildingPointInfo.Parser.ParseFrom(extraInfo);
        if (detail != null)
        {
            if (detail.AllianceId == myAllianceId)
            {
                return PlayerType.PlayerAlliance;
            }
        }
        return PlayerType.PlayerOther;
    }
}
// 野怪

// Boss怪


public enum ExplorePointInfoState
{
    ExplorePointInfoStateNULL = 0,
    ExplorePointInfoStateNormal = 1,
    ExplorePointInfoStateAttack = 2,
}

//小队探索点
public class ExplorePointInfo : PointInfo
{
    public string ownerUid; //所属玩家
    public long uuid;//探索点的唯一id
    public string eventId;//对应事件的配置id

    public ExplorePointInfo()
    {
    }
    
    public ExplorePointInfo(WorldPointInfo pi) : base(pi)
    {
        var explorePointInfo = pi.ExplorePointInfo;
        ownerUid = explorePointInfo.OwnerUid;
        uuid = explorePointInfo.Uuid;
        eventId = explorePointInfo.EventId;
    }
    
    public override PointInfo Clone()
    {
        var info = new ExplorePointInfo();
        BaseClone(info);
        info.ownerUid = ownerUid;
        info.uuid = uuid;
        info.eventId = eventId;
        return info;
    }
}

//采样点
public class SamplePointInfo : PointInfo
{
    public string ownerUid; //所属玩家
    public long uuid;//探索点的唯一id
    public string eventId;//对应事件的配置id

    public SamplePointInfo()
    {
    }
    
    public SamplePointInfo(WorldPointInfo pi) : base(pi)
    {
        var samplePointInfo = pi.SamplePointInfo;
        ownerUid = samplePointInfo.OwnerUid;
        uuid = samplePointInfo.Uuid;
        eventId = samplePointInfo.EventId;
    }
    
    public override PointInfo Clone()
    {
        var info = new ExplorePointInfo();
        BaseClone(info);
        info.ownerUid = ownerUid;
        info.uuid = uuid;
        info.eventId = eventId;
        return info;
    }
}

public class GarbagePointInfo : PointInfo
{
    public string ownerUid; //所属玩家
    public long uuid;//
    public string eventId;//对应事件的配置id
    public long endTime;//结束时间
    public GarbagePointInfo()
    {
    }
    
    public GarbagePointInfo(WorldPointInfo pi) : base(pi)
    {
        var garbagePointInfo = pi.GarbagePointInfo;
        ownerUid = garbagePointInfo.OwnerUid;
        uuid = garbagePointInfo.Uuid;
        eventId = garbagePointInfo.EventId;
        endTime = garbagePointInfo.EndTime;
    }
    
    public override PointInfo Clone()
    {
        var info = new GarbagePointInfo();
        BaseClone(info);
        info.ownerUid = ownerUid;
        info.uuid = uuid;
        info.eventId = eventId;
        info.endTime = endTime;
        return info;
    }
}


public class WorldTileInfo
{
    public WorldTileInfo()
    {
    }
    public int pointIndex;
    public int serverId;
    private PointInfo pointInfo;
    private WorldDesertInfo desertInfo;
    private int pointType = (int)WorldPointType.Other;
    public void AddPointInfo(PointInfo p)
    {
        if (p != null)
        {
            pointInfo = p;
            pointIndex = pointInfo.pointIndex;
            serverId = pointInfo.serverId;
            pointType = pointInfo.PointType;
        }
    }
    public void AddDesertInfo(WorldDesertInfo d)
    {
        if (d != null)
        {
            desertInfo = d;
            pointIndex = desertInfo.pointIndex;
            serverId = desertInfo.serverId;
        }
        
    }

    public PointInfo GetPointInfo()
    {
        return pointInfo;
    }
    public WorldDesertInfo GetWorldDesertInfo()
    {
        return desertInfo;
    }

    public void RemovePointInfo()
    {
        pointInfo = null;
        pointType = (int)WorldPointType.Other;
    }
    public void RemoveDesertInfo()
    {
        desertInfo = null;
    }

    public bool GetIsDataEmpty()
    {
        return (pointInfo == null && desertInfo == null);
    }

    public int GetPointType()
    {
        return pointType;
    }
}

public class RuinPointInfo : PointInfo
{
    public int endTime;
    public RuinPointInfo()
    {
    }
    
    public RuinPointInfo(WorldPointInfo pi) : base(pi)
    {
        var detail = WorldRuinPointInfo.Parser.ParseFrom(extraInfo);
        tileSize = detail.Size;
        endTime = detail.EndTime;
    }
}

public class DragonPointInfo : PointInfo
{
    // public int buildId;
    // public int state;
    // public string alAbbr;
    // public string allianceId;
    // public long occupyTime;
    // public long openTime;
    // public long startTime;
    public DragonPointInfo()
    {
    }
    
    public DragonPointInfo(WorldPointInfo pi) : base(pi)
    {
        // var detail = DragonBuildingPointInfo.Parser.ParseFrom(extraInfo);
        // buildId = detail.BuildId;
        // state = detail.State;
        // alAbbr = detail.AlAbbr;
        // allianceId = detail.AllianceId;
        // occupyTime = detail.OccupyTime;
        // openTime = detail.OpenTime;
        // startTime = detail.StartTime;
    }
    // public override PointInfo Clone()
    // {
    //     var info = new DragonPointInfo();
    //     BaseClone(info);
    //     buildId = info.buildId;
    //     state = info.state;
    //     alAbbr = info.alAbbr;
    //     allianceId = info.allianceId;
    //     occupyTime = info.occupyTime;
    //     openTime = info.openTime;
    //     startTime = info.startTime;
    //     return info;
    // }
    public override PlayerType GetPlayerType()
    {
        string myAllianceId = GameEntry.Data.Player.GetAllianceId();
        if (string.IsNullOrEmpty(myAllianceId))
        {
            return PlayerType.PlayerOther;
        }
        var detail = DragonBuildingPointInfo.Parser.ParseFrom(extraInfo);
        if (detail != null && detail.AllianceId.IsNullOrEmpty() ==false)
        {
            if (detail.AllianceId == myAllianceId)
            {
                return PlayerType.PlayerAlliance;
            }
            else
            {
                return PlayerType.PlayerOther;
            }
        }
        return PlayerType.PlayerNone;
    }
}

public class CrossThronePointInfo : PointInfo
{
    // public int buildId;
    // public int state;
    // public string alAbbr;
    // public string allianceId;
    // public long occupyTime;
    // public long openTime;
    // public long startTime;
    public CrossThronePointInfo()
    {
    }
    
    public CrossThronePointInfo(WorldPointInfo pi) : base(pi)
    {
        // var detail = DragonBuildingPointInfo.Parser.ParseFrom(extraInfo);
        // buildId = detail.BuildId;
        // state = detail.State;
        // alAbbr = detail.AlAbbr;
        // allianceId = detail.AllianceId;
        // occupyTime = detail.OccupyTime;
        // openTime = detail.OpenTime;
        // startTime = detail.StartTime;
    }
    // public override PointInfo Clone()
    // {
    //     var info = new DragonPointInfo();
    //     BaseClone(info);
    //     buildId = info.buildId;
    //     state = info.state;
    //     alAbbr = info.alAbbr;
    //     allianceId = info.allianceId;
    //     occupyTime = info.occupyTime;
    //     openTime = info.openTime;
    //     startTime = info.startTime;
    //     return info;
    // }
    public override PlayerType GetPlayerType()
    {
        string myAllianceId = GameEntry.Data.Player.GetAllianceId();
        if (string.IsNullOrEmpty(myAllianceId))
        {
            return PlayerType.PlayerOther;
        }
        var detail = CrossThroneBuildPointInfo.Parser.ParseFrom(extraInfo);
        if (detail != null && detail.AllianceId.IsNullOrEmpty() ==false)
        {
            if (detail.AllianceId == myAllianceId)
            {
                return PlayerType.PlayerAlliance;
            }
            else
            {
                return PlayerType.PlayerOther;
            }
        }
        return PlayerType.PlayerNone;
    }
}
