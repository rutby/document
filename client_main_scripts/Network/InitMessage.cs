using GameFramework;
using Sfs2X.Entities.Data;
using UnityEngine;
using XLua;

/// <summary>
/// init.error
/// </summary>
public class InitErrorMessage : BaseMessage
{
    public override string GetMsgId()
    {
        return "init.error";
    }
    protected override void CSHandleResponse(ISFSObject message)
    {
        // ApplicationLaunch.Instance.Loading.OnInitError();
    }
}

public class InitMessage : BaseMessage
{
    public static InitMessage Instance;
    private LuaTable initMsgTable;
    
    public InitMessage()
    {
        Instance = this;
    }

    public override string GetMsgId()
    {
        return "init";
    }

    protected override void CSHandleResponse(ISFSObject message)
    {
        PostEventLog.Record(PostEventLog.Defines.PUSH_INIT_RECV);

        // FIXME: 这个消息需要移动到LUA
        if (message.ContainsKey("identification"))
        {
            // var temp = message.TryGetObj("identification");
            // if (temp != null)
            // {
            //     var isAuthenticate = temp.TryGetBool("authenticate");
            //     var isCn = temp.TryGetBool("isCN");
            //     var isChild = temp.TryGetBool("isChild");
            //     GameEntry.GlobalData.SetCnFlagFromServer(isCn);
            //     if (!isAuthenticate && isCn)
            //     {
            //         ApplicationLaunch.Instance.Loading.IsNeedIdentification = true;
            //         ApplicationLaunch.Instance.Loading.IsNeedMailIdentification = false;
            //         var uid = temp.TryGetString("uid");
            //         GameEntry.Setting.GameUid = uid;
            //         GameEntry.Setting.SetString(GameDefines.SettingKeys.GAME_UID, uid);
            //         return;
            //     }
            //     if(isCn && isChild)
            //     {
            //         ApplicationLaunch.Instance.Loading.IsNeedIdentification = true;
            //         ApplicationLaunch.Instance.Loading.IsNeedMailIdentification = false;
            //         ApplicationLaunch.Instance.Loading.IsChild = true;
            //         var uid = temp.TryGetString("uid");
            //         GameEntry.Setting.GameUid = uid;
            //         GameEntry.Setting.SetString(GameDefines.SettingKeys.GAME_UID, uid);
            //         return;
            //     }
            // }
        }
        if (message.ContainsKey("deviceVerify"))
        {
            var temp = message.TryGetObj("deviceVerify");
            if (temp != null)
            {
                var needVerify = temp.TryGetBool("needVerify");
                var mailStr = temp.TryGetString("mail");
                if (needVerify)
                {
                    var uid = temp.TryGetString("uid");
                    GameEntry.Setting.GameUid = uid;
                    GameEntry.Setting.SetString(GameDefines.SettingKeys.GAME_UID, uid);
                    GameEntry.Event.Fire(EventId.NeedMailIdentify,mailStr);
                    return;
                }
            }
        }
        GameEntry.Event.Fire(EventId.NeedMailIdentify,"");
        InitData(message);
    }

    private enum NewUserWorld
    {
        Skip, // 0 跳过新手世界
        Ing,  // 1 正在新手世界中
        Pass  // 2 经历过新手世界
    }
    public void InitData(ISFSObject message)
    {
        try
        {
            Log.Debug("login init data begin");
            if (message.ContainsKey("isShipShow"))
            {
                message.GetSFSObject("dataConfig")?.PutInt("isShipShow", message.TryGetInt("isShipShow"));
            }
            
            //先临时在这里对GameUid赋下值
            if (message.ContainsKey("user"))
            {
                var user = message.GetSFSObject("user");
                var uid = user.GetUtfString("uid");
                ////af初始化放到uid创建好之后
                if (!string.IsNullOrEmpty(uid))
                {
                    GameEntry.Sdk.initAppsFlyer(uid);
                }
               
                GameEntry.Setting.GameUid = uid;
            }

            GameEntry.GlobalData.Init(message);
            GameEntry.Data.Player.Init(message);
            if (SceneManager.IsSceneNone())
            {
                if (GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER)
                {
                    SceneManager.CreateWorld();
                }
                else
                {
                    SceneManager.CreateCity();
                }
                
            }
            //推送
            PushManager.Instance.onLoginComplete();
        
            GameEntry.Timer.Tomorrow = (long)message.GetInt("tomorrow") * 1000;
            
            CheckDeviceChangeMessage.Instance.Send();
            
            LuaInitData(message);
            
            Log.Debug("login init data end");
        }
        catch (System.Exception e)
        {
            PostEventLog.Record(PostEventLog.Defines.LOGIN_PARSE_ERROR, e.StackTrace);
#if UNITY_EDITOR
            Log.Error(e);
            throw e;
#endif
        }
    }

    private void LuaInitData(ISFSObject message)
    {
        GameEntry.Lua.DispatchResponse(GetMsgId(), ((SFSObject)message).ToLuaTable(GameEntry.Lua.Env));
    }
}

