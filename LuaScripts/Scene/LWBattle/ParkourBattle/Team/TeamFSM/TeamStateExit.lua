
---
--- 小队状态 之 退场
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.TeamStateExit
local TeamStateExit = BaseClass("TeamStateExit")
local Const = require("Scene.LWBattle.Const")


function TeamStateExit:__init(team)
    self.team = team
    self.timeMgr=UITimeManager:GetInstance()
    self.controlPoint1 = nil
    self.controlPoint2 = nil
    self.controlPoint3 = nil
end

function TeamStateExit:__delete()
    self.team = nil
    self.timeMgr=nil
    self.controlPoint1 = nil
    self.controlPoint2 = nil
    self.controlPoint3 = nil
    self.b = nil
end

function TeamStateExit:OnEnter(cp1,cp2,cp3)
    self.controlPoint1=Vector3.New(cp1.x,0,cp1.z)
    self.controlPoint2=Vector3.New(cp2.x,0,cp2.z)
    self.controlPoint3=Vector3.New(cp3.x,0,cp3.z)
    self.duration = (math.abs(cp3.x-cp1.x) + math.abs(cp3.z-cp1.z)) / EXIT_SPEED
    self.b=Vector3.zero
    self.startTime = self.timeMgr:GetServerTime()
    self.goStraight=false
end

function TeamStateExit:OnExit()
    self.controlPoint1 = nil
    self.controlPoint2 = nil
    self.controlPoint3 = nil
    self.b = nil
end

function TeamStateExit:OnUpdate()
    local now = self.timeMgr:GetServerTime()
    local t=(now-self.startTime)*0.001
    if t<self.duration then
        local timePercent = t / self.duration
        local a = self.controlPoint1 + (self.controlPoint2-self.controlPoint1) * timePercent
        local b = self.controlPoint2 + (self.controlPoint3-self.controlPoint2) * timePercent
        for _,v in pairs(self.team.teamUnits) do
            local member = v---@type Scene.LWBattle.ParkourBattle.Team.MemberUnit
            local offset = member.localPosition
            self.b.x = offset.x+b.x
            self.b.z = offset.z+b.z
            if member.transform then
                member.transform:LookAt(self.b)
            end
        end
        local newPos=a+(b-a)*timePercent
        self.team:SetPosition(newPos.x,newPos.z)
    else
        local deltaT = t - self.duration
        local deltaZ =  deltaT * EXIT_SPEED
        self.team:SetPosition(self.controlPoint3.x,self.controlPoint3.z+deltaZ)
        if not self.goStraight then
            self.goStraight=true
            for _,v in pairs(self.team.teamUnits) do
                local member = v---@type Scene.LWBattle.ParkourBattle.Team.MemberUnit
                local offset = member.localPosition
                self.b.x = offset.x+self.controlPoint3.x
                self.b.z = self.controlPoint3.z+1024
                if member.transform then
                    member.transform:LookAt(self.b)
                end
            end
        end
    end
end

function TeamStateExit:HandleInput(input,param)
    
end



return TeamStateExit
