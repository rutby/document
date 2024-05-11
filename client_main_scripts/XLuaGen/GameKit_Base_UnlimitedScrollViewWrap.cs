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
    public class GameKitBaseUnlimitedScrollViewWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameKit.Base.UnlimitedScrollView);
			Utils.BeginObjectRegister(type, L, translator, 0, 8, 11, 9);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Clear", _m_Clear);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItemWrapCount", _m_GetItemWrapCount);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItem", _m_GetItem);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItemWrap", _m_GetItemWrap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddItemWrap", _m_AddItemWrap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InsertItemWrap", _m_InsertItemWrap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveItemWrap", _m_RemoveItemWrap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddItemToTail", _m_AddItemToTail);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "HeadIndex", _g_get_HeadIndex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TailIndex", _g_get_TailIndex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ViewportSize", _g_get_ViewportSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ContentSize", _g_get_ContentSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ContentPosition", _g_get_ContentPosition);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Velocity", _g_get_Velocity);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "DragOnHeadOrTailOfTheScrollView", _g_get_DragOnHeadOrTailOfTheScrollView);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnPointerDownScrollView", _g_get_OnPointerDownScrollView);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnBeginDrag", _g_get_OnBeginDrag);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnItemMoveIn", _g_get_OnItemMoveIn);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnItemMoveOut", _g_get_OnItemMoveOut);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "ToHead", _s_set_ToHead);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ToTail", _s_set_ToTail);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ContentPosition", _s_set_ContentPosition);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Velocity", _s_set_Velocity);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "DragOnHeadOrTailOfTheScrollView", _s_set_DragOnHeadOrTailOfTheScrollView);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnPointerDownScrollView", _s_set_OnPointerDownScrollView);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnBeginDrag", _s_set_OnBeginDrag);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnItemMoveIn", _s_set_OnItemMoveIn);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnItemMoveOut", _s_set_OnItemMoveOut);
            
			
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
					
					var gen_ret = new GameKit.Base.UnlimitedScrollView();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.UnlimitedScrollView constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Clear(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Clear(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItemWrapCount(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetItemWrapCount(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    GameKit.Base.ItemWrap _wrap = (GameKit.Base.ItemWrap)translator.GetObject(L, 2, typeof(GameKit.Base.ItemWrap));
                    
                        var gen_ret = gen_to_be_invoked.GetItem( _wrap );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItemWrap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetItemWrap( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object _userdata = translator.GetObject(L, 2, typeof(object));
                    
                        var gen_ret = gen_to_be_invoked.GetItemWrap( _userdata );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.UnlimitedScrollView.GetItemWrap!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddItemWrap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _prefab = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    object _userdata = translator.GetObject(L, 3, typeof(object));
                    
                    gen_to_be_invoked.AddItemWrap( _prefab, _userdata );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InsertItemWrap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    UnityEngine.GameObject _prefab = (UnityEngine.GameObject)translator.GetObject(L, 3, typeof(UnityEngine.GameObject));
                    object _userdata = translator.GetObject(L, 4, typeof(object));
                    
                    gen_to_be_invoked.InsertItemWrap( _index, _prefab, _userdata );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveItemWrap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveItemWrap( _index );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object _userdata = translator.GetObject(L, 2, typeof(object));
                    
                    gen_to_be_invoked.RemoveItemWrap( _userdata );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to GameKit.Base.UnlimitedScrollView.RemoveItemWrap!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddItemToTail(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _prefab = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    object _userdata = translator.GetObject(L, 3, typeof(object));
                    
                    gen_to_be_invoked.AddItemToTail( _prefab, _userdata );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_HeadIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.HeadIndex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TailIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.TailIndex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ViewportSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.ViewportSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ContentSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.ContentSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ContentPosition(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.ContentPosition);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Velocity(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.Velocity);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DragOnHeadOrTailOfTheScrollView(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.DragOnHeadOrTailOfTheScrollView);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnPointerDownScrollView(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnPointerDownScrollView);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnBeginDrag(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnBeginDrag);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnItemMoveIn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnItemMoveIn);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnItemMoveOut(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnItemMoveOut);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ToHead(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ToHead = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ToTail(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.ToTail = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ContentPosition(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.ContentPosition = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Velocity(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.Velocity = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_DragOnHeadOrTailOfTheScrollView(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.DragOnHeadOrTailOfTheScrollView = translator.GetDelegate<GameKit.Base.UnlimitedScrollView.DragOnHeadOrTailOfTheScrollViewDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnPointerDownScrollView(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnPointerDownScrollView = translator.GetDelegate<GameKit.Base.UnlimitedScrollView.OnPointerDownScrollViewDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnBeginDrag(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnBeginDrag = translator.GetDelegate<GameKit.Base.UnlimitedScrollView.BeginDragDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnItemMoveIn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnItemMoveIn = translator.GetDelegate<GameKit.Base.UnlimitedScrollView.ItemMoveInDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnItemMoveOut(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GameKit.Base.UnlimitedScrollView gen_to_be_invoked = (GameKit.Base.UnlimitedScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnItemMoveOut = translator.GetDelegate<GameKit.Base.UnlimitedScrollView.ItemMoveOutDelegate>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
