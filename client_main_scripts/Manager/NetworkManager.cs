using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using GameFramework;
using GameKit.Base;
using Main.Scripts.Network;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using Sfs2X.Util;
using UnityEngine;
using UnityEngine.Networking;
using XLua;

public class NetworkManager : IGameController, INetManager
{
    public NetworkManager()
    {
        MessageFactory.Instance.InitMessageHandlers();
        _futureManager = new FutureManager();
    }

    public void OnUpdate(float elapseSeconds)
    {
        UpdateSmartFoxClient();
    }

    public void Shutdown()
    {
        Disconnect();
        Log.Info("net work shut down");
    }

    public FutureManager getFutureManager()
    {
        return _futureManager;
    }

    public string getCurLine()
    {
        if (m_proxy == null)
        {
            return "direct";
        }

        return m_proxy.proxyName;
    }

    #region SmartFoxClient

    private FutureManager _futureManager;
    // private SmartFox m_Client;
    private INetProxy m_proxy;//当前选中线路
    private List<INetProxy> m_allSelectProxy = new List<INetProxy>();//选择中线路

    public string GameServerUrl { get; set; }
    public int GameServerPort { get; set; }
    public string ZoneName { get; set; }
    public string Uid { get; set; }
    public bool Logined { get; private set; }
    
    public bool IsConnected
    {
        get
        {
            return m_proxy != null && m_proxy.IsConnected;
        }
    }

    public bool IsConnecting
    {
        get
        {
            return m_proxy != null && m_proxy.IsConnecting;
        }
    }

    public Action<string, string> OnConnectionEvent;

    //内网连接线上服务器
    private void onBeforeConnect()
    {
        // 外网连接
        if (CommonUtils.IsDebug() == false)
        {
            GameServerUrl = "47.254.93.20";
            GameServerPort = 8088;
            ZoneName = "APS1";
            Uid = "478473000001";
        }
        
        
        //外网服务器地址 s3xxx.az.im30app.com xxx为服务器id
        //GameServerUrl = "s3335.az.im30app.com";
        //GameServerPort = 9933;
        //ZoneName = "COK335";//zone 为COKxxx xxx为服务器id
        //Uid = "383585611000335";
        //GameEntry.Setting.SetString(GameDefines.SettingKeys.GAME_UID, Uid);

        ////后台增加了uuid验证，需要手动输入uuid,U3d账号不需要
        ////在后台管理系统里面查找数据库：select openedPos from userprofile  where uid='383585611000335'
        //string uuid = "4156a051563d47a29fabaa9db8902192FB881551435895600";
        //GameEntry.Setting.SetString(GameDefines.SettingKeys.UUID, uuid);
    }

    public void Connect()
    {
        Logined = false;
#if UNITY_EDITOR
        onBeforeConnect();
#endif
        //清理所有正在连接中的线路
        clearAllLine();
        //选线
        chooseLine();
        _futureManager.reset();
        // Log.Info("Connect ip {0}, Port {1}", GameServerUrl, GameServerPort);
    }

    private void clearAllLine()
    {
        foreach (var p in m_allSelectProxy)
        {
            p.Disconnect();
        }
        m_allSelectProxy.Clear();
    }

    private void initLine()
    {
        var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllProxy");
        var hasLine = false;
        var useRaw = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsUseNetRaw");

        if (table != null)
        {
            for (int i = 1; i <= table.Length; ++i)
            {
                var data = (LuaTable)table[i];
                if (data.ContainsKey("lineName") && data.ContainsKey("lineUrl") && data.ContainsKey("port"))
                {
                    var lineName = data.Get<string>("lineName");
                    var lineUrl = data.Get<string>("lineUrl");
                    var port = data.Get<int>("port");
                    INetProxy line;
                    if (!useRaw)
                    {
                        line = new NetProxy(lineName, lineUrl, port, this);
                    }
                    else
                    {
                        line = new NetRawProxy(lineName, lineUrl, port, this);
                    }

                    m_allSelectProxy.Add(line);
                    hasLine = true;
                }
            }
        }

        if (hasLine == false)
        {
            NetProxy direct = new NetProxy("direct", GameServerUrl, GameServerPort, this);
        }
    }

    private void chooseLine()
    {
        initLine();
        foreach (var p in m_allSelectProxy)
        {
            p.Connect();
        }
    }

    public void Send(IRequest request)
    {
        if (m_proxy != null)
            m_proxy.Send(request);
    }

    public void SendLuaMessage(string msgId, byte[] sfsObjBinary)
    {
        SFSObject sfsObj;
        if (sfsObjBinary != null)
        {
            sfsObj = SFSObject.NewFromBinaryData(new Sfs2X.Util.ByteArray(sfsObjBinary));
        }
        else
        {
            sfsObj = SFSObject.NewInstance();
        }

        int fuId = _futureManager.getFutureId();
        sfsObj.PutInt("_id", fuId);
        _futureManager.onSendRequest(fuId, msgId);
        Send(new ExtensionRequest(msgId, sfsObj));
    }

    public void Disconnect()
    {
        Logined = false;
        
        if (m_proxy != null)
        {
            m_proxy.Disconnect();

            m_proxy = null;
        }
    }

    public void KillConnection()
    {
        // if (m_proxy != null)
        // {
        //     m_proxy.ki
        // }
    }

    public void SyncPingPong(int time = -1)
    {
        if (m_proxy != null)
        {
            m_proxy.SyncPingPong(time);
        }
    }

    public bool IsPingPongTimeOut
    {
        get
        {
            if (m_proxy != null)
            {
                return m_proxy.IsPingPongTimeOut;
            }

            return false;
        }
    }

    public bool OnConnection(INetProxy proxy, BaseEvent e)
    {
        bool success = (bool) e.Params["success"];
        if (success)
        {
            if (m_proxy == null)
            {
                foreach (var p in m_allSelectProxy)
                {
                    if (!p.proxyName.Equals(proxy.proxyName))
                    {
                        p.Disconnect();
                    }
                }

                m_proxy = proxy;
                // m_allSelectProxy.Clear();

                //消息推送相关
                string pushType = GameEntry.Setting.GetString("CATCH_PUSH_TYPE", "");
                if (!string.IsNullOrEmpty(pushType))
                {
                    GameEntry.Setting.SetString("CATCH_PUSH_TYPE", "");
                }

                OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_SUCCESS, null);
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            bool allError = true;
            
            foreach (var p in m_allSelectProxy)
            {
                if (p.Status != ProxyStatus.connectError)
                {
                    allError = false;
                    break;
                }
            }

            if (allError)
            {
                var errCode = e.Params["errorCode"];
                string errorMessage = (string) e.Params["errorMessage"];
                try
                {
                    errorMessage = errorMessage.Split('\n')[0];
                    errorMessage = errorMessage.Substring(errorMessage.LastIndexOf(':'));
                    Log.Error("Connect to server failed:{0}", errorMessage);

                    if (errorMessage.Contains("Network is unreachable"))
                    {
                        OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_UNREACHABLE, errorMessage);
                    }
                    else
                    {
                        OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_NETWORK, errorMessage);
                    }
                }
                catch (Exception ex)
                {
                    Log.Error(ex.Message);
                }
            }
        }

        return false;
    }


    public void OnConnectionLost(string reason, INetProxy proxy)
    {
        Log.Error("Connection {0} was lost, Reason: {1} cur line {2}", proxy.proxyName, reason, getCurLine());
        
        if (m_proxy != null && !m_proxy.proxyName.Equals(proxy.proxyName))
        {
            Log.Info("line {0} lost not cur {1} line do nothing", proxy.proxyName, getCurLine());
            return;
        }

        if (IsConnecting)
        {
            OnConnectionError(LoginErrorCode.ERROR_CONN_LOST);
            return;
        }

        if (GameEntry.GlobalData.isInBackGround)
            return;

        //被其他手机给顶了就不连了
        if (GameEntry.GlobalData.pushOffWithQuitGame)
            return;

        PostEventLog.Record(PostEventLog.Defines.DISCONNECT_RETRY, $"connection lost, reason: {reason}");
        Log.Info("connection lost, reconnect");
        Disconnect();
        ApplicationLaunch.Instance.DisconnectRetry();
    }

    private void OnConnectionError(string error)
    {
        bool allError = true;
        if (m_proxy != null)
        {
            allError = true;
        }
        else
        {
            foreach (var p in m_allSelectProxy)
            {
                if (p.Status != ProxyStatus.connectError)
                {
                    allError = false;
                    break;
                }
            }
        }

        if (allError)
        {
            Disconnect();
            int.TryParse(error, out var errcode);
            OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_NETWORK, "OnConnectionError");
            if (error == LoginErrorCode.ERROR_NO_NET || (errcode < -200))
            {
                GameEntry.Event.Fire(EventId.Net_Connect_Error, error);
                return;
            }

            GameEntry.Event.Fire(EventId.Net_Connect_Error, LoginErrorCode.ERROR_CONNECT);
        }
    }
    
    public void OnLogin(BaseEvent e)
    {
        Logined = MessageFactory.Instance.OnLogin(e);
    }

    private void OnPingPoing(BaseEvent evt)
    {
        SyncPingPong();
        // Log.Debug("OnPingPoing");
    }

    public void OnLoginError(BaseEvent e)
    {
        string error = (string)e.Params["errorMessage"];
        short errorCode = (short)e.Params["errorCode"];
        Log.Error("Login error: {0}_code{1}", error, errorCode);
        
        Logined = false;
        MessageFactory.Instance.OnLoginError(error,errorCode);
//         string[] arSplit = error.Split(';');
//         if (arSplit.Length > 0 && arSplit[0] == "4")
//         {
//             // ban user
//             if (arSplit.Length >= 4)
//             {
//                 ShowAccountBind(error);
//             }
//             else
//             {
//                 ShowAccountBind("");
//             }
//         }
//         else if (errorCode == 1 || error == "E002")
//         {
//             PlayerPrefs.DeleteAll();
//             ApplicationLaunch.Instance.ReloadGame();
//         }
//         else
//         {
//             if (error == "E010")
//             {
//                 UIUtils.ShowMessage(GameEntry.Localization.GetString("110319"),
//                     delegate { ApplicationLaunch.Instance.Quit(); });
//             }
//             else
//             {
// #if DEBUG
//                 UIUtils.ShowReloadMessage(GameEntry.Localization.GetString(error), delegate { ApplicationLaunch.Instance.ReloadGame(); }, delegate { ApplicationLaunch.Instance.Quit(); }, "110043");
// #else
//                 string dialog = GameEntry.Localization.GetString("129063") + " \n" + error;
//                 UIUtils.ShowReloadMessage(dialog, delegate { ApplicationLaunch.Instance.ReloadGame(); }, delegate { ApplicationLaunch.Instance.Quit(); }, "110043");
// #endif
//                 
//             }
//
//             
//         }
    }

    private void ShowAccountBind(string errorCode)
    {
        if (errorCode.IsNullOrEmpty())
        {
            UIUtils.ShowMessage(GameEntry.Localization.GetString("E100085"), 1, null);
            return;
        }
        GameEntry.Lua.UIManager.OpenWindow("UIAccountBan",errorCode);
    }
    public void OnLogout(BaseEvent e)
    {
        Log.Debug("Logout");
        Logined = false;
    }

    private void OnExtensionResponse(BaseEvent e)
    {
        SyncPingPong();
        MessageFactory.Instance.DispatchResponse(e);
    }

    private void OnPublicMessage(BaseEvent e)
    {
        Log.Debug("public message");
    }

    private void OnLogError(BaseEvent e)
    {
        string message = (string)e.Params["message"];
        Log.Error(message);
        PostEventLog.Record(PostEventLog.Defines.SOCKET_ERROR, $"socket error: {message}");
    }

    private void UpdateSmartFoxClient()
    {
        if (m_proxy != null)
        {
            m_proxy.UpdateSmartFoxClient();
        }
        else
        {
            foreach (var p in m_allSelectProxy)
            {
                p.UpdateSmartFoxClient();
            }
        }


    }

    #endregion
    
    
    #region HttpClient
    
    public LoginServerInfo[] ServerList
    {
        get;
        set;
    }

    public LoginServerInfo GetServerInfo(int id)
    {
   
        if (ServerList == null)
        {
            //如果serverList为空，从本地取
            LoginServerInfo logInInfo = new LoginServerInfo();
            logInInfo.id = id;
            logInInfo.ip = GameEntry.Setting.GetString(GameDefines.SettingKeys.SERVER_IP);
            logInInfo.port = GameEntry.Setting.GetInt(GameDefines.SettingKeys.SERVER_PORT);
            logInInfo.zone = GameEntry.Setting.GetString(GameDefines.SettingKeys.SERVER_ZONE);

            return logInInfo;
        }
        for (int i = 0; i < ServerList.Length; i++)
        {
            if (ServerList[i].id == id)
            {
                return ServerList[i];
            }
        }

        return null;
    }

    public string GetServerIdBySharedUser()
    {
        string ret = "";
        string zone = ZoneName;
        if (string.IsNullOrEmpty(zone) || zone.Length < 3)
        {
            return ret;
        }

        ret = zone.Substring(3);

        return ret;
    }

// #if OLD_PACK
//     private static readonly string _onlineGateServer = "http://gsl-ds.metapoint.club";//"http://gsl-aps.readygo.tech";
//     private static readonly string _debugGateServer = "http://10.7.88.142:82";
//     private static readonly string _onlineGateServer_CN = "http://cn-gsl-aps.first.fun/gameservice/getserverlist.php";
// #else
    private static string _onlineGateServer;// = "http://gsl-ds.metapoint.club";//"http://gsl-aps.readygo.tech";//"https://gslds.im30app.com";
    private static readonly string _debugGateServer = "http://10.7.88.182:82";
    private static readonly string _onlineGateServer_CN = "http://cn-gsl-aps.first.fun/gameservice/getserverlist.php";
// #endif

    /// <summary>
    /// 更新当前选中的getServer线路
    /// </summary>
    /// <remarks>getServer线路通过checkVersion跑马后的结果中产生，不再写死</remarks>
    /// <param name="host"></param>
    public void SelectOnlineGateServer(string host)
    {
        _onlineGateServer = host;

        Log.Info($"NetworkManager::SelectOnlineGateServer::host:{host}");
    }

    /// <summary>
    /// 清空当前选中的getServer线路
    /// </summary>
    public void ClearOnlineGateServer()
    {
        _onlineGateServer = null;

        Log.Info($"NetworkManager::ClearOnlineGateServer");
    }
    
        
    public UnityWebRequest GetServerList()
    {
        var formData = new Dictionary<string, string>();
        if (CommonUtils.IsDebug())
        {
            formData.Add("gmFlag", "0");
            string deviceID = GameEntry.Device.GetDeviceUid();
            formData.Add("uuid", deviceID);
            formData.Add("loginFlag", "0");
            formData.Add("country", GameEntry.GlobalData.fromCountry);
            formData.Add("is3D", "1");
            formData.Add("lang", GameEntry.Localization.GetLanguageName());
            formData.Add("simOp", GameEntry.Sdk.GetSimOperator());
            formData.Add("platform", GameUtility.GetPlatformName());
            formData.Add("packageName", GameEntry.Sdk.GetPackageName());
        }
        else
        {
            string deviceID = GameEntry.Device.GetDeviceUid();
            formData.Add("uuid", deviceID);
            formData.Add("loginFlag", "1");
            formData.Add("country", GameEntry.GlobalData.fromCountry);
            formData.Add("is3D", "1");
            formData.Add("lang", GameEntry.Localization.GetLanguageName());
            formData.Add("simOp", GameEntry.Sdk.GetSimOperator());
            formData.Add("platform", GameUtility.GetPlatformName());
            formData.Add("newServer","1");
            formData.Add("packageName", GameEntry.Sdk.GetPackageName());
            // formData.Add("gmFlag", GameEntry.Data.Player.gmFlag.ToString());
        }
        
        var request = UnityWebRequest.Post(ServerListHost + "/gameservice/getserverlist.php", formData);
        request.SendWebRequest();
        var formDataStr = string.Join("&", formData.Select(i => $"{i.Key}={i.Value}"));
        Log.Info("getservlist : {0}_{1}",ServerListHost, formDataStr);
        return request;
    }

    public UnityWebRequest GetServerStatus()
    {
        string deviceID = GameEntry.Device.GetDeviceUid();
        
        var form = new Dictionary<string, string>();
        form.Add("uuid", deviceID);
        form.Add("loginFlag", "1");
        form.Add("country", GameEntry.GlobalData.fromCountry);
        form.Add("lang", GameEntry.Localization.GetLanguageName());
        form.Add("gameuid", Uid);
        form.Add("sid", ZoneName.Length > 3 ? ZoneName.Substring(3) : "");
        form.Add("serverIp", GameServerUrl);
        
        var request = UnityWebRequest.Post(ServerListHost + "/gameservice/probe.php", form);
        request.SendWebRequest();
        return request;
    }
    
    private string ServerListHost
    {
        get
        {
            if (CommonUtils.IsDebug())
            {
                return _debugGateServer;
            }
            var packageName  = GameEntry.Sdk.GetPackageName();
            if (packageName.EndsWith("cn"))
            {
                return _onlineGateServer_CN;
            }
            return _onlineGateServer;
        }
    }
    
#endregion
}

[System.Serializable]
public class LoginServerInfo
{
    public int id;
    public string name;
    public string ip;
    public int inner_port;
    public int port;
    public string zone;
    public bool cnserver;
    public int server_type;
    public string gameUid;
    public string uuid;
    public string uid;

    public bool merge;
    public bool cnToOther;
    public long daoliang_time;
    public string ptype;
}

[System.Serializable]
public class LoginServerListRespon
{
    public int code;
    public LoginServerInfo[] serverList;
    public int country;
    public string tcp;
    public string newDesertFlag;
    public int lastLoggedServer;

    public bool UseMQTT;
    public string MQTTIP;
    public int MQTTPort;
    public bool uploadLog;
    public string NetType;

    public LoginServerInfo GetLastLoggedServerInfo()
    {
        if (lastLoggedServer != 0)
        {
            for (int i = 0; i < serverList.Length; ++i)
            {
                if (serverList[i].id == lastLoggedServer)
                {
                    return serverList[i];
                }
            }
        }

        return null;
    }
}

[System.Serializable]
public class ServerStatusRespon
{
    public int code;
    public int cokerrcode;
    public string message;
    public int time;
}