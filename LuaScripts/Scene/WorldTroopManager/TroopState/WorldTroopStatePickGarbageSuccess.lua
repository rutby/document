---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 下午2:22
---
local base = WorldTroopStateBase
local WorldTroopStatePickGarbageSuccess = BaseClass("WorldTroopStatePickGarbageSuccess",WorldTroopStateBase)
local Const = require"Scene.WorldTroopManager.Const"
local TotalTime = 0.6
function WorldTroopStatePickGarbageSuccess:__init(worldTroop,stateMachine)
    base.__init(self,worldTroop,stateMachine)
end

function  WorldTroopStatePickGarbageSuccess:__delete()
    base.__delete(self)
end
function WorldTroopStatePickGarbageSuccess:OnStateEnter()
    if self.worldTroop == nil then
        return
    end
    self.worldTroop:PlayAnim(Const.WorldTroopAnim.Anim_Hit)
    self.worldTroop:TroopUnitPickSuccess()
    self.startTime = Time.realtimeSinceStartup
    WorldTroopManager:GetInstance():AddToUpdateList(self.worldTroop:GetMarchUUID())
end

function WorldTroopStatePickGarbageSuccess:OnStateLeave()

end

function WorldTroopStatePickGarbageSuccess:OnStateUpdate()
    if Time.realtimeSinceStartup-self.startTime >TotalTime then
        self:ChangeState(Const.WorldTroopState.PickGarbageLeaveGarbage)
    end
end




return WorldTroopStatePickGarbageSuccess