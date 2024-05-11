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
    public class PathUtilsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(PathUtils);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 8, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetBuildingNeighbors", _m_GetBuildingNeighbors_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetNeighborDir", _m_GetNeighborDir_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetSortedBuildingNeighbors", _m_GetSortedBuildingNeighbors_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "StringToPathInfos", _m_StringToPathInfos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "StringToPoint", _m_StringToPoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetNearestMainOutPos", _m_GetNearestMainOutPos_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetTruckPathMainOutPosList", _m_GetTruckPathMainOutPosList_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new PathUtils();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to PathUtils constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildingNeighbors_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1) || LuaAPI.lua_isint64(L, 1))) 
                {
                    long _buildUuid = LuaAPI.lua_toint64(L, 1);
                    
                        var gen_ret = PathUtils.GetBuildingNeighbors( _buildUuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _itemId = LuaAPI.xlua_tointeger(L, 1);
                    int _pointId = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = PathUtils.GetBuildingNeighbors( _itemId, _pointId );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& translator.Assignable<LuaBuildData>(L, 1)) 
                {
                    LuaBuildData _buildingDate = (LuaBuildData)translator.GetObject(L, 1, typeof(LuaBuildData));
                    System.Collections.Generic.List<UnityEngine.Vector2Int> _entries;
                    
                        var gen_ret = PathUtils.GetBuildingNeighbors( _buildingDate, out _entries );
                        translator.Push(L, gen_ret);
                    translator.Push(L, _entries);
                        
                    
                    
                    
                    return 2;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PathUtils.GetBuildingNeighbors!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetNeighborDir_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector2Int _pos;translator.Get(L, 1, out _pos);
                    UnityEngine.Vector2Int _buildPos;translator.Get(L, 2, out _buildPos);
                    int _tiles = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = PathUtils.GetNeighborDir( _pos, _buildPos, _tiles );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSortedBuildingNeighbors_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 1)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<UnityEngine.Vector2Int>(L, 3)) 
                {
                    int _itemId = LuaAPI.xlua_tointeger(L, 1);
                    int _pointId = LuaAPI.xlua_tointeger(L, 2);
                    UnityEngine.Vector2Int _startPos;translator.Get(L, 3, out _startPos);
                    
                        var gen_ret = PathUtils.GetSortedBuildingNeighbors( _itemId, _pointId, _startPos );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& translator.Assignable<LuaBuildData>(L, 1)&& translator.Assignable<UnityEngine.Vector2Int>(L, 2)&& translator.Assignable<UnityEngine.Vector2Int[]>(L, 3)) 
                {
                    LuaBuildData _buildingDate = (LuaBuildData)translator.GetObject(L, 1, typeof(LuaBuildData));
                    UnityEngine.Vector2Int _startPos;translator.Get(L, 2, out _startPos);
                    UnityEngine.Vector2Int[] _neighbors = (UnityEngine.Vector2Int[])translator.GetObject(L, 3, typeof(UnityEngine.Vector2Int[]));
                    
                        var gen_ret = PathUtils.GetSortedBuildingNeighbors( _buildingDate, _startPos, _neighbors );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PathUtils.GetSortedBuildingNeighbors!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StringToPathInfos_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _pathStr = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = PathUtils.StringToPathInfos( _pathStr );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StringToPoint_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _pathStr = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = PathUtils.StringToPoint( _pathStr );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetNearestMainOutPos_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector2Int _targetPos;translator.Get(L, 1, out _targetPos);
                    
                        var gen_ret = PathUtils.GetNearestMainOutPos( _targetPos );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTruckPathMainOutPosList_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 0) 
                {
                    
                        var gen_ret = PathUtils.GetTruckPathMainOutPosList(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 0) 
                {
                    System.Collections.Generic.List<UnityEngine.Vector2Int> _entries;
                    
                        var gen_ret = PathUtils.GetTruckPathMainOutPosList( out _entries );
                        translator.Push(L, gen_ret);
                    translator.Push(L, _entries);
                        
                    
                    
                    
                    return 2;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to PathUtils.GetTruckPathMainOutPosList!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
