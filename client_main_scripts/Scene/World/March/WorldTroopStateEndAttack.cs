using System.Collections.Generic;
using UnityEngine;
public class WorldTroopStateEndAttack : WorldTroopStateBase
{

    public WorldTroopStateEndAttack(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
    }

    public override void OnStateEnter()
    {
        GameEntry.Event.Fire(EventId.HideTroopHead, worldTroop.GetMarchUUID());
        GameEntry.Event.Fire(EventId.ShowTroopName, worldTroop.GetMarchUUID());
    }

    public override void OnStateLeave()
    {
    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (worldTroop == null)
        {
            return;
        }
        if ((worldTroop.GetMarchStatus() == MarchStatus.CHASING||worldTroop.GetMarchStatus() == MarchStatus.MOVING))
        {
            ChangeState(WorldTroopState.Move);
            if (worldTroop.IsExplore())
            { 
                GameEntry.Event.Fire(EventId.AttackExploreEnd, worldTroop.GetMarchUUID());
            }
        }
        else if (worldTroop.GetMarchStatus() == MarchStatus.DESTROY_WAIT)
        {
            ChangeState(WorldTroopState.AttackBuild);
        }
        else if(worldTroop.GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
        {
            ChangeState(WorldTroopState.TransPortBackHome);
        }
        else
        {

            ChangeState(WorldTroopState.Idle);
            if (worldTroop.IsExplore())
            { 
                GameEntry.Event.Fire(EventId.AttackExploreEnd, worldTroop.GetMarchUUID());
            }
        }
    }
}