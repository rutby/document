using System;
using System.Collections.Generic;
using System.IO;
using GameFramework;
using UnityEngine;
using UnityEngine.Assertions;
using UnityGameFramework.Runtime;
using XLua;
using Object = UnityEngine.Object;

public class WorldMapZoneManager : WorldManagerBase
{
    private const string ZoneMapPrefab = "Assets/Main/Scenes/Zone/Prefab/ZoneMapRoot.prefab";
    private const string EdenZoneMapPrefab = "Assets/Main/Scenes/EdenZone/Prefab/ZoneMapRoot.prefab";
    public const string EdgeMeshPath = "Assets/Main/Scenes/Zone/Edge/edge_{0}_{1}.bytes";
    public const string EdenEdgeMeshPath = "Assets/Main/Scenes/EdenZone/Edge/edge_{0}_{1}.bytes";
    public const string WorldCityColorTable = "worldcity_color";
    private float _cityUiScaleUp = 2f;
    [NonSerialized] public Transform ZoneTemplate;
    private bool TestColor = false;
    private const float ZonePosToTilePos = 1;//(50 / 65.0f);

    private enum LoadState
    {
        None = 0,
        StartLoad = 1,
        Update = 2,
        Loaded = 3
    }

    private LoadState _loadState = LoadState.None;
    private WorldZoneTreeNode _findNode;

    public Dictionary<int, WorldZone> WorldZones { get; private set; } = new Dictionary<int, WorldZone>();


    private WorldZoneMapData _zoneMapData;
    private WorldZoneMapRoot _zoneMapRoot;
    private VEngine.Asset zoneAssert;
    private VEngine.Asset textAssert;
    public Transform EdgeRoot { get; private set; }
    public Transform ZoneRoot { get; private set; }
    private Dictionary<int, Dictionary<int, GameObject>> _edgeEntities;
    private AutoAdjustLod adjuster = null;

    private Transform _smallMap;


    private readonly List<WorldZone> _lastClippedZones = new List<WorldZone>();
    private List<WorldZone> _clippedZones = new List<WorldZone>();
    private readonly List<WorldZone> _lastClippedEdges = new List<WorldZone>();
    private List<WorldZone> _clippedEdges = new List<WorldZone>();

    public Dictionary<int, Vector4> zonePos = new Dictionary<int, Vector4>(128);


    private int _worldCityColorCount;
    private readonly Dictionary<int, WorldCityColor> _worldCityColors = new Dictionary<int, WorldCityColor>();

    private LuaTable _allianceCityLuaTable;

    private bool _functionOn = false;


    private Material _edgeMaterial1, _edgeMaterial2;
    private Material _zoneMaterial1, _zoneMaterial2;
    private static readonly Dictionary<Color, Material> CacheEdgeMat1 = new Dictionary<Color, Material>();
    private static readonly Dictionary<Color, Material> CacheEdgeMat2 = new Dictionary<Color, Material>();
    private Material _useMaterial;
    private int allianceCityCenterOffset = -3;
    private int allianceCityRange = 20;


    private bool isCurActive = true;
    private bool isSetActive = true;
    public Material GetEdgeMaterial(int matIdx, Color color)
    {
        var cache = matIdx == 0 ? CacheEdgeMat1 : CacheEdgeMat2;
        if (cache.TryGetValue(color, out var mat))
        {
            return mat;
        }

        var newMat = new Material(matIdx == 0 ? _edgeMaterial1 : _edgeMaterial2)
        {
            name = Time.frameCount.ToString(), color = color
        };
        cache.Add(color, newMat);

        return newMat;
    }


    public WorldMapZoneManager(WorldScene scene)
        : base(scene)
    {
    }

    private static bool IsFuncOpen()
    {
        var ret = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsAllianceCityOpen");
        Debug.LogFormat("#WorldZone#, IsFuncOpen = {0}", ret);
        return ret;
    }

    public override void Init()
    {
        Debug.LogFormat("#WorldZone#, Step in Init!");

        GameEntry.Event.Subscribe(EventId.WorldCityOwnerInfoReceived, OnCityOwnerInfoReceived);
        GameEntry.Event.Subscribe(EventId.WorldCityOwnerInfoChanged, OnCityOwnerInfoChanged);
        GameEntry.Event.Subscribe(EventId.ShowWorldZoneChangeColor, DoCityColorChange);

        world.AfterUpdate += OnCameraAfterUpdate;
        
        var cityRangeDiameter = GameEntry.Lua.CallWithReturnInt("CSharpCallLuaInterface.GetConfigNum", "NPC_city_range", "k2");
        if (cityRangeDiameter > 0)
        {
            allianceCityRange = cityRangeDiameter / 2;
        }

        LoadWorldCityColor();
        OnInitObject();
    }


    public override void UnInit()
    {
        OnRemoveObject();
        GameEntry.Event.Unsubscribe(EventId.WorldCityOwnerInfoReceived, OnCityOwnerInfoReceived);
        GameEntry.Event.Unsubscribe(EventId.WorldCityOwnerInfoChanged, OnCityOwnerInfoChanged);
        GameEntry.Event.Unsubscribe(EventId.ShowWorldZoneChangeColor, DoCityColorChange);

        world.AfterUpdate -= OnCameraAfterUpdate;
    }

    public void OnRemoveObject()
    {
        _allianceCityLuaTable?.Dispose();
        if (_zoneMapRoot != null)
        {
            Object.Destroy(_zoneMapRoot.gameObject);
            _zoneMapRoot = null;
        }
        if (zoneAssert != null)
        {
            GameEntry.Resource.UnloadAsset(zoneAssert);
            zoneAssert = null;
        }

        if (textAssert != null)
        {
            GameEntry.Resource.UnloadAsset(textAssert);
            textAssert = null;
        }

        foreach (var mat in CacheEdgeMat1.Values)
        {
            if (mat != null)
            {
                Object.Destroy(mat);
            }
        }
        CacheEdgeMat1.Clear();
        foreach (var mat in CacheEdgeMat2.Values)
        {
            if (mat != null)
            {
                Object.Destroy(mat);
            }
        }
        CacheEdgeMat2.Clear();
    }

    public void OnInitObject()
    {
        _functionOn = IsFuncOpen();
        if (!_functionOn)
        {
            return;
        }
        _loadState = LoadState.StartLoad;
        LoadMapDataFromFile(() =>
        {
            Debug.LogFormat("#WorldZone#, LoadMapDataFromFile Complete! ");
            if (_zoneMapData == null)
            {
                Debug.LogError("#WorldZone# _zoneMapData is null!");
                return;
            }

            Debug.LogFormat("#WorldZone# _zoneMapData.zone.Count={0}", _zoneMapData.zones.Count);

            _edgeEntities = new Dictionary<int, Dictionary<int, GameObject>>(_zoneMapData.zones.Count);
            //var request = GameEntry.Resource.LoadAssetAsync(ZoneMapPrefab, typeof(WorldZoneMapRoot));
            var path = ZoneMapPrefab;
            if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
            {
                path = EdenZoneMapPrefab;
            }

            if (_zoneMapRoot != null)
            {
                Object.Destroy(_zoneMapRoot.gameObject);
                _zoneMapRoot = null;
            }
            if (zoneAssert != null)
            {
                GameEntry.Resource.UnloadAsset(zoneAssert);
                zoneAssert = null;
            }
            zoneAssert = GameEntry.Resource.LoadAssetAsync(path, typeof(GameObject));
            if (zoneAssert == null)
            {
                Debug.LogError("#WorldZone# request is null!");
                return;
            }

            zoneAssert.completed += result =>
            {
                Debug.LogFormat("#WorldZone#, Load ZoneMapPrefab Complete! ");

                if (zoneAssert.isError)
                {
                    Debug.LogFormat("#WorldZone#, Load ZoneMapPrefab Error! Error={0}", zoneAssert.error);
                    return;
                }

                //_zoneMapRoot = Object.Instantiate(request.asset as WorldZoneMapRoot, world.Transform);
                var obj = Object.Instantiate(zoneAssert.asset as GameObject, world.Transform);
                _zoneMapRoot = obj.GetComponent<WorldZoneMapRoot>();

                _zoneMapRoot.transform.localScale = Vector3.one;
                ZoneRoot = _zoneMapRoot.transform.Find("ZoneRoot");
                EdgeRoot = _zoneMapRoot.transform.Find("EdgeRoot");
                ZoneTemplate = ZoneRoot.Find("ZoneTemplate");
                adjuster = _zoneMapRoot.GetComponent<AutoAdjustLod>();

                var meshRenderer = EdgeRoot.Find("MaterialHolder").GetComponent<MeshRenderer>();
                var materials = meshRenderer.materials;
                _edgeMaterial1 = materials[0];
                _edgeMaterial2 = materials[1];

                var collider = ZoneRoot.Find("Collider");
                collider.GetComponent<TouchObjectEventTrigger>().onPointerClick = OnBgClick;

                LoadZonePosFile();


                var oldState = _loadState;
                _loadState = LoadState.Loaded;
                //if (oldState == LoadState.Update)
                {
                    UpdateAllZoneOwner();
                }

                OnCameraAfterUpdate();
            };
        });
    }

    private bool IsInited()
    {
        return _loadState == LoadState.Loaded;
    }

    private void LoadWorldCityColor()
    {
        _worldCityColorCount =
            GameEntry.Lua.CallWithReturnInt("CSharpCallLuaInterface.GetDataTableCount", WorldCityColorTable);
        for (var i = 1; i <= _worldCityColorCount; i++)
        {
            var cityColor = new WorldCityColor(i);
            _worldCityColors.Add(i, cityColor);
        }
    }

    public void SetMapZoneActive(bool active)
    {
        isSetActive = active;
    }

    public int GetZoneIdByPosId(int pointId)
    {
        if (_zoneMapData != null)
        {
            var data = _zoneMapData.GetZoneByPosId(pointId);
            if (data != null)
            {
                return data.ZoneId;
            }
        }

        return 0;
    }

    public bool IsPointInAllianceCity(int pointId)
    {
        if (_zoneMapData == null)
            return false;
        
        var zoneId = GetZoneIdByPosId(pointId);
        var zoneData = _zoneMapData.GetZoneData(zoneId);
        var cityTilePos = TileCoord.IndexToTilePos(zoneData.CityPos, new Vector2Int(
            (_zoneMapData.width * ZonePosToTilePos).ToInt(), (_zoneMapData.height * ZonePosToTilePos).ToInt()));
        cityTilePos += new Vector2Int(allianceCityCenterOffset, allianceCityCenterOffset);
        var pos = world.IndexToTilePos(pointId);
        return Vector2Int.Distance(cityTilePos, pos) <= allianceCityRange;
    }

    public WorldCityColor GetWorldCityColor(int index)
    {
        return _worldCityColors.TryGetValue(index, out var ret) ? ret : null;
    }


    private void LoadZonePosFile()
    {
        zonePos.Clear();
        var asset = _zoneMapRoot.posAsset;
        using (var memStream = new MemoryStream())
        {
            var br = new BinaryReader(memStream);

            memStream.Write(asset.bytes, 0, asset.bytes.Length);
            memStream.Seek(0, SeekOrigin.Begin);

            var count = br.ReadUInt16();
            for (var i = 0; i < count; i++)
            {
                var zoneIndex = br.ReadUInt16();
                var x = br.ReadInt16();
                var y = br.ReadInt16();
                var w = br.ReadInt16();
                var h = br.ReadInt16();

                zonePos.Add(zoneIndex, new Vector4(x, y, w, h));
            }

            br.Close();
        }
    }

    public Vector4 GetZoneRect(int zoneIndex)
    {
        return zonePos.TryGetValue(zoneIndex, out var v) ? v : Vector4.zero;
    }

    private void LoadMapDataFromFile(Action callback)
    {
        var path = GameDefines.EntityAssets.WorldMapZone;
        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
        {
            path =  GameDefines.EntityAssets.WorldEdenMapZone;
        }

        if (textAssert != null)
        {
            GameEntry.Resource.UnloadAsset(textAssert);
            textAssert = null;
        }
        textAssert =
            GameEntry.Resource.LoadAssetAsync(path, typeof(TextAsset));
        textAssert.completed += req =>
        {
            var asset = req.asset as TextAsset;
            if (asset == null)
            {
                Debug.LogFormat("#WorldZone#, LoadMapDataFromFile Error! asset is null! ");
                GameEntry.Resource.UnloadAsset(textAssert);
                textAssert = null;
                return;
            }

            using (var memStream = new MemoryStream())
            {
                var br = new BinaryReader(memStream);

                memStream.Write(asset.bytes, 0, asset.bytes.Length);
                memStream.Seek(0, SeekOrigin.Begin);

                _zoneMapData = new WorldZoneMapData();
                _zoneMapData.Load(br);
                br.Close();

                _findNode = new WorldZoneTreeNode(new RectInt(0, 0, _zoneMapData.width, _zoneMapData.height));
                _findNode.CrateSubNodes(1);
                WorldZones.Clear();
                foreach (var zone in _zoneMapData.zones.Values)
                {
                    var zoneInfo = new WorldZone(this, zone);
                    WorldZones.Add(zoneInfo.index, zoneInfo);
                    _findNode.AddZone(zoneInfo);
                }

                UpdateAllZoneOwner();

                callback?.Invoke();
            }

            GameEntry.Resource.UnloadAsset(textAssert);
            textAssert = null;
        };
    }

    private void OnCameraAfterUpdate()
    {
        if (!IsInited())
            return;

        OnClip();
        if (_zoneMapRoot != null)
        {
            if (isCurActive != isSetActive)
            {
                isCurActive = isSetActive;
                _zoneMapRoot.gameObject.SetActive(isCurActive);
            }
        }
        
    }

    private void OnBgClick()
    {
        var tilepos = world.GetTouchTilePos();
        world.AutoLookat(world.TileToWorld(tilepos), world.Zoom,0.5f, () =>
        {
            world.AutoZoom(world.InitZoom,0.4f);
        });
    }

    private Vector3 _p0, _p1, _p2, _p3, _curPos;
    private readonly Vector2Int[] _camVerts = new Vector2Int[4];
    private Vector3 _lastCamPosition = Vector3.zero;
    private Rect _lastRect = Rect.zero;


    private void OnClip(object sender = null, GameEventArgs e = null)
    {
        var cam = world.Camera;

        var angle = cam.GetRotation().eulerAngles.x % 360;
        if (angle < 30 || angle > 95)
        {
            return;
        }

        _curPos = cam.GetPosition();
        if (_lastCamPosition == _curPos)
            return;

        _lastCamPosition = _curPos;

        _p0 = cam.GetRaycastGroundPoint(new Vector3(0, Screen.height));
        _p1 = new Vector3(_curPos.x + _curPos.x - _p0.x, 0, _p0.z);
        _p2 = cam.GetRaycastGroundPoint(new Vector3(0, 0));
        _p3 = new Vector3(_curPos.x + (_curPos.x - _p2.x), 0, _p2.z);
        _lastRect = new Rect(_p0.x, _p0.z, _p1.x - _p0.x, _p2.z - _p0.z);

        _camVerts[0] = world.WorldToTile(_p0);
        _camVerts[1] = world.WorldToTile(_p1);
        _camVerts[2] = world.WorldToTile(_p3);
        _camVerts[3] = world.WorldToTile(_p2);


        //var rect = new RectInt(camVerts[0].x, camVerts[0].y, camVerts[1].x - camVerts[0].x,camVerts[3].y - camVerts[0].y);

        var rect = new RectInt(
            Mathf.CeilToInt(_camVerts[0].x / ZonePosToTilePos),
            Mathf.CeilToInt(_camVerts[0].y / ZonePosToTilePos),
            Mathf.CeilToInt((_camVerts[1].x - _camVerts[0].x) / ZonePosToTilePos),
            Mathf.CeilToInt((_camVerts[3].y - _camVerts[0].y) / ZonePosToTilePos)
        );

        var camRot = cam.GetRotation().eulerAngles;
        if (_smallMap != null)
        {
            //smallMap.UpdateCameraRotation(camRot.x);
            //smallMap.UpdateCamView(camVerts);
        }

        if (adjuster != null)
        {
            if (adjuster.IsMainShow())
            {
                DoClipEdges(rect);
            }
            else
            {
                DoClipZones(rect, camRot);
            }
        }
    }

    private void CalcClipData(RectInt rect, ref List<WorldZone> zones)
    {
        if (_loadState == LoadState.Loaded && _findNode != null)
        {
            int count = 0;
            zones.Clear();
            _findNode.FindZone(rect, ref zones, ref count);
            //Debug.LogFormat("findNode => find = {0}, count = {1}", zones.Count, count);
        }
    }

    void DoClipEdges(RectInt rect)
    {
        // Log.Debug("#WorldZone#, DoClipZones! ");

        // 清除zone列表的状态
        if (_clippedZones.Count > 0)
        {
            foreach (var zone in _clippedZones)
            {
                zone.ToggleZone(false);
            }

            _clippedZones.Clear();
        }

        // 裁剪对象
        _lastClippedEdges.Clear();
        if (_clippedEdges.Count > 0)
        {
            _lastClippedEdges.AddRange(_clippedEdges);
            foreach (var zone in _lastClippedEdges)
            {
                zone.findState = -1;
            }
        }

        CalcClipData(rect, ref _clippedEdges);

        foreach (var zone in _lastClippedEdges)
        {
            // 出裁剪区域的对象
            if (zone.findState < 0)
            {
                //ToggleEdge(zone, false);
                //zone.ToggleEdge(false);
                zone.findState = 0;

                GameEntry.Event.Fire(EventId.AllianceCityOutView, (int)zone.data.ZoneId);
            }
        }

        foreach (var zone in _clippedEdges)
        {
            // 新裁剪进来的对象
            if (zone.findState > 0)
            {
                zone.ToggleEdge(true);
                zone.findState = 0;

                GameEntry.Event.Fire(EventId.AllianceCityInView, (int)zone.data.ZoneId);
            }

            zone.finded = false;
        }
    }

    void DoClipZones(RectInt rect, Vector3 camRot)
    {
        //Log.Debug("#WorldZone#, DoClipZones! ");

        // 清除 edges 列表的状态
        if (_clippedEdges.Count > 0)
        {
            foreach (var zone in _clippedEdges)
            {
                zone.ToggleEdge(false);
            }

            _clippedEdges.Clear();
        }

        // 裁剪对象
        _lastClippedZones.Clear();
        if (_clippedZones.Count > 0)
        {
            _lastClippedZones.AddRange(_clippedZones);
            foreach (var zone in _lastClippedZones)
            {
                zone.findState = -1;
            }
        }

        CalcClipData(rect, ref _clippedZones);

        foreach (var zone in _lastClippedZones)
        {
            // 出裁剪区域的对象
            if (zone.findState < 0)
            {
                zone.ToggleZone(false);

                zone.findState = 0;

                GameEntry.Event.Fire(EventId.AllianceCityOutView, (int)zone.data.ZoneId);
            }
        }

        //var ty1 = WorldCamera.LodArray[1]; //WorldCamera.GetLodArrayByIndex(5);
        //var scale = 1f + (curPos.y - ty1) * cityUIScaleUp / (world.Camera.ZoomMax - ty1);
        //var cityScale = new Vector3(0.2f * scale, 0.2f * scale, 0.2f * scale);
        foreach (var zone in _clippedZones)
        {
            // 新裁剪进来的对象
            if (zone.findState > 0)
            {
                zone.ToggleZone(true);

                zone.findState = 0;

                GameEntry.Event.Fire(EventId.AllianceCityInView, (int)zone.data.ZoneId);
            }

            zone.finded = false;
        }
    }

    //更新地块所需信息
    private List<int> UpdateAllZoneOwner()
    {
        var changes = new List<int>();

        if (!IsInited())
        {
            _loadState = LoadState.Update;
            return changes;
        }

        //if (_allianceCityLuaTable == null) //lua中每次更新table都先赋值为{} 地址重新分配了 需要重新get下
        {
            _allianceCityLuaTable =
                GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllianceCityList");
        }
        var needCheckColor = (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER);
        foreach (var zone in _zoneMapData.zones.Values)
        {
            var oldAllianceId = zone.AllianceId;
            var oldColor = zone.color;
            var ret = GetZoneOwnerAllianceInfo(zone.ZoneId, out var allianceId, out var color);
            if (!ret) //当前未被占领
            {
                zone.AllianceId = string.Empty;
                zone.color = TestColor ? UnityEngine.Random.Range(0, _worldCityColorCount) : -1;
                if (!oldAllianceId.Equals(zone.AllianceId))
                    changes.Add(zone.ZoneId);

                continue;
            }

            zone.AllianceId = allianceId;
            zone.color = color % _worldCityColorCount + 1;

            if (!oldAllianceId.Equals(zone.AllianceId))
            {
                changes.Add(zone.ZoneId);
            }
            else if(needCheckColor == true && oldColor !=zone.color)
            {
                changes.Add(zone.ZoneId);
            }
                
        }

        return changes;
    }

    private WorldZone GetWorldZoneInfoById(int zoneId)
    {
        if (WorldZones.TryGetValue(zoneId, out var info))
        {
            return info;
        }

        return null;
    }

    private bool GetZoneOwnerAllianceInfo(int zoneId, out string allianceId, out int color)
    {
        allianceId = string.Empty;
        color = 0;

        if (_allianceCityLuaTable == null || !_allianceCityLuaTable.ContainsKey(zoneId))
        {
            return false;
        }

        var table = _allianceCityLuaTable.Get<LuaTable>(zoneId);
        if (table == null)
        {
            Debug.LogError("GetZoneOwnerAllianceInfo Lua func return invalid format !!!");
            return false;
        }

        allianceId = table.Get<string>("allianceId");
        color = table.Get<int>("color");

        return true;
    }

    //城点所属信息首次接收 登录时下发
    private void OnCityOwnerInfoReceived(object o)
    {
        if (!_functionOn)
        {
            return;
        }

        OnCityOwnerInfoChanged();
    }

    //城点所属信息发生改变
    private void OnCityOwnerInfoChanged(object o = null)
    {
        Debug.Log("#WorldZone# step in OnCityOwnerInfoChanged!");

        if (!_functionOn)
        {
            return;
        }

        var changes = UpdateAllZoneOwner();
        Debug.Log($"#WorldZone# OnCityOwnerInfoChanged changedCount:{changes.Count}!");

        for (var i = 0; i < changes.Count; i++)
        {
            WorldZone zone = GetWorldZoneInfoById(changes[i]);
            if (zone == null)
                continue;

            WorldCityColor cfg = GetWorldCityColor(zone.data.color);
            if (zone.zoneRoot != null)
            {
                zone.SetZoneRenderParam(cfg);
            }

            zone.SetEdgeMaterial(cfg != null ? 1 : 0, cfg?.outlineColor ?? Color.white);
        }
    }


    private void DoCityColorChange(object o)
    {
        if (_functionOn && o != null)
        {
            if (o is string str)
            {
                var strArr = str.Split(';');
                if (strArr.Length >= 3)
                {
                    var cityId = strArr[0].ToInt();
                    var beforeColor = strArr[1].ToInt() % _worldCityColorCount + 1;
                    var afterColor = strArr[2].ToInt() % _worldCityColorCount + 1;
                    WorldZone zone = GetWorldZoneInfoById(cityId);
                    if (zone != null)
                    {
                        if (zone.zoneRoot != null)
                        {
                            zone.SetZoneChangeColor(beforeColor, afterColor);
                            return;
                        }
                    }
                }
            }
        }

        GameEntry.Event.Fire(EventId.UINoInput, 3);
    }


    public Texture2D[] GetTextures()
    {
        return _zoneMapRoot.splashTextures;
    }

    public float GetZoneScale()
    {
        return _zoneMapRoot.ZoneScale;
    }
}

public class WorldCityColor
{
    public Color outlineColor;
    public Color innerColor;
    public Color baseColor;
    public int splashIndex;

    public static Color ConvertToColor(string str)
    {
        if (!str.IsNullOrEmpty())
        {
            if (str[0] != '#')
                str = "#" + str;

            if (ColorUtility.TryParseHtmlString(str, out Color color))
                return color;
        }

        return Color.black;
    }

    public WorldCityColor(int xmlId)
    {
        const string functionName = "CSharpCallLuaInterface.GetTemplateData";
        const string tableName = WorldMapZoneManager.WorldCityColorTable;

        splashIndex = GameEntry.Lua.CallWithReturn<int, string, int, string>(functionName, tableName, xmlId, "splash");
        outlineColor =
            ConvertToColor(
                GameEntry.Lua.CallWithReturn<string, string, int, string>(functionName, tableName, xmlId,
                    "outlineColor"));
        innerColor =
            ConvertToColor(
                GameEntry.Lua.CallWithReturn<string, string, int, string>(functionName, tableName, xmlId,
                    "innerColor"));
        baseColor = ConvertToColor(
            GameEntry.Lua.CallWithReturn<string, string, int, string>(functionName, tableName, xmlId, "baseColor"));

        if (splashIndex > 0) splashIndex -= 1;
    }
}