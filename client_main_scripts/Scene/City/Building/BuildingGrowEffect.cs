using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using GameFramework;
using UnityEngine;

public class BuildingGrowEffect : MonoBehaviour
{
    [Serializable]
    public class RendererMaterial
    {
        public Renderer renderer;

        // 建造完成的材质
        public Material[] normalMaterials;

        // 3D打印材质
        public Material[] growingMaterials;

        public Material[] disappearMaterials;
        public Material[] normalHighMaterials;
    }

    [SerializeField]
    private BuildingGrowAnimationCurve animCurve;
    
    // 建筑模型
    [SerializeField]
    private GameObject normalObj;
    [SerializeField]
    private GameObject shadowObj;
    
    private float EffectPlayLeftTime = 0.2f;
    private float GlassGridAlpha = 0.15f;
    // 升级动画开始/结束时，要实例化显示的资源
    [SerializeField]
    private string[] prefabInstanceOnStart;
    
    private List<InstanceRequest> attachmentList = new List<InstanceRequest>();
    
    // 总高度和当前进度
    [SerializeField]
    private float height;
    // 高度增加值，默认为0
    [SerializeField]
    private float heightDelta = 0.0f;

    private Vector4 bounds;

    private VEngine.Asset constructMaterial;

    [SerializeField]
    private GameObject[] rendererMaterialsExclude;
    
    [Space(10)] [SerializeField]
    private RendererMaterial[] rendererMaterials;
    
    private int _startTime;
    private int _endTime;
    private int _animStage = int.MinValue;
    private long _uuid;
    private int _buildId;
    private float _time;
    public bool isWorking;
    public bool isHiding =false;
    private MaterialPropertyBlock propBlock;

    private float progressCurveFinalTime = 0.7320341f;
    private float progressCurveFinalTimeEnd = 0.7512913f;
    private float scanCurveFinalTime = 0.8127133f;
    private float scanCurveFinalTimeEnd = 0.8505808f;
    private float gridFinalTime = 0.6180536f;
    private float gridFinalTimeEnd = 0.6335183f;
    private float glassCoverCurveFinalTime = 0.85f;
    private float glassCoverCurveFinalTimeEnd = 0.95f;

    private bool isOther;

    private void Awake()
    {
        propBlock = new MaterialPropertyBlock();
    }

    public void StartBuild(long uuid, int buildId, int startTime, int endTime, int tileSize, string ownerUid,bool isDomeUpdate =false,bool isShowRobet = false,bool needGridAlpha = true)
    {
        _uuid = uuid;
        _buildId = buildId;
        _startTime = startTime;
        _endTime = endTime;
        if (isWorking)
        {
            
        }
        else if (_animStage != 0)
        {
            _animStage = 0;
            
            _time = GameEntry.Timer.GetServerTimeSeconds() - startTime;
            if (_time < 0)
            {
                _time = 0;
            }
            
            bounds = new Vector4(-tileSize * 0.5f, -tileSize * 0.5f, tileSize, tileSize) * SceneManager.World.TileSize;

            if (shadowObj != null)
            {
                shadowObj.SetActive(false);
            }

            SetNormalMaterials();
            foreach (var rm in rendererMaterials)
            {
                rm.renderer.sharedMaterials = rm.growingMaterials;
            }

            if (isDomeUpdate)
            {
                if (needGridAlpha)
                {
                    propBlock.SetFloat("_GridAlpha", GlassGridAlpha);
                }
                else
                {
                    propBlock.SetFloat("_GridAlpha", 0);
                }
            }
            propBlock.SetFloat("_ScanProgress", 0);
            propBlock.SetFloat("_Progress", 0);
            propBlock.SetFloat("_GridProgress", 0);
            propBlock.SetFloat("_GridYOffset", 0);
            propBlock.SetFloat("_GlassProgress", 0);
            propBlock.SetFloat("_BuildingHeight", height);
            propBlock.SetVector("_WorldPivot", transform.position);
            propBlock.SetVector("_Bounds", bounds);
            
            foreach (var rm in rendererMaterials)
            {
                rm.renderer.SetPropertyBlock(propBlock);
            }

            isOther = ownerUid != GameEntry.Data.Player.Uid;
            
            if (prefabInstanceOnStart != null && !isDomeUpdate)
            {
                foreach (var i in prefabInstanceOnStart)
                {
                    var req = GameEntry.Resource.InstantiateAsync(i);
                    req.completed += delegate
                    {
                        req.gameObject.transform.SetParent(transform);
                        req.gameObject.transform.localPosition = Vector3.zero;
                    };
                    attachmentList.Add(req);
                }
            }
        }
    }
    
    public void DisappearBuild(long uuid, int buildId, int startTime, int endTime, int tileSize, string ownerUid)
    {
        _uuid = uuid;
        _buildId = buildId;
        _startTime = startTime;
        _endTime = endTime;
        if (!isHiding)
        {
            _time = GameEntry.Timer.GetServerTimeSeconds() - startTime;
            if (_time < 0)
            {
                _time = 0;
            }
            
            bounds = new Vector4(-tileSize * 0.5f, -tileSize * 0.5f, tileSize, tileSize) * SceneManager.World.TileSize;
            
            if (shadowObj != null)
            {
                shadowObj.SetActive(false);
            }

            SetNormalMaterials();
            foreach (var rm in rendererMaterials)
            {
                rm.renderer.sharedMaterials = rm.disappearMaterials;
            }

            propBlock.SetFloat("_ScanProgress", 1);
            propBlock.SetFloat("_Progress", 1);
            propBlock.SetFloat("_GridProgress", 1);
            propBlock.SetFloat("_GridYOffset", 0);
            propBlock.SetFloat("_GlassProgress", 1);
            propBlock.SetFloat("_BuildingHeight", height);
            propBlock.SetVector("_WorldPivot", transform.position);
            propBlock.SetVector("_Bounds", bounds);
            
            foreach (var rm in rendererMaterials)
            {
                rm.renderer.SetPropertyBlock(propBlock);
            }

            isOther = ownerUid != GameEntry.Data.Player.Uid;
            isHiding = true;
        }
    }


    public void ShowNormal(PlayerType playType = PlayerType.PlayerNone)
    {
        _startTime = 0;
        _endTime = 0;
        _time = 0;
        _animStage = int.MinValue;
        if (constructMaterial != null)
        {
            GameEntry.Resource.UnloadAsset(constructMaterial);
            constructMaterial = null;
        }
        SetNormalMaterials();
        
        if (shadowObj != null)
        {
            shadowObj.SetActive(true);
        }

        // RefreshShowColor(playType);
    }
    
    public void ShowBuildGridSelection()
    {
        if (constructMaterial == null)
        {
            constructMaterial = GameEntry.Resource.LoadAssetAsync(GameDefines.EntityAssets.ConstructMaterial, typeof(Material));
            constructMaterial.completed += delegate
            {
                var mat = constructMaterial.asset as Material;
        
                foreach (var rm in rendererMaterials)
                {
                    var matArray = new Material[rm.normalMaterials.Length];
                    for (int i = 0; i < matArray.Length; i++)
                    {
                        matArray[i] = mat;
                    }
                    rm.renderer.sharedMaterials = matArray;
                }
            };
        }
    }
    
    public void ShowCanPlace(bool canPlace)
    {
        var prop = new MaterialPropertyBlock();
        prop.SetFloat("_ColorSwitch", canPlace ? 0 : 1);
        foreach (var rm in rendererMaterials)
        {
            rm.renderer.SetPropertyBlock(prop);
        }
    }

    public float GetHeight()
    {
        return height + heightDelta;
    }
    
    private bool canStartGrow()
    {
        if (_buildId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
        {
            return true;
        }

        return false;
    }

    private void Update()
    {
        if (_endTime <= 0)
            return;

        if (!isWorking)
        {
            isWorking = canStartGrow();
        }
        
        var now = GameEntry.Timer.GetServerTimeSeconds();
        if (_startTime < now)
        {
            _time += Time.deltaTime;

            float duration = 0.001f;
            if (_animStage == 0)
            {
                duration = _endTime - _startTime;
            }
            else if (_animStage == 1)
            {
                duration = EffectPlayLeftTime;
            }
            
            float p = Mathf.Clamp01(_time / duration);
            float pp = p, ps = p, pg = p, pGlass = p;
            
            if (animCurve != null)
            {
                if (_animStage == 0)
                {
                    pp = animCurve.progressCurve.Evaluate(p);
                    pGlass = animCurve.glassCoverCurve.Evaluate(p);
                    ps = animCurve.scanCurve.Evaluate(p);
                    pg = animCurve.gridCurve.Evaluate(p);
                }
                else if (_animStage == 1)
                {
                    pp = animCurve.progressCurve1.Evaluate(p);
                    pGlass = animCurve.glassCoverCurve1.Evaluate(p);
                    ps = animCurve.scanCurve1.Evaluate(p);
                    pg = animCurve.gridCurve1.Evaluate(p);
                }
            }
        
            if (isHiding)
            {
                propBlock.SetFloat("_ScanProgress", 1-ps);
                propBlock.SetFloat("_Progress", 1-pp);
                propBlock.SetFloat("_GridProgress", 1-pg);
                propBlock.SetFloat("_GlassProgress", 1-pGlass);
            }
            else
            {
                propBlock.SetFloat("_ScanProgress", ps);
                propBlock.SetFloat("_Progress", pp);
                propBlock.SetFloat("_GridProgress", pg);
                propBlock.SetFloat("_GlassProgress", pGlass);
            }

            propBlock.SetFloat("_BuildingHeight", height);
            propBlock.SetVector("_WorldPivot", transform.position);
            propBlock.SetVector("_Bounds", bounds);
            
            foreach (var rm in rendererMaterials)
            {
                rm.renderer.SetPropertyBlock(propBlock);
            }
            
            if (p >= 1 && _animStage == 0)
            {
                EndAnimStage0();
                
                isWorking = false;
                _time = 0;
                _animStage = 1;
            }
        }
    }

    private void OnDisable()
    {
        bool isUseHigh = SceneManager.IsInCity();
        // 不需要显示建造过程时，恢复到正常建筑显示的材质
        foreach (var rm in rendererMaterials)
        {
            if (isUseHigh)
            {
                rm.renderer.sharedMaterials = rm.normalHighMaterials;
            }
            else
            {
                rm.renderer.sharedMaterials = rm.normalMaterials;
            }
        }
    }

    private void SetNormalMaterials()
    {
        bool isUseHigh = SceneManager.IsInCity();
        int graphicLv = SceneQualitySetting.GetGraphicLevel();
        foreach (var rm in rendererMaterials)
        {
            if (rm.renderer == null)
            {
                Log.Error("renderer null " + gameObject.name);
                continue;
            }
            if (isUseHigh && graphicLv != GameDefines.QualityLevel_Low)
            {
                rm.renderer.sharedMaterials = rm.normalHighMaterials;
            }
            else
            {
                rm.renderer.sharedMaterials = rm.normalMaterials;
            }
        }
    }

    private void EndAnimStage0()
    {
        if (shadowObj != null)
        {
            shadowObj.SetActive(true);
        }

        foreach (var i in attachmentList)
        {
            i.Destroy();
        }
        attachmentList.Clear();
    }
    
    public void EndAnim()
    {
        EndAnimStage0();
        
        isWorking = false;
        _startTime = 0;
        _endTime = 0;
        _time = 0;
        _animStage = int.MinValue;
    }
    
    public void SetAlphaValue(float alpha)
    {
        Color color;
        foreach (var rm in rendererMaterials)
        {
            if (rm.renderer.sharedMaterial.HasProperty("_Color"))
            {
                rm.renderer.GetPropertyBlock(propBlock);
                color = propBlock.GetColor("_Color");
                color.a = alpha;
                propBlock.SetColor("_Color",color);
                rm.renderer.SetPropertyBlock(propBlock);
            
                if (alpha <= 0)
                    rm.renderer.gameObject.SetActive(false);
                else
                    rm.renderer.gameObject.SetActive(true);  
            }
        }
    }
    
    //改变颜色，用于区分敌我
    private void RefreshShowColor(PlayerType playType)
    {
        float _Fresnel_switch = 1.0f;
        float _Fresnel_Color_switch = 1.0f;
        switch (playType)
        {
            case PlayerType.PlayerNone:
            case PlayerType.PlayerSelf:
                _Fresnel_switch = 1.0f;
                _Fresnel_Color_switch = 1.0f;
                break;
            case PlayerType.PlayerAlliance:
            case PlayerType.PlayerAllianceLeader:
                _Fresnel_switch = 0f;
                _Fresnel_Color_switch = 1.0f;
                break;
            case PlayerType.PlayerOther:
                _Fresnel_switch = 0f;
                _Fresnel_Color_switch = 0f;
                break;
        }

        foreach (var rm in rendererMaterials)
        {
            rm.renderer.material.SetFloat("_Fresnel_switch", _Fresnel_switch);
            rm.renderer.material.SetFloat("_Fresnel_Color_switch", _Fresnel_Color_switch);
        }
    }

    public bool IsUseFakeShadow()
    {
        bool isUseHigh = SceneManager.IsInCity();
        if (isUseHigh)
        {
            foreach (var rm in rendererMaterials)
            {
                foreach (var tempPer in rm.normalHighMaterials)
                {
                    if (tempPer.name.Contains("_high"))
                    {
                        return false;
                    }
                }
            }
        }
       
        return true;
    }

    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    public void SetRendererMaterials()
    {
#if UNITY_EDITOR
        // 获取正常材质和建筑生长材质
        if (normalObj == null)
        {
            Log.Error("Normal Obj not set");
            return;
        }
        
        var renderers = new List<Renderer>();
        renderers.AddRange(normalObj.GetComponentsInChildren<MeshRenderer>());
        renderers.AddRange(normalObj.GetComponentsInChildren<SkinnedMeshRenderer>());
        renderers.RemoveAll(a => Array.Exists(rendererMaterialsExclude, r => r != null && r.name == a.name));
        
        rendererMaterials = new RendererMaterial[renderers.Count];
        for (int i = 0; i < renderers.Count; i++)
        {
            var rm = new RendererMaterial();
            rm.renderer = renderers[i];
            rm.normalMaterials = renderers[i].sharedMaterials;
            rm.growingMaterials = rm.normalMaterials.Select(a =>
            {
                var assetPath = UnityEditor.AssetDatabase.GetAssetPath(a);
                var path = Path.GetDirectoryName(assetPath);
                var filename = Path.GetFileNameWithoutExtension(assetPath);
                if (filename.Contains("_low"))
                {
                    filename = filename.Replace("_low", "");
                }
                if (filename.Contains("_high"))
                {
                    filename = filename.Replace("_high", "");
                }
                var growMat = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(Path.Combine(path, filename + "_grow.mat"));
                return growMat != null ? growMat : a;
            }).ToArray();
            rm.disappearMaterials = rm.normalMaterials.Select(a =>
            {
                var assetPath = UnityEditor.AssetDatabase.GetAssetPath(a);
                var path = Path.GetDirectoryName(assetPath);
                var filename = Path.GetFileNameWithoutExtension(assetPath);
                if (filename.Contains("_low"))
                {
                    filename = filename.Replace("_low", "");
                }
                if (filename.Contains("_high"))
                {
                    filename = filename.Replace("_high", "");
                }
                var disMat = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(Path.Combine(path, filename + "_disappear.mat"));
                return disMat != null ? disMat : a;
            }).ToArray();
            rm.normalHighMaterials = rm.normalMaterials.Select(a =>
            {
                var assetPath = UnityEditor.AssetDatabase.GetAssetPath(a);
                var path = Path.GetDirectoryName(assetPath);
                var filename = Path.GetFileNameWithoutExtension(assetPath);
                Material growMat = null;
                if (filename.Contains("_low"))
                {
                    filename = filename.Replace("_low", "");
                }
                if (filename.Contains("_high"))
                {
                    filename = filename.Replace("_high", "");
                }
                growMat = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(Path.Combine(path, filename + "_high.mat"));
                return growMat != null ? growMat : a;
            }).ToArray();
            rendererMaterials[i] = rm;
        }
        /*
        if (glassCover != null)
        {
            var oldRendererMaterials = rendererMaterials;
            rendererMaterials = new RendererMaterial[oldRendererMaterials.Length + 1];
            Array.Copy(oldRendererMaterials, rendererMaterials, oldRendererMaterials.Length);
            
            var glassRenderer = glassCover.GetComponent<Renderer>();
            var rm = new RendererMaterial();
            rm.renderer = glassRenderer;
            rm.normalMaterials = glassRenderer.sharedMaterials;
            rm.growingMaterials = rm.normalMaterials.Select(a =>
            {
                var assetPath = UnityEditor.AssetDatabase.GetAssetPath(a);
                var path = Path.GetDirectoryName(assetPath);
                var filename = Path.GetFileNameWithoutExtension(assetPath);
                var glassMat = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(Path.Combine(path, filename + "_grow.mat"));
                return glassMat != null ? glassMat : a;
            }).ToArray();
            rendererMaterials[rendererMaterials.Length - 1] = rm;
        }*/
        
        //
        // 获取建筑模型最大高度
        //
        height = 0;
        var filters = normalObj.GetComponentsInChildren<MeshFilter>();
        foreach (var f in filters)
        {
            var verts = f.sharedMesh.vertices;
            foreach (var v in verts)
            {
                var worldV = f.transform.TransformPoint(v);
                if (worldV.y > height)
                {
                    height = worldV.y;
                }
            }
        }
        
        var skinned = normalObj.GetComponentsInChildren<SkinnedMeshRenderer>();
        foreach (var f in skinned)
        {
            var verts = f.sharedMesh.vertices;
            var bindposes = f.sharedMesh.bindposes;
            var boneWeights = f.sharedMesh.boneWeights;
            var bones = f.bones;
            for (var i = 0; i < verts.Length; i++)
            {
                var v = verts[i];
                var w = boneWeights[i];
                Vector4 worldV = bones[w.boneIndex0].localToWorldMatrix * bindposes[w.boneIndex0] * v * w.weight0
                                 + bones[w.boneIndex1].localToWorldMatrix * bindposes[w.boneIndex1] * v * w.weight1
                                 + bones[w.boneIndex2].localToWorldMatrix * bindposes[w.boneIndex2] * v * w.weight2
                                 + bones[w.boneIndex3].localToWorldMatrix * bindposes[w.boneIndex3] * v * w.weight3;
                
                if (worldV.y > height)
                {
                    height = worldV.y;
                }
            }
        }
#endif
    }

    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    private void TestStartBuild()
    {
        enabled = true;
        var startTime = GameEntry.Timer.GetServerTimeSeconds();
        var endTime = startTime + Mathf.RoundToInt(ProgressTime);
        StartBuild(0, 0, startTime, endTime, 2, GameEntry.Data.Player.Uid);
    }

    [Sirenix.OdinInspector.Button(Sirenix.OdinInspector.ButtonSizes.Large)]
    private void TestStopBuild()
    {
        enabled = false;
        ShowNormal();
    }
    
    public float ProgressTime = 6.8f;

}