using System;
using System.Collections.Generic;
using DG.Tweening;
using GameFramework;
using Protobuf;
using UnityEngine;

public abstract class WorldPointObject
{
    protected WorldScene world;
    protected int pointIndex;
    protected bool isVisible;
    protected GameObject gameObject;
    protected InstanceRequest instance;
    protected List<InstanceRequest> oldInstances;
    private InstanceRequest _troopDestinationInst;
    private WorldTroopDestinationSignal _troopDestination;
    protected bool isSHowDestination = false;
    protected TouchObjectEventTrigger _touchObject;
    protected AutoAdjustLod adjuster = null;
    protected int pointType = (int)WorldPointType.Other;
    
    protected InstanceRequest _desertTileInst;
    protected PlayerType desertPlayerType = PlayerType.PlayerNone;
    protected bool hasAssistance = false;
    private long desertUuid = 0;
    private bool isFireDesertEffect = false;
    private bool isFireDesertMine = false;
    private bool isFireDesertLevel = false;
    private int desertId = 0;
    private bool isRedDesert = false;
    private bool isYellowDesert = false;
    private int desertMineId = 0;
    public WorldPointObject(WorldScene worldScene, int pointIndex,int pType)
    {
        world = worldScene;
        this.pointIndex = pointIndex;
        isVisible = true;
        pointType = pType;
        desertUuid = 0;
        oldInstances = new List<InstanceRequest>();
    }
    public void SetVisible(bool v)
    {
        isVisible = v;
        if (gameObject != null)
        {
            gameObject.SetActive(v);
        }
    }

    public int GetPointType()
    {
        return pointType;
    }
    // 创建游戏对象
    public virtual void CreateGameObject()
    {
        GameEntry.Event.Subscribe(EventId.MarchItemUpdateSelf, UpdateSelfMarch);
        CheckShowDesertTile();
    }

    public void SetClickEvent()
    {
        if (gameObject == null)
            return;
        
        _touchObject = gameObject.GetComponent<TouchObjectEventTrigger>();
        if (_touchObject == null)
            return;
        _touchObject.onPointerClick = () =>
        {
            GameEntry.Lua.Call("UIUtil.OnClickWorld", pointIndex, (int) ClickWorldType.Collider);
        };
    }

    public void UpdateSelfMarch(object o)
    {
        CheckShowTroopDestination();
    }
    // 数据变化时，更新游戏对象的表现
    public virtual void UpdateGameObject()
    {
        CheckShowDesertTile();
    }

    public virtual void OnUpdate(float deltaTime)
    {

    }

    public virtual void CheckShowTroopDestination()
    {
        
    }

    public void ShowTroopDestinationSignal(Vector3 localDestination, EnumDestinationSignalType signalType,int tileSize)
    {
        if (gameObject == null)
        {
            return;
        }
        if (_troopDestinationInst == null)
        {
            CreateTroopDestinationSignal(localDestination, signalType, tileSize);
            isSHowDestination = true;
        }
        else if(_troopDestinationInst!=null && _troopDestination!=null)
        {
            _troopDestination.SetDestinationForMarch(localDestination,signalType,tileSize);
            isSHowDestination = true;
        }
    }
    public void HideTroopDestinationSignal()
    {
        if (_troopDestinationInst != null)
        {
            if (_troopDestination != null)
            {
                _troopDestination.HideDestination();
            }
            else
            {
                DestroyTroopDestinationSignal();
            }
        }

        isSHowDestination = false;
    }
    private void CreateTroopDestinationSignal(Vector3 localDestination, EnumDestinationSignalType signalType,int tileSize)
    {
        if (gameObject == null)
        {
            return;
        }
        _troopDestinationInst =
            GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TroopDestinationSignal);
        _troopDestinationInst.completed += delegate(InstanceRequest request)
        {
            if (gameObject == null)
            {
                DestroyTroopDestinationSignal();
                return;
            }
            _troopDestinationInst.gameObject.transform.SetParent(gameObject.transform);
            _troopDestinationInst.gameObject.transform.localScale = Vector3.one;
            _troopDestination = _troopDestinationInst.gameObject.GetComponent<WorldTroopDestinationSignal>();
            _troopDestination.SetDestinationForMarch(localDestination,signalType,tileSize);
        };
    }
    private void DestroyTroopDestinationSignal()
    {
        if (_troopDestinationInst != null)
        {
            _troopDestinationInst.Destroy();
            _troopDestinationInst = null;
            _troopDestination = null;
        }
        isSHowDestination = false;
    }
    public virtual void OnUpdateIconScale(Quaternion rot, float scale)
    {
        
    }

    public virtual void Destroy()
    {
        GameEntry.Event.Unsubscribe(EventId.MarchItemUpdateSelf, UpdateSelfMarch);
        if (_touchObject != null)
        {
            _touchObject.onPointerClick = null;
        }
        DestroyTroopDestinationSignal();
        DestroyDesertTile();
        ClearOldObject();
        oldInstances = null;
        if (instance != null)
        {
            instance.Destroy();
            instance = null;
            gameObject = null;
        }
    }
    
    protected void ClearOldObject()
    {
        if (oldInstances != null)
        {
            foreach (var per in oldInstances)
            {
                if (per != null)
                {
                    per.Destroy();
                }
            }
            oldInstances.Clear();
        }
    }
    
    protected void AddOldObject()
    {
        if (instance != null)
        {
            oldInstances.Add(instance);
        }
    }

    public void SetAutoAdjustLod()
    {
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info == null)
        {
            return;
        }
        
        adjuster = gameObject.GetComponent<AutoAdjustLod>();
        if (adjuster == null)
        {
            adjuster = gameObject.AddComponent<AutoAdjustLod>();
        }

        if (info.pointType == WorldPointType.EXPLORE_POINT)
        {
            adjuster.SetLodType(LodType.Explore);
        }
        else if (info.pointType == WorldPointType.SAMPLE_POINT)
        {
            adjuster.SetLodType(LodType.Sample);
        }
        else if (info.pointType == WorldPointType.GARBAGE)
        {
            adjuster.SetLodType(LodType.Garbage);
        }
        else if (info.pointType == WorldPointType.MONSTER_REWARD)
        {
            adjuster.SetLodType(LodType.MonsterReward);
        }
        else if (info.pointType == WorldPointType.SAMPLE_POINT_NEW)
        {
            adjuster.SetLodType(LodType.Sample);
        }
        else if (info.pointType == WorldPointType.DETECT_EVENT_PVE)
        {
            adjuster.SetLodType(LodType.RadarPve);
        }
        else if (info.pointType == WorldPointType.NPC_CITY)
        {
            adjuster.SetLodType(LodType.NPCCity);
        }
    }

    private void CreateDesertTile(int tileSize,int pos,WorldDesertInfo info)
    {
        if (_desertTileInst == null)
        {
            desertPlayerType = info.GetPlayerType();
            hasAssistance = info.hasAssistance;
            desertId = info.desertId;
            isRedDesert = info.IsRed();
            isYellowDesert = info.IsYellow();
            desertMineId = info.mineId;
            PointInfo pointData = world.GetPointInfo(pointIndex);
            var showId = 100;
            // if (pointData == null || pointData.pointType == WorldPointType.WorldRuinPoint)
            // {
                showId = info.desertId;
            // }
            _desertTileInst = GameEntry.Resource.InstantiateAsync(GetModelPath(showId,info));
            _desertTileInst.completed += delegate(InstanceRequest request)
            {
                if (request.gameObject == null)
                {
                    DestroyDesertTile();
                    return;
                }
                request.gameObject.transform.SetParent(world.DynamicObjNode);
                var offset = (tileSize - 1);
                request.gameObject.transform.position = SceneManager.World.TileIndexToWorld(pos)+new Vector3(-offset, 0, -offset);
                request.gameObject.transform.localScale = new Vector3(tileSize, tileSize, tileSize);
                request.gameObject.SetActive(true);
                var str = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Desert,info.desertId,"desert_level");
                var curLevel = 0;
                if (str.IsNullOrEmpty() == false)
                {
                    curLevel = str.ToInt();
                }
                var bg = request.gameObject.transform.Find("icon/bg")?.gameObject;
                var levelText = request.gameObject.transform.Find("icon/name")?.GetComponent<SuperTextMesh>();
                var flag = request.gameObject.transform.Find("ModelGo/assistance")?.gameObject;
                if (bg != null)
                {
                    if (curLevel > 0)
                    {
                        if (bg.activeSelf == false)
                        {
                            bg.SetActive(true);
                        }
                    }
                    else
                    {
                        if (bg.activeSelf == true)
                        {
                            bg.SetActive(false);
                        }
                    }
                }
                if (levelText != null)
                {
                    if (curLevel > 0)
                    {
                        if (levelText.gameObject.activeSelf == false)
                        {
                            levelText.gameObject.SetActive(true);
                        }
                        levelText.text = str;
                    }
                    else
                    {
                        if (levelText.gameObject.activeSelf == true)
                        {
                            levelText.gameObject.SetActive(false);
                        }
                    }
                    
                   
                }

                if (flag != null)
                {
                    if (info.hasAssistance)
                    {
                        if (flag.activeSelf == false)
                        {
                            flag.SetActive(true);
                        }
                    }
                    else
                    {
                        if (flag.activeSelf == true)
                        {
                            flag.SetActive(false);
                        }
                    }
                }

                if (desertUuid != 0)
                {
                    var serverNow = GameEntry.Timer.GetServerTimeSeconds();
                    if (info.protectEndTime > serverNow || desertPlayerType == PlayerType.PlayerSelf)
                    {
                        isFireDesertEffect = true;
                        GameEntry.Event.Fire(EventId.DesertEffectInView,desertUuid);
                    }

                    if (info.mineId > 0)
                    {
                        isFireDesertMine = true;
                        GameEntry.Event.Fire(EventId.DesertMineInView, desertUuid);
                    }

                    if (info.oriDesertId != info.desertId && info.oriDesertId > 0)
                    {
                        isFireDesertLevel = true;
                        GameEntry.Event.Fire(EventId.DesertUpdateLevelInView, desertUuid);
                    }
                    GameEntry.Event.Fire(EventId.DesertInView,desertUuid);
                }
                
            };
        }
    }

    private string GetModelPath(int desertId,WorldDesertInfo info)
    {
        var modelName= "";
        var type = (int)WorldPointType.Other;
        if (WorldScene.ModelPathDic.ContainsKey(desertId))
        {
            var item = WorldScene.ModelPathDic[desertId];
            if (item.ContainsKey(type))
            {
                modelName = item[type];
            }
        }
        if (modelName.IsNullOrEmpty())
        {
            modelName =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Desert,desertId,"desert_model");
            if (!WorldScene.ModelPathDic.ContainsKey(desertId))
            {
                WorldScene.ModelPathDic[desertId] = new Dictionary<int, string>();
            }

            WorldScene.ModelPathDic[desertId][type] = modelName;
        }
        if (desertPlayerType == PlayerType.PlayerSelf)
        {
            return "Assets/Main/Prefabs/Building/"+modelName+"Self.prefab";
        }
        if (desertPlayerType == PlayerType.PlayerAlliance)
        {
            return "Assets/Main/Prefabs/Building/"+modelName+"Alliance.prefab";
        }
        if (desertPlayerType == PlayerType.PlayerOther)
        {
            if (info.IsYellow())
            {
                return "Assets/Main/Prefabs/Building/"+modelName+"Yellow.prefab"; 
            } 
            if (info.IsRed())
            {
                return "Assets/Main/Prefabs/Building/"+modelName+"Other.prefab"; 
            }
            return "Assets/Main/Prefabs/Building/"+modelName+"White.prefab"; 
            
        }
        return "Assets/Main/Prefabs/Building/"+modelName+"None.prefab";
    }
    private void UpdateDesertTile(int tileSize,int pos,WorldDesertInfo info)
    {
        var playerInfo = info.GetPlayerType();
        
        if (hasAssistance!= info.hasAssistance || desertId!=info.desertId || desertMineId!=info.mineId)
        {
            DestroyDesertTile();
            CreateDesertTile(tileSize,pos,info);
        }
        else if(playerInfo != desertPlayerType)
        {
            DestroyDesertTile();
            CreateDesertTile(tileSize,pos,info);
        }else if (playerInfo == desertPlayerType && desertPlayerType == PlayerType.PlayerOther)
        {
            var isYellow = info.IsYellow();
            if (isYellow != isYellowDesert)
            {
                isYellowDesert = isYellow;
                DestroyDesertTile();
                CreateDesertTile(tileSize,pos,info);
            }
            else
            {
                var isRed = info.IsRed();
                if (isRed != isRedDesert)
                {
                    isRedDesert = isRed;
                    DestroyDesertTile();
                    CreateDesertTile(tileSize,pos,info);
                }
            }

        }
    }
    private void DestroyDesertTile()
    {
        if (_desertTileInst != null)
        {
            _desertTileInst.Destroy();
            _desertTileInst = null;
        }
        if (desertUuid != 0)
        {
            if (isFireDesertEffect)
            {
                GameEntry.Event.Fire(EventId.DesertEffectOutView,desertUuid);
                isFireDesertEffect = false;
            }

            if (isFireDesertMine)
            {
                GameEntry.Event.Fire(EventId.DesertMineOutView, desertUuid);
                isFireDesertMine = false;
            }

            if (isFireDesertLevel)
            {
                GameEntry.Event.Fire(EventId.DesertUpdateLevelOutView, desertUuid);
                isFireDesertLevel = false;
            }
            
            GameEntry.Event.Fire(EventId.DesertOutView,desertUuid);
        }
    }

    public void CheckShowDesertTile()
    {
        var info = world.GetWorldTileInfo(pointIndex);
        var desertInfo = info.GetWorldDesertInfo();
        var pointInfo = info.GetPointInfo();
        if ((pointInfo == null || pointInfo.pointType == WorldPointType.WorldRuinPoint) && desertInfo != null)
        {
            var tile = 1;
            desertUuid = desertInfo.uuid;
            var mainPoint = desertInfo.pointIndex;

            if (_desertTileInst == null)
            {
                CreateDesertTile(tile,mainPoint,desertInfo);
            }
            else
            {
                UpdateDesertTile(tile,mainPoint,desertInfo);
            }
            
        }else if (_desertTileInst != null)
        {
            DestroyDesertTile();
        }
    }
}

//
// 世界建筑点
//
public class WorldBuildObject : WorldPointObject
{
    private CityBuilding cityBuilding;
    public long bUuid;
    private bool isDoFoldingUp = false;
    private float foldUpTime = 0.0f;
    private float startTime = 0.0f;
    private Vector3 startPos;
    private Vector3 endPos;
    private int bloodNum;
    private SpriteRenderer spriteRenderer;
    private GameObject playerHeadObj;
    private UIPlayerHead playerHead;
    private bool needFireOutView;//建筑着火/大本保护罩子/大本名字/自己的建筑
    private long _destroyStartTime = -1;
    public WorldBuildObject(WorldScene worldScene, int pointIndex,int pType)
        :base(worldScene, pointIndex,pType)
    {
        
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        BuildPointInfo bi = world.GetPointInfo(pointIndex) as BuildPointInfo;
        int level = bi.level;
        // if (bi.level > 0)
        // {
        //     if (bi.IsThisState(QueueState.UPGRADE))
        //     {
        //         ++level;//升级所用模型为下一级模型，0升1除外
        //     }
        // }
        // if (bi.itemId == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB && bi.level == 0)
        // {
        //     level = 0;
        // }
        var levelId = bi.itemId + level;
        
        var model= "";
        var type = bi.PointType;
        var skinId = bi.skinId;
        if (skinId > 0)
        {
            if (WorldScene.ModelPathDic.ContainsKey(skinId))
            {
                var item = WorldScene.ModelPathDic[skinId];
                if (item.ContainsKey(type))
                {
                    model = item[type];
                }
            }
            if (model.IsNullOrEmpty())
            {
                model =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Decoration,skinId,"model_world");
                if (!WorldScene.ModelPathDic.ContainsKey(skinId))
                {
                    WorldScene.ModelPathDic[skinId] = new Dictionary<int, string>();
                }

                WorldScene.ModelPathDic[skinId][type] = model;
            }
        }
        else
        {
            if (WorldScene.ModelPathDic.ContainsKey(levelId))
            {
                var item = WorldScene.ModelPathDic[levelId];
                if (item.ContainsKey(type))
                {
                    model = item[type];
                }
            }
            if (model.IsNullOrEmpty())
            {
                model =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,levelId,"model_world");
                if (!WorldScene.ModelPathDic.ContainsKey(levelId))
                {
                    WorldScene.ModelPathDic[levelId] = new Dictionary<int, string>();
                }

                WorldScene.ModelPathDic[levelId][type] = model;
            }
        }
        
        if (model.IsNullOrEmpty() ==false)
        {
            AddOldObject();

            instance = GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.Building, model));
            instance.completed += delegate
            {
                ClearOldObject();
                gameObject = instance.gameObject;
                if (gameObject != null)
                {
                    gameObject.transform.SetParent(world.DynamicObjNode);

                    cityBuilding = gameObject.GetComponent<CityBuilding>();
                    bUuid = bi.uuid;
                    if (cityBuilding != null)
                    {
                        CityBuilding.Param param = new CityBuilding.Param();
                        param.buildUuid = bUuid;
                        cityBuilding.CSInit(param);
                    }
                    gameObject.SetActive(isVisible);
                    if (isVisible)
                    {
                        needFireOutView = true;
                    }

                    bloodNum = bi.curHp;
                    _destroyStartTime = bi.destroyStartTime;
                    var temId = bi.itemId + bi.level;
                    var max_hp = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,temId,"max_hp").ToInt();
                    if (max_hp>0)
                    {
                        if (max_hp > bi.curHp)
                        {
                            GameEntry.Event.Fire(EventId.ShowIsOnFire,bUuid);
                            needFireOutView = true;
                        }
                    }
                    if (bi.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                    {
                        needFireOutView = true;
                        GameEntry.Event.Fire(EventId.CheckDomeOpen, bi.uuid);
                        spriteRenderer = gameObject.transform.Find("Icon/Sprite").GetComponentInChildren<SpriteRenderer>(true);
                        playerHeadObj = spriteRenderer.gameObject.transform.Find("head")?.gameObject;
                        if (playerHeadObj != null)
                        {
                            playerHead = playerHeadObj.transform.Find("headIcon")?.GetComponentInChildren<UIPlayerHead>(true);
                        }
                        SetIconSprite(bi);
                        SetPlayerHead(bi);
                    }

                    CheckShowTroopDestination();
                }
            };
        }

    }

    // 数据变化时，更新游戏对象的表现
    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        if (gameObject == null)
            return;
        if (cityBuilding != null)
        {
            cityBuilding.refeshDate();
            BuildPointInfo info = world.GetPointInfo(pointIndex) as BuildPointInfo;
            if (info != null)
            {
                if (bloodNum != info.curHp)
                {
                    bloodNum = info.curHp;
                    GameEntry.Event.Fire(EventId.ShowIsOnFire,bUuid);
                    needFireOutView = true;
                }
                if (info.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                {
                    needFireOutView = true;
                    GameEntry.Event.Fire(EventId.CheckDomeOpen, info.uuid);
                    SetIconSprite(info);
                }

                if (info.destroyStartTime > 0 && _destroyStartTime <= 0)
                {
                    needFireOutView = true;
                }
                else if (info.destroyStartTime <= 0 && _destroyStartTime > 0)
                {
                    needFireOutView = true;
                }

                _destroyStartTime = info.destroyStartTime;
            }
        }
    }

    private void SetIconSprite(BuildPointInfo info)
    {
        switch (info.GetPlayerType())
        {
            case PlayerType.PlayerSelf:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian3.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Self;
                break;
            case PlayerType.PlayerAlliance:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian4.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Ally;
                break;
            case PlayerType.PlayerAllianceLeader:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian5.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Leader;
                break;
            case PlayerType.PlayerOther:
                if (info.allianceId.IsNullOrEmpty() == false)
                {
                    string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                    if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                    }
                    else
                    {
                        
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian1.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Other;
                    }
                }
                else
                {
                    spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian1.png");
                    spriteRenderer.sortingOrder = (int) MainBuildOrder.Other;
                }
                break;
        }
    }
    
    private void SetPlayerHead(BuildPointInfo info)
    {
        if (playerHeadObj == null)
        {
            return;
        }
        if(info.GetPlayerType() == PlayerType.PlayerSelf)
        {
            if (playerHead != null)
            {
                playerHeadObj.SetActive(true);
                playerHead.enabled = true;
                var uid = GameEntry.Data.Player.Uid;
                var userPic = GameEntry.Lua.CallWithReturn<string>("CSharpCallLuaInterface.GetPlayerPic");
                var userPicVer = GameEntry.Lua.CallWithReturn<int>("CSharpCallLuaInterface.GetPlayerPicVer");
                playerHead.SetData(uid,userPic,userPicVer);
            }
            
            
        }
        else
        {
            playerHeadObj.SetActive(false);
        }
    }

    public void FoldUpBuild()
    {
        if (cityBuilding != null)
        {
            isDoFoldingUp = true;
            startTime = 0.0f;
            startPos = gameObject.transform.position;
            endPos = startPos + new Vector3(0,2.6f,0);
        }
    }

    public override void Destroy()
    {
        if (cityBuilding != null)
        {
            cityBuilding.CSUninit();
        }

        if (needFireOutView)
        {
            GameEntry.Event.Fire(EventId.WORLD_BUILD_OUT_VIEW, bUuid);
        }
        base.Destroy();
    }

    public override void OnUpdate(float deltaTime)
    {
        if (cityBuilding != null)
        {
            cityBuilding.CSUpdate(deltaTime);
        }

        if (isDoFoldingUp)
        {
            startTime += deltaTime;
            if (startTime >= foldUpTime)
            {
                var pos = world.WorldToScreenPoint(gameObject.transform.position);
                BuildPointInfo bi = world.GetPointInfo(pointIndex) as BuildPointInfo;
                if (bi != null)
                {
                    if (bi.IsMine())
                    {
                        GameEntry.Lua.ShowFoldUpBuild(pos.x.ToString(),pos.y.ToString(),pos.z.ToString(),bUuid.ToString());
                    }

                }
                world.AddToDeleteList(pointIndex);
            }
            else
            {
                gameObject.transform.position = Vector3.Lerp(startPos, endPos, (startTime / foldUpTime));
            }
        }
    }

    public override void OnUpdateIconScale(Quaternion rot, float scale)
    {
        // if (cityBuilding != null)
        // {
        //     cityBuilding.UpdateIconScale(rot, scale);
        // }
    }

    public Vector3 GetPosition()
    {
        return SceneManager.World.TileIndexToWorld(pointIndex);
    }

    public float GetHeight()
    {
        if(cityBuilding != null)
        {
            return cityBuilding.GetHeight();
        }

        return 3;
    }

    public CityBuilding GetCityBuilding()
    {
        return cityBuilding;
    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (VARIABLE.targetUuid == bUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}


public class WorldBuildObjectNew : WorldPointObject
{
    private WorldBuilding cityBuilding;
    public long bUuid;
    private bool isDoFoldingUp = false;
    private float foldUpTime = 0.0f;
    private float startTime = 0.0f;
    private Vector3 startPos;
    private Vector3 endPos;
    private SpriteRenderer spriteRenderer;
    private GameObject playerHeadObj;
    private UIPlayerHead playerHead;
    private bool needFireOutView;//建筑着火/大本保护罩子/大本名字/自己的建筑
    private long _destroyStartTime = -1;
    private long _buildFireEndTime = -1;
    private string _positionId;
    private SpriteRenderer seasonIcon;
    public WorldBuildObjectNew(WorldScene worldScene, int pointIndex,int pType)
        :base(worldScene, pointIndex,pType)
    {
        
    }

    public override void CreateGameObject()
    {
        BuildPointInfo bi = world.GetPointInfo(pointIndex) as BuildPointInfo;
        var tilePos = world.IndexToTilePos(pointIndex);
        if (bi != null)
        {
            var sz = bi.tileSize;
            if (sz > 1)
            {
                for (int x = 0; x < sz; x++)
                {
                    for (int y = 0; y < sz; y++)
                    {
                        var pos = tilePos - new Vector2Int(x, y);
                        if (!SceneManager.World.IsInMap(pos))
                        {
                            continue;
                        }

                        int tempIndex = world.TilePosToIndex(pos);
                        if (tempIndex == pointIndex)
                        {
                            continue;
                        }
                        SceneManager.World.RemoveObjectByPoint(tempIndex);
                    }
                }

            }
        }
        base.CreateGameObject();
        int level = bi.level;
        // if (bi.level > 0)
        // {
        //     if (bi.IsThisState(QueueState.UPGRADE))
        //     {
        //         ++level;//升级所用模型为下一级模型，0升1除外
        //     }
        // }
        // if (bi.itemId == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB && bi.level == 0)
        // {
        //     level = 0;
        // }
        var levelId = bi.itemId + level;
        
        var model= "";
        var type = bi.PointType;
        var skinId = bi.skinId;
        if (skinId > 0)
        {
            if (WorldScene.ModelPathDic.ContainsKey(skinId))
            {
                var item = WorldScene.ModelPathDic[skinId];
                if (item.ContainsKey(type))
                {
                    model = item[type];
                }
            }
            if (model.IsNullOrEmpty())
            {
                model =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Decoration,skinId,"model_world");
                if (!WorldScene.ModelPathDic.ContainsKey(skinId))
                {
                    WorldScene.ModelPathDic[skinId] = new Dictionary<int, string>();
                }

                WorldScene.ModelPathDic[skinId][type] = model;
            }
        }
        else
        {
            if (WorldScene.ModelPathDic.ContainsKey(levelId))
            {
                var item = WorldScene.ModelPathDic[levelId];
                if (item.ContainsKey(type))
                {
                    model = item[type];
                }
            }
            if (model.IsNullOrEmpty())
            {
                model =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building,levelId,"model_world");
                if (!WorldScene.ModelPathDic.ContainsKey(levelId))
                {
                    WorldScene.ModelPathDic[levelId] = new Dictionary<int, string>();
                }

                WorldScene.ModelPathDic[levelId][type] = model;
            }
        }
        if (model.IsNullOrEmpty() ==false)
        {
            AddOldObject();

            instance = GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.Building, model));
            instance.completed += delegate
            {
                ClearOldObject();
                gameObject = instance.gameObject;
                if (gameObject != null)
                {
                    gameObject.transform.SetParent(world.DynamicObjNode);

                    cityBuilding = gameObject.GetComponent<WorldBuilding>();
                    bUuid = bi.uuid;
                    if (cityBuilding != null)
                    {
                        WorldBuilding.Param param = new WorldBuilding.Param();
                        param.buildUuid = bUuid;
                        param.buildSceneType = WorldBuilding.BuildSceneType.World;
                        cityBuilding.CSInit(param);
                        cityBuilding.UpdateCityLabel(bi.uuid);
                    }
                    gameObject.SetActive(isVisible);
                    if (isVisible)
                    {
                        if (bi.IsMine())
                        {
                            GameEntry.Event.Fire(EventId.WORLD_BUILD_IN_VIEW, bUuid);
                        }
                        needFireOutView = true;
                    }
                    
                    _destroyStartTime = bi.destroyStartTime;
                    _buildFireEndTime = bi.fireEndTime;
                    var temId = bi.itemId + bi.level;
                    if (bi.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                    {
                        var curTime = GameEntry.Timer.GetServerTime();
                        if (curTime<_buildFireEndTime)
                        {
                            GameEntry.Event.Fire(EventId.ShowIsOnFire,bUuid);
                            needFireOutView = true;
                        }
                        needFireOutView = true;
                        if (bi.positionId.IsNullOrEmpty() == false)
                        {
                            _positionId = bi.positionId;
                            GameEntry.Event.Fire(EventId.CheckShowGovPos,bUuid);
                        }
                        GameEntry.Event.Fire(EventId.CheckDomeOpen, bi.uuid);
                        spriteRenderer = gameObject.transform.Find("Icon/Sprite").GetComponentInChildren<SpriteRenderer>(true);
                        playerHeadObj = spriteRenderer.gameObject.transform.Find("head")?.gameObject;
                        if (playerHeadObj != null)
                        {
                            playerHead = playerHeadObj.transform.Find("headIcon")?.GetComponentInChildren<UIPlayerHead>(true);
                        }
                        SetIconSprite(bi);
                        SetPlayerHead(bi);
                        if (bi.IsMine())
                        {
                            var moveUuid = GameEntry.Lua.CallWithReturn<long>("CSharpCallLuaInterface.GetOnMovingBuildUuid");
                            if (moveUuid != 0 && moveUuid == bi.uuid)
                            {
                                gameObject.SetActive(false);
                            }
                        }
                    }
                    else
                    {
                        seasonIcon= gameObject.transform.Find("iconGo/icon")?.GetComponentInChildren<SpriteRenderer>(true);
                        if (seasonIcon != null)
                        {
                            SetBuildIconColor(bi);
                        }
                    }

                    CheckShowTroopDestination();
                }
            };
        }

    }

    // 数据变化时，更新游戏对象的表现
    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        if (gameObject == null)
            return;
        if (cityBuilding != null)
        {
            cityBuilding.refeshDate();
            cityBuilding.UpdateCityLabel(bUuid);
            BuildPointInfo info = world.GetPointInfo(pointIndex) as BuildPointInfo;
            if (info != null)
            {
                if (info.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                {
                    if (_buildFireEndTime!=info.fireEndTime)
                    {
                        _buildFireEndTime = info.fireEndTime;
                        GameEntry.Event.Fire(EventId.ShowIsOnFire,bUuid);
                        needFireOutView = true;
                    }

                    var changeGovPos = false;
                    if (_positionId.IsNullOrEmpty() == false)
                    {
                        if (info.positionId.IsNullOrEmpty())
                        {
                            changeGovPos = true;
                        }
                        else if(_positionId != info.positionId)
                        {
                            changeGovPos = true;
                        }
                    }
                    else
                    {
                        if (info.positionId.IsNullOrEmpty() == false)
                        {
                            changeGovPos = true;
                        }
                    }

                    if (changeGovPos)
                    {
                        _positionId = info.positionId;
                        GameEntry.Event.Fire(EventId.CheckShowGovPos,bUuid);
                    }
                    needFireOutView = true;
                    GameEntry.Event.Fire(EventId.CheckDomeOpen, info.uuid);
                    SetIconSprite(info);
                }
                else
                {
                    if (seasonIcon != null)
                    {
                        SetBuildIconColor(info);
                    }
                }
                if (info.destroyStartTime > 0 && _destroyStartTime <= 0)
                {
                    needFireOutView = true;
                }
                else if (info.destroyStartTime <= 0 && _destroyStartTime > 0)
                {
                    needFireOutView = true;
                }

                _destroyStartTime = info.destroyStartTime;
            }
        }
    }

    private void SetIconSprite(BuildPointInfo info)
    {
        var isCrossServer = false;
        if (info.srcServerId != GameEntry.Data.Player.GetSelfServerId())
        {
            isCrossServer = true;
        }
        switch (info.GetPlayerType())
        {
            case PlayerType.PlayerSelf:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian3.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Self;
                break;
            case PlayerType.PlayerAlliance:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian4.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Ally;
                break;
            case PlayerType.PlayerAllianceLeader:
                spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian5.png");
                spriteRenderer.sortingOrder = (int) MainBuildOrder.Leader;
                break;
            case PlayerType.PlayerOther:
                if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                {
                    if (GameEntry.Data.Player.IsAllianceSelfCamp(info.allianceId) && GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==false)
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian7.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Other;
                    }
                    else
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                    }
                }
                else if (GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER || GameEntry.GlobalData.serverType == (int)ServerType.CROSS_THRONE)
                {
                    spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                    spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                }

                else if (info.allianceId.IsNullOrEmpty() == false)
                {
                     
                    string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                    if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                    }
                    else
                    {
                        if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                        {
                            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                            spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                        }
                        else
                        {
                            spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian1.png");
                            spriteRenderer.sortingOrder = (int) MainBuildOrder.Other;
                        }
                        
                    }
                }
                else
                {
                    if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian6.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Enemy;
                    }
                    else
                    {
                        spriteRenderer.LoadSprite("Assets/Main/Sprites/LodIcon/huojian1.png");
                        spriteRenderer.sortingOrder = (int) MainBuildOrder.Other;
                    }
                }
                break;
        }
    }

    private void SetBuildIconColor(BuildPointInfo info)
    {
        var isCrossServer = false;
        if (info.srcServerId != GameEntry.Data.Player.GetSelfServerId())
        {
            isCrossServer = true;
        }
//         iconColor = new Color(0.68f, 0.98f, 0.1f, 1f);
//     }
//     else if (marchInfo!=null && marchInfo.allianceUid == GameEntry.Data.Player.GetAllianceId())
//     {
//         iconColor = new Color(0.06f, 0.54f, 0.98f,1f);
//         UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_alliance";
//     }
// else
// {
//     iconColor = new Color(0.95f,0.24f,0.24f,1f);
//     UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_other";
// }
        switch (info.GetPlayerType())
        {
            case PlayerType.PlayerSelf:
                seasonIcon.color = new Color(0.68f, 0.98f, 0.1f, 1f);
                break;
            case PlayerType.PlayerAlliance:
                seasonIcon.color = new Color(0.06f, 0.54f, 0.98f,1f);
                break;
            case PlayerType.PlayerAllianceLeader:
                seasonIcon.color = new Color(0.06f, 0.54f, 0.98f,1f);
                break;
            case PlayerType.PlayerOther:
                if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                {
                    if (GameEntry.Data.Player.IsAllianceSelfCamp(info.allianceId) && GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==false)
                    {
                        seasonIcon.color = new Color(0.996f, 0.913f, 0.007f, 1f);
                    }
                    else
                    {
                        seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                    }
                }
                else if (info.allianceId.IsNullOrEmpty() == false)
                {
                    string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                    if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                    {
                        seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                    }
                    else
                    {
                        if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                        {
                            seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                        }
                        else
                        {
                            seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                        }
                        
                    }
                }
                else
                {
                    if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                    {
                        seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                    }
                    else
                    {
                        seasonIcon.color = new Color(0.95f,0.24f,0.24f,1f);
                    }
                }
                break;
        }
    }
    
    private void SetPlayerHead(BuildPointInfo info)
    {
        if (playerHeadObj == null)
        {
            return;
        }
        if(info.GetPlayerType() == PlayerType.PlayerSelf)
        {
            if (playerHead != null)
            {
                playerHeadObj.SetActive(true);
                playerHead.enabled = true;
                var uid = GameEntry.Data.Player.Uid;
                var userPic = GameEntry.Lua.CallWithReturn<string>("CSharpCallLuaInterface.GetPlayerPic");
                var userPicVer = GameEntry.Lua.CallWithReturn<int>("CSharpCallLuaInterface.GetPlayerPicVer");
                playerHead.SetData(uid,userPic,userPicVer);
            }
            
            
        }
        else
        {
            playerHeadObj.SetActive(false);
        }
    }

    public void FoldUpBuild()
    {
        if (cityBuilding != null)
        {
            foldUpTime = cityBuilding.DoFoldUpAnim();
            isDoFoldingUp = true;
            startTime = 0.0f;
            startPos = gameObject.transform.position;
            endPos = startPos + new Vector3(0,2.6f,0);
        }
    }
    

    public override void Destroy()
    {
        if (cityBuilding != null)
        {
            cityBuilding.CSUninit();
        }

        if (needFireOutView)
        {
            GameEntry.Event.Fire(EventId.WORLD_BUILD_OUT_VIEW, bUuid);
        }
        base.Destroy();
    }

    public override void OnUpdate(float deltaTime)
    {
        if (cityBuilding != null)
        {
            cityBuilding.CSUpdate(deltaTime);
        }

        if (isDoFoldingUp)
        {
            startTime += deltaTime;
            if (startTime >= foldUpTime)
            {
                var pos = world.WorldToScreenPoint(gameObject.transform.position);
                BuildPointInfo bi = world.GetPointInfo(pointIndex) as BuildPointInfo;
                if (bi != null)
                {
                    if (bi.IsMine())
                    {
                        GameEntry.Lua.ShowFoldUpBuild(pos.x.ToString(),pos.y.ToString(),pos.z.ToString(),bUuid.ToString());
                    }

                }
                world.AddToDeleteList(pointIndex);
            }
            else
            {
                gameObject.transform.position = Vector3.Lerp(startPos, endPos, (startTime / foldUpTime));
            }
        }
    }

    public override void OnUpdateIconScale(Quaternion rot, float scale)
    {
        // if (cityBuilding != null)
        // {
        //     cityBuilding.UpdateIconScale(rot, scale);
        // }
    }

    public Vector3 GetPosition()
    {
        return SceneManager.World.TileIndexToWorld(pointIndex);
    }

    public float GetHeight()
    {
        if(cityBuilding != null)
        {
            return cityBuilding.GetHeight();
        }

        return 3;
    }

    public WorldBuilding GetCityBuilding()
    {
        return cityBuilding;
    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (VARIABLE.targetUuid == bUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

//
// 资源
//
public class WorldResObject : WorldPointObject
{
    private GameObject model;
    private GameObject headObj;
    private SpriteRenderer headBg;
    private SpriteRenderer headIcon;
    private SpriteRenderer stateIcon;
    private SpriteRenderer lodIcon;
    private BuildingLabel label;
    private UIWorldLabel ModelLable;
    private UIWorldLabel IconLable;
    private long _gatherMarchUuid;
    // private Color MyTroopLineColor = new Color(0.68f, 0.98f, 0.1f, 1f);
    // private Color AllianceTroopLineColor = new Color(0.06f, 0.54f, 0.98f,1f);
    // private Color OtherTroopLineColor = new Color(1f, 1f, 1f,1f);// new Color(0.79f, 0.79f, 0.79f, 0.8f);
    // private Color EnemyTroopLineColor =  new Color(0.95f,0.24f,0.24f,1f);
    public WorldResObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        var info = world.GetPointInfo(pointIndex) as ResPointInfo;
        if (info != null)
        {
            //var template = GameEntry.DataTable.GetGatherResourceTemplate(info.id);
            //if (template != null)
            //{
                AddOldObject();
                instance = GameEntry.Resource.InstantiateAsync(GetAssetPath(info.id));
                instance.completed += delegate
                {
                    DestroyModel();
                    ClearOldObject();
                    gameObject = instance.gameObject;
                    if (gameObject != null)
                    {
                        gameObject.transform.SetParent(world.DynamicObjNode);
                        gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                        gameObject.SetActive(isVisible);
                        lodIcon = gameObject.transform.Find("Icon/CollectResourceIconSprite")
                            ?.GetComponentInChildren<SpriteRenderer>(true);
                        ModelLable = gameObject.transform.Find("Model/MonsterLabel")?.GetComponent<UIWorldLabel>();
                        IconLable = gameObject.transform.Find("Icon/IconLabel")?.GetComponent<UIWorldLabel>();
                        SetAutoAdjustLod();
                        // model = gameObject.transform.Find("Content/Model").gameObject;
                        var icon = gameObject.transform.Find("Icon/troopIcon")?.gameObject;
                        if (icon != null)
                        {
                            headObj = icon.transform.Find("head")?.gameObject;
                            if (headObj != null)
                            {
                                headBg = headObj.transform.Find("headbg")?.GetComponentInChildren<SpriteRenderer>(true);
                                headIcon = headObj.transform.Find("headIcon")?.GetComponentInChildren<SpriteRenderer>(true);
                            }
                        }
                        stateIcon = gameObject.transform.Find("Model/stateIcon")?.GetComponentInChildren<SpriteRenderer>(true);

                         var showIcon = false;
                         var headBgImg = "";
                         var headIconImg = "";
                         var UserHeadPath = "";
                         var iconColor = new Color(1f, 1f, 1f,1f);
                         if (info!=null && info.gatherMarchUuid != 0 )
                        {
                            // //依次判断自己-- > 盟友-- > 敌人
                            var marchInfo = world.GetMarch(info.gatherMarchUuid);
                            if ( marchInfo!=null && marchInfo.IsMine())
                            {
                                UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect";
                                // army = gameObject.GetComponent<BasementGetArmyResMetal>();
                                // army.Init(info.gatherMarchUuid);
                                _gatherMarchUuid = info.gatherMarchUuid;
                                // world.CreateArmyAnimalObject(info.gatherMarchUuid,info.id);
                                showIcon = true;
                                var armyInfo = marchInfo.GetFirstArmyInfo();
                                if (armyInfo != null && armyInfo.HeroInfos != null && armyInfo.HeroInfos.Count > 0)
                                {
                                    var heroData = armyInfo.HeroInfos[0];
                                    var rarity = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.APSHeros,heroData.heroId,"rarity");
                                    var isReachMax = heroData.GetIsAllSKillReachMax();
                                    headBgImg = GameEntry.Lua.CallWithReturn<string,int,bool>("CSharpCallLuaInterface.GetHeroQuality",rarity.ToInt(),isReachMax);
                                    headIconImg = GameEntry.Lua.CallWithReturn<string,int>("CSharpCallLuaInterface.GetHeroIcon",heroData.heroId);
                                }
                                iconColor = new Color(0.68f, 0.98f, 0.1f, 1f);
                            }
                            else if (marchInfo!=null && marchInfo.allianceUid == GameEntry.Data.Player.GetAllianceId())
                            {
                                iconColor = new Color(0.06f, 0.54f, 0.98f,1f);
                                UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_alliance";
                            }
                            else
                            {
                                if (marchInfo!=null &&GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER &&
                                    GameEntry.Data.Player.IsAllianceSelfCamp(marchInfo.allianceUid)&& GameEntry.Data.Player.GetIsInAttackDic(marchInfo.ownerUid)==false)
                                {
                                    iconColor = new Color(0.996f, 0.913f, 0.007f, 1f);
                                    UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_yellow";
                                }
                                else
                                {
                                    iconColor = new Color(0.95f,0.24f,0.24f,1f);
                                    UserHeadPath = "Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect_other";
                                }
                            }

                            if (stateIcon != null)
                            {
                                stateIcon.gameObject.SetActive(true);
                                stateIcon.LoadSprite(UserHeadPath);
                            }
                           
                        }
                        else
                        {
                            if (stateIcon != null)
                            {
                                stateIcon.gameObject.SetActive(false);
                            }
                        }
                         
                         var resLevel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.GatherResource,info.id,"level");
                         if (ModelLable != null)
                         {
                             ModelLable.gameObject.SetActive(true);
                             ModelLable.SetLevel(resLevel.ToInt(),iconColor);
                         }
                         if (IconLable != null)
                         {
                             IconLable.gameObject.SetActive(true);
                             IconLable.SetLevel(resLevel.ToInt(),iconColor);
                         }

                         if (lodIcon != null)
                         {
                             lodIcon.color = iconColor;
                         }
                        if (headObj != null)
                        {
                            if (showIcon == true)
                            {
                                headObj.SetActive(true);
                                if (headBg != null)
                                {
                                    headBg.LoadSprite(headBgImg);
                                }

                                if (headIcon != null)
                                {
                                    headIcon.LoadSprite(headIconImg);
                                }
                                
                            }
                            else
                            {
                                headObj.SetActive(false);
                            }
                        
                        }
                        
                        
                        
                        // label = gameObject.transform.Find("Content/Label").GetComponent<BuildingLabel>();
                        //label = gameObject.transform.Find("Label").GetComponent<UIWorldLabel>();
                        //label.SetLevel(info.level);

                        CheckShowTroopDestination();
                        SetClickEvent();
                    }
                };
            //}
        }
        
    }
    public override void Destroy()
    {
        DestroyModel();
        base.Destroy();
    }
    
    private void DestroyModel()
    {
        if (_gatherMarchUuid != 0)
        {
            GameEntry.Event.Fire(EventId.CollectPointOut,_gatherMarchUuid);
            _gatherMarchUuid = 0;
        }
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
 
    }

    // private string GetAssetPath(ResourceType type,int size)
    // {
    //     switch (type)
    //     {
    //         // case ResourceType.Food:
    //         //     return "Assets/Main/Prefabs/WorldResource/ResFood.prefab";
    //         // case ResourceType.Nuclear:
    //         //     return "Assets/Main/Prefabs/WorldResource/ResWood.prefab";
    //         case ResourceType.Oil:
    //             return "Assets/Main/Prefabs/WorldResource/ResOil.prefab";
    //         case ResourceType.Metal:
    //             return "Assets/Main/Prefabs/WorldResource/ResIron.prefab";
    //         case ResourceType.Money:
    //             return "Assets/Main/Prefabs/WorldResource/ResGold.prefab";
    //         default:
    //             return "Assets/Main/Prefabs/WorldResource/ResGold.prefab";
    //     }
    //
    //     return "";
    // }
    
    //获得模型名字
    // private string GetModelName(long marchUuid)
    // {
    //     if (marchUuid != 0)
    //     {
    //         var marchInfo = world.GetMarch(marchUuid);
    //         if (marchInfo != null)
    //         {
    //             if (marchInfo.IsMine())
    //             {
    //                 return GameDefines.EntityAssets.CollectBuildModelSelf;
    //             }
    //             else if (marchInfo.allianceUid == GameEntry.Data.Player.GetAllianceId())
    //             {
    //                 return GameDefines.EntityAssets.CollectBuildModelAlliance;
    //             }
    //         }
    //     }
    //
    //     return GameDefines.EntityAssets.CollectBuildModelEnemy;
    // }
    private string GetAssetPath(int id)
    {
        var resModel = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.GatherResource,id,"model");
        if (!resModel.IsNullOrEmpty())
        {
            return "Assets/Main/Prefabs/CollectResource/" + resModel+".prefab";
        }
        return "Assets/Main/Prefabs/CollectResource/CollectResourcesGold_world.prefab";
    }
    
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex) as ResPointInfo;
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (info!=null && info.gatherMarchUuid != 0 && VARIABLE.targetUuid == info.gatherMarchUuid)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
            else if (info!=null && (VARIABLE.target == MarchTargetType.COLLECT) && VARIABLE.targetPos == pointIndex)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

//
// 联盟矿
//
public class WorldAllianceBuildObject : WorldPointObject
{
    private WorldAllianceBuilding allianceBuild;
    private SpriteRenderer stateIcon;
    private long bUuid;
    public WorldAllianceBuildObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            AddOldObject();
            if (instance != null)
            {
                return;
            }

            var prefabPath = GameEntry.Lua.CallWithReturn<string, PointInfo>(
                "CSharpCallLuaInterface.GetWorldPointModelPath",
                info);
            if (!prefabPath.IsNullOrEmpty())
            {
                instance = GameEntry.Resource.InstantiateAsync(prefabPath);
                instance.completed += delegate
                {
                    //ClearOldObject();
                    gameObject = instance.gameObject;
                    if (gameObject != null)
                    {
                        gameObject.transform.SetParent(world.DynamicObjNode);
                        allianceBuild = gameObject.GetComponent<WorldAllianceBuilding>();
                        bUuid = info.uuid;
                        var extraData =  AllianceBuildingPointInfo.Parser.ParseFrom(info.extraInfo);
                        
                        if (allianceBuild != null)
                        {
                            WorldAllianceBuilding.Param param = new WorldAllianceBuilding.Param();
                            param.buildUuid = bUuid;
                            if (extraData != null)
                            {
                                param.buildId = extraData.BuildId;
                            }
                            param.buildSceneType = WorldAllianceBuilding.AllianceBuildSceneType.World;
                            allianceBuild.CSInit(param);
                            allianceBuild.UpdateCityLabel(info.uuid);
                        }
                        gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                        gameObject.SetActive(isVisible);
                        stateIcon = gameObject.transform.Find("ModelGo/stateIcon")?.GetComponentInChildren<SpriteRenderer>(true);
                        // model = gameObject.transform.Find("Model").gameObject;
                        // icon = gameObject.transform.Find("Icon").gameObject;
                        SetAutoAdjustLod();
                        UpdateGameObject();
                        CheckShowTroopDestination();
                        SetClickEvent();
                    }
                };
            }
            
        }
    }
    
    
    public override void Destroy()
    {
        base.Destroy();
        if (allianceBuild != null)
        {
            allianceBuild.CSUninit();
        }
    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex);
        var isShow = false;
        foreach (var VARIABLE in selfMarchList)
        {
            if (isShow == false)
            {
                if (info != null && info.uuid == VARIABLE.targetUuid && VARIABLE.targetUuid != 0 &&
                    (VARIABLE.status == MarchStatus.BUILD_ALLIANCE_BUILDING || VARIABLE.status == MarchStatus.COLLECTING || VARIABLE.status == MarchStatus.COLLECTING_ASSISTANCE))
                {
                    isShow = true;
                }
            }
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }

            if (info != null && info.uuid == VARIABLE.targetUuid && VARIABLE.targetUuid != 0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid,
                    pointIndex, VARIABLE.target, false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }
        if (needHide)
        {
            HideTroopDestinationSignal();
            if (stateIcon != null)
            {
                stateIcon.gameObject.SetActive(false);
            }
            
        }
        if (info != null && isShow ==true )
        {
            var extraData =  AllianceBuildingPointInfo.Parser.ParseFrom(info.extraInfo);
            if (extraData != null)
            {
                if (extraData.State == 1)
                {
                    if (stateIcon != null)
                    {
                        stateIcon.LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_icon_march_dig");
                    }
                }
                else
                {
                    if (stateIcon != null)
                    {
                        stateIcon.LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_icon_march_collect");
                    }
                }
            }
        }
        if (stateIcon != null)
        {
            stateIcon.gameObject.SetActive(isShow);
        }
    }
}
//
// 野怪/集结怪
//
public class WorldMonsterObject : WorldPointObject, WorldCulling.ICullingObject
{
    private const float BoundingSphereRadius = 2.0f;
    private BoundingSphere boundingSphere = new BoundingSphere(Vector3.zero, BoundingSphereRadius);
    //private MarchStateMachine stateMachine;
    private int monsterId;
    private GameObject model;
    private GameObject icon;
    private UIWorldLabel label;
    private GPUSkinningAnimator[] anims;
    
    private long battleDefUuid;

    public WorldMonsterObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
        //stateMachine = new MarchStateMachine(this);
        //stateMachine.AddBehaviour(MarchStateMachine.BehaviourType.Patrol);
        //stateMachine.AddBehaviour(MarchStateMachine.BehaviourType.Attack);
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        // var info = world.PointManager.GetPointInfo(pointIndex);
        // int monsterId = 0;
        // if (info.pointType == WorldPointType.WorldMonster)
        // {
        //     monsterId = (info as FieldMonsterPointInfo).monsterId;
        // }
        // else if (info.pointType == WorldPointType.WorldBoss)
        // {
        //     monsterId = (info as BossPointInfo).bossId;
        // }
        // var template = GameEntry.DataTable.GetCsvDataRow(GameDefines.TableName.APSMonster, monsterId.ToString());
        // if (template != null)
        // {
        //     var prefabPath = string.Format(GameDefines.EntityAssets.MonsterPath,template.GetString("model_name"));
        //     AddOldObject();
        //     instance = GameEntry.Resource.InstantiateAsync(prefabPath);
        //     instance.completed += delegate
        //     {
        //         ClearOldObject();
        //         gameObject = instance.gameObject;
        //         if (gameObject != null)
        //         {
        //             gameObject.transform.SetParent(world.DynamicObjNode);
        //             gameObject.transform.position = WorldScene.TileIndexToWorld(pointIndex);
        //             gameObject.SetActive(isVisible);
        //
        //             model = gameObject.transform.Find("Model").gameObject;
        //             icon = gameObject.transform.Find("Icon").gameObject;
        //             label = gameObject.transform.Find("Label").GetComponent<UIWorldLabel>();
        //             anims = model.GetComponentsInChildren<GPUSkinningAnimator>();
        //
        //             boundingSphere.position = gameObject.transform.position;
        //
        //             world.Culling.AddCullingBounds(this);
        //             if (info.pointType == WorldPointType.WorldMonster)
        //             {
        //                 label.SetLevel((info as FieldMonsterPointInfo).level);
        //             }
        //             else if (info.pointType == WorldPointType.WorldBoss)
        //             {
        //                 label.SetLevel((info as BossPointInfo).level);
        //             }
        //    
        //             //stateMachine.ChangeBehaviour(MarchStateMachine.BehaviourType.Patrol);
        //         }
        //     };
        // }
        //
        //GameEntry.Event.Subscribe(EventId.WorldBattleUpdate, ShowBattle);
    }

    public override void OnUpdate(float deltaTime)
    {
        //stateMachine.OnUpdate(deltaTime);
    }

    public override void OnUpdateIconScale(Quaternion rot, float scale)
    {
        // if (icon == null)
        //     return;
        // SetIconScale(icon.transform, scale, rot);
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
    }
    
    public override void Destroy()
    {
        world.RemoveCullingBounds(this);
        base.Destroy();
    }

    // public void Attack(long defUuid, BattleType defType)
    // {
    //     if (defUuid != 0)
    //     {
    //         battleDefUuid = defUuid;
    //         battleDefType = defType;
    //         //stateMachine.ChangeBehaviour(MarchStateMachine.BehaviourType.Attack);
    //     }
    //     else
    //     {
    //         battleDefUuid = 0;
    //         battleDefType = BattleType.None;
    //         //stateMachine.ChangeBehaviour(MarchStateMachine.BehaviourType.Patrol);
    //     }
    // }

    public void ShowBattleHurt(int hurt)
    {
        world.ShowBattleBlood(new BattleDecBloodTip.Param()
        {
            startPos = world.TileIndexToWorld(pointIndex),
            num = hurt,
            path = WorldTroop.normalWordPath,
        });
    }

    #region Culling

    public int CullingBoundsIndex { get; set; } = -1;

    public BoundingSphere GetBoundingSphere()
    {
        return boundingSphere;
    }

    public void OnCullingStateVisible(bool visible)
    {
        Array.ForEach(anims, i => i.Visible = visible);
    }

    #endregion

    #region March

    public long GetMarchStartTime()
    {
        throw new NotImplementedException();
    }

    public int[] GetMovePath()
    {
        throw new NotImplementedException();
    }

    public float GetSpeed()
    {
        return 0.3f * world.TileSize;
    }

    public Vector3 GetPosition()
    {
        if (gameObject != null)
        {
            return gameObject.transform.position;
        }
        return Vector3.zero;
    }
    
    public void SetPosition(Vector3 position)
    {
        if (gameObject != null)
        {
            gameObject.transform.position = position;
        }
    }

    public Vector3 GetTargetPosition()
    {
        throw new NotImplementedException();
    }

    public Vector4 GetPatrolArea()
    {
        // var center = world.TileIndexToWorld(pointIndex) + new Vector3(0, 0, WorldScene.TileDiagonalSize * 0.5f);
        // var radius = 0.5f * WorldScene.TileDiagonalSize;
        // return new Vector4(center.x, center.y, center.z, radius);
        return Vector4.zero;
    }

    public Quaternion GetRotation()
    {
        if (model != null)
        {
            return model.transform.rotation;
        }
        return Quaternion.identity;
    }

    public void SetRotation(Quaternion rotation)
    {
        if (model != null)
        {
            model.transform.rotation = rotation;
        }
    }

    public void CreateMarchLine()
    {
        throw new NotImplementedException();
    }

    public void DestroyMarchLine()
    {
        throw new NotImplementedException();
    }

    public void UpdateMarchLine(WorldTroopPathSegment[] path, int currPath, Vector3 currPos, bool clear = false)
    {
        throw new NotImplementedException();
    }

    public void PlayAnim(string animName)
    {
        for (int i = 0; i < anims.Length; i++)
        {
            anims[i].Play(animName);
        }
    }

    public void OnMarchMoveEnd()
    {
        throw new NotImplementedException();
    }

    #endregion
}


//小队探索
public class WorldExploreObject : WorldDetectEventItemObject
{
    private GPUSkinningAnimator[] gpuAnims;
    private ExplorePointInfoState currentState = ExplorePointInfoState.ExplorePointInfoStateNULL;
    public WorldExploreObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }

    public override bool DoDisappear()
    {
        return false;
    }
    
    protected override bool NeedShowDetectEventIcon()
    {
        return true;
    }

    public Transform GetTransform()
    {
        if (gameObject && gameObject.transform != null)
        {
            return gameObject.transform;
        }

        return null;
    }
    protected override bool NeedShowTime()
    {
        return false;
    }

    protected override string GetEventId()
    {
        var info = world.GetPointInfo(pointIndex) as ExplorePointInfo;
        return info.eventId;
    }
    
    protected override string GetModePath()
    {
        // return "Assets/Main/Prefabs/Explore/explore.prefab";
        var image = GameEntry.ConfigCache.GetTemplateData("detect_event", eventId.ToInt(), "image");
        return string.Format("Assets/Main/Prefabs/Monsters/{0}.prefab", image); 
    }
    
    protected override void DoWhenCreateComplete(GameObject model)
    {
        // GameEntry.Event.Subscribe(EventId.AttackExploreStart, DoWhenAttackExploreStart);
        GameEntry.Event.Subscribe(EventId.AttackExploreEnd, DoWhenAttackExploreEnd);
        model.transform.rotation = Quaternion.LookRotation(new Vector3(0.1f, 0, -1.0f));
        var labels = gameObject.transform.GetComponentsInChildren<UIWorldLabel>(true);
        Array.ForEach(labels, label => label.SetLevel(false));

        // var label = gameObject.transform.Find("ModelLabel").gameObject;
        // label.SetActive(false);
        SetState(ExplorePointInfoState.ExplorePointInfoStateNormal);
    }

    public void DoWhenAttackExploreStart(object userData, int soliderNum, int hp, int hpMax)
    {
        if (currentState != ExplorePointInfoState.ExplorePointInfoStateAttack)
        {
            var worldTroop = world.GetTroop((long)userData);
            var str = pointIndex.ToString() +";"+ soliderNum.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString();
            GameEntry.Event.Fire(EventId.ShowExploreHeadInBattle, str);
            model.transform.rotation = Quaternion.LookRotation(worldTroop.GetPosition() - model.transform.position);
        }
        SetState(ExplorePointInfoState.ExplorePointInfoStateAttack);
    }
    
    private void DoWhenAttackExploreEnd(object userData)
    {
        GameEntry.Event.Fire(EventId.HideExploreHead, pointIndex);
        SetState(ExplorePointInfoState.ExplorePointInfoStateNormal);
    }

    private void DoAttack(GameObject model)
    {
        DoAnimation(model, "attack");
    }

    public void UpdateBattleHeadUI(int anger, int hp, int hpMax)
    {
        var str = pointIndex.ToString() +";"+ anger.ToString() +";"+ hp.ToString() +";"+ hpMax.ToString();
        GameEntry.Event.Fire(EventId.ShowExploreBattleValue, str);
    }

    private void DoIdle(GameObject model)
    {
        DoAnimation(model, "idle");
    }
    private void DoAnimation(GameObject model, string animationName)
    {
        if (model)
        {
            gpuAnims = model.GetComponentsInChildren<GPUSkinningAnimator>();
            if (gpuAnims != null)
            {
                for (int i = 0; i < gpuAnims.Length; i++)
                {
                    gpuAnims[i].Play(animationName, UnityEngine.Random.Range(0, 1.0f));
                }
            }
        }
    }

    public void SetState(ExplorePointInfoState state)
    {
        if (currentState != state)
        {
            currentState = state;
            if (currentState == ExplorePointInfoState.ExplorePointInfoStateNormal)
            {
                DoIdle(model);
            }
            else if (currentState == ExplorePointInfoState.ExplorePointInfoStateAttack)
            {
                DoAttack(model);
            }
        }
    }

    public override void Destroy()
    {
        // GameEntry.Event.Unsubscribe(EventId.AttackExploreStart, DoWhenAttackExploreStart);
        GameEntry.Event.Unsubscribe(EventId.AttackExploreEnd, DoWhenAttackExploreEnd);
        GameEntry.Event.Fire(EventId.HideExploreHead, pointIndex);
        base.Destroy();
    }
    
    private float releaseSkillTick = 0;
    private const string sheldPath = "Assets/_Art/Effect/prefab/hero/Shaonian/VFX_shaonian_hudun.prefab";

    public float RelaseSkillTick
    {
        get
        {
            return releaseSkillTick;
        }
        set
        {
            releaseSkillTick = value;
        }

    }
    
    public void DoSkill(int useSkillID, DamageType damageType,int heroId,Dictionary<long,List<string>> useSkillList,long useSkillUid)
    {
        var effectPath =  GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.SkillTab, useSkillID,"effect_path");
        var requestInst = GameEntry.Resource.InstantiateAsync(effectPath);

        requestInst.completed += (result) =>
        {
            var hangPoint = this.model.gameObject;
            if(hangPoint!=null)
            {
                requestInst.gameObject.transform.SetParent(hangPoint.transform);
            }
            else
            {
                requestInst.gameObject.transform.SetParent(model.transform);
            }
            requestInst.gameObject.transform.localPosition = Vector3.zero;
            requestInst.gameObject.transform.localRotation = Quaternion.identity;
            requestInst.gameObject.transform.localScale = Vector3.one;
           // Debug.LogError(effectPath + ":" + useSkillID);
            //激光特效
            if (effectPath.IndexOf("VFX_Nvniuzai_attack")>=0/*useSkillID== 100008|| useSkillID== 100009||useSkillID== 100001*/)
            {
                var linRender = requestInst.gameObject.transform.GetComponentInChildren<LineRenderer>();
                if(linRender!=null)
                {
                    linRender.SetPosition(0, linRender.transform.position);
                    var traget = world.GetTroop(useSkillUid);
                    if(traget!=null)
                    {
                        linRender.SetPosition(1, new Vector3(traget.GetTransform().position.x, linRender.transform.position.y, traget.GetTransform().position.z));
                    }
                    else
                    {
                        requestInst.gameObject.Destroy();
                        return;
                    }
                }
            }
            YieldUtils.DelayActionWithOutContext(() => { requestInst.gameObject.Destroy(); }, 2);
        };
    }
    #if false
    public void ShowBattleHurt(int hurt, WorldMarchDataManager.BattleWordType worldType)
    {
        if(model == null || model.transform==null)
        {
            return;
        }
        string showPath = string.Empty;

        switch(worldType)
        {
            case WorldMarchDataManager.BattleWordType.Cure:
            {
                showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleCureBloodTip .prefab";
                break;
            }
            case WorldMarchDataManager.BattleWordType.Normal:
            {
                showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleNormalBloodTip.prefab";
                break;
            }
            case WorldMarchDataManager.BattleWordType.Skill:
            {
                showPath = "Assets/Main/Prefabs/UI/BattleWord/BattleDecBloodTip.prefab";
                break;
            }
            default:
                break;
        }

        world.ShowBattleBlood(new BattleDecBloodTip.Param()
        {
            startPos = model.gameObject.transform.position,
            num = hurt,
            path = WorldTroop.normalWordPath
        },showPath);
    }
#endif
}

public class WorldDetectEventItemObject : WorldPointObject
{
    protected GameObject model;
    protected GameObject icon;
    protected InstanceRequest detectEventInst;
    protected InstanceRequest pickGarbageInst;
    protected InstanceRequest colloctEffectObject;
    protected long pickupEndTime;
    protected long pickupStartTime;
    protected SuperTextMesh timeText;
    protected readonly string eventId;
    private bool isDisappearPlayEnd;
    private BoxCollider _boxCollider;
    private const string collectEffectPath = "Assets/_Art/Effect/prefab/scene/Common/VFX_jianlaji.prefab";
    
    private bool detectEventActiveCache = true;
    
    public WorldDetectEventItemObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
        eventId = GetEventId();
        isDisappearPlayEnd = false;
    }

    public virtual void UpdateDetectEventActive()
    {
        if (adjuster != null)
        {
            adjuster.UpdateLod(SceneManager.World.GetLodLevel());
        }
    }
    
    public override void OnUpdate(float deltaTime)
    {
        UpdateProgress();
    }

    public virtual bool DoDisappear()
    {
        if (model)
        { 
            Sequence seq = DOTween.Sequence();
            seq.Append(model.gameObject.transform.DOScale(new Vector3(1.0f, 1.0f, 1.0f), 0.5f));
            seq.Append(model.gameObject.transform.DOScale(new Vector3(0.3f, 0.3f, 0.3f), 0.3f));
            seq.onComplete = () =>
            {
                // isDisappearPlayEnd = true;
                SceneManager.World.AddToDeleteList(pointIndex);
            };
            return true;
        }
        return false;
    }

    // public bool NeedDestroyWhenDisappearEnd()
    // {
    //     return isDisappearPlayEnd;
    // }
    
    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        DoWhenMarchInfoChange(null);
    }
    
    protected virtual bool NeedShowDetectEventIcon()
    {
        return false;
    }

    protected virtual bool NeedShowTime()
    {
        return false;
    }

    protected virtual string GetEventId()
    {
        return "";
    }
    
    protected virtual string GetModePath()
    {
        return "Assets/Main/Prefabs/Sample/sample.prefab";
    }

    public void UpdateProgress()
    {
        var leftTime = 0L;
        if (timeText == null || pickGarbageInst == null)
        {
            return;
        }
        if (pickupEndTime > GameEntry.Timer.GetServerTime())
        {
            leftTime = pickupEndTime - GameEntry.Timer.GetServerTime();
        }
        timeText.text = GameEntry.Timer.MilliSecondToFmtString(leftTime);
    }

    private void DoWhenCollectStart(object userData)
    {
        var selfUid = GetPointUid();
        if ((long)userData == selfUid)
        {
            ShowCollectParticle();
        }
    }

    protected virtual long GetPointUid()
    {
        return 0L;
    }

    protected virtual void DoWhenMarchInfoChange(object userData)
    {
        var showProgress = NeedShowTime();
        if (!showProgress)
        {
            if (pickGarbageInst != null)
            {
                pickGarbageInst.Destroy();
                pickGarbageInst = null;
                HideCollectParticle();
            }

            detectEventActiveCache = true;
            UpdateDetectEventActive();
            if (detectEventInst != null && detectEventInst.gameObject != null)
            {
                detectEventInst.gameObject.SetActive(true);
            }
        }
        else
        {
            if (pickGarbageInst == null)
            {
                pickGarbageInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.CollectGarbageUI);
                pickGarbageInst.completed += delegate
                {
                    pickGarbageInst.gameObject.transform.SetParent(gameObject.transform);
                    pickGarbageInst.gameObject.transform.localPosition = Vector3.zero;
                    timeText = pickGarbageInst.gameObject.transform.Find("PosGo/TimeText").GetComponent<SuperTextMesh>();
                    var progress = pickGarbageInst.gameObject.GetComponent<ChangeSceneCircleSlider>();
                    progress.Init(pickupStartTime, pickupEndTime);
                    UpdateProgress();
                };
            }
            
            detectEventActiveCache = false;
            UpdateDetectEventActive();
            if (detectEventInst != null && detectEventInst.gameObject != null)
            {
                detectEventInst.gameObject.SetActive(false);
            }
        }
    }

    public override void Destroy()
    {
        base.Destroy();
        if (detectEventInst != null)
        {
            detectEventInst.Destroy();
            detectEventInst = null;
        }
        if (pickGarbageInst != null)
        {
            pickGarbageInst.Destroy();
            pickGarbageInst = null;
        }

        if (colloctEffectObject != null)
        {
            colloctEffectObject.Destroy();
            colloctEffectObject = null;
        }
        GameEntry.Event.Unsubscribe(EventId.MarchItemUpdateSelf, DoWhenMarchInfoChange);
        GameEntry.Event.Unsubscribe(EventId.GarbageCollectStart, DoWhenCollectStart);
    }
    
    public override void CreateGameObject()
    {
        base.CreateGameObject();
        AddOldObject();
        instance = GameEntry.Resource.InstantiateAsync(GetModePath());
        instance.completed += delegate
        { 
            ClearOldObject(); 
            gameObject = instance.gameObject;
            if (gameObject != null)
            {
                gameObject.name = "WorldPointObject_" + pointIndex;

                gameObject.transform.SetParent(world.DynamicObjNode);
                gameObject.transform.position = world.TileIndexToWorld(pointIndex);
                gameObject.SetActive(isVisible);
                gameObject.transform.localScale = Vector3.one;
                _boxCollider = gameObject.transform.GetComponent<BoxCollider>();
                model = gameObject.transform.Find("Model").gameObject;
                model.gameObject.transform.localScale = Vector3.one;
                icon = gameObject.transform.Find("Icon").gameObject;
                icon.SetActive(false);
                SetAutoAdjustLod();
                ShowDetectEvent();
                DoWhenMarchInfoChange(null);
                DoWhenCreateComplete(model);
                CheckShowTroopDestination();
                SetClickEvent();
            }
        };
        GameEntry.Event.Subscribe(EventId.MarchItemUpdateSelf, DoWhenMarchInfoChange);
        GameEntry.Event.Subscribe(EventId.GarbageCollectStart, DoWhenCollectStart);
    }

    protected virtual void DoWhenCreateComplete(GameObject model)
    {
        
    }

    public List<Vector3> GetPickPoint(Vector3 startPt)
    {
        var result = new List<Vector3>();
        if (model != null && model.gameObject != null)
        {
            float distance = 1.5f;
            int index = 0;
            int total = 5;
            float angleGap = 360 / total;
            //方案1
            double diffX = startPt.x - model.transform.position.x;
            double diffZ = startPt.z - model.transform.position.z;
            double startAngle = Math.Atan2( diffZ, diffX ) * 180 / Math.PI;
            while (index < total)
            {
                var angle = angleGap * index + startAngle;
                var addX = distance * Math.Cos(angle * Math.PI / 180);
                var addZ = distance * Math.Sin(angle * Math.PI / 180);
                var pt = model.transform.position + new Vector3((float)addX, 0.0f, (float)addZ);
                result.Add(pt);
                ++index;
            }
                //方案2
                
                // var bounds = _boxCollider.bounds;
                //
                // float distance = Vector3.Distance(model.transform.position, startPt) * 2;
                // int index = 0;
                // int total = 5;
                // float angleGap = 360 / total;
            //     double diffX = startPt.x - model.transform.position.x;
        //     double diffZ = startPt.z - model.transform.position.z;
        //     double startAngle = Math.Atan2( diffZ, diffX ) * 180 / Math.PI;
        //
        //     var min = bounds.min;
        //     var max = bounds.max;
        //     List<Vector2> allineStart = new List<Vector2>();
        //     List<Vector2> allineEnd = new List<Vector2>();
        //
        //     allineStart.Add(new Vector2(min.x, min.z));
        //     allineStart.Add(new Vector2(min.x, min.z));
        //     allineStart.Add(new Vector2(max.x, max.z));
        //     allineStart.Add(new Vector2(max.x, max.z));
        //
        //     allineEnd.Add(new Vector2(min.x, max.z));
        //     allineEnd.Add(new Vector2(max.x, min.z));
        //     allineEnd.Add(new Vector2(min.x, max.z));
        //     allineEnd.Add(new Vector2(max.x, min.z));
        //
        // while (index < total)
        // {
        //     var angle = angleGap * index + startAngle;
        //     var addX = distance * Math.Cos(angle * Math.PI / 180);
        //     var addZ = distance * Math.Sin(angle * Math.PI / 180);
        //     var tmpEndPt = new Vector2(model.transform.position.x + (float)addX,model.transform.position.z + (float)addZ);
        //     int lineIndex = 0;
        //     int lineTotal = allineEnd.Count;
        //     Vector2 tempStartPt = new Vector2(model.transform.position.x, model.transform.position.z);
        //     while (lineIndex < lineTotal)
        //     {
        //         var temp = GetIntersection(allineStart[lineIndex], allineEnd[lineIndex], tempStartPt,
        //             tmpEndPt);
        //
        //         if (temp.x == 0 && temp.y == 0)
        //         {
        //             
        //         }
        //         else
        //         {
        //             if ((temp.x - allineEnd[lineIndex].x) * (temp.x - allineStart[lineIndex].x) <= 0 && (temp.y - allineEnd[lineIndex].y) * (temp.y - allineStart[lineIndex].y) <= 0 &&
        //                 (temp.x - tmpEndPt.x) * (temp.x - tempStartPt.x) <= 0 && (temp.y - tmpEndPt.y) * (temp.y - tempStartPt.y) <= 0)
        //             {
        //                 result.Add(new Vector3(temp.x, 0, temp.y));
        //                 break;
        //             }
        //         }
        //
        //         ++lineIndex;
        //     }Rdqe
        //     ++index;
        // }
        }
        return result;
    }
    
    public Vector2 GetIntersection(Vector2 lineFirstStar, Vector2 lineFirstEnd, Vector2 lineSecondStar, Vector2 lineSecondEnd)
    {
        float a = 0, b = 0;
        int state = 0;
        if (lineFirstStar.x != lineFirstEnd.x)
        { 
            a = (lineFirstEnd.y - lineFirstStar.y) / (lineFirstEnd.x - lineFirstStar.x); 
            state |= 1;
        }
        if (lineSecondStar.x != lineSecondEnd.x)
        {
            b = (lineSecondEnd.y - lineSecondStar.y) / (lineSecondEnd.x - lineSecondStar.x);
            state |= 2;
        }
        switch (state)
        {
            case 0: //L1与L2都平行Y轴
            { 
                Log.Error("wrong position");
                return new Vector2(0, 0);
            } 
            case 1: //L1存在斜率, L2平行Y轴
            {
                float x = lineSecondStar.x;
                float y = (lineFirstStar.x - x) * (-a) + lineFirstStar.y; 
                return new Vector2(x, y);
            } 
            case 2: //L1 平行Y轴，L2存在斜率
            { 
                float x = lineFirstStar.x;

                float y = (lineSecondStar.x - x) * (-b) + lineSecondStar.y; 
                return new Vector2(x, y);
            }
            case 3: //L1，L2都存在斜率
            {
                if (a == b)
                {
                    Log.Error("wrong position1");
                    return new Vector2(0, 0);
                }
                float x = (a * lineFirstStar.x - b * lineSecondStar.x - lineFirstStar.y + lineSecondStar.y) / (a - b);
                float y = a * x - a * lineFirstStar.x + lineFirstStar.y;
                return new Vector2(x, y);
            }
        }
        return new Vector2(0, 0);
    }

    private void ShowCollectParticle()
    {
        // if (colloctEffectObject != null)
        // {
        //     if (colloctEffectObject.gameObject != null)
        //     {
        //         colloctEffectObject.gameObject.SetActive(true);
        //     }
        // }
        // else
        // {
        //     colloctEffectObject = GameEntry.Resource.InstantiateAsync(collectEffectPath);
        //     colloctEffectObject.completed += delegate
        //     {
        //         var atkEffectObject = colloctEffectObject.gameObject;
        //         atkEffectObject.SetActive(true);
        //         var point = gameObject.transform;
        //         if (point != null)
        //         {
        //             atkEffectObject.transform.SetParent(point);
        //             atkEffectObject.transform.localPosition = Vector3.zero;
        //             atkEffectObject.transform.localRotation = Quaternion.identity;
        //             atkEffectObject.transform.localScale = Vector3.one;
        //             
        //         }
        //     };
        // }
    }

    private void HideCollectParticle()
    {
        if (colloctEffectObject != null)
        {
            colloctEffectObject.Destroy();
            colloctEffectObject = null;
        }
    }
    
    private void ShowDetectEvent()
    {
        if (!NeedShowDetectEventIcon())
        {
            return;
        }
        detectEventInst = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.DetectEventUI);
        detectEventInst.completed += delegate
        {
            detectEventInst.gameObject.SetActive(true);
            detectEventInst.gameObject.transform.SetParent(gameObject.transform);
            detectEventInst.gameObject.transform.localPosition = Vector3.zero;
            var eventQuality = detectEventInst.gameObject.transform.Find("Transform/Detect_event_quality_icon").GetComponent<SpriteRenderer>();
            var eventIcon = detectEventInst.gameObject.transform.Find("Transform/Detect_event_icon").GetComponent<SpriteRenderer>();

            var tempQuality = GameEntry.ConfigCache.GetTemplateData("detect_event", eventId.ToInt(), "quality");
            var quality = tempQuality.ToInt();
            var tempIcon = GameEntry.ConfigCache.GetTemplateData("detect_event", eventId.ToInt(), "icon");
            var iconString = string.Format("Assets/Main/Sprites/UI/UIRadarCenter/{0}.png", tempIcon); 
            var tmpType = GameEntry.ConfigCache.GetTemplateData("detect_event", eventId.ToInt(), "type");
            var type = tmpType.ToInt();
            var qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_green.png";

            if (type == 10)
            {
                qualityStr = "Assets/Main/Sprites/UI/UIRadarCenter/Detect_spec_gold";
                eventIcon.transform.localPosition = new Vector3(0, 0, 0);
            }
            else
            {
                eventIcon.transform.localPosition = new Vector3(0, 0.11f, 0);
                if (quality == (int)DetectEventColor.DETECT_EVENT_WHITE )
                {
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_white";
                }
                else if (quality == (int)DetectEventColor.DETECT_EVENT_GREEN )
                {
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_green";
                }
                else if (quality == (int)DetectEventColor.DETECT_EVENT_BLUE)
                {
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_blue.png";
                }
                else if (quality == (int)DetectEventColor.DETECT_EVENT_PURPLE)
                {
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_purple.png";
                }
                else if (quality == (int)DetectEventColor.DETECT_EVENT_ORANGE)
                { 
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_orange.png";
                }
                else if (quality == (int)DetectEventColor.DETECT_EVENT_GOLDEN)
                {
                    qualityStr = "Assets/Main/Sprites/UI/UIBuildBubble/UIDetectEven_img_color_golden.png";
                }
            }
            
            eventQuality.LoadSprite(qualityStr);
            eventIcon.LoadSprite(iconString);
            if (pickGarbageInst != null)
            {
                detectEventActiveCache = false;
                UpdateDetectEventActive();
            }
        };
    }
    
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex);
        
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (info!=null && info.uuid ==VARIABLE.targetUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

//采样
public class WorldSampleObject : WorldDetectEventItemObject
{
    public WorldSampleObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
        
    }

    protected override bool NeedShowDetectEventIcon()
    {
        return true;
    }

    public override bool DoDisappear()
    {
        return false;
    }

    protected override long GetPointUid()
    {
        var info = world.GetPointInfo(pointIndex) as SamplePointInfo;
        if (info != null)
        {
            return info.uuid;
        }

        return 0L;
    }

    protected override bool NeedShowTime()
    {
        var info = world.GetPointInfo(pointIndex) as SamplePointInfo;
        if (info == null)
        {
            return false;
        }
        
        var showProgress = false;
        pickupStartTime = 0L;
        pickupEndTime = 0L;

        var marches = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var total = marches.Count;
        var startTime = 0L;
        var endTime = 1L;
        for (var i = 0; i < total; i++)
        {
            var march = marches[i];
            if (march != null && march.targetUuid == info.uuid && (march.status == MarchStatus.PICKING || march.status == MarchStatus.SAMPLING))
            {
                showProgress = true;
                pickupStartTime = march.startTime;
                pickupEndTime = march.endTime;
                break;
            }
        }

        if (!showProgress)
        {
            var fakeData = world.GetAllSampleFakeData();
            foreach (var march in fakeData)
            {
                if (march.Value != null && march.Value.targetUuid == info.uuid && march.Value.status == MarchStatus.SAMPLING)
                {
                    showProgress = true;
                    pickupStartTime = march.Value.startTime;
                    pickupEndTime = march.Value.endTime;
                    break;
                }
            }
        }
        return showProgress;
    }

    protected override string GetEventId()
    {
        var info = world.GetPointInfo(pointIndex) as SamplePointInfo;
        if (info != null)
        {
            return info.eventId;
        }
        return "";
    }
    
    protected override string GetModePath()
    {
        // return "Assets/Main/Prefabs/Sample/sample.prefab";
        var template = "";
        var id = eventId.ToInt();
        var type = (int)WorldPointType.SAMPLE_POINT;
        if (WorldScene.ModelPathDic.ContainsKey(id))
        {
            var item = WorldScene.ModelPathDic[id];
            if (item.ContainsKey(type))
            {
                template = item[type];
            }
        }
        if (template.IsNullOrEmpty())
        {
            template =  GameEntry.ConfigCache.GetTemplateData("detect_event", id, "image");
            if (!WorldScene.ModelPathDic.ContainsKey(id))
            {
                WorldScene.ModelPathDic[id] = new Dictionary<int, string>();
            }

            WorldScene.ModelPathDic[id][type] = template;
        }
        var imageStr = string.Format("Assets/Main/Prefabs/Garbage/{0}.prefab", template);

        return imageStr;

    }
}

//垃圾点
public class WorldGarbageObject : WorldDetectEventItemObject
{
    public WorldGarbageObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
        
    }
    
    protected override bool NeedShowDetectEventIcon()
    {
        return false;
    }

    protected override bool NeedShowTime()
    {
        var info = world.GetPointInfo(pointIndex) as GarbagePointInfo;
        if (info == null)
        {
            return false;
        }
        
        var showProgress = false;
        pickupStartTime = 0L;
        pickupEndTime = 0L;

        var marches = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var total = marches.Count;
        var startTime = 0L;
        var endTime = 1L;
        for (var i = 0; i < total; i++)
        {
            var march = marches[i];
            if (march != null && march.targetUuid == info.uuid && (march.status == MarchStatus.PICKING || march.status == MarchStatus.SAMPLING))
            {
                showProgress = true;
                pickupStartTime = march.startTime;
                pickupEndTime = march.endTime;
                break;
            }
        }

        var fakeData = world.GetAllSampleFakeData();
        foreach (var march in fakeData)
        {
            if (march.Value != null && march.Value.targetUuid == info.uuid && march.Value.status == MarchStatus.SAMPLING)
            {
                showProgress = true;
                pickupStartTime = march.Value.startTime;
                pickupEndTime = march.Value.endTime;
                break;
            }
        }

        return showProgress;
    }

    protected override long GetPointUid()
    {
        var info = world.GetPointInfo(pointIndex) as GarbagePointInfo;
        if (info != null)
        {
            return info.uuid;
        }

        return 0L;
    }

    protected override string GetEventId()
    {
        var info = world.GetPointInfo(pointIndex) as GarbagePointInfo;
        if (info != null)
        {
            return info.eventId;
        }
        return "";
    }
    
    protected override string GetModePath()
    {
        var template = "";
        var id = eventId.ToInt();
        var type = (int)WorldPointType.GARBAGE;
        if (WorldScene.ModelPathDic.ContainsKey(id))
        {
            var item = WorldScene.ModelPathDic[id];
            if (item.ContainsKey(type))
            {
                template = item[type];
            }
        }
        if (template.IsNullOrEmpty())
        {
            template =  GameEntry.ConfigCache.GetTemplateData("detect_event", id, "image");
            if (!WorldScene.ModelPathDic.ContainsKey(id))
            {
                WorldScene.ModelPathDic[id] = new Dictionary<int, string>();
            }

            WorldScene.ModelPathDic[id][type] = template;
        }
        var imageStr = string.Format("Assets/Main/Prefabs/Garbage/{0}.prefab", template);

        return imageStr;
    }
}

public class WorldBasePointObject : WorldPointObject
{
    // private GameObject model;
    // private GameObject icon;
    
    public WorldBasePointObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }
    

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            AddOldObject();
             if (instance != null)
             {
                 return;
             }
             var prefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
                     info);
             if (!prefabPath.IsNullOrEmpty())
             {
                 instance = GameEntry.Resource.InstantiateAsync(prefabPath);
                 instance.completed += delegate
                 {
                     //ClearOldObject();
                     gameObject = instance.gameObject;
                     if (gameObject != null)
                     {
                         gameObject.transform.SetParent(world.DynamicObjNode);
                         gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                         gameObject.SetActive(isVisible);
            
                         // model = gameObject.transform.Find("Model").gameObject;
                         // icon = gameObject.transform.Find("Icon").gameObject;
            
                         SetAutoAdjustLod();
                         UpdateGameObject();
                         CheckShowTroopDestination();
                         SetClickEvent();
                     }
                 };
             }
        }
        
        
    }
    public override void Destroy()
    {
        base.Destroy();
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex);
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (info!=null && info.uuid == VARIABLE.targetUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

public class WorldDragonPointObject : WorldPointObject
{
    private SpriteRenderer icon;
    private int pointId;
    private GameObject bookGo;
    private UIWorldLabel[] cityLabels;
    private long uuid;
    public WorldDragonPointObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }
    

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            pointId = info.mainIndex;
            uuid = info.uuid;
            AddOldObject();
             if (instance != null)
             {
                 return;
             }
             var prefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
                     info);
             if (!prefabPath.IsNullOrEmpty())
             {
                 instance = GameEntry.Resource.InstantiateAsync(prefabPath);
                 instance.completed += delegate
                 {
                     //ClearOldObject();
                     gameObject = instance.gameObject;
                     if (gameObject != null)
                     {
                         gameObject.transform.SetParent(world.DynamicObjNode);
                         gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                         gameObject.SetActive(isVisible);
            
                         // model = gameObject.transform.Find("Model").gameObject;
                         // icon = gameObject.transform.Find("Icon").gameObject;
                         icon = gameObject.transform.Find("Icon/IconSprite")?.GetComponentInChildren<SpriteRenderer>(true);
                         cityLabels = gameObject.GetComponentsInChildren<UIWorldLabel>(true);
                         bookGo = gameObject.transform.Find("ModelGo/Normal/bookEffect")?.gameObject;
                         SetAutoAdjustLod();
                         UpdateGameObject();
                         CheckShowTroopDestination();
                         SetClickEvent();
                         GameEntry.Event.Fire(EventId.DragonBuildInView,uuid);
                     }
                 };
             }
        }
        
        
    }
    public override void Destroy()
    {
        base.Destroy();
        GameEntry.Event.Fire(EventId.DragonBuildOutView,uuid);
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            if (icon != null)
            {
                var str = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetDragonBuildLodIcon",
                    info);
                icon.LoadSprite(str);
            }

            if (cityLabels != null)
            {
                Color32 color;
                switch (info.GetPlayerType())
                {
                    case PlayerType.PlayerAlliance:
                    {
                        color = GameDefines.CityLabelTextColor.Blue;
                        break;
                    }
                    case PlayerType.PlayerOther:
                    {
                        color = GameDefines.CityLabelTextColor.Red;
                        break;
                    }
                    default:
                    {
                        color = GameDefines.CityLabelTextColor.White;
                        break;
                    }
                }
                var nameStr = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetDragonBuildName",
                    info);
                Array.ForEach(cityLabels, label =>
                {
                    label.gameObject.SetActive(true);
                    label.SetNameBgSkin();
                    label.SetName(nameStr, color);
                });
            }

            if (bookGo != null)
            {
                bool has = false;
                var detail = DragonBuildingPointInfo.Parser.ParseFrom(info.extraInfo);
                if (detail != null)
                {
                    if (detail.State > 0)
                    {
                        has = true;
                    }
                }
                bookGo.SetActive(has);
            }
            GameEntry.Event.Fire(EventId.DragonBuildInView,uuid);
        }

    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex);
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (info!=null && info.uuid == VARIABLE.targetUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

public class WorldThronePointObject : WorldPointObject
{
    private SpriteRenderer icon;
    private int pointId;
    private UIWorldLabel[] cityLabels;
    private long uuid;
    public WorldThronePointObject(WorldScene worldScene, int pointIndex,int pType) : base(worldScene, pointIndex,pType)
    {
    }
    

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            pointId = info.mainIndex;
            uuid = info.uuid;
            AddOldObject();
             if (instance != null)
             {
                 return;
             }
             var prefabPath = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetWorldPointModelPath",
                     info);
             if (!prefabPath.IsNullOrEmpty())
             {
                 instance = GameEntry.Resource.InstantiateAsync(prefabPath);
                 instance.completed += delegate
                 {
                     //ClearOldObject();
                     gameObject = instance.gameObject;
                     if (gameObject != null)
                     {
                         gameObject.transform.SetParent(world.DynamicObjNode);
                         gameObject.transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                         gameObject.SetActive(isVisible);
            
                         // model = gameObject.transform.Find("Model").gameObject;
                         // icon = gameObject.transform.Find("Icon").gameObject;
                         icon = gameObject.transform.Find("Icon/IconSprite")?.GetComponentInChildren<SpriteRenderer>(true);
                         cityLabels = gameObject.GetComponentsInChildren<UIWorldLabel>(true);
                         SetAutoAdjustLod();
                         UpdateGameObject();
                         CheckShowTroopDestination();
                         SetClickEvent();
                         GameEntry.Event.Fire(EventId.CrossThroneBuildInView,uuid);
                     }
                 };
             }
        }
        
        
    }
    public override void Destroy()
    {
        base.Destroy();
        GameEntry.Event.Fire(EventId.CrossThroneBuildOutView,uuid);
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info != null)
        {
            if (icon != null)
            {
                var str = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetThroneBuildLodIcon",
                    info);
                icon.LoadSprite(str);
            }

            if (cityLabels != null)
            {
                Color32 color;
                switch (info.GetPlayerType())
                {
                    case PlayerType.PlayerAlliance:
                    {
                        color = GameDefines.CityLabelTextColor.Blue;
                        break;
                    }
                    case PlayerType.PlayerOther:
                    {
                        color = GameDefines.CityLabelTextColor.Red;
                        break;
                    }
                    default:
                    {
                        color = GameDefines.CityLabelTextColor.White;
                        break;
                    }
                }
                var nameStr = GameEntry.Lua.CallWithReturn<string,PointInfo>("CSharpCallLuaInterface.GetThroneBuildName",
                    info);
                Array.ForEach(cityLabels, label =>
                {
                    label.gameObject.SetActive(true);
                    label.SetNameBgSkin();
                    label.SetName(nameStr, color);
                });
            }
            GameEntry.Event.Fire(EventId.CrossThroneBuildInView,uuid);
        }

    }
    public override void CheckShowTroopDestination()
    {
        var needHide = isSHowDestination;
        var selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        var info = world.GetPointInfo(pointIndex);
        foreach (var VARIABLE in selfMarchList)
        {
            if (VARIABLE.IsVisibleMarch() == false)
            {
                continue;
            }
            if (info!=null && info.uuid == VARIABLE.targetUuid && VARIABLE.targetUuid!=0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                var destinationType = world.GetDestinationType(VARIABLE.uuid, VARIABLE.targetUuid, 
                    pointIndex, VARIABLE.target,false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }

        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}
public class WorldNpcCity : WorldPointObject
{
    private UIWorldLabel[] cityLabels;
    private NpcCityPointInfo npcCityPointInfo;
    private int level;
    
    public WorldNpcCity(WorldScene worldScene, int pointIndex, int pType) : base(worldScene, pointIndex, pType)
    {
        
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        if (instance != null)
        {
            return;
        }
        
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info == null)
        {
            return;
        }
        
        AddOldObject();
        npcCityPointInfo = NpcCityPointInfo.Parser.ParseFrom(info.extraInfo);
        level = GameEntry.ConfigCache.GetTemplateData("pvp_virtual_player", npcCityPointInfo.NpcId, "level").ToInt();
        string modelName = GameEntry.ConfigCache.GetTemplateData("pvp_virtual_player", npcCityPointInfo.NpcId, "model");
        string prefabPath = string.Format(GameDefines.EntityAssets.Building, modelName);
        if (!prefabPath.IsNullOrEmpty())
        {
            instance = GameEntry.Resource.InstantiateAsync(prefabPath);
            instance.completed += delegate
            {
                gameObject = instance.gameObject;
                if (gameObject != null)
                {
                    Transform transform = gameObject.transform;
                    transform.SetParent(world.DynamicObjNode);
                    transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                    gameObject.SetActive(isVisible);
                    cityLabels = gameObject.GetComponentsInChildren<UIWorldLabel>(true);

                    Collider collider = transform.GetComponent<Collider>();
                    if (collider != null)
                    {
                        collider.enabled = false;
                    }
                    
                    Transform spriteTf = transform.Find("Icon/Sprite");
                    if (spriteTf != null)
                    {
                        SpriteRenderer sprite = spriteTf.GetComponent<SpriteRenderer>();
                        if (sprite != null)
                        {
                            sprite.LoadSprite("Assets/Main/Sprites/LodIcon/huojian1.png");
                            sprite.sortingOrder = (int) MainBuildOrder.Enemy;
                        }
                    }
                    
                    Transform headTf = transform.Find("Icon/Sprite/head");
                    if (headTf != null)
                    {
                        headTf.gameObject.SetActive(false);
                    }
                    
                    SetAutoAdjustLod();
                    UpdateGameObject();
                    CheckShowTroopDestination();
                    SetClickEvent();
                    GameEntry.Event.Fire(EventId.NpcCityInView, npcCityPointInfo.Uuid);
                }
            };
        }
    }

    public override void UpdateGameObject()
    {
        base.UpdateGameObject();
        if (cityLabels != null)
        {
            foreach (UIWorldLabel label in cityLabels)
            {
                label.gameObject.SetActive(true);
                label.SetNameBgSkin();
                label.SetName(npcCityPointInfo.Name, GameDefines.CityLabelTextColor.White);
                label.SetLevel(level);
            }
        }
    }

    public override void Destroy()
    {
        base.Destroy();
        GameEntry.Event.Fire(EventId.NpcCityOutView, npcCityPointInfo.Uuid);
    }

    public override void CheckShowTroopDestination()
    {
        bool needHide = isSHowDestination;
        List<WorldMarch> selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info == null)
        {
            return;
        }
        
        foreach (WorldMarch march in selfMarchList)
        {
            if (march.IsVisibleMarch() && info.uuid == march.targetUuid && march.targetUuid != 0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                EnumDestinationSignalType destinationType = world.GetDestinationType(march.uuid, march.targetUuid, pointIndex, march.target, false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }
        
        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
}

public class WorldRuinCity : WorldPointObject
{
    private ITimer hideTimer;

    public WorldRuinCity(WorldScene worldScene, int pointIndex, int pType) : base(worldScene, pointIndex, pType)
    {
        
    }

    public override void CreateGameObject()
    {
        base.CreateGameObject();
        if (instance != null)
        {
            return;
        }
        
        RuinPointInfo info = world.GetPointInfo(pointIndex) as RuinPointInfo;
        if (info == null || !info.isMainPoint)
        {
            return;
        }
        
        // AddOldObject();

        var prefabPath = GameEntry.Lua.CallWithReturn<string, PointInfo>(
            "CSharpCallLuaInterface.GetWorldPointModelPath",
            info);

        if (!prefabPath.IsNullOrEmpty())
        {
            instance = GameEntry.Resource.InstantiateAsync(prefabPath);
            instance.completed += delegate
            {
                gameObject = instance.gameObject;
                if (gameObject != null)
                {
                    Transform transform = gameObject.transform;
                    transform.SetParent(world.DynamicObjNode);
                    transform.position = SceneManager.World.TileIndexToWorld(pointIndex);
                    gameObject.SetActive(isVisible);

                    SetAutoAdjustLod();
                    UpdateGameObject();
                    CheckShowTroopDestination();
                    var now = GameEntry.Timer.GetServerTimeSeconds();
                    if (now < info.endTime)
                    {
                        hideTimer = GameEntry.Timer.RegisterTimer(info.endTime - now, delegate
                        {
                            SetVisible((false));
                            GameEntry.Timer.CancelTimer(hideTimer);
                            hideTimer = null;
                        });
                    }
                    else
                    {
                        SetVisible((false));
                    }
                }
            };
        }
    }
    
    public override void CheckShowTroopDestination()
    {
        bool needHide = isSHowDestination;
        List<WorldMarch> selfMarchList = world.GetOwnerMarches(GameEntry.Data.Player.Uid);
        PointInfo info = world.GetPointInfo(pointIndex);
        if (info == null)
        {
            return;
        }
        
        foreach (WorldMarch march in selfMarchList)
        {
            if (march.IsVisibleMarch() && info.uuid == march.targetUuid && march.targetUuid != 0)
            {
                needHide = false;
                Vector3 targetRealPos = world.TileIndexToWorld(pointIndex);
                int tileSize = 1;
                EnumDestinationSignalType destinationType = world.GetDestinationType(march.uuid, march.targetUuid, pointIndex, march.target, false, ref targetRealPos, ref tileSize);
                ShowTroopDestinationSignal(targetRealPos, destinationType, tileSize);
                break;
            }
        }
        
        if (needHide)
        {
            HideTroopDestinationSignal();
        }
    }
    public override void Destroy()
    {
        if (hideTimer != null)
        {
            GameEntry.Timer.CancelTimer(hideTimer);
            hideTimer = null;
        }
        base.Destroy();
    }

}