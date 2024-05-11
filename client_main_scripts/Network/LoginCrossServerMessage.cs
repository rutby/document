/*-----------------------------------------------------------------------------------------
// FileName：LoginCrossServerMessage.cs
// Author：wangweiying
// Date：2019.1.31
// Description：跨服登陆消息
//-----------------------------------------------------------------------------------------*/
using Sfs2X.Entities.Data;
using Sfs2X.Requests;

public class LoginCrossServerMessage : BaseMessage
{
    public override string GetMsgId()
    {
        return "login";
    }

    public void SendRequest()
    {
        GameEntry.NetworkCross.Send(this);
    }

    public override void Send(params object[] args)
    {
        var request = CSSetData(args);
        GameEntry.NetworkCross.Send(request);
    }

    public string mUserName = "";

    protected override IRequest CSSetData(params object[] args)
    {
        ISFSObject obj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        obj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        int selfSid = GameEntry.Data.Player.GetSelfServerId();
        mUserName = GameEntry.Data.Player.Uid;
        var uidStr = selfSid + "_" + mUserName;
        obj.PutUtfString("uid", uidStr);

        int nSid = GameEntry.Data.Player.GetCrossServerId();
        obj.PutInt("sid", nSid);
        //举例注释：我在41服，点击45服查看45的地图  发送给45服务器的login信息(sid:45，fsid:41) byanning
        
        obj.PutInt("fsid", selfSid);
        
        obj.PutInt("loginType", 1);

        obj.PutUtfString("appVersion", GameEntry.Sdk.Version);
        obj.PutUtfString("versionCode", GameEntry.Sdk.VersionCode);
        ////前台版本
        //putParam("appVersion", CCString::create(cocos2d::extension::CCDevice::getVersionName()));
        ////小版本号
        //putParam("versionCode", CCString::create(cocos2d::extension::CCDevice::getVersionCode()));
        string zone = "APS"+ nSid;
        return new LoginRequest(mUserName, "", zone, obj);
    }

    protected override void CSHandleResponse(ISFSObject message)
    {
        if (message.ContainsKey("errorMessage")) {
            string errorCode = message.GetUtfString("errorMessage");

            GameEntry.NetworkCross.Logined = false;
            GameEntry.NetworkCross.Disconnect();
            GameEntry.NetworkCross.ClearRequestQueue();

            if (errorCode == "4")
            {
                return;
            }
            else if (errorCode == "E001")
            {
                return;
            }
            else if (errorCode == "E002")
            {
                return;
            }
            else if (errorCode == "E003")
            {
                return;
            }
            else if (errorCode == "E004")
            {//合服导入ing
                return;
            }
            else if (errorCode == "120870")
            {
                return;
            }
        }
        bool loginResult = false;
        if (message.ContainsKey("loginStatus")) 
        {
            if (message.TryGetString("loginStatus") == "0")
            {
                loginResult = true;
            }
        }

        if (loginResult)
        {
            GameEntry.NetworkCross.Logined = true;
        }
        else
        {
            GameEntry.NetworkCross.Logined = false;
            GameEntry.NetworkCross.Disconnect();
            GameEntry.NetworkCross.ClearRequestQueue();
            GameEntry.NetworkCross.ClearSpecialCommand();
        }
    }
}
