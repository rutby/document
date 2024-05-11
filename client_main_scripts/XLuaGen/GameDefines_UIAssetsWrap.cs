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
    public class GameDefinesUIAssetsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.UIAssets);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 9, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UILoading", GameDefines.UIAssets.UILoading);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ProfileGraphy", GameDefines.UIAssets.ProfileGraphy);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GFXConsole", GameDefines.UIAssets.GFXConsole);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UIPartsMaterialInfo", GameDefines.UIAssets.UIPartsMaterialInfo);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UITokenShop", GameDefines.UIAssets.UITokenShop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UIMultipleShop", GameDefines.UIAssets.UIMultipleShop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SceneRocketFireEffect", GameDefines.UIAssets.SceneRocketFireEffect);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SceneRocketSmokeEffect", GameDefines.UIAssets.SceneRocketSmokeEffect);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.UIAssets();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.UIAssets constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
