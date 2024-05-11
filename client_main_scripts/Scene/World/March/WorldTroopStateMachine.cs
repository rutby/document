
using System.Collections.Generic;

//
// 行军状态机
//

public enum WorldTroopState
{
    None = 0, // 无
    Idle = 1, // 空闲
    Move = 2, // 移动
    AttackBegin = 3, // 攻击开启
    Attack = 4,  // 攻击
    AttackEnd = 5,
    Death = 6, // 死亡
    // 捡垃圾相关
    PickGarbageMovetoGarbage = 7, // 小人走向目标点
    PickingGarbage = 8, // 捡垃圾
    PickGarbageSuccess = 9, // 捡垃圾成功
    PickGarbageFailed = 10, // 捡垃圾失败
    PickGarbageLeaveGarbage = 11, // 小人返回车子
    AttackBuild = 12,
    TransPortBackHome = 13,
}

public class WorldTroopStateMachine
{
    private Dictionary<WorldTroopState, WorldTroopStateBase> states = new Dictionary<WorldTroopState, WorldTroopStateBase>();
    private WorldTroopStateBase currState;
    private WorldTroop worldTroop;

    private WorldTroopState currStateType;
    public WorldTroopState CurrentStateType
    {
        get { return currStateType; }
    }

    public WorldTroopStateMachine(WorldTroop worldTroop)
    {
        this.worldTroop = worldTroop;
        currStateType = WorldTroopState.None;
        currState = new WorldTroopStateBase(worldTroop, this);
        
        states.Add(WorldTroopState.None, currState);
        states.Add(WorldTroopState.Idle, new WorldTroopStateIdle(worldTroop, this));
        states.Add(WorldTroopState.Move, new WorldTroopStateMove(worldTroop, this));
        states.Add(WorldTroopState.Attack, new WorldTroopStateAttack(worldTroop, this));
        states.Add(WorldTroopState.AttackBegin, new WorldTroopStateStartAttack(worldTroop, this));
        states.Add(WorldTroopState.AttackEnd, new WorldTroopStateEndAttack(worldTroop, this));
        states.Add(WorldTroopState.Death, new WorldTroopStateDeath(worldTroop, this));
        states.Add(WorldTroopState.PickGarbageMovetoGarbage, new WorldTroopStatePickGarbageMovetoGarbage(worldTroop, this));
        states.Add(WorldTroopState.PickingGarbage, new WorldTroopStatePickingGarbage(worldTroop, this));
        states.Add(WorldTroopState.PickGarbageSuccess, new WorldTroopStatePickGarbageSuccess(worldTroop, this));
        states.Add(WorldTroopState.PickGarbageLeaveGarbage, new WorldTroopStatePickGarbageLeaveGarbage(worldTroop, this));
        states.Add(WorldTroopState.AttackBuild, new WorldTroopAttackBuild(worldTroop, this));
        states.Add(WorldTroopState.TransPortBackHome, new WorldTroopTransBack(worldTroop, this));
    }
    public WorldTroopState GetCurrentState()
    {
        return currStateType;
    }
    public WorldTroopStateBase GetState(WorldTroopState stateType)
    {
        WorldTroopStateBase state;
        if (states.TryGetValue(stateType, out state))
            return state;
        return null;
    }

    public void ChangeState(WorldTroopState stateType)
    {
        if (currStateType == stateType)
            return;
        GameEntry.Event.Fire(EventId.CheckTroopStateIcon, worldTroop.GetMarchUUID());
        WorldTroopStateBase state;
        if (!states.TryGetValue(stateType, out state))
            return;
        // Log.Debug($"ChangeBehaviour {currStateType} -> {stateType}");
        currState.OnStateLeave();
        currState = state;
        currStateType = stateType;
        currState.OnStateEnter();
    }
    
    public void OnUpdate(float deltaTime)
    {
        currState.OnStateUpdate(deltaTime);
    }
}