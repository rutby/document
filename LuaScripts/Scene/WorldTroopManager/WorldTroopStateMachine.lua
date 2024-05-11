---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 下午2:13
---
local Const = require"Scene.WorldTroopManager.Const"
local WorldTroopStateIdle = require ("Scene.WorldTroopManager.TroopState.WorldTroopStateIdle")
local WorldTroopStateMove = require("Scene.WorldTroopManager.TroopState.WorldTroopStateMove")
local WorldTroopStateAttack = require("Scene.WorldTroopManager.TroopState.WorldTroopStateAttack")
local WorldTroopStateStartAttack = require("Scene.WorldTroopManager.TroopState.WorldTroopStateStartAttack")
local WorldTroopStateEndAttack = require("Scene.WorldTroopManager.TroopState.WorldTroopStateEndAttack")
local WorldTroopStateDeath = require("Scene.WorldTroopManager.TroopState.WorldTroopStateDeath")
local WorldTroopStatePickGarbageMovetoGarbage = require("Scene.WorldTroopManager.TroopState.WorldTroopStatePickGarbageMovetoGarbage")
local WorldTroopStatePickingGarbage = require("Scene.WorldTroopManager.TroopState.WorldTroopStatePickingGarbage")
local WorldTroopStatePickGarbageSuccess = require("Scene.WorldTroopManager.TroopState.WorldTroopStatePickGarbageSuccess")
local WorldTroopStatePickGarbageLeaveGarbage = require("Scene.WorldTroopManager.TroopState.WorldTroopStatePickGarbageLeaveGarbage")
local WorldTroopAttackBuild = require("Scene.WorldTroopManager.TroopState.WorldTroopAttackBuild")
local WorldTroopTransBack = require("Scene.WorldTroopManager.TroopState.WorldTroopTransBack")

local WorldTroopStateMachine = BaseClass("WorldTroopStateMachine")
function WorldTroopStateMachine:__init()

end

function WorldTroopStateMachine:__delete()
end
function WorldTroopStateMachine:__initState(worldTroop)
    self.worldTroop =worldTroop
    self.currStateType = Const.WorldTroopState.None
    self.curState = WorldTroopStateBase.New(worldTroop,self)
    self.state = {}
    self.state[Const.WorldTroopState.None] = self.curState
    self.state[Const.WorldTroopState.Idle] = WorldTroopStateIdle.New(worldTroop,self)
    self.state[Const.WorldTroopState.Move] = WorldTroopStateMove.New(worldTroop,self)
    self.state[Const.WorldTroopState.Attack] = WorldTroopStateAttack.New(worldTroop,self)
    self.state[Const.WorldTroopState.AttackBegin] = WorldTroopStateStartAttack.New(worldTroop,self)
    self.state[Const.WorldTroopState.AttackEnd] = WorldTroopStateEndAttack.New(worldTroop,self)
    self.state[Const.WorldTroopState.Death] = WorldTroopStateDeath.New(worldTroop,self)
    self.state[Const.WorldTroopState.PickGarbageMovetoGarbage] = WorldTroopStatePickGarbageMovetoGarbage.New(worldTroop,self)
    self.state[Const.WorldTroopState.PickingGarbage] = WorldTroopStatePickingGarbage.New(worldTroop,self)
    self.state[Const.WorldTroopState.PickGarbageSuccess] = WorldTroopStatePickGarbageSuccess.New(worldTroop,self)
    self.state[Const.WorldTroopState.PickGarbageLeaveGarbage] = WorldTroopStatePickGarbageLeaveGarbage.New(worldTroop,self)
    self.state[Const.WorldTroopState.AttackBuild] = WorldTroopAttackBuild.New(worldTroop,self)
    self.state[Const.WorldTroopState.TransPortBackHome] = WorldTroopTransBack.New(worldTroop,self)
end
function WorldTroopStateMachine:GetCurrentState()
    return self.currStateType
end
function WorldTroopStateMachine:ChangeState(stateType)
    if self.curState ==nil then
        return
    end
    if self.currStateType == stateType then
        return 
    end
    EventManager:GetInstance():Broadcast(EventId.CheckTroopStateIcon,self.worldTroop:GetMarchUUID())
    local state = self.state[stateType]
    if state ~=nil then
        self.curState:OnStateLeave()
        self.curState = state
        self.currStateType = stateType
        self.curState:OnStateEnter()
    end
end
function WorldTroopStateMachine:OnUpdate()
    if self.curState~=nil then
        self.curState:OnStateUpdate()
    end
    
end
function WorldTroopStateMachine:OnTroopChange()
    if self.curState~=nil then
        self.curState:OnTroopChange()
    end
end
return WorldTroopStateMachine