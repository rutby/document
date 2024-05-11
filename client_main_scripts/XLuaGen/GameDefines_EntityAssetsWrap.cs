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
    public class GameDefinesEntityAssetsWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.EntityAssets);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 76, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Building", GameDefines.EntityAssets.Building);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AllianceBuilding", GameDefines.EntityAssets.AllianceBuilding);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TouchTerrainEffect", GameDefines.EntityAssets.TouchTerrainEffect);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldCityGrass", GameDefines.EntityAssets.WorldCityGrass);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BatteryAttackRange", GameDefines.EntityAssets.BatteryAttackRange);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QuanEffectRange", GameDefines.EntityAssets.QuanEffectRange);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "World", GameDefines.EntityAssets.World);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "City", GameDefines.EntityAssets.City);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Wasteland_City", GameDefines.EntityAssets.Wasteland_City);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Wasteland_City_Dig", GameDefines.EntityAssets.Wasteland_City_Dig);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldSceneDesc", GameDefines.EntityAssets.WorldSceneDesc);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldEdenSceneDesc", GameDefines.EntityAssets.WorldEdenSceneDesc);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldSceneAllianceCityDesc", GameDefines.EntityAssets.WorldSceneAllianceCityDesc);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldMapZone", GameDefines.EntityAssets.WorldMapZone);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldEdenMapZone", GameDefines.EntityAssets.WorldEdenMapZone);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldEdenMapArea", GameDefines.EntityAssets.WorldEdenMapArea);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_World0_Low", GameDefines.EntityAssets.Terrain_World0_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_World0_High", GameDefines.EntityAssets.Terrain_World0_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TerrainSetting_Low", GameDefines.EntityAssets.TerrainSetting_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TerrainSetting_High", GameDefines.EntityAssets.TerrainSetting_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_Eden_World_Low", GameDefines.EntityAssets.Terrain_Eden_World_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_Eden_World_High", GameDefines.EntityAssets.Terrain_Eden_World_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EdenTerrainSetting_Low", GameDefines.EntityAssets.EdenTerrainSetting_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EdenTerrainSetting_High", GameDefines.EntityAssets.EdenTerrainSetting_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_City_Low", GameDefines.EntityAssets.Terrain_City_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Terrain_City_High", GameDefines.EntityAssets.Terrain_City_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TerrainSetting_City_Low", GameDefines.EntityAssets.TerrainSetting_City_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TerrainSetting_City_High", GameDefines.EntityAssets.TerrainSetting_City_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TroopLine", GameDefines.EntityAssets.TroopLine);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TroopDestinationSignal", GameDefines.EntityAssets.TroopDestinationSignal);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TroopLineDrag", GameDefines.EntityAssets.TroopLineDrag);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroop", GameDefines.EntityAssets.WorldTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopSample", GameDefines.EntityAssets.WorldTroopSample);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MonsterActBoss", GameDefines.EntityAssets.MonsterActBoss);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopAlliance", GameDefines.EntityAssets.WorldTroopAlliance);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopOther", GameDefines.EntityAssets.WorldTroopOther);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopYellow", GameDefines.EntityAssets.WorldTroopYellow);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldVirtualTroop", GameDefines.EntityAssets.WorldVirtualTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ScoutTroop", GameDefines.EntityAssets.ScoutTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ResTransTroop", GameDefines.EntityAssets.ResTransTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GolloesExploreTroop", GameDefines.EntityAssets.GolloesExploreTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GolloesTradeTroop", GameDefines.EntityAssets.GolloesTradeTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldRallyTroop", GameDefines.EntityAssets.WorldRallyTroop);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FieldMonster", GameDefines.EntityAssets.FieldMonster);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FieldBoss", GameDefines.EntityAssets.FieldBoss);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ConstructMaterial", GameDefines.EntityAssets.ConstructMaterial);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TileUnlocked", GameDefines.EntityAssets.TileUnlocked);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TileLocked", GameDefines.EntityAssets.TileLocked);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildGrid", GameDefines.EntityAssets.BuildGrid);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MonsterPath", GameDefines.EntityAssets.MonsterPath);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildBlock", GameDefines.EntityAssets.BuildBlock);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopSoldier", GameDefines.EntityAssets.WorldTroopSoldier);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopTank", GameDefines.EntityAssets.WorldTroopTank);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopPlane", GameDefines.EntityAssets.WorldTroopPlane);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldTroopJunkman", GameDefines.EntityAssets.WorldTroopJunkman);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildMetalFew", GameDefines.EntityAssets.BuildMetalFew);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildMetalMiddle", GameDefines.EntityAssets.BuildMetalMiddle);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildMetalMax", GameDefines.EntityAssets.BuildMetalMax);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildWoodFew", GameDefines.EntityAssets.BuildWoodFew);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildWoodMiddle", GameDefines.EntityAssets.BuildWoodMiddle);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildWoodMax", GameDefines.EntityAssets.BuildWoodMax);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DetectEventUI", GameDefines.EntityAssets.DetectEventUI);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CollectGarbageUI", GameDefines.EntityAssets.CollectGarbageUI);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CityWorkMan", GameDefines.EntityAssets.CityWorkMan);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FogPath", GameDefines.EntityAssets.FogPath);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CityCameraSand", GameDefines.EntityAssets.CityCameraSand);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldCityTreeHigh", GameDefines.EntityAssets.WorldCityTreeHigh);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldCityTree", GameDefines.EntityAssets.WorldCityTree);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FocusCurve", GameDefines.EntityAssets.FocusCurve);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GarbageStone", GameDefines.EntityAssets.GarbageStone);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GarbageCrystal", GameDefines.EntityAssets.GarbageCrystal);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CollectBuildModelSelf", GameDefines.EntityAssets.CollectBuildModelSelf);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CollectBuildModelAlliance", GameDefines.EntityAssets.CollectBuildModelAlliance);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CollectBuildModelEnemy", GameDefines.EntityAssets.CollectBuildModelEnemy);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AllianceBossModel", GameDefines.EntityAssets.AllianceBossModel);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.EntityAssets();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.EntityAssets constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
