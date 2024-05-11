namespace BitBenderGames.CameraState
{
    public abstract class CameraStateBase
    {
        protected MobileTouchCamera _touchCamera;

        public CameraStateBase(MobileTouchCamera touchCamera)
        {
            this._touchCamera = touchCamera;
        }
        
        public abstract void OnEnter();
        public abstract void OnUpdate();
        public abstract void OnLeave();
    }
}