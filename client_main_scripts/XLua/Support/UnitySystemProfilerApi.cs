using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;
using UnityEngine.Profiling;

// 目前用来测试

public class UnitySystemProfilerApi
{
    private static readonly Dictionary<long, string> _showNames = new Dictionary<long, string>(32);
    
    public delegate void BeginSample(IntPtr pointer);
    public delegate void EndSample();

    [DllImport("xlua", CallingConvention = CallingConvention.Cdecl)]
    public static extern void InitProfileDelegate(BeginSample begin, EndSample end);

    public static void InitUnityProfile_xLuaDll()
    {
        InitProfileDelegate(Unity_BeginSample, Unity_EndProfile);
    }

    // 这个pointer表示从C传过来的字符串，注意必须是一个常量指针，否则统计会有点问题
    [MonoPInvokeCallback(typeof(BeginSample))]
    public static void Unity_BeginSample(IntPtr pointer)
    {
        long l = pointer.ToInt64();
        if (_showNames.TryGetValue(l, out string name))
        {
            Profiler.BeginSample(name);
            return;
        }
        
        string message = Marshal.PtrToStringAnsi(pointer);
        _showNames[l] = message;
        Profiler.BeginSample(message);
    }
    
    [MonoPInvokeCallback(typeof(EndSample))]
    public static void Unity_EndProfile()
    {
        Profiler.EndSample();
    }
    
    
    
    // public delegate void BeginSample_NoParam();
    //
    // [DllImport("xlua", CallingConvention = CallingConvention.Cdecl)]
    // public static extern void InitProfileBeginDelegate_NoParam(BeginSample_NoParam sample);
    //
    // [MonoPInvokeCallback(typeof(BeginSample_NoParam))]
    // public static void Unity_BeginSample_NoParam()
    // {
    //     Profiler.BeginSample("lsz");
    // }
}