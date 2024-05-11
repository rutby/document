
using System;
using GameFramework;
using UnityEngine;
using System.Text;
using System.Collections.Generic;

//
// 行军状态-向目标移动
//
public class WorldTroopStateMove : WorldTroopStateBase
{
    public class WayInfo
    {
        public WorldTroopPathSegment[] pathList;
        public int targetPos;

    }

    private List<WayInfo> wayList = new List<WayInfo>();

    private WorldTroopPathSegment[] pathList;
    private int curPathIndex;
    private float curPathLen;
    private float moveSpeed;
    private Vector3 moveDir;
    private Vector3 position;
    private int targetPos;
    private int realTargetPos;//用于划线真实落点
    private long endTime;
    public WorldTroopStateMove(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {

    }

    public override void OnStateEnter()
    {
        StartMove();
    }

    public override void OnStateLeave()
    {
        pathList = null;

    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (worldTroop == null)
        {
            return;
        }
        RecoverWorldTroop();
        if (worldTroop.IsBattle() == false)
        {
            if (worldTroop.GetMarchStatus() == MarchStatus.DESTROY_WAIT)
            {
                ChangeState(WorldTroopState.AttackBuild);
            }
            else if(worldTroop.GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
            {
                ChangeState(WorldTroopState.TransPortBackHome);
            }
            else if (targetPos != worldTroop.GetMarchTargetPos())
            {
                StartMove();
            }else if (Math.Abs(moveSpeed - worldTroop.GetSpeed()) > 0.1f)
            {
                StartMove();
            }
        }
        else
        {
            ChangeState(WorldTroopState.Attack);
        }
        UpdateMovement(deltaTime);

    }

    public override void OnLodChanged(int lod)
    {
        if (worldTroop == null)
        {
            return;
        }
        if (lod < 4 && (pathList != null && pathList.Length > 1))
        {
            StartMove();
        }
        else
        {
            // worldTroop.DestroyMarchLine();
            // worldTroop.DestroyTroopDestination();
        }

        if (lod <= 1)
        {
            worldTroop.PlayAnim(WorldTroop.Anim_Run);
        }
    }

    private void StartMove()
    {
        if (worldTroop == null)
        {
            return;
        }
        long serverNow = GameEntry.Timer.GetServerTime();
        targetPos = worldTroop.GetMarchTargetPos();
        // if (worldTroop.IsMonsterTroop())
        // {
        //     //缓存路径
        //     var wayInfo = wayList.Find(p => p.targetPos == targetPos);
        //     if (wayInfo == null)
        //     {
        //         WayInfo info = new WayInfo();
        //         info.targetPos = targetPos;
        //         info.pathList = worldTroop.CreatePathSegment();
        //         wayList.Add(info);
        //     }
        //
        //     //服务器给推送的pathList
        //     pathList = wayList[0].pathList;//worldTroop.CreatePathSegment();
        // }
        // else
        //{
            pathList = worldTroop.CreatePathSegment();
        //}
        // if (worldTroop.NeedGetRealTargetPos())
        // {
        //     realTargetPos = worldTroop.GetRealMarchTargetPos();
        // }
        // else
        // {
        //     realTargetPos = 0;
        // }
        moveSpeed = worldTroop.GetSpeed();
        //到现在走了多少距离
        var blackEndTime = worldTroop.GetMarchBlackEndTime();
        var blackStartTime = worldTroop.GetMarchBlackStartTime();
        var startTime = worldTroop.GetMarchStartTime();
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
        position = worldTroop.GetPosition();
        if (pathList != null && pathList.Length > 1)
        {
            WorldTroop.CalcMoveOnPath(pathList, 0, curPathLen, out curPathIndex, out _, out _);
            if (curPathIndex >= pathList.Length - 1)
            {
                FinishMove();
            }
            else
            {
                var moveVec = pathList[curPathIndex + 1].pos - position;
                moveDir = moveVec.normalized;
                curPathLen = moveVec.magnitude;
                worldTroop.PlayAnim(WorldTroop.Anim_Run);
                worldTroop.SetRotation(Quaternion.LookRotation(moveDir));
                // worldTroop.CreateMarchLine();
                // worldTroop.UpdateMarchLine(pathList, curPathIndex, position, realTargetPos);
                // worldTroop.CreateTroopDestination();
                // if (realTargetPos > 0)
                // {
                //     worldTroop.UpdateTroopDestination(realTargetPos);
                // }
                // else
                // {
                //     worldTroop.UpdateTroopDestination(targetPos);
                // }
            }
        }
        else
        {
            FinishMove();
        }
    }
    private void UpdateMovement(float deltaTime)
    {
        if (worldTroop == null)
        {
            return;
        }
        if (pathList == null || curPathIndex >= pathList.Length - 1)
            return;
        // 移动
        moveSpeed = worldTroop.GetSpeed();
        //到现在走了多少距离
        var blackEndTime = worldTroop.GetMarchBlackEndTime();
        var blackStartTime = worldTroop.GetMarchBlackStartTime();
        if (blackEndTime > 0 && blackStartTime > 0)
        {
            long serverNow = GameEntry.Timer.GetServerTime();
            if ( blackStartTime<=serverNow &&serverNow <= blackEndTime)
            {
                moveSpeed = moveSpeed *SceneManager.World.BlackLandSpeed;
            }
        }
        position += moveDir * moveSpeed * deltaTime;
        worldTroop.SetPosition(position);
        // bool needRefresh = false;
        // if (worldTroop.NeedGetRealTargetPos() && realTargetPos <= 0)
        // {
        //     realTargetPos = worldTroop.GetRealMarchTargetPos();
        //     if (realTargetPos > 0)
        //     {
        //         needRefresh = true;
        //     }
        // }
        // worldTroop.UpdateMarchLine(pathList, curPathIndex, position, realTargetPos, needRefresh);
        // if (realTargetPos > 0)
        // {
        //     worldTroop.UpdateTroopDestination(realTargetPos);
        // }
        // else
        // {
        //     worldTroop.UpdateTroopDestination(targetPos);
        // }
        worldTroop.SetRotation(Quaternion.LookRotation(moveDir));
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
            // if (wayList.Count > 0)
            // {
            //     wayList.RemoveAt(0);
            // }
            //
            // if (wayList.Count > 0)
            // {
            //     pathList = wayList[0].pathList;
            //     var moveVec = pathList[1].pos - position;
            //     moveDir = moveVec.normalized;
            //     curPathLen = moveVec.magnitude;
            // }

        }
    }

    private void FinishMove()
    {
        if(wayList.Count>0)
        {
            return;
        }

        if (worldTroop == null)
        {
            return;
        }

        if (pathList != null && pathList.Length > 0)
        {
            worldTroop.SetPosition(pathList[pathList.Length-1].pos);
        }
        else
        {
            worldTroop.SetPosition(worldTroop.GetMarchInfo().position);
        }
        pathList = null;
        // worldTroop.DestroyMarchLine();
        // worldTroop.DestroyTroopDestination(); 
        if (worldTroop.IsPickGarbageTroop())
        {
            ChangeState(WorldTroopState.PickGarbageMovetoGarbage);
        }
        else if (worldTroop.IsGolloesExplore())
        {
            ChangeState(WorldTroopState.PickingGarbage);
        }
        else
        {
            ChangeState(WorldTroopState.Idle);
            
        }

        // if (worldTroop.IsMonsterTroop())
        // {
        //     // Log("monster state =============" + worldTroop.GetMarchStatus());
        //     GameEntry.Event.Fire(EventId.MonsterMoveEnd, worldTroop.GetMarchUUID());
        // }


    }
}