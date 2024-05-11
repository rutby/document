using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using Protobuf;
using Sfs2X.Entities.Data;
using UnityEngine;
using XLua;

//
// 世界行军数据
//
#if false
public partial class WorldMarchDataManager : WorldManagerBase
{
    private QueuedThread workerThread;
    private Queue<ParseDataTask> parseDataTasks = new Queue<ParseDataTask>();
    private Dictionary<long, WorldMarch> allMarches = new Dictionary<long, WorldMarch>();
    private Dictionary<long, WorldMarch> tempAllMarches = new Dictionary<long, WorldMarch>();
    private Dictionary<long, WorldMarch> ownerMarches = new Dictionary<long, WorldMarch>();
    private Dictionary<string,List<WorldMarch>> allianceMarches = new Dictionary<string, List<WorldMarch>>();
    private Dictionary<long, WorldMarch> fakeSampleMarches = new Dictionary<long, WorldMarch>();
    private Dictionary<long, WorldMarch> RallyMarchDic = new Dictionary<long, WorldMarch>();
    private Dictionary<long, int> SortRallyMarchDic = new Dictionary<long, int>();
    private Dictionary<long, WorldMarch> dragonMarches = new Dictionary<long, WorldMarch>();
    private Bounds viewBounds = new Bounds();
    private Rect viewRect = new Rect();
    private bool showBattleBlood = false;
    private List<Vector3> CalTroopLineVec = new List<Vector3>();
    private int LOD;
    private bool UseNewAlarmSystem;
    public WorldMarchDataManager(WorldScene scene) : base(scene)
    {
        
    }


    public override void Init()
    {
        base.Init();
        UseNewAlarmSystem = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsUseNewAlarmFunction");
        LOD = world.GetLodLevel();
        workerThread = new QueuedThread("MarchDataWorker");
        workerThread.Start();
        showBattleBlood = GameEntry.Setting.GetPrivateBool("ShowTroopBloodNum", true);
        GameEntry.Event.Subscribe(EventId.ChangeShowTroopBloodNumState, OnChangeShowBloodNum);
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);
    }

    public override void UnInit()
    {
        base.UnInit();
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
        GameEntry.Event.Unsubscribe(EventId.ChangeShowTroopBloodNumState, OnChangeShowBloodNum);
        workerThread.Stop();
    }

    public override void OnUpdate(float deltaTime)
    {
        UpdateViewRect();
        UpdateTaskList();
        UpdateMove(deltaTime);
        //UpdateBattle(deltaTime);
    }

    public void OnLodChanged(object userdata)
    {
        var lod = (int) userdata;
        LOD = lod;
    }
    private void OnChangeShowBloodNum(object userData)
    {
        showBattleBlood = GameEntry.Setting.GetPrivateBool("ShowTroopBloodNum", true);
    }
    private void UpdateViewRect()
    {
        var mainCam = Camera.main;
        var center = world.CurTarget;
        viewBounds.center = center;
        viewBounds.extents = Vector3.one;
        viewBounds.Encapsulate(world.GetRaycastGroundPoint(new Vector3(0, 0, 0)));
        viewBounds.Encapsulate(world.GetRaycastGroundPoint(new Vector3(0, mainCam.pixelHeight, 0)));
        viewBounds.Encapsulate(world.GetRaycastGroundPoint(new Vector3(mainCam.pixelWidth, mainCam.pixelHeight, 0)));
        viewBounds.Encapsulate(world.GetRaycastGroundPoint(new Vector3(mainCam.pixelWidth, 0, 0)));
        viewBounds.Expand(world.TileSize * 5);
        viewRect.center = new Vector2(viewBounds.center.x, viewBounds.center.z);
        viewRect.size = new Vector2(viewBounds.size.x, viewBounds.size.z);
        
    }

    private bool IsInView(Vector3 position)
    {
        return position.x >= viewRect.xMin &&  position.x <  viewRect.xMax && position.z >= viewRect.yMin && position.z < viewRect.yMax;
    }

    private bool IsLineInView(WorldTroopPathSegment[] path, int currPath, Vector3 currPos)
    {
        CalTroopLineVec.Clear();
        if (path == null)
        {
            return false;
        }
        CalTroopLineVec.Add(currPos);
        int count = path.Length - currPath;
        if (count > 0)
        {
            for (int i = currPath + 1; i < path.Length; i++)
            {
                CalTroopLineVec.Add(path[i].pos);
            }
            for(int i =0;i < CalTroopLineVec.Count-1;++i)
            {
                if(IntersectsSegment(viewRect, new Vector2(CalTroopLineVec[i].x, CalTroopLineVec[i].z), new Vector2(CalTroopLineVec[i+1].x, CalTroopLineVec[i+1].z)))
                {
                    return true;
                }
            }
        }

        return false;
    }

    private static bool IntersectsSegment(Rect rect, Vector2 p1, Vector2 p2)
    {
        float num1 = Mathf.Min(p1.x, p2.x);
        float num2 = Mathf.Max(p1.x, p2.x);
        if ((double) num2 > (double) rect.xMax)
            num2 = rect.xMax;
        if ((double) num1 < (double) rect.xMin)
            num1 = rect.xMin;
        if ((double) num1 > (double) num2)
            return false;
        float num3 = Mathf.Min(p1.y, p2.y);
        float num4 = Mathf.Max(p1.y, p2.y);
        float f = p2.x - p1.x;
        if ((double) Mathf.Abs(f) > 1.40129846432482E-45)
        {
            float num5 = (p2.y - p1.y) / f;
            float num6 = p1.y - num5 * p1.x;
            num3 = num5 * num1 + num6;
            num4 = num5 * num2 + num6;
        }
        if ((double) num3 > (double) num4)
        {
            float num5 = num4;
            num4 = num3;
            num3 = num5;
        }
        if ((double) num4 > (double) rect.yMax)
            num4 = rect.yMax;
        if ((double) num3 < (double) rect.yMin)
            num3 = rect.yMin;
        return (double) num3 <= (double) num4;
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = new Color(0, 0.8f, 0.2f, 0.6f);
        Gizmos.DrawCube(new Vector3(viewRect.center.x, 0, viewRect.center.y), new Vector3(viewRect.size.x, 1, viewRect.size.y));
    }

    public void HandleWorldMarchGet(ISFSObject message)
    {
        if (!message.ContainsKey("marchInfos"))
            return;

        var task = new ParseDataTask()
        {
            taskType = ParseDataTask.TaskType.WorldMarchGet,
            message = message
        };
        parseDataTasks.Enqueue(task);
        workerThread.AddTask(task);
    }

    public void HandlePushWorldMarchAdd(ISFSObject message)
    {

        if (!message.ContainsKey("uuid"))
        {
            return;
        }
        
        var task = new ParseDataTask()
        {
            taskType = ParseDataTask.TaskType.PushMarchAdd,
            message = message
        };
        parseDataTasks.Enqueue(task);
        workerThread.AddTask(task);
    }

    public void HandlePushWorldMarchDel(ISFSObject message)
    {
        if (!message.ContainsKey("uuid"))
        {
            return;
        }
        
        var task = new ParseDataTask()
        {
            taskType = ParseDataTask.TaskType.PushMarchDel,
            message = message
        };
        parseDataTasks.Enqueue(task);
        workerThread.AddTask(task);
    }

    public void HandleFormationMarch(ISFSObject message)
    {
        if (!message.ContainsKey("uuid"))
        {
            return;
        }
        
        var task = new ParseDataTask()
        {
            taskType = ParseDataTask.TaskType.FormationMarch,
            message = message
        };
        parseDataTasks.Enqueue(task);
        workerThread.AddTask(task); 
        if (message.ContainsKey("resource"))
        {
            var data = message.GetSFSObject("resource");
            GameEntry.Lua.Call("LuaEntry.Resource:UpdateResource", ((SFSObject)data).ToLuaTable(GameEntry.Lua.Env));
        }
    }

    public void HandleFormationMarchChange(ISFSObject message)
    {
        if (!message.ContainsKey("uuid"))
        {
            return;
        }
        
        var task = new ParseDataTask()
        {
            taskType = ParseDataTask.TaskType.FormationMarchChange,
            message = message
        };
        parseDataTasks.Enqueue(task);
        workerThread.AddTask(task);

        if (message.ContainsKey("resource"))
        {
            var data = message.GetSFSObject("resource");
            GameEntry.Lua.Call("LuaEntry.Resource:UpdateResource", ((SFSObject)data).ToLuaTable(GameEntry.Lua.Env));
        }

    }

    public void AddFakeSampleMarchData(long startIndex, long endIndex, long startTime, long endTime)
    {
        if (!IsFakeSampleMarchData(endIndex))
        {
            var info = world.GetPointInfo((int)endIndex);
            var march = new WorldMarch();
            march.endTime = endTime;
            march.allianceUid = GameEntry.Data.Player.GetAllianceId();
            march.allianceAbbr = "";
            march.allianceIcon = "";
            march.startTime = startTime;
            march.type = NewMarchType.NORMAL;
            march.target = MarchTargetType.SAMPLE;
            march.status = MarchStatus.MOVING;
            march.uuid = endIndex;
            march.pic = "";
            march.picVer = 0;
            if (info != null)
            {
                march.targetUuid = info.uuid;
            }
            // march.isCameraFollow = true;
            march.ownerName = GameEntry.Data.Player.GetName();
            march.ownerUid = GameEntry.Data.Player.GetUid();
            march.startPos = (int)startIndex;
            march.targetPos = (int)endIndex;
            march.targetWorldPos = SceneManager.World.TileIndexToWorld(march.targetPos);

            var start = world.IndexToTilePos(march.startPos);
            var end = world.IndexToTilePos(march.targetPos);
            var dis = Math.Sqrt(Math.Pow(start.x - end.x, 2) + Math.Pow(start.y - end.y, 2));
            march.speed = (float)dis * 1000 / (endTime - startTime);
            end = GetAttackPos(start, end,3.0f);
            string pathStr = WorldPathfinding.PathToString(new List<Vector2Int>{start, end});
            march.path = pathStr.Split(';').Select(a => a.ToInt()).ToArray();
            fakeSampleMarches[endIndex] = march;
            // AddOrUpdateMarch(march);
            allMarches[march.uuid] = march;
            march.InitMove(CreatePathSegment(march));
        }
    }

    public Dictionary<long, WorldMarch> GetAllSampleFakeData()
    {
        return fakeSampleMarches;
    }
    public void UpdateFakeSampleMarchDataWhenStartPick(long index, long endTime)
    {
        if (IsFakeSampleMarchData(index))
        {
            var marchInfo = fakeSampleMarches[index];
            marchInfo.startTime = marchInfo.endTime;
            marchInfo.endTime = endTime;
            marchInfo.status = MarchStatus.SAMPLING;
            marchInfo.pathList = null;
            GameEntry.Event.Fire(EventId.GarbageCollectStart, marchInfo.targetUuid);
            GameEntry.Event.Fire(EventId.MarchItemUpdateSelf);
            world.DestroyTroopLine(index);
        }
    }

    public void UpdateFakeSampleMarchDataWhenBack(long index, long startTime, long endTime)
    {
        if (IsFakeSampleMarchData(index))
        {
            var marchInfo = fakeSampleMarches[index];
            marchInfo.targetPos = marchInfo.startPos;
            marchInfo.realTargetPos = marchInfo.targetPos;
            marchInfo.startPos = (int)index;
            marchInfo.status = MarchStatus.MOVING;
            marchInfo.target = MarchTargetType.BACK_HOME;
            marchInfo.startTime = startTime;
            marchInfo.endTime = endTime;
            var start = world.IndexToTilePos(marchInfo.startPos);
            var end = world.IndexToTilePos(marchInfo.targetPos);
            var dis = Math.Sqrt(Math.Pow(start.x - end.x, 2) + Math.Pow(start.y - end.y, 2));
            marchInfo.speed = (float)dis * 1000 / (endTime - startTime);
            // end = GetAttackPos(start, end,3.0f);
            start = GetAttackPos(end, start,3.0f);
            string pathStr = WorldPathfinding.PathToString(new List<Vector2Int>{start, end});
            marchInfo.path = pathStr.Split(';').Select(a => a.ToInt()).ToArray();

            marchInfo.InitMove(CreatePathSegment(marchInfo));
            GameEntry.Event.Fire(EventId.MarchItemUpdateSelf);
        }
    }

    public void RemoveFakeSampleMarchData(long index)
    {
        if (IsFakeSampleMarchData(index))
        {
            world.DestroyTroop(index);
            world.DestroyTroopLine(index);
            fakeSampleMarches.Remove(index);
            RemoveMarch(index);
        }
    }

    public void OnResetData()
    {
        var needDestroyMarchList = allMarches.Keys;
        foreach (var uuid in needDestroyMarchList)
        {
            world.DestroyTroop(uuid);
            world.DestroyTroopLine(uuid);
        }
        allMarches.Clear();
        tempAllMarches.Clear(); 
        ownerMarches.Clear(); 
        allianceMarches.Clear(); 
        fakeSampleMarches.Clear();
        dragonMarches.Clear();
        GameEntry.Event.Fire(EventId.MarchItemUpdateSelf);
        // GameEntry.Event.Fire(EventId.MarchItemTargetMeUpdate);
        GameEntry.Event.Fire(EventId.UpdateMarchItem);
    }

    private bool IsFakeSampleMarchData(long index)
    {
        return fakeSampleMarches.ContainsKey(index);
    }
    
    public bool ExistMarch(long uuid)
    {
        return allMarches.ContainsKey(uuid);
    }

    public bool IsInRallyMarch(long uuid)
    {
        bool isInRally = false;
        if (allMarches.ContainsKey(uuid))
        {
            var march = allMarches[uuid];
            if (march.status == MarchStatus.IN_TEAM || march.status == MarchStatus.WAIT_RALLY)
            {
                isInRally = true;
            }
        }
        return isInRally;
    }

    public bool IsInCollectMarch(long uuid)
    {
        bool IsInCollect = false;
        if (allMarches.ContainsKey(uuid))
        {
            var march = allMarches[uuid];
            if (march.status == MarchStatus.COLLECTING || march.status == MarchStatus.COLLECTING_ASSISTANCE)
            {
                IsInCollect = true;
            }
        }
        return IsInCollect;
    }
    //援军队伍
    public bool IsInAssistanceMarch(long uuid)
    {
        bool IsInAssistance = false;
        if (allMarches.ContainsKey(uuid))
        {
            var march = allMarches[uuid];
            if (march.status == MarchStatus.ASSISTANCE || march.status == MarchStatus.COLLECTING_ASSISTANCE)
            {
                IsInAssistance = true;
            }
        }
        return IsInAssistance;
    }

    public bool IsSelfInCurrentMarchTeam(long rallyMarchUuid)
    {

        var march = GetMarch(rallyMarchUuid);
        if (march == null)
        {
            return false;
        }

        if (march.type == NewMarchType.BOSS || march.type == NewMarchType.MONSTER ||march.type == NewMarchType.MONSTER_SIEGE)
        {
            return false;
        }

        if (march.ownerUid.IsNullOrEmpty())
        {
            return false;
        }
        if (march.ownerUid == GameEntry.Data.Player.Uid)
        {
            return true;
        }
        var teamUuid = march.teamUuid;
        if (teamUuid <= 0)
        {
            return false;
        }
        string allianceId = GameEntry.Data.Player.GetAllianceId();
        var selfMarchList = GetOwnerMarches(GameEntry.Data.Player.Uid, allianceId);
        if (selfMarchList != null)
        {
            foreach (var VARIABLE in selfMarchList)
            {
                if (teamUuid == VARIABLE.teamUuid)
                {
                    return true;
                }
            }
        }

        return false;
    }
    public WorldMarch GetMarch(long uuid)
    {
        WorldMarch march;
        allMarches.TryGetValue(uuid, out march);
        if (march == null)
        {
            ownerMarches.TryGetValue(uuid, out march);
        }
        return march;
    }
    public List<WorldMarch> GetOwnerMarches(string ownerUid,string allianceUid="")
    {
        var list = new List<WorldMarch>();
        list.AddRange(ownerMarches.Values);
        if (!allianceUid.IsNullOrEmpty()&&allianceMarches.ContainsKey(allianceUid))//从集结编队中找到自己为发起者的编队
        {
            var temp = allianceMarches[allianceUid];
            foreach (var VARIABLE in temp)
            {
                if (VARIABLE.ownerUid == ownerUid )
                {
                    
                    list.Add(VARIABLE);
                }
            }
        }
        return list;
    }
    public WorldMarch GetAllianceMarchesInTeam(string allianceUid,long teamUuid)//找出加入的联盟集结部队
    {
        if (!allianceUid.IsNullOrEmpty() && allianceMarches.ContainsKey(allianceUid))
        {
            foreach (var VARIABLE in allianceMarches[allianceUid])
            {
                if (VARIABLE.teamUuid == teamUuid)
                {
                    return VARIABLE;
                }
            
            }
        }
        return null;
    }
    // public List<WorldMarch> GetAllianceMarches(string allianceUid)
    // {
    //     List<WorldMarch> marchList;
    //     allianceMarches.TryGetValue(allianceUid, out marchList);
    //     return marchList;
    // }

    public WorldMarch GetOwnerFormationMarch(string ownerUid, long formationUuid, string allianceUid ="")
    {
        var list = GetOwnerMarches(ownerUid,allianceUid);
        if (list == null)
            return null;
        return list.Find(m => m.ownerFormationUuid == formationUuid);
    }

    public void RemoveOwnerMarches(string ownerUid)
    {
        foreach (var march in ownerMarches)
        {
            allMarches.Remove(march.Value.uuid);
            world.DestroyTroop(march.Value.uuid);
            world.DestroyTroopLine(march.Value.uuid);
        }
    }

    // 目标类型|目标点|目标uuid|集结时间index/行军uuid/编队uuid/自动返回/英雄&&士兵结构
    public void StartMarch(int targetType, int targetPoint, long targetUuid, int timeIndex, long marchUuid =0,long formationUuid=0, int backHome = 1,byte[] sfsObjBinary=null,int startPos = 0,int targetServerId = -1)
    {

        if (targetType == (int)MarchTargetType.COLLECT)
        {
            GameEntry.Event.Fire(EventId.UIMAIN_VISIBLE, true);
            world.AutoLookat(SceneManager.World.CurTarget, SceneManager.World.InitZoom, GameDefines.LookAtFocusTime);
        }

        if (formationUuid!=0)
        {
            string allianceId = GameEntry.Data.Player.GetAllianceId();
            var march = GetOwnerFormationMarch(GameEntry.Data.Player.Uid, formationUuid, allianceId);
            if (march != null)
            {
                SendChangeMarchToServer(march.uuid, targetType, targetPoint, targetUuid,backHome==1,targetServerId);
            }
            else
            {
                SFSObject formationData = null;
                if (sfsObjBinary != null)
                {
                    formationData = SFSObject.NewFromBinaryData(new Sfs2X.Util.ByteArray(sfsObjBinary));
                }
                SendCreateMarchToServer(formationUuid, targetType, targetPoint, targetUuid, timeIndex,formationData,startPos,backHome==1,targetServerId);
            }
        }
        else if (marchUuid != 0)
        {
            SendChangeMarchToServer(marchUuid, targetType, targetPoint, targetUuid,backHome==1,targetServerId);
        }
    }

    private static Vector2Int GetAttackPos(Vector2Int start, Vector2Int end,float attackOffsetRange)
    {
        float ATTACK_OFFSET_RANGE = attackOffsetRange;
        float dist = Vector2Int.Distance(start, end);
        float percent = 1 - ATTACK_OFFSET_RANGE / dist;
        return new Vector2Int(Mathf.RoundToInt((end.x - start.x) * percent + start.x), Mathf.RoundToInt((end.y - start.y) * percent + start.y));
    }
    
    private void SendCreateMarchToServer(long formationUuid, int targetType, int targetPoint, long targetUuid, int timeIndex,SFSObject formationData,int startPos, bool backHome =true,int targetServerId = -1)
    {
        var posStart = startPos;
        if (startPos <= 0)
        {
            // var buildingData = GameEntry.Lua.CallWithReturn<LuaBuildData, int>(
            //     "CSharpCallLuaInterface.GetBuildingDataByBuildId", GameDefines.BuildingTypes.FUN_BUILD_MAIN);
            
            var buildingData = GameEntry.Data.Building.GetBuildingDataByBuildId(GameDefines.BuildingTypes.FUN_BUILD_MAIN);
            if (buildingData != null)
            {
                posStart = buildingData.pointId;
            }
        }
        int waitTimeIndex = timeIndex;
        var start = world.IndexToTilePos(posStart);
        var end = world.IndexToTilePos(targetPoint);
        if (targetType == (int)MarchTargetType.ATTACK_ARMY
            || targetType == (int)MarchTargetType.ATTACK_MONSTER
            || targetType == (int)MarchTargetType.ATTACK_BUILDING
            || targetType == (int)MarchTargetType.EXPLORE
            || targetType == (int)MarchTargetType.SAMPLE
            || targetType == (int)MarchTargetType.PICK_GARBAGE)
            // || targetType == (int)MarchTargetType.GOLLOES_EXPLORE)
        {
            end = GetAttackPos(start, end,3.0f);
        }
        else if (targetType == (int)MarchTargetType.RALLY_FOR_BOSS)
        {
            end = GetAttackPos(start, end,3.0f);
        }else if (targetType == (int)MarchTargetType.ATTACK_ALLIANCE_CITY ||
                  targetType == (int)MarchTargetType.RALLY_FOR_ALLIANCE_CITY || targetType == (int)MarchTargetType.RALLY_THRONE)
        {
            var tempEnd = end + new Vector2Int(-3, -3);
            end = GetAttackPos(start, tempEnd,5.0f);
        }
        string pathStr = WorldPathfinding.PathToString(new List<Vector2Int>{start, end});
        // WorldMarchFormationMessage.Instance.Send(new WorldMarchFormationMessage.Request()
        // {
        //     formationUuid = formationUuid,
        //     path = pathStr,
        //     targetUid = targetUuid,
        //     worldId = 0,
        //     target = targetType,
        //     waitTimeIndex = waitTimeIndex,
        //     autoBackHome = backHome,
        //     formationParam = formationData,
        //     targetServerId = targetServerId
        // });
        /*
        SceneManager.World.FindPath(start, end, path =>
        {
            string pathStr = WorldPathfinding.PathToString(path);
            WorldMarchFormationMessage.Instance.Send(new WorldMarchFormationMessage.Request()
            {
                formationUuid = formationUuid,
                path = pathStr,
                targetUid = targetUuid,
                worldId = 0,
                target = targetType,
                waitTimeIndex = waitTimeIndex,
                autoBackHome = backHome,
                formationParam = formationData,
            });
            
        });
        */
    }
    private void SendChangeMarchToServer(long marchUuid, int targetType, int targetPoint, long targetUuid,bool backHome =true,int targetServerId = -1)
    {
        var marchInfo = GetMarch(marchUuid);
        if (marchInfo == null)
        {
            return;
        }

        var posStart = 0;
        if (marchInfo.status == MarchStatus.COLLECTING || marchInfo.status == MarchStatus.ASSISTANCE)
        {
            posStart = marchInfo.targetPos;
            if (marchInfo.status == MarchStatus.COLLECTING)
            {
                
            }
        }
        else
        {
            posStart = world.WorldToTileIndex(marchInfo.position);
        }
        
        
        var start = world.IndexToTilePos(posStart);
        var end = world.IndexToTilePos(targetPoint);
        
        if (targetType == (int)MarchTargetType.ATTACK_ARMY
            || targetType == (int)MarchTargetType.ATTACK_MONSTER
            || targetType == (int)MarchTargetType.ATTACK_BUILDING
            || targetType == (int)MarchTargetType.EXPLORE
            || targetType == (int)MarchTargetType.SAMPLE
            || targetType == (int)MarchTargetType.PICK_GARBAGE)
            // || targetType == (int)MarchTargetType.GOLLOES_EXPLORE)
        {
            end = GetAttackPos(start, end,3.0f);
        }
        else if (targetType == (int)MarchTargetType.RALLY_FOR_BOSS)
        {
            end = GetAttackPos(start, end,3.0f);
        }
        else if (targetType == (int)MarchTargetType.ATTACK_ALLIANCE_CITY ||
                 targetType == (int)MarchTargetType.RALLY_FOR_ALLIANCE_CITY|| targetType == (int)MarchTargetType.RALLY_THRONE)
        {
            var tempEnd = end + new Vector2Int(-3, -3);
            end = GetAttackPos(start, tempEnd,5.0f);
        }
        string pathStr = WorldPathfinding.PathToString(new List<Vector2Int>{start, end});
        // WorldMarchFormationChangeMessage.Instance.Send(new WorldMarchFormationChangeMessage.Request()
        // {
        //     uuid = marchUuid,
        //     path = pathStr,
        //     targetUid = targetUuid,
        //     worldId = 0,
        //     target = targetType,
        //     autoBackHome = backHome,
        //     targetServerId = targetServerId
        // });
        /*
        SceneManager.World.FindPath(start, end, path =>
        {
            string pathStr = WorldPathfinding.PathToString(path);
            WorldMarchFormationChangeMessage.Instance.Send(new WorldMarchFormationChangeMessage.Request()
            {
                uuid = marchUuid,
                path = pathStr,
                targetUid = targetUuid,
                worldId = 0,
                target = targetType,
                autoBackHome = backHome
            });
            
        });
        */
    }
    private void UpdateTaskList()
    {
        while (parseDataTasks.Count > 0)
        {
            var task = parseDataTasks.Peek();
            if (!task.isDone)
                break;

            parseDataTasks.Dequeue();
            ProcessDoneTask(task);
        }
    }

    private bool NeedGetRealTargetPos(WorldMarch march)
    {
        if (march.target == MarchTargetType.ATTACK_BUILDING || march.target == MarchTargetType.ATTACK_CITY || march.target == MarchTargetType.RALLY_FOR_CITY)
        {
            return true;
        }

        if (march.target == MarchTargetType.ATTACK_ALLIANCE_BUILDING ||
            march.target == MarchTargetType.RALLY_ALLIANCE_BUILDING ||
            march.target == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE||
            march.target == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE||
            march.target == MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE||
            march.target == MarchTargetType.ATTACK_DRAGON_BUILDING||
            march.target == MarchTargetType.TRIGGER_DRAGON_BUILDING||
            march.target == MarchTargetType.TAKE_SECRET_KEY||
            march.target == MarchTargetType.TRANSPORT_SECRET_KEY||
            march.target == MarchTargetType.RALLY_DRAGON_BUILDING||
            march.target == MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING||
            march.target == MarchTargetType.RALLY_CROSS_THRONE_BUILDING||
            march.target == MarchTargetType.ASSISTANCE_DRAGON_BUILDING||
            march.target == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING)
        {
            return true;
        }
        if (march.target == MarchTargetType.ATTACK_ARMY ||
            march.target == MarchTargetType.ATTACK_MONSTER ||
            march.target == MarchTargetType.RALLY_FOR_BOSS ||
            march.target == MarchTargetType.ATTACK_ALLIANCE_BOSS||
            march.target == MarchTargetType.EXPLORE ||
            march.target == MarchTargetType.SAMPLE ||
            march.target == MarchTargetType.PICK_GARBAGE || march.target == MarchTargetType.RALLY_FOR_BUILDING || march.target == MarchTargetType.ATTACK_DESERT || march.target == MarchTargetType.TRAIN_DESERT)
        {
            return true;
        }
        if (march.target == MarchTargetType.ASSISTANCE_DESERT ||
            march.target == MarchTargetType.ASSISTANCE_CITY ||
            march.target == MarchTargetType.ASSISTANCE_BUILD )
        {
            return true;
        }
        return false;
    }
    
    private int GetRealMarchTargetPos(WorldMarch march)
    {
        if (march.target == MarchTargetType.ATTACK_BUILDING|| march.target == MarchTargetType.RALLY_FOR_BUILDING || march.target == MarchTargetType.ASSISTANCE_BUILD)
        {
            var info = world.GetPointInfoByUuid(march.targetUuid);
            if (info != null && info.pointType == WorldPointType.PlayerBuilding)
            {
                return info.mainIndex;
            }
        }
        if (march.target == MarchTargetType.ATTACK_ALLIANCE_BUILDING|| march.target == MarchTargetType.RALLY_ALLIANCE_BUILDING || march.target == MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING || march.target == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE||
            march.target == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE||
            march.target == MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE)
        {
            var info = world.GetPointInfoByUuid(march.targetUuid);
            if (info != null && info.pointType == WorldPointType.WORLD_ALLIANCE_BUILD)
            {
                var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",info.mainIndex);
                if (tile <= 1)
                {
                    tile = 1;
                }
                var centerIndex =
                    GameEntry.Lua.CallWithReturn<int, int, int>("CSharpCallLuaInterface.GetBuildModelCenter",
                        info.mainIndex, tile);
                return centerIndex;
            }
        }
        if (march.target == MarchTargetType.ATTACK_DRAGON_BUILDING || march.target == MarchTargetType.RALLY_DRAGON_BUILDING || march.target == MarchTargetType.TAKE_SECRET_KEY || march.target == MarchTargetType.TRANSPORT_SECRET_KEY || march.target == MarchTargetType.TRIGGER_DRAGON_BUILDING)
        {
            var info = world.GetPointInfoByUuid(march.targetUuid);
            if (info != null && info.pointType == WorldPointType.DRAGON_BUILDING)
            {
                var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",info.mainIndex);
                if (tile <= 1)
                {
                    tile = 1;
                }
                var centerIndex =
                    GameEntry.Lua.CallWithReturn<int, int, int>("CSharpCallLuaInterface.GetBuildModelCenter",
                        info.mainIndex, tile);
                return centerIndex;
            }
        }
        if (march.target == MarchTargetType.ASSISTANCE_CROSS_THRONE_BUILDING || march.target == MarchTargetType.RALLY_CROSS_THRONE_BUILDING || march.target == MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING)
        {
            var info = world.GetPointInfoByUuid(march.targetUuid);
            if (info != null && info.pointType == WorldPointType.CROSS_THRONE_BUILD)
            {
                var tile = GameEntry.Lua.CallWithReturn<int,int>("CSharpCallLuaInterface.GetWorldPointTileSize",info.mainIndex);
                if (tile <= 1)
                {
                    tile = 1;
                }
                var centerIndex =
                    GameEntry.Lua.CallWithReturn<int, int, int>("CSharpCallLuaInterface.GetBuildModelCenter",
                        info.mainIndex, tile);
                return centerIndex;
            }
        }
        else if (march.target == MarchTargetType.ATTACK_CITY || march.target == MarchTargetType.RALLY_FOR_CITY || march.target == MarchTargetType.ASSISTANCE_CITY)
        {
            var info = world.GetPointInfoByUuid(march.targetUuid);
            if (info != null && info.pointType == WorldPointType.PlayerBuilding)
            {
                var centerIndex =
                    GameEntry.Lua.CallWithReturn<int, int, int>("CSharpCallLuaInterface.GetBuildModelCenter",
                        info.mainIndex, info.tileSize);
                return centerIndex;
            }
        }
        else if (march.target == MarchTargetType.ATTACK_ARMY ||
                 march.target == MarchTargetType.ATTACK_MONSTER ||
                 march.target == MarchTargetType.ATTACK_ALLIANCE_BOSS||
                 march.target == MarchTargetType.RALLY_FOR_BOSS)

        {
            var targetMarch = GetMarch(march.targetUuid);
            if (targetMarch != null)
            {
                return world.WorldToTileIndex(targetMarch.position);
            }
        }
        else if (march.target == MarchTargetType.EXPLORE ||
                 march.target == MarchTargetType.SAMPLE ||
                 march.target == MarchTargetType.PICK_GARBAGE)

        {
            var pointInfo = world.GetPointInfoByUuid(march.targetUuid);
            if (pointInfo != null)
            {
                return pointInfo.pointIndex;
            }
        }
        else if (march.target == MarchTargetType.ATTACK_DESERT || march.target == MarchTargetType.TRAIN_DESERT || march.target == MarchTargetType.ASSISTANCE_DESERT)
        {
            var pointId = (int) march.targetUuid;
            var tileCount = world.TileCount;
            if (pointId > 0 && pointId < tileCount.x * tileCount.y)
            {
                return pointId;
            }

        }
        else if (march.target == MarchTargetType.GOLLOES_EXPLORE)
        {
            return (int)march.targetUuid;
        }
        return 0;
    }

    private void UpdateMove(float deltaTime)
    {
        foreach (var i in allMarches)
        {
            var march = i.Value;
            
            // 移动
            march.UpdateMove(deltaTime);
            
            // 进入/离开视口时，创建/销毁行军车
            if (IsInView(march.position) && march.IsVisibleMarch())
            {
                if (!world.IsTroopCreate(march.uuid))
                {
                    world.CreateTroop(march);
                }
            }
            else
            {
                if (world.IsTroopCreate(march.uuid))
                {
                    world.DestroyTroop(march.uuid);
                }
            }

            if (IsLineInView(march.pathList,march.pathIndex,march.position) && march.IsVisibleMarch())
            {
                if (!world.IsTroopLineCreate(march.uuid))
                {
                    world.CreateTroopLine(march);
                }
            }
            else
            {
                if (world.IsTroopLineCreate(march.uuid))
                {
                    world.DestroyTroopLine(march.uuid);
                }
            }
            
            // 更新行军线的显示
            bool needRefresh = false;
            if (NeedGetRealTargetPos(march) && march.realTargetPos <= 0)
            {
                march.realTargetPos = GetRealMarchTargetPos(march);
                if (march.realTargetPos > 0)
                {
                    needRefresh = true;
                }
            }

            var position = march.position;
            var troop = world.GetTroop(march.uuid);
            if (troop != null)
            {
                position = troop.GetPosition();
            }
            world.UpdateTroopLine(march, march.pathList, march.pathIndex, position, march.realTargetPos, needRefresh, false);
        }
    }

    private void UpdateVisibleTroop(WorldMarch march)
    {
        if (march.IsVisibleMarch())
        {
            if (IsInView(march.position) && world.IsTroopCreate(march.uuid))
            {
                world.UpdateTroop(march);
            }
            if (IsLineInView(march.pathList,march.pathIndex,march.position) && world.IsTroopLineCreate(march.uuid))
            {
                world.CreateTroopLine(march);
            }
        }
    }

    private void ProcessDoneTask(ParseDataTask task)
    {
        var updateSelfMarch = false;
        var updateTargetMineMarch = false;
        var updateDragonMarch = false;
        var updateMarchList = new Dictionary<long, WorldMarch>();
        var needRemoveMarchData = new List<long>();
        if (task.taskType == ParseDataTask.TaskType.WorldMarchGet)//自己的行军在这个地方不做刷新
        {
            // ownerMarches.Clear(); //跨服时，服务器不会发送原服玩家行军数据，这个地方需要客户端单独存储原服数据，跨服获取时不删除
            allianceMarches.Clear();
            var temp = allMarches;
            allMarches = tempAllMarches;
            tempAllMarches = temp;
            RallyMarchDic.Clear();
            dragonMarches.Clear();
            foreach (var march in task.marchList)
            {
                if (IsVisibleToLocalPlayer(march))
                {
                    var oldmarch = GetMarch(march.uuid);
                    if (oldmarch != null)
                    {
                        if (updateTargetMineMarch == false)
                        {
                            if (IsTargetForMine(oldmarch))
                            {
                                updateTargetMineMarch = true;
                            }
                        }

                        if (updateDragonMarch == false)
                        {
                            if (oldmarch.secretKey != march.secretKey)
                            {
                                updateDragonMarch = true;
                            }
                        }
                        
                    }
                    AddOrUpdateMarch(march);
                    if (march.secretKey > 0)
                    {
                        dragonMarches.Add(march.uuid,march);
                        if (updateDragonMarch == false)
                        {
                            updateDragonMarch = true;
                        }
                    }
                    
                    if (world.IsTroopCreate(march.uuid))
                        world.UpdateTroop(march);
                    if (world.IsTroopLineCreate(march.uuid))
                        world.CreateTroopLine(march);
                    if (updateSelfMarch == false)
                    {
                        if (march.ownerUid == GameEntry.Data.Player.Uid)
                        {
                            updateSelfMarch = true;
                        }
                        else if (march.type == NewMarchType.ASSEMBLY_MARCH)
                        {
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            if ((!allianceId.IsNullOrEmpty()) && march.allianceUid == allianceId)
                            {
                                updateSelfMarch = true;
                            }
                        }
                    }

                    if (updateTargetMineMarch == false)
                    {
                        if (IsTargetForMine(march))
                        {
                            updateTargetMineMarch = true;
                        }
                    }
                }

                if (march.type == NewMarchType.ASSEMBLY_MARCH && march.target == MarchTargetType.RALLY_THRONE&& march.status == MarchStatus.WAIT_THRONE && march.inBattle ==false)
                {
                    RallyMarchDic.Add(march.uuid,march);
                }
                
            }

            UpdateSortRallyMarch();
            // 旧数据对比新数据，把多的行军删除
            foreach (var i in tempAllMarches)
            {
                if (IsFakeSampleMarchData(i.Key))
                {
                    allMarches[i.Key] = i.Value;
                    continue;
                }
                if (!allMarches.ContainsKey(i.Key))
                {
                    if (updateSelfMarch == false)
                    {
                        if (i.Value.ownerUid == GameEntry.Data.Player.Uid)
                        {
                            updateSelfMarch = true;
                        }
                        else if (i.Value.type == NewMarchType.ASSEMBLY_MARCH)
                        {
                            var allianceId = GameEntry.Data.Player.GetAllianceId();
                            if ((!allianceId.IsNullOrEmpty()) && i.Value.allianceUid == allianceId)
                            {
                                updateSelfMarch = true;
                            }
                        }
                    }

                    if (updateTargetMineMarch == false)
                    {
                        if (IsTargetForMine(i.Value))
                        {
                            updateTargetMineMarch = true;
                        }
                    }

                    if (updateDragonMarch == false)
                    {
                        if (i.Value.secretKey > 0)
                        {
                            updateDragonMarch = true;
                        }
                    }
                    removeList.Add(i.Key);
                }
                    
            }

            foreach (var i in removeList)
            {
                world.DestroyTroop(i);
                world.DestroyTroopLine(i);
            }
            removeList.Clear();
            tempAllMarches.Clear();
            
            // 被覆盖的装饰隐藏
            UpdateOccupyPoints(tempAllMarches, allMarches);
        }
        else if (task.taskType == ParseDataTask.TaskType.PushMarchAdd)
        {
            foreach (var march in task.marchList)
            {
                if (!IsVisibleToLocalPlayer(march))
                {
                    //Log.Debug("PushMarchAdd skip " + march.uuid);
                    continue;
                }
                var isTargetSelf = IsTargetForMine(march);
                var oldmarch = GetMarch(march.uuid);
                if (oldmarch != null)
                {
                    if (updateDragonMarch == false)
                    {
                        if (oldmarch.secretKey != march.secretKey)
                        {
                            updateDragonMarch = true;
                        }

                        if (IsTargetForMine(oldmarch) != isTargetSelf)
                        {
                            if (isTargetSelf == true)
                            {
                                updateMarchList[march.uuid] = march;
                            }
                            else
                            {
                                needRemoveMarchData.Add(march.uuid);
                            }
                        }
                    }

                }
                else
                {
                    if (isTargetSelf == true)
                    {
                        updateMarchList[march.uuid] = march;
                    }
                }
                AddOrUpdateMarch(march);
                if (march.secretKey > 0)
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches[march.uuid] = march;
                    }
                    else
                    {
                        dragonMarches.Add(march.uuid,march);
                    }
                    
                    if (updateDragonMarch == false)
                    {
                        updateDragonMarch = true;
                    }
                }
                else
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches.Remove(march.uuid);
                        
                        if (updateDragonMarch == false)
                        {
                            updateDragonMarch = true;
                        }
                    }
                }
                UpdateVisibleTroop(march);
                
                if (march.type == NewMarchType.MONSTER || march.type == NewMarchType.BOSS)
                {
                    world.AddOccupyPoints(world.IndexToTilePos(march.targetPos), Vector2Int.one);
                }
                
                if (updateSelfMarch == false)
                {
                    if (march.ownerUid == GameEntry.Data.Player.Uid)
                    {
                        updateSelfMarch = true;
                    }
                    else if (march.type == NewMarchType.ASSEMBLY_MARCH)
                    {
                        var allianceId = GameEntry.Data.Player.GetAllianceId();
                        if ((!allianceId.IsNullOrEmpty()) && march.allianceUid == allianceId)
                        {
                            updateSelfMarch = true;
                        }
                    }
                }
                
                if (march.type == NewMarchType.ASSEMBLY_MARCH && march.target == MarchTargetType.RALLY_THRONE&& march.status == MarchStatus.WAIT_THRONE && march.inBattle ==false)
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic[march.uuid] = march;
                    }
                    else
                    {
                        RallyMarchDic.Add(march.uuid,march);
                    }
                    
                    UpdateSortRallyMarch();
                }
                else
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic.Remove(march.uuid);
                        UpdateSortRallyMarch();
                    }
                    
                }
            }
        }
        else if (task.taskType == ParseDataTask.TaskType.PushMarchDel)
        {
            world.DestroyTroop(task.marchUuid, task.isBattleFail);
            world.DestroyTroopLine(task.marchUuid);
            WorldMarch march;
            if (allMarches.TryGetValue(task.marchUuid, out march))
            {
                if (updateSelfMarch == false)
                {
                    if (march.ownerUid == GameEntry.Data.Player.Uid)
                    {
                        updateSelfMarch = true;
                    }
                    else if (march.type == NewMarchType.ASSEMBLY_MARCH)
                    {
                        var allianceId = GameEntry.Data.Player.GetAllianceId();
                        if ((!allianceId.IsNullOrEmpty()) && march.allianceUid == allianceId)
                        {
                            updateSelfMarch = true;
                        }
                    }
                }

                if (IsTargetForMine(march))
                {
                    needRemoveMarchData.Add(march.uuid);
                }
                
                if (march.type == NewMarchType.MONSTER || march.type == NewMarchType.BOSS)
                {
                    world.RemoveOccupyPoints(world.IndexToTilePos(march.targetPos), Vector2Int.one);
                }
                if (RallyMarchDic.ContainsKey(march.uuid))
                {
                    RallyMarchDic.Remove(march.uuid);
                    UpdateSortRallyMarch();
                }

                if (dragonMarches.ContainsKey(march.uuid))
                {
                    dragonMarches.Remove(march.uuid);
                    updateDragonMarch = true;
                }
            }
            
            RemoveMarch(task.marchUuid);
        }
        else if (task.taskType == ParseDataTask.TaskType.FormationMarch)
        {
            // 出征
            foreach (var march in task.marchList)
            {
                if (!IsVisibleToLocalPlayer(march))
                {
                    //Log.Debug("FormationMarch skip " + march.uuid);
                    continue;
                }
                var isTargetSelf = IsTargetForMine(march);
                var oldmarch = GetMarch(march.uuid);
                if (oldmarch != null)
                {
                    if (updateDragonMarch == false)
                    {
                        if (oldmarch.secretKey != march.secretKey)
                        {
                            updateDragonMarch = true;
                        }
                    }
                    if (IsTargetForMine(oldmarch) != isTargetSelf)
                    {
                        if (isTargetSelf == true)
                        {
                            updateMarchList[march.uuid] = march;
                        }
                        else
                        {
                            needRemoveMarchData.Add(march.uuid);
                        }
                    }
                }
                else
                {
                    if (isTargetSelf == true)
                    {
                        updateMarchList[march.uuid] = march;
                    }
                }
                AddOrUpdateMarch(march);
                if (march.secretKey > 0)
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches[march.uuid] = march;
                    }
                    else
                    {
                        dragonMarches.Add(march.uuid,march);
                    }
                    
                    if (updateDragonMarch == false)
                    {
                        updateDragonMarch = true;
                    }
                }
                else
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches.Remove(march.uuid);
                        
                        if (updateDragonMarch == false)
                        {
                            updateDragonMarch = true;
                        }
                    }
                }
                UpdateVisibleTroop(march);
                if (updateSelfMarch == false)
                {
                    if (march.ownerUid == GameEntry.Data.Player.Uid)
                    {
                        updateSelfMarch = true;
                    }
                    else if (march.type == NewMarchType.ASSEMBLY_MARCH)
                    {
                        var allianceId = GameEntry.Data.Player.GetAllianceId();
                        if ((!allianceId.IsNullOrEmpty()) && march.allianceUid == allianceId)
                        {
                            updateSelfMarch = true;
                        }
                    }
                }
                if (march.type == NewMarchType.ASSEMBLY_MARCH && march.target == MarchTargetType.RALLY_THRONE&& march.status == MarchStatus.WAIT_THRONE && march.inBattle ==false)
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic[march.uuid] = march;
                    }
                    else
                    {
                        RallyMarchDic.Add(march.uuid,march);
                    }
                    
                    UpdateSortRallyMarch();
                }
                else
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic.Remove(march.uuid);
                        UpdateSortRallyMarch();
                    }
                    
                }
            }
        }
        else if (task.taskType == ParseDataTask.TaskType.FormationMarchChange)
        {
            // 更改出征目标
            foreach (var march in task.marchList)
            {
                if (!IsVisibleToLocalPlayer(march))
                {
                    //Log.Debug("FormationMarchChange skip " + march.uuid);
                    continue;
                }
                var isTargetSelf = IsTargetForMine(march);
                var oldmarch = GetMarch(march.uuid);
                if (oldmarch != null)
                {
                    if (IsTargetForMine(oldmarch) != isTargetSelf)
                    {
                        if (isTargetSelf == true)
                        {
                            updateMarchList[march.uuid] = march;
                        }
                        else
                        {
                            needRemoveMarchData.Add(march.uuid);
                        }
                    }
                    if (updateDragonMarch == false)
                    {
                        if (oldmarch.secretKey != march.secretKey)
                        {
                            updateDragonMarch = true;
                        }
                    }
                }
                else
                {
                    if (isTargetSelf == true)
                    {
                        updateMarchList[march.uuid] = march;
                    }
                }
                AddOrUpdateMarch(march);
                if (march.secretKey > 0)
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches[march.uuid] = march;
                    }
                    else
                    {
                        dragonMarches.Add(march.uuid,march);
                    }
                    
                    if (updateDragonMarch == false)
                    {
                        updateDragonMarch = true;
                    }
                }
                else
                {
                    if (dragonMarches.ContainsKey(march.uuid))
                    {
                        dragonMarches.Remove(march.uuid);
                        
                        if (updateDragonMarch == false)
                        {
                            updateDragonMarch = true;
                        }
                    }
                }
                UpdateVisibleTroop(march);
                if (updateSelfMarch == false)
                {
                    if (march.ownerUid == GameEntry.Data.Player.Uid)
                    {
                        updateSelfMarch = true;
                    }
                    else if (march.type == NewMarchType.ASSEMBLY_MARCH)
                    {
                        var allianceId = GameEntry.Data.Player.GetAllianceId();
                        if ((!allianceId.IsNullOrEmpty()) && march.allianceUid == allianceId)
                        {
                            updateSelfMarch = true;
                        }
                    }
                }

                if (updateTargetMineMarch == false)
                {
                    if (IsTargetForMine(march))
                    {
                        updateTargetMineMarch = true;
                    }
                }
                if (march.type == NewMarchType.ASSEMBLY_MARCH && march.target == MarchTargetType.RALLY_THRONE&& march.status == MarchStatus.WAIT_THRONE && march.inBattle ==false)
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic[march.uuid] = march;
                    }
                    else
                    {
                        RallyMarchDic.Add(march.uuid,march);
                    }
                    
                    UpdateSortRallyMarch();
                }
                else
                {
                    if (RallyMarchDic.ContainsKey(march.uuid))
                    {
                        RallyMarchDic.Remove(march.uuid);
                        UpdateSortRallyMarch();
                    }
                    
                }
            }
        }
        if (updateSelfMarch == true)
        {
            GameEntry.Event.Fire(EventId.MarchItemUpdateSelf);
        }

        if (updateMarchList.Count > 0 || needRemoveMarchData.Count > 0)
        {
            updateTargetMineMarch = true;
            GameEntry.Lua.Call("CSharpCallLuaInterface.WorldMarchTargetMineDataUpdate",updateMarchList,needRemoveMarchData);
        }
        if (updateTargetMineMarch == true && UseNewAlarmSystem==false)
        {
             GameEntry.Event.Fire(EventId.MarchItemTargetMeUpdate);
        }

        if (updateDragonMarch == true)
        {
            GameEntry.Event.Fire(EventId.DragonSecretShow);
        }
        GameEntry.Event.Fire(EventId.UpdateMarchItem);
    }

    private void UpdateSortRallyMarch()
    {
        SortRallyMarchDic.Clear();
        if (RallyMarchDic.Count > 0)
        {
            var tempSortList = RallyMarchDic.OrderBy(o => o.Value.startTime).ToDictionary(p => p.Key, o => o.Value);
            var index = 0;
            foreach (var VARIABLE in tempSortList)
            {
                index++;
                SortRallyMarchDic[VARIABLE.Key] = index;
            }

        }
    }

    public int GetRallyMarchIndexByUuid(long uuid)
    {
        if (SortRallyMarchDic.ContainsKey(uuid))
        {
            return SortRallyMarchDic[uuid];
        }

        return -1;
    }

    public Dictionary<long,WorldMarch> GetDragonMarch()
    {
        return dragonMarches;
    }
    private void UpdateOccupyPoints(Dictionary<long, WorldMarch> oldData, Dictionary<long, WorldMarch> newData)
    {
        foreach (var n in newData)
        {
            var marchUuid = n.Key;
            var march = n.Value;
            if (!oldData.ContainsKey(marchUuid) && IsVisibleToLocalPlayer(march)
                && (march.type == NewMarchType.BOSS || march.type == NewMarchType.MONSTER))
            {
                world.AddOccupyPoints(world.IndexToTilePos(march.targetPos), Vector2Int.one);
            }
        }
        
        foreach (var n in oldData)
        {
            var marchUuid = n.Key;
            var march = n.Value;
            if (!newData.ContainsKey(marchUuid) && IsVisibleToLocalPlayer(march)
                                                && (march.type == NewMarchType.BOSS || march.type == NewMarchType.MONSTER))
            {
                world.RemoveOccupyPoints(world.IndexToTilePos(march.targetPos), Vector2Int.one);
            }
        }
    }

    // 对玩家是否可见，属于指定玩家的March，只对该玩家可见，其他人看不见
    private bool IsVisibleToLocalPlayer(WorldMarch march)
    {
        
        if (march.type == NewMarchType.MONSTER || march.type == NewMarchType.BOSS)
        {
            if (!string.IsNullOrEmpty(march.belongUid))
            {
                if (march.belongUid == GameEntry.Data.Player.Uid)
                {
                    return true;
                }
                
            }

            return true;

        }
        else
        {
            return true;
        }

        return false;
    }

    private void AddOrUpdateMarch(WorldMarch march)
    {
        allMarches[march.uuid] = march;
        
        if (march.type == NewMarchType.NORMAL || march.type == NewMarchType.DIRECT_MOVE_MARCH || march.type == NewMarchType.SCOUT || march.type == NewMarchType.EXPLORE
            || march.type == NewMarchType.RESOURCE_HELP || march.type == NewMarchType.GOLLOES_EXPLORE ||
            march.type == NewMarchType.GOLLOES_TRADE)
        {

            if (march.ownerUid == GameEntry.Data.Player.Uid)
            {
                ownerMarches[march.uuid] = march;
            }
            
            List<WorldMarch> marchList;
            if (allianceMarches.TryGetValue(march.allianceUid, out marchList))
            {
                marchList.RemoveAll(i => i.uuid == march.uuid);
            }
        }

        else if (march.type == NewMarchType.ASSEMBLY_MARCH)
        {
            List<WorldMarch> marchList;
            if (!allianceMarches.TryGetValue(march.allianceUid, out marchList))
            {
                marchList = new List<WorldMarch>();
                allianceMarches.Add(march.allianceUid, marchList);
            }

            int idx = marchList.FindIndex(i => i.uuid == march.uuid);
            if (idx != -1)
            {
                marchList[idx] = march;
            }
            else
            {
                marchList.Add(march);
            }

            ownerMarches.Remove(march.uuid);
        }
        march.InitMove(CreatePathSegment(march));
    }
    
    private WorldTroopPathSegment[] CreatePathSegment(WorldMarch march)
    {
        if (march.status != MarchStatus.MOVING
            && march.status != MarchStatus.BACK_HOME
            && march.status != MarchStatus.CHASING
            && march.status != MarchStatus.IN_WORM_HOLE)
        {
            return null;
        }
        
        var path = march.path;
        if (path.Length < 2)
        {
            return null;
        }
        
        var pathList = new WorldTroopPathSegment[path.Length];
        for (int i = 0; i < pathList.Length; i++)
        {
            pathList[i] = new WorldTroopPathSegment();
            if (i < pathList.Length - 1)
            {
                var curPos = world.TileIndexToWorld(path[i]);
                var nextPos = world.TileIndexToWorld(path[i + 1]);
                    
                var pathVec = nextPos - curPos;
                pathList[i].pos = curPos;
                pathList[i].dir = pathVec.normalized;
                pathList[i].dist = pathVec.magnitude;
            }
            else
            {
                pathList[i].pos = world.TileIndexToWorld(path[i]);
                pathList[i].dir = pathList[i - 1].dir;
                pathList[i].dist = float.MaxValue;
            }
        }

        return pathList;
    }
    


    //获取MarchBoss信息
    public Dictionary<long, WorldMarch> GetMarchesBossInfo()
    {
        Dictionary<long, WorldMarch> marchesList = new Dictionary<long, WorldMarch>();

        foreach (var item in allMarches)
        {
            if (item.Value.type == NewMarchType.BOSS)
            {
               marchesList.Add(item.Key, item.Value);
            }
        }
        if (marchesList != null)
        {
            return marchesList;
        }
        return null;
    }

    public Dictionary<long, WorldMarch> GetMarchesTargetForMine()
    {
        Dictionary<long, WorldMarch> marchesList = new Dictionary<long, WorldMarch>();
        
        foreach (var item in allMarches)
        {
            if (IsTargetForMine(item.Value))
            {
              // Debug.LogError(item.Value.uuid);
                marchesList.Add(item.Key,item.Value);
            }
        }
       // Debug.LogError(marchesList.Count);
        return marchesList;
    }

    //判断目标是不是自己
    public bool IsTargetForMine(WorldMarch march)
    {
        //  GameEntry.Event.Fire(EventId.UIMainWarningShow,(int)WarningType.Scout);
        LuaBuildData buildingData;
        WorldTileInfo info;
        WorldDesertInfo desertInfo;
        switch (march.target)
        {
            case MarchTargetType.RALLY_FOR_BUILDING: //建筑
            case MarchTargetType.RALLY_FOR_CITY:
            case MarchTargetType.ATTACK_BUILDING:
            case MarchTargetType.DIRECT_ATTACK_CITY:
            case MarchTargetType.SCOUT_BUILDING:
            case MarchTargetType.SCOUT_CITY:
            case MarchTargetType.ATTACK_CITY:
                buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(march.targetUuid);
                if (buildingData != null)
                {
                    return true;
                }
                break;
            
            case MarchTargetType.ATTACK_ARMY: //编队
            case MarchTargetType.ATTACK_ARMY_COLLECT:
            case MarchTargetType.SCOUT_TROOP:
            case MarchTargetType.SCOUT_ARMY_COLLECT:    
                if (IsSelfInCurrentMarchTeam(march.targetUuid))
                {
                    return true;
                }

                break;
            case MarchTargetType.ASSISTANCE_CITY:
            case MarchTargetType.ASSISTANCE_BUILD:

                buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(march.targetUuid);
                if (buildingData != null)
                {
                    return true;
                }

                break;
            case MarchTargetType.SCOUT_DESERT:
            case MarchTargetType.ATTACK_DESERT:
                info = world.GetWorldTileInfo(march.targetUuid.ToInt());
                if (info != null)
                {
                    desertInfo = info.GetWorldDesertInfo();
                    if (desertInfo != null)
                    {
                        if (desertInfo.GetPlayerType() == PlayerType.PlayerSelf)
                        {
                            return true;
                        }
                    }
                }
                break;
            case MarchTargetType.ASSISTANCE_DESERT:

                desertInfo = world.GetDesertInfoByUuid(march.targetUuid);
                if (desertInfo != null)
                {
                    if (desertInfo.GetPlayerType() == PlayerType.PlayerSelf)
                    {
                        return true;
                    }
                }
                break;
        }

        return false;
    }


    private void RemoveMarch(long marchUuid)
    {
        WorldMarch march;
        if (!allMarches.TryGetValue(marchUuid, out march))
        {
            if (!ownerMarches.TryGetValue(marchUuid, out march))
            {
                return;
            }
        }
            

        if (march.ownerUid == GameEntry.Data.Player.Uid)
        {
            GameEntry.Event.Fire(EventId.WorldMarchDelete, marchUuid);
        }

        allMarches.Remove(march.uuid);
        ownerMarches.Remove(march.uuid);
        List<WorldMarch> marchList;
        if (allianceMarches.TryGetValue(march.allianceUid, out marchList))
        {
            marchList.RemoveAll(i => i.uuid == march.uuid);
        }
    }
    
    private class ParseDataTask : IQueuedThreadTask
    {
        public enum TaskType
        {
            WorldMarchGet,
            PushMarchAdd,
            PushMarchDel,
            FormationMarchChange,
            FormationMarch,
        }

        public TaskType taskType;
        public ISFSObject message;
        public List<WorldMarch> marchList = new List<WorldMarch>();
        public long marchUuid;
        public bool isBattleFail;
        public volatile bool isDone;
        
        public void Process()
        {
            try
            {
                if (taskType == TaskType.WorldMarchGet)
                {
                
                    var marchInfoArray = message.GetSFSArray("marchInfos");
                    var startTime = GameEntry.Timer.GetServerTime();
                    Log.Debug("c# parse world march message march counts:{0}",marchInfoArray.Count);
                    for (int i = 0; i < marchInfoArray.Count; i++)
                    {
                        var sfsObj = marchInfoArray.GetSFSObject(i);
                    
                        var march = new WorldMarch();
                        march.UpdateWorldMarch(sfsObj);
                        if (!string.IsNullOrEmpty(march.eventId) && march.belongUid != GameEntry.Data.Player.Uid)
                        {
                            continue;
                        }
                        marchList.Add(march);
                    }
                    var endTime = GameEntry.Timer.GetServerTime();
                    Log.Debug("c# parse world march message deltaTime:{0},startTime={1},endTime={2}", (endTime - startTime),startTime,endTime);
                }
                else if (taskType == TaskType.PushMarchAdd
                         || taskType == TaskType.FormationMarchChange
                         || taskType == TaskType.FormationMarch)
                {
                    var march = new WorldMarch();
                    march.UpdateWorldMarch(message);
                    if (!string.IsNullOrEmpty(march.eventId) && march.belongUid != GameEntry.Data.Player.Uid)
                    {
                        
                    }
                    else
                    {
                        marchList.Add(march);
                    }
                }
                else if (taskType == TaskType.PushMarchDel)
                {
                    marchUuid = message.TryGetLong("uuid");
                    isBattleFail = message.GetBool("isBattleFail");
                }
            }
            catch (Exception e)
            {
                Log.Error(e.Message);
            }

            isDone = true;
        }
    }
}

#endif

public class WorldMarch
{
    public long uuid;//唯一标识
    public string ownerUid;//行军所属玩家
    public string ownerName;//玩家名字
    public long teamUuid;//集结编队uuid
    public string allianceUid;//联盟id 集结用
    public long ownerFormationUuid;//行军编队Uuid
    public string pathStr;
    public int[] path;//存储路径
    public int targetPos;//目的地
    public int startPos;//出发地
    public long startTime;
    public long endTime;
    public long blackStartTime;
    public long blackEndTime;
    public MarchTargetType target;//行军目的类型
    public MarchStatus status = MarchStatus.DEFAULT;//行军状态
    public NewMarchType type = NewMarchType.DEFAULT;//兵种类型
    public long targetUuid;//目的地Uuid
    public float speed;//行进速度
    public float oriSpeed;//原始速度
    public string plunderRes;//资源类型，数量；资源类型，数量；
    public int worldId;
    public float collectSpd;//采集速度
    public long armyWeight;//负重
    public bool inBattle;
    public List<ArmyInfo> armyInfos = new List<ArmyInfo>();//战斗部分部队相关数据
    public int monsterId;
    public long refreshTime;
    public long actStartTime;
    public long actEndTime;
    
    public bool isBroken;
    public Vector2Int stationDir;
    public string allianceAbbr; //联盟简称
    public string allianceName; //联盟名字
    public string allianceIcon; //联盟icon
    public string eventId;//事件id
    public string belongUid; // 怪物所属玩家
    public string pic;//玩家头像
    public int picVer;
    public int serverId;
    public int targetServer;
    public int srcServer;
    public int realTargetPos;
    public bool isSelect;
    public bool isCameraFollow = false;
    public int pathIndex = 0;
    public Vector3 position;
    public Vector3 targetWorldPos;
    public WorldTroopPathSegment[] pathList;
    private float curPathLen;
    private float moveSpeed;
    private Vector3 moveDir;
    public string bossOwnerUid;
    public int callHelp;
    public int secretKey;
    private bool fightMonster;//表示该行军是否已经打过野怪
    public int skinId;
    public long skinExpireTime;
    public bool IsMine()
    {
        return ownerUid == GameEntry.Data.Player.Uid;
    }

    public bool HasFightMonster()
    {
        return fightMonster;
    }
    public bool IsVisibleMarch()
    {
        var curServerId = GameEntry.Data.Player.GetCurServerId();
        if (curServerId>0 && serverId>0 && serverId != curServerId  )
        {
            return false;
        }

        if (worldId != GameEntry.Data.Player.GetWorldId())
        {
            return false;
        }
        return status != MarchStatus.IN_TEAM
               && status != MarchStatus.WAIT_RALLY
               && status != MarchStatus.COLLECTING
               && status != MarchStatus.ASSISTANCE
               && status != MarchStatus.IN_WORM_HOLE
               && status != MarchStatus.BUILD_WORM_HOLE
               && status != MarchStatus.CROSS_SERVER
               && status != MarchStatus.COLLECTING_ASSISTANCE
               && status != MarchStatus.BUILD_ALLIANCE_BUILDING;
    }
    public void UpdateWorldMarch(ISFSObject q)
    {
        uuid = q.TryGetLong("uuid");
        teamUuid = q.TryGetLong("teamUuid");
        ownerUid = q.TryGetString("ownerUid");
        ownerName = q.TryGetString("ownerName");
        ownerFormationUuid = q.TryGetLong("ownerFormationUuid");
        var strPath = q.TryGetString("path");
        pathStr = strPath;
        path = strPath.Split(';').Select(a => a.ToInt()).ToArray();
        targetPos = q.TryGetInt("targetPos");
        startPos = q.TryGetInt("startPos");
        target = (MarchTargetType)q.TryGetInt("target");
        status = (MarchStatus)q.TryGetInt("status");
        targetUuid = q.TryGetLong("targetUuid");
        startTime = q.TryGetLong("startTime");
        endTime = q.TryGetLong("endTime");
        worldId = q.TryGetInt("worldId");
        secretKey = q.TryGetInt("secretKey");
        if (worldId <= 0)
        {
            blackStartTime = q.TryGetLong("blackStartTime");
            blackEndTime = q.TryGetLong("blackEndTime");
        }
        else
        {
            blackStartTime = 0;
            blackEndTime = 0;
        }
        
        allianceUid = q.TryGetString("allianceUid");
        type = (NewMarchType)q.TryGetInt("type");
        speed = q.TryGetFloat("speed");
        oriSpeed = q.TryGetFloat("oriSpeed");
        plunderRes = q.TryGetString("plunderRes");
        collectSpd = q.TryGetFloat("collectSpd");
        armyWeight = q.TryGetLong("armyWeight");
        inBattle = q.TryGetBool("inBattle");
        eventId = q.TryGetString("eventId");
        belongUid = q.TryGetString("belongUid");
        actEndTime = q.TryGetLong("actEnd");
        actStartTime = q.TryGetLong("actStart");
        bossOwnerUid = q.TryGetString("bossOwnerUid");
        serverId = q.TryGetInt("server");
        targetServer = q.TryGetInt("targetServer");
        srcServer = q.TryGetInt("srcServer");
        fightMonster = q.TryGetBool("fightMonster");
        if (type == NewMarchType.MONSTER || type == NewMarchType.BOSS || type == NewMarchType.ACT_BOSS || type == NewMarchType.PUZZLE_BOSS || type == NewMarchType.MONSTER_SIEGE || type == NewMarchType.ALLIANCE_BOSS)
        {
            monsterId = q.TryGetInt("monsterId");
            refreshTime = q.TryGetLong("refreshTime");
        }
        else if (type == NewMarchType.CHALLENGE_BOSS)
        {
            monsterId = q.TryGetInt("monsterId");
            refreshTime = q.TryGetLong("refreshTime");
            callHelp = q.TryGetInt("callHelp");
        }
        UpdateArmy(q.TryGetArray("combatInfos"));
        isBroken = q.GetBool("isBroken");
        
        var diffPointStr = q.TryGetString("diffPoint");
        if (!string.IsNullOrEmpty(diffPointStr))
        {
            var diffPointArr = diffPointStr.Split(';');
            stationDir = new Vector2Int(int.Parse(diffPointArr[0]), int.Parse(diffPointArr[1]));
        }
        allianceAbbr = q.TryGetString("allianceAbbr");
        allianceName = q.TryGetString("allianceName");
        allianceIcon = q.TryGetString("allianceIcon");
        pic = q.TryGetString("pic");
        picVer = q.TryGetInt("picVer");

        targetWorldPos = SceneManager.World.TileIndexToWorld(targetPos);
        skinId = q.TryGetInt("skinId");
        skinExpireTime = q.TryGetLong("skinExpireTime");
    }
    
    private void UpdateArmy(ISFSArray arr)
    {
        if (arr == null || arr.Size() == 0)
        {
            return;
        }
        armyInfos.Clear();
        for (int i = 0; i < arr.Count; i++)
        {
            var armyInfo = new ArmyInfo();
            var bytes = Convert.FromBase64String(arr.GetUtfString(i));
            var armyCombatUnit = ArmyCombatUnit.Parser.ParseFrom(bytes);
            armyInfo.health = armyCombatUnit.SimpleCombatUnit.Health;
            //armyInfo.type = (BattleType)armyCombatUnit.SimpleCombatUnit.Type;
            armyInfo.initHealth = armyCombatUnit.SimpleCombatUnit.InitHealth;
            armyInfo.uuid = armyCombatUnit.SimpleCombatUnit.Uuid;
            //armyInfo.uid = armyCombatUnit.SimpleCombatUnit.Uid;
            armyInfo.UpdateArmyList(armyCombatUnit.ArmyInfo);
            armyInfos.Add(armyInfo);
        }
   
    }
    

    public bool GetIsBroken()
    {
        // var count = 0;
        // foreach (var VARIABLE in armyInfos)
        // {
        //     count = count + VARIABLE.health;
        // }
        //
        // return count <= 0;

        return isBroken;
    }
    public ArmyInfo GetArmyInfo(long uid)
    {
        foreach (var armyInfo in armyInfos)
        {
            if (armyInfo.uuid == uid)
            {
                return armyInfo;
            }
        }
        return null;
    }

    public ArmyInfo GetFirstArmyInfo()
    {
        foreach (var armyInfo in armyInfos)
        {
            if (armyInfo.uuid == uuid)
            {
                return armyInfo;
            }
        }
        return null;
    }

    public int GetSoliderNum()
    {
        int num = 0;
        foreach (var j in armyInfos)
        {
            foreach (var i in j.Soldiers)
            {
                num += (i.total-i.lost);
            }
            
        }
        
        return num;
    }
    

    public int GetHP()
    {
        int hp = 0;
        foreach (var j in armyInfos)
        {
            hp += j.health;
        }
        return hp;
    }

    public int GetMaxHP()
    {
        int maxHp = 0;
        foreach (var j in armyInfos)
        {
            maxHp += j.initHealth;
        }
        return maxHp;
    }

    public int GetMarchTargetType()
    {
        return (int)target;
    }

    public int GetMarchStatus()
    {
        return (int)status;
    }

    public int GetMarchType()
    {
        return (int)type;
    }
    public Vector3 GetMarchCurPos()
    {
        int pathIndex;
        Vector3 position = new Vector3();
        if ((status == MarchStatus.MOVING || status == MarchStatus.BACK_HOME || status == MarchStatus.CHASING ||
             status == MarchStatus.IN_WORM_HOLE) && (path.Length > 1))
        {
            var pathLen = 0f;
            long serverNow = GameEntry.Timer.GetServerTime();
            if (blackEndTime > 0 && blackStartTime > 0)
            {
                // 如果没进入黑土地
                if (serverNow <= blackStartTime)
                {
                    pathLen = speed * (serverNow - startTime) * 0.001f* SceneManager.World.TileSize;
                }
                // 如果没出黑土地
                else if (serverNow <= blackEndTime)
                {
                    pathLen = speed * (blackStartTime - startTime) * 0.001f* SceneManager.World.TileSize;
                    pathLen+= speed * (serverNow - blackStartTime) * 0.001f* SceneManager.World.TileSize*SceneManager.World.BlackLandSpeed;
                }
                //已经出黑土地
                else
                {
                    pathLen = speed * (blackStartTime - startTime) * 0.001f* SceneManager.World.TileSize;
                    pathLen+= speed * (blackEndTime - blackStartTime) * 0.001f* SceneManager.World.TileSize*SceneManager.World.BlackLandSpeed;
                    pathLen+= speed * (serverNow - blackEndTime) * 0.001f* SceneManager.World.TileSize;
                }
            }
            else
            {
                pathLen = speed * (serverNow - startTime) * 0.001f* SceneManager.World.TileSize;
            }

            var pathSegment = CreatePathSegment();
            WorldTroop.CalcMoveOnPath(pathSegment, 0, pathLen, out pathIndex, out _, out position);
        }
        else if (status == MarchStatus.TRANSPORT_BACK_HOME)
        {
            position = SceneManager.World.TileIndexToWorld(startPos);
        }
        else
        {
            position = SceneManager.World.TileIndexToWorld(targetPos);
        }
        
        return position;
    }
    private WorldTroopPathSegment[] CreatePathSegment()
    {
        if (path.Length < 2)
        {
            return null;
        }
        
        var pathList = new WorldTroopPathSegment[path.Length];
        for (int i = 0; i < pathList.Length; i++)
        {
            pathList[i] = new WorldTroopPathSegment();
            if (i < pathList.Length - 1)
            {
                var curPos = SceneManager.World.TileIndexToWorld(path[i]);
                var nextPos = SceneManager.World.TileIndexToWorld(path[i + 1]);
                    
                var pathVec = nextPos - curPos;
                pathList[i].pos = curPos;
                pathList[i].dir = pathVec.normalized;
                pathList[i].dist = pathVec.magnitude; 
            }
            else
            {
                pathList[i].pos = SceneManager.World.TileIndexToWorld(path[i]);
                pathList[i].dir = pathList[i - 1].dir;
                pathList[i].dist = float.MaxValue;
            }
        }

        return pathList;
    }

    //部队已采集负重量
    public long GetCurArmyWeight()
    {
        int plunderRe = 0;
        if (plunderRes != null)
        {
            int num = 0;
            var stringNum = plunderRes.Split(';');
            foreach (var item in stringNum)
            {
                int pos = item.IndexOf(',');
                num = item.Substring(pos+1).ToInt() + num;
            }
            plunderRe = num;
        }
        return  plunderRe;
    }

    public float GetResourcePercent()
    {
        var hasTimer = GameEntry.Timer.GetServerTime() - startTime;
        var curNum = hasTimer * 0.001 * collectSpd;
        return GetCurArmyWeight() != 0 ? (float)(curNum + GetCurArmyWeight()) / armyWeight : (float)curNum / armyWeight;
    }

    public bool IsMasstroops()
    {
        return target == MarchTargetType.RALLY_FOR_BOSS || target == MarchTargetType.RALLY_FOR_BUILDING || target == MarchTargetType.RALLY_FOR_ALLIANCE_CITY || target == MarchTargetType.RALLY_FOR_CITY || target == MarchTargetType.RALLY_THRONE || target == MarchTargetType.RALLY_ASSISTANCE_THRONE;
    }

    public void InitMove(WorldTroopPathSegment[] pathSegments)
    {
        if (pathSegments == null || pathSegments.Length < 2)
        {
            if (status == MarchStatus.TRANSPORT_BACK_HOME)
            {
                position = SceneManager.World.TileIndexToWorld(startPos);
            }
            else
            {
                position = SceneManager.World.TileIndexToWorld(targetPos);
            }
            
            return;
        }
        long serverNow = GameEntry.Timer.GetServerTime();
        pathIndex = 0;
        moveSpeed = speed * SceneManager.World.TileSize;
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            // 如果没进入黑土地
            if (serverNow <= blackStartTime)
            {
                var deltaTime = serverNow - startTime;
                if (deltaTime < 1)
                {
                    deltaTime = 1;
                }
                curPathLen  = moveSpeed * deltaTime * 0.001f;
            }
            // 如果没出黑土地
            else if (serverNow <= blackEndTime)
            {
                curPathLen  = moveSpeed * (blackStartTime - startTime) * 0.001f;
                var deltaTime = serverNow - blackStartTime;
                if (deltaTime < 1)
                {
                    deltaTime = 1;
                }
                curPathLen += moveSpeed * deltaTime * 0.001f*SceneManager.World.BlackLandSpeed;
            }
            //已经出黑土地
            else
            {
                curPathLen  = moveSpeed* (blackStartTime - startTime) * 0.001f;
                curPathLen += moveSpeed * (blackEndTime - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
                var deltaTime = serverNow - blackEndTime;
                if (deltaTime < 1)
                {
                    deltaTime = 1;
                }
                curPathLen += moveSpeed* deltaTime * 0.001f;
            }
        }
        else
        {
            var deltaTime = serverNow - startTime;
            if (deltaTime < 1)
            {
                deltaTime = 1;
            }
            curPathLen = moveSpeed *deltaTime * 0.001f;
        }
        pathList = pathSegments;
        WorldTroop.CalcMoveOnPath(pathList, 0, curPathLen, out pathIndex, out _, out position);
        if (pathIndex >= pathList.Length - 1)
        {
            curPathLen = 0;
        }
        else
        {
            var moveVec = pathList[pathIndex + 1].pos - position;
            moveDir = moveVec.normalized;
            curPathLen = moveVec.magnitude;
        }
    }

    public void UpdateMove(float deltaTime)
    {
        if (curPathLen <= 0)
            return;
        moveSpeed = speed * SceneManager.World.TileSize;
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            long serverNow = GameEntry.Timer.GetServerTime();
            if ( blackStartTime<=serverNow &&serverNow <= blackEndTime)
            {
                moveSpeed = moveSpeed *SceneManager.World.BlackLandSpeed;
            }
        }
        position += moveDir * (moveSpeed * deltaTime);
        curPathLen -= moveSpeed * deltaTime;
        if (curPathLen <= 0)
        {
            if (pathList != null)
            {
                if (pathIndex >= pathList.Length - 2)
                {
                    curPathLen = 0;
                    position = pathList[pathList.Length - 1].pos;
                }
                else
                {
                    pathIndex++;
                    var moveVec = pathList[pathIndex+1].pos - position;
                    moveDir = moveVec.normalized;
                    curPathLen = moveVec.magnitude;
                }
            }
        }
    }
    //获取皮肤id,过期或者没皮肤返回0
    public int GetSkinId()
    {
        if (skinId > 0)
        {
            if (skinExpireTime == 0 || skinExpireTime > GameEntry.Timer.GetServerTime())
            {
                return skinId;
            }
        }
        return 0;
    }
}

public class ArmyInfo
{
    public int initHealth;
    public int health;
    public long uuid;
    public string uid;
    public List<ArmySoldierInfo> Soldiers = new List<ArmySoldierInfo>();
    public List<HeroInfo> HeroInfos = new List<HeroInfo>();
    public List<ArmyUnitBuff> UnitBuffs = new List<ArmyUnitBuff>();
    public Dictionary<int,MarchUnitEffect> UnitEffects = new Dictionary<int,MarchUnitEffect>();
    public List<SuitInfo> Suits = new List<SuitInfo>();
    // public List<>
    public void UpdateArmyInfo(ISFSObject message)
    {
        initHealth = message.TryGetInt("initHealth");
        health = message.TryGetInt("health");
        uuid = message.TryGetLong("uuid");
        var data = ArmyUnitInfo.Parser.ParseFrom(message.GetByteArray("armyInfo").GetRawBytes());
        UpdateArmyList(data);
    }
    public void UpdateArmyList(ArmyUnitInfo proto)
    {
        HeroInfos.Clear();
        Soldiers.Clear();
        UnitBuffs.Clear();
        Suits.Clear();
        var soliderArr = proto.Soldiers;
        foreach (var variable in soliderArr)
        {
            var oneData = new ArmySoldierInfo();
            oneData.UpdateSoldier(variable);
            Soldiers.Add(oneData);
        }
        var heroesArr = proto.Heroes;
        foreach (var variable in heroesArr)
        {
            var oneData = new HeroInfo();
            oneData.UpdateHeroInfo(variable);
            HeroInfos.Add(oneData);
        }
        var buffArr = proto.UnitBuffs;
        foreach (var variable in buffArr)
        {
            var oneData = new ArmyUnitBuff();
            oneData.UpdateUnitBuff(variable);
            UnitBuffs.Add(oneData);
        }
        var suitInfo = proto.Suits;
        foreach (var variable in suitInfo)
        {
            var oneData = new SuitInfo();
            oneData.UpdateSuitInfo(variable);
            Suits.Add(oneData);
        }

        var unitEffects = proto.UnitEffects;
        foreach (var variable in unitEffects)
        {
            var oneData = new MarchUnitEffect();
            oneData.UpdateEffect(variable);
            if (oneData.effectId > 0)
            {
                UnitEffects.Add(oneData.effectId,oneData);
            }
            
        }
    }
    
    public float GetMarchEffectValue(int effectId)
    {
        var value = 0f;
        if (UnitEffects.ContainsKey(effectId))
        {
            var data = UnitEffects[effectId];
            value = data.value;
        }

        return value;
    }
}

public class MarchUnitEffect
{
    public int effectId;
    public float value;

    public void UpdateEffect(UnitEffect proto)
    {
        effectId = proto.EffectId;
        value = proto.Value;
    }
}
public enum ArmySoldierType
{
    DEFAULT = 0,  // 默认值
    // 基础兵种
    TANK = 1,     //1 坦克
    INFANTRY = 2, //2 步兵
    PLANE = 3,    //3 飞机 
}

public class ArmySoldierInfo
{
    public string uid;//玩家id
    public string armsId;//兵种id
    public ArmySoldierType type;//士兵种类
    public int total;//出征后总量
    public int lost;//损失
    public int wounded;//士兵轻伤
    public int injured;//士兵重伤
    public int dead;//士兵死亡
    
    public void UpdateSoldier(SoldierProto proto)
    {
        //uid = proto.Uid;
        armsId = proto.ArmsId;
        type = (ArmySoldierType)proto.Type;
        total = proto.Total;
        lost = proto.Lost;
        wounded = proto.Wounded;
        injured = proto.Injured;
        dead = proto.Dead;
    }
}
public class HeroSkillInfo
{
    public int skillId;
    public int skillLv;
        
    public void UpdateHeroSkill(HeroSkillInfoProto proto)
    {
        skillId = proto.SkillId;
        skillLv = proto.SkillLv;
    }
}

public class EquipInfo
{
    public int equipId;
    public int lv;
        
    public void UpdateEquip(EquipInfoProto proto)
    {
        equipId = proto.EquipId;
        lv = proto.Lv;
    }
}


public class HeroInfo
{
    public int heroId;
    public long heroUuid;
    public int heroLevel;
    public int heroQuality;
    public int index;
    public int rankLv;
    public int stage;
    public List<HeroSkillInfo> skillInfos = new List<HeroSkillInfo>();

    public void UpdateHeroInfo(HeroInfoProto proto)
    {
        heroId = proto.HeroId;
        //heroUuid = proto.HeroUuid;
        heroLevel = proto.HeroLevel;
        heroQuality = proto.HeroQuality;
        index = proto.Index;
        rankLv = proto.RankLv;
        stage = proto.Stage;
        skillInfos.Clear();
        var array = proto.SkillInfos;
        foreach (var variable in array)
        {
            var oneData = new HeroSkillInfo();
            oneData.UpdateHeroSkill(variable);
            skillInfos.Add(oneData);
        }
    }

    public bool GetIsAllSKillReachMax()
    {
        var unlockNum = 0;
        var totalLv = 0;
        foreach (var VARIABLE in skillInfos)
        {
            if (VARIABLE.skillLv > 0)
            {
                unlockNum++;
            }

            totalLv += VARIABLE.skillLv;
        }

        if (totalLv >= unlockNum * 5)
        {
            if (unlockNum == skillInfos.Count)
            {
                return true;
            }
        }

        return false;
    }
}

public class SuitInfo
{
    public int carIndex;
    public int suitType;
    public List<HeroSkillInfo> skillInfos = new List<HeroSkillInfo>();
    public List<EquipInfo> equipInfos = new List<EquipInfo>();
    public void UpdateSuitInfo(SuitInfoProto proto)
    {
        carIndex = proto.CarIndex;
        suitType = proto.SuitType;
        skillInfos.Clear();
        equipInfos.Clear();
        var array = proto.SkillInfos;
        foreach (var variable in array)
        {
            var oneData = new HeroSkillInfo();
            oneData.UpdateHeroSkill(variable);
            skillInfos.Add(oneData);
        }
        var equipArray = proto.EquipInfos;
        foreach (var variable in equipArray)
        {
            var oneData = new EquipInfo();
            oneData.UpdateEquip(variable);
            equipInfos.Add(oneData);
        }
    }
    
}

public class ArmyUnitBuff
{
    public int buffId;
    public Dictionary<int, float> effectDict; // <effectId, value>
    public int expireTime; // 过期时间戳，秒

    public void UpdateUnitBuff(Protobuf.ArmyUnitBuff proto)
    {
        buffId = proto.BuffId;
        effectDict = new Dictionary<int, float>();
        expireTime = proto.ExpireTime;

        for (int i = 0; i < proto.EffectId.Count; i++)
        {
            effectDict[proto.EffectId[i]] = proto.Value[i];
        }
    }
}