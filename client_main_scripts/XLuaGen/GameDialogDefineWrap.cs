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
    public class GameDialogDefineWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDialogDefine);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 76, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SELECT_ITEM", GameDialogDefine.SELECT_ITEM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SELECT", GameDialogDefine.SELECT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD_LIMIT_OTHERBASE_RANGE", GameDialogDefine.BUILD_LIMIT_OTHERBASE_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD_BOARD_LIMIT_MYBASE_RANGE", GameDialogDefine.BUILD_BOARD_LIMIT_MYBASE_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD_ROAD_LIMIT_MYBASE_RANGE", GameDialogDefine.BUILD_ROAD_LIMIT_MYBASE_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD", GameDialogDefine.BUILD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "REMOVE", GameDialogDefine.REMOVE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OWN", GameDialogDefine.OWN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OUT", GameDialogDefine.OUT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "STORAGE", GameDialogDefine.STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "REPORT", GameDialogDefine.REPORT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TASK", GameDialogDefine.TASK);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COMMANDERINFO", GameDialogDefine.COMMANDERINFO);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LEVEL_NUMBER", GameDialogDefine.LEVEL_NUMBER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SPLIT", GameDialogDefine.SPLIT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COMMANDER_REPORT", GameDialogDefine.COMMANDER_REPORT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UIMAINBOTTOM_COMMANDER_TIP", GameDialogDefine.UIMAINBOTTOM_COMMANDER_TIP);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TIME", GameDialogDefine.TIME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NEED_MINE", GameDialogDefine.NEED_MINE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NEED_BUILD_BUILDING", GameDialogDefine.NEED_BUILD_BUILDING);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GOODS", GameDialogDefine.GOODS);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OIL", GameDialogDefine.OIL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "METAL", GameDialogDefine.METAL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NUCLEAR", GameDialogDefine.NUCLEAR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FOOD", GameDialogDefine.FOOD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OXYGEN", GameDialogDefine.OXYGEN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TRADE_PERCENT", GameDialogDefine.TRADE_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "HOUSE_PERCENT", GameDialogDefine.HOUSE_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "HOSPITAL_PERCENT", GameDialogDefine.HOSPITAL_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SCIENCE_PERCENT", GameDialogDefine.SCIENCE_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD_PERCENT", GameDialogDefine.BUILD_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ENVIRONMENT_PERCENT", GameDialogDefine.ENVIRONMENT_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WATER", GameDialogDefine.WATER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ELECTRICITY", GameDialogDefine.ELECTRICITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PEOPLE", GameDialogDefine.PEOPLE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONEY", GameDialogDefine.MONEY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LACK_RESOURCE", GameDialogDefine.LACK_RESOURCE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LACK_ELECTRCITY_TIP", GameDialogDefine.LACK_ELECTRCITY_TIP);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CAN_PUT", GameDialogDefine.CAN_PUT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NO_PUT_REASON", GameDialogDefine.NO_PUT_REASON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "INCLUD_MINEPOINT", GameDialogDefine.INCLUD_MINEPOINT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "INCLUDE_MINERANGE_POINT", GameDialogDefine.INCLUDE_MINERANGE_POINT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RESOURCE_BUILD_PUT_MINERANGE_POINT", GameDialogDefine.RESOURCE_BUILD_PUT_MINERANGE_POINT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OUT_MYBASE_RANGE", GameDialogDefine.OUT_MYBASE_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "IN_OTHERBASE_RANGE", GameDialogDefine.IN_OTHERBASE_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NO_PUT_RANGE", GameDialogDefine.NO_PUT_RANGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "INCLUDE_BUILDING", GameDialogDefine.INCLUDE_BUILDING);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "THIS_UPGRADING", GameDialogDefine.THIS_UPGRADING);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UNDO", GameDialogDefine.UNDO);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RANDOM", GameDialogDefine.RANDOM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NEW_BASE_RESOURCE_PERCENT", GameDialogDefine.NEW_BASE_RESOURCE_PERCENT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "INCLUDE_OTHER_MINERANGE_POINT", GameDialogDefine.INCLUDE_OTHER_MINERANGE_POINT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "OUT_UNLOCK_RANGE_REASON", GameDialogDefine.OUT_UNLOCK_RANGE_REASON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UNCONNECT_BOARD_REASON", GameDialogDefine.UNCONNECT_BOARD_REASON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UNCONNECT_ROAD_REASON", GameDialogDefine.UNCONNECT_ROAD_REASON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ONLY_IN_INSIDE", GameDialogDefine.ONLY_IN_INSIDE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ONLY_OUT_INSIDE", GameDialogDefine.ONLY_OUT_INSIDE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ONLY_IN_MAIN_INSIDE", GameDialogDefine.ONLY_IN_MAIN_INSIDE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NOT_BUILD_ON_BASE_EXPANSION", GameDialogDefine.NOT_BUILD_ON_BASE_EXPANSION);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NOT_BUILD_ON_WORLD_RESOURCE", GameDialogDefine.NOT_BUILD_ON_WORLD_RESOURCE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ONLY_BUILD_ROAD", GameDialogDefine.ONLY_BUILD_ROAD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BUILD_UN_CONNECT", GameDialogDefine.BUILD_UN_CONNECT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NEED_FIRST_BUILD", GameDialogDefine.NEED_FIRST_BUILD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RESET", GameDialogDefine.RESET);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONSTER", GameDialogDefine.MONSTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "COLLECT_RESOURCE_DESTROY", GameDialogDefine.COLLECT_RESOURCE_DESTROY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NO_PUT_ROAD", GameDialogDefine.NO_PUT_ROAD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GOTO", GameDialogDefine.GOTO);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ROAD_UN_CONNECT", GameDialogDefine.ROAD_UN_CONNECT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ROAD_REACH_BUILD_MAX", GameDialogDefine.ROAD_REACH_BUILD_MAX);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LEFT", GameDialogDefine.LEFT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GUIDE_BUILD_ROAD", GameDialogDefine.GUIDE_BUILD_ROAD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NO_ARRIVE_FOG", GameDialogDefine.NO_ARRIVE_FOG);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CONFIRM", GameDialogDefine.CONFIRM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CANCEL", GameDialogDefine.CANCEL);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDialogDefine();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDialogDefine constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
