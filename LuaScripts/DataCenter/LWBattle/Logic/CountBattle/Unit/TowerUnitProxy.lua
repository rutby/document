local base = require "DataCenter.LWBattle.Logic.CountBattle.Unit.EnemyUnitProxy"
local TowerUnitProxy = {}
TowerUnitProxy.__index = TowerUnitProxy
setmetatable(TowerUnitProxy, base)

local VfxPool = require "DataCenter.LWBattle.Logic.CountBattle.Comp.VfxPool"

function TowerUnitProxy.Create(group, unit, cfg, visible)
    local copy = {}
    setmetatable(copy, TowerUnitProxy)
    copy:Init(group, unit, cfg, visible)
    return copy
end

function TowerUnitProxy:Init(group, unit, cfg, visible)
    base.Init(self, group, unit, cfg, visible)

    if not string.IsNullOrEmpty(self.cfg.hitVfx) then
        self.hurtVfxPool = VfxPool.Create(self.cfg.hitVfx, 6)
    end
end

function TowerUnitProxy:Dispose()
    if self.hurtVfxPool then
        self.hurtVfxPool:Dispose()
    end
    self.hurtVfxPool = nil

    base.Dispose(self)
end

function TowerUnitProxy:OnHurt(dmgContext)
    base.OnHurt(self, dmgContext)
    if dmgContext.showHitVfx and self.hurtVfxPool then
        self.hurtVfxPool:Play(dmgContext.hitPos, -dmgContext.hitDir)
    end
end

return TowerUnitProxy