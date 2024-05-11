local base = require "DataCenter.LWBattle.Logic.CountBattle.Traps.TrapStatic"
local TrapDynamic = BaseClass("TrapDynamic", base)

local MotionPart = require "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionPart"

function TrapDynamic:__init()
    self.motionParts = {}
end

function TrapDynamic:__delete()
    for _, motionPart in pairs(self.motionParts) do
        motionPart:Dispose()
    end
    self.motionParts = nil
end

function TrapDynamic:OnResLoaded()
    base.OnResLoaded(self)
    for _, motionCfg in ipairs(self.cfg.motionCfgs) do
        local motionPart = self.motionParts[motionCfg.part]
        if not motionPart then
            local rootTrans = motionCfg.part == "root"
            local partTrans = rootTrans and self.transform or self.transform:Find(motionCfg.part)
            assert(partTrans, "TrapDynamic motion part not found: " .. motionCfg.part)
            motionPart = MotionPart.Create(self, partTrans, rootTrans)
            self.motionParts[motionCfg.part] = motionPart
        end
        motionPart:AddMotion(motionCfg)
    end
end

function TrapDynamic:SyncView()
    for _, motionPart in pairs(self.motionParts) do
        motionPart:SyncView()
    end
    base.SyncView(self)
end

function TrapDynamic:OnUpdate(dt)
    local anyPartDirty = false
    if self.actived and self.sleepTimer <= 0 then
        for _, motionPart in pairs(self.motionParts) do
            motionPart:OnUpdate(dt)
            anyPartDirty = anyPartDirty or motionPart:IsDirty()
        end
    end

    if anyPartDirty then
        self:SyncView()
        self:UpdateShapes()
    end

    base.OnUpdate(self, dt)
end

return TrapDynamic