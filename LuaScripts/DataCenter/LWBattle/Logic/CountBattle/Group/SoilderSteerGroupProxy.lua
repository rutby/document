local base = require "DataCenter.LWBattle.Logic.CountBattle.Group.SteerGroupProxy"
local SoilderSteerGroupProxy = BaseClass("SoilderSteerGroupProxy", base)

local Consts = require "DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts"
local Resource = CS.GameEntry.Resource

function SoilderSteerGroupProxy:__init(logic, cfg)
    self.vibrateCD = 1

    self.circleHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/LWCountBattle/Huds/GroupCircleBlue.prefab")
    self.circleHandle:completed('+', function(handle)
        local gameObject = handle.gameObject
        local transform = handle.gameObject.transform
        transform:SetParent(self.transform, false)
        transform:Set_localPosition((Vector3.zero + Vector3.up * 0.01):Split())
        transform:Set_localScale((Vector3.one * (self:GetRadius() * 2 + 0.5)):Split())
        gameObject:SetActive(false)
        self.circleGO = gameObject
        self.circleTrans = transform
        self.circleTransValid = true
        self.circleMat = transform:GetComponent(typeof(CS.UnityEngine.Renderer)).material
        self.circleColor = self.circleMat:GetColor('_Main_Color')
    end)
    
    self.unitProxiesPtMap = {}
    self.unitMaxPt = 0
end

function SoilderSteerGroupProxy:__delete()
    if self.circleTween then
        self.circleTween:Kill()
    end
    self.circleTween = nil

    if not IsNull(self.circleHandle) then
        self.circleHandle:RealDestroy()
    end
    self.circleHandle = nil
    self.circleGO = nil
    self.circleTrans = nil
    self.circleTransValid = nil
    self.circleMat = nil
    self.circleColor = nil
    self.spawnTaskSoilderCfgMap = nil
    self.unitProxiesPtMap = nil
end

function SoilderSteerGroupProxy:OnUpdate()
    base.OnUpdate(self)
    local dt = Time.deltaTime
    if self.vibrateCD > 0 then
        self.vibrateCD = self.vibrateCD - dt
    end

    if not self.engagingGroup and self.circleTransValid and (not self.circleTween or not self.circleTween:IsActive()) then
        local scale = self:GetRadius() * 2 + 0.5
        self.circleTrans:Set_localScale(scale, scale, 1)
    end
end

function SoilderSteerGroupProxy:DoSpawn(amount, soilderCfg, UnitClass)
    if amount and amount <= 0 then return end
    if not self.spawnTaskUnitClassMap then self.spawnTaskUnitClassMap = {} end
    if not self.spawnTaskSoilderCfgMap then self.spawnTaskSoilderCfgMap = {} end
    local finalUnitClass = UnitClass or self.cfg.DefaultUnitClass
    if not finalUnitClass.IsSoidler then
        Logger.LogError('SoilderSteerGroupProxy:DoSpawn UnitClass must be a Soilder class')
        return
    end
    local finalSoilderCfg = soilderCfg or self.cfg.defaultSoilderCfg
    local taskId = self.group:Spawn(amount or self.cfg.amount, finalSoilderCfg.point, finalSoilderCfg.radius)
    self.spawnTaskUnitClassMap[taskId] = finalUnitClass
    self.spawnTaskSoilderCfgMap[taskId] = finalSoilderCfg
    self.scoreBubble:ExpandAnim()

    if self.vibrateCD <= 0 then
        self:Vibrate()
    end

    self:PlayCircleTween()
end

function SoilderSteerGroupProxy:PlayCircleTween()
    if not IsNull(self.circleGO) then
        if self.circleTween then
            self.circleTween:Kill()
        end
        self.circleGO:SetActive(true)
        local x, y = self.circleTrans:Get_localScale()
        self.circleTween = self.circleTrans:DOScale(Vector3(x + 5, y + 5, 1), 0.5):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
            if not IsNull(self.circleGO) then
                self.circleGO:SetActive(false)
            end
        end)
        self.circleMat:SetColor('_Main_Color', self.circleColor)
        self.circleMat:DOFade(0, '_Main_Color', 0.5):SetEase(CS.DG.Tweening.Ease.OutCubic)
    end
    
end

function SoilderSteerGroupProxy:OnUnitSpawn(taskId, unit)
    if not self.spawnTaskUnitClassMap then return end
    if not self.spawnTaskSoilderCfgMap then return end
    local UnitClass = self.spawnTaskUnitClassMap[taskId]
    local SoilderCfg = self.spawnTaskSoilderCfgMap[taskId]
    if not UnitClass or not SoilderCfg then return end
    if not IsNull(unit) then
        self.unitProxies[unit.id] = UnitClass.Create(self, unit, self.cfg, self.visible, SoilderCfg)
        local maxPt = SoilderCfg.point
        if not self.unitProxiesPtMap[maxPt] then
            self.unitProxiesPtMap[maxPt] = {}
        end
        self.unitProxiesPtMap[maxPt][unit.id] = self.unitProxies[unit.id]
        if self.unitMaxPt < maxPt then
            self.unitMaxPt = maxPt
        end
    end
end

function SoilderSteerGroupProxy:RemoveUnit(unitId)
    local unitProxy = self.unitProxies[unitId]
    if not unitProxy then return end
    if self.unitProxiesPtMap[unitProxy.maxPt] then
        self.unitProxiesPtMap[unitProxy.maxPt][unitId] = nil
    end

    base.RemoveUnit(self, unitId)
end

function SoilderSteerGroupProxy:DoDespawn(point)
    if point and point <= 0 then return end
    local restPt = point
    for i = 1, self.unitMaxPt do
        local unitPtMap = self.unitProxiesPtMap[i]
        if unitPtMap then
            for id, unitProxy in pairs(unitPtMap) do
                if unitProxy.unit.point <= restPt then
                    restPt = restPt - unitProxy.unit.point
                    self:RemoveUnit(id)
                    unitProxy:Dispose()
                else
                    unitProxy.unit.point = unitProxy.unit.point - restPt
                    return
                end
            end
        end
    end
end

function SoilderSteerGroupProxy:OnGroupPointDecreased(decPt)
    base.OnGroupPointDecreased(self, decPt)
    if self.vibrateCD <= 0 then
        self:Vibrate()
    end
end

function SoilderSteerGroupProxy:Vibrate()
    self.vibrateCD = Consts.VIBRATE_CD
    -- self.group:Vibrate()
end

return SoilderSteerGroupProxy