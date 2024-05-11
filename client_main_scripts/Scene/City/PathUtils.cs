using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using XLua;
using Random = UnityEngine.Random;

public class PathInfo
{
    public string type;
    public string uuid;
    public List<Vector2Int> path;
}

public class PathUtils
{
    private static string PathToString(List<Vector2Int> path)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < path.Count; i++)
        {
            if (i != 0)
            {
                sb.Append(";");
            }

            sb.Append(PointToString(path[i]));
        }

        return sb.ToString() + ";";
    }

    private static string PointToString(Vector2Int pos)
    {
        return string.Format("{0},{1}", pos.x, pos.y);
    }

    private static readonly Dictionary<Vector2Int, Vector2Int> MainRoundEntryOffset =
        new Dictionary<Vector2Int, Vector2Int>()
        {
            { new Vector2Int(3, 2), new Vector2Int(2, 2) },
            { new Vector2Int(3, 1), new Vector2Int(2, 1) },
            { new Vector2Int(3, 0), new Vector2Int(2, 0) },
            { new Vector2Int(3, -1), new Vector2Int(2, -1) },
            { new Vector2Int(3, -2), new Vector2Int(2, -2) },
            { new Vector2Int(2, -3), new Vector2Int(2, -2) },
            { new Vector2Int(1, -3), new Vector2Int(1, -2) },
            { new Vector2Int(0, -3), new Vector2Int(0, -2) },
            { new Vector2Int(-1, -3), new Vector2Int(-1, -2) },
            { new Vector2Int(-2, -3), new Vector2Int(-2, -2) },
            { new Vector2Int(-3, -2), new Vector2Int(-2, -2) },
            { new Vector2Int(-3, -1), new Vector2Int(-2, -1) },
            { new Vector2Int(-3, 0), new Vector2Int(-2, 0) },
            { new Vector2Int(-3, 1), new Vector2Int(-2, 1) },
            { new Vector2Int(-3, 2), new Vector2Int(-2, 2) },
            { new Vector2Int(-2, 3), new Vector2Int(-2, 2) },
            { new Vector2Int(-1, 3), new Vector2Int(-1, 2) },
            { new Vector2Int(0, 3), new Vector2Int(0, 2) },
            { new Vector2Int(1, 3), new Vector2Int(1, 2) },
            { new Vector2Int(2, 3), new Vector2Int(2, 2) },
        };

    public static Vector2Int[] GetBuildingNeighbors(long buildUuid)
    {
        // var buildingDate = GameEntry.Lua.CallWithReturn<LuaBuildData, long>(
        //     "CSharpCallLuaInterface.GetBuildingDataByUuid", buildUuid);

        var buildingDate = GameEntry.Data.Building.GetBuildingDataByUuid(buildUuid);
        if (buildingDate == null)
        {
            return null;
        }

        return GetBuildingNeighbors(buildingDate.buildId, buildingDate.pointId);
    }

    public static Vector2Int[] GetBuildingNeighbors(int itemId, int pointId)
    {
        var pos = SceneManager.World.IndexToTilePos(pointId);
        int tiles = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, itemId,"tiles").ToInt();
        List<Vector2Int> list = new List<Vector2Int>();
        for (int i = 0; i < tiles; ++i)
        {
            list.Add(pos + new Vector2Int(-i, -tiles));
            list.Add(pos + new Vector2Int(1, -i));
            list.Add(pos + new Vector2Int(-i, 1));
            list.Add(pos + new Vector2Int(-tiles, -i));
        }
        return list.ToArray();
    }
    
    public static List<Vector2Int> GetBuildingNeighbors(LuaBuildData buildingDate, out List<Vector2Int> entries)
    {
        Vector2Int pos = SceneManager.World.IndexToTilePos(buildingDate.pointId);
        int tiles = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, buildingDate.buildId,"tiles").ToInt();
        entries = new List<Vector2Int>();
        for (int i = 0; i < tiles; ++i)
        {
            for (int j = 0; j < tiles; ++j)
            {
                entries.Add(pos + new Vector2Int(-i, -j));
            }
        }
        List<Vector2Int> list = new List<Vector2Int>();
        for (int i = 0; i < tiles; ++i)
        {
            list.Add(pos + new Vector2Int(-i, -tiles));
            list.Add(pos + new Vector2Int(1, -i));
            list.Add(pos + new Vector2Int(-i, 1));
            list.Add(pos + new Vector2Int(-tiles, -i));
        }
        return list;
    }

    public static Vector2Int GetNeighborDir(Vector2Int pos, Vector2Int buildPos, int tiles)
    {
        var dif = pos - buildPos;
        if (dif.y > 0)
        {
            return Vector2Int.up;
        }

        if (dif.x > 0)
        {
            return Vector2Int.right;
        }

        if (tiles == -dif.x)
        {
            return Vector2Int.left;
        }

        return Vector2Int.down;
    }

    private static float CalNeighborWeight(Vector2Int pos, Vector2Int startPos, Vector2Int buildPos, int tiles)
    {
        var weight = Vector2Int.Distance(pos, startPos);

        var dir = GetNeighborDir(pos, buildPos, tiles);
        if (dir == Vector2Int.right || dir == Vector2Int.left)
        {
            weight += 1000;
        }
        else if (dir == Vector2Int.up)
        {
            weight += 5000;
        }

        return weight;
    }

    public static Vector2Int[] GetSortedBuildingNeighbors(int itemId, int pointId, Vector2Int startPos)
    {
        var neighbors = GetBuildingNeighbors(itemId, pointId);
        
        var buildPos = SceneManager.World.IndexToTilePos(pointId);
        int tiles = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, itemId,"tiles").ToInt();

        Array.Sort(neighbors, (a, b) =>
        {
            var aWeight = CalNeighborWeight(a, startPos, buildPos, tiles);
            var bWeight = CalNeighborWeight(b, startPos, buildPos, tiles);
            return aWeight.CompareTo(bWeight);
        });

        return neighbors;
    }
    
    public static Vector2Int[] GetSortedBuildingNeighbors(LuaBuildData buildingDate, Vector2Int startPos, Vector2Int[] neighbors)
    {
        var buildPos = SceneManager.World.IndexToTilePos(buildingDate.pointId);
        int tiles = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, buildingDate.buildId,"tiles").ToInt();

        Array.Sort(neighbors, (a, b) =>
        {
            var aWeight = CalNeighborWeight(a, startPos, buildPos, tiles);
            var bWeight = CalNeighborWeight(b, startPos, buildPos, tiles);
            return aWeight.CompareTo(bWeight);
        });

        return neighbors;
    }

    private static Vector2Int[] GetMainEntries()
    {
        return MainRoundEntryOffset.Keys.Select(i => i + GameEntry.Data.Building.GetMainPos()).ToArray();
    }

    private static List<Vector2Int> StringToPath(string pathStr)
    {
        List<Vector2Int> ret = new List<Vector2Int>();
        if (!pathStr.IsNullOrEmpty())
        {
            var p = pathStr.Split(';');
            foreach (var pointStr in p)
            {
                if (!string.IsNullOrEmpty(pointStr))
                {
                    var ps = pointStr.Split(',');
                    ret.Add(new Vector2Int(int.Parse(ps[0]), int.Parse(ps[1])));
                }
            }
        }

        return ret;
    }

    public static List<PathInfo> StringToPathInfos(string pathStr)
    {
        List<PathInfo> ret = new List<PathInfo>();
        if (string.IsNullOrEmpty(pathStr))
            return ret;

        var paths = pathStr.Split('|');
        foreach (var p in paths)
        {
            PathInfo pi = new PathInfo();
            var ps = p.Split('@');
            pi.type = ps[0];
            pi.uuid = ps[1];
            pi.path = StringToPath(ps[2]);
            //if(!pi.uuid.IsNullOrEmpty() && pi.uuid != "(null)")
            //{

            //}
            ret.Add(pi);
        }

        return ret;
    }

    public static List<Vector2Int> StringToPoint(string pathStr)
    {
        List<Vector2Int> ret = new List<Vector2Int>();
        if (!pathStr.IsNullOrEmpty())
        {
            var p = pathStr.Split(';');
            foreach (var pointStr in p)
            {
                var ps = pointStr.Split(',');
                ret.Add(new Vector2Int(int.Parse(ps[0]), int.Parse(ps[1])));
            }
        }

        return ret;
    }

//获取车库开始位置
    public static Vector2Int GetNearestMainOutPos(Vector2Int targetPos)
    {
        var posList = GetTruckPathMainOutPosList();

        posList.Sort((a, b) => Vector2Int.Distance(a, targetPos).CompareTo(Vector2Int.Distance(b, targetPos)));

        return posList[0];
    }
//获取车库开始位置、以及出口位置
    public static List<Vector2Int> GetTruckPathMainOutPosList()
    {
        var mainPos = GameEntry.Data.Building.GetMainPos();
        var retList = new List<Vector2Int>
        {
            mainPos + new Vector2Int(0, 3),
            mainPos + new Vector2Int(-1, 3),
            mainPos + new Vector2Int(0, -4),
            mainPos + new Vector2Int(-1, -4),
            mainPos + new Vector2Int(3, 0),
            mainPos + new Vector2Int(3, -1),
            mainPos + new Vector2Int(-4, 0),
            mainPos + new Vector2Int(-4, -1),
        };
        return retList;
    }
    
    public static List<Vector2Int> GetTruckPathMainOutPosList(out List<Vector2Int> entries)
    {
        var mainPos = GameEntry.Data.Building.GetMainPos();
        entries = new List<Vector2Int>
        {
            mainPos + new Vector2Int(0, 2),
            mainPos + new Vector2Int(-1, 2),
            mainPos + new Vector2Int(0, -3),
            mainPos + new Vector2Int(-1, -3),
            mainPos + new Vector2Int(2, 0),
            mainPos + new Vector2Int(2, -1),
            mainPos + new Vector2Int(-3, 0),
            mainPos + new Vector2Int(-3, -1),
        };
        return GetTruckPathMainOutPosList();
    }
    
    private static Vector2Int GetOuterPosInnerPos(Vector2Int outPos)
    {
        var mainPos = GameEntry.Data.Building.GetMainPos();
        mainPos += new Vector2Int(-1, -1);
        var dir = outPos - mainPos;
        if (dir.x == 0)
        {
            return outPos + (dir.y > 0 ? Vector2Int.down : Vector2Int.up);
        }

        return outPos + (dir.x > 0 ? Vector2Int.left : Vector2Int.right);
    }

    private static Vector2Int GetMainBuildNextPointFromDif(Vector2Int dif)
    {
        if (dif.y == -1 && dif.x != 1)
        {
            return Vector2Int.right;
        }

        if (dif.x == 1 && dif.y != 1)
        {
            return Vector2Int.up;
        }

        if (dif.y == 1 && dif.x != -1)
        {
            return Vector2Int.left;
        }

        return Vector2Int.down;
    }
}