local base = require "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionBase"
local MotionChase = {}
MotionChase.__index = MotionChase
setmetatable(MotionChase, base)

function MotionChase.ParseParams(cfg, params)
    cfg.moveSpeed = tonumber(params[1])
    cfg.turnSpeed = tonumber(params[2])
    if not string.IsNullOrEmpty(params[3]) then
        cfg.chasingAnims = string.split(params[3], "|")
    end
end

function MotionChase.Create(part, cfg)
    local copy = {}
    setmetatable(copy, MotionChase)
    copy:Init(part, cfg)
    return copy
end

function MotionChase:Init(part, cfg)
    base.Init(self, part, cfg)
    self.target = nil
end

function MotionChase:Dispose()
    base.Dispose(self)
    self.target = nil
end

function MotionChase:OnUpdate(dt)
    if not self.target then
        self:FindTarget()
    end
    if self.target then
        self:ChaseTarget(dt)
    end
end

function MotionChase:FindTarget()
    local logic = self.part.trap.steerGroup.logic
    if not logic then return end
    local playerGroupProxy = logic.playerGroupProxy
    if not playerGroupProxy then return end
    local minSqrDist = 999999999
    local minUnitId = -1
    local posV2 = Vector2.New(self.part.lpos.x, self.part.lpos.z)
    for _, unitProxy in pairs(playerGroupProxy.unitProxies) do
        local tpos = unitProxy.unit.pos
        local vec = tpos - posV2
        local sqrDist = vec:SqrMagnitude()
        if sqrDist < minSqrDist then
            minSqrDist = sqrDist
            minUnitId = unitProxy.id
        end
    end
    if minUnitId > 0 then
        self.target = playerGroupProxy.unitProxies[minUnitId]
    end
    if self.target then
        if self.cfg.chasingAnims and #self.cfg.chasingAnims > 0  then
            self:CrossFadeAnim(self.cfg.chasingAnims[math.random(1, #self.cfg.chasingAnims)], 0.2)
        end
    end
end

local _QuaternionMul = function(lhs, rhs)
    return Quaternion.New((((lhs.w * rhs.x) + (lhs.x * rhs.w)) + (lhs.y * rhs.z)) - (lhs.z * rhs.y), (((lhs.w * rhs.y) + (lhs.y * rhs.w)) + (lhs.z * rhs.x)) - (lhs.x * rhs.z), (((lhs.w * rhs.z) + (lhs.z * rhs.w)) + (lhs.x * rhs.y)) - (lhs.y * rhs.x), (((lhs.w * rhs.w) - (lhs.x * rhs.x)) - (lhs.y * rhs.y)) - (lhs.z * rhs.z))
end
function MotionChase:ChaseTarget(dt)
    if not self.target then return end
    if not self.target.transformValid then
        self.target = nil
        self:FindTarget()
        if not self.target then
            self:CrossFadeAnim("idle", 0.2)
            return
        end
    end
    local tpos = Vector3(self.target.transform:Get_position())
    local vec = tpos - self.part.lpos
    local dir = Vector3.Normalize(vec)

    if Vector3.Dot(dir, self.part.ldir) > 0.99 then
        self.part.lrot = Quaternion.LookRotation(dir)
    else        
        local isLeft = Vector3.Cross(self.part.ldir, dir).y > 0;
        local rot = Quaternion.AngleAxis(self.cfg.turnSpeed * dt * (isLeft and 1 or -1), Vector3.up);
        self.part.lrot = _QuaternionMul(rot, self.part.lrot)
        self:SetRotDirty()
    end

    dir = self.part.lrot * Vector3.forward
    local delta = dir * self.cfg.moveSpeed * dt
    self.part.lpos = self.part.lpos + delta
    self:SetPosDirty()
end

return MotionChase