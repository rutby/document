---
--- PVE 子弹：随枪口运动
---
local base = require("Scene.LWBattle.Bullet.BulletBase")

---@class Scene.LWBattle.Bullet.BulletFollow : Scene.LWBattle.Bullet.BulletBase
local BulletFollow = BaseClass("BulletFollow",base)


function BulletFollow:Create()
    self.skill:RegisterChantBullet(self.objId,function() self:LogicDie() end)
    base.Create(self)
end

function BulletFollow:OnShow()
    if self.skill:IsNil() then
        self:LogicDie()
        return
    end
    local firePointTransform=self.skill.owner:GetFirePoint()
    if self.bulletEffect then
        self.bulletEffectTrans:SetParent(firePointTransform)
        self.bulletEffectTrans:Set_localPosition(0,0,0)
    end
end

function BulletFollow:LogicDie()
    if self.skill then
        self.skill:UnregisterChantBullet(self.objId)
    end
    base.LogicDie(self)
end

function BulletFollow:Destroy()
    if self.skill then
        self.skill:UnregisterChantBullet(self.objId)
    end
    base.Destroy(self)
end


function BulletFollow:GetPosition()
    if self.bulletEffect then
        return self.bulletEffectTrans.position
    else
        return self.curPos
    end
end

function BulletFollow:GetColliderCenterWorldPos()
    return self.bulletEffectTrans:TransformPoint(self.collider.center)
end

return BulletFollow