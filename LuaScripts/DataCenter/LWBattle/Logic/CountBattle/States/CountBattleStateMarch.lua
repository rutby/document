local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")

local Const = require("Scene.LWBattle.Const")

function State.Create(initPos)
    local copy = {}
    setmetatable(copy, State)
    copy:Init(initPos)
    return copy
end

function State:Init(initPos)
    self.canInput = true
    self.syncCamera = true
    self.lastPlayerZ = initPos.z
end

-- function State:Dispose()
-- end


function State:OnEnter()
    local cfg = self.owner.cfg
    self.stageType = cfg.stageType
    if cfg.stageType == Const.CountBattleType.Attack then
        self.owner.playerGroupProxy:SetVelocity(0, cfg.marchSpeed)
    elseif cfg.stageType == Const.CountBattleType.Defense then
        --塔防模式
        self.owner.playerGroupProxy:SetVelocity(0, 0)
        
        self:StartDefenseEnemyGroups()
    end

    self.owner.playerGroupProxy:OnMarch()
end

function State:OnUpdate(deltaTime)
    if self.owner.playerGroupProxy:GetUnitCount() <= 0 then
        self.owner.fsm:Switch("Lose")
        return
    end
    
    local defense = self.stageType == Const.CountBattleType.Defense
    if defense then
        self:UpdateDefense(deltaTime)
    end

    local playerX, _, playerZ = self.owner.playerGroupProxy.transform:Get_position()
    self:CheckEnemyGroups(playerZ)
    self:CheckDoors(playerX, playerZ, self.lastPlayerZ, defense)
    self:CheckTraps(playerZ)
    self:CheckEnd(playerZ)
    self.lastPlayerZ = playerZ
end

function State:UpdateDefense(deltaTime)

    self.owner:UpdateDefenseOffset(deltaTime)

    --更新door
    local offsetZ = self.owner.deltaZ
    for i = #self.owner.doors, 1, -1 do
        local door = self.owner.doors[i]
        if door then
            local lastZ = door.pos.z
            local newZ = lastZ + offsetZ
            door.lastZ = lastZ
            door.pos.z = newZ
            local pos = door.pos
            door:UpdatePos(pos.x, pos.y, pos.z)
        end
    end
    
    --更新trap
    for _, trap in pairs(self.owner.traps) do
        if trap and trap.transformValid then
            local x,y,z = trap.transform:Get_position()
            local newZ = z + offsetZ
            trap.transform:Set_position(x, y, newZ)

            if trap.motionParts then
                for _, motionPart in pairs(trap.motionParts) do
                    if motionPart.rootTrans then
                        motionPart.lpos.z = newZ
                    end
                    motionPart.posDirty = true --为了驱动part的SyncView
                end
            else
                trap:UpdateShapes() --更新碰撞
                trap:SyncView() --更新bubble显示
            end
        end
    end
    
    --更新end
end

function State:StartDefenseEnemyGroups()
    -- 塔防模式，敌方军团运动
    local moveSpeed = self.owner.marchSpeed
    for _, enemyGroup in ipairs(self.owner.enemyGroupProxies) do
        enemyGroup:SetVelocity(0, -moveSpeed)
    end
end

function State:StopDefenseEnemyGroups()
    -- 塔防模式，退出当前状态时，停止敌方军团运动
    if self.owner.enemyGroupProxies then
        for _, enemyGroup in ipairs(self.owner.enemyGroupProxies) do
            enemyGroup:SetVelocity(0, 0)
        end
    end
end

function State:CheckEnemyGroups(playerZ)
    for i, enemyGroup in ipairs(self.owner.enemyGroupProxies) do
        local _, _, groupZ = enemyGroup.transform:Get_position()
        if playerZ + 70 >= groupZ then
            enemyGroup:TryAwake()
        end
        
        local alertRange = enemyGroup:GetAlertRange()
        if alertRange > 0 then
            if playerZ + alertRange >= groupZ then
                enemyGroup:TryAlert()
            end
        end
        
        if playerZ + self.owner.playerGroupProxy:GetRadius() + enemyGroup:GetRadius() >= groupZ then
            table.remove(self.owner.enemyGroupProxies, i)
            self.owner.fsm:Switch("Engage", enemyGroup)
            break
        end
    end
end

function State:CheckDoors(playerX, playerZ, lastPlayerZ, defense)
    for i = #self.owner.doors, 1, -1 do
        local door = self.owner.doors[i]
        if defense then
            if door:TryPassDefense(playerX, playerZ) then
                door:DoFunc(self.owner.playerGroupProxy)
                DataCenter.LWSoundManager:PlaySound(10025)
            end
        else
            if door:TryPass(playerX, playerZ, lastPlayerZ) then
                door:DoFunc(self.owner.playerGroupProxy)
                DataCenter.LWSoundManager:PlaySound(10025)
            end
        end
        
        if door.passed then
            table.remove(self.owner.doors, i)
            door:Dispose()
        end
    end
end

function State:CheckTraps(playerZ)
    for _, trap in pairs(self.owner.traps) do
        local trapZ = trap:GetPosZ()
        if playerZ + 70 >= trapZ then
            trap.actived = true
        end
        if trapZ + 20 < playerZ then
            self.owner:DeleteTrap(trap.baseId)
        end
    end
end

function State:CheckEnd(playerZ)
    local R = self.owner.playerGroupProxy:GetRadius()
    if self.owner.cfg.endZ + self.owner.defenseOffsetZ <= playerZ + R then
        if self.owner.cfg.endType == 1 then
            self.owner:OnBattleWin()
        elseif self.owner.cfg.endType == 2 then
            self.owner.fsm:Switch("EndLine")
        else
            Logger.LogError("CountBattle error! unknown endType:"..self.owner.cfg.endType)
        end
    end
end

function State:OnExit()
    -- if not IsNull(self.owner.playerGroupProxy) then
    --     self.owner.playerGroupProxy:SetVelocity(0, 0)
    -- end
    local cfg = self.owner.cfg
    self.stageType = cfg.stageType
    if cfg.stageType == Const.CountBattleType.Defense then
        --塔防模式

        self:StopDefenseEnemyGroups()
    end
end

return State