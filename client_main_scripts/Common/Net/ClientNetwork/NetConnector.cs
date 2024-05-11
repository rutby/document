using System;
using System.Net;
using System.Net.Sockets;
using GameFramework;
using Sfs2X.Bitswarm;
using Sfs2X.Requests;

namespace ProtoBufNet
{
    public delegate void ConnecttedDelegate(INetConnection sender);
    public delegate void ErrorDelegte(INetConnection sender, SocketError err);

    public interface INetConnector : IDisposable
    {
        void Connect(string address, ushort port);
       
        void ResisterConnecttedHandler(ConnecttedDelegate handler);
        void ResisterErrorHandler(ErrorDelegte handler);
        bool SendMessage(IRequest m);
        void Close();
    }

    public class NetConnector : INetConnector
    {
        public NetConnector(NetIOService service)
        {
            ioService = service;
            // m_dispatcher = new MessageDispather();
            timerKeepAlive = new System.Timers.Timer(5000);
            timerKeepAlive.Elapsed += this.CheckKeepAlive;
            timerKeepAlive.Enabled = false;

           
            // m_dispatcher.onConnectted += this.HandleConnected;
            // m_dispatcher.onError += this.HandleDisonnected;
        }

        ~NetConnector()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public bool SendMessage(IRequest m)
        {
            if (conn != null && conn.IsConnected)
            {
                conn.SendMessage(m);
                return true;
            }
            else
            {
                return false;
            }
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!m_disposed)
            {
                m_disposed = true;
                if (disposing)
                {
                    if (conn != null)
                    {
                        conn.Close(false, "");
                        conn.Dispose();
                        conn = null;
                    }

                    m_dispatcher = null;
                    timerKeepAlive.Dispose();
                    timerKeepAlive = null;
                    ioService = null;
                }
            }
        }

        public void Connect(string address, ushort port)
        {
            IPAddress addr = IPAddress.Parse(address);
            IPEndPoint ep = new IPEndPoint(addr, port);
            Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            NetConnection c = MakeConnection(ioService, socket, m_dispatcher);
            this.conn = c;

            socket.BeginConnect(address, port, new AsyncCallback(this.HandleConnct), c);
        }

        public void Close()
        {
            if (conn != null)
            {
                conn.Close(false, "");
            }
        }

        public void ResisterConnecttedHandler(ConnecttedDelegate handler)
        {
            // m_dispatcher.onConnectted += handler;
        }

        public void ResisterErrorHandler(ErrorDelegte handler)
        {
            // m_dispatcher.onError += handler;
        }

        protected virtual NetConnection MakeConnection(NetIOService io, Socket socket, MessageDispather disp)
        {
            return new NetConnection(io, socket, disp, "direct");
        }

        private void CheckKeepAlive(object sender, System.Timers.ElapsedEventArgs e)
        {
            ioService.Post((NetIOService io) =>
            {
                if (conn == null || !conn.IsConnected)
                    return;

                long now = DateTime.Now.Ticks / 10000;
                long last = conn.lastRecvTick;

                if (last != 0)
                {
                    long s = now - last;
                    if (s > 30000)
                    {
                        conn.Close(false, "");
                        timerKeepAlive.Enabled = false;
                        return;
                    }
                }

                //KeepAliveMessage k = new KeepAliveMessage();
                //k.time = DateTime.Now.ToFileTimeUtc();
                //this.SendMessage(k);
            });            
        }

        private void HandleConnected(INetConnection c)
        {
            timerKeepAlive.Enabled = true;
            System.Diagnostics.Trace.Assert(c == conn);
        }

        private void HandleDisonnected(INetConnection c, SocketError err)
        {
            timerKeepAlive.Enabled = false;
            if (conn != null)
            {
                conn.Close(false, "");
                conn.Dispose();
            }
            conn = null;
        }

        private void HandleConnct(IAsyncResult ar)
        {
            NetConnection c = ar.AsyncState as NetConnection;
            try
            {
                c.socket.EndConnect(ar);

                Log.Debug("raw connect established");

                c.PostRecv();
                ioService.Post((NetIOService s) =>
                {
                    c.Init();
                });
   
            }
            catch (SocketException e)
            {
                Log.Debug("raw connect fail:");
                Log.Debug(e);
                c.Error("Connection error: " + e.Message + " " + e.StackTrace, e.SocketErrorCode);
            }  
        }

        private System.Timers.Timer timerKeepAlive;
        private NetIOService ioService;
        private MessageDispather m_dispatcher;
        private bool m_disposed = false;
        private INetConnection conn;
    }
}
