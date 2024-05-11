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
    public class MopsicusPluginsMobileInputFieldWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Mopsicus.Plugins.MobileInputField);
			Utils.BeginObjectRegister(type, L, translator, 0, 7, 11, 9);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUnityInputEnabled", _m_SetUnityInputEnabled);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Send", _m_Send);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Hide", _m_Hide);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetIngoreFocus", _m_SetIngoreFocus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRectNative", _m_SetRectNative);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetFocus", _m_SetFocus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetVisible", _m_SetVisible);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "InputField", _g_get_InputField);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Visible", _g_get_Visible);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Text", _g_get_Text);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CustomFont", _g_get_CustomFont);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsManualHideControl", _g_get_IsManualHideControl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsWithDoneButton", _g_get_IsWithDoneButton);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsWithClearButton", _g_get_IsWithClearButton);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "ReturnKey", _g_get_ReturnKey);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnReturnPressed", _g_get_OnReturnPressed);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnFocusChanged", _g_get_OnFocusChanged);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "OnReturnPressedEvent", _g_get_OnReturnPressedEvent);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "Text", _s_set_Text);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "CustomFont", _s_set_CustomFont);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "IsManualHideControl", _s_set_IsManualHideControl);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "IsWithDoneButton", _s_set_IsWithDoneButton);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "IsWithClearButton", _s_set_IsWithClearButton);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "ReturnKey", _s_set_ReturnKey);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnReturnPressed", _s_set_OnReturnPressed);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnFocusChanged", _s_set_OnFocusChanged);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "OnReturnPressedEvent", _s_set_OnReturnPressedEvent);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 2, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetScreenRectFromRectTransform", _m_GetScreenRectFromRectTransform_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new Mopsicus.Plugins.MobileInputField();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Mopsicus.Plugins.MobileInputField constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUnityInputEnabled(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _enabled = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetUnityInputEnabled( _enabled );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetScreenRectFromRectTransform_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.RectTransform _rect = (UnityEngine.RectTransform)translator.GetObject(L, 1, typeof(UnityEngine.RectTransform));
                    
                        var gen_ret = Mopsicus.Plugins.MobileInputField.GetScreenRectFromRectTransform( _rect );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Send(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    NiceJson.JsonObject _data = (NiceJson.JsonObject)translator.GetObject(L, 2, typeof(NiceJson.JsonObject));
                    
                    gen_to_be_invoked.Send( _data );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Hide(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Hide(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetIngoreFocus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _focus = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetIngoreFocus( _focus );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetRectNative(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.RectTransform _inputRect = (UnityEngine.RectTransform)translator.GetObject(L, 2, typeof(UnityEngine.RectTransform));
                    
                    gen_to_be_invoked.SetRectNative( _inputRect );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetFocus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isFocus = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetFocus( _isFocus );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetVisible(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isVisible = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetVisible( _isVisible );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_InputField(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.InputField);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Visible(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.Visible);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Text(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.Text);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CustomFont(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.CustomFont);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsManualHideControl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsManualHideControl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsWithDoneButton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsWithDoneButton);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsWithClearButton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsWithClearButton);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ReturnKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.ReturnKey);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnReturnPressed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnReturnPressed);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnFocusChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnFocusChanged);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OnReturnPressedEvent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.OnReturnPressedEvent);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Text(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Text = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CustomFont(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.CustomFont = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsManualHideControl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IsManualHideControl = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsWithDoneButton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IsWithDoneButton = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsWithClearButton(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IsWithClearButton = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ReturnKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                Mopsicus.Plugins.MobileInputField.ReturnKeyType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.ReturnKey = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnReturnPressed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnReturnPressed = translator.GetDelegate<System.Action>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnFocusChanged(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnFocusChanged = translator.GetDelegate<System.Action<bool>>(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OnReturnPressedEvent(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Mopsicus.Plugins.MobileInputField gen_to_be_invoked = (Mopsicus.Plugins.MobileInputField)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.OnReturnPressedEvent = (UnityEngine.Events.UnityEvent)translator.GetObject(L, 2, typeof(UnityEngine.Events.UnityEvent));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
