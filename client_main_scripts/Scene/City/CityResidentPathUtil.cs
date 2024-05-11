using System;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using UnityEngine;
using VEngine;

public static class CityResidentPathUtil
{
    // 缓存
    private static readonly Dictionary<int, WayPoint> wayPointsDict; // id, point
    private static readonly Dictionary<long, List<WayPoint>> maskWayPointsDict; // mask, points
    private static readonly Dictionary<long, Dictionary<int, List<WayPoint>>> maskFlagWayPointsDict; // mask, flag, points
    private static readonly Dictionary<long, Dictionary<int, Dictionary<string, List<WayPoint>>>> maskFlagArgWayPointsDict; // mask, flag, arg, points
    
    // 寻路
    private static readonly HashSet<WayPoint> toVisitPoints;
    private static readonly HashSet<WayPoint> visitedPoints;
    private static readonly Dictionary<WayPoint, float> realScores; // Dict<WayPoint, score> 起点到某点的折线距离平方
    private static readonly Dictionary<WayPoint, float> evalScores; // Dict<WayPoint, score> 起点到某点的折线距离平方 + 点到终点的直线距离平方
    private static readonly Dictionary<WayPoint, WayPoint> links; // Dict<WayPoint, WayPoint> 到达某点的最近点
    
    // 访问间隔
    private static readonly Dictionary<string, Dictionary<int, Dictionary<int, float>>> visitTimeDict;
    private static readonly Dictionary<string, float> typeVisitIntervalDict; // type, interval

    static CityResidentPathUtil()
    {
        wayPointsDict = new Dictionary<int, WayPoint>();
        maskWayPointsDict = new Dictionary<long, List<WayPoint>>();
        maskFlagWayPointsDict = new Dictionary<long, Dictionary<int, List<WayPoint>>>();
        maskFlagArgWayPointsDict = new Dictionary<long, Dictionary<int, Dictionary<string, List<WayPoint>>>>();
        
        toVisitPoints = new HashSet<WayPoint>();
        visitedPoints = new HashSet<WayPoint>();
        realScores = new Dictionary<WayPoint, float>();
        evalScores = new Dictionary<WayPoint, float>();
        links = new Dictionary<WayPoint, WayPoint>();
        
        visitTimeDict = new Dictionary<string, Dictionary<int, Dictionary<int, float>>>();
        typeVisitIntervalDict = new Dictionary<string, float>();
    }
    
    public static void SetTypeVisitInterval(string type, float interval)
    {
        typeVisitIntervalDict[type] = interval;
    }
    
    public static bool AttemptToStart(string type, int idA, int idB, float speed)
    {
        if (!typeVisitIntervalDict.ContainsKey(type) || speed <= 0)
            return true;

        if (!visitTimeDict.ContainsKey(type))
            visitTimeDict[type] = new Dictionary<int, Dictionary<int, float>>();

        if (!visitTimeDict[type].ContainsKey(idA))
            visitTimeDict[type][idA] = new Dictionary<int, float>();

        if (!visitTimeDict[type][idA].ContainsKey(idB))
            visitTimeDict[type][idA][idB] = 0;

        float interval = typeVisitIntervalDict[type] / speed;
        float lastTime = visitTimeDict[type][idA][idB];
        float curTime = Time.time;
        float visitTime = lastTime + interval;
        if (curTime > visitTime)
        {
            visitTimeDict[type][idA][idB] = curTime;
            return true;
        }
        else
        {
            return false;
        }
    }

    public static void RecordWayPoints(long mask, string fileName, Vector3 parentPos, Quaternion parentRot, Action callback = null)
    {
        if (maskWayPointsDict.ContainsKey(mask))
            return;
        
        Log.Info($"CityResidentPathManager RecordWayPoints: Begin! mask = {mask}, fileName = {fileName}");
        string filePath = string.Format(GameDefines.CityPathFile, fileName);
        Asset req = GameEntry.Resource.LoadAssetAsync(filePath, typeof(TextAsset));
        if (req == null || req.isError)
            return;
        
        req.completed += asset =>
        {
            if (asset == null || asset.isError)
            {
                Log.Info($"CityResidentPathManager RecordWayPoints: Bad asset! mask = {mask}, fileName = {fileName}");
                return;
            }

            string str = asset.asset.ToString();
            string[] lines = str.Split('\n');
            List<WayPoint> wayPoints = new List<WayPoint>();
            foreach (string line in lines)
            {
                if (line != "")
                {
                    WayPoint wayPoint = JsonUtility.FromJson<WayPoint>(line);
                    if (wayPoint != null)
                    {
                        wayPoint.pos = parentRot * wayPoint.pos + parentPos;
                        wayPoints.Add(wayPoint);
                        wayPointsDict[wayPoint.id] = wayPoint;
                    }
                }
            }

            maskWayPointsDict[mask] = wayPoints;

            if (!maskFlagWayPointsDict.ContainsKey(mask))
                maskFlagWayPointsDict[mask] = new Dictionary<int, List<WayPoint>>();
            if (!maskFlagArgWayPointsDict.ContainsKey(mask))
                maskFlagArgWayPointsDict[mask] = new Dictionary<int, Dictionary<string, List<WayPoint>>>();
            
            callback?.Invoke();

            // log
            if (CommonUtils.IsDebug())
            {
                LuaBuildData buildData = GameEntry.Data.Building.GetBuildingDataByUuid(mask);
                if (buildData != null)
                {
                    Log.Info($"CityResidentPathManager RecordWayPoints: Success! bUuid = {mask}, buildId = {buildData.buildId}, count = {wayPoints.Count}");
                }
                else
                {
                    Log.Info($"CityResidentPathManager RecordWayPoints: Success! mask = {mask}, count = {wayPoints.Count}");
                }
            }
        };
    }

    public static List<WayPoint> FindPath(Vector3 startPos, Vector3 endPos, long mask, int flag, string arg)
    {
        List<WayPoint> wayPoints = GetWayPointsByMask(mask, flag, arg);
        if (wayPoints == null)
        {
            Log.Info($"CityResidentPathManager FindPath failed: wayPoints = null, mask = {mask}, flag = {flag}, arg = {arg ?? "null"}");
            return null;
        }
        
        WayPoint startPoint = GetNearWayPoint(startPos, mask, flag, arg);
        if (startPoint == null)
        {
            Log.Info($"CityResidentPathManager FindPath failed: startPoint = null, mask = {mask}, flag = {flag}, arg = {arg ?? "null"}");
            return null;
        }
        
        WayPoint endPoint = GetNearWayPoint(endPos, mask, flag, arg);
        if (endPoint == null)
        {
            Log.Info($"CityResidentPathManager FindPath failed: endPoint = null, mask = {mask}, flag = {flag}, arg = {arg ?? "null"}");
            return null;
        }

        toVisitPoints.Clear();
        toVisitPoints.Add(startPoint);
        visitedPoints.Clear();
        realScores.Clear();
        evalScores.Clear();
        links.Clear();
        foreach (WayPoint wayPoint in wayPoints)
        {
            realScores[wayPoint] = float.MaxValue;
            evalScores[wayPoint] = float.MaxValue;
        }

        float dx = startPoint.pos.x - endPoint.pos.x;
        float dz = startPoint.pos.z - endPoint.pos.z;
        float disSqr = dx * dx + dz * dz;
        realScores[startPoint] = 0;
        evalScores[startPoint] = disSqr;

        bool found = false;
        while (toVisitPoints.Count > 0)
        {
            WayPoint curPoint = null; // evalScore 最低的点
            foreach (WayPoint wayPoint in toVisitPoints)
            {
                if (curPoint == null || evalScores[wayPoint] < evalScores[curPoint])
                {
                    curPoint = wayPoint;
                }
            }
            
            if (curPoint == endPoint)
            {
                found = true;
                break;
            }

            toVisitPoints.Remove(curPoint);
            visitedPoints.Add(curPoint);

            foreach (int id in curPoint.linkIds)
            {
                if (!wayPointsDict.ContainsKey(id))
                    continue;
                
                WayPoint wayPoint = wayPointsDict[id];
                
                if (!realScores.ContainsKey(wayPoint))
                    continue;
                
                if (visitedPoints.Contains(wayPoint))
                    continue;

                dx = curPoint.pos.x - wayPoint.pos.x;
                dz = curPoint.pos.z - wayPoint.pos.z;
                disSqr = dx * dx + dz * dz;
                float score = realScores[curPoint] + disSqr;
                if (score < realScores[wayPoint])
                {
                    toVisitPoints.Add(wayPoint);
                    links[wayPoint] = curPoint;
                    dx = wayPoint.pos.x - endPoint.pos.x;
                    dz = wayPoint.pos.z - endPoint.pos.z;
                    disSqr = dx * dx + dz * dz;
                    realScores[wayPoint] = score;
                    evalScores[wayPoint] = score + disSqr;
                }
            }
        }

        if (found)
        {
            List<WayPoint> path = new List<WayPoint>();
            for (WayPoint curPoint = endPoint; curPoint != startPoint; curPoint = links[curPoint])
            {
                path.Add(curPoint);
            }
            path.Reverse();
            return path;
        }
        else
        {
            Log.Info($"CityResidentPathManager FindPath failed: startPoint = {startPoint.name}, endPoint = {endPoint.name}, mask = {mask}, flag = {flag}, arg = {arg ?? "null"}");
            return null;
        }
    }

    public static Vector3 GetRandomPos(long mask, int flag, string arg)
    {
        List<WayPoint> wayPoints = GetWayPointsByMask(mask, flag, arg);
        if (wayPoints == null)
        {
            return Vector3.zero;
        }

        int ran = UnityEngine.Random.Range(0, wayPoints.Count);
        return wayPoints[ran].pos;
    }

    public static WayPoint GetNearWayPoint(Vector3 pos, long mask, int flag, string arg)
    {
        List<WayPoint> wayPoints = GetWayPointsByMask(mask, flag, arg);
        float minDisSqr = float.MaxValue;
        WayPoint nearWayPoint = null;
        foreach (WayPoint wayPoint in wayPoints)
        {
            float dx = pos.x - wayPoint.pos.x;
            float dz = pos.z - wayPoint.pos.z;
            float disSqr = dx * dx + dz * dz;
            if (disSqr < minDisSqr)
            {
                minDisSqr = disSqr;
                nearWayPoint = wayPoint;
            }
        }
        return nearWayPoint;
    }

    public static WayPoint GetOneWayPointByMask(long mask, int flag, string arg)
    {
        List<WayPoint> wayPoints = GetWayPointsByMask(mask, flag, arg);
        if (wayPoints != null && wayPoints.Count > 0)
            return wayPoints[0];
        
        return null;
    }

    public static List<WayPoint> GetWayPointsByMask(long mask, int flag, string arg)
    {
        if (arg == null)
        {
            if (maskFlagWayPointsDict.ContainsKey(mask))
            {
                if (!maskFlagWayPointsDict[mask].ContainsKey(flag))
                {
                    // cache
                    List<WayPoint> wayPoints = maskWayPointsDict[mask];
                    if (wayPoints.Count > 0) // Count == 0 时不要缓存为空字典，因为可能还未加载完成
                    {
                        maskFlagWayPointsDict[mask][flag] = wayPoints
                            .Where(p => (p.flag & flag) > 0)
                            .ToList();
                    }
                }

                if (maskFlagWayPointsDict[mask].ContainsKey(flag))
                {
                    return maskFlagWayPointsDict[mask][flag];
                }
            }
        }
        else
        {
            if (!maskFlagArgWayPointsDict[mask].ContainsKey(flag))
                maskFlagArgWayPointsDict[mask][flag] = new Dictionary<string, List<WayPoint>>();
            
            if (!maskFlagArgWayPointsDict[mask][flag].ContainsKey(arg))
            {
                // cache
                List<WayPoint> wayPoints = maskWayPointsDict[mask];
                if (wayPoints.Count > 0) // Count == 0 时不要缓存为空字典，因为可能还未加载完成
                {
                    maskFlagArgWayPointsDict[mask][flag][arg] = wayPoints
                        .Where(p => (p.flag & flag) > 0 && p.args != null && p.args.Contains(arg))
                        .ToList();
                }
            }

            if (maskFlagArgWayPointsDict[mask][flag].ContainsKey(arg))
            {
                return maskFlagArgWayPointsDict[mask][flag][arg];
            }
        }

        return null;
    }

    public class WayPoint
    {
        public int id;
        public string name;
        public Vector3 pos;
        public int flag;
        public List<int> linkIds;
        public List<string> args;
    }
}