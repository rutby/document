

---
--- 开火状态之 死亡
---
---@class Scene.LWBattle.Skirmish.UnitFSM.FireStateDie
local FireStateDie = BaseClass("FireStateDie")


---@param unit Scene.LWBattle.Skirmish.Unit.SkirmishUnit
function FireStateDie:__init(unit)
    self.unit = unit---@type Scene.LWBattle.Skirmish.Unit.SkirmishUnit
    self.animLength = self.unit:GetAnimLength(MemberAnim.Dead)
    self.animLength = self.animLength>0 and self.animLength or 2
end

function FireStateDie:__delete()
    self.unit = nil
end

function FireStateDie:OnEnter()
    self.unit:RewindAndPlaySimpleAnim(MemberAnim.Dead)
    self.unit.transform:SetParent(nil)
    self.timer = self.animLength
end

function FireStateDie:OnExit()

end

function FireStateDie:OnUpdate()
    if self.timer>=0 then
        self.timer = self.timer - Time.deltaTime
        if self.timer<0 then
            if self.unit.unitType==UnitType.Member or self.unit.unitType==UnitType.Zombie then
                self.unit.logic:ShowEffectObj("Assets/Main/Prefabs/PVE/Obj_A_build_th_mb.prefab"
                ,self.unit:GetPosition(),nil,-1)
            end
            self.unit:ShowOrHide(false)
            if self.unit.hpBar then
                self.unit.hpBar:SetActive(false)
            end
            --self.unit.logic:RemoveUnit(self.unit)
        end
    end
end




return FireStateDie