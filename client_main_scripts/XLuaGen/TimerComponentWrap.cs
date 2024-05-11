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
    public class TimerComponentWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(TimerComponent);
			Utils.BeginObjectRegister(type, L, translator, 0, 30, 2, 2);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Shutdown", _m_Shutdown);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnUpdate", _m_OnUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetWorldTime", _m_SetWorldTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeTime", _m_ChangeTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateServerMilliseconds", _m_UpdateServerMilliseconds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLocalMilliseconds", _m_GetLocalMilliseconds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLocalSeconds", _m_GetLocalSeconds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetServerTime", _m_GetServerTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetServerTimeSeconds", _m_GetServerTimeSeconds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MillisecondToSecondString", _m_MillisecondToSecondString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SecondsToSecondString", _m_SecondsToSecondString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "MilliSecondToFmtString", _m_MilliSecondToFmtString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SecondToFmtString", _m_SecondToFmtString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefixTimebyZone", _m_RefixTimebyZone);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PassTimeSecondString", _m_PassTimeSecondString);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDateTime", _m_GetDateTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TimeStampToTimeSimple", _m_TimeStampToTimeSimple);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TimeStampToTimeDate", _m_TimeStampToTimeDate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TimeStampToTimeDateMd", _m_TimeStampToTimeDateMd);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TimeStampToTime", _m_TimeStampToTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetUniversalTime", _m_GetUniversalTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetUniversalChatTime", _m_GetUniversalChatTime);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetServerWeekDay", _m_GetServerWeekDay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WeekDay", _m_WeekDay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetWeekDay", _m_GetWeekDay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetResSecondsTo24", _m_GetResSecondsTo24);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RegisterTimer", _m_RegisterTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RegisterTimerRepeat", _m_RegisterTimerRepeat);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CancelTimer", _m_CancelTimer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CancelAllTimers", _m_CancelAllTimers);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "Light", _g_get_Light);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Tomorrow", _g_get_Tomorrow);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "Light", _s_set_Light);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Tomorrow", _s_set_Tomorrow);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new TimerComponent();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Shutdown(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Shutdown(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _elapseSeconds = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.OnUpdate( _elapseSeconds );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetWorldTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _t = LuaAPI.xlua_tointeger(L, 2);
                    int _tz = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.SetWorldTime( _t, _tz );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _t = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.ChangeTime( _t );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateServerMilliseconds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _ms = LuaAPI.lua_toint64(L, 2);
                    
                    gen_to_be_invoked.UpdateServerMilliseconds( _ms );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLocalMilliseconds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetLocalMilliseconds(  );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLocalSeconds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetLocalSeconds(  );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetServerTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetServerTime(  );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetServerTimeSeconds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetServerTimeSeconds(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MillisecondToSecondString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _mstime = LuaAPI.lua_toint64(L, 2);
                    string _separator = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.MillisecondToSecondString( _mstime, _separator );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SecondsToSecondString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _second = LuaAPI.lua_toint64(L, 2);
                    string _separator = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.SecondsToSecondString( _second, _separator );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_MilliSecondToFmtString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _milliSecond = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.MilliSecondToFmtString( _milliSecond );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SecondToFmtString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _secs = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.SecondToFmtString( _secs );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefixTimebyZone(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _time = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.RefixTimebyZone( _time );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PassTimeSecondString(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    long _passTime = LuaAPI.lua_toint64(L, 2);
                    bool _isMstime = LuaAPI.lua_toboolean(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.PassTimeSecondString( _passTime, _isMstime );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _passTime = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.PassTimeSecondString( _passTime );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.PassTimeSecondString!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDateTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _timeStamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetDateTime( _timeStamp );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TimeStampToTimeSimple(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeSimple( _timestamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeSimple( _timestamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.TimeStampToTimeSimple!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TimeStampToTimeDate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeDate( _timestamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeDate( _timestamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.TimeStampToTimeDate!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TimeStampToTimeDateMd(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeDateMd( _timestamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTimeDateMd( _timestamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.TimeStampToTimeDateMd!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TimeStampToTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTime( _timestamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timestamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.TimeStampToTime( _timestamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.TimeStampToTime!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUniversalTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timeStamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetUniversalTime( _timeStamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timeStamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetUniversalTime( _timeStamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.GetUniversalTime!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUniversalChatTime(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    long _timeStamp = LuaAPI.lua_toint64(L, 2);
                    string _format = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetUniversalChatTime( _timeStamp, _format );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _timeStamp = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetUniversalChatTime( _timeStamp );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to TimerComponent.GetUniversalChatTime!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetServerWeekDay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetServerWeekDay(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WeekDay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.DateTime _time;translator.Get(L, 2, out _time);
                    
                        var gen_ret = gen_to_be_invoked.WeekDay( _time );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetWeekDay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _milliSecond = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetWeekDay( _milliSecond );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResSecondsTo24(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetResSecondsTo24(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RegisterTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _delaySec = (float)LuaAPI.lua_tonumber(L, 2);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.RegisterTimer( _delaySec, _onComplete );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RegisterTimerRepeat(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _delaySec = (float)LuaAPI.lua_tonumber(L, 2);
                    float _repeatSec = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.RegisterTimerRepeat( _delaySec, _repeatSec, _onComplete );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CancelTimer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ITimer _timer = (ITimer)translator.GetObject(L, 2, typeof(ITimer));
                    
                    gen_to_be_invoked.CancelTimer( _timer );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CancelAllTimers(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CancelAllTimers(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Light(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.Light);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Tomorrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushint64(L, gen_to_be_invoked.Tomorrow);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Light(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Light = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Tomorrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                TimerComponent gen_to_be_invoked = (TimerComponent)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Tomorrow = LuaAPI.lua_toint64(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
