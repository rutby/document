local Bullet = {}
Bullet.__index = Bullet

local RES_PATH = "Assets/Main/Prefabs/LWCountBattle/Bullets/RifleBullet.prefab"
local Resource = CS.GameEntry.Resource

local SCALE_DURATION = 0.1

local _POOL = {}

local HIT_DAMAGE = 1
local FLY_SPEED = 80
Bullet.SIZE = Vector2(1, 1)

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
        self.box = CS.LW.CountBattle.Box(Vector2(pos.x, pos.z), self.angle, Bullet.SIZE)
    else
        self.box:Set_pos(pos.x, pos.z)
        self.box.angle = self.angle
    end

    self.scaleTimer = 0
    self.lifeTimer = 1

    if loadRes then
        self.handle = Resource:InstantiateAsync(RES_PATH)
        self.handle:completed('+', function(handle)
            self.gameObject = handle.gameObject
            self.transform = self.gameObject.transform
            if self.inPool then
                self.gameObject:SetActive(false)
            else
                self.transform:Set_position(pos.x, pos.y, pos.z)
                self.transform:Set_localScale(0.1, 0.1, 0.1)
                if dirDirty then self.transform:Set_forward(dir:Split()) end
            end
        end)
    elseif not IsNull(self.gameObject) then
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
    self.transform = nil
end

function Bullet:Release()
    self.inPool = true
    if not IsNull(self.gameObject) then
        self.gameObject:SetActive(false)
    end
    table.insert(_POOL, self)
end

function Bullet:OnUpdate(deltaTime, aimTargets, logic)
    self.lifeTimer = self.lifeTimer - deltaTime
    if self.lifeTimer < 0 then
        return true
    end

    if self.angle == 0 then -- 只有forward方向子弹做防穿透处理
        local prePosZ = self.pos.z
        self.pos = self.pos + self.dir * FLY_SPEED * deltaTime
        local currPosZ = self.pos.z
        local diffZ = math.abs(currPosZ - prePosZ)
        self.box:Set_size(Bullet.SIZE.x, diffZ + Bullet.SIZE.y)
        self.box:Set_pos(self.pos.x, math.max(currPosZ, prePosZ) - diffZ * 0.5)
    else
        self.pos = self.pos + self.dir * FLY_SPEED * deltaTime
        self.box:Set_pos(self.pos.x, self.pos.z)
    end

    for _, aimTarget in pairs(aimTargets) do
        if aimTarget and not aimTarget.dead then
            if aimTarget.shape:Overlap(self.box) then
                if aimTarget.onHit then
                    local _, posy = aimTarget.shape:Get_pos()
                    local hitPos = Vector3(self.pos.x, self.pos.y, posy - aimTarget.size)
                    local hit = aimTarget.onHit(HIT_DAMAGE, hitPos, self.dir, true)
                    return hit
                end
            end
        end
    end

    if not IsNull(self.transform) then
        self.transform:Set_position(self.pos.x, self.pos.y, self.pos.z)
        if self.scaleTimer < SCALE_DURATION then
            local lerpW = math.min(1, self.scaleTimer / SCALE_DURATION)
            local scaleX = Mathf.Lerp(0.1, 0.65, lerpW)
            local scaleY = Mathf.Lerp(0.1, 0.65, lerpW)
            local scaleZ = Mathf.Lerp(0.1, 1, lerpW)
            self.transform:Set_localScale(scaleX, scaleY, scaleZ)
            self.scaleTimer = self.scaleTimer + deltaTime
        end
    end
end

return Bullet