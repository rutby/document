using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using Balaso;
using GameFramework;
using Sfs2X.Entities.Data;
using LitJson;
using UnityEngine;
using UnityGameFramework.SDK;
using AppsFlyerSDK;

public class SDKManager : IGameController
{
    private Action<string, string> payCallback_;
    public string pf_displayname = "";
    
    public SDKManager()
    {
    }

    public void Initialize()
    {
#if UNITY_EDITOR
        Platform = new PlatformEditor();
#elif UNITY_ANDROID
        Platform = new PlatformAndroid("com.sdkmanager.SdkListener");
#elif UNITY_IOS
        Platform = new PlatformIOS();
#elif UNITY_STANDALONE
        Platform = new PlatformStandalone();
#endif
        Platform.InitPlatform("");

        Version = Application.version;

        VersionCode = "111";
#if UNITY_EDITOR
#if UNITY_ANDROID
        VersionCode = UnityEditor.PlayerSettings.Android.bundleVersionCode.ToString();
#elif UNITY_IOS
        VersionCode = UnityEditor.PlayerSettings.iOS.buildNumber;
#elif UNITY_STANDALONE
        VersionCode = UnityEditor.PlayerSettings.Android.bundleVersionCode.ToString();
#else
        VersionCode = "1";
#endif
#elif UNITY_ANDROID
       VersionCode = Platform.GetDataFromNative("PM_getVersionCode", "");
#endif
        
#if UNITY_ANDROID
        SetAndroidScreenNotch();
#endif

#if UNITY_IOS
        RequestTrackingAuthorization();
#endif
        InitGoogleAds();
        
        
        //PayManager.Instance.init();
        //FireBaseManager.Init();
        //AppsFlyerManager.Init();
    }
    
    public void Shutdown()
    {
        payCallback_ = null;
    }
    
    // 设置PayManager回调
    public void SetPayMangerCallback(Action<string, string> action)
    {
        payCallback_ = action;
    }
    
    public IPlatformNative Platform
    {
        get;
        private set;
    }

#if UNITY_ANDROID
    public PlatformAndroid Android
    {
        get
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                return Platform as PlatformAndroid;
            }

            return null;
        }
    }
#endif

    public string Version
    {
        get;
        private set;
    }

    public string VersionCode
    {
        get;
        private set;
    }

    public bool IsGoogleAvailable
    {
        get;
        private set;
    }

    public string AndroidScreenNotch
    {
        get; 
        private set;
    }

    public string GetPublishRegion()
    {
        if (Application.platform == RuntimePlatform.Android)
        {
            var channel = GameEntry.Sdk.getChannel();
            return channel;
        }
        else if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            //if (IsArab())
            return "AppStore";
        }

        //# ifdef Channel_91
        //        return "91Store";
        //#else
        //        return "AppStore";
        //#endif
        return "";
    }

    public string GetPackageName()
    {
#if UNITY_EDITOR
        if (CommonUtils.IsDebug() == false)
        {
            return "com.readygo.dark.gp";
        }
#endif
            //string packageName = Application.identifier;
        //if (packageName.EndsWith(".debug", StringComparison.Ordinal))
        //{
        //    packageName = packageName.Substring(0, packageName.Length - 6);
        //}
        //return packageName;
#if UNITY_STANDALONE_OSX
        if (CommonUtils.IsDebug())
        {
            return "com.readygo.aps.pc.mac.debug";
        } 
        else 
        {
            return "com.readygo.aps.pc.mac";
        }
#endif
        
#if UNITY_STANDALONE_WIN
        if (CommonUtils.IsDebug())
        {
            return "com.readygo.aps.pc.debug";
        } 
        else 
        {
            return "com.readygo.aps.pc";
        }
#endif
       
        
        return Application.identifier;
    }

    public string GetPackageSign()
    {
        string identifier = GetPackageName();
        SHA1 sha1 = new SHA1CryptoServiceProvider();
        var hash = sha1.ComputeHash(Encoding.UTF8.GetBytes(identifier));
        return BitConverter.ToString(hash).Replace("-", string.Empty).ToLower();
    }

    public string getChannel()
    {
        return Platform.GetDataFromNative("PM_getPublishChannel", "");
    }

    public void saveDataToSdcard(string data, string path)
    {
        JsonData jData = new JsonData();
        jData["data"] = data;
        jData["filename"] = path;
        Platform.SendDataToNative("PM_saveDataToSdCard", jData.ToJson());
    }

    public void RequestSdCardPermission()
    {
        Platform.GetDataFromNative("PM_requestSdPermit", "");
    }
    
    public void DoInitGooglePay()
    {
        Platform.GetDataFromNative("PM_DoInitGooglePay", "");
    }
    
    public void CheckDownloadGoogleApk()
    {
        Platform.GetDataFromNative("PM_checkDownloadApk", "");
    }

    public string GetDeviceUDID()
    {
        return Platform.GetDataFromNative("PM_getDeviceUDID", "");
    }

    public string GetSerialID()
    {
        return Platform.GetDataFromNative("PM_getSerialID", "");
    }

    public string GetDeviceInfo()
    {
        return Platform.GetDataFromNative("PM_getDeviceInfo", "");
    }
    public void SetAndroidScreenNotch()
    {
        AndroidScreenNotch = Platform.GetDataFromNative("PM_getAndroidScreenNotch", "");
        Log.Debug("Android safe area: {0}", AndroidScreenNotch);
    }

    public void InitGoogleAds()
    {
        Platform.SendDataToNative("GAds_initGoogleAds","");
    }
    public void InitUnityAds(string appId)
    {
        Platform.SendDataToNative("UAds_initUnityAds",appId);
    }
    public string GetHandSetInfo()
    {
        return Platform.GetDataFromNative("PM_getHandSetInfo", "");
    }

    public string GenerateHighVersionUUID()
    {
        return Platform.GetDataFromNative("PM_generateHighVersionUUID", "");
    }

    public string GetSimOperator()
    {
        return Platform.GetDataFromNative("PM_getSimOperator", "");
    }

    public string GetSimOperatorName()
    {
        return Platform.GetDataFromNative("PM_getSimOperatorName", "");
    }
    
    /// <summary>
    /// 获取是通过点击哪个推送进来的pushtag
    /// </summary>
    /// <returns></returns>
    public string getClickPushTag()
    {
        return Platform.GetDataFromNative("PUSH_getPushTag", "");
    }
    
    public string getClickPushId()
    {
        return Platform.GetDataFromNative("PUSH_getPushId", "");
    }

    /// <summary>
    /// 获取是通过点击哪个推送进来的pushtime
    /// </summary>
    /// <returns></returns>
    public string getClickPushTime()
    {
        return Platform.GetDataFromNative("PUSH_getPushTime", "");
    }

    public void ClearAllPushData()
    {
        Platform.SendDataToNative("PUSH_clearAllCache", "{}");
    }

    public void CopyTextToClipboard(string _content)
    {
        try
        {
            JsonData data = new JsonData();
            data["content"] = _content;

            string jsonData = data.ToJson();
            Platform.SendDataToNative("PM_copyTextToClipboard", jsonData);
        }
        catch (System.Exception e)
        {
            Debug.LogWarning(e);
        }
    }

    public bool GetIsNotifyOpen()
    {
        return PushNoticeManager.GetIsNotifyOpen();
    }

    // ios app是否开启了允许跟踪
    public bool IsTrackingEnabled()
    {
        return AppTrackingTransparency.TrackingAuthorizationStatus == AppTrackingTransparency.AuthorizationStatus.AUTHORIZED;
    }

    // 打开ios app设置页面
    public void OpenSettings()
    {
        Platform.GetDataFromNative("PM_OpenSettings","");
    }

    // 请求ios跟踪权限
    private void RequestTrackingAuthorization()
    {
        AppTrackingTransparency.RegisterAppForAdNetworkAttribution();
        var currentStatus = AppTrackingTransparency.TrackingAuthorizationStatus;
        if (currentStatus != AppTrackingTransparency.AuthorizationStatus.AUTHORIZED)
        {
            AppTrackingTransparency.RequestTrackingAuthorization();
        }
    }

    public void LogEvent(string eventName, params object[] datas)
    {
        //Debug 版本不用做统计
        if (CommonUtils.IsDebug())
        {
            return;
        }
        
        //facebook
        JsonData data = new JsonData();
        data["uid"] = GameEntry.Data.Player.Uid;
        data["key"] = eventName;
        string jsonData = data.ToJson();
        SendDataToNative("FB_RecordEvent", jsonData);
        // Platform.SendDataToNative("FB_RecordEvent", eventName);
        RecordAppsflyer(eventName);
    }

    public void Send_FireBase_LogCustomEvent(string dataString)
    {
        //Debug 版本不用做统计
        if (CommonUtils.IsDebug())
        {
            return;
        }

        if (dataString.IsNullOrEmpty())
        {
            return;
        }
        Log.Info("FireBase_LogCustomEvent:{0}",dataString);
        SendDataToNative("FireBase_LogCustomEvent", dataString);
    }

    public void LogEventLevelUp(int lv)
    {
        if (CommonUtils.IsDebug())
        {
            return;
        }
        
        JsonData data = new JsonData();
        data["lv"] = lv;
        Platform.SendDataToNative("FB_LevelUp", data.ToJson());
    }

    public void Login(LoginPlatform loginPF, bool changeAccount = false, bool isBind = false)
    {
        JsonData data = new JsonData();
        data["platform"] = (int)loginPF;
        data["changeAccount"] = changeAccount;
        data["isBind"] = isBind;

        Platform.LoginPlatform = loginPF;
        Platform.SignIn(data.ToJson());
    }

    public void Logout()
    {
        Platform.SignOut();
    }

    public void Pay(string data)
    {
        Platform.Pay((int)Platform.PaymentChannel, data);
    }

    public int CheckPayEnv()
    {
        return Platform.GetDataFromNative("PAY_CheckPayEnv", "").ToInt();
    }

    public string Get_PF_DisplayName()
    {
        return Platform.GetDataFromNative("PF_DisplayName", "");
    }

    public void ConsumeProduct(string orderId, int state)
    {
        Platform.ConsumeProduct(orderId, state);
    }

    public void GotoMarket(string url, string urlCDN)
    {
#if UNITY_ANDROID
        Android?.Call("GotoMarket", url, urlCDN);
#endif
    }

    private readonly Dictionary<string, List<string>> m_Events = new Dictionary<string, List<string>>();

    public void SendDataToGame(string funcName, string data)
    {
        lock (m_Events)
        {
            if (m_Events.TryGetValue(funcName, out List<string> list))
            {
                list.Add(data);
            }
            else
            {
                m_Events.Add(funcName, new List<string> { data });
            }
        }
    }

    public void OnUpdate(float elapseSeconds)
    {
        lock (m_Events)
        {
            Dictionary<string, List<string>>.Enumerator enumerator = m_Events.GetEnumerator();
            while (enumerator.MoveNext())
            {
                for (int i = 0; i < enumerator.Current.Value.Count; ++i)
                    HandleEvent(enumerator.Current.Key, enumerator.Current.Value[i]);
            }

            m_Events.Clear();
        }
    }

    public void HandleEvent(string funcName, string data)
    {
        Log.Info("HandleEvent, funcName = {0}, data = {1}", funcName, data);
        try
        {
            switch (funcName)
            {
                case "onSDKInit":
                    {
    #if UNITY_ANDROID
                        JsonData recvData = JsonMapper.ToObject(data);
                        IsGoogleAvailable = (bool)recvData["1"];
    #endif
                        GameEntry.GlobalData.SetAnalyticID();
                        //这个地方不能打点,这个地方还没有获取到玩家权限,还无法拿到之前的deviceId,这个如果要做得话,需要具体讨论下deviceid的存储规则
    //                    PostEventLog.Record(PostEventLog.Defines.LAUNCH);
    
                        HelpManager.Instance.init();
                    }
                    break;
                case "onSignInCallback":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        OnLoginCallBack(recvData);
                    }
                    break;
                case "PostEvent":
                {
                    PostEventLog.Record(data);
                }
                    break;
                case "onSignOutCallback":
                    {
                        PlatformResult result = JsonUtility.FromJson<PlatformResult>(data);
                        if (int.TryParse(result.code, out int code))
                        {
                            switch (code)
                            {
                                case 1:
                                    Log.Info("登出成功~");
                                    break;
                                case -2:
                                    Log.Info("没有登陆～");
                                    break;
                                default:
                                    Log.Info("登出失败~");
                                    break;
                            }
    
                        }
                    }
                    break;
                case "PermissionRecv":
                {
                    GameEntry.Event.Fire(EventId.SDK_PermissionRecv);
                }
                    break;
                
                // 选择完照片路径然后传给游戏
                case "getHeadImgUrl":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        string urlPath = "";
                        if (recvData != null)
                        { 
                            urlPath = (string)recvData["1"];
                        }
                        UploadImageManager.Instance.OnImagePathOk(urlPath);
                    }
                    break;
                
                case "setGaid":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        string gaid = (string)recvData["1"];
                        bool lat = ((string)recvData["2"]).Equals("true");
    
                        Log.Info("gaid {0}, gaidCache {1}", gaid, GameEntry.GlobalData.gaidCache);
                        if (GameEntry.GlobalData.gaidCache != null && GameEntry.GlobalData.gaidCache.Equals("missed"))
                        {
                            GameEntry.GlobalData.gaid = gaid;
                            UserBindGaidMessage.Instance.Send(new UserBindGaidMessage.Request() { gaid = gaid });
                        }
                        else
                        {
                            GameEntry.GlobalData.gaidCache = gaid;
                        }
                    }
                    break;
                
                case "registerdParseAccount":
                {
                    JsonData recvData = JsonMapper.ToObject(data);
                    string parseId = (string)recvData["1"];
                    string platform = (string)recvData["2"];
                    GameEntry.GlobalData.parseRegisterId = parseId;
                    Log.Info($"registerdParseAccount {parseId}");
                    PushManager.Instance.registerdParseAccount(parseId, platform);
                }
                    break;
                case "SetFireBaseId":
                {
                    JsonData jsonData = JsonMapper.ToObject(data);
                    string firebaseId = (string) jsonData["firebaseId"];
                    PushManager.Instance.SetFireBaseId(firebaseId);
                }
                    break;
                
                case "setFromCountry":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        string country = (string)recvData["1"];
                        Log.Info("setFromCountry fromCountry {0}", country);
    
                        GameEntry.GlobalData.fromCountry = country;
                    }
                    break;
                case "setVersionAndCode":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        Version = (string)recvData["1"];
                        VersionCode = (string)recvData["2"];
                    }
                    break;
                case "onGooglePayInitResult":
                    {
                        if (payCallback_ != null)
                        {
                            payCallback_("onGooglePayInitResult", data);
                        }
                        // GameEntry.PayManager.OnGooglePayInitResult(data);
                    }
                    break;
                case "onPurchaseQueried":
                    {
                        if (payCallback_ != null)
                        {
                            payCallback_("onPurchaseQueried", data);
                        }
                        // GameEntry.PayManager.OnPurchaseQueried(data);
                    }
                    break;
                case "onPurchaseCallback":
                    {
                        if (payCallback_ != null)
                        {
                            payCallback_("onPurchaseCallback", data);
                        }
                        // GameEntry.PayManager.onPurchaseCallback(data);
                    }
                    break;
                case "onRequestPermissionsResult":
                    {
    
                    }
                    
                    break;
                case "FB_Login_Callback":
                    {
                        JsonData recvData = JsonMapper.ToObject(data);
                        OnLoginCallBack(recvData);
                    }
                    break;
                case "GAds_userEarnedReward":
                {
                    GameEntry.Event.Fire(EventId.GoogleAdsUserEarnedReward,data);
                }
                    break;
                case "GAds_userExitReward":
                {
                    GameEntry.Event.Fire(EventId.GoogleAdsUserExitReward,data);
                }
                    break;
                case "GAds_userCreateRewardedAdFail":
                {
                    GameEntry.Event.Fire(EventId.GoogleAdsUserCreateRewardedAdFail,data);
                }
                    break;
                case "GAds_userCreateRewardedAdSuccess":
                {
                    GameEntry.Event.Fire(EventId.GoogleAdsUserCreateRewardedAdSuccess,data);
                }
                    break;
                case "GAds_userClickAd":
                {
                    GameEntry.Event.Fire(EventId.GoogleAdsUserClickAd,data);
                }
                    break;
                case "UAds_userSkipReward":
                {
                    GameEntry.Event.Fire(EventId.UnityAdsUserSkipReward,data);
                }
                    break;
                case "UAds_userFinishReward":
                {
                    GameEntry.Event.Fire(EventId.UnityAdsUserEarnedReward,data);
                }
                    break;
                case "UAds_userClickAd":
                {
                    GameEntry.Event.Fire(EventId.UnityAdsUserClickAd,data);
                }
                    break;
                case "UAds_userCreateRewardedAdSuccess":
                {
                    GameEntry.Event.Fire(EventId.UnityAdsUserCreateRewardedAdSuccess,data);
                }
                    break;
                case "UAds_userCreateRewardedAdFail":
                {
                    GameEntry.Event.Fire(EventId.UnityAdsUserCreateRewardedAdFail,data);
                }
                    break;
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
        }
    }

    public void SendDataToNative(string funcName, string data)
    {
        Platform.SendDataToNative(funcName, data);
    }

    public string GetDataFromNative(string funcName, string data)
    {
        return Platform.GetDataFromNative(funcName, data);
    }

    public string GetPermissionByType(string data)
    {
        return Platform.GetPermissionByType(data);
    }

    
    
    void OnLoginCallBack(JsonData result)
    {
        Log.Info("OnLoginCallBack loginPlatform={0}", Platform.LoginPlatform);
        if (!result.Keys.Contains("errorNo"))
        {
            Platform.UID = (string)result["uid"];
            Log.Info("SDK登录成功~");
            bool isBind = (bool)result["isBind"];

            ISFSObject signal = SFSObject.NewInstance();
            switch (Platform.LoginPlatform)
            {
                case LoginPlatform.GooglePlay:
                    //googleplay
                    if (isBind)
                    {
                        signal.PutUtfString("msgId", "login_sucess_google");
                    }
                    else
                    {
                        pf_displayname = Get_PF_DisplayName();
                        PlayerPrefs.SetString("google_name", pf_displayname);
                        PlayerPrefs.Save();
                        //send message
                        
                        int renameTime = GameEntry.Lua.GetValue_Int("LuaEntry.Player", "renameTime");
                        PostEventLog.Record("google_signin_c_get" + renameTime.ToString());
                        if (renameTime == 0)
                            ChangePFdisplayName.Instance.Send();
                    }

                    break;
                case LoginPlatform.FaceBook:
                    //facebook
                    if (isBind)
                    {
                        signal.PutUtfString("msgId", "login_sucess_fb");
                    }
                    break;
                default:
                    break;
            }
            if (isBind)
            {
                signal.PutUtfString("userId", (string)result["uid"]);
                signal.PutUtfString("userName", (string)result["displayName"]);
                signal.PutUtfString("email", result.Keys.Contains("email") ? (string)result["email"] : "");
                
                signal.PutUtfString("accessToken", result.Keys.Contains("accessToken") ? (string)result["accessToken"] : "");
                signal.PutUtfString("picUrl", result.Keys.Contains("picUrl") ? (string)result["picUrl"] : "");
                signal.PutUtfString("gender", result.Keys.Contains("gender") ? (string)result["gender"] : "");
                GameEntry.Event.Fire(EventId.MSG_RESPONSED3RDPLATFORM, signal);
            }
        }
        else
        {
            string errorNo = result["errorNo"].ToString();
            GameFramework.Log.Info("SDK登录失败~errorNo=" + errorNo);
            bool isBind = (bool)result["isBind"];
            switch (Platform.LoginPlatform)
            {
                case LoginPlatform.GooglePlay:
                    Debug.Log(">>>google c# loginfail");
                    int _gpLoginCnt = GameEntry.Setting.GetInt("google_login_fail_cnt", 0);
                    _gpLoginCnt++;
                    GameEntry.Setting.SetInt("google_login_fail_cnt", _gpLoginCnt);
                    GameEntry.Setting.Save();
                    //googleplay
                    //google AddResult:{"errorNo":"12501"}
                    //12501 取消  12501
                    //12502 重复登录 SIGN_IN_CURRENTLY_IN_PROGRESS
                    //12500  SIGN_IN_FAILED
                    //10 没有用线上签名
                    if (isBind)
                    {
                        ISFSObject signal = SFSObject.NewInstance();
                        if (errorNo == "12501")
                        {
                            signal.PutUtfString("msgId", "login_canceled_google");
                        }
                        else
                        {
                            signal.PutUtfString("msgId", "login_failed_google");
                        }
                        signal.PutUtfString("errorNo", errorNo);
                        GameEntry.Event.Fire(EventId.MSG_RESPONSED3RDPLATFORM, signal);
                    }
                    break;
                case LoginPlatform.FaceBook:
                    //facebook
                    if (isBind)
                    {
                        ISFSObject signal = SFSObject.NewInstance();
                        if (errorNo == "0")
                        {
                            signal.PutUtfString("msgId", "login_canceled_fb");
                        }
                        else
                        {
                            signal.PutUtfString("msgId", "login_failed_fb");//-1 失败,-2没获取到token
                        }
                        signal.PutUtfString("errorNo", errorNo);
                        GameEntry.Event.Fire(EventId.MSG_RESPONSED3RDPLATFORM, signal);
                    }
                    break;
                default:
                    break;
            }

            //UIUtils.ShowTips("登录失败");
        }
    }

    public void HideSplash()
    {
#if UNITY_ANDROID
        Android?.Call("HideSplash");
#endif
    }

    public bool IsShowLogoOk()
    {
        bool? ret = true;
#if UNITY_ANDROID && !UNITY_EDITOR
        ret = Android?.Call<bool>("IsShowLogoOk");
#endif
        return ret.Value;
    }

    //lua中用到的平台判断
    public static bool IS_UNITY_ANDROID()
    {
#if UNITY_ANDROID
        return true;
#else
        return false;
#endif
    }
    
    public static bool IS_UNITY_IOS()
    {
#if UNITY_IOS
        return true;
#else
        return false;
#endif
    }
    
    public static bool IS_UNITY_IPHONE()
    {
#if UNITY_IPHONE
        return true;
#else
        return false;
#endif
    }
    
    public static bool IS_UNITY_EDITOR()
    {
#if UNITY_EDITOR
        return true;
#else
        return false;
#endif
    }
    public static bool IS_UNITY_PC()
    {
#if UNITY_STANDALONE
        return true;
#else
        return false;
#endif
    }

    public static bool IS_IPhonePlayer()
    {
        return Application.platform == RuntimePlatform.IPhonePlayer;
    }
    
    public static bool IS_Android()
    {
        return Application.platform == RuntimePlatform.Android;
    }
    
    public void requestFCMToken(){
        SendDataToNative("FireBase_getFCMToken", "");
    }

    public void CrashlyticsSetCustomValue(string key, string value)
    {
        JsonData data = new JsonData();
        data["key"] = key;
        data["value"] = value;
        string jsonData = data.ToJson();

        // FIXME: 这里应该在底层处理好try..catch
        SendDataToNative("FireBase_CrashlyticsSetCustomValue", jsonData);
    }

    public void CrashlyticsAddLog(string log)
    {
        SendDataToNative("FireBase_CrashlyticsAddCustomLog", log);
    }

    public void CrashlyticsSetUserId(string userId)
    {
        SendDataToNative("FireBase_CrashlyticsSetUserId", userId);
    }
    
    public void initAppsFlyer(string gameUid)
    {
        try
        {
            JsonData data = new JsonData();
            data["uid"] = gameUid;

            string jsonData = data.ToJson();
            SendDataToNative("PM_InitAppFlyer", jsonData);
        }
        catch (System.Exception e)
        {
            GameFramework.Log.Warning(e);
        }
    }
        
    public void RecordAppsflyer(string key)
    {
        try
        {
            JsonData data = new JsonData();
            data["uid"] = GameEntry.Data.Player.Uid;
            data["key"] = key;
            string jsonData = data.ToJson();
            SendDataToNative("PM_RecordAppsflyer", jsonData);
        }
        catch (System.Exception e)
        {
            GameFramework.Log.Warning(e);
        }
    }
        
    public void SetAppsFlyerPurchase(string cost, string itemId)
    {
        // try
        // {
        //     JsonData data = new JsonData();
        //     data["cost"] = cost;
        //     data["itemId"] = itemId;
        //     string jsonData = data.ToJson();
        //     SendDataToNative("PM_SetAppsFlyerPurchase", jsonData);
        //     SetFacebookPurchaseEvent(cost, itemId);
        // }
        // catch (System.Exception e)
        // {
        //     GameFramework.Log.Warning(e);
        // }
    }
    
    public void SetFacebookPurchaseEvent(string cost, string itemId)
    {
        //测试包不打点
        if (CommonUtils.IsDebug())
            return;
        try
        {
            JsonData data = new JsonData();
            data["cost"] = cost;
            data["itemId"] = itemId;
            string jsonData = data.ToJson();
            SendDataToNative("FB_SetPurchaseEvent", jsonData);
        }
        catch (Exception e)
        {
            Log.Warning(e);
        }
    }

    public string GetAppsFlyerUid()
    {
        return GetDataFromNative("AF_getAppsFlyerUid", "");
    }
    
    
    /**********************************/
    //打开相机、相册
    public void OnUploadPhoto(string uid, int code, int idx)
    {
        try
        {
            JsonData data = new JsonData();
            data["uid"] = uid;
            data["code"] = code;
            data["idx"] = idx;

            string jsonData = data.ToJson();
            SendDataToNative("PM_OnUploadPhoto", jsonData);
        }
        catch (System.Exception e)
        {
            GameFramework.Log.Warning(e);
        }
    }
    
}
