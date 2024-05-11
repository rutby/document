using System;
using System.Collections.Generic;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;
using UnityGameFramework.Runtime;

public class UserTowerChangeListenMessage : BaseMessage
{

    public static UserTowerChangeListenMessage Instance;

    public class Request
    {
        public long towerUuid;
        public long targetUuid;
    }
    public override string GetMsgId()
    {
        return "user.tower.change.listen";
    }
    public UserTowerChangeListenMessage()
    {
        Instance = this;
    }

    protected override IRequest CSSetData(params object[] args)
    {
        var req = args[0] as Request;
        ISFSObject retObj = new SFSObject();
        retObj.PutLong("towerUuid", req.towerUuid);
        retObj.PutLong("targetUuid", req.targetUuid);
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        retObj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        return new ExtensionRequest(GetMsgId(), retObj);
    }
    protected override void CSHandleResponse(ISFSObject message)
    {
        
    }
}
