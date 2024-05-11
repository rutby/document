---
--- PVE 关卡
---

local BattleLevel = BaseClass("BattleLevel")

local PVEScenePath = "Assets/Main/Prefab_Dir/Pve/%s.prefab"
local PathFinder = require "Scene.PVEBattleLevel.Utils.PvePathFinder"
local VFXManager = require 'Scene.PVEBattleLevel.VFX.VFXManager'
local Const = require "Scene.BattlePveModule.Const"

local Resource = CS.GameEntry.Resource
local QualitySettings = CS.UnityEngine.QualitySettings
local Localization = CS.GameEntry.Localization

local CameraPosReady = Vector3.New(0, 12.25, 0)
local CameraPosBattle = Vector3.New(0, 12.25, 6.5)
local CameraMoveDuration = 2

function BattleLevel:__init()
    self.entered = false
    self.enterFromWorld = false
    self.mainCamera = nil
    self.pveCamera = nil
    self.waitDoGuide = {}
    self.curHeroes = {}
    
    self.VFXManager = VFXManager.New(self)
    self.VFXManager:Init()
end

function BattleLevel:__delete()
    self.waitDoGuide = nil
    
    self.VFXManager:UnInit()
    self.VFXManager = nil
end

-- 进入关卡
-- param:
-- pveEntrance: PveEntrance 关卡入口
-- levelId: int 关卡ID
-- scene: string 场景名称
--
function BattleLevel:Enter(param)
    assert(param ~= nil)
    assert(param.pveEntrance ~= nil)
    self:Destroy()

    self.levelParam = param
    self.entered = true
    self.curEntranceType = param.pveEntrance
    self.pveStatus = PveStatus.FirstStart
    self.curHeroes = {}

    if SceneUtils.GetIsInCity() then
        CS.SceneManager.World:SetUSkyActive(false)
    end

    local loadingParam = {}
    if self.curEntranceType == PveEntrance.LandBlock or self.curEntranceType == PveEntrance.Story or self.curEntranceType == PveEntrance.SiegeBoss then
        loadingParam.title = Localization:GetString("321393")
        loadingParam.desc = Localization:GetString("321394")
    elseif self.curEntranceType == PveEntrance.ArenaBattle or self.curEntranceType == PveEntrance.ArenaSetting then
        loadingParam.title = Localization:GetString("450065")
        loadingParam.desc = Localization:GetString("450066")
    elseif self.curEntranceType == PveEntrance.DetectEventPve then
        loadingParam.title = Localization:GetString("321395")
        loadingParam.desc = Localization:GetString("321396")
    elseif self.curEntranceType == PveEntrance.MineCave then
        loadingParam.title = Localization:GetString("321395")
        loadingParam.desc = Localization:GetString("321396")
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading, { anim = false }, loadingParam)
    local uiPveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
    uiPveLoading:SetOnEntered(function()
        EventManager:GetInstance():Broadcast(EventId.PveLevelBeforeEnter)
        self:LoadScene(function()
            uiPveLoading:Quit()
            self:Init()
            self:Start()
        end)
    end)
end

function BattleLevel:LoadScene(callback)
    local scene
    if not string.IsNullOrEmpty(self.levelParam.scene) then
        scene = self.levelParam.scene
    else
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
        scene = (dayNight == VitaDefines.DayNight.Day and "PveScene1" or "PveScene1")
    end
    if self.sceneReq then
        self.sceneReq:Destroy()
    end
    self.sceneReq = Resource:InstantiateAsync(string.format(PVEScenePath, scene))
    self.sceneReq:completed('+', function(req)
        self.sceneRoot = req.gameObject.transform
        self.sceneRoot:Set_position(0, 0, 0)
        if callback then
            callback()
        end
    end)
end

function BattleLevel:Destroy()
    self:EnableWorldCamera()
    PveActorMgr:GetInstance():Destroy()
    if self.pathFinder then
        self.pathFinder:Release()
    end
    if self.sceneReq then
        self.sceneReq:Destroy()
        self.sceneReq = nil
    end
    if self.updateTimer then
        UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
        self.updateTimer = nil
    end
    self:RemoveListeners()
    self.curEntranceType = nil
end

function BattleLevel:AddListeners()
    if self.addedListeners then
        return
    end
    self.addedListeners = true
    
    self.onPaySuccess = BindCallback(self, self.OnPaySuccess)
    EventManager:GetInstance():AddListener(EventId.PaySuccess, self.onPaySuccess)
    
    self.onRefreshGuide = BindCallback(self, self.OnRefreshGuide)
    EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.onRefreshGuide)
end

function BattleLevel:RemoveListeners()
    if not self.addedListeners then
        return
    end
    self.addedListeners = false
    
    EventManager:GetInstance():RemoveListener(EventId.PaySuccess, self.onPaySuccess)
    EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.onRefreshGuide)
end

function BattleLevel:EnableWorldCamera()
    if not IsNull(self.mainCamera) then
        self.mainCamera.enabled = true
    end
end

function BattleLevel:DisableWorldCamera()
    if not IsNull(CS.UnityEngine.Camera.main) then
        self.mainCamera = CS.UnityEngine.Camera.main
        self.mainCamera.enabled = false
    end
end

function BattleLevel:Init()
    --[[ ** 1.处理其他模块 ** ]]
    self.pathFinder = PathFinder.New(self)
    self.pathFinder:LoadAsync()
    DataCenter.BuildBubbleManager:ClearAll()
    DataCenter.WorldBuildBubbleManager:ClearAll()
    DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
    WorldCityTipManager:GetInstance():RemoveAllTip()
    DataCenter.WorldFavoDataManager:ClearAllianceMarks()
    -- 通知服务器离开世界，进入关卡
    self.enterFromWorld = CS.SceneManager.IsInWorld()
    if self.enterFromWorld then
        SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
    end
    CrossServerUtil.OnEnterPve()
    CS.SceneManager.Destroy()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.PVE
    RenderSetting.ToggleDepthTexture(true)
    
    self.qualityLevel = Setting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, EnumQualityLevel.Middle)
    
    --[[ ** 2.关卡数据 ** ]]

    -- 关卡相机
    self:DisableWorldCamera()
    self.pveCamera = self.sceneRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    self.pveCamera.tag = "MainCamera"
    if self.cameraTween then
        self.cameraTween:Kill()
        self.cameraTween= nil
    end
    self:SetCameraPos(CameraPosReady)
    --CS.CommonUtils.ChangeCameraStack(self.pveCamera, UIManager:GetInstance():GetUICamera())

    -- 监听
    if self.updateTimer == nil then
        self.updateTimer = function() self:OnUpdate() end
        UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
    self:AddListeners()
    EventManager:GetInstance():Broadcast(EventId.PveLevelEnter)

    self.showHp = Setting:GetPrivateBool("PVE_SHOW_HP", true)
    --self:UpdateHireHeroData()
    
    --[[ ** 3.关卡初始物体 ** ]]
    
    --[[ ** 4.UI ** ]]
    GoToUtil.CloseAllWindows()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMain)
end

function BattleLevel:GetConfig(levelId)
    local config = LocalController:instance():getLine(TableName.Pve, levelId)
    return config
end

function BattleLevel:GetEntranceType()
    return self.curEntranceType
end

function BattleLevel:GetCurHeroes()
    return self.curHeroes
end

function BattleLevel:GetMaxHeroCount()
    local key = LuaEntry.DataConfig:CheckSwitch("new_bridge_item_b") and "k12" or "k5"
    local cfg = LuaEntry.DataConfig:TryGetStr("aps_pve_config", key)
    local spls = string.split(cfg, ";")
    local count = 0
    for i = 1, 5 do
        local needLv = tonumber(spls[i]) or 9999
        if DataCenter.BuildManager.MainLv >= needLv then
            count = count + 1
        end
    end
    return math.min(count, 5)
end

function BattleLevel:EnterBattle()
    local pos = Vector3.zero
    local rot = 0
    SoundUtil.PlayBGMusicByName(SoundAssets.Music_bg_pve)
    PveActorMgr:GetInstance():Enter(self, pos, rot, self.levelParam)
end

function BattleLevel:IsInBattleLevel()
    return self.entered
end

function BattleLevel:GetSceneRoot()
    return self.sceneRoot
end

-- 开始关卡
function BattleLevel:Start()
    self:EnterBattle()
end

-- 退出关卡
function BattleLevel:Exit(afterCallback, beforeCallBack, forceChangeScene)
    if CS.SceneManager.IsInCity() or CS.SceneManager.IsInWorld() then
        return
    end
    
    local levelParam = self.levelParam
    
    self.VFXManager:DestroyParticles()
    CommonUtil.PlayGameBgMusic()

    self.entered = false

    --HeroUtils.ClearHireHeroData()

    self.pveCamera.tag = "Untagged"
    self:EnableWorldCamera()
    local eventId = 0
    if forceChangeScene == ForceChangeScene.City then
        CS.SceneManager.CreateCity()
        eventId = EventId.OnEnterCity
    elseif forceChangeScene ==  ForceChangeScene.World then
        CS.SceneManager.CreateWorld()
        eventId = EventId.OnEnterWorld
    else
        if self.enterFromWorld then
            CS.SceneManager.CreateWorld()
            eventId = EventId.OnEnterWorld
        else
            CS.SceneManager.CreateCity()
            eventId = EventId.OnEnterCity
        end
    end
    if beforeCallBack then
        beforeCallBack()
    end
    local curEntranceType = self.curEntranceType
    if curEntranceType == PveEntrance.ArenaBattle or curEntranceType == PveEntrance.ArenaSetting then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaMain,{anim = false})
        --DataCenter.ArenaManager:TryOpenCacheUI()
    elseif curEntranceType == PveEntrance.MineCave then
        DataCenter.MineCaveManager:SetEnemyPlayerPower()
        local actData = nil
        local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MineCave.Type)
        if table.count(dataList) > 0 then
            actData = dataList[1]
            if actData then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(actData.id))
            end
            
        end
    end
    CS.SceneManager.World:CreateScene(function()
        self:Destroy()
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, levelParam)
        UIManager.Instance:DestroyWindow(UIWindowNames.UIPVEResult)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain)
        if eventId ~= 0 then
            EventManager:GetInstance():Broadcast(eventId)
        end
        
        local guideType = DataCenter.GuideManager:GetGuideType()
        if guideType == GuideType.WaitBackCity then
            DataCenter.GuideManager:DoNext()
        end
        
        if afterCallback then
            afterCallback()
        end
    end)
end

function BattleLevel:GuideEnd()
    
end

function BattleLevel:GetHeroSelectHistory()
    local heroArr = {}

    local uid = LuaEntry.Player.uid
    local pveHeroes
    if self.curEntranceType == PveEntrance.ArenaBattle then
        local str = "ArenaPveCacheHeroes_" .. LuaEntry.Player.uid
        pveHeroes = CS.GameEntry.Setting:GetString(str, "")
    elseif self.curEntranceType == PveEntrance.ArenaSetting then
        local army = DataCenter.ArenaManager:GetDefenseArmy()
        if army and army.heroes then
            for i, v in ipairs(army.heroes) do
                local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.heroUuid)
                if heroData ~= nil then
                    table.insert(heroArr, v.heroUuid)
                end
            end
        end
    elseif self.curEntranceType == PveEntrance.MineCave then
        --矿洞不加载历史英雄
    else
        pveHeroes = Setting:GetPrivateString(SettingKeys.PVE_HEROES, "")
    end
    
    if not string.IsNullOrEmpty(pveHeroes) then
        local heroes = string.split_ss_array(pveHeroes, ";")
        for _, v in ipairs(heroes) do
            local uuid = tonumber(v)
            if uuid and uuid > 0 then
                local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
                if heroData ~= nil then
                    heroArr[#heroArr + 1] = uuid
                end
            end
        end
    end
    return heroArr
end

function BattleLevel:CreateVFX(vfxId, pos, rotation)
    local effect = self.VFXManager:CreateVFX(vfxId)
    effect:SetPosition(pos)
    effect:SetRotation(rotation)
    return effect
end

function BattleLevel:RemoveVFX(vfx)
    self.VFXManager:RemoveVFX(vfx)
end

function BattleLevel:OnUpdate()
    local deltaTime = Time.deltaTime
    self.VFXManager:OnUpdate(deltaTime)
end

function BattleLevel:OnRefreshGuide()
    
end

function BattleLevel:OnPaySuccess()
    UIUtil.PveSceneHeroListRefresh()
end

function BattleLevel:FlyText(str, pos)
    local x = pos.x + math.random() * 2 - 1
    local y = pos.y + math.random() * 0.7 + 1.7
    local z = pos.z
    local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/PveFlyText.prefab")
    req:completed('+', function(req)
        local go = req.gameObject
        local tf = go.transform
        tf.position = Vector3.New(x, y, z)
        local text = go:GetComponentInChildren(typeof(CS.TMPro.TextMeshPro))
        text.text = str
        local anim = go:GetComponent(typeof(CS.SimpleAnimation))
        anim:Play("fly")
        TimerManager:GetInstance():DelayInvoke(function()
            req:Destroy()
        end, 2)
    end)
end

--获取当前关卡id
function BattleLevel:GetLevelId()
    if self.levelParam ~= nil then
        return self.levelParam.levelId
    end
    return 0
end

function BattleLevel:OnStartBattle()
    self:TweenCameraPos(CameraPosBattle, CameraMoveDuration)
end

function BattleLevel:SetCameraPos(pos)
    self.pveCamera.transform.position = pos
end

function BattleLevel:TweenCameraPos(pos, duration, callback)
    if self.cameraTween then
        self.cameraTween:Kill()
    end
    self.cameraTween = self.pveCamera.transform:DOMove(pos, duration):OnComplete(callback)
end

function BattleLevel:OnBattleFinish(battleResult)
    self.battleResult = battleResult
    
    if battleResult == Const.Result.Win then
        if self.curEntranceType == PveEntrance.LandBlock then
            DataCenter.LandManager:SendFinishPve(self.levelParam.blockId, self.levelParam.levelId, 1)
            return
        end
    else
        if self.curEntranceType == PveEntrance.LandBlock then
            DataCenter.LandManager:SendFinishPve(self.levelParam.blockId, self.levelParam.levelId, 0)
            return
        end
    end
    
    self:ShowResult()
end

function BattleLevel:ShowResult()
    TimerManager:GetInstance():DelayInvoke(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, { anim = true, isBlur = true}, self.battleResult, self.levelParam)
    end, 1)
end

--function BattleLevel:UpdateHireHeroData()
--    if self.levelParam and self.levelParam.levelId then
--        local str = GetTableData(TableName.Pve, self.levelParam.levelId, "hire_hero")
--        if not string.IsNullOrEmpty(str) then
--            local spls = string.split(str, "|")
--            HeroUtils.CreateHireHeroData(tonumber(spls[1]), tonumber(spls[2]), tonumber(spls[3]), spls[4])
--            return
--        end
--    end
--    HeroUtils.ClearHireHeroData()
--end

return BattleLevel