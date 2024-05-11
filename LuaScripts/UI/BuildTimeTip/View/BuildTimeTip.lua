--- Created by shimin.
--- DateTime: 2020/9/4 10:47
--- 时间条

local BuildTimeTip = BaseClass("BuildTimeTip")
local Localization = CS.GameEntry.Localization
local pos_path = "PosGo"
local time_text_path = "PosGo/Slider/TimeText"
local slider_path = "PosGo/Slider"
local des_text_path = "PosGo/common_bg3/DesText"
local des_bg_path = "PosGo/common_bg3"
local add_speed_btn_path = "PosGo/AddSpeedBtn"
local cost_txt_path = "PosGo/AddSpeedBtn/goldIcon/costTxt"
local confirm_txt_path = "PosGo/confirmTxt"
local SliderLength2 = 264
local SliderLength1 = 140

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
    self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.UI.Slider))
    self.des_bg = self.transform:Find(des_bg_path).gameObject
    self.des_text =  self.transform:Find(des_text_path):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.AutoAdjustScreenPos = self.transform:Find(pos_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
    self.add_speed_btn = self.transform:Find(add_speed_btn_path):GetComponent(typeof(CS.UnityEngine.UI.Button))
    self.on_click = function()
        self:OnAddSpeedClick()
    end
    self.add_speed_btn.onClick:AddListener(self.on_click)
    
    self.cost_txt = self.transform:Find(cost_txt_path):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.confirm_txt = self.transform:Find(confirm_txt_path):GetComponent(typeof(CS.UnityEngine.UI.Text))
    
end

local function ComponentDestroy(self)
    pcall(function() self.add_speed_btn.onClick:Clear() end)
    self.on_click =nil
    self.add_speed_btn =nil
    self.cost_txt = nil
    self.confirm_txt = nil
    self.time_text = nil
    self.time_text = nil
    self.des_text =  nil
    self.gameObject = nil
    self.des_bg = nil
    self.transform = nil
    self.AutoAdjustScreenPos = nil
end


local function DataDefine(self)
    self.param = nil
    self.lastTime = 0
    self.laseSliderTime = 0
    self.sliderInterVal = 0
    self.curPosition = nil
    self.index = nil
    self.timeText = nil
    self.sliderSpriteSize = nil
    self.desText = nil
    self.sliderLength = 1
    self.costNum = 0 
end

local function DataDestroy(self)
    self.param = nil
    self.lastTime = nil
    self.laseSliderTime = nil
    self.sliderInterVal = nil
    self.sliderSize = nil
    self.curPosition = nil
    self.index = nil
    self.timeText = nil
    self.sliderSpriteSize = nil
    self.desText = nil
    self.request = nil
    self.sliderLength = nil
end

local function ReInit(self,param)
    self.param = param
    self.lastTime = 0
    self.laseSliderTime = 0
    self.firstConfirm = false
    self.sendMessage =false
    self:ShowPanel()
end

local function ShowPanel(self)
    if self.param.showGold~=nil and self.param.showGold == true then
        self.add_speed_btn.gameObject:SetActive(true)
    else
        self.add_speed_btn.gameObject:SetActive(false)
    end
    --self.confirm_txt.text = Localization:GetString()
    self.confirm_txt.gameObject:SetActive(self.firstConfirm)
    if self.param.pos ~= nil then
        self:UpdatePosition(self.param.pos)
    end
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        if self.param.showGold~=nil and self.param.showGold == true then
            self:CheckGoldNum(changeTime)
        end
        local maxTime = self.param.endTime - self.param.startTime
        self:RefreshSliderInterVal()
        if curTime - self.laseSliderTime >= self.sliderInterVal then
            self.laseSliderTime = curTime
            local tempValue = 1 - changeTime / maxTime
            self:RefreshSlider(tempValue)
        end
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.lastTime then
            self.lastTime = tempTimeSec
            local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
            self.time_text.text = tempTimeValue
        end
    end

    if self.param.desName ~= nil and self.param.desName ~= "" then
        self.des_bg:SetActive(true)
        self.des_text.text = self.param.desName
    else
        self.des_bg:SetActive(false)
    end
    
end

--刷新间隔
local function RefreshSliderInterVal(self)
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        local temp = changeTime / (SliderLength2 * 2)
        temp = math.modf(temp / 10)
        temp = temp - temp % 5
        self.sliderInterVal = temp * 10
    end
end

--刷新进度条
local function RefreshSlider(self,value)
    if value >= 0 and value <= 1 then
        self.slider.value = value
    end
end


--更新时间条位置
local function UpdatePosition(self,index)
    if self.index ~= index then
        self.index = index
        local worldPos = BuildingUtils.GetBuildModelDownVec(index, self.param.tiles)
        if self.param.tiles == BuildTilesSize.One then
            self.sliderLength = SliderLength1
        else
            self.sliderLength = SliderLength2
        end
        self.AutoAdjustScreenPos:Init(worldPos)
    end
end

local function RefreshTime(self,value)
    self.time_text.text = value
end

local function OnAddSpeedClick(self)
    if self.param.queueUuid ~=nil then
        if self.sendMessage ==false then
            if self.firstConfirm then
                SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.param.queueUuid,itemIDs = "",isGold = IsGold.UseGold })
                self.sendMessage = true
                self.firstConfirm = false
                self.confirm_txt.gameObject:SetActive(false)
            else
                self.firstConfirm = true
                self.confirm_txt.gameObject:SetActive(self.firstConfirm)
            end
        end
        
    end
end

local function CheckGoldNum(self,curTime)
    local remainSec = curTime/1000
    local num = CommonUtil.GetTimeDiamondCost(remainSec)
    if num~= self.costNum then
        self.costNum = num
        self.cost_txt.text = self.costNum
    end
end
BuildTimeTip.OnCreate = OnCreate
BuildTimeTip.OnDestroy = OnDestroy
BuildTimeTip.ComponentDefine = ComponentDefine
BuildTimeTip.ComponentDestroy = ComponentDestroy
BuildTimeTip.DataDefine = DataDefine
BuildTimeTip.DataDestroy = DataDestroy
BuildTimeTip.ReInit = ReInit
BuildTimeTip.ShowPanel = ShowPanel
BuildTimeTip.RefreshSlider = RefreshSlider
BuildTimeTip.UpdatePosition = UpdatePosition
BuildTimeTip.RefreshSliderInterVal = RefreshSliderInterVal
BuildTimeTip.RefreshTime = RefreshTime
BuildTimeTip.OnAddSpeedClick = OnAddSpeedClick
BuildTimeTip.CheckGoldNum = CheckGoldNum
return BuildTimeTip