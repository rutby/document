using System.Collections.Generic;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using XLua;
using UnityGameFramework.SDK;

[Hotfix]
public class CheckDeviceChangeMessage : BaseMessage
{
	public static CheckDeviceChangeMessage Instance;

	public CheckDeviceChangeMessage()
	{
		Instance = this;
	}

	public override string GetMsgId()
	{
		return "check.device.change";
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
		if (message == null){
			return;
		}

        bool isChange = message.TryGetBool("r");
        //MiddleManager.Instance.isChangeDevice = isChange;

        //TODO 清空邮件DB
        //if (isChange)
        // clearSysMailFromDB();
    }
}