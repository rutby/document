local UISoldierCell = BaseClass("UISoldierCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local Param = DataClass("Param", ParamData)
local ParamData =  {
	callBack,
	index,
	allCount,
	template,
	stateType,
	count,
}

local icon_path = "Icon"
local input_path = "SelectInputField"
local slider_path = "TimeSlider_up"
local slider_handle_path = "TimeSlider_up/Handle Slide Area"
local name_text_path = "content_main_tips_new"

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.input = self:AddComponent(UIInput, input_path)
	self.slider = self:AddComponent(UISlider, slider_path)
	self.slider_handle = self:AddComponent(UIBaseContainer, slider_handle_path)
	self.name_text = self:AddComponent(UIText, name_text_path)
	self.slider:SetOnValueChanged(function (value)
		self:OnValueChange(value)
	end)
	self.input:SetOnEndEdit(function (value)
		self:InputListener(value)
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.icon = nil
	self.input = nil
	self.slider = nil
	self.slider_handle = nil
	self.name_text = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.inputCount = nil
	self.noChangeSlider = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.noChangeSlider = nil
	self.inputCount = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self.icon:LoadSprite(string.format(LoadPath.SoldierIcons,param.template.icon))
	self.name_text:SetText(Localization:GetString(param.template.name).."  "..string.GetFormattedSeperatorNum(param.allCount))
	self.minValue = 0
	self.maxValue = param.allCount
	if param.stateType == HospitalPanelStateType.Treating then
		self.slider:SetInteractable(false)
		self.slider_handle:SetActive(false)
		self.noChangeSlider = true
		self.input:SetInteractable(false)
		self:SetInputText(math.floor(param.count * self.param.allCount))
		self:SetSliderValue(param.count)
	elseif param.stateType == HospitalPanelStateType.Select then
		self.slider:SetInteractable(true)
		self.slider_handle:SetActive(true)
		self.noChangeSlider = true
		self.input:SetInteractable(true)
		self:SetInputText(param.count)
		self:SetSliderValue(self.inputCount / self.maxValue)
	end
end

local function OnValueChange(self,val)
	if self.noChangeSlider then
		self.noChangeSlider = false
	else
		local inputCount = math.floor(val * self.maxValue + 0.5)
		if inputCount < self.minValue then
			self.inputCount = nil
			self:SetInputText(self.minValue)
		else
			self:SetInputText(inputCount)
		end
		self:CallBack()
	end
end

local function CallBack(self)
	if self.param.stateType == HospitalPanelStateType.Select and self.param.callBack ~= nil then
		self.param.callBack(self.param.index,self.inputCount)
	end
end

local function SetInputText(self,value)
	if self.inputCount ~= value then
		self.inputCount = value
		self.input:SetText(string.GetFormattedSeperatorNum(value))
	end
end

local function SetSliderValue(self,value)
	if self.sliderValue ~= value then
		self.sliderValue = value
		self.slider:SetValue(value)
	end
end

local function UpdateSlider(self,value)
	if self.param.stateType == HospitalPanelStateType.Select then
		self:SetInputText(value)
		self:SetSliderValue(self.inputCount / self.maxValue)
	elseif self.param.stateType == HospitalPanelStateType.Treating then
		self.noChangeSlider = true
		self:SetInputText(math.floor(value * self.param.allCount))
		self:SetSliderValue(value)
		self.param.count = value
	end
end


local function InputListener(self,value)
	local temp = value
	if temp ~= nil and temp ~= "" then
		local inputCount = tonumber(temp)
		if inputCount < 0 then
			self.inputCount = nil
			self:SetInputText(0)
		elseif inputCount > self.maxValue then
			self.inputCount = nil
			self:SetInputText(self.maxValue)
		else
			self:SetInputText(inputCount)
		end
		self.noChangeSlider = true
		self:SetSliderValue(inputCount / self.maxValue)
	else
		local sub = self.inputCount
		self.inputCount = nil
		self:SetInputText(sub)
	end
end

UISoldierCell.OnCreate = OnCreate
UISoldierCell.OnDestroy = OnDestroy
UISoldierCell.Param = Param
UISoldierCell.OnEnable = OnEnable
UISoldierCell.OnDisable = OnDisable
UISoldierCell.ComponentDefine = ComponentDefine
UISoldierCell.ComponentDestroy = ComponentDestroy
UISoldierCell.DataDefine = DataDefine
UISoldierCell.DataDestroy = DataDestroy
UISoldierCell.ReInit = ReInit
UISoldierCell.OnValueChange = OnValueChange
UISoldierCell.CallBack = CallBack
UISoldierCell.SetInputText = SetInputText
UISoldierCell.SetSliderValue = SetSliderValue
UISoldierCell.UpdateSlider = UpdateSlider
UISoldierCell.InputListener = InputListener

return UISoldierCell