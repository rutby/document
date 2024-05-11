using UnityEngine;

namespace BitBenderGames.CameraState
{
    public class CameraStateFollow : CameraStateBase
    {
        public GameObject _leaderObj;
        public float _moveToLeaderTime;
        
        private float _animTime;
        
        public CameraStateFollow(MobileTouchCamera touchCamera) : base(touchCamera)
        {
        }

        public override void OnEnter()
        {
            _animTime = 0;
        }

        public void Reset()
        {
            _animTime = 0;
        }

        public override void OnUpdate()
        {
            if (_leaderObj == null)
            {
                _touchCamera.SetState(MobileTouchCamera.State.FreeLook);
                return;
            }
            
            if (_animTime <= _moveToLeaderTime)
            {
                _animTime += Time.deltaTime;
                var startPos = _touchCamera.GetCameraPos();
                var target = _touchCamera.AdjustTarget(_leaderObj.transform.position);
                var endPos = startPos + (target - _touchCamera.GetCameraTargetPos());
                var pos = Vector3.Lerp(startPos, endPos, _animTime / _moveToLeaderTime);
                _touchCamera.SetCameraPos(pos);
            }
            else
            {
                _touchCamera.LookAt(_leaderObj.transform.position);
            }
        }

        public override void OnLeave()
        {
            _leaderObj = null;
        }
    }
}