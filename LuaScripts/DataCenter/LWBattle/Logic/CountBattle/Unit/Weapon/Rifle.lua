local Weapon = {}
Weapon.__index = Weapon

local Bullet = require("DataCenter.LWBattle.Logic.CountBattle.Unit.Bullet.RifleBullet")
local VFX_FIRE = "Assets/Main/Prefabs/Effect/AK/Eff_hero_AK_qiangkou.prefab"
local Resource = CS.GameEntry.Resource

function Weapon.Create(unitProxy, muzzleBone)
    local copy = {}
    setmetatable(copy, Weapon)
    copy:Init(unitProxy, muzzleBone)
    return copy
end

function Weapon:Init(unitProxy, muzzleBone)
    self.fireRange = 50
    self.reloadTime = 1.2

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
    if math.abs(x - tx) - Bullet.SIZE.x * 0.5 > tsize then
        return false
    end
    if tz - z > self.fireRange then
        return false
    end
    return true
end

function Weapon:IsLoaded()
    return self.reloadTimer <= 0
end

function Weapon:Reload()
    self.reloadTimer = (math.random() * 0.5 + 1) * self.reloadTime
end

function Weapon:Fire()
    if self.reloadTimer > 0 then
        return
    end
    self:Reload()
    if not IsNull(self.fireVfx) then
        self.fireVfx:SetActive(true)
        self.fireVfxTimer = 0.5
    end
    if self.OnFireBullet then
        self.OnFireBullet(Bullet.Create(Vector3(self.muzzleBone:Get_position()), self.unitProxy.faceDir))
    end

    if self.unitProxy.group and self.unitProxy.group.logic then
        self.unitProxy.group.logic:PlayFireSound(10009)
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
end


return Weapon