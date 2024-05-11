local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Config = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConfig")
local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")

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

function State:OnExit()
    self.mainView = nil
end

local function _DestroyInfectionZombieWhenWin(trap)
    trap:Die()
end

local function _OnDeadInfection(unitProxy)
    local logic = DataCenter.LWBattleManager.logic
    local cfg = Config.GetTrapRawCfg(1001)
    local pos = Vector3(unitProxy.transform:Get_position())
    local trap = logic:CreateTrap(cfg, pos, math.random(0, 360))
    trap.actived = true
    trap.OnBattleWin = _DestroyInfectionZombieWhenWin

    local base = require "DataCenter.LWBattle.Logic.CountBattle.Unit.SteerUnitProxy"
    base.OnDead(unitProxy)
end

local function _TryPutSoilder(self, unitProxy, col, row)
    local unitSize = unitProxy.soilderCfg.endLineSize
    local empty = true
    local endCol = col + unitSize[1] - 1
    local endRow = row + unitSize[2] - 1
    if endCol > Consts.END_UNITS_PER_LINE then
        return false
    end
    if endRow > Consts.END_UNITS_LINE_LIMIT then
        return false
    end

    for c = col, endCol do
        for r = row, endRow do
            local grid = self.grids[r * 1000 + c]
            if grid then
                empty = false
                break
            end
        end
    end
    if empty then
        for c = col, endCol do
            for r = row, endRow do
                self.grids[r * 1000 + c] = unitProxy
            end
        end
        local linePos = Vector3(self.owner.cfg.boundary[1] + self.gap * col, 0, self.owner.cfg.endZ + self.owner.defenseOffsetZ - self.gap * (row - 1))
        local lineOffset = Vector3((unitSize[1] - 1) * self.gap * 0.5, 0, (unitSize[2] - 1) * self.gap * 0.5)
        unitProxy:MoveToEndLine(linePos + lineOffset)
        -- unitProxy.OnDead = _OnDeadInfection
        return true
    end
    return false
end
local function _FindNewPt(self)
end

function State:OnEnter()
    self.delayTimer = 0.01
    self.spawnSwitch = false
    self.spawnInfos = self.owner.cfg.endParams.spawnInfos
    self.totalAmount = 0
    for _, spawnInfo in pairs(self.spawnInfos) do
        self.totalAmount = self.totalAmount + spawnInfo.amount
    end
    self.spawnCounter = 0
    self.killCounter = 0

    local playerGroupProxy = self.owner.playerGroupProxy
    playerGroupProxy:SetVelocity(0, 0)
    playerGroupProxy:SetBubbleVisible(false)
    playerGroupProxy.group.RepSwitch = false
    playerGroupProxy.group.AttSwitch = false

    self.grids = {}
    self.gap = self.owner.cfg.limitWidth / (Consts.END_UNITS_PER_LINE + 1)
    self.midCol = math.floor(Consts.END_UNITS_PER_LINE * 0.5)
    self.findDir = 1
    local ptRows = {}
    local fullFlags = {}
    for _, unitProxy in pairs(playerGroupProxy.unitProxies) do
        local unitSize = unitProxy.soilderCfg.endLineSize
        local sizeKey = unitSize[1] * 1000 + unitSize[2]
        local isFull = fullFlags[sizeKey]
        if isFull then
            playerGroupProxy:RemoveUnit(unitProxy.id)
            unitProxy:Dispose()
        else
            -- 从当前排中间开始找位置
            local fCol = self.midCol
            local fRow = ptRows[sizeKey] or 1
            local changedDir = false
            while not _TryPutSoilder(self, unitProxy, fCol, fRow) do
                fCol = fCol + self.findDir
                -- 找到头也没找到
                if fCol < 1 or fCol > Consts.END_UNITS_PER_LINE then
                    -- 还没换过方向的话，从中间掉头回去找
                    if not changedDir then
                        self.findDir = -self.findDir
                        changedDir = true
                        fCol = self.midCol + self.findDir
                    else -- 两边都找不到，去下一排找
                        fRow = fRow + 1
                        ptRows[sizeKey] = fRow
                        if fRow > Consts.END_UNITS_LINE_LIMIT then
                            -- 标记当前尺寸已经满了
                            fullFlags[sizeKey] = true
                            -- 放不下的单位直接干掉
                            playerGroupProxy:RemoveUnit(unitProxy.id)
                            unitProxy:Dispose()
                            break
                        end
                        fCol = self.midCol
                    end
                end
            end
        end
    end

    self.mainView = UIManager:GetInstance():GetWindow(UIWindowNames.LWCountBattleMain).View
    self.mainView:UpdateEndType2Condition(self.totalAmount, self.killCounter)
end

local SPAWN_PADDING = 1

function State:OnUpdate(deltaTime)
    if self.delayTimer > 0 then
        self.delayTimer = self.delayTimer - deltaTime
        if self.delayTimer <= 0 then
            self.spawnSwitch = true
        end
    end

    if self.spawnSwitch and self.spawnCounter - self.killCounter < Consts.END_ZOMBIE_LIMIT then
        local randIdx = math.random(1, #self.spawnInfos)
        local spawnInfo = self.spawnInfos[randIdx]
        local cfg = spawnInfo.rawCfg
        local pos = Vector3(math.random() * (self.owner.cfg.limitWidth - SPAWN_PADDING * 2) + (self.owner.cfg.boundary[1] + SPAWN_PADDING), 0, math.random() * 20 + self.owner.cfg.endZ + 20)
        local trap = self.owner:CreateTrap(cfg, pos, 180)
        trap.OnDead = function()
            self.killCounter = self.killCounter + 1
            self.owner.killCount = self.owner.killCount + 1
            if self.mainView then
                self.mainView:UpdateEndType2Condition(self.totalAmount, self.killCounter)
            end
        end
        trap.actived = true
        self.spawnCounter = self.spawnCounter + 1
        spawnInfo.amount = spawnInfo.amount - 1
        if spawnInfo.amount <= 0 then
            table.remove(self.spawnInfos, randIdx)
        end
        if #self.spawnInfos <= 0 then
            self.spawnSwitch = false
        end
    end

    if self.killCounter >= self.totalAmount and self.owner.playerGroupProxy:GetPoint() > 0 then
        self.owner:OnBattleWin()
    end
end

return State