using System;
using System.Collections;
using System.Collections.Generic;
using BitBenderGames;
using Sfs2X.Entities.Data;
using Unity.Mathematics;
using UnityEngine;
using XLua;

public interface SceneInterface
{
   
    Transform DynamicObjNode { get; }
    Transform BuildBubbleNode { get; }
    Vector2Int BlockCount { get; }
    int BlockSize { get; }
    float TileSize { get; }
    Vector2Int TileCount { get; }
    int CurTileCountXMin { get; }
    int CurTileCountXMax { get; }
    int CurTileCountYMin { get; }
    int CurTileCountYMax { get; }
    int WorldSize { get; }
    float BlackLandSpeed{ get; }
    void Init(GameObject go);
    void CreateScene(Action callback = null);
    void Uninit();
    void ChangeQualitySetting();
    void Update();
    void FixedUpdate();
    void SetWorldSize(int size);

    void SetRangeValue(int Xmin, int Ymin, int Xmax, int Ymax);
    
    string FindingPathForEden(int startIndex, int endIndex);
    int GetZoneIdByPosId(int pointId);
    int GetAreaIdByPosId(int pointId);
    void SetMapZoneActive(bool active);
    bool IsTileOccupyed(Vector2Int tilePos);
    int GetBuildTileByItemId(int itemId);
    int GetDesertPoint(int lv, int type);
    Dictionary<long, WorldTileInfo> GetDesertPointList();
    bool IsTileOccupyed(int index);
    Vector3 TileToWorld(Vector2Int tilePos);
    Vector3 TileToWorld(int tilePosX, int tilePosY);
    Vector2Int WorldToTile(Vector3 worldPos);
    Vector3 SnapToTileCenter(Vector3 worldPos);
    Vector3 TileFloatToWorld(Vector2 tilePos);
    Vector3 TileFloatToWorld(float x, float y);
    Vector2 WorldToTileFloat(Vector3 worldPos);
    Vector2Int IndexToTilePos(int index);
    int TilePosToIndex(Vector2Int tilePos);
    Vector3 TileIndexToWorld(int index);
    int WorldToTileIndex(Vector3 pos);
    float TileDistance(Vector2Int a, Vector2Int b);
    int GetIndexByOffset(int index, int x = 0, int y = 0);
    int GetIndexByOffsetByDirection(int index, int dir);
    void OnPlayerBankruptcyFinish(string uid);
    void ShowBattleBlood(object param, string path = WorldTroop.normalWordPath);
    void RegisterPhysics(MonoBehaviour obj);
    void UnregisterPhysics(MonoBehaviour obj);
    
    #region Camera

    void SetZoomParams(int level, float y, float offsetZ, float sensitivity);
    void SetCameraFOV(float fov);
    
    Vector2Int GetTouchTilePos();
    Vector3 GetTouchPoint();
    Vector3 GetTouchPoint(Vector3 screenPos);
    Vector3 GetRaycastGroundPoint(Vector3 screenPos);
    Vector3 CurTarget { get; }
    void AutoFocus(Vector3 lookat, LookAtFocusState state, float time, bool focusToCenter = true, bool lockView = false, Action onComplete = null);
    void QuitFocus(float time);
    float InitZoom { get; }
    float Zoom { get; set; }
    bool CanMoving { get; set; }
    float GetLodDistance();
    Quaternion GetRotation();
    float GetPreviousLodDistance();
    float GetMapIconScale();
    Vector3 GetCameraPos();
    TouchInputController TouchInputController { get; }
    Ray ScreenPointToRay(Vector3 pos);
    float GetMinLodDistance();
    bool IsFocus { get; }
    Vector3 WorldToScreenPoint(Vector3 worldPos);
    void AutoLookat(Vector3 lookat, float zoom = -1, float time = 0.2f, Action onComplete = null);
    void AutoZoom(float zoom, float time = 0.2f, Action onComplete = null);
    void Lookat(Vector3 lookWorldPosition);
    Vector2Int CurTilePos { get; }
    Vector2Int CurTilePosClamped { get; }
    Vector3 ScreenPointToWorld(Vector3 worldPos, float disPlane = 0);
    int GetLodLevel();
    void UpdateViewRequest(bool isForce = false);
    void TrackMarch(long marchId);
    void TrackMarchV2(Vector3 position, Transform transform = null);
    void DisTrackMarch();

    void DisablePostProcess();
    void EnablePostProcess();
    void SetTouchInputControllerEnable(bool able);
    bool GetTouchInputControllerEnable();
    bool Enabled { get; set; }
    event Action AfterUpdate;
    void StopCameraMove();
    #endregion

    bool IsInMap(Vector2Int pt);
    bool IsInMapByIndex(int index);
    Vector2Int ClampTilePos(Vector2Int tilePos);
    void ChangeServer(int serverId);
    void OnChangeServerRemove();
    void OnChangeServerTypeRefresh();
    void RemoveBlackDesert();

    void InitBlackBlock();
    void CreateDragonLandRange();

    void RemoveDragonLandRange();
    int GetCollectResourceBuildRange();
    int GetCollectResourceTile();

    #region tmp pointManager

    ExplorePointInfo GetExplorePointInfoByIndex(int pointIndex);
    SamplePointInfo GetSamplePointInfoByIndex(int pointIndex);
    ResPointInfo GetResourcePointInfoByIndex(int pointIndex);
    bool IsCollectRangePoint(int pointIndex);
    PointInfo GetPointInfo(int pointIndex);
    WorldTileInfo GetWorldTileInfo(int pointIndex);
    int GetCollectPoint(int resourceType);
    List<int> GetAllCollectRangePoint(int resourceType);
    List<int> GetAllCollectRangePointType(int resourceType, int mainIndex);
    bool IsCollectPoint(int pointIndex);
    GarbagePointInfo GetGarbagePointInfoByIndex(int pointIndex);
    PointInfo GetPointInfoByUuid(long uuid);
    WorldDesertInfo GetDesertInfoByUuid(long uuid);
    WorldPointObject GetObjectByPoint(int pointIndex);
    void ShowObject(int point);
    CityBuilding GetBuildingByPoint(int pointIndex);
    float GetBuildingHeight(int pointIndex);
    void HandleViewPointsReply(ISFSObject message);
    void HandleViewUpdateNotify(ISFSObject message);
    void HandleViewTileUpdateNotify(ISFSObject message);
    void SendViewRequest(Vector2Int tilePos, int viewLevel, int serverId);
    bool IsBuildFinish();
    WorldPointObject GetObjectByUuid(long uuid);
    CityBuilding GetBuildingByUuid(long uuid);
    WorldBuilding GetWorldBuildingByPoint(int pointIndex);

    WorldBuilding GetWorldBuildingByUuid(long uuid);
    bool HasPointInfo(int pointIndex);
    void AddToDeleteList(int index);
    void HideObject(int point);
    bool IsSelfPoint(int pointIndex);
    int GetPointType(int index);
    void RemoveObjectByPoint(int point);
    void RemoveOneObjectByPointType(int index, int pointType);
    void RefreshView();
    Dictionary<string, BuildPointInfo> GetSelfAllianceList();

    Dictionary<long, PointInfo> GetDragonPointDic();
    void OnMainBuildMove();
    List<int> GetGarbagePoint();

    #endregion

    #region tmp MarchDataManager

    WorldMarch GetMarch(long uuid);
    Dictionary<long, WorldMarch> GetDragonMarch();
    int GetRallyMarchIndexByUuid(long uuid);
    bool IsTargetForMine(WorldMarch marchData);

    void StartMarch(int targetType, int targetPoint, long targetUuid, int timeIndex, long marchUuid = 0,
        long formationUuid = 0, int backHome = 1, byte[] sfsObjBinary = null, int startPos = 0,int targetServerId = -1);

    void RemoveFakeSampleMarchData(long index);
    void UpdateFakeSampleMarchDataWhenBack(long index, long startTime, long endTime);
    void UpdateFakeSampleMarchDataWhenStartPick(long index, long endTime);
    void AddFakeSampleMarchData(long startIndex, long endIndex, long startTime, long endTime);
    WorldMarch GetOwnerFormationMarch(string ownerUid, long formationUuid, string allianceUid = "");
    WorldMarch GetAllianceMarchesInTeam(string allianceUid, long teamUuid);
    List<WorldMarch> GetOwnerMarches(string ownerUid, string allianceUid = "");
    void HandlePushWorldMarchAdd(ISFSObject message);
    void HandlePushWorldMarchDel(ISFSObject message);
    void HandleWorldMarchGet(ISFSObject message);
    void HandleFormationMarch(ISFSObject message);
    void HandleFormationMarchChange(ISFSObject message);
    bool ExistMarch(long uuid);
    bool IsInRallyMarch(long uuid);
    bool IsInCollectMarch(long uuid);
    bool IsInAssistanceMarch(long uuid);
    bool IsSelfInCurrentMarchTeam(long rallyMarchUuid);
    Dictionary<long, WorldMarch> GetMarchesTargetForMine();
    Dictionary<long, WorldMarch> GetMarchesBossInfo();
    
    #endregion

    #region tmp inputManager

    int curIndex { get; set; }
    bool CanUseInput();
    void SetUseInput(bool canUse);
    long marchUuid { get; set; }
    void SetSelectedPickable(ITouchPickable pickable);
    void ShowLoad(Vector3 pos);
    List<int> touchPickablePos { get; set; }
    ITouchPickable SelectBuild { get; set; }
    int GetClickWorldBulidingPos();
    void HideTouchEffect();
    long GetRaycastHitMarch(Vector3 screenPos);

    void SetDragFormationData(long uuid, int pointId);
    
    #endregion

    #region tmp static manager

    bool IsTileWalkable(Vector2Int tilePos);
    void AddOccupyPoints(Vector2Int p, Vector2Int size);
    void RemoveOccupyPoints(Vector2Int p, Vector2Int size);
    void SetStaticVisibleChunk(int range);
    
    #endregion

    #region tmp troopManager
    WorldTroop CreateGroupTroop(WorldMarch march);
    float GetModelHeight(long marchUuid);
    WorldTroop GetTroop(long marchUuid);
    bool AddBullet(string prefabName, string hitPrefabName, float3 startPos, Quaternion rotation, int tType, long tUuid, float3 targetPos,bool isSelf);

    bool AddBulletV2(string prefabName, string hitPrefabName, Vector3 startPos, Quaternion rotation, int tType,
        int tileSize, Transform trans, bool isSelf);
    EnumDestinationSignalType GetDestinationType(long marchUuid, long targetMarchUuid,int endPos, MarchTargetType targetType,bool isFormation, ref Vector3 realPos, ref int tileSize);
    MarchTargetType GetTargetType(long targetMarchUuid, int pointId);
    void CreateBattleVFX(string prefabPath, float life, Action<GameObject> onComplete);
    void OnTroopDragUpdate(long marchUuid, Vector3 dragPosCurrent, long targetMarchUuid,int startPointId = 0,bool isFormation = false);
    void OnTroopDragStop(long marchUuid, long targetMarchUuid,bool isFormation =false);
    int GetPointSize(int index);
    bool IsTroopCreate(long marchUuid);
    void CreateTroop(WorldMarch march);
    void UpdateTroop(WorldMarch march);
    void DestroyTroop(long marchUuid, bool isBattleFailed = false);

    void CreateTroopLine(WorldMarch march);
    void DestroyTroopLine(long marchUuid);

    void UpdateTroopLine(WorldMarch march, WorldTroopPathSegment[] path, int currPath, Vector3 currPos,
        int realTargetPos = 0, bool needRefresh = false, bool clear = false);
    
    #endregion

    #region tmp path find

    void GetTimeFromCurPosToTargetPos(int posStart, int targetPoint, int speed, long Uuid);
    void FindPath(Vector2Int start, Vector2Int goal, Action<List<Vector2Int>> onComplete);

    #endregion

    #region Culling

    void RemoveCullingBounds(WorldCulling.ICullingObject cullingObject);
    void AddCullingBounds(WorldCulling.ICullingObject cullingObject);

    #endregion

    #region BattleManager

    void BattleFinish(ISFSObject message);
    void UpdateBattleMessage(ISFSObject message);

    #endregion

    #region FakeModelManager

    void UICreateBuilding(int buildId, long buildUuid, int point, int buildTopType, LuaTable noBuildListStr = null);
    void UICreateAllianceBuilding(int buildId, long buildUuid, int point, int buildTopType, LuaTable noBuildListStr = null);
    
    void UIChangeBuilding(int index);
    void UIDestroyBuilding();
    void UIChangeAllianceBuilding(int index);

    void UIDestroyAllianceBuilding();
    void UIDestroyRreCreateBuild();
    void UIDestroyRreCreateAllianceBuild();
    ModelManager.ModelObject AddObjectByPointId(int index, int type);
    ModelManager.ModelObject GetObjectByPointId(int index);

    #endregion
    
    #region ModerManager

    void ReInitObject();
    void ClearReInitObject();

    long GetFormationUuid();

    #endregion

    #region LodManager

    Dictionary<string, LodConfig> GetLodConfigs(int lodType);

    void AddLodAdjuster(AutoAdjustLod adjuster);
    
    void RemoveLodAdjuster(AutoAdjustLod adjuster);

    #endregion

    void AddAutoFace(AutoFaceToCamera autoFace);

    void RemoveAutoFace(AutoFaceToCamera autoFace);

    void AddAutoScale(AutoAdjustScale autoAdjustScale);

    void RemoveAutoScale(AutoAdjustScale autoAdjustScale);

    void SetVisibleByPointType(int pointType, bool isVisible);
    void SetCameraMaxHeight(int height);
    
    float GetCameraMaxHeight();
    
    void SetCameraMinHeight(int height);
    
    float GetCameraMinHeight();
    void ResetCameraMaxHeight();
    void ResetCameraMinHeight();
    
    void DrawBuildGrid(Mesh mesh, int submeshIndex, Material material, Matrix4x4[] matrices, int count);

    GameObject GetTerrainGameObject();
    void SetUSkyLightingPointDistanceFalloff(float val);
    float GetUSkyLightingPointDistanceFalloff();
    void SetUSkyActive(bool active);
}