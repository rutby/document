
using System;
using System.Reflection;
using GameFramework;
using UnityEngine;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

//
// 管理主城和世界场景以及实现场景切换逻辑
//
public static class SceneManager
{
    #region Public

    public enum SceneID
    {
        None = 0,
        City = 1, // 主城
        World = 2, // 世界
        PVE = 3, // PVE场景
        Bridge = 4, // 造桥
    }

    public static SceneInterface World
    {
        get { return world; }
    }
    
    public static int CurrSceneID
    {
        get => (int) currSceneID;
        set => currSceneID = (SceneID)value;
    }

    private static ScriptableRendererData _scriptableRendererData;
    public static void ToggleBlendDepth(bool b)
    {
        if (_scriptableRendererData == null)
        {
            var pipeline = QualitySettings.renderPipeline as UniversalRenderPipelineAsset;
            if (pipeline != null)
            {
                FieldInfo propertyInfo = pipeline.GetType().GetField( "m_RendererDataList", BindingFlags.Instance | BindingFlags.NonPublic );
                _scriptableRendererData = ((ScriptableRendererData[]) propertyInfo?.GetValue(pipeline))?[0];
            }
        }

        if (_scriptableRendererData != null)
        {
            foreach (var feature in _scriptableRendererData.rendererFeatures)
            {
                if (feature.name.Equals("Blend"))
                {
                    var rendererObjects = (RenderObjects)feature;
                    rendererObjects.settings.overrideDepthState = b;
                }
            }
            
            _scriptableRendererData.SetDirty();
        }
    }
    
    public static void CreateWorld()
    {
        //Destroy();
        if (useAutoGc)
        {
            GameEntry.Resource.ReleaseCacheResource();
        }
        worldObj = new GameObject("World", typeof(WorldScene));
        world = worldObj.GetComponent<WorldScene>();
        world.Init(worldObj);
        
        currSceneID = SceneID.World;
        
        ToggleBlendDepth(true);
        Log.Debug("Create world init");
    }

    public static void CreateCity()
    {
        //Destroy();
        if (useAutoGc)
        {
            GameEntry.Resource.ReleaseCacheResource();
        }
        worldObj = new GameObject("City", typeof(CityScene));
        world = worldObj.GetComponent<CityScene>();
        world.Init(worldObj);
        currSceneID = SceneID.City;

        ToggleBlendDepth(false);
        
        Log.Debug("Create city init");
    }

    public static void ChangeScene(SceneID sceneId)
    {
        if (currSceneID == sceneId)
            return;

        Destroy();

        if (sceneId == SceneID.City)
        {
            CreateCity();
        }
        else if (sceneId == SceneID.World)
        {
            CreateWorld();
        }
    }
    
    public static void Destroy()
    {
        Log.Debug("scene Destroy {0}", currSceneID);
        if (currSceneID == SceneID.None)
        {
            return;
        }

        if (worldObj != null)
        {
            world.Uninit();
            world = null;
            GameObject.Destroy(worldObj);
            worldObj = null;
        }

        currSceneID = SceneID.None;
    }
    
    public static void DestroyScene(MonoBehaviour obj)
    {
        Log.Debug("scene DestroyScene {0}", currSceneID);
        SceneInterface scene = obj as SceneInterface;
        if (scene != null)
        {
            scene.Uninit();
            GameObject.Destroy(obj.gameObject);
            //currSceneID = SceneID.None;
        }
    }
    
    public static void Update()
    {
        //world?.Update();
    }
    
    public static void LateUpdate()
    {
        
    }

    public static void FixedUpdate()
    {
        //world?.FixedUpdate();
    }

    // 当前是否在世界
    public static bool IsInWorld()
    {
        return currSceneID == SceneID.World;
    }

    // 当前是否在主城
    public static bool IsInCity()
    {
        return currSceneID == SceneID.City;
    }
    
    public static bool IsInPVE()
    {
        return currSceneID == SceneID.PVE;
    }

    public static bool IsInBridge()
    {
        return currSceneID == SceneID.Bridge;
    }

    public static bool IsSceneNone()
    {
        return currSceneID == SceneID.None;
    }

    public static bool IsSceneBuildFninsh()
    {
        return World.IsBuildFinish();
    }

    public static void SetAutoGcFlag(bool value)
    {
        useAutoGc = value;
    }
    #endregion

    private static SceneID currSceneID = SceneID.None;
    private static InstanceRequest worldInst;
    private static SceneInterface world;
    private static GameObject worldObj;
    private static bool useAutoGc =false;
}