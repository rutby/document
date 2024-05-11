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
    public class GameDefinesTableNameWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(GameDefines.TableName);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 57, 0, 0);
			
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "APSMonster", GameDefines.TableName.APSMonster);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "APSHeros", GameDefines.TableName.APSHeros);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GuideTab", GameDefines.TableName.GuideTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "PlotTab", GameDefines.TableName.PlotTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "FieldMonster", GameDefines.TableName.FieldMonster);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "HeroTab", GameDefines.TableName.HeroTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GoodsTab", GameDefines.TableName.GoodsTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SkillTab", GameDefines.TableName.SkillTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BattleAnimation", GameDefines.TableName.BattleAnimation);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "StatusTab", GameDefines.TableName.StatusTab);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EquipRandomEffect", GameDefines.TableName.EquipRandomEffect);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AllianceGift", GameDefines.TableName.AllianceGift);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AllianceGiftGroup", GameDefines.TableName.AllianceGiftGroup);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AllianceItemWarehouse", GameDefines.TableName.AllianceItemWarehouse);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Territory", GameDefines.TableName.Territory);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TerritoryEffect", GameDefines.TableName.TerritoryEffect);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GoldrushBuilding", GameDefines.TableName.GoldrushBuilding);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ServerPos", GameDefines.TableName.ServerPos);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "SiegeNPC", GameDefines.TableName.SiegeNPC);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Diary", GameDefines.TableName.Diary);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ActivityShow", GameDefines.TableName.ActivityShow);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RightsEffectLevel", GameDefines.TableName.RightsEffectLevel);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "RightsEffect", GameDefines.TableName.RightsEffect);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "VipStoreUnlock", GameDefines.TableName.VipStoreUnlock);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "VipDetails", GameDefines.TableName.VipDetails);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldSeason", GameDefines.TableName.WorldSeason);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldBuilding", GameDefines.TableName.WorldBuilding);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DesertTalent", GameDefines.TableName.DesertTalent);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TalentShading", GameDefines.TableName.TalentShading);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "TalentHome", GameDefines.TableName.TalentHome);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DesertGoldmineWar", GameDefines.TableName.DesertGoldmineWar);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DesertTalentStats", GameDefines.TableName.DesertTalentStats);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Decompose", GameDefines.TableName.Decompose);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Missile", GameDefines.TableName.Missile);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "LoadingTips", GameDefines.TableName.LoadingTips);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Mail_ChannelID", GameDefines.TableName.Mail_ChannelID);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "QuestXml", GameDefines.TableName.QuestXml);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DesertSkillXml", GameDefines.TableName.DesertSkillXml);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GuideStep", GameDefines.TableName.GuideStep);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GuideStepContentInfo", GameDefines.TableName.GuideStepContentInfo);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Office", GameDefines.TableName.Office);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DoomsDayNote", GameDefines.TableName.DoomsDayNote);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "DD_Season_Group", GameDefines.TableName.DD_Season_Group);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Building", GameDefines.TableName.Building);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "BuildingDes", GameDefines.TableName.BuildingDes);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Chapter", GameDefines.TableName.Chapter);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "EffectName", GameDefines.TableName.EffectName);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Global", GameDefines.TableName.Global);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Talent", GameDefines.TableName.Talent);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "ResourceItem", GameDefines.TableName.ResourceItem);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "GatherResource", GameDefines.TableName.GatherResource);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "WorldCity", GameDefines.TableName.WorldCity);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "CityJunk", GameDefines.TableName.CityJunk);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Item", GameDefines.TableName.Item);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Decoration", GameDefines.TableName.Decoration);
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "Desert", GameDefines.TableName.Desert);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new GameDefines.TableName();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to GameDefines.TableName constructor!");
            
        }
        
		
        
		
        
        
        
        
        
        
        
        
        
		
		
		
		
    }
}
