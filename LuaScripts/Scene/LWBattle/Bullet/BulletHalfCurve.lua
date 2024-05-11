---
--- PVE 子弹：半抛物线运动，运动到最高点爆炸
---
local base = require("Scene.LWBattle.Bullet.BulletBase")

---@class Scene.LWBattle.Bullet.BulletHalfCurve
local BulletHalfCurve = BaseClass("BulletHalfCurve",base)
local DIE_PERCENT = DIE_PERCENT

function BulletHalfCurve:Destroy()
    base.Destroy(self)
    if self.path then
        self.path:Clear()
        self.path=nil
    end
    self.totalDis=nil
    self.duration=nil
end

---生成子弹路径
function BulletHalfCurve:OnShow()
    local startPos=self.startPos
    local endPos
    if self.target.x then
        endPos=self.target
    else
        endPos=self.target:GetPosition()
    end
    endPos.y=startPos.y
    local displace=Vector3.New(endPos.x-startPos.x,0,endPos.z-startPos.z)
    local distance=displace:Magnitude()
    ----最小射程=6
    --distance=math.max(Const.BULLET_CURVE_MIN_RANGE * 2 ,distance)
    --endPos=displace:Normalize() * distance + startPos

    if self.skill ~= nil and self.skill.isWorldTroopEffect and self.meta.bullet_fly_speed_world ~= 0 then
        self.duration = distance / self.meta.bullet_fly_speed_world * 1000
    else
        self.duration = distance / self.meta.bullet_fly_speed * 1000
    end

    --self.startTime=self.timeMgr:GetServerTime()
    --self.endTime=self.startTime + self.duration * 0.5
    --Logger.Log("self.startTime=="..self.startTime)
    --Logger.Log("self.endTime=="..self.endTime)
    self.scaledTime=0
    --self.path
    --self.totalDis
    
    self.path=CS.CatmullRomUtils.CalcCurve(startPos,endPos,0.4)
    self.totalDis=0
    for i = 0, self.path.Count-2 do
        --local a=self.path[i]
        --local b=self.path[i + 1]
        self.totalDis=self.totalDis+Vector3.Distance(self.path[i], self.path[i + 1])
    end

end



--更新位置
function BulletHalfCurve:OnUpdateTransform()
    
    --local now = self.timeMgr:GetServerTime()
    --local t=(now-self.startTime)/self.duration--百分比时间
    self.scaledTime=self.scaledTime+Time.deltaTime
    local t=self.scaledTime/self.duration--百分比时间
    
    if t>=DIE_PERCENT then--到达终点后爆炸
        self:DoHitShake()
        self:LogicDie()
        return
    end
    
    --方案1：速度先慢后快
    --t=t*t 
    --方案2：速度先快再慢
    t=-2*(t-0.5)*(t-0.5)+0.5
    local allDis = self.totalDis
    local stepDis= allDis * t
    local curDis=0
    local path=self.path
    local point=path[path.Count-1]
    local nextPoint=point
    for j = 0, path.Count-1 do
        local d=Vector3.Distance(path[j], path[j+1])
        if curDis + d >= stepDis then
            local t2 = t  - curDis / allDis;
            local t3 = t2 * allDis / d;
            point = Vector3.Lerp(path[j], path[j+1],t3);
            nextPoint = path[j + 1];
            break;
        else
            curDis =curDis + d;
        end
    end
    self:SetPosition(point)
    self.bulletEffectTrans.forward = nextPoint - point;
    
end



return BulletHalfCurve