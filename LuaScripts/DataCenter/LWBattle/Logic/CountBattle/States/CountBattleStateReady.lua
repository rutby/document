local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")
local DoorProxy = require("DataCenter.LWBattle.Logic.CountBattle.Door.DoorProxy")
local Const = require("Scene.LWBattle.Const")

function State.Create()
    local copy = {}
    setmetatable(copy, State)
    copy:Init()
    return copy
end

-- function State:Init()
-- end

-- function State:Dispose()
-- end

-- function State:OnUpdate(deltaTime)
-- end

function State:OnExit()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

function State:OnEnter(callBack)
    self:LoadSteerGroups()
    self:LoadTraps()
    self:LoadDoors()

    self.owner.playerGroupProxy:SetBubbleVisible(true)
    self.owner.playerGroupProxy:SetUnitsVisible(true)

    self.timer = TimerManager:GetInstance():DelayInvoke(function()
        if callBack then
            callBack()
        end

        local owner = self.owner
        owner.camera.transform:Set_eulerAngles(Consts.CAMERA_X_ANGLE, 0, 0)
        owner.battleMgr:SetGameStart(true)
        if owner.param.firstGuideStage then
            owner:DoGuideCameraTween()
        end
        owner.fsm:Switch("March")
        DataCenter.LWSoundManager:PlaySound(10008)
    end, 0.2)
end

function State:LoadTraps()
    for i = 1, #self.owner.cfg.trapCfgs do
        local cfg = self.owner.cfg.trapCfgs[i]
        self.owner:CreateTrap(cfg.raw, cfg.pos, cfg.angle)
    end
end

function State:LoadSteerGroups()
    local owner = self.owner
    for i = 1, #owner.cfg.groupCfgs do
        local cfg = owner.cfg.groupCfgs[i]
        local group = owner:CreateSteerGroup(cfg, "enemy" .. i, "ENEMY", Consts.DEFAULT_REP_FACTOR, Consts.DEFAULT_ATT_FACTOR, true, true)
        table.insert(owner.enemyGroupProxies, group)
    end
end

function State:LoadDoors()
    local ownerCfg = self.owner.cfg
    local defense = ownerCfg.stageType == Const.CountBattleType.Defense
    for i = 1, #ownerCfg.doorCfgs do
        local cfg = self.owner.cfg.doorCfgs[i]
        local door = DoorProxy.Create(cfg.pos, 6, cfg.args, cfg.resPath, cfg.soilderId) --cfg.args[1] <= 4 and 6 or 12
        if defense and cfg.args[1] > 4 and cfg.args[3] and cfg.args[3].moveAnim then
            door:PlayAnim(cfg.args[3].moveAnim)
        end
        table.insert(self.owner.doors, door)
    end
end

return State