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
    public class GameDefinesBuildingTypesWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.BuildingTypes);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 53, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_MAIN", GameDefines.BuildingTypes.FUN_BUILD_MAIN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_BUSINESS_CENTER", GameDefines.BuildingTypes.FUN_BUILD_BUSINESS_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_STABLE", GameDefines.BuildingTypes.FUN_BUILD_STABLE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_SCIENE", GameDefines.BuildingTypes.FUN_BUILD_SCIENE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_SMITHY", GameDefines.BuildingTypes.FUN_BUILD_SMITHY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_CONDOMINIUM", GameDefines.BuildingTypes.FUN_BUILD_CONDOMINIUM);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_HOSPITAL", GameDefines.BuildingTypes.FUN_BUILD_HOSPITAL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_STONE", GameDefines.BuildingTypes.FUN_BUILD_STONE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OIL", GameDefines.BuildingTypes.FUN_BUILD_OIL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_ARROW_TOWER", GameDefines.BuildingTypes.FUN_BUILD_ARROW_TOWER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_CAR_BARRACK", GameDefines.BuildingTypes.FUN_BUILD_CAR_BARRACK);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_INFANTRY_BARRACK", GameDefines.BuildingTypes.FUN_BUILD_INFANTRY_BARRACK);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_AIRCRAFT_BARRACK", GameDefines.BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TRAINFIELD_1", GameDefines.BuildingTypes.FUN_BUILD_TRAINFIELD_1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TRAINFIELD_2", GameDefines.BuildingTypes.FUN_BUILD_TRAINFIELD_2);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TRAINFIELD_3", GameDefines.BuildingTypes.FUN_BUILD_TRAINFIELD_3);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TRAINFIELD_4", GameDefines.BuildingTypes.FUN_BUILD_TRAINFIELD_4);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_WATER", GameDefines.BuildingTypes.FUN_BUILD_WATER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_MARKET", GameDefines.BuildingTypes.FUN_BUILD_MARKET);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_ROAD", GameDefines.BuildingTypes.FUN_BUILD_ROAD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_ELECTRICITY_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_WATER_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_WATER_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OIL_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_OIL_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_IRON_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_IRON_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_WIND_TURBINE", GameDefines.BuildingTypes.FUN_BUILD_WIND_TURBINE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_SOLAR_POWER_STATION", GameDefines.BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_DRONE", GameDefines.BuildingTypes.FUN_BUILD_DRONE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_VILLA", GameDefines.BuildingTypes.FUN_BUILD_VILLA);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OXYGEN", GameDefines.BuildingTypes.FUN_BUILD_OXYGEN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_INTEGRATED_FACTORY", GameDefines.BuildingTypes.FUN_BUILD_INTEGRATED_FACTORY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TRADING_CENTER", GameDefines.BuildingTypes.FUN_BUILD_TRADING_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_INFORMATION_CENTER", GameDefines.BuildingTypes.FUN_BUILD_INFORMATION_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_COLD_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_COLD_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_COMPREHENSIVE_STORAGE", GameDefines.BuildingTypes.FUN_BUILD_COMPREHENSIVE_STORAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_DEFENCE_CENTER", GameDefines.BuildingTypes.FUN_BUILD_DEFENCE_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_DOME", GameDefines.BuildingTypes.FUN_BUILD_DOME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_FORGE", GameDefines.BuildingTypes.FUN_BUILD_FORGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_ELECTRICITY", GameDefines.BuildingTypes.FUN_BUILD_ELECTRICITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_RECHARGE_GARAGE", GameDefines.BuildingTypes.FUN_BUILD_RECHARGE_GARAGE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_HONOR_HALL", GameDefines.BuildingTypes.FUN_BUILD_HONOR_HALL);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_BUILDING_CENTER", GameDefines.BuildingTypes.FUN_BUILD_BUILDING_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OFFICER", GameDefines.BuildingTypes.FUN_BUILD_OFFICER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "APS_BUILD_WORMHOLE_MAIN", GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_MAIN);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "APS_BUILD_WORMHOLE_SUB", GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WORM_HOLE_CROSS", GameDefines.BuildingTypes.WORM_HOLE_CROSS);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_RADAR_CENTER", GameDefines.BuildingTypes.FUN_BUILD_RADAR_CENTER);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_TEMP_WIND_POWER_PLANT", GameDefines.BuildingTypes.FUN_BUILD_TEMP_WIND_POWER_PLANT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OUT_WOOD", GameDefines.BuildingTypes.FUN_BUILD_OUT_WOOD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FUN_BUILD_OUT_STONE", GameDefines.BuildingTypes.FUN_BUILD_OUT_STONE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EDEN_WORM_HOLE_1", GameDefines.BuildingTypes.EDEN_WORM_HOLE_1);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EDEN_WORM_HOLE_2", GameDefines.BuildingTypes.EDEN_WORM_HOLE_2);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EDEN_WORM_HOLE_3", GameDefines.BuildingTypes.EDEN_WORM_HOLE_3);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.BuildingTypes();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.BuildingTypes constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
