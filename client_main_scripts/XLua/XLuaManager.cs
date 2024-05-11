using System;
using System.Collections.Generic;
using System.IO;
using GameFramework;
using UnityEngine;
using XLua;

// for partial class!
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;

public partial class XLuaManager
{
    private static readonly string[] LuaRootPath = {"Assets/Main/LuaTxt/", "Assets/Main/DataTable/LuaTxt/"};
    private static readonly string[] LuaRootPathEditor = {"/Main/LuaScripts/", "/Main/DataTable/Lua/"};

    private static readonly string LuaDataTableRootPath = "/ZipDocument/getnewlua/";
    private const string CommonMainScriptName = "Common.Main";
    private const string GameMainScriptName = "GameMain";

    public static bool IsUseLoadAsync = false;
    public static bool IsUseLuaLoading = false;
    public static bool IsUseLuaWorldPoint = false;
    private Dictionary<string, VEngine.Asset> m_LuaScripts = new Dictionary<string, VEngine.Asset>();

    private System.Action OnInitCallback;

    private LuaEnv m_LuaEnv = null;
    private LuaUpdater m_LuaUpdater = null;
    private GameObject updaterObject;
    private LuaScriptInterface.UIManager uiManager;
    private LuaScriptInterface.EventManager eventManager;
    private LuaScriptInterface.QueueDataManager queueDataManager;
    private LuaScriptInterface.BuildQueueManager buildQueueManager;
    private LuaScriptInterface.ItemData itemManager;


    [CSharpCallLua]
    public delegate void DataCenterInitDelegate();

    [CSharpCallLua]
    public delegate void UITimeForLuaDelegate(long timeStamp);

    [CSharpCallLua]
    public delegate void UIShowTipsDelegate(string msg, string img, string atlas);

    [CSharpCallLua]
    public delegate void UIShowFoldUpBuild(string posX, string posY, string posZ, string bUuid);

    [CSharpCallLua]
    public delegate void UIShowMessageDelegate(string tipText, int btnNum, string text1, string text2, Action action1,
        Action action2, Action closeAction, string titleText, bool isChangeImg);

    [CSharpCallLua]
    public delegate void WebSocketProtocalDelegate(string data);

    [CSharpCallLua]
    public delegate string GetTemplateDataFromLua(string xmlId, int id, string attrStr);

    [CSharpCallLua]
    public delegate void UpdateResourceItemMaxValueDelegate();

    [CSharpCallLua]
    public delegate void PreloadAssetsDelegate();

    [CSharpCallLua]
    public delegate void LuaLoadPbConfig(byte[] bytes);

    [CSharpCallLua]
    public delegate int ArmyFormationDataManager(long uuid);

    private LuaFunction dispatchNetMessage;
    private DataCenterInitDelegate dataCenterInit;
    private UITimeForLuaDelegate updateUITimeStamp;
    private UIShowTipsDelegate showTips;
    private UIShowMessageDelegate showMessage;
    private UIShowFoldUpBuild showFoldUpBuild;
    private WebSocketProtocalDelegate webSocketProtocal;
    private GetTemplateDataFromLua getTemplateDataFromLua;
    private ArmyFormationDataManager armyFormationDataManager;
    private PreloadAssetsDelegate preloadAssets;
    private LuaLoadPbConfig luaLoadPbConfig;

    public LuaEnv Env
    {
        get { return m_LuaEnv; }
    }

    // Lua端界面管理器的映射
    public LuaScriptInterface.UIManager UIManager
    {
        get { return uiManager; }
    }

    // Lua端事件管理的映射
    public LuaScriptInterface.EventManager EventManager
    {
        get { return eventManager; }
    }

    // Lua端queue管理的映射
    public LuaScriptInterface.QueueDataManager QueueDataManager
    {
        get { return queueDataManager; }
    }

    public LuaScriptInterface.BuildQueueManager BuildQueueManager
    {
        get { return buildQueueManager; }
    }

    // Lua端道具管理的映射
    public LuaScriptInterface.ItemData ItemManager
    {
        get { return itemManager; }
    }


    public bool HasGameStart { get; protected set; }

    //fix me Initialize方法不能跟shutdown不能在同一帧调用
    public void Initialize(System.Action callback = null)
    {
        Log.Info("xLua Initialize begin.");
        OnInitCallback = callback;

        InitLuaEnv();
        OnInit();
    }

    private void InitLuaEnv()
    {
        HasGameStart = false;
        m_LuaEnv = new LuaEnv();
        ClearCacheTableAll();
        Log.Debug("new luaEnv before init env rawL == RealStatePtr.Zero ? {0} adress {1}", m_LuaEnv.L == RealStatePtr.Zero , m_LuaEnv.GetHashCode());
        if (m_LuaEnv != null)
        {
            m_LuaEnv.AddLoader(CustomLoader);
            m_LuaEnv.AddBuildin("rapidjson", XLua.LuaDLL.Lua.LoadRapidJson);
            m_LuaEnv.AddBuildin("pb", XLua.LuaDLL.Lua.LoadLuaProfobuf);
            initContext();
            Log.Debug("new luaEnv after init env rawL == RealStatePtr.Zero ? {0} adress {1}", m_LuaEnv.L == RealStatePtr.Zero, m_LuaEnv.GetHashCode());
        }
        else
        {
            Log.Error("InitLuaEnv null!!!");
        }
        GameEntry.Event.Fire(EventId.ReInitLoadingLuaState);
    }

    private void OnInit()
    {
        if (m_LuaEnv != null)
        {
            LoadScript(CommonMainScriptName);

            updaterObject = new GameObject("LuaUpdater");
            GameObject.DontDestroyOnLoad(updaterObject);
            m_LuaUpdater = updaterObject.AddComponent<LuaUpdater>();
            m_LuaUpdater.OnInit(m_LuaEnv);
        }

        OnInitCallback?.Invoke();
    }

    public void Update()
    {
        if (m_LuaEnv != null)
        {
            m_LuaEnv.Tick();
        }
    }

    public void StartGame()
    {
        Log.Info("xLua StartGame begin.");
        if (m_LuaEnv != null)
        {
            LoadScript(GameMainScriptName);
            IsUseLoadAsync = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsUseLoadAsync");
            IsUseLuaLoading = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsUseLuaLoading");
            IsUseLuaWorldPoint = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.IsUseLuaWorldPoint");
            SafeDoString("GameMain.Start()");
            HasGameStart = true;
            
            LuaStringLookupTable.Init();
            
            dispatchNetMessage = m_LuaEnv.Global.GetInPath<LuaFunction>("GameMain.Protocal");
            webSocketProtocal = m_LuaEnv.Global.GetInPath<WebSocketProtocalDelegate>("GameMain.WebSocketProtocal");
            dataCenterInit = m_LuaEnv.Global.GetInPath<DataCenterInitDelegate>("GameMain.DataCenterInit");
            preloadAssets = m_LuaEnv.Global.GetInPath<PreloadAssetsDelegate>("GameMain.PreloadAssets");
            updateUITimeStamp = m_LuaEnv.Global.GetInPath<UITimeForLuaDelegate>("GameMain.UpdateUITimeStamp");
            getTemplateDataFromLua = m_LuaEnv.Global.GetInPath<GetTemplateDataFromLua>("GameMain.GetTemplateData");
            showTips = m_LuaEnv.Global.GetInPath<UIShowTipsDelegate>("GameMain.ShowTips");
            showMessage = m_LuaEnv.Global.GetInPath<UIShowMessageDelegate>("GameMain.ShowMessage");
            showFoldUpBuild = m_LuaEnv.Global.GetInPath<UIShowFoldUpBuild>("GameMain.ShowFoldUpBuild");
            uiManager = m_LuaEnv.Global.GetInPath<LuaScriptInterface.UIManager>("UIManager.Instance");
            eventManager = m_LuaEnv.Global.GetInPath<LuaScriptInterface.EventManager>("EventManager.Instance");
            queueDataManager =
                m_LuaEnv.Global.GetInPath<LuaScriptInterface.QueueDataManager>("DataCenter.QueueDataManager");
            buildQueueManager =
                m_LuaEnv.Global.GetInPath<LuaScriptInterface.BuildQueueManager>("DataCenter.BuildQueueManager");
            itemManager = m_LuaEnv.Global.GetInPath<LuaScriptInterface.ItemData>("DataCenter.ItemData");
            armyFormationDataManager =
                m_LuaEnv.Global.GetInPath<ArmyFormationDataManager>("GameMain.GetArmyFormationStamina");
            luaLoadPbConfig = m_LuaEnv.Global.GetInPath<LuaLoadPbConfig>("PBController.InitBytes");
        }
        Log.Info("xLua StartGame end.");
    }

    public void DoLuaLoading(bool isReload, bool showLogo)
    {
        
        GameEntry.Lua.Call("GameMain.DoLoading",isReload, showLogo);
    }
    public void ExitGame()
    {
        if (m_LuaEnv != null && HasGameStart)
        {
            SafeDoString("GameMain.Exit()");
        }
    }

    ////fix me Initialize方法不能跟shutdown不能在同一帧调用
    public void Shutdown()
    {
        // GameEntry.Resource.Loggable = true;
        ClearLuaReference();

        foreach (var i in m_LuaScripts.Values)
        {
            i.Release();
            Log.Debug("release lua {0} status {1}", i.pathOrURL, i.status);
        }

        m_LuaScripts.Clear();

        if (updaterObject != null)
        {
            m_LuaUpdater.Dispose();
            GameObject.Destroy(updaterObject);
            m_LuaUpdater = null;
            updaterObject = null;
        }

        OnInitCallback = null;

        if (m_LuaEnv != null)
        {
            try
            {
                m_LuaEnv.Dispose();
                m_LuaEnv = null;
            }
            catch (System.Exception ex)
            {
                string msg = string.Format("xLua exception : {0}\n {1}", ex.Message, ex.StackTrace);
                Debug.LogError(msg);
            }
        }
        
        // GameEntry.Resource.Loggable = false;
    }

    public void SafeDoString(string scriptContent)
    {
        if (m_LuaEnv != null)
        {
            try
            {
                m_LuaEnv.DoString(scriptContent);
            }
            catch (System.Exception ex)
            {
                string msg = string.Format("xLua exception : {0}\n {1}", ex.Message, ex.StackTrace);
                Debug.LogError(msg);
            }
        }
    }

    public void LoadScript(string scriptName)
    {
        SafeDoString(string.Format("require('{0}')", scriptName));
    }
    

    public static byte[] CustomLoader(ref string filepath)
    {
        string[] dirs;
        if (ApplicationLaunch.Instance.GetZipDataTable()._ConfigStatus == ConfigStatus.FinishUnzip && filepath.Contains("LuaDatatable"))
        {
            var str = filepath.Split('.');
            if (str.Length != 2)
            {
                str = filepath.Split('/');
            }

            if (str.Length == 2)
            {
                var name = str[str.Length - 1];
                var luafile = Application.persistentDataPath +LuaDataTableRootPath + name+ ".lua";
                if (File.Exists(luafile))
                {
                    Log.Debug("load file:{0}",luafile);
                    return File.ReadAllBytes(luafile);
                }
            }

        }
        if (GameEntry.Resource.IsSimulation)
        {
            //filepath是ref 对filepath的修改放到这里 外部需要用到修改后的路径! 对能否正常调试断点至关重要!!! -add by zlh
            filepath = filepath.Replace(".", "/") + ".lua";
            foreach (var dir in LuaRootPathEditor)
            {
                var luafile = Application.dataPath + dir + filepath;
                if (File.Exists(luafile))
                {
                    return File.ReadAllBytes(luafile);
                }
            }
        }
        else
        {
            filepath = filepath.Replace(".", "/") + ".bytes";
            
            VEngine.Asset request;
            
            foreach (var dir in LuaRootPath)
            {
                var luafile = dir + filepath;
                if (GameEntry.Lua.m_LuaScripts.TryGetValue(luafile, out request))
                {
                    return (request.asset as TextAsset).bytes;
                }

                if (GameEntry.Resource.HasAsset(luafile))
                {
                    request = GameEntry.Resource.LoadAsset(luafile, typeof(TextAsset));
                    if (request != null && !request.isError)
                    {
                        byte[] bytes = ((TextAsset) request.asset).bytes;
                        if (GameEntry.Lua.m_LuaScripts.Count == 0)
                        {
                            GameEntry.Lua.m_LuaScripts.Add(luafile, request);
                        }
                        else
                        {
                            TextAsset ta = (TextAsset) request.asset;
                            Resources.UnloadAsset(ta);
                            request.Release();
                            GameEntry.Resource.RemoveCachedUnusedAssets();
                        }
                        return bytes;
                    }
                }
            }
        }

        return null;
    }

    public void DispatchResponse(string cmd, object table)
    {
        if (m_LuaEnv != null && dispatchNetMessage != null && HasGameStart)
        {
            dispatchNetMessage.CallForPushTable(cmd, table);
        }
    }

    public void DataCenterInit()
    {
        if (m_LuaEnv != null && dataCenterInit != null && HasGameStart)
        {
            dataCenterInit();
        }
    }

    public void PreloadAssets()
    {
        if (m_LuaEnv != null && preloadAssets != null && HasGameStart)
        {
            preloadAssets();
        }
    }
    
    public void UpdateUITimeStamp(long timeStamp)
    {
        if (m_LuaEnv != null && updateUITimeStamp != null && HasGameStart)
        {
            updateUITimeStamp(timeStamp);
        }
    }

    public void ShowTips(string msg, string img, string atlas)
    {
        if (m_LuaEnv != null && showTips != null && HasGameStart)
        {
            showTips(msg,img,atlas);
        }
    }

    public void ShowMessage(string tipText, int btnNum, string text1, string text2, Action action1, Action action2,
        Action closeAction, string titleText,bool isChangeImg)
    {
        if (m_LuaEnv != null && showMessage != null && HasGameStart)
        {
            showMessage(tipText,btnNum,text1, text2,action1, action2, closeAction,titleText,isChangeImg);
        }
    }

    public void ShowFoldUpBuild(string posX,string posY,string posZ, string bUuid)
    {
        if (m_LuaEnv != null && showFoldUpBuild != null && HasGameStart)
        {
            showFoldUpBuild(posX,posY,posZ, bUuid);
        }
    }
    public LuaScriptInterface.QueueData GetQueueDataByType(int type)
    {
        return QueueDataManager.GetQueueByType(type);
    }

    public void WebSocketResponse(string data)
    {
        if (m_LuaEnv != null && webSocketProtocal != null && HasGameStart)
        {
            webSocketProtocal(data);
        }
    }

    public string GetTemplateData(string xmlId, int id, string attrStr)
    {
        if (m_LuaEnv != null && getTemplateDataFromLua != null && HasGameStart)
        {
            return getTemplateDataFromLua(xmlId,id,attrStr);
        }

        return "";
    }

    public int GetArmyInfoByStamina(long uuid)
    {
        // return ArmyFormationDataManager.GetArmyInfoByStamina(uuid);  
        if (m_LuaEnv != null && getTemplateDataFromLua != null && HasGameStart)
        {
            return armyFormationDataManager(uuid);
        }

        return 0;
    }

    public void LuaLoadPb(byte[] bytes)
    {
        if (luaLoadPbConfig == null)
            return;
        luaLoadPbConfig(bytes);
    }

    private void ClearLuaReference()
    {
        dispatchNetMessage = null;
        webSocketProtocal  = null;
        dataCenterInit     = null;
        preloadAssets      = null;
        updateUITimeStamp  =  null;
        getTemplateDataFromLua =  null;
        showTips =  null;
        showMessage =  null;
        showFoldUpBuild =  null;
        uiManager =  null;
        eventManager =  null;
        queueDataManager =  null;
        buildQueueManager =  null;
        itemManager =  null;
        armyFormationDataManager =  null;
        luaLoadPbConfig = null;
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// 这个地方主要集中了C#调用未预定义的Lua函数
// 写的比较复杂，主要是支持在整过过程中无GC操作（第一次调用除外）
// 目前支持LUA中.和:的调用方式（即是否压入self)
// 1. Call("LuaTable.Function", params);  
//        表示不压入self
// 2. Call("LuaTable:Function", params);
//        表示压入self
// 3. CallWithReturn
//        表示调用后有返回值
// 4. SetValue("LuaTable", "Attribute", value);
//        表示给lua表的某个属性赋值
// 5. GetValue("LuaTable", "Attribute");
//        表示获取lua表的某个属性
// 
// * 对于lua端譬如ChatManager2:GetInstance():Function这样的调用
//   可以写成"ChatManager2.Instance:Function"
//   当前前提是必须要在lua端先调用过GetInstance()，否则Instance属性为nil
// * 目前因为效率缓存了LuaTable和LuaFunction。所以对于lua端来回变动的表格，
//   每次在lua端变化之后要清一下:ClearCacheTable
//   当然如果需要的话，可以做一下缓存的黑白名单。
// * 有啥问题建议自己修改，对整个流程有改进想法可以联系我
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

public partial class XLuaManager
{
    #region !!!Attributes!!!
    
    enum LuaValueEnum
    {
        V_Bool = 0,
        V_Int,
        V_UInt,
        V_Long,
        V_ULong, 
        V_Double,
        V_String,
        V_Obj,
    }
    
    // 用来表示任何类型，处理元类型需要装箱的问题
    struct LuaValue
    {
        public LuaValueEnum type;
        public bool bv;
        public long lv;
        public ulong ulv;
        public double dv;
        public string sv;
        public object ov;
    }
    
    // 函数调用环境
    struct CallContext
    {
#if UNITY_EDITOR
        public string funcName;
#endif
        public LuaTable table;
        public LuaFunction function;
        public bool pushSelf;
        public List<LuaValue> paras;
    }
    
    // byte[] 压入LUA堆栈
    public struct ByteString
    {
        public byte[] str;
        public int str_len;
    }
    
    class LuaTableLookup
    {
        public string tablePath;
        public LuaTable table;
        public Dictionary<uint, LuaFunction> funcs;
    }
    // 缓存的LuaTable，key是名字的hash
    private Dictionary<uint, LuaTableLookup> lookupTables_ = new Dictionary<uint, LuaTableLookup>(8);
    
    // 增加一个一级缓存
    private string lastFunctionName = "";
    private LuaTable lastTable = null;
    private LuaFunction lastFunction = null;
    private int lastCacheCount = 0;

    // 分隔符- 表示lua的两种调用方式
    private char[] call_sep_ = {'.', ':'};
    
    // push压入
    private Dictionary<Type, Delegate> dictPushParam_ = new Dictionary<Type, Delegate>
    {
        {typeof(int),  new Action<CallContext, int>(AddIntParam) },
        {typeof(double), new Action<CallContext, double>(AddDoubleParam) },
        {typeof(bool), new Action<CallContext, bool>(AddBoolParam) },
        {typeof(long), new Action<CallContext, long>(AddLongParam) },
        {typeof(ulong), new Action<CallContext, ulong>(AddULongParam) },
        {typeof(uint),  new Action<CallContext, uint>(AddUIntParam) },
        {typeof(float),  new Action<CallContext, double>(AddDoubleParam) },
        {typeof(string),  new Action<CallContext, string>(AddStringParam) },
    };
    
    // 为了避免GC的全局缓存，暂时如此
    private List<LuaValue> global_list_cache_ = new List<LuaValue>(12);
    private byte[] global_byte_cache_ = new byte[256];
    
    #endregion

    #region  !!!Context!!!
    
    private void initContext()
    {
        Env.translator.AddPushByteFunc(typeof(ByteString),
            new Action<RealStatePtr, ByteString>((L, v) =>
            {
                LuaAPI.xlua_pushlstring(L, v.str, v.str_len);
            }));

        // NOTICE: xlua有个bug，导致没法使用AddPushByteFunc。
        // 具体在：PushByType函数里面的if (tryGetPushFuncByType(typeof(T), out push_func))
        // 这行使用的是typeof(T)，应该使用v.GetType()。使用前者使用的是编译时的类型，但是如此不会有原生类型装箱。使用后者可以拿到正确的类型。
        // 所以这里同时增加了AddCustomFunc来迫使LuaStackTable压入
        Env.translator.AddCustomFunc(typeof(LuaStackTable),
            (RealStatePtr L, object obj) =>
            {
                ((LuaStackTable)obj).push();
            });
    }

    private void fillByteArray(byte[] dest, ReadOnlySpan<char> src)
    {
        int pos = 0;
        foreach (var c in src)
        {
            dest[pos++] = (byte)c;
        }
    }
    
    public void ClearCacheTable(string luaTableName)
    {
        uint hashCode1 = hash_function(luaTableName.AsSpan());
        lookupTables_.Remove(hashCode1);
    }

    public void ClearCacheTableAll()
    {
        lookupTables_.Clear();
    }
    
    private LuaTableLookup cacheTable(ReadOnlySpan<char> tableName, uint tableHashCode, LuaTable tbl)
    {
        var lt = new LuaTableLookup();
        lt.tablePath = tableName.ToString();
        lt.table = tbl;
        lt.funcs = new Dictionary<uint, LuaFunction>(4);
        lookupTables_[tableHashCode] = lt;
        return lt;
    }

    // 从table下面获取子，可以是table，也可以是function
    private T getLuaChild<T>(LuaTable parent, ReadOnlySpan<char> childName)
    {
        byte[] tByte = byte_Rent(childName.Length);
        fillByteArray(tByte, childName);
            
        ByteString bs;
        bs.str = tByte;
        bs.str_len = childName.Length;
        T t = parent.Get<ByteString, T>(bs);
        byte_Return(tByte);

        return t;
    }

    // 根据分段字符串x.y.z查找table
    private bool getAndCacheTable(ReadOnlySpan<char> tableName, out LuaTableLookup lt)
    {
        uint hashCode1 = hash_function(tableName);
        
        // 如果table没有缓存的话，先找table并进行缓存
        if (lookupTables_.TryGetValue(hashCode1, out lt) == false)
        {
            LuaTable curTable = Env.Global;
            foreach (ReadOnlySpan<char> seg in tableName.SplitSegments('.'))
            {
                curTable = getLuaChild<LuaTable>(curTable, seg);
                if (curTable == null)
                {
                    break;
                }
            }

            if (curTable == null)
            {
                return false;
            }

            lt = cacheTable(tableName, hashCode1, curTable);
        }

        return true;
    }

    private bool getAndCacheFunction(ReadOnlySpan<char> tableName, ReadOnlySpan<char> funcName, out LuaTable t,
        out LuaFunction f)
    {
        LuaTableLookup lt;
        if (getAndCacheTable(tableName, out lt) == false)
        {
            t = null;
            f = null;
            return false;
        }
        
        // 然后查找function，查找并缓存
        t = lt.table;
            
        uint funcNameHashCode = hash_function(funcName);   
        if (lt.funcs.TryGetValue(funcNameHashCode, out f))
        {
            return true;
        }

        f = getLuaChild<LuaFunction>(lt.table, funcName);
        if (f == null)
        {
            return false;
        }
        
        uint hashCode2 = hash_function(funcName);            
        lt.funcs[hashCode2] = f;
        return true;
    }

    private uint hash_function(ReadOnlySpan<char> str)
    {
        uint hash = 5381;
        for (int i = 0; i < str.Length; i++)
        {
            byte ch = (byte)str[i];
            hash = ((hash << 5) + hash) + ch; /* hash * 33 + c */
        }
        return hash;
    }

    // 需要并发的话，使用ArrayPool.Rent
    private byte[] byte_Rent(int len)
    {
        return global_byte_cache_;
    }

    private void byte_Return(byte[] b)
    {
        
    }
    
    private bool makeCallContext(string fullPathName, ref CallContext cc)
    {
        int pos = fullPathName.LastIndexOfAny(call_sep_);
        if (pos == -1)
        {
            Log.Error(" {0} path error?", fullPathName);
            return false;
        }
        
        LuaTable curTable = null;
        LuaFunction curFunc = null;
        
        // 先做个一次缓存比较，主要是有些for循环中使用
        if (fullPathName == lastFunctionName)
        {
            curTable = lastTable;
            curFunc = lastFunction;

            ++lastCacheCount;
        }
        else
        {
            ReadOnlySpan<char> fullPathSpan = fullPathName.AsSpan();
            ReadOnlySpan<char> tablePath = fullPathSpan.Slice(0, pos);
            ReadOnlySpan<char> funcName = fullPathSpan.Slice(pos + 1);
            
            bool ret = getAndCacheFunction(tablePath, funcName, out curTable, out curFunc);
            if (ret == false)
            {
                Log.Error(" {0} not found!", fullPathName);
                return false;
            }
            
            lastFunctionName = fullPathName;
            lastTable = curTable;
            lastFunction = curFunc;
        }

#if UNITY_EDITOR // for debug!
        cc.funcName = fullPathName;
    #endif
        cc.table = curTable;
        cc.function = curFunc;
        cc.pushSelf = (fullPathName[pos] == ':') ? true : false;
        cc.paras = global_list_cache_;
        global_list_cache_.Clear();
    
        return true;
    }

    private T endCallContext<T>(CallContext cc)
    {
        var luaEnv = Env;
        var L = luaEnv.L;
        var translator = luaEnv.translator;
        int oldTop = LuaAPI.lua_gettop(L);
        int errFunc = LuaAPI.load_error_func(L, luaEnv.errorFuncRef);
        
        // 开始压入函数
        cc.function.push(L);
        // translator.PushAny(L, cc.function);
        
        // 是否需要压入self
        int args = cc.paras.Count;
        if (cc.pushSelf == true)
        {
            args++;
            // translator.PushAny(L, cc.table);
            cc.table.push(L);
        }
        
        // 压入参数
        for (int i = 0; i < cc.paras.Count; ++i)
        {
            switch (cc.paras[i].type)
            {
            case LuaValueEnum.V_Bool: translator.PushByType(L, cc.paras[i].bv);
                break;
            
            case LuaValueEnum.V_Double: translator.PushByType(L, cc.paras[i].dv);
                break;
            
            case LuaValueEnum.V_Int: translator.PushByType(L, (int)cc.paras[i].lv);
                break;
            
            case LuaValueEnum.V_Long: translator.PushByType(L, cc.paras[i].lv);
                break;

            case LuaValueEnum.V_UInt: translator.PushByType(L, (uint)cc.paras[i].ulv);
                break;
            
            case LuaValueEnum.V_ULong: translator.PushByType(L, cc.paras[i].ulv);
                break;
            
            case LuaValueEnum.V_String: translator.PushByType(L, cc.paras[i].sv);
                break;
            
            case LuaValueEnum.V_Obj: translator.PushByType(L, cc.paras[i].ov);
                break;
            }
        }
        
        int error = LuaAPI.lua_pcall(L, args, -1, errFunc);
        if (error != 0)
        {
            try
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            catch (LuaException e)
            {
                GameFramework.Log.Error("CallLuaFunc but exception : {0}", e.Message);
                return default;
            }
        }

        // pop the error handler
        LuaAPI.lua_remove(L, errFunc);
        
        // 当前没有
        int newTop = LuaAPI.lua_gettop(L);
        if (oldTop == newTop)
        {
            return default;
        }
        
        // 我们只取第一个返回值，多个返回值就从lua返回一个table，然后用LuaTable接；或者用json，字符串分割都行。
        T ret = default;
        for (int i = oldTop + 1; i <= newTop; i++)
        {
            translator.Get<T>(L, i, out ret);
            break;
        }
        
        LuaAPI.lua_settop(L, oldTop);
        return ret;
    }

    private static void AddIntParam(CallContext cc, int param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_Int;
        lv.lv = param;
        cc.paras.Add(lv);
    }

    private static void AddUIntParam(CallContext cc, uint param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_UInt;
        lv.ulv = param;
        cc.paras.Add(lv);
    }
    
    private static void AddLongParam(CallContext cc, long param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_Long;
        lv.lv = param;
        cc.paras.Add(lv);
    }

    private static void AddULongParam(CallContext cc, ulong param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_ULong;
        lv.ulv = param;
        cc.paras.Add(lv);
    }

    private static void AddDoubleParam(CallContext cc, double param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_Double;
        lv.dv = param;
        cc.paras.Add(lv);
    }
    
    private static void AddBoolParam(CallContext cc, bool param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_Bool;
        lv.bv = param;
        cc.paras.Add(lv);
    }
    
    private static void AddStringParam(CallContext cc, string param)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_String;
        lv.sv = param;
        cc.paras.Add(lv);
    }

    private static void AddObjectParam(CallContext cc, object obj)
    {
        LuaValue lv = new LuaValue();
        lv.type = LuaValueEnum.V_Obj;
        lv.ov = obj;
        cc.paras.Add(lv);
    }

    private void AddParam<T>(CallContext cc, T param)
    {
        Delegate obj;
        Type type = typeof(T);
        if (dictPushParam_.TryGetValue(type, out obj))
        {
            Action<CallContext, T> f = (Action<CallContext, T>)(obj);
            f(cc, param);
        }
        else
        {
            AddObjectParam(cc, param);
        } 
    }
    
    #endregion

    #region Call

    public void Call(string luaFunctionPath)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            endCallContext<object>(cc);
        }
    }
    
    public void Call<T1>(string luaFunctionPath, T1 param1)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            endCallContext<object>(cc);
        }
    }

    public void Call<T1, T2>(string luaFunctionPath, T1 param1, T2 param2)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            endCallContext<object>(cc);
        }
    }
    
    public void Call<T1, T2, T3>(string luaFunctionPath, T1 param1, T2 param2, T3 param3)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            endCallContext<object>(cc);
        }
    }    

    public void Call<T1, T2, T3, T4>(string luaFunctionPath, T1 param1, T2 param2, T3 param3, T4 param4)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            AddParam(cc, param4);
            endCallContext<object>(cc);
        }
    }    

    public void Call<T1, T2, T3, T4, T5>(string luaFunctionPath, T1 param1, T2 param2, T3 param3, T4 param4, T5 param5)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            AddParam(cc, param4);
            AddParam(cc, param5);
            endCallContext<object>(cc);
        }
    } 
    
    #endregion


    #region CallWithReturn

    public T CallWithReturn<T>(string luaFunctionPath)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            return endCallContext<T>(cc);
        }

        return default;
    }   
    
    public T CallWithReturn<T, T1>(string luaFunctionPath, T1 param1)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            return endCallContext<T>(cc);
        }

        return default;
    }     

    public T CallWithReturn<T, T1, T2>(string luaFunctionPath, T1 param1, T2 param2)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            return endCallContext<T>(cc);
        }

        return default;
    }    
    
    public T CallWithReturn<T, T1, T2, T3>(string luaFunctionPath, T1 param1, T2 param2, T3 param3)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            return endCallContext<T>(cc);
        }

        return default;
    }   
    
    public T CallWithReturn<T, T1, T2, T3, T4>(string luaFunctionPath, T1 param1, T2 param2, T3 param3, T4 param4)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            AddParam(cc, param4);
            return endCallContext<T>(cc);
        }

        return default;
    }   

    public T CallWithReturn<T, T1, T2, T3, T4, T5>(string luaFunctionPath, T1 param1, T2 param2, T3 param3, T4 param4, T5 param5)
    {
        CallContext cc = new CallContext();
        bool ret = makeCallContext(luaFunctionPath, ref cc);
        if (ret)
        {
            AddParam(cc, param1);
            AddParam(cc, param2);
            AddParam(cc, param3);
            AddParam(cc, param4);
            AddParam(cc, param5);
            return endCallContext<T>(cc);
        }

        return default;
    }   
    
    // 调用返回int
    public int CallWithReturnInt(string luaFunctionPath)
    {
        return CallWithReturn<int>(luaFunctionPath);
    }   
    
    public int CallWithReturnInt<T1>(string luaFunctionPath, T1 param1)
    {
        return CallWithReturn<int, T1>(luaFunctionPath, param1);
    }     

    public int CallWithReturnInt<T1, T2>(string luaFunctionPath, T1 param1, T2 param2)
    {
        return CallWithReturn<int, T1, T2>(luaFunctionPath, param1, param2);
    }   

    // 调用返回int
    public string CallWithReturnString(string luaFunctionPath)
    {
        return CallWithReturn<string>(luaFunctionPath);
    }   
    
    public string CallWithReturnString<T1>(string luaFunctionPath, T1 param1)
    {
        return CallWithReturn<string, T1>(luaFunctionPath, param1);
    }     

    public string CallWithReturnString<T1, T2>(string luaFunctionPath, T1 param1, T2 param2)
    {
        return CallWithReturn<string, T1, T2>(luaFunctionPath, param1, param2);
    }   
    
    #endregion


    #region !!!SetAndGetValue!!!
    // 设置table表中某个属性的值
    public void SetValue<T>(string luaTable, string attr, T value)
    {
        LuaTableLookup lt;
        if (getAndCacheTable(luaTable.AsSpan(), out lt))
        {
            try
            {
                lt.table.SetInPath(attr, value);
            }
            catch (Exception e)
            {
                Log.Error("SetValue error!");
            }
        }
    }
    
    // 获取表中某个属性的值
    public T GetValue<T>(string luaTable, string attr)
    {
        LuaTableLookup lt;
        if (getAndCacheTable(luaTable.AsSpan(), out lt))
        {
            try
            {
                return lt.table.GetInPath<T>(attr);
            }
            catch (Exception e)
            {
                Log.Error("SetValue error!");
            }
        }

        // 如果是string的话，别返回null了，直接返回"";
        if (typeof(T) == typeof(string))
        {
            return (T)(object)"";
        }
        
        return default;
    }
    
    public int GetValue_Int(string luaTable, string attr)
    {
        return GetValue<int>(luaTable, attr);
    }
    
    public string GetValue_String(string luaTable, string attr)
    {
        return GetValue<string>(luaTable, attr);
    }

    #endregion
}


// 修改底层的代码，通过partial的方式
// 主要就是想直接操作一下某些私有变量
namespace XLua
{
    #region  !!!XLUA partial!!!
    using LuaAPI = XLua.LuaDLL.Lua;
    
    public partial class ObjectTranslator
    {
        public bool AddPushByteFunc<T>(Type t, Action<RealStatePtr, T> func)
        {
            if (push_func_with_type != null)
            {
                push_func_with_type[t] = func;
                return true;
            }

            return false;
        }

        public bool AddCustomFunc(Type t, PushCSObject func)
        {
            if (custom_push_funcs != null)
            {
                custom_push_funcs[t] = func;
                return true;
            }

            return false;
        }

        // 这里将PushByType常用的类型进行展开，避免每次毫无意义的查找字典开销
        public void PushByType(RealStatePtr L, int v)
        {
            LuaAPI.xlua_pushinteger(L, v);
        } 
        
        public void PushByType(RealStatePtr L, double v)
        {
            LuaAPI.lua_pushnumber(L, v);
        } 
        
        // 可以在这里统计一下最常用的string，然后进行ref
        // 详见：https://blog.codingnow.com/2006/01/_lua.html
        public void PushByType(RealStatePtr L, string v)
        {
            LuaAPI.lua_pushstring(L, v);
        } 
        
        public void PushByType(RealStatePtr L, byte[] v)
        {
            LuaAPI.lua_pushstring(L, v);
        } 
        
        public void PushByType(RealStatePtr L, bool v)
        {
            LuaAPI.lua_pushboolean(L, v);
        } 
        
        public void PushByType(RealStatePtr L, long v)
        {
            LuaAPI.lua_pushint64(L, v);
        }

        public void PushByType(RealStatePtr L, ulong v)
        {
            LuaAPI.lua_pushuint64(L, v);
        }

        public void PushByType(RealStatePtr L, uint v)
        {
            LuaAPI.xlua_pushuint(L, v);
        } 
        
        public void PushByType(RealStatePtr L, float v)
        {
            LuaAPI.lua_pushnumber(L, v);
        }

        // 这个函数特殊处理一下
        public void PushByType(RealStatePtr L, XLuaManager.ByteString v)
        {
            LuaAPI.xlua_pushlstring(L, v.str, v.str_len);
        }

        
        // 对Get进行展开
        public void Get(RealStatePtr L, int index, out int v)
        {
            v = LuaAPI.xlua_tointeger(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out double v)
        {
            v = LuaAPI.lua_tonumber(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out string v)
        {
            v = LuaAPI.lua_tostring(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out byte[] v)
        {
            v = LuaAPI.lua_tobytes(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out bool v)
        {
            v = LuaAPI.lua_toboolean(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out long v)
        {
            v = LuaAPI.lua_toint64(L, index);
        }

        public void Get(RealStatePtr L, int index, out ulong v)
        {
            v = LuaAPI.lua_touint64(L, index);
        }

        public void Get(RealStatePtr L, int index, out uint v)
        {
            v = LuaAPI.xlua_touint(L, index);
        } 
        
        public void Get(RealStatePtr L, int index, out float v)
        {
            v = (float)LuaAPI.lua_tonumber(L, index);
        }
        
   
    }



    public partial class LuaTable
    {
        public void SetInt(string key, int value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            LuaAPI.xlua_pushinteger(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        
        public void SetFloat(string key, float value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            LuaAPI.lua_pushnumber(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetDouble(string key, double value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            LuaAPI.lua_pushnumber(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetLong(string key, long value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            LuaAPI.lua_pushint64(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        
        public void SetString(string key, string value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            LuaAPI.lua_pushstring(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetTable(string key, LuaTable value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.lua_pushstring(L, key);
            value.push(L);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        
        ////////////////////////////////////////////////////////
        /// key = int 版本
        ///
        /// 
        public void SetInt(int key, int value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            LuaAPI.xlua_pushinteger(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        
        public void SetFloat(int key, float value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            LuaAPI.lua_pushnumber(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetDouble(int key, double value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            LuaAPI.lua_pushnumber(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetLong(int key, long value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            LuaAPI.lua_pushint64(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        
        public void SetString(int key, string value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            LuaAPI.lua_pushstring(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
        public void SetTable(int key, LuaTable value)
        {
#if THREAD_SAFE || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
            var L = luaEnv.L;
            int oldTop = LuaAPI.lua_gettop(L);
            var translator = luaEnv.translator;

            LuaAPI.lua_getref(L, luaReference);
            LuaAPI.xlua_pushinteger(L, key);
            value.push(L);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                luaEnv.ThrowExceptionFromError(oldTop);
            }
            LuaAPI.lua_settop(L, oldTop);
#if THREAD_SAFE || HOTFIX_ENABLE
            }
#endif
        }
        
    }
    
    #endregion
}


