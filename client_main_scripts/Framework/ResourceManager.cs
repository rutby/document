using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using GameFramework;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;
using VEngine;
using XLua;

//
// 资源管理
//
public class ResourceManager
{
    private const string package_name_channel = "com.readygo.aps.channel";
    private const string package_name_gp = "com.readygo.aps.gp";
    private string debugDownloadURL_ = "http://10.7.88.142:82/gameservice/get3dfile.php?file=";
    private string oriOnlineDownloadURL_ = "https://cdn-ds.readygo.tech/hotupdate/";
    public const string debugCheckVersionURL_ = "http://10.7.88.142:82";
    // private const string AccOnlineCheckVersionURL_ = "http://afad1a33a22474ce7.awsglobalaccelerator.com:15000/gameservice/getlsu3dversion.php?packageName={0}&platform={1}&appVersion={2}&gm={3}&server={4}&uid={5}&deivceId={6}&table_env={7}&returnJson=1";
    // private const string AccDebugCheckVersionURL_ = "http://192.168.30.24:8988/gameservice/getlsu3dversion.php?packageName={0}&platform={1}&appVersion={2}&gm={3}&server={4}&uid={5}&deivceId={6}&table_env={7}&returnJson=1";

    //所有checkVersion线路，跑马成功后，成功的线路会作为getServerList的线路
    private string[] onlineCheckVersionHostList;

    private string[] cdnLineList;
    // checkVersion请求表单格式
    private const string checkVersionFormFormat =
        "/gameservice/getlsu3dversion.php?packageName={0}&platform={1}&appVersion={2}&gm={3}&server={4}&uid={5}&deivceId={6}&returnJson=1";
    
    public readonly string GameResManifestName = "gameres";
    public readonly string DataTableManifestName = "datatable";
    public readonly string LuaManifestName = "lua";

    private string[] manifests;
    private string bkgroundManifest;
    //private string packageResManifest;
    private float lastTimePerSecondUpdate;
    private DownloadUpdateBkground _updateBkground;
    
    public string DownloadURL {
        get{
            if (CommonUtils.IsDebug())
            {
                return debugDownloadURL_;
            }
            else
            {
                return oriOnlineDownloadURL_;

            }
        }
    }
    /// <summary>
    /// 获取完整的checkVersion url地址
    /// </summary>
    /// <param name="host"></param>
    /// <returns></returns>
    public string GetCheckVersionURL(string host)
    {
        var gm = GameEntry.Setting.GetInt(GameDefines.SettingKeys.GM_FLAG);
        string package_name = GameEntry.Sdk.GetPackageName();
        if (package_name.Equals(package_name_channel))
            package_name = package_name_gp;
            
        var uid = GameEntry.Setting.GetString(GameDefines.SettingKeys.GAME_UID, "");
        var server = GameEntry.Setting.GetString(GameDefines.SettingKeys.SERVER_ZONE, "");
        var deviceId = GameEntry.Device.GetDeviceUid();
        return host + string.Format(checkVersionFormFormat,  package_name, VEngine.Versions.PlatformName, GameEntry.Sdk.Version, gm > 0 ? 1 : 0, server, uid, deviceId);
    }
    
    public string CheckVersionURL
    {
        get
        {
            return null;
        }
    }

    public enum PreloadType { Cache, KeepAlive }

    public class PreloadCache
    {
        public VEngine.Asset asset;
        public float expiredTime;
    }

    private const float CacheTime = 300.0f;
    private Dictionary<string, PreloadCache> preloadCache = new Dictionary<string, PreloadCache>();
    private List<string> keysRemove = new List<string>();

    public bool Loggable
    {
        get { return VEngine.Logger.Loggable;}
        set { VEngine.Logger.Loggable = value; }
    }

    public void Initialize(Action<bool> onComplete)
    {
        var operation = VEngine.Versions.InitializeAsync();
        operation.completed += delegate
        {
            if (operation.status == VEngine.OperationStatus.Failed)
            {
                Log.Error(operation.error);
            }

            onComplete?.Invoke(operation.status == VEngine.OperationStatus.Success);
        };
        
        manifests = operation.manifests.ToArray();
        bkgroundManifest = operation.bkgroundManifest;
        //packageResManifest = operation.packageResManifest;
        
#if SKIP_UPDATE
        VEngine.Versions.SkipUpdate = true;
#endif
        VEngine.Versions.DownloadURL = DownloadURL;
        VEngine.Versions.getDownloadURL = GetDownloadURL;

        SpriteAtlasManager.atlasRegistered += OnAtlasRegistered;
        SpriteAtlasManager.atlasRequested += OnAtlasRequested;
    }

    public void InitLine()
    {
        InitOnlineCheckVersionHostList();
        InitCDNLineList();
    }
    private void InitOnlineCheckVersionHostList()
    {
        var tempList = new List<string>();
        var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllCheckVersionUrl");
        if (table != null)
        {
            for (int i = 1; i <= table.Length; ++i)
            {
                var data = (LuaTable)table[i];
                if (data.ContainsKey("line"))
                {
                    var line = data.Get<string>("line");
                    tempList.Add(line);
                }
            }
        }

        onlineCheckVersionHostList = tempList.ToArray();
    }

    public string[] GetOnlineCheckVersionHostList()
    {
        return onlineCheckVersionHostList;
    }

    private void InitCDNLineList()
    {
        if (CommonUtils.IsDebug())
        {
            var tempList = new List<string>();
            var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetDebugCDNUrlList");
            if (table != null)
            {
                for (int i = 1; i <= table.Length; ++i)
                {
                    var data = (LuaTable)table[i];
                    if (data.ContainsKey("line"))
                    {
                        var line = data.Get<string>("line");
                        tempList.Add(line);
                    }
                }
            }
            cdnLineList = tempList.ToArray();
            if (cdnLineList.Length > 0)
            {
                debugDownloadURL_ = cdnLineList[0];
            }
        }
        else
        {
            var tempList = new List<string>();
            var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllCDNUrlList");
            if (table != null)
            {
                for (int i = 1; i <= table.Length; ++i)
                {
                    var data = (LuaTable)table[i];
                    if (data.ContainsKey("line"))
                    {
                        var line = data.Get<string>("line");
                        tempList.Add(line);
                    }
                }
            }

            cdnLineList = tempList.ToArray();
            if (cdnLineList.Length > 0)
            {
                oriOnlineDownloadURL_ = cdnLineList[0];
            }
        }
        
    }
    public string[] GetCDNLineList()
    {
        return cdnLineList;
    }
    private string GetDownloadURL(string filename)
    {
        var platformPath = VEngine.Versions.PlatformName;
        string package_name = GameEntry.Sdk.GetPackageName();
        if (package_name.Equals(package_name_channel))
            package_name = package_name_gp;
        return $"{DownloadURL}{package_name}/{platformPath}/{filename}";
    }

    public string[] GetManifestNames()
    {
        return manifests;
    }

    public string GetBkgroundManifestName()
    {
        return bkgroundManifest;
    }

    // public string GetPackageResManifestName()
    // {
    //     return packageResManifest;
    // }

    public string GetTempDownloadPath(string file)
    {
        var ret = $"{Application.temporaryCachePath}/Download/{file}";
        var dir = Path.GetDirectoryName(ret);
        if (!string.IsNullOrEmpty(dir) && !Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }

        return ret;
    }
    
    public void OverrideManifest(VEngine.Manifest manifest)
    {
        if (VEngine.Versions.SkipUpdate)
            return;
        
        var from = GetTempDownloadPath(manifest.name);
        var dest = VEngine.Versions.GetDownloadDataPath(manifest.name);
        if (File.Exists(from))
        {
            Log.Debug("Copy {0} to {1}.", from, dest);
            File.Copy(from, dest, true);
        }
        var versionName = VEngine.Manifest.GetVersionFile(manifest.name);
        from = GetTempDownloadPath(versionName);
        if (File.Exists(from))
        {
            var path = VEngine.Versions.GetDownloadDataPath(versionName);
            Log.Debug("Copy {0} to {1}.", from, path);
            File.Copy(from, path, true);
        }
        if (!VEngine.Versions.IsChanged(manifest.name))
        {
            return;
        }
        manifest.Load(dest);
        Log.Debug($"Load manifest {dest} {manifest.version}");
        VEngine.Versions.Override(manifest);
    }
    
    //
    // 更新所有 Manifest
    //
    public VEngine.UpdateVersions UpdateManifests()
    {
        return VEngine.Versions.UpdateAsync(manifests);
    }

    //
    // 获取更新文件总大小
    //
    public ulong GetDownloadSize(List<VEngine.Manifest> manifests, List<VEngine.DownloadInfo> downloadInfos)
    {
        if (VEngine.Versions.SkipUpdate || manifests == null || manifests.Count == 0)
            return 0;

        ulong totalSize = 0;
        downloadInfos.Clear();
        var bundles = VEngine.Versions.GetBundlesWithGroups(manifests.ToArray(), null);
        foreach (var bundle in bundles)
        {
            var savePath = VEngine.Versions.GetDownloadDataPath(bundle.name);
            
            if (!VEngine.Versions.IsDownloaded(bundle))
            {
                if (!downloadInfos.Exists(downloadInfo => downloadInfo.savePath == savePath))
                {
                    totalSize += bundle.size;
                    downloadInfos.Add(new VEngine.DownloadInfo
                    {
                        crc = bundle.crc,
                        url = VEngine.Versions.GetDownloadURL(bundle.name),
                        size = bundle.size,
                        savePath = savePath
                    });
                }
            }    
        }
        
        return totalSize;
    }

    //
    // 下载所有更新
    //
    public VEngine.DownloadVersions DownloadUpdates(List<VEngine.DownloadInfo> downloadInfos)
    {
        return VEngine.Versions.DownloadAsync(downloadInfos.ToArray());
    }

    public void StartBkgroundDownload(List<string> manifestNames)
    {
        var manifests = new List<VEngine.Manifest>();
        foreach (var n in manifestNames)
        {
            var m = VEngine.Versions.GetManifest(n);
            manifests.Add(m);
        }
        var downloadInfos = new List<VEngine.DownloadInfo>();
        var totalSize = GetDownloadSize(manifests, downloadInfos);
        if (totalSize > 0)
        {
            _updateBkground = new DownloadUpdateBkground {manifests = new List<VEngine.Manifest>(manifests)};
            _updateBkground.Start(downloadInfos);
            Log.Debug("start bkground download {0}", totalSize);
        }
    }
    
    public void BeginWhiteListCheck()
    {
        VEngine.Versions.CheckWhiteList = true;
    }

    public bool EndWhiteListCheck()
    {
        VEngine.Versions.CheckWhiteList = false;
        if (VEngine.Versions.WhiteListFailed.Count > 0)
        {
            foreach (var i in VEngine.Versions.WhiteListFailed)
            {
                Log.Info("whitelist failed: {0}", i);
            }
        }
        return VEngine.Versions.WhiteListFailed.Count == 0;
    }

    public void Clear()
    {
        foreach (var i in preloadCache)
        {
            i.Value.asset.Release();
        }
        preloadCache.Clear();

        ClearInstance();
        
        objectPoolMgr.ClearAllPool();
    }

    //
    // 加载资源
    //
    public VEngine.Asset LoadAsset(string path, Type type)
    {
        return VEngine.Asset.Load(path, type);
    }

    public VEngine.Asset LoadAssetAsync(string path, Type type)
    {
        return VEngine.Asset.LoadAsync(path, type);
    }

    public void PreloadAsset(string path, Type type, PreloadType preloadType = PreloadType.Cache)
    {
        var expiredTime = preloadType == PreloadType.Cache ? Time.realtimeSinceStartup + CacheTime : float.MaxValue;
        if (preloadCache.TryGetValue(path, out var cache))
        {
            cache.expiredTime = expiredTime;
        }
        else
        {
            var asset = VEngine.Asset.LoadAsync(path, type);
            preloadCache.Add(path, new PreloadCache {asset = asset, expiredTime = expiredTime});
        }
    }

    //
    // 卸载资源
    //
    public void UnloadAsset(VEngine.Asset asset)
    {
        if (asset != null)
        {
            asset.Release();
        }
    }

    // 资源清单中是否有该资源
    public bool HasAsset(string path)
    {
        var tempPath = path;
        VEngine.AssetInfo asset;
        return VEngine.Versions.GetAsset(ref tempPath, out asset);
    }

    // 资源是否已下载
    public bool IsAssetDownloaded(string path)
    {
        return VEngine.Versions.IsAssetDownloaded(path);
    }

    public void UnloadUnusedAssets()
    {
        objectPoolMgr.ClearUnusedPool();
        VEngine.Asset.UnloadUnusedAssets();
        VEngine.Bundle.DebugOutputCache();
    }

    /**
     * 释放缓存信息 luagc、c#gc
     */
    public void ReleaseCacheResource()
    {
        Log.Debug("release cache begin");
        // objectPoolMgr.ClearUnusedPool();
        GameEntry.Lua.Env.FullGc();
        // Log.Debug("release cache lua gc");
        System.GC.Collect();
        Log.Debug("release cache end ");
    }
    
    public void CollectGarbage()
    {
        // 输出日志
        Log.Info("CollectGarbage begin");
        objectPoolMgr.DebugOutput();
        VEngine.Asset.DebutOutputCache();
        VEngine.Bundle.DebugOutputCache();
        
        objectPoolMgr.ClearUnusedPool();
        VEngine.Asset.UnloadUnusedAssets();
        
        Log.Info("CollectGarbage end");
        objectPoolMgr.DebugOutput();
        VEngine.Asset.DebutOutputCache();
        VEngine.Bundle.DebugOutputCache();
    }

    public void DebugOutput()
    {
        objectPoolMgr.DebugOutput();
        VEngine.Asset.DebutOutputCache();
        VEngine.Bundle.DebugOutputCache();
    }

    public void DebugLoadCount()
    {
        VEngine.Asset.DebugLoadCount();
    }

    public void RemoveCachedUnusedAssets()
    {
        VEngine.Asset.RemoveCachedUnusedAssets();
    }

    public string GetResVersion()
    {
        return VEngine.Versions.ManifestsVersion;
    }

    public bool IsSimulation
    {
        get { return VEngine.Versions.IsSimulation; }
    }

    public bool SkipUpdate
    {
        get { return VEngine.Versions.SkipUpdate; }
    }

    public void Update()
    {
        UpdateInstance();

        if (Time.realtimeSinceStartup - lastTimePerSecondUpdate >= 1)
        {
            lastTimePerSecondUpdate = Time.realtimeSinceStartup;
            
            UnityUIExtension.Update();
            UpdatePoolClean();
            UpdatePreloadRelease();
        }
        
        _updateBkground?.Update();
    }

    private void UpdatePoolClean()
    {
        objectPoolMgr.TryCleanPool();
    }

    private void UpdatePreloadRelease()
    {
        foreach (var i in preloadCache)
        {
            if (i.Value.expiredTime < Time.realtimeSinceStartup)
            {
                i.Value.asset.Release();
                keysRemove.Add(i.Key);
            }
        }

        if (keysRemove.Count > 0)
        {
            foreach (var key in keysRemove)
            {
                preloadCache.Remove(key);
            }
            keysRemove.Clear();
        }
    }
    
    //========================================================================
    // Sprite late binding
    //========================================================================
    #region SpriteAtlas
    
    private const string AtlasRootPath = "Assets/Main/Atlas/{0}.spriteatlas";
    
    private void OnAtlasRegistered(SpriteAtlas sa)
    {
        Log.Debug("OnAtlasRegistered: {0},{1}", sa.name, Time.frameCount);
    }
    
    private void OnAtlasRequested(string atlasName, System.Action<SpriteAtlas> callback)
    {
        Log.Debug("OnAtlasRequested: {0},{1}", atlasName, Time.frameCount);

        var atlasPath = string.Format(AtlasRootPath, atlasName);
        var req = VEngine.Asset.Load(atlasPath, typeof(SpriteAtlas));
        if (!req.isError)
        {
            callback(req.asset as SpriteAtlas);
        }
    }
    
    #endregion
    
    //========================================================================
    // GameObject Instantiate & Destroy
    //========================================================================
    #region Instantiate & Destroy
    
    private static readonly int MAX_INSTANCE_PERFRAME = 20;
    private static readonly float MAX_INSTANCE_TIME = 15.0f;
    private ObjectPoolMgr objectPoolMgr = new ObjectPoolMgr();
    private List<InstanceRequest> toInstanceList = new List<InstanceRequest>();
    private List<InstanceRequest> instancingList = new List<InstanceRequest>();
    private Dictionary<GameObject, InstanceRequest> gameObject2Request = new Dictionary<GameObject, InstanceRequest>();

    private void UpdateInstance()
    {
        int max = MAX_INSTANCE_PERFRAME;
        if (toInstanceList.Count > 0 && instancingList.Count < max)
        {
            int count = Math.Min(max - instancingList.Count, toInstanceList.Count);
            for (var i = 0; i < count; ++i)
            {
                var item = toInstanceList[i];
                if (item.state == InstanceRequest.State.Destroy)
                    continue;

                item.Instantiate();
                instancingList.Add(item);
            }

            toInstanceList.RemoveRange(0, count);
        }

        var time = DateTime.Now.TimeOfDay.TotalMilliseconds;
        int insCount = 0;
        for (var i = 0; i < instancingList.Count; i++)
        {
            var item = instancingList[i];
            if (item.Update())
                continue;
           

            instancingList.RemoveAt(i);
            --i;
            ++insCount;
            if (DateTime.Now.TimeOfDay.TotalMilliseconds - time > MAX_INSTANCE_TIME)
            {
                Log.Debug("resource log long time: {0} use time: {1} instaceCount : {2}", item.PrefabPath,
                    DateTime.Now.TimeOfDay.TotalMilliseconds - time, insCount);
                break;
            }
        }

        // if (insCount > 0)
        // {
        //     Log.Debug("resource log instance count: {0} use time: {1}", insCount,
        //         DateTime.Now.TimeOfDay.TotalMilliseconds - time);
        // }
    }


    private void ClearInstance()
    {
        foreach (var i in toInstanceList)
        {
            i.Destroy(); 
        }

        foreach (var i in instancingList)
        {
            i.Destroy();
        }
    }

    public ObjectPool GetObjectPool(string prefabPath)
    {
        return objectPoolMgr.GetPool(prefabPath, this);
    }

    public InstanceRequest InstantiateAsync(string prefabPath)
    {
        var req = new InstanceRequest(prefabPath);
        toInstanceList.Add(req);
        return req;
    }

    #endregion
}

public class InstanceRequest
{
    private string prefabPath;
    private ObjectPool pool;

    public enum State
    {
        Init, Loading, Instanced, Destroy
    }

    public string PrefabPath
    {
        get { return prefabPath; }
    }

    public bool isDone { get; private set; }

    public State state;
    public GameObject gameObject;
    public event Action<InstanceRequest> completed;

    public InstanceRequest(string prefabPath)
    {
        this.prefabPath = prefabPath;
        state = State.Init;
    }
    
    public void Instantiate()
    {
        pool = GameEntry.Resource.GetObjectPool(prefabPath);
        pool.lastDespawnTime = float.MaxValue;
        state = State.Loading;
    }
    
    public void RealDestroy()
    {
        if (gameObject != null)
        {
            UnityEngine.Object.Destroy(gameObject);
        }
        state = State.Destroy;
        completed = null;
    }

    public void Destroy()
    {
        if (gameObject != null)
        {
            pool.DeSpawn(gameObject);
            gameObject = null;
            pool = null;
        }
        
        state = State.Destroy;
        completed = null;
    }

    public bool Update()
    {
        if (state == State.Destroy)
            return false;
        if (!pool.IsAssetLoaded)
            return true;
        try
        {
            if (gameObject == null)
            {
                gameObject = pool.Spawn();
                state = State.Instanced;
                isDone = true;
            }

            completed?.Invoke(this);
            completed = null;
        }
        catch (Exception ex)
        {
            //Log.Error(ex.StackTrace);
            Log.Error(ex);
        }
        
        return false;
    }
}


class LoadSpriteInfo
{
    public LoadSpriteInfo(VEngine.Asset asset, Action<Asset> cb, GameObject image,string spritePath)
    {
        asset_ = asset;
        cb_ = cb;
        image_ = image;
        path = spritePath;
    }

    private GameObject image_;
    private VEngine.Asset asset_;
    public bool spriteHasEnable = false;
    public string path = "";
    private Action<Asset> cb_;
    public VEngine.Asset asset
    {
        get { return asset_; }
    }

    public void Release()
    {
        if (cb_ != null)
        {
            if (asset_ != null)
            {
                asset_.completed -= cb_;
            }

            cb_ = null;
        }

        if (asset_ != null)
        {
            asset_.Release();
        }
        path = "";
        asset_ = null;
        RecoverActive();
        image_ = null;
        
    }

    public void RecoverActive()
    {
        if (spriteHasEnable && !image_.IsNull()) 
        {
            image_.gameObject.SetActive(true);
        }
        spriteHasEnable = false;
    }
}
//
// UI扩展
//
public static class UnityUIExtension
{
    static List<UnityEngine.Object> keyToRemove = new List<UnityEngine.Object>(100);
    static readonly Dictionary<UnityEngine.Object, LoadSpriteInfo> AllRefs = new Dictionary<UnityEngine.Object, LoadSpriteInfo>();
    // public static void LoadSprite(this Image image, string spritePath, string defaultSprite = null)
    // {
    //     if (AllRefs.TryGetValue(image, out var asset))
    //     {
    //         asset.Release();
    //         AllRefs.Remove(image);
    //     }
    //     asset = LoadSprite(spritePath, defaultSprite);
    //     if (asset != null && !asset.isError)
    //     {
    //         AllRefs.Add(image, asset);
    //         image.sprite = asset.asset as Sprite;
    //     }
    // }
    //
    // public static void LoadSprite(this CircleImage image, string spritePath, string defaultSprite = null)
    // {
    //     if (AllRefs.TryGetValue(image, out var asset))
    //     {
    //         asset.Release();
    //         AllRefs.Remove(image);
    //     }
    //     asset = LoadSprite(spritePath, defaultSprite);
    //     if (asset != null && !asset.isError)
    //     {
    //         AllRefs.Add(image, asset);
    //         image.sprite = asset.asset as Sprite;
    //     }
    // }
    //
    // public static void LoadSprite(this SpriteRenderer spriteRenderer, string spritePath, string defaultSprite = null)
    // {
    //     if (AllRefs.TryGetValue(spriteRenderer, out var asset))
    //     {
    //         asset.Release();
    //         AllRefs.Remove(spriteRenderer);
    //     }
    //     asset = LoadSprite(spritePath, defaultSprite);
    //     if (asset != null && !asset.isError)
    //     {
    //         AllRefs.Add(spriteRenderer, asset);
    //         spriteRenderer.sprite = asset.asset as Sprite;
    //     }
    // }
    //
    // public static void LoadSprite(this SpriteMeshRenderer meshRenderer, string spritePath, string defaultSprite = null)
    // {
    //     if (AllRefs.TryGetValue(meshRenderer, out var asset))
    //     {
    //         asset.Release();
    //         AllRefs.Remove(meshRenderer);
    //     }
    //     asset = LoadSprite(spritePath, defaultSprite);
    //     if (asset != null && !asset.isError)
    //     {
    //         AllRefs.Add(meshRenderer, asset);
    //         meshRenderer.sprite = asset.asset as Sprite;
    //     }
    // }

    public static void LoadSprite(this Image image, string spritePath, string defaultSprite = null, Action onComplete = null)
    {
        if (XLuaManager.IsUseLoadAsync)
        {
            if (!spritePath.EndsWith(".png"))
            {
                spritePath += ".png";
            }
            if (AllRefs.TryGetValue(image, out var asset))
            {
                if (asset != null)
                {
                    if (asset.path == spritePath)
                    {
                        return;
                    }
                    asset.Release();
                }
                
                AllRefs.Remove(image);
            }
            var assetNew = GameEntry.Resource.LoadAssetAsync(spritePath,typeof(Sprite));
            var eve = new Action<Asset>(delegate
            {
                if (assetNew.isError == false)
                {
                    var spr = assetNew.asset as Sprite;
                    if (spr != null && image != null)
                    {
                        image.sprite = spr;
                        if (AllRefs.TryGetValue(image, out var info))
                        {
                            info.RecoverActive();
                        }
                        onComplete?.Invoke();
                    }
                    else
                    {
                        Log.Info("target Image is null:{0}", spritePath);
                    }
                }
            });
            if (assetNew != null && !assetNew.isError)
            {
                LoadSpriteInfo tmp = new LoadSpriteInfo(assetNew, eve, image.gameObject,spritePath);
                if (image.IsActive())
                {
                    image.gameObject.SetActive(false);
                    tmp.spriteHasEnable = true;
                }

                assetNew.completed += eve;
                AllRefs.Add(image, tmp);
            }
            
        }
        else
        {
            if (AllRefs.TryGetValue(image, out var asset))
            {
                asset.Release();
                AllRefs.Remove(image);
            }
            asset = LoadSprite(spritePath, defaultSprite, image.gameObject);
            if (asset != null && !asset.asset.isError)
            {
                AllRefs.Add(image, asset);
                image.sprite = asset.asset.asset as Sprite;
                onComplete?.Invoke();
            }
        }
        
    }
    public static void LoadSprite(this CircleImage image, string spritePath, string defaultSprite = null,Action onComplete = null)
    {
        if (XLuaManager.IsUseLoadAsync)
        {
            if (!spritePath.EndsWith(".png"))
            {
                spritePath += ".png";
            }
            if (AllRefs.TryGetValue(image, out var asset))
            {
                if (asset != null)
                {
                    if (asset.path == spritePath)
                    {
                        return;
                    }
                    asset.Release();
                }
                
                AllRefs.Remove(image);
            }
            var assetNew = GameEntry.Resource.LoadAssetAsync(spritePath,typeof(Sprite));
            var eve = new Action<Asset>(delegate
            {
                if (assetNew.isError == false)
                {
                    var spr = assetNew.asset as Sprite;
                    if (spr != null && image != null)
                    {
                        image.sprite = spr;
                        if (AllRefs.TryGetValue(image, out var info))
                        {
                            info.RecoverActive();
                        }
                        onComplete?.Invoke();
                    }
                    else
                    {
                        Log.Info("target CircleImage is null:{0}", spritePath);
                    }
                }
            });
            if (assetNew != null && !assetNew.isError )
            {
                LoadSpriteInfo tmp = new LoadSpriteInfo(assetNew, eve, image.gameObject,spritePath);
                
                if (image.gameObject.activeSelf)
                {
                    image.gameObject.SetActive(false);
                    tmp.spriteHasEnable = true;
                }
                assetNew.completed += eve;
                AllRefs.Add(image, tmp);
            }

        }
        else
        {
            if (AllRefs.TryGetValue(image, out var asset))
            {
                asset.Release();
                AllRefs.Remove(image);
            }
            asset = LoadSprite(spritePath, defaultSprite, image.gameObject);
            if (asset != null && !asset.asset.isError)
            {
                AllRefs.Add(image, asset);
                image.sprite = asset.asset.asset as Sprite;
                onComplete?.Invoke();
            }
        }
        
    }
    
    public static void LoadSprite(this SpriteRenderer spriteRenderer, string spritePath, string defaultSprite = null,Action onComplete = null)
    {
        if (XLuaManager.IsUseLoadAsync)
        {
            if (!spritePath.EndsWith(".png"))
            {
                spritePath += ".png";
            }
            if (AllRefs.TryGetValue(spriteRenderer, out var asset))
            {
                if (asset != null)
                {
                    if (asset.path == spritePath)
                    {
                        return;
                    }
                    asset.Release();
                }
                
                AllRefs.Remove(spriteRenderer);
            }
            var assetNew = GameEntry.Resource.LoadAssetAsync(spritePath,typeof(Sprite));
            var eve = new Action<Asset>(delegate
            {
                if (assetNew.isError == false)
                {
                    var spr = assetNew.asset as Sprite;
                    if (spr != null && spriteRenderer != null)
                    {
                        spriteRenderer.sprite = spr;
                        if (AllRefs.TryGetValue(spriteRenderer, out var info))
                        {
                            info.RecoverActive();
                        }
                        onComplete?.Invoke();
                    }
                    else
                    {
                        Log.Info("target SpriteRenderer is null:{0}", spritePath);
                    }
                }
            });
            if (assetNew != null && !assetNew.isError )
            {
                assetNew.completed += eve;
                LoadSpriteInfo tmp = new LoadSpriteInfo(assetNew, eve, spriteRenderer.gameObject,spritePath);
                if (spriteRenderer.gameObject.activeSelf)
                {
                    spriteRenderer.gameObject.SetActive(false);
                    tmp.spriteHasEnable = true;
                }
                AllRefs.Add(spriteRenderer, tmp);
            }

        }
        else
        {
            if (AllRefs.TryGetValue(spriteRenderer, out var asset))
            {
                asset.Release();
                AllRefs.Remove(spriteRenderer);
            }
            asset = LoadSprite(spritePath, defaultSprite, spriteRenderer.gameObject);
            if (asset != null && !asset.asset.isError)
            {
                AllRefs.Add(spriteRenderer, asset);
                spriteRenderer.sprite = asset.asset.asset as Sprite;
                onComplete?.Invoke();
            }
        }
        
    }
    
    public static void LoadSprite(this SpriteMeshRenderer meshRenderer, string spritePath, string defaultSprite = null,Action onComplete = null)
    {
        if (XLuaManager.IsUseLoadAsync)
        {
            if (!spritePath.EndsWith(".png"))
            {
                spritePath += ".png";
            }
            if (AllRefs.TryGetValue(meshRenderer, out var asset))
            {
                if (asset != null)
                {
                    if (asset.path == spritePath)
                    {
                        return;
                    }
                    asset.Release();
                }
                
                AllRefs.Remove(meshRenderer);
            }
            var assetNew = GameEntry.Resource.LoadAssetAsync(spritePath,typeof(Sprite));
            var eve = new Action<Asset>(delegate
            {
                if (assetNew.isError == false)
                {
                    var spr = assetNew.asset as Sprite;
                    if (spr != null && meshRenderer != null)
                    {
                        meshRenderer.sprite = spr;
                        if (AllRefs.TryGetValue(meshRenderer, out var info))
                        {
                            info.RecoverActive();
                        }
                        onComplete?.Invoke();
                    }
                    else
                    {
                        Log.Info("target SpriteMeshRenderer is null:{0}", spritePath);
                    }
                }
            });
            if (assetNew != null && !assetNew.isError )
            {
                assetNew.completed += eve;
                LoadSpriteInfo tmp = new LoadSpriteInfo(assetNew, eve, meshRenderer.gameObject,spritePath);
                if (meshRenderer.gameObject.activeSelf)
                {
                    meshRenderer.gameObject.SetActive(false);
                    tmp.spriteHasEnable = true;
                }
                AllRefs.Add(meshRenderer, tmp);
            }

        }
        else
        {
            if (AllRefs.TryGetValue(meshRenderer, out var asset))
            {
                asset.Release();
                AllRefs.Remove(meshRenderer);
            }
            asset = LoadSprite(spritePath, defaultSprite, meshRenderer.gameObject);
            if (asset != null && !asset.asset.isError)
            {
                AllRefs.Add(meshRenderer, asset);
                meshRenderer.sprite = asset.asset.asset as Sprite;
                onComplete?.Invoke();
            }
        }
        
    }
    public static void Update()
    {
        foreach (var kv in AllRefs)
        {
            var obj = kv.Key;
            if (obj == null)
            {
                kv.Value?.Release();
                keyToRemove.Add(obj);
            }
        }

        if (keyToRemove.Count > 0)
        {
            foreach (var k in keyToRemove)
            {
                AllRefs.Remove(k);
            }
            keyToRemove.Clear();
        }
    }
    
    private static LoadSpriteInfo LoadSprite(string spritePath, string defaultSprite, GameObject image)
    {
        if (!spritePath.EndsWith(".png"))
        {
            spritePath += ".png";
        }
        var req = VEngine.Asset.Load(spritePath, typeof(Sprite));
        if ((req == null || req.isError) && !string.IsNullOrEmpty(defaultSprite))
        {
            if (!defaultSprite.EndsWith(".png"))
            {
                defaultSprite += ".png";
            }
            req = VEngine.Asset.Load(defaultSprite, typeof(Sprite));
        }

        if (req != null)
        {
            return new LoadSpriteInfo(req, null, image,spritePath);
        }
        else
        {
            return null;
        }
    }
    
    
    
#region ScrollRect
    public static void SetHorizontalNormalizedPosition(this ScrollRect scrollRect, float ratio)
    {
        scrollRect.horizontalNormalizedPosition = ratio;
    }

    public static float GetHorizontalNormalizedPosition(this ScrollRect scrollRect)
    {
        return scrollRect.horizontalNormalizedPosition;
    }

    #endregion
    
}


//
// 后台下载更新
//
class DownloadUpdateBkground
{
    public List<VEngine.Manifest> manifests;

    private VEngine.DownloadVersions _downloadVersions;
    
    public void Start(List<VEngine.DownloadInfo> downloadInfos)
    {
        _downloadVersions = VEngine.Versions.DownloadAsync(downloadInfos.ToArray());
    }

    public void Update()
    {
        if (_downloadVersions != null && _downloadVersions.isDone)
        {
            if (_downloadVersions.isError)
            {
                var downloadInfos = new List<VEngine.DownloadInfo>();
                var totalSize = GameEntry.Resource.GetDownloadSize(manifests, downloadInfos);
                if (totalSize > 0)
                {
                    Log.Debug("restart bkground download {0}", totalSize);
                    Start(downloadInfos);
                }
                else
                {
                    _downloadVersions = null;
                    Log.Debug("finish bkground download 1");
                }
            }
            else
            {
                _downloadVersions = null;
                Log.Debug("finish bkground download 2");
            }
        }
    }
}