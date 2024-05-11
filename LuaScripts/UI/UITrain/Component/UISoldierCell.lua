local UISoldierCell = BaseClass("UISoldierCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local this_path = ""
local icon_path = "Icon"
local level_text_path = "UISoldier_img_levelbg/LevelText"
local num_text_path = "CountText"
local upgrad_path = "Upgrade_icon"

local SelectNumColor = Color.New(1,1,1,1)
local UnSelectNumColor = Color.New(1,1,1,0.5)

-- 创建
function UISoldierCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UISoldierCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UISoldierCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UISoldierCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UISoldierCell:ComponentDefine()
	self.icon = self:AddComponent(UIImage, icon_path)
	self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
	self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
	self.upgrade = self:AddComponent(UIBaseContainer, upgrad_path)
end

--控件的销毁
function UISoldierCell:ComponentDestroy()
end

--变量的定义
function UISoldierCell:DataDefine()
	self.param = {}
	self.numColor = nil
end

--变量的销毁
function UISoldierCell:DataDestroy()
	self.param = nil
	self.numColor = nil
end

-- 全部刷新
function UISoldierCell:ReInit(param)
	self.param = param
	if param.armyId ~= nil then
		local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
		if template ~= nil then
			self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
			self.level_text:SetText(RomeNum[template.show_level])
		end
	end
	if param.isUnLock then
		if param.isToUnLock then
			UIGray.SetGray(self.icon.transform, true, true)
		else
			UIGray.SetGray(self.icon.transform, false, true)
		end
	else
		UIGray.SetGray(self.icon.transform, true, true)
	end
	local count = 0
	local soldier = DataCenter.ArmyManager:FindArmy(param.armyId)
	if soldier ~= nil then
		count = soldier.free
	end
	self.num_text:SetText(string.GetFormattedSeperatorNum(count))
	self:SetSelect(param.isSelect)
	local showUpgrade = DataCenter.ArmyManager:IsCanUpgrade(param.armyId, param.buildId)
	local unlock = DataCenter.ArmyManager:GetCanUnLockUpgrade(param.buildId)
	self.upgrade:SetActive(showUpgrade and unlock)
end

function UISoldierCell:OnBtnClick()
	if self.param.callBack ~= nil then
		self.param.callBack(self.param.index)
	end
end

function UISoldierCell:SetSelect(value)
	if value then
		self:SetNumColor(SelectNumColor)
	else
		self:SetNumColor(UnSelectNumColor)
	end
end

function UISoldierCell:SetNumColor(value)
	if self.numColor ~= value then
		self.numColor = value
		self.num_text:SetColor(value)
	end
end

function UISoldierCell:GetSelectGo()
	return self.transform
end

return UISoldierCell