

---
--- 开火状态之 自动开火(小兵专用）
---
---@class Scene.LWBattle.Skirmish.UnitFSM.FireStateAuto
local FireStateAuto = BaseClass("FireStateAuto")
local speed=Vector3.zero

---@param unit Scene.LWBattle.Skirmish.Unit.SkirmishUnit
function FireStateAuto:__init(unit)
    self.unit = unit---@type Scene.LWBattle.Skirmish.Unit.SkirmishUnit
end

function FireStateAuto:__delete()
    self.unit = nil
    self.skill = nil
    self.bulletMeta = nil
    if self.bulletEffectReq then
        self.bulletEffectReq:Destroy()
        self.bulletEffectReq = nil
        self.bulletTransform = nil
    end
end

function FireStateAuto:OnEnter(curCD,maxCD,skillMeta)
    self.curCD = curCD
    self.maxCD = maxCD
    self.skillMeta = skillMeta
    self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.skillMeta.bullet)
    if self.skillMeta.skill_effect>0 then--有些技能，例如光环，没有特效
        self.effectMeta = DataCenter.PveSkillEffectTemplateManager:GetTemplate(self.skillMeta.skill_effect)
    end
    if self.effectMeta then
        self.meta_fire_delay = self.effectMeta.fire_delay
    else
        self.meta_fire_delay = 0
    end
    self.realFireDelay = -1
    self.duration = -1
end

function FireStateAuto:OnExit()
    self.skillMeta = nil
    self.bulletMeta = nil
    if self.bulletEffectReq then
        self.bulletEffectReq:Destroy()
        self.bulletEffectReq = nil
        self.bulletTransform = nil
    end
end

function FireStateAuto:OnUpdate()
    if self.curCD>=0 then
        self.curCD = self.curCD - Time.deltaTime
        if self.curCD<0 then
            if self.unit:IsMoving() then
                self.unit:CrossFadeSimpleAnim(AnimName.AttackMove,1,0.2)
            else
                self.unit:CrossFadeSimpleAnim(AnimName.Attack,self.animSpeed,0.2)
            end
            self.realFireDelay = self.meta_fire_delay
            self.curCD = self.maxCD
        end
    end


    if self.realFireDelay>=0 then
        self.realFireDelay = self.realFireDelay - Time.deltaTime
        if self.realFireDelay<0 then
            if not self.bulletEffectReq then
                self.bulletEffectReq = CS.GameEntry.Resource:InstantiateAsync(self.bulletMeta.bullet_effect)
                self.bulletEffectReq:completed('+', function(req)
                    if req.gameObject then
                        self.bulletTransform=req.gameObject.transform
                        self:InitBulletEffect()
                    else
                        Logger.LogError("资源找不到！请检查路径！"..self.bulletMeta.bullet_effect)
                    end
                end)
            else
                self:InitBulletEffect()
            end
        end
    end

    if self.bulletTransform and self.duration>=0 then
        speed.z = self.bulletMeta.bullet_fly_speed * Time.deltaTime
        self.bulletTransform:Translate(speed)
        self.duration = self.duration - Time.deltaTime
        if self.duration<0 then
            self.bulletTransform.gameObject:SetActive(false)
            self.bulletTransform.position = self.unit:GetFirePoint().position
            if self.unit:IsMoving() then
                self.unit:CrossFadeSimpleAnim(AnimName.Run,1,0.2)
            else
                self.unit:CrossFadeSimpleAnim(AnimName.Idle,1,0.2)
            end
        end
    end
end



function FireStateAuto:InitBulletEffect()
    if IsNull(self.bulletTransform) then
        return
    end
    self.bulletTransform.gameObject:SetActive(true)
    local startPos = self.unit:GetFirePoint().position
    self.bulletTransform.position = startPos
    --self.bulletPos = Vector3.New(startPos.x,startPos.y,startPos.z)
    local targetPos = self.unit.logic:GetRandomTargetPos(self.unit.platoon.army.index)
    self.bulletTransform:LookAt(targetPos)
    local displace=Vector3.New(targetPos.x-startPos.x,0,targetPos.z-startPos.z)
    local distance=displace:Magnitude()
    if self.bulletMeta.bullet_fly_speed==0 then
        self.duration = 1
    else
        self.duration = distance / self.bulletMeta.bullet_fly_speed
    end
    
end


return FireStateAuto