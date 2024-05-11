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
    public class UIGoodsFlyWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIGoodsFly);
			Utils.BeginObjectRegister(type, L, translator, 0, 3, 14, 14);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoAnimForLua", _m_DoAnimForLua);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoAnim", _m_DoAnim);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DoAnimBox", _m_DoAnimBox);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "isRun", _g_get_isRun);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "targetPos", _g_get_targetPos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "minSize", _g_get_minSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "maxSize", _g_get_maxSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isReset", _g_get_isReset);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "oldPos", _g_get_oldPos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "moveTime", _g_get_moveTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "firstCurve", _g_get_firstCurve);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "secondCurve", _g_get_secondCurve);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "thirdCurve", _g_get_thirdCurve);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "controlPointOffset", _g_get_controlPointOffset);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "img", _g_get_img);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "txt", _g_get_txt);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "middleValue", _g_get_middleValue);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "isRun", _s_set_isRun);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "targetPos", _s_set_targetPos);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "minSize", _s_set_minSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "maxSize", _s_set_maxSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isReset", _s_set_isReset);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "oldPos", _s_set_oldPos);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "moveTime", _s_set_moveTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "firstCurve", _s_set_firstCurve);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "secondCurve", _s_set_secondCurve);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "thirdCurve", _s_set_thirdCurve);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "controlPointOffset", _s_set_controlPointOffset);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "img", _s_set_img);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "txt", _s_set_txt);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "middleValue", _s_set_middleValue);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 3, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Bezier2", _m_Bezier2_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Bezier3", _m_Bezier3_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new UIGoodsFly();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UIGoodsFly constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoAnimForLua(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _minRange = (float)LuaAPI.lua_tonumber(L, 2);
                    float _maxRange = (float)LuaAPI.lua_tonumber(L, 3);
                    int _rewardType = LuaAPI.xlua_tointeger(L, 4);
                    string _pic = LuaAPI.lua_tostring(L, 5);
                    int _num = LuaAPI.xlua_tointeger(L, 6);
                    UnityEngine.Vector3 _destPos;translator.Get(L, 7, out _destPos);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 8);
                    
                    gen_to_be_invoked.DoAnimForLua( _minRange, _maxRange, _rewardType, _pic, _num, _destPos, _onComplete );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoAnim(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<UnityEngine.Vector3>(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& translator.Assignable<System.Action>(L, 6)) 
                {
                    float _minRange = (float)LuaAPI.lua_tonumber(L, 2);
                    float _maxRange = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.Vector3 _destPos;translator.Get(L, 4, out _destPos);
                    UnityEngine.Vector3 _startPos;translator.Get(L, 5, out _startPos);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 6);
                    
                    gen_to_be_invoked.DoAnim( _minRange, _maxRange, _destPos, _startPos, _onComplete );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& (LuaAPI.lua_isnil(L, 5) || LuaAPI.lua_type(L, 5) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.Vector3>(L, 6)&& translator.Assignable<System.Action>(L, 7)) 
                {
                    float _minRange = (float)LuaAPI.lua_tonumber(L, 2);
                    float _maxRange = (float)LuaAPI.lua_tonumber(L, 3);
                    int _rewardType = LuaAPI.xlua_tointeger(L, 4);
                    string _pic = LuaAPI.lua_tostring(L, 5);
                    UnityEngine.Vector3 _destPos;translator.Get(L, 6, out _destPos);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 7);
                    
                    gen_to_be_invoked.DoAnim( _minRange, _maxRange, _rewardType, _pic, _destPos, _onComplete );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 8&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& (LuaAPI.lua_isnil(L, 5) || LuaAPI.lua_type(L, 5) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& translator.Assignable<UnityEngine.Vector3>(L, 7)&& translator.Assignable<System.Action>(L, 8)) 
                {
                    float _minRange = (float)LuaAPI.lua_tonumber(L, 2);
                    float _maxRange = (float)LuaAPI.lua_tonumber(L, 3);
                    int _rewardType = LuaAPI.xlua_tointeger(L, 4);
                    string _pic = LuaAPI.lua_tostring(L, 5);
                    int _num = LuaAPI.xlua_tointeger(L, 6);
                    UnityEngine.Vector3 _destPos;translator.Get(L, 7, out _destPos);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 8);
                    
                    gen_to_be_invoked.DoAnim( _minRange, _maxRange, _rewardType, _pic, _num, _destPos, _onComplete );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIGoodsFly.DoAnim!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DoAnimBox(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _minRange = (float)LuaAPI.lua_tonumber(L, 2);
                    float _maxRange = (float)LuaAPI.lua_tonumber(L, 3);
                    UnityEngine.Vector3 _startPos;translator.Get(L, 4, out _startPos);
                    UnityEngine.Vector3 _destPos;translator.Get(L, 5, out _destPos);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 6);
                    
                    gen_to_be_invoked.DoAnimBox( _minRange, _maxRange, _startPos, _destPos, _onComplete );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Bezier2_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector3 _startPos;translator.Get(L, 1, out _startPos);
                    UnityEngine.Vector3 _controlPos;translator.Get(L, 2, out _controlPos);
                    UnityEngine.Vector3 _endPos;translator.Get(L, 3, out _endPos);
                    float _t = (float)LuaAPI.lua_tonumber(L, 4);
                    
                        var gen_ret = UIGoodsFly.Bezier2( _startPos, _controlPos, _endPos, _t );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Bezier3_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector3 _startPos;translator.Get(L, 1, out _startPos);
                    UnityEngine.Vector3 _controlPos1;translator.Get(L, 2, out _controlPos1);
                    UnityEngine.Vector3 _controlPos2;translator.Get(L, 3, out _controlPos2);
                    UnityEngine.Vector3 _endPos;translator.Get(L, 4, out _endPos);
                    float _t = (float)LuaAPI.lua_tonumber(L, 5);
                    
                        var gen_ret = UIGoodsFly.Bezier3( _startPos, _controlPos1, _controlPos2, _endPos, _t );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isRun(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isRun);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_targetPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.targetPos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_minSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.minSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_maxSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.maxSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isReset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isReset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_oldPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.oldPos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_moveTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.moveTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_firstCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.firstCurve);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_secondCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.secondCurve);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_thirdCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.thirdCurve);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_controlPointOffset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.controlPointOffset);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_img(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.img);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_txt(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.txt);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_middleValue(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.middleValue);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isRun(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isRun = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_targetPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.targetPos = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_minSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.minSize = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_maxSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.maxSize = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isReset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isReset = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_oldPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.oldPos = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_moveTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.moveTime = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_firstCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.firstCurve = (UnityEngine.AnimationCurve)translator.GetObject(L, 2, typeof(UnityEngine.AnimationCurve));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_secondCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.secondCurve = (UnityEngine.AnimationCurve)translator.GetObject(L, 2, typeof(UnityEngine.AnimationCurve));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_thirdCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.thirdCurve = (UnityEngine.AnimationCurve)translator.GetObject(L, 2, typeof(UnityEngine.AnimationCurve));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_controlPointOffset(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.controlPointOffset = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_img(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.img = (UnityEngine.UI.Image)translator.GetObject(L, 2, typeof(UnityEngine.UI.Image));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_txt(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.txt = (UnityEngine.UI.Text)translator.GetObject(L, 2, typeof(UnityEngine.UI.Text));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_middleValue(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                UIGoodsFly gen_to_be_invoked = (UIGoodsFly)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.middleValue = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
