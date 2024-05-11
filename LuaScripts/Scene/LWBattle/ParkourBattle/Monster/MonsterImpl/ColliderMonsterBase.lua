---
--- Created by wjy.
---
local base = require "Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj"
---@class Scene.LWBattle.ParkourBattle.Monster.MonsterImp.ColliderMonsterBase : Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj 
local ColliderMonsterBase = BaseClass("ColliderMonsterBase",base)
local Const = require("Scene.LWBattle.Const")
local Collider = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")


function ColliderMonsterBase:Init(logic,mgr,guid,x,y,monsterMeta)
    base.Init(self,logic,mgr,guid,x,y,monsterMeta)
    self.colliderComponent = Collider.New()
    self.dontCollid = {}
    self.collidCnt = monsterMeta.collide_count
end


function ColliderMonsterBase:OnLoadComplete()
    -- colliderComponent
    self.colliderComponent:InitCollider(self.transform, 10, LayerMask.GetMask("Member"))
    self.colliderComponent:SetOnCollide(function (collderCnt, colliderComponentArray )
        if collderCnt>0 then
            self:OnCollision(collderCnt, colliderComponentArray )
        end
    end)
end

function ColliderMonsterBase:OnUpdate()
    base.OnUpdate(self)
    if self.colliderComponent then
        self.colliderComponent:CollisionDetect()
    end

    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
        self:UpdateReversePos()
    end
end

function ColliderMonsterBase:UpdateReversePos()
    local deltaTime = Time.deltaTime
    local pos = self:GetPosition()
    local add = self.logic:GetMoveSpeedZ() * deltaTime
    local z = pos.z - add

    self.y = z

    if self.transform then
        self.transform:Set_position(pos.x, 0, z)
    else
        self.curWorldPos.z = z
    end
end

function ColliderMonsterBase:OnCollision(collderCnt, colliderComponentArray )
    for i = 0, collderCnt-1, 1 do
        self:Attack(colliderComponentArray[i])
    end
end


function ColliderMonsterBase:Attack(otherObj)
    local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger~=nil and trigger.ObjectId~=0 and self.dontCollid[trigger.ObjectId] == nil then
        base.DoColliderEffect(self)
        self.dontCollid[trigger.ObjectId] = 1 
        local tar = DataCenter.LWBattleManager.logic:GetUnit(trigger.ObjectId)
        --只能碰真伤
        if tar and (tar.curBlood or 0 )> 0 and #self.monsterMeta.collide_damage==3 and self.monsterMeta.collide_damage[1] == 2 then
            self:CollidEffect(tar)

            self.battleMgr:DealDamage(
                self,
                tar,
                {},
                1,
                tar:GetPosition(),
                nil,
                0.2,
                nil,nil,nil,nil,
                self.monsterMeta.collide_damage[2], -- ex type
                self.monsterMeta.collide_damage[3]  -- exvalue
            )
            self.collidCnt = self.collidCnt - 1
            if self.collidCnt == 0 then
                self:Death()
            end
        end
    end
end




function ColliderMonsterBase:DestroyView()
    base.DestroyView(self)
    if self.colliderComponent then
        self.colliderComponent:Destroy()
        self.colliderComponent = nil
    end
end


function ColliderMonsterBase:DestroyData()
    self.dontCollid=nil
    self.collidCnt=nil
    base.DestroyData(self)
end

function ColliderMonsterBase:CollidEffect(tar)
    self.battleMgr:ShowEffectObj(
        Const.ParkourCollidEffectPath, tar:GetPosition(),nil,1,nil
    )
end

return ColliderMonsterBase
