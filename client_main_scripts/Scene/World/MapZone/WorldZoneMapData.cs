
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class WorldZoneData
{
    // 城点信息
    public short ZoneId { get; private set; }
    public int Level { get; private set; }
    public int PosType { get; private set; }
    public int CityPos { get; private set; }
    public int CityState { get; private set; }
    // public string Name { get; private set; }

    // 区域描边图信息
    public short X { get; private set; }
    public short Y { get; private set; }
    public short W { get; private set; }
    public short H { get; private set; }
    public short Cx { get; private set; }
    public short Cy { get; private set; }

    // 联盟信息
    public int color = -1;
    public string AllianceId = string.Empty;
    
    public List<int> edgeNeigbours { get; } = new List<int>();

    public List<ushort> Neigbours { get; private set; } = new List<ushort>();

    public List<int> edgeIdList;

    public bool IsNeighborZone(int zoneId)
    {
        return Neigbours.Contains((ushort)zoneId);
    }

    public void Load(BinaryReader br)
    {
        // 城点数据
        ZoneId = br.ReadInt16();
        Level = br.ReadInt32();
        PosType = br.ReadInt32();
        CityPos = br.ReadInt32() + 1;  // 服务器的位置id，从1开始，
        CityState = br.ReadInt32(); //visible
        // Name = GameEntry.DataTable.GetString(GameDefines.TableName.WorldCity, ZoneId.ToString(), "name");

        int i, tx, tz;
        int count = br.ReadInt32();
        Neigbours.Clear();
        Neigbours.Capacity = count;
        for (i = 0; i < count; i++)
        {
            Neigbours.Add(br.ReadUInt16());
        }

        // 区域描边图信息
        X = br.ReadInt16();
        Y = br.ReadInt16();
        W = br.ReadInt16();
        H = br.ReadInt16();
        Cx = br.ReadInt16();
        Cy = br.ReadInt16();

        // 边界的 Mesh 数据，为减小文件，uv 和 分段信息 需要加载后计算。
        //改为记录边界信息 通过边界id 加载已序列化的mesh文件
        count = br.ReadInt32();
        edgeIdList = new List<int>(count);
        for (i = 0; i < count; i++)
        {
            edgeIdList.Add(br.ReadInt16());
        }

        // EdgeNeigbours
        count = br.ReadInt32();
        edgeNeigbours.Clear();
        edgeNeigbours.Capacity = count;
        for (i = 0; i < count; i++)
        {
            edgeNeigbours.Add(br.ReadUInt16());
        }
        
    }
}

public class WorldZoneMapData
{
    //编辑器里一个格子对应真实5*5个格子
    private const float gridRange =1;
    public int width;
    public int height;
    public int scale;
    private const int gridSize = 1001;
    // 六角格所属城点数据
    short[] gridToZone;

    public Dictionary<int, WorldZoneData> zones = new Dictionary<int, WorldZoneData>(256);

    public void Load(BinaryReader br)
    {
        width = br.ReadInt32();
        height = br.ReadInt32();
        scale = br.ReadInt32();

        int i, count;
        count = br.ReadInt32();
        zones.Clear();
        for (i = 0; i < count; i++)
        {
            WorldZoneData zone = new WorldZoneData();
            zone.Load(br);
            zones.Add(zone.ZoneId, zone);
        }

        // 六角格归属信息
        count = br.ReadInt32();
        gridToZone = new short[count];
        count = br.ReadInt32();

        int begin;
        short len, sdx;
        for (i = 0; i < count; i++)
        {
            begin = br.ReadInt32();
            len = br.ReadInt16();
            sdx = br.ReadInt16();
            for (int k = 0; k < len; k++)
            {
                gridToZone[begin + k] = sdx;
            }
        }
    }

    // 获取城点区域信息
    public WorldZoneData GetZoneData(int zoneId)
    {
        if (zones.TryGetValue(zoneId, out WorldZoneData value))
        {
            return value;
        }
        return null;
    }

    // 获取位置所在的城点信息
    public WorldZoneData GetZoneByPosId(int pointId)
    {
        // if (gridToZone == null || pointId < 0)
        //     return null;
        //
        // //转下格子
        // int tmpId = (pointId - 1) / (gridRange * gridRange) + 1;
        // if (tmpId >= gridToZone.Length)
        // {
        //     return null;
        // }
        // var zoneId = gridToZone[tmpId];
        //
        // return GetZoneData(zoneId);
        //
        if (gridToZone == null || pointId < 0)
            return null;

        //转下格子
        //var Vec2 = SceneManager.World.IndexToTilePos(pointId);
        // var Vec2New = new Vector2Int((Vec2.x / gridRange).ToInt(), (Vec2.y / gridRange).ToInt());
        // var tmpId = Vec2New.x + Vec2New.y *gridSize;
        // if (tmpId >= gridToZone.Length)
        // {
        //     return null;
        // }
        var zoneId = gridToZone[pointId];
        return GetZoneData(zoneId);
    }
}