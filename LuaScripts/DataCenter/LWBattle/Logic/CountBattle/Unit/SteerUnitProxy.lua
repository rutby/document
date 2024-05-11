local SteerUnitProxy = {}
SteerUnitProxy.__index = SteerUnitProxy

local Resource = CS.GameEntry.Resource
function SteerUnitProxy.Create(group, unit, cfg, visible)
    local copy = {}
    setmetatable(copy, SteerUnitProxy)
    copy:Init(group, unit, cfg, visible)
    return copy
end

function SteerUnitProxy:Init(group, unit, cfg, visible, prefab)
    self.group = group
    self.id = unit.id
    self.unit = unit
    self.unitValid = true  -- 前提是上层做了保证
    self.maxPt = unit.point
    self.cfg = cfg
    self.faceDir = cfg.faceDir or (Quaternion.Euler(0, math.random(0, 360), 0) * Vector3.forward)
    self.hp = cfg.maxHp
    self.deadVfx = cfg.deadVfx
    local resPath = prefab or cfg.res
    self.handle = Resource:InstantiateAsync(resPath)
    self.handle:completed('+', function(handle)
        self.gameObject = handle.gameObject
        self.gameObjectValid = not IsNull(self.gameObject)
        self.transform = self.gameObject.transform
        self.transformValid = self.gameObjectValid
        self.transform:Set_forward(self.faceDir:Split())
        self.simpleAnim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
        if not IsNull(self.simpleAnim) and not string.IsNullOrEmpty(self.currAnim) then
            self.simpleAnim:Play(self.currAnim)
        end
        self:OnResLoaded()
        self.gameObject:SetActive(self.visible)
    end)

    self.unit.OnDead = function() self:OnDead() end
    self.syncUnit = true
    self.visible = visible
    
    self.deadAnimPlaying = false
end

function SteerUnitProxy:Dispose()
    self.group = nil
    if self.unitValid then
        self.unit.OnDead = nil
        self.unit:Destroy()
        self.unit = nil
        self.unitValid = nil
    end
    if not IsNull(self.handle) then
        self.handle:Destroy()
        self.handle = nil
    end
    self.gameObject = nil
    self.gameObjectValid = nil
    self.transform = nil
    self.transformValid = nil
    self.simpleAnim = nil
    self.disposed = true
    self.deadAnimPlaying = false
    if not IsNull(self.deadTimer) then
        self.deadTimer:Stop()
        self.deadTimer = nil
    end
end

function SteerUnitProxy:PlayAnim(anim, fade)
    self.currAnim = anim
    if not IsNull(self.simpleAnim) then
        self.simpleAnim:CrossFade(anim, fade or 0)
    end
end

function SteerUnitProxy:SetFaceDir(dir)
    self.faceDir = Vector3.Normalize(dir)
    if self.transformValid then
        self.transform:Set_forward(self.faceDir:Split())
    end
end

function SteerUnitProxy:SetVisible(visible)
    self.visible = visible
    if self.gameObjectValid then
        self.gameObject:SetActive(visible)
    end
end

function SteerUnitProxy:Damage(dmgContext)
    if self.hp <= 0 then
        dmgContext.abandon = true
        return
    end
    dmgContext.realDmg = math.min(self.hp, dmgContext.rawDmg)
    self.hp = self.hp - dmgContext.realDmg
    if self.hp <= 0 then
        self.group:RemoveUnit(self.id)
        self:OnDead(dmgContext)
    else
        self:OnHurt(dmgContext)
    end
end

function SteerUnitProxy:OnResLoaded()
end
  
function SteerUnitProxy:OnUpdate(dt)
    if self.deadAnimPlaying then
        return
    end
    if self.disposed then
        return
    end
    if self.syncUnit and self.unitValid and self.transformValid then
        self.unit:Sync(self.transform)
    end
end

function SteerUnitProxy:OnDead(dmgContext)
    if self.deadAnimPlaying then
        return
    end
    
    if self.deadVfx and self.transformValid then
        local x, y, z = self.transform:Get_position()
        local vfxHandle = Resource:InstantiateAsync(self.deadVfx)
        vfxHandle:completed('+', function(handle)
            local gameObject = handle.gameObject
            local transform = gameObject.transform
            if not IsNull(transform) then
                transform:Set_position(x, y, z)
            end
        end)
    end

    if self.cfg and self.cfg.deathAnim then
        local count = #self.cfg.deathAnim
        if count > 0 then
            local anim = self.cfg.deathAnim[math.random(1, count)]
            if not IsNull(self.simpleAnim) then
                local length = self.simpleAnim:GetClipLength(anim)
                if length > 0 then
                    self.deadAnimPlaying = true
                    self:PlayAnim(anim, 0.2)
                    self:OnDeadAnimPlaying()
                    --当前状态下无人管理了，GroupProxy中已移除，SteerGroup中也已移除了，交由logic缓存，以便退出战斗后集中销毁
                    if self.group and self.group.logic then
                        self.group.logic:AddDeadPlayingUnit(self)
                    end
                    self.deadTimer = TimerManager:DelayInvoke(function()
                        self.deadTimer = nil
                        self:OnDeadAnimEnd()
                    end, length)
                    return
                end
            end
        end
    end
    
    self:Dispose()
end

function SteerUnitProxy:OnDeadAnimPlaying()
    
end

function SteerUnitProxy:OnDeadAnimEnd()
    if self.deadAnimPlaying then
        if self.group and self.group.logic then
            self.group.logic:RemoveDeadPlayingUnit(self)
        end
        self:Dispose()
    end
end

function SteerUnitProxy:OnHurt(dmgContext)
end

function SteerUnitProxy:OnMarch()
end

function SteerUnitProxy:OnEngageBegin()
    self.engaging = true
end

function SteerUnitProxy:OnEngageDone()
    self.engaging = false
    if not IsNull(self.simpleAnim) then
        self.simpleAnim:CrossFade("Default", 0.2)
    end
end

function SteerUnitProxy:ResetSyncUnit()
    self.syncUnit = true
end

return SteerUnitProxy