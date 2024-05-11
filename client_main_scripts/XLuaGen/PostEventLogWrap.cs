#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;

    [Unity.IL2CPP.CompilerServices.Il2CppSetOption(Unity.IL2CPP.CompilerServices.Option.NullChecks, false)]
    public class PostEventLogWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(PostEventLog);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 7, 1, 1);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "init", _m_init_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "stop", _m_stop_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "PostException", _m_PostException_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Record", _m_Record_xlua_st_);
            
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "POSTURL", PostEventLog.POSTURL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "POSTURL_CN", PostEventLog.POSTURL_CN);
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "hasInit", _g_get_hasInit);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "hasInit", _s_set_hasInit);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "PostEventLog does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_init_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    PostEventLog.init(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_stop_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    PostEventLog.stop(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PostException_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _action = LuaAPI.lua_tostring(L, 1);
                    string _logString = LuaAPI.lua_tostring(L, 2);
                    string _longText = LuaAPI.lua_tostring(L, 3);
                    
                    PostEventLog.PostException( _action, _logString, _longText );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Record_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _action = LuaAPI.lua_tostring(L, 1);
                    
                    PostEventLog.Record( _action );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _action = LuaAPI.lua_tostring(L, 1);
                    string _param1 = LuaAPI.lua_tostring(L, 2);
                    
                    PostEventLog.Record( _action, _param1 );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count >= 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaTypes.LUA_TNONE == LuaAPI.lua_type(L, 2) || (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING))) 
                {
                    string _action = LuaAPI.lua_tostring(L, 1);
                    string[] _args = translator.GetParams<string>(L, 2);
                    
                    PostEventLog.Record( _action, _args );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _action = LuaAPI.lua_tostring(L, 1);
                    string _param1 = LuaAPI.lua_tostring(L, 2);
                    string _param2 = LuaAPI.lua_tostring(L, 3);
                    
                    PostEventLog.Record( _action, _param1, _param2 );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PostEventLog.Record!");
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_hasInit(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushboolean(L, PostEventLog.hasInit);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_hasInit(RealStatePtr L)
        {
		    try {
                
			    PostEventLog.hasInit = LuaAPI.lua_toboolean(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
