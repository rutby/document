using System;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using GameFramework;
using ProtoBufNet;
using Sfs2X.Core;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;

namespace GameKit.Base
{
    public class NetRawProxy : INetProxy
    {
        private float lastPingPongTime;
        private int offMaxTime = 12; // 默认心跳时间

        public string proxyName { get; private set; }
        private string host;
        private int port;
        private NetIOService ioService;
        private System.Timers.Timer timerKeepAlive;
        private MessageDispather m_dispatcher;
        private bool m_disposed = false;
        private NetConnection conn;
        private INetManager parent;

        public ProxyStatus Status { get; private set; }

        public NetRawProxy(string name, string h, int p, INetManager net)
        {
            this.proxyName = name;
            this.host = h;
            this.port = p;
            this.Status = ProxyStatus.init;
            this.parent = net;
            init();
        }

        public bool IsConnected
        {
            get { return conn != null && conn.IsConnected; }
        }

        public bool IsConnecting
        {
            get { return Status == ProxyStatus.connecting; }
        }


        private void init()
        {
            ioService = new NetIOService();
            m_dispatcher = new MessageDispather(this);

            timerKeepAlive = new System.Timers.Timer(4000);
            timerKeepAlive.Elapsed += this.CheckKeepAlive;
            timerKeepAlive.Enabled = false;
// #if UNITY_EDITOR
//             m_Client.Debug = true;
//             //m_Client.EnableLagMonitor(true);
//             m_Client.AddLogListener(Sfs2X.Logging.LogLevel.ERROR, OnLogError);
// #endif
//             m_Client.AddEventListener(SFSEvent.CONNECTION, OnConnection);
//             m_Client.AddEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
//             m_Client.AddEventListener(SFSEvent.EXTENSION_RESPONSE, OnExtensionResponse);
//             m_Client.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
//             m_Client.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
//             m_Client.AddEventListener(SFSEvent.LOGIN, OnLogin);
//             m_Client.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);
//             m_Client.AddEventListener(SFSEvent.LOGOUT, OnLogout);
//             m_Client.AddEventListener(SFSEvent.PING_PONG, OnPingPoing);
//             // m_Client.AddEventListener(SFSEvent.SOCKET_ERROR, OnSocketError);
//             if (m_Client.SocketClient.Socket != null)
//             {
//                 m_Client.SocketClient.Socket.OnError += OnRawSocketError;
//             }
        }

        private void CheckKeepAlive(object sender, System.Timers.ElapsedEventArgs e)
        {
            ioService.Post((NetIOService io) =>
            {
                if (conn == null || !conn.IsConnected)
                    return;

                long now = DateTime.Now.Ticks / 10000;
                long last = conn.lastRecvTick;

                // if (last != 0)
                // {
                //     long s = now - last;
                //     if (s > 30000)
                //     {
                //         conn.Close(false);
                //         timerKeepAlive.Enabled = false;
                //         return;
                //     }
                // }

                conn.SendMessage(new PingPongRequest());
            });
        }

        public void UpdateSmartFoxClient()
        {
            if (ioService == null)
                return;

            ioService.Poll();
        }

        public void Connect()
        {
            SyncPingPong();

            
            
            lookupHostName();
        }

        private void lookupHostName()
        {
            Log.Info("raw Connect line {0} ip {1}, Port {2} dns begin", proxyName, host, port);
            Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            NetConnection c = new NetConnection(ioService, socket, m_dispatcher, "line " + proxyName);
            this.conn = c;
            try
            {
                Dns.BeginGetHostAddresses(host, OnHostNameResolved, c);
            } 
            catch (SocketException ex)
            {
                this.conn.Error("Dns error: " + ex.Message + " " + ex.StackTrace, ex.SocketErrorCode);
            }
        }
        
        private void OnHostNameResolved(IAsyncResult result)
        {
            Log.Info("raw Connect line {0} ip {1}, Port {2} dns end", proxyName, host, port);
            // PostEventLog.Record(PostEventLog.Defines.DNS_SUCESS, proxyName);
            NetConnection c = (NetConnection)result.AsyncState;
            if (c.IsDisposed())
            {
                return;
            }

            IPAddress[] hostAddresses = null;
            try
            {
                hostAddresses = Dns.EndGetHostAddresses(result);
            } 
            catch (SocketException ex)
            {
                this.conn.Error("Dns error: " + ex.Message + " " + ex.StackTrace, ex.SocketErrorCode);
            }
             

            bool isConnect = false;
            foreach (IPAddress address in hostAddresses)
            {
                try
                {
                    if (address.AddressFamily == AddressFamily.InterNetwork)
                    {
                        // socket.BeginConnect(host, port, new AsyncCallback(this.HandleConnct), this.conn);
                        this.conn.socket.BeginConnect(address, port, new AsyncCallback(this.HandleConnct), this.conn);
                        Log.Info("raw Connect line {0} ip {1}, Port {2} begin ip {3}", proxyName, address.ToString(), port,
                            address.ToString());
                        isConnect = true;
                        break;
                    }

                }
                catch (SocketException ex)
                {
                    this.conn.Error("Connection error: " + ex.Message + " " + ex.StackTrace, ex.SocketErrorCode);
                }
                catch (Exception ex)
                {
                    Log.Error("General exception on connection: " + ex.Message + " " + ex.StackTrace);
                }
            }


            if (isConnect)
            {
                // parent.getFutureManager().reset();
                Status = ProxyStatus.connecting;
                Log.Info("raw Connect line {0} ip {1}, Port {2}", proxyName, host, port);
            }
            else
            {
                Log.Error("raw Connect line error {0} ip {1}, Port {2}", proxyName, host, port);
            }
        }

        private void HandleConnct(IAsyncResult ar)
        {
            NetConnection c = ar.AsyncState as NetConnection;
            try
            {
                if (c.IsDisposed())
                {
                    return;
                }

                c.socket.EndConnect(ar);

                Log.Debug("raw connect established");

                // c.PostRecv();

                ioService.Post((NetIOService s) =>
                {
                    OnConnection((BaseEvent) new SFSEvent(SFSEvent.CONNECTION, new Hashtable()
                    {
                        ["success"] = true
                    }));
                });

                ioService.Post((NetIOService s) => { c.Init(); });
            }
            catch (SocketException e)
            {
                Log.Debug("raw connect fail:");
                Log.Debug(e);
                c.Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }
        }

        public void OnConnection(BaseEvent e)
        {
            if (timerKeepAlive != null)
            {
                timerKeepAlive.Enabled = true;
            }

            bool success = (bool) e.Params["success"];
            if (success)
            {
                Status = ProxyStatus.connected;
            }
            else
            {
                Status = ProxyStatus.connectError;
            }


            if (parent != null && parent.OnConnection(this, e))
            {
                conn.PostRecv();
            }
            Log.Info("raw Connect line {0} ip {1}, Port {2} sucess", proxyName, host, port);
        }

        public void OnConnectionLost(string reason, SocketError code)
        {
            if (timerKeepAlive != null)
            {
                timerKeepAlive.Enabled = false;
            }

            Status = ProxyStatus.connectError;
            OnRawSocketError(reason, code);
            parent.OnConnectionLost(reason, this);
        }

        private void OnLogout(BaseEvent e)
        {
            parent.OnLogout(e);
        }

        public void OnExtensionResponse(string cmd, SFSObject so)
        {
            SyncPingPong();
            MessageFactory.Instance.DispatchResponse(cmd, so);
        }

        public void OnLogin(BaseEvent e)
        {
            SyncPingPong();
            parent.OnLogin(e);
            // m_Client?.EnableLagMonitor(true);
        }

        public void OnLoginError(BaseEvent e)
        {
            parent.OnLoginError(e);
        }

        private void OnPublicMessage(BaseEvent e)
        {
            Log.Debug("public message");
        }

        private void OnLogError(BaseEvent e)
        {
            string message = (string) e.Params["message"];
            Log.Error(message);
            // PostEventLog.Record(PostEventLog.Defines.SOCKET_ERROR, $"socket error: {message}");
        }

        void OnRawSocketError(string error, SocketError se)
        {
            string msg = string.Format("Socket error : {0}_{1}_{2}", proxyName, se == SocketError.NotConnected, error);
            Log.Error(msg);
            PostEventLog.Record(PostEventLog.Defines.SOCKET_ERROR, msg);
        }

        public void OnPingPoing()
        {
            SyncPingPong();
            // Log.Debug("OnPingPoing");
        }

        public void SyncPingPong(int time = -1)
        {
            if (time == -1)
            {
                lastPingPongTime = Time.realtimeSinceStartup;
            }
            else
            {
                lastPingPongTime = time;
            }
        }

        public bool IsPingPongTimeOut
        {
            get
            {
                if (lastPingPongTime == 0)
                {
                    return false;
                }

                if (offMaxTime > 0 && lastPingPongTime + offMaxTime < Time.realtimeSinceStartup)
                {
                    return true;
                }

                return false;
            }
        }

        public void Disconnect()
        {
            if (conn != null)
            {
                timerKeepAlive.Dispose();
                timerKeepAlive = null;
                conn.Close(true, "disconnect");
                conn.Dispose();
                conn = null;
                Status = ProxyStatus.init;
                

                Log.Info("raw line {0} disconnect", proxyName);
            }
        }

        public void Send(IRequest request)
        {
            if (conn != null && conn.IsConnected)
            {
                conn.SendMessage(request);
            }
        }
    }
}