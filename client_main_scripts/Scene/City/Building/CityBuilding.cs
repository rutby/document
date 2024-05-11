using System.Collections.Generic;
using UnityEngine;
using XLua;

public class CityBuilding : MonoBehaviour, ITouchPickable,
    ITouchObjectClickHandler,
    ITouchObjectBeginLongTabHandler,
    ITouchObjectDoubleClickHandler,
    ITouchObjectEndLongTabHandler
{

    public enum BuildSceneType
    {
        City = 1,
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
        public bool noDoAnim;
        public bool visible;
        public bool canShowBuildMark;
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

    //建筑动画播放状态
    public enum AnimTimeState
    {
        Play, //正在播放
        Stop, //停止
    }
    public static float ScreenRangeLeft = 0.0f;
    public static float ScreenRangeRight = 0.0f;
    public static float ScreenRangeTop = 0.0f;
    public static float ScreenRangeDown = 0.0f;
    public static int MaxFurnitureCount = 20;
    public static int MaxWallCount = 4;
    public static int MaxSundryCount = 10;

    private AnimTimeState _curAnimState;
    private float _curTime;
    private float _allTime;

    [SerializeField] private GameObject _shadow; //建筑影子
    [SerializeField] private GameObject _effectGo; //建筑升级盒子
    [SerializeField] private GPUSkinningAnimator gpuAnim; //建筑动画
    [SerializeField] private SimpleAnimation simpleAnim;
    [SerializeField] private SimpleAnimation _effectAnim; //建筑特效动画
    [SerializeField] private GameObject _normalObj; //正常态
    [SerializeField] private GameObject _farObj; //远处显示的状态
    [SerializeField] private GameObject _nearObj; //近处显示的状态
    [SerializeField] private GameObject _fireObj;
    [SerializeField] private GameObject _nofireObj;
    [SerializeField] private GameObject _canCreateEffect;
    public long Uuid { get; set; }

    public BuildPointInfo GetBuildInfo()
    {
        return null;
    }

    public int build_Id;
    private Param _param;
    private string _animName;
    private string _ownerUuid;
    protected int _level;
    private Dictionary<AnimTimeState, float> _buildingLevelBuildActionTime;
    private int _state;
    private long _updateTime;
    private bool _canDoAnim = true;//引导不做动画
    private Dictionary<int, Transform> _furnitureDic = new Dictionary<int, Transform>();
    private Dictionary<string, Transform> _warDic = new Dictionary<string, Transform>();
    private Dictionary<string, GameObject> _sundryDic = new Dictionary<string, GameObject>();
    private float _minX;//边界屏幕x最小坐标
    private float _maxX;//边界屏幕x最大坐标
    private float _minY;//边界屏幕y最小坐标
    private float _maxY;//边界屏幕y最大坐标
    
    private void Awake()
    {
    }

    protected internal virtual void CSInit(object userData)
    {
        _buildingLevelBuildActionTime = new Dictionary<AnimTimeState, float>();
        build_Id = 0;
        _level = 0;
        _minX = ScreenRangeLeft;
        _maxX = Screen.width - ScreenRangeRight;
        _minY = ScreenRangeDown;
        _maxY = Screen.height - ScreenRangeTop;
        _param = userData as Param;
        if (_param != null)
        {
            SetCanDoAnim(!_param.noDoAnim);
            Uuid = _param.buildUuid;
            build_Id = _param.buildId;
            // scan = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.BuildingDes, build_Id,"scan").ToInt();
            var modelCenterPos =
                GameEntry.Lua.CallWithReturn<Vector3, int>("CSharpCallLuaInterface.GetBuildPositionByBuildId",
                    build_Id);
            transform.position = modelCenterPos;
            float rotationY = 0;
            string temp =
                GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.BuildingDes, build_Id, "rotation");
            if (!string.IsNullOrWhiteSpace(temp))
            {
                rotationY = temp.ToFloat();
            }
            transform.eulerAngles = new Vector3(0, rotationY, 0);
            refeshDate();
            if (_param.buildSceneType == BuildSceneType.Fake)
            {
                FromUILoad();
            }
            ChangeNearModel(!_param.canShowBuildMark);
            SetVisible(_param.visible);
        }
        else
        {
            SetVisible(false);
        }

    }

    protected internal virtual void CSUninit()
    {
        CancelAnimTimer();
        Uuid = -1;
        _param = null;
        _animName = null;
    }

    protected internal virtual void CSUpdate(float elapseSeconds)
    {
    }

    public virtual void refeshDate()
    {
        if (_param != null)
        {
            switch (_param.buildSceneType)
            {
                case BuildSceneType.City:
                {
                    if (_param.buildUuid == 0)
                    {
                        _level = 0;
                    }
                    else
                    {
                        var buildingData = GameEntry.Data.Building.GetBuildingDataByUuid(_param.buildUuid);
                        if (buildingData != null)
                        {
                            _level = buildingData.level;
                            _state = buildingData.state;
                            _updateTime = buildingData.buildUpdateTime;
                        }
                    }

                    if (_canCreateEffect != null)
                    {
                        var visible =
                            GameEntry.Lua.CallWithReturn<bool, int>(
                                "CSharpCallLuaInterface.CanShowCreateEffect", _param.buildId);
                        SetCreateEffectVisible(visible);
                    }
                }
                    break;
                case BuildSceneType.Fake:
                {
                    _level = 0;
                }
                    break;
            }
            _buildingLevelBuildActionTime.Clear();
            if (_level > 0)
            {
                var buildingLevelBuildAction = GameEntry.ConfigCache.GetTemplateData(GameDefines.TableName.BuildingDes, build_Id,"building_action");
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

            UpdateBuildState();
            RefreshFireState();
        }
    }

    private void UpdateBuildState()
    {
        if (_effectGo == null)
        {
            return;
        }
        var now = GameEntry.Timer.GetServerTime();
        if (_updateTime > 0 && _updateTime <= now)
        {
            if (_effectGo.activeSelf == false)
            {
                _effectGo.SetActive(true);
            }
            
            if (_normalObj.activeSelf == true)
            {
                _normalObj.SetActive(false);
            }
        }
        else
        {
            if (_effectGo.activeSelf == true)
            {
                _effectGo.SetActive(false);
            }
            
            if (_normalObj.activeSelf == false)
            {
                _normalObj.SetActive(true);
            }
        }
    }


    private void SetTouchPickAblePos()
    {
        if (SceneManager.World.SelectBuild == (ITouchPickable)this)
        {
            int index = SceneManager.World.WorldToTileIndex(transform.position);
            SceneManager.World.touchPickablePos = GameEntry.Lua.CallWithReturn<List<int>, int, int>(
                "CSharpCallLuaInterface.GetBuildTileIndex", build_Id,
                index);
            GameEntry.Event.Fire(EventId.UIPlaceBuildChangePos, index);
        }
    }


    void FromUILoad()
    {
        SceneManager.World.SetSelectedPickable(this);
        long tempBuildUuid = 0;
        int point = 0;
        PlaceBuildType tempTopType = PlaceBuildType.Build;
        if (_param != null)
        {
            tempBuildUuid = _param.buildUuid;
            point = _param.point;
            tempTopType = _param.BuildTopType;
            SetTouchPickAblePos();
            GameEntry.Lua.UIManager.OpenWindow("UIPlaceBuild",build_Id,tempBuildUuid,point,(int)tempTopType);
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
        // var tilePos = SceneManager.World.GetTouchTilePos();
        //
        // Vector2Int vecPos = new Vector2Int(TilePos.x, TilePos.y);
        // if (tilePos == vecPos)
        // {
        //     return true;
        // }
        //
        // int sz = tiles;
        // if (sz > 1)
        // {
        //     return GameEntry.Lua.CallWithReturn<bool,int,int,int,int,int>("CSharpCallLuaInterface.CheckIsInBuildRange",tilePos.x,tilePos.y,vecPos.x,vecPos.y, sz);
        // }

        return false;
    }

    public void Drag(Vector3 pos)
    {
        if (SceneManager.World.GetTouchInputControllerEnable())
        {
           
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

    void ITouchPickable.Click()
    {
    }

    //设置建筑特效显示/隐藏
    private void ShowEffect(bool isShow)
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

    public float PlayAnim(string animName)
    {
        float result = 0;
        if (!_canDoAnim)
        {
            return result;
        }
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
            {
                var aniState = simpleAnim.GetState(animName);
                if (aniState != null)
                {
                    simpleAnim.SetStateSpeed(_animName, 1);
                    result = UIUtils.PlayAnimationReturnTime(simpleAnim, animName);
                }
            }
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
            return Vector2Int.zero;

        }
    }

    public bool OnDoubleClick()
    {
        return OnClick();
    }

    public bool OnClick()
    {
        DoBuildClickAnim();
        GameEntry.Lua.Call("UIUtil.OnClickCity", _param.point,(int)ClickWorldType.Collider);
        return true;
    }

    public bool OnBeginLongTap()
    {
        return true;
    }

    public bool OnEndLongTap()
    {
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
            if (!string.IsNullOrEmpty(_animName))
            {
                simpleAnim.SetStateSpeed(_animName, 0);
            }
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
        return 0;
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
        }

        return false;
    }
    

    protected virtual bool IsSelfControlWorkAnim()
    {
        return false;
    }

    public void SetCanDoAnim(bool canDoAnim)
    {
        _canDoAnim = canDoAnim;
        if (simpleAnim != null)
        {
            if (canDoAnim)
            {
                if (_animName != null && !simpleAnim.isPlaying)
                {
                    PlayAnim(_animName);
                }
            }
            else
            {
                if (simpleAnim.isPlaying)
                {
                    simpleAnim.SetStateSpeed(_animName, 0);
                }
            }
        }
    }
    
    public void SetVisible(bool visible)
    {
        gameObject.SetActive(visible);
    }
    
    public void ChangeNearModel(bool enter)
    {
        if (enter)
        {
            if (_nearObj != null)
            {
                _nearObj.gameObject.SetActive(true);
            }
            if (_farObj != null)
            {
                _farObj.gameObject.SetActive(false);
            }
        }
        else
        {
            if (_nearObj != null)
            {
                _nearObj.gameObject.SetActive(false);
            }
            if (_farObj != null)
            {
                _farObj.gameObject.SetActive(true);
            }
        }
    }

    private void InitFurnitureList()
    {
        if (!_furnitureDic.ContainsKey(1))
        {
            _furnitureDic.Clear();
            Transform parentGo = null;
            Transform useGo = _normalObj.transform;
            for (int i = 1; i < MaxFurnitureCount; ++i) 
            {
                var go = GetChildByName(useGo, "furniture" + i);
                if (go == null)
                {
                    break;
                }
                else
                {
                    if (parentGo == null)
                    {
                        parentGo = go.parent;
                        useGo = parentGo;
                    }
                    _furnitureDic[i] = go;
                }
            }
        }
    }

    public static Transform GetChildByName(Transform tr, string str)
    {
        var result = tr.Find(str);
        if (result != null)
        {
            return result;
        }
        int childCount = tr.childCount;
        if (childCount > 0)
        {
            for (int i = 0; i < childCount; ++i)
            {
                var per = tr.GetChild(i);
                var go = GetChildByName(per, str);
                if (go != null)
                {
                    return go;
                }
            }
        }
       

        return null;
    }
    
    public Dictionary<int, Transform> GetFurnitureDic()
    {
        InitFurnitureList();
        return _furnitureDic;
    }

    public void RefreshFireState()
    {
        
        if (build_Id == GameDefines.BuildingTypes.FUN_BUILD_MAIN)
        {
            var isShowFire = GameEntry.Lua.CallWithReturn<bool>("CSharpCallLuaInterface.GetMainBuildFireIsOpen");
            if (isShowFire)
            {
                if (_fireObj != null && _fireObj.gameObject.activeSelf == false)
                {
                    _fireObj.gameObject.SetActive(true);
                }
                if (_nofireObj != null && _nofireObj.gameObject.activeSelf == true)
                {
                   _nofireObj.gameObject.SetActive(false);
                }
            }
            else
            {
                if (_fireObj != null && _fireObj.gameObject.activeSelf == true)
                {
                    _fireObj.gameObject.SetActive(false);
                }
                if (_nofireObj != null && _nofireObj.gameObject.activeSelf == false)
                {
                    _nofireObj.gameObject.SetActive(true);
                }
            }
        }
    }
    
    
    private void SetCreateEffectVisible(bool visible)
    {
        if (_canCreateEffect != null)
        {
            _canCreateEffect.SetActive(visible);
        }
    }
    
    public virtual void OnBattleAtkUpdate(long targetUuid)
    {
    }
    
    
    private void InitWallList()
    {
        if (_warDic.Count == 0)
        {
            Transform parentGo = null;
            Transform useGo = _normalObj.transform;
            string nameStr = "";
            for (int i = 1; i < MaxWallCount; ++i)
            {
                nameStr = "hide_wall" + i;
                var go = GetChildByName(useGo, nameStr);
                if (go == null)
                {
                    break;
                }
                else
                {
                    if (parentGo == null)
                    {
                        parentGo = go.parent;
                        useGo = parentGo;
                    }
                    _warDic[nameStr] = go;
                }
            }
        }
    }
    
    public Dictionary<string, Transform> GetWallDic()
    {
        InitWallList();
        return _warDic;
    }
  
    private void InitSundryList()
    {
        if (_sundryDic.Count == 0)
        {
            Transform parentGo = null;
            Transform useGo = _normalObj.transform;
            string nameStr = "";
            for (int i = 1; i < MaxSundryCount; ++i)
            {
                nameStr = "sundry" + i;
                var go = GetChildByName(useGo, nameStr);
                if (go == null)
                {
                    break;
                }
                else
                {
                    if (parentGo == null)
                    {
                        parentGo = go.parent;
                        useGo = parentGo;
                    }

                    _sundryDic[nameStr] = go.gameObject;
                }
            }
        }
    }
    
    public Dictionary<string, GameObject> GetSundryDic()
    {
        InitSundryList();
        return _sundryDic;
    }
}

