using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using GameFramework;
using UnityEngine;
using XLua;
public class LoginInitCommand : BaseMessage
{
    public override string GetMsgId()
    {
        return "login.init";
    }
    protected override IRequest CSSetData(params object[] args)
    {
        ISFSObject retObj = new SFSObject();
        var dataConfigMd5 =GameEntry.Lua.CallWithReturn<string>("CSharpCallLuaInterface.GetConfigMd5");
        if (!dataConfigMd5.IsNullOrEmpty())
        {
            retObj.PutUtfString("dataConfigMd5", dataConfigMd5);
        }
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        retObj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        return new ExtensionRequest(GetMsgId(), retObj);
    }
    protected override void CSHandleResponse(ISFSObject message)
    {
        if (message == null || message.ContainsKey("errorCode"))
        {
            return;
        }
        
        //同步登录数据
        InitMessage.Instance.InitData(message);
        if (SceneManager.World != null)
        {
            SceneManager.World.RefreshView();
        }
        GameEntry.Event.Fire(EventId.CloseDisconnectView);
        GameEntry.Event.Fire(EventId.Guide_video_Play);
    }
}