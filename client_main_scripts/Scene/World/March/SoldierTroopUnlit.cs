using System.Collections;
using UnityEngine;

public class SoldierTroopUnlit : WorldTroopUnit
{
    private const string attackEffectPath = "Assets/_Art/Effect/prefab/Arms/Jiqiangbing/VFX_jiqiangbing_attack_one.prefab";
    private const string attackHitPath = "Assets/_Art/Effect/prefab/Arms/Jiqiangbing/VFX_jiqiangbing_attack_one_hit01.prefab";
    //攻击特效挂点
    private const string effectHangPoint = "A_soldier_jqb01_01/A_soldie@jqb_skin/DeformationSystem/root";
    private InstanceRequest atkEffectInst;
    private GameObject atkEffectObject = null;
    private WaitForSeconds loopWait = null;
    private WaitForSeconds birthDelay = new WaitForSeconds(0.8f);
    private bool isRun = false;


    public SoldierTroopUnlit(UnitType type, WorldTroop owner):base(type)
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
    public override void LootAt(Vector3 target)
    {
        
    }
   
   



}
