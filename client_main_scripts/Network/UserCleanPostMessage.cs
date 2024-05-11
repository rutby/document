using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;

public class UserCleanPostMessage : BaseMessage {
    
    public static UserCleanPostMessage Instance;
    public UserCleanPostMessage()
    {
        Instance = this;
    }
    public override string GetMsgId()
    {
        return "user.clean.post";
    }

    protected override IRequest CSSetData(params object[] args)
    {
        ISFSObject retObj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        retObj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        return new ExtensionRequest(GetMsgId(), retObj);
    }

    protected override void CSHandleResponse(ISFSObject message)
    {
        ApplicationLaunch.Instance.ReloadGame();
    }
}
