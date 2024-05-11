---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2022/9/22 15:20
---
local CharacterStateManager = BaseClass("CharacterStateManager")
local CharacterStateType = require("Scene.PVEBattleLevel.Character.State.CharacterStateType")
--人物的总状态机注册表，主要新添加了状态机就要写到这里面，要不然会执行不到
local StateMap =
{
    [CharacterStateType.Default] = "Scene.PVEBattleLevel.Character.State.CharacterDefaultState",
    [CharacterStateType.Attack] = "Scene.PVEBattleLevel.Character.State.CharacterAttackState",
    [CharacterStateType.Move] = "Scene.PVEBattleLevel.Character.State.CharacterMoveState",
    [CharacterStateType.MoveByPath] = "Scene.PVEBattleLevel.Character.State.CharacterMovePathState",
    [CharacterStateType.Die] = "Scene.PVEBattleLevel.Character.State.CharacterDeadState",
    [CharacterStateType.Collect] = "Scene.PVEBattleLevel.Character.State.CharacterCollectState",
    [CharacterStateType.InertialIdle] = "Scene.PVEBattleLevel.Character.State.CharacterInertialIdleState",
    [CharacterStateType.Skill] = "Scene.PVEBattleLevel.Character.State.CharacterSkillState",
    [CharacterStateType.StrideOver] = "Scene.PVEBattleLevel.Character.State.CharacterStrideOverState",
    [CharacterStateType.BeHit] = "Scene.PVEBattleLevel.Character.State.CharacterBeHitState",
    [CharacterStateType.Build] = "Scene.PVEBattleLevel.Character.State.CharacterBuildState",
    [CharacterStateType.Shower] = "Scene.PVEBattleLevel.Character.State.CharacterShowerState",
    [CharacterStateType.PeeOrStool] = "Scene.PVEBattleLevel.Character.State.CharacterPeeOrStoolState",
    [CharacterStateType.UseItemAction] = "Scene.PVEBattleLevel.Character.State.CharacterUseActionItem",
    [CharacterStateType.StandUp] = "Scene.PVEBattleLevel.Character.State.CharacterStandUpState",
    [CharacterStateType.DoAnimation] = "Scene.PVEBattleLevel.Character.State.CharacterAniState",
    [CharacterStateType.Duck] = "Scene.PVEBattleLevel.Character.State.CharacterDuckState",
    [CharacterStateType.PickGarbage] = "Scene.PVEBattleLevel.Character.State.CharacterPickGarbageState",
    [CharacterStateType.ReportSkill] = "Scene.PVEBattleLevel.Character.State.CharacterReportSkillState"
}

function CharacterStateManager:__init(owner,completeHandler)
    self.m_owner = owner
    self.m_states = {}
    self.m_currentState = nil
    self.m_nextState = nil
    self.m_onStateComplete = completeHandler
    self.m_startDoNextStateCallback = BindCallback(self,self.__startDoNextState)
    self.m_doNextStateTimer = nil
end

function CharacterStateManager:OnUpdate(deltaTime)
    if self.m_currentState ~= nil then
        self.m_currentState:OnUpdate(deltaTime)
    end
end

function CharacterStateManager:SetState(type,data)
    --导致死不了，先注释掉
    --if self.m_owner.m_isPause == true and type ~= CharacterStateType.Default then
    --    return
    --end
    
    --当前有执行的状态机
    if self:__checkState(self.m_currentState,type,data) then
        return
    end

    self:ExitCurrentState()
    
    self:__setNextState(type,data)
end

function CharacterStateManager:__setNextState(type,data)
    if self:__checkState(self.m_nextState,type,data) then
        return
    end

    local state = self:__createState(type)
    if state == nil then
        Logger.LogError("not found state:" .. type)
        return
    end

    state:SetData(data)

    if self.m_nextState ~= nil then
        --下一个状态没有执行就被其他状态替换了，执行一下预备退出函数，执行一些逻辑
        --预备退出逻辑函数是状态机还没开始执行的情况
        self.m_nextState:PrepareStateExit()
    end

    self.m_nextState = state

    if self.m_doNextStateTimer == nil then
        self.m_doNextStateTimer = TimerManager:GetInstance():DelayInvoke(self.m_startDoNextStateCallback,0.01)--下一帧执行
    end
end

function CharacterStateManager:__startDoNextState()
    self.m_doNextStateTimer:Stop()
    self.m_doNextStateTimer = nil

    if self.m_nextState ~= nil then
        local state = self.m_nextState
        self.m_nextState = nil
        self.m_currentState = state
        self.m_currentState:OnEnter()
    else
        self.m_owner:DoDefaultState()
    end
end

function CharacterStateManager:__checkState(state, newType, newData)
    if state ~= nil then
        --相同类型，并且是唯一状态机，则直接赋值
        if state:GetType() == newType and state:IsOnly() then
            state:SetData(newData)
            return true
        end

        --是否允许打断
        if not state:AllowStopByType(newType) then
            return true
        end
    end
    
    return false
end

function CharacterStateManager:__createState(type)
    local state = self.m_states[type] --是否已有此类型状态机
    if state == nil then
        local stateClassPath = StateMap[type] 
        if not string.IsNullOrEmpty(stateClassPath) then
            local stateClass = require(stateClassPath)
            if stateClass ~= nil then
                state = stateClass.New(self.m_owner,type,function(stateType,data) self:OnStateComplete(stateType,data) end)
                self.m_states[type] = state
            end
        end
    end
    
    return state
end

function CharacterStateManager:OnStateComplete(type,data)
    if self.m_currentState ~= nil and self.m_currentState:GetType() == type then
        self:__clearCurrentState()
    end

    if self.m_onStateComplete ~= nil then
        self.m_onStateComplete(self.m_owner,type,data)
    end

    if self.m_nextState == nil and self.m_owner ~= nil and not self.m_owner:IsDie() then
        --self.m_owner:DoDefaultState()
    end
end

function CharacterStateManager:ChangeCharacterState()
    if self.m_currentState ~= nil then
        self.m_currentState:ChangeCharacterState()
    end
end

function CharacterStateManager:GetCurrentState()
    return self.m_currentState
end

function CharacterStateManager:GetCurrentStateType()
    if self.m_currentState ~= nil then
        return self.m_currentState:GetType()
    end
    return nil
end

function CharacterStateManager:GetNextStateType()
    if self.m_nextState ~= nil then
        return self.m_nextState:GetType()
    end
    return nil
end

--退出当前状态机
function CharacterStateManager:ExitCurrentState()
    if self.m_currentState ~= nil then
        self.m_currentState:OnExit()
        self:__clearCurrentState()
    end
end

function CharacterStateManager:__clearCurrentState()
    if self.m_currentState == nil then
        return
    end
    
    if not self.m_currentState:IsOnly() then
        self.m_currentState:Destroy()
        self.m_states[self.m_currentState:GetType()] = nil
    end
    self.m_currentState = nil
end

function CharacterStateManager:__destroyAllState()
    if self.m_states == nil then
        return
    end
    for _,v in pairs(self.m_states) do
        v:Destroy()
    end
    self.m_states = nil
end

function CharacterStateManager:__stopNextStateTimer()
    if self.m_doNextStateTimer ~= nil then
        self.m_doNextStateTimer:Stop()
        self.m_doNextStateTimer = nil
    end
end

function CharacterStateManager:Destroy()
    self:__destroyAllState()
    self:__stopNextStateTimer()
    self.m_owner = nil
    self.m_currentState = nil
    self.m_nextState = nil
    self.m_startDoNextStateCallback = nil
    self.m_onStateComplete = nil
end

return CharacterStateManager