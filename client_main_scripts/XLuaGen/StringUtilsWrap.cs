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
    public class StringUtilsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(StringUtils);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 17, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "IntToString", _m_IntToString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetMD5", _m_GetMD5_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFormattedSeperatorNum", _m_GetFormattedSeperatorNum_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFormattedInt", _m_GetFormattedInt_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFormattedLong", _m_GetFormattedLong_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFormattedStr", _m_GetFormattedStr_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFormattedPercentStr", _m_GetFormattedPercentStr_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GenerateRandomStr", _m_GenerateRandomStr_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FormatDBString", _m_FormatDBString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ConvertToRomanFromInt", _m_ConvertToRomanFromInt_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FormatPassedTime", _m_FormatPassedTime_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SplitString", _m_SplitString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTimerString", _m_GetTimerString_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FormatStringMaxLength", _m_FormatStringMaxLength_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "S2Sec", _m_S2Sec_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "TryParseInt", _m_TryParseInt_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "StringUtils does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IntToString_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _variable = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.IntToString( _variable );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMD5_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _msg = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.GetMD5( _msg );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormattedSeperatorNum_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)) 
                {
                    int _value = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedSeperatorNum( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1) || LuaAPI.lua_isint64(L, 1))) 
                {
                    long _value = LuaAPI.lua_toint64(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedSeperatorNum( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _value = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedSeperatorNum( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to StringUtils.GetFormattedSeperatorNum!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormattedInt_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _value = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedInt( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormattedLong_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    long _value = LuaAPI.lua_toint64(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedLong( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormattedStr_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    double _value = LuaAPI.lua_tonumber(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedStr( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormattedPercentStr_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    double _value = LuaAPI.lua_tonumber(L, 1);
                    
                        var gen_ret = StringUtils.GetFormattedPercentStr( _value );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GenerateRandomStr_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int __codeCount = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.GenerateRandomStr( __codeCount );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FormatDBString_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.FormatDBString( _str );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ConvertToRomanFromInt_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _lv = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.ConvertToRomanFromInt( _lv );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FormatPassedTime_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    double _passed = LuaAPI.lua_tonumber(L, 1);
                    
                        var gen_ret = StringUtils.FormatPassedTime( _passed );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SplitString_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    char _key = (char)LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = StringUtils.SplitString( _str, _key );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<System.Collections.Generic.List<string>>(L, 3)) 
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    char _key = (char)LuaAPI.xlua_tointeger(L, 2);
                    System.Collections.Generic.List<string> _list = (System.Collections.Generic.List<string>)translator.GetObject(L, 3, typeof(System.Collections.Generic.List<string>));
                    
                    StringUtils.SplitString( _str, _key, ref _list );
                    translator.Push(L, _list);
                        
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to StringUtils.SplitString!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTimerString_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    long _l = LuaAPI.lua_toint64(L, 1);
                    
                        var gen_ret = StringUtils.GetTimerString( _l );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FormatStringMaxLength_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    int _maxLen = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = StringUtils.FormatStringMaxLength( _str, _maxLen );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.FormatStringMaxLength( _str );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to StringUtils.FormatStringMaxLength!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_S2Sec_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)) 
                {
                    int _rawNum = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = StringUtils.S2Sec( _rawNum );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _rawStr = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.S2Sec( _rawStr );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to StringUtils.S2Sec!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TryParseInt_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _str = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = StringUtils.TryParseInt( _str );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
