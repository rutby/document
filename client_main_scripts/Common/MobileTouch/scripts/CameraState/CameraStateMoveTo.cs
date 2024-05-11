using System;
using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateMoveTo : CameraStateBase
    {
        public Vector3 _target;
        public float _time;
        public float _zoom;
        public Action _onComplete;
        public MoveType _moveType;

        public enum MoveType
        {
            ZoomOnly, MoveAndZoom
        }

        private Quaternion _startRot;
        private Quaternion _endRot;
        private Vector3 _startPos;
        private Vector3 _endPos;
        private float _startZoom;
        private float _endZoom;
        
        private int _anim;
        private float _animTime;
        private FocusCurveStruct _curve;
        
        public CameraStateMoveTo(MobileTouchCamera touchCamera) : base(touchCamera)
        {
            _curve = new FocusCurveStruct();
        }
        
        public override void OnEnter()
        {
            Refresh();
        }

        public override void OnUpdate()
        {
            _animTime += Time.deltaTime;
            if (_animTime <= _time)
            {
                LoadCurve();
                var t = _animTime / _time;
                if (_curve.focusCurve != null)
                {
                    t = _curve.focusCurve.enterCurve.Evaluate(t);
                }
                if (_moveType == MoveType.MoveAndZoom)
                {
                    _touchCamera.SetCameraPos(Vector3.Lerp(_startPos, _endPos, t));
                    _touchCamera.SetRotation(Quaternion.Lerp(_startRot, _endRot, t));
                }
                else if (_moveType == MoveType.ZoomOnly)
                {
                    _touchCamera.CamZoom = Mathf.Lerp(_startZoom, _endZoom, t);
                }
            }
            else
            {
                if (_moveType == MoveType.MoveAndZoom)
                {
                    _touchCamera.SetCameraPos(_endPos);
                    _touchCamera.SetRotation(_endRot);
                }
                else if (_moveType == MoveType.ZoomOnly)
                {
                    _touchCamera.CamZoom = _endZoom;
                }
                _touchCamera.SetState(MobileTouchCamera.State.Idle);
            }
        }

        public override void OnLeave()
        {
            var complete = _onComplete;
            _onComplete = null;
            complete?.Invoke();
        }

        public void Refresh()
        {
            _zoom = Mathf.Clamp(_zoom, _touchCamera.CamZoomMin, _touchCamera.CamZoomMax);
            _touchCamera.CalcZoom(_zoom, _touchCamera.GetCameraPos(), out var outPos, out var outRot);

            if (_moveType == MoveType.MoveAndZoom)
            {
                _startRot = _touchCamera.GetRotation();
                _endRot = outRot;
                _startPos = _touchCamera.GetCameraPos();
                _endPos = outPos + (_target - _touchCamera.GetCameraTargetPos());
            }
            else if (_moveType == MoveType.ZoomOnly)
            {
                _startZoom = _touchCamera.CamZoom;
                _endZoom = _zoom;
            }

            _animTime = 0;
        }
        
        private void LoadCurve()
        {
            if (_curve.instanceRequest == null)
            {
                _curve.instanceRequest =
                    GameEntry.Resource.InstantiateAsync("Assets/Main/Prefabs/World/CameraMoveCurve.prefab");
                _curve.instanceRequest.completed += delegate
                {
                    var gameObject = _curve.instanceRequest.gameObject;
                    if (gameObject != null)
                    {
                        _curve.focusCurve = gameObject.GetComponent<FocusCurve>();
                    }
                };
            }
        }
        private void DestroyCurve()
        {
            if (_curve.instanceRequest != null)
            {
                _curve.instanceRequest.Destroy();
                _curve.instanceRequest = null;
                _curve.focusCurve = null;
            }
        }
    }
}