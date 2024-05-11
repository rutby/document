
using System;
using System.Collections;
using System.Collections.Generic;
using GameFramework;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;
using XLua;
using Random = UnityEngine.Random;

public class UILoadingComponent : MonoBehaviour
{
    public TextMeshProUGUIEx versionText;
    public Image background;
    public VideoPlayer videoPlayer;
    public Animator animator;
    public Slider progressBar;
    public TextMeshProUGUIEx loadingText;
    public TextMeshProUGUIEx tipText;
    public TextMeshProUGUIEx downloadText;
    public TextMeshProUGUIEx percentText;
    public Image logoImage;
    public GameObject wifiObj;
    
    private const string LOG_TAG = "[UILoading] ";
    //private string _load1 = Application.streamingAssetsPath + "/" + "O_loading_1.mp4";
    private static readonly string loadingVideoUrl = Application.streamingAssetsPath + "/" + "loading.mp4";
    private const float ShowLoadingAnimTime = 5.0f;

    private bool showLogo = false;
    private bool isPlayingUIAnim;
    private float totalTime;
    private bool isRefreshLocalizationText;
    
    private enum State { None, Download, Login }
    private State state = State.None;

    public void CSOpen(object userData)
    {
        DebugLog("UILoading CSOpen");
        InitLuaState(null);
        GameEntry.Event.Subscribe(EventId.BeginDownloadUpdate, OnStartBundleDownload);
        GameEntry.Event.Subscribe(EventId.EndDownloadUpdate,  OnStartLogin);
        GameEntry.Event.Subscribe(EventId.NetworkRetry,  OnNetworkRetry);
        GameEntry.Event.Subscribe(EventId.ReInitLoadingLuaState,  InitLuaState);
        GameEntry.Sound.PlayBGMusicByName(GameDefines.SoundAssets.Music_Bgm_night);
        GameEntry.Sdk.HideSplash();
        background.gameObject.SetActive(true);
        wifiObj.SetActive(false);
        
//        showLogo = (bool)userData;
        // logoImage.gameObject.SetActive(false);
//        if (showLogo)
//        {
//            animator.Play("UILoadAnimator", 0, 0);
//        }
        
        loadingText.text = "";
        downloadText.text = "";
        tipText.text = "";
        versionText.text = "";
        percentText.text = "";
        SetProgressBar(0);
        state = State.Login;
        isRefreshLocalizationText = false;
        //加载视频
        //videoPlayer.source = VideoSource.Url;
        //videoPlayer.url = loadingVideoUrl;
        //videoPlayer.isLooping = false;
        //videoPlayer.Prepare();
        //videoPlayer.GetComponent<RawImage>().enabled = false;

        if (GameEntry.Localization.IsInitDone)
        {
            loadingText.text = GameEntry.Localization.GetString("100231");
            // Version
            var appVersionStr = string.Format("{0}[{1}]", GameEntry.Sdk.Version, GameEntry.Sdk.VersionCode);
            var resVersionStr = GameEntry.Resource.GetResVersion();
            versionText.text = GameEntry.Localization.GetString("100050") +" "+ appVersionStr + "\n"
                               + GameEntry.Localization.GetString("100051") +" "+ resVersionStr;
        }

        // // string list = GameEntry.Setting.GetString(GameDefines.SettingKeys.GAME_UID,"");
        // string picName = "";
        // var packageName = GameEntry.Sdk.GetPackageName();
        // if (packageName == "com.readygo.xcity.gp")
        // {
        //     picName = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Global,1001,"k2");
        // }
        // else
        // {
        //     picName = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Global,1001,"k1");
        // }
        // if (!picName.IsNullOrEmpty())
        // {
        //     background.LoadSprite("Assets/Main/TextureEx/Loading/" + picName,"Assets/Main/TextureEx/Loading/Loading");
        // }
        // else
        // {
        //     background.LoadSprite("Assets/Main/TextureEx/Loading/Loading");
        // }
        // else
        // {
        //     int rd = (Random.Range(0,1.0f) > 0.5 ? 1 : 0);
        //     if (rd == 1)
        //     {
        //         background.LoadSprite("Assets/Main/Loading/" + tableRows);
        //     }
        //     else
        //     {
        //         background.LoadSprite("Assets/Main/Loading/" + "Loading_Bg1");
        //     }
        // }

        luaOnStart?.Invoke();

    }
    
    
    private LuaTable scriptEnv;
    private Action luaOnStart;
    private Action luaOnDestroy;
    private void InitLuaState(object obj)
    {
        Log.Debug("InitLuaState begin");
        luaOnDestroy?.Invoke();
        Log.Debug("InitLuaState after luaOnDestroy");
        LuaEnv luaEnv = GameEntry.Lua.Env;
        Log.Debug("gameentry lua env {0}", luaEnv.GetHashCode());
        scriptEnv = luaEnv.NewTable();

        // 为每个脚本设置一个独立的环境，可一定程度上防止脚本间全局变量、函数冲突
        LuaTable meta = luaEnv.NewTable();
        meta.Set("__index", luaEnv.Global);
        scriptEnv.SetMetaTable(meta);
        meta.Dispose();

        scriptEnv.Set("self", this);
        
        string luaFilePath = "Loading.LoadingView";
        byte[] luadata = XLuaManager.CustomLoader(ref luaFilePath);
        luaEnv.DoString(luadata, "LoadingView", scriptEnv);

        scriptEnv.Get("OnStart", out luaOnStart);
        scriptEnv.Get("OnDestroy", out luaOnDestroy);
    }

    public void CSClose(object userData)
    {
        GameEntry.Event.Unsubscribe(EventId.BeginDownloadUpdate, OnStartBundleDownload);
        GameEntry.Event.Unsubscribe(EventId.EndDownloadUpdate,  OnStartLogin);
        GameEntry.Event.Unsubscribe(EventId.NetworkRetry,  OnNetworkRetry);
        GameEntry.Event.Unsubscribe(EventId.ReInitLoadingLuaState,  InitLuaState);
        luaOnDestroy?.Invoke();
        luaOnDestroy = null;
        luaOnStart = null;
    }

    private void Update()
    {
        if (showLogo)
        {
            totalTime += Time.deltaTime;
            if (totalTime >= 2.5)
            {
                // logoImage.gameObject.SetActive(false);
                showLogo = false;
                totalTime = 0f;
            }
        }
        
        if (GameEntry.Localization.IsInitDone && !isRefreshLocalizationText)
        {
            RefreshLocalizationText();
            isRefreshLocalizationText = true;
        }

        if (state == State.Login)
        {
            //SetProgressBar(ApplicationLaunch.Instance.Loading.LoadingProgress);
        }
        else if (state == State.Download)
        {
            // var downloadProgress = ApplicationLaunch.Instance.Loading.BundleDownloadProgress;
            // var totalMB = ByteToMegaByte(ApplicationLaunch.Instance.Loading.BundleDownloadTotalBytes);
            // var progressMB = downloadProgress * totalMB;
            // downloadText.text = GameEntry.Localization.GetString("129045", 
            //     progressMB.ToString("f2"), totalMB.ToString("f2"));
            // SetProgressBar(downloadProgress);
        }
    }

    public float GetLogoAnimLength()
    {
        foreach (var i in animator.runtimeAnimatorController.animationClips)
        {
            if (i.name == "uiloadAnimator")
            {
                return i.length;
            }
        }

        return 0;
    }

    private void RefreshLocalizationText()
    {
        loadingText.text = GameEntry.Localization.GetString("100231");
        var appVersionStr = string.Format("{0}[{1}]", GameEntry.Sdk.Version, GameEntry.Sdk.VersionCode);
        var resVersionStr = GameEntry.Resource.GetResVersion();
        versionText.text = GameEntry.Localization.GetString("100050") +" "+ appVersionStr + "\n"
                           + GameEntry.Localization.GetString("100051") +" "+ resVersionStr;
    }

    private void SetProgressBar(float value)
    {
        //var remapValue = (1 - ProgressInit) * value;
        //progressBar.value = ProgressInit + remapValue;
        progressBar.value = value;
        percentText.text = value.ToString("0.0%");
    }

    private float GetProgressBar()
    {
        //return (progressBar.value - ProgressInit) / (1 - ProgressInit);
        return progressBar.value;
    }

    private void OnStartLogin(object ud)
    {
        DebugLog("OnStartLogin");

        //if (!videoPlayer.isPlaying)
        //{
        //    videoPlayer.Play();
        //    videoPlayer.GetComponent<RawImage>().enabled = true;
        //}

        //if (!isPlayingUIAnim)
        //{
        //    animator.Play("UILoading",0,0);
        //}
        
        state = State.Login;
        
        // logoImage.gameObject.SetActive(false);
        loadingText.gameObject.SetActive(true);
        
        SetProgressBar(0);
        downloadText.text = "";
        
        //StartCoroutine(StartLoadProcess());
    }

    private void OnNetworkRetry(object ud)
    {
        bool showWifi = (bool) ud;
        wifiObj.SetActive(showWifi);
    }

    private IEnumerator StartLoadProcess()
    {
        yield return new WaitForSeconds (ShowLoadingAnimTime);
        // _startShow = true;
    }

    private void OnStartBundleDownload(object ud)
    {
        DebugLog("OnStartBundleDownload");
        
        //isPlayingUIAnim = true;
        //animator.Play("UILoading",0,0);
        //videoPlayer.Play();
        state = State.Download;
        SetProgressBar(0);
        loadingText.gameObject.SetActive(false);
        var totalMB = 0;
        downloadText.text = GameEntry.Localization.GetString("129045", 
            0.0f.ToString("f2"), totalMB.ToString("f2"));
    }

    private void DebugLog(string msg)
    {
        Log.Info(LOG_TAG + msg);
    }
    private float ByteToMegaByte(float byteSize)
    {
        return byteSize / (1024.0f * 1024.0f);
    }
}
