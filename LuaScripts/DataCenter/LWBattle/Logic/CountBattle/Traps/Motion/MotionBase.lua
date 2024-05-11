local MotionBase = {}
MotionBase.__index = MotionBase

function MotionBase.Create(part, cfg)
    local copy = {}
    setmetatable(copy, MotionBase)
    copy:Init(part, cfg)
    return copy
end

function MotionBase:Init(part, cfg)
    self.part = part
    self.cfg = cfg
end

function MotionBase:Dispose()
    self.part = nil
    self.cfg = nil
end

function MotionBase:SetPosDirty()
    self.part.posDirty = true
end
function MotionBase:SetRotDirty()
    self.part.rotDirty = true
end
function MotionBase:SetActiveDirty()
    self.part.activeDirty = true
end

function MotionBase:CrossFadeAnim(animName, fadeTime)
    local simpleAnim = self.part.trap.simpleAnim
    if simpleAnim then
        simpleAnim:CrossFade(animName, fadeTime)
    end
end

return MotionBase