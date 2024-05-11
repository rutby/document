---
--- PVE 丧尸
---

local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local Const = require("Scene.PVEBattleLevel.Const")


local Zombie = BaseClass("Zombie")

local IdleState = require"Scene.PVEBattleLevel.Zombie.ZombieIdleState"
local MoveState = require"Scene.PVEBattleLevel.Zombie.ZombieMoveState"
local AttackState = require"Scene.PVEBattleLevel.Zombie.ZombieAttackState"
local DeadState = require"Scene.PVEBattleLevel.Zombie.ZombieDeadState"

Zombie.State = 
{
    Idle = 1,
    Move = 2,
    Attack = 3,
    Dead = 4
}

Zombie.Anim =
{
    Stand = "Idle",
    Walk = "Run",
    Attack = "Attack",
    RunAttack = "RunAttack",
}

local Anim = Zombie.Anim
local State = Zombie.State

local function SetState(zombie, stateIndex, ...)
    if zombie.currStateIndex == stateIndex then
        return
    end
    --print("Zombie set state", zombie.objId, zombie.currStateIndex, "->", stateIndex)
    zombie.currState:OnExit()
    zombie.currStateIndex = stateIndex
    zombie.currState = zombie.stateList[zombie.currStateIndex]
    zombie.currState:OnEnter(...)
end

function Zombie:__init(battleLevel, objId, tempId)
    self.objId = objId
    self.tempId = tempId
    self.position = Vector3.zero
    self.rotation = Quaternion.identity
    self.currStateIndex = State.Idle
    self.currState = nil
    self.battleLevel = battleLevel
    self.stateList = {}
    self.animator = nil
    self.animListen = nil
    self.tombstone = nil
    self.attackTargetId = nil
    self.pathIndex = 2
    self.isVisible = true
    self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
end

function Zombie:__delete()
    
end

function Zombie:Create()
    local templateMgr = DataCenter.PveZombieTemplateManager
    self.template = templateMgr:GetTemplate(self.tempId)

    self.path = {}
    --print("zombie create ", self.tempId)
    local tilePath = self.battleLevel:GetZombiePath(self.tempId)
    for i, v in ipairs(tilePath) do
        local p = SceneUtils.TileToWorld(v)
        self.path[#self.path + 1] = Vector3.New(p.x, p.y, p.z)
    end
    
    self.curBlood = math.max(self.template.maxBlood, 0)

    self.stateList[State.Idle] = IdleState.New(self)
    self.stateList[State.Move] = MoveState.New(self)
    self.stateList[State.Attack] = AttackState.New(self)
    self.stateList[State.Dead] = DeadState.New(self)

    if #self.path == 1 then
        self.currStateIndex = State.Idle
    else
        self.currStateIndex = State.Move
    end
    

    local prefabPath = string.format("Assets/Main/Prefabs/PVELevel/%s.prefab", self.template.model)
    self.requestObj = Resource:InstantiateAsync(prefabPath)
    self.requestObj:completed('+', function()
        local gameObject = self.requestObj.gameObject
        local transform = gameObject.transform
        self.gameObject = gameObject
        self.transform = transform
        
        self.gameObject.name = "Zombie_" .. tostring(self.objId)
        self.gameObject:SetActive(self.isVisible)
        
        local trigger = gameObject:GetComponent(typeof(CS.CitySpaceManTrigger))
        trigger.ObjectId = self.objId
        
        local model = transform:Find("Model")
        self.animator = model:GetComponent(typeof(CS.UnityEngine.Animator))
        self.animListen = model:GetComponent(typeof(CS.CitySpaceManAnimationListener))
        self.animListen.animation_attackDone = function()
            self:OnAttackHitTarget()
        end

        if #self.path > 0 then
            self:SetPosition(self.path[1])
        end
        
        self.currState = self.stateList[self.currStateIndex]
        self.currState:OnEnter()
    end)
end

function Zombie:Destroy()
    if self.currState then
        self.currState:OnExit()
        self.currState = nil
    end
    if self.requestObj then
        self.requestObj:Destroy()
        self.requestObj = nil
    end
    if self.tombstone then
        self.tombstone:Destroy()
        self.tombstone = nil
    end
    if self.animListen then
        self.animListen.animation_attackDone = nil
        self.animListen = nil
    end
end

function Zombie:OnUpdate(deltaTime)
    if self.currState then
        self.currState:OnUpdate(deltaTime)
    end
end

function Zombie:SetVisible(visible)
    self.isVisible = visible
    if self.gameObject then
        self.gameObject:SetActive(visible)
    end
end

function Zombie:PlayAnim(anim)
    for k, v in pairs(Anim) do
        self.animator:ResetTrigger(v)
    end
    self.animator:SetTrigger(anim)
end

function Zombie:GetCurBlood()
    return self.curBlood
end

function Zombie:BeAttack(hurt)
    self.curBlood = math.max(self.curBlood - hurt, 0)
    --print("Zombie be attack", self.objId, self.curBlood, hurt)
    if self.curBlood <= 0 then
        --print("Zombie die", self.objId)
        self:Die()
    end
end

function Zombie:GetPosition()
    return self.position
end

function Zombie:SetPosition(pos)
    self.position = pos
    if self.transform then
        self.transform.position = pos
    end
end

function Zombie:SetRotation(quaternion)
    self.rotation = quaternion
    if self.transform then
        self.transform.rotation = quaternion
    end
end

function Zombie:GetMoveSpeed()
    return self.template.moveSpeed
end


function Zombie:GetPathPoint(pathIndex)
    if pathIndex > #self.path then
        return
    end
    return self.path[pathIndex]
end

function Zombie:SetPathIndex(index)
    self.pathIndex = index
end

function Zombie:GetPathIndex()
    return self.pathIndex
end

function Zombie:Die()
    SetState(self, State.Dead)
end

function Zombie:AttackTarget()
    SetState(self, State.Attack)
end

function Zombie:Idle()
    SetState(self, State.Idle)    
end

function Zombie:Move()
    SetState(self, State.Move)
end

function Zombie:DoSearchTarget()
    local pos = self:GetPosition()
    local layerMask = LayerMask.GetMask("Default")
    local top = Vector3.New(pos.x, pos.y + 2, pos.z)
    local down = pos
    local radius = self.template.attackRadius
    local cnt = Physics.OverlapCapsuleNonAlloc(top, down, radius, self.colliderArray, layerMask);
    if cnt <= 0 then
        self.attackTargetId = nil
        return
    end

    local nearestId = nil
    local minDist = 1000000
    cnt = math.min(20, cnt)
    for i = 1, cnt do
        local collider = self.colliderArray[i - 1]
        local trigger = collider:GetComponentInParent(typeof(CS.CitySpaceManTrigger))
        if trigger ~= nil and trigger.ObjectId ~= 0 then
            if not (trigger.ObjectId >= Const.ZombieIdMin and trigger.ObjectId <= Const.ZombieIdMax) then
                local obj = self.battleLevel:GetObj(trigger.ObjectId)
                if obj ~= nil and obj:GetCurBlood() > 0 then
                    local collider_pos = collider.transform.position;
                    local dist = Vector3.Distance(collider_pos, pos)
                    if dist < minDist then
                        minDist = dist
                        nearestId = trigger.ObjectId
                    end
                end
            end
        end
    end

    self.attackTargetId = nearestId
end

function Zombie:GetAttackTarget()
    return self.battleLevel:GetObj(self.attackTargetId)
end

function Zombie:ShowTombstone()
    if self.tombstone == nil then
        self.tombstone = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/Obj_A_build_th_mb.prefab")
        self.tombstone:completed('+', function()
            local gameObject = self.tombstone.gameObject
            local transform = gameObject.transform
            transform.position = self:GetPosition()
        end)
    end
    self:SetVisible(false)
end

function Zombie:OnAttackHitTarget()
    local target = self:GetAttackTarget()
    if target ~= nil and target:GetCurBlood() > 0 then
        target:BeAttack(1)
    end
end


return Zombie