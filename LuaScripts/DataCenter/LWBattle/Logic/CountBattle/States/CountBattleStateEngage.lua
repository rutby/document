local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")
local Const = require("Scene.LWBattle.Const")

function State.Create()
    local copy = {}
    setmetatable(copy, State)
    copy:Init()
    return copy
end

function State:Init()
    self.syncCamera = true
end

-- function State:Dispose()
-- end

function State:OnEnter(enemyGroup)
    self.timer = 0.5
    self.exitTimer = 0
    self.exitState = nil
    self.done = false
    local cfg = self.owner.cfg

    assert(enemyGroup ~= nil, "CountBattle<Engage> enemyGroup is nil")
    self.enemyGroup = enemyGroup

    local playerGroupProxy = self.owner.playerGroupProxy

    playerGroupProxy:SetEngageGroup(enemyGroup)
    playerGroupProxy.group.attForceFactor = Consts.DEFAULT_ATT_FACTOR * 2
    playerGroupProxy.group.AttSwitch = true
    enemyGroup.group.attForceFactor = Consts.DEFAULT_ATT_FACTOR * 2
    enemyGroup.group.AttSwitch = true
    
    local srcPosA = playerGroupProxy:GetPos()
    local srcPosB = enemyGroup:GetPos()
    local dstPos = enemyGroup.canMove and (srcPosA + srcPosB) * 0.5 or srcPosB

    local vec = dstPos - srcPosA
    local dir = vec.normalized
    local vel = dir * Consts.ENGAGING_SPEED
    playerGroupProxy:SetVelocity(vel.x, vel.z)
    if enemyGroup.canMove then
        enemyGroup:SetVelocity(-vel.x, -vel.z)
    elseif cfg.stageType == Const.CountBattleType.Defense then
        enemyGroup:SetVelocity(0, 0)
    end
    self.timer = vec.magnitude / Consts.ENGAGING_SPEED

    playerGroupProxy:OnEngageBegin(enemyGroup)
    enemyGroup:OnEngageBegin(playerGroupProxy)

    self.soundHandle = DataCenter.LWSoundManager:PlaySound(10011,true)
end

function State:OnUpdate(deltaTime)
    local playerGroupProxy = self.owner.playerGroupProxy

    if self.timer > 0 then
        self.timer = self.timer - deltaTime
        if self.timer <= 0 then
            playerGroupProxy:SetVelocity(0, 0, 0)
            self.enemyGroup:SetVelocity(0, 0, 0)
        end
    end
    
    if self.done then
        if self.exitTimer > 0 then
            self.exitTimer = self.exitTimer - deltaTime
            if self.exitTimer <= 0 then
                self.owner.fsm:Switch(self.exitState)
            end
        end
    else
        if playerGroupProxy:GetUnitCount() <= 0 then
            self.done = true
            self.exitTimer = 0.25
            self.exitState = "Lose"
        end
        if self.enemyGroup:GetUnitCount() <= 0 then
            self.done = true
            self.exitTimer = 0.01
            self.exitState = "March"
        end
    end
end

function State:OnExit()
    local playerGroupProxy = self.owner.playerGroupProxy
    if playerGroupProxy then
        playerGroupProxy:SetVelocity(0, 0, 0)
        playerGroupProxy:SetEngageGroup(nil)
        playerGroupProxy.group.attForceFactor = Consts.DEFAULT_ATT_FACTOR
        playerGroupProxy.group.AttSwitch = true
        playerGroupProxy:OnEngageDone()
    end
    self.enemyGroup:SetVelocity(0, 0, 0)
    self.enemyGroup:OnEngageDone()
    self.enemyGroup = nil

    DataCenter.LWSoundManager:StopSound(self.soundHandle)
end

return State