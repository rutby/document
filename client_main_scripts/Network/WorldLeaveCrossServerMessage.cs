/*-----------------------------------------------------------------------------------------
// FileName：WorldLeaveCrossServerMessage.cs
// Author：wangweiying
// Date：2019.1.31
// Description：请求离开跨服
//-----------------------------------------------------------------------------------------*/
using System.Collections;
using System.Collections.Generic;
using Sfs2X.Entities.Data;
using UnityEngine;
using Sfs2X.Requests;
public class WorldLeaveCrossServerMessage : BaseMessage
{
    public static WorldLeaveCrossServerMessage Instance;


    public WorldLeaveCrossServerMessage()
    {
        Instance = this;
    }

    public override string GetMsgId()
    {
        return "user.leave.world";
    }
    public void SendRequest()
    {
        GameEntry.NetworkCross.Send(this);
    }
    protected override IRequest CSSetData(params object[] args)
    {
        ISFSObject obj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        obj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        obj.PutInt("worldId",GameEntry.Data.Player.GetWorldId());
        return new ExtensionRequest(GetMsgId(), obj);
    }
    public override void Send(params object[] args)
    {
        var request = CSSetData(args);
        GameEntry.NetworkCross.Send(request);
    }
    protected override void CSHandleResponse(ISFSObject message)
    {

    }
}
