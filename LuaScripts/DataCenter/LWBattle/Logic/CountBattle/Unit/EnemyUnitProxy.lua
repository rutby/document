local base = require "DataCenter.LWBattle.Logic.CountBattle.Unit.SteerUnitProxy"
local EnemyUnitProxy = {}
EnemyUnitProxy.__index = EnemyUnitProxy
setmetatable(EnemyUnitProxy, base)

local Resource = CS.GameEntry.Resource

function EnemyUnitProxy.Create(group, unit, cfg, visible)
    local copy = {}
    setmetatable(copy, EnemyUnitProxy)
    copy:Init(group, unit, cfg, visible)
    return copy
end

function EnemyUnitProxy:Init(group, unit, cfg, visible)
    base.Init(self, group, unit, cfg, visible)
end

function EnemyUnitProxy:OnResLoaded()
    base.OnResLoaded(self)
    self.onHitByBullet = function (dmg, hitPos, hitDir, showHitVfx)
        return self:OnHitByBullet(dmg, hitPos, hitDir, showHitVfx)
    end
    self.aimTarget = self.group.logic:RegisterAimTarget(CS.LW.CountBattle.Circle(self.unit.pos, 0, self.unit.radius), self.onHitByBullet)
end

function EnemyUnitProxy:Dispose()
    if self.aimTarget and self.group and self.group.logic then
        self.group.logic:UnregisterAimTarget(self.aimTarget.id)
    end
    if self.aimTarget then
        self.aimTarget.dead = true
    end
    self.aimTarget = nil

    self.onHitByBullet = nil
    base.Dispose(self)
end

function EnemyUnitProxy:OnDeadAnimPlaying()
    base.OnDeadAnimPlaying(self)

    if self.aimTarget and self.group and self.group.logic then
        self.group.logic:UnregisterAimTarget(self.aimTarget.id)
    end
    if self.aimTarget then
        self.aimTarget.dead = true
    end
    self.aimTarget = nil

    self.onHitByBullet = nil
end

function EnemyUnitProxy:OnUpdate(dt)
    base.OnUpdate(self, dt)
    if self.disposed or not self.transform then
        return
    end

    if not self.engaging and self.aimTarget then
        local x, _, z = self.transform:Get_position()
        self.aimTarget.shape:SetPos(x, z)
    end

    if self.engaging and not self.contact then
        local x, y, z = self.transform:Get_position()
        local srcPos = Vector3.New(x, y, z)
        local tarPos = Vector3.New(self.group.engagingGroup:GetPosX(), 0, self.group.engagingGroup:GetPosZ())
        local selfR = self.unit.radius
        local tarR = self.group.engagingGroup:GetRadius()
        local sqrDist = (srcPos - tarPos):Magnitude() - tarR
        if sqrDist <= selfR then
            self.contact = true
            self:OnContact()
        end
    end
end

function EnemyUnitProxy:OnContact()
end

function EnemyUnitProxy:OnMarch()
    base.OnMarch(self)
end

function EnemyUnitProxy:OnEngageBegin()
    base.OnEngageBegin(self)
    self.contact = false
end

function EnemyUnitProxy:OnEngageDone()
    base.OnEngageDone(self)
    self.contact = false
end

function EnemyUnitProxy:OnHitByBullet(dmg, hitPos, hitDir, showHitVfx)
    local dmgContext = {rawDmg=dmg, hitPos=hitPos, hitDir=hitDir, showHitVfx=showHitVfx} -- todo pool?
    self:Damage(dmgContext)
    return not dmgContext.abandon
end

function EnemyUnitProxy:OnHurt(dmgContext)
    if self.engaging then
        dmgContext.abandon = true
        return
    end
    self.group:OnNotice()
    local hpPercent = self.hp / self.cfg.maxHp
    local newPt = math.ceil(self.cfg.point * hpPercent)
    self.unit.point = newPt
end

function EnemyUnitProxy:OnDead()
    self.group.logic.killCount = self.group.logic.killCount + 1
    base.OnDead(self)
end

return EnemyUnitProxy