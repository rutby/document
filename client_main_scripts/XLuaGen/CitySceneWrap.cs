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
    public class CitySceneWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(CityScene);
			Utils.BeginObjectRegister(type, L, translator, 0, 233, 30, 10);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Init", _m_Init);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateScene", _m_CreateScene);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveFakeSampleMarchData", _m_RemoveFakeSampleMarchData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateFakeSampleMarchDataWhenBack", _m_UpdateFakeSampleMarchDataWhenBack);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateFakeSampleMarchDataWhenStartPick", _m_UpdateFakeSampleMarchDataWhenStartPick);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddFakeSampleMarchData", _m_AddFakeSampleMarchData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EndDig", _m_EndDig);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UninitSubModulesAndCameraUpdate", _m_UninitSubModulesAndCameraUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Uninit", _m_Uninit);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeQualitySetting", _m_ChangeQualitySetting);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Update", _m_Update);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FixedUpdate", _m_FixedUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TileToWorld", _m_TileToWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WorldToTile", _m_WorldToTile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SnapToTileCenter", _m_SnapToTileCenter);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TileFloatToWorld", _m_TileFloatToWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WorldToTileFloat", _m_WorldToTileFloat);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IndexToTilePos", _m_IndexToTilePos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TilePosToIndex", _m_TilePosToIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TileIndexToWorld", _m_TileIndexToWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WorldToTileIndex", _m_WorldToTileIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TileDistance", _m_TileDistance);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetWorldSize", _m_SetWorldSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetRangeValue", _m_SetRangeValue);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsTileOccupyed", _m_IsTileOccupyed);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDesertPoint", _m_GetDesertPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDesertPointList", _m_GetDesertPointList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ChangeServer", _m_ChangeServer);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnChangeServerRemove", _m_OnChangeServerRemove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnChangeServerTypeRefresh", _m_OnChangeServerTypeRefresh);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveBlackDesert", _m_RemoveBlackDesert);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateDragonLandRange", _m_CreateDragonLandRange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveDragonLandRange", _m_RemoveDragonLandRange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InitBlackBlock", _m_InitBlackBlock);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSelfAllianceList", _m_GetSelfAllianceList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDragonPointDic", _m_GetDragonPointDic);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetIndexByOffset", _m_GetIndexByOffset);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetIndexByOffsetByDirection", _m_GetIndexByOffsetByDirection);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnPlayerBankruptcyFinish", _m_OnPlayerBankruptcyFinish);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnExtendDome", _m_OnExtendDome);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowBattleBlood", _m_ShowBattleBlood);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RegisterPhysics", _m_RegisterPhysics);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetBuildTileByItemId", _m_GetBuildTileByItemId);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UnregisterPhysics", _m_UnregisterPhysics);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTouchTilePos", _m_GetTouchTilePos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTouchPoint", _m_GetTouchPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetRaycastGroundPoint", _m_GetRaycastGroundPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AutoFocus", _m_AutoFocus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "QuitFocus", _m_QuitFocus);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLodDistance", _m_GetLodDistance);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetRotation", _m_GetRotation);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMapIconScale", _m_GetMapIconScale);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCameraPos", _m_GetCameraPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ScreenPointToRay", _m_ScreenPointToRay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMinLodDistance", _m_GetMinLodDistance);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "WorldToScreenPoint", _m_WorldToScreenPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Lookat", _m_Lookat);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AutoLookat", _m_AutoLookat);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AutoZoom", _m_AutoZoom);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ScreenPointToWorld", _m_ScreenPointToWorld);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLodLevel", _m_GetLodLevel);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TrackMarch", _m_TrackMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "TrackMarchV2", _m_TrackMarchV2);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisTrackMarch", _m_DisTrackMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisablePostProcess", _m_DisablePostProcess);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "EnablePostProcess", _m_EnablePostProcess);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetTouchInputControllerEnable", _m_SetTouchInputControllerEnable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCameraTouchEnable", _m_SetCameraTouchEnable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTouchInputControllerEnable", _m_GetTouchInputControllerEnable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StopCameraMove", _m_StopCameraMove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetIndexByOffset_New", _m_GetIndexByOffset_New);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetIndexByOffsetByDirection_New", _m_GetIndexByOffsetByDirection_New);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetZoomParams", _m_SetZoomParams);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCameraFOV", _m_SetCameraFOV);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetZoomParams", _m_GetZoomParams);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetFOV", _m_GetFOV);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInMap", _m_IsInMap);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInMapByIndex", _m_IsInMapByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetZoneIdByPosId", _m_GetZoneIdByPosId);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetMapZoneActive", _m_SetMapZoneActive);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FindingPathForEden", _m_FindingPathForEden);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAreaIdByPosId", _m_GetAreaIdByPosId);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClampTilePos", _m_ClampTilePos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCollectResourceBuildRange", _m_GetCollectResourceBuildRange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCollectResourceTile", _m_GetCollectResourceTile);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGlobalShaderLOD", _m_GetGlobalShaderLOD);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetGlobalShaderLOD", _m_SetGlobalShaderLOD);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetProfileTerrainSwitch", _m_GetProfileTerrainSwitch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ProfileToggleTerrain", _m_ProfileToggleTerrain);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetProfileBuildingSwitch", _m_GetProfileBuildingSwitch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ProfileToggleBuilding", _m_ProfileToggleBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetProfileStaticSwitch", _m_GetProfileStaticSwitch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ProfileToggleStatic", _m_ProfileToggleStatic);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetHeightFogSwitch", _m_GetHeightFogSwitch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ProfileToggleHeightFog", _m_ProfileToggleHeightFog);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGraphySwitch", _m_GetGraphySwitch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ProfileToggleMarch", _m_ProfileToggleMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetExplorePointInfoByIndex", _m_GetExplorePointInfoByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSamplePointInfoByIndex", _m_GetSamplePointInfoByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetResourcePointInfoByIndex", _m_GetResourcePointInfoByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsCollectRangePoint", _m_IsCollectRangePoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPointInfo", _m_GetPointInfo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetWorldTileInfo", _m_GetWorldTileInfo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCollectPoint", _m_GetCollectPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAllCollectRangePoint", _m_GetAllCollectRangePoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAllCollectRangePointType", _m_GetAllCollectRangePointType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsCollectPoint", _m_IsCollectPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGarbagePointInfoByIndex", _m_GetGarbagePointInfoByIndex);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPointInfoByUuid", _m_GetPointInfoByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDesertInfoByUuid", _m_GetDesertInfoByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetObjectByPoint", _m_GetObjectByPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowObject", _m_ShowObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetBuildingByPoint", _m_GetBuildingByPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetBuildingHeight", _m_GetBuildingHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleViewPointsReply", _m_HandleViewPointsReply);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleViewUpdateNotify", _m_HandleViewUpdateNotify);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleViewTileUpdateNotify", _m_HandleViewTileUpdateNotify);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SendViewRequest", _m_SendViewRequest);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsBuildFinish", _m_IsBuildFinish);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetObjectByUuid", _m_GetObjectByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetBuildingByUuid", _m_GetBuildingByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetWorldBuildingByPoint", _m_GetWorldBuildingByPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetWorldBuildingByUuid", _m_GetWorldBuildingByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HasPointInfo", _m_HasPointInfo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddToDeleteList", _m_AddToDeleteList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HideObject", _m_HideObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsSelfPoint", _m_IsSelfPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPointType", _m_GetPointType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsSelfFreeBoard", _m_IsSelfFreeBoard);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddObjectByPoint", _m_AddObjectByPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveObjectByPoint", _m_RemoveObjectByPoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveOneObjectByPointType", _m_RemoveOneObjectByPointType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RefreshView", _m_RefreshView);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnMainBuildMove", _m_OnMainBuildMove);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateViewRequest", _m_UpdateViewRequest);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetGarbagePoint", _m_GetGarbagePoint);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateGroupTroop", _m_CreateGroupTroop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMarch", _m_GetMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsTargetForMine", _m_IsTargetForMine);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetRallyMarchIndexByUuid", _m_GetRallyMarchIndexByUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "StartMarch", _m_StartMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetOwnerFormationMarch", _m_GetOwnerFormationMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetAllianceMarchesInTeam", _m_GetAllianceMarchesInTeam);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetOwnerMarches", _m_GetOwnerMarches);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDragonMarch", _m_GetDragonMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandlePushWorldMarchAdd", _m_HandlePushWorldMarchAdd);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandlePushWorldMarchDel", _m_HandlePushWorldMarchDel);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleWorldMarchGet", _m_HandleWorldMarchGet);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleFormationMarch", _m_HandleFormationMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HandleFormationMarchChange", _m_HandleFormationMarchChange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ExistMarch", _m_ExistMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInRallyMarch", _m_IsInRallyMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInCollectMarch", _m_IsInCollectMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsInAssistanceMarch", _m_IsInAssistanceMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsSelfInCurrentMarchTeam", _m_IsSelfInCurrentMarchTeam);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMarchesTargetForMine", _m_GetMarchesTargetForMine);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetMarchesBossInfo", _m_GetMarchesBossInfo);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CanUseInput", _m_CanUseInput);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUseInput", _m_SetUseInput);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetSelectedPickable", _m_SetSelectedPickable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowLoad", _m_ShowLoad);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetDragFormationData", _m_SetDragFormationData);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetClickWorldBulidingPos", _m_GetClickWorldBulidingPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "HideTouchEffect", _m_HideTouchEffect);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetRaycastHitMarch", _m_GetRaycastHitMarch);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsTileWalkable", _m_IsTileWalkable);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddOccupyPoints", _m_AddOccupyPoints);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveOccupyPoints", _m_RemoveOccupyPoints);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetStaticVisibleChunk", _m_SetStaticVisibleChunk);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetModelHeight", _m_GetModelHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTroop", _m_GetTroop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddBullet", _m_AddBullet);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddBulletV2", _m_AddBulletV2);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetDestinationType", _m_GetDestinationType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTargetType", _m_GetTargetType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateBattleVFX", _m_CreateBattleVFX);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnTroopDragUpdate", _m_OnTroopDragUpdate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnTroopDragStop", _m_OnTroopDragStop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPointSize", _m_GetPointSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "IsTroopCreate", _m_IsTroopCreate);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateTroop", _m_CreateTroop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateTroop", _m_UpdateTroop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DestroyTroop", _m_DestroyTroop);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateTroopLine", _m_CreateTroopLine);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DestroyTroopLine", _m_DestroyTroopLine);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateTroopLine", _m_UpdateTroopLine);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTimeFromCurPosToTargetPos", _m_GetTimeFromCurPosToTargetPos);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "FindPath", _m_FindPath);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveCullingBounds", _m_RemoveCullingBounds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddCullingBounds", _m_AddCullingBounds);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "BattleFinish", _m_BattleFinish);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateBattleMessage", _m_UpdateBattleMessage);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UICreateBuilding", _m_UICreateBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UICreateAllianceBuilding", _m_UICreateAllianceBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIChangeBuilding", _m_UIChangeBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIDestroyBuilding", _m_UIDestroyBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIChangeAllianceBuilding", _m_UIChangeAllianceBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIDestroyAllianceBuilding", _m_UIDestroyAllianceBuilding);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIDestroyRreCreateBuild", _m_UIDestroyRreCreateBuild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UIDestroyRreCreateAllianceBuild", _m_UIDestroyRreCreateAllianceBuild);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddObjectByPointId", _m_AddObjectByPointId);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetObjectByPointId", _m_GetObjectByPointId);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "InitFogOfWar", _m_InitFogOfWar);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReInitFogOfWar", _m_ReInitFogOfWar);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UnlockFogOfWar", _m_UnlockFogOfWar);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UnlockFogOfWar2x2", _m_UnlockFogOfWar2x2);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetFogVisible", _m_SetFogVisible);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RegisterFogCompleteAction", _m_RegisterFogCompleteAction);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ReInitObject", _m_ReInitObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearReInitObject", _m_ClearReInitObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetFormationUuid", _m_GetFormationUuid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetLodConfigs", _m_GetLodConfigs);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddLodAdjuster", _m_AddLodAdjuster);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveLodAdjuster", _m_RemoveLodAdjuster);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetVisibleByPointType", _m_SetVisibleByPointType);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetSpecialPointDic", _m_GetSpecialPointDic);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCameraMaxHeight", _m_SetCameraMaxHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCameraMaxHeight", _m_GetCameraMaxHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetCameraMinHeight", _m_SetCameraMinHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetCameraMinHeight", _m_GetCameraMinHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetCameraMaxHeight", _m_ResetCameraMaxHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ResetCameraMinHeight", _m_ResetCameraMinHeight);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetPreviousLodDistance", _m_GetPreviousLodDistance);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DrawBuildGrid", _m_DrawBuildGrid);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddAutoFace", _m_AddAutoFace);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveAutoFace", _m_RemoveAutoFace);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AddAutoScale", _m_AddAutoScale);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "RemoveAutoScale", _m_RemoveAutoScale);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTerrainGameObject", _m_GetTerrainGameObject);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUSkyLightingPointDistanceFalloff", _m_SetUSkyLightingPointDistanceFalloff);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetUSkyLightingPointDistanceFalloff", _m_GetUSkyLightingPointDistanceFalloff);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetUSkyActive", _m_SetUSkyActive);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "AfterUpdate", _e_AfterUpdate);
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "BlockCount", _g_get_BlockCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "BlockSize", _g_get_BlockSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TileSize", _g_get_TileSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TileCount", _g_get_TileCount);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "DynamicObjNode", _g_get_DynamicObjNode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "BuildBubbleNode", _g_get_BuildBubbleNode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Transform", _g_get_Transform);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTileCountXMin", _g_get_CurTileCountXMin);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTileCountXMax", _g_get_CurTileCountXMax);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTileCountYMin", _g_get_CurTileCountYMin);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTileCountYMax", _g_get_CurTileCountYMax);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "WorldSize", _g_get_WorldSize);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "BlackLandSpeed", _g_get_BlackLandSpeed);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTarget", _g_get_CurTarget);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "InitZoom", _g_get_InitZoom);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Zoom", _g_get_Zoom);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CanMoving", _g_get_CanMoving);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "TouchInputController", _g_get_TouchInputController);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "IsFocus", _g_get_IsFocus);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTilePos", _g_get_CurTilePos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "CurTilePosClamped", _g_get_CurTilePosClamped);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Enabled", _g_get_Enabled);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "frameBufferWidth", _g_get_frameBufferWidth);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "frameBufferHeight", _g_get_frameBufferHeight);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "curIndex", _g_get_curIndex);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "marchUuid", _g_get_marchUuid);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "touchPickablePos", _g_get_touchPickablePos);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "SelectBuild", _g_get_SelectBuild);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "preCreateBuild", _g_get_preCreateBuild);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "placeFalseBuild", _g_get_placeFalseBuild);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "InitZoom", _s_set_InitZoom);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Zoom", _s_set_Zoom);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "CanMoving", _s_set_CanMoving);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "Enabled", _s_set_Enabled);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "curIndex", _s_set_curIndex);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "marchUuid", _s_set_marchUuid);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "touchPickablePos", _s_set_touchPickablePos);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "SelectBuild", _s_set_SelectBuild);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "preCreateBuild", _s_set_preCreateBuild);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "placeFalseBuild", _s_set_placeFalseBuild);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 1, 0);
			
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "LodArray", _g_get_LodArray);
            
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new CityScene();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _go = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.Init( _go );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateScene(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& translator.Assignable<System.Action>(L, 2)) 
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.CreateScene( _callback );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.CreateScene(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.CreateScene!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveFakeSampleMarchData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _index = LuaAPI.lua_toint64(L, 2);
                    
                    gen_to_be_invoked.RemoveFakeSampleMarchData( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateFakeSampleMarchDataWhenBack(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _index = LuaAPI.lua_toint64(L, 2);
                    long _startTime = LuaAPI.lua_toint64(L, 3);
                    long _endTime = LuaAPI.lua_toint64(L, 4);
                    
                    gen_to_be_invoked.UpdateFakeSampleMarchDataWhenBack( _index, _startTime, _endTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateFakeSampleMarchDataWhenStartPick(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _index = LuaAPI.lua_toint64(L, 2);
                    long _endTime = LuaAPI.lua_toint64(L, 3);
                    
                    gen_to_be_invoked.UpdateFakeSampleMarchDataWhenStartPick( _index, _endTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddFakeSampleMarchData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _startIndex = LuaAPI.lua_toint64(L, 2);
                    long _endIndex = LuaAPI.lua_toint64(L, 3);
                    long _startTime = LuaAPI.lua_toint64(L, 4);
                    long _endTime = LuaAPI.lua_toint64(L, 5);
                    
                    gen_to_be_invoked.AddFakeSampleMarchData( _startIndex, _endIndex, _startTime, _endTime );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EndDig(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.EndDig(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UninitSubModulesAndCameraUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UninitSubModulesAndCameraUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Uninit(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Uninit(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeQualitySetting(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ChangeQualitySetting(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Update(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.Update(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FixedUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.FixedUpdate(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TileToWorld(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    int _tilePosX = LuaAPI.xlua_tointeger(L, 2);
                    int _tilePosY = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TileToWorld( _tilePosX, _tilePosY );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector2Int>(L, 2)) 
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.TileToWorld( _tilePos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.TileToWorld!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WorldToTile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    
                        var gen_ret = gen_to_be_invoked.WorldToTile( _worldPos );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SnapToTileCenter(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    
                        var gen_ret = gen_to_be_invoked.SnapToTileCenter( _worldPos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TileFloatToWorld(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _x = (float)LuaAPI.lua_tonumber(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.TileFloatToWorld( _x, _y );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector2>(L, 2)) 
                {
                    UnityEngine.Vector2 _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.TileFloatToWorld( _tilePos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.TileFloatToWorld!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WorldToTileFloat(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    
                        var gen_ret = gen_to_be_invoked.WorldToTileFloat( _worldPos );
                        translator.PushUnityEngineVector2(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IndexToTilePos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IndexToTilePos( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TilePosToIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.TilePosToIndex( _tilePos );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TileIndexToWorld(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.TileIndexToWorld( _index );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WorldToTileIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _pos;translator.Get(L, 2, out _pos);
                    
                        var gen_ret = gen_to_be_invoked.WorldToTileIndex( _pos );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TileDistance(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _a;translator.Get(L, 2, out _a);
                    UnityEngine.Vector2Int _b;translator.Get(L, 3, out _b);
                    
                        var gen_ret = gen_to_be_invoked.TileDistance( _a, _b );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetWorldSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _size = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetWorldSize( _size );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetRangeValue(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _Xmin = LuaAPI.xlua_tointeger(L, 2);
                    int _Ymin = LuaAPI.xlua_tointeger(L, 3);
                    int _Xmax = LuaAPI.xlua_tointeger(L, 4);
                    int _Ymax = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.SetRangeValue( _Xmin, _Ymin, _Xmax, _Ymax );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsTileOccupyed(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsTileOccupyed( _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector2Int>(L, 2)) 
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.IsTileOccupyed( _tilePos );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.IsTileOccupyed!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDesertPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _lv = LuaAPI.xlua_tointeger(L, 2);
                    int _type = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetDesertPoint( _lv, _type );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDesertPointList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetDesertPointList(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ChangeServer(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _serverId = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ChangeServer( _serverId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnChangeServerRemove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnChangeServerRemove(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnChangeServerTypeRefresh(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnChangeServerTypeRefresh(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveBlackDesert(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RemoveBlackDesert(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateDragonLandRange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CreateDragonLandRange(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveDragonLandRange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RemoveDragonLandRange(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitBlackBlock(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.InitBlackBlock(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSelfAllianceList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetSelfAllianceList(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDragonPointDic(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetDragonPointDic(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIndexByOffset(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _x = LuaAPI.xlua_tointeger(L, 3);
                    int _y = LuaAPI.xlua_tointeger(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset( _index, _x, _y );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _x = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset( _index, _x );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset( _index );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.GetIndexByOffset!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIndexByOffsetByDirection(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _dir = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffsetByDirection( _index, _dir );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnPlayerBankruptcyFinish(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _uid = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.OnPlayerBankruptcyFinish( _uid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnExtendDome(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnExtendDome(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowBattleBlood(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<object>(L, 2)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    object _param = translator.GetObject(L, 2, typeof(object));
                    string _path = LuaAPI.lua_tostring(L, 3);
                    
                    gen_to_be_invoked.ShowBattleBlood( _param, _path );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<object>(L, 2)) 
                {
                    object _param = translator.GetObject(L, 2, typeof(object));
                    
                    gen_to_be_invoked.ShowBattleBlood( _param );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.ShowBattleBlood!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RegisterPhysics(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.MonoBehaviour _obj = (UnityEngine.MonoBehaviour)translator.GetObject(L, 2, typeof(UnityEngine.MonoBehaviour));
                    
                    gen_to_be_invoked.RegisterPhysics( _obj );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildTileByItemId(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _itemId = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetBuildTileByItemId( _itemId );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnregisterPhysics(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.MonoBehaviour _obj = (UnityEngine.MonoBehaviour)translator.GetObject(L, 2, typeof(UnityEngine.MonoBehaviour));
                    
                    gen_to_be_invoked.UnregisterPhysics( _obj );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTouchTilePos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetTouchTilePos(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTouchPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 1) 
                {
                    
                        var gen_ret = gen_to_be_invoked.GetTouchPoint(  );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector3>(L, 2)) 
                {
                    UnityEngine.Vector3 _screenPos;translator.Get(L, 2, out _screenPos);
                    
                        var gen_ret = gen_to_be_invoked.GetTouchPoint( _screenPos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.GetTouchPoint!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRaycastGroundPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _screenPos;translator.Get(L, 2, out _screenPos);
                    
                        var gen_ret = gen_to_be_invoked.GetRaycastGroundPoint( _screenPos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AutoFocus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 7&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<LookAtFocusState>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)&& translator.Assignable<System.Action>(L, 7)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    LookAtFocusState _state;translator.Get(L, 3, out _state);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _focusToCenter = LuaAPI.lua_toboolean(L, 5);
                    bool _lockView = LuaAPI.lua_toboolean(L, 6);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 7);
                    
                    gen_to_be_invoked.AutoFocus( _lookat, _state, _time, _focusToCenter, _lockView, _onComplete );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<LookAtFocusState>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    LookAtFocusState _state;translator.Get(L, 3, out _state);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _focusToCenter = LuaAPI.lua_toboolean(L, 5);
                    bool _lockView = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.AutoFocus( _lookat, _state, _time, _focusToCenter, _lockView );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<LookAtFocusState>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 5)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    LookAtFocusState _state;translator.Get(L, 3, out _state);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    bool _focusToCenter = LuaAPI.lua_toboolean(L, 5);
                    
                    gen_to_be_invoked.AutoFocus( _lookat, _state, _time, _focusToCenter );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<LookAtFocusState>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    LookAtFocusState _state;translator.Get(L, 3, out _state);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.AutoFocus( _lookat, _state, _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.AutoFocus!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_QuitFocus(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _time = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.QuitFocus( _time );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLodDistance(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetLodDistance(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRotation(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetRotation(  );
                        translator.PushUnityEngineQuaternion(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMapIconScale(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetMapIconScale(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCameraPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCameraPos(  );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPointToRay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _pos;translator.Get(L, 2, out _pos);
                    
                        var gen_ret = gen_to_be_invoked.ScreenPointToRay( _pos );
                        translator.PushUnityEngineRay(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMinLodDistance(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetMinLodDistance(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_WorldToScreenPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    
                        var gen_ret = gen_to_be_invoked.WorldToScreenPoint( _worldPos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Lookat(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _lookWorldPosition;translator.Get(L, 2, out _lookWorldPosition);
                    
                    gen_to_be_invoked.Lookat( _lookWorldPosition );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AutoLookat(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 5&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<System.Action>(L, 5)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 3);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 5);
                    
                    gen_to_be_invoked.AutoLookat( _lookat, _zoom, _time, _onComplete );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 3);
                    float _time = (float)LuaAPI.lua_tonumber(L, 4);
                    
                    gen_to_be_invoked.AutoLookat( _lookat, _zoom, _time );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.AutoLookat( _lookat, _zoom );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector3>(L, 2)) 
                {
                    UnityEngine.Vector3 _lookat;translator.Get(L, 2, out _lookat);
                    
                    gen_to_be_invoked.AutoLookat( _lookat );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.AutoLookat!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AutoZoom(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& translator.Assignable<System.Action>(L, 4)) 
                {
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 2);
                    float _time = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action _onComplete = translator.GetDelegate<System.Action>(L, 4);
                    
                    gen_to_be_invoked.AutoZoom( _zoom, _time, _onComplete );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 2);
                    float _time = (float)LuaAPI.lua_tonumber(L, 3);
                    
                    gen_to_be_invoked.AutoZoom( _zoom, _time );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    float _zoom = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.AutoZoom( _zoom );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.AutoZoom!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ScreenPointToWorld(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    float _disPlane = (float)LuaAPI.lua_tonumber(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.ScreenPointToWorld( _worldPos, _disPlane );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector3>(L, 2)) 
                {
                    UnityEngine.Vector3 _worldPos;translator.Get(L, 2, out _worldPos);
                    
                        var gen_ret = gen_to_be_invoked.ScreenPointToWorld( _worldPos );
                        translator.PushUnityEngineVector3(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.ScreenPointToWorld!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLodLevel(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetLodLevel(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TrackMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchId = LuaAPI.lua_toint64(L, 2);
                    
                    gen_to_be_invoked.TrackMarch( _marchId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TrackMarchV2(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& translator.Assignable<UnityEngine.Vector3>(L, 2)&& translator.Assignable<UnityEngine.Transform>(L, 3)) 
                {
                    UnityEngine.Vector3 _position;translator.Get(L, 2, out _position);
                    UnityEngine.Transform _transform = (UnityEngine.Transform)translator.GetObject(L, 3, typeof(UnityEngine.Transform));
                    
                    gen_to_be_invoked.TrackMarchV2( _position, _transform );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& translator.Assignable<UnityEngine.Vector3>(L, 2)) 
                {
                    UnityEngine.Vector3 _position;translator.Get(L, 2, out _position);
                    
                    gen_to_be_invoked.TrackMarchV2( _position );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.TrackMarchV2!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisTrackMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DisTrackMarch(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisablePostProcess(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DisablePostProcess(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_EnablePostProcess(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.EnablePostProcess(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetTouchInputControllerEnable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _able = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetTouchInputControllerEnable( _able );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCameraTouchEnable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _able = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetCameraTouchEnable( _able );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTouchInputControllerEnable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetTouchInputControllerEnable(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StopCameraMove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.StopCameraMove(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIndexByOffset_New(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _x = LuaAPI.xlua_tointeger(L, 3);
                    int _y = LuaAPI.xlua_tointeger(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset_New( _index, _x, _y );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _x = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset_New( _index, _x );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)) 
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffset_New( _index );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.GetIndexByOffset_New!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetIndexByOffsetByDirection_New(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _dir = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetIndexByOffsetByDirection_New( _index, _dir );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetZoomParams(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _level = LuaAPI.xlua_tointeger(L, 2);
                    float _y = (float)LuaAPI.lua_tonumber(L, 3);
                    float _offsetZ = (float)LuaAPI.lua_tonumber(L, 4);
                    float _sensitivity = (float)LuaAPI.lua_tonumber(L, 5);
                    
                    gen_to_be_invoked.SetZoomParams( _level, _y, _offsetZ, _sensitivity );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCameraFOV(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _fov = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetCameraFOV( _fov );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetZoomParams(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetZoomParams(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFOV(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetFOV(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInMap(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _pt;translator.Get(L, 2, out _pt);
                    
                        var gen_ret = gen_to_be_invoked.IsInMap( _pt );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInMapByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsInMapByIndex( _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetZoneIdByPosId(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointId = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetZoneIdByPosId( _pointId );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetMapZoneActive(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _active = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetMapZoneActive( _active );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FindingPathForEden(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _startIndex = LuaAPI.xlua_tointeger(L, 2);
                    int _endIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.FindingPathForEden( _startIndex, _endIndex );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAreaIdByPosId(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointId = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetAreaIdByPosId( _pointId );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClampTilePos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.ClampTilePos( _tilePos );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCollectResourceBuildRange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCollectResourceBuildRange(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCollectResourceTile(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCollectResourceTile(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGlobalShaderLOD(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetGlobalShaderLOD(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetGlobalShaderLOD(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _level = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.SetGlobalShaderLOD( _level );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetProfileTerrainSwitch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetProfileTerrainSwitch(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ProfileToggleTerrain(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ProfileToggleTerrain(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetProfileBuildingSwitch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetProfileBuildingSwitch(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ProfileToggleBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ProfileToggleBuilding(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetProfileStaticSwitch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetProfileStaticSwitch(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ProfileToggleStatic(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ProfileToggleStatic(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetHeightFogSwitch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetHeightFogSwitch(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ProfileToggleHeightFog(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ProfileToggleHeightFog(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGraphySwitch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetGraphySwitch(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ProfileToggleMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ProfileToggleMarch(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetExplorePointInfoByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetExplorePointInfoByIndex( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSamplePointInfoByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetSamplePointInfoByIndex( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetResourcePointInfoByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetResourcePointInfoByIndex( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsCollectRangePoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsCollectRangePoint( _pointIndex );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPointInfo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetPointInfo( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetWorldTileInfo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetWorldTileInfo( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCollectPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _resourceType = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetCollectPoint( _resourceType );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllCollectRangePoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _resourceType = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetAllCollectRangePoint( _resourceType );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllCollectRangePointType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _resourceType = LuaAPI.xlua_tointeger(L, 2);
                    int _mainIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetAllCollectRangePointType( _resourceType, _mainIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsCollectPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsCollectPoint( _pointIndex );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGarbagePointInfoByIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetGarbagePointInfoByIndex( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPointInfoByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetPointInfoByUuid( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDesertInfoByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetDesertInfoByUuid( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetObjectByPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetObjectByPoint( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _point = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ShowObject( _point );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildingByPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetBuildingByPoint( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildingHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetBuildingHeight( _pointIndex );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleViewPointsReply(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleViewPointsReply( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleViewUpdateNotify(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleViewUpdateNotify( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleViewTileUpdateNotify(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleViewTileUpdateNotify( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendViewRequest(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    int _viewLevel = LuaAPI.xlua_tointeger(L, 3);
                    int _serverId = LuaAPI.xlua_tointeger(L, 4);
                    
                    gen_to_be_invoked.SendViewRequest( _tilePos, _viewLevel, _serverId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsBuildFinish(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.IsBuildFinish(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetObjectByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetObjectByUuid( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetBuildingByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetBuildingByUuid( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetWorldBuildingByPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetWorldBuildingByPoint( _pointIndex );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetWorldBuildingByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetWorldBuildingByUuid( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HasPointInfo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.HasPointInfo( _pointIndex );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddToDeleteList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.AddToDeleteList( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _point = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.HideObject( _point );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsSelfPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsSelfPoint( _pointIndex );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPointType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetPointType( _index );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsSelfFreeBoard(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsSelfFreeBoard( _index );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddObjectByPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _point = LuaAPI.xlua_tointeger(L, 2);
                    int _type = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.AddObjectByPoint( _point, _type );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveObjectByPoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _point = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.RemoveObjectByPoint( _point );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveOneObjectByPointType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _pointType = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.RemoveOneObjectByPointType( _index, _pointType );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RefreshView(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.RefreshView(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnMainBuildMove(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.OnMainBuildMove(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateViewRequest(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _isForce = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.UpdateViewRequest( _isForce );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.UpdateViewRequest(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.UpdateViewRequest!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetGarbagePoint(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetGarbagePoint(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateGroupTroop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    
                        var gen_ret = gen_to_be_invoked.CreateGroupTroop( _march );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetMarch( _uuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsTargetForMine(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldMarch _marchData = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    
                        var gen_ret = gen_to_be_invoked.IsTargetForMine( _marchData );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRallyMarchIndexByUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetRallyMarchIndexByUuid( _uuid );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_StartMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 11&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7) || LuaAPI.lua_isint64(L, 7))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 10)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 11)) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    long _formationUuid = LuaAPI.lua_toint64(L, 7);
                    int _backHome = LuaAPI.xlua_tointeger(L, 8);
                    byte[] _sfsObjBinary = LuaAPI.lua_tobytes(L, 9);
                    int _startPos = LuaAPI.xlua_tointeger(L, 10);
                    int _targetServerId = LuaAPI.xlua_tointeger(L, 11);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid, _formationUuid, _backHome, _sfsObjBinary, _startPos, _targetServerId );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 10&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7) || LuaAPI.lua_isint64(L, 7))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 10)) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    long _formationUuid = LuaAPI.lua_toint64(L, 7);
                    int _backHome = LuaAPI.xlua_tointeger(L, 8);
                    byte[] _sfsObjBinary = LuaAPI.lua_tobytes(L, 9);
                    int _startPos = LuaAPI.xlua_tointeger(L, 10);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid, _formationUuid, _backHome, _sfsObjBinary, _startPos );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 9&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7) || LuaAPI.lua_isint64(L, 7))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)&& (LuaAPI.lua_isnil(L, 9) || LuaAPI.lua_type(L, 9) == LuaTypes.LUA_TSTRING)) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    long _formationUuid = LuaAPI.lua_toint64(L, 7);
                    int _backHome = LuaAPI.xlua_tointeger(L, 8);
                    byte[] _sfsObjBinary = LuaAPI.lua_tobytes(L, 9);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid, _formationUuid, _backHome, _sfsObjBinary );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 8&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7) || LuaAPI.lua_isint64(L, 7))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 8)) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    long _formationUuid = LuaAPI.lua_toint64(L, 7);
                    int _backHome = LuaAPI.xlua_tointeger(L, 8);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid, _formationUuid, _backHome );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 7) || LuaAPI.lua_isint64(L, 7))) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    long _formationUuid = LuaAPI.lua_toint64(L, 7);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid, _formationUuid );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6) || LuaAPI.lua_isint64(L, 6))) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    long _marchUuid = LuaAPI.lua_toint64(L, 6);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex, _marchUuid );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _targetType = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    long _targetUuid = LuaAPI.lua_toint64(L, 4);
                    int _timeIndex = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.StartMarch( _targetType, _targetPoint, _targetUuid, _timeIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.StartMarch!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOwnerFormationMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& (LuaAPI.lua_isnil(L, 4) || LuaAPI.lua_type(L, 4) == LuaTypes.LUA_TSTRING)) 
                {
                    string _ownerUid = LuaAPI.lua_tostring(L, 2);
                    long _formationUuid = LuaAPI.lua_toint64(L, 3);
                    string _allianceUid = LuaAPI.lua_tostring(L, 4);
                    
                        var gen_ret = gen_to_be_invoked.GetOwnerFormationMarch( _ownerUid, _formationUuid, _allianceUid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))) 
                {
                    string _ownerUid = LuaAPI.lua_tostring(L, 2);
                    long _formationUuid = LuaAPI.lua_toint64(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetOwnerFormationMarch( _ownerUid, _formationUuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.GetOwnerFormationMarch!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllianceMarchesInTeam(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _allianceUid = LuaAPI.lua_tostring(L, 2);
                    long _teamUuid = LuaAPI.lua_toint64(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetAllianceMarchesInTeam( _allianceUid, _teamUuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetOwnerMarches(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 3) || LuaAPI.lua_type(L, 3) == LuaTypes.LUA_TSTRING)) 
                {
                    string _ownerUid = LuaAPI.lua_tostring(L, 2);
                    string _allianceUid = LuaAPI.lua_tostring(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetOwnerMarches( _ownerUid, _allianceUid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _ownerUid = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetOwnerMarches( _ownerUid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.GetOwnerMarches!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDragonMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetDragonMarch(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandlePushWorldMarchAdd(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandlePushWorldMarchAdd( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandlePushWorldMarchDel(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandlePushWorldMarchDel( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleWorldMarchGet(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleWorldMarchGet( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleFormationMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleFormationMarch( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HandleFormationMarchChange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.HandleFormationMarchChange( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ExistMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.ExistMarch( _uuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInRallyMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsInRallyMarch( _uuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInCollectMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsInCollectMarch( _uuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsInAssistanceMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsInAssistanceMarch( _uuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsSelfInCurrentMarchTeam(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _rallyMarchUuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsSelfInCurrentMarchTeam( _rallyMarchUuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMarchesTargetForMine(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetMarchesTargetForMine(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetMarchesBossInfo(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetMarchesBossInfo(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CanUseInput(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.CanUseInput(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUseInput(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _canUse = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetUseInput( _canUse );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetSelectedPickable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    ITouchPickable _pickable = (ITouchPickable)translator.GetObject(L, 2, typeof(ITouchPickable));
                    
                    gen_to_be_invoked.SetSelectedPickable( _pickable );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowLoad(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _pos;translator.Get(L, 2, out _pos);
                    
                    gen_to_be_invoked.ShowLoad( _pos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetDragFormationData(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _uuid = LuaAPI.lua_toint64(L, 2);
                    int _pointId = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.SetDragFormationData( _uuid, _pointId );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetClickWorldBulidingPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetClickWorldBulidingPos(  );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_HideTouchEffect(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.HideTouchEffect(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetRaycastHitMarch(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector3 _screenPos;translator.Get(L, 2, out _screenPos);
                    
                        var gen_ret = gen_to_be_invoked.GetRaycastHitMarch( _screenPos );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsTileWalkable(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _tilePos;translator.Get(L, 2, out _tilePos);
                    
                        var gen_ret = gen_to_be_invoked.IsTileWalkable( _tilePos );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddOccupyPoints(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _p;translator.Get(L, 2, out _p);
                    UnityEngine.Vector2Int _size;translator.Get(L, 3, out _size);
                    
                    gen_to_be_invoked.AddOccupyPoints( _p, _size );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveOccupyPoints(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _p;translator.Get(L, 2, out _p);
                    UnityEngine.Vector2Int _size;translator.Get(L, 3, out _size);
                    
                    gen_to_be_invoked.RemoveOccupyPoints( _p, _size );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetStaticVisibleChunk(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _range = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetStaticVisibleChunk( _range );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetModelHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetModelHeight( _marchUuid );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTroop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetTroop( _marchUuid );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddBullet(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _prefabName = LuaAPI.lua_tostring(L, 2);
                    string _hitPrefabName = LuaAPI.lua_tostring(L, 3);
                    Unity.Mathematics.float3 _startPos;translator.Get(L, 4, out _startPos);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 5, out _rotation);
                    int _tType = LuaAPI.xlua_tointeger(L, 6);
                    long _tUuid = LuaAPI.lua_toint64(L, 7);
                    Unity.Mathematics.float3 _targetPos;translator.Get(L, 8, out _targetPos);
                    bool _isSelf = LuaAPI.lua_toboolean(L, 9);
                    
                        var gen_ret = gen_to_be_invoked.AddBullet( _prefabName, _hitPrefabName, _startPos, _rotation, _tType, _tUuid, _targetPos, _isSelf );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddBulletV2(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _prefabName = LuaAPI.lua_tostring(L, 2);
                    string _hitPrefabName = LuaAPI.lua_tostring(L, 3);
                    UnityEngine.Vector3 _startPos;translator.Get(L, 4, out _startPos);
                    UnityEngine.Quaternion _rotation;translator.Get(L, 5, out _rotation);
                    int _tType = LuaAPI.xlua_tointeger(L, 6);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 7);
                    UnityEngine.Transform _trans = (UnityEngine.Transform)translator.GetObject(L, 8, typeof(UnityEngine.Transform));
                    bool _isSelf = LuaAPI.lua_toboolean(L, 9);
                    
                        var gen_ret = gen_to_be_invoked.AddBulletV2( _prefabName, _hitPrefabName, _startPos, _rotation, _tType, _tileSize, _trans, _isSelf );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetDestinationType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 3);
                    int _endPos = LuaAPI.xlua_tointeger(L, 4);
                    MarchTargetType _targetType;translator.Get(L, 5, out _targetType);
                    bool _isFormation = LuaAPI.lua_toboolean(L, 6);
                    UnityEngine.Vector3 _realPos;translator.Get(L, 7, out _realPos);
                    int _tileSize = LuaAPI.xlua_tointeger(L, 8);
                    
                        var gen_ret = gen_to_be_invoked.GetDestinationType( _marchUuid, _targetMarchUuid, _endPos, _targetType, _isFormation, ref _realPos, ref _tileSize );
                        translator.Push(L, gen_ret);
                    translator.PushUnityEngineVector3(L, _realPos);
                        translator.UpdateUnityEngineVector3(L, 7, _realPos);
                        
                    LuaAPI.xlua_pushinteger(L, _tileSize);
                        
                    
                    
                    
                    return 3;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTargetType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 2);
                    int _pointId = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.GetTargetType( _targetMarchUuid, _pointId );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateBattleVFX(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _prefabPath = LuaAPI.lua_tostring(L, 2);
                    float _life = (float)LuaAPI.lua_tonumber(L, 3);
                    System.Action<UnityEngine.GameObject> _onComplete = translator.GetDelegate<System.Action<UnityEngine.GameObject>>(L, 4);
                    
                    gen_to_be_invoked.CreateBattleVFX( _prefabPath, _life, _onComplete );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnTroopDragUpdate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 6)) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    UnityEngine.Vector3 _dragPosCurrent;translator.Get(L, 3, out _dragPosCurrent);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 4);
                    int _startPointId = LuaAPI.xlua_tointeger(L, 5);
                    bool _isFormation = LuaAPI.lua_toboolean(L, 6);
                    
                    gen_to_be_invoked.OnTroopDragUpdate( _marchUuid, _dragPosCurrent, _targetMarchUuid, _startPointId, _isFormation );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    UnityEngine.Vector3 _dragPosCurrent;translator.Get(L, 3, out _dragPosCurrent);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 4);
                    int _startPointId = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.OnTroopDragUpdate( _marchUuid, _dragPosCurrent, _targetMarchUuid, _startPointId );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 4&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& translator.Assignable<UnityEngine.Vector3>(L, 3)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4) || LuaAPI.lua_isint64(L, 4))) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    UnityEngine.Vector3 _dragPosCurrent;translator.Get(L, 3, out _dragPosCurrent);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 4);
                    
                    gen_to_be_invoked.OnTroopDragUpdate( _marchUuid, _dragPosCurrent, _targetMarchUuid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.OnTroopDragUpdate!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnTroopDragStop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 4&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 4)) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 3);
                    bool _isFormation = LuaAPI.lua_toboolean(L, 4);
                    
                    gen_to_be_invoked.OnTroopDragStop( _marchUuid, _targetMarchUuid, _isFormation );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    long _targetMarchUuid = LuaAPI.lua_toint64(L, 3);
                    
                    gen_to_be_invoked.OnTroopDragStop( _marchUuid, _targetMarchUuid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.OnTroopDragStop!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPointSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetPointSize( _index );
                        LuaAPI.xlua_pushinteger(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsTroopCreate(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.IsTroopCreate( _marchUuid );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateTroop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    
                    gen_to_be_invoked.CreateTroop( _march );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateTroop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    
                    gen_to_be_invoked.UpdateTroop( _march );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DestroyTroop(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 3&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    bool _isBattleFailed = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.DestroyTroop( _marchUuid, _isBattleFailed );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 2&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2) || LuaAPI.lua_isint64(L, 2))) 
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    
                    gen_to_be_invoked.DestroyTroop( _marchUuid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.DestroyTroop!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateTroopLine(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    
                    gen_to_be_invoked.CreateTroopLine( _march );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DestroyTroopLine(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    long _marchUuid = LuaAPI.lua_toint64(L, 2);
                    
                    gen_to_be_invoked.DestroyTroopLine( _marchUuid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateTroopLine(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 8&& translator.Assignable<WorldMarch>(L, 2)&& translator.Assignable<WorldTroopPathSegment[]>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 7)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 8)) 
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 3, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 4);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 5, out _currPos);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 6);
                    bool _needRefresh = LuaAPI.lua_toboolean(L, 7);
                    bool _clear = LuaAPI.lua_toboolean(L, 8);
                    
                    gen_to_be_invoked.UpdateTroopLine( _march, _path, _currPath, _currPos, _realTargetPos, _needRefresh, _clear );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 7&& translator.Assignable<WorldMarch>(L, 2)&& translator.Assignable<WorldTroopPathSegment[]>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 7)) 
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 3, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 4);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 5, out _currPos);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 6);
                    bool _needRefresh = LuaAPI.lua_toboolean(L, 7);
                    
                    gen_to_be_invoked.UpdateTroopLine( _march, _path, _currPath, _currPos, _realTargetPos, _needRefresh );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 6&& translator.Assignable<WorldMarch>(L, 2)&& translator.Assignable<WorldTroopPathSegment[]>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 6)) 
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 3, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 4);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 5, out _currPos);
                    int _realTargetPos = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.UpdateTroopLine( _march, _path, _currPath, _currPos, _realTargetPos );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& translator.Assignable<WorldMarch>(L, 2)&& translator.Assignable<WorldTroopPathSegment[]>(L, 3)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& translator.Assignable<UnityEngine.Vector3>(L, 5)) 
                {
                    WorldMarch _march = (WorldMarch)translator.GetObject(L, 2, typeof(WorldMarch));
                    WorldTroopPathSegment[] _path = (WorldTroopPathSegment[])translator.GetObject(L, 3, typeof(WorldTroopPathSegment[]));
                    int _currPath = LuaAPI.xlua_tointeger(L, 4);
                    UnityEngine.Vector3 _currPos;translator.Get(L, 5, out _currPos);
                    
                    gen_to_be_invoked.UpdateTroopLine( _march, _path, _currPath, _currPos );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.UpdateTroopLine!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTimeFromCurPosToTargetPos(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _posStart = LuaAPI.xlua_tointeger(L, 2);
                    int _targetPoint = LuaAPI.xlua_tointeger(L, 3);
                    int _speed = LuaAPI.xlua_tointeger(L, 4);
                    long _Uuid = LuaAPI.lua_toint64(L, 5);
                    
                    gen_to_be_invoked.GetTimeFromCurPosToTargetPos( _posStart, _targetPoint, _speed, _Uuid );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FindPath(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Vector2Int _start;translator.Get(L, 2, out _start);
                    UnityEngine.Vector2Int _goal;translator.Get(L, 3, out _goal);
                    System.Action<System.Collections.Generic.List<UnityEngine.Vector2Int>> _onComplete = translator.GetDelegate<System.Action<System.Collections.Generic.List<UnityEngine.Vector2Int>>>(L, 4);
                    
                    gen_to_be_invoked.FindPath( _start, _goal, _onComplete );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveCullingBounds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldCulling.ICullingObject _cullingObject = (WorldCulling.ICullingObject)translator.GetObject(L, 2, typeof(WorldCulling.ICullingObject));
                    
                    gen_to_be_invoked.RemoveCullingBounds( _cullingObject );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddCullingBounds(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    WorldCulling.ICullingObject _cullingObject = (WorldCulling.ICullingObject)translator.GetObject(L, 2, typeof(WorldCulling.ICullingObject));
                    
                    gen_to_be_invoked.AddCullingBounds( _cullingObject );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_BattleFinish(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.BattleFinish( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateBattleMessage(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    Sfs2X.Entities.Data.ISFSObject _message = (Sfs2X.Entities.Data.ISFSObject)translator.GetObject(L, 2, typeof(Sfs2X.Entities.Data.ISFSObject));
                    
                    gen_to_be_invoked.UpdateBattleMessage( _message );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UICreateBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaAPI.lua_isnil(L, 6) || LuaAPI.lua_type(L, 6) == LuaTypes.LUA_TTABLE)) 
                {
                    int _buildId = LuaAPI.xlua_tointeger(L, 2);
                    long _buildUuid = LuaAPI.lua_toint64(L, 3);
                    int _point = LuaAPI.xlua_tointeger(L, 4);
                    int _buildTopType = LuaAPI.xlua_tointeger(L, 5);
                    XLua.LuaTable _noBuildListStr = (XLua.LuaTable)translator.GetObject(L, 6, typeof(XLua.LuaTable));
                    
                    gen_to_be_invoked.UICreateBuilding( _buildId, _buildUuid, _point, _buildTopType, _noBuildListStr );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _buildId = LuaAPI.xlua_tointeger(L, 2);
                    long _buildUuid = LuaAPI.lua_toint64(L, 3);
                    int _point = LuaAPI.xlua_tointeger(L, 4);
                    int _buildTopType = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.UICreateBuilding( _buildId, _buildUuid, _point, _buildTopType );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.UICreateBuilding!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UICreateAllianceBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 6&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)&& (LuaAPI.lua_isnil(L, 6) || LuaAPI.lua_type(L, 6) == LuaTypes.LUA_TTABLE)) 
                {
                    int _buildId = LuaAPI.xlua_tointeger(L, 2);
                    long _buildUuid = LuaAPI.lua_toint64(L, 3);
                    int _point = LuaAPI.xlua_tointeger(L, 4);
                    int _buildTopType = LuaAPI.xlua_tointeger(L, 5);
                    XLua.LuaTable _noBuildListStr = (XLua.LuaTable)translator.GetObject(L, 6, typeof(XLua.LuaTable));
                    
                    gen_to_be_invoked.UICreateAllianceBuilding( _buildId, _buildUuid, _point, _buildTopType, _noBuildListStr );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 5&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 2)&& (LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 3) || LuaAPI.lua_isint64(L, 3))&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 4)&& LuaTypes.LUA_TNUMBER == LuaAPI.lua_type(L, 5)) 
                {
                    int _buildId = LuaAPI.xlua_tointeger(L, 2);
                    long _buildUuid = LuaAPI.lua_toint64(L, 3);
                    int _point = LuaAPI.xlua_tointeger(L, 4);
                    int _buildTopType = LuaAPI.xlua_tointeger(L, 5);
                    
                    gen_to_be_invoked.UICreateAllianceBuilding( _buildId, _buildUuid, _point, _buildTopType );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to CityScene.UICreateAllianceBuilding!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIChangeBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UIChangeBuilding( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIDestroyBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UIDestroyBuilding(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIChangeAllianceBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UIChangeAllianceBuilding( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIDestroyAllianceBuilding(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UIDestroyAllianceBuilding(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIDestroyRreCreateBuild(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UIDestroyRreCreateBuild(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UIDestroyRreCreateAllianceBuild(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UIDestroyRreCreateAllianceBuild(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddObjectByPointId(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    int _type = LuaAPI.xlua_tointeger(L, 3);
                    
                        var gen_ret = gen_to_be_invoked.AddObjectByPointId( _index, _type );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetObjectByPointId(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetObjectByPointId( _index );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_InitFogOfWar(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Collections.BitArray _fogData = (System.Collections.BitArray)translator.GetObject(L, 2, typeof(System.Collections.BitArray));
                    
                    gen_to_be_invoked.InitFogOfWar( _fogData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReInitFogOfWar(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ReInitFogOfWar(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnlockFogOfWar(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _fogIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UnlockFogOfWar( _fogIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UnlockFogOfWar2x2(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _unlockIndex = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UnlockFogOfWar2x2( _unlockIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetFogVisible(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _visible = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetFogVisible( _visible );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RegisterFogCompleteAction(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Action _callback = translator.GetDelegate<System.Action>(L, 2);
                    
                    gen_to_be_invoked.RegisterFogCompleteAction( _callback );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ReInitObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ReInitObject(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearReInitObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ClearReInitObject(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFormationUuid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetFormationUuid(  );
                        LuaAPI.lua_pushint64(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetLodConfigs(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _lodType = LuaAPI.xlua_tointeger(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetLodConfigs( _lodType );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddLodAdjuster(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoAdjustLod _adjuster = (AutoAdjustLod)translator.GetObject(L, 2, typeof(AutoAdjustLod));
                    
                    gen_to_be_invoked.AddLodAdjuster( _adjuster );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveLodAdjuster(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoAdjustLod _adjuster = (AutoAdjustLod)translator.GetObject(L, 2, typeof(AutoAdjustLod));
                    
                    gen_to_be_invoked.RemoveLodAdjuster( _adjuster );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetVisibleByPointType(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _pointType = LuaAPI.xlua_tointeger(L, 2);
                    bool _isVisible = LuaAPI.lua_toboolean(L, 3);
                    
                    gen_to_be_invoked.SetVisibleByPointType( _pointType, _isVisible );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSpecialPointDic(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetSpecialPointDic(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCameraMaxHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _height = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetCameraMaxHeight( _height );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCameraMaxHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCameraMaxHeight(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetCameraMinHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _height = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetCameraMinHeight( _height );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetCameraMinHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetCameraMinHeight(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetCameraMaxHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResetCameraMaxHeight(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ResetCameraMinHeight(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.ResetCameraMinHeight(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPreviousLodDistance(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetPreviousLodDistance(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DrawBuildGrid(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.Mesh _mesh = (UnityEngine.Mesh)translator.GetObject(L, 2, typeof(UnityEngine.Mesh));
                    int _submeshIndex = LuaAPI.xlua_tointeger(L, 3);
                    UnityEngine.Material _material = (UnityEngine.Material)translator.GetObject(L, 4, typeof(UnityEngine.Material));
                    UnityEngine.Matrix4x4[] _matrices = (UnityEngine.Matrix4x4[])translator.GetObject(L, 5, typeof(UnityEngine.Matrix4x4[]));
                    int _count = LuaAPI.xlua_tointeger(L, 6);
                    
                    gen_to_be_invoked.DrawBuildGrid( _mesh, _submeshIndex, _material, _matrices, _count );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddAutoFace(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoFaceToCamera _autoFace = (AutoFaceToCamera)translator.GetObject(L, 2, typeof(AutoFaceToCamera));
                    
                    gen_to_be_invoked.AddAutoFace( _autoFace );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveAutoFace(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoFaceToCamera _autoFace = (AutoFaceToCamera)translator.GetObject(L, 2, typeof(AutoFaceToCamera));
                    
                    gen_to_be_invoked.RemoveAutoFace( _autoFace );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AddAutoScale(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoAdjustScale _autoScale = (AutoAdjustScale)translator.GetObject(L, 2, typeof(AutoAdjustScale));
                    
                    gen_to_be_invoked.AddAutoScale( _autoScale );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_RemoveAutoScale(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    AutoAdjustScale _autoScale = (AutoAdjustScale)translator.GetObject(L, 2, typeof(AutoAdjustScale));
                    
                    gen_to_be_invoked.RemoveAutoScale( _autoScale );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTerrainGameObject(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetTerrainGameObject(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUSkyLightingPointDistanceFalloff(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    float _val = (float)LuaAPI.lua_tonumber(L, 2);
                    
                    gen_to_be_invoked.SetUSkyLightingPointDistanceFalloff( _val );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetUSkyLightingPointDistanceFalloff(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        var gen_ret = gen_to_be_invoked.GetUSkyLightingPointDistanceFalloff(  );
                        LuaAPI.lua_pushnumber(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetUSkyActive(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    bool _active = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.SetUSkyActive( _active );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BlockCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.BlockCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BlockSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.BlockSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TileSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.TileSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TileCount(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.TileCount);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_DynamicObjNode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.DynamicObjNode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BuildBubbleNode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.BuildBubbleNode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_LodArray(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, CityScene.LodArray);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Transform(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Transform);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTileCountXMin(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.CurTileCountXMin);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTileCountXMax(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.CurTileCountXMax);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTileCountYMin(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.CurTileCountYMin);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTileCountYMax(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.CurTileCountYMax);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_WorldSize(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.WorldSize);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_BlackLandSpeed(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.BlackLandSpeed);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTarget(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.CurTarget);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_InitZoom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.InitZoom);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Zoom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.Zoom);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CanMoving(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.CanMoving);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_TouchInputController(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.TouchInputController);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_IsFocus(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.IsFocus);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTilePos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.CurTilePos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_CurTilePosClamped(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.CurTilePosClamped);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Enabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.Enabled);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_frameBufferWidth(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.frameBufferWidth);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_frameBufferHeight(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.frameBufferHeight);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_curIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.curIndex);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_marchUuid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushint64(L, gen_to_be_invoked.marchUuid);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_touchPickablePos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.touchPickablePos);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_SelectBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.PushAny(L, gen_to_be_invoked.SelectBuild);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_preCreateBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.preCreateBuild);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_placeFalseBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.placeFalseBuild);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_InitZoom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.InitZoom = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Zoom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Zoom = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_CanMoving(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.CanMoving = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Enabled(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Enabled = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_curIndex(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.curIndex = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_marchUuid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.marchUuid = LuaAPI.lua_toint64(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_touchPickablePos(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.touchPickablePos = (System.Collections.Generic.List<int>)translator.GetObject(L, 2, typeof(System.Collections.Generic.List<int>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_SelectBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.SelectBuild = (ITouchPickable)translator.GetObject(L, 2, typeof(ITouchPickable));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_preCreateBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.preCreateBuild = (FakeBuilding)translator.GetObject(L, 2, typeof(FakeBuilding));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_placeFalseBuild(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.placeFalseBuild = (System.Collections.Generic.Queue<FakeBuilding>)translator.GetObject(L, 2, typeof(System.Collections.Generic.Queue<FakeBuilding>));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _e_AfterUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    int gen_param_count = LuaAPI.lua_gettop(L);
			CityScene gen_to_be_invoked = (CityScene)translator.FastGetCSObj(L, 1);
                System.Action gen_delegate = translator.GetDelegate<System.Action>(L, 3);
                if (gen_delegate == null) {
                    return LuaAPI.luaL_error(L, "#3 need System.Action!");
                }
				
				if (gen_param_count == 3)
				{
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "+")) {
						gen_to_be_invoked.AfterUpdate += gen_delegate;
						return 0;
					} 
					
					
					if (LuaAPI.xlua_is_eq_str(L, 2, "-")) {
						gen_to_be_invoked.AfterUpdate -= gen_delegate;
						return 0;
					} 
					
				}
			} catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
			LuaAPI.luaL_error(L, "invalid arguments to CityScene.AfterUpdate!");
            return 0;
        }
        
		
		
    }
}
