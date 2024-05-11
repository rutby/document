using System.Collections.Generic;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;
using XLua;

using UnityGameFramework.Runtime;

[Hotfix]
public class CrossWorldMoveMessage : BaseMessage {

    public class Request
    {
        public int Point;
        public string ItemUuid;
        public int ServerId;
        public int Type;
        public string TicketUuid;
        public int SubType = -1;
        public string MailId;
        public string Army;
        public string AssemblePoint;
    }
    public static CrossWorldMoveMessage Instance;
    public CrossWorldMoveMessage()
    {
        Instance = this;
    }
    public override string GetMsgId()
    {
        return "cross.world.mv";
    }

    private int _serverId;

    protected override IRequest CSSetData(params object[] args)
    {
        var req = args[0] as Request;
        ISFSObject retObj = new SFSObject();
        int fuId = GameEntry.Network.getFutureManager().getFutureId();
        retObj.PutInt("_id", fuId);
        GameEntry.Network.getFutureManager().onSendRequest(fuId, GetMsgId());
        if (req != null)
        {
            _serverId = req.ServerId;
            retObj.PutInt("point", req.Point);
            retObj.PutUtfString("itemUUid", req.ItemUuid);
            retObj.PutInt("serverId", req.ServerId);
            retObj.PutInt("type", req.Type);
            retObj.PutUtfString("ticketUUid", req.TicketUuid);
            if (req.SubType != -1)
            {
                retObj.PutInt("subType", req.SubType);
            }

            if (!req.MailId.IsNullOrEmpty())
            {
                retObj.PutUtfString("mailId", req.MailId);
            }

            if (!req.Army.IsNullOrEmpty())
            {
                retObj.PutUtfString("army", req.Army);
            }
            
            if (!req.AssemblePoint.IsNullOrEmpty())
            {
                retObj.PutUtfString("assemblePoint", req.AssemblePoint);
            }
        }

        return new ExtensionRequest(GetMsgId(), retObj);
    }
    protected override void CSHandleResponse(ISFSObject message)
    {
        UIUtils.HideLoadingMask();
        if (message.ContainsKey("errorCode"))
        {
            UIUtils.ShowTips(message.TryGetString("errorCode"));
            return;
        }
        if (message.ContainsKey("assemblePoint"))
        {
            var serverId = message.TryGetString("assemblePoint");
            // GameEntry.Data.Domain.UpdateUsedFBAssemblePosList(serverId);
        }

        var serverInfo = message.TryGetObj("serverInfo");
        var ip = serverInfo.TryGetString("ip");
        var zone = serverInfo.TryGetString("zone");
        string sid = zone.Substring(3);
        int port = serverInfo.TryGetInt("port");
        string gameUid = message.TryGetString("uid");

        // 必须从这里就进行gameuid持久化设置，否则老号一旦本机持久化本清理login消息发送的gameuid是空的将会返回E002错误
        if (!string.IsNullOrEmpty(gameUid))
        {
            GameEntry.Setting.SetString(GameDefines.SettingKeys.GAME_UID, gameUid);
        }

        GameEntry.Setting.SetString(GameDefines.SettingKeys.SERVER_IP, ip);
        GameEntry.Setting.SetInt(GameDefines.SettingKeys.SERVER_PORT, port);
        GameEntry.Setting.SetString(GameDefines.SettingKeys.SERVER_ZONE, zone);
#if DEBUG
        GameEntry.Setting.SetInt(GameDefines.SettingKeys.LAST_SERVER_KEY, sid.ToInt());
#endif
        ApplicationLaunch.Instance.ReloadGame();
    }
}