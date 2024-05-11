using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateQuitFocus : CameraStateBase
    {
        public Vector3 _target;
        public float _time;
        public bool _focusToCenter;
        // public MobileTouchCamera.State _nextState;

        private Vector3 _startPos;
        private Vector3 _endPos;
        private Quaternion _startRotation;
        private Quaternion _endRotation;
        private AnimationCurve _lerpCurve;
        private float _animTime;
        
        public CameraStateQuitFocus(MobileTouchCamera touchCamera) : base(touchCamera)
        {
        }

        public override void OnEnter()
        {
            _startRotation = _touchCamera.GetRotation();
            _endRotation = Quaternion.Euler(_touchCamera.CamZoomInitRotation, 0, 0);
            
            _startPos = _touchCamera.GetCameraPos();

            if (_focusToCenter)
            {
                var rayOrigin = new Vector3(0, _touchCamera.CamZoomInit, 0);
                var targetForward = _endRotation * Vector3.forward;
                Vector3 camCenterIntersection = _touchCamera.GetIntersectionPoint(new Ray(rayOrigin, targetForward));
                _endPos = _target - targetForward * Vector3.Distance(rayOrigin, camCenterIntersection);
            }
            else
            {
                var screenPos = _touchCamera.WorldToScreenPoint(_target);
                var oldPos = _touchCamera.GetCameraPos();
                var oldRot = _touchCamera.GetRotation();
                var rayOrigin = new Vector3(0, _touchCamera.CamZoomInit, 0);
                
                _touchCamera.SetCameraPos(rayOrigin);
                _touchCamera.SetRotation(_endRotation);
                var targetRay = _touchCamera.ScreenPointToRay(screenPos);
                _touchCamera.SetCameraPos(oldPos);
                _touchCamera.SetRotation(oldRot);
            
                Vector3 camCenterIntersection = _touchCamera.GetIntersectionPoint(targetRay);
                _endPos = _target - targetRay.direction * Vector3.Distance(rayOrigin, camCenterIntersection);
            }

            _lerpCurve = _touchCamera.CameraFocusCurve;
            
            _animTime = 0;
        }

        public override void OnUpdate()
        {
            _animTime += Time.deltaTime;
            if (_animTime <= _time)
            {
                var t = EvaluateLerpCurve(_animTime / _time);
                _touchCamera.SetCameraPos(Vector3.Lerp(_startPos, _endPos, t));
                _touchCamera.SetRotation(Quaternion.Lerp(_startRotation, _endRotation, t));
            }
            else
            {
                _touchCamera.SetCameraPos(_endPos);
                _touchCamera.SetRotation(_endRotation);
                _touchCamera.SetState(MobileTouchCamera.State.Idle);
            }
        }

        public override void OnLeave()
        {
            
        }
        
        private float EvaluateLerpCurve(float t)
        {
            if (_lerpCurve == null || _lerpCurve.length == 0)
            {
                return t;
            }
            return _lerpCurve.Evaluate(t);
        }
    }
}