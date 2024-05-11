local base = require "DataCenter.LWBattle.Logic.CountBattle.Unit.EnemyUnitProxy"
local ZombieUnitProxy = {}
ZombieUnitProxy.__index = ZombieUnitProxy
setmetatable(ZombieUnitProxy, base)

local VfxPool = require "DataCenter.LWBattle.Logic.CountBattle.Comp.VfxPool"

function ZombieUnitProxy.Create(group, unit, cfg, visible)
    local copy = {}
    setmetatable(copy, ZombieUnitProxy)
    copy:Init(group, unit, cfg, visible)
    return copy
end

function ZombieUnitProxy:Init(group, unit, cfg, visible)
    base.Init(self, group, unit, cfg, visible)

    if not string.IsNullOrEmpty(self.cfg.hitVfx) then
        self.hurtVfxPool = VfxPool.Create(self.cfg.hitVfx, 1)
    end
end

function ZombieUnitProxy:Dispose()
    if self.hurtVfxPool then
        self.hurtVfxPool:Dispose()
    end
    self.hurtVfxPool = nil

    base.Dispose(self)
end

function ZombieUnitProxy:OnContact()
    base.OnContact(self)
    local anim = self.cfg.contactAnim[math.random(1, #self.cfg.contactAnim)]
    self:PlayAnim(anim, 0.2)
end

function ZombieUnitProxy:OnMarch()
    base.OnMarch(self)
    local anim = self.cfg.moveAnim[math.random(1, #self.cfg.moveAnim)]
    self:PlayAnim(anim, 0.2)
end

function ZombieUnitProxy:OnEngageBegin()
    base.OnEngageBegin(self)
    local anim = self.cfg.engageAnim[math.random(1, #self.cfg.engageAnim)]
    self:PlayAnim(anim, 0.2)
end

function ZombieUnitProxy:OnHurt(dmgContext)
    base.OnHurt(self, dmgContext)
    if dmgContext.showHitVfx and self.hurtVfxPool then
        self.hurtVfxPool:Play(dmgContext.hitPos, -dmgContext.hitDir)
    end
end

return ZombieUnitProxy