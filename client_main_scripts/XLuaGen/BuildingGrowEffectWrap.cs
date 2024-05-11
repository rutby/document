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
    public class BuildingGrowEffectWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(BuildingGrowEffect);
			Utils.BeginObjectRegister(type, L, translator, 0, 10, 3, 3);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartBuild", _m_StartBuild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisappearBuild", _m_DisappearBuild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowNormal", _m_ShowNormal);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowBuildGridSelection", _m_ShowBuildGridSelection);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowCanPlace", _m_ShowCanPlace);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetHeight", _m_GetHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EndAnim", _m_EndAnim);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetAlphaValue", _m_SetAlphaValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsUseFakeShadow", _m_IsUseFakeShadow);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRendererMaterials", _m_SetRendererMaterials);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "isWorking", _g_get_isWorking);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isHiding", _g_get_isHiding);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ProgressTime", _g_get_ProgressTime);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "isWorking", _s_set_isWorking);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isHiding", _s_set_isHiding);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ProgressTime", _s_set_ProgressTime);
            
			
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
					
					var gen_ret = new BuildingGrowEffect();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to BuildingGrowEffect constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartBuild(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 10&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& (LuaAPI.lua_isnil(L, 7) || LuaAPI.lua_type(L, 7) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 8)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 9)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 10)) 
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _buildId = LuaAPI.xlua_tointeger(L, 3);
                    int _startTime = LuaAPI.xlua_tointeger(L, 4);
                    int _endTime = LuaAPI.xlua_tointeger(L, 5);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 6);
                    string _ownerUid = LuaAPI.lua_tostring(L, 7);
                    bool _isDomeUpdate = LuaAPI.lua_toboolean(L, 8);
                    bool _isShowRobet = LuaAPI.lua_toboolean(L, 9);
                    bool _needGridAlpha = LuaAPI.lua_toboolean(L, 10);
                    
                    gen_to_be_invoked.StartBuild( _uuid, _buildId, _startTime, _endTime, _tileSize, _ownerUid, _isDomeUpdate, _isShowRobet, _needGridAlpha );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 9&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& (LuaAPI.lua_isnil(L, 7) || LuaAPI.lua_type(L, 7) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 8)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 9)) 
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _buildId = LuaAPI.xlua_tointeger(L, 3);
                    int _startTime = LuaAPI.xlua_tointeger(L, 4);
                    int _endTime = LuaAPI.xlua_tointeger(L, 5);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 6);
                    string _ownerUid = LuaAPI.lua_tostring(L, 7);
                    bool _isDomeUpdate = LuaAPI.lua_toboolean(L, 8);
                    bool _isShowRobet = LuaAPI.lua_toboolean(L, 9);
                    
                    gen_to_be_invoked.StartBuild( _uuid, _buildId, _startTime, _endTime, _tileSize, _ownerUid, _isDomeUpdate, _isShowRobet );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 8&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& (LuaAPI.lua_isnil(L, 7) || LuaAPI.lua_type(L, 7) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 8)) 
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _buildId = LuaAPI.xlua_tointeger(L, 3);
                    int _startTime = LuaAPI.xlua_tointeger(L, 4);
                    int _endTime = LuaAPI.xlua_tointeger(L, 5);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 6);
                    string _ownerUid = LuaAPI.lua_tostring(L, 7);
                    bool _isDomeUpdate = LuaAPI.lua_toboolean(L, 8);
                    
                    gen_to_be_invoked.StartBuild( _uuid, _buildId, _startTime, _endTime, _tileSize, _ownerUid, _isDomeUpdate );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& (LuaAPI.lua_isnil(L, 7) || LuaAPI.lua_type(L, 7) == LuaTypes.LUA_TSTRING)) 
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _buildId = LuaAPI.xlua_tointeger(L, 3);
                    int _startTime = LuaAPI.xlua_tointeger(L, 4);
                    int _endTime = LuaAPI.xlua_tointeger(L, 5);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 6);
                    string _ownerUid = LuaAPI.lua_tostring(L, 7);
                    
                    gen_to_be_invoked.StartBuild( _uuid, _buildId, _startTime, _endTime, _tileSize, _ownerUid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to BuildingGrowEffect.StartBuild!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisappearBuild(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _buildId = LuaAPI.xlua_tointeger(L, 3);
                    int _startTime = LuaAPI.xlua_tointeger(L, 4);
                    int _endTime = LuaAPI.xlua_tointeger(L, 5);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 6);
                    string _ownerUid = LuaAPI.lua_tostring(L, 7);
                    
                    gen_to_be_invoked.DisappearBuild( _uuid, _buildId, _startTime, _endTime, _tileSize, _ownerUid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowNormal(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<PlayerType>(L, 2)) 
                {
                    PlayerType _playType;translator.Get(L, 2, out _playType);
                    
                    gen_to_be_invoked.ShowNormal( _playType );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.ShowNormal(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to BuildingGrowEffect.ShowNormal!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowBuildGridSelection(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ShowBuildGridSelection(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowCanPlace(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _canPlace = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.ShowCanPlace( _canPlace );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetHeight(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EndAnim(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.EndAnim(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetAlphaValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _alpha = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetAlphaValue( _alpha );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsUseFakeShadow(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.IsUseFakeShadow(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetRendererMaterials(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.SetRendererMaterials(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isWorking(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isWorking);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isHiding(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isHiding);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ProgressTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.ProgressTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isWorking(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isWorking = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isHiding(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isHiding = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ProgressTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                BuildingGrowEffect gen_to_be_invoked = (BuildingGrowEffect)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ProgressTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
