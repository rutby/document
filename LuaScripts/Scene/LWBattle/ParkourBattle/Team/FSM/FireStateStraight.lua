

---开火状态 之 向正前方开火（跑酷）

local FORWARD=Vector3.New(0,0,25)

local FireStateStraight = BaseClass("FireStateStraight")
function FireStateStraight:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Member
end

function FireStateStraight:__delete()
    self.unit = nil
end

function FireStateStraight:OnEnter()
    self.unit:PlaySimpleAnim("attack_move")
end

function FireStateStraight:OnExit()
    self.unit.skillManager:Interrupt()
end

function FireStateStraight:OnUpdate()
    local skill=self.unit.skillManager:GetActiveSkillIgnoreRange()
    if skill then
        if skill:IsBuffSkill() then
            --buff型技能，不用瞄准、目标是个table
            self.unit.skillManager:ActiveCast(skill,skill:SearchTarget())
        else
            --追踪型子弹自动索敌，其他子弹瞄准准星
            local target = skill:SearchTargetAroundAimIgnoreRange(self.unit:GetPosition()+FORWARD)
            self.unit.skillManager:ActiveCast(skill,target)
        end
    end
end


return FireStateStraight