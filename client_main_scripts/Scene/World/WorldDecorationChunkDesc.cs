using System.Collections.Generic;
// using System.Diagnostics;
using System.IO;
using UnityEngine;
// using Debug = UnityEngine.Debug;

/// <summary>
/// 地图装饰物每块数据
/// </summary>
public class WorldDecorationChunkDesc
{
    private List<WorldSceneDesc.ObjectDesc> _objectDescList;

    public Vector2Int chunkCoord { get; private set; }

    public List<WorldSceneDesc.ObjectDesc> objectDescList => _objectDescList;

    private int _cacheListCount;
    private byte[] _cacheData;

    public WorldDecorationChunkDesc(Vector2Int coord)
    {
        chunkCoord = coord;
        _objectDescList = new List<WorldSceneDesc.ObjectDesc>(64);
    }

    public WorldDecorationChunkDesc()
    {
    }

    public void Add(WorldSceneDesc.ObjectDesc objDesc)
    {
        _objectDescList.Add(objDesc);
    }

    public void Save(BinaryWriter writer)
    {
        var coord = chunkCoord;
        writer.Write(coord.x);
        writer.Write(coord.y);
        var list = _objectDescList;
        writer.Write(list.Count);
        for (int i = 0, c = list.Count; i < c; i++)
        {
            list[i].SaveWorldOptimize(writer);
        }
    }

    public void Load(BinaryReader reader, int objectDescByteCount)
    {
        int coordX = reader.ReadInt32();
        int coordY = reader.ReadInt32();
        chunkCoord = new Vector2Int(coordX, coordY);

        int listCount = reader.ReadInt32();
        _cacheListCount = listCount;
        if (_cacheListCount > 0)
        {
            _cacheData = reader.ReadBytes(listCount * objectDescByteCount);
        }

    }

    public List<WorldSceneDesc.ObjectDesc> GetChunkObjList(int extends)
    {
        if (_cacheData != null)
        {
            // System.Diagnostics.Stopwatch stopwatch = new Stopwatch();
            // stopwatch.Start();
            UnityEngine.Profiling.Profiler.BeginSample("WorldDecorationChunk.Load");
            _objectDescList = new List<WorldSceneDesc.ObjectDesc>(_cacheListCount);

            using (var reader = new BinaryReader(new MemoryStream(_cacheData)))
            {
                for (int i = 0; i < _cacheListCount; i++)
                {
                    var objDesc = new WorldSceneDesc.ObjectDesc();

                    objDesc.LoadWorldOptimize(reader, extends);

                    _objectDescList.Add(objDesc);
                }
            }

            _cacheData = null;
            
            UnityEngine.Profiling.Profiler.EndSample();
            // stopwatch.Stop();
            // Debug.LogError(
            //     $"WorldDecorationChunkLoad time:{stopwatch.ElapsedMilliseconds}ms ticks:{stopwatch.ElapsedTicks}");
        }

        return _objectDescList;
    }
}
