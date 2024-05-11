using System;
using System.Collections.Generic;
using BitBenderGames;
using BitBenderGames.CameraState;
using Data.Csv;
using GameFramework;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using XLua;

public class FocusCurveStruct
{
    public InstanceRequest instanceRequest;
    public FocusCurve focusCurve;
}
public class WorldCamera : WorldManagerBase
{
    public const float MoveTime = 0.3f;
    public const float MainBuildingUpgradeZoom = 54.96f;
    public const float ShowBaseFireCameraZoom = 62.07f;
    public const float PointMoveDetal = 0.1f;
    public static LookAtFocusState[] NeedLoadFocusCurve = {};
    private MobileTouchCamera touchCamera;
    private TouchInputController touchInput;
    private Camera camera;
    private long trackMarchId;

    private Vector3 _lastTarget;

    private Vector3 _focusTarget;
    
    // 相机最高高度
    public static readonly float MAX_POS_Y = 4000f;
    
    // 相机拉到最高时的Y边距
    public static readonly int MAX_PADDING_Y = 100;
 
    private static Vector2 LodScaleKey0 = new Vector2(0, 1);
    private static Vector2 LodScaleKey1 = new Vector2(MAX_POS_Y, MAX_POS_Y * 0.1f);
    
    private int lastLod = 0;

    private static int[] lodArray;
    public static int[] LodArray
    {
        get
        {
            if (lodArray == null)
            {
                LuaTable lodTable = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetLodArray");
                List<int> lodList = new List<int>();
                for (int i = 0; i <= lodTable.Length; i++)
                {
                    lodList.Add(lodTable.Get<int>(i));
                }
                lodArray = lodList.ToArray();
            }
            
            return lodArray;
        }
    }
    
    public float InitZoom
    {
        get { return touchCamera.CamZoomInit; }
    }

    public float ZoomMin
    {
        get { return touchCamera.CamZoomMin; }
        set
        {
            if (touchCamera != null)
            {
                touchCamera.CamZoomMin = value;
            }
            
        }
    }

    public float ZoomMax
    {
        get { return touchCamera.CamZoomMax; }
        set
        {
            if (touchCamera != null)
            {
                touchCamera.CamZoomMax = value;
            }
            
        }
    }

    public Vector3 CurTarget
    {
        get { return GetCameraTargetPos(); }
    }
    
    public Vector2Int CurTilePos
    {
        get { return world.WorldToTile(GetCameraTargetPos()); }
    }

    public Vector2Int CurTilePosClamped
    {
        get { return world.ClampTilePos(CurTilePos); }
    }
    
    public float Zoom
    {
        get { return touchCamera.CamZoom; }
        set { touchCamera.CamZoom = value; }
    }
    
    public bool AutoMove
    {
        // TODO Z
        get { return true; }
        set {  }
    }
    
    public bool IsFocus
    {
        get { return false; }
        set {  }
    }

    public bool CanMoving
    {
        get
        {
            if (touchCamera != null)
            {
                return touchCamera.CanMoveing;
            }
            return false;
        }
        set
        {
            if (touchCamera != null)
            {
                touchCamera.CanMoveing = value;
            }
        }
    }

    public bool Enabled
    {
        get { return camera.gameObject.activeSelf; }
        set
        {
            camera.gameObject.SetActive(value);
        }
    }

    public TouchInputController TouchInputController
    {
        get { return touchInput; }
    }

    public event Action AfterUpdate;
    private Dictionary<LookAtFocusState, FocusCurveStruct> _saveCurve;

    public WorldCamera(WorldScene scene)
        : base(scene)
    {
        camera = UnityEngine.Camera.main;
        _saveCurve = new Dictionary<LookAtFocusState, FocusCurveStruct>();
    }

    public override void Init()
    {
        camera.fieldOfView = 10;
        camera.farClipPlane = 7000;
        touchCamera = camera.GetComponent<MobileTouchCamera>();
        touchCamera.ResetCamera();
        touchCamera.SetYRotation(0);
        touchInput = touchCamera.touchInput;
        SetTouchInputControllerEnable(false);
        touchCamera.AfterUpdate = OnAfterCameraUpdate;
        touchCamera.BeforeUpdate = OnBeforeCameraUpdate;
        touchCamera.CamZoomMax = touchCamera.CamZoomMaxWorld;
        touchCamera.CamZoomMin = touchCamera.CamZoomMinWorld;
        touchCamera.CamZoomInit = GameEntry.Lua.CallWithReturn<float>("CSharpCallLuaInterface.GetWorldCameraZoomInit");
        touchCamera.CamZoom = touchCamera.CamZoomInit;
        
        touchCamera.LodLevel = GetLodLevel();
        touchCamera.use45XCamera = true;
        
        touchCamera.GetComponent<UniversalAdditionalCameraData>().renderShadows = false;

        deviceResolution = Screen.currentResolution;
        LoadCurve();
    }

    public override void UnInit()
    {
        touchCamera.use45XCamera = false;
        touchCamera.AfterUpdate = null;
        touchCamera.BeforeUpdate = null;
        touchCamera.OnDestroy();
        AfterUpdate = null;
        DestroyCurve();
        base.UnInit();
    }

    public int GetLodLevel()
    {
        float lodDistance = GetLodDistance();
        for (int index = 0; index < LodArray.Length; ++index)
        {
            if (lodDistance <= LodArray[index])
            {
                return index;
            }
        }

        return LodArray.Length - 1;
    }

    public float GetLodDistance()
    {
        return camera.transform.position.y;
    }
    
    public float GetPreviousLodDistance()
    {
        return 0;
    }

    public float GetMinLodDistance()
    {
        // ZoomMin * sin(30˚)
        return ZoomMin * 0.5f;
    }

    public void MarkLodChanged()
    {
        lastLod = 0;
    }

    public void AutoLookat(Vector3 lookat, float zoom = -1, float time = 0.2f, Action onComplete = null)
    {
        touchCamera.AutoLookat(lookat, zoom, time, onComplete);
    }

    public void AutoZoom(float zoom, float time = 0.2f, Action onComplete = null)
    {
        touchCamera.AutoZoom(zoom, time, onComplete);
    }

    public void AutoFocus(Vector3 lookat, LookAtFocusState state, float time, bool focusToCenter, bool lockView, Action onComplete = null)
    {
        float zoom = -1;
        float rotation = 0;
        AnimationCurve curve = null;
        if (_saveCurve.ContainsKey(state))
        {
            if (_saveCurve[state].focusCurve != null)
            {
                zoom = _saveCurve[state].focusCurve.camZoom;
                rotation = _saveCurve[state].focusCurve.camZoomFocusRotation;
                curve = _saveCurve[state].focusCurve.enterCurve;
            }
            else
            {
                zoom = touchCamera.CamZoomBuild;
                rotation = touchCamera.CamZoomFocusRotation;
                curve = touchCamera.CameraFocusCurve;
            }
        }
        else
        {
            if (state == LookAtFocusState.PlaceBuild)
            {
                zoom = touchCamera.CamZoomBuild;
                rotation = touchCamera.CamZoomFocusRotation;
                curve = touchCamera.CameraFocusCurve;
            }
            else if (state == LookAtFocusState.Dome)
            {
                zoom = touchCamera.CamZoomDome;
                rotation = touchCamera.CamZoomInitRotation;
                curve = touchCamera.CameraFocusDomeCurve;
            }
            else if (state == LookAtFocusState.MoveCity)
            {
                zoom = touchCamera.CamZoomMoveCity;
                rotation = touchCamera.CamZoomFocusMoveCityRotation;
                curve = touchCamera.CameraFocusMoveCityCurve;
            }
            else if (state == LookAtFocusState.Formation)
            {
                zoom = touchCamera.CamZoomFormation;
                rotation = touchCamera.CamZoomFocusFormationRotation;
                curve = touchCamera.CameraFocusCurve;
            }
        }
        
        touchCamera.AutoFocus(lookat, zoom, time, rotation, focusToCenter, lockView, curve, onComplete);
    }

    public void QuitFocus(float time)
    {
        touchCamera.QuitFocus(time);    
    }

    public void StopMove()
    {
        touchCamera.StopMove();
    }
    
    private Vector3 GetCameraTargetPos()
    {
        return touchCamera.GetCameraTargetPos();
    }

    public void Lookat(Vector3 lookWorldPosition)
    {
        touchCamera.LookAt(lookWorldPosition);
    }

    public override void OnUpdate(float deltaTime)
    {
        //GeometryUtility.CalculateFrustumPlanes(camera, frustumPlanes);
        //var curTilePos = CurTilePos;
    }
    
    public Vector3 GetRaycastGroundPoint(Vector3 screenPos)
    {
        Vector3 posWorld = Vector3.zero;
        if (camera != null && touchCamera != null)
        {
            touchCamera.RaycastGround(ScreenPointToRay(screenPos), out posWorld);
        }
        return posWorld;
    }
    
    public Vector3 WorldToViewportPoint(Vector3 position)
    {
        return camera.WorldToViewportPoint(position);
    }

    public Vector3 WorldToScreenPoint(Vector3 worldPos)
    {
        Vector3 camNormal = camera.transform.forward;
        Vector3 vectorFromCam = worldPos - camera.transform.position;
        float camNormDot = Vector3.Dot(camNormal, vectorFromCam);
        if (camNormDot <= 0)
        {
            // we are behind the camera forward facing plane, project the position in front of the plane
            Vector3 proj = (camNormal * camNormDot * 1.01f);
            worldPos = camera.transform.position + (vectorFromCam - proj);
        }

        var tempPos =  RectTransformUtility.WorldToScreenPoint(camera, worldPos);
        return new Vector3(((float)tempPos.x/resolutionScale),((float)tempPos.y/resolutionScale), 0.0f);
    }

    //屏幕坐标转成世界坐标 disPlane：距离地面的距离，默认0为贴在地面上
    public Vector3 ScreenPointToWorld(Vector3 worldPos,float disPlane = 0)
    {
        Vector3 posWorld = Vector3.zero;
        if (touchCamera != null)
        {
            var ray = ScreenPointToRay(worldPos);
            bool hitSuccess = touchCamera.RefPlane.Raycast(ray, out float hitDistance);
            if (hitSuccess)
            {
                if (hitDistance > disPlane)
                {
                    posWorld = ray.GetPoint(hitDistance - disPlane);
                }
            }
        }
        return posWorld;
    }

    public Ray ScreenPointToRay(Vector3 pos)
    {
        return camera.ScreenPointToRay(ConvertScreenPoint(pos));
    }

    // 相机跟随行军
    public void TrackMarch(long marchId)
    {
        var oldMarch = world.GetMarch(trackMarchId);
        if (oldMarch != null)
        {
            oldMarch.isCameraFollow = false;
        }
        trackMarchId = 0;
        
        var march = world.GetMarch(marchId);
        if (march != null)
        {
            trackMarchId = march.uuid;
            march.isCameraFollow = true;
        }

        if (marchId > 0)
        {
            var troop = SceneManager.World.GetTroop(marchId);
            if (troop != null && troop.GetTransform())
            {
                touchCamera.Follow(troop.GetTransform().gameObject, 0.4f);
            }
            else
            {
                if (march != null)
                {
                    touchCamera.AutoLookat(march.position, -1, 0.2f, null);
                }
                
            }
        }
        else
        {
            touchCamera.Follow(null, 0);
        }
    }

    public void TrackMarchV2(Vector3 position,Transform transform =null)
    {
        if (transform!=null)
        {
            touchCamera.Follow(transform.gameObject, 0.4f);
        }
        else
        {
            touchCamera.AutoLookat(position, -1, 0.2f, null);
                
        }
    }

    public void DisTrackMarch()
    {
        touchCamera.Follow(null, 0);
    }


    private void OnBeforeCameraUpdate()
    {
    }
    
    private void OnAfterCameraUpdate()
    {
        //UpdateCameraRot();
        AfterUpdate?.Invoke();
        if ((CurTarget - _lastTarget).sqrMagnitude > PointMoveDetal)
        {
            _lastTarget = CurTarget;
            GameEntry.Event.Fire(EventId.WORLD_CAMERA_CHANGE_POINT);
        }

        int lod = GetLodLevel();
        if (lastLod != lod)
        {
            touchCamera.LodLevel = lod;
            GameEntry.Event.Fire(EventId.ChangeCameraLod, lod);
            lastLod = lod;
        }
    }

    // 当相机位置超过边界时，将其固定在边界
    public void ClampToEdge()
    {
        if (touchCamera.CurrentState == MobileTouchCamera.State.Focus ||
            touchCamera.CurrentState == MobileTouchCamera.State.MoveTo)
        {
            return;
        }
        
        Vector2 target = world.WorldToTileFloat(CurTarget);

        float posY = camera.transform.position.y;
        int paddingY = (int) (posY / MAX_POS_Y * MAX_PADDING_Y);
        int paddingX = (int) ((float) paddingY / Screen.height * Screen.width);
        
        bool clamped = false;
        if (target.x < SceneManager.World.CurTileCountXMin + paddingX)
        {
            target.x = SceneManager.World.CurTileCountXMin + paddingX;
            clamped = true;
        }

        if (target.x >= SceneManager.World.CurTileCountXMax - paddingX)
        {
            target.x = SceneManager.World.CurTileCountXMax - paddingX - 0.01f;
            clamped = true;
        }

        if (target.y < SceneManager.World.CurTileCountYMin + paddingY)
        {
            target.y = SceneManager.World.CurTileCountYMin + paddingY;
            clamped = true;
        }

        if (target.y >= SceneManager.World.CurTileCountYMax - paddingY)
        {
            target.y = SceneManager.World.CurTileCountYMax - paddingY - 0.01f;
            clamped = true;
        }

        if (clamped)
        {
            touchCamera.LookAt(world.TileFloatToWorld(target));
        }
    }

    public Quaternion GetRotation()
    {
        return camera.transform.rotation;
    }
    
    public Vector3 GetPosition()
    {
        return camera.transform.position;
    }

    public float GetMapIconScale()
    {
        var t = (camera.transform.position.y - LodScaleKey0.x) / (LodScaleKey1.x - LodScaleKey0.x);
        return Mathf.Lerp(LodScaleKey0.y, LodScaleKey1.y, t);
    }

    public float GetMapLabelScale()
    {
        var t = (camera.transform.position.y - LodScaleKey0.x) / (LodScaleKey1.x - LodScaleKey0.x);
        return Mathf.Lerp(LodScaleKey0.y, LodScaleKey1.y, t);
    }
    
    public void EnablePostProcess()
    {
        camera.GetComponent<UniversalAdditionalCameraData>().renderPostProcessing = true;
//        var postVolume = world.Transform.GetComponentInChildren<Volume>();
//        if (postVolume != null)
//        {
//            postVolume.enabled = true;
//        }
    }

    public void DisablePostProcess()
    {
        camera.GetComponent<UniversalAdditionalCameraData>().renderPostProcessing = false;
//        var postVolume = world.Transform.GetComponentInChildren<Volume>();
//        if (postVolume != null)
//        {
//            postVolume.enabled = false;
//        }
    }

    private Vector3[] frustumPoints = new Vector3[4];
    
    public void OnDrawGizmos()
    {
        var bounds = new Bounds(CurTarget, Vector3.one);
        var camPos = CurTarget;
        Gizmos.color = new Color(0, 0, 0.8f, 1);
        Gizmos.DrawSphere(camPos, 1);

        var ray0 = camera.ScreenPointToRay(new Vector3(0, 0, 0));
        var ray1 = camera.ScreenPointToRay(new Vector3(camera.pixelWidth, 0, 0));
        var ray2 = camera.ScreenPointToRay(new Vector3(camera.pixelWidth, camera.pixelHeight, 0));
        var ray3 = camera.ScreenPointToRay(new Vector3(0, camera.pixelHeight, 0));
        var plane = touchCamera.RefPlane;
        
        float dist;
        if (plane.Raycast(ray0, out dist))
        {
            frustumPoints[0] = ray0.GetPoint(dist);
        }
        if (plane.Raycast(ray1, out dist))
        {
            frustumPoints[1] = ray1.GetPoint(dist);
        }
        if (plane.Raycast(ray2, out dist))
        {
            frustumPoints[2] = ray2.GetPoint(dist);
        }
        if (plane.Raycast(ray3, out dist))
        {
            frustumPoints[3] = ray3.GetPoint(dist);
        }
        Gizmos.DrawLine(frustumPoints[0], frustumPoints[1]);
        Gizmos.DrawLine(frustumPoints[1], frustumPoints[2]);
        Gizmos.DrawLine(frustumPoints[2], frustumPoints[3]);
        Gizmos.DrawLine(frustumPoints[3], frustumPoints[0]);
        bounds.Encapsulate(frustumPoints[0]);
        bounds.Encapsulate(frustumPoints[1]);
        bounds.Encapsulate(frustumPoints[2]);
        bounds.Encapsulate(frustumPoints[3]);
        Gizmos.color = new Color(0, 0, 0.8f, 0.6f);
        // Gizmos.DrawCube(bounds.center, bounds.size);
    }

    public void SetTouchInputControllerEnable(bool able)
    {
        if(touchInput != null)
        {
            touchInput.enabled = able;
        }
    }
    
    public bool GetTouchInputControllerEnable()
    {
        return touchInput.enabled;
    }
    
    #region Scene Camera Resolution

    private RenderTexture m_FrameBuffer;
    private CommandBuffer m_CommandBuffer;
    private Resolution deviceResolution;

    public int frameBufferWidth
    {
        get { return m_FrameBuffer == null ? Screen.width : m_FrameBuffer.width; }
    }

    public int frameBufferHeight
    {
        get { return m_FrameBuffer == null ? Screen.height : m_FrameBuffer.height; }
    }

    private float resolutionScale
    {
        get { return frameBufferHeight / (float)Screen.height; }
    }

    private Vector3 ConvertScreenPoint(Vector3 screenPos)
    {
        return screenPos * resolutionScale;
    }

    private void AddCommand()
    {
        RemoveCommand();
        
        m_CommandBuffer = new CommandBuffer();
        m_CommandBuffer.name = "blit to Back buffer";
        m_CommandBuffer.SetRenderTarget (-1);
        m_CommandBuffer.Blit(m_FrameBuffer, BuiltinRenderTextureType.CurrentActive);
        camera.AddCommandBuffer(CameraEvent.AfterEverything, m_CommandBuffer);
    }
    
    private void RemoveCommand()
    {
        if (m_CommandBuffer == null) {
            return;
        }

        camera.RemoveCommandBuffer (CameraEvent.AfterEverything, m_CommandBuffer);
        m_CommandBuffer = null;
    }

    private void ClearFrameBuffer()
    {
        if (m_FrameBuffer != null)
        {
            m_FrameBuffer.Release();
            GameObject.DestroyImmediate(m_FrameBuffer);
            m_FrameBuffer = null;
        }
    }
    
    private void UpdateFrameBuffer(int width, int height, int depth)
    {
        ClearFrameBuffer();

        RenderTextureFormat format = RenderTextureFormat.Default;
        m_FrameBuffer = RenderTexture.GetTemporary(width, height, depth, format);
        m_FrameBuffer.name = "cameraTargetBuffer";
        m_FrameBuffer.hideFlags = HideFlags.DontSave;
        m_FrameBuffer.useMipMap = false;
        m_FrameBuffer.Create();
    }
    
    public void SetResolution(int height)
    {
        float aspect = deviceResolution.width / (float) deviceResolution.height;
        int width = Mathf.RoundToInt(height * aspect);
        Screen.SetResolution(width, height, true);
        
        /*
        float aspect = Screen.width / (float) Screen.height;
        int width = Mathf.RoundToInt(height * aspect);
        if (height < Screen.height)
        {
            UpdateFrameBuffer(width, height, 24);
            camera.SetTargetBuffers(m_FrameBuffer.colorBuffer, m_FrameBuffer.depthBuffer);
            AddCommand();
        }
        else
        {
            RemoveCommand();
            ClearFrameBuffer();
        }
        */
    }

    #endregion

    private void LoadCurve()
    {
        for (int i = 0; i < NeedLoadFocusCurve.Length; ++i)
        {
            FocusCurveStruct curve = new FocusCurveStruct();
            curve.instanceRequest =
                GameEntry.Resource.InstantiateAsync(string.Format(GameDefines.EntityAssets.FocusCurve,
                    (int) NeedLoadFocusCurve[i]));
            curve.instanceRequest.completed += delegate
            {
                var gameObject = curve.instanceRequest.gameObject;
                if (gameObject != null)
                {
                    gameObject.transform.SetParent(SceneManager.World.DynamicObjNode);
                    curve.focusCurve = gameObject.GetComponent<FocusCurve>();
                }
            };
            _saveCurve.Add(NeedLoadFocusCurve[i], curve);
        }
    }
    
    private void DestroyCurve()
    {
        foreach (var per in _saveCurve.Values)
        {
            if (per != null && per.instanceRequest != null)
            {
                per.instanceRequest.Destroy();
            }
        }

        _saveCurve = null;
    }
    
    public void SetZoomParams(int level, float y, float offsetZ, float sensitivity)
    {
        touchCamera.SetZoomParams(level, y, offsetZ, sensitivity);
    }
    
    public void SetFOV(float fov)
    {
        camera.fieldOfView = fov;
        camera.transform.Find("HudCamera").GetComponent<Camera>().fieldOfView = fov;
    }
}
