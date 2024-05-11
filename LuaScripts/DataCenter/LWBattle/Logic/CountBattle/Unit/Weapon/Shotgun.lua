local Weapon = {}
Weapon.__index = Weapon

local Bullet = require("DataCenter.LWBattle.Logic.CountBattle.Unit.Bullet.ShotgunBullet")
local VFX_FIRE = "Assets/Main/Prefabs/Effect/AK/Eff_hero_AK_qiangkou.prefab"
local Resource = CS.GameEntry.Resource

function Weapon.Create(unitProxy, muzzleBone)
    local copy = {}
    setmetatable(copy, Weapon)
    copy:Init(unitProxy, muzzleBone)
    return copy
end

function Weapon:Init(unitProxy, muzzleBone)
    self.fireRangeZ = 50
    self.fireRangeX = 6
    self.reloadTime = 1.5
    self.accAngleRange = 20
    self.fireBursts = 3
    self.shellsPerBurst = 6
    self.burstInterval = 0.2

    self.burstCounter = 0
    self.burstTimer = 0
    self.reloadTimer = 0

    self.unitProxy = unitProxy
    self.muzzleBone = muzzleBone

    self.fireVfxHandle = Resource:InstantiateAsync(VFX_FIRE)
    self.fireVfxHandle:completed('+', function(handle)
        local transform = handle.gameObject.transform
        transform:SetParent(self.muzzleBone, false)
        transform:Set_localPosition(Vector3.zero:Split())
        transform:Set_localRotation(Quaternion.identity:Split())
        transform:Set_localScale(Vector3.one:Split())

        self.fireVfx = handle.gameObject
        self.fireVfx:SetActive(false)
    end)
end

function Weapon:Dispose()
    if not IsNull(self.fireVfxHandle) then
        self.fireVfxHandle:Destroy()
    end
    self.fireVfxHandle = nil
    self.fireVfx = nil

    self.muzzleBone = nil
    self.unitProxy = nil

    self.OnFireBullet = nil
end

function Weapon:IsInRange(x, z, tx, tz, tsize)
    if math.abs(x - tx) > tsize + self.fireRangeX then
        return false
    end
    if tz - z > self.fireRangeZ then
        return false
    end
    return true
end

function Weapon:IsLoaded()
    return self.reloadTimer <= 0
end

function Weapon:Reload()
    self.reloadTimer = (math.random() * 0.25 + 1) * self.reloadTime
end

function Weapon:Fire()
    if self.reloadTimer > 0 then
        return
    end
    self:Reload()
    self.burstCounter = self.fireBursts
    self.burstTimer = 0
end

function Weapon:Burst()
    if not IsNull(self.fireVfx) then
        self.fireVfx:SetActive(true)
        self.fireVfxTimer = 0.5
    end
    if self.OnFireBullet then
        for i = 1, self.shellsPerBurst do
            local dir = Quaternion.Euler(0, math.random() * self.accAngleRange - self.accAngleRange * 0.5, 0) * self.unitProxy.faceDir
            self.OnFireBullet(Bullet.Create(Vector3(self.muzzleBone:Get_position()), dir))
        end
        if self.unitProxy.group and self.unitProxy.group.logic then
            self.unitProxy.group.logic:PlayFireSound(10010)
        end
    end
end

function Weapon:OnUpdate(deltaTime)
    if self.reloadTimer > 0 then
        self.reloadTimer = self.reloadTimer - deltaTime
    end

    if self.fireVfxTimer and self.fireVfxTimer > 0 then
        self.fireVfxTimer = self.fireVfxTimer - deltaTime
        if self.fireVfxTimer <= 0 then
            self.fireVfx:SetActive(false)
        end
    end

    if self.burstCounter > 0 then
        self.burstTimer = self.burstTimer - deltaTime
        if self.burstTimer <= 0 then
            self.burstTimer = self.burstInterval
            self.burstCounter = self.burstCounter - 1
            self:Burst()
        end
    end
end


return Weapon