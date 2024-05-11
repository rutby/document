using System;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using UnityEngine;
using UnityGameFramework.Runtime;
using System.Text;

public class LogoutMessage : BaseMessage
{
    public class Request
    {
        public string zoneName;
    }
    public static LogoutMessage Instance;

    public LogoutMessage()
    {
        Instance = this;
    }
    public string g_durloading_commandlist;
    public override string GetMsgId()
    {
        return "logout";
    }

    protected override IRequest CSSetData(params object[] args)
    {
        g_durloading_commandlist += "logout;";
        return new LogoutRequest();
        //return new ExtensionRequest(GetMsgId(), retObj);
    }
    ISFSObject m_dic;
    protected override void CSHandleResponse(ISFSObject message)
    {
        g_durloading_commandlist += "logoutRec;";
        //printDebugKeyValue("LOADINGCOMMAND", g_durloading_commandlist.c_str());
        //g_sfs_status = 70;

        //if (g_isLoadingSceneInit && m_isInLoad == 0)
        //{
        //    return true;
        //}

        if (message.ContainsKey("zoneName"))
        {
            Debug.Log("logout success");
            m_dic = message;

            //this->retain();
            //CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(LogoutCommand::doReload), this, 0.0f, 0, 0.0f, false);
        }
    }

    public void Handle()
    {
        g_durloading_commandlist += "logoutRec;";
    }
}