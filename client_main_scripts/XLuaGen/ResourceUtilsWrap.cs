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
    public class ResourceUtilsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(ResourceUtils);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 12, 1, 1);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetResourceImagePath", _m_GetResourceImagePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetRewardTypeImagePath", _m_GetRewardTypeImagePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetRewardTypeName", _m_GetRewardTypeName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetResourceTypeCityBuildingByType", _m_GetResourceTypeCityBuildingByType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetResourcesTypeByCityBuildingType", _m_GetResourcesTypeByCityBuildingType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "RewardType2ResourceType", _m_RewardType2ResourceType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetBuildTabTypeByResourceType", _m_GetBuildTabTypeByResourceType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetResourceTypeByBuildTabType", _m_GetResourceTypeByBuildTabType_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ArmyConsume", _m_ArmyConsume_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetResourceItemCount", _m_GetResourceItemCount_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetOutBuildByResType", _m_GetOutBuildByResType_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "pairStorage", _g_get_pairStorage);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "pairStorage", _s_set_pairStorage);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new ResourceUtils();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to ResourceUtils constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourceImagePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    ResourceType _resType;translator.Get(L, 1, out _resType);
                    
                        var gen_ret = ResourceUtils.GetResourceImagePath( _resType );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRewardTypeImagePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _resType = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.GetRewardTypeImagePath( _resType );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRewardTypeName_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _resType = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.GetRewardTypeName( _resType );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourceTypeCityBuildingByType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    int _type = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.GetResourceTypeCityBuildingByType( _type );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourcesTypeByCityBuildingType_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _type = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.GetResourcesTypeByCityBuildingType( _type );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RewardType2ResourceType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    RewardType _rewardType;translator.Get(L, 1, out _rewardType);
                    
                        var gen_ret = ResourceUtils.RewardType2ResourceType( _rewardType );
                        translator.PushResourceType(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildTabTypeByResourceType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    ResourceType _type;translator.Get(L, 1, out _type);
                    
                        var gen_ret = ResourceUtils.GetBuildTabTypeByResourceType( _type );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourceTypeByBuildTabType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UIMainBottomBuildType _type;translator.Get(L, 1, out _type);
                    
                        var gen_ret = ResourceUtils.GetResourceTypeByBuildTabType( _type );
                        translator.PushResourceType(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ArmyConsume_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _resourcesType = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.ArmyConsume( _resourcesType );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourceItemCount_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _type = LuaAPI.xlua_tointeger(L, 1);
                    
                        var gen_ret = ResourceUtils.GetResourceItemCount( _type );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOutBuildByResType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    ResourceType _resourceType;translator.Get(L, 1, out _resourceType);
                    
                        var gen_ret = ResourceUtils.GetOutBuildByResType( _resourceType );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_pairStorage(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, ResourceUtils.pairStorage);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_pairStorage(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    ResourceUtils.pairStorage = (System.Collections.Generic.Dictionary<ResourceType, System.Collections.Generic.List<int>>)translator.GetObject(L, 1, typeof(System.Collections.Generic.Dictionary<ResourceType, System.Collections.Generic.List<int>>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
