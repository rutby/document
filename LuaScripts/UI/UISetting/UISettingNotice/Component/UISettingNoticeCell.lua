local UISettingNoticeCell = BaseClass("UISettingNoticeCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local Param = DataClass("Param", ParamData)
local ParamData =  {
	noticeType,
}

local push_name_path = "PushName"
local push_des_path = "PushDes"
local slider_path = "Slider"
local btn_path = "SwitchBtn"

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
	self.push_name = self:AddComponent(UIText, push_name_path)
	self.push_des = self:AddComponent(UIText, push_des_path)
	self.slider = self:AddComponent(UISlider, slider_path)
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
	self.slider = nil
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
	self.isOn = DataCenter.PushSettingData:IsPushNotify(self.param.noticeType)
	self:SetIsOn()
	
end


local function OnBtnClick(self)
	self.isOn = not self.isOn
	self:SetIsOn()

	local info = {}
	info.type = self.param.noticeType
	info.audio = 0
	if self.isOn then
		info.status = SettingNoticeStatus.On
	else
		info.status = SettingNoticeStatus.Off
	end
	DataCenter.PushSettingData:UpdateOnePushSettingInfo(info)
	SFSNetwork.SendMessage(MsgDefines.ParsePushSet,info)
end

local function SetName(self)
	if self.param.noticeType == SettingNoticeType.PUSH_QUEUE then
		self.push_name:SetLocalText(100170) 
		self.push_des:SetLocalText(350000) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_WORLD then
		self.push_name:SetLocalText(100171) 
		self.push_des:SetLocalText(350001) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_ALLIANCE then
		self.push_name:SetLocalText(390028) 
		self.push_des:SetLocalText(350002) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_ACTIVITY then
		self.push_name:SetLocalText(100176) 
		self.push_des:SetLocalText(350007) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_RESOURCE then
		self.push_name:SetLocalText(100024) 
		self.push_des:SetLocalText(350003) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_CHAT then
		self.push_name:SetLocalText(390029) 
		self.push_des:SetLocalText(350004) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_MAIL then
		self.push_name:SetLocalText(100173) 
		self.push_des:SetLocalText(350005) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_REWARD then
		self.push_name:SetLocalText(100174) 
		self.push_des:SetLocalText(350006) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_WEB_ONLINE then
		self.push_name:SetLocalText(100175) 
		self.push_des:SetLocalText(350010) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_ATTACK then
		self.push_name:SetLocalText(390030) 
		self.push_des:SetLocalText(350008) 
	elseif self.param.noticeType == SettingNoticeType.PUSH_SCOUT then
		self.push_name:SetLocalText(390031) 
		self.push_des:SetLocalText(350009) 
	end
end

local function SetIsOn(self)
	if self.isOn then
		self.slider:SetValue(1)
	else
		self.slider:SetValue(0)
	end
end


UISettingNoticeCell.OnCreate = OnCreate
UISettingNoticeCell.OnDestroy = OnDestroy
UISettingNoticeCell.Param = Param
UISettingNoticeCell.OnEnable = OnEnable
UISettingNoticeCell.OnDisable = OnDisable
UISettingNoticeCell.ComponentDefine = ComponentDefine
UISettingNoticeCell.ComponentDestroy = ComponentDestroy
UISettingNoticeCell.DataDefine = DataDefine
UISettingNoticeCell.DataDestroy = DataDestroy
UISettingNoticeCell.ReInit = ReInit
UISettingNoticeCell.OnBtnClick = OnBtnClick
UISettingNoticeCell.SetName = SetName
UISettingNoticeCell.SetIsOn = SetIsOn


return UISettingNoticeCell