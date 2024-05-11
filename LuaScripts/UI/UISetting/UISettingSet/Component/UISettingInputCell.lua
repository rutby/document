local UISettingInputCell = BaseClass("UISettingInputCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Sound = CS.GameEntry.Sound


local Param = DataClass("Param", ParamData)
local ParamData =  {
	setType,
}

local width_text_path = "WidthText"
local height_text_path = "HeightText"
local height_input_path = "HeightInputField"
local btn_name_path = "ConfirmBtn/ConfirmBtnName"
local btn_path = "ConfirmBtn"

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
	self.width_text = self:AddComponent(UITextMeshProUGUIEx, width_text_path)
	self.height_text = self:AddComponent(UITextMeshProUGUIEx, height_text_path)
	self.height_input = self:AddComponent(UITMPInput, height_input_path)
	self.btn_name = self:AddComponent(UITextMeshProUGUIEx, btn_name_path)
	self.btn = self:AddComponent(UIButton, btn_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.width_text = nil
	self.height_text = nil
	self.height_input = nil
	self.btn_name = nil
	self.btn = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self.height_input:SetText("")
	self:SetName()
	self:RefreshCurText()
end


local function OnBtnClick(self)
	if self.param.setType == SettingSetType.Resolution then
		local height = self.height_input:GetText()
		if height == nil then
			UIUtil.ShowTipsId(280121) 
		else
			local heightNum = tonumber(height)
			if heightNum ~= nil then
				if heightNum > 0 then
					CS.SceneManager.World:SetResolution(heightNum)
					UIUtil.ShowTipsId(120192) 
					self:RefreshCurText()
				else
					UIUtil.ShowTipsId(290036) 
				end
			end
		end
	elseif self.param.setType == SettingSetType.FPS then
		local height = self.height_input:GetText()
		if height == nil then
			UIUtil.ShowTipsId(280121) 
		else
			local heightNum = tonumber(height)
			if heightNum ~= nil then
				if heightNum > 0 then
					CS.GameEntry.GameBase.FrameRate = heightNum;
					UIUtil.ShowTipsId(120192) 
					self:RefreshCurText()
				else
					UIUtil.ShowTipsId(290036) 
				end
				
			end
		end
	end
end

local function SetName(self)
	if self.param.setType == SettingSetType.Resolution then
		self.height_text:SetText("分辨率")
		self.btn_name:SetLocalText(100222) 
	elseif self.param.setType == SettingSetType.FPS then
		self.height_text:SetText("帧率")
		self.btn_name:SetLocalText(100222) 
	end
end

local function RefreshCurText(self)
	if self.param.setType == SettingSetType.Resolution then
		self.width_text:SetText("当前分辨率: "..CS.SceneManager.World.frameBufferWidth.." X ".. CS.SceneManager.World.frameBufferHeight)
	elseif self.param.setType == SettingSetType.FPS then
		self.width_text:SetText("当前帧率:" .. CS.GameEntry.GameBase.FrameRate)
	end
end


UISettingInputCell.OnCreate = OnCreate
UISettingInputCell.OnDestroy = OnDestroy
UISettingInputCell.Param = Param
UISettingInputCell.OnEnable = OnEnable
UISettingInputCell.OnDisable = OnDisable
UISettingInputCell.ComponentDefine = ComponentDefine
UISettingInputCell.ComponentDestroy = ComponentDestroy
UISettingInputCell.DataDefine = DataDefine
UISettingInputCell.DataDestroy = DataDestroy
UISettingInputCell.ReInit = ReInit
UISettingInputCell.OnBtnClick = OnBtnClick
UISettingInputCell.SetName = SetName
UISettingInputCell.RefreshCurText = RefreshCurText

return UISettingInputCell