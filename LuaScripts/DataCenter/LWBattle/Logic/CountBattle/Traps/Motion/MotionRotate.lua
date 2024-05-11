local MotionRotate = {}
MotionRotate.__index = MotionRotate
local base = require "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionBase"
setmetatable(MotionRotate, base)

function MotionRotate.ParseParams(cfg, params)
    local speedArr = string.split(params[1], ",")
    cfg.speed = Vector3.New(tonumber(speedArr[1]), tonumber(speedArr[2]), tonumber(speedArr[3]))
end

function MotionRotate.Create(part, cfg)
    local copy = {}
    setmetatable(copy, MotionRotate)
    copy:Init(part, cfg)
    return copy
end

local _QuaternionMul = function(lhs, rhs)
    return Quaternion.New((((lhs.w * rhs.x) + (lhs.x * rhs.w)) + (lhs.y * rhs.z)) - (lhs.z * rhs.y), (((lhs.w * rhs.y) + (lhs.y * rhs.w)) + (lhs.z * rhs.x)) - (lhs.x * rhs.z), (((lhs.w * rhs.z) + (lhs.z * rhs.w)) + (lhs.x * rhs.y)) - (lhs.y * rhs.x), (((lhs.w * rhs.w) - (lhs.x * rhs.x)) - (lhs.y * rhs.y)) - (lhs.z * rhs.z))
end
function MotionRotate:OnUpdate(dt)
    local rot = Quaternion.identity
    if self.cfg.speed.x ~= 0 then
        rot = _QuaternionMul(rot, Quaternion.AngleAxis(self.cfg.speed.x * dt, Vector3.right))
    end
    if self.cfg.speed.y ~= 0 then
        rot = _QuaternionMul(rot, Quaternion.AngleAxis(self.cfg.speed.y * dt, Vector3.up))
    end
    if self.cfg.speed.z ~= 0 then
        rot = _QuaternionMul(rot, Quaternion.AngleAxis(self.cfg.speed.z * dt, Vector3.forward))
    end
    self.part.lrot = _QuaternionMul(rot, self.part.lrot)

    self:SetRotDirty()
end

return MotionRotate