---
--- Pve 丧尸移动状态
---

local ZombieMoveState = BaseClass("ZombieMoveState")

function ZombieMoveState:__init(zombie)
    self.zombie = zombie
    self.pathLen = 0
    self.rotation = Quaternion.identity
end

function ZombieMoveState:__delete()

end

function ZombieMoveState:OnEnter()
    local zombie = self.zombie
    self.pathIndex = zombie:GetPathIndex()
    self.currPathEnd = zombie:GetPathPoint(self.pathIndex)
    if self.currPathEnd == nil then
        zombie:Idle()
        return
    end
    
    local curPos = zombie:GetPosition()
    self.pathLen = Vector3.Distance(self.currPathEnd, curPos)
    self.moveForward = Vector3.Normalize(self.currPathEnd - curPos)
    zombie:SetRotation(Quaternion.LookRotation(self.moveForward))
    zombie:PlayAnim(zombie.Anim.Walk)
end

function ZombieMoveState:OnExit()
    
end

function ZombieMoveState:OnUpdate(deltaTime)
    local zombie = self.zombie
    
    -- 沿路线移动
    local curPos = zombie:GetPosition()
    local moveLen = deltaTime * zombie:GetMoveSpeed()
    self.pathLen = self.pathLen - moveLen
    if self.pathLen <= 0 then
        zombie:SetPosition(self.currPathEnd)

        self.pathIndex = self.pathIndex + 1
        zombie:SetPathIndex(self.pathIndex)
        --print("zombie change path", self.pathIndex)

        self.currPathEnd = zombie:GetPathPoint(self.pathIndex)
        if self.currPathEnd == nil then
            zombie:Idle()
        else 
            self.pathLen = Vector3.Distance(self.currPathEnd, curPos)
            self.moveForward = self.currPathEnd - curPos
        end
    else
        zombie:SetPosition(curPos + self.moveForward * moveLen)
    end
    
    -- 索敌
    zombie:DoSearchTarget()
    local target = zombie:GetAttackTarget()
    if target ~= nil then
        zombie:AttackTarget()
    end
end

return ZombieMoveState