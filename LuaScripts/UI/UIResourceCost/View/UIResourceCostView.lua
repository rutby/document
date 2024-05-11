---
--- 火力发电站进度条界面
--- Created by shimin.
--- DateTime: 2021/7/16 18:23
---
local UIResourceCostView = BaseClass("UIResourceCostView",UIBaseView)
local base = UIBaseView


local pos_go_path = "PosGo"
local slider_path = "PosGo/AnimGo/Slider"
local time_text_path ="PosGo/AnimGo/Slider/TimeText"
local fill_img_path ="PosGo/AnimGo/Slider/Fill Area/Fill"
local anim_go_path = "PosGo/AnimGo"

local SliderLength = 206
local GreenValue = 0.5
local RedValue = 0.25

local AnimWaitTime = 500
local AnimAddTime = 2000

local PosNormalPosition = Vector3.New(0,0,0)
local PosAnimPosition = Vector3.New(0,133.3,0)

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.fill_img = self:AddComponent(UIImage, fill_img_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.anim_go = self:AddComponent(UIBaseContainer, anim_go_path)
    self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
end

local function ComponentDestroy(self)
    self.pos_go = nil
    self.time_text = nil
    self.fill_img = nil
    self.slider = nil
    self.anim_go = nil
    self.AutoAdjustScreenPos = nil
end


local function DataDefine(self)
    self.unavailableTime = nil
    self.produceEndTime = nil
    self.costSpeed = 0
    self.costMaxTime = 0
    self.laseTime = 0
    self.lastCurTime = 0
    self.state = nil
    self.extraTime = 0
    self.animExtraTime = 0
    self.animStartAddTime = 0
    self.animStartAddEndTime = 0
    self.animCloseTime = 0
    self.isChangeState = nil
end

local function DataDestroy(self)
    self.unavailableTime = nil
    self.produceEndTime = nil
    self.costSpeed = nil
    self.costMaxTime = nil
    self.laseTime = nil
    self.lastCurTime = nil
    self.state = nil
    self.extraTime = nil
    self.animExtraTime = nil
    self.animStartAddTime = nil
    self.animStartAddEndTime = nil
    self.animCloseTime = nil
    self.isChangeState = nil
end


local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.isChangeState = true
    local uuid,extraTime,startEndTime = self:GetUserData()
    self.buildUuid = tonumber(uuid)
    if extraTime ~= nil and extraTime ~= "" then
        self.extraTime = tonumber(extraTime)
        self.state = UIResourceCostState.Animation
        local curTime = UITimeManager:GetInstance():GetServerTime()
        self.animStartAddTime =  curTime + AnimWaitTime
        self.animStartAddEndTime =  self.animStartAddTime + AnimAddTime
        self.animCloseTime =  self.animStartAddEndTime + AnimWaitTime
    else
        self.state = UIResourceCostState.Normal
        self.animStartAddTime = 0
        self.animStartAddEndTime = 0
        self.animCloseTime = 0
    end
    self.animExtraTime = 0
    self:SetSelectSliderValue(0)
    self:RefreshPanel()
    if startEndTime ~= nil and startEndTime ~= "" then
        self.produceEndTime = tonumber(startEndTime)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.produceEndTime < curTime then
            self.produceEndTime = curTime + AnimWaitTime * 2
        end
    end
end


local function RefreshPanel(self)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
    if buildData ~= nil then
        self.pointIndex = buildData.pointId
        self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
        self.unavailableTime = buildData.unavailableTime
        self.produceEndTime = buildData.produceEndTime
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId,buildData.level)
        if levelTemplate ~= nil then
            self.costSpeed = levelTemplate:GetCostSpeed() / 1000
            self.costMaxTime = levelTemplate:GetCostMax() / self.costSpeed
        end
    end
    self:RefreshPosGoPosition()
    if self.isChangeState then
        self.isChangeState = false
        local tile = self.buildTemplate.tiles
        self.worldPos = BuildingUtils.GetBuildModelCenterVec(self.pointIndex, tile)
        self.AutoAdjustScreenPos:Init(self.worldPos)
    end
end

local function Update(self)
    if self.unavailableTime > 0 then
        self.ctrl:CloseSelf()
    else
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.animStartAddTime > curTime then
            self.animExtraTime = 0
        elseif self.animStartAddEndTime > curTime then
            self.animExtraTime = math.floor(((1 - (self.animStartAddEndTime - curTime) / AnimAddTime) * self.extraTime))
        elseif self.animCloseTime > curTime then
            self.animExtraTime = self.extraTime
        elseif self.animCloseTime > 0 and self.animCloseTime < curTime then
            if self.state == UIResourceCostState.Animation and not self.isChangeState then
                self.ctrl:CloseSelf()
                return
            else
                self.state = UIResourceCostState.Normal
                self.animExtraTime = 0
                self.animStartAddTime = 0
                self.animStartAddEndTime = 0
                self.animCloseTime = 0
                self:RefreshPanel()
            end
        end
        local leftTime = self.produceEndTime + self.animExtraTime - curTime
        if leftTime < 0 then
            self.ctrl:CloseSelf()
        else
            local sceLeftTime = math.ceil(leftTime / 1000)
            if sceLeftTime ~= self.laseTime then
                self.laseTime = sceLeftTime
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
                self.time_text:SetText(tempTimeValue)
            end
            if TimeBarUtil.CheckIsNeedChangeBar(self.costMaxTime - leftTime,self.costMaxTime - self.lastCurTime,self.costMaxTime,SliderLength) then
                self.lastCurTime = leftTime
                self:SetSelectSliderValue(leftTime / self.costMaxTime)
            end
        end
    end
end

local function SetSelectSliderValue(self,value)
    if self.selectSliderValue ~= value then
        self.selectSliderValue = value
        self:RefreshFillBg()
        self.slider:SetValue(value)
    end
end

local function RefreshFillBg(self)
    if self.selectSliderValue >= GreenValue then
        self:SetBgImg("Assets/Main/Sprites/UI/Common/New/Common_pro_green")
    elseif self.selectSliderValue > RedValue then
        self:SetBgImg("Assets/Main/Sprites/UI/Common/New/Common_pro_light_yellow")
    else
        self:SetBgImg("Assets/Main/Sprites/UI/Common/New/Common_pro_red")
    end
end

local function SetBgImg(self,value)
    if self.bgName ~= value then
        self.bgName = value
        self.fill_img:LoadSprite(value)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
    self:AddUIListener(EventId.UIResourceCostChangeState, self.UIResourceCostChangeStateSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
    self:RemoveUIListener(EventId.UIResourceCostChangeState, self.UIResourceCostChangeStateSignal)
end

local function UpdateBuildSignal(self,bUuid)
    if bUuid ~= nil then
        if tonumber(bUuid) == self.buildUuid then
            if self.state ~= UIResourceCostState.Animation then
                self:RefreshPanel()
            end
        end
    end
end

local function RefreshPosGoPosition(self)
    if self.state == UIResourceCostState.Animation then
        self.anim_go.transform.localPosition = PosAnimPosition
    elseif self.state == UIResourceCostState.Normal then
         self.anim_go.transform.localPosition = PosNormalPosition
    end
end

local function UIResourceCostChangeStateSignal(self,uuid)
    if uuid ~= nil then
        if tonumber(uuid) == self.buildUuid then
            if self.state == UIResourceCostState.Animation then
                self.isChangeState = true
                self.anim_go.transform.localPosition = PosNormalPosition
            else
                self.isChangeState = true
                self:RefreshPanel()
            end
        else
            self.buildUuid = tonumber(uuid)
            if self.state == UIResourceCostState.Animation then
                self.isChangeState = true
                self.anim_go.transform.localPosition = PosNormalPosition
            else
                self.isChangeState = true
                self:RefreshPanel()
            end
        end
    end
end

UIResourceCostView.OnCreate= OnCreate
UIResourceCostView.OnDestroy = OnDestroy
UIResourceCostView.OnEnable = OnEnable
UIResourceCostView.OnDisable = OnDisable
UIResourceCostView.ComponentDefine = ComponentDefine
UIResourceCostView.ComponentDestroy = ComponentDestroy
UIResourceCostView.DataDefine = DataDefine
UIResourceCostView.DataDestroy = DataDestroy
UIResourceCostView.ReInit = ReInit
UIResourceCostView.SetSelectSliderValue = SetSelectSliderValue
UIResourceCostView.Update = Update
UIResourceCostView.RefreshPanel = RefreshPanel
UIResourceCostView.SetBgImg = SetBgImg
UIResourceCostView.RefreshFillBg = RefreshFillBg
UIResourceCostView.OnAddListener = OnAddListener
UIResourceCostView.OnRemoveListener = OnRemoveListener
UIResourceCostView.UpdateBuildSignal = UpdateBuildSignal
UIResourceCostView.RefreshPosGoPosition = RefreshPosGoPosition
UIResourceCostView.UIResourceCostChangeStateSignal = UIResourceCostChangeStateSignal

return UIResourceCostView