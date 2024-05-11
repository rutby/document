---
---小队 MemberUnit的集合
---

local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Const = require("Scene.LWBattle.Const")
local HeroUnit = require("Scene.LWBattle.ParkourBattle.Team.HeroUnit")
local WorkerUnit = require("Scene.LWBattle.ParkourBattle.Team.WorkerUnit")
local fingerDir = Vector3.zero

---@class Scene.LWBattle.ParkourBattle.Team
local Team = BaseClass("Team")
local FSM=require("Framework.Common.FSM")
--跑酷阶段，自动前进，玩家可以操作左右移动
local TeamStateFarm=require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateFarm")
--boss阶段，万向移动状态，玩家可以操作摇杆移动
local TeamStateBoss=require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateBoss")
--退场阶段，自动移动状态，玩家不可以操作移动（路径点模式）
local TeamStateExit=require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateExit")

local TeamConfig = {
    Human = {x = 1.5,z = 2,lineUnitNumber = 3,}, --x轴间隔，z轴间隔，每行单位数量上限
    Tank = {x = 2.5,z = 2.6,lineUnitNumber = 3,},
    Worker = {x = 1.5,z = 1.5,lineUnitNumber = 3,},
}
local TeamRowCount = 4


function Team:__init(x,z,logic,defaultHero)
    local go = GameObject("TeamRoot")
    self.gameObject = go
    self.transform = go.transform
    self.curPos = Vector3.New(x,0,z)
    self:SetPosition(x,z)
    self.teamUnits = {}
    self.teamMemberPosition = {human = {},tank = {},worker = {}}
    self.logic = logic
    self.memberCnt = {human = 0,tank = 0,worker = 0}
    self.moveSpeedDirty = true
    self.moveSpeedZDirty = true
    self.superArmorDirty = true
    self.superArmor = false
    self.isExiting = false
    self:CalArrange()
    local heroIds = string.split(defaultHero,"|")
    for _,heroId in ipairs(heroIds) do
        self:AddMember(tonumber(heroId))
    end
    self:InitFSM()
    self.oldZ=0
    self.oldX=0
end

function Team:__delete()
    self:Destroy()
end

function Team:Update()
    if self.fsm then
        self.fsm:OnUpdate()
    end
    for _, unit in pairs(self.teamUnits) do
        unit:OnUpdate()
    end
    if self:IsSuperArmor() or self:IsExiting() then
        self:UpdateMemberCollision()
    end
end

function Team:Destroy()
    if self.teamUnits then
        for _, unit in pairs(self.teamUnits) do
            self.logic:RemoveUnit(unit.guid)
        end
        self.teamUnits = nil
    end
    if self.gameObject then
        GameObject.Destroy(self.gameObject);
        self.gameObject = nil
        self.transform = nil
    end
    if self.fsm then
        self.fsm:Delete()
        self.fsm = nil
    end
end

function Team:InitFSM()
    self.fsm = FSM.New()--运动状态机
    self.fsm:AddState(Const.ParkourMoveState.Auto,TeamStateExit.New(self))
    self.fsm:AddState(Const.ParkourMoveState.LeftRight,TeamStateFarm.New(self))
    self.fsm:AddState(Const.ParkourMoveState.AllDirection,TeamStateBoss.New(self))
    self.fsm:ChangeState(Const.ParkourMoveState.LeftRight)
end

function Team:SaveHero(heroId)
    local heroCfg = self:GenHeroCfg(heroId)
    if not heroCfg then
        Logger.LogError("no hero ",heroId)
        return
    end
    if self:CheckIsFull(heroCfg) then--满员
        local tank =self:GetRandomTank()
        if tank then--有坦克换坦克
            self:RemoveMember(tank)
            self:RealAddMember(heroCfg)
        else--无坦克新增
            self:RealAddMember(heroCfg)
        end
    else
        self:RealAddMember(heroCfg)
    end
end


function Team:AddMember(heroId)
    local heroCfg = self:GenHeroCfg(heroId)
    if not heroCfg then
        Logger.LogError("no hero ",heroId)
        return
    end
    if self:CheckIsFull(heroCfg) then--满员不新增
        return
    end
    self:RealAddMember(heroCfg)
end

function Team:RealAddMember(heroCfg)
    local isHuman = heroCfg.meta.is_human

    local hero = ObjectPool:GetInstance():Load(HeroUnit)
    hero:Init(self.logic,self, self.transform,Vector3.zero, heroCfg)
    table.insert(self.teamUnits,hero)
    self.logic:AddUnit(hero)
    if heroCfg.meta.is_front==1 then
        self.memberCnt["tank"] = self.memberCnt["tank"] + 1
    elseif heroCfg.meta.is_front == 2 then
        self.memberCnt["human"] = self.memberCnt["human"] + 1
    else
        if isHuman then
            self.memberCnt["human"] = self.memberCnt["human"] + 1
        else
            self.memberCnt["tank"] = self.memberCnt["tank"] + 1
        end
    end
    self:ReArrange()
end

function Team:GenHeroCfg(heroId)
    local hero = HeroInfo.New()
    hero:UpdateFromTemplate(heroId,1)
    return hero
end

function Team:RemoveMember(hero)
    if self:GetMemberCount()<1 or not hero then
        Logger.LogError("No member can be removed!")
        return 
    end
    if self.logic.state==Const.ParkourBattleState.PreExit or self.logic.state==Const.ParkourBattleState.Exit then
        return
    end
    Logger.Log("Remove team member "..hero.guid)
    hero.curBlood=0
    table.removebyvalue(self.teamUnits,hero)
    self.logic:RemoveUnit(hero.guid)
    local heroType
    if hero.meta.is_front == 1 then
        heroType = "tank"
    elseif hero.meta.is_front == 2 then
        heroType = "human"
    else
        heroType = hero.isHuman and "human" or "tank"
    end
    self.memberCnt[heroType] = math.max(self.memberCnt[heroType] - 1, 0)
    self:ReArrange()
end

function Team:CalArrange()
    self.teamMemberPosition = {human = {},tank = {},worker = {}}
    local function _cal(cfg, cap, dir)
        local pos = {}
        local rShift = math.floor((cap-1)/cfg.lineUnitNumber) / 2
        for i = 0, cap - 1, 1 do
            local curRow = math.floor(i/cfg.lineUnitNumber)
            local curRawCap = math.min(cap - curRow * cfg.lineUnitNumber, cfg.lineUnitNumber)
            local xShift = - cfg.x * (curRawCap - 1)/2
            table.insert(pos ,Vector3.New( xShift + cfg.x * (i % curRawCap), 0,  (curRow - rShift ) * cfg.z * dir ))
        end
        return pos
    end
    for i = 0, TeamConfig.Tank.lineUnitNumber * TeamRowCount , 1 do
        self.teamMemberPosition.tank[i] = _cal(TeamConfig.Tank, i, 1)   --从后向前排列
    end
    for i = 0, TeamConfig.Human.lineUnitNumber * TeamRowCount , 1 do
        self.teamMemberPosition.human[i] = _cal(TeamConfig.Human, i, -1)    --从前向后排列
    end
    for i = 0, TeamConfig.Worker.lineUnitNumber * TeamRowCount , 1 do
        self.teamMemberPosition.worker[i] = _cal(TeamConfig.Worker, i, -1)
    end
end


function Team:ReArrange()
    local humanCnt = 0
    local tankCnt = 0
    local workerCnt = 0
    
    local humanPos = self.teamMemberPosition.human[self.memberCnt.human]
    local tankPos = self.teamMemberPosition.tank[self.memberCnt.tank]
    local workerPos = self.teamMemberPosition.worker[self.memberCnt.worker]
    
    local tankRowH = math.ceil(self.memberCnt.tank/TeamConfig.Tank.lineUnitNumber) * TeamConfig.Tank.z/2
    local humanRowH = math.ceil(self.memberCnt.human/TeamConfig.Human.lineUnitNumber) * TeamConfig.Human.z/2
    local workerRowH = math.ceil(self.memberCnt.worker/TeamConfig.Worker.lineUnitNumber) * TeamConfig.Worker.z/2
    local rowCenter = tankRowH + humanRowH + workerRowH

    local tankShift = Vector3.New(0,0,rowCenter - tankRowH )
    local humanShift = Vector3.New(0,0, workerRowH - tankRowH)
    local workerShift = Vector3.New(0,0, workerRowH - rowCenter)

    for _, unit in pairs(self.teamUnits) do
        if unit.meta.is_front and unit.meta.is_front == 1 then
            tankCnt = tankCnt + 1
            unit:SetLocalPosition(tankPos[tankCnt] + tankShift)
        end
    end
    
    for _, unit in pairs(self.teamUnits) do
        if unit.unitType == UnitType.Plot then
            workerCnt = workerCnt + 1
            unit:SetLocalPosition(workerPos[workerCnt] + workerShift)
        elseif unit.meta.is_front and unit.meta.is_front == 0 then
            if unit.isHuman then
                humanCnt = humanCnt + 1
                unit:SetLocalPosition(humanPos[humanCnt] + humanShift)
            else
                tankCnt = tankCnt + 1
                unit:SetLocalPosition(tankPos[tankCnt] + tankShift)
            end
        end
    end
    
    for _, unit in pairs(self.teamUnits) do
        if unit.meta.is_front and unit.meta.is_front == 2 then
            humanCnt = humanCnt + 1
            unit:SetLocalPosition(humanPos[humanCnt] + humanShift)
        end
    end
end

function Team:GetMemberCount()
    return self.memberCnt.human + self.memberCnt.tank
end

function Team:SetPosition(x,z)
    self.curPos.x=x
    self.curPos.z=z
    self.transform:Set_position(x,0,z)
end

function Team:GetPosition()
    return self.curPos
end

function Team:GetPositionZ()
    return self.curPos.z
end


function Team:MoveHorizontalTo(x)
    self.fsm:ChangeState(Const.ParkourMoveState.LeftRight,x)
end

function Team:OnFingerDown(pos)
    --self.fsm:HandleInput(Const.ParkourInput.FingerDown,pos)
    for _, unit in pairs(self.teamUnits) do
        unit:OnFingerDown(fingerDir)
    end
end
function Team:OnFingerUp()
    self.fsm:HandleInput(Const.ParkourInput.FingerUp)
    for _, unit in pairs(self.teamUnits) do
        unit:OnFingerUp(fingerDir)
    end
end
function Team:OnFingerHold(x,z)

    --控制移动
    local oldPos = self:GetPosition()
    local distance = self:GetMoveSpeed() * Time.deltaTime
    --Logger.Log("移动："..x..","..z..","..distance)
    local deltaX = x * distance
    local deltaZ = z * distance
    local newX = oldPos.x + deltaX
    local newZ = oldPos.z + deltaZ
    if self.logic.data:Contains(newX,newZ) then
        self:SetPosition(newX,newZ)
    elseif self.logic.data:Contains(oldPos.x,newZ) then
        self:SetPosition(oldPos.x,newZ)
    elseif self.logic.data:Contains(newX,oldPos.z) then
        self:SetPosition(newX,oldPos.z)
    end
    
    --控制旋转
    if x==0 and z==0 then
        return
    end
    if math.abs(self.oldX-x)>0.01 or math.abs(self.oldZ-z)>0.01 then
        fingerDir.x = oldPos.x + x * 1024
        fingerDir.z = oldPos.z + z * 1024
        for _, unit in pairs(self.teamUnits) do
            unit:OnFingerHold(fingerDir)
        end
        --Logger.LogError("xz")
    end
    self.oldX=x
    self.oldZ=z
end

function Team:SetActive(isOn)
    if  self.gameObject then
        self.gameObject:SetActive(isOn)
    end
end

function Team:GetMoveSpeedZ()
    if not self.moveSpeedZDirty then
        return self.finalSpeedZ
    end
    self.moveSpeedZDirty = false
    local addValue = 0
    for _, unit in pairs(self.teamUnits) do
        local bfValue = unit:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed)
        if bfValue > 0 then
            addValue =  self.speedZ * bfValue
            break
        end
    end
    self.finalSpeedZ =  self.speedZ + addValue
    return self.finalSpeedZ
end

function Team:IsSuperArmor()
    if not self.superArmorDirty then
        return self.superArmor
    end
    local oldValue = self.superArmor
    self.superArmorDirty = false
    self.superArmor = false
    for _,unit in pairs(self.teamUnits) do
        local buff = unit.buffManager:GetPropertyBuff(HeroEffectDefine.SuperArmor)
        if buff > 0 then
            self.superArmor = true
            break
        end
    end
    if oldValue ~= self.superArmor then
        self:SetInvincible(self.superArmor)--狂飙时无敌
        EventManager:GetInstance():Broadcast(EventId.SquadSuperArmorStateChange)
    end
    return self.superArmor
end

function Team:UpdateMemberCollision()
    for _,member in pairs(self.teamUnits) do
        if member.unitType~=UnitType.Plot then
            if not member.colliderComponent then
                local collision = function (colliderCnt, colliderComponentArray)
                    self:OnCollision(colliderCnt, colliderComponentArray)
                end
                member:InitColliderComponent(LayerMask.GetMask("Zombie")|LayerMask.GetMask(LayerType.Junk),collision)
            end
            if member.colliderComponent then
                member.colliderComponent:CollisionDetect()
            end
        end
    end
end

function Team:OnCollision(colliderCnt, colliderComponentArray )
    for i = 0, colliderCnt-1, 1 do
        self:Hit(colliderComponentArray[i])
    end
end

local HitDamageCD = 100 --霸体伤害对单位伤害cd
local deathEffPath = "Assets/_Art/Effect_B/Prefab/Common/Eff_shiti_boom.prefab"
function Team:Hit(otherObj)
    local now = UITimeManager:GetInstance():GetServerTime()
    local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger~=nil and trigger.ObjectId~=0 then
        local tar = self.logic:GetUnit(trigger.ObjectId)
        if tar and (tar.curBlood or 0) > 0 and now - (tar.lastHitTime or 0) > HitDamageCD then
            tar.lastHitTime = now
            --伤害
            --击退
            local hurt = 1
            local hitPoint = tar:GetPosition()
            local hitDir = nil
            local whiteTime = 0.2
            local stiffTime = 0
            local hitBackDistance = nil
            local hitEff = nil

            if tar.meta.crash_kill > 0 then
                hurt = tar.maxBlood * (tar.meta.crash_kill / 100)
            else
                return
            end

            if hurt < tar.curBlood then
                hitBackDistance = Vector3.Normalize(hitPoint - self:GetPosition()) * 10
            end
            local m_deathEffPath = deathEffPath
            if tar.meta.monster_type == Const.MonsterType.Junk then
                m_deathEffPath = nil
            end
            tar:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
            tar:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,nil,m_deathEffPath,true)
            --self.logic.damageTextMgr:GenText(hurt,hitPoint,Const.DamageTextStyle.BeAttack,DamageType.Physics,false)

            if tar.meta.is_boss == 1 then
                --震屏
                local p = {}
                p.duration = 0.5
                p.strength = Vector3.New(1, 1, 0)
                p.vibrato = 20
                self.logic:ShakeCameraWithParam(p)
            end
        end
    end
end

function Team:AddWorker(workerId)
    local workerCfg = LocalController:instance():getLine(TableName.LW_Worker,tonumber(workerId))
    if not workerCfg then
        Logger.LogError("no worker Config ",workerId)
        return
    end

    local worker = ObjectPool:GetInstance():Load(WorkerUnit)
    worker:Init(self.logic,self, self.transform,Vector3.zero,workerCfg)
    table.insert(self.teamUnits,worker)
    self.logic:AddUnit(worker)
    self.memberCnt.worker = self.memberCnt.worker + 1
    self:ReArrange()
    self.logic:OnWorkerSave()
end

function Team:GetRandomTank()
    for _,member in pairs(self.teamUnits) do
        if member.unitType==UnitType.Member and not member.isHuman then
            return member
        end
    end
    return nil
end

--检查满员
function Team:CheckIsFull(heroCfg)
    local remain

    if heroCfg.meta.is_front == 1 then--优先在第一排
        remain=(TeamRowCount - math.ceil(self.memberCnt.human / TeamConfig.Human.lineUnitNumber))
                * TeamConfig.Tank.lineUnitNumber - self.memberCnt.tank
    elseif heroCfg.meta.is_front == 2 then--优先在非1排
        remain=(TeamRowCount - math.ceil(self.memberCnt.tank / TeamConfig.Tank.lineUnitNumber))
                * TeamConfig.Human.lineUnitNumber - self.memberCnt.human
    else
        if heroCfg.meta.is_human then
            remain=(TeamRowCount - math.ceil(self.memberCnt.tank / TeamConfig.Tank.lineUnitNumber))
                    * TeamConfig.Human.lineUnitNumber - self.memberCnt.human
        else
            remain=(TeamRowCount - math.ceil(self.memberCnt.human / TeamConfig.Human.lineUnitNumber))
                    * TeamConfig.Tank.lineUnitNumber - self.memberCnt.tank
        end
    end

    if remain < 1 then
        return true
    end
end


function Team:IsExiting()
    return self.logic.state==Const.ParkourBattleState.Exit
end

function Team:ChangeStage(stage)
    if stage == Const.ParkourBattleState.Boss then
        self.fsm:ChangeState(Const.ParkourMoveState.AllDirection)
    elseif stage == Const.ParkourBattleState.Exit then
        --路径点模式
        --local destinationQueue = {}
        --table.insert(destinationQueue,Vector3.New(Const.ParkourSceneCenter,0,10000))
        --local curPos = self:GetPosition()
        --table.insert(destinationQueue,Vector3.New(Const.ParkourSceneCenter,0,curPos.z))
        --self.fsm:ChangeState(Const.ParkourMoveState.Auto,destinationQueue)
        --贝塞尔曲线
        local curPos = self:GetPosition()
        local controlPoint1 = curPos
        local controlPoint2 = Vector3.New(Const.ParkourSceneCenter,0,curPos.z+EXIT_CTRL_POINT_OFFSET)
        local controlPoint3 = Vector3.New(Const.ParkourSceneCenter,0,
                curPos.z+EXIT_CTRL_POINT_OFFSET+math.abs(Const.ParkourSceneCenter-curPos.x))
        self.fsm:ChangeState(Const.ParkourMoveState.Auto,controlPoint1,controlPoint2,controlPoint3)
    end
    for _, unit in pairs(self.teamUnits) do
        unit:ChangeStage(stage)
    end
end


function Team:GetMoveSpeed()
    if self.moveSpeed and not self.moveSpeedDirty then
        return self.moveSpeed
    end
    self.moveSpeed=99
    self.moveSpeedDirty=false
    for _,member in pairs(self.teamUnits) do--小队速度=最慢的成员的速度
        local speed=member:GetMoveSpeed()
        self.moveSpeed = self.moveSpeed > speed and speed or self.moveSpeed
    end
    return self.moveSpeed
end

return Team
