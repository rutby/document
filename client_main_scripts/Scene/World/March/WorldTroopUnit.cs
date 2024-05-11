using System;
using DG.Tweening;
using UnityEngine;
using System.Collections.Generic;


public class BattleUtil
{
    public static void ReSetParticleSystems(ParticleSystem[] particles)
    {
        for (int i = 0; i < particles.Length; i++)
        {
            if (particles[i] != null)
            {
                particles[i].Simulate(0.0f);
                particles[i].Play();
            }

        }
    }

}

//
// 行军单位：士兵、坦克、飞机
//
public class WorldTroopUnit
{
    public enum UnitType
    {
        Tank,
        Infantry,
        Plane,
        Junkman,
    }
    public string Uid
    {
        get;
        set;
    }

    private enum State
    {
        Birth,
        Attack,
        Back,
        Destroy,
        MovetoGarbage,
        PickGarbage,
        PickGarbageSuccess,
        PickGarbageFailed,
        BackFromGarbage,
        ToCarrier,
    };

    private UnitType type;
    private State state;
    private InstanceRequest instance;
    private Transform transform;
    private Vector3 birthDest;
    private Vector3 pickDest;
    private Vector3 garbageObjectPos;
    private float stateTime;
    protected SimpleAnimation anim;
    protected GameObject gameObject;
    protected ParticleSystem[] particleSystems;
    public WorldTroop target;
    protected List<InstanceRequest> effectList = new List<InstanceRequest>();
    public WorldTroopUnit(UnitType type)
    {
        this.type = type;
    }

    public void CreateInstance(Action onComplete,Transform parent=null)
    {
        string prefab = "";
        if (type == UnitType.Infantry)
        {
            prefab = GameDefines.EntityAssets.WorldTroopSoldier;
            //prefab = GameDefines.EntityAssets.WorldTroopPlane;
        }
        else if (type == UnitType.Tank)
        {
            prefab = GameDefines.EntityAssets.WorldTroopTank;
            //prefab = GameDefines.EntityAssets.WorldTroopPlane;
        }
        else if (type == UnitType.Plane)
        {
            prefab = GameDefines.EntityAssets.WorldTroopPlane;
        }

        else if (type == UnitType.Junkman)
        {
            prefab = GameDefines.EntityAssets.WorldTroopJunkman;
        }
        instance = GameEntry.Resource.InstantiateAsync(prefab);
        instance.completed += delegate
        {
            gameObject = instance.gameObject;
            transform = gameObject.transform;
            transform.SetParent(parent);
            transform.localRotation = Quaternion.identity;
            anim = gameObject.GetComponentInChildren<SimpleAnimation>();
            onComplete?.Invoke();
        };
    }

    public virtual void Destroy()
    {
        instance.Destroy();
        gameObject = null;
        transform = null;
        anim = null;
    }

    public void Update()
    {
        if (instance == null || !instance.isDone || gameObject == null)
            return;

        switch (state)
        {
            case State.Birth:
            {
                if (type == UnitType.Junkman)
                {
                    // LootAt(birthDest);
                    LootAt(pickDest);
                }
                else
                {
                    var pos = Vector3.Lerp(transform.position, birthDest, Time.deltaTime * 2);
                    transform.position = pos;
                    //LootAt(owner.GetTargetTroopPosition());
                }

                stateTime -= Time.deltaTime;
                if (stateTime < 0)
                {
                    if (type == UnitType.Junkman)
                    {
                        MoveToGarbage();
                    }
                    else
                    {
                        state = State.Attack;
                    }
                    //owner.LogDebug($"{type} State.Attack");
                }

                break;
            }

            case State.Back:
            {
                var ownerPos = birthDest;
                var pos = Vector3.Lerp(transform.position, ownerPos, Time.deltaTime);
                transform.position = pos;
                stateTime -= Time.deltaTime;
                if (stateTime < 0)
                {
                    state = State.Destroy;
                    //owner.LogDebug($"{type} State.Destroy");
                }

                break;
            }

            case State.MovetoGarbage:
            {
                // LootAt(pickDest);
                stateTime -= Time.deltaTime;
                // if (stateTime <= 0.2f)
                // {
                //     LootAt(garbageObjectPos);
                // }
                // else
                // {
                //     LootAt(pickDest);
                // }

                ChangeLookAt(pickDest, garbageObjectPos, stateTime, 0.4f);
                if (stateTime < 0)
                {
                    DoPickGarbage();
                }
                break;
            }
            case State.PickGarbage:
            {
                transform.position = pickDest;
                LootAt(garbageObjectPos);
                break;
            }
            case State.PickGarbageSuccess:
            {
                transform.position = pickDest;
                stateTime -= Time.deltaTime;
                if (stateTime < 0)
                {
                    PickMoveBack();
                }
                break;
            }
            case State.BackFromGarbage:
            {
                stateTime -= Time.deltaTime;
                LootAt(birthDest);
                if (stateTime < 0)
                {
                    GotoCarrier();
                }
                break;
            }
            
            case State.ToCarrier:
            {
                stateTime -= Time.deltaTime;
                LootAt(birthDest);
                if (stateTime < 0)
                {
                    gameObject.SetActive((false));
                    state = State.Destroy;
                }
                break;
            }

            case State.Attack:
            {
                //LootAt(owner.GetTargetTroopPosition());
                break;
            }
        }
    }

    public void BirthThenAttack(Vector3 birthDest)
    {
        this.birthDest = birthDest;
        state = State.Birth;
        anim.Play(WorldTroop.Anim_Birth);
        anim.PlayQueued(WorldTroop.Anim_Attack);

        stateTime = 1;
        var animState = anim.GetState(WorldTroop.Anim_Birth);
        if (animState != null)
        {
            stateTime = animState.length;
        }
    }

    public void BirthThenMoveToGarbage(Vector3 birthDest, Vector3 pickDest, Vector3 garbageObjectPos)
    {
        if (anim != null)
        {
            this.birthDest = birthDest;
            this.pickDest = pickDest;
            this.garbageObjectPos = garbageObjectPos;
            state = State.Birth;
            anim.Play(WorldTroop.Anim_Pick_Garbage_Run);
            stateTime = 0.4f;
            var middlePt = (transform.position + birthDest) / 2;
            middlePt.y = 1.95f;
            transform.DOMove(birthDest, stateTime).SetEase(Ease.InBack);
        
            var sequence = DOTween.Sequence();
            sequence.Append(transform.DOMove(middlePt, stateTime * 0.3f).SetEase(Ease.OutSine));
            sequence.Append(transform.DOMove(birthDest, stateTime * 0.7f).SetEase(Ease.InSine));
            sequence.PlayForward();
        }
    }
    
    private void MoveToGarbage()
    {
        if (anim != null)
        {
            state = State.MovetoGarbage;
            anim.Play(WorldTroop.Anim_Pick_Garbage_Run);
            var distance = Vector3.Distance(birthDest, pickDest);
            var speed = 4.0f;
            stateTime = distance / speed;
            transform.DOMove(pickDest, stateTime).SetEase(Ease.Linear);
        }
        
        // var sequence = DOTween.Sequence();
        // sequence.Append(transform.DOScale(new Vector3(transform.localScale.x, transform.localScale.y, transform.localScale.z), stateTime * 0.78f));
        // sequence.Append(transform.DORotate(birthDest, stateTime * 0.7f).SetEase(Ease.InCubic));
        // sequence.PlayForward();
    }

    private void GotoCarrier()
    {
        if (anim != null)
        {
            stateTime = 0.4f;
            state = State.ToCarrier;
            anim.Play(WorldTroop.Anim_Pick_Garbage_Run);
            var endPt = birthDest + new Vector3(0, 1.6f, 0);
            var middlePt = (endPt + birthDest) / 2;
            middlePt.y = 1.95f;
            transform.DOMove(birthDest, stateTime).SetEase(Ease.InBack);
            
            var sequence = DOTween.Sequence();
            sequence.Append(transform.DOMove(middlePt, stateTime * 0.7f).SetEase(Ease.OutSine));
            sequence.Append(transform.DOMove(endPt, stateTime * 0.3f).SetEase(Ease.InSine));
            sequence.PlayForward();
        }
    }

    private void DoPickGarbage()
    {
        if (anim != null)
        {
            state = State.PickGarbage;
            anim.Play(WorldTroop.Anim_Pick_Garbage);
            var animationState = anim.GetState(WorldTroop.Anim_Pick_Garbage);
            if (animationState != null)
            {
                var speed = animationState.speed;
                animationState.speed = 2.0f;
            }
        }
    }
    
    public void BirthThenPickGarbage(Vector3 birthDest, Vector3 pickDest, Vector3 garbageObjectPos)
    {
        this.birthDest = birthDest;
        this.pickDest = pickDest;
        this.garbageObjectPos = garbageObjectPos;
        DoPickGarbage();
    }

    public void PickGarbageSuccess()
    {
        if (anim != null)
        {
            stateTime = 0.6f;
            state = State.PickGarbageSuccess;
            anim.Play(WorldTroop.Anim_Pick_Garbage_Success);
        }
    }

    public void PickMoveBack()
    {
        if (anim != null)
        {
            state = State.BackFromGarbage;
            var distance = Vector3.Distance(birthDest, pickDest);
            var speed = 4.0f;
            stateTime = Math.Min(distance / speed, 1);
        
            transform.DOMove(birthDest, stateTime).SetEase(Ease.Linear);
            anim.Play(WorldTroop.Anim_Pick_Garbage_Run);
        }
    }

    public void Back()
    {
        state = State.Back;
        if(anim!=null)
        {
            anim.Play(WorldTroop.Anim_Back);
            //owner.LogDebug($"{type} Back");
            stateTime = 1;
            var animState = anim.GetState(WorldTroop.Anim_Back);
            if (animState != null)
            {
                stateTime = animState.length;
            }
        }
        YieldUtils.DelayActionWithOutContext(() => { Destroy(); }, 1);
    }

    public void Attack()
    {
        state = State.Attack;
        anim.Play(WorldTroop.Anim_Attack);
        //owner.LogDebug($"{type} Attack");
    }

    public void SetPosition(Vector3 pos)
    {
        transform.position = pos;
    }

    public virtual void LootAt(Vector3 target)
    {
        transform.LookAt(target);
    }

    public virtual void ChangeLookAt(Vector3 start, Vector3 end, float currentTime, float totalTime)
    {
        if (currentTime >= totalTime)
        {
            transform.LookAt(start);
        }
        else
        {
            float ratio = (totalTime - currentTime) / totalTime;
            ratio = Math.Max(ratio, 0.0f);
            ratio = Math.Min(ratio, 1.0f);
            var current = Vector3.Lerp(start, end, ratio);
            transform.LookAt(current);
        }
    }

    public bool IsBackFinish()
    {
        return state == State.Destroy;
    }
    public virtual void PlayAttackEffect()
    {
    //    Debug.LogError("PlayAttackEffect:"+Time.realtimeSinceStartup);

    }
    public virtual void StopAttackEffect()
    {
        if(target!=null)
        {
            target.ClearHitEffect();
        }
        for (int i = 0; i < effectList.Count; i++)
        {
            effectList[i].Destroy();
        }
        effectList.Clear();

    }
    protected InstanceRequest CreateEffect(string path,string effectHangPoint, Action<GameObject> onComplete)
    {
        var req = GameEntry.Resource.InstantiateAsync(path);
        req.completed += delegate
        {
            var atkEffectObject = req.gameObject;
            if(atkEffectObject==null)
            {
                Debug.Log(string.Format("init {0} error", path));
                return;
            }
            if(gameObject==null)
            {
                return;
            }
            var point = gameObject.transform.Find(effectHangPoint);
            if (point != null)
            {
                atkEffectObject.transform.SetParent(point);

                atkEffectObject.transform.localPosition = Vector3.zero;
                atkEffectObject.transform.localRotation = Quaternion.identity;
                atkEffectObject.transform.localScale = Vector3.one;
                onComplete(atkEffectObject);
            }
        };
        return req;
    }
    protected void ReSetParticleSystems()
    {
        BattleUtil.ReSetParticleSystems(particleSystems);
    }


    protected virtual void PlayHitEffect(string effectPath, WorldTroop target)
    {
        if(target==null)
        {
          
            return;
        }
        target.PlayHitEffect(effectPath);
        
    }
}