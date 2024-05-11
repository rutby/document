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
    public class LWCountBattleSteerGroupWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(LW.CountBattle.SteerGroup);
			Utils.BeginObjectRegister(type, L, translator, 0, 12, 26, 18);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPosX", _m_SetPosX);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPosY", _m_SetPosY);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPosXZ", _m_SetPosXZ);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetPos", _m_SetPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetVelocity", _m_SetVelocity);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddTrapCollider", _m_AddTrapCollider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FindTrapCollider", _m_FindTrapCollider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateTrapCollider", _m_UpdateTrapCollider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveTrapCollider", _m_RemoveTrapCollider);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Spawn", _m_Spawn);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveUnit", _m_RemoveUnit);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Vibrate", _m_Vibrate);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupPoint", _g_get_GroupPoint);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupCircle", _g_get_GroupCircle);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupRadius", _g_get_GroupRadius);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupBoundLeft", _g_get_GroupBoundLeft);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupBoundRight", _g_get_GroupBoundRight);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupBoundTop", _g_get_GroupBoundTop);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupBoundBottom", _g_get_GroupBoundBottom);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupBoundBox", _g_get_GroupBoundBox);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "UnitCount", _g_get_UnitCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "DisableLogic", _g_get_DisableLogic);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "RepSwitch", _g_get_RepSwitch);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AttSwitch", _g_get_AttSwitch);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupPos", _g_get_GroupPos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupPosX", _g_get_GroupPosX);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupPosY", _g_get_GroupPosY);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "GroupPosZ", _g_get_GroupPosZ);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Units", _g_get_Units);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "EngageGroup", _g_get_EngageGroup);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "groupTag", _g_get_groupTag);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "spawnPerSecond", _g_get_spawnPerSecond);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "repForceFactor", _g_get_repForceFactor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "attForceFactor", _g_get_attForceFactor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnUnitSpawn", _g_get_OnUnitSpawn);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnUnitRemoved", _g_get_OnUnitRemoved);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnGroupPointChanged", _g_get_OnGroupPointChanged);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnCollideTrap", _g_get_OnCollideTrap);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupPoint", _s_set_GroupPoint);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupCircle", _s_set_GroupCircle);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupBoundLeft", _s_set_GroupBoundLeft);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupBoundRight", _s_set_GroupBoundRight);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupBoundTop", _s_set_GroupBoundTop);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "GroupBoundBottom", _s_set_GroupBoundBottom);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "DisableLogic", _s_set_DisableLogic);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "RepSwitch", _s_set_RepSwitch);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "AttSwitch", _s_set_AttSwitch);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "EngageGroup", _s_set_EngageGroup);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "groupTag", _s_set_groupTag);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "spawnPerSecond", _s_set_spawnPerSecond);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "repForceFactor", _s_set_repForceFactor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "attForceFactor", _s_set_attForceFactor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnUnitSpawn", _s_set_OnUnitSpawn);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnUnitRemoved", _s_set_OnUnitRemoved);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnGroupPointChanged", _s_set_OnGroupPointChanged);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnCollideTrap", _s_set_OnCollideTrap);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 1, 1);
			
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "TICK_INTERVAL", _g_get_TICK_INTERVAL);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "TICK_INTERVAL", _s_set_TICK_INTERVAL);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new LW.CountBattle.SteerGroup();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to LW.CountBattle.SteerGroup constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPosX(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetPosX( _x );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPosY(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _y = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetPosY( _y );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPosXZ(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _z = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.SetPosXZ( _x, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.SetPos( _x, _y, _z );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetVelocity(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _vx = (float)LuaAPI.lua_tonumber(L, 2);
                    float _vz = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.SetVelocity( _vx, _vz );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddTrapCollider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _id = LuaAPI.xlua_tointeger(L, 2);
                    UnityEngine.Collider _collider = (UnityEngine.Collider)translator.GetObject(L, 3, typeof(UnityEngine.Collider));
                    
                        var gen_ret = gen_to_be_invoked.AddTrapCollider( _id, _collider );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FindTrapCollider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _id = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.FindTrapCollider( _id );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateTrapCollider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _id = LuaAPI.xlua_tointeger(L, 2);
                    float _x = (float)LuaAPI.lua_tonumber(L, 3);
                    float _z = (float)LuaAPI.lua_tonumber(L, 4);
                    float _angle = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    gen_to_be_invoked.UpdateTrapCollider( _id, _x, _z, _angle );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& translator.Assignable<UnityEngine.Collider>(L, 3)) 
                {
                    int _id = LuaAPI.xlua_tointeger(L, 2);
                    UnityEngine.Collider _collider = (UnityEngine.Collider)translator.GetObject(L, 3, typeof(UnityEngine.Collider));
                    
                    gen_to_be_invoked.UpdateTrapCollider( _id, _collider );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to LW.CountBattle.SteerGroup.UpdateTrapCollider!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveTrapCollider(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _id = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveTrapCollider( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Spawn(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _amount = LuaAPI.xlua_tointeger(L, 2);
                    int _point = LuaAPI.xlua_tointeger(L, 3);
                    float _radius = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.Spawn( _amount, _point, _radius );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveUnit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    LW.CountBattle.SteerUnit _unit = (LW.CountBattle.SteerUnit)translator.GetObject(L, 2, typeof(LW.CountBattle.SteerUnit));
                    
                    gen_to_be_invoked.RemoveUnit( _unit );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Vibrate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Vibrate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.GroupPoint);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupCircle(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.GroupCircle);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupRadius(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupRadius);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupBoundLeft(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupBoundLeft);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupBoundRight(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupBoundRight);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupBoundTop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupBoundTop);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupBoundBottom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupBoundBottom);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupBoundBox(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.GroupBoundBox);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_UnitCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.UnitCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DisableLogic(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.DisableLogic);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_RepSwitch(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.RepSwitch);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AttSwitch(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.AttSwitch);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.GroupPos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupPosX(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupPosX);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupPosY(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupPosY);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GroupPosZ(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.GroupPosZ);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Units(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Units);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_EngageGroup(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.EngageGroup);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TICK_INTERVAL(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, LW.CountBattle.SteerGroup.TICK_INTERVAL);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_groupTag(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.groupTag);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_spawnPerSecond(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.spawnPerSecond);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_repForceFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.repForceFactor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_attForceFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.attForceFactor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnUnitSpawn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnUnitSpawn);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnUnitRemoved(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnUnitRemoved);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnGroupPointChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnGroupPointChanged);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnCollideTrap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnCollideTrap);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupPoint(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupPoint = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupCircle(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupCircle = (LW.CountBattle.Circle)translator.GetObject(L, 2, typeof(LW.CountBattle.Circle));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupBoundLeft(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupBoundLeft = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupBoundRight(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupBoundRight = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupBoundTop(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupBoundTop = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GroupBoundBottom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.GroupBoundBottom = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DisableLogic(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.DisableLogic = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_RepSwitch(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.RepSwitch = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_AttSwitch(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.AttSwitch = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_EngageGroup(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.EngageGroup = (LW.CountBattle.SteerGroup)translator.GetObject(L, 2, typeof(LW.CountBattle.SteerGroup));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TICK_INTERVAL(RealStatePtr L)
        {
		    try {
                
			    LW.CountBattle.SteerGroup.TICK_INTERVAL = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_groupTag(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.groupTag = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_spawnPerSecond(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.spawnPerSecond = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_repForceFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.repForceFactor = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_attForceFactor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.attForceFactor = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnUnitSpawn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnUnitSpawn = translator.GetDelegate<System.Action<int, LW.CountBattle.SteerUnit>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnUnitRemoved(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnUnitRemoved = translator.GetDelegate<System.Action<int>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnGroupPointChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnGroupPointChanged = translator.GetDelegate<System.Action<int>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnCollideTrap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                LW.CountBattle.SteerGroup gen_to_be_invoked = (LW.CountBattle.SteerGroup)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnCollideTrap = translator.GetDelegate<System.Action<int, int>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
