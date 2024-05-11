
using System;
using System.Collections.Generic;
using BitBenderGames;
using GameFramework;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using XLua;

public class CityCamera : CityManagerBase
{
    private MobileTouchCamera touchCamera;
    private TouchInputController touchInput;
    private Camera camera;
    private long trackMarchId;
    private Vector3 _lastTarget;
    private float _lastZoom;
    private Vector3 _focusTarget;

    private static Vector2 LodScaleKey0 = new Vector2(0, 1);
    private static Vector2 LodScaleKey1 = new Vector2(220, 22);
    public static LookAtFocusState[] NeedLoadFocusCurve = {};
    private Dictionary<LookAtFocusState, FocusCurveStruct> _saveCurve;

    private int lastLod = 0;
    
    private static int[] lodArray;
    public static int[] LodArray
    {
        get
        {
            if (lodArray == null)
            {
                LuaTable lodTable = GameEntry.Lua.CallWithReturn<LuaTable>("CSharpCallLuaInterface.GetCityLodArray");
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
        set { touchCamera.CamZoomInit = value; }
    }

    public float ZoomMin
    {
        get { return touchCamera.CamZoomMin; }
        set { touchCamera.CamZoomMin = value; }
    }

    public float ZoomMax
    {
        get { return touchCamera.CamZoomMax; }
        set { touchCamera.CamZoomMax = value; }
    }

    public Vector3 CurTarget
    {
        get { return GetCameraTargetPos(); }
    }
    
    public Vector2Int CurTilePos
    {
        get { return scene.WorldToTile(GetCameraTargetPos()); }
    }

    public Vector2Int CurTilePosClamped
    {
        get { return scene.ClampTilePos(CurTilePos); }
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
        set { ; }
    }
    
    public bool IsFocus
    {
        // TODO Z
        get { return false; }
        set { ; }
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

    public CityCamera(CityScene scene)
        : base(scene)
    {
        camera = UnityEngine.Camera.main;
        _saveCurve = new Dictionary<LookAtFocusState, FocusCurveStruct>();
    }

    public override void Init()
    {
        camera.fieldOfView = 25;
        camera.farClipPlane = 4500;
        touchCamera = camera.GetComponent<MobileTouchCamera>();
        touchCamera.ResetCamera();
        touchCamera.SetYRotation(-10);
        touchInput = touchCamera.touchInput;
        SetTouchInputControllerEnable(false);
        touchCamera.AfterUpdate = OnAfterCameraUpdate;
        touchCamera.BeforeUpdate = OnBeforeCameraUpdate;
        touchCamera.CamZoomMax = touchCamera.CamZoomMaxCity;
        touchCamera.CamZoomMin = touchCamera.CamZoomMinCity;
        touchCamera.use45XCamera = false;
        InitZoom = GameEntry.Lua.CallWithReturn<float>("CSharpCallLuaInterface.GetCityCameraZoomInit");
        touchCamera.CamZoom = InitZoom;
        touchCamera.LodLevel = 1;
        touchCamera.GetComponent<UniversalAdditionalCameraData>().renderShadows = true;
        
        LoadCurve();
        GameEntry.Event.Subscribe(EventId.ChangeCameraInitZoom, ChangeCameraInitZoomSignal);
    }

    public override void UnInit()
    {
        GameEntry.Event.Unsubscribe(EventId.ChangeCameraInitZoom, ChangeCameraInitZoomSignal);
        touchCamera.AfterUpdate = null;
        touchCamera.BeforeUpdate = null;
        touchCamera.use45XCamera = false;
        touchCamera.OnDestroy(); 
        AfterUpdate = null;
        DestroyCurve();
        base.UnInit();
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
        if (!Enabled)
        {
            return;
        }
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
        return new Vector3(((float)tempPos.x),((float)tempPos.y), 0.0f);
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
        return camera.ScreenPointToRay(pos);
    }

    private void OnBeforeCameraUpdate()
    {
    }
    
    private void OnAfterCameraUpdate()
    {
        //UpdateCameraRot();
        AfterUpdate?.Invoke();
        if ((CurTarget - _lastTarget).sqrMagnitude > float.Epsilon || Mathf.Abs(Zoom - _lastZoom) > float.Epsilon)
        {
            _lastTarget = CurTarget;
            _lastZoom = Zoom;
            GameEntry.Event.Fire(EventId.WORLD_CAMERA_CHANGE_POINT);
        }
        
        int lod = GetLodLevel();
        if (lastLod != lod)
        {
            touchCamera.LodLevel = lod;
            GameEntry.Event.Fire(EventId.ChangeCameraLod, lod);
            Log.Debug("on fire ChangeCameraLod finish");
            lastLod = lod;
        }
    }

    // 当相机位置超过边界时，将其固定在边界
    public void ClampToEdge()
    {
        
        var target = scene.WorldToTileFloat(CurTarget);
        //var edgeRect = WorldScene.TileEdgeRect;
        
        bool clamped = false;
        if (target.x < scene.CurTileCountXMin)
        {
            target.x = scene.CurTileCountXMin;
            clamped = true;
        }

        if (target.x >= scene.CurTileCountXMax)
        {
            target.x = scene.CurTileCountXMax - 0.01f;
            clamped = true;
        }

        if (target.y < scene.CurTileCountYMin)
        {
            target.y = scene.CurTileCountYMin;
            clamped = true;
        }

        if (target.y >= scene.CurTileCountYMax)
        {
            target.y = scene.CurTileCountYMax - 0.01f;
            clamped = true;
        }

        if (clamped)
        {
            touchCamera.LookAt(scene.TileFloatToWorld(target));
            touchCamera.IsInClamp = true;
        }
        else
        {
            touchCamera.IsInClamp = false;
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
        var camPos = CurTarget;
        Gizmos.color = new Color(0, 0, 0.8f, 1);
        //Gizmos.DrawSphere(camPos, 1);

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
    }

    public void SetTouchInputControllerEnable(bool able)
    {
        if(touchInput != null)
        {
            touchInput.enabled = able;
        }
    }
    
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
    
    public List<MobileTouchCamera.ZoomParam> GetZoomParams()
    {
        return touchCamera.GetZoomParams();
    }
    
    public void SetFOV(float fov)
    {
        camera.fieldOfView = fov;
        camera.transform.Find("HudCamera").GetComponent<Camera>().fieldOfView = fov;
    }

    public float GetFOV()
    {
        return camera.fieldOfView;
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
    
    private void ChangeCameraInitZoomSignal(object userData)
    {
        if (userData != null)
        {
            float zoom =  userData.ToFloat();
            if (zoom > 0)
            {
                InitZoom = zoom;
            }
        }
    }
    
}
