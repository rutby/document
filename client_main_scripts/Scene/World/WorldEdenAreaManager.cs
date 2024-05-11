
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using GameFramework;
using UnityEngine;
using UnityEngine.Profiling;
using XLua;

public class WorldEdenAreaManager : WorldManagerBase
{
    private WorldAreaMapData _areaMapData;
    private Dictionary<int,string> _alliancePassDic= new Dictionary<int, string>();
    public WorldEdenAreaManager(WorldScene scene) : base(scene)
    {
        
    }
    public override void Init()
    {
        base.Init();
        GameEntry.Event.Subscribe(EventId.WorldPassOwnerInfoReceived, OnPassOwnerInfoReceived);
        GameEntry.Event.Subscribe(EventId.WorldPassOwnerInfoChanged, OnPassOwnerInfoChanged);
        if (GameEntry.GlobalData.serverType != (int)ServerType.EDEN_SERVER)
        {
            return;
        }
        LoadMapDataFromFile(() =>
        {
            Debug.LogFormat("#WorldArea#, LoadMapDataFromFile Complete! ");
            if (_areaMapData == null)
            {
                Debug.LogError("#WorldArea# _areaMapData is null!");
                return;
            }

            InitPassData();
            Debug.LogFormat("#WorldArea# _areaMapData.areas.Count={0}", _areaMapData.areas.Count);
            OnPassOwnerInfoReceived();
        });
    }

    private void LoadMapDataFromFile(Action callback)
    {
        var path = GameDefines.EntityAssets.WorldEdenMapArea;
        var assetRequest = GameEntry.Resource.LoadAssetAsync(path, typeof(TextAsset));
        assetRequest.completed += req =>
        {
            var asset = req.asset as TextAsset;
            if (asset == null)
            {
                Debug.LogFormat("#WorldArea#, LoadMapDataFromFile Error! asset is null! ");
                req.Release();
                return;
            }

            using (var memStream = new MemoryStream())
            {
                var br = new BinaryReader(memStream);

                memStream.Write(asset.bytes, 0, asset.bytes.Length);
                memStream.Seek(0, SeekOrigin.Begin);

                _areaMapData = new WorldAreaMapData();
                _areaMapData.Load(br);
                br.Close();
                callback?.Invoke();
            }

            req.Release();
        };
    }

    private void InitPassData()
    {
        var areaDic = _areaMapData.areas;
        LuaTable templates = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetEdenPassTemplate");
        for (int i = 1; i <= templates.Length; i++)
        {
            LuaTable template = templates.Get<LuaTable>(i);
            var areaId = template.Get<int>("in_area");
            var outerAreaId =template.Get<int>("out_area");
            if (areaDic.ContainsKey(areaId))
            {
                var inAreaInfo = areaDic[areaId];
                EdenAreaOuterPoint inOuterPoint = new EdenAreaOuterPoint();
                inOuterPoint.Init(template,false,world);
                inAreaInfo.AddOuterPoint(inOuterPoint);
            }

            if (areaDic.ContainsKey(outerAreaId))
            {
                var outAreaInfo = areaDic[outerAreaId];
                EdenAreaOuterPoint outOuterPoint = new EdenAreaOuterPoint();
                outOuterPoint.Init(template,true,world);
                outAreaInfo.AddOuterPoint(outOuterPoint);
            }
            
            
        }
    }

    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.WorldPassOwnerInfoReceived, OnPassOwnerInfoReceived);
        GameEntry.Event.Unsubscribe(EventId.WorldPassOwnerInfoChanged, OnPassOwnerInfoChanged);
        base.UnInit();
    }

    public override void OnUpdate(float deltaTime)
    {
        base.OnUpdate(deltaTime);
    }
    
    private void OnPassOwnerInfoReceived(object o =null)
    {

        OnPassOwnerInfoChanged();
    }

    //城点所属信息发生改变
    private void OnPassOwnerInfoChanged(object o = null)
    {
        Debug.Log("#WorldArea# step in OnPassOwnerInfoChanged!");
        
        _alliancePassDic.Clear();
        var alliancePassLuaTable = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAlliancePassList");
        if (alliancePassLuaTable == null)
        {
            return;
        }

        for (int i = 1; i <= alliancePassLuaTable.Length; ++i)
        {
            var luaTab = alliancePassLuaTable.Get<LuaTable>(i);
            var allianceId = luaTab.Get<string>("allianceId");
            var passId = luaTab.Get<int>("cityId");
            if (!_alliancePassDic.ContainsKey(passId) && allianceId.IsNullOrEmpty()==false)
            {
                _alliancePassDic.Add(passId,allianceId);
            }
        }
    }
    public int GetAreaIdByPosId(int pointId)
    {
        if (_areaMapData!= null)
        {
            var data = _areaMapData.GetAreaByPosId(pointId);
            if (data != null)
            {
                return data.GetAreaId();
            }
        }

        return 0;
    }

    public EdenAreaInfo GetEdenAreaInfo(int areaId)
    {
        if (_areaMapData!= null)
        {
           return _areaMapData.GetAreaData(areaId);
        }

        return null;
    }

    public string FindingPath(int startIndex, int endIndex)
    {
        var startArea = GetAreaIdByPosId(startIndex);
        var endArea = GetAreaIdByPosId(endIndex);
        if (startArea == endArea)
        {
            var str = startIndex + ";" + endIndex;
            return str;
        }

        var startAreaInfo = GetEdenAreaInfo(startArea);
        if (startAreaInfo == null)
        {
            Log.Error("find path err : start eden area not exist :{0}", startArea);
            return "";
        }
        var endAreaInfo = GetEdenAreaInfo(endArea);
        if (endAreaInfo == null)
        {
            Log.Error("find path err : end eden area not exist :{0}", endArea);
            return "";
        }
        var allianceId = GameEntry.Data.Player.GetAllianceId();
        Profiler.BeginSample("Eden Find");
        Dictionary<int,EdenPathFindNode> nodeMap = new Dictionary<int, EdenPathFindNode>();
        var openList = new List<EdenPathFindNode>();
        var closeList = new HashSet<EdenPathFindNode>();
        EdenPathFindNode node;
        if (nodeMap.ContainsKey(startAreaInfo.GetAreaId()))
        {
            node = nodeMap[startAreaInfo.GetAreaId()];
        }
        else
        {
            node = new EdenPathFindNode(startAreaInfo);
            nodeMap.Add(startAreaInfo.GetAreaId(),node);
        }
        node.SetLastOutPoint(world.IndexToTilePos(startIndex));
        openList.Add(node);
        var hasFind = false;
        while (openList.Count > 0)
        {
            node = openList[0];
            openList.RemoveAt(0);
            closeList.Add(node);
            if (node.getAreaInfo().GetAreaId() == endAreaInfo.GetAreaId())
            {
                hasFind = true;
                break;
            }

            var outPointDic = node.getAreaInfo().GetOuterPointMap();
            foreach (var outerArea in outPointDic.Keys)
            {
                EdenAreaOuterPoint nextPass = FindWalkableNearestPass(outerArea, node.GetLastOutPoint(), allianceId, node.getAreaInfo());
                if (nextPass == null)
                {
                    continue;
                }
                EdenPathFindNode findNode;
                var nextAreaInfo = GetEdenAreaInfo(outerArea);
                if (nextAreaInfo == null)
                {
                    continue;
                }
                if (nodeMap.ContainsKey(nextAreaInfo.GetAreaId()))
                {
                    findNode = nodeMap[nextAreaInfo.GetAreaId()];
                }
                else
                {
                    findNode = new EdenPathFindNode(nextAreaInfo);
                    nodeMap.Add(nextAreaInfo.GetAreaId(),findNode);
                }

                if (closeList.Contains(findNode))
                {
                    continue;
                }

                var gCostAndOutPoint = CalGCost(node.GetLastOutPoint(), nextPass);
                float gCost = node.GetgCost() + gCostAndOutPoint.Item1;
                if (openList.Contains(findNode) == false || gCost < findNode.GetgCost())
                {
                    findNode.SetgCost(gCost);
                    findNode.SetLastOutPoint(gCostAndOutPoint.Item2);
                    findNode.SetAreaOuterPoint(nextPass);
                    findNode.setParent(node);
                    if (openList.Contains(findNode) == false)
                    {
                        openList.Add(findNode);
                        openList.Sort((a, b) => a.GetgCost().CompareTo(b.GetgCost()));
                    }
                }
            }
        }

        if (hasFind)
        {
            var pathList = GenPath(node, world.IndexToTilePos(endIndex),world.IndexToTilePos(startIndex));
            var pathStr = "";
            for (int i = 0; i <= pathList.Count - 1; ++i)
            {
                pathStr += world.TilePosToIndex(pathList[i]);
                if (i < pathList.Count-1)
                {
                    pathStr += ";";
                }
            }

            return pathStr;
        }

        return "";
    }
    
    private EdenAreaOuterPoint FindWalkableNearestPass(int nextArea, Vector2Int startPoint, String allianceId,EdenAreaInfo curArea)
    {
        if (curArea.GetOuterPointMap() == null)
        {
            return null;
        }
        List<EdenAreaOuterPoint> outerPointList = curArea.GetOuterPointMap()[nextArea];
        if (outerPointList == null || outerPointList.Count<=0)
        {
            return null;
        }
        List<EdenAreaOuterPoint> walkablePassList = new List<EdenAreaOuterPoint>();
        foreach (var outerPoint in outerPointList)
        {
            if (outerPoint.GetPassType() == PassType.NONE_CITY_PASS)
            {
                walkablePassList.Add(outerPoint);
                continue;
            }

            if (outerPoint.GetPassType() == PassType.ALLIANCE_CITY_PASS)
            {
                if (_alliancePassDic.ContainsKey(outerPoint.GetRelatedCityId()))
                {
                    var tempAllianceId = _alliancePassDic[outerPoint.GetRelatedCityId()];
                    if (tempAllianceId == allianceId ||GameEntry.Data.Player.IsAllianceSelfCamp(tempAllianceId))
                    {
                        walkablePassList.Add(outerPoint); 
                        continue;
                    }
                }
            }
        }

        if (walkablePassList.Count<=0)
        {
            return null;
        }
        walkablePassList.Sort((a, b) =>
        {
            float aLength = SceneManager.World.TileDistance(startPoint, a.GetInnerPointList()[0]);
            float bLength = SceneManager.World.TileDistance(startPoint, b.GetInnerPointList()[0]);
            return aLength.CompareTo(bLength);
        });
        return walkablePassList[0];
    }
    private Tuple<float, Vector2Int> CalGCost(Vector2Int startPoint, EdenAreaOuterPoint nextPass)
    {
        var inPoint = nextPass.GetInnerPointList()[0];
        var outPoint = nextPass.GetOuterPointList()[0];
        var dis = SceneManager.World.TileDistance(startPoint, inPoint);
        return new Tuple<float, Vector2Int>(dis, outPoint);
    }
    private List<Vector2Int> GenPath(EdenPathFindNode node, Vector2Int end,Vector2Int start)
    {
        var calPointId = end;
        List<Vector2Int> path = new List<Vector2Int>();
        path.Add(end);
        while (node != null)
        {
            var beforeNode = node.getParent();
            if (beforeNode != null)
            {
                var innerAndOutPoint = node.FindNearestInnerPointAndOutPoint(calPointId, node.GetAreaOuterPoint());
                calPointId = innerAndOutPoint.Item2;
                path.Add(innerAndOutPoint.Item1);
                path.Add(innerAndOutPoint.Item2);
            }
            node = beforeNode;
        }
        path.Add(start);
        path.Reverse();
        return path;
    }
}

public class EdenPathFindNode
{
    private EdenAreaInfo areaInfo;
    private EdenPathFindNode parent;

    private Vector2Int lastOutPoint;

    private EdenAreaOuterPoint areaOuterPoint;

    private float fCost;

    private float gCost;

    public EdenPathFindNode(EdenAreaInfo areaInfo)
    {
        this.areaInfo = areaInfo;
    }

    public EdenAreaInfo getAreaInfo()
    {
        return areaInfo;
    }

    public EdenPathFindNode getParent()
    {
        return parent;
    }

    public float getfCost()
    {
        return fCost;
    }

    public void setParent(EdenPathFindNode parent)
    {
        this.parent = parent;
    }

    public void setfCost(float fCost)
    {
        this.fCost = fCost;
    }

    public float GetgCost()
    {
        return gCost;
    }

    public void SetgCost(float gCost)
    {
        this.gCost = gCost;
    }

    public Vector2Int GetLastOutPoint()
    {
        return lastOutPoint;
    }

    public void SetLastOutPoint(Vector2Int pos)
    {
        lastOutPoint = pos;
    }

    public EdenAreaOuterPoint GetAreaOuterPoint()
    {
        return areaOuterPoint;
    }

    public void SetAreaOuterPoint(EdenAreaOuterPoint areaOuterPoint)
    {
        this.areaOuterPoint = areaOuterPoint;
    }
    public Tuple<Vector2Int, Vector2Int> FindNearestInnerPointAndOutPoint(Vector2Int startPoint,
        EdenAreaOuterPoint pass)
    {
        int index = 0;
        float minDistance = float.MaxValue;
        // 倒着处理
        List<Vector2Int> innerList = pass.GetOuterPointList();
        for (int i = 0; i < innerList.Count; i++)
        {
            float dis = SceneManager.World.TileDistance(startPoint, innerList[i]);
            if (dis < minDistance)
            {
                minDistance = dis;
                index = i;
            }
        }

        return new Tuple<Vector2Int, Vector2Int>(pass.GetOuterPointList()[index], pass.GetInnerPointList()[index]);
    }
    
    
}

public enum PassType
{
    DEFAULT = 0,
    NONE_CITY_PASS = 1,
    ALLIANCE_CITY_PASS = 2,
    
}
    // 伊甸园相关 区块出口
public class EdenAreaOuterPoint
{
    private int passId;
    private PassType passType;
    private int relatedCityId;
    private int areaId;
    private int outerAreaId;
    private List<Vector2Int> innerPointList = new List<Vector2Int>();
    private List<Vector2Int> outerPointList = new List<Vector2Int>();

    public EdenAreaOuterPoint()
    {
    }

    public void Init(LuaTable template, bool trans,WorldScene scene)
    {
        passId = template.Get<int>("id");
        passType = (PassType)(template.Get<int>("type"));
        if (passType == PassType.DEFAULT)
        {
            throw new Exception("pass type is DEFAULT " + passId);
        }

        if (passType == PassType.ALLIANCE_CITY_PASS)
        {
            relatedCityId = template.Get<int>("cityid");
        }

        if (trans)
        {
            areaId = template.Get<int>("out_area");
            outerAreaId =template.Get<int>("in_area");
            String[] inPointList = template.Get<string>("out_area_point").Split('|');
            foreach (var inPoint in inPointList)
            {
                var pointId = inPoint.ToInt();
                innerPointList.Add(scene.IndexToTilePos(pointId));
            }
            String[] outPointList = template.Get<string>("in_area_point").Split('|');
            foreach (var outPoint in outPointList)
            {
                var pointId = outPoint.ToInt();
                outerPointList.Add(scene.IndexToTilePos(pointId));
            }
        }
        else
        {
            areaId = template.Get<int>("in_area");
            outerAreaId =template.Get<int>("out_area");
            String[] inPointList = template.Get<string>("in_area_point").Split('|');
            foreach (var inPoint in inPointList)
            {
                var pointId = inPoint.ToInt();
                innerPointList.Add(scene.IndexToTilePos(pointId));
            }
            String[] outPointList = template.Get<string>("out_area_point").Split('|');
            foreach (var outPoint in outPointList)
            {
                var pointId = outPoint.ToInt();
                outerPointList.Add(scene.IndexToTilePos(pointId));
            }
        }

        if (areaId == outerAreaId)
        {
            throw new Exception("area id is same as outerArea " + passId);
        }

        if (innerPointList.Count<=0 || innerPointList.Count != outerPointList.Count)
        {
            throw new Exception("pass point list is err :  " + passId);
        }

    }

    public int GetPassId()
    {
        return passId;
    }

    public PassType GetPassType()
    {
        return passType;
    }

    public int GetRelatedCityId()
    {
        return relatedCityId;
    }

    public int GetAreaId()
    {
        return areaId;
    }

    public int GetOuterAreaId()
    {
        return outerAreaId;
    }

    public List<Vector2Int> GetInnerPointList()
    {
        return innerPointList;
    }

    public List<Vector2Int> GetOuterPointList()
    {
        return outerPointList;
    }
    
}
    // 伊甸园相关 区域数据
public class EdenAreaInfo
{
    private int areaId;
    private Dictionary<int, List<EdenAreaOuterPoint>> outerPointMap = new Dictionary<int, List<EdenAreaOuterPoint>>();
    public EdenAreaInfo()
    {
    }
    public void Load(BinaryReader br)
    {
        // 城点数据
        areaId = br.ReadInt16();
        var Level = br.ReadInt32();
        var PosType = br.ReadInt32();
        var CityPos = br.ReadInt32() + 1;  // 服务器的位置id，从1开始，
        var CityState = br.ReadInt32(); //visible
        // Name = GameEntry.DataTable.GetString(GameDefines.TableName.WorldCity, ZoneId.ToString(), "name");

        int i, tx, tz;
        int count = br.ReadInt32(); 
        List<ushort> Neigbours = new List<ushort>();
        Neigbours.Clear();
        Neigbours.Capacity = count;
        for (i = 0; i < count; i++)
        {
            Neigbours.Add(br.ReadUInt16());
        }

        // 区域描边图信息
        var X = br.ReadInt16();
        var Y = br.ReadInt16();
        var W = br.ReadInt16();
        var H = br.ReadInt16();
        var Cx = br.ReadInt16();
        var Cy = br.ReadInt16();

        // 边界的 Mesh 数据，为减小文件，uv 和 分段信息 需要加载后计算。
        //改为记录边界信息 通过边界id 加载已序列化的mesh文件
        count = br.ReadInt32();
        var edgeIdList = new List<int>(count);
        for (i = 0; i < count; i++)
        {
            edgeIdList.Add(br.ReadInt16());
        }

        // EdgeNeigbours
        count = br.ReadInt32(); 
        List<int> edgeNeigbours = new List<int>();
        edgeNeigbours.Clear();
        edgeNeigbours.Capacity = count;
        for (i = 0; i < count; i++)
        {
            edgeNeigbours.Add(br.ReadUInt16());
        }
    }

    public void AddOuterPoint(EdenAreaOuterPoint outerPoint)
    {
        List<EdenAreaOuterPoint> outPointList;
        if (outerPointMap.ContainsKey(outerPoint.GetOuterAreaId()))
        {
            outPointList = outerPointMap[outerPoint.GetOuterAreaId()];
        }
        else
        {
            outPointList = new List<EdenAreaOuterPoint>();
            outerPointMap.Add(outerPoint.GetOuterAreaId(),outPointList);
        }
        outPointList.Add(outerPoint);
    }

    public int GetAreaId()
    {
        return areaId;
    }
    

    public Dictionary<int, List<EdenAreaOuterPoint>> GetOuterPointMap()
    {
        return outerPointMap;
    }
}

public class WorldAreaMapData
{
    //编辑器里一个格子对应真实5*5个格子
    private const float gridRange =1;
    public int width;
    public int height;
    public int scale;
    private const int gridSize = 1001;
    // 六角格所属城点数据
    short[] gridToArea;

    public Dictionary<int, EdenAreaInfo> areas = new Dictionary<int, EdenAreaInfo>(256);

    public void Load(BinaryReader br)
    {
        width = br.ReadInt32();
        height = br.ReadInt32();
        scale = br.ReadInt32();

        int i, count;
        count = br.ReadInt32();
        areas.Clear();
        for (i = 0; i < count; i++)
        {
            EdenAreaInfo zone = new EdenAreaInfo();
            zone.Load(br);
            areas.Add(zone.GetAreaId(), zone);
        }

        // 六角格归属信息
        count = br.ReadInt32();
        gridToArea = new short[count];
        count = br.ReadInt32();

        int begin;
        int len;
        short sdx;
        for (i = 0; i < count; i++)
        {
            begin = br.ReadInt32();
            len = br.ReadInt32();
            sdx = br.ReadInt16();
            for (int k = 0; k < len; k++)
            {
                gridToArea[begin + k] = sdx;
            }
        }
    }

    // 获取城点区域信息
    public EdenAreaInfo GetAreaData(int zoneId)
    {
        if (areas.TryGetValue(zoneId, out EdenAreaInfo value))
        {
            return value;
        }
        return null;
    }

    // 获取位置所在的城点信息
    public EdenAreaInfo GetAreaByPosId(int pointId)
    {
        if (gridToArea == null || pointId < 0)
            return null;
        var areaId = gridToArea[pointId];
        return GetAreaData(areaId);
    }
}


