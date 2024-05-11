
---
--- 移动状态 之 路径点模式
---
---@class Scene.LWBattle.Skirmish.ArmyFSM.MoveStatePath
local MoveStatePath = BaseClass("MoveStatePath")
local Const = require("Scene.LWBattle.Const")

function MoveStatePath:__init(army)
    self.army = army
    self.destination = Vector3.New(0,0,0)
    self.direction = Vector3.New(0,0,0)
end

function MoveStatePath:__delete()
    self.army = nil
    self.destination = nil
    self.destinationQueue = nil
    self.direction = nil
end

function MoveStatePath:OnEnter(destinationQueue)
    self.destinationQueue = destinationQueue
    self:TrySetNextDestination()
end

function MoveStatePath:OnExit()
    self.destinationQueue = nil
end

function MoveStatePath:OnUpdate()
    local curPos = self.army:GetPosition()
    local delta = self.destination - curPos
    local speed = self.army:GetMoveSpeed()
    local maxMovement = speed * Time.deltaTime
    if delta:SqrMagnitude()<maxMovement*maxMovement then
        self.army:SetPosition(self.destination.x,self.destination.z)
        self:TrySetNextDestination()
    else
        local newPos = self.direction * maxMovement + curPos
        self.army:SetPosition(newPos.x,newPos.z)
    end
end

function MoveStatePath:TrySetNextDestination()
    if #self.destinationQueue<1 then
        self.army.fsm:ChangeState(SkirmishMoveState.Stay)
        return
    end
    local destination=table.remove(self.destinationQueue)
    self.destination.x = destination.x
    self.destination.z = destination.z
    local curPos = self.army:GetPosition()
    local delta = self.destination - curPos
    self.direction = delta:Normalize()
end

return MoveStatePath