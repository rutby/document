using System.Collections.Generic;
using BitBenderGames;
using GameFramework;
using UnityEngine;
using UnityEngine.EventSystems;

//
// 处理世界输入
//   世界行军、怪、资源、世界建筑等的点击
//
public class WorldInputManager : WorldManagerBase
{
    //点击: OnFingerDown -> OnLongTapProgress -> OnInputClick -> OnFingerUp
    //拖拽: OnFingerDown -> OnLongTapProgress -> OnDragStart -> OnDragUpdate -> OnDragStop -> OnFingerUp

    private static readonly float m_LoadDelay = 0.15f;
    
    private TouchInputController touchInput;
    private bool isLongTabStart;
    private bool isLongTabEnd;
    private bool isFingerDownUIObject;
    public long marchUuid;
    public long formationUuid;
    public int formationPointId;
    private bool isInDrag = false;

    private List<ITouchObject> touchObjects = new List<ITouchObject>();
    private ITouchObject touchEnterObj;
    private ITouchObject touchPress;
    private ITouchObject touchDrag;
    private ITouchObject touchLongTab;
    
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
    
    private bool _isCanTouch = true;
    
    private InstanceRequest QuanEffectRangeReq;
    private bool QuanEffectRangeVisible;
    private SimpleAnimation BlankAnimator;

    private int lodCache;
    private int _curDragIndex;

    private static readonly int BlankTitleEffectMaxLod = 2;

    public WorldInputManager(WorldScene scene)
        : base(scene)
    {
        touchPickablePos = new List<int>();
        _isCanTouch = true;
        QuanEffectRangeVisible = false;
    }

    public override void Init()
    {
        isLongTabStart = false;
        isLongTabEnd = false;
        isFingerDownUIObject = false;
        isInDrag = false;
        formationUuid = 0;
        formationPointId = 0;
        _curDragIndex = 0;
        touchInput = world.Camera.TouchInputController;
        Log.Info("worldInputManager touch init");
        touchInput.OnFingerDown += OnFingerDown;
        touchInput.OnFingerUp += OnFingerUp;
        touchInput.OnDragStart += OnDragStart;
        touchInput.OnDragUpdate += OnDragUpdate;
        touchInput.OnDragStop += OnDragStop;
        touchInput.OnInputClick += OnInputClick;
        touchInput.OnLongTapProgress += OnLongTapProgress;
        touchInput.OnPinchStart += OnPinchStart;
        GameEntry.Event.Subscribe(EventId.ChangeCameraLod, OnUpdateLod);
        
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
        touchInput.OnPinchStart -= OnPinchStart;
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
        
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraLod, OnUpdateLod);
    }

    private void OnUpdateLod(object lodObj)
    {
        int lod = (int) lodObj;

        if (lodCache <= BlankTitleEffectMaxLod && lod > BlankTitleEffectMaxLod)
        {
            if (QuanEffectRangeVisible)
            {
                HideBlankTitleEffect();
            }
        }

        lodCache = lod;
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
        
        var info = world.GetPointInfo(curIndex);
        if (TouchObjectEvent.ExecuteBeginLongTab(touchLongTab))
        {
            
        }
        else if (world.IsTileWalkable(world.IndexToTilePos(curIndex)) && lodCache <= BlankTitleEffectMaxLod)
        {
            ShowBlankTitleEffect(curIndex);
        }
    }

    private void OnLongTabEnd()
    {
        if (!CanUseInput())
        {
            return;
        }

        HideLoad();
        if (BlankAnimator != null)
        {
            BlankAnimator.Play("V_zdbx_quan_xuanzhuan");
        }
       
        TouchObjectEvent.ExecuteEndLongTab(touchLongTab);
    }
    
    private void ClickWorld()
    {
        world.marchUuid = 0;
        if (touchPress != null)
        {
            GameEntry.Lua.Call("UIUtil.OnClickWorld", world.TilePosToIndex(touchPress.TilePos),(int)ClickWorldType.Collider);
        }
        else
        {
            //Log.Info("click point ground");
            GameEntry.Lua.Call("UIUtil.OnClickWorld", curIndex,(int)ClickWorldType.Ground);
        }
        
        //这里建筑和怪在一起 点击先点怪
        var tilepos = world.IndexToTilePos(curIndex);
        
        // GameEntry.Sound.PlayEffect(GameDefines.SoundAssets.Music_Sfx_world_click_space);
        ShowTouchEffect(tilepos);
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
                quanEffectRange.transform.SetParent(world.DynamicObjNode);
                quanEffectRange.transform.position = world.TileIndexToWorld(pointIndex);
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
            BlankAnimator.transform.position = world.TileIndexToWorld(pointIndex);
            BlankAnimator.Play("V_zdbx_quan");
        }
    }

    public void HideBlankTitleEffect()
    {
        QuanEffectRangeVisible = false;
        if (BlankAnimator != null)
        {
            BlankAnimator.Stop();
            BlankAnimator.gameObject.SetActive(false);
        }
    }

    private void OnFingerDown(Vector3 pos)
    {
        HideBlankTitleEffect();
        isFingerDownUIObject = GetIsPointerOverUIObject();
        isLongTabStart = false;
        isLongTabEnd = false;
        var tilepos = world.GetTouchTilePos();
        curIndex = world.TilePosToIndex(tilepos);
        _curDragIndex = curIndex;
        if (!isFingerDownUIObject)
        {
            touchPress = TouchObjectEvent.GetFirstEventObject<ITouchObjectPointerDownHandler>(touchObjects);
            var info = world.GetPointInfo(curIndex);
            var isSelfBuildAndNotTurret = false;
            if (info != null)
            {
                var buildInfo = info as BuildPointInfo;
                if (info.ownerUid != GameEntry.Data.Player.Uid)
                {
                    isSelfBuildAndNotTurret = true;
                }
                else if(buildInfo != null && buildInfo.itemId != GameDefines.BuildingTypes.FUN_BUILD_ARROW_TOWER)
                {
                    isSelfBuildAndNotTurret = true;
                }
            }
            if (info == null || isSelfBuildAndNotTurret )
            {
                var paotaiEffec =  SceneManager.World.BuildBubbleNode.Find("TurretAttackRangeEffect");
                if (paotaiEffec != null)
                {
                    paotaiEffec.gameObject.SetActive(false);
                }
            }
            TouchObjectEvent.ExecutePointerDown(touchPress);
            if (touchPress == null)
            {
                touchPress = TouchObjectEvent.GetFirstEventObject<ITouchObjectClickHandler>(touchObjects);
            }
            touchDrag = TouchObjectEvent.GetFirstEventObject<ITouchObjectBeginDragHandler>(touchObjects);
            touchLongTab = TouchObjectEvent.GetFirstEventObject<ITouchObjectBeginLongTabHandler>(touchObjects);
        }
        
        if (selectedPickable != null)
        {
            _isClickSelectedPickable = touchPickablePos.Contains(curIndex);
            world.CanMoving = !_isClickSelectedPickable;
        }
        else
        {
            if (!isFingerDownUIObject)
            {
                WorldScene.selectMarchUuid = GetRaycastHitMarch(pos);
                if (WorldScene.selectMarchUuid == 0 )
                {
                    var index = GetRaycastHitExploreAndSamplePoint(pos);
                    if (index > 0)
                    {
                        curIndex = index;
                    }
                }
            }
            
        }

        if (!isFingerDownUIObject)
        {
            world.TrackMarch(0);
        }
        GameEntry.Event.Fire(EventId.OnWorldInputPointDown,curIndex);
    }

    private void RaycastTouchObject(Vector3 screenPos)
    {
        touchObjects.Clear();
        var ray = world.ScreenPointToRay(screenPos);
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
                if (SceneManager.World.IsTileWalkable(world.IndexToTilePos(curIndex)) && lodCache <= BlankTitleEffectMaxLod)
                {
                    //空地显示UI
                    if (SceneManager.World.GetPointInfo(curIndex) == null)
                    {
                        GameEntry.Lua.UIManager.OpenWindow("UIWorldBlackTile", curIndex.ToString());
                    }
                    else
                    {
                        HideBlankTitleEffect();
                        GameEntry.Lua.Call("UIUtil.OnClickWorld", curIndex,(int)ClickWorldType.Collider);
                    }
                    
                }
            }
        }
        else
        {
            HideBlankTitleEffect();
        }
        // var march = world.GetMarch(marchUuid);
        // if (march != null)
        // {
        //     march.isSelect = false;
        // }
        isInDrag = false;
        isLongTabStart = false;
        isLongTabEnd = false;
        world.CanMoving = true;
        curIndex = -1;
        _curDragIndex = -1;
        WorldScene.selectMarchUuid = 0;
        formationUuid = 0;
        formationPointId = 0;
        TouchObjectEvent.ExecutePointerUp(touchPress);
        touchPress = null;
        touchDrag = null;
        touchLongTab = null;
        touchObjects.Clear();
        HideLoad(); 
        GameEntry.Event.Fire(EventId.OnWorldInputPointUp);
        //HideBatteryEffect();
    }

    public void SetDragFormationData(long uuid, int pointId)
    {
        formationUuid = uuid;
        formationPointId = pointId;
    }

    private void OnPinchStart(Vector3 pinchCenter, float pinchDistance)
    {
        if (isInDrag == true && (marchUuid != 0 || formationUuid != 0 || WorldScene.selectMarchUuid != 0))
        {
            marchUuid = 0;
            formationUuid = 0;
            WorldScene.selectMarchUuid = 0;
            world.OnTroopDragStop(marchUuid, 0);
            isInDrag = false;
        }
    }
    
    private void OnDragStart(Vector3 dragStartpos, bool isLongTap)
    {
        isInDrag = true;
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
        if (isInDrag == false)
        {
            return;
        }
        if (selectedPickable != null)
        {
            if (_isClickSelectedPickable)
            {
                var pos = world.GetTouchPoint();
                selectedPickable.Drag(selectedPickable.GetClosestPoint(pos));
            }
        }
        else if (marchUuid != 0 && WorldScene.selectMarchUuid!=0&& marchUuid == WorldScene.selectMarchUuid)
        {
            world.OnTroopDragUpdate(marchUuid, dragPosCurrent, GetRaycastHitMarch(dragPosCurrent));
            
        }
        else if (formationUuid != 0)
        {
            world.OnTroopDragUpdate(formationUuid, dragPosCurrent, GetRaycastHitMarch(dragPosCurrent),formationPointId,true);
        }

        if (!isFingerDownUIObject)
        {
            TouchObjectEvent.ExecuteDrag(touchDrag, dragPosStart, dragPosCurrent);
        }

        var index = SceneManager.World.WorldToTileIndex(SceneManager.World.GetTouchPoint());
        if (_curDragIndex != index)
        {
            _curDragIndex = index;
            GameEntry.Event.Fire(EventId.OnWorldInputPointDrag, index);
        }
    }

    private void OnDragStop(Vector3 dragStopPos, Vector3 dragFinalMomentum)
    {
        if (isInDrag == false)
        {
            return;
        }
        if (marchUuid != 0 && WorldScene.selectMarchUuid!=0 && marchUuid ==WorldScene.selectMarchUuid)
        {
            world.OnTroopDragStop(marchUuid, GetRaycastHitMarch(dragStopPos));
        }
        else if (formationUuid != 0)
        {
            world.OnTroopDragStop(formationUuid, GetRaycastHitMarch(dragStopPos),true);
        }
        
        GameEntry.Event.Fire(EventId.OnWorldInputDragEnd);
        if (!isFingerDownUIObject)
        {
            TouchObjectEvent.ExecuteEndDrag(touchDrag, dragStopPos);
        }
    }
    
    public long GetRaycastHitMarch(Vector3 screenPos)
    {
        var ray = world.ScreenPointToRay(screenPos);
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

    private int GetRaycastHitExploreAndSamplePoint(Vector3 screenPos)
    {
        var ray = world.ScreenPointToRay(screenPos);
        RaycastHit hitInfo;
        if (Physics.Raycast(ray, out hitInfo, float.PositiveInfinity, LayerMask.GetMask("WorldArmy")))
        {
            var obj = hitInfo.transform.gameObject;
            if (hitInfo.transform.gameObject.name.Contains("Model"))
            {
                obj = hitInfo.transform.parent.gameObject;
            }

            var objIds = obj.name.Split('_');
            if (objIds.Length > 1 && objIds[0] == "WorldPointObject")
            {
                return int.Parse(objIds[1]);
            }
        }

        return 0;

    }

    private bool GetIsPointerOverUIObject()
    {
        if (TouchWrapper.TouchCount > 0)
        {
            foreach (var t in TouchWrapper.Touches)
            {
                if (EventSystem.current.IsPointerOverGameObject(t.FingerId))
                {
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
                    touchEffect.transform.position = world.TileToWorld(tilePos);
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
            touchEffect.transform.position = world.TileToWorld(tilePos);
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
