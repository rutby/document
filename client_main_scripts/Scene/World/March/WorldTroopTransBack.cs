using System.Collections.Generic;
using UnityEngine;

public class WorldTroopTransBack : WorldTroopStateBase
{
    private long lastAttackSecond = 0;
    public WorldTroopTransBack(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
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
        worldTroop.SetRotationRoot();
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
        GameEntry.Event.Fire(EventId.ShowMarchTrans, worldTroop.GetMarchUUID());
    }
    public override void OnStateLeave()
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.RemoveAttack();
        GameEntry.Event.Fire(EventId.HideMarchTrans, worldTroop.GetMarchUUID());
        base.OnStateLeave();
        
    }
    public override void OnStateUpdate(float deltaTime)
    {
        base.OnStateUpdate(deltaTime);
        if (worldTroop == null)
        {
            return;
        }
        
        if (worldTroop.IsBattle() == true)
        {
           ChangeState(WorldTroopState.AttackBegin);
        }
        else if(worldTroop.GetMarchStatus() != MarchStatus.TRANSPORT_BACK_HOME)
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
    

}