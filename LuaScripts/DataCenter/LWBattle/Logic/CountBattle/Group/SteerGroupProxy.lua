local SteerGroupProxy = BaseClass("SteerGroupProxy")

local GameObject = CS.UnityEngine.GameObject

local ScoreBubble = require "DataCenter.LWBattle.Logic.CountBattle.Comp.ScoreBubble"

function SteerGroupProxy:__init(logic, cfg)
    self.logic = logic
    self.cfg = cfg
    self.canMove = cfg.moveSpeed > 0

    self.gameObject = GameObject(cfg.name)
    self.transform = self.gameObject.transform
    self.transform:Set_position(cfg.initPos:Split()) 
    self.group = self.gameObject:AddComponent(typeof(CS.LW.CountBattle.SteerGroup))
    self.groupValid = true
    self.group.groupTag = cfg.tag
    self.group.repForceFactor = cfg.repF --0.5
    self.group.attForceFactor = cfg.attF --0.02
    self.group.spawnPerSecond = 200
    self.group.RepSwitch = cfg.repOn
    self.group.AttSwitch = cfg.attOn
    self.group.OnUnitSpawn = function(taskId, unit) self:OnUnitSpawn(taskId, unit) end
    self.group.OnUnitRemoved = function(unitId) self:OnUnitRemoved(unitId) end
    self.group.OnGroupPointChanged = function(point) self:OnGroupPointChanged(point) end
    self.group.OnCollideTrap = function(trapId, unitId) self:OnCollideTrap(trapId, unitId) end

    self.unitProxies = {}
    self.lastPoint = nil
    self.visible = true

    self.onUpdate = function() self:OnUpdate() end
    UpdateManager:GetInstance():AddUpdate(self.onUpdate)

    self.scoreBubble = ScoreBubble.Create(cfg.tag == "PLAYER" and "BLUE" or "RED", Vector3(0, 3, 0), self.group.GroupPoint, true, self.transform)
end

function SteerGroupProxy:__delete()
    UpdateManager:GetInstance():RemoveUpdate(self.onUpdate)
    self.onUpdate = nil

    for _, unitProxy in pairs(self.unitProxies) do
        unitProxy:Dispose()
    end
    self.unitProxies = nil

    if self.scoreBubble then
        self.scoreBubble:Dispose()
    end
    self.scoreBubble = nil

    if self.groupValid then
        self.group.OnUnitSpawn = nil
        self.group.OnUnitRemoved = nil
        self.group.OnGroupPointChanged = nil
        self.group.OnCollideTrap = nil
    end
    if not IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end
    self.gameObject = nil
    self.transform = nil
    self.group = nil
    self.groupValid = nil
    self.cfg = nil
    self.spawnTaskUnitClassMap = nil
    self.spawnTaskCfgMap = nil
    self.logic = nil
    self.engagingGroup = nil
end

function SteerGroupProxy:SetBubbleVisible(visible)
    self.scoreBubble:SetVisible(visible)
end

function SteerGroupProxy:SetUnitsVisible(visible)
    self.visible = visible
    if self.unitProxies then
        for _, unitProxy in pairs(self.unitProxies) do
            unitProxy:SetVisible(visible)
        end
    end
end

function SteerGroupProxy:OnUpdate()
    local dt = Time.deltaTime
    if self.unitProxies then
        for _, unitProxy in pairs(self.unitProxies) do
            unitProxy:OnUpdate(dt)
        end
    end
    if self.scoreBubble then
        self.scoreBubble:SyncView()
    end
end

function SteerGroupProxy:OnMarch()
    for _, unitProxy in pairs(self.unitProxies) do
        unitProxy:OnMarch()
    end
end

function SteerGroupProxy:OnEngageBegin(otherGroup)
    self.engagingGroup = otherGroup
    for _, unitProxy in pairs(self.unitProxies) do
        unitProxy:OnEngageBegin()
    end
end

function SteerGroupProxy:OnEngageDone()
    if not self.unitProxies then return end
    self.engagingGroup = nil
    for _, unitProxy in pairs(self.unitProxies) do
        unitProxy:OnEngageDone()
    end
end

function SteerGroupProxy:DoSpawn(amount, UnitClass)
    if amount and amount <= 0 then return end

    if self.cfg.subCfgs then
        if not self.spawnTaskCfgMap then
            self.spawnTaskCfgMap = {}
        end

        for _, subCfg in ipairs(self.cfg.subCfgs) do
            local taskId = self.group:Spawn(subCfg.amount, subCfg.point or 1, subCfg.radius)
            self.spawnTaskCfgMap[taskId] = subCfg
        end

    else
        if not self.spawnTaskUnitClassMap then self.spawnTaskUnitClassMap = {} end
        local taskId = self.group:Spawn(amount or self.cfg.amount, self.cfg.point or 1, self.cfg.radius)
        self.spawnTaskUnitClassMap[taskId] = UnitClass or self.cfg.DefaultUnitClass
    end
    
    self.scoreBubble:ExpandAnim()
end

function SteerGroupProxy:OnUnitSpawn(taskId, unit)
    if self.cfg.subCfgs then
        if not self.spawnTaskCfgMap then
            return
        end
        
        local subCfg = self.spawnTaskCfgMap[taskId]
        if not subCfg then
            return
        end

        if not IsNull(unit) then
            local unitClass = self.logic:GetUnitClass(subCfg.class)
            self.unitProxies[unit.id] = unitClass.Create(self, unit, subCfg, self.visible)
        end

    else
        if not self.spawnTaskUnitClassMap then return end
        local UnitClass = self.spawnTaskUnitClassMap[taskId]
        if not UnitClass then return end
        if not IsNull(unit) then
            self.unitProxies[unit.id] = UnitClass.Create(self, unit, self.cfg, self.visible)
        end
    end
end

function SteerGroupProxy:OnUnitRemoved(unitId)
    self:RemoveUnit(unitId)
end

function SteerGroupProxy:OnGroupPointChanged(point)
    if self.scoreBubble then
        self.scoreBubble:SetScore(point)
    end
    if self.lastPoint and self.lastPoint < point then
        self:OnGroupPointIncreased(point - self.lastPoint)
    end
    if self.lastPoint and self.lastPoint > point then
        self:OnGroupPointDecreased(self.lastPoint - point)
    end
    self.lastPoint = point
end

function SteerGroupProxy:OnGroupPointIncreased(incPt)
end

function SteerGroupProxy:OnGroupPointDecreased(decPt)
    self.scoreBubble:ShrinkAnim()
end

function SteerGroupProxy:OnCollideTrap(trapId, unitId)
    if not self.logic then return end
    local trap = self.logic.traps[trapId]
    local unitProxy = self.unitProxies[unitId]
    if not trap or not unitProxy or not unitProxy.unitValid then return end
    local unit = unitProxy.unit

    if trap.cfg.maxPt > 0 then
        local trapPt = trap.pt
        local unitPt = unit.point
        trap:OnHitByUnit(unitPt)
        unit.point = unit.point - trapPt
        if unit.point <= 0 then
            self:RemoveUnit(unitId);
            unit:Kill();
        end
    else
        self:RemoveUnit(unitId);
        unit:Kill();
    end

    local unitProxy = self.unitProxies[unitId]
    if unitProxy and unitProxy.unitValid then
        self:RemoveUnit(unitId);
        unitProxy.unit:Kill();
    end
end

function SteerGroupProxy:GetPoint()
    if not self.groupValid then return 0 end
    return self.group.GroupPoint
end

function SteerGroupProxy:RemoveUnit(unitId)
    local unitProxy = self.unitProxies[unitId]
    if not unitProxy then return end
    self.unitProxies[unitId] = nil

    if unitProxy and unitProxy.unitValid then
        self.group:RemoveUnit(unitProxy.unit)
    end
end

function SteerGroupProxy:Overlay(otherGroup)
    if not self.groupValid then return false end
    if not otherGroup or not otherGroup.groupValid then return false end
    return self.group.GroupCircle:Overlap(otherGroup.group.GroupCircle)
end

function SteerGroupProxy:SetEngageGroup(otherGroup)
    if not self.groupValid then return end
    if not otherGroup or not otherGroup.groupValid then
        self.group.EngageGroup = nil
    else
        self.group.EngageGroup = otherGroup.group
    end
end

function SteerGroupProxy:GetUnitCount()
    if self.groupValid then
        return self.group.UnitCount
    end
    return 0
end

function SteerGroupProxy:SetVelocity(x, z)
    if self.groupValid then
        self.group:SetVelocity(x, z)
    end
end

function SteerGroupProxy:AddTrapCollider(shapeId, collider)
    if self.groupValid then
        return self.group:AddTrapCollider(shapeId, collider)
    end
    return false
end

function SteerGroupProxy:FindTrapCollider(shapeId)
    if self.groupValid then
        return self.group:FindTrapCollider(shapeId)
    end
    return nil
end

function SteerGroupProxy:RemoveTrapCollider(shapeId)
    if self.groupValid then
        self.group:RemoveTrapCollider(shapeId)
    end
end

function SteerGroupProxy:UpdateTrapCollider(shapeId, collider)
    if self.groupValid then
        self.group:UpdateTrapCollider(shapeId, collider)
    end
end

function SteerGroupProxy:GetBoundLeft()
    if self.groupValid then
        return self.group.GroupBoundLeft
    end
    return 0
end

function SteerGroupProxy:GetBoundRight()
    if self.groupValid then
        return self.group.GroupBoundRight
    end
    return 0
end

function SteerGroupProxy:GetRadius()
    if self.groupValid then
        return self.group.GroupRadius
    end
    return 0
end

function SteerGroupProxy:GetPosX()
    if self.groupValid then
        return self.group.GroupPosX
    end
    return 0
end

function SteerGroupProxy:GetPosZ()
    if self.groupValid then
        return self.group.GroupPosZ
    end
    return 0
end

function SteerGroupProxy:GetPos()
    if self.groupValid then
        return self.group.GroupPos
    end
    return Vector3.zero
end

function SteerGroupProxy:SetPosX(x)
    if self.groupValid then
        self.group:SetPosX(x)
    end
end

function SteerGroupProxy:SetPosY(y)
    if self.groupValid then
        self.group:SetPosX(y)
    end
end

function SteerGroupProxy:SetPosXZ(x, z)
    if self.groupValid then
        self.group:SetPosXZ(x, z)
    end
end

function SteerGroupProxy:SetPos(x, y, z)
    if self.groupValid then
        self.group:SetPosXZ(x, y, z)
    end
end

return SteerGroupProxy