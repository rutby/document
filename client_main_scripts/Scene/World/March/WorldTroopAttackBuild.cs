using System.Collections.Generic;
using UnityEngine;

public class WorldTroopAttackBuild : WorldTroopStateBase
{
    private long startTimeSecond = 0;
    private long endTimeSecond = 0;
    private long targetUuid=0;
    private long lastAttackSecond = 0;
    public WorldTroopAttackBuild(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
       
    }
    public override void OnStateEnter()
    {
        base.OnStateEnter();
        if (worldTroop == null)
        {
            return;
        }
        var marchInfo = worldTroop.GetMarchInfo();
        if (marchInfo != null)
        {
            startTimeSecond = marchInfo.startTime/1000;
            endTimeSecond = marchInfo.endTime/1000;
            targetUuid = marchInfo.targetUuid;
        }
        worldTroop.SetRotationRoot();
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
        GameEntry.Event.Fire(EventId.ShowTroopAtkBuildIcon, worldTroop.GetMarchUUID());
    }
    public override void OnStateLeave()
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.RemoveAttack();
        GameEntry.Event.Fire(EventId.HideTroopAtkBuildIcon, worldTroop.GetMarchUUID());
        base.OnStateLeave();
        
    }
    public override void OnStateUpdate(float deltaTime)
    {
        base.OnStateUpdate(deltaTime);
        if (worldTroop == null)
        {
            return;
        }

        CheckAttack();
        if (worldTroop.IsBattle() == true)
        {
           ChangeState(WorldTroopState.AttackBegin);
        }
        else if(worldTroop.GetMarchStatus() != MarchStatus.DESTROY_WAIT)
        {
            if ((worldTroop.GetMarchStatus() == MarchStatus.CHASING||worldTroop.GetMarchStatus() == MarchStatus.MOVING))
            {
                ChangeState(WorldTroopState.Move);
            }
            else
            {

                ChangeState(WorldTroopState.Idle);
            }
        }
    }

    private void CheckAttack()
    {
        if (worldTroop == null)
        {
            return;
        }
        var curSec = GameEntry.Timer.GetServerTimeSeconds();
        if (curSec < endTimeSecond)
        {
            if (curSec - lastAttackSecond >= 1)
            {
                lastAttackSecond = curSec;
                worldTroop.ShowAttack();
            }
        }
        
    }

}