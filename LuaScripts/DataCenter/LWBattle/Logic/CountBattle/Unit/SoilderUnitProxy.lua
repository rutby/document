local base = require "DataCenter.LWBattle.Logic.CountBattle.Unit.SteerUnitProxy"
local Const = require("Scene.LWBattle.Const")
local SoilderUnitProxy = {}
SoilderUnitProxy.__index = SoilderUnitProxy
setmetatable(SoilderUnitProxy, base)

SoilderUnitProxy.IsSoidler = true

function SoilderUnitProxy.Create(group, unit, cfg, visible, soilderCfg)
    local copy = {}
    setmetatable(copy, SoilderUnitProxy)
    copy:Init(group, unit, cfg, visible, soilderCfg)
    return copy
end

function SoilderUnitProxy:Init(group, unit, cfg, visible, soilderCfg)
    base.Init(self, group, unit, cfg, visible, soilderCfg.prefab)
    self.deadVfx = soilderCfg.deadVfx
    self.soilderCfg = soilderCfg
    self.soilderId = soilderCfg.id
    self.bullets = {}
    self.canFire = true
end

function SoilderUnitProxy:Dispose()
    if self.weapon then
        self.weapon:Dispose()
    end
    self.weapon = nil
    self.soilderCfg = nil
    self.inLine = nil

    base.Dispose(self)
end

function SoilderUnitProxy:OnResLoaded()
    local muzzleBone = self.transform:Find(self.soilderCfg.muzzleBone)
    local logic = self.group.logic
    local weaponClass = self.soilderCfg.weaponClass
    if logic and logic.changeWeaponClass and logic.changeWeaponClass[self.soilderId] then
        weaponClass = logic.changeWeaponClass[self.soilderId]
    end
    self.weapon = weaponClass.Create(self, muzzleBone)

    if string.IsNullOrEmpty(self.currAnim) then
        if logic and logic.stageType and logic.stageType == Const.CountBattleType.Defense then
            self:PlayAnim(self.soilderCfg.aimAnim, 0.2)
        end
    end
end

function SoilderUnitProxy:ChangeWeapon(newWeaponClass)
    if self.weapon then
        if self.weapon then
            self.weapon:Dispose()
        end
        self.weapon = nil
    end

    local muzzleBone = self.transform:Find(self.soilderCfg.muzzleBone)
    self.weapon = newWeaponClass.Create(self, muzzleBone)

    if self.onFireBullet then
        self.weapon.OnFireBullet = self.onFireBullet
    end
end
  
function SoilderUnitProxy:OnUpdate(dt)
    base.OnUpdate(self, dt)

    if self.disposed then
        return
    end

    if self.engaging and not self.contact and self.transformValid then
        local srcPos = Vector3.New(self.transform:Get_position())
        local tarPos = Vector3.New(self.group.engagingGroup:GetPosX(), 0, self.group.engagingGroup:GetPosZ())
        local selfR = self.unit.radius
        local tarR = self.group.engagingGroup:GetRadius()
        local sqrDist = (srcPos - tarPos):Magnitude() - tarR
        if sqrDist <= selfR * 5 then
            self.contact = true
            self:PlayAnim(self.soilderCfg.contactAnim, 0.2)
        end
    end

    if self.weapon then
        self.weapon:OnUpdate(dt)
        if self.canFire and self.weapon:IsLoaded() and self.group and self.group.logic and self.transformValid then
            local x, _, z = self.transform:Get_position()
            local aimTargets = self.group.logic.aimTargets
            if self.inLine then
                local minDist = 99999999
                local minDistTarget = nil
                for _, aimTarget in pairs(aimTargets) do
                    if aimTarget and not aimTarget.dead and not aimTarget.ignoreByWeapon then
                        local posx, posy = aimTarget.shape:Get_pos()
                        local dist = Vector2.Distance(Vector2.New(self.unit.pos.x, self.unit.pos.z), Vector2.New(posx, posy))
                        if dist < minDist then
                            minDist = dist
                            minDistTarget = aimTarget
                        end
                    end
                end
                if minDistTarget then
                    local posx, posy = minDistTarget.shape:Get_pos()
                    self:SetFaceDir(Vector3(posx, 0, posy) - Vector3(x, 0, z))
                    self:Fire()
                end
            else
                for _, aimTarget in pairs(aimTargets) do
                    if aimTarget and not aimTarget.dead and not aimTarget.ignoreByWeapon then
                        local posx, posy = aimTarget.shape:Get_pos()
                        if self.weapon:IsInRange(x, z, posx, posy, aimTarget.size) then
                            self:Fire()
                            break
                        end
                    end
                end
            end
        end
    end

end

function SoilderUnitProxy:OnMarch()
    base.OnMarch(self)

    local logic = self.group.logic
    if logic and logic.stageType and logic.stageType == Const.CountBattleType.Defense then
        self:PlayAnim(self.soilderCfg.aimAnim, 0.2)
        return
    end
    self:PlayAnim(self.soilderCfg.marchAnim, 0.2)
end

function SoilderUnitProxy:OnEngageBegin()
    base.OnEngageBegin(self)
    self.contact = false
    self.canFire = false
    self:PlayAnim(self.soilderCfg.moveAnim, 0.2)
end

function SoilderUnitProxy:OnEngageDone()
    base.OnEngageDone(self)
    self.contact = false
    self.canFire = true
end

function SoilderUnitProxy:MoveToEndLine(linePos)
    self.syncUnit = false
    self.inLine = true
    self.canFire = false
    self:PlayAnim(self.soilderCfg.moveAnim, 0.2)
    if not IsNull(self.transform) then
        self.transform:DOLookAt(linePos, 0.2)
        self.transform:DOMove(linePos, 1):SetEase(CS.DG.Tweening.Ease.InQuad):OnComplete(function()
            self:PlayAnim(self.soilderCfg.aimAnim, 0.2)
            self.transform:DOLookAt(linePos + Vector3.forward, 0.2)
            self.unit:SetPos(linePos.x, linePos.z)
            self.canFire = true
            self.weapon:Reload()
        end)
    end
end

function SoilderUnitProxy:Fire()
    if not self.onFireBullet then
        self.onFireBullet = function(bullet)
            if bullet and self.group and self.group.logic then
                self.group.logic:AddBullet(bullet)
            end
        end
        self.weapon.OnFireBullet = self.onFireBullet
    end
    self.weapon:Fire()
    if self.inLine then
        self.simpleAnim:Play(self.soilderCfg.aimAnim)
        self.simpleAnim:Play(self.soilderCfg.shootAnim)
    end
end

return SoilderUnitProxy