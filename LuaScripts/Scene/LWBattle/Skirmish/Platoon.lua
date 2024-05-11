---
---排 一个captain和若干minion组成的集合
---

local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Platoon = BaseClass("Platoon")
local Captain = require("Scene.LWBattle.Skirmish.Unit.Captain")
local Minion = require("Scene.LWBattle.Skirmish.Unit.Minion")

function Platoon:__init(logic,army,index)
    self.index=index
    self.army=army
    self.logic=logic
    self.sceneData = self.logic.sceneData
    self.battleData = self.logic.battleData
    local go = GameObject("PlatoonRoot")
    self.gameObject = go
    self.transform = go.transform
    self.transform:SetParent(army.transform)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.curWorldPos = Vector3.zero
    self.localPosition = self.sceneData.platoonLocalPos[index]
    self.transform:Set_localPosition(self.localPosition.x,self.localPosition.y,self.localPosition.z)
    self.heroData = self.battleData.heroData[self.index]
    self.dirMultiplier = self.army.dirMultiplier
    self.isMoving = true
    self:CreateCaptain()
    self:CreateMinions()
end

function Platoon:__delete()
    self:Destroy()
end

function Platoon:CreateCaptain()

    self.captain = ObjectPool:GetInstance():Load(Captain)
    self.captain:Init(self.logic,self,self.heroData,Vector3.zero,self.index)--排长的index=排的index
    self.logic:AddCaptain(self.index,self.captain)
    self.logic:AddUnit(self.captain)
end

function Platoon:CreateMinions()
    self.minions = {}
    self.deadMinions = {}
    self.minionHero = HeroInfo.New()
    local minionsNum = self:Hp2MinionsNum(self.heroData.initHp)
    if minionsNum<=0 then
        return
    end
    local soldierMeta=DataCenter.SoldierDataManager:GetTemplate(self.battleData.topSoldierId[self.army.index])
    if soldierMeta then
        self.minionHero:UpdateFromTemplate(soldierMeta.playback_hero_id,1)
        for i = 1, minionsNum do
            local minion = ObjectPool:GetInstance():Load(Minion)
            minion:Init(self.logic,self,self.minionHero,self.sceneData.minionLocalPos[i],i)
            table.insert(self.minions,minion)
            self.logic:AddUnit(minion)
        end
    end
end

function Platoon:OnUpdate()

end

function Platoon:Destroy()
    for _,v in pairs(self.minions) do
        self.logic:RemoveUnit(v)
    end
    self.minions={}
    self.logic:RemoveUnit(self.captain)
    if self.gameObject then
        CS.UnityEngine.GameObject.Destroy(self.gameObject);
        self.gameObject = nil
        self.transform = nil
    end
    self.logic=nil
    self.index=nil
    self.army=nil
    self.sceneData = nil
    self.battleData = nil
    self.heroData = nil
    self.curPos = nil
    self.minionHero = nil
end


function Platoon:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        return self.army:GetPosition()+self.localPosition * self.dirMultiplier
    end
end


function Platoon:ChangeStage(stage)
    if stage == SkirmishStage.Load then

    elseif stage == SkirmishStage.Opening then

    end
    self.captain:ChangeStage(stage)
    for _, unit in pairs(self.minions) do
        unit:ChangeStage(stage)
    end
end

function Platoon:GetMoveVelocity()
    return self.army:GetMoveVelocity()
end

--队长受伤时
function Platoon:OnCaptainTakeDamage(curHp)
    local targetMinionsNum = self:Hp2MinionsNum(curHp)
    local curMinionNum = #self.minions
    local needDeadNum = curMinionNum - targetMinionsNum
    for i = 1, needDeadNum do
        local minion = table.remove(self.minions,math.random(#self.minions))
        table.insert(self.deadMinions,minion)
        minion:GoDie()
    end
end

--队长回血时
function Platoon:OnCaptainHeal(curHp)
    local targetMinionsNum = self:Hp2MinionsNum(curHp)
    local curMinionNum = #self.minions
    local needReviveNum = targetMinionsNum - curMinionNum
    --local full = 1
    for i = 1, needReviveNum do
        local minion = table.remove(self.deadMinions)
        table.insert(self.minions,minion)
        minion:Revive()
        
        --for j = full, self.sceneData.MAX_MINION_PER_HERO do
        --    if not self:HasIndexMinion(j) then
        --        local minion = Minion.New(self,self.minionHero,self.sceneData.minionLocalPos[j],j)
        --        table.insert(self.minions,minion)
        --        self.logic:AddUnit(minion)
        --        full = j + 1
        --        break
        --    end
        --end
    end
end

function Platoon:HasIndexMinion(index)
    for k,v in ipairs(self.minions) do
        if v.index==index then
            return true
        end
    end
    return false
end


--血量转化为小兵数量
function Platoon:Hp2MinionsNum(curHp)
    --return 0
    return math.ceil( self.sceneData.MAX_MINION_PER_HERO * curHp / self.heroData.maxHp)
end

function Platoon:StopMoving()
    self.captain:StopMoving()
    for _, unit in pairs(self.minions) do
        unit:StopMoving()
    end
    self.isMoving = false
end

return Platoon
