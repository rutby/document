
using System;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using UnityEngine;
using DG.Tweening;
using XLua;
using Object = UnityEngine.Object;

//
// 世界行军部队，包括：玩家、怪物、BOSS
//
public class WorldTroop : WorldCulling.ICullingObject
{
    public float delStartTick = 0;
    private WorldTroopStateMachine sm;
    private InstanceRequest requestInst;
    private InstanceRequest fdInst = null;
    private SimpleAnimation simpleAni;
    
    private InstanceRequest _troopDestinationInst;
    private WorldTroopDestinationSignal _troopDestination;
    protected bool isSHowDestination = false;
    private InstanceRequest shieldRequest = null;
    private List<InstanceRequest> normalAttackInstList = new List<InstanceRequest>();
    private List<InstanceRequest> skillInstList = new List<InstanceRequest>();
    private List<InstanceRequest> fdInstList = new List<InstanceRequest>();
    private InstanceRequest detectEventInst;
    private InstanceRequest keyRequest;
    private Transform transform;
    private WorldScene world;
    private bool cullVisible;//用于减少计算
    private bool _visible;//真正用于显示
    private int monsterLevel;
    private bool isDelayDestroy;
    private float delayDestroySec;
    private bool IsAddShield = false;
    private GameObject model;
    private GameObject icon;
    private Dictionary<string, GameObject> performanceDict = new Dictionary<string, GameObject>();
    private UIWorldLabel[] labels;
    private SimpleAnimation[] anims;
    private GPUSkinningAnimator[] gpuAnims;
    private ModelHeight _modelHeight;
    private TouchObjectEventTrigger touchEvent;

    private GameObject rotationRoot;
    // private InstanceRequest headUIInst; 
    // private WorldTroopHeadUI headUI;
    // private InstanceRequest nameTextInst;
    private const float BoundingSphereRadius = 2.0f;
    private BoundingSphere boundingSphere = new BoundingSphere(Vector3.zero, BoundingSphereRadius);

    private WorldMarch marchInfo;
    private SpriteRenderer spriteRenderer;
    private GameObject headObj;
    private SpriteRenderer headBg;
    private SpriteRenderer headIcon;
    private SpriteRenderer marchStateIcon;
    private List<WorldTroopUnit> troopUnits = new List<WorldTroopUnit>();
    private Dictionary<Renderer, Material> _rendererMaterils = new Dictionary<Renderer, Material>();
    private AutoAdjustLod adjuster = null;

    private static readonly int Prop_Fresnel_switch = Shader.PropertyToID("_Fresnel_switch");
    private static readonly int Prop_Fresnel_Color_switch = Shader.PropertyToID("_Fresnel_Color_switch");

    private const string sheldPath = "Assets/_Art/Effect/prefab/hero/Shaonian/VFX_shaonian_hudun.prefab";
    private const string secretKeyPath = "Assets/_Art/Effect/prefab/scene/Common/VFX_secret_key.prefab";
    public const string skillWordPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
    public const string skillCarWordPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCarDecBloodTip.prefab";
    public const string BattleCriticalWordPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCriticalDecBloodTip.prefab";
    public const string normalWordPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
    public const string cureWordPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCureBloodTip .prefab";
    public const string battleVictoryPath = "Assets/_Art/Effect/prefab/scene/VFX_victory.prefab";
    public const string battleFailurePath = "Assets/_Art/Effect/prefab/scene/VFX_failure.prefab";
    public const string battleDefeatPath = "Assets/_Art/Effect/prefab/scene/VFX_defeat.prefab";

    private const string fdBirthEPath = "Assets/_Art/Effect/prefab/Arms/Feidie/VFX_feidie_brith.prefab";
    private const string fdOutPutEPath = "Assets/_Art/Effect/prefab/Arms/Feidie/VFX_feidie.prefab";
    private const string fdPath = "Assets/_Art/Models/Vehicle/FeiDie/prefab/A_vehicle_fd.prefab";
    private const string challengeBossEffect = "Assets/_Art/Effect/prefab/monster/Dashachong/VFX_shachong_zhaohuan.prefab";
    private const string ybcPath = "Model/A_vehicle_ybc_prefab";
    private const string iconPath = "Icon";
    private const string performancePath = "Model/Performance";
    private const string spritePath = "Icon/Sprite";
    private const string lablePath = "Label";
    private const string modelPath1 = "Model";
    private const string modelPath2 = "ModelLayer/Model";
    private const string fdEffectPoint = "A_vehicle_fd_skin/Root";
    private const string marchPath = "March_{0}";
    private const string hangRotationRoot = "rotationRoot";
    public const string Anim_Birth = "birth";
    public const string Anim_Idle = "idle";
    public const string Anim_Run = "run";
    public const string Anim_Attack = "attack";
    public const string Anim_Hit = "hit";
    public const string Anim_Death = "death";
    public const string Anim_Stop = "stop";
    public const string Anim_Back = "back";
    public const string Anim_Pick_Garbage = "xiaoren_work";
    public const string Anim_Pick_Garbage_Run = "xiaoren_run";
    public const string Anim_Pick_Garbage_Success = "xiaoren_show";

    private const string huangPoint = "A_vehicle_ybc_prefab/root";
    public const float AttackRange = 6;
    public const float range = 4;

    public long defAtkUuid;
    private bool detectEventActiveCache = true;
    private static readonly Vector3[] TankPos =
    {
        new Vector3(-0.8f, 0.051f, 1.722f + 0.632f),
        new Vector3(0.739f, 0.051f, 1.681f + 0.632f)
    };
    private static readonly Vector3[] InfantryPos =
    {
        new Vector3(-2.038f, -0.138f, 0.1589999f + 0.632f),
        new Vector3(-1.987f, -0.138f, -1.56f + 0.632f),
        new Vector3(2.121f, -0.138f, -1.56f + 0.632f),
        new Vector3(2.121f, -0.138f, 0.1099999f + 0.632f),
    };
    private static readonly Vector3[] PlanePos =
    {
        new Vector3(-1.733f, 2.263f, -2.244f + 0.632f),
        new Vector3(1.909f, 2.443f, -2.466f + 0.632f)
    };

    private static readonly Vector3[] GarbageBirthPos =
    {
        new Vector3(0.0f, 0.0f, 3.0f),//1
        new Vector3(2.1f, 0.0f, 0.4f),//2
        new Vector3(1.5f, 0.0f, 1.65f),//3
        new Vector3(-1.5f, 0.0f, 1.65f),//4
        new Vector3(-2.1f, 0.0f, 0.4f),//5
    };
    // private static readonly Vector3[] GarbagePickPos =
    // {
    //     new Vector3(0.0f, 0.0f, 5.0f),
    //     new Vector3(-0.7f, 0.0f, 7.31f),
    //     new Vector3(0.7f, 0.0f, 7.31f),
    //     new Vector3(-1.02f, 0.0f, 5.67f),
    //     new Vector3(1.02f, 0.0f, 5.67f),
    // };
    private bool isBattle = false;
    private bool showBattleEffect = false;
    private bool showGunAttack = false;
    private string _effectPdName = "";//炮弹特效名字
    private string _effectPkName = "";//炮口特效名字
    private string _effectHitName = "";//被攻击特效名字
    private float _attackHeight = 7.0f;//炮弹飞行高度
    
    public bool IsBattle()
    {
        //被攻击时，march数据不刷新
        return isBattle;
    }
    public void SetIsBattle(bool value)
    {
        isBattle = value;
    }
    public WorldTroop(WorldScene world)
    {
        sm = new WorldTroopStateMachine(this);
        this.world = world;
    }

    public void Create(WorldMarch march,bool showEffect,bool gunAttack)
    {
        showBattleEffect = showEffect;
        showGunAttack = gunAttack;
        if (march == null)
        {
            return;
        }

        marchInfo = march;

        if (IsMonsterTroop()|| marchInfo.type == NewMarchType.ACT_BOSS || marchInfo.type == NewMarchType.PUZZLE_BOSS || marchInfo.type == NewMarchType.ALLIANCE_BOSS)
        {
            var tempLevel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.APSMonster, marchInfo.monsterId,"level");
            if (!tempLevel.IsNullOrEmpty())
            {
                monsterLevel = tempLevel.ToInt();
            }
            else
            {
                monsterLevel = 1;
            }

        }
        
        InstantiateTroopObject();

        GameEntry.Event.Subscribe(EventId.MarchItemUpdateSelf, UpdateSelfMarch);
    }

    public bool IsDelayDestroyed
    {
        get { return isDelayDestroy && delayDestroySec <= 0; }
    }

    public void DelayDestroy(float delaySec)
    {
        isDelayDestroy = true;
        delayDestroySec = delaySec;
        sm.ChangeState(WorldTroopState.Death);
    }

    public void Destroy()
    {
        DestroyTroopObject();
        world.RemovePosAndRotationDataByMarchUuid(marchInfo.uuid);
        foreach (var i in troopUnits)
        {
            i.Destroy();
        }
        troopUnits.Clear();
        if (touchEvent != null)
        {
            touchEvent.onPointerUp = null;
            touchEvent.onPointerDown = null;
            touchEvent.onPointerClick = null;
            touchEvent.onPointerDoubleClick = null;
            touchEvent.onBeginDrag = null;
            touchEvent.onDrag = null;
            touchEvent.onEndDrag = null;
            touchEvent = null;
        }

        if (marchInfo.type == NewMarchType.NORMAL || marchInfo.type == NewMarchType.ASSEMBLY_MARCH)
        {
            GameEntry.Event.Fire(EventId.HideTroopAtkBuildIcon,marchInfo.uuid);
            GameEntry.Event.Fire(EventId.HideMarchTrans,marchInfo.uuid);
            GameEntry.Event.Fire(EventId.HideTroopName,marchInfo.uuid);
        }
        GameEntry.Event.Fire(EventId.HideTroopHead,marchInfo.uuid);
        if (shieldRequest != null)
        {
            shieldRequest.Destroy();
            shieldRequest = null;
        }

        if (keyRequest != null)
        {
            keyRequest.Destroy();
            keyRequest = null;
        }
        RemoveAttack();
        if (skillInstList != null)
        {
            foreach (var VARIABLE in skillInstList)
            {
                if (VARIABLE != null)
                {
                    VARIABLE.Destroy();
                }
            }
            skillInstList.Clear();
        }
        if (fdInstList != null)
        {
            foreach (var VARIABLE in fdInstList)
            {
                if (VARIABLE != null)
                {
                    VARIABLE.Destroy();
                }
            }
            fdInstList.Clear();
        }
        
        if (detectEventInst != null)
        {
            detectEventInst.Destroy();
            detectEventInst = null;
        }

        DestroyTroopDestinationSignal();
        GameEntry.Lua.Call("UIUtil.CloseWorldMarchTileUI",marchInfo.uuid);
        
        if (GameEntry.Lua.UIManager.IsWindowOpen("UIAllianceRally"))
        {
            GameEntry.Lua.UIManager.DestroyWindow("UIAllianceRally");
        }
        GameEntry.Event.Unsubscribe(EventId.MarchItemUpdateSelf, UpdateSelfMarch);
    }

    public void LogDebug(string msg)
    {
        if (marchInfo != null && marchInfo.ownerUid == GameEntry.Data.Player.Uid)
        {
            //Log.Debug("WorldTroop: " + msg);
        }
    }

    public void ChangeShowEffectState(bool showEffect)
    {
        if (showEffect != showBattleEffect)
        {
            if (showBattleEffect)
            {
                if (shieldRequest != null)
                {
                    shieldRequest.Destroy();
                    shieldRequest = null;
                }
                RemoveAttack();
                if (skillInstList != null)
                {
                    foreach (var VARIABLE in skillInstList)
                    {
                        if (VARIABLE != null)
                        {
                            VARIABLE.Destroy();
                        }
                    }
                    skillInstList.Clear();
                }
            }

            showBattleEffect = showEffect;
        }
    }
    public void ChangeShowGunEffectState(bool showEffect)
    {
        showGunAttack = showEffect;
    }
    public void UpdateSelfMarch(object o)
    {
        CheckShowTroopDestination();
    }
    private void ShowTroopDestinationSignal(EnumDestinationSignalType signalType,int tileSize)
    {
        if (model == null)
        {
            return;
        }
        if (_troopDestinationInst == null)
        {
            CreateTroopDestinationSignal(signalType, tileSize);
            isSHowDestination = true;
        }
        else if(_troopDestinationInst!=null && _troopDestination!=null)
        {
            var localDestination = GetPosition();
            _troopDestination.SetDestinationForMarch(localDestination,signalType,tileSize);
            isSHowDestination = true;
        }
    }
    private void HideTroopDestinationSignal()
    {
        if (_troopDestinationInst != null)
        {
            if (_troopDestination != null)
            {
                _troopDestination.HideDestination();
            }
            else
            {
                DestroyTroopDestinationSignal();
            }
        }

        isSHowDestination = false;
    }
    private void CreateTroopDestinationSignal(EnumDestinationSignalType signalType,int tileSize)
    {
        if (model == null)
        {
            return;
        }
        _troopDestinationInst =
            GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopDestinationSignal);
        _troopDestinationInst.completed += delegate(InstanceRequest request)
        {
            if (model == null)
            {
                DestroyTroopDestinationSignal();
                return;
            }
            _troopDestinationInst.gameObject.transform.SetParent(model.transform);
            _troopDestinationInst.gameObject.transform.localScale = Vector3.one;
            _troopDestination = _troopDestinationInst.gameObject.GetComponent<WorldTroopDestinationSignal>();
            var localDestination = GetPosition();
            _troopDestination.SetDestinationForMarch(localDestination,signalType,tileSize);
        };
    }
    private void DestroyTroopDestinationSignal()
    {
        if (_troopDestinationInst != null)
        {
            _troopDestinationInst.Destroy();
            _troopDestinationInst = null;
            _troopDestination = null;
        }
        isSHowDestination = false;
    }
    
    private void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        if (marchInfo != null)
        {
            var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
            foreach (var VARIABLE in selfMarchList)
            {
                if (VARIABLE.IsVisibleMarch() == false)
                {
                    continue;
                }
                if (VARIABLE.targetUuid == marchInfo.uuid)
                {
                    needHide = false;
                    Vector3 targetRealPos = Vector3.zero;
                    int tileSize = 1;
                    var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                        0, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                    ShowTroopDestinationSignal(destinationType, tileSize);
                    break;
                }
            }
        }
        

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
    private void InstantiateTroopObject()
    {
        string prefabPath = null;
        if (marchInfo.type == NewMarchType.ASSEMBLY_MARCH)
            prefabPath = GameDefines.EntityAssets.WorldRallyTroop;
        else if (marchInfo.type == NewMarchType.NORMAL || marchInfo.type == NewMarchType.DIRECT_MOVE_MARCH)
        {
            //这里有两种方案 我选了方案1, 性能消耗过大，改成了方案2
            //1.直接调用lua，所有实现判断全部由lua实现，优点便于日后热更，加功能，缺点，每次创建新车调用一次lua
            //2.使用缓存处理，从lua中拿一次所有模型数据，使用哪个模型在C#写，优点 效率高，不用频繁调用lua，缺点，拓展性为0

            // //方案1
            // int skinId = marchInfo.GetSkinId();
            // var luaData = GameEntry.Lua.CallWithReturn<LuaTable, int, long, string, string, int>(
            //     "CSharpCallLuaInterface.GetMarchSkinNameBySkinId", skinId, marchInfo.uuid, 
            //     marchInfo.ownerUid, marchInfo.allianceUid, (int)marchInfo.target);
            // if (luaData != null)
            // {
            //     prefabPath = luaData.Get<string>("prefabName");
            //     _effectPdName = luaData.Get<string>("pdName");
            //     _effectPkName = luaData.Get<string>("pkName");
            //     _effectHitName = luaData.Get<string>("hitName");
            //     _attackHeight = luaData.Get<float>("height");
            // }
            
            //方案2
            if (marchInfo.target == MarchTargetType.SAMPLE)
            {
                prefabPath = GameDefines.EntityAssets.WorldTroopSample;
                
            }
            else
            {
                var marchPrefabType = MarchPrefabType.Self;
                var uid = GameEntry.Data.Player.GetUid();
                if (uid == marchInfo.ownerUid)
                {
                    //自己（绿色）
                    marchPrefabType = MarchPrefabType.Self;
                }
                else
                {
                    var allianceId = GameEntry.Data.Player.GetAllianceId();
                    if (!string.IsNullOrEmpty(allianceId) && allianceId == marchInfo.allianceUid)
                    {
                        //盟友（蓝色）
                        marchPrefabType = MarchPrefabType.Alliance;
                    }
                    else if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER && GameEntry.Data.Player.IsAllianceSelfCamp(marchInfo.allianceUid))
                    {
                        //同阵营（黄色）
                        marchPrefabType = MarchPrefabType.Camp;
                    }
                    else
                    {
                        //敌人（红色）
                        marchPrefabType = MarchPrefabType.Other;
                    }
                }
                
                //皮肤
                int skinId = marchInfo.GetSkinId();
                if (!WorldScene.ModelPathDic.ContainsKey(skinId))
                {
                    var luaData = GameEntry.Lua.CallWithReturn<LuaTable, int>(
                        "CSharpCallLuaInterface.GetMarchSkinNameBySkinId", skinId);
                    if (luaData != null)
                    {
                        if (luaData.ContainsKey("prefabName"))
                        {
                            if (!WorldScene.ModelPathDic.ContainsKey(skinId))
                            {
                                WorldScene.ModelPathDic[skinId] = new Dictionary<int, string>();
                            }
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkinSelf] = luaData.Get<string>("prefabName");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkin_EFFECT_PK] = luaData.Get<string>("pkName");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkin_EFFECT_PD] = luaData.Get<string>("pdName");;
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkin_EFFECT_HIT] = luaData.Get<string>("hitName");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkin_ATTACK_HEIGHT] = luaData.Get<string>("height");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkinAlliance] = luaData.Get<string>("prefabNameAlliance");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkinCamp] = luaData.Get<string>("prefabNameCamp");
                            WorldScene.ModelPathDic[skinId][(int)WorldPointType.MarchSkinOther] = luaData.Get<string>("prefabNameOther");
                        }
                    }
                }
                var skinDic = WorldScene.ModelPathDic[skinId];
                if (skinDic != null)
                {
                    _effectPdName = skinDic[(int)WorldPointType.MarchSkin_EFFECT_PD];
                    _effectPkName = skinDic[(int)WorldPointType.MarchSkin_EFFECT_PK];
                    _effectHitName = skinDic[(int)WorldPointType.MarchSkin_EFFECT_HIT];
                    _attackHeight = skinDic[(int)WorldPointType.MarchSkin_ATTACK_HEIGHT].ToFloat();
                    switch (marchPrefabType)
                    {
                        case MarchPrefabType.Self:
                        {
                            prefabPath = skinDic[(int)WorldPointType.MarchSkinSelf];
                        }
                            break;
                        case MarchPrefabType.Alliance:
                        {
                            prefabPath = skinDic[(int)WorldPointType.MarchSkinAlliance];
                        }
                            break;
                        case MarchPrefabType.Camp:
                        {
                            prefabPath = skinDic[(int)WorldPointType.MarchSkinCamp];
                        }
                            break;
                        case MarchPrefabType.Other:
                        {
                            prefabPath = skinDic[(int)WorldPointType.MarchSkinOther];
                        }
                            break;
                    }
                }
            }
        }
        else if (marchInfo.type == NewMarchType.MONSTER || marchInfo.type == NewMarchType.BOSS || marchInfo.type == NewMarchType.CHALLENGE_BOSS || marchInfo.type== NewMarchType.MONSTER_SIEGE)
        {
            var levelId = marchInfo.monsterId;
        
            var modelName= "";
            var type = (int)WorldPointType.WorldMonster;
            if (WorldScene.ModelPathDic.ContainsKey(levelId))
            {
                var item = WorldScene.ModelPathDic[levelId];
                if (item.ContainsKey(type))
                {
                    modelName = item[type];
                }
            }
            if (modelName.IsNullOrEmpty())
            {
                modelName =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.APSMonster, marchInfo.monsterId,"model_name");
                if (!WorldScene.ModelPathDic.ContainsKey(levelId))
                {
                    WorldScene.ModelPathDic[levelId] = new Dictionary<int, string>();
                }

                WorldScene.ModelPathDic[levelId][type] = modelName;
            }
            if (!string.IsNullOrEmpty(modelName))
                prefabPath = string.Format(GameDefines.EntityAssets.MonsterPath,modelName);
            if (string.IsNullOrEmpty(prefabPath))
            {
                Log.Error("monster prefab is null, " + marchInfo.monsterId);
            }
        }
        else if (marchInfo.type == NewMarchType.SCOUT)
        {
            prefabPath = GameDefines.EntityAssets.ScoutTroop;
        }
        else if (marchInfo.type == NewMarchType.RESOURCE_HELP)
        {
            prefabPath = GameDefines.EntityAssets.ResTransTroop;
        }
        else if (marchInfo.type == NewMarchType.GOLLOES_EXPLORE)
        {
            prefabPath = GameDefines.EntityAssets.GolloesExploreTroop;
        }
        else if (marchInfo.type == NewMarchType.GOLLOES_TRADE)
        {
            prefabPath = GameDefines.EntityAssets.GolloesTradeTroop;
        }
        else if (marchInfo.type == NewMarchType.EXPLORE)
        {
            prefabPath = GameDefines.EntityAssets.WorldTroop;
        }
        else if (marchInfo.type == NewMarchType.ACT_BOSS)
        {
            prefabPath = GameDefines.EntityAssets.MonsterActBoss;
        }
        else if (marchInfo.type == NewMarchType.PUZZLE_BOSS)
        {
            prefabPath = GameDefines.EntityAssets.MonsterActBoss;
        }
        else if (marchInfo.type == NewMarchType.ALLIANCE_BOSS)
        {
            prefabPath = GameDefines.EntityAssets.AllianceBossModel;
        }
        if (prefabPath == null)
            return;
        
        requestInst = GameEntry.Resource.InstantiateAsync(prefabPath);
        requestInst.completed += OnGameObjectCreate;
    }

    private void DestroyTroopObject()
    {
        this.UnLoadFd();
       // this.HideHeadUI(true);
        //this.BackTroopUnits();
        this.ClearEffect();

        foreach (var i in _rendererMaterils)
        {
            UnityEngine.Object.Destroy(i.Key.material);
            i.Key.sharedMaterial = i.Value;
        }
        _rendererMaterils.Clear();
        
        if (requestInst!=null)
        {
            requestInst.Destroy();
        }

        requestInst = null;
        transform = null;
        model = null;
        icon = null;
        labels = null;
        anims = null;
        gpuAnims = null;
        cullVisible = false;
        world.RemoveCullingBounds(this);
    }
    public WorldMarch GetMarchInfo()
    {
        return marchInfo;
    }
    public bool WorldTroopObjectIsCreate()
    {
        return transform != null;
    }

   private void OnGameObjectCreate(InstanceRequest request)
    {
        request.gameObject.name = string.Format(marchPath, marchInfo.uuid);
        transform = request.gameObject.transform;
        transform.parent = world.DynamicObjNode;
        world.AddCullingBounds(this);

        icon = transform.Find(iconPath).gameObject;
        model = (transform.Find(modelPath1) ?? transform.Find(modelPath2)).gameObject;
        InitLod(request.gameObject);
        if (marchInfo != null && marchInfo.type == NewMarchType.BOSS)
        {
            var tempModel = transform.Find("Model/A_animal_shachong_gpuskin")?.gameObject;
            if (tempModel != null)
            {
                model = tempModel;
            }
        }
        anims = model.GetComponentsInChildren<SimpleAnimation>();
        gpuAnims = model.GetComponentsInChildren<GPUSkinningAnimator>();
        if (showBattleEffect ==false)
        {
            if (anims != null)
            {
                foreach (var VARIABLE in anims)
                {
                    VARIABLE.enabled = false;
                }
            }
            if (gpuAnims != null)
            {
                foreach (var VARIABLE in gpuAnims)
                {
                    VARIABLE.enabled = false;
                }
            }

            anims = null;
            gpuAnims = null;
        }
        
        _modelHeight = transform.GetComponent<ModelHeight>();
        spriteRenderer = transform.Find(spritePath)?.GetComponentInChildren<SpriteRenderer>(true);
        if (icon != null)
        {
            headObj = icon.transform.Find("head")?.gameObject;
            if (headObj != null)
            {
                headBg = headObj.transform.Find("headbg")?.GetComponentInChildren<SpriteRenderer>(true);
                headIcon = headObj.transform.Find("headIcon")?.GetComponentInChildren<SpriteRenderer>(true);
                marchStateIcon = headObj.transform.Find("stateIcon")?.GetComponentInChildren<SpriteRenderer>(true);
            }
        }

        rotationRoot = transform.Find(hangRotationRoot)?.gameObject;
        touchEvent = transform.GetComponentInChildren<TouchObjectEventTrigger>(true);
        touchEvent.onPointerDown = OnPointerDown;
        touchEvent.onPointerClick = OnClick;
        touchEvent.onPointerDoubleClick = OnDoubleClick;
        touchEvent.onBeginDrag = OnBeginDrag;
        touchEvent.onDrag = OnDrag;
        touchEvent.onEndDrag = OnEndDrag;
        touchEvent.onPointerUp = OnPointerUp;
        
        var adjust = transform.GetComponent<AutoAdjustScale>();
        if (adjust != null)
        {
            adjust.enabled = true;
        }
        if (IsMonsterTroop()||marchInfo.type == NewMarchType.ACT_BOSS || marchInfo.type == NewMarchType.PUZZLE_BOSS)
        {
            labels = transform.GetComponentsInChildren<UIWorldLabel>(true);
            Array.ForEach(labels, label => label.SetLevel(monsterLevel));
        }
        else if (marchInfo.type == NewMarchType.ALLIANCE_BOSS)
        {
            labels = transform.GetComponentsInChildren<UIWorldLabel>(true);
            var tempName = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.APSMonster, marchInfo.monsterId,"name");
            var alliance = GameEntry.Localization.GetString("311026", marchInfo.allianceAbbr,GameEntry.Localization.GetString(tempName));
            Array.ForEach(labels, label =>
            {
                label.SetLevel(monsterLevel);
                label.SetName(alliance);
            });
        }
        else
        {
            GameEntry.Event.Fire(EventId.HideTroopHead, GetMarchUUID());
            GameEntry.Event.Fire(EventId.ShowTroopName, GetMarchUUID());
        }
        if (marchInfo.IsMasstroops())
        {
            fdInst = GameEntry.Resource.InstantiateAsync(fdPath);
            fdInst.completed += (r) =>
            {
                var ybc = transform.Find(ybcPath);
                ybc.gameObject.SetActive(false);
                r.gameObject.transform.SetParent(model.transform);
                r.gameObject.transform.localPosition = Vector3.zero;
                r.gameObject.transform.localScale = Vector3.one;
                r.gameObject.transform.localRotation = Quaternion.identity;
                simpleAni = r.gameObject.GetComponentInChildren<SimpleAnimation>();
                CreateFdBirthEffect();
                // simpleAni.Play(WorldTroop.Anim_Birth);
                simpleAni.PlayQueued(WorldTroop.Anim_Run);
            };
        }
        else
        {
            var ybc = transform.Find(ybcPath);
            if (ybc != null)
            {
                ybc.gameObject.SetActive(true);
            }
        }
        

        performanceDict.Clear();
        Transform performanceRoot = transform.Find(performancePath);
        if (performanceRoot != null)
        {
            foreach (Transform tf in performanceRoot)
            {
                performanceDict.Add(tf.name, tf.gameObject);
            }
        }

        InitTroopColor();
        InitPositionRotation();
        EnterInitState();
        ShowDetectEvent();
        UpdateIconSprite();
        UpdatePerformance();
        UpdateMarchSecretKey();
        AdjustIcon();
        transform.gameObject.SetActive(_visible);
        GameEntry.Event.Fire(EventId.WorldTroopGameObjectCreateFinish, marchInfo.uuid.ToString());
    }
   
    public void InitLod(GameObject gameObject)
    {
        LodType lodType = LodType.None;
        bool noOptimizeActivate = false;
        
        if (marchInfo.type == NewMarchType.NORMAL ||
            marchInfo.type == NewMarchType.ASSEMBLY_MARCH ||
            marchInfo.type == NewMarchType.SCOUT ||
            marchInfo.type == NewMarchType.EXPLORE ||
            marchInfo.type == NewMarchType.RESOURCE_HELP ||
            marchInfo.type == NewMarchType.GOLLOES_EXPLORE ||
            marchInfo.type == NewMarchType.GOLLOES_TRADE ||
            marchInfo.type == NewMarchType.DIRECT_MOVE_MARCH ||
            marchInfo.type == NewMarchType.CHALLENGE_BOSS)
        {
            string allianceId = GameEntry.Data.Player.GetAllianceId();
            if (marchInfo.ownerUid == GameEntry.Data.Player.Uid)
            {
                lodType = LodType.TroopSelf;
            }
            else if (!allianceId.IsNullOrEmpty() && marchInfo.allianceUid == allianceId)
            {
                lodType = LodType.TroopAlly;
            }
            else
            {
                lodType = LodType.TroopOther;
            }
            noOptimizeActivate = true;
        }
        else if (marchInfo.type == NewMarchType.MONSTER ||
                 marchInfo.type == NewMarchType.BOSS||marchInfo.type == NewMarchType.MONSTER_SIEGE ||
                 marchInfo.type == NewMarchType.ALLIANCE_BOSS)
        {
            lodType = LodType.Monster;
            noOptimizeActivate = false;
        }
        else if (marchInfo.type == NewMarchType.ACT_BOSS ||
                 marchInfo.type == NewMarchType.PUZZLE_BOSS ||
                 marchInfo.type == NewMarchType.CHALLENGE_BOSS
                 )
        {
            lodType = LodType.WorldBoss;
            noOptimizeActivate = false;
        }
        
        adjuster = gameObject.GetComponent<AutoAdjustLod>();
        if (lodType != LodType.None)
        {
            if (adjuster == null)
            {
                adjuster = gameObject.AddComponent<AutoAdjustLod>();
            }
            adjuster.SetNoOptimizeActivate(noOptimizeActivate);
            adjuster.SetLodType(lodType);
        }
        else
        {
            if (adjuster != null)
            {
                Object.Destroy(adjuster);
            }
        }
    }
   
    public void UnLoadFd()
    {
        if (fdInst != null)
        {
            CreateFdBirthEffect();
            fdInst.Destroy();
            fdInst = null;
         
        }
    }
    public void MoveFd()
    {
        if (fdInst != null)
        {
            if (fdInst.gameObject != null)
            {
                fdInst.gameObject.transform.DOLocalMove(Vector3.back * 5, 0.5f);
                CreateFdOutPutEffect();
            }

        }

    }
    public void CreateFdBirthEffect()
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        // var effectInst = GameEntry.Resource.InstantiateAsync(fdBirthEPath);
        // fdInstList.Add(effectInst);
        // effectInst.completed += (r) =>
        // {
        //     if (fdInst!=null && fdInst.gameObject != null)
        //     {
        //         var hangPoint = fdInst.gameObject.transform.Find(fdEffectPoint);
        //         r.gameObject.transform.SetParent(hangPoint);
        //         r.gameObject.transform.localPosition = new Vector3(-2f, 0, 0);
        //         r.gameObject.transform.localScale = Vector3.one;
        //         r.gameObject.transform.localRotation = Quaternion.identity;
        //         YieldUtils.DelayActionWithOutContext(() => { effectInst.Destroy(); }, 0.5f);
        //     }
        //     else
        //     {
        //         effectInst.Destroy();
        //     }
        //     
        // };
    }
    public void CreateFdOutPutEffect()
    {
        if (adjuster != null && adjuster.IsMainShow())
        {
            return;
        }
        // var effectInst = GameEntry.Resource.InstantiateAsync(fdOutPutEPath);
        // fdInstList.Add(effectInst);
        // effectInst.completed += (r) =>
        // {
        //     if (fdInst!=null && fdInst.gameObject != null)
        //     {
        //         var hangPoint = fdInst.gameObject.transform.Find(fdEffectPoint);
        //         r.gameObject.transform.SetParent(hangPoint);
        //         r.gameObject.transform.localPosition = new Vector3(-2f, 0, 0);
        //         r.gameObject.transform.localScale = Vector3.one;
        //         r.gameObject.transform.localRotation = Quaternion.identity;
        //         YieldUtils.DelayActionWithOutContext(() => { effectInst.Destroy(); }, 1);
        //     }
        //     else
        //     {
        //         effectInst.Destroy();
        //     }
        //     
        // };

    }

    private void InitTroopColor()
    {
    }
    
    private void EnterInitState()
    {
        //LogDebug($"WorldTroop EnterInitBeahviour {requestInst.PrefabPath} {marchUuid} status {GetMarchStatus()}");


        Log.Debug("EnterInitState "+GetMarchStatus()+":"+this.GetMarchUUID()+":"+isBattle);
        if (GetMarchStatus() == MarchStatus.MOVING
            || GetMarchStatus() == MarchStatus.BACK_HOME
            || GetMarchStatus() == MarchStatus.CHASING
            || GetMarchStatus() == MarchStatus.WAIT_THRONE
             || GetMarchStatus() == MarchStatus.IN_WORM_HOLE)
        {
            if (marchInfo.inBattle == false)
            {
                if (marchInfo.path.Length > 1)
                {
                    sm.ChangeState(WorldTroopState.Move);
                }
                else //if (GetMarchTargetType() == MarchTargetType.STATE || GetMarchTargetType() == MarchTargetType.RANDOM_MOVE)
                {
                    sm.ChangeState(WorldTroopState.Idle);

                }
            }
            else
            {
                sm.ChangeState(WorldTroopState.Attack);
            }
        }
        else if (GetMarchStatus() == MarchStatus.STATION)
        {
            sm.ChangeState(WorldTroopState.Idle);
            if (IsMonsterTroop())
            {
                GameEntry.Event.Fire(EventId.MonsterMoveEnd, marchInfo.uuid);
            }
        }
        else if (GetMarchStatus() == MarchStatus.ATTACKING)
        {
            sm.ChangeState(WorldTroopState.Attack);
        }
        else if (GetMarchStatus() == MarchStatus.PICKING || GetMarchStatus() == MarchStatus.SAMPLING || GetMarchStatus() == MarchStatus.GOLLOES_EXPLORING)
        {
            sm.ChangeState(WorldTroopState.PickingGarbage);
        }
        else if (GetMarchStatus() == MarchStatus.DESTROY_WAIT)
        {
            sm.ChangeState(WorldTroopState.AttackBuild);
        }
        else if (GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
        {
            sm.ChangeState(WorldTroopState.TransPortBackHome);
        }
        else
        {
            sm.ChangeState(WorldTroopState.None);
            // if (IsMonsterTroop())
            // {
            //     GameEntry.Event.Fire(EventId.MonsterMoveEnd, marchInfo.uuid);
            // }
        }

    }
    

    private void InitPositionRotation()
    {
        if ((GetMarchStatus() == MarchStatus.MOVING
            || GetMarchStatus() == MarchStatus.BACK_HOME
            || GetMarchStatus() == MarchStatus.CHASING
            || GetMarchStatus() == MarchStatus.WAIT_THRONE
            || GetMarchStatus() == MarchStatus.IN_WORM_HOLE) && (marchInfo.path.Length > 1))
        {
            int pathIndex;
            Vector3 position;
            long serverNow = GameEntry.Timer.GetServerTime();
            var moveSpeed = GetSpeed();
            //到现在走了多少距离
            var blackEndTime = GetMarchBlackEndTime();
            var blackStartTime = GetMarchBlackStartTime();
            var startTime = GetMarchStartTime();
            float pathLen = 0.0f;
            if (blackEndTime > 0 && blackStartTime > 0)
            {
                // 如果没进入黑土地
                if (serverNow <= blackStartTime)
                {
                    pathLen  = moveSpeed * (serverNow - startTime) * 0.001f;
                }
                // 如果没出黑土地
                else if (serverNow <= blackEndTime)
                {
                    pathLen  = moveSpeed * (blackStartTime - startTime) * 0.001f;
                    pathLen += moveSpeed * (serverNow - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
                }
                //已经出黑土地
                else
                {
                    pathLen  = moveSpeed* (blackStartTime - startTime) * 0.001f;
                    pathLen += moveSpeed * (blackEndTime - blackStartTime) * 0.001f*SceneManager.World.BlackLandSpeed;
                    pathLen += moveSpeed* (serverNow - blackEndTime) * 0.001f;
                }
            }
            else
            {
                pathLen = moveSpeed * (serverNow - startTime) * 0.001f;
            }
            var pathSegment = CreatePathSegment();
            CalcMoveOnPath(pathSegment, 0, pathLen, out pathIndex, out _, out position);
            SetPosition(position);
            SetRotation(Quaternion.LookRotation(pathSegment[pathIndex].dir));
        }
        else
        {
            if (GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
            {
                SetPosition(SceneManager.World.TileIndexToWorld(marchInfo.startPos));
            }
            else
            {
                SetPosition(SceneManager.World.TileIndexToWorld(marchInfo.targetPos));
            }
            
            if (marchInfo.stationDir == Vector2Int.zero)
                SetRotation(Quaternion.identity);
            else if (marchInfo.type != NewMarchType.BOSS && marchInfo.type != NewMarchType.CHALLENGE_BOSS)
                SetRotation(Quaternion.LookRotation(new Vector3(marchInfo.stationDir.x, 0, marchInfo.stationDir.y)));
        }
    }

    public bool IsBossTroop()
    {
        return marchInfo.type == NewMarchType.BOSS;
    }
    public bool IsMonsterTroop()
    {
        return marchInfo.type == NewMarchType.MONSTER || marchInfo.type == NewMarchType.BOSS || marchInfo.type == NewMarchType.CHALLENGE_BOSS || marchInfo.type == NewMarchType.MONSTER_SIEGE;
    }

    public bool IsMarchTargetAttack()
    {
        var marchTargetType = GetMarchTargetType();
        return marchTargetType == MarchTargetType.ATTACK_ARMY
               || marchTargetType == MarchTargetType.ATTACK_MONSTER
               || marchTargetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS
               || marchTargetType == MarchTargetType.ATTACK_BUILDING
               || marchTargetType == MarchTargetType.ATTACK_ALLIANCE_CITY
               || marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT
               || marchTargetType == MarchTargetType.RALLY_FOR_BOSS
               || marchTargetType == MarchTargetType.RALLY_FOR_BUILDING
               || marchTargetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY
               || marchTargetType == MarchTargetType.RALLY_THRONE
               || marchTargetType == MarchTargetType.ATTACK_CITY
               || marchTargetType ==MarchTargetType.DIRECT_ATTACK_CITY
               || marchTargetType == MarchTargetType.ATTACK_NPC_CITY
               || marchTargetType == MarchTargetType.RALLY_NPC_CITY
               || marchTargetType == MarchTargetType.DIRECT_ATTACK_NPC_CITY
               || marchTargetType ==MarchTargetType.DIRECT_ATTACK_CITY
               || marchTargetType == MarchTargetType.RALLY_FOR_CITY
               || marchTargetType == MarchTargetType.EXPLORE;
    }

    public bool IsMarchTargetChangable()
    {
        var marchTargetType = GetMarchTargetType();
        return marchTargetType == MarchTargetType.SCOUT_TROOP;
    }

    public WorldTroopPathSegment[] CreatePathSegment()
    {
        var path = GetMovePath();
        if (path.Length < 2)
        {
            return null;
        }
        
        var pathList = new WorldTroopPathSegment[path.Length];
        for (int i = 0; i < pathList.Length; i++)
        {
            pathList[i] = new WorldTroopPathSegment();
            if (i < pathList.Length - 1)
            {
                var curPos = world.TileIndexToWorld(path[i]);
                var nextPos = world.TileIndexToWorld(path[i + 1]);
                    
                var pathVec = nextPos - curPos;
                pathList[i].pos = curPos;
                pathList[i].dir = pathVec.normalized;
                // if(marchType == NewMarchType.MONSTER)
                // {
                //     pathList[i].dist = pathVec.magnitude;
                // }
                // else
                // {
                     pathList[i].dist = pathVec.magnitude;
                // }

            }
            else
            {
                pathList[i].pos = world.TileIndexToWorld(path[i]);
                pathList[i].dir = pathList[i - 1].dir;
                pathList[i].dist = float.MaxValue;
            }
        }

        return pathList;
    }
    
    //
    // 计算路径的索引及在路径中的位置
    //    输出 pathIdx 范围 [0, path.Length - 1]
    public static void CalcMoveOnPath(WorldTroopPathSegment[] path, int startIndex, float startPathLen, out int pathIdx, out float pathLen, out Vector3 pos)
    {
        pathIdx = startIndex;
        pathLen = startPathLen;
        
        while (pathIdx < path.Length && pathLen > path[pathIdx].dist)
        {
            pathLen -= path[pathIdx].dist;
            pathIdx++;
        }

        if (pathIdx < path.Length - 1)
        {
            pos = path[pathIdx].pos + path[pathIdx].dir * pathLen;
        }
        else
        {
            pos = path[path.Length - 1].pos;
        }
    }

    public void Refresh(WorldMarch march)
    {
        isDelayDestroy = false;
        
        if (transform == null)
            return;

        if (march == null)
            return;

        var oldType = marchInfo.type;
        marchInfo = march;

        if (oldType != march.type)
        {
            DestroyTroopObject();
            InstantiateTroopObject();
        }

        UpdateIconSprite();
        UpdatePerformance();
        UpdateMarchSecretKey();
    }


    public Transform GetTransform()
    {
        return transform;
    }
    public GameObject GetModel()
    {
        return this.model;
    }



    private void OnPointerDown()
    {
    }

    private void OnPointerUp()
    {
    }
    private void OnClick()
    {
        GameEntry.Lua.Call("UIUtil.OnClickWorldTroop", marchInfo.uuid);
    }

    private void OnDoubleClick()
    {
    }

    private void OnBeginDrag(Vector3 dragStartPos)
    {
    }

    private void OnDrag(Vector3 dragStartPos, Vector3 dragCurrPos)
    {
    }

    private void OnEndDrag(Vector3 dragStopPos)
    {
    }

    public void OnUpdate(float deltaTime)
    {
        sm.OnUpdate(deltaTime);
        UpdateTroopUnits();
        
        if (cullVisible && adjuster != null && adjuster.IsMainShow())
        {
            AdjustIcon();
        }

        if (isDelayDestroy)
        {
            delayDestroySec -= deltaTime;
        }
    }

    public void AdjustIcon()
    {
        // icon.transform.rotation = SceneManager.World.GetRotation();
        // float scale = SceneManager.World.GetMapIconScale();
        // icon.transform.localScale = new Vector3(scale, scale, scale);
    }
    
    private void UpdateIconSprite()
    {
        if (spriteRenderer == null)
            return;
        
        string allianceId = GameEntry.Data.Player.GetAllianceId();
        
        if (marchInfo.ownerUid == GameEntry.Data.Player.Uid)
        {
            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_green.png");
        }
        else if (!allianceId.IsNullOrEmpty() && marchInfo.allianceUid == allianceId)
        {
            //如果是自己盟的联盟boss
            if (marchInfo.type == NewMarchType.ALLIANCE_BOSS)
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/allianceBoss_blue.png");
            }
            else
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_blue.png");
            }
        }
        else if (marchInfo.type == NewMarchType.ALLIANCE_BOSS && (allianceId.IsNullOrEmpty() || marchInfo.allianceUid != allianceId))
        {
            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/allianceBoss_red.png");
        }
        else if (marchInfo.srcServer != GameEntry.Data.Player.GetSelfServerId())
        {
            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_red.png");
        }
        else if (GameEntry.Data.Player.GetIsInAttackDic(marchInfo.ownerUid) == true || GameEntry.Data.Player.GetIsInFightServerList(marchInfo.srcServer) == true )
        {
            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_red.png");
        }
        else if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            if (GameEntry.Data.Player.IsAllianceSelfCamp(marchInfo.allianceUid))
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_yellow.png");
            }
            else
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_red.png");
            }
        }
        else
        {
            string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
            if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == marchInfo.allianceUid)
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_red.png");
            }
            else
            {
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/troop_white.png");
            }
        }
        

        if (headObj == null)
        {
            return;
        }
        if (marchInfo.ownerUid == GameEntry.Data.Player.Uid && marchInfo.type == NewMarchType.NORMAL)
        {
            var armyInfo = marchInfo.GetFirstArmyInfo();
            if (armyInfo != null && armyInfo.HeroInfos != null && armyInfo.HeroInfos.Count > 0)
            {
                var heroData = armyInfo.HeroInfos[0];
                var rarity = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.APSHeros,heroData.heroId,"rarity");
                var isReachMax = heroData.GetIsAllSKillReachMax();
                var heroHeadBg = GameEntry.Lua.CallWithReturn<string,int,bool>("CSharpCallLuaInterface.GetHeroQuality",rarity.ToInt(),isReachMax);
                var heroHeadIcon = GameEntry.Lua.CallWithReturn<string,int>("CSharpCallLuaInterface.GetHeroIcon",heroData.heroId);
                headBg.LoadSprite(heroHeadBg);
                headIcon.LoadSprite(heroHeadIcon);

            }
            var marchStateIconPath = GameEntry.Lua.CallWithReturn<string,WorldMarch>("CSharpCallLuaInterface.GetMarchStateIcon",marchInfo);
            marchStateIcon.LoadSprite(marchStateIconPath);
        }
        else if (marchInfo.ownerUid == GameEntry.Data.Player.Uid && marchInfo.type == NewMarchType.SCOUT)
        {
            headObj.SetActive(true);
        }
        else
        {
            headObj.SetActive(false);
        }
    }

    // 更新表现
    public void UpdatePerformance()
    {
        if (performanceDict.Count == 0)
            return;
        
        int curTimeSec = GameEntry.Timer.GetServerTimeSeconds();
        HashSet<string> showPerformances = new HashSet<string>();
        
        // 根据Buff
        ArmyInfo armyInfo = marchInfo.GetFirstArmyInfo();
        if (armyInfo?.UnitBuffs != null)
        {
            foreach (ArmyUnitBuff buff in armyInfo.UnitBuffs)
            {
                int buffId = buff.buffId;
                int curState = (int) sm.GetCurrentState();
                
                // 过期
                if (curTimeSec > buff.expireTime)
                {
                    continue;
                }
                
                // 如果未缓存，则读表缓存
                if (!WorldScene.ModelPathDic.ContainsKey(buffId))
                {
                    WorldScene.ModelPathDic[buffId] = new Dictionary<int, string>();
                    LuaTable performanceInfo = GameEntry.Lua.CallWithReturn<LuaTable, int>("CSharpCallLuaInterface.GetBuffPerformanceInfo", buffId);
                    if (performanceInfo != null)
                    {
                        string modelName = performanceInfo.Get<string>("modelName");
                        int troopState = performanceInfo.Get<int>("troopState");
                        WorldScene.ModelPathDic[buffId][troopState] = modelName;
                    }
                }
                
                // 读缓存
                if (WorldScene.ModelPathDic[buffId].ContainsKey(curState))
                {
                    string modelName = WorldScene.ModelPathDic[buffId][curState];
                    showPerformances.Add(modelName);
                }
            }
        }
        
        // 更新表现
        foreach (var kvp in performanceDict)
        {
            bool show = showPerformances.Contains(kvp.Key);
            GameObject go = kvp.Value;
            if (go.activeSelf != show)
            {
                go.SetActive(show);
            }
        }
    }

    public void UpdateMarchSecretKey()
    {
        if (marchInfo.secretKey >0 && keyRequest == null)
        {
            keyRequest = GameEntry.Resource.InstantiateAsync(secretKeyPath);
            keyRequest.completed += (result) =>
            {
                if (transform != null)
                {
                    keyRequest.gameObject.transform.SetParent(transform);
        
                    keyRequest.gameObject.transform.localPosition = Vector3.zero;
                    keyRequest.gameObject.transform.localRotation = Quaternion.identity;
                    keyRequest.gameObject.transform.localScale = Vector3.one;
                }
                else
                {
                    keyRequest.Destroy();
                    keyRequest = null;
                }
            
            };
        }else if (keyRequest != null && marchInfo.secretKey == 0)
        {
            keyRequest.Destroy();
            keyRequest = null;
        }
    }
    private void ShowDetectEvent()
    {
        // GameEntry.Data.Player.Uid
        if (!string.IsNullOrEmpty(marchInfo.eventId) && marchInfo.belongUid == GameEntry.Data.Player.Uid)
        {
            if (detectEventInst == null)
            {
                detectEventInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.DetectEventUI);
                detectEventInst.completed += delegate
                {
                    detectEventInst.gameObject.transform.SetParent(transform);
                    detectEventInst.gameObject.transform.localPosition = Vector3.zero;
                    var eventQuality = detectEventInst.gameObject.transform.Find("Transform/Detect_event_quality_icon").GetComponent<SpriteRenderer>();
                    var eventIcon = detectEventInst.gameObject.transform.Find("Transform/Detect_event_icon").GetComponent<SpriteRenderer>();
                    eventIcon.transform.localPosition = new Vector3(0, 0.11f, 0);
                    var tempQuality = GameEntry.ConfigCache.GetTemplateData("detect_event", marchInfo.eventId.ToInt(), "quality");
                    var quality = tempQuality.ToInt();
                    var tempIcon = GameEntry.ConfigCache.GetTemplateData("detect_event", marchInfo.eventId.ToInt(), "icon");
                    var iconString = string.Format("Assets/Main/Sprites/UI/UIBuildBubble/{0}.png", tempIcon); 
                    var qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_green.png";
                    if (quality == (int)DetectEventColor.DETECT_EVENT_WHITE )
                    {
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_white";
                    }
                    else if (quality == (int)DetectEventColor.DETECT_EVENT_GREEN )
                    {
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_green";
                    }
                    else if (quality == (int)DetectEventColor.DETECT_EVENT_BLUE)
                    {
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_blue.png";
                    }
                    else if (quality == (int)DetectEventColor.DETECT_EVENT_PURPLE)
                    {
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_purple.png";
                    }
                    else if (quality == (int)DetectEventColor.DETECT_EVENT_ORANGE)
                    { 
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_orange.png";
                    }
                    else if (quality == (int)DetectEventColor.DETECT_EVENT_GOLDEN)
                    {
                        qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_golden.png";
                    }
                    eventQuality.LoadSprite(qualityStr);
                    eventIcon.LoadSprite(iconString);
                };
            }
        }
        else
        {
            HideDetectEvent();
        }
    }

    private void HideDetectEvent()
    {
        if (detectEventInst != null)
        {
            detectEventInst.gameObject.transform.SetParent(null);
            detectEventInst.Destroy();
        }

        detectEventInst = null;
    }

    private void UpdateTroopUnits()
    {
        if (troopUnits.Count > 0)
        {
            foreach (var i in troopUnits)
            {
                i.Update();
            }

            if (troopUnits.All(i => i.IsBackFinish()))
            {
                ClearTroopUnits();
            }
        }
    }

    /// <summary>
    /// 怪或者Boss直接切换攻击状态,住宅的部队被攻击了，也要触发攻击状态
    /// </summary>
    public void Attack()
    {
        if(this.marchInfo.status == MarchStatus.STATION)
        {
            if (sm.GetCurrentState() != WorldTroopState.Attack)
            {

                sm.ChangeState(WorldTroopState.AttackBegin);
            }
        }
        else if (IsBossTroop())
        {
            if (sm.GetCurrentState() != WorldTroopState.Attack)
            {

                sm.ChangeState(WorldTroopState.Attack);
            }

        }
    }
    #if false
    public void ShowBattleHurt(int hurt, WorldMarchDataManager.BattleWordType worldType)
    {
        if(this.transform==null||this.IsAddShield)
        {
            return;
        }
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        string showPath = string.Empty;
        switch(worldType)
        {
            case WorldMarchDataManager.BattleWordType.Cure:
                {
                    showPath = cureWordPath;
                    break;

                }
            case WorldMarchDataManager.BattleWordType.Normal:
                {
                    showPath = normalWordPath;
                    break;
                }
            case WorldMarchDataManager.BattleWordType.Skill:
                {
                    showPath = skillWordPath;
                    break;
                }
            case WorldMarchDataManager.BattleWordType.CarSkill:
            {
                showPath = skillCarWordPath;
                break;
            }
            case WorldMarchDataManager.BattleWordType.CriticalAttack:
            {
                showPath = BattleCriticalWordPath;
                break;
            }
            default:
                break;

        }

        world.ShowBattleBlood(new BattleDecBloodTip.Param()
        {
            startPos = GetPosition(),
            num = hurt,
            path = showPath,
        
        },showPath);
    }
#endif
    // private void ShowUseSkillUI(long marchUuid,long heroId)
    // {
    //     var str = string.Format("{0},{1}", marchUuid, heroId);
    //     GameEntry.Event.Fire(EventId.ShowHeroIconByUseSkill, str);
    // }
    public void ClearEffect()
    {
        //if(troopUnits.Count>0)
        //{
        //    Debug.LogError("clear effect:" + this.GetMarchUUID());
        //}
        foreach(var troop in troopUnits)
        {
            troop.StopAttackEffect();
        }

    }

    public void ShowBattleSuccess()
    {
        if (IsMonsterTroop())
            return;
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        world.CreateBattleVFX(battleVictoryPath, 2.14f, go =>
        {
            go.transform.SetParent(transform);
            go.transform.localScale = Vector3.one * 2;
            go.transform.localPosition = new Vector3(0, 3.55f, 0);
        });
    }

    public void ShowBattleFailed()
    {
        if (IsMonsterTroop())
            return;
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        world.CreateBattleVFX(battleFailurePath, 2.14f, go =>
        {
            go.transform.SetParent(transform);
            go.transform.localScale = Vector3.one * 2;
            go.transform.localPosition = new Vector3(0, 3.55f, 0);
        });
    }

    public void ShowBattleDefeat()
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        if (IsMonsterTroop())
        {
            
            world.CreateBattleVFX(battleDefeatPath, 2.14f, go =>
            {
                go.transform.SetParent(transform);
                go.transform.localPosition = new Vector3(0, 3.55f, 0);
            });
        }
    }

   
    public bool IsAttackTargetInRange()
    {
        float dis = Vector3.Distance(GetPosition(), GetTargetTroopPosition());
        if(dis < AttackRange && dis>0)
        {
            return true;
        }

        return false;
    }
    
    public Vector3 GetPosition()
    {
        if (model != null)
        {
            return model.transform.position;
        }
        return marchInfo.position;
    }

    public Vector3 GetTargetTroopPosition()
    {
        var targetTroop = world.GetTroop(marchInfo.targetUuid);
        if (targetTroop != null)
        {
            return targetTroop.GetPosition();
        }
        if (GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME)
        {
            return world.TileIndexToWorld(marchInfo.startPos);
        }
        else
        {
            return world.TileIndexToWorld(marchInfo.targetPos);
        }
        
    }

    public Quaternion GetStationRotation()
    {
        if (marchInfo.stationDir == Vector2Int.zero || marchInfo.type == NewMarchType.ACT_BOSS || marchInfo.type == NewMarchType.PUZZLE_BOSS || marchInfo.type == NewMarchType.ALLIANCE_BOSS)
            return Quaternion.identity;
        return Quaternion.LookRotation(new Vector3(marchInfo.stationDir.x, 0, marchInfo.stationDir.y));
    }

    public long GetMarchUUID()
    {
        return marchInfo.uuid;
    }

    public MarchTargetType GetMarchTargetType()
    {
        return marchInfo.target;
    }
    
    public int GetMarchTargetPos()
    {
        return marchInfo.targetPos;
    }

    public bool NeedGetRealTargetPos()
    {
        if (marchInfo.target == MarchTargetType.ATTACK_BUILDING)
        {
            return true;
        }
        if (marchInfo.target == MarchTargetType.ATTACK_ARMY ||
                 marchInfo.target == MarchTargetType.ATTACK_MONSTER ||
                 marchInfo.target == MarchTargetType.RALLY_FOR_BOSS ||
                 marchInfo.target == MarchTargetType.EXPLORE ||
                 marchInfo.target == MarchTargetType.SAMPLE ||
                 marchInfo.target == MarchTargetType.PICK_GARBAGE || marchInfo.target == MarchTargetType.RALLY_FOR_BUILDING)
        {
            return true;
        }
        return false;
    }

    public int GetRealMarchTargetPos()
    {
        if (marchInfo.target == MarchTargetType.ATTACK_BUILDING|| marchInfo.target == MarchTargetType.RALLY_FOR_BUILDING)
        {
            var info = SceneManager.World.GetPointInfoByUuid(marchInfo.targetUuid);
            if (info != null && info.pointType == WorldPointType.PlayerBuilding)
            {
                return info.mainIndex;
            }
        }
        else if (marchInfo.target == MarchTargetType.ATTACK_ARMY ||
                 marchInfo.target == MarchTargetType.ATTACK_MONSTER ||
                 marchInfo.target == MarchTargetType.RALLY_FOR_BOSS)

        {
            var troop = world.GetTroop(marchInfo.targetUuid);
            if (troop != null)
            {
                var pos = troop.GetPosition();
                return world.WorldToTileIndex(pos);
            }
        }
        else if (marchInfo.target == MarchTargetType.EXPLORE ||
                 marchInfo.target == MarchTargetType.SAMPLE ||
                 marchInfo.target == MarchTargetType.PICK_GARBAGE)

        {
            var pointInfo = world.GetPointInfoByUuid(marchInfo.targetUuid);
            if (pointInfo != null)
            {
                return pointInfo.pointIndex;
            }
        }
        else if (marchInfo.target == MarchTargetType.GOLLOES_EXPLORE)
        {
            return (int)marchInfo.targetUuid;
        }
        return 0;
    }

    public MarchStatus GetMarchStatus()
    {
        if (marchInfo.status == MarchStatus.STATION)
        {
            world.HideTroopDestination(GetMarchUUID());
        }
        return marchInfo.status;
    }

    public long GetMarchStartTime()
    {
        return marchInfo.startTime;
    }

    public long GetMarchBlackStartTime()
    {
        return marchInfo.blackStartTime;
    }
    public long GetMarchBlackEndTime()
    {
        return marchInfo.blackEndTime;
    }
    public int[] GetMovePath()
    {
        return marchInfo.path;
    }

    public int GetMovePathCount()
    {
        return marchInfo.path.Length;
    }

    public float GetSpeed()
    {
        return marchInfo.speed * world.TileSize;
    }

    public void SetPosition(Vector3 position)
    {
        if (transform != null)
        {
            transform.position = position;
            boundingSphere.position = position;
        }
    }
    public void SetLocalPosition(Vector3 position)
    {
        if (transform != null)
        {
            transform.localPosition = position;
            boundingSphere.position = transform.TransformPoint(position);
        }

    }

    public Quaternion GetRotation()
    {
        if (model != null)
        {
            return model.transform.rotation;
        }
        return Quaternion.identity;
    }
    
    public void SetRotation(Quaternion rotation)
    {
        if (model != null)
        {
            if (marchInfo != null && marchInfo.type == NewMarchType.ACT_BOSS)
            {
                rotation = Quaternion.identity;
            }
            if (marchInfo != null && marchInfo.type == NewMarchType.PUZZLE_BOSS)
            {
                rotation = Quaternion.identity;
            }
            // if (marchInfo != null && marchInfo.type == NewMarchType.ALLIANCE_BOSS)
            // {
            //     rotation = Quaternion.identity;
            // }
            var tempRotation = model.transform.rotation;
            if (tempRotation.Equals(rotation)==false)
            {
                model.transform.rotation = rotation;
                GameEntry.Event.Fire(EventId.TroopRotation, marchInfo.uuid);
            }
        }

        
        
    }

    public void CreateTroopDestination()
    {
        // if (marchInfo.ownerUid != GameEntry.Data.Player.Uid)
        // {
        //     return;
        // }
        // if (_troopDestinationInst == null)
        // {
        //     _troopDestinationInst =
        //         GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopDestinationSignal);
        //     _troopDestinationInst.completed += delegate(InstanceRequest request)
        //     {
        //         _troopDestinationInst.gameObject.transform.SetParent(world.DynamicObjNode);
        //         _troopDestination = _troopDestinationInst.gameObject.GetComponent<WorldTroopDestinationSignal>();
        //     };
        // }
    }

    public void DestroyTroopDestination()
    {
        // if (_troopDestinationInst != null)
        // {
        //     _troopDestinationInst.Destroy();
        //     _troopDestinationInst = null;
        //     _troopDestination = null;
        // }
    }

    public void UpdateTroopDestination(int targetPos)
    {
        // if (IsMonsterTroop())
        //     return;
        // if (marchInfo.ownerUid != GameEntry.Data.Player.Uid)
        // {
        //     return;
        // }
        // if (_troopDestination != null)
        // {
        //     // var targetPos = GetMarchTargetPos();
        //     // if (NeedGetRealTargetPos())
        //     // {
        //     //     targetPos = GetRealMarchTargetPos();
        //     // }
        //     Vector3 targetRealPos = world.TileIndexToWorld(targetPos);
        //     int tileSize = 1;
        //     var destinationType = world.GetDestinationType(marchInfo.uuid, marchInfo.targetUuid, targetPos,
        //         marchInfo.target,false, ref targetRealPos, ref tileSize);
        //     _troopDestination.SetDestinationForMarch(targetRealPos, destinationType, tileSize);
        // }
        
    }

    public void PlayAnim(string animName)
    {
        if (anims != null)
        {
            if (anims.Length > 1)
            {
                for (int i = 0; i < anims.Length; i++)
                {
                    var a = anims[i];
                    var state = a.GetState(animName);
                    if (state != null)
                    {
                        a[animName].time = UnityEngine.Random.Range(0, state.length);
                        a.Play(animName);
                    }
                }
            }
            else if (anims.Length == 1)
            {
                if (anims[0].GetState(animName) != null)
                {
                    anims[0].Play(animName);
                }
            }
        }

        if (gpuAnims != null)
        {
            for (int i = 0; i < gpuAnims.Length; i++)
            {
                gpuAnims[i].Play(animName, UnityEngine.Random.Range(0, 1.0f));
            }
        }
    }
    public MarchStatus GetDefenderMarchStatus()
    {
        var troop = world.GetTroop(marchInfo.targetUuid);
        if(troop==null)
        {
            return MarchStatus.DEFAULT;
        }
        return troop.GetMarchStatus();

    }
    public WorldTroop GetTargetTroop()
    {
        var targetUuid = defAtkUuid; 
        if(targetUuid==0)
        {
            targetUuid = marchInfo.targetUuid;
        }
        var troop= world.GetTroop(targetUuid);

        return troop;
    }


    public Vector3 GetDefenderPosition()
    {
        var uuid = defAtkUuid;
        if (uuid == 0)
        {
            uuid = marchInfo.targetUuid;
        }
        if (GetMarchTargetType() == MarchTargetType.ATTACK_ARMY
            || GetMarchTargetType() == MarchTargetType.ATTACK_MONSTER
            || GetMarchTargetType() == MarchTargetType.DIRECT_ATTACK_ACT_BOSS
            || GetMarchTargetType() == MarchTargetType.ATTACK_ARMY_COLLECT
            || GetMarchTargetType() == MarchTargetType.RALLY_FOR_BOSS
            || GetMarchTargetType() == MarchTargetType.ATTACK_ALLIANCE_BOSS)
        {

            var troop = world.GetTroop(uuid);
            if (troop != null)
            {
                return troop.GetPosition();
            }
            else
            {
                var march = world.GetMarch(uuid);
                if (march != null)
                {
                    return march.position;
                }
            }
        }
        else if (GetMarchTargetType() == MarchTargetType.STATE)
        {
            var troop = world.GetTroop(this.defAtkUuid);
            if (troop != null)
            {
                return troop.GetPosition();
            }
            var march = world.GetMarch(uuid);
            if (march != null)
            {
                return march.position;
            }
            if (world.GetObjectByUuid(uuid) is WorldBuildObjectNew buildObject)
            {
                return buildObject.GetPosition();
            }
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return world.TileIndexToWorld(pointInfo.mainIndex);
            }
        }
        else if (GetMarchTargetType() == MarchTargetType.ATTACK_BUILDING
                 || GetMarchTargetType() == MarchTargetType.RALLY_FOR_BUILDING
                 || GetMarchTargetType() == MarchTargetType.DIRECT_ATTACK_CITY
                 || GetMarchTargetType() == MarchTargetType.ATTACK_CITY)
        {
            if (world.GetObjectByUuid(uuid) is WorldBuildObjectNew buildObject)
            {
                var pos = buildObject.GetPosition();
                var pointInfo = SceneManager.World.GetPointInfoByUuid(uuid);
                if (pointInfo != null)
                {
                    if (pointInfo.tileSize > 1)
                    {
                        pos+=new Vector3(-pointInfo.tileSize,0,-pointInfo.tileSize);
                    }
                }
                return pos;
            }
        }
        else if (marchInfo.target == MarchTargetType.EXPLORE ||
                 marchInfo.target == MarchTargetType.SAMPLE ||
                 marchInfo.target == MarchTargetType.PICK_GARBAGE)

        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.pointIndex);
            }
        }else if (marchInfo.target == MarchTargetType.ATTACK_ALLIANCE_CITY||
                  marchInfo.target == MarchTargetType.RALLY_FOR_ALLIANCE_CITY || marchInfo.target == MarchTargetType.RALLY_THRONE)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-6,0,-6);
            }
        }
        else if (marchInfo.target == MarchTargetType.ATTACK_DRAGON_BUILDING || marchInfo.target == MarchTargetType.RALLY_DRAGON_BUILDING ||marchInfo.target == MarchTargetType.TRIGGER_DRAGON_BUILDING)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-3,0,-3);
            }
        }
        else if (marchInfo.target == MarchTargetType.TRIGGER_CROSS_THRONE_BUILDING || marchInfo.target == MarchTargetType.RALLY_CROSS_THRONE_BUILDING)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-3,0,-3);
            }
        }
        else if (marchInfo.target == MarchTargetType.TAKE_SECRET_KEY)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-5,0,-5);
            }
        }
        else if (marchInfo.target == MarchTargetType.TRANSPORT_SECRET_KEY)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-3,0,-3);
            }
        }
        else if (marchInfo.target == MarchTargetType.PICK_SECRET_KEY)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex);
            }
        }
        else if (marchInfo.target == MarchTargetType.ATTACK_ALLIANCE_BUILDING || marchInfo.target == MarchTargetType.RALLY_ALLIANCE_BUILDING ||marchInfo.target == MarchTargetType.ATTACK_ACT_ALLIANCE_MINE ||marchInfo.target == MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-3,0,-3);
            }
        }
        else if (marchInfo.target == MarchTargetType.ATTACK_NPC_CITY ||marchInfo.target == MarchTargetType.RALLY_NPC_CITY || marchInfo.target == MarchTargetType.DIRECT_ATTACK_NPC_CITY)
        {
            var pointInfo = world.GetPointInfoByUuid(uuid);
            if (pointInfo != null)
            {
                return SceneManager.World.TileIndexToWorld(pointInfo.mainIndex)+ new Vector3(-3,0,-3);
            }
        }
        else if (marchInfo.target == MarchTargetType.GOLLOES_EXPLORE)
        {
            return SceneManager.World.TileIndexToWorld((int)marchInfo.targetUuid);
        }
        if (marchInfo.type == NewMarchType.BOSS || marchInfo.type == NewMarchType.MONSTER ||marchInfo.type == NewMarchType.MONSTER_SIEGE || marchInfo.type == NewMarchType.ALLIANCE_BOSS)
        {
            var troop = world.GetTroop(uuid);
            if (troop != null)
            {
                return troop.GetPosition();
            }
        }
        else if (marchInfo.type == NewMarchType.ACT_BOSS || marchInfo.type == NewMarchType.PUZZLE_BOSS)
        {
            return SceneManager.World.TileIndexToWorld(marchInfo.targetPos);
        }
        else if (marchInfo.target == MarchTargetType.ATTACK_DESERT || marchInfo.target == MarchTargetType.TRAIN_DESERT)
        {
            return SceneManager.World.TileIndexToWorld(marchInfo.targetUuid.ToInt());
        }
        return SceneManager.World.TileIndexToWorld(marchInfo.targetPos);
    }

    public void TroopUnitPickSuccess()
    {
        foreach (var i in troopUnits)
        {
            i.PickGarbageSuccess();
        }
    }

    public void TroopUnitPickBack()
    {
        foreach (var i in troopUnits)
        {
            i.PickMoveBack();
        }
        world.HideTroopDestination(GetMarchUUID());
    }
    public void BackTroopUnits()
    {
        //Debug.LogError("BackTroopUnits");
        DelShield();
        foreach (var i in troopUnits)
        {
            i.Back();
        }
        troopUnits.Clear();
    }

    public void ClearTroopUnits()
    {
        troopUnits.ForEach(i => i.Destroy());
        troopUnits.Clear();
    }

    public void TroopUnitsBirthThenPickGarbage(bool appear = true)
    {
        if (troopUnits.Count > 0 || !IsPickGarbageTroop())
        {
            return;
        }

        List<Vector3> pts = new List<Vector3>();
        if (marchInfo.type == NewMarchType.GOLLOES_EXPLORE)
        {
            pts = GetPickPoint((int)marchInfo.targetUuid, GetPosition());
        }
        else
        {
            var detectEventObject = world.GetObjectByUuid(marchInfo.targetUuid) as WorldDetectEventItemObject;
            if (detectEventObject != null)
            {
                pts = detectEventObject.GetPickPoint(GetPosition());
            }
        }
        var total = GarbageBirthPos.Length;
        for (int i = 0; i < total; i++)
        {
            var offsetBirthPos = GarbageBirthPos[i];
            // var offsetPickPos = GarbagePickPos[i];
            var birthDest = GetPosition() + model.transform.right * offsetBirthPos.x +
                            model.transform.forward * offsetBirthPos.z;
            // var pickDest = GetPosition() + model.transform.right * offsetPickPos.x +
            //                model.transform.forward * offsetPickPos.z;
            var pickDest = GetPosition();
            if (pts.Count > 0)
            {
                if (pts.Count > i)
                {
                    pickDest = pts[i];
                }
                else
                {
                    pickDest = pts[pts.Count - 1];
                }
            }
            var entity = new PickGarbageTroopUnit(WorldTroopUnit.UnitType.Junkman);
            entity.CreateInstance(delegate
            {
                entity.SetPosition(GetPosition() + new Vector3(0, 1.6f, 0));
                if (appear)
                {
                    entity.BirthThenMoveToGarbage(birthDest, pickDest, GetDefenderPosition());
                }
                else
                {
                    entity.BirthThenPickGarbage(birthDest, pickDest, GetDefenderPosition());
                }
            },model.transform);
            troopUnits.Add(entity);
        }
    }
    
    /// <summary>
    /// Cpy from WorldPointObject.GetPickPoint
    /// 用于终点只有坐标的情况（example:咕噜探索）
    /// </summary>
    /// <param name="endP"></param>
    /// <param name="startPt"></param>
    /// <returns></returns>
    public List<Vector3> GetPickPoint(int endP, Vector3 startPt)
    {
        var result = new List<Vector3>();
        if (endP > 0)
        {
            var destPos = SceneManager.World.TileIndexToWorld(endP);
            float distance = 1.5f;
            int index = 0;
            int total = 5;
            float angleGap = 360 / total;
            //方案1
            double diffX = startPt.x - destPos.x;
            double diffZ = startPt.z - destPos.z;
            double startAngle = Math.Atan2(diffZ, diffX) * 180 / Math.PI;
            while (index < total)
            {
                var angle = angleGap * index + startAngle;
                var addX = distance * Math.Cos(angle * Math.PI / 180);
                var addZ = distance * Math.Sin(angle * Math.PI / 180);
                var pt = destPos + new Vector3((float) addX, 0.0f, (float) addZ);
                result.Add(pt);
                ++index;
            }
        }

        return result;
    }

    public bool IsPickGarbageTroop()
    {
        return GetMarchTargetType() == MarchTargetType.PICK_GARBAGE || GetMarchTargetType() == MarchTargetType.SAMPLE;
        // || GetMarchTargetType() == MarchTargetType.GOLLOES_EXPLORE;
    }

    public bool IsGolloesExplore()
    {
        return marchInfo.type == NewMarchType.GOLLOES_EXPLORE;
    }

    public bool IsExplore()
    {
        return marchInfo.type == NewMarchType.EXPLORE;
    }
    public void ReSetEntityTarget()
    {
       foreach(var entity in troopUnits)
        {
            entity.target = GetTargetTroop();

        }
    }
    public void PlayAttackEffect()
    {
        foreach (var entity in troopUnits)
        {
            entity.PlayAttackEffect();

        }
    }
    public void LookAtTarget()
    {
        if(this.IsMonsterTroop())
        {
           SetRotation(Quaternion.LookRotation(GetDefenderPosition() - GetPosition()));

        }

    }

    public void SetRotationRoot()
    {
        if (rotationRoot != null && IsMonsterTroop()==false && marchInfo.type != NewMarchType.ACT_BOSS && marchInfo.type != NewMarchType.PUZZLE_BOSS && marchInfo.type != NewMarchType.ALLIANCE_BOSS)
        {
            
            var rotation = Quaternion.LookRotation(GetDefenderPosition() - GetPosition());
            var pointId = world.WorldToTileIndex(GetPosition());
            var index = world.GetCurPosAndRotationTroopNum(marchInfo.uuid,pointId,rotation);
            if (index != -1)
            {
                var rot = rotation.eulerAngles + new Vector3(0, 20 * index, 0);
                var realRot = Quaternion.Euler(rot);
                var tempRot = rotationRoot.transform.rotation;
                if (tempRot.Equals(realRot) == false)
                {
                    rotationRoot.transform.rotation = realRot;
                }
            }
        }
    }
    
    

    public void TroopUnitsBirthThenAttack()
    {
        return;
        if (troopUnits.Count > 0 || IsMonsterTroop())
            return;
        
        //LogDebug("TroopUnitsAttack");
        
        var armyInfo = marchInfo.GetFirstArmyInfo();
        if (armyInfo == null)
            return;

        foreach (var s in armyInfo.Soldiers)
        {

            if (s.type == ArmySoldierType.INFANTRY)
            {
                foreach (var offset in InfantryPos)
                {
                    var birthDest = GetPosition() + model.transform.right * offset.x +
                                    model.transform.forward * offset.z;
                    var entity = new SoldierTroopUnlit(WorldTroopUnit.UnitType.Infantry, this);
                    entity.Uid = s.uid;
                    entity.target = GetTargetTroop();
                    entity.CreateInstance(delegate
                    {
                        entity.SetPosition(GetPosition());
                        entity.BirthThenAttack(birthDest);
                        entity.PlayAttackEffect();
                      
                    },model.transform);
              
                    troopUnits.Add(entity);
                }
            }
            else if (s.type == ArmySoldierType.TANK)
            {
                foreach (var offset in TankPos)
                {
                    var birthDest = GetPosition() + model.transform.right * offset.x +
                                    model.transform.forward * offset.z;
                    var entity = new TankTroopUnlit(WorldTroopUnit.UnitType.Tank, this);
                    entity.Uid = s.uid;
                    entity.target = GetTargetTroop();
                    entity.CreateInstance(delegate
                    {
                        entity.SetPosition(GetPosition());
                        entity.BirthThenAttack(birthDest);
                        entity.PlayAttackEffect();
                    },model.transform);
   
                    troopUnits.Add(entity);
                }
            }
            else if (s.type == ArmySoldierType.PLANE)
            {
                foreach (var offset in PlanePos)
                {
                    var birthDest = GetPosition() + model.transform.right * offset.x +
                                    model.transform.forward * offset.z;
                    var entity = new PlaneTroopUnlit(WorldTroopUnit.UnitType.Plane, this);
                    entity.Uid = s.uid;
                    entity.target = GetTargetTroop();
                    entity.CreateInstance(delegate
                    {
                        entity.SetPosition(GetPosition());
                        entity.BirthThenAttack(birthDest);
                        entity.PlayAttackEffect();
                    }, model.transform);

                    troopUnits.Add(entity);
                }
            }
          
        }
    }

    public void AddShield()
    {
        if(IsAddShield)
        {
            return;
        }
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }

        if (showBattleEffect == false)
        {
            return;
        }
        IsAddShield = true;
        shieldRequest = GameEntry.Resource.InstantiateAsync(sheldPath);
        shieldRequest.completed += (result) =>
        {
            if (model != null && model.transform != null)
            {
                shieldRequest.gameObject.transform.SetParent(model.transform);
                shieldRequest.gameObject.transform.localPosition = Vector3.zero;
                shieldRequest.gameObject.transform.localRotation = Quaternion.identity;
                shieldRequest.gameObject.transform.localScale = Vector3.one;
            }
            else
            {
                shieldRequest.Destroy();
            }
        };
    }
    public void DelShield()
    {
        if(!IsAddShield)
        {
            return;
        }
        IsAddShield = false;
        if (shieldRequest != null)
        {
            if (shieldRequest.gameObject != null)
            {
                var animator = shieldRequest.gameObject.GetComponent<Animator>();
                if(animator!=null)
                {
                    animator.SetTrigger("close");
                }
                YieldUtils.DelayActionWithOutContext(() =>
                {
                    if (shieldRequest != null)
                    {
                        shieldRequest.Destroy();
                    }
                    
                }, 0.6f);
            }
            else
            {
                shieldRequest.Destroy();
            }
            

        }

    }
    private float releaseSkillTick = 0;

    public float RelaseSkillTick
    {
        get
        {
            return releaseSkillTick;
        }
        set
        {
            releaseSkillTick = value;
        }

    }

    public void ShowRallyMarchAttack()
    {
        if (fdInst!=null && fdInst.gameObject != null)
        {
            simpleAni = fdInst.gameObject.GetComponentInChildren<SimpleAnimation>();
            simpleAni.Play(WorldTroop.Anim_Attack);
            // simpleAni.PlayQueued(WorldTroop.Anim_Run);
        }
    }
    public void ShowAttack()
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }

        if (showBattleEffect == false)
        {
            return;
        }

        if (model == null || model.transform == null)
        {
            return;
        }
            

        var startPos = model.transform.position;
        var hangPoint = model.transform.Find(huangPoint);
        if (hangPoint != null)
        {
            startPos = hangPoint.transform.position;
        }

        var targetPosition = GetDefenderPosition();
        var rotation = Quaternion.LookRotation(targetPosition - GetPosition());
        var uuid = defAtkUuid;
        if (uuid == 0 || marchInfo.target == MarchTargetType.TRAIN_DESERT || marchInfo.target == MarchTargetType.ATTACK_DESERT)
        {
            uuid = marchInfo.targetUuid;
        }
        PlayAnim(Anim_Attack);
        bool isSelf = marchInfo != null && marchInfo.ownerUid == GameEntry.Data.Player.Uid;
        var showSuccess = SceneManager.World.AddBullet(_effectPdName, _effectHitName, startPos,rotation,GetMarchTargetType().ToInt(),uuid,targetPosition,isSelf);
        if (showGunAttack == false || showSuccess == false)
        {
            return;
        }
        var requestInst = GameEntry.Resource.InstantiateAsync(_effectPkName);
        normalAttackInstList.Add(requestInst);
        requestInst.completed += (result) =>
        {
            if (model != null && model.transform != null)
            {
                hangPoint = model.transform.Find(huangPoint);
                if (hangPoint != null)
                {
                    requestInst.gameObject.transform.SetParent(hangPoint.transform);
                }
                else
                {
                    requestInst.gameObject.transform.SetParent(model.transform);
                }
        
                requestInst.gameObject.transform.localPosition = new Vector3(0,2.3f,0);
                requestInst.gameObject.transform.localRotation = Quaternion.Euler(0,-90,0);
                //requestInst.gameObject.transform.localScale = Vector3.one;
                // Debug.LogError(effectPath + ":" + useSkillID);
                GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Effect_Attack);
                YieldUtils.DelayActionWithOutContext(() =>
                {
                    if (requestInst != null)
                    {
                        requestInst.Destroy();
                    }
                }, 1);
            }
            else
            {
                requestInst.Destroy();
            }
            
        };
    }
    public void RemoveAttack()
    {
        if (normalAttackInstList != null)
        {
            foreach (var VARIABLE in normalAttackInstList)
            {
                if (VARIABLE != null)
                {
                    VARIABLE.Destroy();
                }
            }
            
            normalAttackInstList.Clear();
        }
    }

    public void DoSkill(int useSkillID, DamageType damageType,int heroId,Dictionary<long,List<string>> useSkillList,long useSkillUid)
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        if (showBattleEffect == false)
        {
            return;
        }
        var effectPath =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID,"effect_path");
        var requestInst = GameEntry.Resource.InstantiateAsync(effectPath);
        skillInstList.Add(requestInst);
        requestInst.completed += (result) => {
            if (model!=null &&transform != null)
            {
                var hangPoint = model.transform.Find(huangPoint);
                if(hangPoint!=null)
                {
                    requestInst.gameObject.transform.SetParent(hangPoint.transform);
                }
                else
                {
                    requestInst.gameObject.transform.SetParent(model.transform);
                }
                requestInst.gameObject.transform.localPosition = Vector3.zero;
                requestInst.gameObject.transform.localRotation = Quaternion.identity;
                requestInst.gameObject.transform.localScale = Vector3.one;
                if (effectPath.IndexOf("VFX_jiangjun_attack", StringComparison.Ordinal) >= 0)
                {
                    GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Effect_Skill_Attack);
                }
                // Debug.LogError(effectPath + ":" + useSkillID);
                //激光特效
                if (effectPath.IndexOf("VFX_Nvniuzai_attack")>=0/*useSkillID== 100008|| useSkillID== 100009||useSkillID== 100001*/)
                {
                    var linRender = requestInst.gameObject.transform.GetComponentInChildren<LineRenderer>();
                    if(linRender!=null)
                    {
                        linRender.SetPosition(0, linRender.transform.position);
                        var traget = GetTargetTroop();
                        if(traget!=null)
                        {
                            linRender.SetPosition(1, new Vector3(traget.transform.position.x, linRender.transform.position.y, traget.transform.position.z));
                        }
                        else
                        {
                            requestInst.Destroy();
                            return;
                        }
        
                    }
                    //
                }
                YieldUtils.DelayActionWithOutContext(() =>
                {
                    if (requestInst != null)
                    {
                        requestInst.Destroy();
                    }
                    
                }, 2);
            }
            else
            {
                requestInst.Destroy();
            }
            


        };
 
    }
    public void TroopUnitsAttack(bool isBirth = false)
    {
       
    }

    public void OnDrawGizmos()
    {
        if (transform != null && model != null)
        {
            var pos = transform.position;
            
            if (GetMarchStatus() == MarchStatus.MOVING)
                Gizmos.color = Color.green;
            else if (GetMarchStatus() == MarchStatus.CHASING)
                Gizmos.color = Color.gray;
            else if (GetMarchStatus() == MarchStatus.STATION)
                Gizmos.color = Color.blue;
            else if (GetMarchStatus() == MarchStatus.BACK_HOME)
                Gizmos.color = Color.magenta;
            else if (GetMarchStatus() == MarchStatus.ATTACKING)
                Gizmos.color = Color.red;
            else
                Gizmos.color = Color.white;
            
            Gizmos.DrawCube(pos, Vector3.one);
            
            if (sm.CurrentStateType == WorldTroopState.Move)
                Gizmos.color = Color.green;
            else if (sm.CurrentStateType == WorldTroopState.Idle)
                Gizmos.color = Color.blue;
            else if (sm.CurrentStateType == WorldTroopState.None)
                Gizmos.color = Color.magenta;
            else if (sm.CurrentStateType == WorldTroopState.Attack)
                Gizmos.color = Color.red;
            else
                Gizmos.color = Color.white;
            
            Gizmos.DrawSphere(pos + Vector3.up, 0.5f);
            Gizmos.DrawLine(pos, pos + model.transform.forward * 2);
        }
    }

    #region Culling

    public BoundingSphere GetBoundingSphere()
    {
        return boundingSphere;
    }

    public void OnCullingStateVisible(bool visible)
    {
        cullVisible = visible;
    }

    public int CullingBoundsIndex { get; set; } = -1;

    #endregion

    //对外接口，获取模型高度
    public float GetHeight()
    {
        if (_modelHeight != null)
        {
            return _modelHeight.GetHeight();
        }

        return 0;
    }
    public void ChangeFsmState(WorldTroopState stateType)
    {
        sm.ChangeState(stateType);
    }
    #region 播放受击特效
    private Dictionary<string, GameObject> hitEffectDic = new Dictionary<string, GameObject>();
    public void PlayHitEffect(string effectPath)
    {
       // Debug.LogError("play hit effect   " + this.GetMarchUUID());
        // if (hitEffectDic.ContainsKey(effectPath))
        // {
        //     BattleUtil.ReSetParticleSystems(hitEffectDic[effectPath].GetComponentsInChildren<ParticleSystem>());
        //     return;
        // }
        // var req = GameEntry.Resource.InstantiateAsync(effectPath);
        // req.completed += delegate
        // {
        //     if (hitEffectDic.ContainsKey(effectPath))
        //     {
        //         req.gameObject.Destroy();
        //         BattleUtil.ReSetParticleSystems(hitEffectDic[effectPath].GetComponentsInChildren<ParticleSystem>());
        //         return;
        //     }
        //     var hitEffect = req.gameObject;
        //     hitEffect.transform.SetParent(transform);
        //     hitEffect.transform.localPosition = Vector3.zero;
        //     hitEffect.transform.localRotation = Quaternion.identity;
        //     hitEffect.transform.localScale = Vector3.one;
        //     if (!hitEffectDic.ContainsKey(effectPath))
        //     {
        //         hitEffectDic.Add(effectPath, hitEffect);
        //     }
        // };


    }
    public void ClearHitEffect()
    {
        // foreach(var v in hitEffectDic.Values)
        // {
        //     v.Destroy();
        // }
        // hitEffectDic.Clear();

    }
    #endregion

    public void HideJunkMan()
    {
        if (model != null)
        {
            var m = model.transform.Find("WorldTroopJunkman(Clone)");
            if (m == null) 
            { 
                m = transform.Find("WorldTroopJunkman"); 
            }
            if (m != null)
            {
                m.gameObject.SetActive(false);
            }
        }

        if (transform != null)
        { 
            var m = transform.Find("WorldTroopName(Clone)"); 
            if (m == null) 
            { 
                m = transform.Find("WorldTroopName"); 
            }
            if (m != null)
            {
                m.gameObject.SetActive(false);
            }
        }
    }

    public void ShowJunkMan()
    {
        if (model != null)
        {
            var m = model.transform.Find("WorldTroopJunkman(Clone)");
            if (m == null) 
            { 
                m = transform.Find("WorldTroopJunkman"); 
            }
            if (m != null)
            {
                m.gameObject.SetActive(true);
            }
        }
        if (transform != null)
        { 
            var m = transform.Find("WorldTroopName(Clone)"); 
            if (m == null) 
            { 
                m = transform.Find("WorldTroopName"); 
            }
            if (m != null)
            {
                m.gameObject.SetActive(true);
            }
        }
    }

    public void SetVisible(bool active)
    {
        if (_visible != active)
        {
            _visible = active;
            if (transform != null)
            {
                transform.gameObject.SetActive(_visible);
            }
        }
    }
}