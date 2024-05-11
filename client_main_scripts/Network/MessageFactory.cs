/*-----------------------------------------------------------------------------------------
// FileName：MessageFactory.cs
// Author：wangweiying
// Date：2019.1.31
// Description：消息处理分发
//-----------------------------------------------------------------------------------------*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using GameFramework;
using Sfs2X.Core;
using Sfs2X.Entities.Data;
using Sfs2X.Util;
using UnityEngine;
using UnityGameFramework.Runtime;

public class MessageFactory
{
    private static MessageFactory _instance;

    public static MessageFactory Instance
    {
        get
        {
            if (null == _instance)
            {
                _instance = new MessageFactory();
            }

            return _instance;
        }
    }

    private Dictionary<string, BaseMessage> mHandlers;

    //public MessageFactory()
    //{
    //    InitMessageHandlers();
    //}

    public void InitMessageHandlers()
    {
        mHandlers = new Dictionary<string, BaseMessage>();
        var types = AppDomain.CurrentDomain.GetAssemblies()
            .SelectMany(a => a.GetTypes().Where(t => t.BaseType == typeof(BaseMessage)))
            .ToArray();
        foreach (var t in types)
        {
            var obj = t.Assembly.CreateInstance(t.FullName);
            var messageHandler = obj as BaseMessage;

            // 特殊处理下。有两个消息不加入到这里
            if (obj is LoginCrossServerMessage || obj is WorldCrossServerMessage) continue;

            if (!mHandlers.ContainsKey(messageHandler.GetMsgId()))
            {
                mHandlers.Add(messageHandler.GetMsgId(), messageHandler);
            }
            else
            {
                GameFramework.Log.Error(messageHandler.GetMsgId() + " has duplicated");
                //Log.Error(messageHandler.GetMsgId());
            }
        }
    }

    public void DispatchResponse(BaseEvent e)
    {
        ExtensionEvent ee = e as ExtensionEvent;
        if (ee != null)
        {
            DispatchResponse(ee.cmd, ee.rawData as ByteArray);
        }
        else
        {   string cmd = (string)e.Params["cmd"];
            var so = e.Params["params"] as SFSObject;
            DispatchResponse(cmd, so);
            
        }

    }

    // 消息统一分发处理
    public void DispatchResponse(string cmd, SFSObject so)
    {
        
        if (CommonUtils.IsDebug())
        {
#if __LOG
            if (cmd.Equals("world.get.new"))
            {
                Log.Warning(string.Format("<color=green>extension res <{0}> |</color>", cmd));
            }
            else
            {
                var s = so.ToJson();
                Log.Warning(string.Format("<color=green>extension res <{0}> |</color> {1}", cmd, s));
            }
#endif
        }
        try
        {
            if (so.ContainsKey("_id"))
            {
                int fuid = so.GetInt("_id");
                int serverTime = so.TryGetInt("_time");
                GameEntry.Network.getFutureManager().onServerMsgCome(fuid, serverTime);
            }

            if (mHandlers.ContainsKey(cmd))
            {
                // if (cmd.Equals("world.get.new") && XLuaManager.IsUseLuaWorldPoint)
                // {
                //     GameEntry.Lua.DispatchResponse(cmd, so.ToLuaTable(GameEntry.Lua.Env));
                // }
                // else
                // {
                    mHandlers[cmd].Handle(so);
                // }
            }
                
            // 1.C#中没有的消息协议，放在lua中处理，比如新增的协议
            // 2.暂时不将所有协议全部放在lua中，后续可能使用pb代替
            // 3.C#中的协议有变化时，尝试使用Hotfix修复
            else
            {
                GameEntry.Lua.DispatchResponse(cmd, so.ToLuaTable(GameEntry.Lua.Env));
            }
        }catch (System.Exception excep)
        {
            Log.Error("process msg {0} error, {1}", cmd, excep);
        }

    }
    
        // 消息统一分发处理
    public void DispatchResponse(string cmd, ByteArray rawData)
    {
        var sfs = SFSObject.NewFromBinaryData(rawData);
        var so = sfs.GetSFSObject("p").GetSFSObject("p") as SFSObject;
        if (CommonUtils.IsDebug())
        {
#if __LOG
            if (cmd.Equals("world.get.new"))
            {
                Log.Warning(string.Format("<color=green>extension res <{0}> |</color>", cmd));
            }
            else
            {
                var s = so.ToJson();
                Log.Warning(string.Format("<color=green>extension res <{0}> |</color> {1}", cmd, s));
            }
#endif
        }
        try
        {
            if (so.ContainsKey("_id"))
            {
                int fuid = so.GetInt("_id");
                int serverTime = so.TryGetInt("_time");
                GameEntry.Network.getFutureManager().onServerMsgCome(fuid, serverTime);
            }

            if (mHandlers.ContainsKey(cmd))
            {
                if (cmd.Equals("world.get.new") && XLuaManager.IsUseLuaWorldPoint)
                {
                    GameEntry.Lua.DispatchResponse(cmd, so.ToLuaTable(GameEntry.Lua.Env));
                }
                else
                {
                    mHandlers[cmd].Handle(so);
                }
                
            }
            // 1.C#中没有的消息协议，放在lua中处理，比如新增的协议
            // 2.暂时不将所有协议全部放在lua中，后续可能使用pb代替
            // 3.C#中的协议有变化时，尝试使用Hotfix修复
            else
            {
                GameEntry.Lua.DispatchResponse(cmd, so.ToLuaTable(GameEntry.Lua.Env));
            }
        }catch (System.Exception excep)
        {
            Log.Error("process msg {0} error, {1}", cmd, excep);
        }

    }

    // 处理login消息
    public bool OnLogin(BaseEvent e)
    {
        var so = e.Params["data"] as SFSObject;
        if (so == null)
        {
            Log.Error("Login failed");
            return false;
        }
#if UNITY_EDITOR
        Log.Warning("OnLogin: " + so.ToJson());
#endif
        
        mHandlers["login"].Handle(so);

        return true;
    }
    public bool OnLoginError(string errorMessage,short errorCode)
    {
        var so = new SFSObject();
        so.PutUtfString("errorMessage",errorMessage);
        so.PutInt("errorCode",errorCode);
        mHandlers["login"].Handle(so);

        return true;
    }
}
