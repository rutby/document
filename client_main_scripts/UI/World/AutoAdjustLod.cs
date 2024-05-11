using System;
using System.Collections.Generic;
using BitBenderGames;
using DG.Tweening;
using GameFramework;
using Sirenix.OdinInspector;
using UnityEngine;

public class AutoAdjustLod : MonoBehaviourWrapped
{
    public static readonly float FADE_DURATION = 0.3f;
    public static readonly Vector3 OUT_POS = new Vector3(-10000f, 0, -10000f);
    public static readonly Dictionary<GameObject, Vector3> targetOriginPos = new Dictionary<GameObject, Vector3>();
    
    // true: 使用 SetActive 切换，false: 使用 localPosition 切换
    public bool noOptimizeActivate;
    
    public enum ActiveState
    {
        Unknown = -1,
        False = 0,
        True = 1,
    }

    private bool settingSucc = false;
    [SerializeField] private LodType lodType = LodType.None;
    [SerializeField] [ShowIf("@lodType == LodType.None")] private Setting[] settings;

    public void SetLodType(LodType t)
    {
        lodType = t;
        InitConfig();
        OnEnable();
    }

    public void UpdateLod(int lod)
    {
        if (gameObject == null)
        {
            Log.Info($"AutoAdjustLod: Game object has been destroyed! GameObject: {name}");
            return;
        }
        
        foreach (Setting setting in settings)
        {
            ActiveState active = (setting.showLods?.Contains(lod) == true) ? ActiveState.True : ActiveState.False;
            if (setting.activeCache != active)
            {
                setting.activeCache = active;
                if (active == ActiveState.True)
                {
                    //setting.FadeIn();
                    setting.SetTargetsActive(true);
                }
                else
                {
                    //setting.FadeOut();
                    setting.SetTargetsActive(false);
                }
            }
        }
    }

    private void Awake()
    {
        if (IsSceneUseLod())
        {
            InitConfig();
        }
    }

    private void InitConfig()
    {
        settingSucc = InitSettingsByConfig() || InitSettingsByPrefab();
    }

    private void OnEnable()
    {
        if (IsSceneUseLod() && settingSucc)
        {
            SceneManager.World?.AddLodAdjuster(this);
        }
    }

    private void OnDisable()
    {
        if (IsSceneUseLod() && settingSucc)
        {
            SceneManager.World?.RemoveLodAdjuster(this);
        }
    }

    private void OnDestroy()
    {
        // if (settings != null)
        // {
        //     foreach (Setting setting in settings)
        //     {
        //         setting.StopFade();
        //     }
        // }
    }

    public bool IsMainShow()
    {
        foreach (Setting setting in settings)
        {
            if (setting.isMain && setting.activeCache == ActiveState.True)
            {
                return true;
            }
        }
        return false;
    }

    // 读配置
    private bool InitSettingsByConfig()
    {
        if (lodType == LodType.None)
        {
            return false;
        }

        Dictionary<string, LodConfig> configs = SceneManager.World?.GetLodConfigs((int) lodType);
        if (configs == null)
        {
            return false;
        }

        List<Setting> settingList = new List<Setting>();
        foreach (var kvp in configs)
        {
            string path = kvp.Key;
            Transform tf = transform.Find(path);
            if (tf != null)
            {
                GameObject[] targets = { tf.gameObject };
                Setting setting = new Setting();
                setting.SetAdjuster(this);
                setting.InitByConfig(targets, kvp.Value);
                setting.SetTargetsActive(false);
                settingList.Add(setting);
                
                // TODO: Beef set noFading by config
                setting.noFading = (lodType == LodType.Ground || lodType == LodType.Zone);
            }
        }
        settings = settingList.ToArray();
        return true;
    }

    // 读预制体
    private bool InitSettingsByPrefab()
    {
        if (settings == null)
        {
            return false;
        }
        
        foreach (Setting setting in settings)
        {
            setting.SetAdjuster(this);
            setting.InitByPrefab();
            setting.SetTargetsActive(false);
        }
        
        return true;
    }
    
    private bool IsSceneUseLod()
    {
        return SceneManager.IsInWorld() || SceneManager.IsInCity();
    }

    public void SetNoOptimizeActivate(bool noOptimizeActivate)
    {
        this.noOptimizeActivate = noOptimizeActivate;
    }

    [Serializable]
    public class Setting
    {
        public GameObject[] targets;
        public string lodRange;
        
        // true: active 时执行特效逻辑
        public bool isMain;
        
        // true: 禁用切换时淡入淡出
        public bool noFading;
        
        [HideInInspector] public List<int> showLods;
        [ReadOnly] public ActiveState activeCache = ActiveState.Unknown;
        private Sequence fadeSeq;
        private AutoAdjustLod adjuster;

        public void SetAdjuster(AutoAdjustLod adjuster)
        {
            this.adjuster = adjuster;
        }

        public void InitByConfig(GameObject[] targets, LodConfig lodConfig)
        {
            activeCache = ActiveState.Unknown;
            this.targets = targets;
            lodRange = $"{lodConfig.lodStart}-{lodConfig.lodEnd}";
            showLods = new List<int>();
            isMain = lodConfig.isMain;
            noFading = lodConfig.noFading;
            for (int i = lodConfig.lodStart; i <= lodConfig.lodEnd; i++)
            {
                showLods.Add(i);
            }
        }

        public void InitByPrefab()
        {
            activeCache = ActiveState.Unknown;
            showLods = new List<int>();
            string[] ranges = lodRange.Split(';', ',');
            foreach (string range in ranges)
            {
                string[] strs = range.Split('-');
                if (strs.Length == 1)
                {
                    showLods.Add(strs[0].ToInt());
                }
                else if (strs.Length == 2)
                {
                    for (int i = strs[0].ToInt(); i <= strs[1].ToInt(); i++)
                    {
                        showLods.Add(i);
                    }
                }
            }
        }

        // public void StopFade()
        // {
        //     fadeSeq?.Kill();
        // }

        // public void FadeIn()
        // {
        //     if (noFading)
        //     {
        //         SetTargetsActive(true);
        //         return;
        //     }
        //     
        //     fadeSeq?.Kill();
        //     fadeSeq = DOTween.Sequence();
        //     SetTargetsActive(true);
        //     foreach (GameObject target in targets)
        //     {
        //         if (target == null)
        //         {
        //             continue;
        //         }
        //         
        //         fadeSeq.Join(DOFadeSprites(target, 1, FADE_DURATION));
        //         //fadeSeq.Join(DOFadeTexts(target, 1, FADE_DURATION));
        //         
        //         // TODO: Beef use fading
        //         foreach (MeshRenderer renderer in target.GetComponentsInChildren<MeshRenderer>(true))
        //         {
        //             renderer.enabled = true;
        //             // if (renderer.GetComponent<SuperTextMesh>() == null)
        //             // {
        //             //     renderer.enabled = true;
        //             // }
        //         }
        //         foreach (SkinnedMeshRenderer renderer in target.GetComponentsInChildren<SkinnedMeshRenderer>(true))
        //         {
        //             renderer.enabled = true;
        //         }
        //     }
        // }

        // public void FadeOut()
        // {
        //     if (noFading)
        //     {
        //         SetTargetsActive(false);
        //         return;
        //     }
        //     
        //     fadeSeq?.Kill();
        //     fadeSeq = DOTween.Sequence();
        //     foreach (GameObject target in targets)
        //     {
        //         if (target == null || !target.activeSelf)
        //         {
        //             continue;
        //         }
        //         
        //         fadeSeq.Join(DOFadeSprites(target, 0, FADE_DURATION));
        //         //fadeSeq.Join(DOFadeTexts(target, 0, FADE_DURATION));
        //         
        //         // TODO: Beef use fading
        //         foreach (MeshRenderer renderer in target.GetComponentsInChildren<MeshRenderer>(true))
        //         {
        //             renderer.enabled = false;
        //             // if (renderer.GetComponent<SuperTextMesh>() == null)
        //             // {
        //             //     renderer.enabled = false;
        //             // }
        //         }
        //         foreach (SkinnedMeshRenderer renderer in target.GetComponentsInChildren<SkinnedMeshRenderer>(true))
        //         {
        //             renderer.enabled = false;
        //         }
        //     }
        //     
        //     fadeSeq.OnComplete(() =>
        //     {
        //         SetTargetsActive(false);
        //     });
        // }

        public void SetTargetsActive(bool active)
        {
            if (adjuster.noOptimizeActivate)
            {
                // 不使用优化
                foreach (GameObject target in targets)
                {
                    if (target != null)
                    {
                        if (targetOriginPos.ContainsKey(target))
                        {
                            target.transform.localPosition = targetOriginPos[target];
                            targetOriginPos.Remove(target);
                        }
                        
                        if (target.activeSelf != active)
                        {
                            target.SetActive(active);
                        }
                    }
                }
            }
            else
            {
                // 使用优化
                foreach (GameObject target in targets)
                {
                    if (target != null)
                    {
                        if (active)
                        {
                            if (!target.activeSelf)
                            {
                                target.SetActive(true);
                            }

                            if (targetOriginPos.ContainsKey(target))
                            {
                                target.transform.localPosition = targetOriginPos[target];
                                targetOriginPos.Remove(target);
                            }
                        }
                        else
                        {
                            if (!IsOutPos(target.transform.localPosition))
                            {
                                targetOriginPos[target] = target.transform.localPosition;
                                target.transform.localPosition = OUT_POS;
                            }
                        }
                    }
                }
            }
        }

        private bool IsOutPos(Vector3 pos)
        {
            return pos.x < OUT_POS.x + 1 && pos.z < OUT_POS.z + 1;
        }

        // private Tween DOFadeSprites(GameObject target, float endValue, float duration)
        // {
        //     SpriteRenderer[] sprites = target.GetComponentsInChildren<SpriteRenderer>(true);
        //     float startValue;
        //     if (sprites.Length > 0)
        //     {
        //         startValue = sprites[0].color.a;
        //     }
        //     else
        //     {
        //         startValue = endValue;
        //         duration = 0;
        //     }
        //     
        //     return DOTween.To(a =>
        //     {
        //         foreach (SpriteRenderer sprite in sprites)
        //         {
        //             sprite.Set_color_a(a);
        //         }
        //     }, startValue, endValue, duration);
        // }

        // private Tween DOFadeTexts(GameObject target, float endValue, float duration)
        // {
        //     SuperTextMesh[] texts = target.GetComponentsInChildren<SuperTextMesh>(true);
        //     float startValue;
        //     if (texts.Length > 0)
        //     {
        //         startValue = (float) texts[0].color.a / byte.MaxValue;
        //     }
        //     else
        //     {
        //         startValue = endValue;
        //         duration = 0;
        //     }
        //     
        //     return DOTween.To(a =>
        //     {
        //         foreach (SuperTextMesh text in texts)
        //         {
        //             text.SetColorAlpha(a);
        //         }
        //     }, startValue, endValue, duration);
        // }
    }
}