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
    public class GameDefinesUILayerWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.UILayer);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 10, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Scene", GameDefines.UILayer.Scene);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Background", GameDefines.UILayer.Background);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UIResource", GameDefines.UILayer.UIResource);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Normal", GameDefines.UILayer.Normal);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Info", GameDefines.UILayer.Info);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Dialog", GameDefines.UILayer.Dialog);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Guide", GameDefines.UILayer.Guide);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TopMost", GameDefines.UILayer.TopMost);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Battle3D", GameDefines.UILayer.Battle3D);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "GameDefines.UILayer does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
