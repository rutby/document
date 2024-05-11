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
    public class GameDefinesSoundAssetsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.SoundAssets);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 39, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_M_city_1", GameDefines.SoundAssets.Music_M_city_1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_M_city_3", GameDefines.SoundAssets.Music_M_city_3);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Sfx_logo_loading", GameDefines.SoundAssets.Music_Sfx_logo_loading);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_M_battle_1", GameDefines.SoundAssets.Music_M_battle_1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Video_bg_1", GameDefines.SoundAssets.Video_bg_1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Bgm_night", GameDefines.SoundAssets.Music_Bgm_night);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Bgm_day", GameDefines.SoundAssets.Music_Bgm_day);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Open", GameDefines.SoundAssets.Music_Effect_Open);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Close", GameDefines.SoundAssets.Music_Effect_Close);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Ground", GameDefines.SoundAssets.Music_Effect_Ground);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Mist", GameDefines.SoundAssets.Music_Effect_Mist);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Building", GameDefines.SoundAssets.Music_Effect_Building);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Ranch", GameDefines.SoundAssets.Music_Effect_Ranch);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Creeps", GameDefines.SoundAssets.Music_Effect_Creeps);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Army", GameDefines.SoundAssets.Music_Effect_Army);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Electric", GameDefines.SoundAssets.Music_Effect_Electric);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Crystal", GameDefines.SoundAssets.Music_Effect_Crystal);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Water", GameDefines.SoundAssets.Music_Effect_Water);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Gas", GameDefines.SoundAssets.Music_Effect_Gas);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Coin", GameDefines.SoundAssets.Music_Effect_Coin);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Product1", GameDefines.SoundAssets.Music_Effect_Product1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Product2", GameDefines.SoundAssets.Music_Effect_Product2);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Product3", GameDefines.SoundAssets.Music_Effect_Product3);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Trained", GameDefines.SoundAssets.Music_Effect_Trained);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Plant", GameDefines.SoundAssets.Music_Effect_Plant);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Feed", GameDefines.SoundAssets.Music_Effect_Feed);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Produce_Put", GameDefines.SoundAssets.Music_Effect_Produce_Put);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Produce_Box", GameDefines.SoundAssets.Music_Effect_Produce_Box);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Bill", GameDefines.SoundAssets.Music_Effect_Bill);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Button", GameDefines.SoundAssets.Music_Effect_Button);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Message", GameDefines.SoundAssets.Music_Effect_Message);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Finish", GameDefines.SoundAssets.Music_Effect_Finish);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Rocket", GameDefines.SoundAssets.Music_Effect_Rocket);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Rocket_Land", GameDefines.SoundAssets.Music_Effect_Rocket_Land);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Radar", GameDefines.SoundAssets.Music_Effect_Radar);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Alliance", GameDefines.SoundAssets.Music_Effect_Alliance);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Attack", GameDefines.SoundAssets.Music_Effect_Attack);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Music_Effect_Skill_Attack", GameDefines.SoundAssets.Music_Effect_Skill_Attack);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.SoundAssets();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.SoundAssets constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
