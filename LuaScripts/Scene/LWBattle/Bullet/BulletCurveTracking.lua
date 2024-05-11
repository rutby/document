---
--- PVE 子弹：抛物线追踪运动
---
local base = require("Scene.LWBattle.Bullet.BulletTrackingBase")

---@class Scene.LWBattle.Bullet.BulletCurveTracking : Scene.LWBattle.Bullet.BulletTrackingBase
local BulletCurveTracking = BaseClass("BulletCurveTracking",base)


function BulletCurveTracking:OnShow()

    base.OnShow(self)
    if self.logicDie then
        return
    end
    if self.height>0 then
        local doubleHeight = self.height * 2
        self.distance = self.distance + doubleHeight--弹道长度=水平距离+竖直距离*2，估算
        self.ctrlPoint2.y = self.startPos.y + doubleHeight
    else
        local doubleHeight = self.distance * self.heightWidthRatio * 2
        self.distance = self.distance + doubleHeight--弹道长度=水平距离+竖直距离*2，估算
        self.ctrlPoint2.y = self.startPos.y + doubleHeight
    end

    if self.noCollision then
        self.duration = self.skill.forceLifeTime
    else
        self.duration=self.distance/self.flySpeed
    end
    
    local forward = self.ctrlPoint2 - self.ctrlPoint1
    self.bulletEffectTrans.forward = forward

end




return BulletCurveTracking