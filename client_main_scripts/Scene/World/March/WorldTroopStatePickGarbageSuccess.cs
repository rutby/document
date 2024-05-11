using System.Collections.Generic;
using UnityEngine;

public class WorldTroopStatePickGarbageSuccess : WorldTroopStateBase
{
    private float startTime = 0;
    private const float totalTime = 0.6f;

    public WorldTroopStatePickGarbageSuccess(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
    }

    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.PlayAnim(WorldTroop.Anim_Hit);
        startTime = Time.realtimeSinceStartup;
        worldTroop.TroopUnitPickSuccess();
    }

    public override void OnStateLeave()
    {
        
    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (Time.realtimeSinceStartup - startTime > totalTime)
        {
            ChangeState(WorldTroopState.PickGarbageLeaveGarbage);
        }
    }

    public override void OnLodChanged(int lod)
    {
        
    }
}