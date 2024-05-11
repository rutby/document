---
--- PVE 子弹：抛物线运动
--- 当且仅当飞到终点时做一次碰撞检测
---@type Scene.LWBattle.Bullet.BulletBase
local base = require("Scene.LWBattle.Bullet.BulletBase")

---@class Scene.LWBattle.Bullet.BulletCurve ： Scene.LWBattle.Bullet.BulletBase
local BulletCurve = BaseClass("BulletCurve",base)
local Const = require("Scene.LWBattle.Const")
local DIE_PERCENT = DIE_PERCENT

function BulletCurve:Destroy()
    base.Destroy(self)
    if self.path then
        self.path:Clear()
        self.path=nil
    end
    self.luaPath = {}
    self.pathDis = {}
    self.AngleOffset = nil
    self.totalDis=nil
    self.duration=nil
    self.springRound=nil
end

--不做碰撞检测
function BulletCurve:OnUpdateCollision()
end

---生成子弹路径
function BulletCurve:OnShow()
    local startPos = self.startPos
    local endPos = self:GetTargetPos()
    if not endPos then
        self:LogicDie()
        return
    end
    --endPos.y = startPos.y
    local displace=Vector3.New(endPos.x-startPos.x,0,endPos.z-startPos.z)

    if self.AngleOffset then--尿分叉
        displace = displace * Quaternion.Euler(0,self.AngleOffset,0)
        endPos = startPos + displace
    end
    
    if self.meta.random_ring_range>0 then--随机偏移
        local randomRadius = math.random() * self.meta.random_ring_range
        local randomAngle = math.random() * 6.283
        local randomOffset = Vector3.New(math.cos(randomAngle),0,math.sin(randomAngle)) * randomRadius
        displace = displace + randomOffset
        endPos = endPos + randomOffset
    end

    if self.height>0 then--高度固定模式
        local distance = displace:Magnitude()
        self.heightWidthRatio = self.height/distance
    end
    self.end_pos = endPos
    self.path=CS.CatmullRomUtils.CalcCurve(startPos,endPos,self.heightWidthRatio)
    self.luaPath = {}
    self.pathDis = {}
    for i = 0, self.path.Count-1 do
        local csVec=self.path[i]
        self.luaPath[i]=Vector3.New(csVec.x,csVec.y,csVec.z)
    end

    self.totalDis=0
    for i = 0, self.path.Count-2 do
        self.pathDis[i+1]=Vector3.Distance(self.luaPath[i], self.luaPath[i + 1])
        self.totalDis=self.totalDis+self.pathDis[i+1]
    end
    local forward = self.path[1] - self.path[0]
    self.bulletEffectTrans.forward = forward
    
    if self.meta.spiral_loops>0 then--螺旋线
        self.duration=4/self.flySpeed * self.meta.spiral_loops
        self.springRound=self.meta.spiral_loops * 6.283
    elseif self.height>0 then--高度固定模式
        self.duration = 2*self.height/self.flySpeed
    else
        self.duration=self.totalDis/self.flySpeed
    end

    if self.noCollision then
        self.duration = self.skill.forceLifeTime
    end

    --self.startTime=self.timeMgr:GetServerTime()
    --self.endTime=self.startTime+self.duration
    self.scaledTime=0
end



--更新位置
function BulletCurve:OnUpdateTransform()
    
    --local now = self.timeMgr:GetServerTime()
    --local t=(now-self.startTime)*0.001/self.duration--百分比时间
    self.scaledTime=self.scaledTime+Time.deltaTime
    local t=self.scaledTime/self.duration--百分比时间
    
    if t>=DIE_PERCENT then--到达终点后做一次碰撞检测
        self:CollisionDetection()
        self:LogicDie()
        return
    end
    --百分比路程
    local p
    
    --方案1：速度先慢后快
    --p=t*t 
    
    
    if self.animCurve then
        p=self.animCurve:Evaluate(t)
    else
        --方案2：速度先快再慢再快
        if t<0.5 then
            p=-2*(t-0.5)*(t-0.5)+0.5
        else
            p=2*(t-0.5)*(t-0.5)+0.5
        end
    end
    
    --方案3：匀速
    --p=t
    
    local allDis = self.totalDis
    local stepDis= allDis * p
    local curDis=0
    local path=self.path
    local luaPath=self.luaPath
    local point=luaPath[path.Count-1]--lua
    local nextPoint=point
    for j = 0, path.Count-1 do
        local d=self.pathDis[j+1]
        if d == nil then
            local curve = self.animCurve and "hasCurve" or "noCurve"
            if self.animCurve then
                curve = curve..CS.BulletMotionEditor.CurveToString(self.animCurve)
            end
            Logger.LogError(string.format("抛物线子弹异常：j=%s,p=%s,t=%s,curve=%s,metaId=%s,dur=%s,dis=%s,spd=%s,s=%s,%s,%s,e=%s,%s,%s",
                    j,p,t,curve,self.meta.id,self.duration,self.totalDis,self.flySpeed,self.startPos.x,self.startPos.y,self.startPos.z
            ,self.end_pos.x,self.end_pos.y,self.end_pos.z))
            self:LogicDie()
            return
        end
        if curDis + d >= stepDis then
            local t2 = p - curDis / allDis;
            local t3 = t2 * allDis / d;
            point = Vector3.Lerp(luaPath[j], luaPath[j+1],t3)--lua
            nextPoint = path[j + 1];--c#
            break;
        else
            curDis =curDis + d;
        end
    end

    local forward = nextPoint - point
    self.bulletEffectTrans.forward = forward
    if self.meta.spiral_loops>0 then--螺旋线
        local angle=t*self.springRound
        local offset=self.bulletEffectTrans.right*math.cos(angle)+self.bulletEffectTrans.up*math.sin(angle)--c#
        offset = offset * (-4*(t-0.5)*(t-0.5)+1) * self.meta.spiral_radius
        self:SetPosition(offset+point)
    else
        self:SetPosition(CS.UnityEngine.Vector3(point.x,point.y,point.z))
    end

    
end

return BulletCurve