
using System;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using Main.Scripts.Scene;
using UnityEngine;
using UnityEngine.PlayerLoop;
using Object = UnityEngine.Object;

//
// 世界场景静态环境物管理，包括地表、山、树木、地表装饰物等
//
// 概念
//     Block（分区）: 整个世界的分区，每个区为500x500
//     Chunk（块）: 将一个分区再分成块，分区内的装饰物按块划分，以相机的注视点所在块为9宫格中心块，实现装饰物9宫加载显示
public class WorldStaticManager : WorldManagerBase
{
    private const int CreateCountPerFrame = 20;
    private const int TileCountPerChunk = 10;
    private const int ObjectExtents = 4;
    private const int DecorateLod = 7;
    private const int AllianceCityLod = 3;
    private const int TerrainLod = 5;
    private const int TerrainClickLod = 3;
    private Transform parentNode;

    private enum StaticObjectType
    {
        Decorate = 0,  // 装饰物   
        City = 1,      // 城点
    }

    private static readonly int Prop_Control = Shader.PropertyToID("_Control");
    private static readonly int Prop_Splat0 = Shader.PropertyToID("_Splat0");
    private static readonly int Prop_Splat1 = Shader.PropertyToID("_Splat1");
    private static readonly int Prop_Control_ST = Shader.PropertyToID("_Control_ST");
    private static readonly int Prop_Splat0_ST = Shader.PropertyToID("_Splat0_ST");
    private static readonly int Prop_Splat1_ST = Shader.PropertyToID("_Splat1_ST");
    private static readonly int Prop_TerrainBounds = Shader.PropertyToID("_TerrainBounds");
    
    private int chunkCountPerBlock;
    private List<VEngine.Asset> terrainAssets = new List<VEngine.Asset>();
    private List<VEngine.Asset> terrainAssetsNew = new List<VEngine.Asset>();
    private Dictionary<Vector2Int, GameObject> terrains = new Dictionary<Vector2Int, GameObject>();
    private HashSet<Vector2Int> tmpCalcTerrains = new HashSet<Vector2Int>();
    private List<Vector2Int> tmpForRemove = new List<Vector2Int>();

    private VEngine.Asset worldSceneDescAsset;
    private VEngine.Asset worldSceneCityDescAsset;
    private List<Block> blockTemplates;
    private Block[][] worldBlocks;
    private Block cityBlock;
    
    private Dictionary<int, StaticObject> objsDict = new Dictionary<int, StaticObject>();
    private Dictionary<int, Tuple<Vector2Int, WorldSceneDesc.ObjectDesc>> createList = new Dictionary<int, Tuple<Vector2Int, WorldSceneDesc.ObjectDesc>>();
    private List<int> objsToRemove = new List<int>();
    private List<WorldSceneDesc.ObjectDesc> chunkObjList = new List<WorldSceneDesc.ObjectDesc>();
    
    private int lastViewLevel;
    private Vector2Int lastViewChunk;
    private int lastViewRange;

    private InstanceRequest blackBlockRequest;//黑土地

    private InstanceRequest dragonBlockRequest;

    private InstanceRequest crossThroneRequest;
    private Dictionary<Vector2Int, int> occupyPoints = new Dictionary<Vector2Int, int>();
    private bool isLoadFinish;
    private string terrainPrefabName;
    private Action loadTerrainCallback;

    class Block
    {
        private string terrainName;
        private VEngine.Asset assetReq;
        private WorldSceneDesc blockTpl;
        private Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>> chunks = new Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>>();
        
        public void Init(string terrainName, byte[] bytes, WorldStaticManager mgr)
        {
            blockTpl = new WorldSceneDesc();
            blockTpl.Load(bytes);
            
            this.terrainName = terrainName; 

            // 数据分块
            for (int i = 0; i < blockTpl.objectDescs.Count; i++)
            {
                var objDesc = blockTpl.objectDescs[i];
                var chunkCoord = mgr.TilePosToChunkCoord(SceneManager.World.WorldToTile(objDesc.localPos));
                if (chunks.TryGetValue(chunkCoord, out var list))
                {
                    list.Add(objDesc);
                }
                else
                {
                    list = new List<WorldSceneDesc.ObjectDesc>();
                    list.Add(objDesc);
                    chunks.Add(chunkCoord, list);
                }
            }
        }

        public void Uninit()
        {
            
        }

        public List<WorldSceneDesc.ObjectDesc> GetChunkObjList(Vector2Int chunkCoord)
        {
            if (chunks.TryGetValue(chunkCoord, out var list))
                return list;
            return null;
        }

        public bool IsTileWalkable(Vector2Int tilePos)
        {
            return blockTpl.gridDesc.grids[tilePos.y * SceneManager.World.BlockSize + tilePos.x] == 0;
        }

        public string TerrainName
        {
            get => terrainName;
            set => terrainName = value;
        }
    }
    
    class StaticObject
    {
        public StaticObject(WorldSceneDesc.ObjectDesc desc, Vector3 pos)
        {
            this.desc = desc;
            isVisible = true;
            position = pos;
            tilePos = SceneManager.World.WorldToTile(pos);
        }

        public void Load(Transform parent)
        {
            request = GameEntry.Resource.InstantiateAsync(desc.assetPath);
            request.completed += delegate
            {
                if (request.gameObject == null)
                {
                    Log.Error("gameObject null");
                    return;
                }
                if (desc == null)
                {
                    Log.Warning("OnSpawn desc null");
                    return;
                }
                
                gameObject = request.gameObject;
                gameObject.transform.SetParent(parent, false);
                gameObject.transform.localPosition = position;
                gameObject.transform.localScale = desc.scale;
                gameObject.transform.localRotation = Quaternion.Euler(desc.rotation);
                gameObject.SetActive(isVisible);
            };
        }

        public void Unload()
        {
            desc = null;
            request.Destroy();
        }

        public void SetVisible(bool v)
        {
            isVisible = v;
            if (gameObject != null)
            {
                gameObject.SetActive(v);
            }
        }

        public bool IsVisible => isVisible;

        public StaticObjectType Type
        {
            get { return (StaticObjectType)desc.type; }
        }
        
        public Vector2Int TilePos
        {
            get { return tilePos; }
        }
        
        public int Id
        {
            get { return desc.id; }
        }

        private InstanceRequest request;
        private WorldSceneDesc.ObjectDesc desc;
        private GameObject gameObject;
        private bool isVisible;
        private Vector2Int tilePos;
        private Vector3 position;
    }

    public WorldStaticManager(WorldScene scene) : base(scene)
    {
        
    }

    public override void Init()
    {
        
        chunkCountPerBlock = world.BlockSize / TileCountPerChunk;
        OnInitObject();
        world.AfterUpdate += UpdateView;
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);

    }
    
    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
        world.AfterUpdate -= UpdateView;
        OnRemoveObject();
    }

    public void OnRemoveObject()
    {
        isLoadFinish = false;
        foreach (var i in terrains)
        {
            var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
            pool.DeSpawn(i.Value);
        }
        terrains.Clear();
        foreach (var i in blockTemplates)
        {
            i.Uninit();
        }
        
        foreach (var kv in objsDict)
        {
            kv.Value.Unload();
        }
        objsDict.Clear();

        UnloadTerrainAssets();
        Object.Destroy(parentNode.gameObject);
        parentNode = null;
        worldBlocks = null;
        if (worldSceneDescAsset != null)
        {
            worldSceneDescAsset.Release();
            worldSceneDescAsset = null;
        }
        if (worldSceneCityDescAsset != null)
        {
            worldSceneCityDescAsset.Release();
            worldSceneCityDescAsset = null;
        }

        RemoveBlackDesert();
        RemoveDragonLandRange();
        RemoveCrossThroneRange();
    }

    public void OnInitObject()
    {
        parentNode = new GameObject("Static").transform;
        parentNode.transform.SetParent(world.Transform, false);
        InitViewChunk();
        InitWorldBlocks();
        InitBlackBlock();
        CreateDragonLandRange();
        CreateCrossThroneRange();
        //InitAllianceCity();
    }
    public override void OnUpdate(float deltaTime)
    {
        if (!isLoadFinish)
            return;

        // UpdateView();
    }

    public void RemoveBlackDesert()
    {
        if (blackBlockRequest != null)
        {
            blackBlockRequest.Destroy();
            blackBlockRequest = null;
        }
    }
    public bool IsTileWalkable(Vector2Int tilePos)
    {
        if (world.IsInMap(tilePos))
        {
            int bx = tilePos.x / world.BlockSize;
            int by = tilePos.y / world.BlockSize;
            int x = tilePos.x - (bx * world.BlockSize);
            int y = tilePos.y - (by * world.BlockSize);
            return worldBlocks[by][bx] != null && worldBlocks[by][bx].IsTileWalkable(new Vector2Int(x, y));
        }

        return false;
    }
    
    public void AddOccupyPoints(Vector2Int p, Vector2Int size)
    {
        // for (int y = p.y; y > p.y - size.y; y--)
        // {
        //     for (int x = p.x; x > p.x - size.x; x--)
        //     {
        //         var t = new Vector2Int(x, y);
        //         if (world.IsInMap(t))
        //         {
        //             if (occupyPoints.TryGetValue(t, out var count))
        //             {
        //                 occupyPoints[t] = count + 1;
        //             }
        //             else
        //             {
        //                 occupyPoints.Add(t, 1);
        //             }
        //         }
        //     }
        // }
        //
        // HideObjectInRect(p, size);
    }

    public void RemoveOccupyPoints(Vector2Int p, Vector2Int size)
    {
        for (int y = p.y; y > p.y - size.y; y--)
        {
            for (int x = p.x; x > p.x - size.x; x--)
            {
                var t = new Vector2Int(x, y);
                if (occupyPoints.TryGetValue(t, out var count))
                {
                    count--;
                    if (count == 0)
                    {
                        occupyPoints.Remove(t);
                    }
                }
            }
        }
        
        ShowObjectsInRect(p, size);
    }
    
    public bool IsOccupied(Vector2Int p)
    {
        var oxMin = p.x - ObjectExtents;
        var oxMax = p.x + ObjectExtents;
        var oyMin = p.y - ObjectExtents;
        var oyMax = p.y + ObjectExtents;
        for (int y = oyMin; y <= oyMax; y++)
        {
            for (int x = oxMin; x <= oxMax; x++)
            {
                if (occupyPoints.ContainsKey(new Vector2Int(x, y)))
                    return true;
            }
        }

        return false;
    }

    private void CheckLoadFinish()
    {
        foreach (var i in terrainAssets)
        {
            if (!i.isDone)
                return;
        }

        isLoadFinish = true;
    }
    

    private void HideObjectInRect(Vector2Int p, Vector2Int size)
    {
        var xMin = p.x - (size.x - 1);
        var xMax = xMin + (size.x - 1);
        var yMin = p.y - (size.y - 1);
        var yMax = yMin + (size.y - 1);
        
        foreach (var i in objsDict.Values)
        {
            var oxMin = i.TilePos.x - ObjectExtents;
            var oxMax = i.TilePos.x + ObjectExtents;
            var oyMin = i.TilePos.y - ObjectExtents;
            var oyMax = i.TilePos.y + ObjectExtents;

            if (oxMin <= xMax && oxMax >= xMin && oyMin <= yMax && oyMax >= yMin && i.Type == StaticObjectType.Decorate)
            {
                i.SetVisible(false);
            }
        }
    }
    
    private void ShowObjectsInRect(Vector2Int p, Vector2Int size)
    {
        var xMin = p.x - (size.x - 1);
        var xMax = xMin + (size.x - 1);
        var yMin = p.y - (size.y - 1);
        var yMax = yMin + (size.y - 1);

        foreach (var i in objsDict.Values)
        {
            var oxMin = i.TilePos.x - ObjectExtents;
            var oxMax = i.TilePos.x + ObjectExtents;
            var oyMin = i.TilePos.y - ObjectExtents;
            var oyMax = i.TilePos.y + ObjectExtents;

            if (oxMin <= xMax && oxMax >= xMin && oyMin <= yMax && oyMax >= yMin && !i.IsVisible && !IsOccupied(i.TilePos))
            {
                i.SetVisible(true);
            }
        }
    }

    private void InitViewChunk()
    {
        lastViewChunk = new Vector2Int(int.MinValue, int.MinValue);
        lastViewLevel = int.MinValue;
        lastViewRange = GetVisibleChunkRange();
    }

    public void LoadTerrainAssets(Action callback)
    {
        loadTerrainCallback = callback;
        
        var terrainPrefab = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_Eden_World_High
                : GameDefines.EntityAssets.Terrain_Eden_World_Low;
        }
        else
        {
            terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_World0_High
                : GameDefines.EntityAssets.Terrain_World0_Low;
        }
        var req = GameEntry.Resource.LoadAssetAsync(terrainPrefab, typeof(GameObject));
        req.completed += (r) =>
        {
            CheckLoadFinish();
            UpdateView();
            if (isLoadFinish && loadTerrainCallback != null)
            {
                loadTerrainCallback?.Invoke();
                loadTerrainCallback = null;
            }
        };
        terrainAssets.Add(req);

        //
        // 加载地表融合贴图的设置
        //
        var terrainSetting = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainSetting = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.EdenTerrainSetting_High
                : GameDefines.EntityAssets.EdenTerrainSetting_Low;
        }
        else
        {
            terrainSetting =SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.TerrainSetting_High
                : GameDefines.EntityAssets.TerrainSetting_Low;
        }
        req = GameEntry.Resource.LoadAssetAsync(terrainSetting, typeof(ScriptableObject));
        req.completed += delegate
        {
            ChangeTerrainSetting(req.asset as TerrainSetting);
            CheckLoadFinish();
            UpdateView();
            if (isLoadFinish && loadTerrainCallback != null)
            {
                loadTerrainCallback?.Invoke();
                loadTerrainCallback = null;
            }
        };
        terrainAssets.Add(req);
    }

    private void ChangeTerrainSetting(TerrainSetting setting)
    {
        Shader.SetGlobalTexture(Prop_Control, setting.control);
        Shader.SetGlobalTexture(Prop_Splat0, setting.splat0);
        Shader.SetGlobalTexture(Prop_Splat1, setting.splat1);
        Shader.SetGlobalVector(Prop_Control_ST, setting.control_st);
        Shader.SetGlobalVector(Prop_Splat0_ST, setting.splat0_st);
        Shader.SetGlobalVector(Prop_Splat1_ST, setting.splat1_st);
        Shader.SetGlobalVector(Prop_TerrainBounds, setting.terrainBounds);
    }

    private void UnloadTerrainAssets()
    {
        foreach (var i in terrainAssets)
        {
            i.Release();
            i.completed = null;
        }
        terrainAssets.Clear();
    }

    private void InitWorldBlocks()
    {
        worldBlocks = new Block[world.BlockCount.y][];
        for (int i = 0; i < world.BlockCount.y; i++)
        {
            worldBlocks[i] = new Block[world.BlockCount.x];
        }
        
        terrainPrefabName = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainPrefabName = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_Eden_World_High
                : GameDefines.EntityAssets.Terrain_Eden_World_Low;
        }
        else
        {
            terrainPrefabName = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_World0_High
                : GameDefines.EntityAssets.Terrain_World0_Low;
        }
        blockTemplates = new List<Block>();
        var path = GameDefines.EntityAssets.WorldSceneDesc;
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            path = GameDefines.EntityAssets.WorldEdenSceneDesc;
        }
        worldSceneDescAsset = GameEntry.Resource.LoadAssetAsync(path, typeof(TextAsset));
        worldSceneDescAsset.completed += delegate
        {
            var block = new Block();
            block.Init(terrainPrefabName, worldSceneDescAsset.Get<TextAsset>().bytes, this);
            blockTemplates.Add(block);
            
            worldSceneDescAsset.Release();
            worldSceneDescAsset = null;
            
            // 设置每个分区引用的模版
            var blockTypeCount = GameEntry.Lua.CallWithReturn<int, string, string>("CSharpCallLuaInterface.GetConfigNum","player_birth_rectangle", "k3");

            for (int by = 0; by < world.BlockCount.y; by++)
            {
                for (int bx = 0; bx < world.BlockCount.x; bx++)
                {
                    var index = (by & 1) == 0 ? (bx % blockTypeCount) : ((bx + 1) % blockTypeCount);
                    if (index >= blockTemplates.Count)
                    {
                        index = blockTemplates.Count - 1;
                    }
                    worldBlocks[by][bx] = blockTemplates[index];
                }
            }
        };
    }

    public void InitBlackBlock()
    {
        var show = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetCanShowBlackLand");
        if (show == false)
        {
            return;
        }
        if (blackBlockRequest == null)
        {
            blackBlockRequest = GameEntry.Resource.InstantiateAsync("Assets/Main/Prefabs/World/BlackBlock.prefab");
            blackBlockRequest.completed += (result) =>
            {
                if (blackBlockRequest.gameObject == null)
                {
                    Log.Error("gameObject null");
                    return;
                }
                blackBlockRequest.gameObject.transform.position = new Vector3(1000, 0, 1000);
            };
        }
    }

    public void CreateDragonLandRange()
    {
        if (GameEntry.GlobalData.serverType != (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
        {
            return;
        }
        if (dragonBlockRequest == null)
        {
           dragonBlockRequest = GameEntry.Resource.InstantiateAsync("Assets/Main/Prefabs/World/DragonWarDesert.prefab");
           dragonBlockRequest.completed += (result) =>
            {
                if (dragonBlockRequest.gameObject == null)
                {
                    Log.Error("gameObject null");
                    return;
                }
                dragonBlockRequest.gameObject.transform.position = new Vector3(1000, 0, 1000);
            };
        }
        
    }
    public void CreateCrossThroneRange()
    {
        if (GameEntry.GlobalData.serverType != (int)ServerType.CROSS_THRONE)
        {
            return;
        }
        if (crossThroneRequest == null)
        {
            crossThroneRequest = GameEntry.Resource.InstantiateAsync("Assets/Main/Prefabs/World/CrossThroneDesert.prefab");
            crossThroneRequest.completed += (result) =>
            {
                if (crossThroneRequest.gameObject == null)
                {
                    Log.Error("gameObject null");
                    return;
                }
                crossThroneRequest.gameObject.transform.position = new Vector3(1000, 0, 1000);
            };
        }
        
    }
    public void RemoveCrossThroneRange()
    {
        if (crossThroneRequest != null)
        {
            crossThroneRequest.Destroy();
            crossThroneRequest = null;
        }
    }
    public void RemoveDragonLandRange()
    {
        if (dragonBlockRequest != null)
        {
            dragonBlockRequest.Destroy();
            dragonBlockRequest = null;
        }
    }

    private void InitAllianceCity()
    {
        // 加载联盟城点
        worldSceneCityDescAsset = GameEntry.Resource.LoadAssetAsync(GameDefines.EntityAssets.WorldSceneAllianceCityDesc, typeof(TextAsset));
        worldSceneCityDescAsset.completed += delegate
        {
            cityBlock = new Block();
            cityBlock.Init("", worldSceneCityDescAsset.Get<TextAsset>().bytes, this);
            
            worldSceneCityDescAsset.Release();
            worldSceneCityDescAsset = null;
        };
    }
    
    public void ChangeTerrain()
    {
        terrainAssetsNew.Clear();

        var terrainPrefab = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_Eden_World_High
                : GameDefines.EntityAssets.Terrain_Eden_World_Low;
        }
        else
        {
            terrainPrefab = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_World0_High
                : GameDefines.EntityAssets.Terrain_World0_Low;
        }
        var req = GameEntry.Resource.LoadAssetAsync(terrainPrefab, typeof(GameObject));
        req.completed += (r) =>
        {
            CheckChangeFinish();
        };
        
        //
        // 加载地表融合贴图的设置
        //
        var terrainSetting = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainSetting = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.EdenTerrainSetting_High
                : GameDefines.EntityAssets.EdenTerrainSetting_Low;
        }
        else
        {
            terrainSetting =SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.TerrainSetting_High
                : GameDefines.EntityAssets.TerrainSetting_Low;
        }

        req = GameEntry.Resource.LoadAssetAsync(terrainSetting, typeof(ScriptableObject));
        req.completed += delegate
        {
            ChangeTerrainSetting(req.asset as TerrainSetting);
            CheckChangeFinish();
        };
        terrainAssetsNew.Add(req);
    }

    private void CheckChangeFinish()
    {
        if (terrainAssetsNew.Count == 0)
            return;
        foreach (var i in terrainAssetsNew)
        {
            if (!i.isDone)
                return;
        }

        foreach (var i in terrains)
        {
            var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
            pool.DeSpawn(i.Value);
        }
        terrains.Clear();
        
        UnloadTerrainAssets();
        
        var temp = terrainAssets;
        terrainAssets = terrainAssetsNew;
        terrainAssetsNew = temp;
        
        terrainPrefabName = "";
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            terrainPrefabName = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_Eden_World_High
                : GameDefines.EntityAssets.Terrain_Eden_World_Low;
        }
        else
        {
            terrainPrefabName = SceneQualitySetting.GetTerrainLevel() == GameDefines.QualityLevel_High
                ? GameDefines.EntityAssets.Terrain_World0_High
                : GameDefines.EntityAssets.Terrain_World0_Low;
        }
        InitViewChunk();
        UpdateView();
    }

    private Vector2Int TilePosToChunkCoord(Vector2Int tilePos)
    {
        return new Vector2Int(tilePos.x / TileCountPerChunk, tilePos.y / TileCountPerChunk);
    }

    private Vector2Int TilePosToBlockCoord(Vector2Int tilePos)
    {
        return new Vector2Int(tilePos.x / world.BlockSize, tilePos.y / world.BlockSize);
    }

    private Vector2Int ChunkCoordToBlockCoord(Vector2Int chunkCoord)
    {
        if (chunkCoord.x < 0)
            chunkCoord.x -= chunkCountPerBlock;
        if (chunkCoord.y < 0)
            chunkCoord.y -= chunkCountPerBlock;
        return new Vector2Int(chunkCoord.x / chunkCountPerBlock, chunkCoord.y / chunkCountPerBlock);
    }

    private void GetChunkObjList(Vector2Int chunkCoord, List<WorldSceneDesc.ObjectDesc> list)
    {
        list.Clear();
        
        // 山石装饰物
        var blockCoord = ChunkCoordToBlockCoord(chunkCoord);
        var block = GetBlock(blockCoord);
        if (block != null)
        {
            var blockBaseChunk = new Vector2Int(blockCoord.x * chunkCountPerBlock, blockCoord.y * chunkCountPerBlock);
            var objList = block.GetChunkObjList(chunkCoord - blockBaseChunk);
            if (objList != null)
            {
                list.AddRange(objList);
            }
        }

        // 联盟城点
        if (cityBlock != null)
        {
            var objList = cityBlock.GetChunkObjList(chunkCoord);
            if (objList != null)
            {
                list.AddRange(objList);
            }
        }
    }

    private Block GetBlock(Vector2Int blockCoord)
    {
        if (blockCoord.x < 0)
            blockCoord.x += world.BlockCount.x;
        if (blockCoord.y < 0)
            blockCoord.y += world.BlockCount.y;
        if (blockCoord.x >= world.BlockCount.x)
            blockCoord.x -= world.BlockCount.x;
        if (blockCoord.y >= world.BlockCount.y)
            blockCoord.y -= world.BlockCount.y;
        return worldBlocks[blockCoord.y][blockCoord.x];
    }
    
    private int GetVisibleChunkRange()
    {
        float currDist = world.GetLodDistance();
        
        int i = 1;
        while (currDist >= i * 70)
            i++;
        
        return i;
        
        // if (currDist < 70)
        // {
        //     return 1;
        // }
        // else if (currDist < 150)
        // {
        //     return 2;
        // }
        // else
        // {
        //     return 3;
        // }
    }

    private void UpdateView()
    {
        if (!isLoadFinish)
            return;
        
        bool viewChunkChanged = false;
        bool viewLevelChanged = false;
        
        var cameraTilePos = world.CurTilePos;
        var viewChunkCoord = TilePosToChunkCoord(cameraTilePos);
        int currViewLevel = world.GetLodLevel();
        int currViewRange = GetVisibleChunkRange();
        
        if (lastViewChunk != viewChunkCoord)
        {
            lastViewChunk = viewChunkCoord;
            viewChunkChanged = true;
        }

        if (lastViewLevel != currViewLevel || lastViewRange != currViewRange)
        {
            lastViewLevel = currViewLevel;
            lastViewRange = currViewRange;
            viewLevelChanged = true;
        }
        
        // 视口所在Chunk变化时，更新显示内容
        if (currViewLevel <= 7)
        {
            if (viewChunkChanged || viewLevelChanged)
            {
                var chunksVisibleRange = GetVisibleChunkRange();

                // 隐藏超出范围的物体
                int minX = viewChunkCoord.x - chunksVisibleRange;
                int maxX = viewChunkCoord.x + chunksVisibleRange;
                int minY = viewChunkCoord.y - chunksVisibleRange;
                int maxY = viewChunkCoord.y + chunksVisibleRange;

                foreach (var kv in objsDict)
                {
                    var obj = kv.Value;
                    var chunkCoord = TilePosToChunkCoord(obj.TilePos);
                    var lodVisible = (obj.Type == StaticObjectType.Decorate && currViewLevel <= DecorateLod) 
                                     || (obj.Type == StaticObjectType.City && currViewLevel <= AllianceCityLod);
                    if (chunkCoord.x < minX || chunkCoord.x > maxX || chunkCoord.y < minY || chunkCoord.y > maxY || !lodVisible)
                    {
                        objsToRemove.Add(obj.Id);
                        obj.Unload();
                    }
                }

                if (objsToRemove.Count > 0)
                {
                    for (int i = 0; i < objsToRemove.Count; i++)
                    {
                        objsDict.Remove(objsToRemove[i]);
                    }
                    objsToRemove.Clear();
                }

                // 删除待创建列表里还没开始创建但超出显示范围的
                foreach (var kv in createList)
                {
                    var desc = kv.Value.Item2;
                    var tilePos = kv.Value.Item1;
                    var chunkCoord = TilePosToChunkCoord(tilePos);
                    var lodVisible = (desc.type == (int) StaticObjectType.Decorate && currViewLevel <= DecorateLod) 
                                     || (desc.type == (int) StaticObjectType.City && currViewLevel <= AllianceCityLod);
                    if (chunkCoord.x < minX || chunkCoord.x > maxX || chunkCoord.y < minY || chunkCoord.y > maxY || !lodVisible)
                    {
                        objsToRemove.Add(kv.Key);
                    }
                }

                if (objsToRemove.Count > 0)
                {
                    for (int i = 0; i < objsToRemove.Count; i++)
                    {
                        createList.Remove(objsToRemove[i]);
                    }
                    objsToRemove.Clear();
                }

                // 显示进入视野范围的物体
                for (int y = -chunksVisibleRange; y <= chunksVisibleRange; y++)
                {
                    for (int x = -chunksVisibleRange; x <= chunksVisibleRange; x++)
                    {
                        var chunkCoord = viewChunkCoord + new Vector2Int(x, y);
                        var blockCoord = ChunkCoordToBlockCoord(chunkCoord);

                        GetChunkObjList(chunkCoord, chunkObjList);
                        if (chunkObjList.Count > 0)
                        {
                            for (int i = 0; i < chunkObjList.Count; i++)
                            {
                                var objDesc = chunkObjList[i];
                                var tilePos = Vector2Int.zero;
                                bool lodVisible = true;
                                if (objDesc.type == (int) StaticObjectType.City)
                                {
                                    tilePos = world.WorldToTile(objDesc.localPos);
                                    lodVisible = currViewLevel <= AllianceCityLod;
                                }
                                else if (objDesc.type == (int) StaticObjectType.Decorate)
                                {
                                    var blockBasePos = world.TileFloatToWorld(
                                        blockCoord.x * world.BlockSize, blockCoord.y * world.BlockSize);
                                    tilePos = world.WorldToTile(blockBasePos + objDesc.localPos);
                                    lodVisible = currViewLevel <= DecorateLod;
                                }
                                
                                if (!objsDict.ContainsKey(objDesc.id)
                                    && !createList.ContainsKey(objDesc.id)
                                    && world.IsInMap(tilePos)
                                    && lodVisible
                                    && (objDesc.type == (int)StaticObjectType.City || !IsOccupied(tilePos)))
                                {
                                    createList.Add(objDesc.id,
                                        new Tuple<Vector2Int, WorldSceneDesc.ObjectDesc>(tilePos, objDesc));
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if (objsDict.Count > 0)
            {
                foreach (var kv in objsDict)
                {
                    kv.Value.Unload();
                }
                objsDict.Clear();
            }
            
            if (createList.Count > 0)
            {
                createList.Clear();
            }
        }
        
        
        //
        // 分帧加载
        //
        if (createList.Count > 0)
        {
            int count = 0;
            foreach (var i in createList)
            {
                var tilePos = i.Value.Item1;
                var desc = i.Value.Item2;
                objsToRemove.Add(i.Key);
                if (desc.type == (int)StaticObjectType.City || !IsOccupied(tilePos))
                {
                    StaticObject obj = null;
                    if (desc.type == (int) StaticObjectType.City && currViewLevel <= AllianceCityLod)
                    {
                        obj = new StaticObject(desc, desc.localPos);
                    }
                    else if (desc.type == (int) StaticObjectType.Decorate && currViewLevel <= DecorateLod)
                    {
                        var blockCoord = TilePosToBlockCoord(tilePos);
                        var blockBasePos = world.TileFloatToWorld(blockCoord.x * world.BlockSize, blockCoord.y * world.BlockSize);
                        obj = new StaticObject(desc, blockBasePos + desc.localPos);
                    }
                    
                    if (obj != null && !objsDict.ContainsKey(obj.Id))
                    {
                        obj.Load(parentNode);
                        objsDict.Add(obj.Id, obj);
                        
                        if (count > CreateCountPerFrame)
                            break;
                        count++;
                    }
                }
            }
            
            for (int i = 0; i < objsToRemove.Count; i++)
            {
                createList.Remove(objsToRemove[i]);
            }
            objsToRemove.Clear();
        }
        
        
        //
        // 更新地表
        //
        if (currViewLevel >= 1 && currViewLevel <= TerrainLod)
        {
            if (viewChunkChanged || viewLevelChanged)
            {
                // foreach (var i in terrains)
                // {
                //     var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
                //     pool.DeSpawn(i.Value);
                // }
                //
                // terrains.Clear();
            
                tmpCalcTerrains.Clear();
                tmpForRemove.Clear();
                var chunksVisibleRange = GetVisibleChunkRange() + 2;
                for (int y = -chunksVisibleRange; y <= chunksVisibleRange; y++)
                {
                    for (int x = -chunksVisibleRange; x <= chunksVisibleRange; x++)
                    {
                        var chunkCoord = viewChunkCoord + new Vector2Int(x, y);
                        var blockCoord = ChunkCoordToBlockCoord(chunkCoord);

                        if (!tmpCalcTerrains.Contains(blockCoord))
                            tmpCalcTerrains.Add(blockCoord);
                    }
                }

                foreach (var pos in tmpCalcTerrains)
                {
                    if (!terrains.ContainsKey(pos))
                    {
                        var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
                        var terrainObj = pool.Spawn();
                        terrainObj.GetComponent<TouchObjectEventTrigger>().onPointerClick = OnTerrainClick;
                        terrainObj.transform.position = world.TileFloatToWorld(
                            pos.x * world.BlockSize, pos.y * world.BlockSize);
                        terrainObj.GetComponent<Collider>().enabled = world.GetLodLevel() >= TerrainClickLod;
                        terrains.Add(pos, terrainObj);
                    }
                }
                foreach (var i in terrains)
                {
                    if (!tmpCalcTerrains.Contains(i.Key))
                    {
                        var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
                        pool.DeSpawn(i.Value);
                        tmpForRemove.Add(i.Key);
                    }
                }

                foreach (var val in tmpForRemove)
                {
                    terrains.Remove(val);
                }
            }
        }
        else if (terrains.Count > 0)
        {
            foreach (var i in terrains)
            {
                var pool = GameEntry.Resource.GetObjectPool(terrainPrefabName);
                pool.DeSpawn(i.Value);
            }

            terrains.Clear();
        }
    }

    private void OnLodChanged(object userdata)
    {
        var lod = (int) userdata;
        if (lod >= TerrainClickLod)
        {
            foreach (var t in terrains.Values)
            {
                t.GetComponent<Collider>().enabled = true;
            }
        }
        else
        {
            foreach (var t in terrains.Values)
            {
                t.GetComponent<Collider>().enabled = false;
            }
        }
    }

    private void OnTerrainClick()
    {
        if (world.GetLodLevel() >= TerrainClickLod)
        {
            var tilepos = world.GetTouchTilePos();
            world.AutoLookat(world.TileToWorld(tilepos), world.Zoom,0.3f, () =>
            {
                world.AutoZoom(world.InitZoom);
            });
            
        }
    }

    public void OnDrawGizmos()
    {
        /*
        Gizmos.color = new Color(1, 0, 0, 0.2f);
        foreach (var i in occupyPoints)
        {
            Gizmos.DrawCube(WorldScene.TileToWorld(i), new Vector3(2, 0.1f, 2));
        }
        
        Gizmos.color = new Color(0, 1, 0, 0.2f);
        foreach (var i in objsDict.Values)
        {
            var oxMin = i.TilePos.x - ObjectExtents;
            var oxMax = i.TilePos.x + ObjectExtents;
            var oyMin = i.TilePos.y - ObjectExtents;
            var oyMax = i.TilePos.y + ObjectExtents;
            for (int y = oyMin; y <= oyMax; y++)
            {
                for (int x = oxMin; x <= oxMax; x++)
                {
                    Gizmos.DrawCube(WorldScene.TileToWorld(new Vector2Int(x, y)), new Vector3(2, 0.1f, 2));
                }
            }
        }
        */
    }

    #region Profile
    
    private bool profileTerrainSwitch = true;

    public bool GetProfileTerrainSwitch()
    {
        return profileTerrainSwitch;
    }
    
    public void ProfileToggleTerrain()
    {
        profileTerrainSwitch = !profileTerrainSwitch;

        foreach (var i in terrains.Values)
        {
            //i.SetActive(profileTerrainSwitch);
            i.SetLayerRecursively(LayerMask.NameToLayer(profileTerrainSwitch ? "Default" : "Hide"));
        }
    }

    private bool profileSwitch = true;

    public bool GetProfileSwitch()
    {
        return profileSwitch;
    }
    
    public void ProfileToggle()
    {
        profileSwitch = !profileSwitch;
        
        foreach (var kv in objsDict)
        {
            kv.Value.SetVisible(profileSwitch);
        }
    }

    #endregion
    
}