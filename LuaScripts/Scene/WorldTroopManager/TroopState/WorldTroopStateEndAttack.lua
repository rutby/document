---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 下午2:21
---
local base = WorldTroopStateBase
local WorldTroopStateEndAttack = BaseClass("WorldTroopStateEndAttack",WorldTroopStateBase)
local Const = require"Scene.WorldTroopManager.Const"

function WorldTroopStateEndAttack:__init(worldTroop,stateMachine)
    base.__init(self,worldTroop,stateMachine)
end

function WorldTroopStateEndAttack:__delete()
    base.__delete(self)
end

function WorldTroopStateEndAttack:OnStateEnter()
    if self.worldTroop == nil then
        return
    end
    EventManager:GetInstance():Broadcast(EventId.HideTroopHead,self.worldTroop:GetMarchUUID())
    EventManager:GetInstance():Broadcast(EventId.ShowTroopName,self.worldTroop:GetMarchUUID())
    WorldTroopManager:GetInstance():UpdateListRemove(self.worldTroop:GetMarchUUID())
    self:OnTroopChange()
end

function WorldTroopStateEndAttack:OnStateLeave()

end

function WorldTroopStateEndAttack:OnStateUpdate()

end

function WorldTroopStateEndAttack:OnTroopChange()
    if self.worldTroop == nil then
        return
    end
    if self.worldTroop:GetMarchStatus() == MarchStatus.CHASING
            or self.worldTroop:GetMarchStatus() == MarchStatus.MOVING then
        self:ChangeState(Const.WorldTroopState.Move)
    elseif self.worldTroop:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
        self:ChangeState(Const.WorldTroopState.AttackBuild)
    elseif self.worldTroop:GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME then
        self:ChangeState(Const.WorldTroopState.TransPortBackHome)
    else
        self:ChangeState(Const.WorldTroopState.Idle)
    end
end



return WorldTroopStateEndAttack