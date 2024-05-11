local Bullet = {}
Bullet.__index = Bullet

local RES_PATH = "Assets/Main/Prefabs/LWCountBattle/Bullets/ShotgunBullet.prefab"
local Resource = CS.GameEntry.Resource

local _POOL = {}

local HIT_DAMAGE = 1
local HIT_TIMES = 4

local SCALE_DURATION = 0.1

local FLY_SPEED = 80
Bullet.SIZE = Vector2(1, 3)
local BOX_Z_OFFSET = -1.3

function Bullet.Create(pos, dir)
    if #_POOL > 0 then
        local bullet = table.remove(_POOL)
        bullet:Init(pos, dir, false)
        return bullet
    else
        local copy = {}
        setmetatable(copy, Bullet)
        copy:Init(pos, dir, true)
        return copy
    end
end

function Bullet.DisposePool()
    for i = 1, #_POOL do
        _POOL[i]:Dispose()
    end
    _POOL = {}
end

function Bullet:Init(pos, dir, loadRes)
    self.inPool = false

    self.pos = pos
    local dirDirty = self.dir ~= dir
    self.dir = dir
    self.angle = Vector3.Angle(Vector3.forward, dir)
    if IsNull(self.box) then
        self.box = CS.LW.CountBattle.Box(Vector2(pos.x, pos.z + BOX_Z_OFFSET), self.angle, Bullet.SIZE)
    else
        self.box:Set_pos(pos.x, pos.z + BOX_Z_OFFSET)
        self.box.angle = self.angle
    end

    self.scaleTimer = 0
    self.lifeTimer = 1
    self.hitTimes = HIT_TIMES
    self.hitRecords = {}

    if loadRes then
        self.handle = Resource:InstantiateAsync(RES_PATH)
        self.handle:completed('+', function(handle)
            self.gameObject = handle.gameObject
            self.gameObjectValid = not IsNull(self.gameObject)
            self.transform = self.gameObject.transform
            if self.inPool then
                self.gameObject:SetActive(false)
            else
                self.transform:Set_position(pos.x, pos.y, pos.z)
                self.transform:Set_localScale(0.1, 0.1, 0.1)
                if dirDirty then self.transform:Set_forward(dir:Split()) end
            end
        end)
    elseif self.gameObjectValid then
        self.gameObject:SetActive(true)
        self.transform:Set_position(pos.x, pos.y, pos.z)
        self.transform:Set_localScale(0.1, 0.1, 0.1)
        if dirDirty then self.transform:Set_forward(dir:Split()) end
    end
end

function Bullet:Dispose()
    if not IsNull(self.handle) then
        self.handle:Destroy()
    end
    self.box = nil
    self.handle = nil
    self.gameObject = nil
    self.gameObjectValid = nil
    self.transform = nil
    self.hitRecords = nil
end

function Bullet:Release()
    self.inPool = true
    if self.gameObjectValid then
        self.gameObject:SetActive(false)
    end
    table.insert(_POOL, self)
end

function Bullet:OnUpdate(deltaTime, aimTargets, logic)
    self.lifeTimer = self.lifeTimer - deltaTime
    if self.lifeTimer < 0 then
        return true
    end

    self.pos = self.pos + self.dir * FLY_SPEED * deltaTime
    self.box:Set_pos(self.pos.x, self.pos.z + BOX_Z_OFFSET)

    for _, aimTarget in pairs(aimTargets) do
        if aimTarget and not aimTarget.dead and not self.hitRecords[aimTarget.id] then
            if aimTarget.shape:Overlap(self.box) then
                if aimTarget.onHit then
                    local hitPos = Vector3(self.pos.x, self.pos.y, aimTarget.shape.pos.y - aimTarget.size)
                    local hit = aimTarget.onHit(HIT_DAMAGE, hitPos, self.dir, true)
                    if hit then
                        self.hitTimes = self.hitTimes - 1
                        self.hitRecords[aimTarget.id] = true
                    end
                    return self.hitTimes <= 0
                end
            end
        end
    end

    if not IsNull(self.transform) then
        self.transform:Set_position(self.pos.x, self.pos.y, self.pos.z)
        if self.scaleTimer < SCALE_DURATION then
            local lerpW = math.min(1, self.scaleTimer / SCALE_DURATION)
            local scaleX = Mathf.Lerp(0.1, 1, lerpW)
            local scaleY = Mathf.Lerp(0.1, 1, lerpW)
            local scaleZ = Mathf.Lerp(0.1, 1, lerpW)
            self.transform:Set_localScale(scaleX, scaleY, scaleZ)
            self.scaleTimer = self.scaleTimer + deltaTime
        end
    end
end

return Bullet