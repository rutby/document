//------------------------------------------------------------
// Game Framework v3.x
// Copyright © 2013-2018 Jiang Yin. All rights reserved.
// Homepage: http://gameframework.cn/
// Feedback: mailto:jiangyin@gameframework.cn
//------------------------------------------------------------

using GameFramework;
using UnityEngine;
using UnityGameFramework.Runtime;

/// <summary>
/// 游戏入口。
/// </summary>
public static class GameEntry
{
    // 基础设置
    public static BaseComponent GameBase { get; private set; }

    // 事件订阅
    public static EventComponent Event { get; private set; }

    public static Transform UIContainer { get; private set; }
    
    // UI相机
    public static Camera UICamera { get; private set; }
    
    // 资源管理
    public static ResourceManager Resource { get; private set; }

    // 本地化
    public static LocalizationManager Localization { get; private set; }

    // 网络连接
    public static NetworkManager Network { get; private set; }

    // 跨服链接 
    public static CrossServerComponent NetworkCross { get; private set; }

    // 声效管理
    public static SoundComponent Sound { get; private set; }

    // 客户端设置存储
    public static SettingManager Setting { get; private set; }

    // Lua脚本管理
    public static XLuaManager Lua { get; private set; }

    // 玩家数据
    public static CustomDataManager Data { get; private set; }

    //pb预处理
    public static PBController pb { get; private set; }

    // 定时器
    public static TimerComponent Timer { get; private set; }
    
    // 
    public static GlobalDataManager GlobalData { get; private set; }

    // 原生系统SDK
    public static SDKManager Sdk { get; private set; }

    // 设备信息
    public static DeviceManager Device { get; private set; }
    
    public static BuildAnimatorManager BuildAnimatorManager { get; private set; }

    public static ConfigCache ConfigCache { get; private set; }

    public static void Init()
    {
        Log.Info("GameEntry Init Begin.");
        Event = new EventComponent(EventPoolMode.AllowNoHandler | EventPoolMode.AllowMultiHandler);
        Localization = new LocalizationManager();
        Network = new NetworkManager();
        NetworkCross = new CrossServerComponent();
        Sound = new SoundComponent();
        Setting = new SettingManager();
        Data = new CustomDataManager();
        pb = new PBController();
        Timer = new TimerComponent();
        GlobalData = new GlobalDataManager();
        Resource = new ResourceManager();
        Lua = new XLuaManager();
        Sdk = new SDKManager();
        Sdk.Initialize();
        Device = new DeviceManager();
        ConfigCache = new ConfigCache();
        BuildAnimatorManager = new BuildAnimatorManager();
        UIContainer = GameObject.Find("GameFramework/UI/UIContainer").transform;
        UICamera = GameObject.Find("GameFramework/UI/UICamera").GetComponent<Camera>();
        
        var trans = GameObject.Find("GameFramework/UI/UICamera").transform;
        if (trans!=null)
        {
                
            var uiCamera = trans.GetComponent<Camera>();
            trans.position = new Vector3(Screen.width/2, Screen.height/2, -10);
            uiCamera.orthographicSize = Screen.height / 2;
        }
        Log.Info("GameEntry Init End.");
    }

    public static void RegisterComponent(GameFrameworkComponent com)
    {
        if (com.GetType() == typeof(BaseComponent))
        {
            GameBase = com as BaseComponent;
        }
    }

    // 开始重连之前调用
    public static void OnDisconnectRetry()
    {
        // 重连时清除配置缓存
        ConfigCache.reset();
    }

    public static void Shutdown()
    {
        Lua.ExitGame();
        Event.Shutdown();
        Network.Shutdown();
        Timer.Shutdown();
        Sdk.Shutdown();
        BuildAnimatorManager.Shutdown();
        Resource.Clear();
        ConfigCache.reset();
        Lua.Shutdown();
    }

    /// <summary>
    /// 所有游戏框架模块轮询。
    /// </summary>
    /// <param name="elapseSeconds">逻辑流逝时间，以秒为单位。</param>
    /// <param name="realElapseSeconds">真实流逝时间，以秒为单位。</param>
    public static void Update(float elapseSeconds)
    {
        Event.OnUpdate(elapseSeconds);
        Network.OnUpdate(elapseSeconds);
        NetworkCross.OnUpdate(elapseSeconds);
        Timer.OnUpdate(elapseSeconds);
        Sound.OnUpdate(elapseSeconds);
        
        Sdk.OnUpdate(elapseSeconds);
        Lua.Update();
        Resource.Update();
        // ChatTranslator.Update();
        
        // 聊天更新
        ChatService.Instance.OnUpdate();
    }
}