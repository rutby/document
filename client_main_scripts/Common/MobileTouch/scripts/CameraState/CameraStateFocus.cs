using System;
using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateFocus : CameraStateBase
    {
        private MobileTouchCameraDragMove _dragMove;
        private bool _inputDonwOnUI = false;

        public Vector3 _target;
        public float _time;
        public float _zoom;
        public float _rotation;
        public AnimationCurve _lerpCurve;
        public bool _focusToCenter;
        public bool _lockView;
        public Action _onComplete;
        
        private Vector3 _startPos;
        private Vector3 _endPos;
        private Quaternion _startRotation;
        private Quaternion _endRotation;
        private const int AnimFocus = 0;
        private const int AnimEnd = 1;
        private int _anim;
        private float _animTime;
        
        public CameraStateFocus(MobileTouchCamera touchCamera) : base(touchCamera)
        {
            _dragMove = new MobileTouchCameraDragMove(touchCamera);
        }

        public override void OnEnter()
        {
            _touchCamera.touchInput.OnFingerDown += OnFingerDown;
            _touchCamera.touchInput.OnDragStart += OnDragStart;
            _touchCamera.touchInput.OnDragUpdate += OnDragUpdate;
            _touchCamera.touchInput.OnDragStop += OnDragStop;
            
            _startRotation = _touchCamera.GetRotation();
            _endRotation = Quaternion.Euler(_rotation, 0, 0);
            
            _startPos = _touchCamera.GetCameraPos();
            _zoom = Mathf.Clamp(_zoom, _touchCamera.CamZoomMin, _touchCamera.CamZoomMax);

            if (_focusToCenter)
            {
                var targetForward = _endRotation * Vector3.forward;
                var rayOrigin = new Vector3(0, _zoom, 0);
                Vector3 camCenterIntersection = _touchCamera.GetIntersectionPoint(new Ray(rayOrigin, targetForward));
                _endPos = _target - targetForward * Vector3.Distance(rayOrigin, camCenterIntersection);
            }
            else
            {
                var screenPos = _touchCamera.WorldToScreenPoint(_target);
                var oldPos = _touchCamera.GetCameraPos();
                var oldRot = _touchCamera.GetRotation();
                var rayOrigin = new Vector3(0, _zoom, 0);
                
                _touchCamera.SetCameraPos(rayOrigin);
                _touchCamera.SetRotation(_endRotation);
                var targetRay = _touchCamera.ScreenPointToRay(screenPos);
                _touchCamera.SetCameraPos(oldPos);
                _touchCamera.SetRotation(oldRot);
            
                Vector3 camCenterIntersection = _touchCamera.GetIntersectionPoint(targetRay);
                _endPos = _target - targetRay.direction * Vector3.Distance(rayOrigin, camCenterIntersection);
            }

            _anim = AnimFocus;
            _animTime = 0;
            
            _dragMove.Reset();
        }

        public override void OnUpdate()
        {
            if (_anim == AnimFocus)
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
                    _anim = AnimEnd;
                    _onComplete?.Invoke();
                }
            }
            else if (_anim == AnimEnd)
            {
                _dragMove.UpdatePosition(Time.deltaTime);
                _dragMove.UpdateAutoScroll();
            }
        }

        public override void OnLeave()
        {
            _touchCamera.touchInput.OnFingerDown -= OnFingerDown;
            _touchCamera.touchInput.OnDragStart -= OnDragStart;
            _touchCamera.touchInput.OnDragUpdate -= OnDragUpdate;
            _touchCamera.touchInput.OnDragStop -= OnDragStop;
            _onComplete = null;
        }
        
        private void OnFingerDown(Vector3 pos)
        {
            _inputDonwOnUI = _touchCamera.InputDonwOnUI(pos);
            _dragMove.OnFingerDown();
        }
        
        private void OnDragStart(Vector3 dragPosStart, bool isLongTap)
        {
            if (_touchCamera.CanMoveing && !_inputDonwOnUI && !_lockView)
            {
                _dragMove.OnDragStart(dragPosStart);
            }
        }

        private void OnDragUpdate(Vector3 dragPosStart, Vector3 dragPosCurrent, Vector3 correctionOffset)
        {
            if (_touchCamera.CanMoveing && !_inputDonwOnUI && !_lockView)
            {
                _dragMove.OnDragUpdate(dragPosStart, dragPosCurrent, correctionOffset);
            }
        }

        private void OnDragStop(Vector3 dragStopPos, Vector3 dragFinalMomentum)
        {
            _dragMove.OnDragStop();
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