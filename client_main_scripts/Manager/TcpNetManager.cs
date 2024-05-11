
using System;
using GameFramework;
using GameKit.Base;
using Sfs2X.Core;

public class TcpNetManager : INetManager
{
    private NetStateBase[] _stateList = new NetStateBase[(int) NetState.StateCount];
    private NetStateBase _curState;
    
    public Action<string, string> OnConnectionEvent;
    public Action<string, INetProxy> OnConnectionLostEvent;
    public Action<BaseEvent> OnLoginEvent;

    public TcpNetManager()
    {
        initState();
    }

    private void initState()
    {
        _stateList[(int) NetState.INIT] = new NetInitState(this);
        _stateList[(int) NetState.CHOOSELINE] = new NetChooseLineState(this);
        _stateList[(int) NetState.CONNECTED] = new NetConnecedState(this);
        _stateList[(int) NetState.CONNECTLOST] = new NetConnectLostState(this);
        _stateList[(int) NetState.CONNECTERROR] = new NetConnectErrorState(this);
        changeState(NetState.INIT, null);
    }

    public void connect()
    {
        changeState(NetState.CHOOSELINE, null);
    }

    public void changeState(NetState newState, params object[] para)
    {
        NetStateBase newStateBase = _stateList[(int) newState];
        if (_curState != newStateBase)
        {
            if (_curState != null)
            {
                _curState.OnExit();
                Log.Info("change net state {0}_{1}", _curState.getState(), newState);
            }

            
            _curState = newStateBase;
            _curState.OnEnter(para);
        }
        else
        {
            Log.Error("error change same state {0}", newState);
        }
    }

    public void update()
    {
        if (_curState != null)
        {
            _curState.OnUpdate();
        }
    }

    public bool OnConnection(INetProxy proxy, BaseEvent e)
    {
        if (_curState != null)
        {
            return _curState.OnConnection(proxy, e);
        }

        return false;
    }

    public void OnConnectionLost(string reason, INetProxy proxy)
    {
        if (_curState != null)
        {
            _curState.OnConnectionLost(reason, proxy);
        }
    }

    public void callOnConnectionLost(string reason, INetProxy proxy)
    {
        OnConnectionLostEvent?.Invoke(reason, proxy);
    }

    public void OnLogout(BaseEvent e)
    {
        
    }

    public void OnLogin(BaseEvent e)
    {
        OnLoginEvent?.Invoke(e);
    }

    public void OnLoginError(BaseEvent e)
    {
        
    }
}
