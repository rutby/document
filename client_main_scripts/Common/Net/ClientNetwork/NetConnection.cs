using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Net.Sockets;
using GameFramework;
using Sfs2X.Exceptions;
using Sfs2X.Requests;
using Sfs2X.Bitswarm;
using Sfs2X.Core;
using Sfs2X.Entities.Data;

namespace ProtoBufNet
{
    
    public interface INetConnection : IDisposable
    {
        bool IsConnected { get; }
        void Close(bool graceful, string reason);
    
        long lastRecvTick { get; set; }
        
        bool SendMessage(IRequest m);
    }

    public class NetConnection : INetConnection
    {
        public NetConnection(NetIOService service, Socket socket, MessageDispather dispatch, string name)
        {
            m_service = service;
            m_socket = socket;
            m_dispatch = dispatch;

            m_name = name;
            m_packets_send = new LinkedList<NetPacket>();
        }

        ~NetConnection()
        {
            Dispose(true);
        }

        internal void Init()
        {
            // if (m_dispatch.onConnectted != null)
            // {
            //     m_dispatch.onConnectted(this);
            // }
        }

        internal Socket socket
        {
            get{return m_socket;}
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!m_disposed)
            {
                m_disposed = true;
                if (disposing)
                {
                    m_socket.Close();
                    //m_socket.Dispose();
                    m_socket = null;
                    m_dispatch = null;
                    m_packets_send = null;
                    m_service = null;
                }
            }
        }

        public bool IsConnected
        {
            get
            {
                if (m_socket != null)
                    return m_socket.Connected;
                else
                    return false;
            }
        }

        public bool IsDisposed()
        {
            return m_disposed;
        }

        public bool SendMessage(IRequest request)
        {
            if (!this.IsConnected)
            {
                Log.Warning("You are not connected. Request cannot be sent: " + (object) request);
                return false;
            }
            else
            {
                try
                {
                    // request.Validate(this);
                    request.Execute(null);
                    sendPackage(request.Message);
                }
                catch (SFSValidationError ex)
                {
                    string str = ex.Message;
                    foreach (string error in ex.Errors)
                        str = str + "\t" + error + "\n";
                    Log.Warning(str);
                }
                catch (SFSCodecError ex)
                {
                    Log.Error("send error {0}", ex.StackTrace);
                }
            }

            return true;
        }

        private void sendPackage(IMessage message)
        {
            NetPacket p = new NetPacket(false);
            ISFSObject sfsObject = new SFSObject();
            sfsObject.PutByte(MessageDispather.CONTROLLER_ID, Convert.ToByte(message.TargetController));
            sfsObject.PutShort(MessageDispather.ACTION_ID, Convert.ToInt16(message.Id));
            sfsObject.PutSFSObject(MessageDispather.PARAM_ID, message.Content);
            message.Content = sfsObject;
            
            p.onBeforeSend(message);
            SendPacket(p);
        }

        public void Close(bool graceful, string reason)
        {
            if (m_socket == null || !m_socket.Connected)
                return;
            PostEventLog.Record(PostEventLog.Defines.SOCKET_SHUTDOWN, m_name, reason);
            try
            {
                m_socket.Shutdown(SocketShutdown.Both);
            }
            catch (SocketException e)
            {
               Log.Error("{0} socket shut down error {1}", m_name, "Connection error: " + e.SocketErrorCode +" " + e.Message + " " + e.StackTrace);
            }

        }
        

        public long lastRecvTick
        {
            get;
            set;
        }

        private void SendPacket(NetPacket p)
        {
            try
            {
                lock (m_packets_send)
                {
                    m_packets_send.AddLast(p);
                    if (m_packets_send.Count == 1)
                        PostSend();
                }
            }
            catch (SocketException e)
            {
                Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }



        private void PostSend()
        {
            if (m_packets_send.Count != 0)
            {
                NetPacket p = m_packets_send.First.Value;
                m_send_offset = 0;
                m_socket.BeginSend(p.Buffer.GetBytes(), m_send_offset, p.Buffer.DataLength, SocketFlags.None, new AsyncCallback(this.HandlePackageSend), p);
            }
        }

        internal void PostRecv()
        {
            NetPacket p = new NetPacket(true);
            m_socket.BeginReceive(p.Buffer.GetBytes(), 0, p.Buffer.DataLength, SocketFlags.None, new AsyncCallback(this.HandleHeaderRecv), p);
        }

        /**
         * 读取包头
         */
        private void HandleHeaderRecv(IAsyncResult ar)
        {
            try
            {
                if (m_socket == null || IsDisposed())
                {
                    return;
                }

                int transferd = m_socket.EndReceive(ar);
                NetPacket p = ar.AsyncState as NetPacket;
                
                if (transferd < 1)
                {
                    m_socket.BeginReceive(
                        p.headerBuff().GetBytes(),
                        0,
                        p.headerBuff().DataLength,
                        SocketFlags.None,
                        new AsyncCallback(this.HandleHeaderRecv), p);
                }
                else
                {
                    p.parseHeader();
                    m_socket.BeginReceive(p.bodyLengthBuff().GetBytes(), 0, p.bodyLengthBuff().DataLength, SocketFlags.None, new AsyncCallback(this.HandleBodyLengthRecv), p);
                }
            }
            catch (SocketException e)
            {
                Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }

        /**
         * 读取包内容长度
         */
        private void HandleBodyLengthRecv(IAsyncResult ar)
        {
            try
            {
                int transferd = m_socket.EndReceive(ar);
                NetPacket p = ar.AsyncState as NetPacket;
                p.bodyLengthHasRead += transferd;
                if (p.bodyLengthHasRead < p.bodyLengthBuff().DataLength)
                {
                    m_socket.BeginReceive(
                        p.bodyLengthBuff().GetBytes(),
                        p.bodyLengthHasRead,
                        p.bodyLengthBuff().DataLength - p.bodyLengthHasRead,
                        SocketFlags.None,
                        new AsyncCallback(this.HandleBodyLengthRecv), p);
                }
                else
                {
                    p.parseBodyLength();
                    m_socket.BeginReceive(p.bodyBuff().GetBytes(), 0, p.bodyBuff().DataLength, SocketFlags.None, new AsyncCallback(this.HandleBodyRecv), p);
                }
            }
            catch (SocketException e)
            {
                Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }

        /**
         * 读取包体
         */
        private void HandleBodyRecv(IAsyncResult ar)
        {
            try
            {
                if (m_socket == null || IsDisposed())
                {
                    return;
                }
                int transferd = m_socket.EndReceive(ar);
                NetPacket p = ar.AsyncState as NetPacket;
                p.bodyHasRead += transferd;
                if (p.bodyHasRead < p.bodyBuff().DataLength)
                {
                    m_socket.BeginReceive(
                        p.bodyBuff().GetBytes(),
                        p.bodyHasRead,
                        p.bodyBuff().DataLength - p.bodyHasRead,
                        SocketFlags.None,
                        new AsyncCallback(this.HandleBodyRecv), p);
                }
                else
                {
                    p.onPackageReceiveFinish();
                    FinishRecvPacket(p);
                }
            }
            catch (SocketException e)
            {
                Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }

        private void FinishRecvPacket(NetPacket p)
        {
            lastRecvTick = DateTime.Now.Ticks / 10000;
            m_service.Post((NetIOService s) =>
            {
                m_dispatch.Dispatch(this, p);
            });

            PostRecv();
        }
        
        
        private void HandlePackageSend(IAsyncResult ar)
        {
            try
            {
                if (IsDisposed() || m_socket == null)
                {
                    return;
                }

                int transfered = m_socket.EndSend(ar);
                NetPacket p = ar.AsyncState as NetPacket;
            
                m_send_offset += transfered;
                if (m_send_offset < p.Buffer.DataLength)
                {
                    m_socket.BeginSend(
                        p.Buffer.GetBytes(),
                        m_send_offset,
                        p.Buffer.DataLength - m_send_offset,
                        SocketFlags.None,
                        new AsyncCallback(this.HandlePackageSend),
                        p);
                }
                else
                {
                    m_send_offset = 0;
                    FinishSendPacket(p);
                }
            }
            catch (SocketException e)
            {
                Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }

        private void FinishSendPacket(NetPacket p)
        {
            lock (m_packets_send)
            {
                Debug.Assert(p == m_packets_send.First.Value);
                m_packets_send.RemoveFirst();
                PostSend();
            }
        }

        internal void Error(string err, SocketError errCode)
        {
            this.Close(false, "socket error");

            m_service.Post((NetIOService s) =>
            {
                if (m_disposed)
                    return;

                lock (m_packets_send)
                {
                    m_packets_send.Clear();
                }

                m_dispatch.OnConnectionLost(err, errCode);
                Dispose();
            });
        }

        private NetIOService m_service;

        private LinkedList<NetPacket> m_packets_send;
        private Socket m_socket;
        private MessageDispather m_dispatch;
        private string m_name;
        private int m_send_offset = 0;
        private bool m_disposed = false;
        private int m_sendId;
    }
}
