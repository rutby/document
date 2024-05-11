using System.Collections.Generic;
using UnityEngine;

public class WorldTroopStatePickGarbageMovetoGarbage : WorldTroopStateBase
{
    private float startTime = 0;
    private const float totalTime = 2;

    public WorldTroopStatePickGarbageMovetoGarbage(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
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
        worldTroop.PlayAnim(WorldTroop.Anim_Idle);
        worldTroop.HideJunkMan();
        worldTroop.TroopUnitsBirthThenPickGarbage();
        startTime = Time.realtimeSinceStartup;
    }

    public override void OnStateLeave()
    {
        
    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (Time.realtimeSinceStartup - startTime > totalTime)
        {
            ChangeState(WorldTroopState.PickingGarbage);
        }
    }

    public override void OnLodChanged(int lod)
    {
        
    }
}