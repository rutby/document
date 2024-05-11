using UnityEngine;
using XLua;
using System;

//[LuaCallCSharp]
public class LuaUIFormLogic : MonoBehaviour
{
    [System.Serializable]
    public class Injection
    {
        public string name;
        public GameObject value;
    }

    public TextAsset luaScript;
    public Injection[] injections;

    internal static LuaEnv luaEnv = new LuaEnv(); //all lua behaviour shared one luaenv only!
    internal static float lastGCTime = 0;
    internal const float GCInterval = 1;//1 second 
    public OneObjDelegate luaInit;
    public OneObjDelegate luaOpen;
    public TwoFloatDelegate luaUpdate;
    public OneObjDelegate luaClose;
    public Action luaCover;
    public Action luaResume;
    public Action luaPause;
    public OneObjDelegate luaRefocus;
    public Action luaReveal;

    private LuaTable scriptEnv;

    public bool DoLuaFunction(string name, out object[] res, params object[] args)
    {
        var func = scriptEnv.Get<LuaFunction>(name);
        if(func == null)
        {
            res = null;
            return false;
        }
        else
        {
            res = func.Call(args);
            return true;
        }
    }

    public void LuaInit(object userData)
    {
        scriptEnv = luaEnv.NewTable();

        // 为每个脚本设置一个独立的环境，可一定程度上防止脚本间全局变量、函数冲突
        LuaTable meta = luaEnv.NewTable();
        meta.Set("__index", luaEnv.Global);
        scriptEnv.SetMetaTable(meta);
        meta.Dispose();

        scriptEnv.Set("self", this);
        foreach (var injection in injections)
        {
            scriptEnv.Set(injection.name, injection.value);
        }

        luaEnv.DoString(luaScript.text, gameObject.name, scriptEnv);

        luaInit = scriptEnv.Get<OneObjDelegate>("init");
        luaOpen = scriptEnv.Get<OneObjDelegate>("open");
        luaUpdate = scriptEnv.Get<TwoFloatDelegate>("update");
        luaClose = scriptEnv.Get<OneObjDelegate>("close");
        luaCover = scriptEnv.Get<Action>("cover");
        luaResume = scriptEnv.Get<Action>("resume");
        luaPause = scriptEnv.Get<Action>("pause");
        luaRefocus = scriptEnv.Get<OneObjDelegate>("refocus");
        luaReveal = scriptEnv.Get<Action>("reveal");

        if (luaInit != null)
        {
            luaInit(userData);
        }
    }

    public void LuaOpen(object userData)
    {
        if(luaOpen != null)
        {
            luaOpen(userData);
        }
    }

    public void LuaUpdate(float elapseSeconds, float realElapseSeconds)
    {
        if(luaUpdate != null)
        {
            luaUpdate(elapseSeconds, realElapseSeconds);
        }
        if (Time.time - lastGCTime > GCInterval)
        {
            luaEnv.Tick();
            lastGCTime = Time.time;
        }
    }

    public void LuaClose(object userData)
    {
        if(luaClose != null)
        {
            luaClose(userData);
        }
    }

    public void LuaCover()
    {
        if(luaCover != null)
        {
            luaCover();
        }
    }

    public void LuaResume()
    {
        if(luaResume != null)
        {
            luaResume();
        }
    }

    public void LuaPause()
    {
        if(luaPause != null)
        {
            luaPause();
        }
    }

    public void LuaRefocus(object userData)
    {
        if(luaRefocus != null)
        {
            luaRefocus(userData);
        }
    }

    public void LuaReveal()
    {
        if(luaReveal != null)
        {
            luaReveal();
        }
    }

    void OnDestroy()
    {
        luaClose = null;
        luaUpdate = null;
        luaOpen = null;
        luaCover = null;
        luaRefocus = null;
        luaReveal = null;
        luaPause = null;
        luaResume = null;
        scriptEnv.Dispose();
        injections = null;
    }
}