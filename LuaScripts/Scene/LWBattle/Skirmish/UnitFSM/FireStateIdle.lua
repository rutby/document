

---
--- 开火状态之 停火
---
---@class Scene.LWBattle.Skirmish.UnitFSM.FireStateIdle
local FireStateIdle = BaseClass("FireStateIdle")


---@param unit Scene.LWBattle.Skirmish.Unit.SkirmishUnit
function FireStateIdle:__init(unit)
    self.unit = unit---@type Scene.LWBattle.Skirmish.Unit.SkirmishUnit
end

function FireStateIdle:__delete()
    self.unit = nil
end

function FireStateIdle:OnEnter()
    if self.unit:IsMoving() then
        self.unit:CrossFadeSimpleAnim(AnimName.Run,1,0.2)
        --self.unit:PlaySimpleAnim(AnimName.Run)
    else
        self.unit:CrossFadeSimpleAnim(AnimName.Idle,1,0.2)
        --self.unit:PlaySimpleAnim(AnimName.Idle)
    end
end

function FireStateIdle:OnExit()

end

function FireStateIdle:OnUpdate()

end



return FireStateIdle