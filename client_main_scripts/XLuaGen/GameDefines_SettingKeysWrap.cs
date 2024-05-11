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
    public class GameDefinesSettingKeysWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.SettingKeys);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 58, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ACCOUNT_LIST_DEBUG", GameDefines.SettingKeys.ACCOUNT_LIST_DEBUG);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LAST_SERVER_KEY", GameDefines.SettingKeys.LAST_SERVER_KEY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GAME_UID", GameDefines.SettingKeys.GAME_UID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GM_FLAG", GameDefines.SettingKeys.GM_FLAG);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UUID", GameDefines.SettingKeys.UUID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DEVICE_ID", GameDefines.SettingKeys.DEVICE_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SERVER_IP", GameDefines.SettingKeys.SERVER_IP);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SERVER_PORT", GameDefines.SettingKeys.SERVER_PORT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SERVER_ZONE", GameDefines.SettingKeys.SERVER_ZONE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ACCOUNT_LIST", GameDefines.SettingKeys.ACCOUNT_LIST);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "IM30_ACCOUNT", GameDefines.SettingKeys.IM30_ACCOUNT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "IM30_PWD", GameDefines.SettingKeys.IM30_PWD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ACCOUNT_STATUS", GameDefines.SettingKeys.ACCOUNT_STATUS);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ACCOUNT_SENDMIL_AGAINTIME", GameDefines.SettingKeys.ACCOUNT_SENDMIL_AGAINTIME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WX_APPID_CACHE", GameDefines.SettingKeys.WX_APPID_CACHE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WX_USERNAME_CACHE", GameDefines.SettingKeys.WX_USERNAME_CACHE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FB_USERID", GameDefines.SettingKeys.FB_USERID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FB_USERNAME", GameDefines.SettingKeys.FB_USERNAME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DEVICE_UID", GameDefines.SettingKeys.DEVICE_UID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CUSTOM_UID", GameDefines.SettingKeys.CUSTOM_UID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EMAIL_CONFIRM", GameDefines.SettingKeys.EMAIL_CONFIRM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OICQ_USERID", GameDefines.SettingKeys.OICQ_USERID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OICQ_USERNAME", GameDefines.SettingKeys.OICQ_USERNAME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WEIBO_USERID", GameDefines.SettingKeys.WEIBO_USERID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WEIBO_USERNAME", GameDefines.SettingKeys.WEIBO_USERNAME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AZ_ACCOUNT", GameDefines.SettingKeys.AZ_ACCOUNT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AZ_ACCOUNTSTATUS", GameDefines.SettingKeys.AZ_ACCOUNTSTATUS);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COK_PURCHASE_SUCCESSED_KEY", GameDefines.SettingKeys.COK_PURCHASE_SUCCESSED_KEY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COK_PURCHASE_KEY", GameDefines.SettingKeys.COK_PURCHASE_KEY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GP_USERID", GameDefines.SettingKeys.GP_USERID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GP_USERNAME", GameDefines.SettingKeys.GP_USERNAME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CATCH_ITEM_ID", GameDefines.SettingKeys.CATCH_ITEM_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EFFECT_MUSIC_ON", GameDefines.SettingKeys.EFFECT_MUSIC_ON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BG_MUSIC_ON", GameDefines.SettingKeys.BG_MUSIC_ON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ThreeDWORLD_SWITCH", GameDefines.SettingKeys.ThreeDWORLD_SWITCH);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SHOW_FAVORITE", GameDefines.SettingKeys.SHOW_FAVORITE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TASK_TIPS_ON", GameDefines.SettingKeys.TASK_TIPS_ON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WORLD_SCROLL_UI", GameDefines.SettingKeys.WORLD_SCROLL_UI);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TOUCH_SP_FUN", GameDefines.SettingKeys.TOUCH_SP_FUN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COORDINATE_ON_SHOW", GameDefines.SettingKeys.COORDINATE_ON_SHOW);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Transporter_Hidden", GameDefines.SettingKeys.Transporter_Hidden);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ISETTING_CASTLE_CLICK_PRIORITY", GameDefines.SettingKeys.ISETTING_CASTLE_CLICK_PRIORITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "USER_LANGUAGE", GameDefines.SettingKeys.USER_LANGUAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RECHARGE_ACTV_TOMORROW_TIME", GameDefines.SettingKeys.RECHARGE_ACTV_TOMORROW_TIME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GUIDE_STEP", GameDefines.SettingKeys.GUIDE_STEP);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GUIDE_MP4", GameDefines.SettingKeys.GUIDE_MP4);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GUIDE_FOR_TERRITORY", GameDefines.SettingKeys.GUIDE_FOR_TERRITORY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GUIDE_FOR_MARCH", GameDefines.SettingKeys.GUIDE_FOR_MARCH);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "POST_PROCESSING_BLOOM", GameDefines.SettingKeys.POST_PROCESSING_BLOOM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "POST_PROCESSING_VIGNETTE", GameDefines.SettingKeys.POST_PROCESSING_VIGNETTE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SCENE_PARTICLES", GameDefines.SettingKeys.SCENE_PARTICLES);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RESOURCE_LOGGER", GameDefines.SettingKeys.RESOURCE_LOGGER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SCENE_GRAPHIC_LEVEL", GameDefines.SettingKeys.SCENE_GRAPHIC_LEVEL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SCENE_FPS_LEVEL", GameDefines.SettingKeys.SCENE_FPS_LEVEL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SHOW_DEBUG_CHOOSE_SERVER", GameDefines.SettingKeys.SHOW_DEBUG_CHOOSE_SERVER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MAIL_LAST_OPEN_TIME_BY_GROUP", GameDefines.SettingKeys.MAIL_LAST_OPEN_TIME_BY_GROUP);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ALLIANCE_WAR_OLD_DATA", GameDefines.SettingKeys.ALLIANCE_WAR_OLD_DATA);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.SettingKeys();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.SettingKeys constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
