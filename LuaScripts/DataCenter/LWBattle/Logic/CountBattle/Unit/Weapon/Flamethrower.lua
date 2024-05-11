local Weapon = {}
Weapon.__index = Weapon

local Bullet = require("DataCenter.LWBattle.Logic.CountBattle.Unit.Bullet.FlamethrowerBullet")
local Resource = CS.GameEntry.Resource

function Weapon.Create(unitProxy, muzzleBone)
    local copy = {}
    setmetatable(copy, Weapon)
    copy:Init(unitProxy, muzzleBone)
    return copy
end

function Weapon:Init(unitProxy, muzzleBone)
    self.unitProxy = unitProxy
    self.muzzleBone = muzzleBone

    self.flame = Bullet.Create(self.muzzleBone, self.unitProxy.faceDir)
end

function Weapon:Dispose()
    if self.flame then
        self.flame:Dispose()
    end
    self.flame = nil
    self.muzzleBone = nil
    self.unitProxy = nil

    self.OnFireBullet = nil
end

function Weapon:IsInRange(x, z, tx, tz, tsize)
    if math.abs(x - tx) - Bullet.SIZE.x * 0.5 > tsize then
        return false
    end
    if tz - z > Bullet.SIZE.y then
        return false
    end
    return true
end

function Weapon:IsLoaded()
    return self.flame
end

function Weapon:Reload()
end

function Weapon:Fire()
    local justActive = not self.flame.isActive
    self.flame:Active()

    if justActive and self.OnFireBullet then
        self.OnFireBullet(self.flame)
    end
end

function Weapon:OnUpdate(deltaTime)
end


return Weapon