//
// PVE关卡静态装饰物管理
//

using System.Collections.Generic;
using System.Linq;
using GameFramework;
using UnityEngine;
using VEngine;

public class PVEStaticManager
{
    private int _createCountPerFrame = 20;
    private int _tileCountPerChunk = 20;
    private Transform _parentNode;
    private WorldSceneDesc _sceneDesc;
    private List<VEngine.Asset> _descAsset;
    private Dictionary<int, StaticObject> _objsDict = new Dictionary<int, StaticObject>();
    private Dictionary<int, WorldSceneDesc.ObjectDesc> _createList = new Dictionary<int, WorldSceneDesc.ObjectDesc>();
    private List<int> objsToRemove = new List<int>();

    private Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>> _chunks = new Dictionary<Vector2Int, List<WorldSceneDesc.ObjectDesc>>();

    private Dictionary<int, PrefabLightmapData.RendererInfo> lightMapData = new Dictionary<int, PrefabLightmapData.RendererInfo>();

    private Vector2Int _lastViewChunk;
    private int _visibleChunkRange = 1;
    private int _lastVisibleChunkRange = 1;
    private bool useLightMap = false;

    private int _loadCount = 0;
    private int _finishCount = 0;

    private int _lwObjId = 0;
    class StaticObject
    {
        public StaticObject(WorldSceneDesc.ObjectDesc desc, Vector3 pos)
        {
            this.desc = desc;
            position = pos;
            tilePos = TileCoord.WorldToTile(pos);
            isVisible = true;
        }

        public void Load(Transform parent,bool useLightMap, Dictionary<int, PrefabLightmapData.RendererInfo> lightMapData)
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
                if(useLightMap)
                {
                    ApplyLightMap(lightMapData, desc.id);
                }
                gameObject.SetActive(isVisible);
            };
        }
        void ApplyLightMap(Dictionary<int, PrefabLightmapData.RendererInfo> lightMapData,int id)
        {
            if (lightMapData.ContainsKey(id))
            {
                var info = lightMapData[id];
                var renderer = gameObject.GetComponentInChildren<MeshRenderer>();
                if (renderer != null)
                {
                    renderer.lightmapIndex = info.lightmapIndex;
                    renderer.lightmapScaleOffset = info.lightmapOffsetScale;
                }
            }
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

    public void InitLightMapConfig(string jsonStr)
    {
        lightMapData.Clear();
        if (GameEntry.Resource.HasAsset(jsonStr))
        {
            var lightMap =  GameEntry.Resource.LoadAsset(jsonStr, typeof(TextAsset));
            if(lightMap!=null)
            {
                
                var txt = lightMap.asset.ToString();
                var infos = txt.Split(';');
                for(int i=0;i<infos.Length-1;i++)
                {
                    var str = infos[i];
                    if (str.IsNullOrEmpty() == false)
                    {
                        var info = infos[i].Split(':');
                        if (info[0].IsNullOrEmpty() == false)
                        {
                            if(info[0]==string.Empty)
                            {
                                continue;
                            }
                            int id = System.Convert.ToInt32(info[0]);
                            int index = System.Convert.ToInt32(info[1]);
                            var offsets = info[2].Split(',');
                            Vector4 vOffset = new Vector4(System.Convert.ToSingle(offsets[0]), System.Convert.ToSingle(offsets[1]), System.Convert.ToSingle(offsets[2]), System.Convert.ToSingle(offsets[3]));
                            Log.Debug("Init offset"+ vOffset);
                            PrefabLightmapData.RendererInfo t = new PrefabLightmapData.RendererInfo
                            {
                                lightmapIndex = index,
                                lightmapOffsetScale = vOffset
                            };
                            if(!lightMapData.ContainsKey(id))
                            {
                                lightMapData.Add(id, t);
                            }
                        }
                    }
                    
                
                }
                useLightMap = true;

            }
        }
       
    }
    public void Init(string descPath, int tileCountPerChunk, int createCountPerFrame)
    {
        _parentNode = new GameObject("PVEStatic").transform;
        _lastViewChunk = new Vector2Int(int.MinValue, int.MinValue);
        _tileCountPerChunk = tileCountPerChunk;
        _createCountPerFrame = createCountPerFrame;
        _descAsset = new List<Asset>();
        _sceneDesc = new WorldSceneDesc();
        _loadCount = 0;
        _finishCount = 0;
        if (!string.IsNullOrEmpty(descPath))
        {
            Append(descPath,0);
        }
    }

    public void InitLW(int tileCountPerChunk, int createCountPerFrame)
    {
        _parentNode = new GameObject("PVEStatic").transform;
        _lastViewChunk = new Vector2Int(int.MinValue, int.MinValue);
        _tileCountPerChunk = tileCountPerChunk;
        _createCountPerFrame = createCountPerFrame;
        _descAsset = new List<Asset>();
        _sceneDesc = new WorldSceneDesc();
        _loadCount = 0;
        _finishCount = 0;
        _lwObjId = 10000;
    }

    public void Append(string descPath,float offset)
    {
        _loadCount++;
        var req = GameEntry.Resource.LoadAssetAsync(descPath, typeof(TextAsset));
        _descAsset.Add(req);
        req.completed += delegate
        {
            _finishCount++;
            
            var textAsset = req.asset as TextAsset;
            var descs = _sceneDesc.LoadWithReturn(textAsset.bytes);

            // 装饰物分区
            for (int i = 0; i < descs.Count; i++)
            {
                var objDesc = descs[i];
                objDesc.id = ++_lwObjId;
                objDesc.localPos = objDesc.localPos + new Vector3(0, 0, offset);
                var chunkCoord = TilePosToChunkCoord(TileCoord.WorldToTile(objDesc.localPos));
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
            
            req.Release();
            _descAsset.Remove(req);
        };
    }
    
    public void UnInit()
    {
        if (_descAsset != null)
        {
            for (int i = 0; i < _descAsset.Count; i++)
            {
                _descAsset[i].Release(); 
            }
            _descAsset = null;
        }
        
        foreach (var kv in _objsDict)
        {
            kv.Value.Unload();
        }
        _objsDict.Clear();
        
        Object.Destroy(_parentNode.gameObject);
        _parentNode = null;
        
        _createList.Clear();
        _chunks.Clear();
        _sceneDesc = null;
    }
    
    public void OnUpdate(int viewX, int viewY)
    {
        UpdateView(viewX, viewY);
    }

    private void UpdateView(int viewX, int viewY)
    {
        if (_loadCount > _finishCount)
            return;

        var cameraTilePos = new Vector2Int(viewX, viewY);
        var viewChunkCoord = TilePosToChunkCoord(cameraTilePos);
        
        if (_lastViewChunk != viewChunkCoord || _lastVisibleChunkRange != _visibleChunkRange)
        {
            _lastViewChunk = viewChunkCoord;
            _lastVisibleChunkRange = _visibleChunkRange;

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
                var chunkCoord = TilePosToChunkCoord(TileCoord.WorldToTile(desc.localPos));
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

            var mainPos = TileCoord.TileToWorld(cameraTilePos);
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
                            if (!_objsDict.ContainsKey(objDesc.id)
                                && !_createList.ContainsKey(objDesc.id))
                            {
                                objDesc.distance = Vector3.Distance(mainPos, objDesc.localPos);
                                _createList.Add(objDesc.id, objDesc);
                            }
                        }
                    }
                }
            }
        }

        if (_createList.Count > 0)
        {
            var list = _createList.Values.ToList();
            list.Sort((a, b) =>
            {
                if (a.distance > b.distance)
                {
                    return 1;
                }
                else if (a.distance < b.distance)
                {
                    return -1;
                }

                return 0;
            });
            int count = 0;
            for (int i = 0; i < list.Count; ++i)
            {
                var desc = list[i];
                objsToRemove.Add(desc.id);

                var obj = new StaticObject(desc, desc.localPos);
                if (!_objsDict.ContainsKey(obj.Id))
                {
                    obj.Load(_parentNode, useLightMap, lightMapData);
                    _objsDict.Add(obj.Id, obj);

                    count++;
                    if (count > _createCountPerFrame)
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
    

    private Vector2Int TilePosToChunkCoord(Vector2Int tilePos)
    {
        return new Vector2Int(tilePos.x / _tileCountPerChunk, tilePos.y / _tileCountPerChunk);
    }
    
    private List<WorldSceneDesc.ObjectDesc> GetChunkObjList(Vector2Int chunkCoord)
    {
        if (_chunks.TryGetValue(chunkCoord, out var list))
            return list;
        return null;
    }

    public void SetVisibleChunk(int range)
    {
        _visibleChunkRange = range;
    }
    
}