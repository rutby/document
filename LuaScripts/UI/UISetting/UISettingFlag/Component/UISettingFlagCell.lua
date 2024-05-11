local UISettingFlagCell = BaseClass("UISettingFlagCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local Param = DataClass("Param", ParamData)
local ParamData =  {
	name,
}

local this_path = ""
local des_path = "Name"
local img_path = "FlagImg"

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
	self.img = self:AddComponent(UIImage, img_path)
	self.des = self:AddComponent(UIText, des_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.img = nil
	self.des = nil
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
	if param.name ~= nil then
		self.des:SetText(param.name)
		self.img:LoadSprite("Assets/Main/Sprites/CountryFlag/" .. param.name)
	end
end


local function OnBtnClick(self)
	UIUtil.ShowMessage(Localization:GetString("390058"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
		SFSNetwork.SendMessage(MsgDefines.SetCountryFlag,{ flag = self.param.name})
		self.view.ctrl:CloseSelf()
	end)
end


UISettingFlagCell.OnCreate = OnCreate
UISettingFlagCell.OnDestroy = OnDestroy
UISettingFlagCell.Param = Param
UISettingFlagCell.OnEnable = OnEnable
UISettingFlagCell.OnDisable = OnDisable
UISettingFlagCell.ComponentDefine = ComponentDefine
UISettingFlagCell.ComponentDestroy = ComponentDestroy
UISettingFlagCell.DataDefine = DataDefine
UISettingFlagCell.DataDestroy = DataDestroy
UISettingFlagCell.ReInit = ReInit
UISettingFlagCell.OnBtnClick = OnBtnClick

return UISettingFlagCell