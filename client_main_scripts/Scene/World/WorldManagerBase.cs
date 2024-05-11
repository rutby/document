public abstract class WorldManagerBase
{
    protected WorldScene world;

    public WorldManagerBase(WorldScene scene)
    {
        this.world = scene;
    }

    public virtual void Init()
    {
    }

    public virtual void UnInit()
    {
    }

    public virtual void OnUpdate(float deltaTime)
    {
    }
}