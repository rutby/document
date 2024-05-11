
---PVE 所有指向型子弹基类
---无碰撞检测，飞到终点时与目标碰撞一次（如果目标还在的话）

local base = require("Scene.LWBattle.Bullet.BulletBase")
---@class Scene.LWBattle.Bullet.BulletTrackingBase : Scene.LWBattle.Bullet.BulletBase
local BulletTrackingBase = BaseClass("BulletTrackingBase",base)
local DIE_PERCENT = DIE_PERCENT


function BulletTrackingBase:Create()
    if self.index==1 then--枪口创建的子弹，子弹初速度要叠加owner速度在枪口z方向上的分量
        local firePointForward=self.owner:GetFirePoint().forward
        local forward = Vector3.New(firePointForward.x,0,firePointForward.z)
        local ownerVelocity=self.owner:GetMoveVelocity()--lua
        self.inertiaSpeed = Vector3.Dot(forward,ownerVelocity)
    else
        self.inertiaSpeed = 0
    end
    base.Create(self)
end

function BulletTrackingBase:Destroy()
    base.Destroy(self)
    self.ctrlPoint1=nil
    self.ctrlPoint2=nil
    self.ctrlPoint3=nil
    self.inertiaSpeed=nil
end

--不做碰撞检测
function BulletTrackingBase:OnUpdateCollision()
end


function BulletTrackingBase:OnShow()
    self.flySpeed = self.flySpeed + self.inertiaSpeed
    --self.startTime=self.timeMgr:GetServerTime()
    self.scaledTime=0
    self.ctrlPoint1=self.startPos
    local targetPos=self:GetTargetPos()
    --targetPos.y=self.startPos.y
    if not targetPos then
        self:LogicDie()
        return
    end
    self.tempTargetPos = Vector3.New(targetPos.x,0,targetPos.z)
    self.displace=Vector3.New(targetPos.x-self.startPos.x,0,targetPos.z-self.startPos.z)
    self.distance=self.displace:Magnitude()

    if self.angleOffset then--尿分叉
        self.displace = self.displace * Quaternion.Euler(0,self.angleOffset,0)
        self.ctrlPoint2 = self.startPos + self.displace * 0.5
    else
        self.ctrlPoint2 = self.startPos + self.displace * 0.5
    end

    if self.meta.spiral_loops>0 then--螺旋线
        self.angleSpeed = self.flySpeed --* 0.628--弹簧角速度（弧度）= 子弹速度*2pi
        self.flySpeed = self.flySpeed / self.meta.spiral_loops
    end
    if self.noCollision then
        self.duration = self.skill.forceLifeTime
    else
        self.duration=self.distance/self.flySpeed
    end
end



--碰撞发生后，处理被撞者逻辑
function BulletTrackingBase:DoCollisionForTarget()
    if self.target.GetCurBlood and self.target:GetCurBlood() > 0 and self.target.GetCollider and self.target:GetCollider() then
        --碰撞型子弹碰到了重复的人
        if self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity then
            local objId = self.target.guid
            if self:IsCollideDuplicately(objId) then
                return false
            else
                self.collidedIdList[objId] = true
                self:RealDoCollisionForTarget(self.target:GetCollider(), self:GetPosition(), self.target)
                self.collidedTimes = self.collidedTimes + 1
                return true
            end
        else
            self:RealDoCollisionForTarget(self.target:GetCollider(), self:GetPosition(), self.target)
            return true
        end
    end
    return false
end


--碰撞发生后，处理子弹自身的逻辑
function BulletTrackingBase:DoCollisionForBullet()
    --震屏
    self:DoHitShake()
    --碰撞触发子弹
    self:DoHitTriggerNewBullet()
    --子弹耐久更新
    self:LogicDie()
end


--更新位置
function BulletTrackingBase:OnUpdateTransform()
    --local now = self.timeMgr:GetServerTime()
    --local timePercent=(now-self.startTime)*0.001/self.duration
    self.scaledTime=self.scaledTime+Time.deltaTime
    local t=self.scaledTime
    self.ctrlPoint3=self:GetTargetPos() or self.tempTargetPos--子弹飞行过程中目标死亡，使用备用坐标
    --self.ctrlPoint3.y=self.startPos.y
    local timePercent = t / self.duration--百分比时间
    if timePercent>=DIE_PERCENT then---飞到终点时与目标碰撞一次
        self:DoCollisionForTarget()
        self:DoCollisionForBullet()
        return
    end
    local progress
    if self.animCurve then
        progress=self.animCurve:Evaluate(timePercent)
    else
        progress=timePercent
    end
    --self.ctrlPoint12都是c#,self.ctrlPoint3是lua
    local a = self.ctrlPoint1 + (self.ctrlPoint2-self.ctrlPoint1) * progress
    local b = self.ctrlPoint2 + (-self.ctrlPoint2+self.ctrlPoint3) * progress
    local curPos=a+(b-a)*progress

    self.bulletEffectTrans:LookAt(b)

    if self.meta.spiral_loops>0 then--螺旋线
        local angle=t * self.angleSpeed
        local offset=self.bulletEffectTrans.right*math.cos(angle)+Vector3.New(0,math.sin(angle),0)
        offset = offset * self.meta.spiral_radius
        curPos = curPos + offset
    end
    
    self:SetPosition(curPos)
end


return BulletTrackingBase