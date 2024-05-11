using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using GameFramework;
using GameKit.Base;
using Sfs2X.Bitswarm;
using Sfs2X.Controllers;
using Sfs2X.Core;
using Sfs2X.Entities;
using Sfs2X.Entities.Data;
using Sfs2X.Exceptions;
using Sfs2X.Requests;
using Sfs2X.Util;

namespace ProtoBufNet
{
    public class MessageDispather
    {
        public static readonly string CONTROLLER_ID = "c";
        public static readonly string ACTION_ID = "a";
        public static readonly string PARAM_ID = "p";
        public static readonly string USER_ID = "u";
        public static readonly string UDP_PACKET_ID = "i";

      
        private static readonly int MsgType_SYS = 0;
        private static readonly int MsgType_GAME = 1;

        private NetRawProxy proxy;

        public MessageDispather(NetRawProxy proxy)
        {
            this.proxy = proxy;
        }

        public void OnConnectionLost(string msg, SocketError error)
        {
            proxy.OnConnectionLost(msg, error);
        }


        public void Dispatch(INetConnection c, NetPacket p)
        {
            IMessage message = new Message();
            if (p.info.IsNull(MessageDispather.CONTROLLER_ID))
                throw new SFSCodecError("Request rejected: No Controller ID in request!");
            if (p.info.IsNull(MessageDispather.ACTION_ID))
                throw new SFSCodecError("Request rejected: No Action ID in request!");
            message.Id = Convert.ToInt32(p.info.GetShort(MessageDispather.ACTION_ID));
            message.Content = p.info.GetSFSObject(MessageDispather.PARAM_ID);
            message.IsUDP = p.info.ContainsKey(MessageDispather.UDP_PACKET_ID);
            
            int id = (int) p.info.GetByte(MessageDispather.CONTROLLER_ID);
            if (id == MsgType_SYS)
            {
                HandleSystemMessage(message);
            }
            else if (id == MsgType_GAME){
                HandleExtensionMessage(message);
            }
            else
            {
                throw new SFSError("Cannot handle server response. Unknown controller, id: " + (object) id);
            }
        }


        private void HandleExtensionMessage(IMessage message)
        {
           
            ISFSObject content = message.Content;
            string cmd  = content.GetUtfString(ExtensionController.KEY_CMD);
            SFSObject so = (SFSObject)content.GetSFSObject(ExtensionController.KEY_PARAMS);

            proxy.OnExtensionResponse(cmd, so);
            // this.sfs.DispatchEvent((BaseEvent) new SFSEvent(SFSEvent.EXTENSION_RESPONSE, data));
        }

        private void HandleSystemMessage(IMessage message)
        {
            if (message.Id == 1)
            {
                FnLogin(message);
            } else if (message.Id == 29)
            {
                FnPingPong(message);
            }
            else
            {
                Log.Error("not support sys {0} data {1}", message.Id, message.Content.ToJson());
            }
        }
        
        private void FnLogin(IMessage msg)
        {
            ISFSObject content = msg.Content;
            Hashtable data = new Hashtable();
            if (content.IsNull(BaseRequest.KEY_ERROR_CODE))
            {
                data[(object) "data"] = (object) content.GetSFSObject(LoginRequest.KEY_PARAMS);
                SFSEvent sfsEvent = new SFSEvent(SFSEvent.LOGIN, data);
                proxy.OnLogin(sfsEvent);
            }
            else
            {
                short num = content.GetShort(BaseRequest.KEY_ERROR_CODE);
                string errorMessage = ErrorCodes.GetErrorMessage((int) num, (object[]) content.GetUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                data[(object) "errorMessage"] = (object) errorMessage;
                data[(object) "errorCode"] = (object) num;
                proxy.OnLoginError((BaseEvent) new SFSEvent(SFSEvent.LOGIN_ERROR, data));
            }
        }
        
        private void FnPingPong(IMessage msg)
        {
            // int num = this.sfs.LagMonitor.OnPingPong();
            // this.sfs.DispatchEvent((BaseEvent) new SFSEvent(SFSEvent.PING_PONG, new Hashtable()
            // {
            //     [(object) "lagValue"] = (object) num
            // }));
            proxy.OnPingPoing();
        }
    }

}
