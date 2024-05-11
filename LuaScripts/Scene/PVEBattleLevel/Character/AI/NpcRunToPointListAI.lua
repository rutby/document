---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ycheng.
--- DateTime: 2022/12/5 15:20
---
local NpcBaseAI = require("Scene.PVEBattleLevel.Character.AI.NpcBaseAI")
local NpcRunToPointListAI = BaseClass("NpcMovePathAI",NpcBaseAI)

local StateType = {
    MoveState = "MoveState",
    CompleteState = "CompleteState"
}

function NpcRunToPointListAI:__initState()
    self.m_agent = self.m_owner:GetNavmeshAgent()
    self.m_states:AddState(StateType.MoveState, self.Move_Enter,self.Move_Update,self.Move_Exit)
    self.m_states:AddState(StateType.CompleteState,self.Complete_Enter)
end

function NpcRunToPointListAI:SetData(data,callback)
    NpcBaseAI.SetData(self,data,callback)
    self:ParsePath(data)
end

function NpcRunToPointListAI:ParsePath(data)
    self.path = {}
    local pathStr = data["path"]
    local pathArr = string.split(pathStr, ";")
    for _, str in ipairs(pathArr) do
        local spls = string.split(str, ",")
        if #spls == 2 then
            local p = Vector3.New()
            p.x = tonumber(spls[1])
            p.y = 0
            p.z = tonumber(spls[2])
            table.insert(self.path, p)
        end
    end
end

function NpcRunToPointListAI:Start()
    NpcBaseAI.Start(self)
    self.m_currentPathIndex = 1
    self.m_states:SetState(StateType.MoveState)
end

function NpcRunToPointListAI:Move_Enter()
    self:StartMove()
end

function NpcRunToPointListAI:StartMove()
    if self.m_currentPathIndex > #self.path then
        return
    end
    self.pathPos = self.path[self.m_currentPathIndex]
    self.m_owner:MovePath(self.pathPos)
end

function NpcRunToPointListAI:Move_Update(deltaTime)
    if (self.m_agent.pathPending) then
        return
    end
    if self.pathPos ~= nil then
        local dis = Vector3.Distance(self.m_owner:GetPosition(),self.pathPos)
        --local str = ">>>npc:";
        --str = str .. "   dis: " .. tostring(dis)
        --str = str .. "   index: " .. tostring(self.m_currentPathIndex)
        --str = str .. "   speed: " .. tostring(self.m_agent.velocity)
        --str = str .. "   pend: " .. tostring(self.m_agent.pathPending)
        --str = str .. "  accle: " .. tostring(self.m_agent.acceleration)
        --print(str)
        
        if self.m_currentPathIndex > #self.path then
            self.m_states:SetState(StateType.CompleteState)
        --elseif (dis < 0.3 or (not self.m_agent.pathPending and self.m_agent:IsVelocityZero())) then
        elseif dis < 0.5 then
            self.m_currentPathIndex = self.m_currentPathIndex + 1
            self:StartMove()
        end
    end
end

function NpcRunToPointListAI:Move_Exit()
    self.pathPos = nil
end

function NpcRunToPointListAI:Complete_Enter()
    print(">>>npc exit")
    self:TriggerCallBack()
    self:OnAIComplete()
end

function NpcRunToPointListAI:Destroy()
    NpcBaseAI.Destroy(self)
end

return NpcRunToPointListAI