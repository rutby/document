---
--- PVE 子弹：直线运动
---
local base = require("Scene.LWBattle.Bullet.BulletBase")

---@class Scene.LWBattle.Bullet.BulletStraight : Scene.LWBattle.Bullet.BulletBase
local BulletStraight = BaseClass("BulletStraight",base)
local speed=Vector3.zero
local DIE_PERCENT = DIE_PERCENT


function BulletStraight:Create()
    if self.index==1 then--枪口创建的子弹，子弹初速度要叠加owner速度在枪口z方向上的分量（惯性速度）
        --枪口创建的子弹，子弹初速度要叠加枪口速度（惯性速度）
        self.inertiaVelocity = self.owner:GetMoveVelocity()--lua
    else
        self.inertiaVelocity = Vector3.zero
    end
    base.Create(self)
end


function BulletStraight:Destroy()
    base.Destroy(self)
    self.worldForward = nil
    self.worldVelocity = nil
    self.totalDisplacement = nil
end

function BulletStraight:OnShow()
    --self.flySpeed表示子弹相对于枪口的速率（即配置的速率）
    if self.skill ~= nil and self.skill.isWorldTroopEffect then
        self.duration=self.meta.lifetime_world
    else
        self.duration=self.meta.lifetime
    end
    --self.startTime=self.timeMgr:GetServerTime()
    self.scaledTime=0
    self.worldForward=self.bulletEffectTrans.forward--c#
    if self.meta.spiral_loops>0 then--螺旋线
        self.worldRight=self.bulletEffectTrans.right
        self.worldUp=self.bulletEffectTrans.up
        self.angleSpeed = self.flySpeed --* 0.628--弹簧角速度（弧度）= 子弹速度*2pi
        self.flySpeed = self.flySpeed / self.meta.spiral_loops
    end

    if self.noCollision then
        self.duration = self.skill.forceLifeTime
        self.worldVelocity = self.worldForward * self.skill.meta.horizontal_speed--子弹相对世界速度,c#
    else
        local flyVelocity = self.worldForward * self.flySpeed--子弹相对枪口速度,c#
        self.worldVelocity = flyVelocity + self.inertiaVelocity--子弹相对世界速度,c#
    end
    
    self.totalDisplacement = self.worldVelocity * self.duration--子弹相对世界总位移,c#
    if self.base_type==BulletDurabilityType.Collide or self.base_type==BulletDurabilityType.CollideInfinity then--碰撞型子弹
        local luaVec = Vector2.New(self.worldVelocity.x,self.worldVelocity.z)--c#转lua
        local worldSpeed = Vector2.Magnitude(luaVec)--世界系下速率
        self.dotMaxCD = self.dimension/worldSpeed--碰撞检测cd=线度/速率，节省无意义的检测
    end

end



--更新位置
function BulletStraight:OnUpdateTransform()
    
    if self.meta.spiral_loops>0 then--螺旋线
        --local now = self.timeMgr:GetServerTime()
        --local t=(now-self.startTime)*0.001
        self.scaledTime=self.scaledTime+Time.deltaTime
        local t=self.scaledTime
        local displacement=self.startPos + self.worldVelocity * t
        local angle=t * self.angleSpeed
        local offset=self.worldRight*math.cos(angle)+self.worldUp*math.sin(angle)
        offset = offset * self.meta.spiral_radius
        self:SetPosition(displacement + offset)
    else
        if self.animCurve then
            --local now = self.timeMgr:GetServerTime()
            --local t=(now-self.startTime)*0.001/self.duration--百分比时间
            self.scaledTime=self.scaledTime+Time.deltaTime
            local t=self.scaledTime/self.duration--百分比时间
            if t<DIE_PERCENT then
                local p=self.animCurve:Evaluate(t)--百分比路程
                self:SetPosition(self.startPos + self.totalDisplacement * p)
            else
                if self.noCollision then--无碰撞模式，此模式下不在update里做碰撞检测，死亡时做一次
                    self:CollisionDetection()
                end
                self:LogicDie()
            end
        else
            speed.z = self.flySpeed * Time.deltaTime
            self.bulletEffectTrans:Translate(speed)
        end
    end
end

return BulletStraight