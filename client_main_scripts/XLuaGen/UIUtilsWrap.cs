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
    public class UIUtilsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UIUtils);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 30, 1, 1);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "GetSpecialScreenWidth", _m_GetSpecialScreenWidth_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsPhone", _m_IsPhone_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AddChildManually", _m_AddChildManually_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CheckGuiRaycastObjects", _m_CheckGuiRaycastObjects_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetGuiRaycastObjects", _m_GetGuiRaycastObjects_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowMessage", _m_ShowMessage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowMessages", _m_ShowMessages_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "NewShowMessage", _m_NewShowMessage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowReloadMessage", _m_ShowReloadMessage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowLoadingMask", _m_ShowLoadingMask_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "HideLoadingMask", _m_HideLoadingMask_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowTips", _m_ShowTips_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowLackResource", _m_ShowLackResource_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ShowRankView", _m_ShowRankView_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "WordToScenePoint", _m_WordToScenePoint_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ScreenPointToLocalPointInRectangle", _m_ScreenPointToLocalPointInRectangle_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "BuildSkeletonDataAsset", _m_BuildSkeletonDataAsset_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "checkUserName", _m_checkUserName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "checkPwd", _m_checkPwd_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "getAccountBindStateName", _m_getAccountBindStateName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "getIM30AccountBindStateName", _m_getIM30AccountBindStateName_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "getAccountBindState", _m_getAccountBindState_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AccountNeedBind", _m_AccountNeedBind_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFirstChild", _m_GetFirstChild_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SetTextWithImage", _m_SetTextWithImage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPosAtText", _m_GetPosAtText_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "PlayAnimationReturnTime", _m_PlayAnimationReturnTime_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetCurScreenMaxRadiusSize", _m_GetCurScreenMaxRadiusSize_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetBuildPointByMeteoriteHitGlass", _m_GetBuildPointByMeteoriteHitGlass_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "tmpWidth", _g_get_tmpWidth);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "tmpWidth", _s_set_tmpWidth);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "UIUtils does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSpecialScreenWidth_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.GetSpecialScreenWidth(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsPhone_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.IsPhone(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddChildManually_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Transform _parent = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    UnityEngine.Transform _child = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
                    
                    UIUtils.AddChildManually( _parent, _child );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckGuiRaycastObjects_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 0) 
                {
                    
                        var gen_ret = UIUtils.CheckGuiRaycastObjects(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& translator.Assignable<UnityEngine.Vector2>(L, 1)) 
                {
                    UnityEngine.Vector2 _mousePos;translator.Get(L, 1, out _mousePos);
                    
                        var gen_ret = UIUtils.CheckGuiRaycastObjects( _mousePos );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.CheckGuiRaycastObjects!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGuiRaycastObjects_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector2 _mousePos;translator.Get(L, 1, out _mousePos);
                    
                        var gen_ret = UIUtils.GetGuiRaycastObjects( _mousePos );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowMessage_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    bool _isChangeImg = LuaAPI.lua_toboolean(L, 4);
                    
                    UIUtils.ShowMessage( _message, _confirmAction, _cancelAction, _isChangeImg );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    
                    UIUtils.ShowMessage( _message, _confirmAction, _cancelAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    
                    UIUtils.ShowMessage( _message, _confirmAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)&& translator.Assignable<System.Action>(L, 6)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 7)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _confirmText = LuaAPI.lua_tostring(L, 3);
                    string _cancelText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 6);
                    bool _isChangeImg = LuaAPI.lua_toboolean(L, 7);
                    
                    UIUtils.ShowMessage( _message, _buttonCount, _confirmText, _cancelText, _confirmAction, _cancelAction, _isChangeImg );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)&& translator.Assignable<System.Action>(L, 6)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _confirmText = LuaAPI.lua_tostring(L, 3);
                    string _cancelText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 6);
                    
                    UIUtils.ShowMessage( _message, _buttonCount, _confirmText, _cancelText, _confirmAction, _cancelAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _confirmText = LuaAPI.lua_tostring(L, 3);
                    string _cancelText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    
                    UIUtils.ShowMessage( _message, _buttonCount, _confirmText, _cancelText, _confirmAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _confirmText = LuaAPI.lua_tostring(L, 3);
                    string _cancelText = LuaAPI.lua_tostring(L, 4);
                    
                    UIUtils.ShowMessage( _message, _buttonCount, _confirmText, _cancelText );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _confirmText = LuaAPI.lua_tostring(L, 3);
                    
                    UIUtils.ShowMessage( _message, _buttonCount, _confirmText );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    
                    UIUtils.ShowMessage( _message, _buttonCount );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    
                    UIUtils.ShowMessage( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowMessage!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowMessages_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)&& translator.Assignable<System.Action>(L, 6)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 7)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _cancelText = LuaAPI.lua_tostring(L, 3);
                    string _confirmText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 6);
                    bool _isChangeImg = LuaAPI.lua_toboolean(L, 7);
                    
                    UIUtils.ShowMessages( _message, _buttonCount, _cancelText, _confirmText, _confirmAction, _cancelAction, _isChangeImg );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)&& translator.Assignable<System.Action>(L, 6)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _cancelText = LuaAPI.lua_tostring(L, 3);
                    string _confirmText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 6);
                    
                    UIUtils.ShowMessages( _message, _buttonCount, _cancelText, _confirmText, _confirmAction, _cancelAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 5)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _cancelText = LuaAPI.lua_tostring(L, 3);
                    string _confirmText = LuaAPI.lua_tostring(L, 4);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 5);
                    
                    UIUtils.ShowMessages( _message, _buttonCount, _cancelText, _confirmText, _confirmAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    int _buttonCount = LuaAPI.xlua_tointeger(L, 2);
                    string _cancelText = LuaAPI.lua_tostring(L, 3);
                    string _confirmText = LuaAPI.lua_tostring(L, 4);
                    
                    UIUtils.ShowMessages( _message, _buttonCount, _cancelText, _confirmText );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowMessages!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_NewShowMessage_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    bool _isChangeImg = LuaAPI.lua_toboolean(L, 4);
                    
                    UIUtils.NewShowMessage( _message, _confirmAction, _cancelAction, _isChangeImg );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    
                    UIUtils.NewShowMessage( _message, _confirmAction, _cancelAction );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    
                    UIUtils.NewShowMessage( _message, _confirmAction );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.NewShowMessage!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowReloadMessage_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    string _rTxt = LuaAPI.lua_tostring(L, 4);
                    float _countTime = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    UIUtils.ShowReloadMessage( _message, _confirmAction, _cancelAction, _rTxt, _countTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    string _rTxt = LuaAPI.lua_tostring(L, 4);
                    
                    UIUtils.ShowReloadMessage( _message, _confirmAction, _cancelAction, _rTxt );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 2)&& translator.Assignable<System.Action>(L, 3)) 
                {
                    string _message = LuaAPI.lua_tostring(L, 1);
                    System.Action _confirmAction = translator.GetDelegate<System.Action>(L, 2);
                    System.Action _cancelAction = translator.GetDelegate<System.Action>(L, 3);
                    
                    UIUtils.ShowReloadMessage( _message, _confirmAction, _cancelAction );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowReloadMessage!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowLoadingMask_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 0) 
                {
                    
                    UIUtils.ShowLoadingMask(  );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 1)&& translator.Assignable<UnityEngine.Color>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    bool _animation = LuaAPI.lua_toboolean(L, 1);
                    UnityEngine.Color _color;translator.Get(L, 2, out _color);
                    bool _isAutoTimer = LuaAPI.lua_toboolean(L, 3);
                    
                    UIUtils.ShowLoadingMask( _animation, _color, _isAutoTimer );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 1)&& translator.Assignable<UnityEngine.Color>(L, 2)) 
                {
                    bool _animation = LuaAPI.lua_toboolean(L, 1);
                    UnityEngine.Color _color;translator.Get(L, 2, out _color);
                    
                    UIUtils.ShowLoadingMask( _animation, _color );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowLoadingMask!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideLoadingMask_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    UIUtils.HideLoadingMask(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowTips_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count >= 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaTypes.LUA_TNONE == LuaAPI.lua_type(L, 3) || translator.Assignable<object>(L, 3))) 
                {
                    string _msgKey = LuaAPI.lua_tostring(L, 1);
                    float _closeTime = (float)LuaAPI.lua_tonumber(L, 2);
                    object[] _args = translator.GetParams<object>(L, 3);
                    
                    UIUtils.ShowTips( _msgKey, _closeTime, _args );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count >= 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    string _msgKey = LuaAPI.lua_tostring(L, 1);
                    float _closeTime = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    UIUtils.ShowTips( _msgKey, _closeTime );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count >= 0&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _msgKey = LuaAPI.lua_tostring(L, 1);
                    
                    UIUtils.ShowTips( _msgKey );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowTips!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowLackResource_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<ResourceType, long>>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    string _tipContent = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.Dictionary<ResourceType, long> _resources = (System.Collections.Generic.Dictionary<ResourceType, long>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Dictionary<ResourceType, long>));
                    string _actionName = LuaAPI.lua_tostring(L, 3);
                    System.Action _actionCallBack = translator.GetDelegate<System.Action>(L, 4);
                    bool _tipContentIsKey = LuaAPI.lua_toboolean(L, 5);
                    bool _actionNameIsKey = LuaAPI.lua_toboolean(L, 6);
                    
                    UIUtils.ShowLackResource( _tipContent, _resources, _actionName, _actionCallBack, _tipContentIsKey, _actionNameIsKey );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<ResourceType, long>>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    string _tipContent = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.Dictionary<ResourceType, long> _resources = (System.Collections.Generic.Dictionary<ResourceType, long>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Dictionary<ResourceType, long>));
                    string _actionName = LuaAPI.lua_tostring(L, 3);
                    System.Action _actionCallBack = translator.GetDelegate<System.Action>(L, 4);
                    bool _tipContentIsKey = LuaAPI.lua_toboolean(L, 5);
                    
                    UIUtils.ShowLackResource( _tipContent, _resources, _actionName, _actionCallBack, _tipContentIsKey );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Collections.Generic.Dictionary<ResourceType, long>>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)&& translator.Assignable<System.Action>(L, 4)) 
                {
                    string _tipContent = LuaAPI.lua_tostring(L, 1);
                    System.Collections.Generic.Dictionary<ResourceType, long> _resources = (System.Collections.Generic.Dictionary<ResourceType, long>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Dictionary<ResourceType, long>));
                    string _actionName = LuaAPI.lua_tostring(L, 3);
                    System.Action _actionCallBack = translator.GetDelegate<System.Action>(L, 4);
                    
                    UIUtils.ShowLackResource( _tipContent, _resources, _actionName, _actionCallBack );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.ShowLackResource!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowRankView_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    UIUtils.ShowRankView(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WordToScenePoint_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Vector3 _wordPosition;translator.Get(L, 1, out _wordPosition);
                    
                        var gen_ret = UIUtils.WordToScenePoint( _wordPosition );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPointToLocalPointInRectangle_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Transform _transform = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    UnityEngine.Vector2 _screenPos;translator.Get(L, 2, out _screenPos);
                    
                        var gen_ret = UIUtils.ScreenPointToLocalPointInRectangle( _transform, _screenPos );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BuildSkeletonDataAsset_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _skeletonPath = LuaAPI.lua_tostring(L, 1);
                    UIUtils.SkeletonDelegate _handler = translator.GetDelegate<UIUtils.SkeletonDelegate>(L, 2);
                    
                    UIUtils.BuildSkeletonDataAsset( _skeletonPath, _handler );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_checkUserName_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _userName = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = UIUtils.checkUserName( _userName );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_checkPwd_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _pwd = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = UIUtils.checkPwd( _pwd );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _pwd1 = LuaAPI.lua_tostring(L, 1);
                    string _pwd2 = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = UIUtils.checkPwd( _pwd1, _pwd2 );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.checkPwd!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getAccountBindStateName_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.getAccountBindStateName(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getIM30AccountBindStateName_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.getIM30AccountBindStateName(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_getAccountBindState_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.getAccountBindState(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AccountNeedBind_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.AccountNeedBind(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFirstChild_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    UnityEngine.Transform _parent = (UnityEngine.Transform)translator.GetObject(L, 1, typeof(UnityEngine.Transform));
                    string _name = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = UIUtils.GetFirstChild( _parent, _name );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetTextWithImage_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.UI.Text>(L, 1)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.UI.Image>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.UI.Text _text = (UnityEngine.UI.Text)translator.GetObject(L, 1, typeof(UnityEngine.UI.Text));
                    string _des = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.UI.Image _image = (UnityEngine.UI.Image)translator.GetObject(L, 3, typeof(UnityEngine.UI.Image));
                    int _imageWidth = LuaAPI.xlua_tointeger(L, 4);
                    
                    UIUtils.SetTextWithImage( _text, _des, _image, _imageWidth );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.UI.Text>(L, 1)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& translator.Assignable<UnityEngine.UI.Image>(L, 3)) 
                {
                    UnityEngine.UI.Text _text = (UnityEngine.UI.Text)translator.GetObject(L, 1, typeof(UnityEngine.UI.Text));
                    string _des = LuaAPI.lua_tostring(L, 2);
                    UnityEngine.UI.Image _image = (UnityEngine.UI.Image)translator.GetObject(L, 3, typeof(UnityEngine.UI.Image));
                    
                    UIUtils.SetTextWithImage( _text, _des, _image );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.SetTextWithImage!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPosAtText_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Canvas>(L, 1)&& translator.Assignable<UnityEngine.UI.Text>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Canvas _canvas = (UnityEngine.Canvas)translator.GetObject(L, 1, typeof(UnityEngine.Canvas));
                    UnityEngine.UI.Text _text = (UnityEngine.UI.Text)translator.GetObject(L, 2, typeof(UnityEngine.UI.Text));
                    int _charIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = UIUtils.GetPosAtText( _canvas, _text, _charIndex );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Canvas>(L, 1)&& translator.Assignable<UnityEngine.UI.Text>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    UnityEngine.Canvas _canvas = (UnityEngine.Canvas)translator.GetObject(L, 1, typeof(UnityEngine.Canvas));
                    UnityEngine.UI.Text _text = (UnityEngine.UI.Text)translator.GetObject(L, 2, typeof(UnityEngine.UI.Text));
                    string _strFragment = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = UIUtils.GetPosAtText( _canvas, _text, _strFragment );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.GetPosAtText!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_PlayAnimationReturnTime_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<SimpleAnimation>(L, 1)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    SimpleAnimation _anim = (SimpleAnimation)translator.GetObject(L, 1, typeof(SimpleAnimation));
                    string _animName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = UIUtils.PlayAnimationReturnTime( _anim, _animName );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Animator>(L, 1)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    UnityEngine.Animator _anim = (UnityEngine.Animator)translator.GetObject(L, 1, typeof(UnityEngine.Animator));
                    string _animName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = UIUtils.PlayAnimationReturnTime( _anim, _animName );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<GPUSkinningAnimator>(L, 1)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    GPUSkinningAnimator _anim = (GPUSkinningAnimator)translator.GetObject(L, 1, typeof(GPUSkinningAnimator));
                    string _animName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = UIUtils.PlayAnimationReturnTime( _anim, _animName );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UIUtils.PlayAnimationReturnTime!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCurScreenMaxRadiusSize_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.GetCurScreenMaxRadiusSize(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildPointByMeteoriteHitGlass_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    
                        var gen_ret = UIUtils.GetBuildPointByMeteoriteHitGlass(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_tmpWidth(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.lua_pushnumber(L, UIUtils.tmpWidth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_tmpWidth(RealStatePtr L)
        {
		    try {
                
			    UIUtils.tmpWidth = (float)LuaAPI.lua_tonumber(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
