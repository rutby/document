local UITrainDetailCell = BaseClass("UITrainDetailCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local this_path = ""
local detail_icon_path = "icon"
local detail_name_path = "name_text"
local detail_value_path = "value_text"
local slider_path = "slider"

-- 创建
function UITrainDetailCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UITrainDetailCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UITrainDetailCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UITrainDetailCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UITrainDetailCell:ComponentDefine()
	self.detail_icon = self:AddComponent(UIImage, detail_icon_path)
	self.detail_name = self:AddComponent(UITextMeshProUGUIEx, detail_name_path)
	self.detail_value = self:AddComponent(UITextMeshProUGUIEx, detail_value_path)
	self.slider = self:AddComponent(UISlider, slider_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
function UITrainDetailCell:ComponentDestroy()
end

--变量的定义
function UITrainDetailCell:DataDefine()
	self.param = {}
	self.clickDes = ""
end

--变量的销毁
function UITrainDetailCell:DataDestroy()
	self.param = {}
	self.clickDes = ""
end

-- 全部刷新
function UITrainDetailCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UITrainDetailCell:OnBtnClick()
	local param = UIHeroTipsView.Param.New()
	param.content = self.clickDes
	param.dir = UIHeroTipsView.Direction.ABOVE
	param.defWidth = 280
	param.pivot = 0.5
	param.position = self.transform.position + Vector3.New(0, 50, 0)
	param.bindObject = self.gameObject
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

function UITrainDetailCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		self.detail_icon:LoadSprite(UITrainDetailTypeIcon[self.param.detailType])
		self:SetDetailInfo()
	else
		self:SetActive(false)
	end
end

function UITrainDetailCell:SetDetailInfo()
	local cur = 0
	local all = 1
	if self.param.detailType == UITrainDetailType.Attack then
		self.detail_name:SetLocalText(GameDialogDefine.ATTACK)
		cur = self.param.template.attack
		all =  self.param.maxTemplate.attack
		--self.detail_add_value:SetText(self:GetAddText(self.param.template:GetAttackAddValue()))
		self.clickDes = Localization:GetString(GameDialogDefine.ATTACK_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.Defense then
		self.detail_name:SetLocalText(GameDialogDefine.DEFENSE)
		cur = self.param.template.defence
		all =  self.param.maxTemplate.defence
		--self.detail_add_value:SetText(self:GetAddText(self.param.template:GetDefenceAddValue()))
		self.clickDes = Localization:GetString(GameDialogDefine.DEFENSE_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.Blood then
		self.detail_name:SetLocalText(GameDialogDefine.BLOOD)
		cur = self.param.template.health
		all =  self.param.maxTemplate.health
		--self.detail_add_value:SetText(self:GetAddText(self.param.template:GetHealthAddValue()))
		self.clickDes = Localization:GetString(GameDialogDefine.BLOOD_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.Speed then
		self.detail_name:SetLocalText(GameDialogDefine.SPEED)
		cur = self.param.template:GetSpeedValue()
		all =  self.param.maxTemplate:GetSpeedValue()
		--self.detail_add_value:SetText("")
		self.clickDes = Localization:GetString(GameDialogDefine.SPEED_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.Load then
		self.detail_name:SetLocalText(GameDialogDefine.LOAD)
		cur = self.param.template.load
		all =  self.param.maxTemplate.load
		--self.detail_add_value:SetText(self:GetAddText(self.param.template:GetLoadAddValue()))
		self.clickDes = Localization:GetString(GameDialogDefine.LOAD_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.Power then
		self.detail_name:SetLocalText(GameDialogDefine.POWER)
		cur = self.param.template.power
		all =  self.param.maxTemplate.power
		--self.detail_add_value:SetText(self:GetAddText(self.param.template:GetAttackAddValue()))
		self.clickDes = Localization:GetString(GameDialogDefine.POWER_CLICK_DES)
	elseif self.param.detailType == UITrainDetailType.TrapAttack then
		self.detail_name:SetLocalText(GameDialogDefine.TRAP_ATTACK)
		cur = self.param.template.damage
		all =  self.param.maxTemplate.damage
		--self.detail_add_value:SetText("")
		self.clickDes = Localization:GetString(GameDialogDefine.ATTACK_CLICK_DES)
	end
	self.detail_value:SetText(cur)
	self.slider:SetValue(cur / all)
end

return UITrainDetailCell