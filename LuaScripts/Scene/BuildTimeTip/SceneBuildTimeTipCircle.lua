--- Created by shimin.
--- DateTime: 2021/8/16 23:40
--- 圆形时间条

local SceneBuildTimeTipCircle = BaseClass("SceneBuildTimeTipCircle")

local slider_path = "GameObject/PosGo/Slider"
local icon_path = "GameObject/PosGo/Icon"
local timeText_path = "GameObject/PosGo/timeBg/time"
local pos_go_path = "GameObject/PosGo"

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end

    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.ChangeSceneCircleSlider = self.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
    self.anim = self.transform:GetComponent(typeof(CS.SimpleAnimation))--CS.UnityEngine.Animator))--
    self.timeText = self.transform:Find(timeText_path):GetComponent(typeof(CS.SuperTextMesh))
    self.pos_go = self.transform:Find(pos_go_path)
end

local function ComponentDestroy(self)
    self.slider = nil
    self.icon = nil
    self.ChangeSceneCircleSlider = nil
    self.anim = nil
    self.timeText = nil
    self.pos_go = nil
end


local function DataDefine(self)
    self.param = nil
    self.curPosition = nil
    self.index = nil
    self.timer = nil
    self.timer_action = function(temp)
        self:TimeRefresh()
    end
end

local function DataDestroy(self)
    self.param = nil
    self.curPosition = nil
    self.index = nil
    self.timer_action = nil
    self:DeleteTime()
end

local function ReInit(self, paramList)
    local param = paramList[1]
    self.param = param
    self:RefreshActive(true)
    self:ShowPanel()
end

local function ShowPanel(self)
    if self.param.iconName == nil then
        self.icon.gameObject:SetActive(false)
    else
        self.icon:LoadSprite(self.param.iconName)
        if self.param.iconScale == nil then
            self.icon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        else
            self.icon.transform.localScale = self.param.iconScale
        end
        self.icon.gameObject:SetActive(true)
    end
    if self.param.position ~= nil then
        self:UpdateWorldPosition(self.param.position)
    elseif self.param.pos ~= nil then
        self:UpdatePosition(self.param.pos)
    end
    self:RefreshSliderInterVal()
    self:PlayAppearAnim()
end

local function RefreshSliderInterVal(self)
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        self.ChangeSceneCircleSlider:Init(self.param.startTime,self.param.endTime)
    end
end

local function PlayAppearAnim(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.endTime - curTime
    local passedTime = curTime - self.param.startTime
    if self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.param.buildId == BuildingTypes.WORM_HOLE_CROSS or BuildingUtils.IsInEdenSubwayGroup(self.param.buildId)==true then
        self:AddTime()
        if passedTime < 1000 then
            self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
            self.anim.gameObject:SetActive(false)
            TimerManager:GetInstance():DelayInvoke(function()
                self.anim.gameObject:SetActive(true)
                self.anim:Play("SceneBuildTimeTipCircle_defaultshow")--, 0, 0)
            end, 0.1)
        else
            self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
            self.anim.gameObject:SetActive(false)
            TimerManager:GetInstance():DelayInvoke(function()
                self.anim.gameObject:SetActive(true)
                self.anim:Play("SceneBuildTimeTipCircle_default")--, 0, 0)
            end, 0.1)
        end
    else
        if passedTime < 1000 then
            self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
            self.anim.gameObject:SetActive(false)
            TimerManager:GetInstance():DelayInvoke(function()
                self.anim.gameObject:SetActive(true)
                self.anim:Play("SceneBuildTimeTipCircle_anim")--, 0, 0)
            end, 0.1)
        else
            self.anim:Play("SceneBuildTimeTipCircle_idle")--, 0, 0)
        end
    end

end

--更新时间条位置
local function UpdatePosition(self,index)
    if self.index ~= index then
        self.index = index
        self.transform.position = BuildingUtils.GetBuildModelDownVec(index, self.param.tiles) + self.param.extraHeight
    end
end

--更新时间条位置
function SceneBuildTimeTipCircle:UpdateWorldPosition(position)
    self.transform.position = position + TimePositionDelta
end


local function RefreshActive(self,isActive)
    self.pos_go.gameObject:SetActive(isActive)
end

local function AddTime(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

local function TimeRefresh(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.endTime - curTime
    self.timeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
end

local function DeleteTime(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function CheckIfTimeTipExist(self, paramList)
    if paramList and #paramList > 0 then
        local tempParam = paramList[1]
        if self.param.model == tempParam.model then
            return true
        end
    end
    return false
end

SceneBuildTimeTipCircle.OnCreate = OnCreate
SceneBuildTimeTipCircle.OnDestroy = OnDestroy
SceneBuildTimeTipCircle.ComponentDefine = ComponentDefine
SceneBuildTimeTipCircle.ComponentDestroy = ComponentDestroy
SceneBuildTimeTipCircle.DataDefine = DataDefine
SceneBuildTimeTipCircle.DataDestroy = DataDestroy
SceneBuildTimeTipCircle.ReInit = ReInit
SceneBuildTimeTipCircle.ShowPanel = ShowPanel
SceneBuildTimeTipCircle.UpdatePosition = UpdatePosition
SceneBuildTimeTipCircle.RefreshSliderInterVal = RefreshSliderInterVal
SceneBuildTimeTipCircle.PlayAppearAnim = PlayAppearAnim
SceneBuildTimeTipCircle.RefreshActive = RefreshActive
SceneBuildTimeTipCircle.AddTime = AddTime
SceneBuildTimeTipCircle.TimeRefresh = TimeRefresh
SceneBuildTimeTipCircle.DeleteTime = DeleteTime
SceneBuildTimeTipCircle.CheckIfTimeTipExist = CheckIfTimeTipExist
return SceneBuildTimeTipCircle