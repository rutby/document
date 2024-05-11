-- 引导中重登需要加载的特殊表现管理器
local GuideNeedLoadManager = BaseClass("GuideNeedLoadManager")

local WorldAttackPlayerScene = require "Scene.WorldAttackPlayerScene.WorldAttackPlayerScene"

local HideFlag = "hide"

function GuideNeedLoadManager:__init()
    self.allScene = {}
    self.useGuideTimelineMarker = false
    self.saveParam = {}--保存重登之后需要显示的数据
    self.worldAttackPlayerSceneParam = {}--世界攻击玩家场景特殊的参数
    self:AddListener()
end

function GuideNeedLoadManager:__delete()
    self:DestroyAllObject()
    self.useGuideTimelineMarker = false
    self.saveParam = {}--保存重登之后需要显示的数据
    self.worldAttackPlayerSceneParam = {}--世界攻击玩家场景特殊的参数
    self:RemoveListener()
end

function GuideNeedLoadManager:Startup()
end

function GuideNeedLoadManager:AddListener()
    if self.guideTimelineMarkerSignal == nil then
        self.guideTimelineMarkerSignal = function(id)
            self:OnTimelineMarkerSignal(id)
        end
        EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
    end
    if self.gotoTimeSignal == nil then
        self.gotoTimeSignal = function(id)
            self:GotoTime(id)
        end
        EventManager:GetInstance():AddListener(EventId.GotoTime, self.gotoTimeSignal)
    end
    if self.onEnterWorldSignal == nil then
        self.onEnterWorldSignal = function()
            self:OnEnterWorldSignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
    end
    if self.onEnterCitySignal == nil then
        self.onEnterCitySignal = function()
            self:OnEnterCitySignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
    end
    if self.moveWorldCitySignal == nil then
        self.moveWorldCitySignal = function()
            self:MoveWorldCitySignal()
        end
        EventManager:GetInstance():AddListener(EventId.MoveWorldCity, self.moveWorldCitySignal)
    end
    if self.pveLevelEnterSignal == nil then
        self.pveLevelEnterSignal = function()
            self:PveLevelEnterSignal()
        end
        EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
    end
    if self.mergeEnterSignal == nil then
        self.mergeEnterSignal = function()
            self:MergeEnterSignal()
        end
        EventManager:GetInstance():AddListener(EventId.MergeEnter, self.mergeEnterSignal)
    end
end

function GuideNeedLoadManager:RemoveListener()
    if self.guideTimelineMarkerSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.guideTimelineMarkerSignal)
        self.guideTimelineMarkerSignal = nil
    end
    if self.gotoTimeSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.GotoTime, self.gotoTimeSignal)
        self.gotoTimeSignal = nil
    end
    if self.onEnterWorldSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
        self.onEnterWorldSignal = nil
    end
    if self.onEnterCitySignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
        self.onEnterCitySignal = nil
    end
    if self.moveWorldCitySignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.MoveWorldCity, self.moveWorldCitySignal)
        self.moveWorldCitySignal = nil
    end
    if self.pveLevelEnterSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
        self.pveLevelEnterSignal = nil
    end
    if self.mergeEnterSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.MergeEnter, self.mergeEnterSignal)
        self.mergeEnterSignal = nil
    end
end

function GuideNeedLoadManager:DestroyAllObject()
    for k,v in pairs(self.allScene) do
        v:OnDestroy()
    end
    self.allScene = {}
end

function GuideNeedLoadManager:OnTimelineMarkerSignal(id)
    if self:IsUseGuideTimelineMarker() then
        if id == GuideTimeLineShowMarkerType.End then
            self.useGuideTimelineMarker = false
            self:CheckDoNext()
        else
            -- 打开对话界面
            local template = DataCenter.GuideManager:GetCurTemplate()
            if template ~= nil then
                if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
                    local para2 = template.para2
                    if para2 ~= nil then
                        DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
                        DataCenter.GuideManager:DoGuide()
                    end
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
end

function GuideNeedLoadManager:CheckDoNext()
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil then
        if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
            DataCenter.GuideManager:DoNext()
        end
    end
end

function GuideNeedLoadManager:GotoTime(time)
    for k,v in pairs(self.allScene) do
        if v.GotoTime ~= nil then
            v:GotoTime(time)
        end
    end
end

function GuideNeedLoadManager:IsUseGuideTimelineMarker()
    return self.useGuideTimelineMarker
end


function GuideNeedLoadManager:AddSaveParam(sceneType, param)
    if param ~= nil and self.saveParam[sceneType] ~= param then
        self.saveParam[sceneType] = param
        self:SendSaveParam()
        if sceneType == GuideAnimObjectType.WorldAttackPlayerScene then
            EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
        end
    end
end

function GuideNeedLoadManager:RemoveSaveParam(sceneType)
    if self.saveParam[sceneType] ~= nil then
        self.saveParam[sceneType] = nil
        self:SendSaveParam()
    end
end

function GuideNeedLoadManager:SendSaveParam()
    local str = ""
    for k,v in pairs(self.saveParam) do
        if str ~= "" then
            str = str .. "|"
        end
        str = str .. k .. ";" .. v
    end
    DataCenter.GuideManager:SendSaveGuideMessage(GuideNeedLoadScene, str)
end

function GuideNeedLoadManager:InitLoadScene()
    local str = DataCenter.GuideManager:GetSaveGuideValue(GuideNeedLoadScene)
    if str ~= nil and str ~= "" then
        local spl = string.split_ss_array(str, "|")
        for k,v in ipairs(spl) do
            local spl2 = string.split_ss_array(v, ";")
            if table.count(spl2) > 1 then
                local sceneType = tonumber(spl2[1])
                self:AddSaveParam(sceneType, spl2[2])
                self:LoadSceneBySceneType(sceneType)
            end
        end
    end
end

function GuideNeedLoadManager:LoadSceneBySceneType(sceneType)
    if self.saveParam[sceneType] ~= nil then
        local spl = string.split_ss_array(self.saveParam[sceneType], ",")
        local count = table.count(spl)
        if sceneType == GuideAnimObjectType.WorldAttackPlayerScene then
            local param = {}
            param.sceneType = sceneType
            param.hide = spl[1]
            self:LoadWorldAttackPlayerScene(param)
        end
    end
end

function GuideNeedLoadManager:GetModel(sceneType)
    return self.allScene[sceneType]
end

function GuideNeedLoadManager:IsInCityScene(sceneType)
    return false
end

function GuideNeedLoadManager:IsInWorldScene(sceneType)
    return sceneType == GuideAnimObjectType.WorldAttackPlayerScene
end

function GuideNeedLoadManager:LoadWorldAttackPlayerScene(param)
    if param.startTime == nil then
        param.startTime = UITimeManager:GetInstance():GetServerSeconds()
    end
    if self.worldAttackPlayerSceneParam.startTime == nil then
        self.worldAttackPlayerSceneParam.startTime = param.startTime
        self.worldAttackPlayerSceneParam.allTime = LuaEntry.DataConfig:TryGetNum("guide_hudier_comingsoon", "k6")
        self.worldAttackPlayerSceneParam.stopTime = LuaEntry.DataConfig:TryGetNum("guide_hudier_comingsoon", "k7")
        local posStr = LuaEntry.DataConfig:TryGetStr("guide_hudier_comingsoon", "k2")
        if not string.IsNullOrEmpty(posStr) then
            local spl = string.split_ii_array(posStr, "|")
            if spl[2] ~= nil then
                self.worldAttackPlayerSceneParam.endDeltaPos = Vector3.New(spl[1], 0, spl[2])
                local dis = math.sqrt(self.worldAttackPlayerSceneParam.endDeltaPos.x * self.worldAttackPlayerSceneParam.endDeltaPos.x
                        + self.worldAttackPlayerSceneParam.endDeltaPos.z + self.worldAttackPlayerSceneParam.endDeltaPos.z)
                self.worldAttackPlayerSceneParam.perTimeMoveDis = self.worldAttackPlayerSceneParam.allTime / dis
            end
        end
    end
    self:AddSaveParam(GuideAnimObjectType.WorldAttackPlayerScene, param.hide .. "," .. param.startTime)
    if SceneUtils.GetIsInWorld() then
        if self.allScene[param.sceneType] == nil then
            self.allScene[param.sceneType] = WorldAttackPlayerScene.New(self.worldAttackPlayerSceneParam)
        end
    end
end

function GuideNeedLoadManager:RemoveWorldAttackPlayerScene(deleteData)
    self:RemoveScene(GuideAnimObjectType.WorldAttackPlayerScene)
    if deleteData then
        self:RemoveSaveParam(GuideAnimObjectType.WorldAttackPlayerScene)
        self.worldAttackPlayerSceneParam = {}
        EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
    end
end

function GuideNeedLoadManager:OnEnterWorldSignal()
    for k,v in pairs(self.saveParam) do
        if self:IsInWorldScene(k) then
            self:LoadSceneBySceneType(k)
        else
            self:RemoveScene(k)
        end
    end
end

function GuideNeedLoadManager:OnEnterCitySignal()
    for k,v in pairs(self.saveParam) do
        if self:IsInCityScene(k) then
            self:LoadSceneBySceneType(k)
        else
            self:RemoveScene(k)
        end
    end
end

function GuideNeedLoadManager:RemoveScene(sceneType)
    local scene = self.allScene[sceneType]
    if scene ~= nil then
        scene:OnDestroy()
        self.allScene[sceneType] = nil
    end
end

function GuideNeedLoadManager:MoveWorldCitySignal()
    if SceneUtils.GetIsInWorld() then
        for k,v in pairs(self.saveParam) do
            if self:IsInWorldScene(k) then
                self:RemoveScene(k)
                self:LoadSceneBySceneType(k)
            end

        end
    end
end

function GuideNeedLoadManager:GetFakeNpcMarch()
    return self.saveParam[GuideAnimObjectType.WorldAttackPlayerScene]
end

function GuideNeedLoadManager:SetFakeNpcMarchHide(isHide)
    local str = self:GetFakeNpcMarch()
    local isContain = false
    if str ~= nil then
        isContain = string.startswith(str, HideFlag)
    end
    if isHide then
        if not isContain then
            self:AddSaveParam(GuideAnimObjectType.WorldAttackPlayerScene, HideFlag .. str)
        end
    else
        if isContain then
            str = string.gsub(str, HideFlag, "")
            self:AddSaveParam(GuideAnimObjectType.WorldAttackPlayerScene, str)
        end
    end
end

function GuideNeedLoadManager:IsFakeNpcMarchHide()
    local str = self:GetFakeNpcMarch()
    local result = false
    if str ~= nil then
        result = string.startswith(str, HideFlag)
    end
    return result
end

--pos:行军当前的位置 
--angle:行军当前的角度
--needTimer:是否需要计时器（到达配置位置后会停止不动）
function GuideNeedLoadManager:GetFakeNpcMarchPosAndAngle()
    local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
    if mainWorldPos >0 then
        local mainPos = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
        local center = {}
        center.x = math.floor(WorldTileCount/2)
        center.y = math.floor(WorldTileCount/2)
        local pos = self.worldAttackPlayerSceneParam.endDeltaPos
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local needTimer = true
        local moveTime = curTime - self.worldAttackPlayerSceneParam.startTime
        if moveTime >= self.worldAttackPlayerSceneParam.stopTime then
            moveTime = self.worldAttackPlayerSceneParam.stopTime
            needTimer = false
        end
        local percent = (self.worldAttackPlayerSceneParam.allTime - moveTime) / self.worldAttackPlayerSceneParam.allTime
        local endPosX = pos.x * percent
        local endPosZ = pos.z * percent

        local angle = WorldDownEulerAngles
        local tilePos = SceneUtils.IndexToTilePos(mainWorldPos, ForceChangeScene.World)
        if tilePos.x >= center.x then
            if tilePos.y >= center.y then
                pos = Vector3.New(mainPos.x - endPosX,0,mainPos.z - endPosZ)
                angle = WorldUpEulerAngles
            else
                pos = Vector3.New(mainPos.x -endPosX,0,mainPos.z + endPosZ)
                angle = WorldRightEulerAngles
            end
        else
            if tilePos.y >= center.y then
                pos = Vector3.New(mainPos.x + endPosX,0,mainPos.z - endPosZ)
                angle = WorldLeftEulerAngles
            else
                pos = Vector3.New(mainPos.x + endPosX,0,mainPos.z + endPosZ)
                angle = WorldDownEulerAngles
            end
        end
        return pos, angle, needTimer
    end
end

function GuideNeedLoadManager:PveLevelEnterSignal()
    self:RemoveAllScene()
end

function GuideNeedLoadManager:MergeEnterSignal()
    self:RemoveAllScene()
end

function GuideNeedLoadManager:RemoveAllScene()
    for k,v in pairs(self.saveParam) do
        self:RemoveScene(k)
    end
end

return GuideNeedLoadManager