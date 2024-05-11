---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 6/21/21 4:39 PM
---



-- local hero_dynamic_download_path = "Assets/Download/HeroModel/High/%s.prefab"
local hero_build_in_path = LoadPath.DyHero
local default_build_in_model_name = "tank"

local HeroSquadModelViewer = BaseClass("HeroSquadModelViewer", UIBaseContainer)
local QualitySettingUtil = require "Util.QualitySettingUtil"
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen

local HeroRenderLayer = "PlaneShadowObject"

local GrabRenderLayer = "Grab"

local AdvanceEffectName = 'HeroAdvanceEffect'
local shadowDistance
local defaultQuality

HeroSquadModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack, onTimeLineCallback)
    base.OnCreate(self)

    self.rtSize = 1440

    self:ComponentDefine(enableTouch)
    self.defaultScenePos = Vector3.New(9999,9999,9999)
    self.cameraOffsetFlag = 1
    self.cameraOffset = Vector3.zero

    self.sceneLoaded = nil
    self.sceneCamera = nil
    -- self.heroCameras = {}
    self.heroModels = {}
    self.sceneLoading = nil
    self.heroesLoaded = {}
    self.heroesLoading = {}
    self.lastHeroesUuid = nil
    self.heroLoadedCallback = nil

    self.curRotationX = 0
    self.onDragCallBack = onDragCallBack
    self.onTimeLineCallback = onTimeLineCallback
    self.rotateState = 0
    self.rawImage:SetEnable(false)
    --self.rawImage:SetColor(Color.New(1, 1, 1, 0))

    HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef + 1
    self.refTag = HeroSquadModelViewer.openedRef

    self.weaponLoading = nil
    self.weaponLoaded = nil
    self.weaponModel = nil
    self.weaponModeId = nil
    self.waitCallbacks = {}
end

local function OnDestroy(self)
    RenderSetting.ToggleFurRenderFeature(false)
    HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef - 1
    self.refTag = nil
    self.waitCallbacks = nil
    self:ReleaseTexture()

    for _, v in pairs(self.heroesLoading) do
        if v ~= nil then
            v:RealDestroy()
        end
    end
    
    for _,v in pairs(self.heroesLoaded) do
        if v ~= nil then
            v:RealDestroy()
        end
    end

    if self.weaponLoading ~= nil then
        self.weaponLoading:RealDestroy()
    end
    self.weaponLoading = nil
    if self.weaponLoaded ~= nil then
        self.weaponLoaded:RealDestroy()
    end
    self.weaponLoaded = nil
    self.weaponModel = nil
    self.weaponModeId = nil
    
    self.heroSlots = nil
    self.heroSlotsDefaultPos = nil
    self.weaponSlot = nil
    self.weaponSlotDefaultPos = nil
    if self.sceneLoading ~= nil then
        self.sceneLoading:Destroy()
    end

    if self.sceneLoaded ~= nil then
        self.sceneLoaded:Destroy()
    end

    self.heroesLoading = nil
    self.sceneLoaded = nil
    self.sceneLoading = nil
    self.lastHeroId = nil
    self.curRotationX = nil
    self.sceneCamera = nil
    -- self.heroCameras = nil
    self.heroModels = nil

    self.onDragCallBack = nil
    self.onTimeLineCallback = nil
    self.rotateState = nil

    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)

    if self.sceneLoaded ~= nil then
        self.sceneLoaded.gameObject:SetActive(true)
    end
    self:SetQuality(true)
    RenderSetting.ToggleFurRenderFeature(true)

    if self.heroesUuid ~= nil then
        for _, v in pairs(self.heroesUuid) do
            local model = self.heroModels[v]
            local animation = model:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
            if animation then
                animation:Stop()
                animation:Play("idle")
            end
        end
    end
    if self.weaponModel ~= nil then
        local animation = self.weaponModel:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if animation then
            animation:Stop()
            animation:Play("idle")
        end
    end
    
    --CS.UnityEngine.Shader.EnableKeyword('HERO_SHOW')
end
local function SetQuality(self, enable)
    if enable then
        shadowDistance = RenderSetting.GetShadowDistance()
        RenderSetting.SetShadowDistance(6)
    else
        RenderSetting.SetShadowDistance(shadowDistance)
    end

end

local function OnDisable(self)
    --CS.UnityEngine.Shader.DisableKeyword('HERO_SHOW')

    if self.sceneLoaded ~= nil then
        self.sceneLoaded.gameObject:SetActive(false)
    end
    base.OnDisable(self)
    self:SetQuality(false)

end

local function ComponentDefine(self, enableTouch)
    self.rawImage = self:AddComponent(UIRawImage, "")
end

local function ComponentDestroy(self)
end

local function SetHeroesUuid(self,heroesUuid)
    self.lastHeroesUuid = self.heroesUuid
    
    self.heroesUuid = heroesUuid

    -- self.time1 = UITimeManager:GetInstance():GetServerTime()

    --清理角色
    self:RemoveUnusedHeroes(heroesUuid)
    self:ReloadScene(function(ret)
        if not ret then
            return
        end

        -- self.time2 = UITimeManager:GetInstance():GetServerTime()
        if self.heroesUuid == nil then
            return
        end

        for index,v in pairs(self.heroesUuid) do 
            self:ReloadHero(index,v, function(ret2)
                if self.heroLoadedCallback then
                    self.heroLoadedCallback()
                end
            end)
        end
    end)
end

local function SetWeaponMeta(self, appearanceId)
    if not appearanceId then
        return
    end
    self.lastWeaponId = appearanceId
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)

    -- 清理角色
    self:CheckRemoveTacticalWeapon()
    self:ReloadScene(function(ret)
        if not ret then
            return
        end

        self:ReloadWeapon(appearanceMeta)
    end)
end

local function ExecuteWaitCallbacks(self,result)
    if self.waitCallbacks == nil then
        return
    end
    for _,v in pairs(self.waitCallbacks) do
        v(result)
    end
    self.waitCallbacks = {}
end

--- 加载预览场景
local function ReloadScene(self, callback)
    --场景已加载
    if self.sceneLoaded ~= nil then
        local camera = self.sceneCamera
        self:OnRenderTexture(camera)
        self.sceneLoaded.gameObject:SetActive(true)

        if callback ~= nil then
            callback(true)
        end
        return
    end

    --正在加载中
    if self.sceneLoading ~= nil then
        table.insert(self.waitCallbacks, callback)
        return
    end


    local scenePath = HeroUtils.DisplayPVPSquadScenePath
    Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)

    local request = ResourceManager:InstantiateAsync(scenePath)
    self.sceneLoading = request

    request:completed('+', function()
        if request.isError then
            self.sceneLoading = nil
            if callback ~= nil then
                callback(false)
            end
            ExecuteWaitCallbacks(self,false)
            return
        end

        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)

        local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))

        self.sceneLoading = nil
        self.sceneLoaded = request
        self.sceneCamera = camera

        self:ToggleSceneCamera(true)

        local hero1Slot = request.gameObject.transform:Find("Hero1Slot")
        local hero2Slot = request.gameObject.transform:Find("Hero2Slot")
        local hero3Slot = request.gameObject.transform:Find("Hero3Slot")
        local hero4Slot = request.gameObject.transform:Find("Hero4Slot")
        local hero5Slot = request.gameObject.transform:Find("Hero5Slot")
        self.heroSlots = {hero1Slot, hero2Slot, hero3Slot, hero4Slot, hero5Slot}

        local hero1SlotDefaultPos = hero1Slot.position
        local hero2SlotDefaultPos = hero2Slot.position
        local hero3SlotDefaultPos = hero3Slot.position
        local hero4SlotDefaultPos = hero4Slot.position
        local hero5SlotDefaultPos = hero5Slot.position
        self.heroSlotsDefaultPos = {hero1SlotDefaultPos, hero2SlotDefaultPos, hero3SlotDefaultPos, hero4SlotDefaultPos, hero5SlotDefaultPos}
        if callback ~= nil then
            callback(true)
        end

        self.weaponSlot = request.gameObject.transform:Find("WeaponSlot")
        self.weaponSlotDefaultPos = self.weaponSlot.position
        ExecuteWaitCallbacks(self,true)
    end)
end

local function SetHeroOnSlot(self,heroModel,slotIndex)
    if heroModel == nil then
        return
    end

    if self.heroSlots == nil or self.heroSlots[slotIndex] == nil then
        return
    end

    local slot = self.heroSlots[slotIndex]
    local slotTransform = slot.transform
    local heroTransform = heroModel.transform
    heroTransform:SetParent(slotTransform)
    heroTransform:Set_localPosition(0, 0, 0)
    heroTransform:Set_localScale(1, 1, 1)
    heroTransform.localRotation = Quaternion.identity
end

---加载英雄
local function ReloadHero(self,slotIndex, heroId, callback)
    --正在加载中
    if self.heroesLoading[heroId] ~= nil then
        return
    end

    if heroId == nil then
        if callback ~= nil then
            callback(false)
        end
        return
    end

    if self.heroesLoaded[heroId] ~= nil then
        self.heroesLoaded[heroId].gameObject:SetActive(true)
        
        SetHeroOnSlot(self,self.heroesLoaded[heroId].gameObject,slotIndex)

        if callback ~= nil then
            callback(true)
        end
        return
    end

    local modelPath
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroId)
    local modelName = ""
    if heroData ~= nil then
        modelName = heroData.appearanceMeta.queue_model_path
    end
    --如果配表中没有找到名称直接使用默认内置角色画
    if modelName == nil or modelName == "" then
        Logger.LogError("#HeroPreview# ReloadHero Error! prefab_high is nil!, heroId:" .. heroId)
        modelPath = string.format(hero_build_in_path, default_build_in_model_name)
    else
        --查找优先级 动更目录 >> 内置目录 >> 默认角色
        -- modelPath = string.format(hero_dynamic_download_path, modelName)
        -- local hasAsset = ResourceManager:IsAssetDownloaded(modelPath)
        -- if not hasAsset then
        modelPath = modelName--string.format(hero_build_in_path, modelName)
        local hasAsset = ResourceManager:IsAssetDownloaded(modelPath)

        if not hasAsset then
            modelPath = string.format(hero_build_in_path, default_build_in_model_name)
        end
        -- end
    end

    local hasAsset = ResourceManager:IsAssetDownloaded(modelPath)
    if not hasAsset then
        --连默认角色都没找到
        Logger.LogError("#HeroPreview# ReloadHero Error! No model resource found, even the default!")

        --self:ToggleSceneCamera(true)
        if callback ~= nil then
            callback(false)
        end

        return
    end

    local request = ResourceManager:InstantiateAsync(modelPath)
    self.heroesLoading[heroId] = request
    request:completed('+', function()
        if request.isError then
            Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroId:" .. heroId .. ", Error:" .. request.error)

            self.heroesLoading[heroId] = nil
            if callback ~= nil then
                callback(false)
            end
            return
        end

        -- self.time3 = UITimeManager:GetInstance():GetServerTime()
        --Logger.Log('#zlh# loadHero ms:' .. (self.time3 - self.time2) .. ',load hero total ms:' .. (self.time3 - self.time1))

        local currentScene = self.sceneLoaded
        local go_rt = request.gameObject.transform
        --英雄默认出生点
        local spawnPoint = currentScene.gameObject.transform:Find('SpawnPoint')
        request.gameObject:SetActive(true)
        go_rt:SetParent(spawnPoint ~= nil and spawnPoint or currentScene.gameObject.transform)
        go_rt:Set_localPosition(0, 0, 0)
        go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        -- go_rt:Set_eulerAngles(0, 0, 0)
        self.heroesLoading[heroId] = nil

        go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
        -- go_rt:Set_eulerAngles(0, 0, 0)
        self.heroModels[heroId] = go_rt
        SetHeroOnSlot(self, request.gameObject,slotIndex)


        local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
        local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)

        if director then
            director.enabled = false
        end

        local animation = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if animation then
            animation:Stop()
            animation:Play("idle")
        end

        if timeLineCamera ~= nil then
            timeLineCamera.gameObject:SetActive(false)
        end

        --模型炮塔复位
        local canon_path = heroData.appearanceMeta.canon_path
        local cannon = go_rt:Find(canon_path)
        if cannon ~= nil then
            local localForward = Vector3.New(0, 0, 0)
            local canonFix = heroData.appearanceMeta.canon_rotation
            if canonFix and #canonFix==3 then--存在修正
                localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
            end
            cannon:Set_localEulerAngles(localForward)
        end

        self.heroesLoading[heroId] = nil
        self.heroesLoaded[heroId] = request

        if callback ~= nil then
            callback(true)
        end
    end)
end

    
local function RemoveUnusedHeroes(self,heroesUuid)

    if self.heroesLoading ~= nil then
        for k,v in pairs(self.heroesLoading) do
            if not table.hasvalue(heroesUuid,k) then
                v:RealDestroy()
                self.heroesLoading[k] = nil
            end
        end
    end

    if self.heroesLoaded ~= nil then
        for k,v in pairs(self.heroesLoaded) do
            if not table.hasvalue(heroesUuid,k) then
                v:RealDestroy()
                self.heroesLoaded[k] = nil
            end
        end
    end

    if self.heroModels ~= nil then
        for k,v in pairs(self.heroModels) do
            if not table.hasvalue(heroesUuid,k) then
                self.heroModels[k] = nil
            end
        end
    end

end
   
---加载英雄
local function ReloadWeapon(self, appearanceMeta, callback)
    if not appearanceMeta then
        if callback ~= nil then
            callback(false)
        end
        return
    end

    --正在加载中
    if self.weaponModeId == appearanceMeta.id then
        return
    end

    local modelPath = appearanceMeta.queue_model_path
    if string.IsNullOrEmpty(modelPath) then
        if callback ~= nil then
            callback(false)
        end
        return
    end

    local hasAsset = ResourceManager:IsAssetDownloaded(modelPath)
    if not hasAsset then
        --连默认角色都没找到
        Logger.LogError("#HeroPreview# ReloadWeapon Error! No model resource found, even the default!")
        if callback ~= nil then
            callback(false)
        end
        return
    end

    local request = ResourceManager:InstantiateAsync(modelPath)
    self.weaponLoading = request
    self.weaponModeId = appearanceMeta.id
    request:completed('+', function()
        if request.isError then
            Logger.LogError("#RecruitScene# ModelViewer ReWeapon Error! modelPath:" .. modelPath .. ", Error:" .. request.error)

            self.weaponLoading = nil
            if callback ~= nil then
                callback(false)
            end
            return
        end

        local currentScene = self.sceneLoaded
        local go_rt = request.gameObject.transform
        --英雄默认出生点
        local spawnPoint = currentScene.gameObject.transform:Find('SpawnPoint')
        request.gameObject:SetActive(true)
        go_rt:SetParent(spawnPoint ~= nil and spawnPoint or currentScene.gameObject.transform)
        go_rt:Set_localPosition(0, 0, 0)
        go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        -- go_rt:Set_eulerAngles(0, 0, 0)
        self.weaponLoading = nil

        go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
        -- go_rt:Set_eulerAngles(0, 0, 0)
        self.weaponModel = go_rt
        local slotTransform = self.weaponSlot.transform
        local weaponTransform = self.weaponModel.transform
        weaponTransform:SetParent(slotTransform)
        weaponTransform:Set_localPosition(0, 0, 0)
        weaponTransform:Set_localScale(1, 1, 1)
        weaponTransform.localRotation = Quaternion.identity


        local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
        local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)

        if director then
            director.enabled = false
        end

        local animation = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if animation then
            animation:Stop()
            animation:Play("idle")
        end

        if timeLineCamera ~= nil then
            timeLineCamera.gameObject:SetActive(false)
        end

        --模型炮塔复位
        local canon_path = appearanceMeta.canon_path
        local cannon = go_rt:Find(canon_path)
        if cannon ~= nil then
            local localForward = Vector3.New(0, 0, 0)
            local canonFix = appearanceMeta.canon_rotation
            if canonFix and #canonFix==3 then--存在修正
                localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
            end
            cannon:Set_localEulerAngles(localForward)
        end

        self.weaponLoading = nil
        self.weaponLoaded = request

        if callback ~= nil then
            callback(true)
        end
    end)
end

local function CheckRemoveTacticalWeapon(self,appearanceMeta)
    if appearanceMeta ~= nil and appearanceMeta.id == self.weaponModeId then
        return
    end
    if self.weaponLoading ~= nil then
        self.weaponLoading:RealDestroy()
        self.weaponLoading = nil
    end
    if self.weaponLoaded ~= nil then
        self.weaponLoaded:RealDestroy()
        self.weaponLoaded = nil
    end
    if self.weaponModel ~= nil then
        self.weaponModel = nil
    end
end

---设置renderTexture
local function OnRenderTexture(self, camera)
    if camera == nil then
        Logger.LogError("#zlh# OnRenderTexture camera is nil!")
        return
    end
    --打开毛发renderfeature

    if self.renderTexture == nil then
        local scale = 1
        local qulity = QualitySettingUtil.GetQulity()
        if qulity < 2 then
            scale = 0.8
        end
        local rtWidth = self.rtSize---math.floor(Screen.width * scale)
        local rtHeight = self.rtSize--math.floor(Screen.height * scale)
        local rtFormat = RenderTextureFormat.ARGB32
        -- if qulity >= 2 then
            -- if CS.UnityEngine.SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGB32) then
                -- rtFormat = RenderTextureFormat.ARGB32
            -- else
                -- rtFormat = RenderTextureFormat.DefaultHDR
            -- end
        -- end
        self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
        self.renderTexture.name = "HeroShow"
        --self.renderTexture.autoGenerateMips = false
        self.rawImage:SetTexture(self.renderTexture)
        self.rawImage:SetEnable(true)
        self.rawImage:SetColor(Color.New(1, 1, 1, 1))
    end

    camera.targetTexture = self.renderTexture
    --self.rawImage:SetActive(true)
end

---释放renderTexture
local function ReleaseTexture(self)
    self.rawImage:SetTexture(nil)

    -- for _, camera in pairs(self.heroCameras) do
    --     if camera ~= nil then
    --         camera.targetTexture = nil
    --     end
    -- end

    if self.sceneCamera ~= nil then
        self.sceneCamera.targetTexture = nil
    end

    if self.renderTexture ~= nil then
        RenderTexture.ReleaseTemporary(self.renderTexture)
        self.renderTexture = nil
    end
end


---temp
local function ToggleSceneCamera(self, b)
    local sceneCamera = self.sceneCamera
    if sceneCamera ~= nil then
        sceneCamera.gameObject:SetActive(b)

        if b then
            self:ApplyCameraLensShift()

            self:OnRenderTexture(sceneCamera)
        else
            sceneCamera.targetTexture = nil
        end
    end
end

local function SetCameraOffset(self, vector3Offset)
    self.cameraOffset = vector3Offset
    if self.sceneCamera then
        --v.transform:Set_localPosition(x, 0, 0)
        local v3 = HeroSquadModelViewer.CampCameraPosTable + self.cameraOffset
        self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
    end
end

local function ApplyCameraLensShift(self)
    local camera
    --camera = self.sceneCamera
    camera = self.curTimeLineCamera

    if camera ~= nil then
        if self.lensShift ~= nil then
            camera.lensShift = self.lensShift
        end
    end
end

local function SetHeroLoadedCallback(self, callback)
    self.heroLoadedCallback = callback
end

local function SetBeginDragListener(self, listener)
    self.beginDragListener = listener
end

local function SetEndDragListener(self, listener)
    self.endDragListener = listener
end

local function SetDefaultScenePos(self, defaultPos)
    self.defaultScenePos = defaultPos
end

--

local function ChangeToPreview(self)
    local camera = self.sceneCamera
    local duration = 0.2
    self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
    self:DoCameraAttrAni(camera, "focalLength", 21, duration)
    --camera.lensShift = Vector2.zero
end

local function DoCameraAttrAni(self, camera, attr, endValue, duration)
    local function Getter()
        return camera[attr]
    end

    local function Setter(x)
        camera[attr] = x
    end

    DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function FindTagRecursively(t, tagName, level)
    local ret1 = {}
    for k = 0, t.childCount - 1 do
        local child = t:GetChild(k)
        if child.gameObject.tag == tagName then
            table.insert(ret1, child)
        else
            if level > 1 then
                local ret2 = FindTagRecursively(child, tagName, level - 1)
                table.insertto(ret1, ret2)
            end
        end
    end

    return ret1
end

local function ToggleSceneVisible(self, t)
    if self.sceneLoaded then
        self.sceneLoaded.gameObject:SetActive(t)
    end
end

--- 恢复角色位置
local function ResetPositions(self)
    if table.IsNullOrEmpty(self.heroSlots) then
        return
    end
    for i, v in pairs(self.heroSlots) do
        v.transform:DOKill()
        v.transform.position = self.heroSlotsDefaultPos[i]
    end
end

--- 移动角色位置
---@param index number
local function MoveHeroSlotPos(self, index, screenPos)
    if table.IsNullOrEmpty(self.heroSlots) then
        return
    end
    local slot = self.heroSlots[index]
    if slot then
        slot.transform.position = self.sceneCamera:ScreenToWorldPoint(Vector3.New(screenPos.x, screenPos.y, 12))
    end
end

--- 移动固定槽位到其他槽位为止
local function HeroSlotMoveToIndex(self,index,dstIndex,time)
    if table.IsNullOrEmpty(self.heroSlots) then
        return
    end
    local animTime = time or 0.2
    if animTime <= 0 then
        local slot = self.heroSlots[index]
        if slot then
            slot.transform.position = self.heroSlotsDefaultPos[dstIndex]
        end
    else
        local slot = self.heroSlots[index]
        if slot then
            local pos = self.heroSlotsDefaultPos[dstIndex]
            slot.transform:DOMove(pos, animTime)
        end
    end
end

HeroSquadModelViewer.OnCreate = OnCreate
HeroSquadModelViewer.OnDestroy = OnDestroy
HeroSquadModelViewer.OnEnable = OnEnable
HeroSquadModelViewer.OnDisable = OnDisable
HeroSquadModelViewer.ComponentDefine = ComponentDefine
HeroSquadModelViewer.ComponentDestroy = ComponentDestroy

HeroSquadModelViewer.SetHeroesUuid = SetHeroesUuid
HeroSquadModelViewer.ReloadScene = ReloadScene
HeroSquadModelViewer.ReloadHero = ReloadHero
HeroSquadModelViewer.RemoveUnusedHeroes = RemoveUnusedHeroes

HeroSquadModelViewer.OnRenderTexture = OnRenderTexture
HeroSquadModelViewer.ReleaseTexture = ReleaseTexture

HeroSquadModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroSquadModelViewer.SetCameraOffset = SetCameraOffset

HeroSquadModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback

HeroSquadModelViewer.SetBeginDragListener = SetBeginDragListener
HeroSquadModelViewer.SetEndDragListener = SetEndDragListener

HeroSquadModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroSquadModelViewer.ApplyCameraLensShift = ApplyCameraLensShift
HeroSquadModelViewer.SetQuality = SetQuality
HeroSquadModelViewer.ChangeToPreview = ChangeToPreview
HeroSquadModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroSquadModelViewer.FindTagRecursively = FindTagRecursively
HeroSquadModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroSquadModelViewer.ResetPositions = ResetPositions
HeroSquadModelViewer.MoveHeroSlotPos = MoveHeroSlotPos
HeroSquadModelViewer.HeroSlotMoveToIndex = HeroSlotMoveToIndex
HeroSquadModelViewer.SetWeaponMeta = SetWeaponMeta
HeroSquadModelViewer.CheckRemoveTacticalWeapon = CheckRemoveTacticalWeapon
HeroSquadModelViewer.ReloadWeapon = ReloadWeapon

HeroSquadModelViewer.CampCameraPosTable = 9999

return HeroSquadModelViewer