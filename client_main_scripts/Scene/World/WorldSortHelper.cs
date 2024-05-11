using System.Collections.Generic;
using UnityEngine;

public class WorldSortHelper
{
    int _count;
    SortHelpHeap _helper;
    public WorldSortHelper(int count)
    {
        _count = count;
        _helper = new SortHelpHeap(count);
    }

    public void GetSortList(Vector2Int cameraPoint, Dictionary<int, PointInfo> sortList, List<PointInfo> outList)
    {
        if (sortList.Count < _count)
        {
            foreach (var tmp in sortList)
            {
                outList.Add(tmp.Value);
            }
            sortList.Clear();
        }
        else 
        {
            _helper.GetSortList(cameraPoint, sortList, outList); 
        }
    }

    public bool IsOutOfViewRange(int i, Vector2Int cameraPoint)
    {
        var tilePos = SceneManager.World.IndexToTilePos(i);
        var dist = Mathf.Max(SortHelpHeap.fastAbs(tilePos.x - cameraPoint.x), SortHelpHeap.fastAbs(tilePos.y - cameraPoint.y));
        if (dist >= 25)
        {
            return true;
        }

        return false;
    }

}



public class SortHelpHeap
{
    private PointInfo[] heap;

    private int Size = 0;
    private int capacity;
    private Vector2Int _comparePoint;

    public SortHelpHeap(int capacity)
    {
        if (heap == null)
        {
            heap = new PointInfo[capacity];
        }

        this.capacity = capacity;
    }

    public void GetSortList(Vector2Int cameraPoint, Dictionary<int, PointInfo> sortList, List<PointInfo> outList)
    {
        _comparePoint = cameraPoint;
        Size = 0;
        foreach (var tmp in sortList){
            Add(tmp.Value);
        }

        for (int i = 0; i < Size; ++i){
            PointInfo tmp = heap[i];
            outList.Add(tmp);
            sortList.Remove(tmp.pointIndex);
        }
    }

    private void Add(PointInfo node)
    {
        if (Size == 0)
        {
            heap[0] = node;
            this.Size++;
        }
        else if (this.Size == this.capacity)
        {
            ProcessFullHeap(node);
        }
        else if (this.Size < this.capacity)
        {
            heap[this.Size] = node;

            int ParentPos = (this.Size - 1) >> 1;
            int curPos = this.Size;

            while (ParentPos >= 0)
            {
                if (!comparePoint(heap[ParentPos].pointIndex, heap[curPos].pointIndex))
                {
                    Swap(ref heap[ParentPos], ref heap[curPos]);
                    curPos = ParentPos;
                    ParentPos = (curPos - 1) >> 1;
                }
                else
                {
                    break;
                }
            }

            this.Size++;
        }
    }

    private bool comparePoint(int index1, int index2)
    {
        var t1 = SceneManager.World.IndexToTilePos(index1);
        var t2 = SceneManager.World.IndexToTilePos(index2);
        int d1 = fastAbs(t1.x - _comparePoint.x) + fastAbs(t1.y - _comparePoint.y);
        int d2 = fastAbs(t2.x - _comparePoint.x) + fastAbs(t2.y - _comparePoint.y);
        return d1 > d2;
    }

    private void ProcessFullHeap(PointInfo node)
    {
        if (comparePoint(node.pointIndex, heap[0].pointIndex))
        {
            return;
        }

        heap[0] = node;
        int curPos = 0;
        int left = (curPos << 1) + 1;
        int right = (curPos << 1) + 2;

        while (left < this.Size)
        {
            PointInfo root = heap[curPos];
            int compareIndex = left;
            if (right < this.Size)
            {
                if (!comparePoint(heap[left].pointIndex, heap[right].pointIndex))
                {
                    compareIndex = right;
                }
            }
            if (!comparePoint(heap[curPos].pointIndex, heap[compareIndex].pointIndex)){
                Swap(ref heap[curPos], ref heap[compareIndex]);
                curPos = compareIndex;
            } else {
                break;
            }

            left = (curPos << 1) + 1;
            right = (curPos << 1) + 2;
        }

    }

    private void Swap(ref PointInfo a, ref PointInfo b)
    {
        PointInfo temp = a;
        a = b;
        b = temp;
    }

    public static int fastAbs(int value)//求绝对值
    {
        return (value ^ (value >> 31)) - (value >> 31);
    }

}