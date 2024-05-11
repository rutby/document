
using System;
using GameFramework;
using Sfs2X.Core;

public class NetConnectErrorState : NetStateBase
{
    public NetConnectErrorState(TcpNetManager tcpNetManager):base(NetState.CONNECTERROR, tcpNetManager)
    {
        
    }
    
    public override void OnEnter(params object[] param)
    {
        BaseEvent e = (BaseEvent) param[0];
        var errCode = e.Params["errorCode"];
        string errorMessage = (string) e.Params["errorMessage"];
        try
        {
            errorMessage = errorMessage.Split('\n')[0];
            errorMessage = errorMessage.Substring(errorMessage.LastIndexOf(':'));
            Log.Error("Connect to server failed:{0}", errorMessage);

            if (errorMessage.Contains("Network is unreachable"))
            {
                _netManager.OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_UNREACHABLE, errorMessage);
            }
            else
            {
                _netManager.OnConnectionEvent?.Invoke(LoginErrorCode.ERROR_NETWORK, errorMessage);
            }
        }
        catch (Exception ex)
        {
            Log.Error(ex.Message);
        }
    }

    public override void OnExit()
    {
        
    }

    public override void OnUpdate()
    {
        
    }
}
