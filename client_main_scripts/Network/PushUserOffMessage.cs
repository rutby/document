using System.Collections;
using System.Collections.Generic;
using Sfs2X.Entities.Data;
using UnityEngine;
using UnityGameFramework.Runtime;
using XLua;

//
// 此账号已在其他客户端登陆
//
[Hotfix]
public class PushUserOffMessage : BaseMessage
{

	public override string GetMsgId()
	{
		return "push.user.off";
	}

	protected override void CSHandleResponse(ISFSObject message)
	{
		GameEntry.GlobalData.pushOffWithQuitGame = true;
		GameEntry.NetworkCross.RemoveConnect();
		UIUtils.ShowMessages(GameEntry.Localization.GetString("E100083"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,null,
			delegate { ApplicationLaunch.Instance.Quit(); });
	}
}

