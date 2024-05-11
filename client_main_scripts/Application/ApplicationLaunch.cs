using System;
using System.Text;
using DG.Tweening;
using GameFramework;
using GameKit.Base;
using UnityEngine;
using UnityEngine.Profiling;

public class ApplicationLaunch : MonoBehaviour
{
    private static ApplicationLaunch _instance;

    public static ApplicationLaunch Instance
    {
        get { return _instance; }
    }

#if OLD_PACK
    private const string googlePublicKey =
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiYVPWSTL1D2+Rbyx9uyAx6PlPuXGGufEqInq1LfN3Thu7g6XYniKB0zhUKElEhSHxKMHJSJYK7TpUx6NGmW075+VHngPNHa94wZakn/pUvwoumRad/FJUoTlk3JeNfemlcUHwSNyzrykt1tCYqakgsQzETZY/Bp0C+NjOVzZFqMqZkmHy+n7IJx1GVOU9AW9HHaUmqAvPDLsolpKDoPw5KN1XIw+Z04HDjgpG3m9p+YaDNuUUWcJu12oQ+2qTrwzZSwwLe/hlG6uFciD6aar7/rbXydFZjYGQVeMMj4YQhe4T7ROEq6tlobn2yEeeJw8JMj92K46XbVeCMnJK+Vv3wIDAQAB";
#else
    private const string googlePublicKey =
 "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr8Ldw9qyOp2M2S78H0znUckZTw+f7np8zK6YdHwJ++qwTnNCWZD/HciziQw5+E1Cf0WezzMXO70vs/iqiUH7AXXsLyktQkp+Na1yTQRCLE/dX31oa9apMEIvFX/oqqRw9Og9kH19VAz8Q4gnv14flPM0b5Ogigm7wIENwe19/bU7VbpHcTNeqJmmynt7iDbKg7y/2IvNKJifcvlmYEF5YGL0CzM8Ju4WGttzaSE6HFdgYvqoI/SFMCVSxH7hw7WWv9fQcggTfmN2HAkTov8QRYdBsX+lURgFojMZ6kXp9F9wIkFvBaHE3XXnHCgEA4xvI4ERagW8HIz9FD3UQCljWwIDAQAB";
#endif

    //这里缓存了lua appStartLoading中的uiLoading的request，之所以在这里缓存是因为热更Reload时，不想对uiLoading立即Destroy(立即Destroy会闪一下黑屏)
    //而是等新的uiLoading加载后再Destroy旧的loading,但这个时候lua因为做了Shutdown，丢失了对oldLoading的request引用。因此将loading的request放到这里。
    public static InstanceRequest uiLoadingRequest;
    
    // // 配置的zip处理
    private ZipDataTable _zipDataTable;
    
    // private ITimer checkOfflineTimer;
    //记录进入后台的时间
    private long enterBackGroundTime = 0;
    private bool isReloadGame = false;
    private bool isRestartGame = false;
    private LogFile logFile;

    private double _lastUpdateTime;
    

    void Awake()
    {
#if !UNITY_EDITOR
        // 普通 LOG 输出不输出整个栈了
        Application.SetStackTraceLogType(LogType.Error, StackTraceLogType.ScriptOnly);
        Application.SetStackTraceLogType(LogType.Exception, StackTraceLogType.ScriptOnly);
        Application.SetStackTraceLogType(LogType.Assert, StackTraceLogType.ScriptOnly);
        Application.SetStackTraceLogType(LogType.Log, StackTraceLogType.None);
        Application.SetStackTraceLogType(LogType.Warning, StackTraceLogType.None);
#endif
        Application.lowMemory += OnLowMemory;

        Log.Info("Application Awake!");
        _instance = this;
        DontDestroyOnLoad(gameObject);

        GameEntry.Init();
        GameEntry.Resource.Loggable = GameEntry.Setting.GetBool(GameDefines.SettingKeys.RESOURCE_LOGGER, false);
        CreateZipDataTable();
#if UNITY_IOS || UNITY_IPHONE

        var gm = GameEntry.Setting.GetInt(GameDefines.SettingKeys.GM_FLAG,0);
        if (gm > 0)
        {
            logFile = new LogFile();
            logFile.ClearOld();
            Application.logMessageReceivedThreaded += (condition, trace, type) => { logFile.Write(type, trace, condition); };
        
            BuglyAgent.InitWithAppId("89a43918c9");
            BuglyAgent.EnableExceptionHandler();
            BuglyAgent.ConfigAutoReportLogLevel(LogSeverity.LogInfo);
            BuglyAgent.SetUserId(GameEntry.Setting.GetString(GameDefines.SettingKeys.GAME_UID, ""));
        }
        
#endif
        
#if UNITY_STANDALONE
        logFile = new LogFile();
        logFile.ClearOld();
        Application.logMessageReceivedThreaded += (condition, trace, type) => { logFile.Write(type, trace, condition); };
#endif
        Log.Info("Resource.Initialize.");
        GameEntry.Resource.Initialize(OnResourcesInitialized);
        if (CommonUtils.IsDebug())
        {
            gameObject.AddComponent<ShowFPS>();
        }
        // checkOfflineTimer = GameEntry.Timer.RegisterTimerRepeat(0, 1, CheckOffline);
    }

    private void OnApplicationQuit()
    {
        Log.Error("app quit real begin");
        try
        {
            PostEventLog.Record(PostEventLog.Defines.APP_QUIT);

            // if (checkOfflineTimer != null)
            // {
            //     GameEntry.Timer.CancelTimer(checkOfflineTimer);
            //     checkOfflineTimer = null;
            // }

            SceneManager.Destroy();
            GameEntry.Shutdown();
            PostEventLog.stop();
        }
        catch (Exception e)
        {
            Log.Error("quit error: {0}", e.StackTrace);
        }
    }

    private void Update()
    {
        try
        {
            if (isReloadGame)
            {
                ReloadGameImpl(true);
                isReloadGame = false; 
            }
            if (isRestartGame)
            {
                ReloadGameImpl(false);
                isRestartGame = false;
            }
            GameEntry.Update(Time.deltaTime);
            SceneManager.Update();
            if (Time.time - _lastUpdateTime > 1)
            {
                CheckOffline();
                _lastUpdateTime = Time.time;
            }
        }
        catch (Exception e)
        {
            Log.Error("app launch error {0}_{1}",e.Message, e.StackTrace);
        }
        
    }

    private void LateUpdate()
    {
        SceneManager.LateUpdate();
    }

    private void FixedUpdate()
    {
        SceneManager.Update();
        if (isResourceInitOk)
        {
            bool ret = GameEntry.Sdk.IsShowLogoOk();
            if (ret == true)
            {
                DoLoadGame(false, true);
                isResourceInitOk = false;
            }
        }
    }

    private void DoLoadGame(bool isReload, bool showLogo)
    {
        // 初始化xlua引擎 
        GameEntry.Lua.Initialize();
        GameEntry.Lua.StartGame();
        Log.Info("XLua Initialized: {0} ", Time.realtimeSinceStartup);
        
        GameEntry.Localization.Initialize(GameEntry.Setting.UserLanguage);
        GameEntry.Localization.LoadDictionary("Dialog");
        if (XLuaManager.IsUseLuaLoading)
        {
            GameEntry.Lua.DoLuaLoading(isReload, showLogo);
        }
    }

    private bool isResourceInitOk = false;
    /// <summary>
    /// AssetBundle资源管理器初始化回调
    /// </summary>
    /// <param name="key">Key.</param>
    /// <param name="obj">Object.</param>
    /// <param name="err">Error.</param>
    private void OnResourcesInitialized(bool succ)
    {
        Log.Info("OnResourcesInitialized {0}.", succ);
        isResourceInitOk = true;
        // 关闭URP的调试界面
#if !UNITY_EDITOR
        UnityEngine.Rendering.DebugManager.instance.enableRuntimeUI = false;
#endif
        
    }

    public void Quit()
    {
        Log.Error("app quit begin");
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#elif UNITY_ANDROID && !UNITY_2018_4_OR_NEWER // Application.Quit() crash has been fixed after 2018.4
        AndroidUtils.Quit();
#else
        Application.Quit();
#endif
    }
    public void ReloadGame()
    {
        isReloadGame = true;
    }

    private void ReloadGameImpl(bool needReload)
    {
        try
        {
            GameEntry.Lua.ExitGame();
            SceneManager.Destroy();
            GameEntry.Event.Shutdown();
            GameEntry.Network.Shutdown();
            GameEntry.Timer.Shutdown();
            GameEntry.Sdk.Shutdown();
            GameEntry.BuildAnimatorManager.Shutdown();
            GameEntry.Sound.StopAllSounds();
            GameObjectPool.Instance.ClearPool();
            GameEntry.Data.Reset();
            GameEntry.GlobalData.Reset();
            GameEntry.Resource.Clear();
            GameEntry.ConfigCache.reset();
            GameEntry.Lua.Shutdown();
        } 
        catch (Exception e)
        {
            Log.Error("ReloadGameImpl error: {0}", e.StackTrace);
        }

        Log.Info("ReloadGameImpl finish");
        DoLoadGame(needReload, false);
    }

    public void ReStartGame()
    {
        isRestartGame = true;
    }

    public void StartNewGame()
    {
        UnityEngine.PlayerPrefs.DeleteAll();
        ApplicationLaunch.Instance.ReloadGame();
    }
    private void OnApplicationPause(bool pause)
    {
        GameEntry.GlobalData.isInBackGround = pause;
        if (pause)
        {
            ApplicationDidEnterBackground();
        }
        else
        {
            ApplicationWillEnterForeground();
        }
    }

    /*
        是否需要重连 
        重连策略： 
        1、如果网络断开了需要重连  
        2、如果在后台的时长超过60秒重连 
        3、在loading界面不重连 
        4、被别人顶了不重连，会弹出提示，点击后直接退出    
    */
    private bool IsNeedReConnect()
    {
        if (SceneManager.IsSceneNone())
            return false;
        

        if(GameEntry.GlobalData.pushOffWithQuitGame)
            return false;

        long curTime = GameEntry.Timer.GetLocalSeconds();
        if(GameEntry.Network.IsConnected == false || curTime - enterBackGroundTime > 60)
        {
            return true;
        }
        return false;
    }

    private bool IsNeedReload()
    {
        long curTime = GameEntry.Timer.GetLocalSeconds();
        if (enterBackGroundTime > 0 && curTime - enterBackGroundTime > 60 * 15)
        {
            return true;
        }

        return false;
    }
    
    private void ApplicationDidEnterBackground()
    {
        //如果此时聊天界面打开的.切到后台,直接关闭
        if (GameEntry.Lua.UIManager.IsWindowOpen("UIChatNew"))
        {
            GameEntry.Lua.UIManager.DestroyWindow("UIChatNew");
        }
        Log.Debug("程序进入后台~~~~");
        enterBackGroundTime = GameEntry.Timer.GetLocalSeconds();
        GameEntry.Setting.Save();
    }

    private void ApplicationWillEnterForeground()
    {
        Log.Debug("程序进入前台~~~~~");
#if UNITY_ANDROID
        PushNoticeManager.pushDataToHttpServer();
#endif
        /*if (GameEntry.GlobalData.isCallingThirdPlatform)
        {
            //如果在调用第三方app的话切回来就不重连了
            GameEntry.GlobalData.isCallingThirdPlatform = false;
            GameEntry.Timer.SyncPingpong(0);
        }
        else */
        
        if (IsNeedReload())
        {
            ReloadGame();
        }
        else if (IsNeedReConnect())
        {
            GameEntry.Network.SyncPingPong(0);
            DisconnectRetry();
            PostEventLog.Record(PostEventLog.Defines.DISCONNECT_RETRY, "EnterForeground");
        }
    }
    

    private void CheckOffline()
    {
        if (!GameEntry.Network.Logined || GameEntry.GlobalData.pushOffWithQuitGame)
            return;
        

        if (GameEntry.Network.IsPingPongTimeOut)
        {
            PostEventLog.Record(PostEventLog.Defines.DISCONNECT_RETRY, "PingPongTimeOut");
            GameEntry.Network.SyncPingPong(0);
            GameEntry.Network.Disconnect();
            DisconnectRetry();
        }
    }

    public void DisconnectRetry()
    {
        if (GameEntry.Lua.UIManager.IsWindowOpen("UIDisconnect"))
            return;

        GameEntry.OnDisconnectRetry();
        GameEntry.Lua.UIManager.OpenWindow("UIDisconnect", GameDefines.UILayer.TopMost);
    }

    private void OnLowMemory()
    {
        StringBuilder builder = new StringBuilder();
        builder.AppendLine("OnLowMemory");
        builder.AppendLine("TempAllocatorSize " + Profiler.GetTempAllocatorSize());
        builder.AppendLine("MonoHeapSize " + Profiler.GetMonoHeapSizeLong());
        builder.AppendLine("MonoUsedSize " + Profiler.GetMonoUsedSizeLong());
        builder.AppendLine("TotalAllocatedMemory " + Profiler.GetTotalAllocatedMemoryLong());
        builder.AppendLine("TotalUnusedReservedMemory " + Profiler.GetTotalUnusedReservedMemoryLong());
        builder.AppendLine("TotalReservedMemory " + Profiler.GetTotalReservedMemoryLong());
        builder.AppendLine("AllocatedMemoryForGraphicsDriver " + Profiler.GetAllocatedMemoryForGraphicsDriver());
        Log.Info(builder.ToString());
    }
    public void CreateZipDataTable()
    {
        _zipDataTable = new ZipDataTable();
    }

    public ZipDataTable GetZipDataTable()
    {
        return _zipDataTable;
    }
}