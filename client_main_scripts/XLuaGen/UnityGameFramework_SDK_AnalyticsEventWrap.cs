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
    public class UnityGameFrameworkSDKAnalyticsEventWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(UnityGameFramework.SDK.AnalyticsEvent);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 43, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "TutorialComplete", _m_TutorialComplete_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FirstOpenAppsflyer", _m_FirstOpenAppsflyer_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Login", _m_Login_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "TriggerEventPurchase", _m_TriggerEventPurchase_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "LevelUp", _m_LevelUp_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "ClickBuyIn60m", _m_ClickBuyIn60m_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SpeedUp", _m_SpeedUp_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GiftPackage", _m_GiftPackage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AllianceHonorExchange", _m_AllianceHonorExchange_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AllianceScoreUsage", _m_AllianceScoreUsage_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AllianceChat", _m_AllianceChat_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "EventDone", _m_EventDone_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendAdjustTrack", _m_SendAdjustTrack_xlua_st_);
            
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "first_open_new", UnityGameFramework.SDK.AnalyticsEvent.first_open_new);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "app_launch", UnityGameFramework.SDK.AnalyticsEvent.app_launch);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "trackAppLaunch", UnityGameFramework.SDK.AnalyticsEvent.trackAppLaunch);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventPurchase", UnityGameFramework.SDK.AnalyticsEvent.EventPurchase);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventLevelUp", UnityGameFramework.SDK.AnalyticsEvent.EventLevelUp);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "click_buy_car_in_60m", UnityGameFramework.SDK.AnalyticsEvent.click_buy_car_in_60m);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "click_gifts", UnityGameFramework.SDK.AnalyticsEvent.click_gifts);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "click_gifts_in_30m", UnityGameFramework.SDK.AnalyticsEvent.click_gifts_in_30m);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "setCustomerUserID", UnityGameFramework.SDK.AnalyticsEvent.setCustomerUserID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "tutorialComplete", UnityGameFramework.SDK.AnalyticsEvent.tutorialComplete);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "triggerEventLoginComplete", UnityGameFramework.SDK.AnalyticsEvent.triggerEventLoginComplete);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventCompletedRegistration", UnityGameFramework.SDK.AnalyticsEvent.EventCompletedRegistration);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "fbEventCompletedTutorial", UnityGameFramework.SDK.AnalyticsEvent.fbEventCompletedTutorial);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventSpeedUp", UnityGameFramework.SDK.AnalyticsEvent.EventSpeedUp);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventGiftPackage", UnityGameFramework.SDK.AnalyticsEvent.EventGiftPackage);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventPurchaseItem", UnityGameFramework.SDK.AnalyticsEvent.EventPurchaseItem);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventFBEntrance", UnityGameFramework.SDK.AnalyticsEvent.EventFBEntrance);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventHireWorker", UnityGameFramework.SDK.AnalyticsEvent.EventHireWorker);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventAllianceHonorExchange", UnityGameFramework.SDK.AnalyticsEvent.EventAllianceHonorExchange);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventAllianceScoreUsage", UnityGameFramework.SDK.AnalyticsEvent.EventAllianceScoreUsage);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EventAllianceTalkMore", UnityGameFramework.SDK.AnalyticsEvent.EventAllianceTalkMore);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FBEventDone", UnityGameFramework.SDK.AnalyticsEvent.FBEventDone);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "battle_base", UnityGameFramework.SDK.AnalyticsEvent.battle_base);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "battle_resource", UnityGameFramework.SDK.AnalyticsEvent.battle_resource);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "battle_rein", UnityGameFramework.SDK.AnalyticsEvent.battle_rein);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "battle_scout", UnityGameFramework.SDK.AnalyticsEvent.battle_scout);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "social_chat_country", UnityGameFramework.SDK.AnalyticsEvent.social_chat_country);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "social_chat_alliance", UnityGameFramework.SDK.AnalyticsEvent.social_chat_alliance);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "social_send_gift", UnityGameFramework.SDK.AnalyticsEvent.social_send_gift);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new UnityGameFramework.SDK.AnalyticsEvent();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to UnityGameFramework.SDK.AnalyticsEvent constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TutorialComplete_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _data = LuaAPI.lua_tostring(L, 1);
                    int __type = LuaAPI.xlua_tointeger(L, 2);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.TutorialComplete( _data, __type );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FirstOpenAppsflyer_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    UnityGameFramework.SDK.AnalyticsEvent.FirstOpenAppsflyer(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Login_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _msg = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 1, typeof(Sfs2X.Entities.Data.ISFSObject));
                    string _userId = LuaAPI.lua_tostring(L, 2);
                    string _userName = LuaAPI.lua_tostring(L, 3);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.Login( _msg, _userId, _userName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TriggerEventPurchase_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _cost = LuaAPI.lua_tostring(L, 1);
                    string _key = LuaAPI.lua_tostring(L, 2);
                    string _orderId = LuaAPI.lua_tostring(L, 3);
                    string _uid = LuaAPI.lua_tostring(L, 4);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.TriggerEventPurchase( _cost, _key, _orderId, _uid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_LevelUp_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _lv = LuaAPI.lua_tostring(L, 1);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.LevelUp( _lv );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClickBuyIn60m_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 1);
                    string _name = LuaAPI.lua_tostring(L, 2);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.ClickBuyIn60m( _id, _name );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SpeedUp_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    int _user_level = LuaAPI.xlua_tointeger(L, 1);
                    int _castle_level = LuaAPI.xlua_tointeger(L, 2);
                    int _type = LuaAPI.xlua_tointeger(L, 3);
                    int _spend = LuaAPI.xlua_tointeger(L, 4);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.SpeedUp( _user_level, _castle_level, _type, _spend );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GiftPackage_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _entracnce = LuaAPI.lua_tostring(L, 1);
                    string _name = LuaAPI.lua_tostring(L, 2);
                    int _id = LuaAPI.xlua_tointeger(L, 3);
                    int _user_castle = LuaAPI.xlua_tointeger(L, 4);
                    int _user_level = LuaAPI.xlua_tointeger(L, 5);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.GiftPackage( _entracnce, _name, _id, _user_castle, _user_level );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AllianceHonorExchange_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    string _id = LuaAPI.lua_tostring(L, 2);
                    int _user_castle = LuaAPI.xlua_tointeger(L, 3);
                    int _user_level = LuaAPI.xlua_tointeger(L, 4);
                    int _rank = LuaAPI.xlua_tointeger(L, 5);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.AllianceHonorExchange( _name, _id, _user_castle, _user_level, _rank );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AllianceScoreUsage_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    string _id = LuaAPI.lua_tostring(L, 2);
                    int _rank = LuaAPI.xlua_tointeger(L, 3);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.AllianceScoreUsage( _name, _id, _rank );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AllianceChat_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _eventName = LuaAPI.lua_tostring(L, 1);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.AllianceChat( _eventName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EventDone_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _eventName = LuaAPI.lua_tostring(L, 1);
                    string _data = LuaAPI.lua_tostring(L, 2);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.EventDone( _eventName, _data );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendAdjustTrack_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _track = LuaAPI.lua_tostring(L, 1);
                    string _eventValue = LuaAPI.lua_tostring(L, 2);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.SendAdjustTrack( _track, _eventValue );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _track = LuaAPI.lua_tostring(L, 1);
                    
                    UnityGameFramework.SDK.AnalyticsEvent.SendAdjustTrack( _track );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to UnityGameFramework.SDK.AnalyticsEvent.SendAdjustTrack!");
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
