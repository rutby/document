---
--- PVE 子弹生成器
--- 用于处理子弹连发与多发逻辑
---




---@class Scene.LWBattle.Bullet.BulletCreator
local BulletCreator = BaseClass("BulletCreator")


local BulletStraight = require"Scene.LWBattle.Bullet.BulletStraight"
local BulletStraightTracking = require"Scene.LWBattle.Bullet.BulletStraightTracking"
local BulletCurve = require"Scene.LWBattle.Bullet.BulletCurve"
local BulletCurveTracking = require"Scene.LWBattle.Bullet.BulletCurveTracking"
local BulletStatic = require"Scene.LWBattle.Bullet.BulletStatic"
local BulletFollow = require"Scene.LWBattle.Bullet.BulletFollow"
local BulletRay = require"Scene.LWBattle.Bullet.BulletRay"



function BulletCreator:__delete()
    self:Destroy()
end


function BulletCreator:Destroy()
    self.meta=nil
    self.skill=nil
    self.context=nil
    if self.timers then
        for _,timer in pairs(self.timers) do
            timer={}
        end
    end
    self.timers={}
    self.pastTime = nil
    self.timerStartIndex=nil
    self.objId=nil
    self.logic=nil
    self.bulletMgr=nil
end

function BulletCreator:Init(logic,bulletMgr,objId,meta,skill,context)
    self.logic=logic
    self.bulletMgr=bulletMgr
    self.objId=objId
    self.meta=meta---@type DataCenter.PveBullet.PveBulletTemplate
    --PVP模式，此模式下子弹波数，波间隔，每波子弹数，子弹间隔读另一套配置
    self.PVP = self.logic:GetPVEType()==PVEType.Skirmish or self.logic:GetPVEType()==PVEType.FakePVP
    self.bullet_row_count = self.PVP and self.meta.bullet_row_count_replay or self.meta.bullet_row_count
    self.bullet_wave_count = self.PVP and 1 or self.meta.bullet_wave_count
    self.bullet_diff_time = self.PVP and self.meta.bullet_diff_time_replay or self.meta.bullet_diff_time
    self.bullet_wave_diff_time = self.PVP and self.meta.bullet_wave_diff_time_replay or self.meta.bullet_wave_diff_time
    self.skill=skill
    self.context=context
    if self.bullet_wave_count==1 and self.bullet_row_count==1 then
        self:CreateOneBullet(nil, self.context.redirect)
        self:Destroy()
        return false--子弹创建完毕，Creator直接销毁
    end
    self.pastTime = 0
    self.timerStartIndex = 1
    self.timers={}
    local firstOffsetAngle
    if self.meta.random_angle_range<=0 then--均匀散射
        firstOffsetAngle=(1-self.bullet_row_count)*0.5*self.meta.bullet_angle_diff
    end

    for i = 0, self.bullet_wave_count-1 do
        for j = 0, self.bullet_row_count-1 do
            local delayTime=self.bullet_wave_diff_time * i + self.bullet_diff_time * j
            local angleOffset
            if self.meta.random_angle_range>0 then--随机散射
                angleOffset=((math.random()*2)-1)*self.meta.random_angle_range
            else--均匀散射
                angleOffset=firstOffsetAngle+j*self.meta.bullet_angle_diff
            end
            local timerParam={}
            timerParam.angleOffset=angleOffset
            timerParam.delayTime=delayTime
            --if self.meta.is_following and (not self.param.forceFollowing) and i > 0 and j == 0 then
            if self.logic:GetPVEType()~=PVEType.World and self.meta.is_following and i > 0 and j == 0 then
                timerParam.redirect=true--有且只有指向型子弹每波重新索敌
            end
            self.timers[#self.timers+1]=timerParam
        end
    end
    return true
end

function BulletCreator:OnUpdate()
    if self.timerStartIndex > #self.timers then
        return
    end
    self.pastTime=self.pastTime+Time.deltaTime
    for i = self.timerStartIndex,#self.timers do
        local timerParam=self.timers[i]
        if timerParam.delayTime<=self.pastTime then
            if self.skill.owner.curBlood <= 0 then--人死了不创建子弹
                self.bulletMgr:RemoveCreator(self)
                return
            end
            --context：碰撞触发子弹、死亡触发子弹重新索敌；timerParam：指向型子弹每波重新索敌
            self:CreateOneBullet(timerParam.angleOffset, self.context.redirect or timerParam.redirect)
        else
            self.timerStartIndex = i
            return
        end
    end
    self.bulletMgr:RemoveCreator(self)
end

function BulletCreator:GetBulletPosAndAngle()
    local pos = self.context.pos
    local angle = self.context.angle
    if self.skill and self.skill.owner then
        local firePointTransform = self.skill.owner:GetFirePoint()
        if not IsNull(firePointTransform) then
            if not pos then pos = firePointTransform.position end
            if not angle and firePointTransform.eulerAngles then angle = firePointTransform.eulerAngles.y end
        end
    end
    return pos or Vector3.zero, angle or 0
end

---targetPos不一定是坐标，也可能是目标unit
function BulletCreator:CreateOneBullet(angleOffset, redirect)
    local objId = self.bulletMgr:GetNextObjId()
    local pos, angle = self:GetBulletPosAndAngle()
    local index = self.context.index or 1
    local target = redirect and self.skill:Redirect(pos, self.context.exclusions, index == 1) or self.context.target
    local motherMeta = self.context.mother
    local inheritHitMap = self.context.exclusions

    local bulletClass
    if self.meta.mvt_type==BulletMoveType.Static then--不运动
        bulletClass=BulletStatic---@type Scene.LWBattle.Bullet.BulletStatic
    elseif self.meta.mvt_type==BulletMoveType.Straight then--直线子弹
        --if self.meta.is_following or self.param.forceFollowing then
        if self.meta.is_following then
            if target then
                bulletClass=BulletStraightTracking---@type Scene.LWBattle.Bullet.BulletStraight
            else
                return
            end
        else
            bulletClass=BulletStraight---@type Scene.LWBattle.Bullet.BulletStraight
        end
    elseif self.meta.mvt_type==BulletMoveType.Parabola then--抛物线子弹
        --if self.meta.is_following or self.param.forceFollowing then
        if self.meta.is_following then
            if target then
                bulletClass=BulletCurveTracking---@type Scene.LWBattle.Bullet.BulletStraight
            else
                return
            end
        else
            bulletClass=BulletCurve---@type Scene.LWBattle.Bullet.BulletCurve
        end
    elseif self.meta.mvt_type==BulletMoveType.Follow then--随枪口运动子弹
        bulletClass=BulletFollow---@type Scene.LWBattle.Bullet.BulletFollow
    elseif self.meta.mvt_type==BulletMoveType.Ray then--高速直线子弹，射线检测
        --if self.meta.is_following or self.param.forceFollowing then
        if self.meta.is_following then
            if target then
                bulletClass=BulletStraightTracking---@type Scene.LWBattle.Bullet.BulletStraight
            else
                return
            end
        else
            bulletClass=BulletRay---@type Scene.LWBattle.Bullet.BulletRay
        end
    end
    self.bulletMgr:CreateBullet(bulletClass,self.logic,self.bulletMgr,objId,self.meta,self.skill,index,pos,angle,angleOffset,target,inheritHitMap,motherMeta)
end



return BulletCreator
