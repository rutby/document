

local ZombieCommonAI = require "Scene.LWBattle.AI.ZombieCommonAI"

---
--- Pve 丧尸攻击状态
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateAttack
local ZombieStateAttack = BaseClass("ZombieStateAttack")


function ZombieStateAttack:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Zombie
    self.ai=ZombieCommonAI.New(self.unit)---@type Scene.LWBattle.AI.ZombieCommonAI
end

function ZombieStateAttack:__delete()
    self.unit = nil
end

function ZombieStateAttack:OnEnter(skill,target)
    self.unit.skillManager:ActiveCast(skill,target)
end

function ZombieStateAttack:OnExit()
    self.unit.skillManager:Interrupt()
    self.nextSkill = nil
    self.target = nil
end

function ZombieStateAttack:OnUpdate()
    
    --施法动画没有播放
    if not self.unit.skillManager:GetCastingSkill() then
        if self.unit:GetCurAnimName()~=AnimName.Aim then
            --self.unit:CrossFadeSimpleAnim(AnimName.Aim,nil,0.2)
            self.unit:PlaySimpleAnim(AnimName.Aim)
        end
        if self.nextSkill then
            if self.target and self.target:GetCurBlood()>0 then
                if self.nextSkill:IsTargetInRange(self.target) then--检查武器是否指向目标
                    self.unit.skillManager:ActiveCast(self.nextSkill,self.target)
                    self.nextSkill = nil
                else
                    self.unit.fsm:ChangeState(ZombieState.Run)
                end
            else
                self.target=self.ai:GetTarget(self.nextSkill)
            end
        else
            self.nextSkill=self.unit.skillManager:GetActiveSkillIgnoreRange()
            if self.nextSkill then
                if self.nextSkill:IsBuffSkill() then--buff类技能没有瞄准阶段，直接释放（甚至可以无目标释放）
                    self.unit.skillManager:ActiveCast(self.nextSkill,self.ai:GetTarget(self.nextSkill))
                    self.nextSkill = nil
                else
                    self.target=self.ai:GetTarget(self.nextSkill)
                end
            else
                --没有技能可用时，回到idle状态
                self.unit.fsm:ChangeState(ZombieState.Idle)
            end
        end
    end
end


return ZombieStateAttack