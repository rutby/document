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
    public class WorldTroopLineWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(WorldTroopLine);
			Utils.BeginObjectRegister(type, L, translator, 0, 9, 0, 0);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FadeIn", _m_FadeIn);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FadeOut", _m_FadeOut);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsFadeOutFinish", _m_IsFadeOutFinish);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetDragPath", _m_SetDragPath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetMovePath", _m_SetMovePath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartMove", _m_StartMove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetStraightMovePath", _m_SetStraightMovePath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetColor", _m_SetColor);
			
			
			
			
			
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
					
					var gen_ret = new WorldTroopLine();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to WorldTroopLine constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Clear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FadeIn(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.FadeIn(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FadeOut(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.FadeOut(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsFadeOutFinish(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.IsFadeOutFinish(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetDragPath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _start;translator.Get(L, 2, out _start);
                    UnityEngine.Vector3 _end;translator.Get(L, 3, out _end);
                    
                    gen_to_be_invoked.SetDragPath( _start, _end );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMovePath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& translator.Assignable<WorldTroopPathSegment[]>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 2, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 3);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 4, out _currPos);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 5);
                    bool _needRefresh = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.SetMovePath( _path, _currPath, _currPos, _realTargetPos, _needRefresh );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<WorldTroopPathSegment[]>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 2, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 3);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 4, out _currPos);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.SetMovePath( _path, _currPath, _currPos, _realTargetPos );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<WorldTroopPathSegment[]>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)) 
                {
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 2, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 3);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 4, out _currPos);
                    
                    gen_to_be_invoked.SetMovePath( _path, _currPath, _currPos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to WorldTroopLine.SetMovePath!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartMove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _tarPos = LuaAPI.xlua_tointeger(L, 2);
                    string _strPath = LuaAPI.lua_tostring(L, 3);
                    float _speed = (float)LuaAPI.lua_tonumber(L, 4);
                    long _blackST = LuaAPI.lua_toint64(L, 5);
                    long _blackET = LuaAPI.lua_toint64(L, 6);
                    long _sTime = LuaAPI.lua_toint64(L, 7);
                    long _eTime = LuaAPI.lua_toint64(L, 8);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 9);
                    
                    gen_to_be_invoked.StartMove( _tarPos, _strPath, _speed, _blackST, _blackET, _sTime, _eTime, _realTargetPos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetStraightMovePath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _startPos;translator.Get(L, 2, out _startPos);
                    UnityEngine.Vector3 _endPos;translator.Get(L, 3, out _endPos);
                    
                    gen_to_be_invoked.SetStraightMovePath( _startPos, _endPos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetColor(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                WorldTroopLine gen_to_be_invoked = (WorldTroopLine)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Color _color;translator.Get(L, 2, out _color);
                    
                    gen_to_be_invoked.SetColor( _color );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
