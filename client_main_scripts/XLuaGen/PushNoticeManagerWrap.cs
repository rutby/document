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
    public class PushNoticeManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(PushNoticeManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 8, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "PushNotice", _m_PushNotice_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CancelNotice", _m_CancelNotice_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPushCountById", _m_GetPushCountById_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPushSecondTimeById", _m_GetPushSecondTimeById_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetIsNotifyOpen", _m_GetIsNotifyOpen_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCurrentTimeUnix", _m_GetCurrentTimeUnix_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "pushDataToHttpServer", _m_pushDataToHttpServer_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new PushNoticeManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to PushNoticeManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PushNotice_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _noticeJson = LuaAPI.lua_tostring(L, 1);
                    
                    PushNoticeManager.PushNotice( _noticeJson );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CancelNotice_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _typeJson = LuaAPI.lua_tostring(L, 1);
                    
                    PushNoticeManager.CancelNotice( _typeJson );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPushCountById_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _pushId = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = PushNoticeManager.GetPushCountById( _pushId );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPushSecondTimeById_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _pushId = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = PushNoticeManager.GetPushSecondTimeById( _pushId );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIsNotifyOpen_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = PushNoticeManager.GetIsNotifyOpen(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCurrentTimeUnix_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = PushNoticeManager.GetCurrentTimeUnix(  );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_pushDataToHttpServer_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    PushNoticeManager.pushDataToHttpServer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
