



---
--- Pve 丧尸硬控状态：包含硬直、受伤、眩晕
---此状态下丧尸不可以攻击、不可以移动
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl
local ZombieStateHardControl = BaseClass("ZombieStateHardControl")


function ZombieStateHardControl:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Zombie
    self.controlTime = 0
    self.isStiff = nil
end

function ZombieStateHardControl:__delete()
    self.unit = nil
    self.controlTime = 0
    self.isStiff = nil
end

function ZombieStateHardControl:OnEnter(type,time)
    self.controlTime = time
    self.isStiff = false
    if type==HardControlType.Stiff then
        --if self.unit.agent then
        --    self.unit.agent.speed = 0--暂停移动
        --end
        if self.unit.anim then
            self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(),0)--暂停动画
        end
        self.isStiff = true
    elseif type==HardControlType.Stun then
        self.unit:PlaySimpleAnim(AnimName.Stun,1)
    elseif type==HardControlType.Hurt then
        self.unit:PlaySimpleAnim(AnimName.Hurt,1)
    elseif type==HardControlType.Imprison then
        
    end

end

--被控时再次被控，则延长持续时间
function ZombieStateHardControl:OnTransToSelf(type,time)
    self.controlTime = math.max(self.controlTime,time)
end


function ZombieStateHardControl:OnExit()
    if self.isStiff then
        --if self.unit.agent then
        --    self.unit.agent.speed = self.unit.meta.move_speed
        --end
        if self.unit.anim then
            self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(),1)
        end
        self.isStiff = false
    end
end

function ZombieStateHardControl:OnUpdate()
    self.controlTime=self.controlTime-Time.deltaTime
    if self.controlTime<=0 then
        self.unit.fsm:ChangeState(ZombieState.Idle)
    end
end

return ZombieStateHardControl