using System;
using System.Collections.Generic;
using BitBenderGames.CameraState;
using GameFramework;
using UnityEngine;
using UnityEngine.EventSystems;

namespace BitBenderGames
{
    [RequireComponent(typeof(Camera))]
    public class MobileTouchCamera : MonoBehaviour
    {
        public enum State
        {
            Idle,
            FreeLook,
            MoveTo,
            Focus,
            QuitFocus,
            Follow,
        }

        private List<CameraStateBase> _stateList;
        private State _currentState;
        public State CurrentState => _currentState;
        private CameraStateBase _cameraState;
        
        public TouchInputController touchInput;
        private Camera camera;
        
        private Plane refPlaneXZ = new Plane(new Vector3(0, 1, 0), 0);
        public Plane RefPlane => refPlaneXZ;

        private bool showHorizonError = true;
        private float maxHorizonFallbackDistance = 10000; //This value may need to be tweaked when using the camera in a low-tilt, see above the horizon scenario.

        private bool _use45XCamera;
        public bool use45XCamera
        {
            get
            {
                return _use45XCamera;
            }
            set
            {
                _use45XCamera = value;
                if (_use45XCamera)
                {
                    this.transform.rotation = Quaternion.Euler(45,0,0);
                }
            }
        }
        
        public int LodLevel { get; set; }

        [SerializeField]
        [Tooltip("This value defines how quickly the camera comes to a halt when auto scrolling.")]
        private float dampFactorTimeMultiplier = 2;
        
        [SerializeField]
        [Tooltip("When swiping over the screen the camera will keep scrolling a while before coming to a halt. This variable limits the maximum velocity of the auto scroll.")]
        private float autoScrollVelocityMax = 60;
        
        [SerializeField]
        [Tooltip("When dragging quickly, the camera will keep autoscrolling in the last direction. The autoscrolling will slowly come to a halt. This value defines how fast the camera will come to a halt.")]
        private float autoScrollDamp = 300;
        
        [SerializeField]
        private List<float> autoScrollDamps = new List<float>();

        [SerializeField]
        [Tooltip("This curve allows to modulate the auto scroll damp value over time.")]
        private AnimationCurve autoScrollDampCurve = new AnimationCurve(new Keyframe(0, 1, 0, 0), new Keyframe(0.7f, 0.9f, -0.5f, -0.5f), new Keyframe(1, 0.01f, -0.85f, -0.85f));

        [SerializeField]
        [Tooltip("The lower the value, the slower the camera will follow. The higher the value, the more direct the camera will follow movement updates. Necessary for keeping the camera smooth when the framerate is not in sync with the touch input update rate.")]
        private float camFollowFactor = 15.0f;
        
        private float yRotation = 0;
        [SerializeField]
        private float camZoomInit;
        [SerializeField]
        private float camZoomCityInit;
        [SerializeField]
        private float camZoomWorldInit;
        [SerializeField]
        private float camZoomMin = 15;
        [SerializeField]
        private float camZoomMinCity = 15;
        [SerializeField]
        private float camZoomMinWorld = 50;
        [SerializeField]
        private float camZoomMax = 5000f;
        [SerializeField]
        private float camZoomMaxCity = 60;
        [SerializeField]
        private float camZoomMaxWorld = 5000f;
        [SerializeField]
        private float camZoomBuild;
        [SerializeField]
        private float camZoomFocusRotation;
        [SerializeField]
        private float camZoomDome;
        [SerializeField]
        private float camZoomMoveCity;
        [SerializeField]
        private float camZoomFormation;
        [SerializeField]
        private float camZoomFocusMoveCityRotation;
        [SerializeField]
        private float camZoomFocusFormationRotation;
        [SerializeField]
        private float camZoomInitCityRotation;
        [SerializeField]
        private float camZoomInitWorldRotation;
        [SerializeField]
        private float camOverzoomMargin = 1;
        [SerializeField]
        private List<ZoomParam> zoomParams;
        [SerializeField] 
        private AnimationCurve cameraFocusCurve;
        [SerializeField] 
        private AnimationCurve cameraFocusEarthCurve;
        [SerializeField] 
        private AnimationCurve cameraFocusDomeCurve;
        [SerializeField] 
        private AnimationCurve cameraFocusMoveCityCurve;
        
        [Serializable]
        public class ZoomParam
        {
            public float posY;
            public float offsetZ;
            public float sensitivity;
        }
        
        public float CamZoomInit
        {
            get
            {
                if (SceneManager.CurrSceneID == (int)SceneManager.SceneID.World)
                {
                    camZoomInit = camZoomWorldInit;
                }
                else
                {
                    camZoomInit = camZoomCityInit;
                }
                return camZoomInit;
            }
             set 
             {
                 if (SceneManager.CurrSceneID == (int)SceneManager.SceneID.World)
                 {
                     camZoomWorldInit = value;
                 }
                 else
                 {
                     camZoomCityInit = value;
                 }
             }
        }

        public float CamZoomMin
        {
            get => camZoomMin;
            set => camZoomMin = value;
        }
        public float CamZoomMax
        {
            get => camZoomMax;
            set => camZoomMax = value;
        }

        public float CamZoomMaxCity
        {
            get => camZoomMaxCity;
        }
        public float CamZoomMinCity
        {
            get => camZoomMinCity;
        }
        public float CamZoomMaxWorld
        {
            get => camZoomMaxWorld;
        }
        public float CamZoomMinWorld
        {
            get => camZoomMinWorld;
        }

        public float CamOverZoomMargin => camOverzoomMargin;

        public float CamZoom
        {
            get => transform.position.y;
            set
            {
                if (CalcZoom(value, transform.position, out var outPos, out var outRot))
                {
                    transform.position = outPos;
                    transform.rotation = outRot;
                }
            }
        }
        public void SetYRotation(float rotation)
        {
            var originAngle = transform.rotation.eulerAngles;
            yRotation = rotation;
            transform.rotation = Quaternion.Euler(originAngle.x, rotation, originAngle.z);
        }
        public bool CalcZoom(float cameraY, Vector3 pos, out Vector3 outPos, out Quaternion outRot)
        {
            Vector3 camCenterIntersection = GetCameraTargetPos();
            
            int beg, end;
            GetZoomInterval(cameraY, out beg, out end);
            
            if (beg >= 0 && end >= 0 && beg < zoomParams.Count && end < zoomParams.Count)
            {
                float t = (cameraY - zoomParams[beg].posY) / (zoomParams[end].posY - zoomParams[beg].posY);
                if (use45XCamera)
                {
                    var y = Mathf.Lerp(zoomParams[beg].posY, zoomParams[end].posY,t);
                    var changeY = y - pos.y;
                    var changeZ = -(changeY * 0.7071f);
                    outPos = new Vector3(pos.x, y, pos.z + changeZ);
                    outRot = Quaternion.LookRotation(camCenterIntersection - outPos);
                }
                else
                {
                    var begPos = new Vector3(0, zoomParams[beg].posY, -zoomParams[beg].offsetZ);
                    var endPos = new Vector3(0, zoomParams[end].posY, -zoomParams[end].offsetZ);
                    //因为之前的rotation是基于平面的,不是三维的
                    var p0 = Vector3.Lerp(begPos, endPos, t);  //找到当前应该在的y/z平面上的坐标
                    var r0 = Quaternion.LookRotation(-p0);

                    var r1 = Quaternion.Euler(0, yRotation, 0);
                    var p1 = camCenterIntersection;

                    outRot = r1 * r0;
                    outPos = p1 + r1 * p0;
                }
                
                return true;
            }

            outPos = Vector3.zero;
            outRot = Quaternion.identity;
            return false;
        }
        
        private bool canMoveing = true;
        public bool CanMoveing
        {
            get => canMoveing;
            set
            {
                if (canMoveing != value)
                {
                    //Log.Debug("change CanMoveing =={0}", value);
                }
                canMoveing = value;
            }
        }

        public bool IsInClamp { get; set; } = false;

        public float DampFactorTimeMultiplier => dampFactorTimeMultiplier;
        public float AutoScrollVelocityMax => autoScrollVelocityMax;
        public float AutoScrollDamp => autoScrollDamp;
        public List<float> AutoScrollDamps => autoScrollDamps;
        public AnimationCurve AutoScrollDampCurve => autoScrollDampCurve;
        public float CamFollowFactor => camFollowFactor;

        public float CamZoomBuild
        {
            get => camZoomBuild;
            set => camZoomBuild = value;
        }

        public float CamZoomFocusRotation
        {
            get => camZoomFocusRotation;
            set => camZoomFocusRotation = value;
        }
        public float CamZoomFormation
        {
            get => camZoomFormation;
            set => camZoomFormation = value;
        }
        public float CamZoomFocusFormationRotation
        {
            get => camZoomFocusFormationRotation;
            set => camZoomFocusFormationRotation = value;
        }
        public float CamZoomDome => camZoomDome;
        public float CamZoomMoveCity => camZoomMoveCity;
        public float CamZoomFocusMoveCityRotation => camZoomFocusMoveCityRotation;

        public float CamZoomInitRotation
        {
            get
            {
                if (SceneManager.CurrSceneID == (int)SceneManager.SceneID.World)
                {
                    return camZoomInitWorldRotation;
                }
                else
                {
                    return camZoomInitCityRotation;
                }
            }
        } 
        public AnimationCurve CameraFocusCurve => cameraFocusCurve;
        public AnimationCurve CameraFocusEarthCurve => cameraFocusEarthCurve;
        public AnimationCurve CameraFocusDomeCurve => cameraFocusDomeCurve;
        public AnimationCurve CameraFocusMoveCityCurve => cameraFocusMoveCityCurve;

        public List<ZoomParam> GetZoomParams()
        {
            return new List<ZoomParam>(zoomParams);
        }
        
        public void SetZoomParams(List<ZoomParam> zoomParams)
        {
            this.zoomParams = zoomParams;
        }

        public void SetZoomParams(int level, float y, float offsetZ, float sensitivity)
        {
            if (level > 0 && level < zoomParams.Count)
            {
                zoomParams[level].posY = y;
                zoomParams[level].offsetZ = offsetZ;
                zoomParams[level].sensitivity = sensitivity;
                CamZoom = transform.position.y;
            }
        }
        
        private Action beforeUpdate;
        public Action BeforeUpdate
        {
            set => beforeUpdate = value;
        }
        
        private Action afterUpdate;
        public Action AfterUpdate
        {
            set => afterUpdate = value;
        }
        
        public void Awake()
        {
            // 临时：打包版摄像机高度调整
            // if (!CommonUtils.IsDebug())
            // {
            //     camZoomMax = 350;
            //     camZoomMaxWorld = 350;
            // }
            
            camera = GetComponent<Camera>();
   
            CamZoom = CamZoomInit;
            
            touchInput = new TouchInputController();
            
            _stateList = new List<CameraStateBase>();
            _stateList.Add(new CameraStateIdle(this));
            _stateList.Add(new CameraStateFreeLook(this));
            _stateList.Add(new CameraStateMoveTo(this));
            _stateList.Add(new CameraStateFocus(this));
            _stateList.Add(new CameraStateQuitFocus(this));
            _stateList.Add(new CameraStateFollow(this));

            _currentState = State.Idle;
            _cameraState = GetState(_currentState);
            _cameraState.OnEnter();
        }

        public void ResetCamera()
        {
            Log.Info("touchCamera Reset");
            touchInput = new TouchInputController();
            _currentState = State.Idle;
            _cameraState = GetState(_currentState);
            _cameraState.OnEnter();
        }

        public void OnDestroy()
        {
            SetState(State.Idle);
            beforeUpdate = null;
            afterUpdate = null;
        }

        public void Update()
        {
            if (touchInput.enabled)
            {
                touchInput.OnUpdate();
            }
            beforeUpdate?.Invoke();
            _cameraState.OnUpdate();
            afterUpdate?.Invoke();
        }

        public void Follow(GameObject go, float time)
        {
            var followState = GetState(State.Follow) as CameraStateFollow;
            var oldLeader = followState._leaderObj;
            followState._leaderObj = go;
            followState._moveToLeaderTime = (oldLeader != null && go != null && oldLeader == go) ? -1 : time;
            
            if (_currentState == State.Follow)
            {
                if (go == null)
                {
                    SetState(State.Idle);
                }
                else
                {
                    if (oldLeader != go)
                    {
                        followState.Reset();
                    }
                }
            }
            else if (go != null)
            {
                SetState(State.Follow);
            }
        }

        public void AutoLookat(Vector3 target, float zoom, float time, Action onCompete)
        {
            var curTarget = GetCameraTargetPos();
            if (target == curTarget && Mathf.Approximately(zoom, CamZoom))
            {
                onCompete?.Invoke();
                return;
            }
            
            target = AdjustTarget(target);
            
            var moveState = GetState(State.MoveTo) as CameraStateMoveTo;
            moveState._target = target;
            moveState._zoom = zoom < 0 ? CamZoom : zoom;
            moveState._time = time;
            moveState._onComplete = onCompete;
            moveState._moveType = CameraStateMoveTo.MoveType.MoveAndZoom;
            if (_currentState == State.MoveTo)
            {
                moveState.Refresh();
            }
            SetState(State.MoveTo);
        }

        public void AutoZoom(float zoom, float time, Action onComplete)
        {
            if (Mathf.Approximately(zoom, CamZoom))
            {
                onComplete?.Invoke();
                return;
            }
            var moveState = GetState(State.MoveTo) as CameraStateMoveTo;
            moveState._target = Vector3.zero;
            moveState._zoom = zoom < 0 ? CamZoom : zoom;
            moveState._time = time;
            moveState._onComplete = onComplete;
            moveState._moveType = CameraStateMoveTo.MoveType.ZoomOnly;
            if (_currentState == State.MoveTo)
            {
                moveState.Refresh();
            }
            SetState(State.MoveTo);
        }

        public void AutoFocus(Vector3 target, float zoom, float time, float rotation, bool focusToCenter, bool lockView, AnimationCurve curve, Action onCompete)
        {
            var curTarget = GetCameraTargetPos();
            if (target == curTarget && Mathf.Approximately(zoom, CamZoom))
            {
                onCompete?.Invoke();
                return;
            }
            
            SetState(State.Idle);
            
            target = AdjustTarget(target);
            
            var focusState = GetState(State.Focus) as CameraStateFocus;
            focusState._target = target;
            focusState._zoom = zoom < 0 ? CamZoom : zoom;
            focusState._time = time;
            focusState._lerpCurve = curve;
            focusState._rotation = rotation;
            focusState._onComplete = onCompete;
            focusState._focusToCenter = focusToCenter;
            focusState._lockView = lockView;
            SetState(State.Focus);
        }

        public void QuitFocus(float time)
        {
            if (_currentState != State.Focus)
            {
                return;
            }
            
            var focusState = GetState(State.Focus) as CameraStateFocus;
            var quitFocusState = GetState(State.QuitFocus) as CameraStateQuitFocus;
            if (focusState._lockView && !focusState._focusToCenter)
            {
                quitFocusState._target = focusState._target;
            }
            else
            {
                quitFocusState._target = GetCameraTargetPos();
            }
            quitFocusState._focusToCenter = focusState._focusToCenter;
            quitFocusState._time = time;
            SetState(State.QuitFocus);
        }

        public void StopMove()
        {
            if (_currentState == State.Follow || _currentState == State.FreeLook || _currentState == State.MoveTo)
            {
                SetState(State.Idle);
            }
        }

        public void LookAt(Vector3 target)
        {
            var curTarget = GetCameraTargetPos();
            target = AdjustTarget(target);
            var offset = target - curTarget;
            transform.position = transform.position + offset; // TODO Z
        }

        public CameraStateBase GetState(State state)
        {
            return _stateList[(int) state];
        }

        public void SetState(State newState)
        {
            if (_currentState != newState)
            {
                // Log.Debug("set camera state {0} => {1}", _currentState, newState);

                _currentState = newState;
                var oldState = _cameraState;
                _cameraState = GetState(_currentState);
                oldState.OnLeave();
                _cameraState.OnEnter();
                _cameraState.OnUpdate();
            }
        }

        public bool InputDonwOnUI(Vector3 pos)
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
        
        /// <summary>
        /// Method for retrieving the intersection-point between the given ray and the ref plane.
        /// </summary>
        public Vector3 GetIntersectionPoint(Ray ray)
        {
            float distance = 0;
            bool success = RefPlane.Raycast(ray, out distance);
            if (success == false || (distance > maxHorizonFallbackDistance))
            {
                if (showHorizonError == true)
                {
                    Debug.LogError("Failed to compute intersection between camera ray and reference plane. Make sure the camera Axes are set up correctly.");
                    showHorizonError = false;
                }
                
                //Fallback: Compute a sphere-cap on the ground and use the border point at the direction of the ray as maximum point in the distance.
                Vector3 rayOriginProjected = UnprojectVector2(ProjectVector3(ray.origin));
                Vector3 rayDirProjected = UnprojectVector2(ProjectVector3(ray.direction));
                return rayOriginProjected + rayDirProjected.normalized * maxHorizonFallbackDistance;
            }
            return (ray.origin + ray.direction * distance);
        }
        
        /// <summary>
        /// Method for performing a raycast against either the refplane, or
        /// against a terrain-collider in case the collider is set.
        /// </summary>
        public bool RaycastGround(Ray ray, out Vector3 hitPoint)
        {
            bool hitSuccess = false;
            hitPoint = Vector3.zero;

            float hitDistance = 0;
            hitSuccess = RefPlane.Raycast(ray, out hitDistance);
            if (hitSuccess == true)
            {
                hitPoint = ray.GetPoint(hitDistance);
            }

            return hitSuccess;
        }
        
        /// <summary>
        /// Helper method that unprojects the given Vector2 to a Vector3
        /// according to the camera axes setting.
        /// </summary>
        public Vector3 UnprojectVector2(Vector2 v2, float offset = 0)
        {
            return new Vector3(v2.x, offset, v2.y);
        }
        
        public Vector2 ProjectVector3(Vector3 v3)
        {
            return new Vector2(v3.x, v3.z);
        }
        
        public Vector3 GetCameraTargetPos()
        {
            return GetIntersectionPoint(GetCamCenterRay());
        }

        public Vector3 GetCameraPos()
        {
            return transform.position;
        }

        public void SetCameraPos(Vector3 pos)
        {
            transform.position = pos;
        }

        public Quaternion GetRotation()
        {
            return transform.rotation;
        }

        public void SetRotation(Quaternion rot)
        {
            transform.rotation = rot;
        }

        private Ray GetCamCenterRay()
        {
            return new Ray(transform.position, transform.forward);
        }

        public Ray ScreenPointToRay(Vector3 pos)
        {
            Vector3 position = transform.position;
            transform.position = Vector3.zero;
            Ray ray = camera.ScreenPointToRay(pos);
            transform.position = position;
            Ray ray2 = new Ray(position, ray.direction);
            return ray2;
        }
        
        public bool GetTouchTerrainPos(float x, float y, out Vector3 pos)
        {
            Ray ray = ScreenPointToRay(new Vector3(x, y, 0));
            float enter = 0f;
            bool flag = RefPlane.Raycast(ray, out enter);
            if (flag)
            {
                pos = ray.origin + ray.direction * enter;
                return true;
            }
            pos = Vector3.zero;
            return false;
        }

        public Vector3 WorldToScreenPoint(Vector3 position)
        {
            return camera.WorldToScreenPoint(position);
        }
        
        private void GetZoomInterval(float cameraY, out int beg, out int end)
        {
            beg = -1;
            end = -1;

            for (int i = 0; i < zoomParams.Count; i++)
            {
                if (cameraY < zoomParams[i].posY)
                {
                    beg = i - 1;
                    end = i;
                    break;
                }
            }
        }
        
        public float GetZoomSensitivity()
        {
            int beg, end;
            GetZoomInterval(transform.position.y, out beg, out end);
            
            if (beg >= 0 && end >= 0 && beg < zoomParams.Count && end < zoomParams.Count)
            {
                float cameraY = transform.position.y;
                float t = (cameraY - zoomParams[beg].posY) /
                          (zoomParams[end].posY - zoomParams[beg].posY);

                return Mathf.Lerp(zoomParams[beg].sensitivity, zoomParams[end].sensitivity, t);
            }

            return 1;
        }
        
        public Vector3 AdjustTarget(Vector3 target)
        {
            if (Mathf.Abs(target.y) > Mathf.Epsilon)
            {
                target = GetIntersectionPoint(new Ray(target,
                    target.y >= 0 ? transform.forward : -1 * transform.forward));
            }

            return target;
        }

        private void OnDrawGizmos()
        {
            /*
            var pos = transform.position;
            var lookTarget = GetCameraTargetPos();
            for (int i = 0; i < zoomParams.Count; i++)
            {
                Vector3 from = Vector3.zero;
                Vector3 to = Vector3.zero;
                if (i == 0)
                {
                    from = lookTarget;
                    to = new Vector3(pos.x, zoomParams[i].posY, lookTarget.z - zoomParams[i].offsetZ);
                }
                else
                {
                    from = new Vector3(pos.x, zoomParams[i - 1].posY, lookTarget.z - zoomParams[i - 1].offsetZ);
                    to = new Vector3(pos.x, zoomParams[i].posY, lookTarget.z - zoomParams[i].offsetZ);
                }
                Gizmos.color = Color.magenta;
                Gizmos.DrawLine(from, to);
            }
            */
        }
    }

    //
    // Drag 相机移动
    //
    public class MobileTouchCameraDragMove
    {
        private MobileTouchCamera _touchCamera;

        private Vector3 targetPositionClamped = Vector3.zero;
        private float timeRealDragStop;
        private Vector3 cameraScrollVelocity;
        private Vector3 camVelocity = Vector3.zero;
        private Vector3 posLastFrame = Vector3.zero;
        
        private bool isDragging;
        private bool canDrag;
        private Vector3 dragStartCamPos;

        public MobileTouchCameraDragMove(MobileTouchCamera camera)
        {
            this._touchCamera = camera;
            Reset();
        }

        public void Reset()
        {
            targetPositionClamped = Vector3.zero;
            timeRealDragStop = 0;
            cameraScrollVelocity = Vector3.zero;
            camVelocity = Vector3.zero;
            posLastFrame = Vector3.zero;
            isDragging = false;
            dragStartCamPos = Vector3.zero;
        }

        public void OnFingerDown()
        {
            cameraScrollVelocity = Vector3.zero;
        }

        public void OnDragStart(Vector3 dragPosStart)
        {
            canDrag = !_touchCamera.InputDonwOnUI(dragPosStart);
            if (!canDrag)
            {
                return;
            }
            
            cameraScrollVelocity = Vector3.zero;
            dragStartCamPos = _touchCamera.GetCameraPos();
            isDragging = true;
            SetTargetPosition(_touchCamera.GetCameraPos());
            //Log.Debug($"[Camera] OnDragStart dragStartCamPos {dragStartCamPos}");
        }
        
        public void OnDragUpdate(Vector3 dragPosStart, Vector3 dragPosCurrent, Vector3 correctionOffset)
        {
            if (!canDrag)
            {
                return;
            }
            //Log.Debug($"[Camera] OnDragUpdate isDragging {isDragging} dragPosStart {dragPosStart} dragPosCurrent {dragPosCurrent} correctionOffset {correctionOffset}");
            if (isDragging)
            {
                Vector3 dragVector = GetDragVector(dragPosStart, dragPosCurrent + correctionOffset);
                Vector3 posNewClamped = (dragStartCamPos - dragVector);
                SetTargetPosition(posNewClamped);
            }
        }
        
        public void OnDragStop()
        {
            if (!canDrag)
            {
                return;
            }
            //Log.Debug($"[Camera] OnDragStop isDragging {isDragging}");
            
            if (isDragging)
            {
                cameraScrollVelocity = -_touchCamera.ProjectVector3(camVelocity) * 0.5f;
                timeRealDragStop = Time.realtimeSinceStartup;
                isDragging = false;
            }
        }
        
        public bool UpdateAutoScroll()
        {
            if (cameraScrollVelocity.sqrMagnitude <= float.Epsilon)
                return false;

            float timeSinceDragStop = Time.realtimeSinceStartup - timeRealDragStop;
            float dampFactor = Mathf.Clamp01(timeSinceDragStop * _touchCamera.DampFactorTimeMultiplier);
            float camScrollVel = cameraScrollVelocity.magnitude;
            float camScrollVelRelative = camScrollVel / _touchCamera.AutoScrollVelocityMax;
            int lod = _touchCamera.LodLevel;
            float autoScrollDamp;
            if (lod >= 0 && lod < _touchCamera.AutoScrollDamps.Count)
            {
                autoScrollDamp = _touchCamera.AutoScrollDamps[lod];
            }
            else
            {
                autoScrollDamp = _touchCamera.AutoScrollDamp;
            }
            Vector3 camVelDamp = dampFactor * cameraScrollVelocity.normalized * autoScrollDamp * Time.deltaTime;
            camVelDamp *= EvaluateAutoScrollDampCurve(Mathf.Clamp01(1.0f - camScrollVelRelative));
            if (camVelDamp.sqrMagnitude >= cameraScrollVelocity.sqrMagnitude)
            {
                cameraScrollVelocity = Vector3.zero;
                return false;
            }
            
            cameraScrollVelocity -= camVelDamp;

            return true;
        }
        
        public void UpdatePosition(float deltaTime)
        {
            if (isDragging)
            {
                var t = Mathf.Clamp01(Time.deltaTime * _touchCamera.CamFollowFactor);
                var pos = Vector3.Lerp(_touchCamera.GetCameraPos(), targetPositionClamped, t);
                _touchCamera.SetCameraPos(pos);
            }

            Vector2 autoScrollVector = -cameraScrollVelocity * deltaTime;
            Vector3 camPos = _touchCamera.GetCameraPos();

            camPos.x += autoScrollVector.x;
            camPos.z += autoScrollVector.y;
            
            _touchCamera.SetCameraPos(camPos);
            
            camVelocity = (_touchCamera.GetCameraPos() - posLastFrame) / Time.deltaTime;
            posLastFrame = _touchCamera.GetCameraPos();
        }

        
        private Vector3 GetDragVector(Vector3 dragPosStart, Vector3 dragPosCurrent)
        {
            Vector3 intersectionDragStart = _touchCamera.GetIntersectionPoint(_touchCamera.ScreenPointToRay(dragPosStart));
            Vector3 intersectionDragCurrent = _touchCamera.GetIntersectionPoint(_touchCamera.ScreenPointToRay(dragPosCurrent));
            return (intersectionDragCurrent - intersectionDragStart);
        }
        
        
        private void SetTargetPosition(Vector3 newPositionClamped)
        {
            targetPositionClamped = newPositionClamped;
        }
        
        private float EvaluateAutoScrollDampCurve(float t)
        {
            if (_touchCamera.AutoScrollDampCurve == null || _touchCamera.AutoScrollDampCurve.length == 0)
            {
                return (1);
            }
            return _touchCamera.AutoScrollDampCurve.Evaluate(t);
        }
        
        public void StopCameraScroll()
        {
            cameraScrollVelocity = Vector3.zero;
        }

    }

    //
    // Pinch 视口缩放
    //
    public class MobileTouchCameraPinchZoom
    {
        private MobileTouchCamera _touchCamera;
        
        private bool isPinching;
        private bool canPinch = false;
        private Vector3 pinchCenterCurrent;
        private float pinchDistanceCurrent;
        private Vector3 pinchCenterCurrentLerp;
        private float pinchDistanceCurrentLerp;
        private float pinchDistanceLastLerp;
        private Vector3 pinchStartIntersectionCenter;

        private float pinchDistanceLast;
        
        
        public MobileTouchCameraPinchZoom(MobileTouchCamera camera)
        {
            this._touchCamera = camera;
            isPinching = false;
        }
        
        public void OnPinchStart(Vector3 pinchCenter, float pinchDistance)
        {
            //Log.Debug($"[Camera] OnPinchStart pinchCenter {pinchCenter} pinchDistance {pinchDistance}");
            canPinch = !_touchCamera.InputDonwOnUI(pinchCenter);
            if (!canPinch)
            {
                return;
            }
            
            pinchDistanceCurrent = pinchDistance;
            pinchCenterCurrent = pinchCenter;
            pinchDistanceLast = pinchDistance;
            
            //Log.Debug($"OnPinchStart pinchCenter {pinchCenter} pinchDistance {pinchDistance}");
            
            isPinching = true;
            GameEntry.Event.Fire(EventId.OnTouchPinchStart);
        }

        public void OnPinchUpdate(PinchUpdateData pinchUpdateData)
        {
            //Log.Debug($"[Camera] OnPinchUpdate pinchCenter {pinchUpdateData.pinchCenter} pinchDistance {pinchUpdateData.pinchDistance}");
            if (!canPinch)
            {
                return;
            }
            pinchCenterCurrent = pinchUpdateData.pinchCenter;
            pinchDistanceCurrent = pinchUpdateData.pinchDistance;
        }

        public void OnPinchStop()
        {
            //Log.Debug($"[Camera] OnPinchStop");
            if (!canPinch)
            {
                return;
            }
            
            isPinching = false;
            GameEntry.Event.Fire(EventId.OnTouchPinchEnd);
        }
        
        public bool UpdatePinch()
        {
            if (isPinching)
            {
                //Log.Debug($"UpdatePinch pinchDistanceLast {pinchDistanceLast} pinchDistanceCurrent {pinchDistanceCurrent}");
                
                if (!_touchCamera.GetTouchTerrainPos(pinchCenterCurrent.x, pinchCenterCurrent.y, out var touchTerrainPos0))
                {
                    Log.Debug($"GetTouchTerrainPos0 {pinchCenterCurrent.x} {pinchCenterCurrent.y}");
                    return true;
                }

                float zoomAmount = (pinchDistanceCurrent - pinchDistanceLast) * _touchCamera.GetZoomSensitivity();
                if (zoomAmount > 0)
                {
                    GameEntry.Event.Fire(EventId.OnTouchPinchCameraNear);
                }
                else if (zoomAmount < 0)
                {
                    GameEntry.Event.Fire(EventId.OnTouchPinchCameraFar);
                }
                float cameraSize = _touchCamera.CamZoom - zoomAmount;
                cameraSize = Mathf.Clamp(cameraSize, _touchCamera.CamZoomMin - _touchCamera.CamOverZoomMargin,
                    _touchCamera.CamZoomMax + _touchCamera.CamOverZoomMargin);
                //Log.Debug($"_touchCamera.CamZoom cameraSize {cameraSize} zoomAmount {zoomAmount} zoom {_touchCamera.CamZoom}");
                _touchCamera.CamZoom = cameraSize;

                if (!_touchCamera.GetTouchTerrainPos(pinchCenterCurrent.x, pinchCenterCurrent.y, out var touchTerrainPos1))
                {
                    Log.Debug($"GetTouchTerrainPos1 {pinchCenterCurrent.x} {pinchCenterCurrent.y}");
                    return true;
                }

                var vector = touchTerrainPos1 - touchTerrainPos0;
                Vector3 targetPos = _touchCamera.GetCameraPos() - vector;
                //Log.Debug($"_touchCamera.SetCameraPos vector {vector} touchTerrainPos1 {touchTerrainPos1} touchTerrainPos0 {touchTerrainPos0} targetPos {targetPos}");
                _touchCamera.SetCameraPos(targetPos);

                pinchDistanceLast = pinchDistanceCurrent;
                
                return true;
            }
#if UNITY_EDITOR || UNITY_STANDALONE
            return DoEditorZoom();
#else
            return false;
#endif
        }
        
        private bool DoEditorZoom()
        {
#if UNITY_EDITOR || UNITY_STANDALONE
            float mouseScrollDelta = Input.GetAxis("Mouse ScrollWheel");
            if (!Mathf.Approximately(mouseScrollDelta, 0))
            {
                float editorZoomFactor = 1.2f; // Unity 地图缩放灵敏度系数
                float zoomAmount = mouseScrollDelta * editorZoomFactor * _touchCamera.CamZoom;
                
                float newCamZoom = _touchCamera.CamZoom - zoomAmount;
                if (zoomAmount > 0)
                {
                    GameEntry.Event.Fire(EventId.OnTouchPinchCameraNear);
                }
                else if (zoomAmount < 0)
                {
                    GameEntry.Event.Fire(EventId.OnTouchPinchCameraFar);
                }
                newCamZoom = Mathf.Clamp(newCamZoom, _touchCamera.CamZoomMin, _touchCamera.CamZoomMax);
                _touchCamera.CamZoom = newCamZoom;
                return true;
            }
#endif
            return false;
        }
    }
}