using System;
using System.Collections.Generic;
using System.Text;
using GameFramework;
using UnityEngine;
using XLua;

#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif


// 绑定LUA脚本用
public class LuaMonoBehaviour : MonoBehaviour
{
    [Serializable]
    public class Objects
    {
        public string name;
        public GameObject value;
    }

    [Serializable]
    public class Values
    {
        public string name;
        public string value;
    }
    
    // lua文件的名称；里面必须return 一个正确的lua table
    public string _luaPath;
    
    // 数据列表
    public Values[] _values;
    
    // 物件列表
    public Objects[] _objects;

    // 无效的引用
    private readonly static int LUA_REFNIL = -1;
    
    // 关联的表
    private int _luaTableReference = LUA_REFNIL;
    
    // 一些缓存的函数ref变量
    // 不要用数组存，会有额外GC。。。
    // 添加时需要在GetFunctions 和 UnRefAll 里都加代码
    private int _Awake = LUA_REFNIL;
    private int _Start = LUA_REFNIL;
    private int _OnDestroy = LUA_REFNIL;
    private int _OnEnable = LUA_REFNIL;
    private int _OnDisable = LUA_REFNIL;
    private int _OnCollisionEnter = LUA_REFNIL;
    private int _OnCollisionExit = LUA_REFNIL;
    private int _OnTriggerEnterAction = LUA_REFNIL;
    private int _OnTriggerExitAction = LUA_REFNIL;
    private int _OnAnimationAction = LUA_REFNIL;
    private int _OnApplicationFocus = LUA_REFNIL;
    private int _OnApplicationPause = LUA_REFNIL;

    private static char[] globalBuf = new char[256];
    private static StringBuilder globalSB = new StringBuilder(256);

    LuaMonoBehaviour()
    {
        
    }
    
    private void MakeLuaBytes(out byte[] bytes, out int bytes_len)
    {
        if (string.IsNullOrEmpty(_luaPath))
        {
            bytes = null;
            bytes_len = 0;
            return;
        }
        
        globalSB.Clear();
        globalSB.Append("return require '");
        globalSB.Append(_luaPath);
        globalSB.Append("'");
        
        globalSB.CopyTo(0, globalBuf, 0, globalSB.Length);

        int pos = globalSB.Length;
        if (pos > InternalGlobals.strBuff.Length)
        {
            bytes = Encoding.UTF8.GetBytes(globalBuf, 0, pos);
            bytes_len = bytes.Length;
        }
        else
        {
            bytes_len = Encoding.UTF8.GetBytes(globalBuf, 0, pos, InternalGlobals.strBuff, 0);
            bytes = InternalGlobals.strBuff;
        }
        
        return;
    }
    
    private void Awake()
    {
        // 生成require lua 表
        MakeLuaBytes(out byte[] bytes, out int bytes_len);
        if (bytes_len <= 0)
        {
            // 尚未绑定脚本就不做其他处理了
            return;
        }
        
        // 获取返回值的引用
        _luaTableReference = GetLuaTable(bytes, bytes_len);
        if (_luaTableReference == LUA_REFNIL)
        {
            Log.Error("LuaMonoBehaviour Awake error : {0}", _luaPath??"");
            return;
        }
            
        Set(_luaTableReference, "Mono", this);
        GetFunctions();
            
        // 调用Lua的Awake
        CallLuaFunc(_Awake);
        CallLuaFunc(_Start);
    }

    private void OnDestroy()
    {
        CallLuaFunc(_OnDestroy);

        // 反注册所有的变量
        UnRefAll();
    }
    
    private void OnEnable()
    {
        CallLuaFunc(_OnEnable);
    }

    private void OnDisable()
    {
        CallLuaFunc(_OnDisable);
    }
    
    private void OnCollisionEnter(Collision other)
    {
        CallLuaFunc(_OnCollisionEnter, other);
    }

    private void OnCollisionExit(Collision other)
    {
        CallLuaFunc(_OnCollisionExit, other);
    }

    private void OnTriggerEnter(Collider other)
    {
        CallLuaFunc(_OnTriggerEnterAction, other);
    }

    private void OnTriggerExit(Collider other)
    {
        CallLuaFunc(_OnTriggerExitAction, other);
    }

    private void OnAnimationAction(string name)
    {
        CallLuaFunc(_OnAnimationAction, name);
    }
    
    void OnApplicationFocus(bool hasFocus)
    {
        CallLuaFunc(_OnApplicationFocus, hasFocus);
    }

    void OnApplicationPause(bool pauseStatus)
    {
        CallLuaFunc(_OnApplicationPause, pauseStatus);
    }
    

    // #if UNITY_EDITOR
    // private void OnGUI()
    // {
    //     int a = 0;
    // }
    // #endif

    private void CallLuaFunc(int funcref)
    {
        CallLuaFunc(funcref, 0, (object)null);
    }
    
    private void CallLuaFunc<T>(int funcref, T para)
    {
        CallLuaFunc(funcref, 1, para);
    }

    private void CallLuaFunc<T>(int funcref, int para_count, T para)
    {
        if (funcref <= 0)
        {
            return;
        }

        if (GameEntry.Lua == null || GameEntry.Lua.Env == null)
        {
            Log.Info("CallLuaFunc lua not ready!");
            return;
        }
        
        var Env = GameEntry.Lua.Env; 
        var L = Env.L;
        var translator = Env.translator;
        int oldTop = LuaAPI.lua_gettop(L);

        int top;
        try
        {
            int errFunc = LuaAPI.load_error_func(L, Env.errorFuncRef);
            LuaAPI.lua_getref(L, funcref);

            top = LuaAPI.lua_gettop(L);
            
            // 必须要压入自己；即LuaTable作为self
            LuaAPI.lua_getref(L, _luaTableReference); 
            
            top = LuaAPI.lua_gettop(L);

            // 我们一般情况就只有一个参数
            if (para_count > 0)
            {
                translator.PushAny(L, para);
                para_count = 2;
            }
            else
            {
                para_count = 1;
            }

            top = LuaAPI.lua_gettop(L);
            
            int error = LuaAPI.lua_pcall(L, para_count, -1, errFunc);
            if (error != 0)
                Env.ThrowExceptionFromError(oldTop);

            LuaAPI.lua_remove(L, errFunc);
        }
        catch (Exception e)
        {
            Log.Error("CallLuaFunc error!\n{0}", e.Message);
        }
        finally
        {
            LuaAPI.lua_settop(L, oldTop);
        }

    }

    // 这里先返回LuaFunction，但是会有gc，以后可以写一个小的函数托管
    private int GetFunction(string funcName)
    {
        var L = GameEntry.Lua.Env.L;
        var translator = GameEntry.Lua.Env.translator;
        int oldTop = LuaAPI.lua_gettop(L);
        int funcref = LUA_REFNIL;
        
        // 此时table 已经压栈了，所以这里直接取。然后恢复栈即可
        translator.PushByType(L, funcName);
        LuaTypes t = LuaAPI.lua_type(L, -1);
        
        // 不知道为什么不能使用LuaAPI.lua_rawget(L, -2);
        // 这里使用作者写的这个函数，，但是明显效率低
        LuaAPI.xlua_pgettable(L, -2);
            
        t = LuaAPI.lua_type(L, -1);
        if (t == LuaTypes.LUA_TFUNCTION)
        {
            funcref = LuaAPI.luaL_ref(L, LuaIndexes.LUA_REGISTRYINDEX);
        }
        
        LuaAPI.lua_settop(L, oldTop);
        return funcref;
    }

    private void GetFunctions()
    {
        // 这里手动处理一下，效率高一点
        var L = GameEntry.Lua.Env.L;
        var translator = GameEntry.Lua.Env.translator;
        int oldTop = LuaAPI.lua_gettop(L);
        try
        {
            LuaTypes t;
            // 压入table
            LuaAPI.lua_getref(L, _luaTableReference);
            
            _Awake = GetFunction("Awake");
            _Start = GetFunction("Start");
            _OnDestroy = GetFunction("OnDestroy");
            _OnEnable = GetFunction("OnEnable");
            _OnDisable = GetFunction("OnDisable");
            _OnCollisionEnter = GetFunction("OnCollisionEnter");
            _OnCollisionExit = GetFunction("OnCollisionExit");
            _OnTriggerEnterAction = GetFunction("OnTriggerEnterAction");
            _OnTriggerExitAction = GetFunction("OnTriggerExitAction");
            _OnAnimationAction = GetFunction("OnAnimationAction");
            _OnApplicationFocus = GetFunction("_OnApplicationFocus");
            _OnApplicationPause = GetFunction("_OnApplicationPause");
        }
        catch (Exception e)
        {
            Log.Error("GetFunctions error!");
        }
        finally
        {
            LuaAPI.lua_settop(L, oldTop);
        }
        
    }
 
    
    // 这里主要还是因为GC原因，不想因为用户使用了LuaMono，从而造成额外的负担
    private int GetLuaTable(byte[] bytes, int bytes_len)
    {
        if (GameEntry.Lua == null || GameEntry.Lua.Env == null)
        {
            Log.Info("GetLuaTable Lua not ready!");
            return LUA_REFNIL;
        }
        
        var Env = GameEntry.Lua.Env;
        var _L = Env.L;
        LuaTypes type;

        int oldTop = LuaAPI.lua_gettop(_L);
        int luaref = LUA_REFNIL;
        
        try
        {
            int errFunc = LuaAPI.load_error_func(_L, Env.errorFuncRef);
            if (LuaAPI.xluaL_loadbuffer(_L, bytes, bytes_len, "") == 0)
            {
                if (LuaAPI.lua_pcall(_L, 0, -1, errFunc) == 0)
                {
                    LuaAPI.lua_remove(_L, errFunc);
                }
                else
                {
                    Env.ThrowExceptionFromError(oldTop);
                }
            }
            else
            {
                Env.ThrowExceptionFromError(oldTop);
            }

            // 确保返回值是一个lua table，然后把这个lua table放进注册表
            type = LuaAPI.lua_type(_L, oldTop + 1);
            if (type == LuaTypes.LUA_TTABLE)
            {
                luaref = LuaAPI.luaL_ref(_L, LuaIndexes.LUA_REGISTRYINDEX);
            }
        }
        catch (Exception)
        {
            Log.Error("GetLuaTable error!");
        }
        finally
        {
            LuaAPI.lua_settop(_L, oldTop);
        }
        
        return luaref;
    }
    
    // 给table设置值
    private void Set<TKey, TValue>(int luaref, TKey key, TValue value)
    {
        var Env = GameEntry.Lua.Env;
        var L = Env.L;
        int oldTop = LuaAPI.lua_gettop(L);
        
        try
        {
            var translator = Env.translator;

            LuaAPI.lua_getref(L, luaref);
            translator.PushByType(L, key);
            translator.PushByType(L, value);

            if (0 != LuaAPI.xlua_psettable(L, -3))
            {
                Env.ThrowExceptionFromError(oldTop);
            }
        }
        catch (Exception)
        {
            Log.Error("Set error!");
        }
        finally
        {
            LuaAPI.lua_settop(L, oldTop);
        }
    }

    private void UnRef(ref int funcref)
    {
        var Env = GameEntry.Lua.Env;
        var L = Env.L;
        
        if (funcref > 0) 
        {
            LuaAPI.lua_unref(L, funcref);
            funcref = LUA_REFNIL;
        }
    }

    // 从注册表注销所有相关的引用
    private void UnRefAll()
    {
        if (GameEntry.Lua == null || GameEntry.Lua.Env == null)
        {
            Log.Info("UnRefAll lua not ready!");
            return;
        }

        UnRef(ref _Awake);
        UnRef(ref _Start);
        UnRef(ref _OnDestroy);
        UnRef(ref _OnEnable);
        UnRef(ref _OnDisable);
        UnRef(ref _OnCollisionEnter);
        UnRef(ref _OnCollisionExit);
        UnRef(ref _OnTriggerEnterAction);
        UnRef(ref _OnTriggerExitAction);
        UnRef(ref _OnAnimationAction);
        UnRef(ref _OnApplicationFocus);
        UnRef(ref _OnApplicationPause);

    }
}

