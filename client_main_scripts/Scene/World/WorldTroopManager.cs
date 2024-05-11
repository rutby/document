using System;
using System.Collections.Generic;
using Unity.Collections;
using GameFramework;
using Unity.Jobs;
using Unity.Mathematics;
using Protobuf;
using Sfs2X.Requests;
using UnityEngine;
#if false
public class WorldTroopManager : WorldManagerBase
{
    private const int MaxFrameTime = 10;
    private const float EdgeRateX = 0.1f;
    private const float EdgeRateY = 0.08f;

    public static double time { get; private set; }
    public static bool busy => DateTime.Now.TimeOfDay.TotalMilliseconds - time >= MaxFrameTime;

    private Dictionary<long, WorldTroop> troopsDict = new Dictionary<long, WorldTroop>();
    private List<long> removeList = new List<long>();
    
    private Dictionary<long, WorldMarch> createMarchDict = new Dictionary<long, WorldMarch>();
    private Dictionary<long, bool> destroyMarchDict = new Dictionary<long, bool>();
    
    private WorldPathfinding.AsyncPathfinding pathfinding;
    private InstanceRequest dragTroopLineInst;
    private WorldTroopLine dragTroopLine;
    private List<InstanceRequest> hitInstList = new List<InstanceRequest>();
    private InstanceRequest _troopDestinationInst;
    private WorldTroopDestinationSignal _troopDestination;
    private Dictionary<NewMarchType, bool> _hideModelType = new Dictionary<NewMarchType, bool>();//引导需要隐藏的行军类型
    private int LOD;
    private int SelfMarchLod = 8;
    private int OtherMarchLod = 4;
    private bool showBattleEffect = false;
    private bool showGunAttack = false;
    private bool showDamageAttack = false;
    private int bulletCount = 80;
    class BattleVFX
    {
        public float life;
        public InstanceRequest inst;
    }

    private List<BulletInfo> transList = new List<BulletInfo>();
    private List<BattleVFX> vfxList = new List<BattleVFX>();
    

    public WorldTroopManager(WorldScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        _hideModelType.Clear();
        LOD = world.GetLodLevel();
        showBattleEffect = GameEntry.Setting.GetPrivateBool("ShowTroopAttackEffect", true);
        GameEntry.Event.Subscribe(EventId.ShowWorldMarchByType,ShowWorldMarchByTypeSignal);
        showGunAttack = GameEntry.Setting.GetPrivateBool("ShowTroopGunAttackEffect", true);
        showDamageAttack = GameEntry.Setting.GetPrivateBool("ShowTroopDamageAttackEffect", true);
        bulletCount = GameEntry.Lua.CallWithReturn<int>("CSharpCallLuaInterface.GetCreateBulletMaxCount");
        GameEntry.Event.Subscribe(EventId.ChangeShowTroopGunAttackEffectState,OnChangeShowTroopGunEffect);
        GameEntry.Event.Subscribe(EventId.ChangeShowTroopDamageAttackEffectState,OnChangeShowTroopDamageEffect);
        GameEntry.Event.Subscribe(EventId.HideWorldMarchByType,HideWorldMarchByTypeSignal);
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);
        GameEntry.Event.Subscribe(EventId.ChangeShowTroopAttackEffectState, OnChangeShowTroopEffect);
    }
    
    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ShowWorldMarchByType,ShowWorldMarchByTypeSignal);
        GameEntry.Event.Unsubscribe(EventId.HideWorldMarchByType,HideWorldMarchByTypeSignal);
        GameEntry.Event.Unsubscribe(EventId.ChangeShowTroopAttackEffectState, OnChangeShowTroopEffect);
        GameEntry.Event.Unsubscribe(EventId.ChangeShowTroopGunAttackEffectState,OnChangeShowTroopGunEffect);
        GameEntry.Event.Unsubscribe(EventId.ChangeShowTroopDamageAttackEffectState,OnChangeShowTroopDamageEffect);
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
        _hideModelType.Clear();
        foreach (var i in troopsDict.Values)
        {
            i.Destroy();
        }
        troopsDict.Clear();
        for (int i = 0; i < transList.Count; i++)
        {
            transList[i].Destroy();
        }
        transList.Clear();
        for (int i = 0; i < vfxList.Count; i++)
        {
            vfxList[i]?.inst.Destroy();
        }
        vfxList.Clear();
        if (hitInstList != null)
        {
            foreach (var VARIABLE in hitInstList)
            {
                if (VARIABLE != null)
                {
                    VARIABLE.Destroy();
                }
            }
            hitInstList.Clear();
        }
        DestroyDragLine();
        DestroyTroopDestination();
    }

    private void OnChangeShowTroopEffect(object userData)
    {
        showBattleEffect = GameEntry.Setting.GetPrivateBool("ShowTroopAttackEffect", true);
        foreach (var i in troopsDict)
        {
            if (i.Value!=null)
            {
                i.Value.ChangeShowEffectState(showBattleEffect);
            }
        }
    }
    private void OnChangeShowTroopGunEffect(object userData)
    {
        showGunAttack = GameEntry.Setting.GetPrivateBool("ShowTroopGunAttackEffect", true);
        foreach (var i in troopsDict)
        {
            if (i.Value!=null)
            {
                i.Value.ChangeShowGunEffectState(showGunAttack);
            }
        }
    }
    private void OnChangeShowTroopDamageEffect(object userData)
    {
        showDamageAttack = GameEntry.Setting.GetPrivateBool("ShowTroopDamageAttackEffect", true);
    }

    public WorldTroop GetTroop(long marchUuid)
    {
        WorldTroop troop;
        if (troopsDict.TryGetValue(marchUuid, out troop))
        {
            return troop;
        }

        return null;
    }

    public void CreateTroop(WorldMarch march)
    {
        if (troopsDict.TryGetValue(march.uuid, out var troop))
        {
            troop.Refresh(march);
        }
        else
        {
            createMarchDict[march.uuid] = march;
            destroyMarchDict.Remove(march.uuid);
        }
    }

    public void DestroyTroop(long marchUuid, bool isBattleFailed = false)
    {
        if (isBattleFailed)
        {
            var troop = GetTroop(marchUuid);
            if (troop != null)
            {
                troop.ShowBattleDefeat();
                troop.DelayDestroy(2.14f);
            }
        }
        else
        {
            destroyMarchDict[marchUuid] = isBattleFailed;
            createMarchDict.Remove(marchUuid);
        }
    }

    public void UpdateTroop(WorldMarch march)
    {
        if (troopsDict.TryGetValue(march.uuid, out var troop))
        {
            troop.Refresh(march);
        }
    }

    private void CreateTroopsAsync()
    {
        if (createMarchDict.Count > 0)
        {
            int count = 0;
            removeList.Clear();
            foreach (var i in createMarchDict)
            {
                if (busy)
                {
                    Log.Debug("CreateTroopsAsync break, count {0}", count);
                    break;
                }

                var checkLod = OtherMarchLod;
                if (i.Value.ownerUid == GameEntry.Data.Player.Uid)
                {
                    checkLod = SelfMarchLod;
                }
                if (LOD<=checkLod)
                {
                    CreateTroopObj(i.Value);
                }
                removeList.Add(i.Key);
                count++;
            }

            foreach (var i in removeList)
                createMarchDict.Remove(i);
        }
    }

    private void DestroyTroopsAsync()
    {
        if (destroyMarchDict.Count > 0)
        {
            int count = 0;
            removeList.Clear();
            foreach (var i in destroyMarchDict)
            {
                if (busy)
                {
                    Log.Debug("DestroyTroopsAsync break, count {0}", count);
                    break;
                }
                DestroyTroopObj(i.Key);
                removeList.Add(i.Key);
                count++;
            }

            foreach (var i in removeList)
                destroyMarchDict.Remove(i);
        }
    }

    public bool IsTroopCreate(long marchUuid)
    {
        return troopsDict.ContainsKey(marchUuid);
    }

    public void OnDragUpdate(long marchUuid, Vector3 dragPosCurrent, long targetMarchUuid,int startPointId = 0,bool isFormation = false)
    {
        var startPos = Vector3.one;
        Vector3 touchPoint = world.GetTouchPoint();
        Vector3 targetRealPos = Vector3.one;
        if (isFormation == false)
        {
            var info = world.GetMarch(marchUuid);
            if (info == null || info.ownerUid != GameEntry.Data.Player.Uid || info.type == NewMarchType.ASSEMBLY_MARCH)
            {
                DestroyDragLine();
                return;
            }

            world.CanMoving = false;
            if (info.status == MarchStatus.IN_WORM_HOLE)//虫洞中无法操作
            {
                UIUtils.ShowTips("129015");
                DestroyDragLine();
                if (_troopDestination != null)
                {
                    _troopDestination.HideDestination();
                }

                return;
            }
            if (info.status == MarchStatus.ASSISTANCE || info.status == MarchStatus.COLLECTING || info.status == MarchStatus.COLLECTING_ASSISTANCE)
            {
                startPos = SceneManager.World.TileIndexToWorld(info.targetPos);
            }
            else
            {
                startPos = info.position;
                var troop = GetTroop(info.uuid);
                if (troop != null)
                {
                    startPos = troop.GetPosition();
                }
            }
        }
        else
        {
            world.CanMoving = false;
            startPos = SceneManager.World.TileIndexToWorld(startPointId);
        }
        EdgeDragUpdate(dragPosCurrent);

        if (pathfinding != null)
        {
            pathfinding.Cancel();
            pathfinding = null;
        }
        CreateDragLine();
        if (dragTroopLine != null)
        {
            dragTroopLine.SetDragPath(startPos, touchPoint);
        }

        targetRealPos = touchPoint;
        int tileSize = 1;
        var endPos = world.WorldToTileIndex(world.GetTouchPoint());
        var marchType = GetTargetType(targetMarchUuid, endPos);
        EnumDestinationSignalType destinationType = GetDestinationType(marchUuid, targetMarchUuid,endPos,marchType,isFormation, ref targetRealPos, ref tileSize);
        float distance = GetDistanceToTarget(startPos, targetRealPos);

        CreateTroopDestination();
        if (_troopDestination != null)
        {
            _troopDestination.SetDestination(targetRealPos, destinationType,marchType, tileSize, distance);
        }
    }

    private void CreateDragLine()
    {
        if (dragTroopLineInst == null)
        {
            dragTroopLineInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopLineDrag);
            dragTroopLineInst.completed += delegate
            {
                dragTroopLineInst.gameObject.transform.SetParent(world.DynamicObjNode);
                dragTroopLine = dragTroopLineInst.gameObject.GetComponent<WorldTroopLine>();
            };
        }
    }

    private void DestroyDragLine()
    {
        if (dragTroopLineInst != null)
        {
            dragTroopLineInst.Destroy();
            dragTroopLineInst = null;
            dragTroopLine = null;
        }
    }

    private void CreateTroopDestination()
    {
        if (_troopDestinationInst == null)
        {
            _troopDestinationInst =
                GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopDestinationSignal);
            _troopDestinationInst.completed += delegate(InstanceRequest request)
            {
                _troopDestinationInst.gameObject.transform.SetParent(world.DynamicObjNode);
                _troopDestinationInst.gameObject.transform.localScale = Vector3.one;
                _troopDestination = _troopDestinationInst.gameObject.GetComponent<WorldTroopDestinationSignal>();
            };
        }
    }

    private void DestroyTroopDestination()
    {
        if (_troopDestinationInst != null)
        {
            _troopDestinationInst.Destroy();
            _troopDestinationInst = null;
            _troopDestination = null;
        }
    }

    private float GetDistanceToTarget(Vector3 myPosV3, Vector3 targetPos)
    {
        Vector2Int myPos = world.WorldToTile(myPosV3);
        Vector2Int destinationPos = world.WorldToTile(targetPos);
        float distance = world.TileDistance(myPos, destinationPos);
        return distance;
    }

    public EnumDestinationSignalType GetDestinationType(long marchUuid, long targetMarchUuid,int endPos, MarchTargetType targetType,bool isFormation, ref Vector3 realPos, ref int tileSize)
    {
        EnumDestinationSignalType tempType = EnumDestinationSignalType.None;
        if (marchUuid != 0 && isFormation ==false)
        {
            if (marchUuid == targetMarchUuid)
            {
                return tempType;
            }

            var info = world.GetMarch(marchUuid);
            if (info == null || info.ownerUid != GameEntry.Data.Player.Uid || info.type == NewMarchType.ASSEMBLY_MARCH)
                return tempType;
            if (info.GetIsBroken())
            {
                return tempType;
            }
        }

        if (targetType == MarchTargetType.RALLY_FOR_BOSS || targetType == MarchTargetType.EXPLORE)
        {
            tempType = EnumDestinationSignalType.None;
        }
        else if (targetType == MarchTargetType.STATE)
        {
            tempType = EnumDestinationSignalType.EmptyGround;
        }
        else if (targetType == MarchTargetType.ATTACK_MONSTER || targetType == MarchTargetType.ATTACK_ARMY || targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS)
        {
            if (targetMarchUuid != 0)
            {
                var targetTroop = GetTroop(targetMarchUuid);
                if (targetTroop != null)
                {
                    realPos = targetTroop.GetPosition();
                    if (targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS)
                    {
                        var info = world.GetMarch(targetMarchUuid);
                        tileSize = 1;
                        if (info != null && (info.type == NewMarchType.ACT_BOSS || info.type == NewMarchType.PUZZLE_BOSS || info.type == NewMarchType.CHALLENGE_BOSS|| info.type == NewMarchType.ALLIANCE_BOSS))
                        {
                            var size = GameEntry.Lua.CallWithReturn<int, string, int, string>("CSharpCallLuaInterface.GetTemplateData", "APS_monster", info.monsterId, "size");
                            if (size > 0)
                            {
                                tileSize = size;
                            }
                        }
                        
                    }
                    else if (targetType == MarchTargetType.ATTACK_ARMY)
                    {
                        tileSize = 1;
                    }
                    
                    tempType = EnumDestinationSignalType.EnemyMarch;
                }
            }
        }
        else
        {
            if (endPos > 0)
            {
                var pointInfo = world.GetPointInfo(endPos);
                if (pointInfo != null)
                {
                    if (pointInfo.pointType == WorldPointType.WORLD_ALLIANCE_CITY)
                    {
                        tileSize = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.pointIndex);
                    }
                    else if (pointInfo.pointType == WorldPointType.WORLD_ALLIANCE_BUILD)
                    {
                        tileSize = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.pointIndex);
                    }
                    else if (pointInfo.pointType == WorldPointType.NPC_CITY)
                    {
                        tileSize = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.pointIndex);
                    }
                    else if (pointInfo.pointType == WorldPointType.DRAGON_BUILDING)
                    {
                        tileSize = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.pointIndex);
                    }
                    else if (pointInfo.pointType == WorldPointType.CROSS_THRONE_BUILD)
                    {
                        tileSize = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",pointInfo.pointIndex);
                    }
                    else
                    {
                        tileSize = pointInfo.tileSize;
                    }
                        
                    realPos = world.TileIndexToWorld(pointInfo.mainIndex);
                    if (targetType == MarchTargetType.COLLECT || targetType == MarchTargetType.SAMPLE ||
                        targetType == MarchTargetType.PICK_GARBAGE || targetType == MarchTargetType.GOLLOES_EXPLORE)
                    {
                        tempType = EnumDestinationSignalType.Other;
                    }
                    else if (targetType == MarchTargetType.BACK_HOME)
                    {
                        if (pointInfo.pointType == WorldPointType.PlayerBuilding)
                        {
                            var build = pointInfo as BuildPointInfo;
                            if (build != null)
                            {
                                tempType = EnumDestinationSignalType.My;
                                realPos = world.TileIndexToWorld(build.inside);
                                tileSize = 3;
                            }
                        }
                        
                    }
                    else if (targetType == MarchTargetType.ATTACK_BUILDING ||
                             targetType == MarchTargetType.ATTACK_ALLIANCE_CITY ||
                             targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING ||
                             targetType == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE||
                             targetType == MarchTargetType.DIRECT_ATTACK_NPC_CITY ||
                             targetType == MarchTargetType.ATTACK_NPC_CITY ||
                             targetType == MarchTargetType.ATTACK_DRAGON_BUILDING||
                             targetType == MarchTargetType.TRIGGER_DRAGON_BUILDING||
                             targetType == MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING||
                             targetType == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE ||
                             targetType == MarchTargetType.TAKE_SECRET_KEY||
                             targetType == MarchTargetType.PICK_SECRET_KEY||
                             targetType == MarchTargetType.ATTACK_ARMY_COLLECT)
                    {
                        tempType = EnumDestinationSignalType.EnemyBuild;
                    }
                    else if (targetType == MarchTargetType.BUILD_ALLIANCE_BUILDING)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.TRANSPORT_SECRET_KEY)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.ATTACK_CITY || targetType == MarchTargetType.DIRECT_ATTACK_CITY)
                    {
                        if (pointInfo.pointType == WorldPointType.PlayerBuilding)
                        {
                            var build = pointInfo as BuildPointInfo;
                            if (build != null)
                            {
                                tempType = EnumDestinationSignalType.EnemyBuild;
                                realPos = world.TileIndexToWorld(build.inside);
                                tileSize = 3;
                            }
                        }
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_CITY)
                    {
                        if (pointInfo.pointType == WorldPointType.PlayerBuilding)
                        {
                            var build = pointInfo as BuildPointInfo;
                            if (build != null)
                            {
                                tempType = EnumDestinationSignalType.Alliance;
                                realPos = world.TileIndexToWorld(build.inside);
                                tileSize = 3;
                            }
                        }
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE)
                    {
                        tempType = EnumDestinationSignalType.Alliance;
                    }
                    else if (targetType == MarchTargetType.ASSISTANCE_BUILD)
                    {
                        var build = pointInfo as BuildPointInfo;
                        if (build != null)
                        {
                            if (build.ownerUid != GameEntry.Data.Player.Uid)
                            {
                                tempType = EnumDestinationSignalType.Alliance;
                            }
                            else
                            {
                                tempType = EnumDestinationSignalType.My;
                            }
                        }
                    }
                }
                else
                {
                    if (targetType == MarchTargetType.ATTACK_CITY || targetType == MarchTargetType.DIRECT_ATTACK_CITY ||targetType == MarchTargetType.ASSISTANCE_CITY || targetType == MarchTargetType.BACK_HOME)
                    {
                        var cityPoint = GameEntry.Lua.CallWithReturn<int, int>("CSharpCallLuaInterface.CheckIsInBasementRange", endPos);
                        if (cityPoint > 0)
                        {
                            var city = world.GetPointInfo(cityPoint);
                            if (city != null)
                            {
                                tileSize = city.tileSize;
                                realPos = world.TileIndexToWorld(city.mainIndex);
                                if (targetType == MarchTargetType.BACK_HOME)
                                {
                                    tempType = EnumDestinationSignalType.My;
                                }else if (targetType == MarchTargetType.ASSISTANCE_CITY)
                                {
                                    tempType = EnumDestinationSignalType.Alliance;
                                }
                                else
                                {
                                    tempType = EnumDestinationSignalType.EnemyBuild;
                                }
                            }

                            
                        }
                       
                    }
                    
                }
            }
        }
        
        return tempType;
    }

    public MarchTargetType GetTargetType(long targetMarchUuid, int pointId)
    {
        MarchTargetType type = MarchTargetType.STATE;
        if (targetMarchUuid != 0)
        {
            var targetMarchInfo = world.GetMarch(targetMarchUuid);
            if (targetMarchInfo != null && targetMarchInfo.ownerUid != GameEntry.Data.Player.Uid)
            {
                if (targetMarchInfo.type == NewMarchType.MONSTER || targetMarchInfo.type == NewMarchType.CHALLENGE_BOSS)
                {
                    type = MarchTargetType.ATTACK_MONSTER;
                }
                else if (targetMarchInfo.type == NewMarchType.ACT_BOSS || targetMarchInfo.type == NewMarchType.PUZZLE_BOSS || targetMarchInfo.type == NewMarchType.ALLIANCE_BOSS )
                {
                    type = MarchTargetType.DIRECT_ATTACK_ACT_BOSS;
                }
                else if (targetMarchInfo.type == NewMarchType.BOSS)
                {
                    type = MarchTargetType.RALLY_FOR_BOSS;
                }
                else if (targetMarchInfo.type == NewMarchType.EXPLORE || targetMarchInfo.type == NewMarchType.SCOUT || targetMarchInfo.type == NewMarchType.RESOURCE_HELP)
                {
                }
                else if (targetMarchInfo.type == NewMarchType.GOLLOES_EXPLORE)
                {
                    type = MarchTargetType.GOLLOES_EXPLORE;
                }
                else if (targetMarchInfo.type == NewMarchType.GOLLOES_TRADE)
                {
                    type = MarchTargetType.GOLLOES_TRADE;
                }
                // else if (targetMarchInfo.type == NewMarchType.ALLIANCE_BOSS)
                // {
                //     type = MarchTargetType.ATTACK_ALLIANCE_BOSS;
                // }
                else if (targetMarchInfo.GetIsBroken())
                {
                }
                else
                {
                    var allianceUid = GameEntry.Data.Player.GetAllianceId();
                    if (!allianceUid.IsNullOrEmpty() && allianceUid == targetMarchInfo.allianceUid)
                    {
                    }
                    else
                    {
                        type = MarchTargetType.ATTACK_ARMY;
                    }
                }
            }
        }
        else if (pointId > 0)
        {
            if (world.IsTileWalkable(world.IndexToTilePos(pointId)) == false)
            {
            }
            else
            {
                var pointInfo = world.GetPointInfo(pointId);
                if (world.IsCollectRangePoint(pointId) == true && pointInfo == null)
                {
                }
                else
                {
                    if (pointInfo != null && pointInfo.pointType != WorldPointType.Other)
                    {
                        if (pointInfo.pointType == WorldPointType.WorldCollectResource)
                        {
                            type = MarchTargetType.COLLECT;
                        }
                        else if(pointInfo.pointType == WorldPointType.EXPLORE_POINT)
                        {
                            type = MarchTargetType.EXPLORE;
                        }
                        else if(pointInfo.pointType == WorldPointType.SAMPLE_POINT || pointInfo.pointType == WorldPointType.SAMPLE_POINT_NEW)
                        {
                            type = MarchTargetType.SAMPLE;
                        }
                        else if(pointInfo.pointType == WorldPointType.GARBAGE)
                        {
                            type = MarchTargetType.PICK_GARBAGE;
                        }
                        else if(pointInfo.pointType == WorldPointType.WorldResource)
                        {
                            var build = pointInfo as ResPointInfo;
                            if (build != null)
                            {
                                if (build.gatherMarchUuid != 0)
                                {
                                    var allianceId = GameEntry.Data.Player.GetAllianceId();
                                    var march = world.GetMarch(build.gatherMarchUuid);
                                    if (march != null)
                                    {
                                        if (march.ownerUid != GameEntry.Data.Player.Uid)
                                        {
                                            if (!allianceId.IsNullOrEmpty() && march.allianceUid == allianceId)
                                            {
                                            }
                                            else
                                            {
                                                type = MarchTargetType.ATTACK_ARMY_COLLECT;
                                            }
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    type = MarchTargetType.COLLECT;
                                }
                            }
                        }
                        else if (pointInfo.pointType == WorldPointType.PlayerBuilding)
                        {
                            var build = pointInfo as BuildPointInfo;
                            if (build != null)
                            {
                                if (build.ownerUid == GameEntry.Data.Player.Uid)
                                {
                                    if (build.inside != 0)
                                    {
                                        type = MarchTargetType.BACK_HOME;
                                    }
                                    else
                                    {
                                        type = MarchTargetType.ASSISTANCE_BUILD;
                                    }
                                }
                                else
                                {
                                    var allianceId = GameEntry.Data.Player.GetAllianceId();
                                    if (!allianceId.IsNullOrEmpty() && build.allianceId == allianceId)
                                    {
                                        if (build.inside != 0)
                                        {
                                            type = MarchTargetType.ASSISTANCE_CITY;
                                        }
                                        else
                                        {
                                            type = MarchTargetType.ASSISTANCE_BUILD;
                                        }
                                    }
                                    else
                                    {
                                        if (build.inside != 0)
                                        {
                                            type = MarchTargetType.ATTACK_CITY;
                                        }
                                        else
                                        {
                                            type = MarchTargetType.ATTACK_BUILDING;
                                        }
                                    }
                                }
                            }
                        }
                        else if (pointInfo.pointType == WorldPointType.WORLD_ALLIANCE_CITY)
                        {
                            var buildAllianceId =
                                GameEntry.Lua.CallWithReturn<string, int>("WorldBuildUtil.GetBuildAllianceId",
                                    pointInfo.pointIndex);
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            if (!allianceId.IsNullOrEmpty() && buildAllianceId == allianceId)
                            {
                                type = MarchTargetType.ASSISTANCE_ALLIANCE_CITY;
                            }
                            else
                            {
                                type = MarchTargetType.ATTACK_ALLIANCE_CITY;
                            }
                        }
                        else if (pointInfo.pointType == WorldPointType.WORLD_ALLIANCE_BUILD)
                        {
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            var detail = AllianceBuildingPointInfo.Parser.ParseFrom(pointInfo.extraInfo);
                            if (detail.AllianceId == allianceId)
                            {
                                type = detail.State == 0 ? MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE : MarchTargetType.BUILD_ALLIANCE_BUILDING;
                            }
                            else
                            {
                                type = MarchTargetType.ATTACK_BUILDING;
                            }
                            
                        }
                        else if (pointInfo.pointType == WorldPointType.DRAGON_BUILDING)
                        {
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            var detail = DragonBuildingPointInfo.Parser.ParseFrom(pointInfo.extraInfo);
                            if (detail.AllianceId == allianceId)
                            {
                                type = MarchTargetType.ASSISTANCE_DRAGON_BUILDING;
                            }
                            else
                            {
                                type = MarchTargetType.ATTACK_DRAGON_BUILDING;
                            }
                        }
                        else if (pointInfo.pointType == WorldPointType.CROSS_THRONE_BUILD)
                        {
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            var detail = CrossThroneBuildPointInfo.Parser.ParseFrom(pointInfo.extraInfo);
                            if (detail.AllianceId == allianceId)
                            {
                                type = MarchTargetType.ASSISTANCE_CROSS_THRONE_BUILDING;
                            }
                            else
                            {
                                type = MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING;
                            }
                        }
                        else if (pointInfo.pointType == WorldPointType.SECRET_KEY)
                        {
                            type = MarchTargetType.PICK_SECRET_KEY;
                        }
                        else if (pointInfo.pointType == WorldPointType.NPC_CITY)
                        {
                            type = MarchTargetType.ATTACK_NPC_CITY;
                            
                        }
                    }
                    else
                    {
                        var cityPoint = GameEntry.Lua.CallWithReturn<int, int>("CSharpCallLuaInterface.CheckIsInBasementRange", pointId);
                        if (cityPoint > 0)
                        {
                            var city = world.GetPointInfo(cityPoint);
                            if (city != null && city.pointType == WorldPointType.PlayerBuilding)
                            {
                                var build = city as BuildPointInfo;
                                if (build != null && build.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                                {
                                    if (build.ownerUid == GameEntry.Data.Player.Uid)
                                    {
                                        type = MarchTargetType.BACK_HOME;
                                    }
                                    else
                                    {
                                        var allianceId = GameEntry.Data.Player.GetAllianceId();
                                        if (!allianceId.IsNullOrEmpty() && build.allianceId == allianceId)
                                        {
                                            type = MarchTargetType.ASSISTANCE_CITY;
                                        }
                                        else
                                        {
                                            type = MarchTargetType.ATTACK_CITY;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                type = MarchTargetType.STATE;
                            }
                        }
                        else
                        {
                            type = MarchTargetType.STATE;
                        }
                    }
                        
                }
            }
        }

        return type;
    }

    public void OnDragStop(long marchUuid, long targetMarchUuid,bool isFormation =false)
    {
        if (isFormation== false)
        {
            var endPos = world.WorldToTileIndex(world.GetTouchPoint());
            GameEntry.Lua.Call("MarchUtil.OnChangeSingleMarch", marchUuid,targetMarchUuid,endPos);
        }
        else
        {
            var endPos = world.WorldToTileIndex(world.GetTouchPoint());
            GameEntry.Lua.Call("MarchUtil.OnChangeSingleFormation", marchUuid,targetMarchUuid,endPos);
        }
        
        DestroyDragLine();
        if (_troopDestination != null )
        {
            _troopDestination.SetDestinationOver();
        }
    }
    
    public void OnLodChanged(object userdata)
    {
        var lod = (int) userdata;
        LOD = lod;
    }

    public override void OnUpdate(float deltaTime)
    {
        time = DateTime.Now.TimeOfDay.TotalMilliseconds;
        UpdateAllTroops(deltaTime);
        UpdateBattleVFX(deltaTime);
        CreateTroopsAsync();
        DestroyTroopsAsync();
        UpdateBullet();
    }
    private void SpawnHit(string prefabName, Quaternion rotation, float3 gunPosition)
    {

        var requestInst = GameEntry.Resource.InstantiateAsync(prefabName);
        hitInstList.Add(requestInst);
        requestInst.completed += (result) =>
        {
            requestInst.gameObject.transform.position = gunPosition;
            requestInst.gameObject.transform.rotation = rotation;
            YieldUtils.DelayActionWithOutContext(() =>
            {
                if (requestInst != null)
                {
                    requestInst.Destroy();
                }
            }, 0.5f);
            
        };
    }
    private void UpdateBullet()
    {
        NativeArray<float3> tmpPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<float> tmpDistances = new NativeArray<float>(transList.Count, Allocator.TempJob);
        NativeArray<float3> tmpStartPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<float3> tmpTargetPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<double> tmpTimes = new NativeArray<double>(transList.Count, Allocator.TempJob);
        NativeArray<bool> tempIsCreateFinish = new NativeArray<bool>(transList.Count, Allocator.TempJob);
        for (int i = 0; i < transList.Count; i++)
        {
            var finish = transList[i].IsCreateFinish();
            tempIsCreateFinish[i] = finish;
            if (finish)
            {
                tmpPositions[i] = transList[i].Transform.position;
            }
            else
            {
                tmpPositions[i] = float3.zero;
            }
            tmpDistances[i] = float.MaxValue;
            tmpStartPositions[i] = transList[i].StartPosition;
            tmpTargetPositions[i] = transList[i].GetTargetPosition();
            tmpTimes[i] = transList[i].StartTime;
        }
        VelocityJob job = new VelocityJob()
        {
            positions = tmpPositions,
            delaTime = time,
            distances = tmpDistances,
            endPos = tmpTargetPositions,
            startPositions = tmpStartPositions,
            timeArray = tmpTimes,
            isCreateFinish = tempIsCreateFinish
        };
        JobHandle jobHandle = job.Schedule(transList.Count, 32);
        jobHandle.Complete();
        for (int i = transList.Count - 1; i >= 0; i--)
        {
            var obj = transList[i];
            if (tmpDistances[i] <obj.ArriveDistance())
            {
                
                if (obj.IsCreateFinish()&& showDamageAttack)
                {
                    var rotation = obj.GetRotation();
                    var position = obj.GetPosition();
                    SpawnHit(obj.GetHitPrefabName(), rotation,position);
                }
                
                obj.Destroy();
                transList.RemoveAt(i);
                
            }
            else
            {
                var finish = obj.IsCreateFinish();
                if (finish)
                {
                    obj.Transform.position = tmpPositions[i];
                }
            }

        }
        tmpDistances.Dispose();
        tmpPositions.Dispose();
        tmpStartPositions.Dispose();
        tmpTimes.Dispose();
        tempIsCreateFinish.Dispose();
        tmpTargetPositions.Dispose();
    }

    public bool AddBullet(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType, long tUuid,float3 targetPos,bool isSelf)
    {
        if (isSelf || transList.Count <= bulletCount)
        {
            var info = new BulletInfo();
            info.CreateObject(prefabName, hitPrefabName, startPos,rotation,tType,tUuid,targetPos);
            transList.Add(info);
            return true;
        }

        return false;
    }
    
    private void EdgeDragUpdate(Vector3 dragPosCurrent)
    {        
        var rateX = dragPosCurrent.x / Screen.width;
        var rateY = dragPosCurrent.y / Screen.height;
        if (rateX < EdgeRateX || rateX > 1 - EdgeRateX || rateY < EdgeRateY || rateY > 1 - EdgeRateY)
        {
            var touchTerrainPos = world.GetTouchPoint(dragPosCurrent);
            var viewTerrainPos = world.CurTarget;
            var distVec = touchTerrainPos - viewTerrainPos;
            float distLen = distVec.magnitude;
            if (distLen > 0.1f)
            {
                var dir = distVec / distLen;
                float dragSpeed = 0.2f;
                float dist = dragSpeed * Time.deltaTime * world.GetLodDistance();
                var targetPos = viewTerrainPos + dir * dist;
                world.Lookat(targetPos);
            }
        }
    }
    
    private void UpdateAllTroops(float deltaTime)
    {
        foreach (var i in troopsDict)
        {
            i.Value.OnUpdate(deltaTime);
            if (i.Value.IsDelayDestroyed)
            {
                DestroyTroop(i.Key);
            }
        }
    }

    private WorldTroop CreateTroopObj(WorldMarch march)
    {
        WorldTroop troop;
        if (!troopsDict.TryGetValue(march.uuid, out troop))
        {
            troop = new WorldTroop(world);
            troop.Create(march,showBattleEffect,showGunAttack);
            troopsDict.Add(march.uuid, troop);
            troop.SetVisible(CanShow(march));
        }
        else
        {
            troop.Refresh(march);
        }
        
        return troop;
    }

    private void DestroyTroopObj(long marchUuid)
    {
        WorldTroop troop;
        if (troopsDict.TryGetValue(marchUuid, out troop))
        {
            troopsDict.Remove(marchUuid);
            troop.Destroy();
        }
    }
    
    public void CreateBattleVFX(string prefabPath, float life, Action<GameObject> onComplete)
    {
        var inst = GameEntry.Resource.InstantiateAsync(prefabPath);
        vfxList.Add(new BattleVFX { life = life, inst = inst });
        inst.completed += delegate
        {
            onComplete?.Invoke(inst.gameObject);
        };
    }
    
    private void UpdateBattleVFX(float deltaTime)
    {
        for (int i = 0; i< vfxList.Count; i++)
        {
            vfxList[i].life -= deltaTime;
            if (vfxList[i].life <= 0)
            {
                vfxList[i].inst.Destroy();
                vfxList.RemoveAt(i);
                i--;
            }
        }
    }

    public void OnDrawGizmos()
    {
        foreach (var i in troopsDict.Values)
        {
            i.OnDrawGizmos();
        }
    }

    //获取模型高度
    public float GetModelHeight(long marchUuid)
    {
        var troop = GetTroop(marchUuid);
        if (troop != null)
        {
            return troop.GetHeight();
        }

        return 0;
    }
    
    public WorldTroop CreateGroupTroop(WorldMarch march)
    {
        // ???
        return CreateTroopObj(march);
    }
    
    private Dictionary<long, int> battleTroopAndPointId = new Dictionary<long, int>();

    private Dictionary<int, Dictionary<long,Quaternion>> cacheBattleTroopRotationList = new Dictionary<int, Dictionary<long,Quaternion>>();

    public int GetCurPosAndRotationTroopNum(long marchUuid, int pointId, Quaternion rot)
    {
        var count = 0;
        if (battleTroopAndPointId.ContainsKey(marchUuid))
        {
            var pos = battleTroopAndPointId[marchUuid];
            if (pos != pointId)
            {
                if (cacheBattleTroopRotationList.ContainsKey(pos))
                {
                    var dic = cacheBattleTroopRotationList[pos];
                    if (dic.ContainsKey(marchUuid))
                    {
                        dic.Remove(marchUuid);
                    }
                }
            }
        }
        battleTroopAndPointId[marchUuid] = pointId;
        if (cacheBattleTroopRotationList.ContainsKey(pointId))
        {
            var dic = cacheBattleTroopRotationList[pointId];
            if (dic.ContainsKey(marchUuid))
            {
                var rotation = dic[marchUuid];
                if (rotation.Equals(rot))
                {
                    return -1;
                }
            }
            var num = 0;
            foreach (var VARIABLE in dic)
            {
                if (VARIABLE.Value.Equals(rot))
                {
                    num++;
                }
            }
            dic[marchUuid] = rot;
            return num;
        }
        else
        {
            var dic = new Dictionary<long, Quaternion> {{marchUuid, rot}};
            cacheBattleTroopRotationList[pointId] = dic;
        }
        return count;
    }

    public void RemovePosAndRotationDataByMarchUuid(long marchUuid)
    {
        if (battleTroopAndPointId.ContainsKey(marchUuid))
        {
            var pos = battleTroopAndPointId[marchUuid];
            battleTroopAndPointId.Remove(marchUuid);
            if (cacheBattleTroopRotationList.ContainsKey(pos))
            {
                var dic = cacheBattleTroopRotationList[pos];
                if (dic.ContainsKey(marchUuid))
                {
                    dic.Remove(marchUuid);
                }
            }
        }
    }
    
    public void ShowWorldMarchByTypeSignal(object userData)
    {
        if (userData != null)
        {
            var marchType = (NewMarchType) (int) (long) userData;
            SetModelVisibleByMarchType(marchType, true);
        }
    }
     
    public void HideWorldMarchByTypeSignal(object userData)
    {
        if (userData != null)
        {
            var marchType =(NewMarchType) (int) (long) userData;
            SetModelVisibleByMarchType(marchType, false);
        }
    }
    
    public void SetModelVisibleByMarchTypeForLua(int marchType,bool visible)
    {
        SetModelVisibleByMarchType((NewMarchType) marchType, visible);
    }
    private void SetModelVisibleByMarchType(NewMarchType marchType,bool visible)
    {
        if (visible)
        {
            if (_hideModelType.ContainsKey(marchType))
            {
                _hideModelType.Remove(marchType);
            }
        }
        else
        {
            if (!_hideModelType.ContainsKey(marchType))
            {
                _hideModelType.Add(marchType, true);
            }
        }

        foreach (var per in troopsDict.Values)
        {
            var trueType = GetHideTypeByMarchInfo(per.GetMarchInfo());
            if (trueType == marchType)
            {
                per.SetVisible(visible);
            }
        }
    }

    //雷达怪特殊类型，不能直接相等
    private NewMarchType GetHideTypeByMarchInfo(WorldMarch marchInfo)
    {
        if (marchInfo != null)
        {
            if(marchInfo.type == NewMarchType.MONSTER && !string.IsNullOrEmpty(marchInfo.eventId))
            {
                return NewMarchType.EXPLORE;
            }
            
            return marchInfo.type;
        }
        return NewMarchType.DEFAULT;
    }
    
    //是否可以显示
    public bool CanShow(WorldMarch marchInfo)
    {
        var hideType = GetHideTypeByMarchInfo(marchInfo);
        return !_hideModelType.ContainsKey(hideType);
    }
}
#endif