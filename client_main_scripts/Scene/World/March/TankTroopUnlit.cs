using System.Collections;
using UnityEngine;

public class TankTroopUnlit : WorldTroopUnit
{
    private const string effectHangPoint  = "A_soldier_tanke/A_soldie@tank_skin/to_unity/tk_Low/Root";
    private const string attackEffectPath = "Assets/_Art/Effect/prefab/Arms/Xiaotanke/VFX_xiaotanke_attack.prefab";
    private const string attackHitPath= "Assets/_Art/Effect/prefab/Arms/Xiaotanke/VFX_xiaotanke_hit.prefab"; 
    private InstanceRequest atkEffectInst;
    public TankTroopUnlit(UnitType type, WorldTroop owner) : base(type)
    {

    }
    public override void PlayAttackEffect()
    {
        base.PlayAttackEffect();
        float delay = 1;
        if (this.anim != null)
        {
            delay = this.anim.GetState(WorldTroop.Anim_Attack).length;
        }
        YieldUtils.DelayActionWithOutContext(() => {
            atkEffectInst = CreateEffect(attackEffectPath, effectHangPoint, (obj) => {
                effectList.Add(atkEffectInst);
            });
        }, delay);

        YieldUtils.DelayActionWithOutContext(() => {
            this.PlayHitEffect(attackHitPath, this.target);
        }, delay + 0.8f);

        YieldUtils.DelayActionWithOutContext(() => {
            if (atkEffectInst != null)
            {
                atkEffectInst.Destroy();
            }
        }, delay + 0.8f + 1);
    }
    public override void StopAttackEffect()
    {
        base.StopAttackEffect();

    }

    public override void Destroy()
    {
        base.Destroy();
    }

}
