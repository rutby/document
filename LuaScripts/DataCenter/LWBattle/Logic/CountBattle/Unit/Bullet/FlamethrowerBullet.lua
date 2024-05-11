local Bullet = {}
Bullet.__index = Bullet

local RES_PATH = "Assets/Main/Prefabs/LWCountBattle/Bullets/FlamethrowerBullet.prefab"
local Resource = CS.GameEntry.Resource

local SCALE_DURATION = 0.6

Bullet.SIZE = Vector2(5, 10)

local LIFT_TIME = 1
local HIT_INTERVAL = 0.15
local HIT_DAMAGE = 1

function Bullet.Create(muzzleBone)
    local copy = {}
    setmetatable(copy, Bullet)
    copy:Init(muzzleBone)
    return copy
end

function Bullet:Init(muzzleBone)
    self.lifeTimer = LIFT_TIME
    self.scaleTimer = 0

    self.box = CS.LW.CountBattle.Box(Vector2.zero, 0, Bullet.SIZE)
    self.hitTimer = 0
    self.particles = nil

    self.handle = Resource:InstantiateAsync(RES_PATH)
    self.handle:completed('+', function(handle)
        self.gameObject = handle.gameObject
        self.transform = self.gameObject.transform
        self.transformValid = not IsNull(self.transform)
        self.transform:SetParent(muzzleBone)
        self.transform:Set_localPosition(0, 0, 0)
        self.transform:Set_localEulerAngles(0, 0, 0)
        self.transform:Set_localScale(1, 1, 1)
        self.particles = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
        for i = 0, self.particles.Length - 1 do
            self.particles[i]:Stop()
        end
    end)

    -- self.debugCube = CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube)

    self.isActive = false
end

function Bullet:Dispose()
    if not IsNull(self.handle) then
        self.handle:Destroy()
    end
    self.box = nil
    self.handle = nil
    self.gameObject = nil
    self.transform = nil
    self.transformValid = nil
    self.particles = nil
    if self.soundHandle then
        DataCenter.LWSoundManager:StopSound(self.soundHandle)
        self.soundHandle = nil
    end
end

function Bullet:Release()
    if not self.isActive then return end
    if self.particles then
        for i = 0, self.particles.Length - 1 do
            self.particles[i]:Stop()
        end
    end
    self.isActive = false
    if self.soundHandle then
        DataCenter.LWSoundManager:StopSound(self.soundHandle)
        self.soundHandle = nil
    end
end

function Bullet:Active()
    if not self.isActive and self.particles then
        for i = 0, self.particles.Length - 1 do
            self.particles[i]:Play()
        end
        self.box.size = Vector2(0.1, 0.1)
        self.scaleTimer = 0
    end
    self.lifeTimer = LIFT_TIME
    self.isActive = true
    if not self.soundHandle then
        self.soundHandle = DataCenter.LWSoundManager:PlaySound(10026,true)
    end
end

function Bullet:OnUpdate(deltaTime, aimTargets, logic)
    if not self.isActive then return end
    
    self.lifeTimer = self.lifeTimer - deltaTime
    if self.lifeTimer < 0 then
        return true
    end

    if self.scaleTimer < SCALE_DURATION then
        self.scaleTimer = self.scaleTimer + deltaTime
    end

    if self.hitTimer <= 0 then
        if self.transformValid then
            local lerpW = math.min(1, self.scaleTimer / SCALE_DURATION)
            local sizeX = Mathf.Lerp(0.1, Bullet.SIZE.x, lerpW)
            local sizeZ = Mathf.Lerp(0.1, Bullet.SIZE.y, lerpW)
            self.box.size = Vector2(sizeX, sizeZ)
            local x, y, z = self.transform:Get_position()
            self.box.pos = Vector2(x, z + sizeZ * 0.5)
            local fx, fy, fz = self.transform:Get_forward()
            self.box.angle = Vector3.Angle(Vector3(fx, 0, fz), Vector3.forward)

            -- if not IsNull(self.debugCube) then
            --     self.debugCube.transform:Set_position(x, 0, z + sizeZ * 0.5)
            --     self.debugCube.transform:Set_localScale(sizeX, 1, sizeZ)
            -- end

            for _, aimTarget in pairs(aimTargets) do
                if aimTarget and not aimTarget.dead then
                    if aimTarget.shape:Overlap(self.box) then
                        if aimTarget.onHit then
                            local posx, posy = aimTarget.shape:Get_pos()
                            aimTarget.onHit(HIT_DAMAGE, Vector3(posx, y, posy - aimTarget.size), Vector3.forward, false)
                        end
                    end
                end
            end
        end
        self.hitTimer = HIT_INTERVAL
    end

    if self.hitTimer > 0 then
        self.hitTimer = self.hitTimer - deltaTime
    end
end

return Bullet