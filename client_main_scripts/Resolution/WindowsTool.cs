/// <summary>
/// 窗口工具系统类(窗口状态)
/// </summary>

using System;
using System.Runtime.InteropServices;
using UnityEngine;

public class WindowsTool: MonoBehaviour
{
    private static WindowsTool _instance;

    public static WindowsTool Instance
    {
        get { return _instance; }
    }
    #region 系统字段 & 系统方法
    

    //获取当前激活窗口
    [DllImport("user32.dll", EntryPoint = "GetForegroundWindow")]
    public static extern System.IntPtr GetForegroundWindow();
    
    //设置窗口位置，尺寸
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    
    //获取窗口位置以及大小
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, ref WIN_RECT lpRect);
    [StructLayout(LayoutKind.Sequential)]
    public struct WIN_RECT
    {
        public int Left; //最左坐标
        public int Top; //最上坐标
        public int Right; //最右坐标
        public int Bottom; //最下坐标
    }
    //边框参数
    private const uint SWP_SHOWWINDOW = 0x0040;

    #endregion

    #region 方法


    void Awake()
    {
        _instance = this;
    }
    private bool SetWindows(int x,int y,int width,int height)
    {
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
        
        return SetWindowPos(GetForegroundWindow(), 0, x, y, width, height, SWP_SHOWWINDOW);
#endif
        return false;
    }

    public bool SetResolution(int width, int height)
    {
        int x = (int)(Screen.currentResolution.width / 2) ;
        int y = (int)(Screen.currentResolution.height / 2) ;
        int x1 = x-(int)(width/2);
        int y1 = y-(int)(height/2);
        return SetWindows(x1, y1, width, height);
    }

    public void EnterFullScreen()
    {
        int x = (int)(Screen.currentResolution.width / 2) ;
        int y = (int)(Screen.currentResolution.height / 2) ;
        int width = Screen.currentResolution.width;
        int heigh = Screen.currentResolution.height;
        int x1 = x - (int)(width * 0.5f);
        int y1 = y - (int)(heigh * 0.5f);
        SetWindows(x1, y1, width, heigh);
        Screen.fullScreenMode = FullScreenMode.FullScreenWindow;
    }

    public void QuitFullScreen()
    {
        Screen.fullScreenMode = FullScreenMode.Windowed;
    }

    public bool GetIsFullScreen()
    {
        if (Screen.fullScreenMode == FullScreenMode.FullScreenWindow)
        {
            return true;
        }

        return false;
    }
    
    private Rect GetWindowInfo()
    {
        Rect targetRect = new Rect();
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
        WIN_RECT rect = new WIN_RECT();
        GetWindowRect(GetForegroundWindow(), ref rect);
        targetRect.width = Mathf.Abs(rect.Right - rect.Left);
        targetRect.height = Mathf.Abs(rect.Top - rect.Bottom);
        targetRect.x = rect.Left;
        targetRect.y = rect.Top;
#endif
        return targetRect;
    }

    public int GetWindowsWidth()
    {
        var width = 0;
        var data = GetWindowInfo();
        return (int)data.width;
    }
    public int GetWindowsHeight()
    {
        var width = 0;
        var data = GetWindowInfo();
        return (int)data.height;
    }


    #endregion
    
}