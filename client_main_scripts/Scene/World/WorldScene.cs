using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using BitBenderGames;
using GameFramework;
using Protobuf;
using Sfs2X.Entities.Data;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using XLua;
using Unity.Jobs;
using Unity.Collections;
//
// 世界场景，负责：
//   建立坐标系统
//   管理世界子模块
//   世界切换、跨边界切服
//
public class WorldScene : MonoBehaviour, SceneInterface
{
    // 整个世界的格子大小
    private const int kTileCountX = 1000;
    private const int kTileCountY = 1000;

    // 整个世界划分成N个区域，每个区域的格子数
    private const int kBlockSize = 1000;

    // 世界横向、纵向区域数量
    private static readonly Vector2Int kBlockCount = new Vector2Int(kTileCountX / kBlockSize, kTileCountY / kBlockSize);

    public static Dictionary<int, Dictionary<int, string>> ModelPathDic = new Dictionary<int, Dictionary<int, string>>();

    public static long selectMarchUuid = 0;
    public Vector2Int BlockCount => kBlockCount;
    public int BlockSize => kBlockSize;
    public float TileSize => TileCoord.TileSize;
    public Vector2Int TileCount { get; private set; }
    
    private InstanceRequest sceneInst;

    private HashSet<MonoBehaviour> activePhysicObj = new HashSet<MonoBehaviour>();
    private Transform dynamicObjNode;

    public Transform DynamicObjNode
    {
        get { return dynamicObjNode; }
    }

    private Transform buildBubbleNode;

    public Transform BuildBubbleNode
    {
        get { return buildBubbleNode; }
    }

    private GameObject gameObject;
    public Transform Transform => gameObject.transform;

    public int CurTileCountXMin { get; private set; }
    public int CurTileCountXMax { get; private set; }
    public int CurTileCountYMin { get; private set; }
    public int CurTileCountYMax { get; private set; }

    public int WorldSize { get; private set; }

    private float _saveCameraHeight = 0;
    private float _saveCameraMinHeight = 0;
    public FakeModelManager FakeModelManager { get; private set; }

    private List<WorldManagerBase> subModules = new List<WorldManagerBase>();

    public WorldCamera Camera { get; private set; }
    private WorldCulling Culling { get; set; }
    private WorldInputManager InputManager { get; set; }
    private WorldStaticManager StaticManager { get; set; }
    private WorldPathfinding Pathfinding { get; set; }
    #if false
    private WorldTroopManager TroopManager { get; set; }
    private WorldPointManager PointManager { get; set; }
    private WorldTroopLineManager TroopLineManager { get; set; }
    private WorldMarchDataManager MarchDataManager { get; set; }
#endif
    private WorldMapZoneManager WorldMapZoneManager { get; set; }
    
    private WorldEdenAreaManager WorldEdenAreaManager { get; set; }
    private WorldLodManager LodManager;
    private WorldAutoMonoManager AutoMonoManager { get; set; }

    public float BlackLandSpeed { get; private set; }

    public void Init(GameObject go)
    {
        ModelPathDic.Clear();
        gameObject = go;
        gameObject.SetActive(true);
        CurTileCountXMin = 0;
        CurTileCountXMax = kTileCountX;
        CurTileCountYMin = 0;
        CurTileCountYMax = kTileCountY;
        TileCount = new Vector2Int(kTileCountX, kTileCountY);
        BlackLandSpeed = 1;
        var path = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            path = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_Eden_World_High
                : GameDefines.EntityAssets.Terrain_Eden_World_Low;
        }
        else
        {
            path = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_World0_High
                : GameDefines.EntityAssets.Terrain_World0_Low;
        }
        GameEntry.Resource.PreloadAsset(path, typeof(GameObject));
        if (!SDKManager.IS_UNITY_PC())
        {
            QualitySettings.SetQualityLevel(0);
        }
        else
        {
            QualitySettings.SetQualityLevel(3);
        }

        SetFogVisible(false);
    }

    public void CreateScene(Action callback = null)
    {
        //获取大本数据
        GameEntry.Lua.Call("CSharpCallLuaInterface.SetIsInCity", false);
        // GameEntry.Lua.Call("CSharpCallLuaInterface.SetMainPos");
        GameEntry.Data.Building.SetMainPos();
        GameEntry.Lua.Call("CSharpCallLuaInterface.WorldMarchGetReq");
        gameObject.transform.localScale = new Vector3(1, 1, 1);
        BlackLandSpeed = GameEntry.Lua.CallWithReturn<float>("CSharpCallLuaInterface.GetBlackDesertDecSpeed");
        
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

        if (subModules.Count == 0)
        {
            Camera = AddSubModule<WorldCamera>();
            InputManager = AddSubModule<WorldInputManager>();
            StaticManager = AddSubModule<WorldStaticManager>();
            Pathfinding = AddSubModule<WorldPathfinding>();
            #if false
            MarchDataManager = AddSubModule<WorldMarchDataManager>();
            PointManager = AddSubModule<WorldPointManager>();
            TroopManager = AddSubModule<WorldTroopManager>();
            TroopLineManager = AddSubModule<WorldTroopLineManager>();
           #endif
            Culling = AddSubModule<WorldCulling>();
            FakeModelManager = AddSubModule<FakeModelManager>();
            LodManager = AddSubModule<WorldLodManager>();
            AutoMonoManager = AddSubModule<WorldAutoMonoManager>();
            WorldMapZoneManager = AddSubModule<WorldMapZoneManager>();
            WorldEdenAreaManager = AddSubModule<WorldEdenAreaManager>();
            
            foreach (var m in subModules)
            {
                m.Init();
            }
            if (XLuaManager.IsUseLuaWorldPoint == true)
            {
                GameEntry.Lua.Call("CSharpCallLuaInterface.StartUpWorldPoint");
                GameEntry.Lua.Call("CSharpCallLuaInterface.StartMarchInit");
            }
            StaticManager.LoadTerrainAssets(() =>
            {
                if (sceneInst == null)
                {
                    sceneInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.World);
                    sceneInst.completed += delegate
                    {
                        Log.Info("CreateScene sceneInst complete 1");
                        sceneInst.gameObject.transform.SetParent(gameObject.transform);
                        SetPostProcessQuality();
                        Camera.SetTouchInputControllerEnable(true);
                        Camera.AfterUpdate += AfterCameraUpdate;
                        Camera.MarkLodChanged();
                        if (GameEntry.GlobalData.serverType != (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
                        {
                            if (GameEntry.GlobalData.serverType == (int)ServerType.CROSS_THRONE)
                            {
                                SetCameraMaxHeight(115);
                                SetWorldSize(300);
                            }
                            else
                            {
                                ResetCameraMaxHeight();
                                SetWorldSize(1000);
                            }
                            Camera.Lookat(TileIndexToWorld(GameEntry.Data.Building.GetWorldMainPos()));
                            //检测是否收起状态
                            GameEntry.Lua.Call("CSharpCallLuaInterface.CheckReplaceMain");
                        }
                        else
                        {
                            GameEntry.Lua.Call("CSharpCallLuaInterface.OnGotoSpecialWorld");
                        }
                        #if false
                        PointManager.StartViewRequest();
                        #endif
                        if (XLuaManager.IsUseLuaWorldPoint == false)
                        {
                            
                        }
                        else
                        {
                            GameEntry.Lua.Call("CSharpCallLuaInterface.StartViewRequest");
                        }    
                        
                        
                        callback?.Invoke();
                        Log.Info("CreateScene sceneInst complete 2");
                    };
                }
                else
                {
                    Log.Info("CreateScene sceneInst == null");
                }
            });
        }
        else
        {
#if false
            if (MarchDataManager != null)
            {
                MarchDataManager.OnResetData();
            }
#endif
            UpdateViewRequest(true);
            if (XLuaManager.IsUseLuaWorldPoint == false)
            {
                
            }
            else
            {
                GameEntry.Lua.Call("CSharpCallLuaInterface.StartViewRequest");
            }
        }
    }

    public void Uninit()
    {
        if (Camera != null)
        {
            Camera.AfterUpdate -= AfterCameraUpdate;
        }

        ModelPathDic.Clear();
        if (XLuaManager.IsUseLuaWorldPoint == true)
        {
            GameEntry.Lua.Call("CSharpCallLuaInterface.CloseMarch");
            GameEntry.Lua.Call("CSharpCallLuaInterface.CloseWorldPoint");
        }
        foreach (var m in subModules)
        {
            m.UnInit();
        }

        subModules.Clear();
        if (transList != null)
        {
            for (int i = 0; i < transList.Count; i++)
            {
                transList[i].Destroy();
            }
            transList.Clear();
        }
        if (hitInstList != null)
        {
            foreach (var VARIABLE in hitInstList)
            {
                if (VARIABLE != null)
                {
                    VARIABLE.Destroy();
                }
            }
            hitInstList.Clear();
        }
        
        if (sceneInst != null)
        {
            sceneInst.Destroy();
            sceneInst = null;
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
    }

    private T AddSubModule<T>() where T : WorldManagerBase
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
       // [typeof(Vignette)] = GameDefines.QualitySetting.PostProcess_Vignette,
        [typeof(LiftGammaGain)] = GameDefines.QualitySetting.PostProcess_LiftGammaGain,
        [typeof(DepthOfField)] = GameDefines.QualitySetting.PostProcess_DepthOfField,
    };
    
    private void SetPostProcessQuality()
    {

        if (sceneInst == null || sceneInst.gameObject == null)
            return;
        
         Volume ppVolume = sceneInst.gameObject.GetComponentInChildren<Volume>(true);
        if (ppVolume == null || ppVolume.profile == null)
            return;
        
        // ppVolume.enabled = true;
        //
        // bool isAnyActive = false;
        // var list = new List<VolumeComponent>();
        // ppVolume.profile.TryGetAllSubclassOf(typeof(VolumeComponent), list);
        // foreach (var com in list)
        // {
        //     if (PostprocessSettingKeys.TryGetValue(com.GetType(), out var settingKey))
        //     {
        //         var lv = GameEntry.Setting.GetInt(settingKey, GameDefines.QualityLevel_Off);
        //         if (lv == GameDefines.QualityLevel_Off)
        //         {
        //             com.active = false;
        //         }
        //         else
        //         {
        //             com.active = true;
        //             isAnyActive = true;
        //         }
        //     }
        // }
        //
        // if (isAnyActive)
        // {
        //     Camera.EnablePostProcess();
        // }
        // else
        // {
            Camera.DisablePostProcess();
            ppVolume.enabled = false;
        // }
    }

    public void ChangeQualitySetting()
    {
        SetPostProcessQuality();
        
        if (StaticManager != null)
        {
            StaticManager.ChangeTerrain();
        }
    }

    public void Update()
    {
        UpdateSubModule();
    }

    private void OnDrawGizmos()
    {
        if (Camera != null)
        {
            Camera.OnDrawGizmos();
        }
#if false
        if (MarchDataManager != null)
        {
            MarchDataManager.OnDrawGizmos();
        }
#endif
    }

    private void UpdateSubModule()
    {
        var time = DateTime.Now.TimeOfDay.TotalMilliseconds;
        foreach (var m in subModules)
        {
            try
            {
                m.OnUpdate(Time.deltaTime);
            }
            catch (Exception e)
            {
                Debug.LogError(e);
            }
        }
        UpdateBullet(time);
        var useTime = DateTime.Now.TimeOfDay.TotalMilliseconds - time;
        if (useTime > 15)
        {
            Log.Debug("[scene] process long  use {0}", useTime);
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
        if (WorldSize != size)
        {
            WorldSize = size;
            int halfSize = size / 2;
            CurTileCountXMin = Math.Max(0, (kTileCountX / 2) - halfSize);
            CurTileCountXMax = Math.Min(kTileCountX - 1, ((kTileCountX / 2) + halfSize - 1));
            CurTileCountYMin = Math.Max(0, (kTileCountY / 2) - halfSize);
            CurTileCountYMax = Math.Min(kTileCountY - 1, ((kTileCountY / 2) + halfSize - 1));
        }
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
        // var index = TilePosToIndex(tilePos);
        // return !StaticManager.IsTileWalkable(tilePos)
        //        || PointManager.HasPointInfo(index);
        return false;
    }

    public int GetDesertPoint(int lv, int type)
    {
        return 0;//PointManager.GetDesertPoint(lv, type);
    }

    public Dictionary<long,WorldTileInfo> GetDesertPointList()
    {
        return null;//PointManager.GetDesertPointList();
    }
    public bool IsTileOccupyed(int index)
    {
        // var tilePos = IndexToTilePos(index);
        // return !StaticManager.IsTileWalkable(tilePos)
        //        || PointManager.HasPointInfo(index);
        return false;
    }

    private void AfterCameraUpdate()
    {
        Camera.ClampToEdge();
        //UpdateCrossEdge();
    }

    // 设置到观战网络
    // private void SetViewNet()
    // {
    //     // if (!GameEntry.DataConfig.CheckSwitch("live_between_state"))
    //     // {
    //     //     return;
    //     // }
    //
    //     if (GameEntry.Data.Player.IsInSelfServer())
    //     {
    //         if (GameEntry.NetworkCross.IsConnected())
    //         {
    //             WorldLeaveCrossServerMessage.Instance.Send();
    //         }
    //
    //         GameEntry.NetworkCross.Logined = false;
    //         GameEntry.NetworkCross.Disconnect();
    //         GameEntry.NetworkCross.ClearRequestQueue();
    //     }
    //     else
    //     {
    //         int curServer = GameEntry.Data.Player.GetSelfServerId();
    //         if (curServer <= 0)
    //         {
    //             return;
    //         }
    //
    //         // 清空数据
    //         GameEntry.NetworkCross.Disconnect();
    //         GameEntry.NetworkCross.ClearRequestQueue();
    //
    //         string tempBuf = string.Format("cr_{0}", GameEntry.Data.Player.Uid);
    //         GameEntry.Setting.SetString("na_uid", tempBuf);
    //
    //         tempBuf = string.Format("{0}", curServer);
    //         GameEntry.Setting.SetString("na_sid", tempBuf);
    //
    //         tempBuf = string.Format("{0}", 1);
    //         GameEntry.Setting.SetString("na_loginType", tempBuf);
    //
    //         tempBuf = string.Format("APS{0}", curServer);
    //         GameEntry.NetworkCross.Zone = tempBuf;
    //         GameEntry.NetworkCross.Port = CrossServerComponent.SERVER_PORT;
    //         GameEntry.NetworkCross.InitConnectionList();
    //
    //         LoginCrossServerMessage logincross = new LoginCrossServerMessage();
    //         logincross.SendRequest();
    //     }
    // }

    public void ChangeServer(int serverId)
    {
        // GameEntry.Data.Player.GetSelfServerId() = serverId;
        //GetServerType(serverId);

        //SetViewNet();
    }

    public void OnChangeServerRemove()
    {
        //PointManager.RemoveAllObject();
    }

    public void OnChangeServerTypeRefresh()
    {
        StaticManager.OnRemoveObject();
        StaticManager.OnInitObject();
        StaticManager.LoadTerrainAssets(null);
        WorldMapZoneManager.OnRemoveObject();
        WorldMapZoneManager.OnInitObject();
    }

    public void RemoveBlackDesert()
    {
        StaticManager.RemoveBlackDesert();
    }
    public void CreateDragonLandRange()
    {
        StaticManager.CreateDragonLandRange();
    }

    public void RemoveDragonLandRange()
    {
        StaticManager.RemoveDragonLandRange();
    }

    public void InitBlackBlock()
    {
        StaticManager.InitBlackBlock();
    }
    // 跨过边界时切服
    private void UpdateCrossEdge()
    {
        var lookAtPos = Camera.CurTarget;
        var lookAtTilePos = WorldToTileFloat(lookAtPos);

        int serverId = GetCameraLookAtServerId(lookAtTilePos);
        if (serverId == GameEntry.Data.Player.GetSelfServerId())
            return;
        //
        // ServerListInfo serverInfo = null;
        // if (serverId != -1)
        // {
        //     serverInfo = AllWorldsController.Instance.GetServerListInfo(serverId);
        // }
        // if (serverInfo == null)
        // {
        //     //Camera.ClampToEdge();
        //     return;
        // }

        // 切服
        ChangeServer(serverId);

        // 跨边界时，平移相机、地形以循环显示
        // Vector2 tileOffset = new Vector2();
        // if (lookAtTilePos.x < 0)
        //     tileOffset.x = (TileCountX + EdgeTileCount);
        // if (lookAtTilePos.x >= TileCountX + EdgeTileCount)
        //     tileOffset.x = -(TileCountX + EdgeTileCount);
        // if (lookAtTilePos.y < 0)
        //     tileOffset.y = (TileCountY + EdgeTileCount);
        // if (lookAtTilePos.y >= TileCountY + EdgeTileCount)
        //     tileOffset.y = -(TileCountY + EdgeTileCount);

        //var newLookAtPos = TileFloatToWorld(WorldToTileFloat(lookAtPos) + tileOffset);
        //Camera.Lookat(newLookAtPos);

        // server name tip
        // UIFlyBigTip.FlyText(serverInfo.serverName);
    }

    private int GetCameraLookAtServerId(Vector2 lookAtTilePos)
    {
        // var allWorlds = AllWorldsController.Instance;
        //
        var curServerId = GameEntry.Data.Player.GetSelfServerId();
        // Vector2Int curServerPos = allWorlds.GetServerPosById(curServerId);
        // Vector2Int serverPos = curServerPos;

        // if (lookAtTilePos.x < TileEdgeRect.xMin)
        // {
        //     serverPos.y = curServerPos.y + 1;
        // }
        // else if (lookAtTilePos.x >= TileEdgeRect.xMax)
        // {
        //     serverPos.y = curServerPos.y - 1;
        // }
        //
        // if (lookAtTilePos.y < TileEdgeRect.yMin)
        // {
        //     serverPos.x = curServerPos.x + 1;
        // }
        // else if (lookAtTilePos.y >= TileEdgeRect.yMax)
        // {
        //     serverPos.x = curServerPos.x - 1;
        // }

        // if (serverPos == curServerPos)
        return curServerId;
        //
        // return allWorlds.GetServerIdByServerPoint(serverPos);
    }


    public void RegisterPhysics(MonoBehaviour obj)
    {
        activePhysicObj.Add(obj);
    }

    public void UnregisterPhysics(MonoBehaviour obj)
    {
        activePhysicObj.Remove(obj);
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
        // if (uid == GameEntry.Data.Player.Uid)
        // {
        //
        // }
        //
        // PointManager.DeleteAllObjOfPlayer(uid); //删建筑表现
        // MarchDataManager.RemoveOwnerMarches(uid);
    }

    public void ShowBattleBlood(object param, string path = WorldTroop.normalWordPath)
    {
        if (param != null)
        {
            if (param is BattleDecBloodTip.Param p)
            {
                var posV3 = p.startPos;
                float screenX = Screen.width;
                float screenY = Screen.height;
                var pos = SceneManager.World.WorldToScreenPoint(posV3);
                if (pos.x > 0 && pos.x < screenX && pos.y > 0 && pos.y < screenY)
                {
                    var temp = GameEntry.Resource.InstantiateAsync(path);
                    temp.completed += delegate
                    {
                        var go = temp.gameObject;
                        go.transform.SetParent(dynamicObjNode);
                        var battleDecBloodTip = go.GetComponent<BattleDecBloodTip>();
                        battleDecBloodTip.CSShow(param, temp);
                    };
                }
            }
        }
        
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

    public float InitZoom => Camera.InitZoom;
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
        ;
    }

    public Quaternion GetRotation()
    {
        return Camera.GetRotation();
    }

    public float GetPreviousLodDistance()
    {
        return Camera.GetPreviousLodDistance();
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

    public void AutoLookat(Vector3 lookat, float zoom = -1, float time = 0.2f, Action onComplete = null)
    {
        Camera.AutoLookat(lookat, zoom, time, onComplete);
    }

    public void AutoZoom(float zoom, float time = 0.2f, Action onComplete = null)
    {
        Camera.AutoZoom(zoom, time, onComplete);
    }

    public void Lookat(Vector3 lookWorldPosition)
    {
        Camera.Lookat(lookWorldPosition);
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
        Camera.TrackMarch(marchId);
    }

    public void TrackMarchV2(Vector3 position, Transform transform = null)
    {
        Camera.TrackMarchV2(position,transform);
    }
    public void DisTrackMarch()
    {
        Camera.DisTrackMarch();
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
    }

    public bool GetTouchInputControllerEnable()
    {
        return Camera.GetTouchInputControllerEnable();
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
        return StaticManager.GetProfileTerrainSwitch();
    }

    public void ProfileToggleTerrain()
    {
        StaticManager.ProfileToggleTerrain();
    }

    public void ProfileToggleGlass()
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
        get { return Camera.frameBufferWidth; }
    }

    public int frameBufferHeight
    {
        get { return Camera.frameBufferHeight; }
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
        return null;//PointManager.GetExplorePointInfoByIndex(pointIndex);
    }

    public SamplePointInfo GetSamplePointInfoByIndex(int pointIndex)
    {
        return null;//PointManager.GetSamplePointInfoByIndex(pointIndex);
    }

    public ResPointInfo GetResourcePointInfoByIndex(int pointIndex)
    {
        return null;//PointManager.GetResourcePointInfoByIndex(pointIndex);
    }

    public bool IsCollectRangePoint(int pointIndex)
    {
        return false;
    }

    public PointInfo GetPointInfo(int pointIndex)
    {
        return null;//PointManager?.GetPointInfo(pointIndex);
    }

    public WorldTileInfo GetWorldTileInfo(int pointIndex)
    {
        return null;//PointManager?.GetWorldTileInfo(pointIndex);
    }
    public int GetBuildTileByItemId(int itemId)
    {
        // if (PointManager != null)
        // {
        //     return PointManager.GetBuildTileByItemId(itemId);
        // }

        return 0;
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
        return null;//PointManager?.GetGarbagePointInfoByIndex(pointIndex);
    }

    public PointInfo GetPointInfoByUuid(long uuid)
    {
        return null;//PointManager?.GetPointInfoByUuid(uuid);
    }

    public WorldDesertInfo GetDesertInfoByUuid(long uuid)
    {
        return null;//PointManager?.GetDesertInfoByUuid(uuid);
    }
    public WorldPointObject GetObjectByPoint(int pointIndex)
    {
        return null;//PointManager?.GetObjectByPoint(pointIndex);
    }
    
    

    public Dictionary<string,BuildPointInfo> GetSelfAllianceList()
    {
        return null;//PointManager?.GetSelfAllianceList();
    }
    public Dictionary<long, PointInfo> GetDragonPointDic()
    {
        return null;//PointManager?.GetDragonPointDic();
    }
    public void ShowObject(int point)
    {
    }

    public CityBuilding GetBuildingByPoint(int pointIndex)
    {
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
        //PointManager.HandleViewPointsReply(message);
    }

    public void HandleViewUpdateNotify(ISFSObject message)
    {
        //PointManager.HandleViewUpdateNotify(message);
    }

    public void HandleViewTileUpdateNotify(ISFSObject message)
    {
       // PointManager.HandleViewTileUpdateNotify(message);
    }

    public void SendViewRequest(Vector2Int tilePos, int viewLevel, int serverId)
    {
        //PointManager.SendViewRequest(tilePos, PointManager.GetServerLod(viewLevel), serverId);
    }

    public void UpdateViewRequest(bool isForce = false)
    {
        if (XLuaManager.IsUseLuaWorldPoint == false)
        {
            // if (PointManager != null)
            // {
            //     PointManager.UpdateViewRequest(true);
            // }
        }
        else
        {
            GameEntry.Lua.Call("CSharpCallLuaInterface.ForceRequestPoint");
        }
    }

    public bool IsBuildFinish()
    {
        return sceneInst != null && sceneInst.isDone;
    }

    public WorldPointObject GetObjectByUuid(long uuid)
    {
        return null;//PointManager?.GetObjectByUuid(uuid);
    }

    public CityBuilding GetBuildingByUuid(long uuid)
    {
        return null;
    }
    public WorldBuilding GetWorldBuildingByPoint(int pointIndex)
    {
        return null;//PointManager?.GetWorldBuildingByPoint(pointIndex);
    }

    public WorldBuilding GetWorldBuildingByUuid(long uuid)
    {
        return null;//PointManager?.GetWorldBuildingByUuid(uuid);
    }
    public bool HasPointInfo(int pointIndex)
    {
        // if (PointManager != null)
        // {
        //     return PointManager.HasPointInfo(pointIndex);
        // }

        return false;
    }

    public void AddToDeleteList(int index)
    {
        //PointManager?.AddToDeleteList(index);
    }
    
    public void HideObject(int point)
    {
    }

    public bool IsSelfPoint(int pointIndex)
    {
        // if (PointManager != null)
        // {
        //     return PointManager.IsSelfPoint(pointIndex);
        // }

        return false;
    }

    public int GetPointType(int index)
    {
        //return cityScene.CityPointManager.GetPointType(index);

        // var info = PointManager?.GetPointInfo(index);
        // if (info != null)
        // {
        //     return info.PointType;
        // }

        return (int) WorldPointType.Other;
    }

    public void RemoveObjectByPoint(int point)
    {
        //PointManager?.DestroyObject(point);
    }

    public void RemoveOneObjectByPointType(int index, int pointType)
    {
    }
    public void RefreshView()
    {
        FakeModelManager.UIDestroyBuilding();
        FakeModelManager.UIDestroyAllianceBuilding();
        // if (MarchDataManager != null)
        // {
        //     MarchDataManager.OnResetData();
        // }
        SendViewRequest(GameEntry.Data.Building.GetMainPos(),
            SceneManager.World.GetLodLevel(), GameEntry.Data.Player.GetSelfServerId());
    }
    
    public void OnMainBuildMove()
    {
        
    }

    public List<int> GetGarbagePoint()
    {
        return null;//PointManager?.GetGarbagePoint();
    }


    #endregion

    #region tmp MarchDataManager
    public WorldTroop CreateGroupTroop(WorldMarch march)
    {
        return null;//TroopManager?.CreateGroupTroop(march);
    }
    public WorldMarch GetMarch(long uuid)
    {
        return null;//MarchDataManager?.GetMarch(uuid);
    }

    public Dictionary<long, WorldMarch> GetAllSampleFakeData()
    {
        return null;//MarchDataManager.GetAllSampleFakeData();
    }
    public void RemoveFakeSampleMarchData(long index)
    {
        //MarchDataManager.RemoveFakeSampleMarchData(index);
    }

    public int GetRallyMarchIndexByUuid(long uuid)
    {
        return 0;//MarchDataManager.GetRallyMarchIndexByUuid(uuid);
    }
    public void UpdateFakeSampleMarchDataWhenBack(long index, long startTime, long endTime)
    {
        //MarchDataManager.UpdateFakeSampleMarchDataWhenBack(index, startTime, endTime);
    }

    public void UpdateFakeSampleMarchDataWhenStartPick(long index, long endTime)
    {
        //MarchDataManager.UpdateFakeSampleMarchDataWhenStartPick(index, endTime);
    }

    public void AddFakeSampleMarchData(long startIndex, long endIndex, long startTime, long endTime)
    {
        //MarchDataManager.AddFakeSampleMarchData(startIndex, endIndex, startTime, endTime);
    }

    public void StartMarch(int targetType, int targetPoint, long targetUuid, int timeIndex, long marchUuid =0,long formationUuid=0, int backHome = 1,byte[] sfsObjBinary=null,int startPos = 0,int targetServerId = -1)
    {
        // MarchDataManager.StartMarch(targetType, targetPoint, targetUuid, timeIndex, marchUuid, formationUuid,
        //     backHome, sfsObjBinary,startPos,targetServerId);
    }

    public WorldMarch GetOwnerFormationMarch(string ownerUid, long formationUuid, string allianceUid = "")
    {
        return null;//MarchDataManager.GetOwnerFormationMarch(ownerUid, formationUuid, allianceUid);
    }

    public WorldMarch GetAllianceMarchesInTeam(string allianceUid, long teamUuid)
    {
        return null;//MarchDataManager.GetAllianceMarchesInTeam(allianceUid, teamUuid);
    }

    public List<WorldMarch> GetOwnerMarches(string ownerUid, string allianceUid = "")
    {
        return null;//MarchDataManager.GetOwnerMarches(ownerUid, allianceUid);
    }

    public void HandlePushWorldMarchAdd(ISFSObject message)
    {
        //MarchDataManager?.HandlePushWorldMarchAdd(message);
    }

    public void HandlePushWorldMarchDel(ISFSObject message)
    {
        //MarchDataManager?.HandlePushWorldMarchDel(message);
    }

    public void HandleWorldMarchGet(ISFSObject message)
    {
        //MarchDataManager?.HandleWorldMarchGet(message);
    }

    public void HandleFormationMarch(ISFSObject message)
    {
        //MarchDataManager?.HandleFormationMarch(message);
    }

    public void HandleFormationMarchChange(ISFSObject message)
    {
        //MarchDataManager?.HandleFormationMarchChange(message);
    }

    public bool ExistMarch(long uuid)
    {
        return false;//MarchDataManager.ExistMarch(uuid);
    }

    public bool IsInRallyMarch(long uuid)
    {
        return false;//MarchDataManager.IsInRallyMarch(uuid);
    }

    public bool IsInCollectMarch(long uuid)
    {
        return false;//MarchDataManager.IsInCollectMarch(uuid);
    }

    public bool IsInAssistanceMarch(long uuid)
    {
        return false;//MarchDataManager.IsInAssistanceMarch(uuid);
    }

    public Dictionary<long, WorldMarch> GetDragonMarch()
    {
        return null;//MarchDataManager.GetDragonMarch();
    }
    public bool IsSelfInCurrentMarchTeam(long rallyMarchUuid)
    {
        return false;//MarchDataManager.IsSelfInCurrentMarchTeam(rallyMarchUuid);
    }
    public bool IsTargetForMine(WorldMarch marchData)
    {
        return false;//MarchDataManager.IsTargetForMine(marchData);
    }

    public Dictionary<long, WorldMarch> GetMarchesTargetForMine()
    {
        return null;//MarchDataManager.GetMarchesTargetForMine();
    }

    public Dictionary<long, WorldMarch> GetMarchesBossInfo()
    {
        return null;//MarchDataManager.GetMarchesBossInfo();
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
        InputManager.SetDragFormationData(uuid, pointId);
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
        StaticManager.AddOccupyPoints(p, size);
    }

    public void RemoveOccupyPoints(Vector2Int p, Vector2Int size)
    {
        StaticManager.RemoveOccupyPoints(p, size);
    }

    public void SetStaticVisibleChunk(int range)
    {
        
    }
    #endregion

    #region tmp troopManager

    public float GetModelHeight(long marchUuid)
    {
        return 0;//TroopManager.GetModelHeight(marchUuid);
    }

    public WorldTroop GetTroop(long marchUuid)
    {
        return null;//TroopManager?.GetTroop(marchUuid);
    }

    public bool AddBullet(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType, long tUuid,float3 targetPos,bool isSelf)
    {
        return false;//TroopManager.AddBullet(prefabName, hitPrefabName, startPos, rotation, tType, tUuid,targetPos,isSelf);
    }

    public bool AddBulletV2(string prefabName, string hitPrefabName, Vector3 startPos, Quaternion rotation, int tType,
        int tileSize, Transform trans,bool isSelf)
    {
        return AddBullet(prefabName, hitPrefabName, startPos, rotation, tType, tileSize, trans, isSelf);
    }
    public EnumDestinationSignalType GetDestinationType(long marchUuid, long targetMarchUuid,int endPos, MarchTargetType targetType,bool isFormation, ref Vector3 realPos, ref int tileSize)
    {
        return EnumDestinationSignalType.None;//TroopManager.GetDestinationType(marchUuid, targetMarchUuid,endPos,targetType,isFormation, ref realPos, ref tileSize);
    }

    public MarchTargetType GetTargetType(long targetMarchUuid, int pointId)
    {
        return MarchTargetType.STATE;//TroopManager.GetTargetType(targetMarchUuid, pointId);
    }
        

    public void CreateBattleVFX(string prefabPath, float life, Action<GameObject> onComplete)
    {
        //TroopManager.CreateBattleVFX(prefabPath, life, onComplete);
    }
    public int GetCurPosAndRotationTroopNum(long marchUuid, int pointId, Quaternion rot)
    {
        return 0;//TroopManager.GetCurPosAndRotationTroopNum(marchUuid, pointId, rot);
    }
    public void RemovePosAndRotationDataByMarchUuid(long marchUuid)
    {
        //TroopManager.RemovePosAndRotationDataByMarchUuid(marchUuid);
    }

    public void OnTroopDragUpdate(long marchUuid, Vector3 dragPosCurrent, long targetMarchUuid, int startPointId = 0,
        bool isFormation = false)
    {
        if (XLuaManager.IsUseLuaWorldPoint == false)
        {
            //TroopManager.OnDragUpdate(marchUuid, dragPosCurrent, targetMarchUuid, startPointId, isFormation);
        }
        else
        {
            CanMoving = false;
            if (lastDragPos.Equals(dragPosCurrent)==false)
            {
                lastDragPos = dragPosCurrent;
                EdgeDragUpdate(dragPosCurrent);
                Vector3 targetRealPos = GetTouchPoint();
                var formationTag = 0;
                if (isFormation)
                {
                    formationTag = 1;
                }
                var str = marchUuid + ";"+ formationTag+";"+targetMarchUuid+";"+ targetRealPos.x+";"+targetRealPos.y+";"+targetRealPos.z;
                GameEntry.Event.Fire(EventId.OnTroopDragonUpdatePos, str);
            }
        }
    }

    private Vector3 lastDragPos = Vector3.zero;
    private const float EdgeRateX = 0.1f;
    private const float EdgeRateY = 0.08f;
    private void EdgeDragUpdate(Vector3 dragPosCurrent)
    {        
        var rateX = dragPosCurrent.x / Screen.width;
        var rateY = dragPosCurrent.y / Screen.height;
        if (rateX < EdgeRateX || rateX > 1 - EdgeRateX || rateY < EdgeRateY || rateY > 1 - EdgeRateY)
        {
            var touchTerrainPos = GetTouchPoint(dragPosCurrent);
            var viewTerrainPos = CurTarget;
            var distVec = touchTerrainPos - viewTerrainPos;
            float distLen = distVec.magnitude;
            if (distLen > 0.1f)
            {
                var dir = distVec / distLen;
                float dragSpeed = 0.2f;
                float dist = dragSpeed * Time.deltaTime * GetLodDistance();
                var targetPos = viewTerrainPos + dir * dist;
                Lookat(targetPos);
            }
        }
    }
    public void OnTroopDragStop(long marchUuid, long targetMarchUuid,bool isFormation =false)
    {
        if (XLuaManager.IsUseLuaWorldPoint == false)
        {
            //TroopManager.OnDragStop(marchUuid, targetMarchUuid,isFormation);
        }
        else
        {
            if (isFormation== false)
            {
                var endPos = WorldToTileIndex(GetTouchPoint());
                GameEntry.Lua.Call("MarchUtil.OnChangeSingleMarch", marchUuid,targetMarchUuid,endPos);
            }
            else
            {
                var endPos = WorldToTileIndex(GetTouchPoint());
                GameEntry.Lua.Call("MarchUtil.OnChangeSingleFormation", marchUuid,targetMarchUuid,endPos);
            }
        }
        
    }

    public int GetPointSize(int index)
    {
        return (int)BuildTilesType.One;
    }

    public bool IsTroopCreate(long marchUuid)
    {
        return false;//TroopManager.IsTroopCreate(marchUuid);
    }

    public void CreateTroop(WorldMarch march)
    {
        //TroopManager.CreateTroop(march);
    }

    public void UpdateTroop(WorldMarch march)
    {
        //TroopManager.UpdateTroop(march);
    }
    
    public void DestroyTroop(long marchUuid, bool isBattleFailed = false)
    {
        //TroopManager.DestroyTroop(marchUuid, isBattleFailed);
    }

    public void CreateTroopLine(WorldMarch march)
    {
        //TroopLineManager.CreateTroopLine(march);
    }
    
    public void DestroyTroopLine(long marchUuid)
    {
        //TroopLineManager.DestroyTroopLine(marchUuid);
    }

    public bool IsTroopLineCreate(long marchUuid)
    {
        return false;//TroopLineManager.IsTroopLineCreate(marchUuid);
    }
    
    public void UpdateTroopLine(WorldMarch march, WorldTroopPathSegment[] path, int currPath, Vector3 currPos,
        int realTargetPos = 0, bool needRefresh = false, bool clear = false)
    {
        //TroopLineManager.UpdateTroopLine(march, path, currPath, currPos, realTargetPos, needRefresh, clear);
    }

    public void HideTroopDestination(long uuid)
    {
        //TroopLineManager.HideDestination(uuid);
    }
    
    #endregion

    #region tmp path find

    public void GetTimeFromCurPosToTargetPos(int posStart, int targetPoint, int speed, long Uuid)
    {
        Pathfinding.GetTimeFromCurPosToTargetPos(posStart, targetPoint, speed, Uuid);
    }

    public void FindPath(Vector2Int start, Vector2Int goal, Action<List<Vector2Int>> onComplete)
    {
        Pathfinding.FindPath(start, goal, onComplete);
    }

    #endregion

    #region Culling

    public void RemoveCullingBounds(WorldCulling.ICullingObject cullingObject)
    {
        Culling.RemoveCullingBounds(cullingObject);
    }

    public void AddCullingBounds(WorldCulling.ICullingObject cullingObject)
    {
        Culling.AddCullingBounds(cullingObject);
    }

    #endregion

    #region BattleManager

    public void BattleFinish(ISFSObject message)
    {
        //MarchDataManager?.BattleFinish(message);
    }

    public void UpdateBattleMessage(ISFSObject message)
    {
        //MarchDataManager?.UpdateBattleMessage(message);
    }

    #endregion
    

    #region FakeModelManager

    public void UICreateBuilding(int buildId, long buildUuid, int point, int buildTopType,LuaTable noBuildListStr = null)
    {
        FakeModelManager.UICreateBuilding(buildId, buildUuid, point, buildTopType, noBuildListStr);
    }
    public void UICreateAllianceBuilding(int buildId, long buildUuid, int point, int buildTopType,LuaTable noBuildListStr = null)
    {
        FakeModelManager.UICreateAllianceBuilding(buildId, buildUuid, point, buildTopType, noBuildListStr);
    }

    public void UIChangeBuilding(int index)
    {
        FakeModelManager.UIChangeBuilding(index);
    }

    public void UIDestroyBuilding()
    {
        FakeModelManager.UIDestroyBuilding();
    }

    public void UIChangeAllianceBuilding(int index)
    {
        FakeModelManager.UIChangeAllianceBuilding(index);
    }

    public void UIDestroyAllianceBuilding()
    {
        FakeModelManager.UIDestroyAllianceBuilding();
    }
   

    public FakeWorldBuilding preCreateBuild
    {
        get { return FakeModelManager.preCreateBuild; }
        set { FakeModelManager.preCreateBuild = value; }
    }

    public Queue<FakeWorldBuilding> placeFalseBuild
    {
        get { return FakeModelManager.placeFalseBuild; }
        set { FakeModelManager.placeFalseBuild = value; }
    }

    public void UIDestroyRreCreateBuild()
    {
        FakeModelManager.UIDestroyRreCreateBuild();
    }
    public void UIDestroyRreCreateAllianceBuild()
    {
        FakeModelManager.UIDestroyRreCreateAllianceBuild();
    }

    public ModelManager.ModelObject AddObjectByPointId(int index, int type)
    {
        return null;
    }
    public ModelManager.ModelObject GetObjectByPointId(int index)
    {
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

    public void UnlockFogOfWar(int fogIndex)
    {
    }

    public void UnlockFogOfWar2x2(int unlockIndex)
    {
        
    }
    public void SetFogVisible(bool visible)
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
                    feature.SetActive(visible);
                }
            }

            _scriptableRendererData.SetDirty();
        }
    }
    public void RegisterFogCompleteAction(Action callback)
    {
        
    }

    public void ReInitObject()
    {
      
    }

    public void ClearReInitObject()
    {
      
    }

    public long GetFormationUuid()
    {
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
    #region WorldMapZoneManager

    public int GetZoneIdByPosId(int pointId)
    {
        return WorldMapZoneManager.GetZoneIdByPosId(pointId);
    }

    public bool IsPointInAllianceCity(int pointId)
    {
        return WorldMapZoneManager.IsPointInAllianceCity(pointId);
    }

    public void SetMapZoneActive(bool active)
    {
        WorldMapZoneManager.SetMapZoneActive(active);
    }
    #endregion

    public string FindingPathForEden(int startIndex, int endIndex)
    {
        return WorldEdenAreaManager.FindingPath(startIndex, endIndex);
    }

    public int GetAreaIdByPosId(int pointId)
    {
        return WorldEdenAreaManager.GetAreaIdByPosId(pointId);
    }
    
    //设置世界点类型显示/隐藏
    public void SetVisibleByPointType(int pointType,bool isVisible)
    {
    }
    
    public void SetCameraMaxHeight(int height)
    {
        if (_saveCameraHeight <= 0)
        {
            _saveCameraHeight = Camera.ZoomMax;
        }

        Camera.ZoomMax = height;
    }
    
    public float GetCameraMaxHeight()
    {
        return Camera.ZoomMax;
    }

    public void ResetCameraMaxHeight()
    {
        if (_saveCameraHeight > 0)
        {
            Camera.ZoomMax = _saveCameraHeight;
            _saveCameraHeight = 0;
        }
    }
    
    public void SetCameraMinHeight(int height)
    {
        if (_saveCameraMinHeight <= 0)
        {
            _saveCameraMinHeight = Camera.ZoomMin;
        }

        Camera.ZoomMin = height;
    }
    
    public float GetCameraMinHeight()
    {
        return Camera.ZoomMin;
    }

    public void ResetCameraMinHeight()
    {
        if (_saveCameraMinHeight > 0)
        {
            Camera.ZoomMin = _saveCameraMinHeight;
            _saveCameraMinHeight = 0;
        }
    }

    public void DrawBuildGrid(Mesh mesh, int submeshIndex, Material material, Matrix4x4[] matrices, int count)
    {
        
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
        
    }

    public float GetUSkyLightingPointDistanceFalloff()
    {
        return 0;
    }
    
    public void SetUSkyActive(bool active)
    {
        
    }
    private List<BulletInfo> transList = new List<BulletInfo>();
    private int bulletCount = 80;
    private List<InstanceRequest> hitInstList = new List<InstanceRequest>();
    private bool AddBullet(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType,
                                   int tileSize, Transform trans,bool isSelf)
    {
        if (isSelf || transList.Count <= bulletCount)
        {
            var info = new BulletInfo();
            info.CreateObjectV2(prefabName, hitPrefabName, startPos,rotation,tType,tileSize,trans);
            transList.Add(info);
            return true;
        }

        return false;
    }
    private void UpdateBullet(double time)
    {
        if (transList.Count <= 0)
        {
            return;
        }
        NativeArray<float3> tmpPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<float> tmpDistances = new NativeArray<float>(transList.Count, Allocator.TempJob);
        NativeArray<float3> tmpStartPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<float3> tmpTargetPositions = new NativeArray<float3>(transList.Count, Allocator.TempJob);
        NativeArray<double> tmpTimes = new NativeArray<double>(transList.Count, Allocator.TempJob);
        NativeArray<bool> tempIsCreateFinish = new NativeArray<bool>(transList.Count, Allocator.TempJob);
        for (int i = 0; i < transList.Count; i++)
        {
            var finish = transList[i].IsCreateFinish();
            tempIsCreateFinish[i] = finish;
            if (finish)
            {
                tmpPositions[i] = transList[i].Transform.position;
            }
            else
            {
                tmpPositions[i] = float3.zero;
            }
            tmpDistances[i] = float.MaxValue;
            tmpStartPositions[i] = transList[i].StartPosition;
            tmpTargetPositions[i] = transList[i].GetTargetPositionV2();
            tmpTimes[i] = transList[i].StartTime;
        }
        VelocityJob job = new VelocityJob()
        {
            positions = tmpPositions,
            delaTime = time,
            distances = tmpDistances,
            endPos = tmpTargetPositions,
            startPositions = tmpStartPositions,
            timeArray = tmpTimes,
            isCreateFinish = tempIsCreateFinish
        };
        JobHandle jobHandle = job.Schedule(transList.Count, 32);
        jobHandle.Complete();
        for (int i = transList.Count - 1; i >= 0; i--)
        {
            var obj = transList[i];
            if (tmpDistances[i] <obj.ArriveDistance())
            {
                
                if (obj.IsCreateFinish())
                {
                    var rotation = obj.GetRotation();
                    var position = obj.GetPosition();
                    SpawnHit(obj.GetHitPrefabName(), rotation,position);
                }
                
                obj.Destroy();
                transList.RemoveAt(i);
                
            }
            else
            {
                var finish = obj.IsCreateFinish();
                if (finish)
                {
                    obj.Transform.position = tmpPositions[i];
                }
            }

        }
        tmpDistances.Dispose();
        tmpPositions.Dispose();
        tmpStartPositions.Dispose();
        tmpTimes.Dispose();
        tempIsCreateFinish.Dispose();
        tmpTargetPositions.Dispose();
    }
    private void SpawnHit(string prefabName, Quaternion rotation, float3 gunPosition)
    {

        var requestInst = GameEntry.Resource.InstantiateAsync(prefabName);
        hitInstList.Add(requestInst);
        requestInst.completed += (result) =>
        {
            requestInst.gameObject.transform.position = gunPosition;
            requestInst.gameObject.transform.rotation = rotation;
            YieldUtils.DelayActionWithOutContext(() =>
            {
                if (requestInst != null)
                {
                    requestInst.Destroy();
                }
            }, 0.5f);
            
        };
    }
}