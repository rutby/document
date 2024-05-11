---
---战斗回放逻辑类
---
local base = require "DataCenter.LWBattle.Logic.LWBattleLogicInterface"
---@class DataCenter.LWBattle.Logic.Skirmish.SkirmishLogic
local SkirmishLogic = BaseClass("SkirmishLogic",base);

local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local Time = Time
local rapidjson = require "rapidjson"
local Army = require "Scene.LWBattle.Skirmish.Army"
local SkirmishSceneData = require "DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData"
local SkirmishBattleData = require "DataCenter.LWBattle.Logic.Skirmish.SkirmishBattleData"
local DamageTextManager = require "DataCenter.ZombieBattle.DamageTextManager"
local EffectObjManager = require"Scene.LWBattle.EffectObj.EffectObjManager"
local BulletManager = require"Scene.LWBattle.Bullet.BulletManager"
local UnitManager = require"Scene.LWBattle.BarrageBattle.Unit.UnitManager"
local ULTIMATE_ADVANCE_OFFSET = 0.5 --大招施法前半秒播放技能气泡动画


function SkirmishLogic:Enter(param)
    self.battleMgr = DataCenter.LWBattleManager
    self.sceneData = SkirmishSceneData.New()--场景数据：包含英雄站位等配置数据（常量）
    self.battleData = SkirmishBattleData.New(param.mailExtData)--战斗数据：来源于邮件战报
    
    self.param = param
    self.levelId = param.levelId
    self.battleMgr.cameraOffset:Set(0,0,0)
    self:ChangeStage(SkirmishStage.Load)

    self.bulletManager=BulletManager.New(self)---@type Scene.LWBattle.Bullet.BulletManager
    self.damageTextMgr = DamageTextManager.New()---@type DataCenter.ZombieBattle.DamageTextManager
    self.effectObjMgr=EffectObjManager.New(self)---@type Scene.LWBattle.EffectObj.EffectObjManager
    self.prevActIndex = 0 --上一个完成的动作
    self.useTime = 0
    self.startFrame = Time.frameCount
    self.killNum = 0
    self.unitMgr=UnitManager.New(self)---@type Scene.LWBattle.BarrageBattle.Unit.UnitManager
    self.unitGuid = 0
    self.delayEvents = {}
    self.__event_handlers = {}
    if CS.GameEntry.Sound.PlayParkourBattleBGMusic ~= nil then
        CS.GameEntry.Sound:PlayParkourBattleBGMusic()
    else
        CS.GameEntry.Sound:PlayMusic("bgm_pve_30034")
    end
    self.delayActions={}
    self.captains = {}
    --self:AddListener(EventId.OpenUI, self.OnOpenUI)
end

function SkirmishLogic:__delete()
    self:Destroy()
end

--region camera

function SkirmishLogic:InitCamera()
    self.camera = self.battleMgr.camera
    --self.hudCamera = self.battleMgr.hudCamera
    self.touchCamera = self.battleMgr.touchCamera
    self.touchCamera.CanMoveing = false

    self:InitCameraParams()
    local touchInput = self.battleMgr.touchCamera.touchInput
    self.onFingerDown = function(pos)
        self:OnFingerDown(pos)
    end
    self.onFingerUp = function()
        self:OnFingerUp()
    end

    touchInput:OnFingerDown('+', self.onFingerDown)
    touchInput:OnFingerUp('+', self.onFingerUp)
end

function SkirmishLogic:UnInitCamera()
    if self.touchCamera and self.touchCamera.touchInput then
        local touchInput = self.touchCamera.touchInput
        self.touchCamera.CanMoveing = true

        if self.onFingerDown then
            touchInput:OnFingerDown('-', self.onFingerDown)
        end
        if self.onFingerUp then
            touchInput:OnFingerUp('-', self.onFingerUp)
        end
    end
end
function SkirmishLogic:OnFingerDown()
end
function SkirmishLogic:OnFingerUp()
end

function SkirmishLogic:InitCameraParams()
    local height = self.sceneData.OPENING_CAMERA_HEIGHT
    local fov = self.sceneData.OPENING_CAMERA_FOV
    local rotation = self.sceneData.OPENING_CAMERA_ROTATION
    self.touchCamera.CamZoom = height
    self.touchCamera.LodLevel = 1
    self.camera.fieldOfView = fov
    --self.hudCamera.fieldOfView = fov
    local offsetZ = self:GetOffsetZ(height, rotation)
    self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
    self.defaultHeight = height
    self.touchCamera.CamZoomMin=10
    self.camera.transform.eulerAngles = Vector3.New(rotation, 0, 0)
end



function SkirmishLogic:GetOffsetZ(height, rotation)
    return height / math.tan(rotation * math.pi / 180)
end

function SkirmishLogic:UpdateCameraFollow()
end

function SkirmishLogic:ShakeCameraWithParam(param)
    self.battleMgr:ShakeCameraWithParam(param)
end
--endregion

--region scene

function SkirmishLogic:LoadScene(callBack)
    self.captains = {}--十个英雄 index->captain
    self.armys = {}--两支军队 1为下，2为上
    self.armys[1] = Army.New(self,1,self.sceneData,self.battleData)--军队 5个Platoon组成的集合
    self.armys[2] = Army.New(self,2,self.sceneData,self.battleData)
    
    --Scene
    self.staticMgr = CS.PVEStaticManager()
    self.staticMgr:InitLW(10, 10)
    self.staticMgr:SetVisibleChunk(2)
    self.damageTextMgr:Init(self)
    self.sceneLoadRequest = {}
    local req = Resource:InstantiateAsync(string.format(PVEScenePath, self.sceneData.sceneName))
    req:completed('+', function()
        local sceneRoot = req.gameObject.transform
        sceneRoot:Set_position(0, 0, 0)
        -- 创建成功回调
        if callBack then
            callBack()--调用LWBattleManager:LoadSceneComplete()
        end
        self:ChangeStage(SkirmishStage.Opening)--场景加载完毕，进入开场阶段
    end)
    table.insert(self.sceneLoadRequest,req)
    self.staticMgr:Append(string.format(PVEDecorationPath, self.sceneData.sceneName),0)
end

--endregion

function SkirmishLogic:OnUpdate()
    --local tarPos = self.touchCamera:GetCameraTargetPos()
    --local viewTile = SceneUtils.WorldToTile(tarPos)
    --if self.staticMgr ~= nil then
    --    self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    --end
    --
    --if not self.battleMgr:IsPlayingShakeCamera() then
    --    self:UpdateCameraFollow()
    --end

    self.bulletManager:OnUpdate()
    self.effectObjMgr:OnUpdate()
    self.damageTextMgr:OnUpdate()
    if self.armys then
        self.armys[1]:OnUpdate()
        self.armys[2]:OnUpdate()
    end

    if self.stage==SkirmishStage.Fight then
        self:OnUpdateFight()
    end

    self.unitMgr:OnUpdate()
    
    self:OnUpdateDoDelayAction()
end



function SkirmishLogic:OnUpdateSec()
    self.useTime = self.useTime + 1
end




function SkirmishLogic:DealDamage(attacker,defender,bulletMeta,damageMultiplier,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,exType,exValue)
    --local hurt,isCritical,isMiss=PveUtil.CalculateDamage(attacker,defender,bulletMeta.damage_type,damageMultiplier,exType,exValue)
    --defender:BeAttack(0,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    defender:AfterBeAttack(0,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill)
    --if hurt > 0 then
    --    if attacker.type == Const.ParkourUnitType.Hero then
    --        self:ShowDamageText(hurt,hitPoint,Const.DamageTextStyle.Attack,bulletMeta.damage_type,isCritical)
    --    else
    --        self:ShowDamageText(hurt,hitPoint,Const.DamageTextStyle.BeAttack,bulletMeta.damage_type,isCritical)
    --    end
    --end
    --if isMiss then
    --    self:ShowDamageText(0,hitPoint,Const.DamageTextStyle.Miss,bulletMeta.damage_type,isCritical)
    --end
end


function SkirmishLogic:ShowDamageText(damage,position,style,damage_type,isCritical)
    self.damageTextMgr:GenText(damage,position,style,damage_type,isCritical)
end

function SkirmishLogic:Destroy()
    --self:RemoveListener(EventId.OpenUI)
    for _,v in pairs(self.delayEvents) do
        v:Stop()
    end
    self.delayEvents = {}
    self.delayActions = {}
    self:UnInitCamera()
    self.touchCamera = nil
    if self.staticMgr then
        self.staticMgr:UnInit()
        self.staticMgr = nil
    end
    if self.bulletManager then
        self.bulletManager:Delete()
        self.bulletManager = nil
    end
    self.captains = {}
    if self.armys then
        for _,v in pairs(self.armys) do
            v:Destroy()
        end
        self.armys = nil
    end
    if self.unitMgr then
        self.unitMgr:Destroy()
        self.unitMgr = nil
    end
    if self.damageTextMgr ~= nil then
        self.damageTextMgr:Destroy()
        self.damageTextMgr = nil
    end
    if self.effectObjMgr then
        self.effectObjMgr:Delete()
        self.effectObjMgr = nil
    end
    if(self.sceneLoadRequest) then
        for  _, sceneReq in pairs(self.sceneLoadRequest) do
            sceneReq:Destroy()
        end
        self.sceneLoadRequest = nil
    end
end

function SkirmishLogic:AfterExit()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishMain, { anim = false })
    self.mainUI = nil
end

function SkirmishLogic:AddUnit(unit)
    self.unitMgr:AddUnit(unit)
end

function SkirmishLogic:RemoveUnit(unit)
    self.unitMgr:RemoveUnit(unit)
end

function SkirmishLogic:AllotUnitGuid()
    self.unitGuid = self.unitGuid + 1
    return self.unitGuid
end

function SkirmishLogic:GetUnit(id)
    return self.unitMgr:GetUnit(id)
end

--显示特效，time=nil则1秒后隐藏；time<=0 则永远显示；time>0则显示time秒
function SkirmishLogic:ShowEffectObj(path,pos,rot,time,parent,type)
    return self.effectObjMgr:ShowEffectObj(path,pos,rot,time,parent,type)
end

--移除特效
function SkirmishLogic:RemoveEffectObj(id)
    self.effectObjMgr:RemoveEffectObj(id)
end


function SkirmishLogic:AddListener(msg_name, callback)
    local bindFunc = function(...) callback(self, ...) end
    self.__event_handlers[msg_name] = bindFunc
    EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function SkirmishLogic:RemoveListener(msg_name, callback)
    local bindFunc = self.__event_handlers[msg_name]
    if not bindFunc then
        return
    end
    self.__event_handlers[msg_name] = nil
    EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function SkirmishLogic:AddDelayEvent(event,delay)
    assert(event,"event invalid")
    local timer = TimerManager:GetInstance():DelayInvoke(event,delay)
    table.insert(self.delayEvents,timer)
end



function SkirmishLogic:GetTotalKill()
    return self.killNum
end

function SkirmishLogic:GetFightDuration()
    return self.battleData.fightDuration
end

function SkirmishLogic:GetWatchTime()
    return self.useTime
end

function SkirmishLogic:GetAvgFPS()
    if self.useTime==0 then
        return -1
    end
    return (Time.frameCount-self.startFrame)/self.useTime
end




function SkirmishLogic:ChangeStage(newStage,param)
    local oldStage = self.stage
    if newStage== SkirmishStage.Load then
        self.stage = newStage
        --self.battleMgr:AutoZoom(self.sceneData.OPENING_CAMERA_ZOOM)
    elseif newStage== SkirmishStage.Opening then
        if oldStage~= SkirmishStage.Load then
            return
        end
        --Logger.Log("SkirmishState.Opening")
        self.stage = newStage
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISkirmishMain) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishMain, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
            self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UISkirmishMain).View
        end
        self.battleMgr:LookAt(self.sceneData.camPoint)
        self.battleMgr:SetGameStart(true)
        self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT,self.sceneData.OPENING_TIME)
        self:AddDelayEvent(function()
            self:ChangeStage(SkirmishStage.Fight)
        end, self.sceneData.OPENING_TIME)
    elseif newStage== SkirmishStage.Fight then
        if oldStage~= SkirmishStage.Opening then
            return
        end
        --Logger.Log("SkirmishState.Fight")
        self.stage=newStage
        self.fightTime = 0
        EventManager:GetInstance():Broadcast(EventId.SkirmishFightStage)--进入战斗阶段
    elseif newStage== SkirmishStage.End then
        if oldStage~= SkirmishStage.Opening and oldStage~= SkirmishStage.Fight  then
            return
        end
        local popDelay = param or 3
        --Logger.Log("SkirmishState.End")
        self.stage=newStage
        EventManager:GetInstance():Broadcast(EventId.SkirmishEndStage)--进入结束阶段
        self:AddDelayEvent(function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishResult, { anim = false }, param)
            --if self.mainUI then
            --    self.mainUI:HideReturn()
            --end
        end, popDelay)
    end
    if self.armys then
        for _, army in pairs(self.armys) do
            army:ChangeStage(newStage)
        end
    end
end

--region debug模式
function SkirmishLogic:SetMinionFightPause(isPause)
    for _,army in pairs(self.armys) do
        for _,platoon in pairs(army.platoons) do
            for _,minion in pairs(platoon.minions) do
                minion:SetMinionFightPause(isPause)
            end
        end
    end
end

function SkirmishLogic:SetCaptainFightPause(isPause)
    self.fightPause = isPause
    if not isPause then
        if self.stage~= SkirmishStage.Fight then
            --Logger.Log("SkirmishState.Fight")
            self.stage=SkirmishStage.Fight
            self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT)
        end
        if self.armys then
            for _, army in pairs(self.armys) do
                army:ChangeStage(SkirmishStage.Fight)
            end
        end
        if self.prevActIndex <=0 then
            self.fightTime = 0
        else
            self.fightTime = self.battleData.actions[self.prevActIndex].time
        end
    end
end

--执行下一个动作（ctrl-Y)，返回是否执行成功
function SkirmishLogic:ReDo()
    if self.prevActIndex >= #self.battleData.actions then
        return nil
    end
    self:DoAction(self.prevActIndex + 1)
    self.prevActIndex = self.prevActIndex + 1
    return true
end

--撤销上一个动作（ctrl-Z)，返回是否执行成功
function SkirmishLogic:UnDo()
    if self.prevActIndex <= 0 then
        return nil
    end
    self:UnDoAction(self.prevActIndex)
    self.prevActIndex = self.prevActIndex - 1
    return true
end

--撤销上一个动作，然后执行该动作（ctrl-Z,ctrl-Y)，返回是否执行成功
function SkirmishLogic:UnReDo()
    return self:UnDo() and self:ReDo()
end

--endregion

function SkirmishLogic:OnUpdateFight()
    if self.fightPause then
        return
    end
    
    if self.prevActIndex >= #self.battleData.actions then
        self:ChangeStage(SkirmishStage.End)
        return
    end
    local oldFightTime = self.fightTime--上一帧时间
    self.fightTime = self.fightTime + Time.deltaTime--当前帧时间

    for i = self.prevActIndex + 1, #self.battleData.actions do
        if self.battleData.actions[i].time<self.fightTime then--[上一帧时间,当前帧时间)之间的行为都要播放
            self:DoAction(i)
            self.prevActIndex = i--记录一下（0，上一帧时间）最后一个行为index
        else
            break
        end
    end

    local oldAdvanceTime = oldFightTime+ULTIMATE_ADVANCE_OFFSET
    local advanceTime = self.fightTime+ULTIMATE_ADVANCE_OFFSET
    --需要提前播放的大招气泡
    for i = self.prevActIndex + 1, #self.battleData.actions do
        if self.battleData.actions[i].time<oldAdvanceTime then--(当前帧时间,上一帧时间+0.5)之间的行为忽略
        elseif self.battleData.actions[i].time<advanceTime then--[上一帧时间+0.5,当前帧时间+0.5)之间的行为都要播放
            self:CheckUltimateBubble(i)
        else
            break
        end
    end
    
end

function SkirmishLogic:CheckUltimateBubble(index)
    local curAction = self.battleData.actions[index]
    if curAction.phase==ActionPhase.Cast then--施法行为
        if curAction.casterIndex<=5 and DataCenter.HeroTemplateManager:IsUltimate(curAction.skillId) then
            EventManager:GetInstance():Broadcast(EventId.SkirmishUltimateBubble,curAction)
        end
    end
end

function SkirmishLogic:DoAction(index)
    local curAction = self.battleData.actions[index]
    self:LogAction(curAction)
    if curAction.phase==ActionPhase.Cast or curAction.phase==ActionPhase.FIRE_BULLET then--施法行为
        self.captains[curAction.casterIndex]:DoAction(curAction)
    elseif curAction.phase==ActionPhase.Buff then--挂buff行为
        for _,v in pairs(curAction.targets) do
            self.captains[v.index]:DoAction(curAction,v)
        end
    elseif curAction.phase==ActionPhase.Damage then--挨打行为
        if #curAction.targets==1 then
            self.captains[curAction.targets[1].index]:DoAction(curAction,curAction.targets[1])
        elseif #curAction.targets>1 then
            local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(curAction.skillId)
            local bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(skillMeta.bullet)
            local bullet_row_count = bulletMeta.bullet_row_count_replay--每波子弹数
            local bullet_wave_count = bulletMeta.bullet_wave_count_replay--子弹波数
            local bullet_diff_time = bulletMeta.bullet_diff_time_replay--波内间隔
            local bullet_wave_diff_time = bulletMeta.bullet_wave_diff_time_replay--波波间隔
            if bullet_row_count==1 and bullet_wave_count==1 then
                for _,v in pairs(curAction.targets) do
                    self.captains[v.index]:DoAction(curAction,v)
                end
            else--多段伤害，先后有延迟
                local hitsClientConfig = bullet_wave_count * bullet_row_count--总hit数=波数*每波子弹数
                local hitsServerConfig = skillMeta.pvp_cast_count
                local totalTargets = #curAction.targets
                --if hitsClientConfig~=hitsServerConfig or totalTargets>hitsServerConfig*skillMeta.pvp_pos_num then
                --    Logger.LogError("多段伤害的段数不对。前端配置波数="..bullet_wave_count
                --            .." 前端配置每波子弹数=".. bullet_row_count
                --            .." 后端配置段数=" ..hitsServerConfig
                --            .." 后端配置每段目标数=" ..skillMeta.pvp_pos_num
                --            .." 后端实际传来的Targets总数="..totalTargets
                --            .." skillId="..curAction.skillId)
                --    self:ErrorAction(curAction)
                --end
                local hitIndex = 0
                local targetIndex = 0
                local delayTime = 0
                local targetPerHits = math.ceil(totalTargets/hitsServerConfig)--每段伤害有几个目标
                for i = 0, bullet_wave_count-1 do
                    for j = 0, bullet_row_count-1 do
                        delayTime=bullet_wave_diff_time * i + bullet_diff_time * j
                        for k = 1, targetPerHits do
                            targetIndex = targetIndex + 1
                            --每段伤害的多个目标使用同一延迟
                            if curAction.targets[targetIndex] then
                                curAction.targets[targetIndex].delayTime = delayTime
                            else
                                goto breakPoint
                            end
                        end
                        hitIndex = hitIndex + 1
                    end
                end
                ::breakPoint::
                for i = targetIndex+1, totalTargets do
                    if curAction.targets[i] then
                        curAction.targets[i].delayTime = delayTime
                    end
                end
                curAction.pastIndex = 0
                curAction.pastTime = 0
                table.insert(self.delayActions,curAction)
            end
        end
    end
    EventManager:GetInstance():Broadcast(EventId.SkirmishDoAction,curAction)
end

--延迟执行action
function SkirmishLogic:OnUpdateDoDelayAction()
    for i = #self.delayActions,1,-1 do
        local action = self.delayActions[i]
        if action.pastIndex >= #action.targets then
            table.remove(self.delayActions,i)
        else
            action.pastTime=action.pastTime+Time.deltaTime
            for j = action.pastIndex + 1,#action.targets do
                local target = action.targets[j]
                if target.delayTime and target.delayTime<=action.pastTime then
                    self.captains[target.index]:DoAction(action,target)
                    action.pastIndex = j
                    --Logger.Log("DoDelayAction"..action.order.." "..target.index.." "..target.damage)
                else
                    action.pastIndex = j - 1
                    break
                end
            end
        end
    end
end

--立即执行所有的延迟action
function SkirmishLogic:DoDelayActionInstantly()
    for i = #self.delayActions,1,-1 do
        local action = self.delayActions[i]
        for j = action.pastIndex + 1,#action.targets do
            local target = action.targets[j]
            self.captains[target.index]:DoAction(action,target)
        end
        table.remove(self.delayActions,i)
    end
end

--反执行action
function SkirmishLogic:UnDoAction(index)
    local curAction = self.battleData.actions[index]
    --self:LogAction(curAction)
    if curAction.phase==ActionPhase.Cast then--主动行为
        self.captains[curAction.casterIndex]:UnDoAction(curAction)
    elseif curAction.phase==ActionPhase.Damage then--被动行为
        self:DoDelayActionInstantly()
        for _,v in pairs(curAction.targets) do
            self.captains[v.index]:UnDoAction(curAction,v)
        end
    end
    EventManager:GetInstance():Broadcast(EventId.SkirmishUnDoAction,curAction)
end

function SkirmishLogic:LogAction(action)
    local jsonData = rapidjson.encode(action)
    Logger.Log(jsonData.."uuid"..self.battleData.extData.uuid)
end

function SkirmishLogic:ErrorAction(action)
    local jsonData = rapidjson.encode(action)
    Logger.LogError(jsonData.."uuid"..self.battleData.extData.uuid)
end

function SkirmishLogic:AddCaptain(index,captain)
    self.captains[index]=captain
end

function SkirmishLogic:GetCaptain(index)
    if self.captains[index] then
        return self.captains[index]
    else
        --Logger.LogError("找不到")
        return nil
    end

end

function SkirmishLogic:OnCaptainDeath()

end

function SkirmishLogic:GetRandomTargetPos(index)
    return self.armys[index % 2 +1]:GetRandomPosition()
end

function SkirmishLogic:GetPVEType()
    return PVEType.Skirmish
end

function SkirmishLogic:Exit()
    if self.param.trainUuid then
        local trainData = DataCenter.LWMyStationDataManager:GetMyTruckByUuid(self.param.trainUuid)
        if trainData then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainDetail,{anim=false},trainData)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain,{anim=false},UIMailOpenType.History)
        end
    elseif self.param.fromPVPArenaRecords then
        -- SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRankList, true)
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaMain, { anim = false }, PVPArenaType.PeakArena ,true)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain,{anim=false},UIMailOpenType.History)
    end
    self.battleMgr:Exit()
    
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading,{})
    --self.battleMgr:Exit(function()
    --    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain,{anim=false},UIMailOpenType.History)
    --    EventManager:GetInstance():Broadcast(EventId.UIPVELoadingQuit)
    --end, "quit")
end

function SkirmishLogic:GetMailUuid()
    if self.battleData and self.battleData.extData then
        return self.battleData.extData.uuid
    end
    return nil
end

function SkirmishLogic:JumpToEnd()
    self:ChangeStage(SkirmishStage.End,0)
end

return SkirmishLogic