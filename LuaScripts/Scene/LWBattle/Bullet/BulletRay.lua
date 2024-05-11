
---PVE 子弹：射线
---不做碰撞检测，开火瞬间做一次射线检测
local base = require("Scene.LWBattle.Bullet.BulletBase")
local IgnoreTrigger = CS.UnityEngine.QueryTriggerInteraction.Ignore
local Physics = CS.UnityEngine.Physics
local Array = CS.System.Array
local SUPER_FAST_SPEED = 50

---@class Scene.LWBattle.Bullet.BulletRay : Scene.LWBattle.Bullet.BulletBase
local BulletRay = BaseClass("BulletRay",base)
local speed=Vector3.zero


function BulletRay:Create()
    if self.index==1 then
        --枪口创建的子弹，子弹初速度要叠加枪口速度（惯性速度）lua
        self.inertiaVelocity = self.owner:GetMoveVelocity()
    else
        self.inertiaVelocity = Vector3.zero
    end
    self.diePercent = DIE_PERCENT
    self.defenders = {}
    base.Create(self)
end

function BulletRay:Destroy()
    base.Destroy(self)
    if self.rayHitArray then
        Array.Clear(self.rayHitArray)
    end
    self.rayHitArray = nil
    self.defenders = nil
    self.worldVelocity = nil
    self.worldForward = nil
    self.totalDisplacement = nil
    self.totalDistance = nil
end

--update里不做碰撞检测，射线检测在子弹实例化时就做完了，所有被打者存在一个table里，这里做的是被打者受伤害逻辑
function BulletRay:OnUpdateCollision()
end


function BulletRay:OnShow()
    --self.flySpeed表示子弹相对于枪口的速率（即配置的速率）
    if self.skill ~= nil and self.skill.isWorldTroopEffect then
        self.duration=self.meta.lifetime_world
    else
        self.duration=self.meta.lifetime
    end
    --self.startTime=self.timeMgr:GetServerTime()
    self.scaledTime=0
    self.worldForward=self.bulletEffectTrans.forward--c#

    if self.noCollision then
        --self.duration是按照pve配置算出的最大射程；forceLifeTime是后端算出的实际弹道距离；射程不可能小于距离
        if self.duration<self.skill.forceLifeTime then
            self.duration = self.skill.forceLifeTime * 1.2--多0.2是为了保证射线起点在碰撞盒外边
        end
        --noCollision模式不考虑惯性速度
        self.flySpeed = self.skill.meta.horizontal_speed
        self.worldVelocity = self.worldForward * self.skill.meta.horizontal_speed--子弹相对世界速度,c#
    else
        local flyVelocity = self.worldForward * self.flySpeed--子弹相对枪口速度,c#
        self.worldVelocity = flyVelocity + self.inertiaVelocity--子弹相对世界速度,c#
    end
    self.totalDisplacement = self.worldVelocity * self.duration--子弹相对世界总位移,c#
    local luaVec = Vector2.New(self.totalDisplacement.x,self.totalDisplacement.z)--c#转lua
    self.totalDistance = Vector2.Magnitude(luaVec)--子弹相对世界总路程
    if self.base_type==BulletDurabilityType.Collide or self.base_type==BulletDurabilityType.CollideInfinity then--碰撞型子弹
        self.rayHitArray = Array.CreateInstance(typeof(CS.UnityEngine.RaycastHit),32)
        --开火瞬间做一次射线检测
        self:RaycastDetection()
    else
        Logger.LogError("射线子弹持续型")
    end
end



--更新位置
function BulletRay:OnUpdateTransform()
    if self.animCurve then
        --local now = self.timeMgr:GetServerTime()
        --local t=(now-self.startTime)*0.001/self.duration--百分比时间
        self.scaledTime=self.scaledTime+Time.deltaTime
        local t=self.scaledTime/self.duration--百分比时间
        if t<self.diePercent then
            local p=self.animCurve:Evaluate(t)--百分比路程
            self:SetPosition(self.startPos + self.totalDisplacement * p)
            if self.flySpeed<=SUPER_FAST_SPEED then--慢速子弹，运动到目标处理受伤逻辑
                for i = #self.defenders, 1,-1 do
                    if p > self.defenders[i].perDis then
                        self:DoCollision(self.defenders[i].rayHit)
                        table.remove(self.defenders,i)
                    else
                        break
                    end
                end
            end
        else
            for i = #self.defenders, 1,-1 do
                self:DoCollision(self.defenders[i].rayHit)
            end
            self:LogicDie()
        end
    else
        speed.z = self.flySpeed * Time.deltaTime
        self.bulletEffectTrans:Translate(speed)
    end
    
end




local function partition_distance(arr, left, right)
    local pivotIndex = math.floor((left + right) / 2)
    local pivotValue = arr[pivotIndex].distance
    arr[pivotIndex], arr[right] = arr[right], arr[pivotIndex]
    local storeIndex = left
    for i = left, right - 1 do
        if arr[i].distance < pivotValue then
            arr[i], arr[storeIndex] = arr[storeIndex], arr[i]
            storeIndex = storeIndex + 1
        end
    end
    arr[storeIndex], arr[right] = arr[right], arr[storeIndex]
    return storeIndex
end

local function quickselect_distance(arr, left, right, n)
    if left == right then
        return arr[left]
    end
    local pivotIndex = partition_distance(arr, left, right)
    local k = pivotIndex - left + 1
    if n == k then
        return arr[pivotIndex]
    elseif n < k then
        return quickselect_distance(arr, left, pivotIndex - 1, n)
    else
        return quickselect_distance(arr, pivotIndex + 1, right, n - k)
    end
end

local function find_min_distance_n(arr, n)
    local left = 1
    local right = #arr
    local min_n = {}
    for i = 1, n do
        local min = quickselect_distance(arr, left, right, i)
        table.insert(min_n, min)
    end
    return min_n
end



function BulletRay:RaycastDetection()
    local layerMask = self.targetLayerMask
    --由于Physics.Raycast不检测包住origin的collider，所以射线起点放在最远点，从最远点射向开火点
    local origin = self.startPos + self.totalDisplacement
    local dir = self.worldVelocity * (-1)
    --CS.UnityEngine.Debug.DrawRay(origin,self.totalDisplacement * (-1),CS.UnityEngine.Color.red,1)
    local cnt=Physics.RaycastNonAlloc(origin,dir,self.rayHitArray,self.totalDistance,layerMask,IgnoreTrigger)
    if (not cnt) or cnt <= 0 then
        return
    end
    
    local limit = self.noCollision and 1 or self.meta.bullet_damage_count--子弹碰撞上限

    if self.flySpeed>SUPER_FAST_SPEED then--超快速子弹，开火瞬间处理受伤逻辑
        if limit<0 or cnt<limit then--子弹碰撞无上限
            for i = 1, cnt do
                self:DoCollision(self.rayHitArray[i-1])
            end
        else
            local arr = {}
            for i = 1, cnt do
                arr[i]=self.rayHitArray[i-1]
            end
            arr = self:FindMax(arr,limit)
            ---arr = self:find_closest_n(arr,limit)
            for i = 1, limit do
                self:DoCollision(arr[i])
            end
            self.diePercent = (self.totalDistance-arr[1].distance)/self.totalDistance--死亡百分比时间（路程）
        end
    else--慢速子弹，记录被打者，子弹运动到目标再处理受伤逻辑
        if limit<0 or cnt<limit then--子弹碰撞无上限
            for i = 1, cnt do
                local defender = {["rayHit"]=self.rayHitArray[i-1], 
                                  ["perDis"]=(self.totalDistance-self.rayHitArray[i-1].distance)/self.totalDistance}
                self.defenders[i]=defender
                table.sort(self.defenders,function(a,b) return a.perDis>b.perDis end)--按距离降序
            end
        else
            local arr = {}
            for i = 1, cnt do
                arr[i]=self.rayHitArray[i-1]
            end
            arr = self:FindMax(arr,limit)
            --arr = self:find_closest_n(arr,limit)
            for i = 1, limit do--按距离降序
                local defender = {["rayHit"]=self.rayHitArray[i-1],
                                  ["perDis"]=(self.totalDistance-self.rayHitArray[i-1].distance)/self.totalDistance}
                self.defenders[i]=defender
            end
            self.diePercent = (self.totalDistance-arr[1].distance)/self.totalDistance--死亡百分比时间（路程）
        end
    end

end

function BulletRay:DoCollision(rayHit)
    self:DoCollisionForTarget(rayHit)
    self:DoCollisionForBullet(rayHit.point)
end

function BulletRay:FindMax(arr,n)
    local cnt=#arr
    local ret = {}
    for i = 1, n do
        local max = arr[1]
        local maxIndex = 1
        for j = 2, cnt-i+1 do
            if arr[j].distance>max.distance then
                max = arr[j]
                maxIndex = j
            end
        end
        table.remove(arr,maxIndex)
        ret[n-i+1]=max
    end
    return ret
end

function BulletRay:FindMin(arr,n)
    local cnt=#arr
    local ret = {}
    for i = 1, n do
        local min = arr[1]
        local minIndex = 1
        for j = 2, cnt-i+1 do
            if arr[j].distance<min.distance then
                min = arr[j]
                minIndex = j
            end
        end
        table.remove(arr,minIndex)
        ret[n-i+1]=min
    end
    return ret
end

function BulletRay:find_closest_n(arr, n)--chatgpt生成
    local heap = {}
    for i = 1, #arr do
        local elem = arr[i]
        table.insert(heap, elem)
        local j = #heap
        while j > 1 do
            local parent = math.floor(j / 2)
            if heap[j].distance > heap[parent].distance then
                heap[j], heap[parent] = heap[parent], heap[j]
                j = parent
            else
                break
            end
        end
        if #heap > n then
            table.remove(heap, 1)
            local j = 1
            while true do
                local left = j * 2
                local right = left + 1
                local smallest = j
                if left <= #heap and heap[left].distance > heap[smallest].distance then
                    smallest = left
                end
                if right <= #heap and heap[right].distance > heap[smallest].distance then
                    smallest = right
                end
                if smallest ~= j then
                    heap[j], heap[smallest] = heap[smallest], heap[j]
                    j = smallest
                else
                    break
                end
            end
        end
    end
    return heap
end




--碰撞发生后，处理被打者的逻辑
function BulletRay:DoCollisionForTarget(rayHit)
    local trigger = rayHit.transform:GetComponent(typeof(CS.CitySpaceManTrigger))
    if not trigger or trigger.ObjectId <= 0 then
        return
    end
    local objId = trigger.ObjectId
    local obj = self.bulletMgr:GetUnit(objId)
    --被打者血量大于0
    if not obj or obj:GetCurBlood() <= 0 then
        return
    end
    
    --伤害倍率
    local damage = self.skill:GetBulletDamageFactor(self.index) * self.meta.damage
    if damage <= 0 then
        return
    end
    --被打者碰撞盒中心
    local center = rayHit.transform:TransformPoint(rayHit.collider.center)
    --打击点（碰撞点），由于反向射线，射线与碰撞体交点在被打者背面，需要以被打者中心为中心点做中心对称
    local hitPoint= 2 * center - rayHit.point
    --方案2：打击方向为子弹运动的方向，由子弹初始位置指向打击点
    local hitDir = hitPoint - self.startPos
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
function BulletRay:DoCollisionForBullet(pos)
    --震屏
    self:DoHitShake()
    --碰撞触发子弹
    self:DoHitTriggerNewBullet(pos)
end

return BulletRay