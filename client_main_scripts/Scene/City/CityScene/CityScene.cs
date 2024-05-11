using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using BitBenderGames;
using GameFramework;
using Main.Scripts.Scene;
using Sfs2X.Entities.Data;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using XLua;
public enum CitySceneType
{
    DigDig,
    Guide,
    World,
}

public class CityScene : MonoBehaviour, SceneInterface
{
    private CitySceneType citySceneType = CitySceneType.Guide;
    //城内世界的格子大小
    private const int kTileCountX = 100;
    private const int kTileCountY = 100;
    private const int kBlockSize = 100;
    private static readonly Vector2Int kBlockCount = new Vector2Int(kTileCountX / kBlockSize, kTileCountY / kBlockSize);

    private static readonly int Prop_Control = Shader.PropertyToID("_Control");
    private static readonly int Prop_Splat0 = Shader.PropertyToID("_Splat0");
    private static readonly int Prop_Splat1 = Shader.PropertyToID("_Splat1");
    private static readonly int Prop_Control_ST = Shader.PropertyToID("_Control_ST");
    private static readonly int Prop_Splat0_ST = Shader.PropertyToID("_Splat0_ST");
    private static readonly int Prop_Splat1_ST = Shader.PropertyToID("_Splat1_ST");
    private static readonly int Prop_TerrainBounds = Shader.PropertyToID("_TerrainBounds");
    
    
    public Vector2Int BlockCount => kBlockCount;
    public int BlockSize => kBlockSize;
    public float TileSize => TileCoord.TileSize;
    public Vector2Int TileCount { get; private set; }

    private List<CityManagerBase> subModules = new List<CityManagerBase>();
    
    private Transform dynamicObjNode;
    
    private float prevLodDist = -1;

    public Transform DynamicObjNode
    {
        get { return dynamicObjNode; }
    }

    private Transform buildBubbleNode;

    public Transform BuildBubbleNode
    {
        get { return buildBubbleNode; }
    }
    private InstanceRequest sceneInst;
    private InstanceRequest sceneInst_dig;

    private bool isBuildComplete = false;
    private GameObject gameObject;

    private InstanceRequest terrainInst;
    private VEngine.Asset terrainSetting;
    private InstanceRequest terrainInstNew;
    private VEngine.Asset terrainSettingNew;
    private FOWSystem fowSystem;
    private Action fogCallBack;
    
    private Transform cityGrid;
    private static int[] lodArray;
    public static int[] LodArray
    {
        get
        {
            if (lodArray == null)
            {
                LuaTable lodTable = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetLodArray");
                List<int> lodList = new List<int>();
                for (int i = 0; i <= lodTable.Length; i++)
                {
                    lodList.Add(lodTable.Get<int>(i));
                }
                lodArray = lodList.ToArray();
            }
            
            return lodArray;
        }
    }

    
    public Transform Transform
    {
        get { return gameObject.transform; }
    }
    
    public int CurTileCountXMin { get; private set; }
    public int CurTileCountXMax { get; private set; }
    public int CurTileCountYMin { get; private set; }
    public int CurTileCountYMax { get; private set; }
    
    public int WorldSize { get; private set; }

    private HashSet<MonoBehaviour> activePhysicObj = new HashSet<MonoBehaviour>();
    private CityCamera Camera { get; set; }
    private CityStaticManager StaticManager { get; set; }
    // private CityPointManager CityPointManager { get; set; }
    private ModelManager ModelManager { get; set; }
    private FakeCityModelManager FakeCityModelManager { get; set; }
    private CityInputManager InputManager { get; set; }
    
    private CityLodManager LodManager;
    private CityAutoMonoManager AutoMonoManager { get; set; }
    
    private CityLightManager CityLightManager { get; set; }
    
    public float BlackLandSpeed { get; private set; }

    public void Init(GameObject go)
    {
        this.gameObject = go;
        gameObject.SetActive(true);

        var citySize = kTileCountX;
        
        WorldSize = citySize;
        CurTileCountXMin = 0;
        CurTileCountXMax = citySize - 1;
        CurTileCountYMin = 0;
        CurTileCountYMax = citySize - 1;
        BlackLandSpeed = 1;
        TileCount = new Vector2Int(kTileCountX, kTileCountY);
        SetWorldSize(25);
        GameEntry.Lua.Call("CSharpCallLuaInterface.SetIsInCity", true);
        GameEntry.Lua.Call("CSharpCallLuaInterface.WorldMarchGetReq");
        if (!SDKManager.IS_UNITY_PC())
        {
           QualitySettings.SetQualityLevel(2);
        }
        else
        {
            QualitySettings.SetQualityLevel(3);
        }


        string path = "Assets/Main/Prefab_Dir/Home/Terrian/MainMapTerrian.prefab";//GameDefines.EntityAssets.Wasteland_City;
        GameEntry.Resource.PreloadAsset(path, typeof(GameObject));
        // GameEntry.Resource.PreloadAsset(
        //     SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
        //         ? GameDefines.EntityAssets.Terrain_City_High
        //         : GameDefines.EntityAssets.Terrain_City_Low, typeof(GameObject));
    }
    
    public void CreateScene(Action callback = null)
    {
        Log.Debug("city scene  start create");
        isBuildComplete = false;
        var citySize = kTileCountX;
        var cityCenter = new Vector2Int(citySize / 2, citySize / 2);
        
        if (dynamicObjNode == null)
        {
            dynamicObjNode = new GameObject("dynamicObj").transform;
            dynamicObjNode.SetParent(gameObject.transform, false);
        }

        if (buildBubbleNode == null)
        {
            buildBubbleNode = new GameObject("buildBubbleNode").transform;
            buildBubbleNode.SetParent(dynamicObjNode, false);
        }
        if (sceneInst == null)
        {
            this.citySceneType = CitySceneType.DigDig;
            Log.Debug("city scene prefab start load");
            sceneInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.Wasteland_City);
            sceneInst.completed += delegate
            {
                Log.Debug("city scene prefab create ok");
                sceneInst.gameObject.transform.SetParent(gameObject.transform);
                Log.Debug("city scene prefab sceneInst.gameObject.transform.SetParent(gameObject.transform);");
                 SetPostProcessQuality();
                Log.Debug("city scene prefab SetPostProcessQuality");
                Camera.SetTouchInputControllerEnable(true);
                Log.Debug("city scene prefab load ok");
                SetLightData();
                CheckInvokeCreateComplete(callback);
                GameEntry.Event.Fire(EventId.MainMapTerrainLoadFinish);
            };
        }


        if (terrainInst == null)
        {
            // var terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
            //     ? GameDefines.EntityAssets.Terrain_City_High
            //     : GameDefines.EntityAssets.Terrain_City_Low;
            string terrainPrefab = "Assets/Main/Prefab_Dir/Home/Terrian/MainMapTerrian.prefab";
            Log.Debug("terrain start load, " + terrainPrefab);
            terrainInst = GameEntry.Resource.InstantiateAsync(terrainPrefab);
            terrainInst.completed += (r) =>
            {
                Log.Debug("terrain create ok, " + terrainPrefab);
                terrainInst.gameObject.transform.SetParent(gameObject.transform);
                //如果是开荒 序章地表创建后先隐藏，开荒结束后再打开
                terrainInst.gameObject.SetActive(true);
                Log.Debug("terrain load ok, " + terrainPrefab);
                
                CheckInvokeCreateComplete(callback);
                if (terrainInst == null || !terrainInst.isDone)
                    return;
                if (sceneInst == null || !sceneInst.isDone)
                    return;
                Log.Debug("CheckInvokeCreateComplete {0}_{1}_{2}", isBuildComplete, terrainInst == null ? false : terrainInst.isDone, sceneInst == null ? false : sceneInst.isDone);
            };
        }
        
        // if (terrainSetting == null)
        // {
        //     var setting = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
        //         ? GameDefines.EntityAssets.TerrainSetting_City_High
        //         : GameDefines.EntityAssets.TerrainSetting_City_Low;
        //     Log.Debug("terrainSetting start load ");
        //     terrainSetting = GameEntry.Resource.LoadAssetAsync(setting, typeof(ScriptableObject));
        //     terrainSetting.completed += delegate
        //     {
        //         Log.Debug("terrainSetting load ok, " + terrainSetting.pathOrURL);
        //         if (terrainSetting != null)
        //         {
        //             ChangeTerrainSetting(terrainSetting.asset as TerrainSetting);
        //         }
        //     };
        // }

        // GameEntry.Lua.Call("CSharpCallLuaInterface.SetMainPos");
        GameEntry.Data.Building.SetMainPos();
        Log.Debug("CreateScene 1, ");
        if (subModules.Count == 0)
        {
            Camera = AddSubModule<CityCamera>();
            Log.Debug("CreateScene Camera = AddSubModule<CityCamera>() ");
            StaticManager = AddSubModule<CityStaticManager>();
            Log.Debug("CreateScene StaticManager = AddSubModule<CityStaticManager>()");
            // CityPointManager = AddSubModule<CityPointManager>();
            FakeCityModelManager = AddSubModule<FakeCityModelManager>();
            Log.Debug("CreateScene FakeCityModelManager = AddSubModule<FakeCityModelManager>();");
            ModelManager = AddSubModule<ModelManager>();
            Log.Debug("CreateScene ModelManager = AddSubModule<ModelManager>();");
            InputManager = AddSubModule<CityInputManager>();
            Log.Debug("CreateScene InputManager = AddSubModule<CityInputManager>();");
            LodManager = AddSubModule<CityLodManager>();
            Log.Debug("CreateScene LodManager = AddSubModule<CityLodManager>();");
            AutoMonoManager = AddSubModule<CityAutoMonoManager>();
            Log.Debug("CreateScene AutoMonoManager = AddSubModule<CityAutoMonoManager>();");
            CityLightManager = AddSubModule<CityLightManager>();
            Log.Debug("CreateScene CityLightManager = AddSubModule<CityLightManager>();");
            foreach (var m in subModules)
            {
                m.Init();
            }
            Log.Debug("CreateScene m.Init();;");
            StaticManager.ToggleShow(true);
            Log.Debug("CreateScene StaticManager.ToggleShow(false);, ");
            Camera.AfterUpdate += AfterCameraUpdate;
            Camera.Lookat(TileToWorld(cityCenter));
            Log.Debug("CreateScene Camera.Lookat(TileToWorld(cityCenter))");
        }
        else
        {
            CheckInvokeCreateComplete(callback);
        }
        Log.Debug("CreateScene ok");
        
    }
    private void CheckInvokeCreateComplete(Action onComplete)
    {
        if (terrainInst == null || !terrainInst.isDone)
            return;
        if (sceneInst == null || !sceneInst.isDone)
            return;

        Log.Debug("CheckInvokeCreateComplete isBuildComplete ");
        isBuildComplete = true;
        onComplete?.Invoke();
    }

    private void SetLightData()
    {
        if (sceneInst == null || !sceneInst.isDone)
            return;
        CityLightManager.AddParam(sceneInst.gameObject);
    }
    
    public void RemoveFakeSampleMarchData(long index)
    {
        
    }

    public void UpdateFakeSampleMarchDataWhenBack(long index, long startTime, long endTime)
    {
        
    }

    public void UpdateFakeSampleMarchDataWhenStartPick(long index, long endTime)
    {
        
    }

    public void AddFakeSampleMarchData(long startIndex, long endIndex, long startTime, long endTime)
    {
        
    }

    public void EndDig()
    {
    }
    
    public void UninitSubModulesAndCameraUpdate()
    {
        foreach (var m in subModules)
        {
            m.UnInit();
        }

        subModules.Clear();
        Camera.AfterUpdate -= AfterCameraUpdate;
    }

    public void Uninit()
    {
        UninitSubModulesAndCameraUpdate();
        if (terrainInst != null)
        {
            terrainInst.Destroy();
            terrainInst = null;
        }

        if (terrainSetting != null)
        {
            terrainSetting.Release();
            terrainSetting = null;
        }

        if (buildBubbleNode != null)
        {
            GameObject.Destroy(buildBubbleNode.gameObject);
            buildBubbleNode = null;
        }

        if (dynamicObjNode != null)
        {
            GameObject.Destroy(dynamicObjNode.gameObject);
            dynamicObjNode = null;
        }
        
        isBuildComplete = false;

    }
    
    private T AddSubModule<T>() where T : CityManagerBase
    {
        var t = (T)Activator.CreateInstance(typeof(T), new object[]{this});
        subModules.Add(t);
        return t;
    }
    
    private static Dictionary<Type, string> PostprocessSettingKeys = new Dictionary<Type, string>
    {
        [typeof(Bloom)] = GameDefines.QualitySetting.PostProcess_Bloom,
       // [typeof(ColorAdjustments)] = GameDefines.QualitySetting.PostProcess_ColorAdjustments,
        [typeof(Tonemapping)] = GameDefines.QualitySetting.PostProcess_Tonemapping,
        //[typeof(Vignette)] = GameDefines.QualitySetting.PostProcess_Vignette,
        [typeof(LiftGammaGain)] = GameDefines.QualitySetting.PostProcess_LiftGammaGain,
        [typeof(DepthOfField)] = GameDefines.QualitySetting.PostProcess_LiftGammaGain,
    };
    
    private void SetPostProcessQuality()
    {
        if (sceneInst == null || sceneInst.gameObject == null)
            return;
        
        Volume ppVolume = sceneInst.gameObject.GetComponentInChildren<Volume>(true);
        if (ppVolume == null || ppVolume.profile == null)
            return;
        
        ppVolume.enabled = true;

        bool isAnyActive = false;
        var list = new List<VolumeComponent>();
        ppVolume.profile.TryGetAllSubclassOf(typeof(VolumeComponent), list);
        foreach (var com in list)
        {
            if (PostprocessSettingKeys.TryGetValue(com.GetType(), out var settingKey))
            {
                var lv = GameEntry.Setting.GetInt(settingKey, GameDefines.QualityLevel_Off);
                if (lv == GameDefines.QualityLevel_Off)
                {
                    com.active = false;
                }
                else
                {
                    com.active = true;
                    isAnyActive = true;
                }
            }
        }

        if (isAnyActive)
        {
             Camera.EnablePostProcess();
        }
        else
        {
            Camera.DisablePostProcess();
            ppVolume.enabled = false;
        }
    }

    public void ChangeQualitySetting()
    {
        SetPostProcessQuality();
        // ChangeTerrain();
    }

    public void Update()
    {
        UpdateSubModule();
    }

    // private void ChangeTerrain()
    // {
    //     Action onChangeComplete = delegate
    //     {
    //         if (terrainInstNew != null && terrainInstNew.isDone &&
    //             terrainSettingNew != null && terrainSettingNew.isDone)
    //         {
    //             if (terrainInst != null)
    //             {
    //                 terrainInst.Destroy();
    //             }
    //
    //             if (terrainSetting != null)
    //             {
    //                 terrainSetting.Release();
    //             }
    //             
    //             terrainInstNew.gameObject.transform.SetParent(gameObject.transform);
    //             ChangeTerrainSetting(terrainSettingNew.asset as TerrainSetting);
    //
    //             terrainInst = terrainInstNew;
    //             terrainSetting = terrainSettingNew;
    //             terrainInstNew = null;
    //             terrainSettingNew = null;
    //         }
    //     };
    //     string terrainPrefab = "Assets/Main/Prefab_Dir/Home/Terrian/MainMapTerrian.prefab";
    //     // var terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
    //     //     ? GameDefines.EntityAssets.Terrain_City_High
    //     //     : GameDefines.EntityAssets.Terrain_City_Low;
    //     terrainInstNew = GameEntry.Resource.InstantiateAsync(terrainPrefab);
    //     terrainInstNew.completed += (r) =>
    //     {
    //         onChangeComplete();
    //     };
    //     
    //     // var setting = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
    //     //     ? GameDefines.EntityAssets.TerrainSetting_High
    //     //     : GameDefines.EntityAssets.TerrainSetting_Low;
    //     //
    //     // terrainSettingNew = GameEntry.Resource.LoadAssetAsync(setting, typeof(ScriptableObject));
    //     // terrainSettingNew.completed += delegate
    //     // {
    //     //     onChangeComplete();
    //     // };
    // }
    //
    // private void ChangeTerrainSetting(TerrainSetting setting)
    // {
    //     Shader.SetGlobalTexture(Prop_Control, setting.control);
    //     Shader.SetGlobalTexture(Prop_Splat0, setting.splat0);
    //     Shader.SetGlobalTexture(Prop_Splat1, setting.splat1);
    //     Shader.SetGlobalVector(Prop_Control_ST, setting.control_st);
    //     Shader.SetGlobalVector(Prop_Splat0_ST, setting.splat0_st);
    //     Shader.SetGlobalVector(Prop_Splat1_ST, setting.splat1_st);
    //     Shader.SetGlobalVector(Prop_TerrainBounds, setting.terrainBounds);
    // }
    
#if false
    
    private GUIStyle textStyle;
    private void OnGUI()
    {
        if (textStyle == null)
        {
            textStyle = new GUIStyle();
            textStyle.normal.textColor = Color.green;
            textStyle.fontSize = 25;
        }
        
        var point = GetTouchPoint();
        
        var fogX = (int)(point.x / kFogTileSize);
        var fogY = (int)(point.z / kFogTileSize);
        var fogId = fogY * kFogTileCount.x + fogX + 1;
        
        var fogSX = (int)(point.x / kFogTile2x2Size);
        var fogSY = (int)(point.z / kFogTile2x2Size);
        var fogSId = fogSY * kFogTile2x2Count.x + fogSX + 1;
        
        GUILayout.BeginArea(new Rect(20, 20, 400, 300));
        GUILayout.Label(string.Format("Fog Pos: ({0} {1}), {2}", fogX, fogY, fogId), textStyle);
        GUILayout.Label(string.Format("Fog S Pos: ({0} {1}), {2}", fogSX, fogSY, fogSId), textStyle);

        var s1 = GameEntry.Data.Fog.GetSpecialFogIdByFodIdAndDirection(fogId, 1);
        var s2 = GameEntry.Data.Fog.GetSpecialFogIdByFodIdAndDirection(fogId, 2);
        var s3 = GameEntry.Data.Fog.GetSpecialFogIdByFodIdAndDirection(fogId, 3);
        var s4 = GameEntry.Data.Fog.GetSpecialFogIdByFodIdAndDirection(fogId, 4);
        GUILayout.Label(string.Format("Fog SS Pos: {0} {1} {2} {3}", s1, s2, s3, s4), textStyle);
        
        
        GUILayout.EndArea();
    }

    
#endif

    private void OnDrawGizmos()
    {
        if (Camera != null)
        {
            Camera.OnDrawGizmos();
        }
    }
    
    private void UpdateSubModule()
    {
        foreach (var m in subModules)
        {
            m.OnUpdate(Time.deltaTime);
        }
    }
    
    public void FixedUpdate()
    {
        if (activePhysicObj.Count > 0)
        {
            Physics.Simulate(Time.fixedDeltaTime);
        }
    }

    // 格子坐标 -> 世界坐标
    public Vector3 TileToWorld(Vector2Int tilePos)
    {
        return TileCoord.TileToWorld(tilePos);
    }

    // 格子坐标 -> 世界坐标
    public Vector3 TileToWorld(int tilePosX, int tilePosY)
    {
        return TileCoord.TileToWorld(tilePosX, tilePosY);
    }

    // 世界坐标 -> 格子坐标
    public Vector2Int WorldToTile(Vector3 worldPos)
    {
        return TileCoord.WorldToTile(worldPos);
    }

    // 将 worldPos 对齐到格子中心的世界坐标
    public Vector3 SnapToTileCenter(Vector3 worldPos)
    {
        return TileCoord.SnapToTileCenter(worldPos);
    }

    // 浮点格子坐标 -> 世界坐标
    public Vector3 TileFloatToWorld(Vector2 tilePos)
    {
        return TileCoord.TileFloatToWorld(tilePos);
    }
    public Vector3 TileFloatToWorld(float x, float y)
    {
        return TileCoord.TileFloatToWorld(x, y);
    }

    // 世界坐标 -> 浮点格子坐标 
    public Vector2 WorldToTileFloat(Vector3 worldPos)
    {
        return TileCoord.WorldToTileFloat(worldPos);
    }

    public Vector2Int IndexToTilePos(int index)
    {
        return TileCoord.IndexToTilePos(index, TileCount);
    }

    public int TilePosToIndex(Vector2Int tilePos)
    {
        return TileCoord.TilePosToIndex(tilePos, TileCount);
    }

    public Vector3 TileIndexToWorld(int index)
    {
        return TileCoord.TileIndexToWorld(index, TileCount);
    }

    public int WorldToTileIndex(Vector3 pos)
    {
        return TileCoord.WorldToTileIndex(pos, TileCount);
    }

    public float TileDistance(Vector2Int a, Vector2Int b)
    {
        return TileCoord.TileDistance(a, b);
    }

    public void SetWorldSize(int size)
    {
        int halfSize = size / 2;
        CurTileCountXMin = Math.Max(0, (kTileCountX / 2) - (size /3));
        CurTileCountXMax = Math.Min(kTileCountX - 1, ((kTileCountX / 2) +(size /3) - 1));
        CurTileCountYMin = Math.Max(0, (kTileCountY / 2) - (3*size /4));
        CurTileCountYMax = Math.Min(kTileCountY - 1, ((kTileCountY / 2) + halfSize - 1));
    }

    public void SetRangeValue(int Xmin, int Ymin, int Xmax, int Ymax)
    {
        CurTileCountXMin = Math.Max(0, Xmin);
        CurTileCountYMin = Math.Max(0, Ymin);
        CurTileCountXMax = Math.Min(kTileCountX - 1, Xmax);
        CurTileCountYMax = Math.Min(kTileCountY - 1, Ymax);
    }
    
    public bool IsTileOccupyed(Vector2Int tilePos)
    {
        return false;
    }

    public int GetDesertPoint(int lv, int type)
    {
        return 0;
    }
    public Dictionary<long,WorldTileInfo> GetDesertPointList()
    {
        return new Dictionary<long, WorldTileInfo>();
    }
    public bool IsTileOccupyed(int index)
    {
        return false;
    }
    private void AfterCameraUpdate()
    {
        Camera.ClampToEdge();
        //UpdateCrossEdge();
    }
    
    public void ChangeServer(int serverId)
    {
        
    }
    public void OnChangeServerRemove()
    {
    }

    public void OnChangeServerTypeRefresh()
    {
        
    }
    
    public void RemoveBlackDesert()
    {
    }
    
    public void CreateDragonLandRange()
    {
        
    }

    public void RemoveDragonLandRange()
    {
        
    }

    public void InitBlackBlock()
    {
        
    }
    public Dictionary<string,BuildPointInfo> GetSelfAllianceList()
    {
        return new Dictionary<string, BuildPointInfo>();
    }
    
    public Dictionary<long, PointInfo> GetDragonPointDic()
    {
        return new Dictionary<long, PointInfo>();
    }

    public int GetIndexByOffset(int index, int x = 0, int y = 0)
    {
        var temp = GetIndexByOffsetX(index, x);
        if (temp > 0)
        {
            return GetIndexByOffsetY(temp, y);
        }

        return 0;
    }

    private int GetIndexByOffsetX(int index, int offset = 1)
    {
        int temp = index - 1;
        temp = temp % kTileCountX;

        temp += offset;
        if (temp >= 0 && temp < kTileCountX)
        {
            return index + offset;
        }

        return 0;
    }

    private int GetIndexByOffsetY(int index, int offset = 1)
    {
        int temp = index - 1;
        temp = temp / kTileCountX;

        temp += offset;
        if (temp >= 0 && temp < kTileCountX)
        {
            return index + kTileCountX * offset;
        }

        return 0;
    }

    public int GetIndexByOffsetByDirection(int index, int dir)
    {
        switch (dir)
        {
            case (int) DirectionType.Down:
                return GetIndexByOffset(index, 0, -1);
            case (int) DirectionType.Left:
                return GetIndexByOffset(index, -1, 0);
            case (int) DirectionType.Right:
                return GetIndexByOffset(index, 1, 0);
            case (int) DirectionType.Top:
                return GetIndexByOffset(index, 0, 1);
        }

        return 0;
    }


    public void OnPlayerBankruptcyFinish(string uid)
    {
       
    }
    
    public void OnExtendDome()
    {
     
    }
    
    public void ShowBattleBlood(object param, string path = WorldTroop.normalWordPath)
    {
        
    }
    public void RegisterPhysics(MonoBehaviour obj)
    {
        activePhysicObj.Add(obj);
    }
    public int GetBuildTileByItemId(int itemId)
    {
        return GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, itemId, "tiles").ToInt();
    }
    public void UnregisterPhysics(MonoBehaviour obj)
    {
        activePhysicObj.Remove(obj);
    }

    public Vector2Int GetTouchTilePos()
    {
        return WorldToTile(GetTouchPoint());
    }
    
    public Vector3 GetTouchPoint()
    {
        return Camera.GetRaycastGroundPoint(Input.mousePosition);
    }

    public Vector3 GetTouchPoint(Vector3 screenPos)
    {
        return Camera.GetRaycastGroundPoint(screenPos);
    }

    public Vector3 GetRaycastGroundPoint(Vector3 screenPos)
    {
        return Camera.GetRaycastGroundPoint(screenPos);
    }

    #region Camera

    public Vector3 CurTarget => Camera.CurTarget;

    public void AutoFocus(Vector3 lookat, LookAtFocusState state, float time, bool focusToCenter = true, bool lockView = false, Action onComplete = null)
    {
        Camera.AutoFocus(lookat, state, time, focusToCenter, lockView, onComplete);
    }

    public void QuitFocus(float time)
    {
        Camera.QuitFocus(time);
    }

    public float InitZoom
    {
        get => Camera.InitZoom;
        set => Camera.InitZoom = value;
    }

    public float Zoom
    {
        get => Camera.Zoom;
        set => Camera.Zoom = value;
    }
    
    public bool CanMoving
    {
        get => Camera.CanMoving;
        set => Camera.CanMoving = value;
    }

    public float GetLodDistance()
    {
        return Camera.GetLodDistance();
    }

    public Quaternion GetRotation()
    {
        return Camera.GetRotation();
    }

    public float GetMapIconScale()
    {
        return Camera.GetMapIconScale();
    }

    public Vector3 GetCameraPos()
    {
        return Camera.GetPosition();
    }

    public TouchInputController TouchInputController => Camera.TouchInputController;

    public Ray ScreenPointToRay(Vector3 pos)
    {
        return Camera.ScreenPointToRay(pos);
    }

    public float GetMinLodDistance()
    {
        return Camera.GetMinLodDistance();
    }

    public bool IsFocus => Camera.IsFocus;

    public Vector3 WorldToScreenPoint(Vector3 worldPos)
    {
        return Camera.WorldToScreenPoint(worldPos);
    }

    public void Lookat(Vector3 lookWorldPosition)
    {
        Camera.Lookat(lookWorldPosition);
    }

    public void AutoLookat(Vector3 lookat, float zoom = -1, float time = 0.2f, Action onComplete = null)
    {
        Camera.AutoLookat(lookat, zoom, time, onComplete);
    }

    public void AutoZoom(float zoom, float time = 0.2f, Action onComplete = null)
    {
        Camera.AutoZoom(zoom, time, onComplete);
    }

    public Vector2Int CurTilePos => Camera.CurTilePos;

    public Vector2Int CurTilePosClamped => Camera.CurTilePosClamped;

    public Vector3 ScreenPointToWorld(Vector3 worldPos, float disPlane = 0)
    {
        return Camera.ScreenPointToWorld(worldPos, disPlane);
    }

    public int GetLodLevel()
    {
        return Camera.GetLodLevel();
    }

    public void TrackMarch(long marchId)
    {
        
    }
    public void TrackMarchV2(Vector3 position, Transform transform = null)
    {
    }
    public void DisTrackMarch()
    {
    }

    public void DisablePostProcess()
    {
        Camera.DisablePostProcess();
    }

    public void EnablePostProcess()
    {
        Camera.EnablePostProcess();
    }

    public void SetTouchInputControllerEnable(bool able)
    {
        Camera.SetTouchInputControllerEnable(able);
        InputManager.SetTouchInputControllerEnable(able);
    }
    
    public void SetCameraTouchEnable(bool able)
    {
        Camera.SetTouchInputControllerEnable(able);
    }

    public bool GetTouchInputControllerEnable()
    {
        return InputManager.GetTouchInputControllerEnable();
    }

    public bool Enabled
    {
        get => Camera.Enabled;
        set => Camera.Enabled = value;
    }

    public event Action AfterUpdate
    {
        add => Camera.AfterUpdate += value;
        remove => Camera.AfterUpdate -= value;
    }

    public void StopCameraMove()
    {
        Camera.StopMove();
    }

    public int GetIndexByOffset_New(int index, int x = 0, int y = 0)
    {
        var temp = GetIndexByOffsetX(index, x);
        if (temp > 0)
        {
            return GetIndexByOffsetY(temp, y);
        }

        return 0;
    }

    public int GetIndexByOffsetByDirection_New(int index, int dir)
    {
        switch (dir)
        {
            case (int) DirectionType.Down:
                return GetIndexByOffset_New(index, 0, -1);
            case (int) DirectionType.Left:
                return GetIndexByOffset_New(index, -1, 0);
            case (int) DirectionType.Right:
                return GetIndexByOffset_New(index, 1, 0);
            case (int) DirectionType.Top:
                return GetIndexByOffset_New(index, 0, 1);
        }

        return 0;
    }
    
    public void SetZoomParams(int level, float y, float offsetZ, float sensitivity)
    {
        Camera.SetZoomParams(level, y, offsetZ, sensitivity);
    }

    public void SetCameraFOV(float fov)
    {
        Camera.SetFOV(fov);
    }

    public List<MobileTouchCamera.ZoomParam> GetZoomParams()
    {
        return Camera.GetZoomParams();
    }

    public float GetFOV()
    {
        return Camera.GetFOV();
    }
    
    
    #endregion

    public bool IsInMap(Vector2Int pt)
    {
        if (pt.x < CurTileCountXMin || pt.x > CurTileCountXMax || pt.y < CurTileCountYMin || pt.y > CurTileCountYMax)
        {
            return false;
        }

        return true;
    }

    public bool IsInMapByIndex(int index)
    {
        return IsInMap(IndexToTilePos(index));
    }
    public int GetZoneIdByPosId(int pointId)
    {
        return 0;
    }
    public void SetMapZoneActive(bool active)
    {
    }
    
    public string FindingPathForEden(int startIndex, int endIndex)
    {
        return "";
    }
    public int GetAreaIdByPosId(int pointId)
    {
        return 0;
    }
    public Vector2Int ClampTilePos(Vector2Int tilePos)
    {
        if (tilePos.x < 0)
            tilePos.x = 0;
        if (tilePos.x > kTileCountX - 1)
            tilePos.x = kTileCountX - 1;
        if (tilePos.y < 0)
            tilePos.y = 0;
        if (tilePos.y > kTileCountY - 1)
            tilePos.y = kTileCountY - 1;
        return tilePos;
    }
    
    public int GetCollectResourceBuildRange()
    {
        return 0;
    }
    
    public int GetCollectResourceTile()
    {
        return 0;
    }
    
    #region Profile
    public int GetGlobalShaderLOD()
    {
        return 1;
    }

    public bool SetGlobalShaderLOD(int level)
    {
        var changeSuccess = false;
        var lv = (GlobalShaderLod) level;
        if (lv == GlobalShaderLod.LOW)
        {
            Shader.globalMaximumLOD = 201;
            Debug.Log("切换low");
        }
        else if (lv == GlobalShaderLod.MIDDLE)
        {
            Shader.globalMaximumLOD = 401;
            Debug.Log("切换mid");
        }
        else if (lv == GlobalShaderLod.HIGH)
        {
            Shader.globalMaximumLOD = 601;
            Debug.Log("切换high");
        }

        return changeSuccess;
    }

    public bool GetProfileTerrainSwitch()
    {
        return false;
    }

    public void ProfileToggleTerrain()
    {
    }

    public bool GetProfileBuildingSwitch()
    {
        return false;
    }

    public void ProfileToggleBuilding()
    {
    }

    public bool GetProfileStaticSwitch()
    {
        return false;
    }

    public void ProfileToggleStatic()
    {
    }

    public bool GetHeightFogSwitch()
    {
        return false;
    }

    public void ProfileToggleHeightFog()
    {
    }

    public int frameBufferWidth
    {
        get { return Screen.width; }
    }

    public int frameBufferHeight
    {
        get { return Screen.height; }
    }

    #endregion

    #region 渲染控制台打开开关

    private InstanceRequest gfxConsoleRequest;

    public bool GetGraphySwitch()
    {
        return gfxConsoleRequest != null;
    }

    public void ProfileToggleMarch()
    {
        if (gfxConsoleRequest == null)
        {
            gfxConsoleRequest = GameEntry.Resource.InstantiateAsync(GameDefines.UIAssets.GFXConsole);
            gfxConsoleRequest.completed += delegate { Log.Debug("创建GFXConsole成功"); };
        }
        else
        {
            gfxConsoleRequest.Destroy();
            gfxConsoleRequest = null;
        }
    }

    #endregion
    
    #region tmp pointManager

    public ExplorePointInfo GetExplorePointInfoByIndex(int pointIndex)
    {
        return null;
    }

    public SamplePointInfo GetSamplePointInfoByIndex(int pointIndex)
    {
        return null;
    }

    public ResPointInfo GetResourcePointInfoByIndex(int pointIndex)
    {
        return null;
    }

    public bool IsCollectRangePoint(int pointIndex)
    {
        return false;
    }

    public PointInfo GetPointInfo(int pointIndex)
    {
        return null;
    }
    public WorldTileInfo GetWorldTileInfo(int pointIndex)
    {
        return null;
    }

    public int GetCollectPoint(int resourceType)
    {
        return 0;
    }

    public List<int> GetAllCollectRangePoint(int resourceType)
    {
        return null;
    }

    public List<int> GetAllCollectRangePointType(int resourceType, int mainIndex)
    {
        return null;
    }


    public bool IsCollectPoint(int pointIndex)
    {
        return false;
    }
    

    public GarbagePointInfo GetGarbagePointInfoByIndex(int pointIndex)
    {
        return null;
    }

    public PointInfo GetPointInfoByUuid(long uuid)
    {
        return null;
    }
    public WorldDesertInfo GetDesertInfoByUuid(long uuid)
    {
        return null;
    }

    public WorldPointObject GetObjectByPoint(int pointIndex)
    {
        return null;
    }
    

    public void ShowObject(int point)
    {
        if (ModelManager != null)
        {
            var obj = ModelManager.GetObjectByPointId(point);
            obj?.SetIsVisible(true);
        }
    }

    public CityBuilding GetBuildingByPoint(int pointIndex)
    {
        if (ModelManager != null)
        {
            var obj = ModelManager.GetObjectByPointId(pointIndex);
            if (obj != null)
            {
                var temp = obj as ModelManager.BuildObject;
                if (temp != null)
                {
                    return temp.cityBuilding;
                }
            }
        }
       
        return null;

    }
    
    public float GetBuildingHeight(int pointIndex)
    {
        var city = GetBuildingByPoint(pointIndex);
        if (city != null)
        {
            return city.GetHeight();
        }

        return 1;
    }

    public void HandleViewPointsReply(ISFSObject message)
    {
  
    }

    public void HandleViewUpdateNotify(ISFSObject message)
    {

    }
    public void HandleViewTileUpdateNotify(ISFSObject message)
    {
    }

    public void SendViewRequest(Vector2Int tilePos, int viewLevel, int serverId)
    {
        
    }
    

    public bool IsBuildFinish()
    {
        return isBuildComplete;
    }

    public WorldPointObject GetObjectByUuid(long uuid)
    {
        return null;
    }

    public CityBuilding GetBuildingByUuid(long uuid)
    {
        return null;
    }
    
    public WorldBuilding GetWorldBuildingByPoint(int pointIndex)
    {
        return null;
    }

    public WorldBuilding GetWorldBuildingByUuid(long uuid)
    {
        return null;
    }
    public bool HasPointInfo(int pointIndex)
    {
        return false;
    }

    public void AddToDeleteList(int index)
    {
        
    }

    public void HideObject(int point)
    {
        if (ModelManager != null)
        {
            var obj = ModelManager.GetObjectByPointId(point);
            obj?.SetIsVisible(false); 
        }
    }

    public bool IsSelfPoint(int pointIndex)
    {
        return false;
    }

    public int GetPointType(int index)
    {
        return GameEntry.Lua.CallWithReturn<int, int>("CSharpCallLuaInterface.GetCityPointType", index);
    }

    public bool IsSelfFreeBoard(int index)
    {
        return false;
    }

    public void AddObjectByPoint(int point, int type)
    {
        if (ModelManager != null)
        {
            ModelManager.LoadOneObject(point, type);
        }
    }
    
    public void RemoveObjectByPoint(int point)
    {
        if (ModelManager != null)
        {
            ModelManager.RemoveOneObject(point);
        }
    }

    public void RemoveOneObjectByPointType(int index, int pointType)
    {
        if (ModelManager != null)
        {
            ModelManager.RemoveOneObjectByPointType(index, pointType);
        }
    }
    public void RefreshView()
    {
        if (FakeCityModelManager != null)
        {
            FakeCityModelManager.UIDestroyBuilding();
        }

        if (ModelManager != null)
        {
            ModelManager.ClearReInitObject();
            ModelManager.ReInitObject();
        }
    }

    public void OnMainBuildMove()
    {
        
    }

    public void UpdateViewRequest(bool isForce = false)
    {
    }

    public List<int> GetGarbagePoint()
    {
        return null;
    }

    #endregion

    #region tmp MarchDataManager
    public WorldTroop CreateGroupTroop(WorldMarch march)
    {
        return null;
    }
    public WorldMarch GetMarch(long uuid)
    {
        return null;
    }
    
    public bool IsTargetForMine(WorldMarch marchData)
    {
        return false;
    }
    public int GetRallyMarchIndexByUuid(long uuid)
    {
        return -1;
    }

    public void StartMarch(int targetType, int targetPoint, long targetUuid, int timeIndex, long marchUuid =0,long formationUuid=0, int backHome = 1,byte[] sfsObjBinary=null,int startPos = 0,int targetServerId = -1)
    {

    }

    public WorldMarch GetOwnerFormationMarch(string ownerUid, long formationUuid, string allianceUid = "")
    {
        return null;
    }

    public WorldMarch GetAllianceMarchesInTeam(string allianceUid, long teamUuid)
    {
        return null;
    }

    public List<WorldMarch> GetOwnerMarches(string ownerUid, string allianceUid = "")
    {
        return null;
    }
    public Dictionary<long, WorldMarch> GetDragonMarch()
    {
        return null;
    }
    public void HandlePushWorldMarchAdd(ISFSObject message)
    {
      
    }

    public void HandlePushWorldMarchDel(ISFSObject message)
    {
        
    }

    public void HandleWorldMarchGet(ISFSObject message)
    {

    }

    public void HandleFormationMarch(ISFSObject message)
    {

    }

    public void HandleFormationMarchChange(ISFSObject message)
    {
        
    }

    public bool ExistMarch(long uuid)
    {
        return false;
    }

    public bool IsInRallyMarch(long uuid)
    {
        return false;
    }

    public bool IsInCollectMarch(long uuid)
    {
        return false;
    }

    public bool IsInAssistanceMarch(long uuid)
    {
        return false;
    }

    public bool IsSelfInCurrentMarchTeam(long rallyMarchUuid)
    {
        return false;
    }

    public Dictionary<long, WorldMarch> GetMarchesTargetForMine()
    {
        return new Dictionary<long, WorldMarch>();
    }

    public Dictionary<long, WorldMarch> GetMarchesBossInfo()
    {
        return new Dictionary<long, WorldMarch>();
    }

    #endregion


    #region tmp inputManager

    public int curIndex
    {
        get { return InputManager.curIndex; }
        set { InputManager.curIndex = value; }
    }
    
    public bool CanUseInput()
    {
        return InputManager.CanUseInput();
    }

    public void SetUseInput(bool canUse)
    {
        InputManager.SetUseInput(canUse);
    }

    public long marchUuid
    {
        get { return InputManager.marchUuid; }
        set { InputManager.marchUuid = value; }
    }

    public void SetSelectedPickable(ITouchPickable pickable)
    {
        InputManager.SetSelectedPickable(pickable);
    }

    public void ShowLoad(Vector3 pos)
    {
        InputManager.ShowLoad(pos);
    }

    public void SetDragFormationData(long uuid, int pointId)
    {
    }
    

    public List<int> touchPickablePos
    {
        get { return InputManager.touchPickablePos; }
        set { InputManager.touchPickablePos = value; }
    }

    public ITouchPickable SelectBuild
    {
        get { return InputManager.SelectBuild; }
        set { InputManager.SelectBuild = value; }
    }


    public int GetClickWorldBulidingPos()
    {
        return InputManager.GetClickWorldBulidingPos();
    }
    
    public void HideTouchEffect()
    {
        InputManager.HideTouchEffect();
    }

    public long GetRaycastHitMarch(Vector3 screenPos)
    {
        return InputManager.GetRaycastHitMarch(screenPos);
    }

    #endregion

    #region tmp static manager

    public bool IsTileWalkable(Vector2Int tilePos)
    {
        return StaticManager.IsTileWalkable(tilePos);
    }

    public void AddOccupyPoints(Vector2Int p, Vector2Int size)
    {
        //StaticManager.AddOccupyPoints(p, size);
    }

    public void RemoveOccupyPoints(Vector2Int p, Vector2Int size)
    {
        // StaticManager.RemoveOccupyPoints(p, size);
    }

    public void SetStaticVisibleChunk(int range)
    {
        StaticManager.SetVisibleChunk(range);
    }

    #endregion

    #region tmp troopManager

    public float GetModelHeight(long marchUuid)
    {
        return 0;
    }

    public WorldTroop GetTroop(long marchUuid)
    {
        return null;
    }

    public bool AddBullet(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType, long tUuid, float3 targetPos,bool isSelf)
    {
        return false;
    }
    public bool AddBulletV2(string prefabName, string hitPrefabName, Vector3 startPos, Quaternion rotation, int tType,
        int tileSize, Transform trans,bool isSelf)
    {
        return false;
    }
    public EnumDestinationSignalType GetDestinationType(long marchUuid, long targetMarchUuid,int endPos, MarchTargetType targetType,bool isFormation, ref Vector3 realPos, ref int tileSize)
    {
        switch (targetType)
        {
            case MarchTargetType.STATE:
                return EnumDestinationSignalType.EmptyGround;
            case MarchTargetType.PICK_GARBAGE:
                return EnumDestinationSignalType.My;
            case MarchTargetType.ATTACK_MONSTER:
                return EnumDestinationSignalType.EnemyMarch;
        }
        return EnumDestinationSignalType.None;
    }
    public MarchTargetType GetTargetType(long targetMarchUuid, int pointId)
    {
        return MarchTargetType.STATE;
    }

    public void CreateBattleVFX(string prefabPath, float life, Action<GameObject> onComplete)
    {
        
    }

    public void OnTroopDragUpdate(long marchUuid, Vector3 dragPosCurrent, long targetMarchUuid,int startPointId = 0,bool isFormation = false)
    {
        
    }

    public void OnTroopDragStop(long marchUuid, long targetMarchUuid,bool isFormation =false)
    {
        
    }

    public int GetPointSize(int index)
    {
        return GameEntry.Lua.CallWithReturn<int, int>("CSharpCallLuaInterface.GetCityPointSize", index);
    }

    public bool IsTroopCreate(long marchUuid)
    {
        return false;
    }

    public void CreateTroop(WorldMarch march)
    {
        
    }

    public void UpdateTroop(WorldMarch march)
    {
        
    }

    public void DestroyTroop(long marchUuid, bool isBattleFailed = false)
    {
        
    }
    
    public void CreateTroopLine(WorldMarch march)
    {
        
    }
    
    public void DestroyTroopLine(long marchUuid)
    {
        
    }
    
    public void UpdateTroopLine(WorldMarch march, WorldTroopPathSegment[] path, int currPath, Vector3 currPos,
        int realTargetPos = 0, bool needRefresh = false, bool clear = false)
    {
        
    }

    #endregion

    #region tmp path find

    public void GetTimeFromCurPosToTargetPos(int posStart, int targetPoint, int speed, long Uuid)
    {
        
    }

    public void FindPath(Vector2Int start, Vector2Int goal, Action<List<Vector2Int>> onComplete)
    {
        
    }

    #endregion

    #region Culling

    public void RemoveCullingBounds(WorldCulling.ICullingObject cullingObject)
    {
        
    }

    public void AddCullingBounds(WorldCulling.ICullingObject cullingObject)
    {
        
    }

    #endregion

    #region BattleManager

    public void BattleFinish(ISFSObject message)
    {
        
    }

    public void UpdateBattleMessage(ISFSObject message)
    {
     
    }

    #endregion

    #region FakeModelManager

    public void UICreateBuilding(int buildId, long buildUuid, int point, int buildTopType,
        LuaTable noBuildListStr = null)
    {
        FakeCityModelManager.UICreateBuilding(buildId, buildUuid, point, buildTopType, noBuildListStr);
    }
    public void UICreateAllianceBuilding(int buildId, long buildUuid, int point, int buildTopType,LuaTable noBuildListStr = null)
    {
    }
    public void UIChangeBuilding(int index)
    {
        FakeCityModelManager.UIChangeBuilding(index);
    }

    public void UIDestroyBuilding()
    {
        FakeCityModelManager.UIDestroyBuilding();
    }

    public void UIChangeAllianceBuilding(int index)
    {
        
    }

    public void UIDestroyAllianceBuilding()
    {
    }

    public FakeBuilding preCreateBuild
    {
        get { return FakeCityModelManager.preCreateBuild; }
        set { FakeCityModelManager.preCreateBuild = value; }
    }

    public Queue<FakeBuilding> placeFalseBuild
    {
        get { return FakeCityModelManager.placeFalseBuild; }
        set { FakeCityModelManager.placeFalseBuild = value; }
    }

    public void UIDestroyRreCreateBuild()
    {
        FakeCityModelManager.UIDestroyRreCreateBuild();
    }
    public void UIDestroyRreCreateAllianceBuild()
    {
    }
    public ModelManager.ModelObject AddObjectByPointId(int index, int type)
    {
        if (ModelManager != null)
        {
            return ModelManager.LoadOneObject(index, type);
        }

        return null;
    }

    public ModelManager.ModelObject GetObjectByPointId(int index)
    {
        if (ModelManager != null)
        {
            return ModelManager.GetObjectByPointId(index);
        }

        return null;
    }

    #endregion
    
    #region FogOfWar
    
    public void InitFogOfWar(BitArray fogData)
    {
    }
    public void ReInitFogOfWar()
    {
    }
    private void InitFogAlpha(BitArray fogData)
    {
    }
    public void UnlockFogOfWar(int fogIndex)
    {
    }
    public void UnlockFogOfWar2x2(int unlockIndex)
    {
    }
    public void SetFogVisible(bool visible)
    {
    }
    public void RegisterFogCompleteAction(Action callback)
    {
    }
    #endregion
    
    #region PointLight
    #endregion
    #region ModelManager
    public void ReInitObject()
    {
        if (ModelManager != null)
        {
            ModelManager.ReInitObject();
        }
    }

    public void ClearReInitObject()
    {
        if (ModelManager != null)
        {
            ModelManager.ClearReInitObject();
        }
    }

    public long GetFormationUuid()
    {
        if (ModelManager != null)
        {
              return ModelManager.GetFormationUuid(); 
        }

        return 0;
    }

    public Dictionary<string, LodConfig> GetLodConfigs(int lodType)
    {
        return LodManager.GetLodConfigs(lodType);
    }

    public void AddLodAdjuster(AutoAdjustLod adjuster)
    {
        LodManager.AddLodAdjuster(adjuster);
    }

    public void RemoveLodAdjuster(AutoAdjustLod adjuster)
    {
        LodManager.RemoveLodAdjuster(adjuster);
    }

    #endregion
    
    //设置世界点类型显示/隐藏
    public void SetVisibleByPointType(int pointType,bool isVisible)
    {
        if (ModelManager != null)
        {
            ModelManager.SetVisibleByPointType(pointType, isVisible);
        }
    }

    public Dictionary<int, int> GetSpecialPointDic()
    {
        return  new Dictionary<int, int>();
    }
    private void ToggleBorderCollider()
    {
        borderColliderVisible = !borderColliderVisible;

        var borderRootNode = dynamicObjNode.Find("BorderRoot");
        if (borderRootNode == null)
        {
            Debug.LogError("could not find BorderRoot!");
            return;
        }
        
        var meshRenderers = borderRootNode.GetComponentsInChildren<MeshRenderer>();
        foreach (var m in meshRenderers)
        {
            m.enabled = borderColliderVisible;
        }
    }

    private void ToggleGrid()
    {
        gridVisible = !gridVisible;

        if (cityGrid == null)
        {
            Debug.LogError("could not find Grid Node!");
            return;
        }

        cityGrid.gameObject.SetActive(gridVisible);
    }


    private bool cheatOpen = false;
    
    private void ToggleCheat()
    {
    }
    void ToggleFog()
    {
      
            var pipeline = QualitySettings.renderPipeline as UniversalRenderPipelineAsset;
            if (pipeline != null)
            {
                FieldInfo propertyInfo = pipeline.GetType().GetField("m_RendererDataList", BindingFlags.Instance | BindingFlags.NonPublic);
               var  _scriptableRendererData = ((ScriptableRendererData[])propertyInfo?.GetValue(pipeline))?[0];
            foreach (var feature in _scriptableRendererData.rendererFeatures)
            {
                if (feature.name.Equals("NewHeightFogRenderFeature"))
                {
                    feature.SetActive(false);
                }
            }

            _scriptableRendererData.SetDirty();
        }
      
    }
    private void DrawDebugPanel()
    {
        var ty = 80;
        if(GUI.Button(new Rect(20, ty, 120, 50), "Toggle Cheat"))
        {
            ToggleCheat();
        }

        if (GUI.Button(new Rect(300, ty, 120, 50), "ToggleFog"))
        {
            ToggleFog();
        }
        if (GUI.Button(new Rect(500, ty, 120, 50), "ToggleCollider"))
        {
            GameObject ColliderRoot = GameObject.Find("ColliderRoot");
            Destroy(ColliderRoot);
        }
        if (gridVisible)
        {
            var worldPos = GetTouchPoint();
            var tilePos = WorldToTile(worldPos) + new Vector2Int(-49, -49);
            GUI.skin.label.fontSize = 22;
            GUI.Label(new Rect(20, Screen.height-120, 400, 50), "World Pos: " + worldPos);
            GUI.Label(new Rect(20, Screen.height- 60, 400, 50), "Tile Pos: " + tilePos);
        }
    }

    private bool consoleVisible = false;
    private bool borderColliderVisible = false;
    private bool gridVisible = false;

#if UNITY_EDITOR
    private void OnGUI()
    {
        // if(GUI.Button(new Rect(20, 20, 120, 50), "Toggle Console"))
        // {
        //     consoleVisible = !consoleVisible;
        // }
        //
        // if (consoleVisible)
        // {
        //     DrawDebugPanel();
        // }
    }
#endif
    private void InitFogParam(float height, float posY, Color color)
    {
        var pipeline = QualitySettings.renderPipeline as UniversalRenderPipelineAsset;
        if (pipeline != null)
        {
            FieldInfo propertyInfo = pipeline.GetType().GetField("m_RendererDataList", BindingFlags.Instance | BindingFlags.NonPublic);
            var _scriptableRendererData = ((ScriptableRendererData[])propertyInfo?.GetValue(pipeline))?[0];
            foreach (var feature in _scriptableRendererData.rendererFeatures)
            {
                if (feature is HeightFogRenderFeature)
                {
                    var fogFeature = feature as HeightFogRenderFeature;
                    fogFeature.fogSetting._FogDisappearHeight = height;
                    fogFeature.fogSetting._FogPosY = posY;
                    fogFeature.fogSetting.unexploredColor = color;

                }
            }

            _scriptableRendererData.SetDirty();
        }
    }
    
    public void SetCameraMaxHeight(int height)
    {
        Camera.ZoomMax = height;
    }
    
    public float GetCameraMaxHeight()
    {
        return Camera.ZoomMax;
    }

    
    public void SetCameraMinHeight(int height)
    {
        Camera.ZoomMin = height;
    }
    
    public float GetCameraMinHeight()
    {
        return Camera.ZoomMin;
    }

    public void ResetCameraMaxHeight()
    {
    }
    
    public void ResetCameraMinHeight()
    {
    }
    
    public float GetPreviousLodDistance()
    {
        return prevLodDist;
    }
    
    public void DrawBuildGrid(Mesh mesh, int submeshIndex, Material material, Matrix4x4[] matrices, int count)
    {
        Graphics.DrawMeshInstanced(mesh, submeshIndex, material, matrices, count);
    }

    public void AddAutoFace(AutoFaceToCamera autoFace)
    {
        AutoMonoManager.AddAutoFace(autoFace);
    }

    public void RemoveAutoFace(AutoFaceToCamera autoFace)
    {
        AutoMonoManager.RemoveAutoFace(autoFace);
    }

    public void AddAutoScale(AutoAdjustScale autoScale)
    {
        AutoMonoManager.AddAutoScale(autoScale);
    }

    public void RemoveAutoScale(AutoAdjustScale autoScale)
    {
        AutoMonoManager.RemoveAutoScale(autoScale);
    }

    public GameObject GetTerrainGameObject()
    {
        return sceneInst?.gameObject;
    }

    public void SetUSkyLightingPointDistanceFalloff(float val)
    {
        CityLightManager.SetUSkyLightingPointDistanceFalloff(val);
    }

    public float GetUSkyLightingPointDistanceFalloff()
    {
        return CityLightManager.GetUSkyLightingPointDistanceFalloff();
    }
    
    public void SetUSkyActive(bool active)
    {
        CityLightManager.SetUSkyActive(active);
    }
}