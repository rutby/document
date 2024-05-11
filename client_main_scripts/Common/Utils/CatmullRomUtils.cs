
using System.Collections.Generic;
using UnityEngine;

public class CatmullRomUtils
{
    public static List<Vector3> CalcCatmullRomCurve(List<Vector3> ctrlPoints,bool loop)
    {
        if (ctrlPoints == null || ctrlPoints.Count <= 2) return null;
        List<Vector3> points = new List<Vector3>();

        int current = 0;

        //绘制0~n-1
        for (; current < ctrlPoints.Count - 1; current++)
        {
            if (current == 0) // 第一个点时，其相关的四个点为 0,0,1,2
            {
                GetCatmullRomSplinePos(points, ctrlPoints[0], ctrlPoints[0], ctrlPoints[1], ctrlPoints[2]);
            }
            else if (current == ctrlPoints.Count - 2) // 为倒数第二个点: n-3,n-2,n-1,n-1
            {
                GetCatmullRomSplinePos(points, ctrlPoints[current - 1], ctrlPoints[current], ctrlPoints[current + 1], ctrlPoints[current + 1]);
            }
            else
            {
                GetCatmullRomSplinePos(points, ctrlPoints[current - 1], ctrlPoints[current], ctrlPoints[current + 1], ctrlPoints[current + 2]);
            }
        }

        if (loop) // 循环就是绘制最后一个点与第一个点之间的线段 ： n - 2,n-1,0,1
        {
            current = ctrlPoints.Count - 1;
            GetCatmullRomSplinePos(points, ctrlPoints[current - 1], ctrlPoints[current], ctrlPoints[0], ctrlPoints[1]);
        }

        return points;
    }

    private const int SIMPLE_POINT_PRE_UNIT = 50;
    private static void GetCatmullRomSplinePos(List<Vector3> pos, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
    {
        int loops = Mathf.CeilToInt(Mathf.Abs(p1.x - p2.x) * SIMPLE_POINT_PRE_UNIT);
        for (int i = 0; i <= loops; i++)
        {
            pos.Add(GetCatmullRomPosition(i /(float)loops, p0, p1, p2, p3));
        }
    }
    
    private static Vector3 GetCatmullRomPosition(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
    {
        Vector3 a = 2 * p1;
        Vector3 b = p2 - p0;
        Vector3 c = 2 * p0 - 5 * p1 + 4 * p2 - p3;
        Vector3 d = -p0 + 3 * p1 - 3 * p2 + p3;
        Vector3 pos = 0.5f * (a + (b * t) + (c * t * t) + (d * t * t * t));
        return pos;
    }

    public static List<Vector3> CalcCurve(Vector3 start,Vector3 end, float hwRatio)
    {
        var path = new List<Vector3>(2);
        path.Add(start);
        path.Add(end);
        float dis = Vector3.Distance(start, end);
        Vector3 ctrPoint = (start + end) / 2 + new Vector3(0,dis * hwRatio,0);
        path.Insert(1,ctrPoint);
        return CalcCatmullRomCurve(path,10);
    }

    public static List<Vector3> CalcCurveByPoints(Vector3 start,Vector3 end, Vector3 center)
    {
        var path = new List<Vector3>(3);
        path.Add(start);
        path.Add(center);
        path.Add(end);
        return CalcCatmullRomCurve(path,10);
    }

    public static List<Vector3> CalcCatmullRomCurve(List<Vector3> ctrlPoints,int frameCount)
    {
        if (ctrlPoints == null || ctrlPoints.Count <= 2) return null;
        List<Vector3> points = new List<Vector3>();

        List<int> frames = new List<int>();
        List<float> distance = new List<float>();
        float allDistance = 0;
        for (int i = 0; i < ctrlPoints.Count; i++)
        {
            if (i < ctrlPoints.Count - 1)
            {
                float dis = Vector3.Distance(ctrlPoints[i], ctrlPoints[i + 1]);
                allDistance += dis;
                distance.Add(dis);
            }
        }

        for (int i = 0; i < distance.Count; i++)
        {
            frames.Add((int) (frameCount * (distance[i] / allDistance)));
        }
        
        
        int current = 0;

        //绘制0~n-1
        for (; current < ctrlPoints.Count - 1; current++)
        {
            if (current == 0) // 第一个点时，其相关的四个点为 0,0,1,2
            {
                GetCatmullRomSplinePos(points, ctrlPoints[0], ctrlPoints[0], ctrlPoints[1], ctrlPoints[2],frames[current]);
            }
            else if (current == ctrlPoints.Count - 2) // 为倒数第二个点: n-3,n-2,n-1,n-1
            {
                GetCatmullRomSplinePos(points, ctrlPoints[current - 1], ctrlPoints[current], ctrlPoints[current + 1],
                    ctrlPoints[current + 1], frames[current]);
            }
            else
            {
                GetCatmullRomSplinePos(points, ctrlPoints[current - 1], ctrlPoints[current], ctrlPoints[current + 1],
                    ctrlPoints[current + 2], frames[current]);
            }
        }
        return points;
    }
    
    private static void GetCatmullRomSplinePos(List<Vector3> pos, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, int frame)
    {
        int loops = frame;
        if (frame==0)
        {
            pos.Add(p1);
        }
        else
        {
            for (int i = 0; i <= loops; i++)
            {
                pos.Add(GetCatmullRomPosition(i /(float)loops, p0, p1, p2, p3));
            }
        }
    }
}