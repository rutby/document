local TrapStatic = BaseClass("TrapStatic")

local Resource = CS.GameEntry.Resource
local SpriteRenderer = CS.UnityEngine.SpriteRenderer

local ScoreBubble = require "DataCenter.LWBattle.Logic.CountBattle.Comp.ScoreBubble"
local VfxPool = require "DataCenter.LWBattle.Logic.CountBattle.Comp.VfxPool"


local _AUTO_INC_ID = 1
function TrapStatic:__init(cfg, pos, angle, steerGroup, logic)
    self.baseId = _AUTO_INC_ID * 100
    _AUTO_INC_ID = _AUTO_INC_ID + 1
    self.cfg = cfg
    self.hp = cfg.maxHp
    self.pt = cfg.maxPt
    self.hpPerPt = cfg.maxPt > 0 and (cfg.maxHp / cfg.maxPt) or 0
    self.steerGroup = steerGroup
    self.logic = logic
    self.subShapes = {}
    self.aimTargets = {}
    self.abilities = {}
    self.headIcon = cfg.headIcon

    self.onHitByBullet = function (dmg, hitPos, hitDir, showHitVfx)
        return self:OnHitByBullet(dmg, hitPos, hitDir, showHitVfx)
    end
    self:LoadRes(cfg.res, pos, Quaternion.Euler(0, angle, 0))
    self.sleepTimer = cfg.sleepTime
    self.actived = false
end

function TrapStatic:__delete()
    self.actived = false

    for _, ability in pairs(self.abilities) do
        ability:Dispose()
    end
    self.abilities = nil

    if self.scoreBubble then
        self.scoreBubble:Dispose()
    end
    self.scoreBubble = nil

    if self.hurtVfxPool then
        self.hurtVfxPool:Dispose()
    end
    self.hurtVfxPool = nil

    if not IsNull(self.handle) then
        self.handle:RealDestroy()
    end
    self.handle = nil
    self.gameObject = nil
    self.gameObjectValid = nil
    self.transform = nil
    self.transformValid = nil

    if not IsNull(self.steerGroup) then
        for subShapeId, _ in pairs(self.subShapes) do
            self.steerGroup:RemoveTrapCollider(subShapeId)
        end
        for _, aimTarget in pairs(self.aimTargets) do
            self.steerGroup.logic:UnregisterAimTarget(aimTarget.id)
            aimTarget.dead = true
        end
    end
    self.subShapes = nil
    self.aimTargets = nil
    self.steerGroup = nil

    self.simpleAnim = nil
    self.cfg = nil
    self.colliderInited = nil
end

function TrapStatic:LoadRes(prefabPath, pos, rot)
    self.handle = Resource:InstantiateAsync(prefabPath)
    self.handle:completed('+', function(handle)
        self.gameObject = handle.gameObject
        self.gameObjectValid = not IsNull(self.gameObject)
        self.transform = self.gameObject.transform
        self.transformValid = self.gameObjectValid
        local x,y,z = pos:Split()
        if self.logic and self.logic.defenseOffsetZ then
            z = z + self.logic.defenseOffsetZ
        end
        self.transform:Set_position(x, y, z)
        self.transform:Set_rotation(rot:Split())
        if self.sleepTimer <= 0 then
            self:InitColliders()
        end
        self.simpleAnim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
        local head = self.transform:Find("tubiao")
        if not IsNull(head) then
            local sr = head:GetComponent(typeof(SpriteRenderer))
            if not string.IsNullOrEmpty(self.headIcon) then
                sr:LoadSprite(self.headIcon)
                head.gameObject:SetActive(true)
            else
                head.gameObject:SetActive(false)
            end
        end
        self:OnResLoaded()
    end)

    if not string.IsNullOrEmpty(self.cfg.hitVfx) then
        self.hurtVfxPool = VfxPool.Create(self.cfg.hitVfx, 5)
    end
end

function TrapStatic:InitColliders()
    if self.colliderInited or not self.gameObjectValid or not self.steerGroup then return end
    self.colliderInited = true
    local colliders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Collider))
    for i = 0, colliders.Length-1 do
        local subShapeId = self.baseId + i
        local collider = colliders[i]
        if self.steerGroup:AddTrapCollider(subShapeId, collider) then
            self.subShapes[subShapeId] = {collider = collider, actived = true}
            local steerCollider = self.steerGroup:FindTrapCollider(subShapeId)
            if not IsNull(steerCollider) then
                local shape = steerCollider.shape
                if not IsNull(shape) then
                    local aimTarget = self.steerGroup.logic:RegisterAimTarget(shape, self.onHitByBullet, self.cfg.maxHp <= 0) -- 没有hp的陷阱不被武器主动攻击
                    self.aimTargets[subShapeId] = aimTarget
                end
            end
        end
    end
end

function TrapStatic:OnResLoaded()
    if self.cfg.maxPt > 1 then
        self.scoreBubble = ScoreBubble.Create("RED", Vector3.New(0, self.cfg.bubbleH, 0), self.pt, true, self.transform)
        self.scoreBubble.autoAnim = true
    end
end

function TrapStatic:GetPosZ()
    if not self.transformValid then return 999999 end
    local _, _, z = self.transform:Get_position()
    return z
end

function TrapStatic:SyncView()
    if self.scoreBubble then
        self.scoreBubble:SyncView()
    end
end

function TrapStatic:UpdateShapes()
    if IsNull(self.steerGroup) then return end
    for subShapeId, subShape in pairs(self.subShapes) do
        if subShape.actived then
            self.steerGroup:UpdateTrapCollider(subShapeId, subShape.collider)
        end
    end
end

function TrapStatic:SetPt(pt)
    if self.pt == pt then return end
    self.pt = pt
    if self.scoreBubble then
        self.scoreBubble:SetScore(self.pt)
    end
    if self.pt <= 0 then
        self:Die()
    end
end

function TrapStatic:OnUpdate(dt)
    if self.actived then
        if self.sleepTimer > 0 then
            self.sleepTimer = self.sleepTimer - dt
            if self.sleepTimer <= 0 then
                self:InitColliders()
            end
        end
    end
end

function TrapStatic:OnHitByUnit(unitPt)
    if self.cfg.maxHp > 0 then -- 有hp，和单位碰撞时不单要扣pt，还得扣掉相应的hp
        self.hp = self.hp - unitPt * self.hpPerPt
    end
    self:SetPt(self.pt - unitPt)
end

function TrapStatic:OnHitByBullet(dmg, hitPos, hitDir, showHitVfx)
    if self.cfg.maxHp <= 0 then -- 没有hp，打不烂的陷阱
        self:Hurt(hitPos, hitDir, showHitVfx)
        return true
    end
    if self.hp <= 0 then
        return false
    end
    self.hp = self.hp - dmg
    if self.hp <= 0 then
        self:Die()
    else
        self:Hurt(hitPos, hitDir, showHitVfx)
    end
    return true
end

function TrapStatic:Hurt(hitPos, hitDir, showHitVfx)
    if showHitVfx and self.hurtVfxPool then
        self.hurtVfxPool:Play(hitPos, -hitDir)
    end

    if self.cfg.maxPt > 0 then
        local hpPercent = self.hp / self.cfg.maxHp
        local newPt = math.ceil(self.cfg.maxPt * hpPercent)
        self:SetPt(newPt)
    end
    if self.OnHurt then
        self.OnHurt()
    end
end

function TrapStatic:Die()
    if not string.IsNullOrEmpty(self.cfg.deadVfx) then
        local x, y, z = self.transform:Get_position()
        local vfxHandle = Resource:InstantiateAsync(self.cfg.deadVfx)
        vfxHandle:completed('+', function(handle)
            local gameObject = handle.gameObject
            local transform = gameObject.transform
            transform:Set_position(x, y, z)
        end)
    end
    if self.OnDead then
        self.OnDead()
    end
    if self.cfg.deadEffects and #self.cfg.deadEffects > 0 then
        local pos = self.transform.position
        for _, deadEffect in ipairs(self.cfg.deadEffects) do
            self.logic:OnTrapDeadEffect(deadEffect, pos, self.headIcon)
        end
    end
    self.steerGroup.logic:DeleteTrap(self.baseId)
end

function TrapStatic:AddAbility(className, ...)
    local class = require("DataCenter.LWBattle.Logic.CountBattle.Traps.Ability."..className)
    assert(class, "TrapStatic:AddAbility "..className.." not found")
    local ability = class.Create(self, ...)
    table.insert(self.abilities, ability)
    return ability
end

return TrapStatic