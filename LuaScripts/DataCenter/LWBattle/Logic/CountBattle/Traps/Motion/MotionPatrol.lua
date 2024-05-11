local base = require "DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionBase"
local MotionPatrol = {}
MotionPatrol.__index = MotionPatrol
setmetatable(MotionPatrol, base)

function MotionPatrol.ParseParams(cfg, params)
    cfg.speed = tonumber(params[1])
    local toArr = string.split(params[2], ",")
    cfg.to = Vector3.New(tonumber(toArr[1]), tonumber(toArr[2]), tonumber(toArr[3]))
    cfg.interval = tonumber(params[3]) or 0
end

function MotionPatrol.Create(part, cfg)
    local copy = {}
    setmetatable(copy, MotionPatrol)
    copy:Init(part, cfg)
    return copy
end

function MotionPatrol:Init(part, cfg)
    base.Init(self, part, cfg)

    --改为计算local的
    self.srcPos = Vector3.New(0, 0, 0)
    self.dstPos = self.srcPos + cfg.to
    self.dstDir = cfg.to.normalized
    self.oneWayDist = cfg.to.magnitude
    self.oneWayTime = self.oneWayDist / cfg.speed
    
    self.curPos = self.srcPos:Clone()
    self.moveTo = self.dstPos
    self.moveDir = self.dstDir

    self.holdTime = math.max(0, cfg.interval - self.oneWayTime)
    self.holdTimer = self.holdTime
end

function MotionPatrol:OnUpdate(dt)
    if self.holdTimer > 0 then
        self.holdTimer = self.holdTimer - dt
        if self.holdTimer <= 0 then
            dt = -self.holdTimer
        else
            return
        end
    end

    self:SetPosDirty()
    
    local delta = self.moveTo - self.curPos
    local sqrDist = delta.sqrMagnitude
    local stepDist = self.cfg.speed * dt
    
    while sqrDist < stepDist * stepDist do
        self.part.lpos = self.part.lpos + (self.moveTo - self.curPos)
        
        self.curPos.x = self.moveTo.x
        self.curPos.y = self.moveTo.y
        self.curPos.z = self.moveTo.z
        
        self.moveTo = self.moveTo == self.dstPos and self.srcPos or self.dstPos
        self.moveDir = -self.moveDir
        self.holdTimer = self.holdTime
        
        if self.holdTimer > 0 then
            return
        end
        stepDist = stepDist - math.sqrt(sqrDist)
        sqrDist = self.oneWayDist
    end
    local move = self.moveDir * stepDist
    self.part.lpos = self.part.lpos + move
    self.curPos = self.curPos + move
end

return MotionPatrol