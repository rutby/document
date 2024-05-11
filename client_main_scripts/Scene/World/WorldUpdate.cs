
using System;
using System.Collections.Generic;
using GameFramework;
using Protobuf;
using Sfs2X.Entities.Data;


//
// 异步处理世界点数据，减轻主线程负载
//
public class WorldUpdate
{
    private QueuedThread workerThread;
    private Queue<ParsePointsTask> taskList = new Queue<ParsePointsTask>();
    private List<int> keyToRemove = new List<int>();
    private WorldSortHelper sortHelper = new WorldSortHelper(20);
    
    public WorldUpdate()
    {
    }
    
    public void Init()
    {
        workerThread = new QueuedThread("WorldUpdate");
        workerThread.Start();
    }

    public void UnInit()
    {
        Clear();
        workerThread.Stop();
    }

    public void Clear()
    {
        keyToRemove.Clear();
        taskList.Clear();
    }

    public void Update()
    {
        while (taskList.Count > 0)
        {
            var task = taskList.Peek();
            if (!task.isDone)
            {
                break;
            }
            taskList.Dequeue();
            task.InvokeCallback();
        }
    }

    public void ProcessPointsMessage(ISFSObject message, Action<List<PointInfo>> callback, Action<List<LandPointInfo>> cbLandPoints,Action<List<WorldDesertInfo>> cbDesertInfos,Action<List<PointInfo>> cbAlInfos)
    {
        ParsePointsTask task = new ParsePointsTask
        {
            taskType = ParsePointsTask.TaskType.Points,
            message = message,
            cbPoints = callback,
            cbLandPoints = cbLandPoints,
            cbDesertInfos = cbDesertInfos,
            cbAlInfos = cbAlInfos,
        };
        taskList.Enqueue(task);
        workerThread.AddTask(task);
    }

    public void ProcessCreatePointMessage(ISFSObject message, Action<List<PointInfo>> callback)
    {
        ParsePointsTask task = new ParsePointsTask
        {
            taskType = ParsePointsTask.TaskType.Create,
            message = message,
            cbCreates = callback
        };
        taskList.Enqueue(task);
        workerThread.AddTask(task);
    }
    public void ProcessUpdateTileMessage(ISFSObject message, Action<List<WorldDesertInfo>> callback)
    {
        ParsePointsTask task = new ParsePointsTask
        {
            taskType = ParsePointsTask.TaskType.UpdateTiles,
            message = message,
            cbDesertInfos = callback
        };
        taskList.Enqueue(task);
        workerThread.AddTask(task);
    }

    public void ProcessRemovePointMessage(ISFSObject message, Action<List<int>> callback)
    {
        ParsePointsTask task = new ParsePointsTask
        {
            taskType = ParsePointsTask.TaskType.Remove,
            message = message,
            cbRemoves = callback
        };
        taskList.Enqueue(task);
        workerThread.AddTask(task);
    }

    /*
    private void AddPointInfos(ThreadTask task)
    {
        var cameraPoint = SceneManager.World.CurTilePos;
        foreach (var pointInfo in task.pointInfos)
        {
            if (sortHelper.IsOutOfViewRange(pointInfo.pointIndex, cameraPoint))
                continue;
            
            pointInfos[pointInfo.pointIndex] = pointInfo;
        }
    }

    public void GetSortCityInView(List<PointInfo> createList)
    {
        if (pointInfos.Count == 0)
        {
            createList.Clear();
            return;
        }
        
        var cameraPoint = SceneManager.World.CurTilePos;
        
        // 超出的直接删除
        keyToRemove.Clear();
        foreach (var i in pointInfos.Keys)
        {
            if (sortHelper.IsOutOfViewRange(i, cameraPoint))
            {
                keyToRemove.Add(i);
            }
        }
        foreach (var i in keyToRemove)
        {
            pointInfos.Remove(i);
        }
        if (pointInfos.Count == 0)
        {
            createList.Clear();
            return;
        }
        
        // 取出离相机中心最近的N个
        createList.Clear();
        sortHelper.GetSortList(cameraPoint, pointInfos, createList);
    }

    private static bool IsInfoValid(ISFSObject info)
    {
        var tileType = (WorldTileType)info.GetInt("t");
        switch (tileType)
        {
            case WorldTileType.FieldMonster:
            {
                var refreshTime = info.ContainsKey("rt") ? info.GetInt("rt") : 0;
                var startTime = info.ContainsKey("st") ? info.GetInt("st") : 0;
                var now = GameEntry.Timer.GetServerTimeSeconds();
                if (now > refreshTime || now < startTime)
                {
                    return false;
                }
                break;
            }
            case WorldTileType.ResourceTile:
                // 空资源不显示在世界
                break;
            case WorldTileType.tile_city_ruins:
                {
                    long rStamp = info.TryGetLong("rt") * 1000;
                    long now = GameEntry.Timer.GetServerTime();
                    if (now > rStamp)
                    {
                        return false;
                    }
                    break;
                }

        }

        return true;
    }
    */
    
}

class ParsePointsTask : IQueuedThreadTask
{
    public enum TaskType
    {
        Create, Remove, Points,UpdateTiles
    }

    public TaskType taskType;
    public ISFSObject message;
    public List<PointInfo> pointInfos = new List<PointInfo>();
    public List<PointInfo> allianceInfos = new List<PointInfo>();
    public List<int> removedPointId = new List<int>();
    public List<LandPointInfo> landPointInfos = new List<LandPointInfo>();
    public List<WorldDesertInfo> desertInfos = new List<WorldDesertInfo>();
    public Action<List<PointInfo>> cbPoints;
    public Action<List<PointInfo>> cbCreates;
    public Action<List<int>> cbRemoves;
    public Action<List<LandPointInfo>> cbLandPoints;
    public Action<List<WorldDesertInfo>> cbDesertInfos;
    public Action<List<PointInfo>> cbAlInfos;
    public volatile bool isDone;

    public void Process()
    {
        if (taskType == TaskType.Points)
        {
            var tmp = message.GetSFSArray("points");
            if (tmp != null)
            {
                var startTime = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalMilliseconds;
                Log.Debug("c# parse world point message point counts:{0}",tmp.Count);
                for (int i = 0; i < tmp.Count; ++i)
                {
                    var p = WorldPointInfo.Parser.ParseFrom(tmp.GetByteArray(i).GetRawBytes());
                    AddPointInfo(NewPointInfo(p));
                }
                var endTime = DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalMilliseconds;
                Log.Debug("c# parse world point message deltaTime:{0},startTime={1},endTime={2}", (endTime - startTime),startTime,endTime);
            }
            var lands = message.GetSFSArray("lands");
            if (lands != null)
            {
                for (int i = 0; i < lands.Count; i++)
                {
                    var land = LandPointInfo.Parser.ParseFrom(lands.GetByteArray(i).GetRawBytes());
                    landPointInfos.Add(land);
                }
            }
            var deserts = message.GetSFSArray("deserts");
            if (deserts != null)
            {
                for (int i = 0; i < deserts.Count; i++)
                {
                    var land = DesertInfo.Parser.ParseFrom(deserts.GetByteArray(i).GetRawBytes());
                    desertInfos.Add(new WorldDesertInfo(land));
                }
            }
            var alInfos = message.GetSFSArray("alInfos");
            if (alInfos != null)
            {
                for (int i = 0; i < alInfos.Count; i++)
                {
                    var p = WorldPointInfo.Parser.ParseFrom(alInfos.GetByteArray(i).GetRawBytes());
                    allianceInfos.Add(NewPointInfo(p));
                    AddPointInfo(NewPointInfo(p));
                }
            }
        }
        else if (taskType == TaskType.Create)
        {
            var tmp = message.GetSFSArray("points");
            for (int i = 0; i < tmp.Count; ++i)
            {
                var p = WorldPointInfo.Parser.ParseFrom(tmp.GetByteArray(i).GetRawBytes());
                AddPointInfo(NewPointInfo(p));
            }
            
           
        }
        else if (taskType == TaskType.UpdateTiles)
        {
            var deserts = message.GetSFSArray("deserts");
            if (deserts != null)
            {
                for (int i = 0; i < deserts.Count; i++)
                {
                    var land = DesertInfo.Parser.ParseFrom(deserts.GetByteArray(i).GetRawBytes());
                    desertInfos.Add(new WorldDesertInfo(land));
                }
            }
        }
        else if (taskType == TaskType.Remove)
        {
            var tmp = message.GetSFSArray("pointIds");
            for (int i = 0; i < tmp.Count; ++i)
            {
                removedPointId.Add(tmp.GetInt(i));
            }
        }

        isDone = true;
    }

    public void InvokeCallback()
    {
        if (taskType == TaskType.Points)
        {
            cbPoints.Invoke(pointInfos);
            cbLandPoints.Invoke(landPointInfos);
            cbDesertInfos.Invoke(desertInfos);
            cbAlInfos.Invoke(allianceInfos);
        }
        else if (taskType == TaskType.Create)
        {
            cbCreates.Invoke(pointInfos);
        }
        else if (taskType == TaskType.UpdateTiles)
        {
            cbDesertInfos.Invoke(desertInfos);
        }
        else if (taskType == TaskType.Remove)
        {
            cbRemoves.Invoke(removedPointId);
        }
    }
    
    private PointInfo NewPointInfo(WorldPointInfo p)
    {
        switch ((WorldPointType)p.PointType)
        {
            case WorldPointType.PlayerBuilding:
                return new BuildPointInfo(p);
            case WorldPointType.WorldResource:
                return new ResPointInfo(p);
            case WorldPointType.SAMPLE_POINT:
            case WorldPointType.SAMPLE_POINT_NEW:
                return new SamplePointInfo(p);
            case WorldPointType.EXPLORE_POINT:
            case WorldPointType.DETECT_EVENT_PVE:
                return new ExplorePointInfo(p);
            case WorldPointType.GARBAGE:
                return new GarbagePointInfo(p);
            case WorldPointType.WORLD_ALLIANCE_CITY:
                return new PointInfo(p);
            case WorldPointType.WORLD_ALLIANCE_BUILD:
                return new AllianceBuildPointInfo(p);
            case WorldPointType.DRAGON_BUILDING:
                return new DragonPointInfo(p);
            case WorldPointType.CROSS_THRONE_BUILD:
                return new CrossThronePointInfo(p);
            case WorldPointType.WorldRuinPoint:
                return new RuinPointInfo(p);
            default:
                return new PointInfo(p);
        }

        return null;
    }
    

    private void AddPointInfo(PointInfo pi)
    {
        if (pi == null)
            return;
        
        pointInfos.Add(pi);
    }
}
