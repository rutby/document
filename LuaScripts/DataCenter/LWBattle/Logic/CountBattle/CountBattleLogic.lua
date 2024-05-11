local FSMachine = require("Common.FSMachine")

local base = require "DataCenter.LWBattle.Logic.LWBattleLogicInterface"
local CountBattleLogic = BaseClass("CountBattleLogic",base)
local Touch = CS.BitBenderGames.TouchWrapper

local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")
local Config = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConfig")
local Const = require("Scene.LWBattle.Const")

local GroupClassMap = 
{
    ["ENEMY"] = require("DataCenter.LWBattle.Logic.CountBattle.Group.EnemySteerGroupProxy"),
    ["PLAYER"] = require("DataCenter.LWBattle.Logic.CountBattle.Group.SoilderSteerGroupProxy"),
}
local UnitClassMap = 
{
    ["Soilder"] = require("DataCenter.LWBattle.Logic.CountBattle.Unit.SoilderUnitProxy"),
    ["Zombie"] = require("DataCenter.LWBattle.Logic.CountBattle.Unit.ZombieUnitProxy"),
    ["Tower"] = require("DataCenter.LWBattle.Logic.CountBattle.Unit.TowerUnitProxy"),
}
local TrapClassDir = "DataCenter.LWBattle.Logic.CountBattle.Traps.%s"

local VfxPool = require "DataCenter.LWBattle.Logic.CountBattle.Comp.VfxPool"
local RocketHitEff = "Assets/Main/Prefabs/LWCountBattle/HitVfx/Eff_Rocket_hit.prefab"

local SOILDER_WEAPON_PATH_FORMAT = "DataCenter.LWBattle.Logic.CountBattle.Unit.Weapon.%s"

local DISPLACE_EPSILON = 0.01--最小位移
local AIM_TARGET_INC_ID = 0
local FPS_SAMPLE_CD = 10 --fps采样周期

local FireSoundCD = {
    [10009] = 0.2,
    [10010] = 0.2,
}

function CountBattleLogic:Enter(param)
    if self.active then
        Logger.LogError("CountBattleLogic is already actived.")
        return
    end

    -- CS.UnityEngine.Application.targetFrameRate = 20
    CS.LW.CountBattle.SteerGroup.TICK_INTERVAL = 0.02
    CS.LW.CountBattle.SteerDisplay.DELAY_TICKS = 3

    self.battleMgr = DataCenter.LWBattleManager
    self.param = param
    --if self.param.retry then
    --    先去掉，断线重连逻辑有限制
    --    self.param.firstGuideStage = nil
    --end
    self.cfg = Config.Parse(param.levelId)
    
    -- self:AddListener(EventId.CountBattlePlayerGroupSpawn, self.OnPlayerGroupSpawn)
    

    self.doors = {}
    self.traps = {}
    self.groupProxies = {}
    self.playerGroupProxy = nil
    self.enemyGroupProxies = {}
    self.aimTargets = {}
    self.bullets = {}
    self.fireSoundTimers = {}
    self.killCount = 0
    self.deadPlayingUnitProxies = {}
    
    self.fsm = FSMachine.Create(self)
    self.fsm:Add("Init", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateInit").Create())
    self.fsm:Add("Load", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateLoad").Create())
    self.fsm:Add("Ready", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateReady").Create())
    self.fsm:Add("Guide", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateGuide").Create())
    self.fsm:Add("March", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateMarch").Create(self.cfg.initPos))
    self.fsm:Add("Engage", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateEngage").Create())
    self.fsm:Add("EndLine", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateEndLine").Create())
    self.fsm:Add("Win", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateWin").Create())
    self.fsm:Add("Lose", require("DataCenter.LWBattle.Logic.CountBattle.States.CountBattleStateLose").Create())
    
    self.useTime = 0
    self.startFrame = Time.frameCount
    self.sampleCd = FPS_SAMPLE_CD
    self.sampleFrame = Time.frameCount
    self.lowestFps = 999--最低帧率（每十秒统计一次平均帧率，记录全场最小值）

    self.camLerpW = 1
    self.active = true
    
    self.stageType = self.cfg.stageType
    self.marchSpeed = self.cfg.marchSpeed
    self.defenseOffsetZ = 0             --塔防模式记录Z方向运动偏移量
    self.deltaZ = 0
    
    self.rocketHitEffPool = VfxPool.Create(RocketHitEff, 20)
    self.changeWeaponClass = {} --武器替换
end

function CountBattleLogic:__delete()
    self:Destroy()
end

function CountBattleLogic:Destroy()
    --CS.SceneManager.ResetNightColor()
    if not self.active then return end
    self.active = false

    self:RemoveAllListeners()

    -- doors
    for _, door in ipairs(self.doors) do
        if door then door:Dispose() end
    end
    self.doors = {}

    -- traps
    for _, trap in pairs(self.traps) do
        if trap then trap:Delete() end
    end
    self.traps = {}

    -- bullets
    for _, bullet in pairs(self.bullets) do
        bullet:Dispose()
    end
    self.bullets = {}

    -- groups
    for _, groupProxy in pairs(self.groupProxies) do
        if groupProxy then groupProxy:Delete() end
    end
    self.groupProxies = {}
    self.playerGroupProxy = nil
    self.enemyGroupProxies = nil

    for _, v in ipairs(self.deadPlayingUnitProxies) do
        if v then
            v:Dispose()
        end
    end
    self.deadPlayingUnitProxies = nil

    -- fsm
    if self.fsm ~= nil then
        self.fsm:Dispose()
        self.fsm = nil
    end

    -- bullet pool
    require("DataCenter.LWBattle.Logic.CountBattle.Unit.Bullet.RifleBullet").DisposePool()
    require("DataCenter.LWBattle.Logic.CountBattle.Unit.Bullet.ShotgunBullet").DisposePool()
    self.aimTargets = nil

    if self.camTween then
        self.camTween:Kill()
    end
    self.camTween = nil
    self.camera = nil

    if self.rocketHitEffPool then
        self.rocketHitEffPool:Dispose()
    end
    self.rocketHitEffPool = nil
end

function CountBattleLogic:AddListener(msg_name, callback)
    if not self.__event_handlers then self.__event_handlers = {} end
    local bindFunc = function(...) callback(self, ...) end
    self.__event_handlers[msg_name] = bindFunc
    EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function CountBattleLogic:RemoveAllListeners(msg_name)
    if not self.__event_handlers then return end
    for msg_name, bindFunc in pairs(self.__event_handlers) do
        if not bindFunc then
            EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
        end
    end
    self.__event_handlers = nil
end

function CountBattleLogic:CreateSteerGroup(rawCfg, name, tag, repF, attF, repOn, attOn)
    local cfg = {}
    cfg.name = name
    cfg.tag = tag
    cfg.repF = repF
    cfg.attF = attF
    cfg.repOn = repOn
    cfg.attOn = attOn
    cfg.DefaultUnitClass = UnitClassMap[rawCfg.class]
    for k, v in pairs(rawCfg) do
        cfg[k] = v
    end

    assert(self.groupProxies[cfg.name] == nil, "CountBattle group name already exist:" .. cfg.name)

    local GROUP_CLASS = GroupClassMap[tag]
    assert(GROUP_CLASS, "CountBattle group class not found:" .. tag)
    local groupProxy = GROUP_CLASS.New(self, cfg)
    self.groupProxies[cfg.name] = groupProxy
    return groupProxy
end

function CountBattleLogic:GetUnitClass(class)
    return UnitClassMap[class]
end

function CountBattleLogic:DeleteSteerGroup(name)
    local groupProxy = self.groupProxies[name]
    if not groupProxy then return end
    if self.playerGroupProxy == groupProxy then
        self.playerGroupProxy = nil
    end
    if self.engagingEnemyGroup == groupProxy then
        self.engagingEnemyGroup = nil
    end
    for i, enemyGroupProxy in ipairs(self.enemyGroupProxies) do
        if enemyGroupProxy == groupProxy then
            table.remove(self.enemyGroupProxies, i)
            break
        end
    end
    groupProxy:Delete()
    self.groupProxies[name] = nil
end

function CountBattleLogic:CreateTrap(trapCfg, pos, angle)
    local className = #trapCfg.motionCfgs > 0 and "TrapDynamic" or "TrapStatic"
    local classDef = require(string.format(TrapClassDir, className))
    local trap = classDef.New(trapCfg, pos, angle, self.playerGroupProxy, self)
    self.traps[trap.baseId] = trap
    return trap
end

function CountBattleLogic:DeleteTrap(trapId)
    local trap = self.traps[trapId]
    if not trap then return end
    trap:Delete()
    self.traps[trapId] = nil
end

function CountBattleLogic:RegisterAimTarget(shape, onHit, ignoreByWeapon)
    AIM_TARGET_INC_ID = AIM_TARGET_INC_ID + 1
    local target = {
        id = AIM_TARGET_INC_ID,
        shape = shape,
        onHit = onHit,
        size = shape.radius or math.min(shape.size.x, shape.size.y),
        ignoreByWeapon = ignoreByWeapon,
    }
    self.aimTargets[target.id] = target
    return target
end

function CountBattleLogic:PlayFireSound(soundId)
    local timer = self.fireSoundTimers[soundId] or 0
    if timer <= 0 then
        self.fireSoundTimers[soundId] = FireSoundCD[soundId] or 1
        DataCenter.LWSoundManager:PlaySound(soundId)
    end
end

function CountBattleLogic:UnregisterAimTarget(id)
    self.aimTargets[id] = nil
end

function CountBattleLogic:AddBullet(bullet)
    table.insert(self.bullets, bullet)
end

function CountBattleLogic:InitCamera()
    self.fsm:Switch("Init")
end

function CountBattleLogic:LoadScene(callBack)
    self.fsm:Switch("Load", callBack)
end

function CountBattleLogic:OnUpdate()
    local dt = Time.deltaTime
    if self.fsm then
        self.fsm:Update(dt)
    end

    if self.fingerDown then
        self:OnFingerHold()
    end

    for _, trap in pairs(self.traps) do
        if trap then
            trap:OnUpdate(dt)
        end
    end

    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        if bullet and bullet:OnUpdate(dt, self.aimTargets, self) then
            bullet:Release()
            table.remove(self.bullets, i)
        end
    end

    for k, v in pairs(self.fireSoundTimers) do
        self.fireSoundTimers[k] = v - dt
    end

    if not self.playerGroupProxy then return end

    local boundLeft = self.playerGroupProxy:GetBoundLeft()
    local boundRight = self.playerGroupProxy:GetBoundRight()
    local nowX = self.playerGroupProxy:GetPosX()
    if nowX + boundLeft < self.cfg.boundary[1] then
        local newX = self.cfg.boundary[1] - boundLeft
        self.playerGroupProxy:SetPosX(newX)
    elseif nowX + boundRight > self.cfg.boundary[2] then
        local newX = self.cfg.boundary[2] - boundRight
        self.playerGroupProxy:SetPosX(newX)
    end
    self:SyncComera()

    if self.playerGroupProxy:GetPoint() <= 0 then
        self:OnBattleLose()
    end
end


function CountBattleLogic:SyncComera()
    if not self.playerGroupProxy then return end
    if not self.fsm.currState or not self.fsm.currState.syncCamera then
        return
    end

    local _, _, z = self.playerGroupProxy.transform:Get_position()

    local camPos = Vector3.New(self.cfg.initPos.x, 0, z) + Consts.FOLLOW_VIEW_OFFSET
    if self.camLerpW < 1 and self.srcCamPos then
        camPos = Vector3.Lerp(self.srcCamPos, camPos, self.camLerpW)
    end
    self.camera.transform:Set_position(camPos.x, camPos.y, camPos.z)

    local viewTile = SceneUtils.WorldToTile(camPos + Consts.SCENE_VIEW_OFFSET)
    if self.staticMgr ~= nil then
        self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
    -- self.battleMgr:CameraFollowLookAt(camPos)
end

--手指开始按下
function CountBattleLogic:OnFingerDown(pos)
    if not self.fsm.currState or not self.fsm.currState.canInput then
        return
    end
    self.fingerDown = true
    local touchCamera = self.battleMgr.touchCamera
    local ray = touchCamera:ScreenPointToRay(pos)
    local plane = Plane.New(Vector3.up,0)
    local hit,dis = plane:Raycast(ray)
    local hitPoint = ray:GetPoint(dis)
    self.lastFingerPosX = hitPoint.x
end

--手指抬起
function CountBattleLogic:OnFingerUp()
    self.fingerDown = false
end

function CountBattleLogic:OnFingerHold()
    local currState = self.fsm.currState
    if currState and Touch.TouchCount > 0 then
        local touch = Touch.Touches[0]
        local pos = touch.Position
        local touchCamera = self.battleMgr.touchCamera
        local ray = touchCamera:ScreenPointToRay(pos)
        local plane = Plane.New(Vector3.up,0)
        local hit,dis = plane:Raycast(ray)
        local hitPoint = ray:GetPoint(dis)
        local delta = hitPoint.x - self.lastFingerPosX
        if math.abs(delta) >= DISPLACE_EPSILON then
            self.lastFingerPosX = hitPoint.x
            if currState.canInput then
                local nowX = self.playerGroupProxy:GetPosX()
                local newX = nowX + delta
                self.playerGroupProxy:SetPosX(newX)
            end
        end
    else
        self.fingerDown = false
    end
end

function CountBattleLogic:OnUpdateSec()
    self.useTime = self.useTime + 1
    self.sampleCd = self.sampleCd - 1
    if self.sampleCd<=0 then
        self.sampleCd = FPS_SAMPLE_CD
        local fps = (Time.frameCount-self.sampleFrame)/FPS_SAMPLE_CD
        self.sampleFrame = Time.frameCount
        if fps<self.lowestFps then
            self.lowestFps = fps
        end
    end
end

function CountBattleLogic:OnBattleWin()
    self.fsm:Switch("Win")
end

function CountBattleLogic:OnBattleLose()
    self.fsm:Switch("Lose")
end

function CountBattleLogic:NoticeWin()
    --发出胜利通知
    local restSoilders = 0
    if self.cfg.saveRestSoilders and self.playerGroupProxy then
        restSoilders = self.playerGroupProxy:GetPoint()
    end
    -- TODO: Beef 这里先跳过服务器
    --SFSNetwork.SendMessage(MsgDefines.LWSaveCountRecord, self.cfg.levelId, restSoilders)
    EventManager:GetInstance():Broadcast(EventId.PVEBattleVictoryConfirmed, PVEType.Count)
end

function CountBattleLogic:NoticeLose()
    --发出失败通知
    --EventManager:GetInstance():Broadcast(EventId.GF_count_battle_lose, self.cfg.levelId)
end

function CountBattleLogic:AfterExit()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCountBattleMain, { anim = false })
end

function CountBattleLogic:GetStageId()
    return self.cfg.levelId
end

function CountBattleLogic:GetCostTime()
    return self.useTime
end

function CountBattleLogic:GetAvgFPS()
    if self.useTime == 0 then
        return -1
    end
    return (Time.frameCount - self.startFrame) / self.useTime
end

function CountBattleLogic:GetLowestFPS()
    return math.min(self.lowestFps,self:GetAvgFPS())
end

function CountBattleLogic:GetTotalKill()
    return self.killCount
end

function CountBattleLogic:GetPVEType()
    return PVEType.Count
end

function CountBattleLogic:GetInitPos()
    return self.cfg.initPos
end

function CountBattleLogic:GetGuideTimelineOffset()
    return Vector3.New(-0.4, 0, 12.9)
end

function CountBattleLogic:OnGuideTimelineStart(timelineGO)
    local camInTimeline = timelineGO:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    self.srcCamPos = camInTimeline.transform.position
    self.srcCamAngle = camInTimeline.transform.eulerAngles.x
    self.srcCamFov = camInTimeline.fieldOfView
    camInTimeline.enabled = false

    if self.camera then
        self.camera.transform.position = self.srcCamPos
        self.camera.transform.eulerAngles = Vector3.New(self.srcCamAngle, 0, 0)
        self.camera.fieldOfView = self.srcCamFov
    end
end

-- 第一关Timeline调的
function CountBattleLogic:OnGuideTimelineDone()
    self.fsm:Switch("Ready")
end

function CountBattleLogic:DoGuideCameraTween()
    self.camLerpW = 0
    self.camTween = CS.DG.Tweening.DOTween.To(
        function()
            return self.camLerpW
        end,
        function(lerpW)
            self.camLerpW = lerpW
            if self.camera then
                self.camera.transform.eulerAngles = Vector3.New(Mathf.Lerp(self.srcCamAngle, Consts.CAMERA_X_ANGLE, lerpW), 0, 0)
                self.camera.fieldOfView = Mathf.Lerp(self.srcCamFov, 60, lerpW)
            end
        end, 1, 1.5)
end

function CountBattleLogic:IsDefenseMode()
    return self.stageType == Const.CountBattleType.Defense
end

function CountBattleLogic:UpdateDefenseOffset(dt)
    if self.stageType ~= Const.CountBattleType.Defense then
        return
    end
    self.deltaZ = -dt * self.marchSpeed
    local add = self.deltaZ
    self.defenseOffsetZ = self.defenseOffsetZ + add
end

function CountBattleLogic:PlayRocketEff(pos, dir)
    if self.rocketHitEffPool then
        self.rocketHitEffPool:Play(pos, -dir)
    end
end

function CountBattleLogic:OnTrapDeadEffect(deadEffect, trapPos, headIcon)
    local type = deadEffect[1]
    if type == Const.CountBattleTrapDeadEffect.ChangeWeapon then
        local soliderId = deadEffect[2]
        local newWeapon = deadEffect[3]
        local newWeaponClass = require(string.format(SOILDER_WEAPON_PATH_FORMAT, newWeapon))
        self.changeWeaponClass[soliderId] = newWeaponClass
        
        --替换所有当前士兵的武器
        if self.playerGroupProxy then
            for _, unitProxy in pairs(self.playerGroupProxy.unitProxies) do
                if unitProxy.soilderId and unitProxy.soilderId == soliderId then
                    unitProxy:ChangeWeapon(newWeaponClass)
                end
            end

            if not string.IsNullOrEmpty(headIcon) then
                local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(trapPos)
                local targetPos = CS.CSUtils.WorldPositionToUISpacePosition(self.playerGroupProxy.circleTrans.position)

                UIUtil.DoFlyCustom(headIcon, nil, 1, srcPos, targetPos, nil, nil, function()
                    if self.playerGroupProxy then
                        self.playerGroupProxy:PlayCircleTween()
                    end
                end)
            end
        end
    elseif type == Const.CountBattleTrapDeadEffect.AddSolider then
        local soliderId = deadEffect[2]
        local count = tonumber(deadEffect[3])

        if self.playerGroupProxy then
            local soliderCfg = Config.GetSoilderRawCfg(soliderId)
            self.playerGroupProxy:DoSpawn(count, soliderCfg)

            if not string.IsNullOrEmpty(headIcon) then
                local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(trapPos)
                local targetPos = CS.CSUtils.WorldPositionToUISpacePosition(self.playerGroupProxy.circleTrans.position)

                UIUtil.DoFlyCustom(headIcon, nil, 1, srcPos, targetPos, nil, nil, function()
                    if self.playerGroupProxy then
                        self.playerGroupProxy:PlayCircleTween()
                    end
                end)
            end
        end
    end
end

function CountBattleLogic:AddDeadPlayingUnit(unitProxy)
    table.insert(self.deadPlayingUnitProxies, unitProxy)
end

function CountBattleLogic:RemoveDeadPlayingUnit(unitProxy)
    table.removebyvalue(self.deadPlayingUnitProxies, unitProxy, true)
end

return CountBattleLogic