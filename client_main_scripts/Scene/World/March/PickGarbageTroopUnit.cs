using System.Collections;
using UnityEngine;
using Log = GameFramework.Log;

public class PickGarbageTroopUnit : WorldTroopUnit
{

    public PickGarbageTroopUnit(UnitType type):base(type)
    {

    }

    public override void PlayAttackEffect()
    {
        
    }

    public override void StopAttackEffect()
    {
        
    }
    
    public override void LootAt(Vector3 target)
    {
        var moveVec = (target - gameObject.transform.position);
        var moveDir = moveVec.normalized;
        var rotation = Quaternion.LookRotation(moveDir);
        gameObject.transform.rotation = rotation;
    }
}
