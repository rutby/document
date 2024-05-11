---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ycheng.
--- DateTime: 2022/12/5 15:20
---
local NpcBaseAI = require("Scene.PVEBattleLevel.Character.AI.NpcBaseAI")
local NpcMovePathAI = BaseClass("NpcMovePathAI",NpcBaseAI)
local States = require("Util.States")

local StateType = {
    MoveState = "MoveState",
    WaitState = "WaitState",
    CompleteState = "CompleteState"
}

function NpcMovePathAI:__initState()
    self.m_states:AddState(StateType.MoveState, self.Move_Enter,self.Move_Update,self.Move_Exit)
    self.m_states:AddState(StateType.WaitState, self.Wait_Enter,self.Wait_Update,self.Wait_Exit)
    self.m_states:AddState(StateType.CompleteState,self.Complete_Enter)
end

function NpcMovePathAI:SetData(data,callback)
    NpcBaseAI.SetData(self,data,callback)
    self:ParsePath(data)
end

function NpcMovePathAI:ParsePath(data)
    self.path = {}
    local pathStr = data["path"]
    local pathArr = string.split(pathStr, ";")
    for _, str in ipairs(pathArr) do
        local spls = string.split(str, ",")
        if #spls == 2 then
            local p = {}
            p.x = tonumber(spls[1])
            p.y = tonumber(spls[2])
            local pos = SceneUtils.TileToWorld(p)
            table.insert(self.path, pos)
        end
    end
end

function NpcMovePathAI:Start()
    NpcBaseAI.Start(self)
    self.m_currentPathIndex = 1
    self.m_states:SetState(StateType.WaitState)
end

function NpcMovePathAI:Move_Enter()
    if self.m_currentPathIndex > #self.path then
        return
    end
    self.pathPos = self.path[self.m_currentPathIndex]
end

function NpcMovePathAI:Move_Update(deltaTime)
    if self.pathPos ~= nil then
        local dis = Vector3.Distance(self.m_owner:GetPosition(),self.pathPos)
        if dis > 0.3 then
            self.m_owner:MovePath(self.pathPos)
        elseif self.m_currentPathIndex < #self.path then
            self.m_states:SetState(StateType.WaitState)
        else
            self.m_states:SetState(StateType.CompleteState)
        end
    end
end

function NpcMovePathAI:Move_Exit()
    self.m_currentPathIndex = self.m_currentPathIndex + 1
    self.pathPos = nil
end

function NpcMovePathAI:Wait_Enter()
    self.waitPlayer = DataCenter.BattleLevel:GetPlayer()
    self.m_owner:Idle()
end

function NpcMovePathAI:Wait_Update(deltaTime)
    if self.waitPlayer ~= nil then
        local dis = Vector3.Distance(self.m_owner:GetPosition(),self.waitPlayer:GetPosition()) - self.waitPlayer:GetModelRadius()
        if dis <= 1.5 then
            --玩家到达跟前了
            if self.m_currentPathIndex >= #self.path then
                self:TriggerCallBack()
            end
            self.m_states:SetState(StateType.MoveState)
        end
    else
        self.m_states:SetState(StateType.MoveState)
    end
end

function NpcMovePathAI:Wait_Exit()
    self.waitPlayer = nil
end

function NpcMovePathAI:Complete_Enter()
    self:OnAIComplete()
end

function NpcMovePathAI:Destroy()
    NpcBaseAI.Destroy(self)
end

return NpcMovePathAI