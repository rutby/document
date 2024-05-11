
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using Priority_Queue;
using UnityEngine;

//
// 世界寻路
//   寻路过程为分帧执行，以防在大地图寻路时卡顿
//
public class WorldPathfinding : WorldManagerBase
{
    // 异步寻路操作；可查询异步过程是否完成以及取消未完成的操作
    public class AsyncPathfinding : IEnumerator
    {
        private SearchTask task;

        public AsyncPathfinding(SearchTask task)
        {
            this.task = task;
        }
        
        public bool isDone
        {
            get { return task.isDone;  }
        }

        public List<Vector2Int> path
        {
            get { return task.path; }
        }

        public void Cancel()
        {
            task.isDone = true;
            task.isCancel = true;
        }

        public bool MoveNext()
        {
            return !isDone;
        }

        public void Reset()
        {
            
        }

        public object Current
        {
            get { return null; }
        }
    }

    // 寻路任务状态
    public class SearchTask
    {
        public bool isDone;
        public bool isCancel;
        public List<Vector2Int> path = new List<Vector2Int>(1000);
        public Action<List<Vector2Int>> onComplete;
        public Vector2Int start, goal;
        public int areaIndex;
        public List<Area> searchAreas = new List<Area>();
        public JPS.Searcher searcher;
        public JPS.JPS_Result res;
    }
    
    // 地图静态格子
    class StaticMap : JPS.IGrid
    {
        public bool IsWalkable(int x, int y)
        {
            return SceneManager.World.IsTileWalkable(new Vector2Int(x, y));
        }
    }

    class AreaMap : JPS.IGrid
    {
        private Area area;
        public AreaMap(Area area)
        {
            this.area = area;
        }
        
        public bool IsWalkable(int x, int y)
        {
            if (x >= area.min.x && x <= area.max.x && y >= area.min.y && y <= area.max.y)
            {
                return SceneManager.World.IsTileWalkable(new Vector2Int(x, y));
            }

            return false;
        }
    }
    
    private List<SearchTask> pathfindingTasks = new List<SearchTask>();
    private int processIndex;

    //
    //
    // 分区
    public class AreaEdge
    {
        public const int AreaWidth = 500;
        public const int ConnectionCount = 10;
        public Vector2Int[] connections;
        public Area area;

        public enum Dir
        {
            Up,
            Right,
            Down,
            Left,
        }

        public AreaEdge(Area area, Dir dir)
        {
            connections = new Vector2Int[ConnectionCount];
            Vector2Int s, e, step;
            if (dir == Dir.Up)
            {
                s = new Vector2Int(area.min.x, area.max.y);
                e = new Vector2Int(area.max.x, area.max.y);
                step = new Vector2Int(AreaWidth / (ConnectionCount - 1), 0);
            }
            else if (dir == Dir.Right)
            {
                s = new Vector2Int(area.max.x, area.min.y);
                e = new Vector2Int(area.max.x, area.max.y);
                step = new Vector2Int(0, AreaWidth / (ConnectionCount - 1));
            }
            else if (dir == Dir.Down)
            {
                s = new Vector2Int(area.min.x, area.min.y);
                e = new Vector2Int(area.max.x, area.min.y);
                step = new Vector2Int(AreaWidth / (ConnectionCount - 1), 0);
            }
            else //if (dir == Dir.Left)
            {
                s = new Vector2Int(area.min.x, area.min.y);
                e = new Vector2Int(area.min.x, area.max.y);
                step = new Vector2Int(0, AreaWidth / (ConnectionCount - 1));
            }
            
            connections[0] = s;
            connections[ConnectionCount - 1] = e;
            for (int i = 1; i <= ConnectionCount - 2; i++)
            {
                connections[i] = s + step * i;
            }
        }
    }
    
    public class Area
    {
        public Vector2Int min;
        public Vector2Int max;
        public Vector2Int areaPos;
        public AreaEdge[] edges;

        public Area(Vector2Int areaPos, Vector2Int min, Vector2Int max)
        {
            this.areaPos = areaPos;
            this.min = min;
            this.max = max;
            
            edges = new AreaEdge[4];
            for (int i = 0; i < 4; i++)
            {
                edges[i] = new AreaEdge(this, (AreaEdge.Dir)i);
            }
        }

        public Rect GetRect()
        {
            return new Rect(min, new Vector2(max.x + 1 - min.x, max.y + 1 - min.y));
        }
    }

    private Area[] worldAreas;
    
    public WorldPathfinding(WorldScene scene) : base(scene)
    {
    }

    public override void Init()
    {
        base.Init();

        int aw = world.BlockCount.x;
        int ah = world.BlockCount.y;

        worldAreas = new Area[aw * ah];
        for (int ay = 0; ay < ah; ay++)
        {
            for (int ax = 0; ax < aw; ax++)
            {
                worldAreas[ay * aw + ax] = new Area(new Vector2Int(ax, ay),
                    new Vector2Int(ax * world.BlockSize, ay * world.BlockSize),
                    new Vector2Int((ax + 1) * world.BlockSize - 1, (ay + 1) * world.BlockSize - 1));
            }
        }
    }

    public override void UnInit()
    {
        base.UnInit();
    }
    
    // 一圈邻居坐标
    private static readonly Vector2Int[] NeighborOffset =
    {
        new Vector2Int(1, 0),
        new Vector2Int(0, 1),
        new Vector2Int(-1, 0),
        new Vector2Int(0, -1),
        new Vector2Int(1, 1),
        new Vector2Int(-1, 1),
        new Vector2Int(-1, -1),
        new Vector2Int(1, -1),
    };

    private static readonly float[] NeighborCost = {1, 1, 1, 1, 1.414f, 1.414f, 1.414f, 1.414f};

    private static Vector2Int GetNeighborPos(Vector2Int pos, int dir)
    {
        return pos + NeighborOffset[dir];
    }

    public override void OnUpdate(float deltaTime)
    {
        base.OnUpdate(deltaTime);
        
        if (pathfindingTasks.Count == 0)
            return;

        while (true)
        {
            processIndex++;
            if (processIndex >= pathfindingTasks.Count)
            {
                processIndex = 0;
            }
            
            var task = pathfindingTasks[processIndex];
            if (task.isCancel)
            {
                pathfindingTasks.RemoveAt(processIndex);
                if (pathfindingTasks.Count == 0)
                    break;
            }
            else if (task.isDone)
            {
                pathfindingTasks.RemoveAt(processIndex);
                List<Vector2Int> path;
                path = Floyd(task.path);
                
                task.onComplete?.Invoke(path);
                if (pathfindingTasks.Count == 0)
                    break;
            }
            else
            {
                UpdateSearchStep(task);
                break;
            }
        }
    }

    // 发起异步寻路，如果目标点不可走，则在目标点周围找一个离起点最近的可走点作为目标点
    public AsyncPathfinding FindPath(Vector2Int start, Vector2Int goal, Action<List<Vector2Int>> onComplete)
    {
        if (!world.IsTileWalkable(goal) && goal != start)
        {
            goal = ClosestCell(OpenCells(start, goal), start, goal);
        }

        var task = new SearchTask();
        task.start = start;
        task.goal = goal;
        task.onComplete = onComplete;
        task.searchAreas = FindPassAreas(start, goal);
        task.areaIndex = 0;
        if (task.searchAreas.Count > 0)
        {
            var area = task.searchAreas[task.areaIndex];
            task.searcher = new JPS.Searcher(new AreaMap(area));

            Vector2Int areaEntry, areaExit;
            GetAreaEntryExit(start, goal, area, out areaEntry, out areaExit);
            task.res = task.searcher.FindPathInit(areaEntry, areaExit);
        }

        pathfindingTasks.Add(task);
        return new AsyncPathfinding(task);
    }


    public void GetTimeFromCurPosToTargetPos(int posStart,int targetPoint,int speed,long Uuid)
    {
        var start = world.IndexToTilePos(posStart);
        var end = world.IndexToTilePos(targetPoint);
        SceneManager.World.FindPath(start, end, path =>
        {
            if (path.Count <= 1)
            {
                Log.Error("cannot find path");
                return;
            }

            var length = 0.0f;
            for (int i = 0; i < path.Count - 1; i++)
            {
                var startPos = path[i];
                var ednPos = path[i+1];
                length+=Vector2Int.Distance(startPos, ednPos);
            }

            var time = (int)(Mathf.Ceil(length / speed));
            var str = Uuid.ToString() + ";" + time.ToString();
            GameEntry.Event.Fire(EventId.ReturnTimeFromCurPosToTargetPos, str);
        });
    }

    private static List<Vector2Int> SuperCoverLine(Vector2Int p0, Vector2Int p1, List<Vector2Int> points = null, int limitCount = int.MaxValue)
    {
        int dx = p1.x - p0.x, dy = p1.y - p0.y;
        int nx = Math.Abs(dx), ny = Math.Abs(dy);
        int sign_x = dx > 0 ? 1 : -1, sign_y = dy > 0 ? 1 : -1;

        if (points == null)
        {
            points = new List<Vector2Int>();
        }
        var p = new Vector2Int(p0.x, p0.y);
        points.Add(p);
        if (points.Count >= limitCount)
            return points;
        
        for (int ix = 0, iy = 0; ix < nx || iy < ny;)
        {
            if ((1 + 2 * ix) * ny == (1 + 2 * iy) * nx)
            {
                // next step is diagonal
                p.x += sign_x;
                p.y += sign_y;
                ix++;
                iy++;
            }
            else if ((0.5 + ix) / nx < (0.5 + iy) / ny)
            {
                // next step is horizontal
                p.x += sign_x;
                ix++;
            }
            else
            {
                // next step is vertical
                p.y += sign_y;
                iy++;
            }

            points.Add(new Vector2Int(p.x, p.y));
            if (points.Count >= limitCount)
                return points;
        }

        return points;
    }

    private List<Area> FindPassAreas(Vector2Int start, Vector2Int goal)
    {
        List<Area> passAreas = new List<Area>();
        var points = SuperCoverLine(start, goal);
        if (points.Count <= 0)
            return passAreas;

        var p = points[0];
        var areaIdx = (p.y / world.BlockSize) * world.BlockCount.x + (p.x / world.BlockSize);
        passAreas.Add(worldAreas[areaIdx]);
        
        for (int i = 1; i < points.Count; i++)
        {
            p = points[i];
            areaIdx = (p.y / world.BlockSize) * world.BlockCount.x + (p.x / world.BlockSize);
            var area = worldAreas[areaIdx];
            if (passAreas[passAreas.Count - 1] != area)
            {
                passAreas.Add(area);
            }
        }

        return passAreas;
    }

    private void GetAreaEntryExit(Vector2Int start, Vector2Int goal, Area area, out Vector2Int entry, out Vector2Int exit)
    {
        entry = start;
        exit = goal;
        
        var res = new Raycast2DLineRect.LineRectResult();
        Raycast2DLineRect.RaycastLineRect(start, goal, area.GetRect(), ref res);
        if (res.HaveHit)
        {
            Vector2Int dir = goal - start;
            Vector2Int p0 = new Vector2Int((int)(start.x + dir.x * res.entry), (int)(start.y + dir.y * res.entry));
            if (res.entrySector != Raycast2DLineRect.Sector.__)
            {
                Vector2Int[] connections = null;
                if (res.entrySector == Raycast2DLineRect.Sector.S1)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Up].connections;
                }
                else if (res.entrySector == Raycast2DLineRect.Sector.S5)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Right].connections;
                }
                else if (res.entrySector == Raycast2DLineRect.Sector.S7)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Down].connections;
                }
                else if (res.entrySector == Raycast2DLineRect.Sector.S3)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Left].connections;
                }

                if (connections != null)
                {
                    float minDist = float.PositiveInfinity;
                    Vector2Int closestPoint = Vector2Int.zero;
                    foreach (var c in connections)
                    {
                        var sqrMagnitude = (c - p0).sqrMagnitude;
                        if (sqrMagnitude < minDist)
                        {
                            minDist = sqrMagnitude;
                            closestPoint = c;
                        }
                    }

                    entry = closestPoint;
                }
            }

            if (res.exitSector != Raycast2DLineRect.Sector.__)
            {
                Vector2Int[] connections = null;
                Vector2Int p1  = new Vector2Int((int)(start.x + dir.x * res.exit), (int)(start.y + dir.y * res.exit));
                if (res.exitSector == Raycast2DLineRect.Sector.S1)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Up].connections;
                }
                else if (res.exitSector == Raycast2DLineRect.Sector.S5)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Right].connections;
                }
                else if (res.exitSector == Raycast2DLineRect.Sector.S7)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Down].connections;
                }
                else if (res.exitSector == Raycast2DLineRect.Sector.S3)
                {
                    connections = area.edges[(int)AreaEdge.Dir.Left].connections;
                }
                if (connections != null)
                {
                    float minDist = float.PositiveInfinity;
                    Vector2Int closestPoint = Vector2Int.zero;
                    foreach (var c in connections)
                    {
                        var sqrMagnitude = (c - p1).sqrMagnitude;
                        if (sqrMagnitude < minDist)
                        {
                            minDist = sqrMagnitude;
                            closestPoint = c;
                        }
                    }

                    exit = closestPoint;
                }
            }
        }
    }

    private HashSet<Vector2Int> OpenCells(Vector2Int start, Vector2Int goal)
    {
        Dictionary<Vector2Int, int> counts = new Dictionary<Vector2Int, int>();
        counts.Add(goal, 0);

        HashSet<Vector2Int> openCells = new HashSet<Vector2Int>();

        float minDist = float.MaxValue;
        int minCount = int.MaxValue;

        BreadthFirstTraversal(goal, (current, next) =>
        {
            float dist = world.TileDistance(goal, next);
            int count = counts[current] + 1;
            counts[next] = count;

            if ((world.IsTileWalkable(next) || next == start) && dist <= minDist)
            {
                minDist = dist;
                minCount = count;
                openCells.Add(next);
            }

            return count <= minCount && SceneManager.World.IsInMap(next);
        });

        return openCells;
    }
    
    private void BreadthFirstTraversal(Vector2Int position, Func<Vector2Int, Vector2Int, bool> isConnected)
    {
        Queue<Vector2Int> queue = new Queue<Vector2Int>();
        queue.Enqueue(position);

        HashSet<Vector2Int> visited = new HashSet<Vector2Int>();
        int searchCount = 0;
        while (queue.Count > 0)
        {
            Vector2Int node = queue.Dequeue();
            for (int i = 0; i < 4; i++)
            {
                Vector2Int next = GetNeighborPos(node, i);

                if (isConnected(node, next) && !visited.Contains(next))
                {
                    queue.Enqueue(next);
                }
            }

            searchCount++;
            if (searchCount > 100000)
                break;
            visited.Add(node);
        }
    }

    private static Vector2Int ClosestCell(HashSet<Vector2Int> openCells, Vector2Int start, Vector2Int goal)
    {
        Vector2Int closest = goal;
        float minDist = float.MaxValue;

        foreach (Vector2Int c in openCells)
        {
            float dist = SceneManager.World.TileDistance(start, c);
            if (dist < minDist)
            {
                minDist = dist;
                closest = c;
            }
        }

        return closest;
    }

    private void UpdateSearchStep(SearchTask task)
    {
        switch (task.res)
        {
            case JPS.JPS_Result.JPS_NEED_MORE_STEPS:
                task.res = task.searcher.FindPathStep(10000);
                break;
            case JPS.JPS_Result.JPS_EMPTY_PATH:
            case JPS.JPS_Result.JPS_FOUND_PATH:
                if (task.res == JPS.JPS_Result.JPS_FOUND_PATH)
                {
                    task.res = task.searcher.FindPathFinish(task.path, 0);
                }
                
                if (task.areaIndex + 1 < task.searchAreas.Count)
                {
                    task.areaIndex++;
                    var area = task.searchAreas[task.areaIndex];
                    task.searcher = new JPS.Searcher(new AreaMap(area));

                    Vector2Int areaEntry, areaExit;
                    GetAreaEntryExit(task.start, task.goal, area, out areaEntry, out areaExit);
                    task.res = task.searcher.FindPathInit(areaEntry, areaExit);
                }
                else
                {
                    task.isDone = true;
                }
                break;
            case JPS.JPS_Result.JPS_NO_PATH:
                task.isDone = true;
                break;
        }
    }

    public static string PathToString(List<Vector2Int> path)
    {
        return string.Join(";", path.Select(p => SceneManager.World.TilePosToIndex(p)));
    }
    
    // public static Vector2Int GetAttackPos(Vector2Int start, Vector2Int end, int radius)
    // {
    //     var r1 = radius;
    //     HashSet<Vector2Int> r1Set = new HashSet<Vector2Int>();
    //     for (int y = end.y - r1; y <= end.y + r1; y++)
    //     {
    //         for (int x = end.x - r1; x <= end.x + r1; x++)
    //         {
    //             var pos = new Vector2Int(x, y);
    //             if (SceneManager.World.IsTileWalkable(pos))
    //             {
    //                 r1Set.Add(new Vector2Int(x, y));
    //             }
    //         }
    //     }
    //
    //     var r0 = radius - 1;
    //     HashSet<Vector2Int> r0Set = new HashSet<Vector2Int>();
    //     for (int y = end.y - r0; y <= end.y + r0; y++)
    //     {
    //         for (int x = end.x - r0; x <= end.x + r0; x++)
    //         {
    //             var pos = new Vector2Int(x, y);
    //             if (SceneManager.World.IsTileWalkable(pos))
    //             {
    //                 r0Set.Add(new Vector2Int(x, y));
    //             }
    //         }
    //     }
    //     
    //     r1Set.ExceptWith(r0Set);
    //
    //     return ClosestCell(r1Set, start, end);
    // }
    
    
    //----------------------------------------弗洛伊德路径平滑--------------------------------------//

    public List<Vector2Int> Floyd( List<Vector2Int> path)
    {
        if (path == null || path.Count <= 2) 
        {
            return path;
        }

        //去掉无用拐点
        int i = 0;
        while (i < path.Count - 1)
        {
            int j = i + 2;
            while (j < path.Count && CheckCrossNoteWalkable(path[i], path[j]))
            {
                path.RemoveAt(j - 1);
            }
            if (j >= path.Count)
                break;
            
            i++;
        }
        return path;
    }

    private bool CheckCrossNoteWalkable(Vector2Int p1, Vector2Int p2)
    {
        int dx = Math.Abs(p2.x - p1.x);
        int dy = Math.Abs(p2.y - p1.y);
        int x = p1.x;
        int y = p1.y;
        int n = dx + dy;
        int err = dx - dy;
        

        var xInc = p2.x > p1.x ? 1 : -1;
        var yInc = p2.y > p1.y ? 1 : -1;

        dx = 2 * dx;
        dy = 2 * dy;

        while (n > 0) {
            if (!Checkwalkable(x, y))
            {
                return false;
            }
            if (err > 0) {
                x += xInc;
                err -= dy;
            }
            else if (err < 0) {
                y += yInc;
                err += dx;
            }
            else {
                if (!Checkwalkable(x, y + yInc) || !Checkwalkable(x + xInc, y))
                {
                    return false;
                }
                x += xInc;
                y += yInc;
                err += dx - dy;
                n -=1;
            }
            n -= 1;
        }
        if (!Checkwalkable(x, y))
        {
            return false;
        }
        return true;
    }
    
    
    private bool Checkwalkable(int x, int y)
    {
        // if (change == 1)//对y上下取整检验
        // {
        //     return SceneManager.World.StaticManager.IsTileWalkable(new Vector2Int((int)x, (int)Math.Floor(y))) &&SceneManager.World.StaticManager.IsTileWalkable(new Vector2Int((int)x, (int)Math.Ceiling(y)));
        // }
        //
        // if (change == 2)//对x上下取整检验
        // {
        //     return SceneManager.World.StaticManager.IsTileWalkable(new Vector2Int((int)Math.Floor(x), (int) y)) &&SceneManager.World.StaticManager.IsTileWalkable(new Vector2Int((int)Math.Ceiling(x), (int)y));
        // }

        //Log.Debug("checkPoint:{0},{1}",x,y);
        return SceneManager.World.IsTileWalkable(new Vector2Int(x, y));

    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 跳点寻路 Jump Point Search
namespace JPS
{
    public enum JPS_Result
    {
        JPS_NO_PATH,
        JPS_FOUND_PATH,
        JPS_NEED_MORE_STEPS,
        JPS_EMPTY_PATH,
    }

    [Flags]
    public enum JPS_Flags : uint
    {
        // No special behavior
        JPS_Flag_Default       = 0x00,

        // Don't check whether start position is walkable.
        // This makes the start position always walkable, even if the map data say otherwise.
        JPS_Flag_NoStartCheck  = 0x04,

        // Don't check whether end position is walkable.
        JPS_Flag_NoEndCheck    = 0x08,
    }

    public interface IGrid
    {
        bool IsWalkable(int x, int y);
    }
    
    class Node
    {
        public float F;
        public float G;
        public Vector2Int Pos;
        public Node Parent;
        private uint flags;
        
        public bool HasParent
        {
            get { return Parent != null; }
        }

        public void SetOpen()
        {
            flags |= 1;
        }

        public void SetClosed()
        {
            flags |= 2;
        }
        
        public bool IsOpen
        {
            get { return (flags & 1) != 0; }
        }
        
        public bool IsClosed
        {
            get { return (flags & 2) != 0; }
        }
    }

    public class Searcher
    {
        private Vector2Int endPos;
        private int stepsRemain;
        private int stepsDone;
        private IGrid grid;
        private Vector2Int[] neighbors;
        private Dictionary<Vector2Int, Node> nodeMap = new Dictionary<Vector2Int, Node>();
        private SimplePriorityQueue<Node> openList = new SimplePriorityQueue<Node>();
        private static readonly Vector2Int npos = new Vector2Int(-1, -1);
        private static readonly int noidx = -1;

        public Searcher(IGrid grid)
        {
            this.grid = grid;
            endPos = npos;
            this.grid = grid;
            neighbors = new Vector2Int[8];
        }

        // 寻路
        //   函数执行完成即返回结果。路径结果添加到path列表，path列表中原有数据不清空
        public bool FindPath(List<Vector2Int> path, Vector2Int start, Vector2Int end, int step, JPS_Flags flags = JPS_Flags.JPS_Flag_Default)
        {
            JPS_Result res = FindPathInit(start, end, flags);

            if (res == JPS_Result.JPS_EMPTY_PATH)
                return true;

            while (true)
            {
                switch (res)
                {
                    case JPS_Result.JPS_NEED_MORE_STEPS:
                        res = FindPathStep(0);
                        break;
                    case JPS_Result.JPS_FOUND_PATH:
                        return FindPathFinish(path, step) == JPS_Result.JPS_FOUND_PATH;
                    case JPS_Result.JPS_EMPTY_PATH:
                        Log.Error("can't happen");
                        return false;
                    case JPS_Result.JPS_NO_PATH:
                        return false;
                }
            }
        }
        
        //
        // 分帧异步寻路
        //   FindPathInit
        //   FindPathStep
        //   FindPathFinish
        //
        public JPS_Result FindPathInit(Vector2Int start, Vector2Int end, JPS_Flags flags = JPS_Flags.JPS_Flag_Default)
        {
            Clear();

            endPos = end;

            if (start == end && (flags & (JPS_Flags.JPS_Flag_NoStartCheck | JPS_Flags.JPS_Flag_NoEndCheck)) == 0)
            {
                return grid.IsWalkable(end.x, end.y) ? JPS_Result.JPS_EMPTY_PATH : JPS_Result.JPS_NO_PATH;
            }

            if ((flags & JPS_Flags.JPS_Flag_NoStartCheck) == 0)
            {
                if (!grid.IsWalkable(start.x, start.y))
                {
                    return JPS_Result.JPS_NO_PATH;
                }
            }
            
            if ((flags & JPS_Flags.JPS_Flag_NoEndCheck) == 0)
            {
                if (!grid.IsWalkable(end.x, end.y))
                {
                    return JPS_Result.JPS_NO_PATH;
                }
            }

            var startNode = GetNode(start);
            openList.Enqueue(startNode, startNode.F);
            
            return JPS_Result.JPS_NEED_MORE_STEPS;
        }

        public JPS_Result FindPathStep(int limit)
        {
            stepsRemain = limit;

            do
            {
                if (openList.Count == 0)
                    return JPS_Result.JPS_NO_PATH;
                var n = openList.Dequeue();
                n.SetClosed();
                if (n.Pos == endPos)
                    return JPS_Result.JPS_FOUND_PATH;
                IdentifySuccessors(n);
            } while (stepsRemain > 0);

            return JPS_Result.JPS_NEED_MORE_STEPS;
        }

        public JPS_Result FindPathFinish(List<Vector2Int> path, int step)
        {
            Node endNode = GetNode(endPos);
            if (!endNode.HasParent)
            {
                return JPS_Result.JPS_NO_PATH;
            }

            List<Vector2Int> tmpPath = new List<Vector2Int>();
            Node next = endNode;
            if (step > 0)
            {
                Node prev = endNode.Parent;
                do
                {
                    int x = next.Pos.x, y = next.Pos.y;
                    int dx = prev.Pos.x - x;
                    int dy = prev.Pos.y - y;
                    int adx = Math.Abs(dx);
                    int ady = Math.Abs(dy);
                    int steps = Math.Max(adx, ady);
                    dx = step * Math.Sign(dx);
                    dy = step * Math.Sign(dy);
                    int dxa = 0, dya = 0;
                    for (int i = 0; i < steps; i += step)
                    {
                        var v = new Vector2Int(x + dxa, y + dya);
                        tmpPath.Add(v);
                        dxa += dx;
                        dya += dy;
                    }

                    next = prev;
                    prev = prev.Parent;
                } while (prev != null);

                tmpPath.Add(next.Pos);
            }
            else if (step == 0)
            {
                while (next != null)
                {
                    tmpPath.Add(next.Pos);
                    next = next.Parent;
                }
            }
            
            tmpPath.Reverse();
            RemoveDuplicates(tmpPath);
            
            path.AddRange(tmpPath);
            
            return JPS_Result.JPS_FOUND_PATH;
        }

        public int GetStepsDone()
        {
            return stepsDone;
        }
        
        private void RemoveDuplicates(List<Vector2Int> path)
        {
            if (path.Count > 2)
            {
                var p0 = path[0];
                var p1 = path[1];
                int i = 2;
                while (i < path.Count)
                {
                    var p2 = path[i];
                    var dir1 = p1 - p0;
                    dir1.Clamp(Vector2Int.one * -1, Vector2Int.one);
                    var dir2 = p2 - p1;
                    dir2.Clamp(Vector2Int.one * -1, Vector2Int.one);
                    if (dir1 == dir2)
                    {
                        path.RemoveAt(i - 1);
                        p1 = p2;
                    }
                    else
                    {
                        p0 = p1;
                        p1 = p2;
                        i++;
                    }
                }
            }
        }
        
        private bool IdentifySuccessors(Node n)
        {
            Vector2Int np = n.Pos;
            //int num = FindNeighborsAStar(n, neighbors);
            int num = FindNeighborsJPS(n, neighbors);

            for (int i = num - 1; i >= 0; --i)
            {
                Vector2Int jp;
                //if ((flags & JPS_Flags.JPS_Flag_AStarOnly) != 0)
                //{
                //    jp = neighbors[i];
                //}
                //else
                {
                    jp = JumpP(neighbors[i], np);
                    if (jp == npos)
                        continue;
                }

                Node jn = GetNode(jp);
                if (!jn.IsClosed)
                {
                    ExpandNode(jp, jn, n);
                }
            }

            return true;
        }
        
        private void Clear()
        {
            nodeMap.Clear();
            openList.Clear();
            endPos = npos;
        }

        private int FindNeighborsJPS(Node n, Vector2Int[] nb)
        {
            Vector2Int np = n.Pos;
            int x = np.x, y = np.y;
            int num = 0;

            if (!n.HasParent)
            {
                if (grid.IsWalkable(x - 1, y))
                {
                    nb[num++] = new Vector2Int(x - 1, y);
                }
                if (grid.IsWalkable(x, y - 1))
                {
                    nb[num++] = new Vector2Int(x, y - 1);
                }
                if (grid.IsWalkable(x, y + 1))
                {
                    nb[num++] = new Vector2Int(x, y + 1);
                }
                if (grid.IsWalkable(x + 1, y))
                {
                    nb[num++] = new Vector2Int(x + 1, y);
                }

                if (grid.IsWalkable(x - 1, y) && grid.IsWalkable(x, y - 1))
                {
                    if (grid.IsWalkable(x - 1, y - 1))
                    {
                        nb[num++] = new Vector2Int(x - 1, y - 1);
                    }
                }
                if (grid.IsWalkable(x - 1, y) && grid.IsWalkable(x, y + 1))
                {
                    if (grid.IsWalkable(x - 1, y + 1))
                    {
                        nb[num++] = new Vector2Int(x - 1, y + 1);
                    }
                }
                if (grid.IsWalkable(x + 1, y) && grid.IsWalkable(x, y - 1))
                {
                    if (grid.IsWalkable(x + 1, y - 1))
                    {
                        nb[num++] = new Vector2Int(x + 1, y - 1);
                    }
                }
                if (grid.IsWalkable(x + 1, y) && grid.IsWalkable(x, y + 1))
                {
                    if (grid.IsWalkable(x + 1, y + 1))
                    {
                        nb[num++] = new Vector2Int(x + 1, y + 1);
                    }
                }

                return num;
            }

            Node parent = n.Parent;
            Vector2Int pp = parent.Pos;
            int dx = Math.Sign(x - pp.x);
            int dy = Math.Sign(y - pp.y);
            if (dx != 0 && dy != 0)
            {
                // Natural neighbours
                bool walkX = grid.IsWalkable(x + dx, y);
                if (walkX)
                {
                    nb[num++] = new Vector2Int(x + dx, y);
                }
                
                bool walkY = grid.IsWalkable(x, y + dy);
                if (walkY)
                {
                    nb[num++] = new Vector2Int(x, y + dy);
                }

                if (walkX && walkY)
                {
                    if (grid.IsWalkable(x + dx, y + dy))
                    {
                        nb[num++] = new Vector2Int(x + dx, y + dy);
                    }
                }
            }
            else if (dx != 0)
            {
                if (grid.IsWalkable(x + dx, y))
                {
                    nb[num++] = new Vector2Int(x + dx, y);
                }
                
                // Forced neighbours
                // ###| f | f 
                // ---+---+---   
                //  p | c |
                // ---+---+---
                //    |   |   
                if (!grid.IsWalkable(x - dx, y + 1))
                {
                    if (grid.IsWalkable(x, y + 1))
                    {
                        nb[num++] = new Vector2Int(x, y + 1);
                    }
                    if (grid.IsWalkable(x + dx, y + 1))
                    {
                        nb[num++] = new Vector2Int(x + dx, y + 1);
                    }
                }

                if (!grid.IsWalkable(x - dx, y - 1))
                {
                    if (grid.IsWalkable(x, y - 1))
                    {
                        nb[num++] = new Vector2Int(x, y - 1);
                    }
                    if (grid.IsWalkable(x + dx, y - 1))
                    {
                        nb[num++] = new Vector2Int(x + dx, y - 1);
                    }
                }
            }
            else if (dy != 0)
            {
                if (grid.IsWalkable(x, y + dy))
                {
                    nb[num++] = new Vector2Int(x, y + dy);
                }
                // Forced neighbours
                //  f |   |   
                // ---+---+---
                //  f | c |   
                // ---+---+---
                // ###| p |   
                if (!grid.IsWalkable(x + 1, y - dy))
                {
                    if (grid.IsWalkable(x + 1, y))
                    {
                        nb[num++] = new Vector2Int(x + 1, y);
                    }
                    if (grid.IsWalkable(x + 1, y + dy))
                    {
                        nb[num++] = new Vector2Int(x + 1, y + dy);
                    }
                }

                if (!grid.IsWalkable(x - 1, y - dy))
                {
                    if (grid.IsWalkable(x - 1, y))
                    {
                        nb[num++] = new Vector2Int(x - 1, y);
                    }
                    if (grid.IsWalkable(x - 1, y + dy))
                    {
                        nb[num++] = new Vector2Int(x - 1, y + dy);
                    }
                }
            }

            return num;
        }
        
        private int FindNeighborsAStar(Node n, Vector2Int[] nb)
        {
            Vector2Int np = n.Pos;
            int x = np.x, y = np.y;
            int num = 0;

            if (grid.IsWalkable(x - 1, y) && grid.IsWalkable(x, y - 1))
            {
                if (grid.IsWalkable(x - 1, y - 1))
                {
                    nb[num++] = new Vector2Int(x - 1, y - 1);
                }
            }

            if (grid.IsWalkable(x, y - 1))
            {
                nb[num++] = new Vector2Int(x, y - 1);
            }
            
            if (grid.IsWalkable(x + 1, y) && grid.IsWalkable(x, y - 1))
            {
                if (grid.IsWalkable(x + 1, y - 1))
                {
                    nb[num++] = new Vector2Int(x + 1, y - 1);
                }
            }

            if (grid.IsWalkable(x - 1, y))
            {
                nb[num++] = new Vector2Int(x - 1, y);
            }
            
            if (grid.IsWalkable(x + 1, y))
            {
                nb[num++] = new Vector2Int(x + 1, y);
            }
            
            if (grid.IsWalkable(x - 1, y) && grid.IsWalkable(x, y + 1))
            {
                if (grid.IsWalkable(x - 1, y + 1))
                {
                    nb[num++] = new Vector2Int(x - 1, y + 1);
                }
            }
            
            if (grid.IsWalkable(x, y + 1))
            {
                nb[num++] = new Vector2Int(x, y + 1);
            }
            
            if (grid.IsWalkable(x + 1, y) && grid.IsWalkable(x, y + 1))
            {
                if (grid.IsWalkable(x + 1, y + 1))
                {
                    nb[num++] = new Vector2Int(x + 1, y + 1);
                }
            }
            
            stepsDone += 8;
            return num;
        }

        private Vector2Int JumpP(Vector2Int p, Vector2Int src)
        {
            int dx = p.x - src.x;
            int dy = p.y - src.y;
            if (dx != 0 && dy != 0)
            {
                return JumpD(p, dx, dy);
            }
            
            if (dx != 0)
            {
                return JumpX(p, dx);
            }
            if (dy != 0)
            {
                return JumpY(p, dy);
            }
            
            return npos;
        }

        private Vector2Int JumpD(Vector2Int p, int dx, int dy)
        {
            int steps = 0;

            while (true)
            {
                if (p == endPos)
                    break;

                ++steps;
                int x = p.x, y = p.y;
                if (HasForced(p, dx, dy))
                {
                    break;
                }

                bool gdx = grid.IsWalkable(x + dx, y);
                bool gdy = grid.IsWalkable(x, y + dy);
                
                if (gdx && JumpX(new Vector2Int(x + dx, y), dx) != npos)
                {
                    break;
                }

                if (gdy && JumpY(new Vector2Int(x, y + dy), dy) != npos)
                {
                    break;
                }

                if (gdx && gdy && grid.IsWalkable(x + dx, y + dy))
                {
                    p.x += dx;
                    p.y += dy;
                }
                else
                {
                    p = npos;
                    break;
                }
            }

            stepsDone += steps;
            stepsRemain -= steps;
            return p;
        }

        private Vector2Int JumpX(Vector2Int p, int dx)
        {
            int y = p.y;
            int steps = 0;

            while (true)
            {
                if (HasForced(p, dx, 0) || p == endPos)
                {
                    break;
                }

                if (!grid.IsWalkable(p.x + dx, y))
                {
                    p = npos;
                    break;
                }

                p.x += dx;
                ++steps;
            }
            
            stepsDone += steps;
            stepsRemain -= steps;
            return p;
        }

        private Vector2Int JumpY(Vector2Int p, int dy)
        {
            int x = p.x;
            int steps = 0;

            while (true)
            {
                if (HasForced(p, 0, dy) || p == endPos)
                {
                    break;
                }
                
                if (!grid.IsWalkable(x, p.y + dy))
                {
                    p = npos;
                    break;
                }

                p.y += dy;
                ++steps;
            }
            
            stepsDone += steps;
            stepsRemain -= steps;
            return p;
        }

        private bool HasForced(Vector2Int p, int dx, int dy)
        {
            if (dy == 0)
            {
                if (!grid.IsWalkable(p.x - dx, p.y + 1))
                {
                    if (grid.IsWalkable(p.x, p.y + 1))
                        return true;
                }

                if (!grid.IsWalkable(p.x - dx, p.y - 1))
                {
                    if (grid.IsWalkable(p.x, p.y - 1))
                        return true;
                }
            }
            else if (dx == 0)
            {
                if (!grid.IsWalkable(p.x - 1, p.y - dy))
                {
                    if (grid.IsWalkable(p.x - 1, p.y))
                        return true;
                }

                if (!grid.IsWalkable(p.x + 1, p.y - dy))
                {
                    if (grid.IsWalkable(p.x + 1, p.y))
                        return true;
                }
            }

            return false;
        }

        private void ExpandNode(Vector2Int jp, Node jn, Node parent)
        {
            float extraG = Euclidean(jp, parent.Pos);
            float newG = parent.G + extraG;
            if (!jn.IsOpen || newG < jn.G)
            {
                jn.G = newG;
                jn.F = jn.G + Manhattan(jp, endPos);
                jn.Parent = parent;
                if (!jn.IsOpen)
                {
                    openList.Enqueue(jn, jn.F);
                    jn.SetOpen();
                }
                else
                {
                    openList.UpdatePriority(jn, jn.F);
                }
            }
        }

        private Node GetNode(Vector2Int pos)
        {
            Node node;
            if (nodeMap.TryGetValue(pos, out node))
            {
                return node;
            }

            node = new Node();
            node.Pos = pos;
            nodeMap.Add(pos, node);
            return node;
        }

        private float Chebyshev(Vector2Int a, Vector2Int b)
        {
            int dx = Math.Abs(a.x - b.x);
            int dy = Math.Abs(a.y - b.y);
            return Math.Max(dx, dy);
        }
        
        private float Manhattan(Vector2Int a, Vector2Int b)
        {
            int dx = Math.Abs(a.x - b.x);
            int dy = Math.Abs(a.y - b.y);
            return dx + dy;
        }

        private float Euclidean(Vector2Int a, Vector2Int b)
        {
            return Vector2Int.Distance(a, b);
        }
        
    }

}



