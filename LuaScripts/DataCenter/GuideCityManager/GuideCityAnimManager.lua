local GuideCityAnimManager = BaseClass("GuideCityAnimManager")
--注意 unity 如果出现timeline加载出来不播放的情况，需要吧所有引用的子物体动画全部改成always,少一个都不行  --shimin 2023.4.26

local UnlockLandScene = require "Scene.GuideAnimScene.UnlockLandScene"
local BellScene = require "Scene.BellScene.BellScene"
local SecondNightScene = require "Scene.GuideAnimScene.SecondNightScene"
local HuntLodgeScene = require "Scene.GuideAnimScene.HuntLodgeScene"
local BurnResidentScene = require "Scene.GuideAnimScene.BurnResidentScene"
local ResidentEnterCityScene = require "Scene.GuideAnimScene.ResidentEnterCityScene"
local ResidentComeScene = require "Scene.GuideAnimScene.ResidentComeScene"
local ResidentScene = require "Scene.GuideAnimScene.ResidentScene"
local SecondNightBScene = require "Scene.GuideAnimScene.SecondNightBScene"

function GuideCityAnimManager:__init()
    self.model = {}
    self.mainCamera = nil
    self:AddListener()
end

function GuideCityAnimManager:__delete()
    self:RemoveListener()
    self:DestroyAllObject()
    self:MainCameraSetActive(true)
end

function GuideCityAnimManager:Startup()
end

function GuideCityAnimManager:MainCameraSetActive(active)
    if self.mainCamera == nil then
        self.mainCamera = CS.UnityEngine.Camera.main
    end
    if self.mainCamera ~= nil then
        self.mainCamera.gameObject:SetActive(active)
    end
end

function GuideCityAnimManager:AddListener()
    if self.guideTimelineMarkerSignal == nil then
        self.guideTimelineMarkerSignal = function(id)
            self:GuideTimelineMarkerSignal(id)
        end
        EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
    end
    if self.refreshGuideSignal == nil then
        self.refreshGuideSignal = function(id)
            self:RefreshGuideSignal(id)
        end
        EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.refreshGuideSignal)
    end
    if self.gotoTimeSignal == nil then
        self.gotoTimeSignal = function(id)
            self:GotoTimeSignal(id)
        end
        EventManager:GetInstance():AddListener(EventId.GotoTime, self.gotoTimeSignal)
    end
    if self.controlTimelinePauseSignal == nil then
        self.controlTimelinePauseSignal = function(id)
            self:ControlTimelinePauseSignal(id)
        end
        EventManager:GetInstance():AddListener(EventId.ControlTimelinePause, self.controlTimelinePauseSignal)
    end
end

function GuideCityAnimManager:RemoveListener()
    if self.guideTimelineMarkerSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
        self.guideTimelineMarkerSignal = nil
    end
    if self.refreshGuideSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.refreshGuideSignal)
        self.refreshGuideSignal = nil
    end
    if self.gotoTimeSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.GotoTime, self.gotoTimeSignal)
        self.gotoTimeSignal = nil
    end
    if self.controlTimelinePauseSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.ControlTimelinePause, self.controlTimelinePauseSignal)
        self.controlTimelinePauseSignal = nil
    end
end

function GuideCityAnimManager:DestroyAllObject()
    for k,v in pairs(self.model) do
        v:Destroy()
    end
    self.model = {}
end

function GuideCityAnimManager:GetModelByType(animType) 
    return self.model[animType]
end

function GuideCityAnimManager:RefreshGuideSignal()
    if not DataCenter.GuideManager:InGuide() then
        self:GuideTimelineMarkerSignal(GuideTimeLineShowMarkerType.End)
    end
end

function GuideCityAnimManager:GuideTimelineMarkerSignal(id)
    if id == GuideTimeLineShowMarkerType.End then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump,{anim = false, playEffect = false})
        self:DestroyAllObject()
        self:CheckDoNext()
    else
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil then
            if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
                DataCenter.GuideManager:DoNext()
            else
                for k,v in ipairs(template.jumptype) do
                    if v == GuideJumpType.TimelineJump then
                        if template.jumpid ~= 0 then
                            DataCenter.GuideManager:SetNoGotoTime(true)
                            DataCenter.GuideManager:SetCurGuideId(template.jumpid)
                            DataCenter.GuideManager:DoGuide()
                        end
                    end
                end
            end
        end
    end
end

function GuideCityAnimManager:CheckDoNext()
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.PlayMovie or guideType == GuideType.WaitMovieComplete then
        DataCenter.GuideManager:DoNext()
    end
end

function GuideCityAnimManager:GotoTimeSignal(time)
    if time ~= nil then
        self:GotoTime(tonumber(time))
    end
end

function GuideCityAnimManager:GotoTime(time)
    for k,v in pairs(self.model) do
        if v.GotoTime ~= nil then
            v:GotoTime(time)
        end
    end
end

function GuideCityAnimManager:GetGuideObj(objType)
    if self.model[objType] ~= nil then
        return self.model[objType]:GetGuideObj()
    end
end

--暂停当前timeline
function GuideCityAnimManager:PauseScene()
    for k,v in pairs(self.model) do
        if v.Pause ~= nil then
            v:Pause()
        end
    end
end

--恢复当前timeline
function GuideCityAnimManager:ResumeScene()
    for k,v in pairs(self.model) do
        if v.Resume ~= nil then
            v:Resume()
        end
    end
end

function GuideCityAnimManager:ControlTimelinePauseSignal(pauseType)
    if pauseType == GuideSetNormalVisible.Hide then
        self:PauseScene()
    else
        self:ResumeScene()
    end
end

function GuideCityAnimManager:DestroyOneScene(sceneType)
    if self.model[sceneType] ~= nil then
        self.model[sceneType]:Destroy()
        self.model[sceneType] = nil
    end
end

function GuideCityAnimManager:LoadOneScene(param)
    if self.model[param.sceneType] == nil then
        self.model[param.sceneType] = self:GetScript(param.sceneType)
    end
    self.model[param.sceneType]:ReInit(param)
end

function GuideCityAnimManager:GetScript(sceneType)
    if sceneType == GuideAnimObjectType.UnlockLandScene then
        return UnlockLandScene.New()
    elseif sceneType == GuideAnimObjectType.BellScene then
        return BellScene.New()
    elseif sceneType == GuideAnimObjectType.SecondNightScene then
        return SecondNightScene.New()
    elseif sceneType == GuideAnimObjectType.HuntLodgeScene then
        return HuntLodgeScene.New()
    elseif sceneType == GuideAnimObjectType.BurnResidentScene then
        return BurnResidentScene.New()
    elseif sceneType == GuideAnimObjectType.ResidentEnterCityScene then
        return ResidentEnterCityScene.New()
    elseif sceneType == GuideAnimObjectType.ResidentComeScene then
        return ResidentComeScene.New()
    elseif sceneType == GuideAnimObjectType.ResidentScene then
        return ResidentScene.New()
    elseif sceneType == GuideAnimObjectType.SecondNightBScene then
        return SecondNightBScene.New()
    end
end

function GuideCityAnimManager:GetGuideTalkObject(scene, id)
    if self.model[scene] ~= nil then
        return self.model[scene]:GetGuideTalkObject(id)
    end
end

--控制主相机相机坐标和旋转角（引导用）
function GuideCityAnimManager:SetMainCameraPositionAndRotation(position, rotation, time, moveCallback)
    local mainCamera = CS.UnityEngine.Camera.main
    if mainCamera ~= nil then
        if time == nil or time <= 0 then
            mainCamera.transform.rotation = rotation
            mainCamera.transform.position = position
            if moveCallback ~= nil then
                moveCallback()
            end
        else
            local param = {}
            param.startPos = mainCamera.transform.position
            param.endPos = position
            param.startRot = mainCamera.transform.rotation
            param.endRot = rotation
            param.mainCamera = mainCamera
            param.curTime = 0
            param.time = time
            param.moveCallback = moveCallback
            local callback = function(callback, backParam)
                backParam.curTime = backParam.curTime + Time.deltaTime
                local percent = backParam.curTime / backParam.time
                if percent >= 1 then
                    backParam.mainCamera.transform.rotation = backParam.endRot
                    backParam.mainCamera.transform.position = backParam.endPos
                    DataCenter.WaitUpdateManager:DeleteOneUpdate(callback)
                    if backParam.moveCallback ~= nil then
                        backParam.moveCallback()
                    end
                else
                    backParam.mainCamera.transform.rotation = Quaternion.Lerp(backParam.startRot, backParam.endRot, percent)
                    backParam.mainCamera.transform.position = Vector3.Lerp(backParam.startPos, backParam.endPos, percent)
                end
            end
            DataCenter.WaitUpdateManager:AddOneUpdate(callback, param)
        end
    end
end


return GuideCityAnimManager