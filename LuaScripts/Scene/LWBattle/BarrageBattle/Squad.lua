
---小队

-- 交资源检测
local Resource = CS.GameEntry.Resource
--检测碰撞
local FSM=require("Framework.Common.FSM")
---@type Scene.LWBattle.BarrageBattle.Unit.Member
local Member = require("Scene.LWBattle.BarrageBattle.Unit.Member")
local SquadStateStay = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateStay")
local SquadStateMove = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateMove")
local SquadStateExit = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateExit")
local Const = require("Scene.LWBattle.Const")
local Formation=require("Scene.LWBattle.Formation")
local TacticalWeaponMember =require("Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember")





---
--- 小队
---
---@class Scene.LWBattle.BarrageBattle.Squad
---@field members table<number, Scene.LWBattle.BarrageBattle.Unit.Member>
local Squad = BaseClass("Squad")



function Squad:__init(manager,guid,heroes,parent,scaleCtrl,tacWeaponInfo,tacWeaponAppearanceId)
    self.heroes=heroes
    self.gameObject = CS.UnityEngine.GameObject("Squad")
    self.gameObject.transform:SetParent(parent,false)
    self.transform = self.gameObject.transform
    self.battleMgr=manager---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.guid = guid
    self.members = {}---@type table<number,Scene.LWBattle.BarrageBattle.Unit.Member>
    self.cur_pos = Vector3.zero
    self.fsm=nil---@type Framework.Common.FSM
    self.destination=nil---@type Scene.LWBattle.LWWayPoint
    self.formation=nil---@type Scene.LWBattle.Formation
    self.createdMember=0
    self.lastTimeCheckNeedStop=0
    self.scaleCtrl=scaleCtrl
    self.animNameCache=nil
    self.superArmor = false --霸体
    self.superArmorDirty = true
    self.qualitySlots = {}
    self.teamWeapon = nil---@type table<number,Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember>
    self.tacWeaponInfo = tacWeaponInfo
    self.tacWeaponAppearanceId = tacWeaponAppearanceId
end

function Squad:__delete()
    self:Destroy()
end

function Squad:Destroy()
    self.members = {}
    self.teamWeapon = nil
    self.cur_pos = nil
    self.fsm:Delete()
    self.fsm=nil
    self.destination=nil
    self.formation:Delete()
    self.createdMember=0
    if self.gameObject then
        CS.UnityEngine.GameObject.Destroy(self.gameObject);
        self.gameObject = nil
        self.transform = nil
    end
    self.animNameCache=nil
    self.battleMgr = nil    
    self.guid = nil
    self:DestroyQualitySlots()
end

--创建

function Squad:OnCreate()
    self:InitFSM()
    self.formation=Formation.New(self)
    self.formation:Init()
    self:CreateMembers()
    self:CreateWeaponMembers()


    --local cube1=CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube).transform
    --local cube2=CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube).transform
    --cube1:SetParent(self.transform,false)
    --cube2:SetParent(self.transform,false)
    --cube1.localPosition= Vector3.New(0,0,0)
    --cube2.localPosition= Vector3.New(0,0,1)
    --cube1.transform.localScale=Vector3.one*0.2
    --cube2.transform.localScale=Vector3.one*0.2

end

function Squad:InitFSM()
    self.fsm = FSM.New()
    self.fsm:AddState(SquadState.Stay,SquadStateStay.New(self))
    self.fsm:AddState(SquadState.Move,SquadStateMove.New(self))
    self.fsm:AddState(SquadState.Exit,SquadStateExit.New(self))
    self.fsm:ChangeState(SquadState.Stay)
end

function Squad:CreateMembers()
    if self.heroes == nil then
        Logger.LogError("heroes is nil")--小队数据不应该为空
        return
    end



    local heroUuids={}
    for slotIndex,heroData in pairs(self.heroes) do
        table.insert(heroUuids,heroData.uuid)
    end
    local campBuff=HeroUtils.GetCampEffectConfig(heroUuids)
    
    for slotIndex,heroData in pairs(self.heroes) do
        local hero = heroData
        local path
        if hero then
            path = hero.appearanceMeta.model_path
            --Logger.Log("hero.modelId"..hero.modelId.."hero.model_path"..path)
        else
            path = "Assets/_Art/Models/Cars/tanke/prefab/tank.prefab"
        end
        --if Const.UseTestModel then--强制使用测试模型
        --    path = Const.TestModel
        --end

        --local appearanceId =GetTableData(TableName.Hero, hero.heroId, "appearance")
        --local hp = hero:GetMaxHp()--0
        -- if supply[slotIndex] then
        --     hp = supply[slotIndex]
        -- end

        local objId = self.battleMgr:GetNextObjId()
        local req = Resource:InstantiateAsync(path)
        local member = ObjectPool:GetInstance():Load(Member)---@type Scene.LWBattle.BarrageBattle.Unit.Member
        member:Init(self.battleMgr,self,objId,req,slotIndex,hero,campBuff)
        table.insert(self.members,member)
        self.battleMgr:AddUnit(member)
        req:completed('+', function(request)
            if request.isError then
                return
            end
            member:OnCreate()
            self:OnCreateFinish()
        end)
    end

    self:RefreshHeroQualitySlot()
    
end

function Squad:CreateWeaponMembers()
    if self.tacWeaponInfo == nil then
        self:OnCreateWeaponFinish()
        return
    end
    local appearanceId = self.tacWeaponAppearanceId
    if appearanceId == nil then
        appearanceId = self.tacWeaponInfo:GetAppearance()
    end
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    if not appearanceMeta then
        self:OnCreateWeaponFinish()
        Logger.LogError("tacWeapon appearanceMeta is nil")
        return
    end
    local path = appearanceMeta.model_path
    local objId = self.battleMgr:GetNextObjId()
    local req = Resource:InstantiateAsync(path)
    
    local member = ObjectPool:GetInstance():Load(TacticalWeaponMember)---@type Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember
    member:Init(self.battleMgr,self,objId,req,self.tacWeaponInfo,appearanceMeta,campBuff)
    self.teamWeapon = member
    self.battleMgr:AddUnit(member)
    req:completed('+', function(request)
        if request.isError then
            return
        end
        member:OnCreate()
        self:OnCreateWeaponFinish()
    end)
end

function Squad:DestroyQualitySlots()
    for _,v in pairs(self.qualitySlots) do
        if not IsNull(v) then
            CS.UnityEngine.GameObject.Destroy(v.gameObject)
        end
    end
end

function Squad:RefreshHeroQualitySlot()
    if table.IsNullOrEmpty(self.qualitySlots) then
        for i = 1, 5 do
            local obj =CS.UnityEngine.GameObject( "QualitySlot"..i)
            obj.transform:SetParent(self.transform,false)
            local offset = self.formation:GetOffsetByIndex(i)
            offset.y = 0.2
            obj.transform:Set_localEulerAngles(90,0, 0)
            obj.transform.localPosition = offset
            obj.transform.localScale = Vector3.New(1.5,1.5,1)
            local sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
            table.insert(self.qualitySlots, sprite)
        end
    end

    for i = 1, 5 do
        local sprite = self.qualitySlots[i]
        if not IsNull(sprite) then
            if not table.IsNullOrEmpty(self.heroes) then
                local hasHero = self.heroes[i] ~= nil
                if hasHero then
                    sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", self.heroes[i].quality))
                else
                    sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
                end
            else
                sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
            end
        end
    end
end

function Squad:ChangeHeroes(heroes)

    --TODO: 复用Member
    self.heroes=heroes
    for _,member in pairs(self.members) do
        self.battleMgr:RemoveUnit(member)
        member:DestroyData()
    end
    self.members = {}

    self.createdMember = 0
    self.moveSpeedDirty = true

    self.battleMgr:SetSquadCreateFinishFlag(false)

    self:CreateMembers()
end

function Squad:SetHeroPosition(index,worldPos)
    for _,member in pairs(self.members) do
        if member.index==index then
            member:SetPosition(worldPos)
            break
        end
    end
end

function Squad:ResetHeroPosition()
    for _,member in pairs(self.members) do
        member:ResetPosition()
    end
end

function Squad:MoveHeroToIndex(index,dstIndex,time)
    for _,member in pairs(self.members) do
        if member.index==index then
            member:MoveToIndex(dstIndex,time)
            break
        end
    end
end

function Squad:OnAllCreateFinish()
    if self.createdMember>=#self.members and (self.tacWeaponInfo == nil or (self.tacWeaponInfo ~= nil and self.teamWeapon)) then 
        if self.scaleCtrl then
            self.transform.localScale=Vector3.one*self.scaleCtrl
        end
        if self.animNameCache then
            self:PlayAnim(self.animNameCache)
        end
        self.battleMgr:OnSquadCreateFinish()
    end
end

function Squad:OnCreateFinish()
    self.createdMember=self.createdMember+1
    if self.createdMember>=#self.members then
        self:OnAllCreateFinish()
    end
end

function Squad:OnCreateWeaponFinish()
    if self.teamWeapon then
        self:OnAllCreateFinish()
    end
end

function Squad:OnStartBattle()
    self:DestroyQualitySlots()
    for _,member in pairs(self.members) do
        member.skillManager:HaloCastAll()
    end
    if self.teamWeapon then
        self.teamWeapon.skillManager:HaloCastAll()
    end
end

---@param pos Common.Tools.UnityEngine.Vector3
function Squad:InitPosition(pos)
    self:SetPosition(pos)
    self:StartCameraFollow(pos)
end

function Squad:ReturnMemberPositions()
    local pos = {}
    for i = 1, 5 do
        local offsetPos = self.formation:GetOffsetByIndex(i)
        local worldPos = self.transform:TransformPoint(offsetPos)
        table.insert(pos, worldPos)
    end
    return pos
end

function Squad:SetRotation(quat)
    self.transform.rotation=quat
end

function Squad:PlayAnim(anim,rewind)
    --Logger.LogError("PlayAnim"..anim)
    self.animNameCache=anim
    ---@param v Scene.LWBattle.BarrageBattle.Unit.Member
    for _,v in pairs(self.members) do
        if rewind == true then
            v:RewindAndPlaySimpleAnim(anim) --从头播放动画
        else
            v:PlaySimpleAnim(anim)
        end
    end
    ---@param v Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember
    if self.teamWeapon then
        if rewind == true then
            self.teamWeapon:RewindAndPlaySimpleAnim(anim) --从头播放动画
        else
            self.teamWeapon:PlaySimpleAnim(anim)
        end
    end
end

function Squad:Attack(targetPos)
    ---@param v Scene.LWBattle.BarrageBattle.Unit.Member
    for _,v in pairs(self.members) do
        local skill=v.skillManager:GetActiveSkillIgnoreRange()
        if skill then
            v.skillManager:ActiveCast(skill,targetPos)
        end
    end
    ---@param v Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember
    -- for _,v in pairs(self.tacMembers) do
    --     local skill=v.skillManager:GetActiveSkillIgnoreRange()
    --     if skill then
    --         v.skillManager:ActiveCast(skill,targetPos)
    --     end
    -- end
end


---@param pos Common.Tools.UnityEngine.Vector3
function Squad:SetPosition(pos)
    self.cur_pos.x = pos.x
    self.cur_pos.z = pos.z
    self.transform:Set_position(self.cur_pos.x,self.cur_pos.y,self.cur_pos.z)
end
function Squad:SetPositionXZ(x,z)
    self.cur_pos.x = x
    self.cur_pos.z = z
    self.transform:Set_position(self.cur_pos.x,self.cur_pos.y,self.cur_pos.z)
end


function Squad:GetPosition()
    return self.cur_pos
end


function Squad:GetMemberCount()
    if not self.members then
        return 0
    end
    local cnt = 0
    for _, _ in pairs(self.members) do
        cnt = cnt + 1
    end
    return cnt
end


--将AI操作转化为命令：设定目的地，destination可以为nil
---@param destination Scene.LWBattle.LWWayPoint
function Squad:OnSetDestination(destination)
    self.destination=destination
    if destination then
        --Logger.Log("正在前往下一个路径点："..destination.pos.x..","..destination.pos.y..","..destination.pos.z)
        --self.fsm:HandleInput(Const.SquadCommand.AttackMove,destination.pos)
        self.fsm:ChangeState(SquadState.Move,destination.pos)
    else
        self.fsm:ChangeState(SquadState.Stay)
    end
end

--将玩家操作转化为命令：按下屏幕
function Squad:OnFingerDown(pos)
    self.stationAttackPos=pos
    for _,v in pairs(self.members) do
        v:HandleInput(MemberCommand.StationAttack,pos)
    end
end

--将玩家操作转化为命令：按住屏幕
function Squad:OnFingerHold(x,z)
    local pos=Vector3.New(x,0,z)
    if not self.stationAttackPos then
        self:OnFingerDown(pos)
        return
    end
    local dis=self.stationAttackPos-pos
    local sqrDiff=Vector3.SqrMagnitude(dis)
    if sqrDiff>0.0001 then
        self:OnFingerDown(pos)
    end
end

--将玩家操作转化为命令：松手
function Squad:OnFingerUp()
    self.stationAttackPos=nil
    for _,v in pairs(self.members) do
        v:HandleInput(MemberCommand.AutoAttack)
    end
end


--当一个队员到达目的地
function Squad:OnMemberArriveWayPoint()
    self.battleMgr:OnArriveWayPoint()
end

--function Squad:CheckEnemyInAlertRange()
--    for _,v in pairs(self.members) do
--        if v:CheckEnemyInAlertRange() then
--            return true
--        end
--    end
--    return false
--end


---检查是否暂停移动（警戒范围内有boss或10个敌人）(内部防止高频调用）
function Squad:CheckNeedStop()
    if self:IsSuperArmor() or self.battleMgr.state==BarrageState.Exit then
        self.needStop = false
        return self.needStop
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if now - self.lastTimeCheckNeedStop < 100 then
        return self.needStop
    end
    self.lastTimeCheckNeedStop = now
    self.needStop = PveUtil.CheckHasUnitInSphereRange(self.battleMgr,self.transform.position,
            Const.MEMBER_ALERT_RADIUS,LayerMask.GetMask("Zombie"),nil,10) 
            or PveUtil.CheckHasBossInSphereRange(self.battleMgr,self.transform.position,
            Const.MEMBER_ALERT_RADIUS,LayerMask.GetMask("Zombie"))
    return self.needStop
end


--local velocity = Vector3.zero
local velocity = Vector3.unity_vector3(0, 0, 0)
local smoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 0)

function Squad:OnUpdate()
    self.fsm:OnUpdate()

    if self.m_startCameraFollow and not self.battleMgr:IsPlayingShakeCamera()
    and self.battleMgr.state~=BarrageState.Exit then
        self:UpdateCameraFollow()
    end

    if self:IsSuperArmor() or self.battleMgr.state==BarrageState.Exit then
        self:UpdateMemberCollision()
    end
end

---@param pos Common.Tools.UnityEngine.Vector3
function Squad:StartCameraFollow(spawnPos)
    self.m_startCameraFollow = true
    self:InitLevelCameraLookat(spawnPos)
end

function Squad:PauseCameraFollow()
    self.m_startCameraFollow = false
end

function Squad:ResumeCameraFollow()
    self.m_startCameraFollow = true
end


-- 计算相机初始位置
function Squad:InitLevelCameraLookat(playerPos)
    local v2 = playerPos
    local v3 = Vector3.forward
    if self.gameObject ~= nil then
        v2 = self.gameObject.transform.position
        v3 = self.gameObject.transform.forward
    end
    tmpV2:Set(v2.x, v2.y, v2.z)
    tmpV3:Set(v3.x, v3.y, v3.z)
    tmpV2.x = tmpV2.x + tmpV3.x * 0.3
    tmpV2.y = tmpV2.y + tmpV3.y * 0.3
    tmpV2.z = tmpV2.z + tmpV3.z * 0.3

    self.battleMgr:Lookat(tmpV2)
end

function Squad:UpdateCameraFollow()
    
    if self.gameObject == nil then
        return
    end
    -----------------------相机缓动------------------------------
    if not DataCenter.GuideManager:InGuide() then
        local v1 = self.battleMgr:GetFollowCameraTarget()
        local v2 = self.gameObject.transform.position
        local v3 = self.gameObject.transform.forward

        tmpV1:Set(v1.x, v1.y, v1.z)
        tmpV2:Set(v2.x, v2.y, v2.z)
        tmpV3:Set(v3.x, v3.y, v3.z)
        tmpV2.x = tmpV2.x + tmpV3.x * 0.3
        tmpV2.y = tmpV2.y + tmpV3.y * 0.3
        tmpV2.z = tmpV2.z + tmpV3.z * 0.3

        --local distance = Vector3.Distance(tmpV1, tmpV2)
        --if distance > 0.001 then
        local distance = true
        if math.abs(tmpV1.x - tmpV2.x) < 0.01 and
                math.abs(tmpV1.y - tmpV2.y) < 0.01 and
                math.abs(tmpV1.z - tmpV2.z) < 0.01 then
            distance = false
            velocity.x, velocity.y, velocity.z = 0, 0, 0
        end

        if distance then
            local targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
            velocity = v
            self.battleMgr:CameraFollowLookat(targetPos)
        end
    end
end


---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function Squad:RemoveMember(member)
    for i,v in pairs(self.members) do
        if v.guid==member.guid then
            table.remove(self.members,i)
            break
        end
    end
end


function Squad:GetMoveSpeed()
    if self.moveSpeed and not self.moveSpeedDirty then
        return self.moveSpeed
    end
    self.moveSpeed=99
    self.moveSpeedDirty=false
    for _,member in pairs(self.members) do
        local speed=member:GetMoveSpeed()
        self.moveSpeed = self.moveSpeed > speed and speed or self.moveSpeed
    end
    return self.moveSpeed
end

function Squad:IsSuperArmor()
    if not self.superArmorDirty then
        return self.superArmor
    end
    local oldValue = self.superArmor
    self.superArmorDirty = false
    self.superArmor = false
    for _,member in pairs(self.members) do
        if member:IsSuperArmor() then
            self.superArmor = true
            break
        end
    end
    if oldValue ~= self.superArmor then
        if self.superArmor then--从非狂飙进入狂飙状态
            --for _,member in pairs(self.members) do
            --    member:InterruptSkill()
            --end
            DataCenter.LWSoundManager:PlaySound(10017)
            self.superArmorSound = DataCenter.LWSoundManager:PlaySound(10018,true,true)
        else--从狂飙进入非狂飙状态
            DataCenter.LWSoundManager:StopSound(self.superArmorSound)
        end
        EventManager:GetInstance():Broadcast(EventId.SquadSuperArmorStateChange)
    end
    return self.superArmor
end

function Squad:UpdateMemberCollision()
    for _,member in pairs(self.members) do
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

function Squad:OnCollision(colliderCnt, colliderComponentArray )
    for i = 0, colliderCnt-1, 1 do
        self:Hit(colliderComponentArray[i])
    end
end

local HitDamageCD = 100 --霸体伤害对单位伤害cd
local deathEffPath = "Assets/_Art/Effect_B/Prefab/Common/Eff_shiti_boom.prefab"
function Squad:Hit(otherObj)
    local now = UITimeManager:GetInstance():GetServerTime()
    local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger~=nil and trigger.ObjectId~=0 then
        local tar = self.battleMgr:GetUnit(trigger.ObjectId)
        if tar and (tar.curBlood or 0) > 0 and now - (tar.lastHitTime or 0) > HitDamageCD then
            tar.lastHitTime = now
            --伤害
            --击退
            local hurt = 1
            local hitPoint = tar.transform.position
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
                hitBackDistance = Vector3.Normalize(hitPoint - self.transform.position) * 10
            end
            local m_deathEffPath = deathEffPath
            if tar.meta.monster_type == Const.MonsterType.Junk then
                m_deathEffPath = nil
            end
            tar:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
            tar:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,nil,m_deathEffPath,true)
            --self.battleMgr:ShowDamageText(hurt,hitPoint,DamageTextType,DamageType.Physics,false)
            if tar.meta.is_boss == 1 then
                --震屏
                local p = {}
                p.duration = 0.5
                p.strength = Vector3.New(1, 1, 0)
                p.vibrato = 20
                self.battleMgr:ShakeCameraWithParam(p)
            end
        end
    end
end

function Squad:ChangeStage(stage)
    if stage == BarrageState.PreExit then
        
    elseif stage == BarrageState.Exit then
        --路径点模式
        --local destinationQueue = {}
        --table.insert(destinationQueue,Vector3.New(BARRAGE_SCENE_CENTER,0,10000))
        --local curPos = self:GetPosition()
        --table.insert(destinationQueue,Vector3.New(BARRAGE_SCENE_CENTER,0,curPos.z))
        --self.fsm:ChangeState(SquadState.Exit,destinationQueue)
        --贝塞尔曲线
        local curPos = self:GetPosition()
        local controlPoint1 = curPos
        local controlPoint2 = Vector3.New(BARRAGE_SCENE_CENTER,0,curPos.z+EXIT_CTRL_POINT_OFFSET)
        local controlPoint3 = Vector3.New(BARRAGE_SCENE_CENTER,0,
                curPos.z+EXIT_CTRL_POINT_OFFSET+math.abs(BARRAGE_SCENE_CENTER-curPos.x))
        self.fsm:ChangeState(SquadState.Exit,controlPoint1,controlPoint2,controlPoint3)
    end
    for _, unit in pairs(self.members) do
        unit:ChangeStage(stage)
    end
    if self.teamWeapon then
        self.teamWeapon:ChangeStage(stage)
    end
end

function Squad:ChangeWeaponSkillChips(skillChips)
    if self.teamWeapon then
        self.teamWeapon:ChangeSkillChips(skillChips)
    end
end

return Squad