
using UnityEngine;

//
// 行军状态-死亡
//
public class WorldTroopStateDeath : WorldTroopStateBase
{
    private int targetPos;


    public WorldTroopStateDeath(WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
        : base(worldTroop, stateMachine)
    {
        
    }

    public override void OnStateEnter()
    {
        if (worldTroop == null)
        {
            return;
        }
        targetPos = worldTroop.GetMarchTargetPos();
        //worldTroop.SetRotation(worldTroop.GetStationRotation());
        worldTroop.PlayAnim(WorldTroop.Anim_Death);
    }

    public override void OnStateUpdate(float deltaTime)
    {
        if (worldTroop == null)
        {
            return;
        }
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
    }

    public override void OnLodChanged(int lod)
    {

    }
}