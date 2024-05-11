using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateFreeLook : CameraStateBase
    {
        private MobileTouchCameraDragMove _dragMove;
        private MobileTouchCameraPinchZoom _pinchZoom;
        private bool _isPinch = false;//是否是缩放操作
        
        public CameraStateFreeLook(MobileTouchCamera touchCamera) : base(touchCamera)
        {
            _dragMove = new MobileTouchCameraDragMove(touchCamera);
            _pinchZoom = new MobileTouchCameraPinchZoom(touchCamera);
        }

        public override void OnEnter()
        {
            _touchCamera.touchInput.OnFingerDown += OnFingerDown;
            _touchCamera.touchInput.OnDragStart += OnDragStart;
            _touchCamera.touchInput.OnDragUpdate += OnDragUpdate;
            _touchCamera.touchInput.OnDragStop += OnDragStop;
            _touchCamera.touchInput.OnPinchStart += OnPinchStart;
            _touchCamera.touchInput.OnPinchUpdateExtended += OnPinchUpdate;
            _touchCamera.touchInput.OnPinchStop += OnPinchStop;
            _dragMove.Reset();
            _isPinch = false;
        }

        public override void OnUpdate()
        {
            bool move = false, zoom = false;
            bool scrollWhell = false;
#if UNITY_EDITOR || UNITY_STANDALONE
            float mouseScrollDelta = Input.GetAxis("Mouse ScrollWheel");
            if (!Mathf.Approximately(mouseScrollDelta, 0))
            {
                scrollWhell = true;
                _isPinch = true;
                _dragMove.StopCameraScroll();
            }
#endif
            if (_touchCamera.CanMoveing)
            {
                _dragMove.UpdatePosition(Time.deltaTime);
                //改成一旦玩家开始缩放就不自动移动
                if (_touchCamera.IsInClamp == false)
                {
                    if (!_isPinch)
                    {
                        move = _dragMove.UpdateAutoScroll();
                    }
                    else
                    {
                        _dragMove.StopCameraScroll();
                    }
                }
                zoom = _pinchZoom.UpdatePinch();
            }

            if (TouchWrapper.TouchCount == 0 && !scrollWhell && !move && !zoom)
            {
                _touchCamera.SetState(MobileTouchCamera.State.Idle);
            }
        }

        public override void OnLeave()
        {
            _touchCamera.touchInput.OnFingerDown -= OnFingerDown;
            _touchCamera.touchInput.OnDragStart -= OnDragStart;
            _touchCamera.touchInput.OnDragUpdate -= OnDragUpdate;
            _touchCamera.touchInput.OnDragStop -= OnDragStop;
            _touchCamera.touchInput.OnPinchStart -= OnPinchStart;
            _touchCamera.touchInput.OnPinchUpdateExtended -= OnPinchUpdate;
            _touchCamera.touchInput.OnPinchStop -= OnPinchStop;
        }

        private void OnFingerDown(Vector3 pos)
        {
            _dragMove.OnFingerDown();
        }

        private void OnDragStart(Vector3 dragPosStart, bool isLongTap)
        {
            _dragMove.OnDragStart(dragPosStart);
        }

        private void OnDragUpdate(Vector3 dragPosStart, Vector3 dragPosCurrent, Vector3 correctionOffset)
        {
            if (_touchCamera.CanMoveing)
            {
                _dragMove.OnDragUpdate(dragPosStart, dragPosCurrent, correctionOffset);
            }
        }

        private void OnDragStop(Vector3 dragStopPos, Vector3 dragFinalMomentum)
        {
            _dragMove.OnDragStop();
        }

        public void OnPinchStart(Vector3 pinchCenter, float pinchDistance)
        {
            if (!_touchCamera.CanMoveing)
                return;
            _isPinch = true;
            _dragMove.StopCameraScroll();
            _pinchZoom.OnPinchStart(pinchCenter, pinchDistance);
        }

        private void OnPinchUpdate(PinchUpdateData pinchUpdateData)
        {
            if (!_touchCamera.CanMoveing)
                return;
            _pinchZoom.OnPinchUpdate(pinchUpdateData);
        }

        private void OnPinchStop()
        {
            if (!_touchCamera.CanMoveing)
                return;
            _pinchZoom.OnPinchStop();
        }
    }
}