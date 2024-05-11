using System;
using System.Buffers;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using UnityEngine;
using GameFramework;
using UnityGameFramework.Runtime;

public static class PostEventLog
{
    public static class Defines
    {
        public const string LAUNCH = "LAUNCH";
        public const string OBB_FETCH = "OBB_FETCH";
        public const string OBB_SUCCESS = "OBB_SUCCESS";

        public const string CHECK_VERSION_START = "CHECK_VERSION_START";
        public const string CHECK_VERSION_SUCCESS = "CHECK_VERSION_SUCCESS";
        public const string CHECK_VERSION_FAILED = "CHECK_VERSION_FAILED";
        public const string CHECK_VERSION_TIMEOUT = "CHECK_VERSION_TIMEOUT";
        public const string CHECK_VERSION_ONUPDATE = "CHECK_VERSION_ONUPDATE";

        public const string DOWNLOAD_MANIFEST_START = "DOWNLOAD_MANIFEST_START";
        public const string DOWNLOAD_MANIFEST_SUCCESS = "DOWNLOAD_MANIFEST_SUCCESS";
        public const string DOWNLOAD_MANIFEST_FAILED = "DOWNLOAD_MANIFEST_FAILED";
        public const string DOWNLOAD_MANIFEST_TIMEOUT = "DOWNLOAD_MANIFEST_TIMEOUT";
        
        public const string DOWNLOAD_START = "DOWNLOAD_START";
        public const string DOWNLOAD_FINISH = "DOWNLOAD_FINISH";
        public const string DOWNLOAD_FAILED = "DOWNLOAD_FAILED";
        
        public const string START_CONNECT = "START_CONNECT";
        public const string CONNECT_TIME_OUT = "CONNECT_TIME_OUT";
        public const string GET_SERVERLIST = "GET_SERVERLIST";
        public const string SERVERLIST_TIME_OUT = "SERVERLIST_TIME_OUT";
        public const string SERVERLIST_FAILED = "SERVERLIST_FAILED";
        public const string LONG_TIME_NOT_PUSH_INIT = "LONG_TIME_NOT_PUSH_INIT";

        public const string LOGIN_START = "LOGIN_START";
        public const string LOGIN_FINISH = "LOGIN_FINISH";
        public const string LOGIN_COMPLETE = "LOGIN_COMPLETE";
        public const string LOGIN_FAILED = "LOGIN_FAILED";
        public const string SERVER_STATUS = "SERVER_STATUS";
        public const string PUSH_INIT_RECV = "PUSH_INIT_RECV";
        public const string LOGIN_PARSE_ERROR = "LOGIN_PARSE_ERROR";
        public const string DISCONNECT_RETRY = "DISCONNECT_RETRY";
        public const string SOCKET_ERROR = "SOCKET_ERROR";
        public const string DNS_SUCESS = "DNS_SUCESS";
        public const string SOCKET_SHUTDOWN = "SOCKET_SHUTDOWN";
        public const string APP_QUIT = "APP_QUIT";
    }
  
    // 参数及字典缓存优化
    private static string[] pN = new string[] { "param0", "param1", "param2", "param3" };
    private static Dictionary<string, string> pairs = new Dictionary<string, string>();
    private static StringBuilder sb = new StringBuilder();

    private static PostEventThread postEventThread = new PostEventThread();
    public static bool hasInit = false;
    private static Dictionary<string, int> actionCountMap = new Dictionary<string, int>();

    private static long posteventId = 0;
    // public const string POSTURL = "http://apilast.im30app.com/gameservice/opengames_lf.php";
    // public const string POSTURL_CN = "http://apilast.im30app.com/gameservice/opengames_lf.php";
    public const string POSTURL = "http://analyse-ds.metapoint.club/clientevent.php";
    public const string POSTURL_CN = "";
    
    // 每种错误只报一遍吧，按照堆栈处理
    private static Dictionary<string, string> exceptionDict = new Dictionary<string, string>();

    private static int getActionCount(string action){
        if (actionCountMap.ContainsKey(action)){
            actionCountMap[action] += 1;
        } else {
            actionCountMap[action] = 1;
        }
        return actionCountMap[action];
    }

    public static void init(){
        if (!hasInit)
        {
            postEventThread.Start();
            // 第一次稍微等一下
            Thread.Sleep(10);
            hasInit = true;
            posteventId = DateTimeOffset.Now.ToUnixTimeMilliseconds();
        }
    }

    public static void stop()
    {
        if (hasInit)
        {
            postEventThread.Stop();
            hasInit = false;
        }
    }

    // 直接发送表单数据
    public static void PostException(string action, string logString, string longText)
    {
        // 每个堆栈只上传一次吧，否则出错之后狂上传也不好。
        string outText;
        if (exceptionDict.TryGetValue(longText, out outText))
        {
            Log.Info("PostException but duplicate!!!");
#if FINAL_RELEASE
            return;
#endif
        }
        exceptionDict[longText] = logString;

        init();

        pairs.Clear();


        var arPool = ArrayPool<byte>.Shared;

        {
            byte[] buf = arPool.Rent(longText.Length * 3);
            try
            {
                int len = System.Text.Encoding.UTF8.GetBytes(longText, 0, longText.Length, buf, 0);
                string base64 = System.Convert.ToBase64String(buf, 0, len);
                pairs.Add("form", base64);
            }
            finally
            {
                arPool.Return(buf);
            }
        }

        {
            byte[] buf = arPool.Rent(logString.Length * 3);
            try
            {
                int len = System.Text.Encoding.UTF8.GetBytes(logString, 0, logString.Length, buf, 0);
                string base64 = System.Convert.ToBase64String(buf, 0, len);
                pairs.Add("keylog", base64);
            }
            finally
            {
                arPool.Return(buf);
            }
        }

        Record(action, pairs);
    }

    // 发送打点数据
    public static void Record(string action)
    {
        if (CommonUtils.IsDebug())
            return;
        
        init();

        pairs.Clear();
        Record(action, pairs);
    }

    // 发送打点数据
    public static void Record(string action, string param1)
    {
        if (CommonUtils.IsDebug())
            return;
        
        init();

        pairs.Clear();
        pairs.Add(pN[0], param1);

        Record(action, pairs);
    }

    // 发送打点数据
    public static void Record(string action, string param1, string param2)
    {
        if (CommonUtils.IsDebug())
            return;
        
        init();

        pairs.Clear();
        pairs.Add(pN[0], param1);
        pairs.Add(pN[1], param2);

        Record(action, pairs);
    }

    // 发送打点数据
    public static void Record(string action, params string[] args)
    {
        if (CommonUtils.IsDebug())
            return;
        
        init();

        pairs.Clear();

        // 0~3使用快速优化处理
        int c = Math.Min(args.Length, pN.Length);
        for (int i=0;i<c;++i)
        {
            pairs.Add(pN[i], args[i]);
        }
        for (int i=c;i<args.Length;++i)
        {
            pairs.Add("param" + i, args[i]);
        }

        Record(action, pairs);
    }

    // 发送打点数据，携带一个参数数组
    private static void Record(string action, Dictionary<string, string> dictionary = null)
    {
        var setting = GameEntry.Setting;
        var device = GameEntry.Device;
        var globalData = GameEntry.GlobalData;
        try
        {
            // 格式化具体的值
            sb.Clear();

            sb.Append("&action=").Append(action);

            sb.AppendFormat("&actioncount={0}", getActionCount(action));
            sb.AppendFormat("&timestamp={0}", DateTimeOffset.Now.ToUnixTimeMilliseconds());

            sb.Append("&uid=").Append(setting.GetPublicString(GameDefines.SettingKeys.GAME_UID, "\"\""));
            sb.Append("&zone=").Append(setting.GetPublicString(GameDefines.SettingKeys.SERVER_ZONE, "\"\""));

            sb.Append("&deviceId=").Append(device.GetDeviceUid());
            sb.Append("&country=").Append(globalData.fromCountry);
            sb.Append("&version=").Append(GameEntry.Sdk.Version);
            sb.Append("&buildcode=").Append(GameEntry.Sdk.VersionCode);
            sb.Append("&platform=")
                .Append(string.IsNullOrEmpty(globalData.analyticID) ? "\"\"" : globalData.analyticID);
            sb.Append("&posteventId=").Append(posteventId);
            sb.Append("&net=").Append(GameEntry.Device.GetNetworkTypeDesc());
            sb.Append("&line=").Append(GameEntry.Network.getCurLine());

            if (dictionary != null)
            {
                foreach (var p in dictionary)
                {
                    string k = p.Key;
                    string v = p.Value;
                    sb.Append("&").Append(k).Append("=").Append(string.IsNullOrEmpty(v) ? "\"\"" : v);
                }
            }

            postEventThread.AddTask(new PostEventThreadTask(sb.ToString()));
        }
        catch (Exception e)
        {
            Log.Error("record log {0} error", action);
        }

#if UNITY_EDITOR
        //GameFramework.Log.Info("[PostEventLog]{0}?{1}", uri, param);
#endif

    }

}

class PostEventThreadTask
{
    private object requestLock = new object();
    private WebRequest webrequest;
    private ManualResetEvent allDone;
    private byte[] content;
    private int contentLen;
    private string uri;
    public string param;
    
    public PostEventThreadTask(string para)
    {
        param = para;
        allDone = new ManualResetEvent(false);
        webrequest = null;
    }

    public void Abort()
    {
        try
        {
            lock (requestLock)
            {
                if (webrequest != null)
                {
                    webrequest.Abort();
                    webrequest = null;
                }
            }
        }
        catch (Exception e)
        {
            Log.Info("Abort excep " + e.Message);
        }
        finally
        {
            allDone.Set();
        }
    }

    public void BeginProcess(byte[] buffer)
    {
        try
        {
            if (string.IsNullOrEmpty(param))
            {
                allDone.Set();
                return;
            }
            
            content = buffer;
            contentLen = Encoding.UTF8.GetBytes(param, 0, param.Length, content, 0);
            
            uri = PostEventLog.POSTURL;

            var request = WebRequest.Create(uri);
            request.Timeout = 10000;
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = contentLen;
            request.BeginGetRequestStream(GetRequestStreamCallback, this);
                
            lock (requestLock)
            {
                webrequest = request;
            }
        }
        catch (Exception e)
        {
            allDone.Set();
            Log.Info("Process excep " + e.Message);
        }
    }

    public void WaitProcessDone()
    {
        try
        {
            allDone.WaitOne();
        }
        catch (Exception e)
        {
            Log.Debug("WaitProcessDone excep " + e.Message);            
        }
    }

    private static void GetRequestStreamCallback(IAsyncResult asynchronousResult)
    {
        //Log.Debug("GetRequestStreamCallback");
        WebRequest request;
        Stream postStream = null;
        PostEventThreadTask task = null;
        try
        {
            task = (PostEventThreadTask) asynchronousResult.AsyncState;

            lock (task.requestLock)
            {
                request = task.webrequest;
            }
            postStream = request.EndGetRequestStream(asynchronousResult);
            postStream.Write(task.content, 0, task.contentLen);
            postStream.Flush();
            
            request.BeginGetResponse(GetResponseCallback, task);
        }
        catch (Exception e)
        {
            if (task != null)
            {
                task.allDone.Set();
            }
            //Log.Info("GetRequestStreamCallback excep " + e.Message);
        }
        finally
        {
            if (postStream != null)
            {
                postStream.Close();
            }
            //Log.Debug("GetRequestStreamCallback finally");
        }
    }

    private static void GetResponseCallback(IAsyncResult asynchronousResult)
    {
        //Log.Debug("GetResponseCallback");
        WebRequest request;
        WebResponse response = null;
        PostEventThreadTask task = null;
        try
        {
            task = (PostEventThreadTask) asynchronousResult.AsyncState;
            
            lock (task.requestLock)
            {
                request = task.webrequest;
            }
            response = request.EndGetResponse(asynchronousResult);
            //using (var respStream = response.GetResponseStream())
            //using (StreamReader reader = new StreamReader(respStream))
            //{
            //    Log.Debug("GetResponseStream " + reader.ReadToEnd());
            //}
        }
        catch (Exception e)
        {
            //Log.Info("GetResponseCallback excep " + e.Message);
        }
        finally
        {
            if (response != null)
            {
                response.Close();
            }
            Log.Debug("[>>>>>>> PostEventLog]{0}?{1}", task.uri, task.param);
            task.allDone.Set();
        }
    }
}


// 后台发送线程
class PostEventThread
{
    private Thread thread;
    private AutoResetEvent wakeupEvent = new AutoResetEvent(false);
    private volatile bool stop;
    private Queue<PostEventThreadTask> tasks = new Queue<PostEventThreadTask>(10);
    private volatile PostEventThreadTask currentTask;

    // 这个buffer主要用来防止GC
    private byte[] buffer = new byte[8192*2];

    public void Start()
    {
        stop = false;
        thread = new Thread(ThreadProc);
        thread.Name = "PostEventThread";
        thread.Start();
    }

    public void Stop()
    {
        try
        {
            stop = true;
            Wakeup();

            if (currentTask != null)
            {
                currentTask.Abort();
            }

            if (thread != null)
            {
                thread.Join();
                thread = null;
            }
            tasks.Clear();
        }
        catch (Exception e)
        {
            Log.Error("Stop exception " + e.Message);
        }
    }

    public void AddTask(PostEventThreadTask task)
    {
        lock (tasks)
        {
            tasks.Enqueue(task);
        }

        Wakeup();
    }

    private void Sleep()
    {
        wakeupEvent.WaitOne();
    }

    private void Wakeup()
    {
        wakeupEvent.Set();
    }

    private void ThreadProc()
    {
        while (!stop)
        {
            currentTask = null;
            
            lock (tasks)
            {
                if (tasks.Count > 0)
                {
                    currentTask = tasks.Dequeue();
                }
            }

            if (currentTask != null)
            {
                try
                {
                    currentTask.BeginProcess(buffer);
                    if (stop)
                    {
                        currentTask.Abort();
                        break;
                    }
                    currentTask.WaitProcessDone();
                }
                catch (Exception e)
                {
                    Log.Info("post thread excep", e);
                }
            }
            else
            {
                Sleep();
            }
        }
        //Log.Debug("post ThreadProc end");
    }
}

