using System.Collections.Generic;
using UnityEngine;

public class PVEUnitManager
{
    private AreaMatrix areaMatrix;
    private List<CitySpaceManTrigger> unitsCache;

    public static bool Available => true;

    public void Init()
    {
        areaMatrix = new AreaMatrix();
        unitsCache = new List<CitySpaceManTrigger>();
    }

    public void UnInit()
    {

    }

    public void SetArea(float x, float y, float width, float height, int cellXCount, int cellYCount)
    {
        areaMatrix.Set(x, y, width, height, cellXCount, cellYCount);
    }

    public void ClearArea()
    {
        areaMatrix.Clear();
    }
    
    public void AddTriggers(List<CitySpaceManTrigger> triggers)
    {
        foreach (CitySpaceManTrigger trigger in triggers)
        {
            AddTrigger(trigger);
        }
    }
    
    public void AddTrigger(CitySpaceManTrigger trigger)
    {
        areaMatrix.AddItem(trigger);
    }

    public List<CitySpaceManTrigger> GetUnitsInCircle(float x, float z, float radius)
    {
        areaMatrix.GetItemsInCircle(ref unitsCache, x, z, radius);
        return unitsCache;
    }

    public List<CitySpaceManTrigger> GetUnitsInRect(float x, float z, float sizeX, float sizeZ)
    {
        areaMatrix.GetItemsInRect(ref unitsCache, x, z, sizeX, sizeZ);
        return unitsCache;
    }

    private class AreaMatrix
    {
        private readonly Dictionary<int, Dictionary<int, List<CitySpaceManTrigger>>> areas;

        private float x;
        private float z;
        private float width;
        private float height;
        private int cellXCount;
        private int cellYCount;
        private float cellWidth;
        private float cellHeight;

        public AreaMatrix()
        {
            areas = new Dictionary<int, Dictionary<int, List<CitySpaceManTrigger>>>();
        }

        public void Set(float x, float z, float width, float height, int cellXCount, int cellYCount)
        {
            areas.Clear();
            this.x = x;
            this.z = z;
            this.width = width;
            this.height = height;
            this.cellXCount = cellXCount;
            this.cellYCount = cellYCount;
            cellWidth = width / cellXCount;
            cellHeight = height / cellYCount;
        }

        public void Clear()
        {
            foreach (Dictionary<int, List<CitySpaceManTrigger>> v in areas.Values)
            foreach (List<CitySpaceManTrigger> list in v.Values)
                list.Clear();
        }

        public void AddByIndex(int i, int j, CitySpaceManTrigger item)
        {
            if (!areas.ContainsKey(i))
                areas[i] = new Dictionary<int, List<CitySpaceManTrigger>>();
            if (!areas[i].ContainsKey(j))
                areas[i][j] = new List<CitySpaceManTrigger>();
            areas[i][j].Add(item);
        }

        public void AddByXZ(float x, float z, CitySpaceManTrigger item)
        {
            GetIndexByXZ(x, z, out int i, out int j);
            AddByIndex(i, j, item);
        }

        public void AddItem(CitySpaceManTrigger item)
        {
            Vector3 pos = item.transform.position;
            GetIndexByXZ(pos.x, pos.z, out int i, out int j);
            AddByIndex(i, j, item);
        }

        public void GetIndexByXZ(float x, float z, out int i, out int j)
        {
            i = Mathf.FloorToInt((x - this.x) / cellWidth);
            i = Mathf.Clamp(i, 0, cellXCount - 1);
            j = Mathf.FloorToInt((z - this.z) / cellHeight);
            j = Mathf.Clamp(j, 0, cellYCount - 1);
        }

        public void GetItemsInCircle(ref List<CitySpaceManTrigger> items, float x, float z, float radius)
        {
            items.Clear();
            GetIndexByXZ(x - radius, z - radius, out int left, out int bottom);
            GetIndexByXZ(x + radius, z + radius, out int right, out int top);
            // 索敌时扩大一圈
            left--;
            bottom--;
            right++;
            top++;
            for (int i = left; i <= right; i++)
            {
                if (!areas.ContainsKey(i))
                    continue;

                for (int j = bottom; j <= top; j++)
                {
                    if (!areas[i].ContainsKey(j))
                        continue;

                    foreach (CitySpaceManTrigger item in areas[i][j])
                    {
                        if (item == null)
                            continue;
                        
                        Vector3 center = item.GetCurCenter();
                        if (item.Radius > 0) // 圆和圆
                        {
                            if (IsCircleOverlapCircle(x, z, radius, center.x, center.z, item.Radius))
                            {
                                items.Add(item);
                            }
                        }
                        else if (item.SizeX > 0 && item.SizeZ > 0) // 圆和矩形
                        {
                            if (IsCircleOverlapRect(x, z, radius, center.x, center.z, item.SizeX, item.SizeZ))
                            {
                                items.Add(item);
                            }
                        }
                    }
                }
            }
        }

        public void GetItemsInRect(ref List<CitySpaceManTrigger> items, float x, float z, float sizeX, float sizeZ)
        {
            items.Clear();
            float halfSizeX = sizeX * 0.5f;
            float halfSizeZ = sizeZ * 0.5f;
            GetIndexByXZ(x - halfSizeX, z - halfSizeX, out int left, out int bottom);
            GetIndexByXZ(x + halfSizeZ, z + halfSizeZ, out int right, out int top);
            // 索敌时扩大一圈
            left--;
            bottom--;
            right++;
            top++;
            for (int i = left; i <= right; i++)
            {
                if (!areas.ContainsKey(i))
                    continue;

                for (int j = bottom; j <= top; j++)
                {
                    if (!areas[i].ContainsKey(j))
                        continue;

                    foreach (CitySpaceManTrigger item in areas[i][j])
                    {
                        if (item == null)
                            continue;
                        
                        Vector3 center = item.GetCurCenter();
                        if (item.Radius > 0) // 矩形和圆
                        {
                            if (IsCircleOverlapRect(center.x, center.z, item.Radius, x, z, sizeX, sizeZ))
                            {
                                items.Add(item);
                            }
                        }
                        else if (item.SizeX > 0 && item.SizeZ > 0) // 矩形和矩形
                        {
                            if (IsRectOverlapRect(x, z, sizeX, sizeZ, center.x, center.z, item.SizeX, item.SizeZ))
                            {
                                items.Add(item);
                            }
                        }
                    }
                }
            }
        }

        private bool IsCircleOverlapCircle(float x1, float y1, float r1, float x2, float y2, float r2)
        {
            float dx = x1 - x2;
            float dy = y1 - y2;
            float rSum = r1 + r2;
            return dx * dx + dy * dy <= rSum * rSum;
        }

        private bool IsCircleOverlapRect(float x1, float y1, float r1, float x2, float y2, float w2, float h2)
        {
            // 矩形中心为 O，将圆放到第一象限
            float dx = Mathf.Abs(x1 - x2);
            float dy = Mathf.Abs(y1 - y2);
            // (mx, my) 是矩形右上角到圆心的最短向量
            float mx = Mathf.Max(dx - w2 * 0.5f, 0);
            float my = Mathf.Max(dy - h2 * 0.5f, 0);
            return mx * mx + my * my <= r1 * r1;
        }

        private bool IsRectOverlapRect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2)
        {
            float dx = Mathf.Abs(x1 - x2);
            float dy = Mathf.Abs(y1 - y2);
            return 2 * dx <= w1 + w2 && 2 * dy <= h1 + h2;
        }
    }
}