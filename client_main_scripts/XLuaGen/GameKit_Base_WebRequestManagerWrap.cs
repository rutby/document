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
    public class GameKitBaseWebRequestManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameKit.Base.WebRequestManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 10, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsDownloadResult", _m_IsDownloadResult);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadAssetBundle", _m_LoadAssetBundle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadTexture", _m_LoadTexture);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "LoadMultimedia", _m_LoadMultimedia);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Get", _m_Get);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Post", _m_Post);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Head", _m_Head);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Put", _m_Put);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Delete", _m_Delete);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DownFile", _m_DownFile);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 2, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FILE_NO_EXISTS", GameKit.Base.WebRequestManager.FILE_NO_EXISTS);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameKit.Base.WebRequestManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsDownloadResult(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Networking.UnityWebRequest _request = (UnityEngine.Networking.UnityWebRequest)translator.GetObject(L, 2, typeof(UnityEngine.Networking.UnityWebRequest));
                    string _result = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.IsDownloadResult( _request, _result );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadAssetBundle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<object>(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    object _userdata = translator.GetObject(L, 6, typeof(object));
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Hash128>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.Hash128 _hash;translator.Get(L, 3, out _hash);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _hash, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Hash128>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.Hash128 _hash;translator.Get(L, 3, out _hash);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _hash, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Hash128>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.Hash128 _hash;translator.Get(L, 3, out _hash);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _hash, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Hash128>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.Hash128 _hash;translator.Get(L, 3, out _hash);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.LoadAssetBundle( _uri, _hash, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadAssetBundle!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadTexture(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<object>(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    object _userdata = translator.GetObject(L, 6, typeof(object));
                    
                    gen_to_be_invoked.LoadTexture( _uri, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    bool _nonReadable = LuaAPI.lua_toboolean(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.LoadTexture( _uri, _nonReadable, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    bool _nonReadable = LuaAPI.lua_toboolean(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _nonReadable, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    bool _nonReadable = LuaAPI.lua_toboolean(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _nonReadable, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    bool _nonReadable = LuaAPI.lua_toboolean(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.LoadTexture( _uri, _nonReadable, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadTexture!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LoadMultimedia(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.AudioType>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.AudioType _audioType;translator.Get(L, 3, out _audioType);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.LoadMultimedia( _uri, _audioType, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.AudioType>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.AudioType _audioType;translator.Get(L, 3, out _audioType);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.LoadMultimedia( _uri, _audioType, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.AudioType>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.AudioType _audioType;translator.Get(L, 3, out _audioType);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.LoadMultimedia( _uri, _audioType, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.AudioType>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.AudioType _audioType;translator.Get(L, 3, out _audioType);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.LoadMultimedia( _uri, _audioType, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.LoadMultimedia!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Get(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<object>(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    object _userdata = translator.GetObject(L, 6, typeof(object));
                    
                    gen_to_be_invoked.Get( _uri, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Get( _uri, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.Get( _uri, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    
                    gen_to_be_invoked.Get( _uri, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Get!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Post(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _postData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Post( _uri, _postData, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _postData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Post( _uri, _postData, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _postData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Post( _uri, _postData, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _postData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Post( _uri, _postData, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.WWWForm>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.WWWForm _formData = (UnityEngine.WWWForm)translator.GetObject(L, 3, typeof(UnityEngine.WWWForm));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Post( _uri, _formData, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.WWWForm>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.WWWForm _formData = (UnityEngine.WWWForm)translator.GetObject(L, 3, typeof(UnityEngine.WWWForm));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Post( _uri, _formData, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.WWWForm>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.WWWForm _formData = (UnityEngine.WWWForm)translator.GetObject(L, 3, typeof(UnityEngine.WWWForm));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Post( _uri, _formData, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.WWWForm>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.WWWForm _formData = (UnityEngine.WWWForm)translator.GetObject(L, 3, typeof(UnityEngine.WWWForm));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Post( _uri, _formData, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection> _multipartFormSections = (System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Post( _uri, _multipartFormSections, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection> _multipartFormSections = (System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Post( _uri, _multipartFormSections, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection> _multipartFormSections = (System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Post( _uri, _multipartFormSections, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection> _multipartFormSections = (System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<UnityEngine.Networking.IMultipartFormSection>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Post( _uri, _multipartFormSections, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<string, string>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.Dictionary<string, string> _formFields = (System.Collections.Generic.Dictionary<string, string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.Dictionary<string, string>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Post( _uri, _formFields, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<string, string>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.Dictionary<string, string> _formFields = (System.Collections.Generic.Dictionary<string, string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.Dictionary<string, string>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Post( _uri, _formFields, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<string, string>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.Dictionary<string, string> _formFields = (System.Collections.Generic.Dictionary<string, string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.Dictionary<string, string>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Post( _uri, _formFields, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<string, string>>(L, 3)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    System.Collections.Generic.Dictionary<string, string> _formFields = (System.Collections.Generic.Dictionary<string, string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.Dictionary<string, string>));
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Post( _uri, _formFields, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Post!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Head(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<object>(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    object _userdata = translator.GetObject(L, 6, typeof(object));
                    
                    gen_to_be_invoked.Head( _uri, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Head( _uri, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.Head( _uri, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    
                    gen_to_be_invoked.Head( _uri, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Head!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Put(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _bodyData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _bodyData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _bodyData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _bodyData = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _bodyData = LuaAPI.lua_tostring(L, 3);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    byte[] _bodyData = LuaAPI.lua_tobytes(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    byte[] _bodyData = LuaAPI.lua_tobytes(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    byte[] _bodyData = LuaAPI.lua_tobytes(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    byte[] _bodyData = LuaAPI.lua_tobytes(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    byte[] _bodyData = LuaAPI.lua_tobytes(L, 3);
                    
                    gen_to_be_invoked.Put( _uri, _bodyData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Put!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Delete(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& translator.Assignable<object>(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    object _userdata = translator.GetObject(L, 6, typeof(object));
                    
                    gen_to_be_invoked.Delete( _uri, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    int _timeout = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.Delete( _uri, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    int _priority = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.Delete( _uri, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 3);
                    
                    gen_to_be_invoked.Delete( _uri, _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.Delete( _uri );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.Delete!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DownFile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.WebRequestManager gen_to_be_invoked = (GameKit.Base.WebRequestManager)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<object>(L, 7)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _localFilePath = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    object _userdata = translator.GetObject(L, 7, typeof(object));
                    
                    gen_to_be_invoked.DownFile( _uri, _localFilePath, _callback, _priority, _timeout, _userdata );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _localFilePath = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    int _timeout = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.DownFile( _uri, _localFilePath, _callback, _priority, _timeout );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _localFilePath = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    int _priority = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.DownFile( _uri, _localFilePath, _callback, _priority );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4)) 
                {
                    string _uri = LuaAPI.lua_tostring(L, 2);
                    string _localFilePath = LuaAPI.lua_tostring(L, 3);
                    GameKit.Base.WebRequestManager.OnWebRequestCallback _callback = translator.GetDelegate<GameKit.Base.WebRequestManager.OnWebRequestCallback>(L, 4);
                    
                    gen_to_be_invoked.DownFile( _uri, _localFilePath, _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.WebRequestManager.DownFile!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
