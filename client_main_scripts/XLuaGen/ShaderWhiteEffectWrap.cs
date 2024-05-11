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
    public class ShaderWhiteEffectWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ShaderWhiteEffect);
			Utils.BeginObjectRegister(type, L, translator, 0, 1, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "PlayEffect", _m_PlayEffect);
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 4, 4);
			
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ShakeWhiteEffectChangeTime", _g_get_ShakeWhiteEffectChangeTime);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ShakeWhiteEffectStayTime", _g_get_ShakeWhiteEffectStayTime);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ShakeWhiteEffectMinValue", _g_get_ShakeWhiteEffectMinValue);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ShakeWhiteEffectMaxValue", _g_get_ShakeWhiteEffectMaxValue);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ShakeWhiteEffectChangeTime", _s_set_ShakeWhiteEffectChangeTime);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ShakeWhiteEffectStayTime", _s_set_ShakeWhiteEffectStayTime);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ShakeWhiteEffectMinValue", _s_set_ShakeWhiteEffectMinValue);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ShakeWhiteEffectMaxValue", _s_set_ShakeWhiteEffectMaxValue);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new ShaderWhiteEffect();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to ShaderWhiteEffect constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PlayEffect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                ShaderWhiteEffect gen_to_be_invoked = (ShaderWhiteEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.PlayEffect(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ShakeWhiteEffectChangeTime(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, ShaderWhiteEffect.ShakeWhiteEffectChangeTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ShakeWhiteEffectStayTime(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, ShaderWhiteEffect.ShakeWhiteEffectStayTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ShakeWhiteEffectMinValue(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, ShaderWhiteEffect.ShakeWhiteEffectMinValue);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ShakeWhiteEffectMaxValue(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, ShaderWhiteEffect.ShakeWhiteEffectMaxValue);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ShakeWhiteEffectChangeTime(RealStatePtr L)
        {
		    try {
                
			    ShaderWhiteEffect.ShakeWhiteEffectChangeTime = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ShakeWhiteEffectStayTime(RealStatePtr L)
        {
		    try {
                
			    ShaderWhiteEffect.ShakeWhiteEffectStayTime = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ShakeWhiteEffectMinValue(RealStatePtr L)
        {
		    try {
                
			    ShaderWhiteEffect.ShakeWhiteEffectMinValue = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ShakeWhiteEffectMaxValue(RealStatePtr L)
        {
		    try {
                
			    ShaderWhiteEffect.ShakeWhiteEffectMaxValue = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
