using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateIdle : CameraStateBase
    {
        public CameraStateIdle(MobileTouchCamera touchCamera) : base(touchCamera)
        {
        }

        public override void OnEnter()
        {
            _touchCamera.touchInput.OnFingerDown += OnFingerDown;
            _touchCamera.touchInput.OnPinchStart += OnPinchStart;
        }

        public override void OnUpdate()
        {
            #if UNITY_EDITOR || UNITY_STANDALONE
            float mouseScrollDelta = Input.GetAxis("Mouse ScrollWheel");
            if (!Mathf.Approximately(mouseScrollDelta, 0))
            {
                OnFingerDown(Input.mousePosition);
            }
            #endif
        }

        public override void OnLeave()
        {
            _touchCamera.touchInput.OnFingerDown -= OnFingerDown;
            _touchCamera.touchInput.OnPinchStart -= OnPinchStart;
        }
        
        private void OnFingerDown(Vector3 pos)
        {
            if (!_touchCamera.InputDonwOnUI(pos))
            {
                _touchCamera.SetState(MobileTouchCamera.State.FreeLook);
            }
        }

        private void OnPinchStart(Vector3 pinchCenter, float pinchDistance)
        {
            if (!_touchCamera.InputDonwOnUI(pinchCenter))
            {
                _touchCamera.SetState(MobileTouchCamera.State.FreeLook);
                var freeLookState = _touchCamera.GetState(MobileTouchCamera.State.FreeLook) as CameraStateFreeLook;
                freeLookState.OnPinchStart(pinchCenter, pinchDistance);
            }
        }
    }
}