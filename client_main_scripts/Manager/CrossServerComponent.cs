/*-----------------------------------------------------------------------------------------
// FileName：CrossServerComponent.cs
// Author：wangweiying
// Date：2019.1.31
// Description：跨服链接
//-----------------------------------------------------------------------------------------*/
using System.Collections.Generic;
using GameFramework;
using UnityGameFramework.Runtime;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using System;
using System.Linq;
using UnityEngine;
using XLua;

public class CrossServerComponent
{
    public class TagServerInfo
    {
        public string ip;
        public int port;
        public bool isProxy;
    }

    public string IP { get; set; }
    public int Port { get; set; }
    public string Zone { get; set; }

    private SmartFox m_Client;
    private float waitReConnectTime;
    private int mConnectCount;
    private bool mIsConnecting;             // 是否正在连接中。。。。
    private List<TagServerInfo> mConnectCadidateList = new List<TagServerInfo>();
    // 准备发送的消息队列
    private List<BaseMessage> mRequestPending = new List<BaseMessage>();
    // 已经发送的消息队列
    private List<BaseMessage> mRequestSended = new List<BaseMessage>();
    // 特殊的消息队列，主要存储了world.get.cross消息。
    // 原因：在跨服期间，断开重连后触发login链接成功，重新请求一个当前地图的信息
    private List<BaseMessage> mSpecialCommand = new List<BaseMessage>();

    public const int SERVER_PORT = 9933;
    public const string SERVER_ZONE = "APS1";
    public const int SERVER_SCOKET_PORT = 8088;
    public const int SERVER_SCOKET_PORT_80 = 80;

    public bool Logined { get; set; }

    public CrossServerComponent()
    {
        InitSmartFox();
    }
    //protected override void Awake()
    //{
    //    base.Awake();
    //    m_Client = new SmartFox();
    //    m_Client.ThreadSafeMode = true;
    //    m_Client.AddEventListener(SFSEvent.CONNECTION, OnConnected);
    //    m_Client.AddEventListener(SFSEvent.CONNECTION_LOST, OnDisconnect);
    //    m_Client.AddEventListener(SFSEvent.EXTENSION_RESPONSE, OnExtensionResponse);
    //    m_Client.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
    //    m_Client.AddEventListener(SFSEvent.LOGIN, OnLogin);
    //    m_Client.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);
    //    m_Client.AddEventListener(SFSEvent.LOGOUT, OnLogout);
    //}
    private void InitSmartFox()
    {
        m_Client = new SmartFox();
        m_Client.ThreadSafeMode = true;
        m_Client.AddEventListener(SFSEvent.CONNECTION, OnConnected);
        m_Client.AddEventListener(SFSEvent.CONNECTION_LOST, OnDisconnect);
        m_Client.AddEventListener(SFSEvent.EXTENSION_RESPONSE, OnExtensionResponse);
        m_Client.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
        m_Client.AddEventListener(SFSEvent.LOGIN, OnLogin);
        m_Client.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);
        m_Client.AddEventListener(SFSEvent.LOGOUT, OnLogout);
    }
    public bool IsConnected()
    {
        return m_Client.IsConnected;
    }

    public void Disconnect()
    {
        if (m_Client != null)
        {
            m_Client.RemoveAllEventListeners();
            m_Client.Disconnect();
            m_Client = null;
        }
    }

    public void RemoveConnect()
    {
        Logined = false;
        Disconnect();
        ClearRequestQueue();
    }
    public void ClearRequestQueue()
    {
        mRequestPending.Clear();
    }

    public void ClearSpecialCommand()
    {
        mSpecialCommand.Clear();
    }
    public void AddSpecialCommand(BaseMessage request)
    {
        if (null != request) mSpecialCommand.Add(request);
    }

    public void InitConnectionList()
    {
        mConnectCadidateList.Clear();
        //组装直连线路
        TagServerInfo si = new TagServerInfo();
        si.port = SERVER_PORT;
        mConnectCadidateList.Add(si);

        si = new TagServerInfo();
        si.port = SERVER_SCOKET_PORT;
        mConnectCadidateList.Add(si);

        si = new TagServerInfo();
        si.port = SERVER_SCOKET_PORT_80;
        mConnectCadidateList.Add(si);

        mConnectCount = 0;
    }

    //private void OnDestroy()
    //{
    //    m_Client.Disconnect();
    //}
    private float repeatRate = .5f;
    private float deltaTime = 1;
    private float reconnectTime = 3;
    public void OnUpdate(float elapseSeconds)
    {
        if (m_Client == null)
        {
            return;
        }
        if (SendPendRequest)
        {
            deltaTime += Time.deltaTime;
                   
            if (deltaTime > repeatRate)
            {
                onSendPendRequest();
                deltaTime = 0;
            }
        }

        if (m_Client.IsConnected == false)
        {
            waitReConnectTime+=Time.deltaTime;
            if (waitReConnectTime >= reconnectTime)
            {
                waitReConnectTime = 0;
                mIsConnecting = false;
            }
        }
        
        m_Client.ProcessEvents();
    }
    
    public void DoConnect()
    {
        if (!PrepareIpAndPort())
        {
            return;
        }
        Logined = false;
        Disconnect();
        ClearRequestQueue();
        if (m_Client == null)
        {
            InitSmartFox();
        }
        waitReConnectTime = 0;
        mIsConnecting = true;

        m_Client.Connect(IP, Port);
    }

    public void Send(IRequest request)
    {
        if (m_Client != null)
        {
            m_Client.Send(request);
        }
        
    }

    public void Send(BaseMessage request)
    {
        if (m_Client == null)
        {
            mRequestPending.Add(request);
            DoConnect();
            return;
        }
        if (!m_Client.IsConnected && !mIsConnecting)
        {
            mRequestPending.Add(request);
            DoConnect();
        }
        else if (!Logined && request.GetMsgId() != "login" && request.GetMsgId() != "login.init")
        {
            mRequestPending.Add(request);
        }
        else
        {
            request.Send();
            mRequestSended.Add(request);
        }
    }

    private bool PrepareIpAndPort()
    {

        // if (mConnectCadidateList.Count <= 0)
        // {
        //     return false;
        // }
        //
        // TagServerInfo si = mConnectCadidateList[mConnectCount % mConnectCadidateList.Count];
        //
        // if (!si.isProxy)
        // {
            int strSid = GameEntry.Data.Player.GetCrossServerId();
            var luaData =  GameEntry.Lua.CallWithReturn<LuaTable, int>("CSharpCallLuaInterface.GetTargetServerIdAndPort", strSid);
            if (luaData != null)
            {
                if (luaData.ContainsKey("ip") && luaData.ContainsKey("port"))
                {
                    IP = luaData.Get<string>("ip");
                    Port = luaData.Get<int>("port");
                }
            }
            return true;
    }

    private void OnConnected(BaseEvent e)
    {
        mIsConnecting = false;
        waitReConnectTime = 0;
        foreach(var iter in mRequestPending)
        {
            if (iter.GetMsgId() == "login")
            {
                // 直接发送消息
                Send(iter);

                mRequestPending.Remove(iter);
                return;
            }
        }

        {
            // 添加一个登陆消息
            LoginCrossServerMessage logincross = new LoginCrossServerMessage();
            logincross.SendRequest();
        }
    }

    private void OnDisconnect(BaseEvent e)
    {
        //Log.Error("connect lost");
        //UIUtils.ShowMessage(GameEntry.Localization.GetString("120085"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, UIUtils.onReloadGame);
    }

    private void OnLogin(BaseEvent e)
    {
        var so = e.Params["data"] as SFSObject;

        foreach (BaseMessage m in mRequestSended)
        {
            if ("login" == m.GetMsgId())
            {
                m.Handle(so);

                mRequestSended.Remove(m);

                break;
            }
        }

        if (mRequestPending.Count == 0)
        {
            if (mSpecialCommand.Count > 0)
            {
                mSpecialCommand.ForEach((BaseMessage message)=>{
                    mRequestPending.Add(message);
                });

                mSpecialCommand.Clear();
            }
        }

        if (mRequestPending.Count > 0)
        {
            SendPendRequest = true;
            //InvokeRepeating("onSendPendRequest", 0, 0.5f);
        }

        Logined = true;
    }

    private bool SendPendRequest = false;
    
    void onSendPendRequest()
    {
        if (m_Client.IsConnected && mRequestPending.Count > 0)
        {
            var message = mRequestPending[0];
            if (null != message)
            {
                message.Send();

                mRequestSended.Add(message);
                mRequestPending.Remove(message);
                return;
            }
        }
        SendPendRequest = false;
        deltaTime = 1;
        //CancelInvoke("onSendPendRequest");
    }

    private void OnLoginError(BaseEvent e)
    {
        string error = (string)e.Params["errorMessage"];
        Log.Error("Login error: {0}", error);
        Logined = false;
        //UIUtils.ShowMessage(GameEntry.Localization.GetString(error), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, UIUtils.onReloadGame);
    }

    private void OnLogout(BaseEvent e)
    {
        Log.Error("Logout CrossServer");
        Logined = false;
    }

    private void OnExtensionResponse(BaseEvent e)
    {
        string cmd = (string)e.Params["cmd"];
        var so = e.Params["params"] as SFSObject;

        if (null != so)
        {
            so.PutUtfString("IsFromCrossObserver", "1");
        }

        if (CommonUtils.IsDebug())
        {
            var s = so.ToJson();
            Log.Warning(string.Format("<color=green>cross extension res <{0}> |</color> {1}", cmd, s));
        }

        foreach(BaseMessage m in mRequestSended)
        {
            if (cmd == m.GetMsgId())
            {
                m.Handle(so);

                mRequestSended.Remove(m);

                return;
            }
        }

        MessageFactory.Instance.DispatchResponse(e);
    }

    private void OnPublicMessage(BaseEvent e)
    {
        Log.Warning("public message");
    }

    // 获取真实的端口
    int GetRealPort(bool isProxy)
    {
        //if (isChina())
        //{
        //    if (isProxy)
        //    {
        //        int addNum = 1;
        //        if (m_port == 80)
        //        {
        //            addNum = 1;
        //        }
        //        else if (m_port == 8080)
        //        {
        //            addNum = 2;
        //        }
        //        else if (m_port == 9933)
        //        {
        //            addNum = 3;
        //        }
        //        int serverId = 1;
        //        if (m_zone != "")
        //        {
        //            std::string subStr = m_zone.substr(3);
        //            serverId = atoi(subStr.c_str());
        //        }
        //        int ipConfig0 = 3999;
        //        int ipConfig1 = 8000;
        //        int ipConfig2 = 900000;
        //        int port = (1000 + serverId) * 10 + addNum;
        //        if (serverId <= ipConfig0)
        //        {

        //        }
        //        else if (serverId >= ipConfig1 && serverId < ipConfig2)
        //        {
        //            port = (5000 + (serverId - 8000)) * 10 + addNum;
        //        }
        //        else if (serverId >= ipConfig2)
        //        {
        //            port = (6000 + (serverId - 900000)) * 10 + addNum;
        //        }
        //        return port;
        //    }
        //    else
        //    {
        //        return getPort();
        //    }
        //}
        return Port;
    }
}
