---
--- 火力发电站运输界面
--- Created by shimin.
--- DateTime: 2021/7/14 15:43
---
local UITransportResView = BaseClass("UITransportResView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path ="UICommonPopUpTitle/bg_mid/titleText"
local resource_icon_path = "ResourceIcon"
local will_add_bar_path = "WillAddBar"
local left_bar_path = "LeftBar"
local capacity_text_path = "CapacityText"
local left_time_text_path = "LeftTimeText"
local extra_time_text_path = "LeftTimeText/Text_green"
local input_field_path = "SelectInputField"
local slider_path = "SelectSlider"
local enter_btn_path ="Common_btn_green_big"
local enter_btn_name_path ="Common_btn_green_big/btnTxt_green_big_new"
local des_text_path ="Content_description"


local SliderLength = 289 * 3.14

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
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.submit_btn = self:AddComponent(UIButton, enter_btn_path)
    self.submit_btn_name = self:AddComponent(UIText, enter_btn_name_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.left_time_text = self:AddComponent(UIText, left_time_text_path)
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
    self.input_field = self:AddComponent(UIInput, input_field_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.will_add_bar = self:AddComponent(UIImage, will_add_bar_path)
    self.left_bar = self:AddComponent(UIImage, left_bar_path)
    self.capacity_text = self:AddComponent(UIText, capacity_text_path)
    self.extra_time_text = self:AddComponent(UIText, extra_time_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.submit_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSubmitClick()
    end)
    self.input_field:SetOnEndEdit(function (value)
        self:InputListener(value)
    end)
    self.slider:SetOnValueChanged(function (value)
        self:OnValueChange(value)
    end)
end

local function ComponentDestroy(self)
    self.return_btn = nil
    self.submit_btn = nil
    self.submit_btn_name = nil
    self.close_btn = nil
    self.left_time_text = nil
    self.title = nil
    self.resource_icon = nil
    self.input_field = nil
    self.slider = nil
    self.will_add_bar = nil
    self.left_bar = nil
    self.capacity_text = nil
    self.extra_time_text = nil
    self.des_text = nil
end


local function DataDefine(self)
    self.timer = nil
    self.buildUuid = nil
    self.unavailableTime = 0
    self.produceEndTime = 0
    self.costSpeed = 0
    self.costMax = 0
    self.willAddCount = nil--要运输的数量
    self.laseTime = nil
    self.lastCurTime = 0
    self.noChangeSlider = nil
    self.selectSliderValue = nil
    self.oilCapacityText = ""
    self.willAddBarValue = nil
    self.leftBarValue = nil
    self.leftCount = 0
    self.lastWillCurTime = 0
    self.extraValue = nil
    self.extraActive = nil
    self.animator_timer_action = function(temp)
        self:AnimatorTime()
    end
end

local function DataDestroy(self)
    self:DeleteTimer()
    self.timer = nil
    EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource,UIWindowNames.UITransportRes)
    self.buildUuid = nil
    self.unavailableTime = nil
    self.produceEndTime = nil
    self.costSpeed = nil
    self.costMax = nil
    self.willAddCount = nil
    self.laseTime = nil
    self.lastCurTime = nil
    self.noChangeSlider = nil
    self.selectSliderValue = nil
    self.oilCapacityText = nil
    self.willAddBarValue = nil
    self.leftBarValue = nil
    self.leftCount = nil
    self.lastWillCurTime = nil
    self.extraValue = nil
    self.extraActive = nil
    self.animator_timer_action = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    local param = {}
    param.list = {ResourceType.Oil,ResourceType.Electricity}
    param.uiName = UIWindowNames.UITransportRes
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource,param)
    self:SetInputText(0)
    self.buildUuid = self:GetUserData()
    self.title:SetLocalText(GameDialogDefine.TRANSPORT_RESOURCE_TITLE) 
    self.resource_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Oil))
    self.submit_btn_name:SetLocalText(GameDialogDefine.TRANSPORT) 
    self.des_text:SetLocalText(GameDialogDefine.TRANSPORT_RESOURCE_DES) 
    self:RefreshResourceMaxCount()
    self:RefreshPanel()
    self:SetSelectSliderValue(0)
    self:SetLeftBarValue(0)
    self:SetWillAddBarValue(0)
end


local function RefreshPanel(self)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
    if buildData ~= nil then
        self.unavailableTime = buildData.unavailableTime
        self.produceEndTime = buildData.produceEndTime
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId,buildData.level)
        if levelTemplate ~= nil then
            self.costSpeed = levelTemplate:GetCostSpeed() / 1000
            self.costMax = levelTemplate:GetCostMax()
            self.capacity_text:SetLocalText(GameDialogDefine.OIL_CAPACITY, self.leftCount, self.costMax) 
        end
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
end

local function Update(self)
    if self.unavailableTime > 0 then
        
    else
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local leftCount = Mathf.Round((self.produceEndTime - curTime) * self.costSpeed)
        if leftCount < 0 then
            leftCount = 0
        end
        if self.leftCount ~= leftCount then
            self.leftCount = leftCount
            self.capacity_text:SetLocalText(GameDialogDefine.OIL_CAPACITY, leftCount, self.costMax) 
        end
        if TimeBarUtil.CheckIsNeedChangeBar(self.costMax - leftCount - self.willAddCount,self.costMax - self.lastWillCurTime,self.costMax,SliderLength) then
            self.lastWillCurTime = leftCount + self.willAddCount
            self:SetWillAddBarValue((leftCount + self.willAddCount) / self.costMax)
        end
        if leftCount > 0 then
            local leftTime = self.produceEndTime - curTime
            local sceLeftTime = math.ceil(leftTime / 1000)
            if sceLeftTime ~= self.laseTime then
                self.laseTime = sceLeftTime
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
                self.left_time_text:SetLocalText(GameDialogDefine.STAY_TIME, tempTimeValue) 
            end
            if TimeBarUtil.CheckIsNeedChangeBar(self.costMax - leftCount,self.costMax - self.lastCurTime,self.costMax,SliderLength) then
                self.lastCurTime = leftCount
                self:SetLeftBarValue(leftCount / self.costMax)
            end
        else
            if self.laseTime ~= 0 then
                self.laseTime = 0
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(0)
                self.left_time_text:SetLocalText(GameDialogDefine.STAY_TIME, tempTimeValue) 
            end
            self:SetLeftBarValue(0)
        end
    end
end


local function InputListener(self,value)
    local temp = value
    if temp ~= nil and temp ~= "" then
        local inputCount = tonumber(temp)
        local maxCount = self.costMax - self.leftCount
        if maxCount > self.maxResourceCount then
            maxCount = self.maxResourceCount
        end
        if self.maxResourceCount == 0 then
            self:ShowOneTip(Localization:GetString(GameDialogDefine.CUR_NO_GAS))
        end
        if inputCount < 0 then
            self.willAddCount = nil
            self:SetInputText(0)
        elseif inputCount > maxCount then
            self.willAddCount = nil
            self:SetInputText(maxCount)
        else
            self:SetInputText(inputCount)
        end
        self.noChangeSlider = true
        self:SetExtraTimeText(self.willAddCount / self.costSpeed)
        if maxCount > 0 then
            self:SetSelectSliderValue((self.willAddCount) / maxCount)
        else
            self:ShowOneTip(Localization:GetString(GameDialogDefine.CUR_GAS_ENOUGH_NO_ADD))
        end
    else
        local sub = self.willAddCount
        self.willAddCount = nil
        self:SetInputText(sub)
    end
end

local function OnValueChange(self,val)
    if self.noChangeSlider then
        self.noChangeSlider = false
    else
        local maxSlider = self.costMax - self.leftCount
        local maxValue = 1
        if maxSlider > 0 then
            if maxValue > self.maxResourceCount / maxSlider then
                maxValue = self.maxResourceCount / maxSlider
            end
            if self.maxResourceCount == 0 then
                self:ShowOneTip(Localization:GetString(GameDialogDefine.CUR_NO_GAS))
            end
        else
            maxValue = 0
        end
        if val > maxValue then
            self.selectSliderValue = nil
            self:SetSelectSliderValue(maxValue)
            self.willAddCount = nil
            if maxValue == 0 then
                self:ShowOneTip(Localization:GetString(GameDialogDefine.CUR_GAS_ENOUGH_NO_ADD))
                self:SetInputText(maxValue)
                self:SetExtraTimeText(maxValue)
            else
                self:SetInputText(self.maxResourceCount)
                self:SetExtraTimeText(self.willAddCount / self.costSpeed)
            end
        else
            self.selectSliderValue = val
            local inputCount = Mathf.Round(val * maxSlider)
            self:SetInputText(inputCount)
            self:SetExtraTimeText(self.willAddCount / self.costSpeed)
        end
    end
end

local function SetSelectSliderValue(self,value)
    if self.selectSliderValue ~= value then
        self.selectSliderValue = value
        self.slider:SetValue(value)
    end
end

local function SetInputText(self,value)
    if self.willAddCount ~= value then
        self.willAddCount = value
        self.input_field:SetText(string.GetFormattedSeperatorNum(value))
    end
end

local function OnSubmitClick(self)
    local useCount = math.ceil(self.willAddCount)
    if useCount > 0 then
        --判断资源是否充足
        local num = LuaEntry.Resource:GetCntByResType(ResourceType.Oil)
        if num >= useCount then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceCost,self.buildUuid,useCount / self.costSpeed,self.produceEndTime)
            SFSNetwork.SendMessage(MsgDefines.UserResupplyBuilding,{uuid = self.buildUuid,resupplyNum = useCount})
            self.ctrl:CloseSelf()
        else
            UIUtil.ShowTipsId(GameDialogDefine.RESOURCE_LACK) 
            self.ctrl:CloseSelf()
        end
    else
        self.ctrl:CloseSelf()
    end
end

local function RefreshResourceMaxCount(self)
    self.maxResourceCount = LuaEntry.Resource:GetCntByResType(ResourceType.Oil)
end

local function UpdateResourceSignal(self)
    self:RefreshResourceMaxCount()
end

local function UpdateBuildSignal(self,bUuid)
    if bUuid ~= nil then
        if tonumber(bUuid) == self.buildUuid then
            self:RefreshPanel()
        end
    end
end

local function SetLeftBarValue(self,value)
    if self.leftBarValue ~= value then
        self.leftBarValue = value
        self.left_bar:SetFillAmount(value)
    end
end

local function SetWillAddBarValue(self,value)
    if self.willAddBarValue ~= value then
        self.willAddBarValue = value
        self.will_add_bar:SetFillAmount(value)
    end
end

local function SetExtraTimeText(self,value)
    if self.extraValue ~= value then
        self.extraValue = value
        if value <= 0 then
            self:SetExtraTimeActive(false)
        else
            self:SetExtraTimeActive(true)
            self.extra_time_text:SetText(self:GetExtraTimeStr(value))
        end
    end
end

local function SetExtraTimeActive(self,value)
    if self.extraActive ~= value then
        self.extraActive = value
        self.extra_time_text:SetActive(value)
    end
end

local function GetExtraTimeStr(self,value) 
    local time = value / 1000
    if time > 3600 then
        local t = Mathf.Round(time / 360) 
        return "+"..(t / 10) ..Localization:GetString(GameDialogDefine.HOUR)
    elseif time > 60 then
        local t = Mathf.Round(time / 60)
        return "+"..t ..Localization:GetString(GameDialogDefine.MIN)
    else
        local t = Mathf.Round(time)
        return "+"..Localization:GetString(GameDialogDefine.SEC,t)
    end
end

local function ShowOneTip(self,des)
    if self.timer == nil then
        self:AddTimer()
        UIUtil.ShowTips(des)
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(TipDefaultTime, self.animator_timer_action , self, true,false,false)
        self.timer:Start()
    end
end
local function AnimatorTime(self)
    self:DeleteTimer()
end

UITransportResView.OnCreate= OnCreate
UITransportResView.OnDestroy = OnDestroy
UITransportResView.OnEnable = OnEnable
UITransportResView.OnDisable = OnDisable
UITransportResView.OnAddListener = OnAddListener
UITransportResView.OnRemoveListener = OnRemoveListener
UITransportResView.ComponentDefine = ComponentDefine
UITransportResView.ComponentDestroy = ComponentDestroy
UITransportResView.DataDefine = DataDefine
UITransportResView.DataDestroy = DataDestroy
UITransportResView.ReInit = ReInit
UITransportResView.RefreshPanel = RefreshPanel
UITransportResView.SetSelectSliderValue = SetSelectSliderValue
UITransportResView.InputListener = InputListener
UITransportResView.Update = Update
UITransportResView.SetInputText = SetInputText
UITransportResView.OnValueChange = OnValueChange
UITransportResView.OnSubmitClick = OnSubmitClick
UITransportResView.RefreshResourceMaxCount = RefreshResourceMaxCount
UITransportResView.UpdateResourceSignal = UpdateResourceSignal
UITransportResView.UpdateBuildSignal = UpdateBuildSignal
UITransportResView.SetLeftBarValue = SetLeftBarValue
UITransportResView.SetWillAddBarValue = SetWillAddBarValue
UITransportResView.GetExtraTimeStr = GetExtraTimeStr
UITransportResView.SetExtraTimeText = SetExtraTimeText
UITransportResView.SetExtraTimeActive = SetExtraTimeActive
UITransportResView.ShowOneTip = ShowOneTip
UITransportResView.DeleteTimer = DeleteTimer
UITransportResView.AddTimer = AddTimer
UITransportResView.AnimatorTime = AnimatorTime

return UITransportResView