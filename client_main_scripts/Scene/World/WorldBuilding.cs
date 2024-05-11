using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using XLua;

public class WorldBuilding : MonoBehaviour, ITouchPickable,
    // ITouchObjectClickHandler,
    ITouchObjectBeginLongTabHandler,
    ITouchObjectEndLongTabHandler
{

    public enum BuildSceneType
    {
        City = 1,
        World = 2,
        Fake = 3,
    }

    public class Param
    {
        public int buildId;
        public long buildUuid;
        public int point;
        public PlaceBuildType BuildTopType;
        public LuaTable noPutPoint;
        public BuildSceneType buildSceneType;
    }

    //建筑动画
    public class AnimName
    {
        public const string Idle = "idle"; //空闲动画
        public const string Click = "trigger"; //点击动画
        public const string Place = "placed"; //放置动画
        public const string Work = "working"; //正在工作状态
        public const string StartWork = "start"; //开始工作状态动画
        public const string EndWork = "end"; //结束工作状态
        public const string WorkIdle = "work_idle"; //结束工作状态后的空闲动画
        public const string SelfWork = "self_working"; //自己建筑正在工作状态（特殊状态）
        public const string SelfEndWork = "self_end"; //自己建筑结束状态（特殊状态）
    }
    
    private static readonly string ModelGoPathName = "ModelGo";
    private static readonly string FoldUpEffectPath = "Assets/Main/Prefabs/BuildEffect/BuildFoldUpEffect.prefab";

    //建筑动画播放状态
    public enum AnimTimeState
    {
        Play, //正在播放
        Stop, //停止
    }

    private enum BuildShowState
    {
        Normal,
        Box,
    }
    public static float ScreenRangeLeft = 0.0f;
    public static float ScreenRangeRight = 0.0f;
    public static float ScreenRangeTop = 0.0f;
    public static float ScreenRangeDown = 0.0f;

    private AnimTimeState _curAnimState;
    private float _curTime;
    private float _allTime;

    [SerializeField] private GameObject buildIcon;
    [SerializeField] protected GameObject buildModel;
    [SerializeField] private GameObject _shadow; //建筑影子
    [SerializeField] private GameObject _baseGlass; //大本罩子
    [SerializeField] private GameObject _effectGo; //建筑粒子特效 例如大本流水效果
    [SerializeField] private GPUSkinningAnimator gpuAnim; //建筑动画
    [SerializeField] private SimpleAnimation simpleAnim;
    [SerializeField] private SimpleAnimation _effectAnim; //建筑特效动画
    [SerializeField] private GameObject _foldUpGo; //建筑收起粒子
    [SerializeField] private GameObject _normalObj; //正常态
    [SerializeField] private GameObject _boxObj; //盒子态
    [SerializeField] private GameObject _ruinsObj; //废墟态
    [SerializeField] private SimpleAnimation _boxAnim;//盒子动画
    [SerializeField] private UIEventTrigger _focusEventTrigger; //点击这个物体将聚焦摄像机
    private UIWorldLabel[] cityLabels;
    private Vector2Int tilePos;
    private InstanceRequest tempInstance;
    private AutoAdjustLod adjuster;
    public Vector2Int TilePos
    {
        get { return tilePos; }
        set { SetTilePos1(value,SceneManager.World.TileToWorld(value)); }
    }

    public long Uuid { get; set; }

    public BuildPointInfo GetBuildInfo()
    {
        if (SceneManager.World != null)
        {
            return SceneManager.World.GetPointInfoByUuid(Uuid) as BuildPointInfo;
        }

        return null;
    }

    public int build_Id;
    public int tiles;
    public int scan;
    public int build_type;
    private Param _param;
    private string _animName;
    private BuildingGrowEffect _grow;
    
    private float _minX;//边界屏幕x最小坐标
    private float _maxX;//边界屏幕x最大坐标
    private float _minY;//边界屏幕y最小坐标
    private float _maxY;//边界屏幕y最大坐标
    
    private bool? _canShowCityLabel = null;
    private string _ownerUuid;
    protected int _level;
    private Dictionary<AnimTimeState, float> _buildingLevelBuildActionTime;
    private int _state;
    private Transform _modelGo;
    private InstanceRequest _foldUpInstanceRequest;//收起特效

    private void Awake()
    {
        _modelGo = transform.Find(ModelGoPathName);
    }

    public virtual void CSInit(object userData)
    {
        _buildingLevelBuildActionTime = new Dictionary<AnimTimeState, float>();
        build_Id = 0;
        _level = 0;
        _grow = gameObject.GetComponent<BuildingGrowEffect>();
        _minX = ScreenRangeLeft;
        _maxX = Screen.width - ScreenRangeRight;
        _minY = ScreenRangeDown;
        _maxY = Screen.height - ScreenRangeTop;
        _param = userData as Param;
        cityLabels = GetComponentsInChildren<UIWorldLabel>(true);

        if (_param != null)
        {
            Uuid = _param.buildUuid;
            int buildId = 0;
            switch (_param.buildSceneType)
            {
                case BuildSceneType.City:
                {
                    // var buildingData = GameEntry.Lua.CallWithReturn<LuaBuildData, long>(
                    //     "CSharpCallLuaInterface.GetBuildingDataByUuid", _param.buildUuid);
                    var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                    if (buildingData != null)
                    {
                        buildId = buildingData.buildId;
                    }
                 
                    GameEntry.Event.Subscribe(EventId.UPDATE_BUILD_DATA, UpdateBuildDataSignal);
                }
                    break;
                case BuildSceneType.World:
                {
                    var info = GetBuildInfo();
                    if (info != null)
                    {
                        buildId = info.itemId;
                        
                    }
                }
                    break;
                case BuildSceneType.Fake:
                {
                    buildId = _param.buildId;
                    Array.ForEach(cityLabels, label =>
                    {
                        label.gameObject.SetActive(false);
                    });
                } 
                    break;
            }

            build_Id = buildId;
            tiles = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, build_Id,"tiles").ToInt();
            if (build_Id == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
            {
                tiles =  SceneManager.World.GetBuildTileByItemId(buildId);
            }
            scan = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, build_Id,"scan").ToInt();
            build_type = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, build_Id,"build_type").ToInt();
            refeshDate();
            if (_foldUpGo != null)
            {
                _foldUpGo.SetActive(false);
            }
            
            if (_param.buildSceneType == BuildSceneType.Fake)
            {
                if (_param.BuildTopType == PlaceBuildType.Build || _param.BuildTopType == PlaceBuildType.Replace)
                {
                    FromUILoad();
                }
                else
                {
                    EnterMoveCityState((int)_param.BuildTopType);
                }
               
                
            }
            if (_focusEventTrigger != null)
            {
                _focusEventTrigger.onPointerClick = data =>
                {
                    Vector3 focusPos = transform.position + new Vector3(1 - tiles, 1 - tiles, 0); 
                    SceneManager.World.AutoLookat(focusPos, 23f, 0.3f);
                };
            }
            
            InitLod(gameObject);
        }
        else
        {
            gameObject.SetActive(false);
        }

    }

    public virtual void CSUninit()
    {
        DestroyFoldUpEffect();
        //RemoveRobot();
        CancelAnimTimer();
        Uuid = -1;
        tilePos = Vector2Int.zero;
        _param = null;
        _animName = null;
        _focusEventTrigger = null;
        _grow = null;
        DestroyDomeInstance();
        
       
        GameEntry.Event.Unsubscribe(EventId.UPDATE_BUILD_DATA, UpdateBuildDataSignal);

        cityLabels = null;
    }

    protected internal virtual void CSUpdate(float elapseSeconds)
    {
        if (_allTime > 0)
        {
            _curTime += Time.deltaTime;
            if (_curTime >= _allTime)
            {
                _allTime = 0;
                _curTime = 0;
                ChangeAnimTimerCallBack();
            }
        }
    }

    public void InitLod(GameObject gameObject)
    {
        BuildPointInfo info = GetBuildInfo();
        if (info == null)
        {
            return;
        }
        
        PlayerType playerType = info.GetPlayerType();
        LodType lodType = LodType.None;
        
        if (build_Id == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
        {
            // 大本
            if (playerType == PlayerType.PlayerSelf)
            {
                lodType = LodType.MainSelf;
            }
            else if (playerType == PlayerType.PlayerAlliance || playerType == PlayerType.PlayerAllianceLeader)
            {
                lodType = LodType.MainAlly;
            }
            else
            {
                if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                {
                    if (GameEntry.Data.Player.IsAllianceSelfCamp(info.allianceId) && GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==false)
                    {
                        lodType = LodType.MainOther;
                    }
                    else
                    {
                        lodType = LodType.MainEnemy;
                    }
                }
                else
                {
                    bool isCrossServer = info.srcServerId != GameEntry.Data.Player.GetSelfServerId();
                    if (info.allianceId.IsNullOrEmpty() == false)
                    {
                        string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                        if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                        {
                            lodType = LodType.MainEnemy;
                        }
                        else
                        {
                            if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                            {
                                lodType = LodType.MainEnemy;
                            }
                            else
                            {
                                lodType = LodType.MainOther;
                            }
                        
                        }
                    }
                    else
                    {
                        if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                        {
                            lodType = LodType.MainEnemy;
                        }
                        else
                        {
                            lodType = LodType.MainOther;
                        }
                    }
                }
                
                
            }
        }
        else if (build_Id == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_MAIN ||
                 build_Id == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB ||
                 build_Id == GameDefines.BuildingTypes.EDEN_WORM_HOLE_1 ||
                 build_Id == GameDefines.BuildingTypes.EDEN_WORM_HOLE_2 ||
                 build_Id == GameDefines.BuildingTypes.EDEN_WORM_HOLE_3 ||
                 build_Id == GameDefines.BuildingTypes.WORM_HOLE_CROSS)
        {
            // 虫洞
            // 大本
            if (playerType == PlayerType.PlayerSelf)
            {
                lodType = LodType.WormHoleSelf;
            }
            else if (playerType == PlayerType.PlayerAlliance || playerType == PlayerType.PlayerAllianceLeader)
            {
                lodType = LodType.WormHoleAlly;
            }
            else
            {
                if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                {
                    if (GameEntry.Data.Player.IsAllianceSelfCamp(info.allianceId) && GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==false)
                    {
                        lodType = LodType.WormHoleOther;
                    }
                    else
                    {
                        lodType = LodType.WormHoleEnemy;
                    }
                }
                else
                {
                    bool isCrossServer = info.srcServerId != GameEntry.Data.Player.GetSelfServerId();
                    if (info.allianceId.IsNullOrEmpty() == false)
                    {
                        string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                        if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                        {
                            lodType = LodType.WormHoleEnemy;
                        }
                        else
                        {
                            if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                            {
                                lodType = LodType.WormHoleEnemy;
                            }
                            else
                            {
                                lodType = LodType.WormHoleOther;
                            }
                        
                        }
                    }
                    else
                    {
                        if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true )
                        {
                            lodType = LodType.WormHoleEnemy;
                        }
                        else
                        {
                            lodType = LodType.WormHoleOther;
                        }
                    }
                }

                
                
            }
        }
        
        adjuster = gameObject.GetComponent<AutoAdjustLod>();
        if (lodType != LodType.None)
        {
            if (adjuster == null)
            {
                adjuster = gameObject.AddComponent<AutoAdjustLod>();
            }
            adjuster.SetLodType(lodType);
        }
        else
        {
            if (adjuster != null)
            {
                Destroy(adjuster);
            }
        }
    }

    public float DoFoldUpAnim()
    {
        ShowFoldUpEffect();
        if (_grow != null)
        {
            _grow.enabled = true;
            _grow.DisappearBuild(Uuid, build_Id, GameEntry.Timer.GetServerTimeSeconds(),
                GameEntry.Timer.GetServerTimeSeconds() + 1, tiles, GameEntry.Data.Player.Uid);
        }
        return 0.7f;
    }

    public void DoExtendDome()
    {
       
    }

    public void DoUpgradeDome()
    {
        GameEntry.Event.Fire(EventId.ShowDomeGlass,Uuid);
        ShowGlass(true);
    }

    public virtual void refeshDate()
    {
        if (_param != null)
        {
            int pointId = 0;
            switch (_param.buildSceneType)
            {
                case BuildSceneType.City:
                {
                    var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                    if (buildingData != null)
                    {
                        pointId = buildingData.pointId;
                        _level = buildingData.level;
                        _state = buildingData.state;
                    }

                }
                    break;
                case BuildSceneType.World:
                {
                    var info = GetBuildInfo();
                    if (info != null)
                    {
                        pointId = info.mainIndex;
                        _level = info.level;
                        if (info.ownerUid == GameEntry.Data.Player.Uid)
                        {
                            var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                            if (buildingData != null)
                            {
                                _state = info.state;
                            }
                        }
                    }
                }
                    break;
                case BuildSceneType.Fake:
                {
                    pointId = _param.point;
                    _level = 0;
                }
                    break;
            }
            _buildingLevelBuildActionTime.Clear();
            if (_level > 0)
            {
                var buildingLevelBuildAction = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.BuildingDes,  build_Id,"building_action");
                if (buildingLevelBuildAction.IsNullOrEmpty()==false)
                {
                    var animStr = buildingLevelBuildAction.Split(';');
                    if (animStr.Length > 1)
                    {
                        _buildingLevelBuildActionTime.Add(AnimTimeState.Play, animStr[0].ToFloat());
                        _buildingLevelBuildActionTime.Add(AnimTimeState.Stop, animStr[1].ToFloat());
                    }
            
                }
            }
            _param.point = pointId;
            if (pointId != 0)
            {
                SetTilePos1(SceneManager.World.IndexToTilePos(pointId), SceneManager.World.TileIndexToWorld(pointId));
            }
            InitBuildingGrow();
        }
    }

    /**
     * 设置世界坐标和格子坐标
     */
    private void SetTilePos1(Vector2Int pos, Vector3 worldpos)
    {
        if (pos != tilePos)
        {
            tilePos = pos;
            transform.position = SceneManager.World.TileToWorld(tilePos);
            SetTouchPickAblePos();
        }
    }

    private void SetTouchPickAblePos()
    {
        if (SceneManager.World.SelectBuild == (ITouchPickable)this)
        {
            SceneManager.World.touchPickablePos = GameEntry.Lua.CallWithReturn<List<int>, int, int>(
                "CSharpCallLuaInterface.GetBuildTileIndex", build_Id,
                SceneManager.World.TilePosToIndex(tilePos));
            GameEntry.Event.Fire(EventId.UIPlaceBuildChangePos, SceneManager.World.TilePosToIndex(tilePos));
        }
    }


    void FromUILoad()
    {
        SceneManager.World.SetSelectedPickable(this);
        long tempBuildUuid = 0;
        int point = 0;
        LuaTable noPutPoint = null;
        PlaceBuildType tempTopType = PlaceBuildType.Build;
        if (_param != null)
        {
            tempBuildUuid = _param.buildUuid;
            int guideType = GameEntry.Lua.CallWithReturn<int>("DataCenter.GuideManager:GetGuideType");
            if (guideType == GameDefines.GuideType.BuildPlace)
            {
                var para2 = GameEntry.Lua.CallWithReturn<string, string>("DataCenter.GuideManager:GetGuideTemplateParam",
                    "para2");
                if (!string.IsNullOrEmpty(para2))
                {
                    var spl = para2.Split(',');
                    if (spl.Length > 1)
                    {
                        _param.point = SceneManager.World.TilePosToIndex(GameEntry.Data.Building.GetMainPos() +
                                                                         new Vector2Int(spl[0].ToInt(),
                                                                             spl[1].ToInt()));
                    }
                    GameEntry.Lua.Call("DataCenter.GuideManager:DoNext");
                }
            }

            point = _param.point;
            tempTopType = _param.BuildTopType;
            noPutPoint = _param.noPutPoint;
            SetTilePos1(SceneManager.World.IndexToTilePos(point), SceneManager.World.TileIndexToWorld(point));
            SetTouchPickAblePos();
            GameEntry.Lua.UIManager.OpenWindow("UIPlaceBuild",build_Id,tempBuildUuid,point,(int)tempTopType);
        }

        if (_grow != null)
        {
            _grow.enabled = false;
            _grow.ShowBuildGridSelection();
            ShowShadow(false);
            ShowEffect(false);
            var putState = GameEntry.Lua.CallWithReturn<int, int,int, long,LuaTable>("CSharpCallLuaInterface.IsCanPutDownByBuild",build_Id,point, tempBuildUuid, noPutPoint);
            _grow.ShowCanPlace(putState == (int)PutState.Ok);
            
        }
    }

    public void EnterMoveCityState(int moveCityType)
    {
        SceneManager.World.SetSelectedPickable(this);
        long tempBuildUuid = 0;
        int point = GameEntry.Data.Building.GetWorldMainPos();
        LuaTable noPutPoint = null;
        PlaceBuildType tempTopType = PlaceBuildType.MoveCity;
        
        if (_param != null)
        {
            _param.BuildTopType = tempTopType;
            tempBuildUuid = _param.buildUuid;
            noPutPoint = _param.noPutPoint;
            SetTilePos1(SceneManager.World.WorldToTile(SceneManager.World.CurTarget), SceneManager.World.CurTarget);
            SetTouchPickAblePos();
            GameEntry.Lua.UIManager.OpenWindow("UIMoveCity",build_Id,tempBuildUuid,point,moveCityType);
        }

        if (_grow != null)
        {
            _grow.enabled = false;
            _grow.ShowBuildGridSelection();
            ShowShadow(false);
            ShowEffect(false);
            var putState = GameEntry.Lua.CallWithReturn<int, int,int, long,LuaTable>("CSharpCallLuaInterface.IsCanPutDownByBuild",build_Id,point, tempBuildUuid, noPutPoint);
            _grow.ShowCanPlace(putState == (int)PutState.Ok);
            
        }
    }

    public Transform GetTransform()
    {
        if (this.transform != null)
            return transform;

        return null;
    }

    public bool PointInPick()
    {
        var tilePos = SceneManager.World.GetTouchTilePos();

        Vector2Int vecPos = new Vector2Int(TilePos.x, TilePos.y);
        if (tilePos == vecPos)
        {
            return true;
        }

        int sz = tiles;
        if (sz > 1)
        {
            return GameEntry.Lua.CallWithReturn<bool,int,int,int,int,int>("CSharpCallLuaInterface.CheckIsInBuildRange",tilePos.x,tilePos.y,vecPos.x,vecPos.y, sz);
        }

        return false;
    }

    public void Drag(Vector3 pos)
    {
        if (SceneManager.World.GetTouchInputControllerEnable())
        {
            if (transform != null)
            {
                bool checkTreeShow = tilePos != SceneManager.World.WorldToTile(pos);
                var modelCenterPos = GameEntry.Lua.CallWithReturn<Vector3, int, int>("CSharpCallLuaInterface.GetBuildMainVecByModelCenter",SceneManager.World.WorldToTileIndex(pos), tiles);
                //设置位置
                SetTilePos1(SceneManager.World.WorldToTile(modelCenterPos), modelCenterPos);

                var pointIndex = SceneManager.World.WorldToTileIndex(modelCenterPos);
                var putState = PutState.None;
                if (_param != null)
                {
                    putState = (PutState)GameEntry.Lua.CallWithReturn<int, int, int, long, List<int>>(
                        "CSharpCallLuaInterface.IsCanPutDownByBuild", build_Id, pointIndex, _param.buildUuid,
                        null);

                }
                else
                {
                    putState = (PutState)GameEntry.Lua.CallWithReturn<int, int, int, long, List<int>>(
                        "CSharpCallLuaInterface.IsCanPutDownByBuild", build_Id, pointIndex, 0, null);
                }

                // _grow.ShowCanPlace(putState == PutState.Ok);
            }
        }
    }

    public virtual bool Select()
    {
        
        return false;
    }

    public bool CanLongTap()
    {
        return false;
    }

    T ITouchPickable.GetPickComponent<T>()
    {
        if (transform != null)
        {
            T com = default;
            com = transform.GetComponent<T>();
            return com;
        }

        return null;
    }


    // 建造过程的表现
    private void InitBuildingGrow()
    {
        if (_grow == null || _param == null)
            return;
        PlayerType playerType = PlayerType.PlayerSelf;
        QueueState state = QueueState.DEFAULT;
        int startTime = 0;
        int endTime = 0;
        string ownerUid = "";
        var now = GameEntry.Timer.GetServerTime();
        switch (_param.buildSceneType)
        {
            case BuildSceneType.City:
            {
                playerType = PlayerType.PlayerSelf;
                ownerUid = GameEntry.Data.Player.Uid;

                var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                if (buildingData != null)
                {
                    if (buildingData.buildUpdateTime>0)
                    {
                        state = QueueState.UPGRADE;
                    }
                    var luaData = GameEntry.Lua.CallWithReturn<LuaTable, long>(
                        "CSharpCallLuaInterface.GetBuildStartTimeAndEndTime", _param.buildUuid);
                    if (luaData != null)
                    {
                        if (luaData.ContainsKey("startTime"))
                        {
                            startTime = (int) (luaData.Get<long>("startTime") / 1000);
                        }
                        if (luaData.ContainsKey("endTime"))
                        {
                            endTime = (int) (luaData.Get<long>("endTime") / 1000);
                        }
                    }
                }

            }
                break;
            case BuildSceneType.World:
            {
                var info = GetBuildInfo();
                if (info != null)
                {
                    playerType = info.GetPlayerType();
                    ownerUid = info.ownerUid;
                    if (info.endTime > 0)
                    {
                        startTime = info.startTime;
                        endTime = info.endTime;
                        state = QueueState.UPGRADE;
                    }
                    else
                    {
                        startTime = info.startTime;
                        endTime = info.endTime;
                        state = info.GetShowState();
                        if (state == QueueState.UPGRADE)
                        {
                            state = info.GetShowStateByIndex(1);
                        }
                    }
                }
            }
                break;
            case BuildSceneType.Fake:
            {
                var param = GameEntry.BuildAnimatorManager.GetBuildingParam(_param.point);
                if (param != null && param.endTime > now)
                {
                    startTime = Mathf.RoundToInt(param.startTime / 1000f);
                    endTime = Mathf.RoundToInt(param.endTime / 1000f);
                }

                GameEntry.BuildAnimatorManager.RemoveOneBuild(_param.point);
            }
                break;
        }
        bool isShowRobot = scan == (int) BuildScanAnim.Play || scan == (int) BuildScanAnim.NoFly;
        
        switch (state)
        {
            case QueueState.UPGRADE:
            {
                if (build_type == (int) BuildType.Second)
                {
                    DoBuildPlaceAnim();
                    _grow.ShowNormal(playerType);
                    ShowShadow(true);
                    ShowGlass(false);
                    SetBuildShowState(BuildShowState.Normal);
                }
                else
                {
                    if (isShowRobot)
                    {
                        if (endTime > (now / 1000))
                        {
                            if (SceneManager.IsInCity())
                            {
                                _grow.enabled = true;
                                _grow.StartBuild(_param.buildUuid, build_Id, startTime, endTime, tiles,
                                    ownerUid, false,
                                    isShowRobot);
                                ShowShadow(false);
                                ShowEffect(false);
                                ShowGlass(true);
                                SetBuildShowState(BuildShowState.Normal);
                            }
                            else
                            {
                                //ShowRobot(startTime, endTime, ownerUid, tiles, _param.buildUuid);
                                if (_grow.isWorking)
                                {
                                    _grow.EndAnim();
                                }
                                if (_grow.enabled)
                                {
                                    _grow.enabled = false;
                                }
                                _grow.ShowNormal(playerType);
                                ShowShadow(true);
                                ShowGlass(false);
                                ShowEffect(false);
                                SetBuildShowState(BuildShowState.Normal);
                            }
                        }
                        else
                        {
                            if (_grow.isWorking)
                            {
                                _grow.EndAnim();
                            }
                            // PlayAnim(AnimName.Idle);
                            if (_grow.enabled)
                            {
                                _grow.enabled = false;
                            }
                            _grow.ShowNormal(playerType);
                            ShowShadow(true);
                            ShowGlass(false);
                            if (playerType == PlayerType.PlayerSelf &&
                                build_Id != GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                            {
                                SetBuildShowState(BuildShowState.Box);
                            }
                            else
                            {
                                SetBuildShowState(BuildShowState.Normal);
                            }

                        }
                    }
                    else
                    {
                        if (_grow.isWorking)
                        {
                            _grow.EndAnim();
                        }

                        // PlayAnim(AnimName.Idle);
                        if (_grow.enabled)
                        {
                            _grow.enabled = false;
                        }
                        _grow.ShowNormal(playerType);
                        ShowShadow(true);
                        ShowGlass(false);
                        ShowEffect(false);
                        if (endTime > (now / 1000))
                        {
                            SetBuildShowState(BuildShowState.Normal);
                        }
                        else
                        {
                            if (playerType == PlayerType.PlayerSelf &&
                                build_Id != GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                            {
                                SetBuildShowState(BuildShowState.Box);
                            }
                            else
                            {
                                SetBuildShowState(BuildShowState.Normal);
                            }
                        }
                        
                    }
                }
            }
                break;

            case QueueState.FACTORY:
            case QueueState.TRAINING:
            {
                if (_grow.isWorking)
                {
                    _grow.EndAnim();
                }

                switch (_animName)
                {
                    case null:
                    case AnimName.Idle:
                    {
                        var time = PlayAnim(AnimName.StartWork);
                        if (time > 0)
                        {
                            GameEntry.Timer.RegisterTimer(time, () =>
                            {
                                if (this != null && _param != null)
                                {
                                    if (_animName == AnimName.StartWork)
                                    {
                                        PlayAnim(AnimName.Work);
                                    }
                                    else
                                    {
                                        PlayAnim(AnimName.Idle);
                                    }
                                }
                            });
                        }
                        else
                        {
                            PlayAnim(AnimName.Work);
                        }
                    }
                        break;
                }

                if (_grow.enabled)
                {
                    _grow.enabled = false;
                }
                _grow.ShowNormal(playerType);
                ShowShadow(true);
                ShowGlass(false);
                SetBuildShowState(BuildShowState.Normal);
            }
                break;
            case QueueState.CURE_ARMY:
            {
                if (_grow.isWorking)
                {
                    _grow.EndAnim();
                }

                if (!IsSelfControlWorkAnim())
                {
                    switch (_animName)
                    {
                        case null:
                        case AnimName.Idle:
                        {
                            var time = PlayAnim(AnimName.StartWork);
                            if (time > 0)
                            {
                                GameEntry.Timer.RegisterTimer(time, () =>
                                {
                                    if (this != null && _param != null)
                                    {
                                        if (_animName == AnimName.StartWork)
                                        {
                                            PlayAnim(AnimName.Work);
                                        }
                                        else
                                        {
                                            PlayAnim(AnimName.Idle);
                                        }
                                    }
                                });
                            }
                            else
                            {
                                PlayAnim(AnimName.Work);
                            }
                        }
                            break;
                    }
                }

                if (_grow.enabled)
                {
                    _grow.enabled = false;
                }
                _grow.ShowNormal(playerType);
                ShowShadow(true);
                ShowGlass(false);
                SetBuildShowState(BuildShowState.Normal);
            }
                break;
            case QueueState.DEFAULT:
            {
                if (_grow.isWorking)
                {
                    _grow.EndAnim();
                }

                if (!IsSelfControlWorkAnim())
                {
                    switch (_animName)
                    {
                        case null:
                        {
                            PlayAnim(AnimName.Idle);
                        }
                            break;
                        case AnimName.Work:
                        {
                            var time = PlayAnim(AnimName.EndWork);
                            if (time > 0)
                            {
                                GameEntry.Timer.RegisterTimer(time, () =>
                                {
                                    if (this != null && _param != null)
                                    {
                                        if (_animName == AnimName.EndWork)
                                        {
                                            if (HasAnimClip(AnimName.WorkIdle))
                                            {
                                                PlayAnim(AnimName.WorkIdle);
                                            }
                                            else
                                            {
                                                PlayAnim(AnimName.Idle);
                                            }
                                        }
                                        else
                                        {
                                            PlayAnim(AnimName.Idle);
                                        }
                                    }
                                });
                            }
                            else
                            {
                                PlayAnim(AnimName.Idle);
                            }
                        }
                            break;
                        case AnimName.SelfWork:
                        {
                            var time = PlayAnim(AnimName.SelfEndWork);
                            if (time > 0)
                            {
                                GameEntry.Timer.RegisterTimer(time, () =>
                                {
                                    if (this != null && _param != null)
                                    {
                                        if (_animName == AnimName.SelfEndWork)
                                        {
                                            if (HasAnimClip(AnimName.WorkIdle))
                                            {
                                                PlayAnim(AnimName.WorkIdle);
                                            }
                                            else
                                            {
                                                PlayAnim(AnimName.Idle);
                                            }
                                        }
                                        else
                                        {
                                            PlayAnim(AnimName.Idle);
                                        }
                                    }
                                });
                            }
                            else
                            {
                                PlayAnim(AnimName.Idle);
                            }
                        }
                            break;
                    }
                }

                if (_grow.enabled)
                {
                    _grow.enabled = false;
                }
               
                _grow.ShowNormal(playerType);
                ShowShadow(true);
                ShowGlass(false);
                SetBuildShowState(BuildShowState.Normal);
            }
                break;
            default:
            {
                if (_grow.isWorking)
                {
                    _grow.EndAnim();
                }

                PlayAnim(AnimName.Idle);
                if (_grow.enabled)
                {
                    _grow.enabled = false;
                }
                _grow.ShowNormal(playerType);
                ShowShadow(true);
                ShowGlass(false);
                SetBuildShowState(BuildShowState.Normal);
                break;
            }

        }
    }

    //设置建筑影子显示/隐藏
    private void ShowShadow(bool isShow)
    {
        if (_shadow != null)
        {
            if (isShow)
            {
                if (_grow != null && _grow.IsUseFakeShadow())
                {
                    _shadow.SetActive(true);
                }
                else
                {
                    _shadow.SetActive(false);
                }
            }
            else
            {
                _shadow.SetActive(false);
            }
        }
    }

    void ITouchPickable.Click()
    {
    }

    public void DestroyDomeInstance()
    {
        if (tempInstance != null)
        {
            tempInstance.Destroy();
            tempInstance = null;
        }
    }

    //设置罩子显示/隐藏
    private void ShowGlass(bool upgradeDome)
    {
        return;
    }

    //设置建筑特效显示/隐藏
    private void ShowEffect(bool isShow)
    {
        if (_effectGo != null)
        {
            _effectGo.SetActive(isShow);
        }
    }
    public bool IsOutRange(Vector3 pos)
    {
        var screen = SceneManager.World.WorldToScreenPoint(pos);
        float screenX = screen.x;
        float screenY = screen.y;
        return screenX < _minX || screenX > _maxX ||
               screenY < _minY || screenY > _maxY;
    }

    public void ChangeTouchPos(int index)
    {
    }

    public void OnBattleDefUpdate(int damage)
    {
        if (damage <= 0)
        {
            return;
        }

        SceneManager.World.ShowBattleBlood(new BattleDecBloodTip.Param()
        {
            startPos = this.transform.position,
            num = damage,
            path = WorldTroop.normalWordPath,
        });
    }

    //针对于假建筑
    public void ResetParam(int posIndex = 0)
    {
        if (_param != null)
        {
            _param.point = posIndex;
        }
    }

    //移动建筑状态
    public void ChangeMove()
    {
        _param.BuildTopType = PlaceBuildType.Move;
        FromUILoad();
    }

    public Vector3 GetClosestPoint(Vector3 pos)
    {
        var screen = SceneManager.World.WorldToScreenPoint(pos);
        float screenX = screen.x;
        float screenY = screen.y;
        if (screenX < _minX)
        {
            screen.x = _minX;
        }
        else if (screenX > _maxX)
        {
            screen.x = _maxX;
        }
        if (screenY < _minY)
        {
            screen.y = _minY;
        }
        else if (screenY > _maxY)
        {
            screen.y = _maxY;
        }

        return SceneManager.World.ScreenPointToWorld(screen);
    }

    public bool HasAnimClip(string animName)
    {
        if (gpuAnim != null)
        {
            return gpuAnim.HasClip(animName);
        }
        else if (simpleAnim != null)
        {
            return simpleAnim.GetState(animName) != null;
        }

        return false;
    }

    public float PlayAnim(string animName)
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return 0;
        }
        
        float result = 0;
        if (_state == (int) BuildingStateType.Upgrading)
        {
            return result;
        }
        if (!string.IsNullOrEmpty(animName))
        {
            _animName = animName;
            if (gpuAnim != null)
                result = UIUtils.PlayAnimationReturnTime(gpuAnim, animName);
            else if (simpleAnim != null)
                result = UIUtils.PlayAnimationReturnTime(simpleAnim, animName);
            var effectName = animName + "_effect";
            if (_effectAnim != null && _effectAnim.GetState(effectName) != null)
            {
                ShowEffect(true);
                UIUtils.PlayAnimationReturnTime(_effectAnim, effectName);
            }
            else
            {
                ShowEffect(false);
            }
        }
        else
        {
            ShowEffect(false);
        }

        ChangeAnimTimerState(AnimTimeState.Play);

        return result;
    }

    public void DoBuildClickAnim()
    {
        float time = 0;
        if (gpuAnim != null)
            time = UIUtils.PlayAnimationReturnTime(gpuAnim, AnimName.Click);
        else if (simpleAnim != null)
            time = UIUtils.PlayAnimationReturnTime(simpleAnim, AnimName.Click);
        if (time > 0)
        {
            GameEntry.Timer.RegisterTimer(time, () =>
            {
                if (this != null && _param != null)
                {
                    PlayAnim(_animName);
                }
            });
        }
    }

    public void DoBuildPlaceAnim()
    {
        float time = 0;
        if (gpuAnim != null)
            time = UIUtils.PlayAnimationReturnTime(gpuAnim, AnimName.Place);
        else if (simpleAnim != null)
            time = UIUtils.PlayAnimationReturnTime(simpleAnim, AnimName.Place);
        if (time > 0)
        {
            GameEntry.Timer.RegisterTimer(time, () =>
            {
                if (this != null && _param != null)
                {
                    if (_animName != null)
                    {
                        PlayAnim(_animName);
                    }
                    else
                    {
                        PlayAnim(AnimName.Idle);
                    }
                }
            });
        }
    }
    

    float ITouchObject.Priority
    {
        get { return 1.0f; }
    }

    Vector2Int ITouchObject.TilePos
    {
        get
        {
            if (_param.buildSceneType == BuildSceneType.City)
            {
                var data = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                if (data != null)
                {
                    return SceneManager.World.IndexToTilePos(data.pointId);
                }
            }
            else if (_param.buildSceneType == BuildSceneType.World)
            {
                var info = GetBuildInfo();
                return SceneManager.World.IndexToTilePos(info.pointIndex);
            }

            return Vector2Int.zero;

        }
    }

    public bool OnClick()
    {
        // DoBuildClickAnim();
        // if (SceneManager.IsInWorld())
        // {
        //     var pointIndex = SceneManager.World.TilePosToIndex(tilePos);
        //     GameEntry.Lua.Call("UIUtil.OnClickWorld", pointIndex,(int)ClickWorldType.Collider);
        // }
        // else if (SceneManager.IsInCity())
        // {
        //     var pointIndex = SceneManager.World.TilePosToIndex(tilePos);
        //     GameEntry.Lua.Call("UIUtil.OnClickCity", pointIndex,(int)ClickWorldType.Collider);
        // }
    
        return true;
    }

    public bool OnBeginLongTap()
    {
        if (GameEntry.Lua.CallWithReturn<bool, int>("CSharpCallLuaInterface.CanMoveBuild", build_Id))
        {
            if (_param.buildSceneType == BuildSceneType.City)
            {
                var data = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                if (data != null)
                {
                    SceneManager.World.ShowLoad(GameEntry.Lua.CallWithReturn<Vector3, int, int>("CSharpCallLuaInterface.GetBuildModelCenterVec",data.pointId, tiles));
                }
            }
            else if (_param.buildSceneType == BuildSceneType.World)
            {
                var info = GetBuildInfo();
                if (info.ownerUid == GameEntry.Data.Player.Uid)
                {
                    var buildInfo = info as BuildPointInfo;
                    if (buildInfo != null)
                    {
                        if (buildInfo.itemId != GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB)
                        {
                            if (buildInfo.itemId == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
                            {
                                var buildingData = GameEntry.Data.Building.GetBuildingDataByBuildId(GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB);
                                if (buildingData == null)
                                {
                                    SceneManager.World.ShowLoad(GameEntry.Lua.CallWithReturn<Vector3, int, int>("CSharpCallLuaInterface.GetBuildModelCenterVec",info.mainIndex, tiles));
                                }
                            }
                            else
                            {
                                SceneManager.World.ShowLoad(GameEntry.Lua.CallWithReturn<Vector3, int, int>("CSharpCallLuaInterface.GetBuildModelCenterVec",info.mainIndex, tiles));
                            }
                                
                        }
                    }
                }
            }
        }

        return true;
    }

    public bool OnEndLongTap()
    {
        if (GameEntry.Lua.CallWithReturn<bool, int>("CSharpCallLuaInterface.CanMoveBuild", build_Id))
        {
            if (_param.buildSceneType == BuildSceneType.City)
            {
                var data = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                if (data != null)
                {
                    ChangeMove();
                }
            }
            else if (_param.buildSceneType == BuildSceneType.World)
            {
                var info = GetBuildInfo();
                if (info.pointType == WorldPointType.PlayerBuilding && info.ownerUid == GameEntry.Data.Player.Uid && info.itemId != GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_SUB)
                {
                    if (info.itemId == GameDefines.BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
                    {
                        var buildingData =
                            GameEntry.Data.Building.GetBuildingDataByBuildId(GameDefines.BuildingTypes
                                .APS_BUILD_WORMHOLE_SUB);
                        if (buildingData == null)
                        {
                            ChangeMove();
                        }
                    }
                    else
                    {
                        ChangeMove();
                    }
                    
                }
            }
        }

        return true;
    }

    private void ChangeAnimTimerState(AnimTimeState animTimeState)
    {
        CancelAnimTimer();
        _curAnimState = animTimeState;
        if (_param == null)
        {
            return;
        }

        float time = 0;
        if (_buildingLevelBuildActionTime.ContainsKey(animTimeState))
        {
            time = _buildingLevelBuildActionTime[animTimeState];
        }

        if (time > 0)
        {
            AddAnimTimer(time);
        }
    }

    private void CancelAnimTimer()
    {
        _allTime = 0;
        _curTime = 0;
    }

    private void AddAnimTimer(float time)
    {
        CancelAnimTimer();
        _allTime = time;
        _curTime = 0;
    }

    private void StopAnim()
    {
        if (gpuAnim != null)
        {
            gpuAnim.Stop();
        }
        else if (simpleAnim != null)
        {
            simpleAnim.Stop();
        }

        ShowEffect(false);
        ChangeAnimTimerState(AnimTimeState.Stop);
    }

    private void ChangeAnimTimerCallBack()
    {
        switch (_curAnimState)
        {
            case AnimTimeState.Play:
            {
                StopAnim();
            }
                break;
            case AnimTimeState.Stop:
            {
                PlayAnim(_animName);
            }
                break;
        }
    }

    public float GetHeight()
    {
        if (_grow != null)
        {
            return _grow.GetHeight();
        }

        return 0;
    }

    public void ShowDome()
    {
        
    }

    public void HideDome()
    {
       
    }

    public bool IsSelf()
    {
        switch (_param.buildSceneType)
        {
            case BuildSceneType.City:
            {
                return true;
            }
                break;
            case BuildSceneType.World:
            {
                var info = GetBuildInfo();
                if (info != null && info.ownerUid == GameEntry.Data.Player.Uid)
                {
                    return true;
                }
            }
                break;
        }

        return false;
    }

    public void UpdateCityLabel(long obj)
    {
        long uuid = obj;
        if (Uuid != uuid)
        {
            return;
        }
        BuildPointInfo info = SceneManager.World.GetPointInfoByUuid(uuid) as BuildPointInfo;
        if (info!=null)
        {
            StringBuilder sb = new StringBuilder();
            var isCrossServer = false;
            if (info.srcServerId != GameEntry.Data.Player.GetSelfServerId())
            {
                sb.Append($"#{info.srcServerId} ");
                isCrossServer = true;
            }
            if (!string.IsNullOrEmpty(info.alAbbr))
            {
                sb.Append($"[{info.alAbbr}]");
            }

            if (!string.IsNullOrEmpty(info.playerName))
            {
                sb.Append(info.playerName);
            }

            Color32 color;
            switch (info.GetPlayerType())
            {
                case PlayerType.PlayerSelf:
                {
                    color = GameDefines.CityLabelTextColor.Green;
                    break;
                }
                case PlayerType.PlayerAlliance:
                {
                    color = GameDefines.CityLabelTextColor.Blue;
                    break;
                }
                case PlayerType.PlayerAllianceLeader:
                {
                    if (info.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                    {
                        color = GameDefines.CityLabelTextColor.Purple;
                    }
                    else
                    {
                        color = GameDefines.CityLabelTextColor.Blue;
                    }
                    break;
                }
                default:
                {
                    if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                    {
                        if (GameEntry.Data.Player.IsAllianceSelfCamp(info.allianceId)&& GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==false)
                        {
                            color = GameDefines.CityLabelTextColor.Yellow;
                        }
                        else
                        {
                            color = GameDefines.CityLabelTextColor.Red;
                        }
                        
                    }
                    else if (GameEntry.GlobalData.serverType == (int)ServerType.DRAGON_BATTLE_FIGHT_SERVER || GameEntry.GlobalData.serverType == (int)ServerType.CROSS_THRONE)
                    {
                        color = GameDefines.CityLabelTextColor.Red;
                    }
                    else
                    {
                        if (info.allianceId.IsNullOrEmpty() == false)
                        {
                        
                            string fightAllianceId = GameEntry.Data.Player.GetFightAllianceId();
                            if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == info.allianceId)
                            {
                                color = GameDefines.CityLabelTextColor.Red;
                            }
                            else
                            {
                                if (isCrossServer ||GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true)
                                {
                                    color = GameDefines.CityLabelTextColor.Red;
                                }
                                else
                                {
                                    color = GameDefines.CityLabelTextColor.White;
                                }
                            
                            }
                        }
                        else
                        {
                            if (isCrossServer || GameEntry.Data.Player.GetIsInAttackDic(info.ownerUid)==true ||GameEntry.Data.Player.GetIsInFightServerList(info.srcServerId) == true)
                            {
                                color = GameDefines.CityLabelTextColor.Red;
                            }
                            else
                            {
                                color = GameDefines.CityLabelTextColor.White;
                            }
                        }
                    }
                    
                    
                    break;
                }
            }
            Array.ForEach(cityLabels, label =>
            {
                label.gameObject.SetActive(true);
                label.SetNameBgSkin(info.titleNameSkinId);
                label.SetName(sb.ToString(), color);
                if (info.itemId == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
                {
                    label.SetLevel(info.level);
                    if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                    {
                        var allianceId = info.allianceId;
                        if (allianceId.IsNullOrEmpty() == false)
                        {
                            var camp = GameEntry.Data.Player.GetAllianceCampByAllianceId(allianceId);
                            if (camp > 0)
                            {
                                label.SetCamp(camp);
                            }
                        }
                    }
                    
                }
                else
                {
                    label.SetLevel(info.level,color);
                }
                
            });
        }
    }

    public void DoGuideStartShow(int time)
    {
        gameObject.SetActive(true);
        if (_grow != null)
        {
            var startTime = GameEntry.Timer.GetServerTimeSeconds();
            _grow.enabled = true;
            _grow.StartBuild(_param.buildUuid, build_Id, startTime, startTime + time, tiles,
                GameEntry.Data.Player.GetUid(), false, false);
            ShowShadow(false);
            ShowEffect(false);
            ShowGlass(true);
            GameEntry.Timer.RegisterTimer(time, () =>
            {
                if (this != null && _param != null)
                {
                    if (_grow.isWorking)
                    {
                        _grow.EndAnim();
                    }
                    _grow.enabled = false;
                    _grow.ShowNormal();
                    ShowShadow(true);
                    ShowGlass(false);
                    DoBuildPlaceAnim();
                }
            });
        }
    }

    protected virtual bool IsSelfControlWorkAnim()
    {
        return false;
    }

    private void SetBuildShowState(BuildShowState state)
    {
        if (adjuster != null && !adjuster.IsMainShow())
        {
            return;
        }
        
        if (state == BuildShowState.Normal)
        {
            if (_normalObj!=null &&_normalObj.activeSelf == false)
            {
                _normalObj.SetActive(true);
            }
        }
        else if (state == BuildShowState.Box)
        {
            if (_normalObj!=null &&_normalObj.activeSelf == true)
            {
                _normalObj.SetActive(false);
            }
            ShowEffect(false);
             //RemoveRobot();
        }
    }

    public void ChangeToBox()
    {
        if (_normalObj!=null &&_normalObj.activeSelf == true)
        {
            _normalObj.SetActive(false);
        }
        ShowEffect(false);
        //RemoveRobot();
    }
    public virtual void OnBattleAtkUpdate(long targetUuid)
    {
    }

    public virtual void OnBattleAtkEnd()
    {
    }

    // 是否覆盖了某个位置
    public bool ContainsPos(Vector2Int pos)
    {
        Vector2Int topRight = tilePos;
        Vector2Int bottomLeft = topRight - Vector2Int.one * (tiles - 1);

        return pos.x >= bottomLeft.x && pos.x <= topRight.x &&
               pos.y >= bottomLeft.y && pos.y <= topRight.y;
    }
    
    private void UpdateBuildDataSignal(object userData)
    {
        long uuid = (long)userData;
        if (_param != null && uuid == _param.buildUuid)
        {
            refeshDate();
        }
    }

    private bool _glassVisible = true;
    public void ProfileToggleGlass()
    {
        _glassVisible = !_glassVisible;
        if (_baseGlass)
        {
            _baseGlass.SetLayerRecursively(LayerMask.NameToLayer(_glassVisible ? "Default" : "Hide"));     
        }
    }

    public void SetMoveState(bool isHide)
    {
        gameObject.SetActive(isHide==false);
    }
    
    private void ShowFoldUpEffect()
    {
        if (_foldUpInstanceRequest == null)
        {
            _foldUpInstanceRequest = GameEntry.Resource.InstantiateAsync(FoldUpEffectPath);
            _foldUpInstanceRequest.completed += delegate
            {
                if (_foldUpInstanceRequest.gameObject == null)
                {
                    return;
                }
                var go = _foldUpInstanceRequest.gameObject;
                if (go != null)
                {
                    go.transform.SetParent(_modelGo);
                    go.transform.localPosition = Vector3.zero;
                    go.transform.localScale = Vector3.one;
                }
            };
        }
    }
    
    private void DestroyFoldUpEffect()
    {
        if (_foldUpInstanceRequest != null)
        {
            _foldUpInstanceRequest.Destroy();
            _foldUpInstanceRequest = null;
        }
    }

}

