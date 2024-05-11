using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;
using XLua;
using UnityGameFramework.Runtime;
using LitJson;

[Hotfix]
public class FSTaskCommand : BaseMessage
{
    public class Request
    {
        public int value;
    }
    public static FSTaskCommand Instance;

    public FSTaskCommand()
    {
        Instance = this;
    }

    public override string GetMsgId()
    {
        return "praise.receive";
    }

    protected override IRequest CSSetData(params object[] args)
    {
        Request data = args[0] as Request;
        SFSObject req = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        req.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        req.PutInt("platforom", data.value);
        return new ExtensionRequest(GetMsgId(), req);
    }

    protected override void CSHandleResponse(ISFSObject message)
    {

    }
}

public class Popup5starPush : BaseMessage
{

    public override string GetMsgId()
    {
        return "push.popup.5star";
    }

    protected override void CSHandleResponse(ISFSObject message)
    {
        //if (!CommonUtils.CheckIsOpenByKey("five_star_evaluation"))
        //{
            return;
        //}
#if UNITY_ANDROID

        string str = GameEntry.Data.Player.Uid + "Freebuild_FiveStar";
        GameEntry.Setting.SetBool(str, true);

#endif
    }
}
