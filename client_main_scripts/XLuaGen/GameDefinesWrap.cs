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
    public class GameDefinesWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 53, 8, 8);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ScreenScaler", GameDefines.ScreenScaler);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "NoChannelParam", GameDefines.NoChannelParam);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "UndisposedMail", GameDefines.UndisposedMail);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GreenBlockFree", GameDefines.GreenBlockFree);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RedBlockFree", GameDefines.RedBlockFree);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GreenFreeMoveKuang", GameDefines.GreenFreeMoveKuang);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RedFreeMoveKuang", GameDefines.RedFreeMoveKuang);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DefaultDialog", GameDefines.DefaultDialog);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EQUIP_SOLTCOUNT", GameDefines.EQUIP_SOLTCOUNT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AreaXSize", GameDefines.AreaXSize);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AreaYSize", GameDefines.AreaYSize);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TileXInArea", GameDefines.TileXInArea);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TileYInArea", GameDefines.TileYInArea);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MaxShowBuildBlockRange", GameDefines.MaxShowBuildBlockRange);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_TYPE_SPD", GameDefines.ITEM_TYPE_SPD);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MAIN_CITY_ID", GameDefines.MAIN_CITY_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONTH_CARD_ID", GameDefines.MONTH_CARD_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SUB_MONTH_CARD_ID", GameDefines.SUB_MONTH_CARD_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MONTH_CARD_REWARD_COUNT", GameDefines.MONTH_CARD_REWARD_COUNT);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "KINGDOM_KING_ID", GameDefines.KINGDOM_KING_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GREAT_KINGDOM_KING_ID", GameDefines.GREAT_KINGDOM_KING_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "INTRODE_KING_ID", GameDefines.INTRODE_KING_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FIRST_GIVE_HERO_ID", GameDefines.FIRST_GIVE_HERO_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SECOND_GIVE_HERO_ID", GameDefines.SECOND_GIVE_HERO_ID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_GENE", GameDefines.ITEM_GENE);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ITEM_RENAME", GameDefines.ITEM_RENAME);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FLT_EPSILON", GameDefines.FLT_EPSILON);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WB_SEASON_ACTIVITY", GameDefines.WB_SEASON_ACTIVITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WB_DECLARE_ACTIVITY", GameDefines.WB_DECLARE_ACTIVITY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ALLIANCE_NOTICE_KEY", GameDefines.ALLIANCE_NOTICE_KEY);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MIN_NAME_CHAR", GameDefines.MIN_NAME_CHAR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MAX_NAME_CHAR", GameDefines.MAX_NAME_CHAR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "MAX_MOOD_CHAR", GameDefines.MAX_MOOD_CHAR);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FBLuckyDrawKey", GameDefines.FBLuckyDrawKey);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DefaultMissile", GameDefines.DefaultMissile);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RandomTruckTargetMin", GameDefines.RandomTruckTargetMin);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RandomTruckInterval", GameDefines.RandomTruckInterval);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RandomPeopleTargetMin", GameDefines.RandomPeopleTargetMin);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RandomPeopleInterval", GameDefines.RandomPeopleInterval);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QualityLevel_Off", GameDefines.QualityLevel_Off);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QualityLevel_Low", GameDefines.QualityLevel_Low);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QualityLevel_Middle", GameDefines.QualityLevel_Middle);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QualityLevel_High", GameDefines.QualityLevel_High);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RenderScaleLow", GameDefines.RenderScaleLow);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GrayMaterialName", GameDefines.GrayMaterialName);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LookAtFocusTime", GameDefines.LookAtFocusTime);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FindCanBuildPointRange", GameDefines.FindCanBuildPointRange);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SaveGuideDoneValue", GameDefines.SaveGuideDoneValue);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Int32Bit", GameDefines.Int32Bit);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ByteSize", GameDefines.ByteSize);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Player_CareerID", GameDefines.Player_CareerID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CityPathFile", GameDefines.CityPathFile);
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "GuideBoardPos", _g_get_GuideBoardPos);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "WorldCityNameBGScale", _g_get_WorldCityNameBGScale);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "SkyBoxPosZ", _g_get_SkyBoxPosZ);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "SkyBoxPosZFreeGrass", _g_get_SkyBoxPosZFreeGrass);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "BlockPos", _g_get_BlockPos);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "BuildTileCenterDelta", _g_get_BuildTileCenterDelta);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "ConnectDirList", _g_get_ConnectDirList);
            Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "OffsetToDirectionMap", _g_get_OffsetToDirectionMap);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "GuideBoardPos", _s_set_GuideBoardPos);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "WorldCityNameBGScale", _s_set_WorldCityNameBGScale);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "SkyBoxPosZ", _s_set_SkyBoxPosZ);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "SkyBoxPosZFreeGrass", _s_set_SkyBoxPosZFreeGrass);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "BlockPos", _s_set_BlockPos);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "BuildTileCenterDelta", _s_set_BuildTileCenterDelta);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "ConnectDirList", _s_set_ConnectDirList);
            Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "OffsetToDirectionMap", _s_set_OffsetToDirectionMap);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            return LuaAPI.luaL_error(L, "GameDefines does not have a constructor!");
        }
        
		
        
		
        
        
        
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_GuideBoardPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, GameDefines.GuideBoardPos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_WorldCityNameBGScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.PushUnityEngineVector3(L, GameDefines.WorldCityNameBGScale);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SkyBoxPosZ(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, GameDefines.SkyBoxPosZ);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SkyBoxPosZFreeGrass(RealStatePtr L)
        {
		    try {
            
			    LuaAPI.xlua_pushinteger(L, GameDefines.SkyBoxPosZFreeGrass);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BlockPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.PushUnityEngineVector3(L, GameDefines.BlockPos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BuildTileCenterDelta(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, GameDefines.BuildTileCenterDelta);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_ConnectDirList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, GameDefines.ConnectDirList);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_OffsetToDirectionMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, GameDefines.OffsetToDirectionMap);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_GuideBoardPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			UnityEngine.Vector2Int gen_value;translator.Get(L, 1, out gen_value);
				GameDefines.GuideBoardPos = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_WorldCityNameBGScale(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			UnityEngine.Vector3 gen_value;translator.Get(L, 1, out gen_value);
				GameDefines.WorldCityNameBGScale = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_SkyBoxPosZ(RealStatePtr L)
        {
		    try {
                
			    GameDefines.SkyBoxPosZ = LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_SkyBoxPosZFreeGrass(RealStatePtr L)
        {
		    try {
                
			    GameDefines.SkyBoxPosZFreeGrass = LuaAPI.xlua_tointeger(L, 1);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_BlockPos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			UnityEngine.Vector3 gen_value;translator.Get(L, 1, out gen_value);
				GameDefines.BlockPos = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_BuildTileCenterDelta(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    GameDefines.BuildTileCenterDelta = (UnityEngine.Vector3[])translator.GetObject(L, 1, typeof(UnityEngine.Vector3[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_ConnectDirList(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    GameDefines.ConnectDirList = (System.Collections.Generic.List<DirectionType>)translator.GetObject(L, 1, typeof(System.Collections.Generic.List<DirectionType>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_OffsetToDirectionMap(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    GameDefines.OffsetToDirectionMap = (System.Collections.Generic.Dictionary<UnityEngine.Vector2Int, Direction>)translator.GetObject(L, 1, typeof(System.Collections.Generic.Dictionary<UnityEngine.Vector2Int, Direction>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
