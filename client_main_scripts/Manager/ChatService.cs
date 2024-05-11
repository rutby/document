using System;
using System.Collections.Generic;
using System.IO;
using BestHTTP.WebSocket;
using GameKit.Base;
using UnityEngine;
using UnityEngine.Networking;
using GameFramework;


// 需要独立出来一个WebSocket，每次连接的时候new一个新的，
// 因为你有callback到Lua层，所以有可能收到旧链接的消息
public class WebSocketItem
{
    struct MsgItem
    {
        public MsgItem(string _k, string _v)
        {
            k = _k;
            v = _v;
        }
        public string k;
        public string v;
    }
    
    // 回调函数处理
    private Action<string, string, int> callback_;
    
    private WebSocket socket;
    
    // 线程数据同步队列
    private object locker = new object();
    private Queue<MsgItem> msgQueue = new Queue<MsgItem>();
    private int msgItemNo = 0;
    
    // 上一次ping的事件
    private float last_ping_time_ = 0; 

    private string CalcSign(string appId, string uid, long time)
    {
        return StringUtils.GetMD5(StringUtils.GetMD5(appId + uid) + time.ToString());
    }
    
    // 设置callback
    public void SetCallBack(Action<string, string, int> cb)
    {
        callback_ = cb;
    }
    
    // 是否活动中
    public bool IsOpen()
    {
        if (socket != null && socket.IsOpen)
        {
            return true;
        }
        
        return false;
    }
    
    // 连接到指定聊天服务器
    public bool Connect(string APP_ID, string protocol, string ip, int port)
    {
        long time = GameEntry.Timer.GetServerTime();
        string uid = GameEntry.Data.Player.Uid;
        string sign = CalcSign(APP_ID, uid, time);

        string url = string.Format("{0}://{1}:{2}", protocol, ip, port);
#if UNITY_EDITOR
        Log.Info("[{1}({2})]Connect: {0}", url, System.Diagnostics.Process.GetCurrentProcess().ProcessName,
            System.Diagnostics.Process.GetCurrentProcess().Id);
#endif
        socket = new WebSocket(new System.Uri(url))
        {
            StartPingThread = true
        };
        
        socket.PingFrequency = 3000;
        socket.CloseAfterNoMesssage = TimeSpan.FromSeconds(25);
        
        socket.InternalRequest.SetHeader("APPID", APP_ID);
        socket.InternalRequest.SetHeader("TIME", time.ToString());
        socket.InternalRequest.SetHeader("UID", uid);
        socket.InternalRequest.SetHeader("SIGN", sign);

        socket.OnOpen += Socket_OnOpen;
        socket.OnMessage += Socket_OnMessage;
        socket.OnBinary += Socket_OnBinary;
        socket.OnClosed += Socket_OnClosed;
        socket.OnError += Socket_OnError;
        // socket.OnErrorDesc += Socket_OnErrorDesc;
        socket.OnIncompleteFrame += Socket_OnIncompleteFrame;

        socket.Open();

        last_ping_time_ = Time.realtimeSinceStartup;
        return true;
    }

    public void Send(string json)
    {
        if (socket != null)
        {
            // 底层会自己判断isOpen
            socket.Send(json);
        }
    }
    
    // 处理线程消息
    public void Process()
    {
        try
        {
            // 超过60秒就算断线了
            // if (Time.realtimeSinceStartup - last_ping_time_ >= 60)
            // {
            //     int a = 0;
            //     Log.Error("ping time out!!!");
            // }
            
            lock (locker)
            {
                while (msgQueue.Count > 0)
                {
                    MsgItem msg = msgQueue.Dequeue();
                    ++msgItemNo;
                    
                    if (callback_ != null)
                    {
                        callback_(msg.k, msg.v, msgItemNo);
                    }
                }
            }
        }
        catch (Exception e)
        {
            Log.Error($"ChatService Process exception!! \n {e.ToString()}");
        }
    }

    public void Close()
    {
        if (socket != null)
            socket.Close();
    }

    //////////////////////////////////////////////////////////////////////////////////////
    /// WebSocket 相关回调信息
    //////////////////////////////////////////////////////////////////////////////////////
    void Socket_OnOpen(WebSocket webSocket)
    {
        Log.Debug("Web Socket On Open");

        lock (locker)
        {
            msgQueue.Enqueue(new MsgItem("onOpen", ""));
        }
    }

    void Socket_OnMessage(WebSocket webSocket, string message)
    {
#if UNITY_EDITOR
        Log.Info("[{1}({2})]Socket_OnMessage: {0}", message, System.Diagnostics.Process.GetCurrentProcess().ProcessName,
            System.Diagnostics.Process.GetCurrentProcess().Id);
#endif
        if (message.Equals("heartbeat"))
        {
            last_ping_time_ = Time.realtimeSinceStartup;
            return;
        }

        try
        {
            lock (locker)
            {
                msgQueue.Enqueue(new MsgItem("onMessage", message));
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);
        }
    }

    void Socket_OnBinary(WebSocket webSocket, byte[] data)
    {
        Log.Debug("Socket_OnBinary: {0}", data.Length);
    }

    void Socket_OnClosed(WebSocket webSocket, ushort code, string message)
    {
        Log.Debug("Socket_OnClosed: {0}", message);

        lock (locker)
        {
            msgQueue.Enqueue(new MsgItem("onClose", message));
        }
    }

    void Socket_OnError(WebSocket webSocket, System.Exception ex)
    {
        if (ex != null)
            Log.Error("{0}, {1}", webSocket.InternalRequest.Uri, ex);

        if (webSocket != null && webSocket.IsOpen)
        {
            webSocket.OnOpen -= Socket_OnOpen;
            webSocket.OnMessage -= Socket_OnMessage;
            webSocket.OnBinary -= Socket_OnBinary;
            webSocket.OnClosed -= Socket_OnClosed;
            webSocket.OnError -= Socket_OnError;
            // webSocket.OnErrorDesc -= Socket_OnErrorDesc;
            webSocket.OnIncompleteFrame -= Socket_OnIncompleteFrame;
            webSocket.Close();
        }
        
        lock (locker)
        {
            msgQueue.Enqueue(new MsgItem("onError", (ex != null) ? ex.Message : ""));
        }
    }
    
    //
    // void Socket_OnErrorDesc(WebSocket webSocket, string reason)
    // {
    //     Log.Error(reason);
    // }

    void Socket_OnIncompleteFrame(WebSocket webSocket, BestHTTP.WebSocket.Frames.WebSocketFrameReader frame)
    {
        Log.Debug(frame.DataAsText);
    }
}


public class ChatService
{
    private static ChatService _instance;
    private static readonly object _lock = new object();

    private int WSItemCount = 0;

    // 当前正在激活的websocket
    private WebSocketItem curWebSocket;

    // 聊天系统的APP_ID
    private string CHAT_APP_ID = "100013";
    private Action<string, string, int> callback_;

    // 当前的用户uid
    private string cur_player_uid_;

    private ChatService()
    {
    }

    public static ChatService Instance
    {
        get
        {
            // Double-Checked Locking
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new ChatService();
                    }
                }
            }

            return _instance;
        }
    }

    // 初始化聊天系统
    public void Init(string chat_app_id, string playerUid, Action<string, string, int> callback)
    {
        Uninit();

        callback_ = callback;
        cur_player_uid_ = playerUid;
        CHAT_APP_ID = chat_app_id;
    }
    
    public void Uninit()
    {
        Disconnect();
        callback_ = null;
    }

    // 初始化聊天系统
    public bool RequestServerList(string url, int ud)
    {
        // 没有的话不让初始化
        if (callback_ == null || cur_player_uid_.IsNullOrEmpty())
        {
            return false;
        }

        string timeStr = GameEntry.Timer.GetServerTimeSeconds().ToString();
        string secret = StringUtils.GetMD5(StringUtils.GetMD5(timeStr.Substring(0, 3)) +
                                           StringUtils.GetMD5(timeStr.Substring(timeStr.Length - 3, 3)));
        string sign = StringUtils.GetMD5(CHAT_APP_ID + cur_player_uid_ + secret);

        WWWForm form = new WWWForm();
        form.AddField("t", timeStr);
        form.AddField("s", sign);
        form.AddField("a", CHAT_APP_ID);
        form.AddField("u", cur_player_uid_);

        if (GameEntry.GlobalData.isChina())
        {
            form.AddField("f", "cn");
        }

        WebRequestManager.Instance.Post(url, form,
            (UnityWebRequest request, bool hasErr, object userdata) =>
            {
                // 如果还没有结束的话，就不处理
                if (request.isDone == false)
                {
                    return;
                }

                if (!hasErr)
                {
                    string serverlistJson = request.downloadHandler.text;
                    callback_("onRequest", serverlistJson, (int) userdata);
                }
                else
                {
                    // 连接失败，1秒后重连
                    callback_("onRequest", "", (int) userdata);
                }
            },
            (int) ThreadPriority.Normal, 10, (object) ud);

        return true;
    }

    // 连接到指定聊天服务器
    public bool Connect(string protocol, string ip, int port)
    {
        Disconnect();

        ++WSItemCount;
        curWebSocket = new WebSocketItem();
        curWebSocket.SetCallBack(callback_);
        curWebSocket.Connect(CHAT_APP_ID, protocol, ip, port);

        return true;
    }

    public void Disconnect()
    {
        if (curWebSocket != null)
        {
            curWebSocket.SetCallBack(null);
            curWebSocket.Close();
        }
    }

    public bool IsConnected()
    {
        if (curWebSocket != null && curWebSocket.IsOpen())
            return true;
        return false;
    }

    // 主动处理
    public void OnUpdate()
    {
        if (curWebSocket != null)
        {
            curWebSocket.Process();
        }
    }

    //lua 调用接口
    public void SendLuaMessage(string jsonMsg)
    {
        // Log.Warning("SendLuaMessage" + jsonMsg);
        if (curWebSocket != null)
        {
            curWebSocket.Send(jsonMsg);
        }
    }

    // 翻译请求
    public void RequestTranslate(string uri, string postParams, Action<string, string> cb)
    {
        // 每一个post请求对应一个cb吧，不用公共的了
        if (cb == null)
        {
            Log.Error("RequestTranslate no callback??? error!!");
            return;
        }
        
        WebRequestManager.Instance.Post(uri, postParams,
            (UnityWebRequest request, bool hasErr, object userdata) =>
            {
                if (request.isDone == false)
                {
                    return;
                }
                
                bool b = true;
                if (hasErr)
                {
                    b = false;
                }
                
                string retdata = request.downloadHandler.text;
                cb(b ? "true" : "false", retdata);
                
            });
    }
    
    // 翻译请求
    public void RequestTranslate(string uri, Dictionary<string, string> postParams, Action<string, string> cb)
    {
        // 每一个post请求对应一个cb吧，不用公共的了
        if (cb == null)
        {
            Log.Error("RequestTranslate no callback??? error!!");
            return;
        }
        
        string sc, sf, tf, ch, ui, scene, uid, tk;
        postParams.TryGetValue("sc", out sc);
        postParams.TryGetValue("sf", out sf);
        postParams.TryGetValue("tf", out tf);
        postParams.TryGetValue("ch", out ch);
        postParams.TryGetValue("ui", out ui);
        postParams.TryGetValue("uid", out uid);
        postParams.TryGetValue("tk", out tk);

        if (string.IsNullOrEmpty(sc) ||
            string.IsNullOrEmpty(ui) ||
            string.IsNullOrEmpty(ch) ||
            string.IsNullOrEmpty(uid))
        {
            Log.Error("RequestTranslate param error!!");
            return;
        }
            
        // 这里要对时间和参数做一个sig加密
        long time = GameEntry.Timer.GetServerTime();
        string full_md5_string = string.Format("{0}{1}{2}{3}{4}{5}", sf, tf, ch, time, tk, uid);
        string md5 = AESHelper.GetMd5Hash(full_md5_string);

        WWWForm form = new WWWForm();
        form.AddField("sc", sc);
        form.AddField("sf", sf);
        form.AddField("tf", tf);
        form.AddField("ch", ch);
        form.AddField("ui", ui);
        form.AddField("scene", ch);
        form.AddField("uid", uid);
        form.AddField("tk", tk);
        ////////////////////////
        form.AddField("t", time.ToString());
        form.AddField("sig", md5);
        
        WebRequestManager.Instance.Post(uri, form,
            (UnityWebRequest request, bool hasErr, object userdata) =>
            {
                if (request.isDone == false)
                {
                    return;
                }
                
                bool b = true;
                if (hasErr)
                {
                    b = false;
                }
                
                string retdata = request.downloadHandler.text;
                cb(b ? "true" : "false", retdata);
                
            });
    }

}