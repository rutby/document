---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/6/12 12:27
---武器弹道特效
local base = require("Scene.PVEBattleLevel.VFX.VFXBase")
local WeaponTrackVFX = BaseClass("WeaponTrackVFX",base)

function WeaponTrackVFX:SetData(data)
    self.targetPos = data.pos
end

function WeaponTrackVFX:InitAsset()
    self.forward = self:GetRotation():MulVec3(Vector3.forward)
    self.speed = tonumber(self.m_template.para1)
    local pos = self:GetPosition()
    self.startPos = Vector3.New(pos.x,pos.y,pos.z)
    self.startMove = true
    self.m_transform:SetParent(nil)
end

function WeaponTrackVFX:MoveTargetPos(deltaTime)
    if self.startMove then
        local pos = self:GetPosition() + Vector3.Normalize(self.forward) * self.speed * deltaTime

        self:SetPosition(pos)
    end
end

function WeaponTrackVFX:OnUpdate(deltaTime)
    self:MoveTargetPos(deltaTime)
    
    base.OnUpdate(self,deltaTime) --这里有检测结束
end

function WeaponTrackVFX:CheckComplete()
    local condition1 = false
    local condition2 = false
    local pos = self:GetPosition()
    local dis
    if self.targetPos ~= nil then
        dis = Vector3.Distance2D_XZ(pos,self.targetPos)
        --Logger.LogError("track dis:"..dis)
        condition1 = dis <= 2
    end
    if self.startPos ~= nil then
        condition2 = Vector3.Distance(pos,self.startPos) > 10
    end
    return condition1 or condition2
end

function WeaponTrackVFX:Destroy()
    base.Destroy(self)
    self.targetPos = nil
    self.forward = nil
    self.speed = nil
    self.startPos = nil
end

return WeaponTrackVFX