local UISettingBtnCell = BaseClass("UISettingBtnCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Sound = CS.GameEntry.Sound


local Param = DataClass("Param", ParamData)
local ParamData =  {
	setType,
}

local push_name_path = "PushName"
local push_des_path = "PushDes"
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
	self.push_name = self:AddComponent(UITextMeshProUGUIEx, push_name_path)
	self.push_des = self:AddComponent(UITextMeshProUGUIEx, push_des_path)
	self.btn_name = self:AddComponent(UITextMeshProUGUIEx, btn_name_path)
	self.btn = self:AddComponent(UIButton, btn_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.push_name = nil
	self.push_des = nil
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
	self:SetName()
end


local function OnBtnClick(self)
	if self.param.setType == SettingSetType.Message then
		UIUtil.ShowMessage(Localization:GetString("280079"),1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			CS.ApplicationLaunch.Instance:ReStartGame()
		end)
	elseif self.param.setType == SettingSetType.Game then
		UIUtil.ShowMessage(Localization:GetString("120079"),1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			LuaEntry.DataConfig:ClearMd5()
			DataCenter.MailDataManager:DeleteAllMailDBData()
			CS.UnityEngine.PlayerPrefs.DeleteAll()
			CS.ApplicationLaunch.Instance:ReStartGame()
		end)
	elseif self.param.setType == SettingSetType.PveResetPos then
		UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.RESET_POSITION_TIP), 2, tostring(GameDialogDefine.RESET_POSITION), GameDialogDefine.CANCEL, function()
			DataCenter.BattleLevel:ResetPlayerPos()
			self.view.ctrl:CloseSelf()
		end)
	elseif self.param.setType == SettingSetType.ScreenResolution then
		if CS.WindowsTool~=nil and CS.WindowsTool.Instance ~= nil then
			local isFullScreen = CS.WindowsTool.Instance:GetIsFullScreen()
			if isFullScreen == false then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISetScreenResolution)
			else
				UIUtil.ShowTips("Full Screen")
			end
		end
	end
	
end

local function SetName(self)
	if self.param.setType == SettingSetType.Message then
		self.push_name:SetLocalText(280078)
		self.push_des:SetLocalText(310033)
		self.btn_name:SetLocalText(150141)
	elseif self.param.setType == SettingSetType.Game then
		self.push_name:SetLocalText(100244)
		self.push_des:SetLocalText(120078)
		self.btn_name:SetLocalText(150141)
	elseif self.param.setType == SettingSetType.PveResetPos then
		self.push_name:SetLocalText(400094)
		self.push_des:SetLocalText(400095)
		self.btn_name:SetLocalText(400090)
	elseif self.param.setType == SettingSetType.ScreenResolution then
		self.push_name:SetText("Set Resolution")
		local curWidth = 0
		local resolutionStr = "1920x1080"
		if CS.WindowsTool~=nil and CS.WindowsTool.Instance ~= nil then
			curWidth = CS.WindowsTool.Instance:GetWindowsWidth()
		end
		if curWidth<1900 and curWidth>1500 then
			resolutionStr = "1600x900"
		elseif curWidth>1300 and curWidth<1500 then
			resolutionStr = "1366x768"
		elseif curWidth>1200 and curWidth<1300 then
			resolutionStr = "1280x720"
		elseif curWidth>1000 and curWidth<1200 then
			resolutionStr = "1024x576"
		end
		self.push_des:SetText("cur Resolution:"..resolutionStr)
		self.btn_name:SetLocalText(280012)
	end
end


UISettingBtnCell.OnCreate = OnCreate
UISettingBtnCell.OnDestroy = OnDestroy
UISettingBtnCell.Param = Param
UISettingBtnCell.OnEnable = OnEnable
UISettingBtnCell.OnDisable = OnDisable
UISettingBtnCell.ComponentDefine = ComponentDefine
UISettingBtnCell.ComponentDestroy = ComponentDestroy
UISettingBtnCell.DataDefine = DataDefine
UISettingBtnCell.DataDestroy = DataDestroy
UISettingBtnCell.ReInit = ReInit
UISettingBtnCell.OnBtnClick = OnBtnClick
UISettingBtnCell.SetName = SetName

return UISettingBtnCell