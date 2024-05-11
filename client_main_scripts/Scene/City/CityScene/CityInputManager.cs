
using System.Collections.Generic;
using BitBenderGames;
using UnityEngine;
using UnityEngine.EventSystems;
using XLua;

//
// 处理世界输入
//   世界行军、怪、资源、世界建筑等的点击
//
public class CityInputManager : CityManagerBase
{
    //点击: OnFingerDown -> OnLongTapProgress -> OnInputClick -> OnFingerUp
    //拖拽: OnFingerDown -> OnLongTapProgress -> OnDragStart -> OnDragUpdate -> OnDragStop -> OnFingerUp

    private static readonly float m_LoadDelay = 0.15f;
    
    private TouchInputController touchInput;
    private bool isLongTabStart;
    private bool isLongTabEnd;
    private bool isFingerDownUIObject;
    public long marchUuid;

    private List<ITouchObject> touchObjects = new List<ITouchObject>();
    private ITouchObject touchEnterObj;
    private ITouchObject touchPress;
    private ITouchObject touchDrag;
    private ITouchObject touchLongTab;
    // 这地方其实这么写不好，等有时间再处理吧。
    private LuaTable joyStickPara;
    
    //当前点击的坐标
    public int curIndex
    {
        get;
        set;
    }

    private bool _isShowLoad;//是否正在展示，防止发多遍关闭事件，load专用

    //拖动 移动建筑 建造拖动使用
    private bool _isClickSelectedPickable;//是否点击了目标ITouchPickable
    private ITouchPickable selectedPickable;//目标ITouchPickable-建筑模型
    public List<int> touchPickablePos;//目标点的位置坐标
    //结束

    private InstanceRequest touchEffectReq;
    private bool touchEffectVisible;
    private GameObject touchEffect;
    
    //炮台攻击范围特效
    public GameObject AttackRangeEffect;
    private InstanceRequest AttackRangeEffectReq;
    private bool AttackRangeEffectVisible;

    private bool _isCanTouch = true;
    
    private InstanceRequest QuanEffectRangeReq;
    private bool QuanEffectRangeVisible;
    private SimpleAnimation BlankAnimator;
    private int _curDragIndex;

    public CityInputManager(CityScene scene)
        : base(scene)
    {
        touchPickablePos = new List<int>();
        _isCanTouch = true;
        QuanEffectRangeVisible = false;
        touchInput = new TouchInputController();
    }

    public override void Init()
    {
        isLongTabStart = false;
        isLongTabEnd = false;
        isFingerDownUIObject = false;
        _curDragIndex = 0;

        touchInput = new TouchInputController();
        touchInput.OnFingerDown += OnFingerDown;
        touchInput.OnFingerUp += OnFingerUp;
        touchInput.OnDragStart += OnDragStart;
        touchInput.OnDragUpdate += OnDragUpdate;
        touchInput.OnDragStop += OnDragStop;
        touchInput.OnInputClick += OnInputClick;
        touchInput.OnLongTapProgress += OnLongTapProgress;
    }
    
    public override void UnInit()
    {
        base.UnInit();
        
        touchInput.OnFingerDown -= OnFingerDown;
        touchInput.OnFingerUp -= OnFingerUp;
        touchInput.OnDragStart -= OnDragStart;
        touchInput.OnDragUpdate -= OnDragUpdate;
        touchInput.OnDragStop -= OnDragStop;
        touchInput.OnInputClick -= OnInputClick;
        touchInput.OnLongTapProgress -= OnLongTapProgress;
        
        if (QuanEffectRangeReq != null)
        {
            QuanEffectRangeReq.Destroy();
            QuanEffectRangeReq = null;
            BlankAnimator = null;
        }

        if (touchEffectReq != null)
        {
            touchEffectReq.Destroy();
            touchEffectReq = null;
        }
    }

    public void SetTouchInputControllerEnable(bool able)
    {
        touchInput.enabled = able;
    }
    
    public bool GetTouchInputControllerEnable()
    {
        return touchInput.enabled;
    }
    
    
    
    //当按下之后生成出来时调用
    public void SetSelectedPickable(ITouchPickable pickable)
    {
        _isClickSelectedPickable = true;
        selectedPickable =  pickable;
    }
    
    public ITouchPickable SelectBuild
    {
        get => selectedPickable;
        set => selectedPickable = value;
    }

    private void OnLongTapProgress(float progress)
    {
        if (isFingerDownUIObject)
        {
            return;
        }

        if (progress >= 1.0f && !isLongTabEnd)
        {
         
            isLongTabEnd = true;
            OnLongTabEnd();
        }
        else if (progress > m_LoadDelay && !isLongTabStart)
        {
            isLongTabStart = true;
            OnLongTapStart();
        }
    }

    private void OnLongTapStart()
    {
        if (!CanUseInput())
        {
            return;
        }
        if (GameEntry.Lua.UIManager.IsWindowOpen("UIWorldBlackTile"))
        {
            GameEntry.Lua.UIManager.DestroyWindow("UIWorldBlackTile");
        }
        
        var info = SceneManager.World.GetPointInfo(curIndex);
        if (TouchObjectEvent.ExecuteBeginLongTab(touchLongTab))
        {
            
        }
        else if(SceneManager.World.IsTileWalkable( SceneManager.World.IndexToTilePos(curIndex)))
        {
            // ShowBlankTitleEffect(curIndex);
            GameEntry.Event.Fire(EventId.OnInputLongTapStart, curIndex);
        }
    }

    private void OnLongTabEnd()
    {
        if (!CanUseInput())
        {
            return;
        }

        HideLoad();
        
        TouchObjectEvent.ExecuteEndLongTab(touchLongTab);
        GameEntry.Event.Fire(EventId.OnInputLongTapEnd, curIndex);
    }
    
    private void ClickWorld()
    {
        if (touchPress != null)
        {
            GameEntry.Lua.Call("UIUtil.OnClickCity",  SceneManager.World.TilePosToIndex(touchPress.TilePos),(int)ClickWorldType.Collider);
        }
        else
        {
            GameEntry.Lua.Call("UIUtil.OnClickCity", curIndex,(int)ClickWorldType.Ground);
        }
        
        //这里建筑和怪在一起 点击先点怪
        var tilepos =  SceneManager.World.IndexToTilePos(curIndex);
        
        // GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Sfx_world_click_space);
        // ShowTouchEffect(tilepos);
    }
    


    private void OnInputClick(Vector3 clickPosition, bool isDoubleClick, bool isLongTap)
    {
        if (isLongTap)
        {
            return;
        }
        if (isFingerDownUIObject)
        {
            return;
        }
        var pos = SceneManager.World.GetTouchPoint();
        selectedPickable?.Drag(pos);
        int index = SceneManager.World.WorldToTileIndex(pos);
        GameEntry.Event.Fire(EventId.OnWorldInputPointClick,index);
        if (!CanUseInput())
        {
            return;
        }

        if (isDoubleClick)
        {
            TouchObjectEvent.ExecuteDoubleClick(touchPress);
        }
        else
        {
            // if (SceneManager.World.GetLodLevel() >= 3)
            // {
            //     var tilepos = SceneManager.World.GetTouchTilePos();
            //     SceneManager.World.AutoLookat( SceneManager.World.TileToWorld(tilepos), SceneManager.World.InitZoom);
            //     return;
            // }

            if (touchPress == null || !TouchObjectEvent.ExecuteClick(touchPress))
            {
                ClickWorld();
            }
        }
    }


    public void ShowBlankTitleEffect(int pointIndex)
    {
        QuanEffectRangeVisible = true;
        if (QuanEffectRangeReq == null)
        {
            QuanEffectRangeReq = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.QuanEffectRange);
            QuanEffectRangeReq.completed += delegate
            {
                var quanEffectRange = QuanEffectRangeReq.gameObject;
                quanEffectRange.transform.SetParent(SceneManager.World.DynamicObjNode);
                quanEffectRange.transform.position =  SceneManager.World.TileIndexToWorld(pointIndex);
                BlankAnimator = quanEffectRange.transform.GetComponent<SimpleAnimation>();
                if (QuanEffectRangeVisible)
                {
                    quanEffectRange.SetActive(true);
                    BlankAnimator.Play("V_zdbx_quan");
                }
                else
                {
                    quanEffectRange.SetActive(false);
                }
            };
        }
        else if (BlankAnimator != null)
        {
            BlankAnimator.gameObject.SetActive(true);
            BlankAnimator.transform.position =  SceneManager.World.TileIndexToWorld(pointIndex);
            BlankAnimator.Play("V_zdbx_quan");
        }
    }

    public void HideBlankTitleEffect()
    {
        QuanEffectRangeVisible = false;
        if (BlankAnimator != null)
        {
            BlankAnimator.gameObject.SetActive(false);
        }
    }

    private void OnFingerDown(Vector3 pos)
    {
        HideBlankTitleEffect();

        isFingerDownUIObject = GetIsPointerOverUIObject();
        isLongTabStart = false;
        isLongTabEnd = false;
        if (!isFingerDownUIObject)
        {
            touchPress = TouchObjectEvent.GetFirstEventObject<ITouchObjectPointerDownHandler>(touchObjects);
            TouchObjectEvent.ExecutePointerDown(touchPress);
            if (touchPress == null)
            {
                touchPress = TouchObjectEvent.GetFirstEventObject<ITouchObjectClickHandler>(touchObjects);
            }
            touchDrag = TouchObjectEvent.GetFirstEventObject<ITouchObjectBeginDragHandler>(touchObjects);
            touchLongTab = TouchObjectEvent.GetFirstEventObject<ITouchObjectBeginLongTabHandler>(touchObjects);
        }
        
        var tilepos = SceneManager.World.GetTouchTilePos();
        curIndex =  SceneManager.World.TilePosToIndex(tilepos);
        _curDragIndex = curIndex;
        if (selectedPickable != null)
        {
            _isClickSelectedPickable = touchPickablePos.Contains(curIndex);
            SceneManager.World.CanMoving = !_isClickSelectedPickable;
        }
        if (!isFingerDownUIObject)
        {
            scene.TrackMarch(0);
        }
        GameEntry.Event.Fire(EventId.OnWorldInputPointDown,curIndex);
    }

    private void RaycastTouchObject(Vector3 screenPos)
    {
        touchObjects.Clear();
        var ray = SceneManager.World.ScreenPointToRay(screenPos);
        var hits = Physics.RaycastAll(ray, float.PositiveInfinity, LayerMask.GetMask("Default", "WorldArmy"));
        for (int i = 0; i < hits.Length; i++)
        {
            var touchObj = hits[i].collider.GetComponentInParent<ITouchObject>();
            if (touchObj != null)
            {
                touchObjects.Add(touchObj);
            }
        }

        if (touchObjects.Count > 0)
        {
            touchObjects.Sort((a, b) => b.Priority.CompareTo(a.Priority));
        }
    }

    private void OnFingerUp()
    {
        _isClickSelectedPickable = false;
        isFingerDownUIObject = false;
        if (isLongTabEnd)
        {
            if (BlankAnimator != null && QuanEffectRangeVisible)
            {
                BlankAnimator.Play("V_zdbx_targetImg");
                BlankAnimator.PlayQueued("V_zdbx_quan_rotation");
                if(SceneManager.World.IsTileWalkable( SceneManager.World.IndexToTilePos(curIndex)))
                {
                    //空地显示UI
                    GameEntry.Lua.UIManager.OpenWindow("UIWorldBlackTile", curIndex.ToString());
                }
            }
        }
        else
        {
            HideBlankTitleEffect();
        }
        isLongTabStart = false;
        isLongTabEnd = false;
        SceneManager.World.CanMoving = true;
        curIndex = -1;
        marchUuid = 0;
        _curDragIndex = -1;
        TouchObjectEvent.ExecutePointerUp(touchPress);
        touchPress = null;
        touchDrag = null;
        touchLongTab = null;
        touchObjects.Clear();
        HideLoad(); 
        GameEntry.Event.Fire(EventId.OnWorldInputPointUp);
        if (GameEntry.Lua.UIManager.IsWindowOpen("UIJoystick"))
        {
            SceneManager.World.CanMoving = true;
            GameEntry.Lua.UIManager.DestroyWindow("UIJoystick", joyStickPara);
        }
    }

    private void OnDragStart(Vector3 dragStartpos, bool isLongTap)
    {
        HideLoad();
        HideBlankTitleEffect();
        HideTouchEffect();
        if (!isFingerDownUIObject)
        {
            GameEntry.Lua.Call("UIUtil.DragWorldCloseWorldUI");
            TouchObjectEvent.ExecuteBeginDrag(touchDrag, dragStartpos);
        }
        GameEntry.Event.Fire(EventId.OnWorldInputDragBegin);
    }

    private void OnDragUpdate(Vector3 dragPosStart, Vector3 dragPosCurrent, Vector3 correctionOffset)
    {
        if (selectedPickable != null)
        {
            if (_isClickSelectedPickable)
            {
                var pos = SceneManager.World.GetTouchPoint();
                selectedPickable.Drag(selectedPickable.GetClosestPoint(pos));
            }
        }
        else if (marchUuid != 0)
        {
            SceneManager.World.OnTroopDragUpdate(marchUuid, dragPosCurrent, GetRaycastHitMarch(dragPosCurrent));
        }
        
        TouchObjectEvent.ExecuteDrag(touchDrag, dragPosStart, dragPosCurrent);
        var index = SceneManager.World.WorldToTileIndex(SceneManager.World.GetTouchPoint());
        if (_curDragIndex != index)
        {
            _curDragIndex = index;
            GameEntry.Event.Fire(EventId.OnWorldInputPointDrag, index);
        }
    }

    private void OnDragStop(Vector3 dragStopPos, Vector3 dragFinalMomentum)
    {
        if (marchUuid != 0 )
        {
            SceneManager.World.OnTroopDragStop(marchUuid, GetRaycastHitMarch(dragStopPos));
        }
        GameEntry.Event.Fire(EventId.OnWorldInputDragEnd);
        if (!isFingerDownUIObject)
        {
            TouchObjectEvent.ExecuteEndDrag(touchDrag, dragStopPos);
        }
    }

    
    public long GetRaycastHitMarch(Vector3 screenPos)
    {
        var ray = SceneManager.World.ScreenPointToRay(screenPos);
        RaycastHit hitInfo;
        if (Physics.Raycast(ray, out hitInfo, float.PositiveInfinity, LayerMask.GetMask("WorldArmy")))
        {
            var obj = hitInfo.transform.gameObject;
            if (hitInfo.transform.gameObject.name.Contains("Model"))
            {
                obj = hitInfo.transform.parent.gameObject;
            }
            var objIds = obj.name.Split('_');
            if (objIds.Length > 1 && objIds[0] == "March")
            {
                return long.Parse(objIds[1]);
            }
        }

        return 0;
    }

    private int GetRaycastHitGarbagePoint(Vector3 screenPos)
    {
        var ray = SceneManager.World.ScreenPointToRay(screenPos);
        RaycastHit hitInfo;
        if (Physics.Raycast(ray, out hitInfo, float.PositiveInfinity, LayerMask.GetMask("WorldArmy")))
        {
            var obj = hitInfo.transform.gameObject;
            if (hitInfo.transform.gameObject.name.Contains("Model"))
            {
                obj = hitInfo.transform.parent.gameObject;
            }

            var objIds = obj.name.Split('_');
            if (objIds.Length > 1 && objIds[0] == "Garbage")
            {
                return int.Parse(objIds[1]);
            }
        }

        return -1;

    }

    private bool GetIsPointerOverUIObject()
    {
        if (TouchWrapper.TouchCount > 0)
        {
            foreach (var t in TouchWrapper.Touches)
            {
                if (EventSystem.current.IsPointerOverGameObject(t.FingerId))
                {
                    //这里面要处理LFTouchThrough的特殊情况
                    var input = EventSystem.current.currentSelectedGameObject;
                    if (input != null)
                    {
                        var through = input.GetComponent<LFTouchThrough>();
                        if (through != null)
                        {
                            //这里必须再处理，下一个是否点到UI
                            PointerEventData eventData = new PointerEventData(EventSystem.current);
#if UNITY_EDITOR || UNITY_STANDALONE
                            eventData.pressPosition = Input.mousePosition;
                            eventData.position = Input.mousePosition;
#endif
#if UNITY_ANDROID || UNITY_IPHONE
                            if (Input.touchCount > 0)
                            {
                                eventData.pressPosition = Input.GetTouch(0).position;
                                eventData.position = Input.GetTouch(0).position;
                            }
#endif
                            List<RaycastResult> list = new List<RaycastResult>();
                            EventSystem.current.RaycastAll(eventData, list);
                            foreach (var result in list)
                            {
                                if (result.gameObject == input)
                                {
                                    continue;
                                }

                                return true;
                            }

                            return false;
                        }
                    }
                   
                    return true;
                }
            }
        }

        return false;
    }
    

    public int GetClickWorldBulidingPos()
    {
        //var building = world.BuildingManager.GetWorldBuildingByPoint(curIndex);
        //if (building == null)
        //{
        //    return curIndex;
        //}
        //else
        //{
        //    return building.PointID;
        //}
        return curIndex;
    }

    //展示旋转的圆圈
    public void ShowLoad(Vector3 pos)
    {
        var x = pos.x;
        var y = pos.y;
        var z = pos.z;
        var str = x + ";" + y + ";" + z;
        _isShowLoad = true;
    }
    
    //删除旋转的圆圈
    public void HideLoad()
    {
        if (_isShowLoad)
        {
            _isShowLoad = false;
        }
    }
    
    //这个函数暂时先放这里，气泡的UI也会用到，当打开某一界面时点击事件不可用（修路，建造）
    public bool CanUseInput()
    {
        return _isCanTouch;
    }

    public void SetUseInput(bool canUse)
    {
        _isCanTouch = canUse;
    }
    public void ShowTouchEffect(Vector2Int tilePos)
    {
        touchEffectVisible = true;
        if (touchEffectReq == null)
        {
            touchEffectReq = GameEntry.Resource.InstantiateAsync(GameDefines.EntityAssets.TouchTerrainEffect);
            touchEffectReq.completed += delegate
            {
                touchEffect = touchEffectReq.gameObject;
                if (touchEffectVisible)
                {
                    touchEffect.SetActive(true);
                    touchEffect.transform.position =  SceneManager.World.TileToWorld(tilePos);
                }
                else
                {
                    touchEffect.SetActive(false);
                }
            };
        }
        else if (touchEffect != null)
        {
            touchEffect.SetActive(true);
            touchEffect.transform.position =  SceneManager.World.TileToWorld(tilePos);
        }
    }

    public void HideTouchEffect()
    {
        touchEffectVisible = false;
        if (touchEffect != null)
        {
            touchEffect.SetActive(false);
        }
    }

    public override void OnUpdate(float deltaTime)
    {
        if (TouchWrapper.TouchCount > 0)
        {
            RaycastTouchObject(TouchWrapper.Touch0.Position);
        }

        if (touchInput.enabled)
        {
            touchInput.OnUpdate();
        }
        ProessTouchEnterAndExit();

        if (TouchWrapper.TouchCount == 0 && touchObjects.Count > 0)
        {
            touchObjects.Clear();
        }
        
        
        // #if UNITY_EDITOR
        // KeyboardDebugUtil.OnUpdate();
        // #endif
    }

    private void ProessTouchEnterAndExit()
    {
        ITouchObject newEnterObj = null;
        if (touchObjects.Count > 0)
        {
            newEnterObj = touchObjects[0];
        }

        if (newEnterObj == null)
        {
            if (touchEnterObj != null && touchEnterObj is ITouchObjectPointerExitHandler)
            {
                ((ITouchObjectPointerExitHandler) touchEnterObj).OnPointerExit();
            }

            touchEnterObj = null;
            return;
        }
        if (newEnterObj == touchEnterObj)
            return;

        touchEnterObj = newEnterObj;
        if (touchEnterObj is ITouchObjectPointerEnterHandler)
        {
            ((ITouchObjectPointerEnterHandler) touchEnterObj).OnPointerEnter();
        }
    }
}
