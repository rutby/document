local base = require "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionBase"
local MotionMarch = {}
MotionMarch.__index = MotionMarch
setmetatable(MotionMarch, base)

function MotionMarch.ParseParams(cfg, params)
    local speedArr = string.split(params[1], ",")
    cfg.speed = Vector3.New(tonumber(speedArr[1]), tonumber(speedArr[2]), tonumber(speedArr[3]))
end

function MotionMarch.Create(part, cfg)
    local copy = {}
    setmetatable(copy, MotionMarch)
    copy:Init(part, cfg)
    return copy
end

function MotionMarch:OnUpdate(dt)
    self.part.lpos = self.part.lpos + self.cfg.speed * dt
    self:SetPosDirty()
end

return MotionMarch