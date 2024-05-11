using System.Collections.Generic;
using UnityEngine;

public class WorldTroopStateStartAttack : WorldTroopStateBase
{
    private int createdCount = 0;
    private List<WorldTroop> troopList = new List<WorldTroop>();
    public WorldTroopStateStartAttack (WorldTroop worldTroop, WorldTroopStateMachine stateMachine)
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
        var marches = worldTroop.GetMarchInfo().armyInfos;
        var worldTroopMarch = SceneManager.World.GetMarch(worldTroop.GetMarchUUID());
        worldTroop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - worldTroop.GetPosition()));
        GameEntry.Event.Fire(EventId.HideTroopName, worldTroop.GetMarchUUID());
        GameEntry.Event.Fire(EventId.ShowTroopHeadInBattle, worldTroop.GetMarchUUID());
        if (marches.Count>1)
        {
            //飞碟往后退
            worldTroop.MoveFd();
            var troopTran = worldTroop.GetTransform();
            if(troopTran!=null)
            {
                var tmp = worldTroop.GetTransform().Find("Model/A_vehicle_ybc_prefab");
                if (tmp!=null)
                {
         
                    tmp.gameObject.SetActive(true);
                }
            }
        }
  
        foreach (var v in marches)
        {
            if (v.uuid != worldTroop.GetMarchUUID())
            {
                var march = SceneManager.World.GetMarch(v.uuid);
                if (march != null)
                {
                    march.type = worldTroopMarch.type;
                    march.status = worldTroopMarch.status;
                }
                var troop = SceneManager.World.CreateGroupTroop(march);
                troopList.Add(troop);
            }
        }
        if(troopList.Count==0)
        {
            var marchInfo = worldTroop.GetMarchInfo();
            if (marchInfo != null)
            {
                {
                    ChangeState(WorldTroopState.Attack);
                }
            }
            //else
            //{
            //    ChangeState(WorldTroopState.Attack);
            //}
        }
    }
    public override void OnStateLeave()
    {
        //Debug.LogError("marchinfo ===================================== level:" + worldTroop.GetMarchUUID());
        createdCount = 0;
        base.OnStateLeave();
        troopList.Clear();
    }
    private  int[] pos = new int[5] { 4, -4, 8, -8, 12 };
    public override void OnStateUpdate(float deltaTime)
    {
        base.OnStateUpdate(deltaTime);
        for (int i = 0; i < troopList.Count; i++)
        {
            var troop = troopList[i];
            if (troop.WorldTroopObjectIsCreate())
            {
                var dir = worldTroop.GetModel().transform.position + worldTroop.GetModel().transform.right * pos[createdCount];
                troop.SetPosition(dir);
                troop.SetRotation(Quaternion.LookRotation(worldTroop.GetDefenderPosition() - troop.GetPosition()));
                troop.ChangeFsmState(WorldTroopState.Attack);
                createdCount++;
               // troop.ShowHeadUI(true);
            }
        }
         //Debug.LogError("create marchinfo =====================================" + createdCount);
        if (createdCount== troopList.Count&& createdCount>0)
        {
            var marchInfo = worldTroop.GetMarchInfo();
            if (marchInfo != null)
            {
                ChangeState(WorldTroopState.Attack);
            }

        }
    }

}