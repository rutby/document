
using UnityEngine;

//
// 行军状态-空闲、停止
//
public class WorldTroopStateIdle : WorldTroopStateBase
{
    private int targetPos;
    
    
    public WorldTroopStateIdle(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
        //worldTroop.HideHeadUI(false);
    }

    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        GameEntry.Event.Fire(EventId.CheckTroopStateIcon, worldTroop.GetMarchUUID());
        targetPos = worldTroop.GetMarchTargetPos();
        if (worldTroop.GetMarchStatus() == MarchStatus.STATION)
        {
            worldTroop.SetRotation(worldTroop.GetStationRotation());
        }
        
        worldTroop.PlayAnim(WorldTroop.Anim_Idle);
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
            if (worldTroop.GetMarchStatus() == MarchStatus.CHASING
                || worldTroop.GetMarchStatus() == MarchStatus.MOVING
                || worldTroop.GetMarchStatus() == MarchStatus.IN_WORM_HOLE){
                if (worldTroop.GetMovePathCount() > 1 && targetPos != worldTroop.GetMarchTargetPos())
                {
                    ChangeState(WorldTroopState.Move);
                }
            }else if (worldTroop.GetMarchStatus() == MarchStatus.DESTROY_WAIT)
            {
                ChangeState(WorldTroopState.AttackBuild);
            }
            else if(worldTroop.GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
            {
                ChangeState(WorldTroopState.TransPortBackHome);
            }
            else if (worldTroop.GetMarchStatus() == MarchStatus.PICKING
                     || worldTroop.GetMarchStatus() == MarchStatus.SAMPLING)
            {
                ChangeState(WorldTroopState.PickGarbageMovetoGarbage);
            }
        }
        else if (worldTroop.IsBattle())
        {
            ChangeState(WorldTroopState.Attack);
        }
    }

    public override void OnLodChanged(int lod)
    {
        if (lod <= 1)
        {
            worldTroop.PlayAnim(WorldTroop.Anim_Idle);
        }
    }
}