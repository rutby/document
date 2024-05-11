using System;
using System.Collections.Generic;
using GameFramework;
using Sfs2X.Entities.Data;
using UnityEngine;
using XLua;
using Protobuf;
//
// 世界格子数据管理
//
#if false
public class WorldPointManager : WorldManagerBase
{
    private static readonly int INF = 100000;
    public static readonly float ShowMapIconDist = 78;
    private static readonly int MaxBuildCountOneFrame = 10;
    private static readonly int MaxDelCountOneFrame = 50;
    private static readonly Vector2Int[] ViewLevelRange =
    {
        new Vector2Int(25, 40) , 
        new Vector2Int(70, 140), 
        new Vector2Int(INF, INF),
        new Vector2Int(INF, INF),
    };
    public static readonly Vector2Int[] LodRequestRange =
    {
        new Vector2Int(6, 6),
        new Vector2Int(18, 18),
        new Vector2Int(INF, INF),
        new Vector2Int(INF, INF),
    };

    public static double time { get; private set; }

    /// <summary>
    ///     判断当前更新器是否处于超时状态，如果超时表示当前帧已经满负荷了，余下的操作应该放到下一帧处理。
    /// </summary>
    public static bool busy => DateTime.Now.TimeOfDay.TotalMilliseconds - time >= 15;
    
    private Vector2Int reqPos;
    private Vector2Int lastDelPos;
    private int LOD = 1;
    private int svLod;
    private int lastDelSvLod;
    private Dictionary<int, WorldTileInfo> allViewPoints = new Dictionary<int, WorldTileInfo>();
    private Dictionary<long, WorldTileInfo> uuidInfoMap = new Dictionary<long, WorldTileInfo>();//通过uuid寻找世界点(与地块无关)
    private Dictionary<long, WorldTileInfo> uuidInfoDesertMap = new Dictionary<long, WorldTileInfo>();//uuid和地块的映射关系
    private Dictionary<int, WorldTileInfo> outOfViewPoints = new Dictionary<int, WorldTileInfo>();
    private List<int> keysToRemove = new List<int>();
    private List<WorldTileInfo> timeOutGarbagePoints = new List<WorldTileInfo>();

    private WorldUpdate pointUpdate = new WorldUpdate();

    private bool startViewRequest = false;
    private bool isRecvViewPoints = false;
    private List<int> toBuildList = new List<int>();

    private Dictionary<int, WorldPointObject> allObjs = new Dictionary<int, WorldPointObject>();

    private Dictionary<int, bool> needDestoryBuild = new Dictionary<int, bool>();
    private Dictionary<int, int> BuildTileSizeDic = new Dictionary<int, int>();
    private Dictionary<string, BuildPointInfo> selfAllianceMemberDic = new Dictionary<string, BuildPointInfo>();
    private Dictionary<long, PointInfo> dragonPointDic = new Dictionary<long, PointInfo>();
    private int alliancePointLod = 5;
    private int SelfPointLod = 8;
    private int OtherPointLod = 4;
    public WorldPointManager(WorldScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        pointUpdate.Init();
        InitBuildTileDictionary();
        LOD = world.GetLodLevel();
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);
        // BuildTileLuaSFSObj = SFSObject.NewFromBinaryData(new Sfs2X.Util.ByteArray(bytes));
    }

    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
        allViewPoints.Clear();
        uuidInfoMap.Clear();
        uuidInfoDesertMap.Clear();
        outOfViewPoints.Clear();
        toBuildList.Clear();
        foreach (var obj in allObjs.Values)
        {
            obj.Destroy();
        }
        pointUpdate.UnInit();
    }

    public void RemoveAllObject()
    {
        allViewPoints.Clear();
        uuidInfoMap.Clear();
        uuidInfoDesertMap.Clear();
        outOfViewPoints.Clear();
        toBuildList.Clear();
        foreach (var obj in allObjs.Values)
        {
            obj.Destroy();
        }
        allObjs.Clear();
        pointUpdate.Clear();
    }

    private void InitBuildTileDictionary()
    {
        BuildTileSizeDic.Clear();
        var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllBuildTileByItemId");
        if (table != null)
        {
            for (int i = 1; i <= table.Length; ++i)
            {
                var data = (LuaTable)table[i];
                if (data.ContainsKey("itemId") && data.ContainsKey("tiles"))
                {
                    var itemId = data.Get<int>("itemId");
                    var tile = data.Get<int>("tiles");
                    if (itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                    {
                        tile = GameEntry.Lua.CallWithReturn<int, string, string>("CSharpCallLuaInterface.GetConfigNum", "worldmap_city", "k12");
                    }
                    
                    BuildTileSizeDic[itemId] = tile;
                }
            }
        }
    }

    public PointInfo GetPointInfo(int pointIndex)
    {
        var pi = GetWorldTileInfo(pointIndex);
        if (pi!=null)
        {
            var p = pi.GetPointInfo();
            return p;
        }
        return null;
    }

    public WorldTileInfo GetWorldTileInfo(int pointIndex)
    {
        WorldTileInfo pi;
        if (allViewPoints.TryGetValue(pointIndex, out pi))
            return pi;
        return null;
    }

    public int GetBuildTileByItemId(int itemId)
    {
        var tile = -1;
        if (BuildTileSizeDic.ContainsKey(itemId))
        {
            tile = BuildTileSizeDic[itemId];
        }
        return tile;
    }
    
    public PointInfo GetPointInfoByUuid(long uuid)
    {
        WorldTileInfo info;
        if (uuidInfoMap.TryGetValue(uuid, out info))
        {
            var p = info.GetPointInfo();
            if (p != null)
            {
                return p;
            }
        }
            
        return null;
    }

    public WorldDesertInfo GetDesertInfoByUuid(long uuid)
    {
        WorldTileInfo info;
        if (uuidInfoDesertMap.TryGetValue(uuid, out info))
        {
            var p = info.GetWorldDesertInfo();
            if (p != null)
            {
                return p;
            }
        }
            
        return null;
    }

    public bool HasPointInfo(int pointIndex)
    {
        var info = GetWorldTileInfo(pointIndex);
        if (info!=null)
        {
            var p = info.GetPointInfo();
            if (p != null)
            {
                return true;
            }
        }
            
        return false;
    }

    public bool IsSelfPoint(int pointIndex)
    {
        var pi = GetPointInfo(pointIndex);
        return pi != null && pi.ownerUid == GameEntry.Data.Player.Uid;
    }
    
    public int GetDesertPoint(int lv,int type)
    {
        foreach (var per in uuidInfoDesertMap.Values)
        {
            var pi = per.GetWorldDesertInfo();
            var desertType = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Desert,pi.desertId,"desert_type").ToInt();
            var desertLv = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Desert,pi.desertId,"desert_level").ToInt();
            if (lv == desertLv && type == desertType && pi.GetPlayerType() == PlayerType.PlayerNone)
            {
                return pi.pointIndex;
            }
        }

        return 0;
    }
    public Dictionary<long,WorldTileInfo> GetDesertPointList()
    {
        return uuidInfoDesertMap;
    }
    
    
    public ResPointInfo GetResourcePointInfoByIndex(int pointIndex)
    {
        var temp = GetPointInfo(pointIndex);
        if (temp != null && temp.pointType == WorldPointType.WorldResource )
        {
            return temp as ResPointInfo;
        }
        return null;
    }

    public ExplorePointInfo GetExplorePointInfoByIndex(int pointIndex)
    {
        var temp = GetPointInfo(pointIndex);
        if (temp != null && (temp.pointType == WorldPointType.EXPLORE_POINT || temp.pointType == WorldPointType.DETECT_EVENT_PVE) )
        {
            return temp as ExplorePointInfo;
        }
        return null;
    }
    
    public SamplePointInfo GetSamplePointInfoByIndex(int pointIndex)
    {
        var temp = GetPointInfo(pointIndex);
        if (temp != null && (temp.pointType == WorldPointType.SAMPLE_POINT || temp.pointType == WorldPointType.SAMPLE_POINT_NEW ))
        {
            return temp as SamplePointInfo;
        }
        return null;
    }

    public GarbagePointInfo GetGarbagePointInfoByIndex(int pointIndex)
    {
        var temp = GetPointInfo(pointIndex);
        if (temp != null && temp.pointType == WorldPointType.GARBAGE )
        {
            return temp as GarbagePointInfo;
        }
        return null;
    }
    
    public override void OnUpdate(float deltaTime)
    {
        time = DateTime.Now.TimeOfDay.TotalMilliseconds;
        int lod = world.GetLodLevel(); // 客户端LOD
        svLod = GetServerLod(lod); // 服务器LOD
        UpdateViewRequest();
        // var t1 = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        DeleteTimeOutGarbage(svLod);
        // var t2 = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        BuildAsync(ViewLevelRange[svLod]);
        // var t3 = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        ObjectsOnUpdate(deltaTime);
        // var t4 = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        pointUpdate.Update();
        // var t5 = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        DeleteOutOfView(ViewLevelRange[svLod]);
        
        if (busy)
        {
            Log.Debug("[world point] process long  use {0}", DateTime.Now.TimeOfDay.TotalMilliseconds - time);
        }
    }

    private void DeleteTimeOutGarbage(int serverLod)
    {
        if (serverLod > 0)
        {
            return;
        }
        var now = GameEntry.Timer.GetServerTime();
        foreach (var pt in allViewPoints.Values)
        {
            var p = pt.GetPointInfo();
            if (p != null)
            {
                var garbageInfo = p as GarbagePointInfo;
                if (garbageInfo != null)
                {
                    if (garbageInfo.endTime < now)
                    {
                        timeOutGarbagePoints.Add(pt);
                    }
                }
            }
            
        }

        if (timeOutGarbagePoints.Count > 0)
        {
            foreach (var pt in timeOutGarbagePoints)
            {
                var p = pt.GetPointInfo();
                if (p!=null && p.isMainPoint)
                {
                    DestroyObject(pt.pointIndex);
                    RemovePointInfo(pt.pointIndex,false);
                }
            }

            timeOutGarbagePoints.Clear();
        }
    }
    
   // 处理返回的视野数据
    public void HandleViewPointsReply(ISFSObject message)
    {
        if (message.ContainsKey("errorCode"))
        {
            Log.Error("HandleViewRep {0}", message.GetUtfString("errorCode"));
            return;
        }

        pointUpdate.ProcessPointsMessage(message, 
            points =>
            {
                isRecvViewPoints = true;
                var localPlayerUid = GameEntry.Data.Player.Uid;
                var tempDragonDic = new Dictionary<long,PointInfo>();
                foreach (var VARIABLE in dragonPointDic)
                {
                    tempDragonDic.Add(VARIABLE.Key,VARIABLE.Value);
                }
                dragonPointDic.Clear();
                bool isRefresh = false;
                foreach (var p in points)
                {
                    if (p is SamplePointInfo && (p as SamplePointInfo).ownerUid != localPlayerUid
                        || p is ExplorePointInfo && (p as ExplorePointInfo).ownerUid != localPlayerUid
                        || p is GarbagePointInfo && (p as GarbagePointInfo).ownerUid != localPlayerUid)
                    {
                        //Log.Debug("ProcessPointsMessage skip sample & explore: " + p.pointIndex);
                        continue;
                    }

                    if (p.serverId>0 && (p.serverId != GameEntry.Data.Player.GetCurServerId() ||
                                         p.worldId != GameEntry.Data.Player.GetWorldId()))
                    {
                        continue;
                    }
                    if (p.pointType == WorldPointType.MONSTER_REWARD)
                    {
                        var bytes = p.extraInfo;
                        var pointInfo = CollectRewardInfo.Parser.ParseFrom(bytes);
                        if (pointInfo.OwnerUid != localPlayerUid)
                        {
                            continue;
                        }
                    }

                    // TODO
                    // 根据LOD删除超范围的点
                    // 优先创建视口内的点
                    AddPointInfo(p);

                    if (p.isMainPoint)
                    {
                        AddToBuildList(p.pointIndex);
                        if (p.pointType == WorldPointType.DRAGON_BUILDING || p.pointType == WorldPointType.SECRET_KEY)
                        {
                            if (dragonPointDic.ContainsKey(p.uuid))
                            {
                                dragonPointDic[p.uuid] = p;
                            }
                            else
                            {
                                dragonPointDic.Add(p.uuid,p);
                            }

                            if (p.pointType == WorldPointType.DRAGON_BUILDING)
                            {
                                if (tempDragonDic.ContainsKey(p.uuid))
                                {
                                    var info = p as DragonPointInfo;
                                    var temp = tempDragonDic[p.uuid];
                                    var tInfo = temp as DragonPointInfo;
                                    if (info != null && tInfo != null && info.GetPlayerType() == tInfo.GetPlayerType())
                                    {
                                    }
                                    else
                                    {
                                        isRefresh = true;
                                    }
                                }
                                else
                                {
                                    isRefresh = true;
                                }
                            }
                            else if(p.pointType == WorldPointType.SECRET_KEY)
                            {
                                if (!tempDragonDic.ContainsKey(p.uuid))
                                {
                                    isRefresh = true;
                                }
                            }
                            
                        }
                    }
                }

                if (isRefresh && GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
                {
                    GameEntry.Event.Fire(EventId.DragonMapDataRefresh);
                }

                GameEntry.Event.Fire(EventId.UPDATE_POINTS_DATA);
            },
            landPoints => { },
            desertInfos =>
            {
                
                foreach (var p in desertInfos)
                {
                    if ((p.serverId > 0 && p.serverId != GameEntry.Data.Player.GetCurServerId()) || GameEntry.Data.Player.GetWorldId() > 0 )
                    {
                        continue;
                    }
                    AddDesertInfo(p);
                    AddToBuildList(p.pointIndex);
                }
            },alInfos =>
            {
                var tempAllianceMemberDic = new Dictionary<string,BuildPointInfo>();
                foreach (var VARIABLE in selfAllianceMemberDic)
                {
                    tempAllianceMemberDic.Add(VARIABLE.Key,VARIABLE.Value);
                }
                selfAllianceMemberDic.Clear();
                bool isRefresh = false;
                foreach (var p in alInfos)
                {
                    if (p.serverId>0 && (p.serverId != GameEntry.Data.Player.GetCurServerId() ||
                                         p.worldId != GameEntry.Data.Player.GetWorldId()))
                    {
                        continue;
                    }
                    var build = p as BuildPointInfo;
                    if (build != null)
                    {
                        var pType = build.GetPlayerType();
                        if (pType == PlayerType.PlayerSelf || pType == PlayerType.PlayerAlliance ||
                            pType == PlayerType.PlayerAllianceLeader)
                        {
                            var ownerUid = build.ownerUid;
                            if (selfAllianceMemberDic.ContainsKey(ownerUid))
                            {
                                selfAllianceMemberDic[ownerUid] = build;
                            }
                            else
                            {
                                selfAllianceMemberDic.Add(ownerUid,build);
                            }
                            if (isRefresh == false)
                            {
                                if (!tempAllianceMemberDic.ContainsKey(ownerUid))
                                {
                                    isRefresh = true;
                                }
                                else
                                {
                                    var tempBuild = tempAllianceMemberDic[ownerUid];
                                    if (pType != tempBuild.GetPlayerType())
                                    {
                                        isRefresh = true;
                                    }else if(tempBuild.mainIndex!=build.mainIndex)
                                    {
                                        isRefresh = true;
                                    }
                                }
                            }
                        }
                    }
                }
                if (selfAllianceMemberDic.Count != tempAllianceMemberDic.Count)
                {
                    isRefresh = true;
                }
                if (isRefresh == true && svLod > 0)
                {
                    GameEntry.Event.Fire(EventId.MiniMapDataRefresh);
                }
            });
    }

    // 视野数据变化
    public void HandleViewUpdateNotify(ISFSObject message)
    {
        string type = message.GetUtfString("type");
        if (type == "create" || type == "change" || type == "relocate")
        {
            pointUpdate.ProcessCreatePointMessage(message, points =>
            {
                if (points != null)
                {
                    var localPlayerUid = GameEntry.Data.Player.Uid;
                    var isRefresh = false;
                    foreach (var p in points)
                    {
                        if (p is SamplePointInfo && (p as SamplePointInfo).ownerUid != localPlayerUid
                            || p is ExplorePointInfo && (p as ExplorePointInfo).ownerUid != localPlayerUid
                            || p is GarbagePointInfo && (p as GarbagePointInfo).ownerUid != localPlayerUid)
                        {
                            //Log.Debug("ProcessCreatePointMessage skip sample & explore: " + p.pointIndex);
                            continue;
                        }

                        if (p.serverId>0 && (p.serverId != GameEntry.Data.Player.GetCurServerId() ||
                                             p.worldId != GameEntry.Data.Player.GetWorldId()))
                        {
                            continue;
                        }
                        if (p.pointType == WorldPointType.MONSTER_REWARD)
                        {
                            var bytes = p.extraInfo;
                            var pointInfo = CollectRewardInfo.Parser.ParseFrom(bytes);
                            if (pointInfo.OwnerUid != localPlayerUid)
                            {
                                continue;
                            } 
                        }
                        if (allViewPoints.ContainsKey(p.pointIndex))
                        {
                            if (p.isMainPoint)
                            {
                                var info = allViewPoints[p.pointIndex];
                                var pInfo = info.GetPointInfo();
                                if ((pInfo!=null && p.pointType == WorldPointType.PlayerBuilding && IsNeedChangeBuildObj(pInfo as BuildPointInfo,
                                    p as BuildPointInfo)==false ) 
                                    ||(pInfo!=null && p.pointType == WorldPointType.WORLD_ALLIANCE_CITY && IsNeedChangeAllianceCity(pInfo,
                                        p)==false )
                                    ||(pInfo!=null && p.pointType == WorldPointType.WORLD_ALLIANCE_BUILD && IsNeedChangeAllianceBuild(pInfo,
                                        p)==false )
                                    ||(pInfo!=null && p.pointType == WorldPointType.DRAGON_BUILDING && IsNeedChangeDragonBuild(pInfo,
                                        p)==false )
                                    ||(pInfo!=null && p.pointType == WorldPointType.CROSS_THRONE_BUILD && IsNeedChangeThroneBuild(pInfo,
                                        p)==false ))
                                {
                                    AddPointInfo(p);
                                    UpdateObject(p.pointIndex);
                                }
                                else
                                {
                                    AddPointInfo(p);
                                    RemoveFromBuildList(p.pointIndex);
                                    DestroyObject(p.pointIndex);
                                    AddToBuildList(p.pointIndex);                                    
                                }
                            }
                            else
                            {
                                AddPointInfo(p);
                            }
                        }
                        else
                        {
                            AddPointInfo(p);
                            if (p.isMainPoint)
                            {
                                AddToBuildList(p.pointIndex);
                            }
                        }

                        if (p.isMainPoint && (p.pointType == WorldPointType.SECRET_KEY ||
                                              p.pointType == WorldPointType.DRAGON_BUILDING))
                        {
                            if (dragonPointDic.ContainsKey(p.uuid))
                            {
                                dragonPointDic[p.uuid] = p;
                            }
                            else
                            {
                                dragonPointDic.Add(p.uuid,p);
                            }
                            isRefresh = true;
                        }
                      
                    }
                    if (isRefresh && GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
                    {
                        GameEntry.Event.Fire(EventId.DragonMapDataRefresh);
                    }
                }
                GameEntry.Event.Fire(EventId.UPDATE_POINTS_DATA);
            });
        }
        else if (type == "remove")
        {
            pointUpdate.ProcessRemovePointMessage(message, points =>
            {

                if (points != null)
                {
                    var isRefresh = false;
                    foreach (var i in points)
                    {
                        RemoveFromBuildList(i);
                        var temp = GetObjectByPoint(i);
                        if ((temp as WorldDetectEventItemObject) != null && (temp as WorldDetectEventItemObject).DoDisappear())
                        {
                            
                        }
                        else
                        {
                            DestroyObject(i);
                        }

                        var pointInfo = GetPointInfo(i);
                        if (pointInfo != null && (pointInfo.pointType == WorldPointType.DRAGON_BUILDING ||
                                                  pointInfo.pointType == WorldPointType.SECRET_KEY))
                        {
                            if (dragonPointDic.ContainsKey(pointInfo.uuid))
                            {
                                dragonPointDic.Remove(pointInfo.uuid);
                                isRefresh = true;
                            }
                        }
                        RemovePointInfo(i,false);
                    }
                    if (isRefresh && GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
                    {
                        GameEntry.Event.Fire(EventId.DragonMapDataRefresh);
                    }
                }
                GameEntry.Event.Fire(EventId.UPDATE_POINTS_DATA);
            });
        }
        else if (type == "foldUp")
        {
            pointUpdate.ProcessRemovePointMessage(message, points =>
            {

                if (points != null)
                {
                    foreach (var i in points)
                    {
                        RemoveFromBuildList(i);
                        FoldUpBuildObject(i);
                        RemovePointInfo(i,false);
                    }
                }
                GameEntry.Event.Fire(EventId.UPDATE_POINTS_DATA);
            });
        }
    }


    public void HandleViewTileUpdateNotify(ISFSObject message)
    {
        string type = message.GetUtfString("type");
        if (type == "update")
        {
            pointUpdate.ProcessUpdateTileMessage(message, desertInfos =>
            {
                foreach (var p in desertInfos)
                {
                    AddDesertInfo(p);
                    AddToBuildList(p.pointIndex);
                }
            });
        }
    }
    
    
    //显示该坐标点物体
    public void UpdateObject(int point)
    {
        var temp = GetObjectByPoint(point);
        if (temp != null)
        {
            temp.UpdateGameObject();
        }
    }

    // 相机位置或Zoom变化时，请求视野数据
    public void UpdateViewRequest(bool isForce = false)
    {
        int lod = world.GetLodLevel(); // 客户端LOD
        int svLod = GetServerLod(lod); // 服务器LOD
        
        Vector2Int curTilePos = world.CurTilePos;

        if (isForce)
        {
            SendViewRequest(curTilePos, svLod, GameEntry.Data.Player.GetSelfServerId());
            return;
        }

        if (!startViewRequest)
        {
            return;
        }

        bool req = false;
        if (svLod < 3)
        {
            Vector2Int deltaPos = reqPos - curTilePos;
            Vector2 range = LodRequestRange[svLod];
            req = Math.Abs(deltaPos.x) > range.x || Math.Abs(deltaPos.y) > range.y;
        }
        
        if (req)
        {
            SendViewRequest(curTilePos, svLod, GameEntry.Data.Player.GetSelfServerId());
        }
    }

    private void OnLodChanged(object userdata)
    {
        var lod = (int) userdata;
        LOD = lod;
        if (!startViewRequest)
        {
            return;
        }
        
        int svLod = GetServerLod(lod);
        Vector2Int curTilePos = world.CurTilePos;
        SendViewRequest(curTilePos, svLod, GameEntry.Data.Player.GetSelfServerId());
    }

    public int GetServerLod(int lod)
    {
        // if (lod >= 7)
        //     return 3;
        if (lod >= 6)
            return 2;
        else if (lod >= 3)
            return 1;
        else
            return 0;
    }

    public void StartViewRequest()
    {
        startViewRequest = true;
    }

    // 请求视野内的点数据
    public void SendViewRequest(Vector2Int tilePos, int viewLevel, int serverId)
    {
        if (viewLevel > 2)
        {
            viewLevel = 2;
        }
        tilePos = world.ClampTilePos(tilePos);
        var realReqServerId = serverId;
        var isInSelfServer = GameEntry.Data.Player.IsInSelfServer();
        if (!isInSelfServer)
        {
            realReqServerId = GameEntry.Data.Player.GetCrossServerId();
        }

        var worldId = GameEntry.Data.Player.GetWorldId();
        if (GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER || GameEntry.GlobalData.serverType == (int)ServerType.CROSS_THRONE )
        {
            viewLevel = 0;
         }
        // GetViewLevelWorldInfoMessage.Instance.Send(new GetViewLevelWorldInfoMessage.Request()
        // {
        //     x = tilePos.x,
        //     y = tilePos.y,
        //     type = 0,
        //     viewLvl = viewLevel,
        //     serverId = realReqServerId,
        //     worldId = worldId,
        // });
        if (!isInSelfServer)
        {
            WorldCrossServerMessage.Instance.SendReqest(new WorldCrossServerMessage.RequestParam()
            {
                x = tilePos.x,
                y = tilePos.y,
                type = 0,
                forceServerId = realReqServerId,
                worldId = GameEntry.Data.Player.GetWorldId()
            });
        }
        reqPos = tilePos;
    }

    private void AddToBuildList(int pointIndex)
    {
        toBuildList.Add(pointIndex);
        outOfViewPoints.Remove(pointIndex);
    }

    private void RemoveFromBuildList(int pointIndex)
    {
        toBuildList.Remove(pointIndex);
    }

  private void AddPointInfo(PointInfo pi)
  {
      PointInfo oldInfo = null;
        if (allViewPoints.ContainsKey(pi.pointIndex))
        {
            var info  = allViewPoints[pi.pointIndex];
            if (info != null)
            {
                oldInfo = info.GetPointInfo();
            }
            allViewPoints[pi.pointIndex].AddPointInfo(pi);
        }
        else
        {
            var info = new WorldTileInfo();
            info.AddPointInfo(pi);
            allViewPoints.Add(info.pointIndex,info);
        }
        
        var tilePos = world.IndexToTilePos(pi.pointIndex);
        int sz = pi.tileSize;
        //矿跟传中心点 
        if (pi.pointType == WorldPointType.WorldCollectResource)
        {
            int offset = GetCircleRange(sz);
            tilePos.x += offset;
            tilePos.y += offset;
        }
        else if (pi.pointType == WorldPointType.WORLD_ALLIANCE_CITY || pi.pointType == WorldPointType.WORLD_ALLIANCE_BUILD || pi.pointType == WorldPointType.NPC_CITY || pi.pointType == WorldPointType.DRAGON_BUILDING || pi.pointType == WorldPointType.CROSS_THRONE_BUILD)
        {
            sz = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pi.pointIndex);
        }
        
        // 添加周边点
        if (sz > 1)
        {
            for (int x = 0; x < sz; x++)
            {
                for (int y = 0; y < sz; y++)
                {
                    var pos = tilePos - new Vector2Int(x, y);
                    if (!SceneManager.World.IsInMap(pos))
                    {
                        continue;
                    }

                    int tempIndex = world.TilePosToIndex(pos);
                    if (tempIndex == pi.mainIndex)
                    {
                        continue;
                    }
                    
                    var rangePoint = pi.Clone();
                    rangePoint.pointIndex = tempIndex;
                    rangePoint.mainIndex = pi.mainIndex;
                    if (allViewPoints.ContainsKey(tempIndex))
                    {
                        allViewPoints[tempIndex].AddPointInfo(rangePoint);
                    }
                    else
                    {
                        var info = new WorldTileInfo();
                        info.AddPointInfo(rangePoint);
                        allViewPoints.Add(info.pointIndex,info);
                    }
                    
                }
            }
        }
        
        world.AddOccupyPoints(tilePos, new Vector2Int(sz, sz));

        // 添加玩家建筑分类信息，可通过uuid快速索引
        if (pi.pointType == WorldPointType.PlayerBuilding)
        {
            var bi = pi as BuildPointInfo;
            if (bi != null && bi.uuid!=0)
            {
                if (uuidInfoMap.ContainsKey(bi.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[bi.uuid] = info;
                }
                uuidInfoMap[bi.uuid].AddPointInfo(bi);
            }
        }
        else if (pi.pointType == WorldPointType.SAMPLE_POINT || pi.pointType == WorldPointType.SAMPLE_POINT_NEW)
        {
            var mo = pi as SamplePointInfo;
            if (mo != null && mo.uuid != 0)
            {
                if (uuidInfoMap.ContainsKey(mo.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[mo.uuid] = info;
                }
                uuidInfoMap[mo.uuid].AddPointInfo(mo);
            }
            
        }
        else if (pi.pointType == WorldPointType.EXPLORE_POINT || pi.pointType == WorldPointType.DETECT_EVENT_PVE)
        {
            var mo = pi as ExplorePointInfo;
            if (mo != null && mo.uuid != 0)
            {
                if (uuidInfoMap.ContainsKey(mo.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[mo.uuid] = info;
                }
                uuidInfoMap[mo.uuid].AddPointInfo(mo);
            }
        }
        else if (pi.pointType == WorldPointType.GARBAGE)
        {
            var mo = pi as GarbagePointInfo;
            if (mo != null && mo.uuid != 0)
            {
                if (uuidInfoMap.ContainsKey(mo.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[mo.uuid] = info;
                }
                uuidInfoMap[mo.uuid].AddPointInfo(mo);
            }
        }
        else if (pi.pointType == WorldPointType.WORLD_ALLIANCE_CITY || pi.pointType == WorldPointType.WORLD_ALLIANCE_BUILD)
        { 
            if (pi.uuid != 0)
            {
                if (uuidInfoMap.ContainsKey(pi.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[pi.uuid] = info;
                }
                uuidInfoMap[pi.uuid].AddPointInfo(pi);
            }
        }
        else
        {
            if (pi.uuid != 0)
            {
                if (uuidInfoMap.ContainsKey(pi.uuid) ==false)
                {
                    var info = new WorldTileInfo();
                    uuidInfoMap[pi.uuid] = info;
                }
                uuidInfoMap[pi.uuid].AddPointInfo(pi);
            }
        }
        // else if (pi.pointType == WorldPointType.WorldMonster)
        // {
        //     var mo = pi as FieldMonsterPointInfo;
        //     uuidInfoMap[mo.uuid] = mo;
        // }
        // else if (pi.pointType == WorldPointType.WorldBoss)
        // {
        //     var bo = pi as BossPointInfo;
        //     uuidInfoMap[bo.uuid] = bo;
        // }
    }

  private void AddDesertInfo(WorldDesertInfo di)
  {
      if (allViewPoints.ContainsKey(di.pointIndex))
      {
          allViewPoints[di.pointIndex].AddDesertInfo(di);
      }
      else
      {
          var info = new WorldTileInfo();
          info.AddDesertInfo(di);
          allViewPoints.Add(info.pointIndex,info);
      }

      if (di != null && di.uuid != 0)
      {
          if (uuidInfoDesertMap.ContainsKey(di.uuid) ==false)
          {
              var info = new WorldTileInfo();
              uuidInfoDesertMap[di.uuid] = info;
          }
          uuidInfoDesertMap[di.uuid].AddDesertInfo(di);
      }
      
  }
  private void RemoveDesertInfo(int pointIndex)
  {
      WorldTileInfo info;
      if (!allViewPoints.TryGetValue(pointIndex, out info))
      {
          return;
      }

      var desert = info.GetWorldDesertInfo();
      if (desert != null && desert.uuid != 0)
      {
          uuidInfoDesertMap.Remove(desert.uuid);
      }
      info.RemoveDesertInfo();
      if (info.GetIsDataEmpty())
      {
          allViewPoints.Remove(info.pointIndex);
      }
  }

  private void RemovePointInfo(int pointIndex,bool forceRemove)
    {
        WorldTileInfo info;
        if (!allViewPoints.TryGetValue(pointIndex, out info))
        {
            return;
        }

        var pi = info.GetPointInfo();
        if (pi == null)
        {
            return;
        }
        int sz = pi.tileSize;
        //矿跟传中心点
        var tilePos = world.IndexToTilePos(pi.pointIndex);
        if (pi.pointType == WorldPointType.WorldCollectResource)
        {
            int offset = GetCircleRange(sz);
            tilePos.x += offset;
            tilePos.y += offset;
        }
        else if (pi.pointType == WorldPointType.WORLD_ALLIANCE_CITY || pi.pointType == WorldPointType.WORLD_ALLIANCE_BUILD || pi.pointType == WorldPointType.NPC_CITY || pi.pointType == WorldPointType.DRAGON_BUILDING || pi.pointType == WorldPointType.CROSS_THRONE_BUILD)
        {
            sz = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pi.pointIndex);
        }
        var needCheckShowTileList = new List<int>();
        if (sz  > 1)
        {
            for (int x = 0; x < sz; x++)
            {
                for (int y = 0; y < sz; y++)
                {
                    var pos = tilePos - new Vector2Int(x, y);
                    if (!world.IsInMap(pos))
                    {
                        continue;
                    }

                    int index = world.TilePosToIndex(pos);
                    if (index == pointIndex)
                    {
                        continue;
                    }

                    if (allViewPoints.ContainsKey(index))
                    {
                        var tempInfo = allViewPoints[index];
                        if (tempInfo != null)
                        {
                            tempInfo.RemovePointInfo();
                            if (tempInfo.GetIsDataEmpty() || forceRemove == true)
                            {
                                allViewPoints.Remove(index);
                            }
                        }
                    }
                    needCheckShowTileList.Add(index);
                }
            }
        }
        
        world.RemoveOccupyPoints(tilePos, new Vector2Int(sz, sz));
        info.RemovePointInfo();
        if (info.GetIsDataEmpty()|| forceRemove == true)
        {
            allViewPoints.Remove(info.pointIndex);
        }
        needCheckShowTileList.Add(info.pointIndex);
        if (pi.pointType == WorldPointType.PlayerBuilding)
        {
            var bi = pi as BuildPointInfo;
            if (bi != null)
            {
                uuidInfoMap.Remove(bi.uuid);
            }
        }
        else if (pi.pointType == WorldPointType.SAMPLE_POINT || pi.pointType == WorldPointType.SAMPLE_POINT_NEW)
        {
            var mo = pi as SamplePointInfo;
            uuidInfoMap.Remove(mo.uuid);
        }
        else if (pi.pointType == WorldPointType.EXPLORE_POINT || pi.pointType == WorldPointType.DETECT_EVENT_PVE)
        {
            var mo = pi as ExplorePointInfo;
            uuidInfoMap.Remove(mo.uuid);
        }
        else if (pi.pointType == WorldPointType.GARBAGE)
        {
            var mo = pi as GarbagePointInfo;
            uuidInfoMap.Remove(mo.uuid);
        }

        // else if (pi.pointType == WorldPointType.WorldMonster)
        // {
        //     var mo = pi as FieldMonsterPointInfo;
        //     uuidInfoMap.Remove(mo.uuid);
        // }
        // else if (pi.pointType == WorldPointType.WorldBoss)
        // {
        //     var bo = pi as BossPointInfo;
        //     uuidInfoMap.Remove(bo.uuid);
        // }
        for (int i = 0; i < needCheckShowTileList.Count; i++)
        {
            var t = GetWorldTileInfo(needCheckShowTileList[i]);
            if (t != null && t.GetIsDataEmpty() == false)
            {
                AddToBuildList(t.pointIndex);
            }
        }

    }

    // 分帧创建或更新世界物体
    private void BuildAsync(Vector2Int viewLevelRange)
    {
        int count = 0;
        for (int i = 0; i < toBuildList.Count; i++)
        {
            if (busy || count > 35)
            {
                Log.Debug("world point BuildAsync break because long  count {0}", count);
                break;
            }

            count++;
            var mainIndex = toBuildList[i];
            var pointInfo = GetPointInfo(toBuildList[i]);
            var checkLod = OtherPointLod;
            if (pointInfo != null)
            {
                mainIndex = pointInfo.mainIndex;
                if (pointInfo.pointType == WorldPointType.WorldRuinPoint)
                {
                    mainIndex = pointInfo.pointIndex;
                }
                if (pointInfo.GetPlayerType() == PlayerType.PlayerSelf 
                    ||pointInfo.pointType == WorldPointType.WORLD_ALLIANCE_BUILD 
                    ||pointInfo.pointType == WorldPointType.DRAGON_BUILDING 
                    ||pointInfo.pointType == WorldPointType.CROSS_THRONE_BUILD
                    ||pointInfo.pointType == WorldPointType.SECRET_KEY)
                {
                    checkLod = SelfPointLod;
                }
                else if (pointInfo.GetPlayerType() == PlayerType.PlayerAlliance ||
                          pointInfo.GetPlayerType() == PlayerType.PlayerAllianceLeader)
                {
                    checkLod = SelfPointLod;
                }
            }

            if (LOD > checkLod)
            {
                continue;
            }
            var obj = GetObjectByPoint(mainIndex);
            if (obj == null)
            {
                
                var tp = world.IndexToTilePos(mainIndex);
                if (!IsOutOfRange(tp, reqPos, viewLevelRange))
                {
                    CreateObject(mainIndex);
                }
            }
            else
            {
                var info = GetWorldTileInfo(mainIndex);
                if (info != null)
                {
                    var objType = obj.GetPointType();
                    if (info.GetPointType() != objType)
                    {
                        DestroyObject(mainIndex);
                        var tp = world.IndexToTilePos(mainIndex);
                        if (!IsOutOfRange(tp, reqPos, viewLevelRange))
                        {
                            CreateObject(mainIndex);
                        }
                    }
                    else
                    {
                        obj.UpdateGameObject();
                    }
                    
                }
                
            }
        }

        if (count > 0)
        {
            toBuildList.RemoveRange(0, count);
        }
    }

    //public void OnLodChanged(int lod)
    //{
    //    foreach (var obj in allObjs.Values)
    //    {
    //        obj.UpdateLod(lod);
    //    }
    //}

    private bool IsOutOfRange(Vector2Int p, Vector2Int center, Vector2Int range)
    {
        var delta = p - center;
        if (Mathf.Abs(delta.x) >= range.x || Mathf.Abs(delta.y) >= range.y)
        {
            return true;
        }

        return false;
    }

    // 删除超出视野的数据
    private void DeleteOutOfView(Vector2Int viewLevelRange)
    {
        if (lastDelPos != reqPos || svLod != lastDelSvLod)
        {
            foreach (var pt in allViewPoints.Values)
            {
                Vector2Int tp = world.IndexToTilePos(pt.pointIndex);
                if (IsOutOfRange(tp, reqPos, viewLevelRange) && GameEntry.GlobalData.serverType != (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER )
                {
                    if (!outOfViewPoints.ContainsKey(pt.pointIndex))
                    {
                        outOfViewPoints.Add(pt.pointIndex, pt);
                    }
                    
                }
            }

            lastDelPos = reqPos;
            lastDelSvLod = svLod;
        }

        if (outOfViewPoints.Count > 0)
        {
            keysToRemove.Clear();
            int count = 0;
            foreach (var i in outOfViewPoints)
            {
                if (busy)
                {
                    Log.Debug("[world point] delete break because long  count {0}", count);
                    break;
                }

                var pt = i.Value;
                DestroyObject(pt.pointIndex);
                RemovePointInfo(pt.pointIndex,true);
                keysToRemove.Add(pt.pointIndex);
                count++;
            }

            foreach (var i in keysToRemove)
            {
                outOfViewPoints.Remove(i);
            }
        }
    }

    private void CreateObject(int pointIndex)
    {
        var info = GetWorldTileInfo(pointIndex);
        if (info == null ||info.GetIsDataEmpty())
            return;

        WorldPointObject obj = null;
        var pType = info.GetPointType();
        switch (pType)
        {
            case (int)WorldPointType.PlayerBuilding:
                obj = new WorldBuildObjectNew(world, pointIndex,pType);
                break;
            case (int)WorldPointType.NPC_CITY:
                obj = new WorldNpcCity(world, pointIndex,pType);
                break;
            case (int)WorldPointType.WorldResource:
                obj = new WorldResObject(world, pointIndex,pType);
                break;
            //case WorldPointType.WorldMonster:
            //    obj = new WorldMonsterObject(world, pointIndex);
            //    break;
            //case WorldPointType.WorldBoss:
            //    obj = new WorldMonsterObject(world, pointIndex);
            //    break;
            case (int)WorldPointType.WorldCollectResource:
                break;
            case (int)WorldPointType.EXPLORE_POINT:
            case (int)WorldPointType.DETECT_EVENT_PVE:
            {
                obj = new WorldExploreObject(world, pointIndex,pType);
            }
                break;
            case (int)WorldPointType.SAMPLE_POINT:
            case (int)WorldPointType.SAMPLE_POINT_NEW:
            {
                obj = new WorldSampleObject(world, pointIndex,pType);
            }
                break;
            case (int)WorldPointType.GARBAGE:
            {
                obj = new WorldGarbageObject(world, pointIndex,pType);
                var visible = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsShowWorldCollectPoint");
                obj.SetVisible(visible);
            }
                break;
            case (int)WorldPointType.WORLD_ALLIANCE_CITY:
            {
                obj = new WorldBasePointObject(world, pointIndex,pType);
                break;
            }
            case (int)WorldPointType.DRAGON_BUILDING:
            {
                obj = new WorldDragonPointObject(world, pointIndex,pType);
                break;
            }
            case (int)WorldPointType.CROSS_THRONE_BUILD:
            {
                obj = new WorldThronePointObject(world, pointIndex,pType);
                break;
            }
            case (int)WorldPointType.SECRET_KEY:
            {
                obj = new WorldBasePointObject(world, pointIndex,pType);
                break;
            }
            case (int)WorldPointType.WorldRuinPoint:
            {
                obj = new WorldRuinCity(world, pointIndex,pType);
                break;
            }

            case (int)WorldPointType.WORLD_ALLIANCE_BUILD:
                obj = new WorldAllianceBuildObject(world, pointIndex, pType);
                break;
            default:
            {
                obj = new WorldBasePointObject(world, pointIndex,pType);
                break;
            }
        }

        if (obj != null)
        {
            obj.CreateGameObject();
            allObjs.Add(pointIndex, obj);
        }
    }

    public void DestroyObject(int pointIndex)
    {
        WorldPointObject obj;
        if (allObjs.TryGetValue(pointIndex, out obj))
        {
            obj.Destroy();
            allObjs.Remove(pointIndex);
        }
    }

    public void AddToDeleteList(int index)
    {
        if (!needDestoryBuild.ContainsKey(index))
        {
            needDestoryBuild.Add(index,true);
        }
    }

    private void DestroyBuildList()
    {
        if (needDestoryBuild.Count > 0)
        {
            foreach (var VARIABLE in needDestoryBuild)
            {
                DestroyObject(VARIABLE.Key);
            }
            needDestoryBuild.Clear();
        }
    }

    private void FoldUpBuildObject(int pointIndex)
    {
        WorldPointObject obj;
        if (allObjs.TryGetValue(pointIndex, out obj))
        {
            if (obj is WorldBuildObjectNew temp)
            {
                temp.FoldUpBuild();
            }
            else
            {
                DestroyObject(pointIndex);
            }
        }
    }

    public WorldPointObject GetObjectByPoint(int pointIndex)
    {
        WorldPointObject obj = null;
        if (allObjs.TryGetValue(pointIndex, out obj))
            return obj;
        return null;
    }

    public WorldPointObject GetObjectByUuid(long uuid)
    {
        var info = GetPointInfoByUuid(uuid);
        if (info == null)
            return null;
        return GetObjectByPoint(info.mainIndex);
    }
    
    private  void ObjectsOnUpdate(float deltaTime)
    {
        foreach (var o in allObjs.Values)
        {
            o.OnUpdate(deltaTime);
        }
        DestroyBuildList();
    }



    public WorldBuilding GetWorldBuildingByPoint(int pointIndex)
    {
        var obj = GetObjectByPoint(pointIndex) as WorldBuildObjectNew;
        return obj?.GetCityBuilding();
    }

    public WorldBuilding GetWorldBuildingByUuid(long uuid)
    {
        var info = GetPointInfoByUuid(uuid);
        if (info != null)
        {
            return GetWorldBuildingByPoint(info.mainIndex);
        }

        return null;
    }

    //是否需要替换新的建筑模型
    private bool IsNeedChangeBuildObj(BuildPointInfo oldInfo, BuildPointInfo newInfo)
    {
        if (oldInfo != null && newInfo != null)
        {
            int x = oldInfo.level;
            // if (x > 0 && oldInfo.IsThisState(QueueState.UPGRADE))
            // {
            //     x += 1;//升级所用模型为下一级模型，0升1除外
            // }
             int y = newInfo.level;
            // if (y > 0 && newInfo.IsThisState(QueueState.UPGRADE))
            // {
            //     y += 1;//升级所用模型为下一级模型，0升1除外
            // }
            var oldLevelId = oldInfo.itemId+ x;
            var oldModel = "";
            var type = (int)WorldPointType.PlayerBuilding;
            var oldSkinId = oldInfo.skinId;
            if (oldSkinId > 0)
            {
                if (WorldScene.ModelPathDic.ContainsKey(oldSkinId))
                {
                    var item = WorldScene.ModelPathDic[oldSkinId];
                    if (item.ContainsKey(type))
                    {
                        oldModel = item[type];
                    }
                }
                if (oldModel.IsNullOrEmpty())
                {
                    oldModel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Decoration,oldSkinId,"model_world");
                    if (!WorldScene.ModelPathDic.ContainsKey(oldLevelId))
                    {
                        WorldScene.ModelPathDic[oldSkinId] = new Dictionary<int, string>();
                    }

                    WorldScene.ModelPathDic[oldSkinId][type] = oldModel;
                }
            }
            else
            {
                if (WorldScene.ModelPathDic.ContainsKey(oldLevelId))
                {
                    var item = WorldScene.ModelPathDic[oldLevelId];
                    if (item.ContainsKey(type))
                    {
                        oldModel = item[type];
                    }
                }
                if (oldModel.IsNullOrEmpty())
                {
                    oldModel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,oldLevelId,"model_world");
                    if (!WorldScene.ModelPathDic.ContainsKey(oldLevelId))
                    {
                        WorldScene.ModelPathDic[oldLevelId] = new Dictionary<int, string>();
                    }

                    WorldScene.ModelPathDic[oldLevelId][type] = oldModel;
                }
            }
            

            var newModel = "";
            var newLevelId = newInfo.itemId+ y;
            var newSkinId = newInfo.skinId;
            if (newSkinId > 0)
            {
                if (WorldScene.ModelPathDic.ContainsKey(newSkinId))
                {
                    var item = WorldScene.ModelPathDic[newSkinId];
                    if (item.ContainsKey(type))
                    {
                        oldModel = item[type];
                    }
                }
                if (oldModel.IsNullOrEmpty())
                {
                    oldModel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Decoration,newSkinId,"model_world");
                    if (!WorldScene.ModelPathDic.ContainsKey(oldLevelId))
                    {
                        WorldScene.ModelPathDic[newSkinId] = new Dictionary<int, string>();
                    }

                    WorldScene.ModelPathDic[newSkinId][type] = oldModel;
                }
            }
            else
            {
                if (WorldScene.ModelPathDic.ContainsKey(newLevelId))
                {
                    var item = WorldScene.ModelPathDic[newLevelId];
                    if (item.ContainsKey(type))
                    {
                        newModel = item[type];
                    }
                }
                if (newModel.IsNullOrEmpty())
                {
                    newModel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,newLevelId,"model_world");
                    if (!WorldScene.ModelPathDic.ContainsKey(newLevelId))
                    {
                        WorldScene.ModelPathDic[newLevelId] = new Dictionary<int, string>();
                    }

                    WorldScene.ModelPathDic[newLevelId][type] = newModel;
                }
            }
           
            if (oldModel.IsNullOrEmpty() == false && newModel.IsNullOrEmpty() == false)
            {
                return oldModel != newModel;
            }
        }
       
        return true;
    }

    private bool IsNeedChangeAllianceCity(PointInfo oldInfo, PointInfo newInfo)
    {
        var oldPrefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            oldInfo);
        var newPrefabPath =  GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            newInfo);
        if (oldPrefabPath.IsNullOrEmpty() ==false && oldPrefabPath.IsNullOrEmpty()== false && oldPrefabPath.Equals(newPrefabPath))
        {
            return false;
        }

        return true;
    }
    private bool IsNeedChangeAllianceBuild(PointInfo oldInfo, PointInfo newInfo)
    {
        var oldPrefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            oldInfo);
        var newPrefabPath =  GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            newInfo);
        if (oldPrefabPath.IsNullOrEmpty() ==false && oldPrefabPath.IsNullOrEmpty()== false && oldPrefabPath.Equals(newPrefabPath))
        {
            return false;
        }

        return true;
    }
    private bool IsNeedChangeDragonBuild(PointInfo oldInfo, PointInfo newInfo)
    {
        var oldPrefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            oldInfo);
        var newPrefabPath =  GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            newInfo);
        if (oldPrefabPath.IsNullOrEmpty() ==false && oldPrefabPath.IsNullOrEmpty()== false && oldPrefabPath.Equals(newPrefabPath))
        {
            return false;
        }

        return true;
    }
    private bool IsNeedChangeThroneBuild(PointInfo oldInfo, PointInfo newInfo)
    {
        var oldPrefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            oldInfo);
        var newPrefabPath =  GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
            newInfo);
        if (oldPrefabPath.IsNullOrEmpty() ==false && oldPrefabPath.IsNullOrEmpty()== false && oldPrefabPath.Equals(newPrefabPath))
        {
            return false;
        }

        return true;
    }

    //获取占地面积所对应的圈数
    public static int GetCircleRange(int tile)
    {
        return (tile - 1) / 2;
    }

    //获取附近垃圾信息
    public List<int> GetGarbagePoint()
    {
        List<int> result = new List<int>();
        foreach (var per in allViewPoints.Values)
        {
            var pi = per.GetPointInfo();
            if (pi != null)
            {
                if (pi.pointType == WorldPointType.GARBAGE && pi.isMainPoint)
                {
                    GarbagePointInfo info = pi as GarbagePointInfo;
                    if (info != null)
                    {
                        result.Add(pi.mainIndex);
                    }
                }
            }
               
        }

        if (result.Count > 1)
        {
            var mainPos = SceneManager.World.IndexToTilePos(SceneManager.World.curIndex);
            result.Sort((a, b) =>
            {
                var pos1 = SceneManager.World.IndexToTilePos(a) - mainPos;
                var pos2 = SceneManager.World.IndexToTilePos(b) - mainPos;
                return pos1.x * pos1.x + pos1.y * pos1.y - pos2.x * pos2.x + pos2.y * pos2.y;
            });
        }
        return result;
    }
    

    public Dictionary<string,BuildPointInfo> GetSelfAllianceList()
    {
        return selfAllianceMemberDic;
    }

    public Dictionary<long, PointInfo> GetDragonPointDic()
    {
        return dragonPointDic;
    }
    

    #region Profile

    private bool profileSwitch = true;

    public bool GetProfileSwitch()
    {
        return profileSwitch;
    }

    public void ProfileToggle()
    {
        profileSwitch = !profileSwitch;
        foreach (var i in allObjs)
        {
            i.Value.SetVisible(profileSwitch);
        }
    }

    #endregion
    
}
#endif