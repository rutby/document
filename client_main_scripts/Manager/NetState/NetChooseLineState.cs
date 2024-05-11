
using System;
using System.Collections.Generic;
using GameFramework;
using GameKit.Base;
using Sfs2X.Core;
using XLua;

public class NetChooseLineState : NetStateBase
{
    private List<INetProxy> m_allSelectProxy = new List<INetProxy>();//选择中线路
    
    public NetChooseLineState(TcpNetManager tcpNetManager):base(NetState.CHOOSELINE, tcpNetManager)
    {
        
    }
    
    public override void OnEnter(params object[] param)
    {
        clearAllLine();
        initLine();
        chooseLine();
    }

    public override void OnExit()
    {
        
    }

    public override void OnUpdate()
    {
        foreach (var p in m_allSelectProxy)
        {
            p.UpdateSmartFoxClient();
        }
    }
    
    private void clearAllLine()
    {
        foreach (var p in m_allSelectProxy)
        {
            p.Disconnect();
        }
        m_allSelectProxy.Clear();
    }

    private void initLine()
    {
        var table = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetAllProxy");
        var hasLine = false;
        var useRaw = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetIsUseNetRaw");
        
        if (table != null)
        {
            for (int i = 1; i <= table.Length; ++i)
            {
                var data = (LuaTable)table[i];
                if (data.ContainsKey("lineName") && data.ContainsKey("lineUrl") && data.ContainsKey("port"))
                {
                    var lineName = data.Get<string>("lineName");
                    var lineUrl = data.Get<string>("lineUrl");
                    var port = data.Get<int>("port");
                    INetProxy line;
                    if (!useRaw)
                    {
                        line = new NetProxy(lineName, lineUrl, port, _netManager);
                    }
                    else
                    {
                        line = new NetRawProxy(lineName, lineUrl, port, _netManager);
                    }
        
                    m_allSelectProxy.Add(line);
                    hasLine = true;
                }
            }
        }
        
        if (hasLine == false)
        {
            NetProxy direct = new NetProxy("direct", GameEntry.Network.GameServerUrl, GameEntry.Network.GameServerPort, _netManager);
        }
    }

    private void chooseLine()
    {
        initLine();
        foreach (var p in m_allSelectProxy)
        {
            p.Connect();
        }
    }
    
    public override bool OnConnection(INetProxy proxy, BaseEvent e)
    {
        bool success = (bool) e.Params["success"];
        if (success)
        {
            //断掉其他线路
            foreach (var p in m_allSelectProxy)
            {
                if (!p.proxyName.Equals(proxy.proxyName))
                {
                    p.Disconnect();
                }
            }

            _netManager.changeState(NetState.CONNECTED, proxy);

            //消息推送相关
            return true;
        }
        else
        {
            bool allError = true;
            
            foreach (var p in m_allSelectProxy)
            {
                if (p.Status != ProxyStatus.connectError)
                {
                    allError = false;
                    break;
                }
            }

            if (allError)
            {
                _netManager.changeState(NetState.CONNECTERROR, e);
            }
        }

        return false;
    }
}
