---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 下午2:22
---
local base = WorldTroopStateBase
local WorldTroopStateDeath = BaseClass("WorldTroopStateDeath",WorldTroopStateBase)
local Const = require"Scene.WorldTroopManager.Const"

function WorldTroopStateDeath:__init(worldTroop,stateMachine)
    base.__init(self,worldTroop,stateMachine)
end

function WorldTroopStateDeath:__delete()
    base.__delete(self)
end

function WorldTroopStateDeath:OnStateEnter()
    if self.worldTroop == nil then
        return
    end
    --self.targetPos = self.worldTroop:GetMarchTargetPos()
    --self.worldTroop:SetRotation(Quaternion.LookRotation(self.worldTroop:GetDefenderPosition() - self.worldTroop:GetPosition()))
    self.worldTroop:PlayAnim(Const.WorldTroopAnim.Anim_Death)
    WorldTroopManager:GetInstance():UpdateListRemove(self.worldTroop:GetMarchUUID())
end



return WorldTroopStateDeath