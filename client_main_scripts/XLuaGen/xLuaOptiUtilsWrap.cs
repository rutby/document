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
    public class xLuaOptiUtilsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(xLuaOptiUtils);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 6, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Quaternion_LookRotation", _m_Quaternion_LookRotation_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Quaternion_RotateTowards", _m_Quaternion_RotateTowards_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Quaternion_ToEulerAngles", _m_Quaternion_ToEulerAngles_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Quaternion_EulerToQuat", _m_Quaternion_EulerToQuat_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Quaternion_MulVec3", _m_Quaternion_MulVec3_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "xLuaOptiUtils does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Quaternion_LookRotation_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _forwardX = (float)LuaAPI.lua_tonumber(L, 1);
                    float _forwardY = (float)LuaAPI.lua_tonumber(L, 2);
                    float _forwardZ = (float)LuaAPI.lua_tonumber(L, 3);
                    float _upX = (float)LuaAPI.lua_tonumber(L, 4);
                    float _upY = (float)LuaAPI.lua_tonumber(L, 5);
                    float _upZ = (float)LuaAPI.lua_tonumber(L, 6);
                    float _x;
                    float _y;
                    float _z;
                    float _w;
                    
                    xLuaOptiUtils.Quaternion_LookRotation( _forwardX, _forwardY, _forwardZ, _upX, _upY, _upZ, out _x, out _y, out _z, out _w );
                    LuaAPI.lua_pushnumber(L, _x);
                        
                    LuaAPI.lua_pushnumber(L, _y);
                        
                    LuaAPI.lua_pushnumber(L, _z);
                        
                    LuaAPI.lua_pushnumber(L, _w);
                        
                    
                    
                    
                    return 4;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Quaternion_RotateTowards_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _fromX = (float)LuaAPI.lua_tonumber(L, 1);
                    float _fromY = (float)LuaAPI.lua_tonumber(L, 2);
                    float _fromZ = (float)LuaAPI.lua_tonumber(L, 3);
                    float _fromW = (float)LuaAPI.lua_tonumber(L, 4);
                    float _toX = (float)LuaAPI.lua_tonumber(L, 5);
                    float _toY = (float)LuaAPI.lua_tonumber(L, 6);
                    float _toZ = (float)LuaAPI.lua_tonumber(L, 7);
                    float _toW = (float)LuaAPI.lua_tonumber(L, 8);
                    float _maxDegreesDelta = (float)LuaAPI.lua_tonumber(L, 9);
                    float _x;
                    float _y;
                    float _z;
                    float _w;
                    
                    xLuaOptiUtils.Quaternion_RotateTowards( _fromX, _fromY, _fromZ, _fromW, _toX, _toY, _toZ, _toW, _maxDegreesDelta, out _x, out _y, out _z, out _w );
                    LuaAPI.lua_pushnumber(L, _x);
                        
                    LuaAPI.lua_pushnumber(L, _y);
                        
                    LuaAPI.lua_pushnumber(L, _z);
                        
                    LuaAPI.lua_pushnumber(L, _w);
                        
                    
                    
                    
                    return 4;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Quaternion_ToEulerAngles_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _qX = (float)LuaAPI.lua_tonumber(L, 1);
                    float _qY = (float)LuaAPI.lua_tonumber(L, 2);
                    float _qZ = (float)LuaAPI.lua_tonumber(L, 3);
                    float _qW = (float)LuaAPI.lua_tonumber(L, 4);
                    float _x;
                    float _y;
                    float _z;
                    
                    xLuaOptiUtils.Quaternion_ToEulerAngles( _qX, _qY, _qZ, _qW, out _x, out _y, out _z );
                    LuaAPI.lua_pushnumber(L, _x);
                        
                    LuaAPI.lua_pushnumber(L, _y);
                        
                    LuaAPI.lua_pushnumber(L, _z);
                        
                    
                    
                    
                    return 3;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Quaternion_EulerToQuat_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 1);
                    float _y = (float)LuaAPI.lua_tonumber(L, 2);
                    float _z = (float)LuaAPI.lua_tonumber(L, 3);
                    float _qx;
                    float _qy;
                    float _qz;
                    float _qw;
                    
                    xLuaOptiUtils.Quaternion_EulerToQuat( _x, _y, _z, out _qx, out _qy, out _qz, out _qw );
                    LuaAPI.lua_pushnumber(L, _qx);
                        
                    LuaAPI.lua_pushnumber(L, _qy);
                        
                    LuaAPI.lua_pushnumber(L, _qz);
                        
                    LuaAPI.lua_pushnumber(L, _qw);
                        
                    
                    
                    
                    return 4;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Quaternion_MulVec3_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    float _qX = (float)LuaAPI.lua_tonumber(L, 1);
                    float _qY = (float)LuaAPI.lua_tonumber(L, 2);
                    float _qZ = (float)LuaAPI.lua_tonumber(L, 3);
                    float _qW = (float)LuaAPI.lua_tonumber(L, 4);
                    float _vX = (float)LuaAPI.lua_tonumber(L, 5);
                    float _vY = (float)LuaAPI.lua_tonumber(L, 6);
                    float _vZ = (float)LuaAPI.lua_tonumber(L, 7);
                    float _x;
                    float _y;
                    float _z;
                    
                    xLuaOptiUtils.Quaternion_MulVec3( _qX, _qY, _qZ, _qW, _vX, _vY, _vZ, out _x, out _y, out _z );
                    LuaAPI.lua_pushnumber(L, _x);
                        
                    LuaAPI.lua_pushnumber(L, _y);
                        
                    LuaAPI.lua_pushnumber(L, _z);
                        
                    
                    
                    
                    return 3;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
