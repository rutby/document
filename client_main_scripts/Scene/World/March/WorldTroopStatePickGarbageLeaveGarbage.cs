using System.Collections.Generic;
using UnityEngine;

public class WorldTroopStatePickGarbageLeaveGarbage : WorldTroopStateBase
{
    private float startTime = 0;
    private const float totalTime = 2.0f;

    public WorldTroopStatePickGarbageLeaveGarbage(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
    }

    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.PlayAnim(WorldTroop.Anim_Back);
        worldTroop.TroopUnitPickBack();
        startTime = Time.realtimeSinceStartup;
    }

    public override void OnStateLeave()
    {
        
    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (Time.realtimeSinceStartup - startTime > totalTime)
        {
            ChangeState(WorldTroopState.Move);
        }
    }

    public override void OnLodChanged(int lod)
    {
        
    }
}