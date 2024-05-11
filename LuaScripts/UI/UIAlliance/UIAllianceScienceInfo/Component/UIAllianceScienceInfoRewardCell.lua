local UIAllianceScienceInfoRewardCell = BaseClass("UIAllianceScienceInfoRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local this_path = ""
local item_icon_path = "Common_icon_cp"
local num_text_path = "content_ui_new"

-- 创建
function UIAllianceScienceInfoRewardCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceScienceInfoRewardCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceInfoRewardCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceInfoRewardCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIAllianceScienceInfoRewardCell:ComponentDefine()
	self.item_icon = self:AddComponent(UIImage, item_icon_path)
	self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
function UIAllianceScienceInfoRewardCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceInfoRewardCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIAllianceScienceInfoRewardCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIAllianceScienceInfoRewardCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIAllianceScienceInfoRewardCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		self.item_icon:LoadSprite(self.param.icon)
		self.num_text:SetText(string.GetFormattedSpecial(self.param.num))
	else
		self:SetActive(false)
	end
end

function UIAllianceScienceInfoRewardCell:OnBtnClick()
	local scaleFactor = UIManager:GetInstance():GetScaleFactor()
	local position = self.item_icon.transform.position + Vector3.New(0, 40, 0) * scaleFactor

	local param = UIHeroTipView.Param.New()
	param.content = self.param.des
	param.dir = UIHeroTipView.Direction.ABOVE
	param.defWidth = 350
	if position.x < 200 then
		param.pivot = 0.2
	elseif position.x > 500 then
		param.pivot = 0.8
	else
		param.pivot = 0.5
	end
	param.position = position
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

function UIAllianceScienceInfoRewardCell:GetFlyPos()
	return self.item_icon.transform.position
end

return UIAllianceScienceInfoRewardCell