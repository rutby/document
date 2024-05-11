using System;
using GameFramework;
using UnityEngine;
using System.Text;
using System.Collections.Generic;
using System.Linq;

public class WorldTroopMove : MonoBehaviour
{
    private WorldTroopPathSegment[] pathList;
    private int curPathIndex;
    private float curPathLen;
    private float moveSpeed;
    private Vector3 moveDir;
    private Vector3 position;
    private int targetPos;
    private int realTargetPos;//用于划线真实落点
    private long endTime;
    private long marchUuid;
    private long blackStartTime;
    private long blackEndTime;
    private long startTime;
    private Transform rotationTrans;
    public void StartMove(Transform trans,int tarPos,string strPath,float speed,long blackST,long blackET,long sTime,long eTime)
    {
        long serverNow = GameEntry.Timer.GetServerTime();
        rotationTrans = trans;
        pathList = CreatePathSegment(strPath);
        moveSpeed = speed;
        targetPos = tarPos;
        blackStartTime = blackST;
        blackEndTime = blackET;
        startTime = sTime;
        //到现在走了多少距离
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            // 如果没进入黑土地
            if (serverNow <= blackStartTime)
            {
                curPathLen  = moveSpeed * (serverNow - startTime) * 0.001f;
            }
            // 如果没出黑土地
            else if (serverNow <= blackEndTime)
            {
                curPathLen  = moveSpeed * (blackStartTime - startTime) * 0.001f;
                curPathLen += moveSpeed * (serverNow - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
            }
            //已经出黑土地
            else
            {
                curPathLen  = moveSpeed* (blackStartTime - startTime) * 0.001f;
                curPathLen += moveSpeed * (blackEndTime - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
                curPathLen += moveSpeed* (serverNow - blackEndTime) * 0.001f;
            }
        }
        else
        {
            curPathLen = moveSpeed * (serverNow - startTime) * 0.001f;
        }
        position = transform.position;
        if (pathList != null && pathList.Length > 1)
        {
            CalcMoveOnPath(pathList, 0, curPathLen, out curPathIndex, out _, out _);
            if (curPathIndex >= pathList.Length - 1)
            {
                FinishMove();
            }
            else
            {
                var moveVec = pathList[curPathIndex + 1].pos - position;
                moveDir = moveVec.normalized;
                curPathLen = moveVec.magnitude;
                
                SetRotation(Quaternion.LookRotation(moveDir));
            }
        }
        else
        {
            FinishMove();
        }
    }

    public void StopMove()
    {
        pathList = null;
    }

    private void FinishMove()
    {

        if (pathList != null && pathList.Length > 0)
        {
            transform.position = pathList[pathList.Length - 1].pos;
        }
        else
        {
            transform.position = SceneManager.World.TileIndexToWorld(targetPos);
        }

        StopMove();
    }

    private WorldTroopPathSegment[] CreatePathSegment(string strPath)
    {
        var path = strPath.Split(';').Select(a => a.ToInt()).ToArray();
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
    
    private void SetRotation(Quaternion rotation)
    {
        var tempRotation =  rotationTrans.rotation;
        if (tempRotation.Equals(rotation)==false)
        {
            rotationTrans.rotation = rotation;
            GameEntry.Event.Fire(EventId.TroopRotation, marchUuid);
        }
    }
    private void Update()
    {
        var deltaTime = Time.deltaTime;
        if (pathList == null || curPathIndex >= pathList.Length - 1)
            return;
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            long serverNow = GameEntry.Timer.GetServerTime();
            if ( blackStartTime<=serverNow &&serverNow <= blackEndTime)
            {
                moveSpeed = moveSpeed *SceneManager.World.BlackLandSpeed;
            }
        }
        position += moveDir * moveSpeed * deltaTime;
        transform.position = position;
        SetRotation(Quaternion.LookRotation(moveDir));
        curPathLen -= moveSpeed * deltaTime;
        if (curPathLen <= 0)
        {
            if (pathList != null)
            {
                if (curPathIndex >= pathList.Length - 2)
                {
                    curPathLen = 0;
                    FinishMove();
                }
                else
                {
                    curPathIndex++;
                    var moveVec = pathList[curPathIndex+1].pos - position;
                    moveDir = moveVec.normalized;
                    curPathLen = moveVec.magnitude;
                }
            }
            else
            {
                FinishMove();
            }
        }
    }
    private void CalcMoveOnPath(WorldTroopPathSegment[] path, int startIndex, float startPathLen, out int pathIdx, out float pathLen, out Vector3 pos)
    {
        pathIdx = startIndex;
        pathLen = startPathLen;
        
        while (pathIdx < path.Length && pathLen > path[pathIdx].dist)
        {
            pathLen -= path[pathIdx].dist;
            pathIdx++;
        }

        if (pathIdx < path.Length - 1)
        {
            pos = path[pathIdx].pos + path[pathIdx].dir * pathLen;
        }
        else
        {
            pos = path[path.Length - 1].pos;
        }
    }
}