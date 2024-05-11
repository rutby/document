---
--- PVE 子弹管理器：所有子弹的创建、销毁、刷新
---

---@class Scene.LWBattle.Bullet.BulletManager
local BulletManager = BaseClass("BulletManager")

local BulletCreator = require"Scene.LWBattle.Bullet.BulletCreator"
local BulletStraight = require"Scene.LWBattle.Bullet.BulletStraight"
local BulletStraightTracking = require"Scene.LWBattle.Bullet.BulletStraightTracking"
local BulletCurve = require"Scene.LWBattle.Bullet.BulletCurve"
local BulletCurveTracking = require"Scene.LWBattle.Bullet.BulletCurveTracking"
local BulletStatic = require"Scene.LWBattle.Bullet.BulletStatic"
local BulletFollow = require"Scene.LWBattle.Bullet.BulletFollow"
local BulletRay = require"Scene.LWBattle.Bullet.BulletRay"

function BulletManager:__init(battleMgr)
    self.battleMgr=battleMgr
    self.nextObjId=0
    self.bullets={}
    self.creators={}
    self.curves={}

end

function BulletManager:__delete()
    self:Destroy()
end

function BulletManager:Destroy()
    self:ResetData()
end

function BulletManager:ResetData()
    if self.bullets then
        for _,v in pairs(self.bullets) do
            v:Delete()
        end
        self.bullets={}
    end
    if self.creators then
        for _,v in pairs(self.creators) do
            v:Delete()
        end
        self.creators={}
    end
    self.curves={}
    ObjectPool:GetInstance():Clear(BulletCreator)
    ObjectPool:GetInstance():Clear(BulletStraight)
    ObjectPool:GetInstance():Clear(BulletStraightTracking)
    ObjectPool:GetInstance():Clear(BulletCurve)
    ObjectPool:GetInstance():Clear(BulletCurveTracking)
    ObjectPool:GetInstance():Clear(BulletStatic)
    ObjectPool:GetInstance():Clear(BulletFollow)
    ObjectPool:GetInstance():Clear(BulletRay)

end


---index：该子弹是该技能生成的第几个子弹，用于查询skill配表的伤害倍率
function BulletManager:CreateBulletCreator(metaId,skill,context)
    local meta = DataCenter.PveBulletTemplateManager:GetTemplate(metaId)
    if not context.mother then context.mother = meta end
    if not context.index then context.index = 1 end
    local objId = self:GetNextObjId()
    local bulletCreator = ObjectPool:GetInstance():Load(BulletCreator)
    local success = bulletCreator:Init(self.battleMgr,self,objId,meta,skill,context)---@type Scene.LWBattle.Bullet.BulletCreator
    if success then
        self.creators[bulletCreator.objId]=bulletCreator
    end
end

function BulletManager:CreateBullet(class,logic,bulletMgr, objId, meta, skill, index, startPos, startAngle, angleOffset, target, inheritHitMap, motherMeta)
    local bullet = ObjectPool:GetInstance():Load(class)
    bullet:Init(logic,bulletMgr, objId, meta, skill, index, startPos, startAngle, angleOffset, target, inheritHitMap, motherMeta)
    bullet:Create()
    self.bullets[bullet.objId]=bullet
end

function BulletManager:OnUpdate()
    for _,v in pairs(self.bullets) do
        if v.objId then
            v:OnUpdate()
        end
    end
    for _,v in pairs(self.creators) do
        if v.objId then
            v:OnUpdate()
        end
    end
end


function BulletManager:RemoveBullet(bullet)
    self.bullets[bullet.objId]=nil
    bullet:Delete()
    ObjectPool:GetInstance():Save(bullet)
end

function BulletManager:RemoveCreator(creator)
    self.creators[creator.objId]=nil
    creator:Delete()
    ObjectPool:GetInstance():Save(creator)
end


function BulletManager:GetNextObjId()
    self.nextObjId = self.nextObjId + 1
    return self.nextObjId
end

function BulletManager:ShakeCameraWithParam(shakeCameraParam)
    self.battleMgr:ShakeCameraWithParam(shakeCameraParam)
end


function BulletManager:DealDamage(attacker,defender,bulletMeta,damageMultiplier,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill)
    if bulletMeta.hit_clear_buff and defender then
        for buffId, count in pairs(bulletMeta.hit_clear_buff) do
            defender.buffManager:RemoveBuffByMetaId(buffId, count)
        end
    end
    return self.battleMgr:DealDamage(attacker,defender,bulletMeta,damageMultiplier,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill)
end

function BulletManager:GetUnit(objId)
    return self.battleMgr:GetUnit(objId)
end


function BulletManager:StringToCurve(str)
    if string.IsNullOrEmpty(str) then
        str = DEFAULT_BULLET_MOTION_STRING
    end
    local curve = self.curves[str]
    if not curve then
        curve=CS.BulletMotionEditor.StringToCurve(str)
        self.curves[str]=curve
    end
    return curve
end

return BulletManager