
using System.Collections.Generic;
using GameFramework;
using UnityEngine;

//
// 场景静态环境物管理，包括山、石、陨石坑等装饰物
//

public class CityStaticManager : CityManagerBase
{
    
    
    private const int ObjectExtents = 1;
    private const int CreateCountPerFrame = 40;
    private const int TileCountPerChunk = 4;
    private Transform _parentNode;
    private WorldSceneDesc _sceneDesc;
    private VEngine.Asset _descAsset;
    private Dictionary<int, StaticObject> _objsDict = new Dictionary<int, StaticObject>();
    private Dictionary<int, WorldSceneDesc.ObjectDesc> _createList = new Dictionary<int, WorldSceneDesc.ObjectDesc>();
    private List<int> objsToRemove = new List<int>();
    private HashSet<Vector2Int> occupyPoints = new HashSet<Vector2Int>();

    private Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>> _chunks = new Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>>();
    public CitySceneType citySceneType = CitySceneType.World;

    private bool isLoadFinish;
    private Vector2Int _lastViewChunk;
    private int _visibleChunkRange = 1;
    private int _lastVisibleChunkRang = 1;
    private float rate = 2.4f;
    class StaticObject
    {
        public StaticObject(WorldSceneDesc.ObjectDesc desc, Vector3 pos)
        {
            this.desc = desc;
            position = pos;
            tilePos = SceneManager.World.WorldToTile(pos);
            isVisible = true;
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

        public int Id
        {
            get { return desc.id; }
        }
        
        public Vector2Int TilePos
        {
            get { return tilePos; }
        }

        private InstanceRequest request;
        private WorldSceneDesc.ObjectDesc desc;
        private GameObject gameObject;
        private bool isVisible;
        private Vector2Int tilePos;
        private Vector3 position;
    }
    
    public CityStaticManager(CityScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        if(this.citySceneType== CitySceneType.DigDig)
        {
            return;
        }
        _parentNode = new GameObject("Static").transform;
        _parentNode.transform.SetParent(scene.Transform, false);

        _lastViewChunk = new Vector2Int(int.MinValue, int.MinValue);
        _sceneDesc = new WorldSceneDesc();
        rate = (float)Screen.height / Screen.width;
        _descAsset = GameEntry.Resource.LoadAssetAsync(WorldSceneDesc.CityDescPath, typeof(TextAsset));
        _descAsset.completed += delegate
        {
            var textAsset = _descAsset.asset as TextAsset;
            _sceneDesc.Load(textAsset.bytes);
        
            // 按格子划分装饰物
            for (int i = 0; i < _sceneDesc.objectDescs.Count; i++)
            {
                var objDesc = _sceneDesc.objectDescs[i];
                var chunkCoord = TilePosToChunkCoord(scene.WorldToTile(objDesc.localPos));
                if (_chunks.TryGetValue(chunkCoord, out var list))
                {
                    list.Add(objDesc);
                }
                else
                {
                    list = new List<WorldSceneDesc.ObjectDesc>();
                    list.Add(objDesc);
                    _chunks.Add(chunkCoord, list);
                }
            }
            
            _descAsset.Release();
            _descAsset = null;
            isLoadFinish = true;
        };
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnLodChanged);
    }
    
    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnLodChanged);
        if (_descAsset != null)
        {
            _descAsset.Release(); 
            _descAsset = null;
        }
        
        foreach (var kv in _objsDict)
        {
            kv.Value.Unload();
        }
        _objsDict.Clear();
        
        Object.Destroy(_parentNode.gameObject);
        _parentNode = null;
    }
    
    public override void OnUpdate(float deltaTime)
    {
        UpdateView();
    }

    private void OnLodChanged(object userdata)
    {
        var lod = (int) userdata;
        _visibleChunkRange = Mathf.Max(1, (lod - 1));
        // if (lod >= TerrainClickLod)
        // {
        //     foreach (var t in terrains.Values)
        //     {
        //         t.GetComponent<Collider>().enabled = true;
        //     }
        // }
        // else
        // {
        //     foreach (var t in terrains.Values)
        //     {
        //         t.GetComponent<Collider>().enabled = false;
        //     }
        // }
    }
    public void AddOccupyPoints(Vector2Int p, Vector2Int size)
    {
        for (int y = p.y; y > p.y - size.y; y--)
        {
            for (int x = p.x; x > p.x - size.x; x--)
            {
                var t = new Vector2Int(x, y);
                if (scene.IsInMap(t))
                {
                    occupyPoints.Add(t);
                }
            }
        }
        
        HideObjectInRect(p, size);
    }

    public void RemoveOccupyPoints(Vector2Int p, Vector2Int size)
    {
        for (int y = p.y; y > p.y - size.y; y--)
        {
            for (int x = p.x; x > p.x - size.x; x--)
            {
                occupyPoints.Remove(new Vector2Int(x, y));
            }
        }
        
        ShowObjectsInRect(p, size);
    }
    
    private void HideObjectInRect(Vector2Int p, Vector2Int size)
    {
        var xMin = p.x - (size.x - 1);
        var xMax = xMin + (size.x - 1);
        var yMin = p.y - (size.y - 1);
        var yMax = yMin + (size.y - 1);
        
        foreach (var i in _objsDict.Values)
        {
            var oxMin = i.TilePos.x - ObjectExtents;
            var oxMax = i.TilePos.x + ObjectExtents;
            var oyMin = i.TilePos.y - ObjectExtents;
            var oyMax = i.TilePos.y + ObjectExtents;

            if (oxMin <= xMax && oxMax >= xMin && oyMin <= yMax && oyMax >= yMin)
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

        foreach (var i in _objsDict.Values)
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

    private void UpdateView()
    {
        if (!isLoadFinish)
            return;

        var cameraTilePos = scene.CurTilePos;
        var viewChunkCoord = TilePosToChunkCoord(cameraTilePos);
        
        if (_lastViewChunk != viewChunkCoord || _lastVisibleChunkRang != _visibleChunkRange)
        {
            _lastViewChunk = viewChunkCoord;
            _lastVisibleChunkRang = _visibleChunkRange;

            // 隐藏超出范围的物体
            int minX = viewChunkCoord.x - _visibleChunkRange;
            int maxX = viewChunkCoord.x + _visibleChunkRange;
            int minY = viewChunkCoord.y - _visibleChunkRange;
            int maxY = viewChunkCoord.y + _visibleChunkRange;

            foreach (var kv in _objsDict)
            {
                var obj = kv.Value;
                var chunkCoord = TilePosToChunkCoord(obj.TilePos);
                if (chunkCoord.x < minX || chunkCoord.x > maxX || chunkCoord.y < minY || chunkCoord.y > maxY)
                {
                    objsToRemove.Add(obj.Id);
                    obj.Unload();
                }
            }

            if (objsToRemove.Count > 0)
            {
                for (int i = 0; i < objsToRemove.Count; i++)
                {
                    _objsDict.Remove(objsToRemove[i]);
                }

                objsToRemove.Clear();
            }

            // 删除待创建列表里还没开始创建但超出显示范围的
            foreach (var kv in _createList)
            {
                var desc = kv.Value;
                var chunkCoord = TilePosToChunkCoord(scene.WorldToTile(desc.localPos));
                if (chunkCoord.x < minX || chunkCoord.x > maxX || chunkCoord.y < minY || chunkCoord.y > maxY)
                {
                    objsToRemove.Add(kv.Key);
                }
            }

            if (objsToRemove.Count > 0)
            {
                for (int i = 0; i < objsToRemove.Count; i++)
                {
                    _createList.Remove(objsToRemove[i]);
                }

                objsToRemove.Clear();
            }

            // 显示进入视野范围的物体
            for (int y = -_visibleChunkRange; y <= _visibleChunkRange; y++)
            {
                for (int x = -_visibleChunkRange; x <= _visibleChunkRange; x++)
                {
                    var chunkCoord = viewChunkCoord + new Vector2Int(x, y);
                    var chunkObjList = GetChunkObjList(chunkCoord);
                    if (chunkObjList != null)
                    {
                        for (int i = 0; i < chunkObjList.Count; i++)
                        {
                            var objDesc = chunkObjList[i];
                            var tilePos = scene.WorldToTile(objDesc.localPos);
                            if (!_objsDict.ContainsKey(objDesc.id)
                                && !_createList.ContainsKey(objDesc.id)
                                && !IsOccupied(tilePos))
                            {
                                _createList.Add(objDesc.id, objDesc);
                            }
                        }
                    }
                }
            }
        }
        
        //
        // 分帧加载
        //
        if (_createList.Count > 0)
        {
            int count = 0;
            foreach (var i in _createList)
            {
                var desc = i.Value;
                objsToRemove.Add(i.Key);
                if (!IsOccupied(scene.WorldToTile(desc.localPos)))
                {
                    var obj = new StaticObject(desc, desc.localPos);
                    if (!_objsDict.ContainsKey(obj.Id))
                    {
                        obj.Load(_parentNode);
                        _objsDict.Add(obj.Id, obj);
                    
                        count++;
                        if (count > CreateCountPerFrame)
                            break;
                    }
                    else
                    {
                        Log.Error("same key allready exist {0}, {1}", obj.Id, desc.id);
                    }
                }
            }
            
            for (int i = 0; i < objsToRemove.Count; i++)
            {
                _createList.Remove(objsToRemove[i]);
            }
            objsToRemove.Clear();
        }
    }

    private bool IsOccupied(Vector2Int p)
    {
        // var oxMin = p.x - ObjectExtents;
        // var oxMax = p.x + ObjectExtents;
        // var oyMin = p.y - ObjectExtents;
        // var oyMax = p.y + ObjectExtents;
        // for (int y = oyMin; y <= oyMax; y++)
        // {
        //     for (int x = oxMin; x <= oxMax; x++)
        //     {
        //         if (occupyPoints.Contains(new Vector2Int(x, y)))
        //             return true;
        //     }
        // }

        return false;
    }

    public bool IsTileWalkable(Vector2Int tilePos)
    {
        return true;
    }

    private Vector2Int TilePosToChunkCoord(Vector2Int tilePos)
    {
        return new Vector2Int(tilePos.x / TileCountPerChunk, tilePos.y / Mathf.CeilToInt((TileCountPerChunk *rate)));
    }
    
    public List<WorldSceneDesc.ObjectDesc> GetChunkObjList(Vector2Int chunkCoord)
    {
        if (_chunks.TryGetValue(chunkCoord, out var list))
            return list;
        return null;
    }

    public void SetVisibleChunk(int range)
    {
        _visibleChunkRange = range;
    }

    public void ToggleShow(bool t)
    {
        if (_parentNode != null)
        {
            _parentNode.gameObject.SetActive(t);
        }
    }
}