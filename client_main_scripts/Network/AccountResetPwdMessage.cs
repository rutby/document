using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;
using XLua;
using UnityGameFramework.Runtime;

/*
[Hotfix]
public class AccountResetPwdMessage : BaseMessage
{
    //找回账号、密码

    public class Request
    {
        public string name;
        public string pwd;
    }
    public static AccountResetPwdMessage Instance;
    public AccountResetPwdMessage()
    {
        Instance = this;
    }
    public override string GetMsgId()
    {
        return "az.account.resetpassword";
    }

    protected override IRequest CSSetData(params object[] args)
    {
        var req = args[0] as Request;
        ISFSObject retObj = new SFSObject();
        retObj.PutUtfString("userName", req.name);

        string strkey = GameEntry.Data.Player.Uid;
        string _pwd = AESHelper.Encrypt(req.pwd, strkey);
        retObj.PutUtfString("pwd", _pwd);

        return new ExtensionRequest(GetMsgId(), retObj);
    }
    protected override void CSHandleResponse(ISFSObject message)
    {
        //GameEntry.Event.Fire(this, new CommonEventArgs(EventId.AccountBindEvent, message));
    }
}

*/