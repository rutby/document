---
--- PVE 所有子弹基类
---
---@class Scene.LWBattle.Bullet.BulletBase
---@field meta DataCenter.PveBullet.PveBulletTemplate
local BulletBase = BaseClass("BulletBase")
local Physics = CS.UnityEngine.Physics
local Resource = CS.GameEntry.Resource
local Array = CS.System.Array
local RIGHT = Vector3.right
local UP = Vector3.up
local FORWARD = Vector3.forward
local ZERO = Vector3.zero



function BulletBase:__delete()
    self:Destroy()
end

function BulletBase:Destroy()
    self.hasData = nil
    --self.DEBUG_Destroy_Enter=1
    if self.warningEffectReq then
        self.warningEffectReq:Destroy()
        self.warningEffectReq = nil
        self.warningEffectTrans = nil
    end

    if self.prefabBulletOverride and self.bulletEffect then
        CS.UnityEngine.GameObject.Destroy(self.bulletEffect)
    end
    self.logic=nil
    self.timeMgr=nil
    self.bulletMgr=nil
    self.objId=nil
    self.meta=nil
    self.motherMeta=nil
    self.skill=nil
    self.owner=nil
    self.index=nil
    self.noCollision=nil
    self.angleOffset=nil
    self.startPos=nil
    self.rot=nil
    self.curPos=nil
    self.animCurve=nil
    self.heightWidthRatio=nil
    self.height=nil
    self.flySpeed=nil
    self.lifetime=nil
    self.fanHalfSin=nil
    self.colliderCenterOffset=nil
    if self.bulletEffectReq then
        self.bulletEffectReq:Destroy()
        self.bulletEffectReq=nil
    end
    self.bulletEffect=nil--@type CS.GameObject
    self.bulletEffectTrans=nil
    self.isBulletVisible=nil
    self.createTask=nil
    self.dotCD=nil
    self.dotMaxCD=nil
    if self.colliderArray then
        Array.Clear(self.colliderArray)
    end
    self.colliderArray = nil
    self.colliderType = nil
    self.targetLayerMask = nil
    self.targetAllyExcludeSelf = nil    
    self.targetSelfExcludeAlly = nil
    self.targetUnitType = nil
    self.target=nil
    self.collidedIdList=nil
    self.collidedTimes=nil
    self.base_type=nil
    self.bulletHp=nil
    self.inheritHitMap=nil
    self.collider=nil
    self.colliderRadius=nil
    self.dimension=nil
    self.colliderCenterOffset=nil
    self.colliderHeight=nil
    self.localHalfVector=nil
    self.prefabBulletOverride=nil
    self.inertiaVelocity=nil
    self.offset=nil
    self.lifetime=nil
    self.logicDie=nil
    self.bulletScale=nil
    self.scaledTime=nil
end

function BulletBase:Init(logic,bulletMgr, objId, meta, skill, index, startPos, startAngle, angleOffset, target, inheritHitMap, motherMeta)
    self.hasData = true
    self.logic=logic
    self.bulletMgr=bulletMgr---@type Scene.LWBattle.Bullet.BulletManager
    self.timeMgr=UITimeManager:GetInstance()
    self.objId=objId
    self.meta=meta
    self.motherMeta = motherMeta
    self.skill=skill
    self.owner=skill.owner
    self.index=index
    --无碰撞模式，此模式下不在update里做碰撞检测，用skill.forceLifeTime控制子弹的销毁时机
    self.noCollision = self.logic:GetPVEType()==PVEType.Skirmish or self.logic:GetPVEType()==PVEType.FakePVP
    self.angleOffset = angleOffset
    self.startPos=startPos--子弹初始位置
    if angleOffset then
        self.rot = Vector3.New(0, startAngle + angleOffset, 0)
    else
        self.rot = Vector3.New(0, startAngle, 0)
    end
    self.curPos=self.startPos--子弹当前位置,c#
    if not self.curPos then
        Logger.LogError(string.format("self.curPos,%s",index))
    end
    self.animCurve=self.bulletMgr:StringToCurve(self.meta.motion_curve)
    self.heightWidthRatio=self.meta.mvt_type_para--读配置
    self.height=self.meta.mvt_type_para_2--读配置
    if skill ~= nil and skill.isWorldTroopEffect then
        self.flySpeed = self.meta.bullet_fly_speed_world    --读配置
        self.lifetime = self.meta.lifetime_world            --子弹最大寿命
    else
        self.flySpeed = self.meta.bullet_fly_speed          --读配置
        self.lifetime = self.meta.lifetime                  --子弹最大寿命
    end
    if meta.melee_angle>0 then
        self.fanHalfSin=math.sin(meta.melee_angle*0.008725)--扇形半角正弦
    end

    if PVE_TEST_MODE and self.owner.bulletMotionEditor then
        --使用editor数据
        local motionEditor = self.owner.bulletMotionEditor
        self.animCurve = motionEditor.MotionCurve
        self.heightWidthRatio = motionEditor.HeightWidthRatio--读motionEditor
        self.height = motionEditor.Height--读motionEditor
        self.flySpeed = motionEditor.FlySpeed--读motionEditor
        if motionEditor.BulletEffect and not motionEditor.BulletEffect:Equals(nil) then    --子弹特效覆盖
            self.prefabBulletOverride = motionEditor.BulletEffect
        end
    end

    self.colliderCenterOffset = ZERO
    self.bulletEffect=nil--@type CS.GameObject
    self.bulletEffectReq=nil
    self.isBulletVisible=nil--bulletEffect可见性
    self.createTask=0
    self.dotCD=0--碰撞检测cd剩余时间
    self.dotMaxCD=0--碰撞检测cd最大时间
    self.colliderArray = Array.CreateInstance(typeof(CS.UnityEngine.Collider),self.meta.bullet_collide_limit)
    self.colliderType = ColliderType.Sphere
    self.targetLayerMask,self.targetAllyExcludeSelf,self.targetSelfExcludeAlly,self.targetUnitType =
    PveUtil.GetTargetLayer(self.owner.unitType,self.meta.target_type)
    self.target=target--技能目标，可能是坐标，可能是unit
    --if (not self.meta.is_following) and (not param.forceFollowing) then
    -- if (not self.meta.is_following) then
    if self.meta.base_type == BulletDurabilityType.Collide then--碰撞型子弹
        local limit = self.noCollision and 1 or self.meta.bullet_damage_count--子弹碰撞上限
        self.collidedIdList={}--记录碰撞过的objectID
        self.collidedTimes = 0--记录碰撞次数
        if limit<0 then--无限次的碰撞型子弹
            self.base_type=BulletDurabilityType.CollideInfinity
        else
            self.base_type=BulletDurabilityType.Collide
            self.bulletHp = limit--子弹的"血量"：子弹可以碰撞的次数
        end
    elseif self.meta.base_type == BulletDurabilityType.Time then--持续型型子弹
        self.base_type=BulletDurabilityType.Time
        self.dotMaxCD = self.meta.continuous_gap--持续型型子弹碰撞检测cd走配置
    end
    -- end
    self.inheritHitMap = inheritHitMap

end

--特效实例化，在__init()后调用
function BulletBase:Create()
    --self.DEBUG_Create_Enter=1
    self.createTask=0
    self:DoCreateSound()
    if self.prefabBulletOverride then--子弹特效
        self.bulletEffect=CS.UnityEngine.GameObject.Instantiate(self.prefabBulletOverride)
        self:InitBulletEffect()
    else
        local bulletEffect = self.meta:GetBulletEffect(self.owner.appearanceId)
        if not string.IsNullOrEmpty(bulletEffect) then
            self.isBulletVisible=false
            self.createTask=self.createTask+1
            self.bulletEffectReq = Resource:InstantiateAsync(bulletEffect)
            self.bulletEffectReq:completed('+', function(req)
                local go = req.gameObject
                if go then
                    self.createTask=self.createTask-1
                    self.bulletEffect = go
                    self.bulletEffectTrans = go.transform
                    self:InitBulletEffect()
                else
                    Logger.LogError("资源找不到！请检查路径！"..bulletEffect)
                end
            end)
        else
            self.isBulletVisible=true
        end
    end

    if not string.IsNullOrEmpty(self.meta.warning_effect) then
        self.warningEffectReq = Resource:InstantiateAsync(self.meta.warning_effect)
        self.warningEffectReq:completed('+', function(req)
            if req.gameObject then
                self.warningEffectTrans = req.gameObject.transform
                self:SyncWarningEffect()
            else
                Logger.LogError("资源找不到！请检查路径！"..self.meta.bullet_effect)
            end
        end)
    end
    --self.DEBUG_Create_Finish=1
end

function BulletBase:InitBulletEffect()
    if self.skill.isWorldTroopEffect then
        self.bulletScale = self.meta.bullet_effect_size_world
    else
        self.bulletScale = self.meta.bullet_effect_size
    end
    self.bulletEffectTrans:Set_localScale(self.bulletScale,self.bulletScale,self.bulletScale)
    self.bulletEffectTrans.position=self.startPos
    self.bulletEffectTrans:Set_eulerAngles(self.rot.x, self.rot.y, self.rot.z)
    self:SetBulletVisible(false)
    self:InitCollider()
    self:InitTrailRenderer()
end

function BulletBase:SyncWarningEffect()
    if self.target then
        if self.warningEffectTrans then
            local targetPos = self:GetTargetPos()
            if targetPos then
                self.warningEffectTrans.position = targetPos
            end
        end
    else
        if self.warningEffectReq then
            self.warningEffectReq:Destroy()
            self.warningEffectReq = nil
            self.warningEffectTrans = nil
        end
    end
end

function BulletBase:InitCollider()
    -- Sphere
    local haveSphereCollider,sphereCollider = self.bulletEffectTrans:TryGetComponent(typeof(CS.UnityEngine.SphereCollider))
    if haveSphereCollider then
        self.colliderType=ColliderType.Sphere
        self.collider=sphereCollider
        self.colliderRadius = self.collider.radius
        self.dimension=self.bulletScale*self.colliderRadius--线度，物体从各个方向来测量时的最大长度
        self.colliderCenterOffset = self.bulletEffectTrans:TransformPoint(self.collider.center)-self.startPos--c#
        return
    end
    -- Capsule
    local haveCapsuleCollider,capsuleCollider = self.bulletEffectTrans:TryGetComponent(typeof(CS.UnityEngine.CapsuleCollider))
    if haveCapsuleCollider then
        self.colliderType=ColliderType.Capsule
        self.collider=capsuleCollider
        self.colliderRadius = self.collider.radius
        self.colliderHeight = self.collider.height
        local dir = self.collider.direction
        local colliderDirection=RIGHT
        if dir==1 then
            colliderDirection=UP
        elseif dir==2 then
            colliderDirection=FORWARD
        end
        self.localHalfVector=colliderDirection*(self.colliderHeight*0.5)
        self.dimension =self.bulletScale*(self.colliderRadius+self.colliderHeight)--线度，物体从各个方向来测量时的最大长度
        self.colliderCenterOffset = self.bulletEffectTrans:TransformPoint(self.collider.center)-self.startPos--c#
        return
    end
    Logger.LogError("子弹没有Sphere或Capsule Collider，子弹名："..self.bulletEffect.name)
end

function BulletBase:InitTrailRenderer()
    local trailRenderer = self.bulletEffect:GetComponentsInChildren(typeof(CS.UnityEngine.TrailRenderer))
    for i = 0, trailRenderer.Length-1 do
        trailRenderer[i]:Clear()
    end
end

--展示开火特效和子弹特效，开火时调用
function BulletBase:Show()
    --self.DEBUG_Show_Enter=1
    self:SetBulletVisible(true)
end



function BulletBase:OnUpdate()

    if self.createTask>0 then--特效实例化未完成
        return
    end

    if self.createTask==0 then--特效实例化完成，播放开火特效
        --self.DEBUG_Show_Start=1
        self.createTask=-1
        self:Show()
        self:OnShow()--播放开火特效后(用来override)
        --self.DEBUG_Show_End=1
        return
    end

    if self:CheckDeath() or not self.isBulletVisible then--子弹已经死亡
        return
    end
    
    --更新碰撞逻辑(用来override)
    self:OnUpdateCollision()

    if not self.hasData then
        return
    end
    
    --更新位置(用来override)
    self:OnUpdateTransform()
    self:SyncWarningEffect()
    
    --Logger.Log(self.objId.."当前坐标："..self.curPos.x..","..self.curPos.z)
end


--播放开火特效后(用来override)
function BulletBase:OnShow()
end

--更新碰撞逻辑(用来override)
function BulletBase:OnUpdateCollision()
    if self.noCollision then
        return
    end
    self.dotCD = self.dotCD-Time.deltaTime
    if self.dotCD<=0 then--碰撞检测cd好
        self.dotCD = self.dotMaxCD
        self:CollisionDetection()
    end
end

--更新位置(用来override)
function BulletBase:OnUpdateTransform()
end

--碰撞检测(用来override)
function BulletBase:CollisionDetection()
    if DataCenter.LWBattleManager:UseNewDetect() then
        local pos = self:GetColliderCenterWorldPos()
        local radius = self.bulletScale * self.colliderRadius
        local units = nil
        local logic = DataCenter.LWBattleManager.logic
        if self.colliderType==ColliderType.Sphere then
            units = PveUtil.GetAllUnitsInSphereRange(logic, pos, radius, self.targetLayerMask)
        else
            local sizeX = radius * 2
            local sizeZ = self.bulletScale * self.colliderHeight
            units = PveUtil.GetAllUnitsInBoxRange(logic, pos, sizeX, sizeZ, self.targetLayerMask)
        end
        if units then
            local count = #units
            if count <= 0 then
                return
            end
            local remainCount = self.meta.bullet_collide_limit--单次碰撞上限
            local hasCollision = false
            for _, unit in ipairs(units) do
                if remainCount <= 0 then
                    break
                end
                local collideSuccess = self:DoCollisionForTarget(unit.collider, pos)
                hasCollision = collideSuccess or hasCollision
                if collideSuccess then
                    remainCount = remainCount - 1
                end
            end
            if hasCollision then
                self:DoCollisionForBullet()
            end
        end
    else
        local pos = self:GetColliderCenterWorldPos()
        local radius = self.bulletScale * self.colliderRadius
        local layerMask = self.targetLayerMask
        local cnt
        if self.colliderType==ColliderType.Sphere then
            cnt = Physics.OverlapSphereNonAlloc(pos, radius, self.colliderArray, layerMask)
        else
            local halfVector =self.bulletEffectTrans:TransformVector(self.localHalfVector)
            local point0=pos+halfVector
            local point1=pos-halfVector
            cnt = Physics.OverlapCapsuleNonAlloc(point0,point1,radius,self.colliderArray,layerMask)
            --if not self.owner.create then
            --    self.owner.create=true
            --    local cube1=CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube)
            --    local cube2=CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube)
            --    local cube3=CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube)
            --    cube1.transform.position = point0
            --    cube2.transform.position = point1
            --    cube3.transform.position = point1+Vector3.New(0,radius,0)
            --    cube1.transform.localScale=Vector3.one*0.1
            --    cube2.transform.localScale=Vector3.one*0.1
            --    cube3.transform.localScale=Vector3.one*0.1
            --    cube1.transform:SetParent(self.bulletEffectTrans)
            --    cube2.transform:SetParent(self.bulletEffectTrans)
            --    cube3.transform:SetParent(self.bulletEffectTrans)
            --end
        end
        if cnt <= 0 then
            return
        end
        local remainCount = self.meta.bullet_collide_limit--单次碰撞上限
        local hasCollision = false
        for i = 1, cnt do
            if remainCount <= 0 then
                break
            end
            local collider = self.colliderArray[i-1]
            local collideSuccess = self:DoCollisionForTarget(collider,pos)
            hasCollision = collideSuccess or hasCollision
            if collideSuccess then
                remainCount = remainCount - 1
            end
        end
        --if self.targetSelfExcludeAlly then--layerMask里没有友方阵营，但是目标包含owner，则需要额外检测子弹与owner的碰撞
        --    if Vector3.Magnitude(pos-self.owner:GetPosition()) < radius + self.owner:GetCollider().radius then
        --        hasCollision = self:DoCollisionForTarget(self.owner:GetCollider(),pos) or hasCollision
        --    end
        --end
        if hasCollision then
            self:DoCollisionForBullet()
        end
    end
end


--碰撞发生后，处理被撞者逻辑
--发生碰撞返回true；没有碰撞返回false
function BulletBase:DoCollisionForTarget(collider,bulletEffectPos)
    if not self:TargetFilter(collider) then
        return false
    end
    local exclusion = self.targetAllyExcludeSelf and self.owner or nil--layerMask里有友方阵营，但是目标不包含自己
    local trigger = collider:GetComponent(typeof(CS.CitySpaceManTrigger))
    --碰撞盒上有CitySpaceManTrigger
    if trigger ~= nil and trigger.ObjectId ~= 0 then
        local objId = trigger.ObjectId
        local obj = self.bulletMgr:GetUnit(objId)
        --被打者血量大于0
        if obj ~= nil and obj:GetCurBlood() > 0 and obj ~= exclusion then
            --有限碰撞型子弹
            if self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity then
                --碰撞型子弹碰到了重复的人
                if self:IsCollideDuplicately(objId) then
                    return false
                else
                    self:RealDoCollisionForTarget(collider,bulletEffectPos,obj)
                    self.collidedIdList[objId] = true
                    self.collidedTimes = self.collidedTimes + 1
                    return true
                end
            else--持续型子弹
                self:RealDoCollisionForTarget(collider,bulletEffectPos,obj)
                return true
            end
        end
    end
    return false
end

function BulletBase:IsCollideDuplicately(objId)
    if self.collidedIdList and self.collidedIdList[objId] then
        return true
    end
    if self.inheritHitMap and self.inheritHitMap[objId] then
        return true
    end
    return false
end

function BulletBase:RealDoCollisionForTarget(collider,bulletEffectPos,obj)
    --Logger.Log("self.index"..self.index)
    --Logger.Log("self.skillDamage"..self.skillDamage[1]..","..self.skillDamage[2]..","..self.skillDamage[3])
    if self.skill:IsNil() then
        return
    end
    --伤害倍率
    local damage = self.skill:GetBulletDamageFactor(self.index) * self.meta.damage
    if self.collidedTimes and self.collidedTimes > 0 then
        for i = 1, self.collidedTimes do
            damage = damage * self.meta.bullet_damage_attenuation
        end
    end
    if damage <= 0 then
        return
    end
    --打击点（碰撞点）：决定击中特效位置
    local hitPoint=collider:ClosestPoint(bulletEffectPos)
    --打击方向：决定击退的方向，以及子弹击中特效的方向
    --方案1：类似于打台球的效果，打击方向为表面法线方向，由打击点指向被打物体中心
    --local hitDir = collider.transform.position - hitPoint
    --方案2：打击方向为子弹运动的方向，由子弹初始位置指向打击点
    local hitDir = hitPoint-self.startPos
    hitDir=Vector3.New(hitDir.x,0,hitDir.z)
    --闪白时间
    local whiteTime=self.meta.white_time
    --硬直时间
    local stiffTime=self.meta.hit_stiff_time
    --击退位移
    local hitBackDistance
    if self.meta.hit_back_distance>0 then
        hitBackDistance=hitDir:SetNormalize()*self.meta.hit_back_distance
    end
    --hitDir没有单位化，以节省性能
    self.bulletMgr:DealDamage(self.owner,obj,self.meta,damage,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,self.meta.hit_effect,self.skill)
end



--碰撞发生后，处理子弹自身的逻辑
function BulletBase:DoCollisionForBullet()
    --震屏
    self:DoHitShake()
    --音效
    self:DoHitSound()
    --碰撞触发子弹
    self:DoHitTriggerNewBullet()
    --子弹耐久更新
    self:RefreshBulletHp()
end

function BulletBase:DoCreateSound()
    local sound = self.meta.create_sound:GetRandom()
    if sound then
        DataCenter.LWSoundManager:PlaySoundWithLimit(sound,SoundLimitType.BulletCreate)
    end
end
function BulletBase:DoHitSound()
    local sound = self.meta.hit_sound:GetRandom()
    if sound then
        DataCenter.LWSoundManager:PlaySoundWithLimit(sound,SoundLimitType.BulletHit)
    end
end

--触发亡语
function BulletBase:TriggerDeathRattle()
    if self.skill:IsNil() then
        return
    end
    if self.meta.death_rattle_bullet > 0 then--如果有亡语
        self.bulletMgr:CreateBulletCreator(self.meta.death_rattle_bullet,self.skill,{pos=self:GetPosition(), angle=self:GetAngle(), index=self.index+1, redirect=true})
    end

    if self.meta.hit_monster_born then
        --死亡召唤
        if self.owner and self.logic and self.logic.SummonMonster then
            self.logic:SummonMonster(self:GetPosition(), self.owner, self.meta.hit_monster_born[1], self.meta.hit_monster_born[2], self.meta.hit_monster_born[3])
        end
    end
end



--返回子弹是否是死亡状态，有两种死亡状态：
--self.lifetime第一次降到0时进入logicDie状态————不再运动和碰撞，logicDie=true,self.lifetime=self.meta.dead_delay
--self.lifetime第二次降到0时进入renderDie状态————bullet:Destroy(),gameObject回缓存池
function BulletBase:CheckDeath()
    self.lifetime = self.lifetime - Time.deltaTime
    if self.lifetime<=0 then
        if not self.logicDie then
            self:LogicDie()
        else
            self:RenderDie()
        end
        return true
    end
    return self.logicDie
end


--逻辑上死亡，不再造成伤害（渲染上还没死）
function BulletBase:LogicDie()
    if not self.hasData then
        return
    end
    if self.logicDie then
        return
    end
    self.logicDie=true
    self:TriggerDeathRattle()
    if self.meta.dead_delay>0 then
        self.lifetime=self.meta.dead_delay
    else
        self:RenderDie()
    end
end


--渲染上死亡
function BulletBase:RenderDie()
    --if BULLET_LOG and self.bulletEffect then
    --    Logger.Log("子弹销毁!name:"..self.bulletEffect.name..",index:"..self.index..",meta:"..self.meta.id..",寿命："..self.meta.lifetime)
    --end
    self.bulletMgr:RemoveBullet(self)
end

--击中时震屏
function BulletBase:DoHitShake()
    if self.meta.hitShakeParam then
        self.bulletMgr:ShakeCameraWithParam(self.meta.hitShakeParam)
    end
end

--碰撞触发子弹
function BulletBase:DoHitTriggerNewBullet(pos)
    pos = pos or self:GetPosition()
    if self.motherMeta and self.motherMeta.second_attack > 0 and self.index <= self.motherMeta.second_attack_count then--如果碰撞可以触发子弹，碰撞触发子弹配置以顶层母弹配置为准
        local exclusions = {}
        table.merge(exclusions, self.collidedIdList)
        if not self.motherMeta.second_attack_repeat then
            table.merge(exclusions, self.inheritHitMap)
        end
        self:CreateChildBulletCreator(pos, exclusions)
    end
end

function BulletBase:CreateChildBulletCreator(pos, exclusions)
    local newTarget = self.skill:Redirect(pos, exclusions, false)
    if not newTarget then return end
    local aimDir = newTarget:GetPosition() - pos
    aimDir.y = 0
    aimDir = aimDir.normalized
    local angle = Vector3.Angle(Vector3.forward, aimDir)
    self.bulletMgr:CreateBulletCreator(self.motherMeta.second_attack,self.skill,{pos=pos, angle=angle, target=newTarget, index=self.index+1, redirect=false, exclusions=exclusions, mother=self.motherMeta})
end

--更新子弹hp(碰撞次数）
function BulletBase:RefreshBulletHp()
    --子弹耐久更新
    if self.base_type == BulletDurabilityType.Collide then--有限碰撞型子弹，用完后消失
        self.bulletHp = self.bulletHp - 1
        if self.bulletHp<=0 then--子弹碰撞次数用尽
            self:LogicDie()
        end
        --else--持续型子弹，或无限次的碰撞型子弹，一定时间后消失
    end
end


--显隐
function BulletBase:SetBulletVisible(visible)
    self.isBulletVisible = visible
    if self.bulletEffect then
        self.bulletEffect:SetActive(visible)
    end
end

function BulletBase:GetTargetPos()
    if not self.target then
        return self.owner:GetPosition()
    elseif self.target.unitType then
        return self.target:GetPosition()
    elseif self.target.x and self.target.z then
        return self.target
    end
    return nil
end


--检查目标是否在扇形范围内
function BulletBase:TargetFilter(collider)
    if not self.fanHalfSin then
        return true
    end
    local cannonTrans = self.owner.cannon
    if not cannonTrans then
        return false
    end
    local targetPos = collider.transform.position
    targetPos.y = 0
    local ownerPos = self.owner:GetPosition()
    ownerPos.y = 0
    local targetDir = targetPos-ownerPos
    targetDir = targetDir.normalized
    local cannonWorldForward
    if self.owner.localForward then
        cannonWorldForward = cannonTrans:TransformDirection(self.owner.localForward)
    else
        cannonWorldForward = cannonTrans.forward
    end
    local cross=Vector3.Cross(cannonWorldForward,targetDir)
    local deg=math.abs(cross.y)--和目标的夹角的正弦的绝对值
    --和目标的夹角 小于 扇形半角。仅仅检查正弦不足以判断前后，要同时保证夹角余弦为正
    if deg < self.fanHalfSin and Vector3.Dot(cannonWorldForward,targetDir)>0 then
        return true
    else
        return false
    end
end


function BulletBase:GetPosition()
    return self.curPos--子弹当前位置,c#
end

--pos 是 CS.UnityEngine.Vector3
function BulletBase:SetPosition(pos)
    self.curPos=pos--子弹当前位置,c#
    if self.bulletEffect then
        self.bulletEffectTrans.position = pos
    end
end

function BulletBase:GetAngle()
    if not IsNull(self.bulletEffectTrans) then
        return self.bulletEffectTrans.eulerAngles.y
    else
        return 0
    end
end

function BulletBase:GetColliderCenterWorldPos()--c#
    --if not self.curPos then
    --    Logger.LogError(string.format("self.curPos==nil,%s,%s,%s,%s,%s,%s",self.DEBUG_Show_Start,self.DEBUG_Show_Enter,
    --            self.DEBUG_Show_End,self.DEBUG_Create_Enter,self.DEBUG_Create_Finish,self.DEBUG_Destroy_Enter))
    --end
    --if not self.colliderCenterOffset then
    --    Logger.LogError(string.format("self.colliderCenterOffset==nil,%s,%s,%s,%s,%s,%s",self.DEBUG_Show_Start,self.DEBUG_Show_Enter,
    --            self.DEBUG_Show_End,self.DEBUG_Create_Enter,self.DEBUG_Create_Finish,self.DEBUG_Destroy_Enter))
    --end
    return self:GetPosition() + self.colliderCenterOffset
end


return BulletBase
