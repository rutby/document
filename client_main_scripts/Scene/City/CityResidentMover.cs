using System;
using System.Collections.Generic;
using DG.Tweening;
using GameFramework;
using UnityEngine;
using WayPoint = CityResidentPathUtil.WayPoint;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class CityResidentMover : MonoBehaviour
{
    private enum MoveState
    {
        Idle = 0,
        Play = 1,
        Clear = 2,
        Pause = 3,
        Wait = 4,
    }
    
    private static readonly Vector3 VecUp = Vector3.up;
    private const float BigFloat = 99999;
    
    public float speed;
    public List<Vector3> path;
    public List<Action> callbacks; // 已废弃
    public int pathIndex;
    public float pathTotalTimeInv; // 线段总用时 的倒数
    public float pathUsedTime; // 线段已用时
    public float pathPercent; // 已走到线段全程的百分比 [0, 1]
    public Vector3 startPos;
    public Vector3 endPos;
    
    private string type;
    private long uuid;
    private MoveState moveState;
    private MoveState moveStateBeforePause;
    private List<WayPoint> pointList;
    private WayPoint startPoint;
    private WayPoint endPoint;
    private WayPoint lastStartPoint;
    private WayPoint lastEndPoint;
    private static float updateInterval; // 多少秒执行一次 Update
    private float updateCd;
    private Vector3 posCache;
    private Transform tran;
    private Tweener rotTween;

    public static bool UseNewMethod()
    {
        return true;
    }

    public Vector3 pos
    {
        get => tran.position;
        set => tran.position = value;
    }

    public Quaternion rot
    {
        get => tran.rotation;
        set
        {
            rotTween?.Kill();
            tran.rotation = value;
        }
    }

    private void Awake()
    {
        type = "";
        moveState = MoveState.Idle;
        speed = 0;
        path = new List<Vector3>();
        pointList = new List<WayPoint>();
        pathIndex = -1;
        pathTotalTimeInv = BigFloat;
        pathUsedTime = 0;
        pathPercent = 0;
        startPos = Vector3.zero;
        endPos = Vector3.zero;
        startPoint = null;
        endPoint = null;
        lastStartPoint = null;
        lastEndPoint = null;
        tran = transform;
    }

    private void Update()
    {
        if (moveState == MoveState.Wait)
            TryPlay();
        
        if (moveState != MoveState.Play)
            return;

        float deltaTime = Time.deltaTime;
        updateCd -= deltaTime;
        pathUsedTime += deltaTime;
        
        if (updateCd > 0)
            return;

        updateCd = updateInterval;
        pathPercent = pathUsedTime * pathTotalTimeInv;
        if (pathPercent > 1 - float.Epsilon)
        {
            // 到达拐点
            pos = endPos;
            Turn();
        }
        else
        {
            // 未到达拐点
            posCache.x = startPos.x + (endPos.x - startPos.x) * pathPercent;
            posCache.z = startPos.z + (endPos.z - startPos.z) * pathPercent;
            pos = posCache;
        }
    }

    private void TryPlay()
    {
        if (startPoint != null && endPoint != null && (startPoint != lastStartPoint || endPoint != lastEndPoint))
        {
            if (CityResidentPathUtil.AttemptToStart(type, startPoint.id, endPoint.id, speed))
            {
                moveState = MoveState.Play;
            }
            else
            {
                moveState = MoveState.Wait;
            }
        }
        else
        {
            moveState = MoveState.Play;
        }
    }

    public WayPoint GetStartPoint()
    {
        return startPoint;
    }

    public WayPoint GetEndPoint()
    {
        return endPoint;
    }

    private void Turn()
    {
        if (pathIndex >= 0 && pathIndex < pointList.Count)
        {
            // 记录所处点
            startPoint = pointList[pathIndex];
        }
        
        if (pathIndex >= path.Count - 1)
        {
            // 已达最后一个拐点
            moveState = MoveState.Idle;
            OnPathComplete();
            return;
        }
        
        moveState = MoveState.Wait;
        pathIndex++;
        startPos = pos;
        endPos = path[pathIndex];
        lastStartPoint = startPoint;
        lastEndPoint = endPoint;
        endPoint = pointList[pathIndex];
        LookAt(endPos);
        
        float dx = startPos.x - endPos.x;
        float dz = startPos.z - endPos.z;
        float disSqr = dx * dx + dz * dz;
        if (disSqr > float.Epsilon)
        {
            pathTotalTimeInv = speed / Mathf.Sqrt(disSqr);
        }
        else
        {
            pathTotalTimeInv = BigFloat;
        }
        pathUsedTime = 0;
        updateCd = 0;
    }

    // 直线前往
    public void BeginStraight(Vector3 startPos, Vector3 endPos)
    {
        path.Add(endPos);
        pointList.Add(null);
        Turn();
    }

    // 寻路前往
    public void Begin(Vector3 startPos, Vector3 endPos, long mask, int flag, string arg)
    {
        List<WayPoint> wayPoints = CityResidentPathUtil.FindPath(startPos, endPos, mask, flag, arg);
        if (wayPoints == null || wayPoints.Count == 0)
        {
            BeginStraight(startPos, endPos);
            return;
        }
        
        foreach (WayPoint point in wayPoints)
        {
            path.Add(point.pos);
            pointList.Add(point);
        }
        
        Turn();
    }

    private void OnPathComplete()
    {
        GameEntry.Event.Fire(EventId.CityResidentMoveComplete, uuid);
    }

    public void LookAt(Vector3 toPos)
    {
        Vector3 dir = toPos - pos;
        if (dir.x != 0 || dir.z != 0)
        {
            rotTween?.Kill();
            rotTween = tran.DOLookAt(toPos, 0.2f);
            //rot = Quaternion.LookRotation(dir, VecUp);
        }
    }

    public void Clear()
    {
        moveState = MoveState.Clear;
        pathIndex = -1;
        path.Clear();
        pointList.Clear();
    }

    public void Pause()
    {
        moveStateBeforePause = moveState;
        moveState = MoveState.Pause;
    }

    public void Resume()
    {
        moveState = moveStateBeforePause;
    }

    public void SetUuid(long uuid)
    {
        this.uuid = uuid;
    }
    
    public void SetType(string type)
    {
        this.type = type;
    }

    public static void SetUpdateInterval(float interval)
    {
        Log.Info($"CityResidentMover SetUpdateInterval: interval = {interval}");
        updateInterval = interval;
    }
    
#if UNITY_EDITOR

    private void OnDrawGizmos()
    {
        if (path.Count == 0 || pathIndex >= path.Count)
        {
            return;
        }

        Vector3 curPos = pos;
        Vector3 offset = Vector3.up * 0.1f;
        Gizmos.color = Color.yellow;
        for (int i = pathIndex; i < path.Count; i++)
        {
            Vector3 toPos = path[i];
            Gizmos.DrawLine(curPos + offset, toPos + offset);
            curPos = toPos;
        }
    }

#endif
}