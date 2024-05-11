/*-----------------------------------------------------------------------------------------
// FileName：WorldCrossServerMessage.cs
// Author：wangweiying
// Date：2019.1.31
// Description：跨服请求数据，这个在服务器只是注册了位置信息。用于后面推送
//-----------------------------------------------------------------------------------------*/
using Sfs2X.Entities.Data;
using Sfs2X.Requests;

public class WorldCrossServerMessage : BaseMessage
{
    public class RequestParam
    {
        public int x;
        public int y;
        public int type;
        public int forceServerId;
        public int worldId = 0;
    }

    public override string GetMsgId()
    {
        return "world.get.cross";
    }

    public int mServerId;
    private RequestParam mParam;
    public static WorldCrossServerMessage Instance;
    public WorldCrossServerMessage()
    {
        Instance = this;
    }
    protected override IRequest CSSetData(params object[] args)
    {
        RequestParam request = mParam;
        ISFSObject obj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        obj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        obj.PutInt("x", request.x);
        obj.PutInt("y", request.y);
        obj.PutLong("timeStamp", GameEntry.Timer.GetServerTime());
        obj.PutInt("type", request.type);
        obj.PutInt("worldId", request.worldId);
        int sid = GameEntry.Data.Player.GetSelfServerId();
        if (request.forceServerId != -1)
        {
            sid = request.forceServerId;
        }
        mServerId = sid;
        obj.PutInt("serverId", sid);

        return new ExtensionRequest(GetMsgId(), obj);
    }

    public void SendReqest(RequestParam param)
    {
        if (string.IsNullOrEmpty(GameEntry.Data.Player.Uid)) return;
        
        if (GameEntry.Data.Player.GetSelfServerId() != mServerId)
        {
            mParam = param;
            GameEntry.NetworkCross.Send(this);
            GameEntry.NetworkCross.ClearSpecialCommand();
            GameEntry.NetworkCross.AddSpecialCommand(this);
        }
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
