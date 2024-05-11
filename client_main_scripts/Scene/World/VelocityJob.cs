using System;
using System.Collections.Generic;
using Unity.Collections;
using GameFramework;
using Unity.Jobs;
using Unity.Mathematics;
using Protobuf;
using Sfs2X.Requests;
using UnityEngine;

public struct VelocityJob : IJobParallelFor
{
    public NativeArray<float3> positions;
    [ReadOnly]
    public NativeArray<float3> startPositions;
    [ReadOnly]
    public NativeArray<double> timeArray;
    [WriteOnly]
    public NativeArray<float> distances;
    [ReadOnly]
    public NativeArray<float3> endPos;
    [ReadOnly]
    public double delaTime;
    [ReadOnly]
    public NativeArray<bool> isCreateFinish;


    public void Execute(int index)
    {
        if (isCreateFinish[index] == false)
        {
            return;
        }
        var center = (startPositions[index] + endPos[index]) * 0.5f;

        center -= new float3(0, 7, 0);

        float3 start = startPositions[index] - center;

        float3 end = endPos[index] - center;

        var dddd =(float)((delaTime - timeArray[index])*0.0015f);

        positions[index] = Vector3.Slerp(start, end, dddd);

        positions[index] += center;

        distances[index] = math.distance(positions[index], endPos[index]);


    }
}