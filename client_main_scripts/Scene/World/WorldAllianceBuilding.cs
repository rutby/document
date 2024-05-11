using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using XLua;
using Protobuf;
using UnityEngine.UI;

public class WorldAllianceBuilding: MonoBehaviour, ITouchPickable,
    ITouchObjectClickHandler
{

    public enum AllianceBuildSceneType
    {
        World = 1,
        Fake = 2,
    }

    public class Param
    {
        public int buildId;
        public long buildUuid;
        public int point;
        public PlaceBuildType BuildTopType;
        public LuaTable noPutPoint;
        public AllianceBuildSceneType buildSceneType;
    }
    
    

    public static float ScreenRangeLeft = 0.0f;
    public static float ScreenRangeRight = 0.0f;
    public static float ScreenRangeTop = 0.0f;
    public static float ScreenRangeDown = 0.0f;

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

    public PointInfo GetBuildInfo()
    {
        if (SceneManager.World != null)
        {
            return SceneManager.World.GetPointInfoByUuid(Uuid);
        }

        return null;
    }

    public int build_Id;
    public int tiles;
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
    private int _offset_range;
    private int _state;

    protected internal virtual void CSInit(object userData)
    {
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
                case AllianceBuildSceneType.World:
                {
                    buildId = _param.buildId;
                }
                   break;
                case AllianceBuildSceneType.Fake:
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
            
            tiles = GameEntry.ConfigCache.GetTemplateData("alliance_res_build",build_Id,"res_size").ToInt();//GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.Building, build_Id,"tiles").ToInt();
            refeshDate();
            if (_foldUpGo != null)
            {
                _foldUpGo.SetActive(false);
            }
            if (_param.buildSceneType == AllianceBuildSceneType.Fake)
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
        }
        else
        {
            gameObject.SetActive(false);
        }

    }

    protected internal virtual void CSUninit()
    {
        Uuid = -1;
        tilePos = Vector2Int.zero;
        _param = null;
        _animName = null;
        _focusEventTrigger = null;

        _grow = null;
        cityLabels = null;
    }
    
    
    
    

    public virtual void refeshDate()
    {
        if (_param != null)
        {
            int pointId = 0;
            switch (_param.buildSceneType)
            {
                case AllianceBuildSceneType.World:
                {
                    _level = GameEntry.ConfigCache.GetTemplateData("alliance_res_build",build_Id,"level").ToInt();
                }
                    break;
                case AllianceBuildSceneType.Fake:
                {
                    pointId = _param.point;
                    _level = 0;
                }
                    break;
            }
            _offset_range = 0;
            _param.point = pointId;
            if (pointId != 0)
            {
                SetTilePos1(SceneManager.World.IndexToTilePos(pointId), SceneManager.World.TileIndexToWorld(pointId));
            }
            InitBuildingGrow();
        }
    }
    
    public void UpdateCityLabel(long obj)
    {
        long uuid = obj;
        if (Uuid != uuid)
        {
            return;
        }

        var abbr = "";
        var info = SceneManager.World.GetPointInfoByUuid(uuid);
        if (info!=null)
        {
            var extraData =  AllianceBuildingPointInfo.Parser.ParseFrom(info.extraInfo);
            if (extraData != null)
            {
                StringBuilder sb = new StringBuilder();
                var isCrossServer = false;
                if (info.srcServerId != GameEntry.Data.Player.GetSelfServerId())
                {
                    sb.Append($"#{info.srcServerId} ");
                    isCrossServer = true;
                }
                if (!string.IsNullOrEmpty(extraData.AlAbbr))
                {
                    sb.Append($"[{extraData.AlAbbr}]");
                    abbr = extraData.AlAbbr;
                }
                var pointName = GameEntry.ConfigCache.GetTemplateData("alliance_res_build", build_Id, "name");
                sb.Append(GameEntry.Localization.GetString(pointName));
                int sid = GameEntry.Data.Player.GetSelfServerId();
                Color32 color;
                switch (info.GetPlayerType())
                {
                    case PlayerType.PlayerAlliance:
                    {
                        color = GameDefines.CityLabelTextColor.Blue;
                        break;
                    }
                    default:
                    {
                        if (GameEntry.GlobalData.serverType == (int)ServerType.EDEN_SERVER)
                        {
                            if (GameEntry.Data.Player.IsAllianceSelfCamp(extraData.AllianceId))
                            {
                                color = GameDefines.CityLabelTextColor.Yellow;
                            }
                            else
                            {
                                color = GameDefines.CityLabelTextColor.Red;
                            }
                            
                        }
                        else
                        {
                            if (extraData.AllianceId.IsNullOrEmpty() == false)
                            {
                                string fightAllianceId =GameEntry.Data.Player.GetFightAllianceId();
                                if (fightAllianceId.IsNullOrEmpty()==false && fightAllianceId == extraData.AllianceId)
                                {
                                    color = GameDefines.CityLabelTextColor.Red;
                                }
                                else
                                {
                                    if (isCrossServer)
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
                                if (isCrossServer)
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
                    label.SetNameBgSkin();
                    label.SetName(sb.ToString(), color);
                    label.SetLevel(_level,color);
                });
            }

        }
        var arrowObj = transform.Find("Icon/Arrow")?.gameObject;
        if (arrowObj != null)
        {
            if (abbr.IsNullOrEmpty())
            {
                arrowObj.SetActive(false);
            }
            else
            {
                var nameTxt = arrowObj.transform.Find("nameObj/nameBg/name")?.GetComponent<NewText>();
                if (nameTxt != null)
                {
                    nameTxt.text = abbr;
                    arrowObj.SetActive(true);
                }
                else
                {
                    arrowObj.SetActive(false);
                }
            }
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
                "CSharpCallLuaInterface.GetAllianceBuildTileIndex", build_Id,
                SceneManager.World.TilePosToIndex(tilePos));
            GameEntry.Event.Fire(EventId.UIPlaceAllianceBuildChangePos, SceneManager.World.TilePosToIndex(tilePos));
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
            point = _param.point;
            tempTopType = _param.BuildTopType;
            noPutPoint = _param.noPutPoint;
            SetTilePos1(SceneManager.World.IndexToTilePos(point), SceneManager.World.TileIndexToWorld(point));
            SetTouchPickAblePos();
            GameEntry.Lua.UIManager.OpenWindow("UIPlaceWorldBuild",build_Id,tempBuildUuid,point,(int)tempTopType);
        }

        if (_grow != null)
        {
            _grow.enabled = false;
            _grow.ShowBuildGridSelection();
            ShowShadow(false);
            var putState = GameEntry.Lua.CallWithReturn<int, int,int>("CSharpCallLuaInterface.IsCanPutDownByAllianceBuild",build_Id,point);
            _grow.ShowCanPlace(putState == (int)PutState.Ok);
            
        }
    }

    public void EnterMoveCityState(int moveCityType)
    {
        SceneManager.World.SetSelectedPickable(this);
        long tempBuildUuid = 0;
        int point = SceneManager.World.TilePosToIndex(GameEntry.Data.Building.GetMainPos());
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
            var putState = GameEntry.Lua.CallWithReturn<int, int,int>("CSharpCallLuaInterface.IsCanPutDownByAllianceBuild",build_Id,point);
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
                putState = (PutState)GameEntry.Lua.CallWithReturn<int, int,int>("CSharpCallLuaInterface.IsCanPutDownByAllianceBuild",build_Id,pointIndex);

                _grow.ShowCanPlace(putState == PutState.Ok);
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
            // case AllianceBuildSceneType.World:
            // {
            //     var info = GetBuildInfo();
            //     if (info != null)
            //     {
            //         playerType = info.GetPlayerType();
            //         ownerUid = info.ownerUid;
            //         if (info.destroyStartTime > 0)
            //         {
            //             startTime = info.startTime;
            //             endTime = info.endTime;
            //             state = QueueState.Ruins;
            //         }
            //         else if (info.endTime > 0)
            //         {
            //             startTime = info.startTime;
            //             endTime = info.endTime;
            //             state = QueueState.UPGRADE;
            //         }
            //         else
            //         {
            //             startTime = info.startTime;
            //             endTime = info.endTime;
            //             state = info.GetShowState();
            //             if (state == QueueState.UPGRADE)
            //             {
            //                 state = info.GetShowStateByIndex(1);
            //             }
            //         }
            //     }
            // }
                // break;
            case AllianceBuildSceneType.Fake:
            {
            }
                break;
        }
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
    
    
    
    

    float ITouchObject.Priority
    {
        get { return 1.0f; }
    }

    Vector2Int ITouchObject.TilePos
    {
        get
        {
            // if (_param.buildSceneType == BuildSceneType.World)
            // {
            //     var info = GetBuildInfo();
            //     return SceneManager.World.IndexToTilePos(info.pointIndex);
            // }

            return Vector2Int.zero;

        }
    }

    public bool OnClick()
    {
        if (SceneManager.IsInWorld())
        {
            var pointIndex = SceneManager.World.TilePosToIndex(tilePos);
            GameEntry.Lua.Call("UIUtil.OnClickWorld", pointIndex,(int)ClickWorldType.Collider);
        }

        return true;
    }
    
    public float GetHeight()
    {
        if (_grow != null)
        {
            return _grow.GetHeight();
        }

        return 0;
    }
    
    
    



    // 是否覆盖了某个位置
    public bool ContainsPos(Vector2Int pos)
    {
        Vector2Int topRight = tilePos;
        Vector2Int bottomLeft = topRight - Vector2Int.one * (tiles - 1);

        return pos.x >= bottomLeft.x && pos.x <= topRight.x &&
               pos.y >= bottomLeft.y && pos.y <= topRight.y;
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
}
