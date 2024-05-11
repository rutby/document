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
    public class GameDefinesSpecialItemIDWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.SpecialItemID);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 9, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_MOVE_RANDOM", GameDefines.SpecialItemID.ITEM_MOVE_RANDOM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_MOVE_CITY", GameDefines.SpecialItemID.ITEM_MOVE_CITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_FREE_MOVE_CITY", GameDefines.SpecialItemID.ITEM_FREE_MOVE_CITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_ALLIANCE_CITY_MOVE", GameDefines.SpecialItemID.ITEM_ALLIANCE_CITY_MOVE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_MERGESERVER_MOVECITY", GameDefines.SpecialItemID.ITEM_MERGESERVER_MOVECITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_CROSS_MOVE_CITY", GameDefines.SpecialItemID.ITEM_CROSS_MOVE_CITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_CROSS_FREE_CITY", GameDefines.SpecialItemID.ITEM_CROSS_FREE_CITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RECRUIT_TYPE_HERO_ACTIVITY", GameDefines.SpecialItemID.RECRUIT_TYPE_HERO_ACTIVITY);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.SpecialItemID();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.SpecialItemID constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
