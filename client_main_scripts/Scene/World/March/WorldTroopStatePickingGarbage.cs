using System.Collections.Generic;
using UnityEngine;

public class WorldTroopStatePickingGarbage : WorldTroopStateBase
{
    public WorldTroopStatePickingGarbage(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
        
    }

    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
        if (worldTroop.IsGolloesExplore())
        {
            worldTroop.PlayAnim(WorldTroop.Anim_Idle);
        }
        else
        {
            worldTroop.PlayAnim(WorldTroop.Anim_Idle);
            worldTroop.TroopUnitsBirthThenPickGarbage(false);
            
        }
        GameEntry.Event.Fire(EventId.GarbageCollectStart, worldTroop.GetMarchInfo().targetUuid);
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
        if (worldTroop.GetMarchStatus() != MarchStatus.PICKING && worldTroop.GetMarchStatus() != MarchStatus.SAMPLING
                                                               && worldTroop.GetMarchStatus() != MarchStatus.GOLLOES_EXPLORING && worldTroop.GetMarchStatus() != MarchStatus.GOLLOES_EXPLORING)
        {
            if (worldTroop.IsGolloesExplore())
            {
                ChangeState(WorldTroopState.Move);
            }
            else
            {
                worldTroop.ShowJunkMan();
                worldTroop.TroopUnitPickBack();
                ChangeState(WorldTroopState.Move);
                //ChangeState(WorldTroopState.PickGarbageSuccess);
            }
        } 
    }

    public override void OnLodChanged(int lod)
    {
        
    }
}