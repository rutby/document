
using System;
using System.Collections.Generic;
using UnityEngine;
//
// 行军状态-攻击
//
public class WorldTroopStateAttack : WorldTroopStateBase
{
    private int targetPos;
    private float waitSkillFinishTime = 1.5f;
    private float startTick = 0;
    private const float maxBattleTime =3;
    
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
    private int realTargetPos;//用于划线真实落点
    private long endTime;
    public WorldTroopStateAttack(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {

    }
    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        startTick = Time.realtimeSinceStartup;
        targetPos = worldTroop.GetMarchTargetPos();
        worldTroop.SetRotationRoot();
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
        GameEntry.Event.Fire(EventId.HideTroopName, worldTroop.GetMarchUUID());
        GameEntry.Event.Fire(EventId.ShowTroopHeadInBattle, worldTroop.GetMarchUUID());
        StartMove();
    }
    public override void OnStateLeave()
    {


    }
    
    public override void OnStateUpdate(float deltaTime)
    {
        //攻击的时候一直朝向敌人
        if (worldTroop == null)
        {
            return;
        }
        RecoverWorldTroop();
        if (worldTroop.IsBattle() == true)
        {
            if (targetPos != worldTroop.GetMarchTargetPos())
            {
                worldTroop.RemoveAttack();
                StartMove();
               
            }
            else if (Math.Abs(moveSpeed - worldTroop.GetSpeed()) > 0.1f)
            {
                StartMove();
            }
        }
        else
        {
            ChangeState(WorldTroopState.AttackEnd);
        }
        UpdateMovement(deltaTime);
    }

    public override void OnLodChanged(int lod)
    {
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
            worldTroop.PlayAnim(WorldTroop.Anim_Attack);
        }
    }

    private void StartMove()
    {
        long serverNow = GameEntry.Timer.GetServerTime();
        targetPos = worldTroop.GetMarchTargetPos();
        ///服务器发送的追击路径，不打断，一个一个路点的播放
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
        // {
            pathList = worldTroop.CreatePathSegment();
        // }
        if (worldTroop.NeedGetRealTargetPos())
        {
            realTargetPos = worldTroop.GetRealMarchTargetPos();
        }
        else
        {
            realTargetPos = 0;
        }
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

    private void FinishMove()
    {
        if(wayList.Count>0)
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
        worldTroop.PlayAnim(WorldTroop.Anim_Attack);
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
    }
}