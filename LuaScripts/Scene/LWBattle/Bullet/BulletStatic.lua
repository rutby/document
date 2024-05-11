---
--- PVE 子弹：无运动
---
local base = require("Scene.LWBattle.Bullet.BulletBase")
---@class Scene.LWBattle.Bullet.BulletStatic : Scene.LWBattle.Bullet.BulletBase
local BulletStatic = BaseClass("BulletStatic",base)



--碰撞检测
function BulletStatic:CollisionDetection()
    if self.bulletEffect then--如果有子弹特效，就走通用的碰撞检测
        base.CollisionDetection(self)
    else--木有子弹特效，不做碰撞检测，直接碰撞
        local collider= self.target:GetCollider()
        if collider then
            self:DoCollisionForTarget(collider,self.startPos)
            self:DoCollisionForBullet()
        end
    end
end



return BulletStatic