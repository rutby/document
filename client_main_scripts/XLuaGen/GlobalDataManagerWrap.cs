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
    public class GlobalDataManagerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GlobalDataManager);
			Utils.BeginObjectRegister(type, L, translator, 0, 16, 52, 52);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Init", _m_Init);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetAnalyticID", _m_SetAnalyticID);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCnFlagFromServer", _m_SetCnFlagFromServer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Reset", _m_Reset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGlobalValue", _m_GetGlobalValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetGlobalValue", _m_SetGlobalValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "recordGaid", _m_recordGaid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isGoogle", _m_isGoogle);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isGoogleOnlyCheckAnalyticID", _m_isGoogleOnlyCheckAnalyticID);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isChina", _m_isChina);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isMiddleEast", _m_isMiddleEast);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isTencent", _m_isTencent);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isAmazon", _m_isAmazon);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isMol", _m_isMol);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isMycard", _m_isMycard);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "isOnestore", _m_isOnestore);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "download_video_url", _g_get_download_video_url);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "download_video_url2", _g_get_download_video_url2);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadurlcdn", _g_get_downloadurlcdn);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "downloadurl", _g_get_downloadurl);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "eu_state", _g_get_eu_state);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fblikeutil", _g_get_fblikeutil);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "force_merge", _g_get_force_merge);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "force_use_downloadxml", _g_get_force_use_downloadxml);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "lua", _g_get_lua);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaCode", _g_get_luaCode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaCode_v3", _g_get_luaCode_v3);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaSize", _g_get_luaSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaVersion", _g_get_luaVersion);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luaVersion_v3", _g_get_luaVersion_v3);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "luazipSize", _g_get_luazipSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "randKey", _g_get_randKey);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "reduce_init_data", _g_get_reduce_init_data);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "serverVersion", _g_get_serverVersion);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "updateType", _g_get_updateType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "upload_video_url", _g_get_upload_video_url);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "xmlVersion", _g_get_xmlVersion);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "loginServerInfo", _g_get_loginServerInfo);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "gcmRegisterId", _g_get_gcmRegisterId);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "referrer", _g_get_referrer);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "deeplinkParams", _g_get_deeplinkParams);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "AndroidID", _g_get_AndroidID);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IMEI", _g_get_IMEI);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "analyticID", _g_get_analyticID);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "s_isGooglePlayAvailable", _g_get_s_isGooglePlayAvailable);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "platformUID", _g_get_platformUID);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "parseRegisterId", _g_get_parseRegisterId);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "fromCountry", _g_get_fromCountry);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "gaid", _g_get_gaid);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isTodayFirstLogin", _g_get_isTodayFirstLogin);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isNewServer", _g_get_isNewServer);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "version", _g_get_version);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "uuid", _g_get_uuid);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "gaidCache", _g_get_gaidCache);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isUploadPic", _g_get_isUploadPic);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isOpenElvaChat", _g_get_isOpenElvaChat);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isFAQVoteResp", _g_get_isFAQVoteResp);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "cityTileCountry", _g_get_cityTileCountry);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "serverType", _g_get_serverType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "serverMax", _g_get_serverMax);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "nowGameCnt", _g_get_nowGameCnt);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "freeSpdT", _g_get_freeSpdT);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TeleportLimitTime", _g_get_TeleportLimitTime);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TransResForbiddenSwith", _g_get_TransResForbiddenSwith);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "NewTransKingdomLevel", _g_get_NewTransKingdomLevel);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsCityMoved", _g_get_IsCityMoved);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "pushOffWithQuitGame", _g_get_pushOffWithQuitGame);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isInBackGround", _g_get_isInBackGround);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "download_video_url", _s_set_download_video_url);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "download_video_url2", _s_set_download_video_url2);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadurlcdn", _s_set_downloadurlcdn);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "downloadurl", _s_set_downloadurl);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "eu_state", _s_set_eu_state);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fblikeutil", _s_set_fblikeutil);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "force_merge", _s_set_force_merge);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "force_use_downloadxml", _s_set_force_use_downloadxml);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "lua", _s_set_lua);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luaCode", _s_set_luaCode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luaCode_v3", _s_set_luaCode_v3);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luaSize", _s_set_luaSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luaVersion", _s_set_luaVersion);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luaVersion_v3", _s_set_luaVersion_v3);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "luazipSize", _s_set_luazipSize);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "randKey", _s_set_randKey);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "reduce_init_data", _s_set_reduce_init_data);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "serverVersion", _s_set_serverVersion);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "updateType", _s_set_updateType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "upload_video_url", _s_set_upload_video_url);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "xmlVersion", _s_set_xmlVersion);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "loginServerInfo", _s_set_loginServerInfo);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "gcmRegisterId", _s_set_gcmRegisterId);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "referrer", _s_set_referrer);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "deeplinkParams", _s_set_deeplinkParams);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "AndroidID", _s_set_AndroidID);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "IMEI", _s_set_IMEI);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "analyticID", _s_set_analyticID);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "s_isGooglePlayAvailable", _s_set_s_isGooglePlayAvailable);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "platformUID", _s_set_platformUID);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "parseRegisterId", _s_set_parseRegisterId);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "fromCountry", _s_set_fromCountry);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "gaid", _s_set_gaid);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isTodayFirstLogin", _s_set_isTodayFirstLogin);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isNewServer", _s_set_isNewServer);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "version", _s_set_version);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "uuid", _s_set_uuid);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "gaidCache", _s_set_gaidCache);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isUploadPic", _s_set_isUploadPic);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isOpenElvaChat", _s_set_isOpenElvaChat);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isFAQVoteResp", _s_set_isFAQVoteResp);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "cityTileCountry", _s_set_cityTileCountry);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "serverType", _s_set_serverType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "serverMax", _s_set_serverMax);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "nowGameCnt", _s_set_nowGameCnt);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "freeSpdT", _s_set_freeSpdT);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "TeleportLimitTime", _s_set_TeleportLimitTime);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "TransResForbiddenSwith", _s_set_TransResForbiddenSwith);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "NewTransKingdomLevel", _s_set_NewTransKingdomLevel);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "IsCityMoved", _s_set_IsCityMoved);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "pushOffWithQuitGame", _s_set_pushOffWithQuitGame);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isInBackGround", _s_set_isInBackGround);
            
			
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
					
					var gen_ret = new GlobalDataManager();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GlobalDataManager constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _dict = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.Init( _dict );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetAnalyticID(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.SetAnalyticID(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCnFlagFromServer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _isCn = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetCnFlagFromServer( _isCn );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Reset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Reset(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGlobalValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _key = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetGlobalValue( _key );
                        translator.PushAny(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetGlobalValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _key = LuaAPI.lua_tostring(L, 2);
                    object _value = translator.GetObject(L, 3, typeof(object));
                    
                        var gen_ret = gen_to_be_invoked.SetGlobalValue( _key, _value );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_recordGaid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.recordGaid(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isGoogle(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isGoogle(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isGoogleOnlyCheckAnalyticID(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isGoogleOnlyCheckAnalyticID(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isChina(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isChina(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isMiddleEast(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isMiddleEast(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isTencent(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isTencent(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isAmazon(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isAmazon(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isMol(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isMol(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isMycard(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isMycard(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_isOnestore(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.isOnestore(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_download_video_url(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.download_video_url);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_download_video_url2(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.download_video_url2);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadurlcdn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.downloadurlcdn);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_downloadurl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.downloadurl);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_eu_state(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.eu_state);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fblikeutil(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.fblikeutil);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_force_merge(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.force_merge);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_force_use_downloadxml(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.force_use_downloadxml);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_lua(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.lua);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaCode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.luaCode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaCode_v3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.luaCode_v3);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.luaSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.luaVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luaVersion_v3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.luaVersion_v3);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_luazipSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.luazipSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_randKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.randKey);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_reduce_init_data(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.reduce_init_data);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_serverVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.serverVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_updateType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.updateType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_upload_video_url(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.upload_video_url);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_xmlVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.xmlVersion);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_loginServerInfo(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.loginServerInfo);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gcmRegisterId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.gcmRegisterId);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_referrer(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.referrer);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_deeplinkParams(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.deeplinkParams);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_AndroidID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.AndroidID);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IMEI(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.IMEI);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_analyticID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.analyticID);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_s_isGooglePlayAvailable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.s_isGooglePlayAvailable);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_platformUID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.platformUID);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_parseRegisterId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.parseRegisterId);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_fromCountry(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.fromCountry);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gaid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.gaid);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isTodayFirstLogin(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isTodayFirstLogin);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isNewServer(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isNewServer);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_version(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.version);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_uuid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.uuid);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_gaidCache(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.gaidCache);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isUploadPic(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isUploadPic);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isOpenElvaChat(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isOpenElvaChat);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isFAQVoteResp(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isFAQVoteResp);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_cityTileCountry(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.cityTileCountry);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_serverType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.serverType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_serverMax(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.serverMax);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_nowGameCnt(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.nowGameCnt);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_freeSpdT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.freeSpdT);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TeleportLimitTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.TeleportLimitTime);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TransResForbiddenSwith(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.TransResForbiddenSwith);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_NewTransKingdomLevel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.NewTransKingdomLevel);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsCityMoved(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsCityMoved);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_pushOffWithQuitGame(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.pushOffWithQuitGame);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isInBackGround(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isInBackGround);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_download_video_url(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.download_video_url = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_download_video_url2(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.download_video_url2 = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadurlcdn(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadurlcdn = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_downloadurl(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.downloadurl = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_eu_state(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.eu_state = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fblikeutil(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fblikeutil = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_force_merge(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.force_merge = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_force_use_downloadxml(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.force_use_downloadxml = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_lua(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.lua = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaCode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luaCode = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaCode_v3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luaCode_v3 = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luaSize = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luaVersion = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luaVersion_v3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luaVersion_v3 = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_luazipSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.luazipSize = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_randKey(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.randKey = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_reduce_init_data(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.reduce_init_data = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_serverVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.serverVersion = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_updateType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.updateType = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_upload_video_url(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.upload_video_url = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_xmlVersion(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.xmlVersion = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_loginServerInfo(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                GlobalDataManager.LoginServerInfo gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.loginServerInfo = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gcmRegisterId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.gcmRegisterId = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_referrer(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.referrer = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_deeplinkParams(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.deeplinkParams = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_AndroidID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.AndroidID = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IMEI(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IMEI = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_analyticID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.analyticID = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_s_isGooglePlayAvailable(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.s_isGooglePlayAvailable = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_platformUID(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.platformUID = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_parseRegisterId(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.parseRegisterId = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_fromCountry(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.fromCountry = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gaid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.gaid = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isTodayFirstLogin(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isTodayFirstLogin = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isNewServer(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isNewServer = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_version(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.version = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_uuid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.uuid = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_gaidCache(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.gaidCache = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isUploadPic(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isUploadPic = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isOpenElvaChat(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isOpenElvaChat = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isFAQVoteResp(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isFAQVoteResp = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_cityTileCountry(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.cityTileCountry = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_serverType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.serverType = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_serverMax(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.serverMax = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_nowGameCnt(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.nowGameCnt = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_freeSpdT(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.freeSpdT = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TeleportLimitTime(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.TeleportLimitTime = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_TransResForbiddenSwith(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.TransResForbiddenSwith = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_NewTransKingdomLevel(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.NewTransKingdomLevel = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_IsCityMoved(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.IsCityMoved = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_pushOffWithQuitGame(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.pushOffWithQuitGame = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isInBackGround(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                GlobalDataManager gen_to_be_invoked = (GlobalDataManager)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isInBackGround = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
