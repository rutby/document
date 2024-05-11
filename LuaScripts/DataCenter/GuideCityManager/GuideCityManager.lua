local GuideCityManager = BaseClass("GuideCityManager")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local Data = CS.GameEntry.Data
local function __init(self)
	self.formationParam = nil
    self.useGuideTimelineMarker = false
    self.info = {}
    self.isUnlockFog = false --是否解锁新的迷雾
    self.cityRoot = nil--拓荒结束需要隐藏的父节点
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    self.formationParam = nil
    self.useGuideTimelineMarker = nil
    self.info = nil
    self.isUnlockFog = nil
    self.cityRoot = nil
end

local function SetFormationParam(self,param)
    self.formationParam = param
end

--城市到世界返回处理
local function MoveCityToWorldHandle(self,message)
    if message["errorCode"] == nil then
        DataCenter.RadarCenterDataManager:GetDetectEventData()
        if message["worldMainPoint"]~=nil then
            LuaEntry.Player:SetMainWorldPointId(message["worldMainPoint"])
        end
        if message["newUserWorld"] ~= nil then
            DataCenter.BuildManager:SetNewUserWorld(message["newUserWorld"])
        end
        if message["allianceBornPoint"] ~= nil then
            DataCenter.GuideManager:SendSaveGuideMessage(AllianceBornPoint, tostring(message["allianceBornPoint"]))
        end
        --local city = CS.SceneManager.World
        --city:UninitSubModulesAndCameraUpdate()
        --DataCenter.BuildBubbleManager:ClearAll()
        --
        --CS.SceneManager:CreateWorld()
        --CS.SceneManager.World:CreateScene(function()
        --    CS.SceneManager.DestroyScene(city)
        --    pcall(function() CS.SceneManager.CurrSceneID = SceneManagerSceneID.World end)
        --    DataCenter.GuideManager:CheckMoveToWorldGuide()
        --    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
        --    CommonUtil.PlayGameBgMusic()
        --    TimerManager:GetInstance():DelayInvoke(function()
        --        CS.SceneManager.World.Camera:MarkLodChanged()
        --        DataCenter.RadarCenterDataManager:GetDetectEventData()
        --        EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
        --    end, 1)
        --end)
        --CS.GameEntry.Sound:PlayMainSceneBGMusic()
        --EventManager:GetInstance():Broadcast(EventId.ShowUIMainSearch)
    else
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.MoveCityToWorld, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

--Timeline相关
local function TimelineMarker0(self)
    -- 打开对话界面
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
        local para2 = template.para2
        if para2 ~= nil then
            DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
            DataCenter.GuideManager:DoGuide()
        end
    end
end

local function OnTimelineMarker(id)
    if DataCenter.GuideCityManager.useGuideTimelineMarker then
        if id == GuideTimeLineShowMarkerType.Zero then
            DataCenter.GuideCityManager:TimelineMarker0()
        end
    end
end

local function PlayTimeline(self)
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    self.newbieTimeline = ResourceManager:InstantiateAsync(UIAssets.UIGuideJianzhangTimeline)
    self.newbieTimeline:completed('+', function()
        -- 禁用场景主相机、点击输入
        CS.SceneManager.World.Enabled = false;
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
        -- timeline放置在大本中心点上
        self.newbieTimeline.gameObject.transform.position = Vector3.New(97, 0, 81)
        -- 注册剧情继续检测
        self.isTimelineContinue = false
        local timeline = self.newbieTimeline.gameObject:GetComponentInChildren(typeof(CS.GuideTimelineMarker))
        self.newbieTimeline_IsContinue = function() return self.isTimelineContinue end
        timeline.IsContinue = self.newbieTimeline_IsContinue
        -- 注册事件监听：
        self.useGuideTimelineMarker = true
    end)
end

local function SetTimeLineContinuePlay(self)
    self.isTimelineContinue = true
end

--是否为大本等级0的特殊阶段
local function IsZeroBaseLevel(self)
    return DataCenter.BuildManager.MainLv == 0
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
end

local function SetCityRoot(self,nodeList)
    self.cityRoot = nodeList
    self:RefreshCityRootActive()
end

local function RefreshCityRootActive(self)
    local isShow = false
    if self.cityRoot ~= nil then
        for k,v in ipairs(self.cityRoot) do
            v.gameObject:SetActive(isShow)
        end
    end
end

local function SetCityRootActive(self, visible)
    if self.cityRoot ~= nil then
        for k,v in ipairs(self.cityRoot) do
            v.gameObject:SetActive(visible)
        end
    end
end

GuideCityManager.__init = __init
GuideCityManager.__delete = __delete
GuideCityManager.MoveCityToWorldHandle = MoveCityToWorldHandle
GuideCityManager.TimelineMarker0 = TimelineMarker0
GuideCityManager.OnTimelineMarker = OnTimelineMarker
GuideCityManager.PlayTimeline = PlayTimeline
GuideCityManager.SetTimeLineContinuePlay = SetTimeLineContinuePlay
GuideCityManager.SetFormationParam = SetFormationParam
GuideCityManager.IsZeroBaseLevel = IsZeroBaseLevel
GuideCityManager.AddListener = AddListener
GuideCityManager.RemoveListener = RemoveListener
GuideCityManager.SetCityRoot = SetCityRoot
GuideCityManager.RefreshCityRootActive = RefreshCityRootActive
GuideCityManager.SetCityRootActive = SetCityRootActive

return GuideCityManager